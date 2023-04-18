Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C876E6B74
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 19:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbjDRRwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 13:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbjDRRwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 13:52:41 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89347AF38
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 10:52:15 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id r9so17591588ljp.9
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 10:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ferroamp-se.20221208.gappssmtp.com; s=20221208; t=1681840334; x=1684432334;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xb79SR5jvbN5Ue1g/1TJ93PdwPewIhop9+9zpHMP824=;
        b=JatVrYQvQlmdE6/2PvljP6TurM7mzsduag28q3YK8STNUgFpbK+IbRmyLC2FbT6fYl
         6CYyXF60cLbPJYZcesMWgJPIRivaJH8MTNwYVzp/MY+vENvjfMCjQ48j7PvJis7GassQ
         CQp0KoiLCfep0yZzkd+G6Ejts2uSuGXRboLS7RU1ZQJK5kRRGbs3Kvnfrc0tLRVVjQsR
         AdqT8jq2JLLKaz0UTKO26v3bp2ejcec4tj7S2Jp2QeGDaart1hXZ7EiSM/7mMrG96Ush
         FkSMJ4NWYD5isGAGJUNkJwq4N0uxVrNWvVye3rTSnihMBqZDtltDcb28o1nisOPSX5Gf
         j6+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681840334; x=1684432334;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xb79SR5jvbN5Ue1g/1TJ93PdwPewIhop9+9zpHMP824=;
        b=Qf8VumWmSs3sSlfD/Y5/0L7Y67fkKCGJpE+elS9sNA/o9A+P1Lb4RQyOe68JG15wIY
         u1eAmjd/n4BfNM8HNOnOGGk7Xux+ANmaZlIulRwm5GyPUafyiuTKkWNQvBKMBMoc2J6X
         nqq+f4difheFDspKmqgRg7URfw6RbGEuoZ2ezb8HEKZ1/y+cA9BHRRv0w5nAPbFy1wj4
         CtWuW2iMEIubOT7uQLTnbjQig3zk4TWrAIun6MBUmmKN+Toq/7q/ybwxp4ktXJpYf17t
         CaXpOVruyUB+mKJecYYNVCQoct1ci3tqTnMs4oX0r1d4cEpvGHfMYneMFoYvO9+SMvgE
         ZR4g==
X-Gm-Message-State: AAQBX9cX89VEw9wTOOMxWWtSkw18PWtr1ZsbRfLXUEeOXlSLHs4ZRx4K
        jlzJ2Skq5JSLv3bwUj68/fwcnaURx9Oz9cdWAHA=
X-Google-Smtp-Source: AKy350bNptFcFGKc4RmTK8lPzj9u3dCvu4UlVLge9A1XLmLlQyQpiIobIEBjepfxEkqC+hj0C75UVw==
X-Received: by 2002:a2e:7c15:0:b0:2a7:6e85:e287 with SMTP id x21-20020a2e7c15000000b002a76e85e287mr952051ljc.45.1681840333714;
        Tue, 18 Apr 2023 10:52:13 -0700 (PDT)
Received: from builder (c188-148-248-178.bredband.tele2.se. [188.148.248.178])
        by smtp.gmail.com with ESMTPSA id u25-20020a2e2e19000000b002a7e9e4e9dcsm2567343lju.114.2023.04.18.10.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 10:52:13 -0700 (PDT)
Date:   Tue, 18 Apr 2023 19:52:12 +0200
From:   =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez 
        <ramon.nordin.rodriguez@ferroamp.se>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH] drivers/net/phy: add driver for Microchip LAN867x 10BASE-T1S
 PHY
Message-ID: <ZD7YzBhzlEBHrEPC@builder>
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
 drivers/net/phy/Kconfig   |   5 ++
 drivers/net/phy/Makefile  |   1 +
 drivers/net/phy/lan867x.c | 144 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 150 insertions(+)
 create mode 100644 drivers/net/phy/lan867x.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 54874555c921..63ba7f51087e 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -284,6 +284,11 @@ config NCN26000_PHY
 	  Currently supports the NCN26000 10BASE-T1S Industrial PHY
 	  with MII interface.
 
+config LAN867X_PHY
+	tristate "Microchip 10BASE-T1S Ethernet PHY"
+	help
+		Currently supports the LAN8670, LAN8671, LAN8672
+
 config AT803X_PHY
 	tristate "Qualcomm Atheros AR803X PHYs and QCA833x PHYs"
 	depends on REGULATOR
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index b5138066ba04..a12c2f296297 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -78,6 +78,7 @@ obj-$(CONFIG_MICROSEMI_PHY)	+= mscc/
 obj-$(CONFIG_MOTORCOMM_PHY)	+= motorcomm.o
 obj-$(CONFIG_NATIONAL_PHY)	+= national.o
 obj-$(CONFIG_NCN26000_PHY)	+= ncn26000.o
+obj-$(CONFIG_LAN867X_PHY) += lan867x.o
 obj-$(CONFIG_NXP_C45_TJA11XX_PHY)	+= nxp-c45-tja11xx.o
 obj-$(CONFIG_NXP_TJA11XX_PHY)	+= nxp-tja11xx.o
 obj-$(CONFIG_QSEMI_PHY)		+= qsemi.o
diff --git a/drivers/net/phy/lan867x.c b/drivers/net/phy/lan867x.c
new file mode 100644
index 000000000000..c861c46ed06b
--- /dev/null
+++ b/drivers/net/phy/lan867x.c
@@ -0,0 +1,144 @@
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
+	const int masks[12] = {
+		0x0E03, 0x0300, 0xFFC0, 0x000F,
+		0xF800, 0x801C, 0x1FFF, 0xFFFF,
+		0x0600, 0x7F00, 0x2000, 0xFFFF,
+	};
+
+	const int values[12] = {
+		0x0002, 0x0000, 0x3380, 0x0006,
+		0xC000, 0x801C, 0x033F, 0x0404,
+		0x0600, 0x2400, 0x2000, 0x7F80,
+	};
+
+	int err;
+	int reg;
+	int reg_value;
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
+	return 0;
+}
+
+static int lan867x_config_interrupt(struct phy_device *phydev)
+{
+	/* None of the interrupts in the lan867x phy seem relevant.
+	 * Other phys inspect the link status and call phy_trigger_machine
+	 * on change.
+	 * This phy does not support link status, and thus has no interrupt
+	 * for it either.
+	 * So we'll just disable all interrupts instead.
+	 */
+
+	int err;
+
+	err = phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN867X_REG_IRQ_1_CTL, 0xFFFF);
+	if (err)
+		return err;
+	err = phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN867X_REG_IRQ_2_CTL, 0xFFFF);
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
+		.config_intr        = lan867x_config_interrupt,
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

