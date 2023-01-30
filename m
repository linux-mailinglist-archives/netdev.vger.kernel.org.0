Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A5B681B0A
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 21:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237159AbjA3UEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 15:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjA3UEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 15:04:04 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85E935B7;
        Mon, 30 Jan 2023 12:04:02 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id k13so12899414plg.0;
        Mon, 30 Jan 2023 12:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oJ4P0/7Fp0wCRDTr6k9aNwM0pDSN8y8lOMVT0a0hr+M=;
        b=GMguhGR/5KzGoCcT+asTn+uaWzS2OXmm62BHl7SR+mlawkTkIqPq7ROdAN3adybGQ0
         PrnLmLD0QfXMrw4ppvxnvNifH4X/RlAKxdtMWFzawFYe915XuvuzImHj4WGauXGNCqH4
         wPhNBQsRWtsjsAG+GUh43c00/8Mcysrcdc/hnWsgwXAPTWYYZaYovUhsjuf/h0A6Ip5f
         Z/h3P7k0K9TFNFtQBcM+JEmr57M/XORBaP9Nk26e2TgydY6ZoGZUXxbZQyWPyOKBtTKK
         kHFMNfOJFQ8aOKCtWOZXwWE3ZEZqRHdA2RS9c3kAB1fDdsse0Ew6Kj0MaJiQ7jVUjsju
         A85w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oJ4P0/7Fp0wCRDTr6k9aNwM0pDSN8y8lOMVT0a0hr+M=;
        b=xZFbZRiPkc/o9BbQbfE/otS/MP/YKxx8zwUnNqvYIztkpbFwH1OCH7M3gvnxNL+FlP
         oEsCEuxq7DUfazes4racpLCGKm4Tw3KY3sr2szBorsSzKFH87HsKwf1O00UtvZYIJ1tW
         p5CKOAljQHO+FTdjN6xeyNlDHwFFuMsdRM+d4UENUxFk/4SkPh++GP4XjIk3xk4X2vir
         /VoXjiEiBQCF0AVL4ZOddmuUFr03A2I4PxYnU5EMp1BrXyPmP0smz0QLKC5+AhUISKH8
         786He5mnwiCW80QkSN0aMGN/uy3I7jM+9DpFsB5uwPQNnFS3CKKeMlibqwZdAEWxAO4+
         ROZA==
X-Gm-Message-State: AO0yUKUtrSvilKUJ1V+2f0I/+qs92gNcxG2K4EVUjzhOYK3uV6THvZo5
        PE2XmtPmpasCvjT8NYXVfCKie/jY0N2V+w==
X-Google-Smtp-Source: AK7set/WTkUIa6Te+NDPxbvH6Wa2PH2/VOn6lWITCpx9lMT062pLD5IOdnoFxxeGfBW4aB267/9ELQ==
X-Received: by 2002:a05:6a20:54a6:b0:bd:b81:2bc3 with SMTP id i38-20020a056a2054a600b000bd0b812bc3mr5689786pzk.2.1675109042023;
        Mon, 30 Jan 2023 12:04:02 -0800 (PST)
Received: from localhost.localdomain.com (2603-8001-4200-6311-92a0-3d53-9224-b276.res6.spectrum.com. [2603:8001:4200:6311:92a0:3d53:9224:b276])
        by smtp.gmail.com with ESMTPSA id o7-20020a17090a55c700b002300fe83a4fsm98684pjm.20.2023.01.30.12.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 12:04:01 -0800 (PST)
From:   Chris Healy <cphealy@gmail.com>
To:     cphealy@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        neil.armstrong@linaro.org, khilman@baylibre.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        jeremy.wang@amlogic.com
Cc:     Chris Healy <healych@amazon.com>
Subject: [PATCH v2] net: phy: meson-gxl: Add generic dummy stubs for MMD register access
Date:   Mon, 30 Jan 2023 12:03:52 -0800
Message-Id: <20230130200352.462548-1-cphealy@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Healy <healych@amazon.com>

The Meson G12A Internal PHY does not support standard IEEE MMD extended
register access, therefore add generic dummy stubs to fail the read and
write MMD calls. This is necessary to prevent the core PHY code from
erroneously believing that EEE is supported by this PHY even though this
PHY does not support EEE, as MMD register access returns all FFFFs.

Fixes: 5c3407abb338 ("net: phy: meson-gxl: add g12a support")
Signed-off-by: Chris Healy <healych@amazon.com>
---

Change in v2:
* Add fixes tag

 drivers/net/phy/meson-gxl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index c49062ad72c6..5e41658b1e2f 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -271,6 +271,8 @@ static struct phy_driver meson_gxl_phy[] = {
 		.handle_interrupt = meson_gxl_handle_interrupt,
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
+		.read_mmd	= genphy_read_mmd_unsupported,
+		.write_mmd	= genphy_write_mmd_unsupported,
 	},
 };
 
-- 
2.39.1

