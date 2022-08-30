Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC24B5A5D84
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiH3H7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbiH3H7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:59:09 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3583DD21EA
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:59:07 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id s23so5361720wmj.4
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=DOZjU19MdyrjsMo/yVt8Gv1h06wVp7LxpnfNQUHkqPE=;
        b=BE7v+se4YfYMORLfoJUut6UwqEI4UHc79MBLU8AZ7yNbB3sjnZjLjJMgdHWDom0bDJ
         vs2RT+XbsTOhdnV1e20q/4wimb1P9BFURR3ric25Lc0VbN1kzeHxm5HhKvgl6Lrskg1n
         acY/ac91Q3Lit0JZ6MTzbFb2r4CZzqEUfWmv9AkdZ9zGA8V3t22V5M8xxZg2n9Aim9iI
         /wh1KyZH9goyave/QjbZZzE8jwVbwWQ6Kuu1arxZiHg99x6CUEuEBFUS/TFeHLlFceYg
         W5H2IPsQHKfcpVGfRdG3kzsgNzA7Vce1a9C0tBH6DVaw+vb4tAmdBZS1OsJZWjf/oern
         uDtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=DOZjU19MdyrjsMo/yVt8Gv1h06wVp7LxpnfNQUHkqPE=;
        b=yiKqq2a9cgzCCmTTw5VUpMdlWaSF2uRpSzmC+fza5r4wz3LGMQV95UP5hHGrzy65pa
         DgvNerFd0XSBnYzbF6pay6vtq6oJPQXFSIAl1yXdiULjfAp95oUKaoRQ6YgbHaSU/yja
         ErnwWziXowhDUqpqUdUGdip9ze00r7nmxOiuHdZms8+P4jv150FfZs+oMcdEa3lx+TD0
         aeqpTEQq/2PqCs2noFj7XUGh+OJM1MhQwCBCspBmfH4mz49dgYGfTykyVsAQ93xQmK5/
         8RsiqAJXTmeSNxajNQNrRBQqKJJvOyNhMhnFGpSRq31ze0IiFM05ni3yWUAqQHKmvaQ4
         +WpA==
X-Gm-Message-State: ACgBeo1A+deGg4YSnWYLC70b6vinBxM6mX8mXIzpPtCu6tueB8AgFwBM
        FYbotjVIDioDrwHgWmtk1NWu/FvNY1en+g==
X-Google-Smtp-Source: AA6agR6N5dh8Y/bW5wyG3UmCW/2DDCRg53trBtl0Pbwj2+vzwZ3dqH3tqCq5RsnvI6aAPwxT3Wi7Vg==
X-Received: by 2002:a1c:4c11:0:b0:3a5:4d01:54be with SMTP id z17-20020a1c4c11000000b003a54d0154bemr9148699wmf.32.1661846345671;
        Tue, 30 Aug 2022 00:59:05 -0700 (PDT)
Received: from P-NTS-Evian.home (2a01cb058f8a18001c97b8d1b477d53f.ipv6.abo.wanadoo.fr. [2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f])
        by smtp.gmail.com with ESMTPSA id r21-20020adfa155000000b0022585f6679dsm8980142wrr.106.2022.08.30.00.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 00:59:05 -0700 (PDT)
From:   Romain Naour <romain.naour@smile.fr>
To:     netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net, olteanv@gmail.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        Romain Naour <romain.naour@skf.com>
Subject: [PATCH v2 1/2] net: dsa: microchip: add KSZ9896 switch support
Date:   Tue, 30 Aug 2022 09:58:59 +0200
Message-Id: <20220830075900.3401750-1-romain.naour@smile.fr>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
---
It seems that the KSZ9896 support has been sent to the kernel netdev
mailing list a while ago but no further patch was sent after the
initial review:
https://www.spinics.net/lists/netdev/msg554771.html

The initial testing with the ksz9896 was done on a 5.10 kernel
but due to recent changes in dsa microchip driver it was required
to rework this initial version for 6.0-rc2 kernel.

v2: remove duplicated SoB line
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

