Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0545A1B4C
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243911AbiHYVkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243988AbiHYVkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:40:05 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56907660
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 14:39:49 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id h5so25360355wru.7
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 14:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=DSDujQX+3SfjKciReMnC3dqgLwDrQasis/foG0E1qKQ=;
        b=g2CsgqIhoLtPOsM3BdhBaGX9Gl6QMEfc/i595nhNWa8sVJnrpyiMQDb9ADx8AObKV7
         oLnQrdkB+Y04TiM/FkfN4V2rtM3jf2ZKYnHVqtC9k0UgiczLSPxh61f7Wa+ECo6jwzMc
         i5gjI/cZDYHA/gLSJN0wzMQgzIRNy387GU/Y1mqzzbVhWkN1VLd2ZTBM7IPddomak/2E
         jOlx5hIvRoqceWRG5B8mjoGMcvtJmjMrIx46Rg7AasJVxvK7kGwlfjzYaL9tFBkUSd45
         nfDG5+kby+r7ObBPbOXKwrpb4bzB4OobPdmJx8xnwJiKEFunxt/Jiz7z/wEfR0AeQDcY
         AdFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=DSDujQX+3SfjKciReMnC3dqgLwDrQasis/foG0E1qKQ=;
        b=ftwF968g8bh1z2AB9P5T+GexfnjQrgGnWJLyaynfDL0WVygKSA4ZGhU8Vgj2VVZO1u
         YEjpwjq+zPMA4zUbD7lDlWLGHO4sS3l1/X2otBmVn0nfUPUjMzzcYoFitN72RJVl95/I
         IidbxCC6rrD5vnXj6b/qfM7shTj81TNWdXQyP5K0yI5n/WzHvSi5c5NaRRGAij1ld1Lu
         irtrwvQWkmqDSsCxAXbzrebnkTVT721iqwdahKO+Shr+G8mESQS3LOY3rgpA4ZRRHbZe
         b+YWwJCjdhvoL4t3GzXwvm1TV1Ao/K/jrF4gAnl2vs4KRUG8N2oQNK81wAc1bfJ3+KSI
         y8FA==
X-Gm-Message-State: ACgBeo3RpkU43cRxJywKfppw0CNwNkRc+6oj6mXfJFWKRVvM88fwV4sy
        c8wbLSYhQUD9asVBSWG8eTdjWEAmeOlHWw==
X-Google-Smtp-Source: AA6agR5ticgEnNHu8M+6UM/65E1VcqpVrOA2nV/rSLX0jY1k2DxTtLob7dnq9BzuUmW35maX7XfV8w==
X-Received: by 2002:a5d:6047:0:b0:225:3af7:ca6d with SMTP id j7-20020a5d6047000000b002253af7ca6dmr3336889wrt.329.1661463587493;
        Thu, 25 Aug 2022 14:39:47 -0700 (PDT)
Received: from P-NTS-Evian.home (2a01cb058f8a18001c97b8d1b477d53f.ipv6.abo.wanadoo.fr. [2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f])
        by smtp.gmail.com with ESMTPSA id j18-20020a05600c191200b003a5c1e916c8sm14038471wmq.1.2022.08.25.14.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 14:39:47 -0700 (PDT)
From:   Romain Naour <romain.naour@smile.fr>
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        arun.ramadoss@microchip.com, Romain Naour <romain.naour@skf.com>,
        Romain Naour <romain.naour@smile.fr>
Subject: [PATCH 1/2] net: dsa: microchip: add KSZ9896 switch support
Date:   Thu, 25 Aug 2022 23:39:42 +0200
Message-Id: <20220825213943.2342050-1-romain.naour@smile.fr>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Romain Naour <romain.naour@skf.com>

Add support for the KSZ9896 6-port Gigabit Ethernet Switch to the
ksz9477 driver.

Although the KSZ9896 is already listed in the device tree binding
documentation since a1c0ed24fe9b (dt-bindings: net: dsa: document
additional Microchip KSZ9477 family switches) the chip id
(0x00989600) is not recognized by ksz_switch_detect() and rejected
by the driver.

The KSZ9896 is similar to KSZ9897 but has only one configurable
MII/RMII/RGMII/GMII cpu port.

Signed-off-by: Romain Naour <romain.naour@skf.com>
Signed-off-by: Romain Naour <romain.naour@smile.fr>
---
It seems that the KSZ9896 support has been sent to the kernel netdev
mailing list a while ago but got lost after initial review:
https://www.spinics.net/lists/netdev/msg554771.html

The initial testing with the ksz9896 was done on a 5.10 kernel
but due to recent changes in dsa microchip driver it was required
to rework this initial version for 6.0-rc2 kernel.
---
 drivers/net/dsa/microchip/ksz_common.c | 30 ++++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h |  2 ++
 drivers/net/dsa/microchip/ksz_spi.c    |  6 ++++++
 3 files changed, 38 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 6bd69a7e6809..759d98f4e317 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -547,6 +547,34 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 				   true, false, false},
 	},
 
+	[KSZ9896] = {
+		.chip_id = KSZ9896_CHIP_ID,
+		.dev_name = "KSZ9896",
+		.num_vlans = 4096,
+		.num_alus = 4096,
+		.num_statics = 16,
+		.cpu_ports = 0x3F,	/* can be configured as cpu port */
+		.port_cnt = 6,		/* total physical port count */
+		.ops = &ksz9477_dev_ops,
+		.phy_errata_9477 = true,
+		.mib_names = ksz9477_mib_names,
+		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
+		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.regs = ksz9477_regs,
+		.masks = ksz9477_masks,
+		.shifts = ksz9477_shifts,
+		.xmii_ctrl0 = ksz9477_xmii_ctrl0,
+		.xmii_ctrl1 = ksz9477_xmii_ctrl1,
+		.supports_mii	= {false, false, false, false,
+				   false, true},
+		.supports_rmii	= {false, false, false, false,
+				   false, true},
+		.supports_rgmii = {false, false, false, false,
+				   false, true},
+		.internal_phy	= {true, true, true, true,
+				   true, false},
+	},
+
 	[KSZ9897] = {
 		.chip_id = KSZ9897_CHIP_ID,
 		.dev_name = "KSZ9897",
@@ -1370,6 +1398,7 @@ static enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
 		proto = DSA_TAG_PROTO_KSZ9893;
 
 	if (dev->chip_id == KSZ9477_CHIP_ID ||
+	    dev->chip_id == KSZ9896_CHIP_ID ||
 	    dev->chip_id == KSZ9897_CHIP_ID ||
 	    dev->chip_id == KSZ9567_CHIP_ID)
 		proto = DSA_TAG_PROTO_KSZ9477;
@@ -1730,6 +1759,7 @@ static int ksz_switch_detect(struct ksz_device *dev)
 
 		switch (id32) {
 		case KSZ9477_CHIP_ID:
+		case KSZ9896_CHIP_ID:
 		case KSZ9897_CHIP_ID:
 		case KSZ9893_CHIP_ID:
 		case KSZ9567_CHIP_ID:
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 0d9520dc6d2d..65980da61b54 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -129,6 +129,7 @@ enum ksz_model {
 	KSZ8765,
 	KSZ8830,
 	KSZ9477,
+	KSZ9896,
 	KSZ9897,
 	KSZ9893,
 	KSZ9567,
@@ -145,6 +146,7 @@ enum ksz_chip_id {
 	KSZ8765_CHIP_ID = 0x8765,
 	KSZ8830_CHIP_ID = 0x8830,
 	KSZ9477_CHIP_ID = 0x00947700,
+	KSZ9896_CHIP_ID = 0x00989600,
 	KSZ9897_CHIP_ID = 0x00989700,
 	KSZ9893_CHIP_ID = 0x00989300,
 	KSZ9567_CHIP_ID = 0x00956700,
diff --git a/drivers/net/dsa/microchip/ksz_spi.c b/drivers/net/dsa/microchip/ksz_spi.c
index 05bd089795f8..1b6ff5e3d575 100644
--- a/drivers/net/dsa/microchip/ksz_spi.c
+++ b/drivers/net/dsa/microchip/ksz_spi.c
@@ -146,6 +146,10 @@ static const struct of_device_id ksz_dt_ids[] = {
 		.compatible = "microchip,ksz9477",
 		.data = &ksz_switch_chips[KSZ9477]
 	},
+	{
+		.compatible = "microchip,ksz9896",
+		.data = &ksz_switch_chips[KSZ9896]
+	},
 	{
 		.compatible = "microchip,ksz9897",
 		.data = &ksz_switch_chips[KSZ9897]
@@ -197,6 +201,7 @@ static const struct spi_device_id ksz_spi_ids[] = {
 	{ "ksz8863" },
 	{ "ksz8873" },
 	{ "ksz9477" },
+	{ "ksz9896" },
 	{ "ksz9897" },
 	{ "ksz9893" },
 	{ "ksz9563" },
@@ -226,6 +231,7 @@ static struct spi_driver ksz_spi_driver = {
 module_spi_driver(ksz_spi_driver);
 
 MODULE_ALIAS("spi:ksz9477");
+MODULE_ALIAS("spi:ksz9896");
 MODULE_ALIAS("spi:ksz9897");
 MODULE_ALIAS("spi:ksz9893");
 MODULE_ALIAS("spi:ksz9563");
-- 
2.34.3

