Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8196E7F5B
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 18:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbjDSQQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 12:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbjDSQQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 12:16:11 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8535D1980
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 09:16:09 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2a8b766322bso29046851fa.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 09:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ferroamp-se.20221208.gappssmtp.com; s=20221208; t=1681920968; x=1684512968;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fi8kjwuXVhj1j5QJjITJjJeOgdxrv9rjxZm14dUtuQY=;
        b=KXwOwbGLmSLWjAKgxAaKOBgtFsUISw/ZIUIGWR/XOB/zbPoZ5UJxYvKWmuoSFXGHEn
         ERgMTAns8IofCNVppoAnndGfMe4Telk5u2COfvV4L/5exqVEoYXjoRpZqR9bzMqeJ5FN
         CDJnIiVbjvzPmlTVE4GaCXbJYoZa5hTcC7w2ZX5qJAqbVGMOpIwvB6PFQBRgxx8WpGD+
         e/bBJXlWHOIH2JqtVhysafjdN0Hb75PciiAWph9A0WuORjTaqrwvZ/gSwH+7kCLYqhqA
         uKJ7+uiRkfRYOzBPAC13KAf9e4CJpbaRtsO5yUhO03t32yBOi5RcS2mpuoNv3Nn6xY+n
         catg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681920968; x=1684512968;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fi8kjwuXVhj1j5QJjITJjJeOgdxrv9rjxZm14dUtuQY=;
        b=JAF5MAD5QMQtFdeckIRegNzJRCZ8BN8iaB54jYTio5gXCoo8NliazW0WzHm5B6v8a1
         JjolbJ6jXqIDu1BFvZn/HkAEvn8D6A6NOMT4CsMNAeZavDbBNkfk8N7DcDN45q5XM+8t
         L2SuqA2abmtlsycx4qgqRKtYujvzsGDJGZ9V0wozS4GQxpMppVgUSVK0xTGk1RdHRfwZ
         5TRlhZQhscoRtHyRDFwsrr34H9KUV3IxMBOsZGfdGtNVrzhdbI8q9Qpv64BwiXrdFaxb
         dott2Uv3WSISMrNTOcnn8vsVRtmkS1+nZtVgWEF5TbK8L3nsMAQs24D2z0Zxx1uY0jed
         A2Rg==
X-Gm-Message-State: AAQBX9cxBGAHnz+UaV70R6E33z6etI29RWlmdZl5RQ+gIKNt7uTi8Gsa
        3EGaP6kpBTzXS/7onsKRG0WjjA==
X-Google-Smtp-Source: AKy350ZHuINkqV6YLMGXFu2FBeywnJBO6mXTYJbiJtNEzpY67Ed1c0kXJtL5q3cmKwUPKOhI/XBvbw==
X-Received: by 2002:ac2:442a:0:b0:4ea:f60c:4e29 with SMTP id w10-20020ac2442a000000b004eaf60c4e29mr3597076lfl.20.1681920967693;
        Wed, 19 Apr 2023 09:16:07 -0700 (PDT)
Received: from debian (151.236.202.107.c.fiberdirekt.net. [151.236.202.107])
        by smtp.gmail.com with ESMTPSA id c25-20020ac244b9000000b004db266f3978sm2736845lfm.174.2023.04.19.09.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 09:16:07 -0700 (PDT)
Date:   Wed, 19 Apr 2023 18:16:05 +0200
From:   =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez 
        <ramon.nordin.rodriguez@ferroamp.se>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
Message-ID: <ZEATxeT+g5Bx5ml2@debian>
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

Changes:
    v2:
- Removed mentioning of not supporting auto-negotiation from commit
  message
- Renamed file drivers/net/phy/lan867x.c ->
  drivers/net/phy/microchip_t1s.c
- Renamed Kconfig option to reflect implementation filename (from
  LAN867X_PHY to MICROCHIP_T1S_PHY)
- Moved entry in drivers/net/phy/KConfig to correct sort order
- Moved entry in drivers/net/phy/Makefile to correct sort order
- Moved variable declarations to conform to reverse christmas tree order
  (in func lan867x_config_init)
- Moved register write to disable chip interrupts to func lan867x_config_init, when omitting the irq disable all togheter I got null pointer dereference, see the call trace below:

    Call Trace:
     <TASK>
     phy_interrupt+0xa8/0xf0 [libphy]
     irq_thread_fn+0x1c/0x60
     irq_thread+0xf7/0x1c0
     ? __pfx_irq_thread_dtor+0x10/0x10
     ? __pfx_irq_thread+0x10/0x10
     kthread+0xe6/0x110
     ? __pfx_kthread+0x10/0x10
     ret_from_fork+0x29/0x50
     </TASK>

- Removed func lan867x_config_interrupt and removed the member
  .config_intr from the phy_driver struct

    v3:
- Indentation level in drivers/net/phy/Kconfig
- Moved const arrays into global scope and made them static in order to have
  them placed in the .rodata section
- Renamed array variables, since they are no longer as closely scoped as
  earlier
- Added comment about why phy_write_mmd is used over phy_modify_mmd
  (this should have been addressed in the V2 change since it was brought
  up in the V1 review)
- Return result of last call instead of saving it in a var and then
  returning the var (in lan867x_config_init)

Testing:
This has been tested with ethtool --set/get-plca-cfg and verified on an
oscilloscope where it was observed that:
- The PLCA beacon was enabled/disabled when setting the node-id to 0/not
  0
- The PLCA beacon is transmitted with the expected frequency when
  changing max nodes
- Two devices using the evaluation board EVB-LAN8670-USB could ping each
  other


This patch adds support for the Microchip LAN867x 10BASE-T1S family
(LAN8670/1/2). The driver supports P2MP with PLCA.

Signed-off-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
---
 drivers/net/phy/Kconfig         |   5 ++
 drivers/net/phy/Makefile        |   1 +
 drivers/net/phy/microchip_t1s.c | 138 ++++++++++++++++++++++++++++++++
 3 files changed, 144 insertions(+)
 create mode 100644 drivers/net/phy/microchip_t1s.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 54874555c921..15a0bd95f12c 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -235,6 +235,11 @@ config MICREL_PHY
 	help
 	  Supports the KSZ9021, VSC8201, KS8001 PHYs.
 
+config MICROCHIP_T1S_PHY
+	tristate "Microchip 10BASE-T1S Ethernet PHY"
+	help
+	  Currently supports the LAN8670, LAN8671, LAN8672
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
index 000000000000..b7fd5141a117
--- /dev/null
+++ b/drivers/net/phy/microchip_t1s.c
@@ -0,0 +1,138 @@
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
+/* The arrays below are pulled from the following table from AN1699
+ * Access MMD Address Value Mask
+ * RMW 0x1F 0x00D0 0x0002 0x0E03
+ * RMW 0x1F 0x00D1 0x0000 0x0300
+ * RMW 0x1F 0x0084 0x3380 0xFFC0
+ * RMW 0x1F 0x0085 0x0006 0x000F
+ * RMW 0x1F 0x008A 0xC000 0xF800
+ * RMW 0x1F 0x0087 0x801C 0x801C
+ * RMW 0x1F 0x0088 0x033F 0x1FFF
+ * W   0x1F 0x008B 0x0404 ------
+ * RMW 0x1F 0x0080 0x0600 0x0600
+ * RMW 0x1F 0x00F1 0x2400 0x7F00
+ * RMW 0x1F 0x0096 0x2000 0x2000
+ * W   0x1F 0x0099 0x7F80 ------
+ */
+
+static const int lan867x_fixup_registers[12] = {
+	0x00D0, 0x00D1, 0x0084, 0x0085,
+	0x008A, 0x0087, 0x0088, 0x008B,
+	0x0080, 0x00F1, 0x0096, 0x0099,
+};
+
+static const int lan867x_fixup_values[12] = {
+	0x0002, 0x0000, 0x3380, 0x0006,
+	0xC000, 0x801C, 0x033F, 0x0404,
+	0x0600, 0x2400, 0x2000, 0x7F80,
+};
+
+static const int lan867x_fixup_masks[12] = {
+	0x0E03, 0x0300, 0xFFC0, 0x000F,
+	0xF800, 0x801C, 0x1FFF, 0xFFFF,
+	0x0600, 0x7F00, 0x2000, 0xFFFF,
+};
+
+static int lan867x_config_init(struct phy_device *phydev)
+{
+	/* HW quirk: Microchip states in the application note (AN1699) for the phy
+	 * that a set of read-modify-write (rmw) operations has to be performed
+	 * on a set of seemingly magic registers.
+	 * The result of these operations is just described as 'optimal performance'
+	 * Microchip gives no explanation as to what these mmd regs do,
+	 * in fact they are marked as reserved in the datasheet.
+	 * It is unclear if phy_modify_mmd would be safe to use or if a write
+	 * really has to happen to each register.
+	 * In order to exacly conform to what is stated in the AN phy_write_mmd is
+	 * used, which might then write the same value back as read + modified.
+	 */
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
+	for (int i = 0; i < ARRAY_SIZE(lan867x_fixup_registers); i++) {
+		reg = lan867x_fixup_registers[i];
+		reg_value = phy_read_mmd(phydev, MDIO_MMD_VEND2, reg);
+		reg_value &= ~lan867x_fixup_masks[i];
+		reg_value |= lan867x_fixup_values[i];
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
+	return phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN867X_REG_IRQ_2_CTL, 0xFFFF);
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

