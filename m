Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B267681F73
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 00:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjA3XOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 18:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjA3XOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 18:14:17 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6203714495;
        Mon, 30 Jan 2023 15:14:16 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id 5so13301974plo.3;
        Mon, 30 Jan 2023 15:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eKu+kd9X+GTaWdLAQUJinb0Z7Cb02sWxRt1ZBDZ1tPw=;
        b=SpwzlWusL1iiV7vQ35dwUjrZC7Z+QLqzZQFGcjkd1UAs/oQ57Et6T8HYbzjSfWefj1
         zNwfPNWHuhVlbHLgAMKTv9HUnXkZfMisbamlbb+U4BCr1fZSN7R6YlILyMjP34fA1X6V
         i2O0zJNBT1cGtT0cI16KFj1xJYBfc/mc6Gpt/fv0SCUvxyVbd2IAmY/KmwDahoDiZQuA
         1jRsKfGummyhtGAywSKzRlGpFx9q/G0HpdxuwQFHvCIuzsunfCZEdmqb++k7xpTsAgrU
         kWZzo5cwCPt2GzmR9HxrwpI0OYMS/lRZQ9wvM4iGQ1anmGrxzm69ZnlzZVmFJpQk5g8u
         yjrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eKu+kd9X+GTaWdLAQUJinb0Z7Cb02sWxRt1ZBDZ1tPw=;
        b=bOrq1bxasSX4dvSMClqzVkrNvnCU20JL4yWBoc9mqltLV8iKaB+5uhBOX5nbFvQIII
         LcTA6Rhyo6YdvRtKMTvzHToaqV8+qXFOC018YL2p1O3xZxKLN8X2NnXzuLZSDaqkO66u
         /MgqYA+9WxqdHQRCGQ35fHvzKZSS3TgUWYXHowUyq30wHizo48w8EkV7svXtu60c8+5k
         xma7ycLOWOtXEgh6+ydx9mAr1PZj3oQlgRy/wcU4xR7w4cLVh0+YngHDEVbfCWES3xqf
         TRB4Ls7c04Vw2wgbPq4lneJR5bmAgn+iTPb/s6rAiNWV2JxnyfJ/E69fui8b9Oc1ukEn
         6Z9g==
X-Gm-Message-State: AO0yUKVKhdOJ7fF+SYAPsPe94J41r+WytaMVjq7QnurbzD/JM0R/Dhy8
        bJAKWW0vBTdT0aRQ/WxyVWc=
X-Google-Smtp-Source: AK7set9foVYSvp+tV1JKInjXZGdAvVr+C0n/JwJUa1GLBHkpNyK7L5AUtM1fVSoN+j+2fi3W2A/FEQ==
X-Received: by 2002:a17:902:cec2:b0:196:5035:98c0 with SMTP id d2-20020a170902cec200b00196503598c0mr18082248plg.23.1675120455748;
        Mon, 30 Jan 2023 15:14:15 -0800 (PST)
Received: from localhost.localdomain.com (2603-8001-4200-6311-92a0-3d53-9224-b276.res6.spectrum.com. [2603:8001:4200:6311:92a0:3d53:9224:b276])
        by smtp.gmail.com with ESMTPSA id x26-20020aa7957a000000b0059393d46228sm5102765pfq.144.2023.01.30.15.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 15:14:15 -0800 (PST)
From:   Chris Healy <cphealy@gmail.com>
To:     cphealy@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        neil.armstrong@linaro.org, khilman@baylibre.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        jeremy.wang@amlogic.com
Cc:     Chris Healy <healych@amazon.com>
Subject: [PATCH v3] net: phy: meson-gxl: Add generic dummy stubs for MMD register access
Date:   Mon, 30 Jan 2023 15:14:02 -0800
Message-Id: <20230130231402.471493-1-cphealy@gmail.com>
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
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Chris Healy <healych@amazon.com>

---

Changes in v3:
* Add reviewed-by
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

