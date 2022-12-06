Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE89F6442BE
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235228AbiLFL60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235181AbiLFL5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 06:57:48 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05150A468
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 03:57:45 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id kw15so2152140ejc.10
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 03:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ETAV5GbK15ksIb7Y/2hAQrE1+2csG56eJ5O31jfiSm0=;
        b=DsfemFw96NwbJCFj2aFQGgrtCd2kXAYLnSqdxWwK+f1C3ozv2O2qwOA162mGChL6hn
         6I8b6+MpLsRWGQ819BWKWHuvh1pk4JJwfFFq5sZbdmqFSxYOgMaXX7rKn93GpyuDU2UM
         h5KKd8pg+2P+K+zmKtJ/mqUMtoyDqHdgVCEk+rCn/GRBXHyMCW+INlcHnX5ff/IH/dhh
         ngzvdJTJTYXIr/Rkgt7Z2UtfSw73i5H6jbxRqHzhD+lA6Z+QcIb+UbW7AP4SfJ2zc+dz
         R5gcQq8CvqHxKE6Ju1pQQRc2JNIv/7wcy8FwdrRHsATiQb5fx6TjiACsYI+HbPtLeLG5
         6s6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ETAV5GbK15ksIb7Y/2hAQrE1+2csG56eJ5O31jfiSm0=;
        b=FptMU0m8JhIOODqa7UGn2ZlqwqRIkh3nE8POJ3jjnemaFrql3tR4yaTLbhnLSjRAW0
         RBa8bpE/qRMnXMkgIsrn9MIOU2cj63oiO807soV30TqQgDQ8o8YjxogcJheIIErSj5U7
         C96wCZ66uMjAZ0J5kxBfefmP38+orYQ778ObyBL4VFI8RVjXaBL9OhMEsC1wXpMJxXbS
         VHtj/ZR2d4C/lEHyCOUTeZ5HO1eTF0KHTH6rbje8kciawR382jwZ9gkgGxYnREruPBMh
         nk7kUDbc2J0mH1+AJ8oa6nyMumk7Pcnm/1q7bM/suwI4DTnue2AHonh15n1lob5vPKQj
         L71w==
X-Gm-Message-State: ANoB5pmSz/k7ceuJcQRfsEVV5eMV1RfvFgbEtzpfrSxxyMdXW31Ezpew
        eCnY7dP56mEUza5V7+BmsorAkQ==
X-Google-Smtp-Source: AA0mqf7GzGmbIAawAMwe6NRH9KO4raa68YejfLxvVTFxOOTu1R7RNxVCX6OXkVFF6vVz1mIthTIjtQ==
X-Received: by 2002:a17:906:2552:b0:7ad:917b:61ec with SMTP id j18-20020a170906255200b007ad917b61ecmr59356203ejb.513.1670327865402;
        Tue, 06 Dec 2022 03:57:45 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id ky20-20020a170907779400b007c0ac4e6b6esm6472076ejc.143.2022.12.06.03.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 03:57:45 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v2 11/11] can: tcan4x5x: Specify separate read/write ranges
Date:   Tue,  6 Dec 2022 12:57:28 +0100
Message-Id: <20221206115728.1056014-12-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221206115728.1056014-1-msp@baylibre.com>
References: <20221206115728.1056014-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Specify exactly which registers are read/writeable in the chip. This
is supposed to help detect any violations in the future.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/tcan4x5x-regmap.c | 43 +++++++++++++++++++++----
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x-regmap.c b/drivers/net/can/m_can/tcan4x5x-regmap.c
index 33aed989e42a..2b218ce04e9f 100644
--- a/drivers/net/can/m_can/tcan4x5x-regmap.c
+++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
@@ -90,16 +90,47 @@ static int tcan4x5x_regmap_read(void *context,
 	return 0;
 }
 
-static const struct regmap_range tcan4x5x_reg_table_yes_range[] = {
+static const struct regmap_range tcan4x5x_reg_table_wr_range[] = {
+	/* Device ID and SPI Registers */
+	regmap_reg_range(0x000c, 0x0010),
+	/* Device configuration registers and Interrupt Flags*/
+	regmap_reg_range(0x0800, 0x080c),
+	regmap_reg_range(0x0814, 0x0814),
+	regmap_reg_range(0x0820, 0x0820),
+	regmap_reg_range(0x0830, 0x0830),
+	/* M_CAN */
+	regmap_reg_range(0x100c, 0x102c),
+	regmap_reg_range(0x1048, 0x1048),
+	regmap_reg_range(0x1050, 0x105c),
+	regmap_reg_range(0x1080, 0x1088),
+	regmap_reg_range(0x1090, 0x1090),
+	regmap_reg_range(0x1098, 0x10a0),
+	regmap_reg_range(0x10a8, 0x10b0),
+	regmap_reg_range(0x10b8, 0x10c0),
+	regmap_reg_range(0x10c8, 0x10c8),
+	regmap_reg_range(0x10d0, 0x10d4),
+	regmap_reg_range(0x10e0, 0x10e4),
+	regmap_reg_range(0x10f0, 0x10f0),
+	regmap_reg_range(0x10f8, 0x10f8),
+	/* MRAM */
+	regmap_reg_range(0x8000, 0x87fc),
+};
+
+static const struct regmap_range tcan4x5x_reg_table_rd_range[] = {
 	regmap_reg_range(0x0000, 0x0010),	/* Device ID and SPI Registers */
 	regmap_reg_range(0x0800, 0x0830),	/* Device configuration registers and Interrupt Flags*/
 	regmap_reg_range(0x1000, 0x10fc),	/* M_CAN */
 	regmap_reg_range(0x8000, 0x87fc),	/* MRAM */
 };
 
-static const struct regmap_access_table tcan4x5x_reg_table = {
-	.yes_ranges = tcan4x5x_reg_table_yes_range,
-	.n_yes_ranges = ARRAY_SIZE(tcan4x5x_reg_table_yes_range),
+static const struct regmap_access_table tcan4x5x_reg_table_wr = {
+	.yes_ranges = tcan4x5x_reg_table_wr_range,
+	.n_yes_ranges = ARRAY_SIZE(tcan4x5x_reg_table_wr_range),
+};
+
+static const struct regmap_access_table tcan4x5x_reg_table_rd = {
+	.yes_ranges = tcan4x5x_reg_table_rd_range,
+	.n_yes_ranges = ARRAY_SIZE(tcan4x5x_reg_table_rd_range),
 };
 
 static const struct regmap_config tcan4x5x_regmap = {
@@ -107,8 +138,8 @@ static const struct regmap_config tcan4x5x_regmap = {
 	.reg_stride = 4,
 	.pad_bits = 8,
 	.val_bits = 32,
-	.wr_table = &tcan4x5x_reg_table,
-	.rd_table = &tcan4x5x_reg_table,
+	.wr_table = &tcan4x5x_reg_table_wr,
+	.rd_table = &tcan4x5x_reg_table_rd,
 	.max_register = TCAN4X5X_MAX_REGISTER,
 	.cache_type = REGCACHE_NONE,
 	.read_flag_mask = (__force unsigned long)
-- 
2.38.1

