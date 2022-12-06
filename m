Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B6C6442AF
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbiLFL56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbiLFL5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 06:57:48 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E57659E
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 03:57:44 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id z92so19981483ede.1
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 03:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kMpVZlkR98KLQohjfLGaqieOVI5mlDmYYzLpVIJ3+Co=;
        b=CNSjIQxzqCV1Ed/RyG27x1c8mgM8Tm7zw0uvRKceaLzWH646iHNwQ1x8wRdEfDtUKH
         ISwpGpz79jBDwK3kHgqoi86GP80S170WIaoqWbZnWFfYDEaxNk96RkF0B+BPF7bVeDFB
         BBb4e7yL2DQV9/Q8b/epz5m5Y1T809jO/LZaivf8pWfqikakzWK8Xe2cAI2VxdSzXjNO
         gi9b5c3kbfHAei05cGAPV2I3nf3kObO+BpnsMPHeYAdIbRHjtu1XYgvjn8CnWCJ2yGa5
         YefpFp13s+Epzc+uZOF+SIZ4PFV3shbKfwkDIbyju4KHUwLDawcfT7zf6kGFpCXy1r7y
         IwdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kMpVZlkR98KLQohjfLGaqieOVI5mlDmYYzLpVIJ3+Co=;
        b=AP+Lq8Zz4VT88Subr49t49RUpV7NX034kqeP4hreOgMOjjTeqTDrB0TYv3d2bEYGVE
         FvOjhc3BlxMRd0cIVkEUbP8MFwNRdov7jjHBCr2rfUeCj4SYO438bYEV++5JuBOan6Nn
         iyCRZZSf9B2Nka6CKgeCy4RLFXOm5kIaQuAAQE+XQhfdwUdXtpqYMHa4Z77IlQ3FhNjL
         emKf1RmU10X3zyAhS60ycpMD5MHstG/3LNY1BnTCX9fVs+eLKm7hluv3lMB4rhrepJr1
         xLI14incRDr/KlRScosLE4HmBOVBnt451Zso9aQig/ULUrX+Uh5mqEaAekzYgS2GI5hs
         vxBA==
X-Gm-Message-State: ANoB5pnWOj029JxWxUjpDiYAo4HBDokwgSkSGW5OX+YT7ycT/pTW5ZUk
        wR+mNy9akNt9SB73wR+sizmKaA==
X-Google-Smtp-Source: AA0mqf61HAelMEyMCoEKHZ1S+ZPOwlygRrC4yfJN6dnK1EOKnRU7bKQ8CmWUh0UFuoxIt90m6JQRNw==
X-Received: by 2002:a05:6402:78e:b0:46c:6f53:bf19 with SMTP id d14-20020a056402078e00b0046c6f53bf19mr11625077edy.299.1670327864545;
        Tue, 06 Dec 2022 03:57:44 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id ky20-20020a170907779400b007c0ac4e6b6esm6472076ejc.143.2022.12.06.03.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 03:57:44 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v2 10/11] can: tcan4x5x: Fix register range of first two blocks
Date:   Tue,  6 Dec 2022 12:57:27 +0100
Message-Id: <20221206115728.1056014-11-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221206115728.1056014-1-msp@baylibre.com>
References: <20221206115728.1056014-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the datasheet 0x10 is the last register in the first block,
not register 0x2c.

The datasheet lists the last register of the second block as 0x830, not
0x83c.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---

Notes:
    v2:
     - Fix end of first range, was 0x1c, is now 0x10
     - Add fix for the end of the second range, was 0x3c, is now 0x30.

 drivers/net/can/m_can/tcan4x5x-regmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x-regmap.c b/drivers/net/can/m_can/tcan4x5x-regmap.c
index 26e212b8ca7a..33aed989e42a 100644
--- a/drivers/net/can/m_can/tcan4x5x-regmap.c
+++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
@@ -91,8 +91,8 @@ static int tcan4x5x_regmap_read(void *context,
 }
 
 static const struct regmap_range tcan4x5x_reg_table_yes_range[] = {
-	regmap_reg_range(0x0000, 0x002c),	/* Device ID and SPI Registers */
-	regmap_reg_range(0x0800, 0x083c),	/* Device configuration registers and Interrupt Flags*/
+	regmap_reg_range(0x0000, 0x0010),	/* Device ID and SPI Registers */
+	regmap_reg_range(0x0800, 0x0830),	/* Device configuration registers and Interrupt Flags*/
 	regmap_reg_range(0x1000, 0x10fc),	/* M_CAN */
 	regmap_reg_range(0x8000, 0x87fc),	/* MRAM */
 };
-- 
2.38.1

