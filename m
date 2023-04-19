Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A19D6E785D
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 13:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbjDSLR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 07:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjDSLRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 07:17:55 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78064B2
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 04:17:32 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id x34so20312681ljq.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 04:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ferroamp-se.20221208.gappssmtp.com; s=20221208; t=1681903001; x=1684495001;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:to:from:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BXJWQFA85v6d8oIIDZh3IpHreb787fwGrma5Fz4wLMk=;
        b=Pf+gTrgTCxvNKeKZ/NnNreVAQMIEgSyaNT/5SPdgFMrwOHgMH499Qp9D3lK2qnLgfI
         //KFGtwJEC2PcWqlvQsKgcdy6a01XPwrP/Xjm8FHHY9H5zvVHLM5AdkhcotnrOHtt+Yv
         gLPrOqsAc/3CXeRBF+NZsA8oLH5Cu83Yox4Gw3K1vFQH7BS2HUXOUYPEHYfOc7Rwal3O
         3iAbyJSq6O+KHnQb78aHmBJsN8o6xd4NbUdt9cNhleXV5JnGq3hvGCyHKqr/fxakUsiY
         jRUDoJa8itKyro8SFjgE9qCRcw4wz0NNg2rq3JC7SUlA6W24NnmDlSSmpccdnlkvBXXW
         KaVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681903001; x=1684495001;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BXJWQFA85v6d8oIIDZh3IpHreb787fwGrma5Fz4wLMk=;
        b=Hv3ZdFvyoUnuwo1HAnzwCuCtZXiRvtiNHavnrox0qXCiU6Asq7epxNz4KT1VTy6nIy
         vUyh4p0MKbcKTuTSPcNwEFNKgJ+fIqt1DhjqcLgiJOGu37xQJ7JOcQgnMSioHfld/ryZ
         h6tY65IIDSQ+JqRLTDPHXvdKFz6dKOzxZe1OO5riECMSx2MY1El7/pcSK+OigNYjZrOn
         c47cw0x+7ZtYUZBe6Zmz7OOpKEbHAAKsNwgwb03uZn3OcEeCpegM/MJ3041J9SX/JDNg
         2PfC5iDFcxXh+jGcarqHd9btMwHCJp/tGEv4GwM+hSE75LJ0rxJWx27rgM2uOeoXZuvY
         XlEw==
X-Gm-Message-State: AAQBX9f3aKdvVDpHLEWb/NBhob/vngW4W/PMoXHx9v8wuNeOKhtzOGI2
        xtJ6YPgNLPFqTYn7ocqebgON3Q==
X-Google-Smtp-Source: AKy350aV0Hl0psbTfICTF/A3hign1DIfw4Z7F0wxWWMDt0OrjGKJkT/rIcF4XdCknXb/MMAzOA/8cA==
X-Received: by 2002:a2e:888c:0:b0:2a8:e4d3:11e2 with SMTP id k12-20020a2e888c000000b002a8e4d311e2mr1512304lji.39.1681903001446;
        Wed, 19 Apr 2023 04:16:41 -0700 (PDT)
Received: from debian (151.236.202.107.c.fiberdirekt.net. [151.236.202.107])
        by smtp.gmail.com with ESMTPSA id u25-20020a2e2e19000000b002a7e9e4e9dcsm2809078lju.114.2023.04.19.04.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 04:16:41 -0700 (PDT)
Date:   Wed, 19 Apr 2023 13:16:39 +0200
From:   =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez 
        <ramon.nordin.rodriguez@ferroamp.se>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH v2] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
Message-ID: <ZD/Nl+4JAmW2VTzh@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for the Microchip LAN867x 10BASE-T1S family
(LAN8670/1/2). The driver supports P2MP with PLCA.

Signed-off-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
---
 drivers/net/phy/Kconfig         |   5 ++
 drivers/net/phy/Makefile        |   1 +
 drivers/net/phy/microchip_t1s.c | 136 ++++++++++++++++++++++++++++++++
 3 files changed, 142 insertions(+)
 create mode 100644 drivers/net/phy/microchip_t1s.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 54874555c921..c12e30f83b4f 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -235,6 +235,11 @@ config MICREL_PHY
 	help
 	  Supports the KSZ9021, VSC8201, KS8001 PHYs.
 
+config MICROCHIP_T1S_PHY
+	tristate "Microchip 10BASE-T1S Ethernet PHY"
+	help
+		Currently supports the LAN8670, LAN8671, LAN8672
+
 config MICROCHIP_PHY
 	tristate "Microchip PHYs"
 	help
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index b5138066ba04..64f649f2f62f 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -74,6 +74,7 @@ obj-$(CONFIG_MICREL_KS8995MA)	+= spi_ks8995.o
 obj-$(CONFIG_MICREL_PHY)	+= micrel.o
 obj-$(CONFIG_MICROCHIP_PHY)	+= microchip.o
 obj-$(CONFIG_MICROCHIP_T1_PHY)	+= microchip_t1.o
+obj-$(CONFIG_MICROCHIP_T1S_PHY) += microchip_t1s.o
 obj-$(CONFIG_MICROSEMI_PHY)	+= mscc/
 obj-$(CONFIG_MOTORCOMM_PHY)	+= motorcomm.o
 obj-$(CONFIG_NATIONAL_PHY)	+= national.o
diff --git a/drivers/net/phy/microchip_t1s.c b/drivers/net/phy/microchip_t1s.c
new file mode 100644
index 000000000000..edb50ce63c63
--- /dev/null
+++ b/drivers/net/phy/microchip_t1s.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Driver for Microchip 10BASE-T1S LAN867X PHY
+ *
+ * Support: Microchip Phys:
+ *  lan8670, lan8671, lan8672
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/phy.h>
+
+#define PHY_ID_LAN867X 0x0007C160
+
+#define LAN867X_REG_IRQ_1_CTL 0x001C
+#define LAN867X_REG_IRQ_2_CTL 0x001D
+
+static int lan867x_config_init(struct phy_device *phydev)
+{
+	/* HW quirk: Microchip states in the application note (AN1699) for the phy
+	 * that a set of read-modify-write (rmw) operations has to be performed
+	 * on a set of seemingly magic registers.
+	 * The result of these operations is just described as 'optimal performance'
+	 * Microchip gives no explanation as to what these mmd regs do,
+	 * in fact they are marked as reserved in the datasheet.
+	 */
+
+	/* The arrays below are pulled from the following table from AN1699
+	 * Access MMD Address Value Mask
+	 * RMW 0x1F 0x00D0 0x0002 0x0E03
+	 * RMW 0x1F 0x00D1 0x0000 0x0300
+	 * RMW 0x1F 0x0084 0x3380 0xFFC0
+	 * RMW 0x1F 0x0085 0x0006 0x000F
+	 * RMW 0x1F 0x008A 0xC000 0xF800
+	 * RMW 0x1F 0x0087 0x801C 0x801C
+	 * RMW 0x1F 0x0088 0x033F 0x1FFF
+	 * W   0x1F 0x008B 0x0404 ------
+	 * RMW 0x1F 0x0080 0x0600 0x0600
+	 * RMW 0x1F 0x00F1 0x2400 0x7F00
+	 * RMW 0x1F 0x0096 0x2000 0x2000
+	 * W   0x1F 0x0099 0x7F80 ------
+	 */
+
+	const int registers[12] = {
+		0x00D0, 0x00D1, 0x0084, 0x0085,
+		0x008A, 0x0087, 0x0088, 0x008B,
+		0x0080, 0x00F1, 0x0096, 0x0099,
+	};
+
+	const int values[12] = {
+		0x0002, 0x0000, 0x3380, 0x0006,
+		0xC000, 0x801C, 0x033F, 0x0404,
+		0x0600, 0x2400, 0x2000, 0x7F80,
+	};
+
+	const int masks[12] = {
+		0x0E03, 0x0300, 0xFFC0, 0x000F,
+		0xF800, 0x801C, 0x1FFF, 0xFFFF,
+		0x0600, 0x7F00, 0x2000, 0xFFFF,
+	};
+
+	int reg_value;
+	int err;
+	int reg;
+
+	/* Read-Modified Write Pseudocode (from AN1699)
+	 * current_val = read_register(mmd, addr) // Read current register value
+	 * new_val = current_val AND (NOT mask) // Clear bit fields to be written
+	 * new_val = new_val OR value // Set bits
+	 * write_register(mmd, addr, new_val) // Write back updated register value
+	 */
+	for (int i = 0; i < ARRAY_SIZE(registers); i++) {
+		reg = registers[i];
+		reg_value = phy_read_mmd(phydev, MDIO_MMD_VEND2, reg);
+		reg_value &= ~masks[i];
+		reg_value |= values[i];
+		err = phy_write_mmd(phydev, MDIO_MMD_VEND2, reg, reg_value);
+		if (err != 0)
+			return err;
+	}
+
+	/* None of the interrupts in the lan867x phy seem relevant.
+	 * Other phys inspect the link status and call phy_trigger_machine
+	 * in the interrupt handler.
+	 * This phy does not support link status, and thus has no interrupt
+	 * for it either.
+	 * So we'll just disable all interrupts on the chip.
+	 */
+	err = phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN867X_REG_IRQ_1_CTL, 0xFFFF);
+	if (err != 0)
+		return err;
+	err = phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN867X_REG_IRQ_2_CTL, 0xFFFF);
+
+	return err;
+}
+
+static int lan867x_read_status(struct phy_device *phydev)
+{
+	/* The phy has some limitations, namely:
+	 *  - always reports link up
+	 *  - only supports 10MBit half duplex
+	 *  - does not support auto negotiate
+	 */
+	phydev->link = 1;
+	phydev->duplex = DUPLEX_HALF;
+	phydev->speed = SPEED_10;
+	phydev->autoneg = AUTONEG_DISABLE;
+
+	return 0;
+}
+
+static struct phy_driver lan867x_driver[] = {
+	{
+		PHY_ID_MATCH_MODEL(PHY_ID_LAN867X),
+		.name               = "LAN867X",
+		.features           = PHY_BASIC_T1S_P2MP_FEATURES,
+		.config_init        = lan867x_config_init,
+		.read_status        = lan867x_read_status,
+		.get_plca_cfg	    = genphy_c45_plca_get_cfg,
+		.set_plca_cfg	    = genphy_c45_plca_set_cfg,
+		.get_plca_status    = genphy_c45_plca_get_status,
+	}
+};
+
+module_phy_driver(lan867x_driver);
+
+static struct mdio_device_id __maybe_unused tbl[] = {
+	{ PHY_ID_MATCH_MODEL(PHY_ID_LAN867X) },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(mdio, tbl);
+
+MODULE_DESCRIPTION("Microchip 10BASE-T1S lan867x Phy driver");
+MODULE_AUTHOR("Ramón Nordin Rodriguez");
+MODULE_LICENSE("GPL");
-- 
2.39.2

