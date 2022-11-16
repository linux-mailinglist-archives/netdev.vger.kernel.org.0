Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2845762CBBC
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbiKPU5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbiKPUyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:54:02 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79232CE25
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:37 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id s5so12236717edc.12
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CeVee7WTu+MIVK7s97PRG5d4Tw3kKV6cU2vVtZ3DItQ=;
        b=ofPkZh1sJHCSjcXBt5MSofHDe4685qhi1/Uc6LWnRd5EToxTmQIbpUn6ccrEQAQAns
         SXavK0S2kbOubR/NRJ7cDZLF6RKWaQ4G757sspLKT7U2Nq1FQa21mr8+z+tgJN1JAHar
         bAGuACN8zSgXgSFsxzahOcOiGZtZqtaI3ADgt8nVKKhB/xQ5NRUK8cjr9uuVpDjrECJG
         ZIM8hXLVCMHjmTEFYN/pf8GLR66Zi1gz5BAhY62LqokcHeYn5zUnYo+GMZQSk9oRLSrz
         5o59LVtNJfrNkQhOE//fxGY7XlXdPB/LDl9sjti2Spkq8u58gt9NoQCSLUs3GqyCorT1
         nZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CeVee7WTu+MIVK7s97PRG5d4Tw3kKV6cU2vVtZ3DItQ=;
        b=jA93Ri7Si7/XyX7RkAgLyQZghnOAwBHSu6/3nk/a6qOXjvio4RhKNjaWyBHM9QpdQ7
         zwS9ORo89121PmXPDXBKJBRWI3JG7bVbdZ/UyPDlo9AX41oLI8I3pAb/GF/Ump0XR17Y
         3lFNktMa2LhpEiWzYfmziFawMa1OEtTp4xxs9SzWLENiOLjlYekOEIXnSB4X/EN53/mn
         9dzBMsTF15WRysB8wsTFcluUEQhsUdqjUoqz/SE55iV79df50CajpGQw14tW6O/23RIr
         XIvK2wrcdhOPVwRhwPdxn7fvKPRWfqpCjE4BU/ixI8lu553l8ShLX4Xh8ocXyVbL3r0A
         X2Ew==
X-Gm-Message-State: ANoB5pkr5+7LiChQ8T83qh56zBnsNmU/pGK/lM70QcFxLkpfVNFfdTrM
        kwIA2QpRDzdkwCDjYdBuS7G5cA==
X-Google-Smtp-Source: AA0mqf5j6sPxY2lkGgEc/UQ8QjGsma8Lta5ZRqNfdGt0PvRbt3fxbOhFaJmq6bYcUruYMVFEqjFqeA==
X-Received: by 2002:a05:6402:17c2:b0:459:443a:faf4 with SMTP id s2-20020a05640217c200b00459443afaf4mr20696086edy.297.1668632016031;
        Wed, 16 Nov 2022 12:53:36 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4090:a244:804b:353b:565:addf:3aa7])
        by smtp.gmail.com with ESMTPSA id kv17-20020a17090778d100b007aece68483csm6782828ejc.193.2022.11.16.12.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 12:53:35 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 15/15] can: tcan4x5x: Specify separate read/write ranges
Date:   Wed, 16 Nov 2022 21:53:08 +0100
Message-Id: <20221116205308.2996556-16-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221116205308.2996556-1-msp@baylibre.com>
References: <20221116205308.2996556-1-msp@baylibre.com>
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
index d4b79d2d4598..19215c39cd5b 100644
--- a/drivers/net/can/m_can/tcan4x5x-regmap.c
+++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
@@ -90,16 +90,47 @@ static int tcan4x5x_regmap_read(void *context,
 	return 0;
 }
 
-static const struct regmap_range tcan4x5x_reg_table_yes_range[] = {
+static const struct regmap_range tcan4x5x_reg_table_wr_range[] = {
+	/* Device ID and SPI Registers */
+	regmap_reg_range(0x000c, 0x001c),
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
 	regmap_reg_range(0x0000, 0x001c),	/* Device ID and SPI Registers */
 	regmap_reg_range(0x0800, 0x083c),	/* Device configuration registers and Interrupt Flags*/
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

