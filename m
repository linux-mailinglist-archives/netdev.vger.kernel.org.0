Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94145AAC2A
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 12:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbiIBKQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 06:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbiIBKQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 06:16:20 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195027F245
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 03:16:17 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id k6-20020a05600c1c8600b003a54ecc62f6so1111478wms.5
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 03:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=q69HqvdgQSKnmUI1UJMlA92uPSmPm3an+A2rTR/K01s=;
        b=NgckYZri6r+0q8l/qxMmZSK8lZIBzKr3J0P7UjVAir63jqITM8ZxbYadAWM5PLFeN3
         WdJPUyaB9F1sUn/1meogWn8etCt4DD75beDAYrXZIB0WWO41noWntgi6zMHw08/kXeOl
         X666evp+CGF25WJE9/+PAZtB7zVljhhF5u6c8BKB5E/11pR9e7TXtNIaitskmH1aNGvm
         dDQskCEZ1QSgvC/TD+iLy89nUM0Xqhgf9enytpLqBYrT1fJfsvZCuSY5sybZdap6l+PT
         sj99GDtFJvqugQhqOA7S1o6rE0hV9TY+kyGH/EDP60cAEMLizc1BFu5VgA3mfvE4xsKX
         RyEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=q69HqvdgQSKnmUI1UJMlA92uPSmPm3an+A2rTR/K01s=;
        b=Eps3qRoERwf7acYIgtM+kVvKIh1HWCE2cQz1rgewjD+HgvVFB0zmR23l4KkIeOuxUb
         FJ5V1v8C7ImAQjrZd/iEo0Fun9bthJYwxVq3W44xub+lADQZti6EhXziv79I0HT4LeVS
         3l0WxeiUaOZ8Se0bfUbxf/zwOkZ18dWSh1ZetNxhenhXqUjXnOBTBj3+nH6jPhZdRVDK
         ewejZsrKPo0UVgFi9ctePIBnHxQZkTgnkI8OUx7Dx0/fvZpGPegMUD2rSo87LUB9d0rD
         KwjAXjNLWVP99ME+2zwc8yskaLZzVYwyR93fRVYzkcSgoK61NfrzsElUBfXvOaKk0E9Y
         pkRg==
X-Gm-Message-State: ACgBeo1KpvEuoVvbi3JlgOUZCY6202g8zM4aHEi1l3JVRj14BTrY2Rzh
        q4PR66zRlUBvNyrOr6dmUB1UiKykNGn5QQ==
X-Google-Smtp-Source: AA6agR5sH7d3VJgf/TGFgTjPpImoVKlkt6FPpOHAfQWBeO1eCF+0QCsOyMKt87sxwfCZ2Ulkbol8cA==
X-Received: by 2002:a05:600c:4e8c:b0:3a6:11e:cc08 with SMTP id f12-20020a05600c4e8c00b003a6011ecc08mr2287971wmq.198.1662113775414;
        Fri, 02 Sep 2022 03:16:15 -0700 (PDT)
Received: from P-NTS-Evian.home (2a01cb058f8a18001c97b8d1b477d53f.ipv6.abo.wanadoo.fr. [2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f])
        by smtp.gmail.com with ESMTPSA id a8-20020adfeec8000000b00226d1821abesm1140913wrp.56.2022.09.02.03.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 03:16:14 -0700 (PDT)
From:   Romain Naour <romain.naour@smile.fr>
To:     netdev@vger.kernel.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, olteanv@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        Romain Naour <romain.naour@skf.com>
Subject: [PATCH v3: net-next 1/4] net: dsa: microchip: add KSZ9896 switch support
Date:   Fri,  2 Sep 2022 12:16:07 +0200
Message-Id: <20220902101610.109646-1-romain.naour@smile.fr>
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
to rework this initial version for 6.0-rc2 kernel and development
tree net-next for the upcoming 6.1 kernel.

v3: rebase onto net-next kernel tree
    Add gbit_capable setting for per-port Gbit detection
v2: remove duplicated SoB line
---
 drivers/net/dsa/microchip/ksz_common.c | 31 ++++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h |  2 ++
 drivers/net/dsa/microchip/ksz_spi.c    |  6 +++++
 3 files changed, 39 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 37fb5ba2cd7a..02fb721c1090 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -965,6 +965,35 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.rd_table = &ksz9477_register_set,
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
+		.gbit_capable	= {true, true, true, true, true, true},
+	},
+
 	[KSZ9897] = {
 		.chip_id = KSZ9897_CHIP_ID,
 		.dev_name = "KSZ9897",
@@ -1798,6 +1827,7 @@ static enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
 		proto = DSA_TAG_PROTO_KSZ9893;
 
 	if (dev->chip_id == KSZ9477_CHIP_ID ||
+	    dev->chip_id == KSZ9896_CHIP_ID ||
 	    dev->chip_id == KSZ9897_CHIP_ID ||
 	    dev->chip_id == KSZ9567_CHIP_ID)
 		proto = DSA_TAG_PROTO_KSZ9477;
@@ -2159,6 +2189,7 @@ static int ksz_switch_detect(struct ksz_device *dev)
 
 		switch (id32) {
 		case KSZ9477_CHIP_ID:
+		case KSZ9896_CHIP_ID:
 		case KSZ9897_CHIP_ID:
 		case KSZ9567_CHIP_ID:
 		case LAN9370_CHIP_ID:
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index c01989c04d4e..6efd2cdbd0bb 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -130,6 +130,7 @@ enum ksz_model {
 	KSZ8765,
 	KSZ8830,
 	KSZ9477,
+	KSZ9896,
 	KSZ9897,
 	KSZ9893,
 	KSZ9567,
@@ -147,6 +148,7 @@ enum ksz_chip_id {
 	KSZ8765_CHIP_ID = 0x8765,
 	KSZ8830_CHIP_ID = 0x8830,
 	KSZ9477_CHIP_ID = 0x00947700,
+	KSZ9896_CHIP_ID = 0x00989600,
 	KSZ9897_CHIP_ID = 0x00989700,
 	KSZ9893_CHIP_ID = 0x00989300,
 	KSZ9567_CHIP_ID = 0x00956700,
diff --git a/drivers/net/dsa/microchip/ksz_spi.c b/drivers/net/dsa/microchip/ksz_spi.c
index 44c2d9912406..bf7cb269118c 100644
--- a/drivers/net/dsa/microchip/ksz_spi.c
+++ b/drivers/net/dsa/microchip/ksz_spi.c
@@ -149,6 +149,10 @@ static const struct of_device_id ksz_dt_ids[] = {
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
@@ -200,6 +204,7 @@ static const struct spi_device_id ksz_spi_ids[] = {
 	{ "ksz8863" },
 	{ "ksz8873" },
 	{ "ksz9477" },
+	{ "ksz9896" },
 	{ "ksz9897" },
 	{ "ksz9893" },
 	{ "ksz9563" },
@@ -229,6 +234,7 @@ static struct spi_driver ksz_spi_driver = {
 module_spi_driver(ksz_spi_driver);
 
 MODULE_ALIAS("spi:ksz9477");
+MODULE_ALIAS("spi:ksz9896");
 MODULE_ALIAS("spi:ksz9897");
 MODULE_ALIAS("spi:ksz9893");
 MODULE_ALIAS("spi:ksz9563");
-- 
2.34.3

