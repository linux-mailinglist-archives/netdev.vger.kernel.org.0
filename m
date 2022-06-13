Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA005498CA
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241767AbiFMPbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 11:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351516AbiFMP2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 11:28:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75AE13F431
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 06:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3efvqG/tp3D4GkVTZVX93KaRQzfunqrAaOeTQWJh+i0=; b=dd3eE4BHT/pMNvRX2Ohj6LwAy4
        5oBCFsSws88+FjLfUn7aFSfhP7XxEpPyetbl0u+VWOi+zHpjfdcWOe2caIMnu8XjL8CTOOWDk6IQ3
        IUixEwY5b50AfHTBveIQTTFu6jfLck6OMEh3qZDBeBSpym8mxhE2ZcNdDvPWvWg7Em04hqeC0KcXN
        uml8JYAt44337CFVYBcTrwyNYBzAWN4y7vy7qEBuUbfwJ30Da8xspF8gwRTKQdKZwNO3KpI06s3iW
        wVTe2eRmAgURTJAxIu7DAOHfKq8S4N87iEpNoHIyE2G+u6qG1X8wj+bAlZeeBDk1gTd9btHQr6Epi
        zRKyaBvw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52104 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o0jhF-0001tO-9h; Mon, 13 Jun 2022 14:01:33 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o0jhE-000JZT-KA; Mon, 13 Jun 2022 14:01:32 +0100
In-Reply-To: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
References: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 14/15] net: dsa: mv88e6xxx: convert 88e639x to
 phylink_pcs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o0jhE-000JZT-KA@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 13 Jun 2022 14:01:32 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the 88E6390, 88E6390X, and 88E6393X family of switches to use
the phylink_pcs infrastructure.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/Makefile   |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c     |  98 +---
 drivers/net/dsa/mv88e6xxx/pcs-639x.c | 834 +++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.c   | 752 +-----------------------
 drivers/net/dsa/mv88e6xxx/serdes.h   |  36 +-
 5 files changed, 874 insertions(+), 847 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/pcs-639x.c

diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
index 03dd49d0c71f..e6062a2c1eaf 100644
--- a/drivers/net/dsa/mv88e6xxx/Makefile
+++ b/drivers/net/dsa/mv88e6xxx/Makefile
@@ -11,6 +11,7 @@ mv88e6xxx-objs += global2_scratch.o
 mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += hwtstamp.o
 mv88e6xxx-objs += pcs-6185.o
 mv88e6xxx-objs += pcs-6352.o
+mv88e6xxx-objs += pcs-639x.o
 mv88e6xxx-objs += phy.o
 mv88e6xxx-objs += port.o
 mv88e6xxx-objs += port_hidden.o
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5855bdc338e1..a3cd3dadeb1f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4347,16 +4347,11 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6352_g1_stu_getnext,
 	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
-	.serdes_power = mv88e6390_serdes_power,
+	.pcs_init = mv88e6390_pcs_init,
+	.pcs_teardown = mv88e639x_pcs_teardown,
+	.pcs_select = mv88e639x_pcs_select,
 	.serdes_get_lane = mv88e6341_serdes_get_lane,
-	/* Check status register pause & lpa register */
-	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
-	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
-	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
-	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
-	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
-	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
@@ -4730,16 +4725,11 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6390_g1_stu_getnext,
 	.stu_loadpurge = mv88e6390_g1_stu_loadpurge,
-	.serdes_power = mv88e6390_serdes_power,
+	.pcs_init = mv88e6390_pcs_init,
+	.pcs_teardown = mv88e639x_pcs_teardown,
+	.pcs_select = mv88e639x_pcs_select,
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
-	/* Check status register pause & lpa register */
-	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
-	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
-	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
-	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
-	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
-	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
@@ -4793,16 +4783,11 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6390_g1_stu_getnext,
 	.stu_loadpurge = mv88e6390_g1_stu_loadpurge,
-	.serdes_power = mv88e6390_serdes_power,
+	.pcs_init = mv88e6390_pcs_init,
+	.pcs_teardown = mv88e639x_pcs_teardown,
+	.pcs_select = mv88e639x_pcs_select,
 	.serdes_get_lane = mv88e6390x_serdes_get_lane,
-	/* Check status register pause & lpa register */
-	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
-	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
-	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
-	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
-	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
-	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
@@ -4854,16 +4839,11 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6390_g1_stu_getnext,
 	.stu_loadpurge = mv88e6390_g1_stu_loadpurge,
-	.serdes_power = mv88e6390_serdes_power,
+	.pcs_init = mv88e6390_pcs_init,
+	.pcs_teardown = mv88e639x_pcs_teardown,
+	.pcs_select = mv88e639x_pcs_select,
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
-	/* Check status register pause & lpa register */
-	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
-	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
-	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
-	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
-	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
-	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
@@ -5015,16 +4995,11 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6390_g1_stu_getnext,
 	.stu_loadpurge = mv88e6390_g1_stu_loadpurge,
-	.serdes_power = mv88e6390_serdes_power,
+	.pcs_init = mv88e6390_pcs_init,
+	.pcs_teardown = mv88e639x_pcs_teardown,
+	.pcs_select = mv88e639x_pcs_select,
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
-	/* Check status register pause & lpa register */
-	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
-	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
-	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
-	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
-	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
-	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
@@ -5168,16 +5143,11 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6352_g1_stu_getnext,
 	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
-	.serdes_power = mv88e6390_serdes_power,
+	.pcs_init = mv88e6390_pcs_init,
+	.pcs_teardown = mv88e639x_pcs_teardown,
+	.pcs_select = mv88e639x_pcs_select,
 	.serdes_get_lane = mv88e6341_serdes_get_lane,
-	/* Check status register pause & lpa register */
-	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
-	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
-	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
-	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
-	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
-	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -5386,16 +5356,11 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6390_g1_stu_getnext,
 	.stu_loadpurge = mv88e6390_g1_stu_loadpurge,
-	.serdes_power = mv88e6390_serdes_power,
+	.pcs_init = mv88e6390_pcs_init,
+	.pcs_teardown = mv88e639x_pcs_teardown,
+	.pcs_select = mv88e639x_pcs_select,
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
-	/* Check status register pause & lpa register */
-	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
-	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
-	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
-	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
-	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
-	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -5453,15 +5418,11 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6390_g1_stu_getnext,
 	.stu_loadpurge = mv88e6390_g1_stu_loadpurge,
-	.serdes_power = mv88e6390_serdes_power,
+	.pcs_init = mv88e6390_pcs_init,
+	.pcs_teardown = mv88e639x_pcs_teardown,
+	.pcs_select = mv88e639x_pcs_select,
 	.serdes_get_lane = mv88e6390x_serdes_get_lane,
-	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
-	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
-	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
-	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
-	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
-	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
@@ -5475,7 +5436,6 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 
 static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	/* MV88E6XXX_FAMILY_6393 */
-	.setup_errata = mv88e6393x_serdes_setup_errata,
 	.irl_init_all = mv88e6390_g2_irl_init_all,
 	.get_eeprom = mv88e6xxx_g2_get_eeprom8,
 	.set_eeprom = mv88e6xxx_g2_set_eeprom8,
@@ -5523,15 +5483,11 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6390_g1_stu_getnext,
 	.stu_loadpurge = mv88e6390_g1_stu_loadpurge,
-	.serdes_power = mv88e6393x_serdes_power,
+	.pcs_init = mv88e6393x_pcs_init,
+	.pcs_teardown = mv88e639x_pcs_teardown,
+	.pcs_select = mv88e639x_pcs_select,
 	.serdes_get_lane = mv88e6393x_serdes_get_lane,
-	.serdes_pcs_get_state = mv88e6393x_serdes_pcs_get_state,
-	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
-	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
-	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
-	.serdes_irq_enable = mv88e6393x_serdes_irq_enable,
-	.serdes_irq_status = mv88e6393x_serdes_irq_status,
 	/* TODO: serdes stats */
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
diff --git a/drivers/net/dsa/mv88e6xxx/pcs-639x.c b/drivers/net/dsa/mv88e6xxx/pcs-639x.c
new file mode 100644
index 000000000000..6483bbdc1634
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/pcs-639x.c
@@ -0,0 +1,834 @@
+#include <linux/interrupt.h>
+#include <linux/irqdomain.h>
+#include <linux/mii.h>
+
+#include "chip.h"
+#include "global2.h"
+#include "phy.h"
+#include "port.h"
+#include "serdes.h"
+
+struct mv88e639x_pcs {
+	struct mdio_device mdio;
+	struct phylink_pcs sgmii_pcs;
+	struct phylink_pcs xg_pcs;
+	phy_interface_t interface;
+	unsigned int irq;
+	char name[64];
+	irqreturn_t (*handle_irq)(struct mv88e639x_pcs *mpcs);
+	struct mv88e6xxx_port *port;
+};
+
+static int mv88e639x_read(struct mv88e639x_pcs *mpcs, u16 regnum, u16 *val)
+{
+	u32 reg_c45 = mdiobus_c45_addr(MDIO_MMD_PHYXS, regnum);
+	int err;
+
+	err = mdiodev_read(&mpcs->mdio, reg_c45);
+	if (err < 0)
+		return err;
+
+	*val = err;
+
+	return 0;
+}
+
+static int mv88e639x_write(struct mv88e639x_pcs *mpcs, u16 regnum, u16 val)
+{
+	u32 reg_c45 = mdiobus_c45_addr(MDIO_MMD_PHYXS, regnum);
+
+	return mdiodev_write(&mpcs->mdio, reg_c45, val);
+}
+
+static int mv88e639x_modify(struct mv88e639x_pcs *mpcs, u16 regnum, u16 mask,
+			    u16 val)
+{
+	u32 reg_c45 = mdiobus_c45_addr(MDIO_MMD_PHYXS, regnum);
+
+	return mdiodev_modify(&mpcs->mdio, reg_c45, mask, val);
+}
+
+static int mv88e639x_modify_changed(struct mv88e639x_pcs *mpcs, u16 regnum,
+				    u16 mask, u16 set)
+{
+	u32 reg_c45 = mdiobus_c45_addr(MDIO_MMD_PHYXS, regnum);
+
+	return mdiodev_modify_changed(&mpcs->mdio, reg_c45, mask, set);
+}
+
+
+static struct mv88e639x_pcs *
+mv88e639x_pcs_alloc(struct device *dev, struct mii_bus *bus, unsigned int addr,
+		    int port)
+{
+	struct mv88e639x_pcs *mpcs;
+
+	mpcs = devm_kzalloc(dev, sizeof(*mpcs), GFP_KERNEL);
+	if (!mpcs)
+		return NULL;
+
+	/* we never initialise or register mpcs->mdio.dev with the
+	 * driver model, so devm_kzalloc() above is safe.
+	 */
+	mpcs->mdio.dev.parent = dev;
+	mpcs->mdio.bus = bus;
+	mpcs->mdio.addr = addr;
+
+	snprintf(mpcs->name, sizeof(mpcs->name),
+		 "mv88e6xxx-%s-serdes-%d", dev_name(dev), port);
+
+	return mpcs;
+}
+
+static irqreturn_t mv88e639x_pcs_handle_irq(int irq, void *dev_id)
+{
+	struct mv88e639x_pcs *mpcs = dev_id;
+	irqreturn_t (*handler)(struct mv88e639x_pcs *);
+
+	handler = READ_ONCE(mpcs->handle_irq);
+	if (!handler)
+		return IRQ_NONE;
+
+	return handler(mpcs);
+}
+
+static int mv88e639x_pcs_setup_irq(struct mv88e639x_pcs *mpcs,
+				   struct mv88e6xxx_chip *chip, int port)
+{
+	unsigned int irq;
+
+	irq = mv88e6xxx_serdes_irq_mapping(chip, port);
+	if (!irq) {
+		/* Use polling mode */
+		mpcs->sgmii_pcs.poll = true;
+		mpcs->xg_pcs.poll = true;
+		return 0;
+	}
+
+	mpcs->irq = irq;
+
+	return request_threaded_irq(irq, NULL, mv88e639x_pcs_handle_irq,
+				    IRQF_ONESHOT, mpcs->name, mpcs);
+}
+
+void mv88e639x_pcs_teardown(struct mv88e6xxx_chip *chip, int port)
+{
+	struct mv88e639x_pcs *mpcs = chip->ports[port].pcs_private;
+
+	if (mpcs && mpcs->irq)
+		free_irq(mpcs->irq, mpcs);
+}
+
+static void mv88e639x_pcs_link_change(struct mv88e639x_pcs *mpcs,
+				      bool link_down)
+{
+	struct mv88e6xxx_port *port = mpcs->port;
+
+	dsa_port_phylink_mac_change(port->chip->ds, port->port, !link_down);
+}
+
+static struct mv88e639x_pcs *sgmii_pcs_to_mv88e639x_pcs(struct phylink_pcs *pcs)
+{
+	return container_of(pcs, struct mv88e639x_pcs, sgmii_pcs);
+}
+
+static irqreturn_t mv88e639x_sgmii_handle_irq(struct mv88e639x_pcs *mpcs)
+{
+	u16 int_status;
+	bool link_down;
+	int err;
+
+	err = mv88e639x_read(mpcs, MV88E6390_SGMII_INT_STATUS, &int_status);
+	if (err)
+		return IRQ_NONE;
+
+	if (int_status & (MV88E6390_SGMII_INT_LINK_DOWN |
+			  MV88E6390_SGMII_INT_LINK_UP)) {
+		link_down = !!(int_status & MV88E6390_SGMII_INT_LINK_DOWN);
+
+		mv88e639x_pcs_link_change(mpcs, link_down);
+
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+static int mv88e639x_sgmii_pcs_control_irq(struct mv88e639x_pcs *mpcs,
+					   bool enable)
+{
+	u16 val = 0;
+
+	if (enable)
+		val |= MV88E6390_SGMII_INT_LINK_DOWN |
+		       MV88E6390_SGMII_INT_LINK_UP;
+
+	return mv88e639x_modify(mpcs, MV88E6390_SGMII_INT_ENABLE,
+				MV88E6390_SGMII_INT_LINK_DOWN |
+				MV88E6390_SGMII_INT_LINK_UP, val);
+}
+
+static int mv88e639x_sgmii_pcs_enable(struct phylink_pcs *pcs)
+{
+	struct mv88e639x_pcs *mpcs = sgmii_pcs_to_mv88e639x_pcs(pcs);
+	int err;
+
+	err = mv88e639x_modify(mpcs, MV88E6390_SGMII_BMCR,
+			       BMCR_RESET | BMCR_LOOPBACK | BMCR_PDOWN, 0);
+	if (err)
+		return err;
+
+	mpcs->handle_irq = mv88e639x_sgmii_handle_irq;
+
+	return mv88e639x_sgmii_pcs_control_irq(mpcs, !!mpcs->irq);
+}
+
+static void mv88e639x_sgmii_pcs_disable(struct phylink_pcs *pcs)
+{
+	struct mv88e639x_pcs *mpcs = sgmii_pcs_to_mv88e639x_pcs(pcs);
+
+	mv88e639x_sgmii_pcs_control_irq(mpcs, false);
+	mv88e639x_modify(mpcs, MV88E6390_SGMII_BMCR, BMCR_PDOWN, BMCR_PDOWN);
+}
+
+static void mv88e639x_sgmii_pcs_get_state(struct phylink_pcs *pcs,
+					  struct phylink_link_state *state)
+{
+	struct mv88e639x_pcs *mpcs = sgmii_pcs_to_mv88e639x_pcs(pcs);
+	u16 bmsr, lpa, status;
+	int err;
+
+	err = mv88e639x_read(mpcs, MV88E6390_SGMII_BMSR, &bmsr);
+	if (err) {
+		dev_err(mpcs->mdio.dev.parent,
+			"can't read Serdes PHY %s: %pe\n",
+			"BMSR", ERR_PTR(err));
+		state->link = false;
+		return;
+	}
+
+	err = mv88e639x_read(mpcs, MV88E6390_SGMII_LPA, &lpa);
+	if (err) {
+		dev_err(mpcs->mdio.dev.parent,
+			"can't read Serdes PHY %s: %pe\n",
+			"LPA", ERR_PTR(err));
+		state->link = false;
+		return;
+	}
+
+	err = mv88e639x_read(mpcs, MV88E6390_SGMII_PHY_STATUS, &status);
+	if (err) {
+		dev_err(mpcs->mdio.dev.parent,
+			"can't read Serdes PHY %s: %pe\n",
+			"status", ERR_PTR(err));
+		state->link = false;
+		return;
+	}
+
+	mv88e6xxx_pcs_decode_state(mpcs->mdio.dev.parent, bmsr, lpa, status,
+				   state);
+}
+
+static int mv88e639x_sgmii_pcs_config(struct phylink_pcs *pcs,
+				      unsigned int mode,
+				      phy_interface_t interface,
+				      const unsigned long *advertising,
+				      bool permit_pause_to_mac)
+{
+	struct mv88e639x_pcs *mpcs = sgmii_pcs_to_mv88e639x_pcs(pcs);
+	u16 val, bmcr;
+	bool changed;
+	int adv, err;
+
+	adv = phylink_mii_c22_pcs_encode_advertisement(interface, advertising);
+	if (adv < 0)
+		return 0;
+
+	mpcs->interface = interface;
+
+	err = mv88e639x_modify_changed(mpcs, MV88E6390_SGMII_ADVERTISE,
+				       0xffff, adv);
+	if (err < 0)
+		return err;
+
+	changed = err > 0;
+
+	err = mv88e639x_read(mpcs, MV88E6390_SGMII_BMCR, &val);
+	if (err)
+		return err;
+
+	if (phylink_autoneg_inband(mode))
+		bmcr = val | BMCR_ANENABLE;
+	else
+		bmcr = val & ~BMCR_ANENABLE;
+
+	/* setting ANENABLE triggers a restart of negotiation */
+	if (bmcr == val)
+		return changed;
+
+	return mv88e639x_write(mpcs, MV88E6390_SGMII_BMCR, bmcr);
+}
+
+static void mv88e639x_sgmii_pcs_an_restart(struct phylink_pcs *pcs)
+{
+	struct mv88e639x_pcs *mpcs = sgmii_pcs_to_mv88e639x_pcs(pcs);
+
+	mv88e639x_modify(mpcs, MV88E6390_SGMII_BMCR,
+			 BMCR_ANRESTART, BMCR_ANRESTART);
+}
+
+static void mv88e639x_sgmii_pcs_link_up(struct phylink_pcs *pcs,
+					unsigned int mode,
+					phy_interface_t interface,
+					int speed, int duplex)
+{
+	struct mv88e639x_pcs *mpcs = sgmii_pcs_to_mv88e639x_pcs(pcs);
+	u16 bmcr;
+	int err;
+
+	if (phylink_autoneg_inband(mode))
+		return;
+
+	bmcr = mv88e6xxx_encode_forced_bmcr(speed, duplex);
+
+	err = mv88e639x_modify(mpcs, MV88E6390_SGMII_BMCR,
+			       BMCR_SPEED1000 | BMCR_SPEED100 | BMCR_FULLDPLX,
+			       bmcr);
+	if (err)
+		dev_err(mpcs->mdio.dev.parent,
+			"can't access Serdes PHY %s: %pe\n",
+			"BMCR", ERR_PTR(err));
+}
+
+static const struct phylink_pcs_ops mv88e639x_sgmii_pcs_ops = {
+	.pcs_enable = mv88e639x_sgmii_pcs_enable,
+	.pcs_disable = mv88e639x_sgmii_pcs_disable,
+	.pcs_get_state = mv88e639x_sgmii_pcs_get_state,
+	.pcs_an_restart = mv88e639x_sgmii_pcs_an_restart,
+	.pcs_config = mv88e639x_sgmii_pcs_config,
+	.pcs_link_up = mv88e639x_sgmii_pcs_link_up,
+};
+
+static struct mv88e639x_pcs *xg_pcs_to_mv88e639x_pcs(struct phylink_pcs *pcs)
+{
+	return container_of(pcs, struct mv88e639x_pcs, xg_pcs);
+}
+
+static int mv88e639x_xg_pcs_enable(struct mv88e639x_pcs *mpcs)
+{
+	return mv88e639x_modify(mpcs, MV88E6390_10G_CTRL1,
+				MDIO_CTRL1_RESET | MDIO_PCS_CTRL1_LOOPBACK |
+				MDIO_CTRL1_LPOWER, 0);
+}
+
+static void mv88e639x_xg_pcs_disable(struct mv88e639x_pcs *mpcs)
+{
+	mv88e639x_modify(mpcs, MV88E6390_10G_CTRL1, MDIO_CTRL1_LPOWER,
+			 MDIO_CTRL1_LPOWER);
+}
+
+static void mv88e639x_xg_pcs_get_state(struct phylink_pcs *pcs,
+				      struct phylink_link_state *state)
+{
+	struct mv88e639x_pcs *mpcs = xg_pcs_to_mv88e639x_pcs(pcs);
+	u16 status;
+	int err;
+
+	state->link = false;
+
+	err = mv88e639x_read(mpcs, MV88E6390_10G_STAT1, &status);
+	if (err) {
+		dev_err(mpcs->mdio.dev.parent,
+			"can't read Serdes PHY %s: %pe\n",
+			"STAT1", ERR_PTR(err));
+		return;
+	}
+
+	state->link = !!(status & MDIO_STAT1_LSTATUS);
+	if (state->link) {
+		switch (state->interface) {
+		case PHY_INTERFACE_MODE_5GBASER:
+			state->speed = SPEED_5000;
+			break;
+
+		case PHY_INTERFACE_MODE_10GBASER:
+		case PHY_INTERFACE_MODE_RXAUI:
+		case PHY_INTERFACE_MODE_XAUI:
+			state->speed = SPEED_10000;
+			break;
+
+		default:
+			state->link = false;
+			return;
+		}
+
+		state->duplex = DUPLEX_FULL;
+	}
+}
+
+static int mv88e639x_xg_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+				  phy_interface_t interface,
+				  const unsigned long *advertising,
+				  bool permit_pause_to_mac)
+{
+	return 0;
+}
+
+struct phylink_pcs *mv88e639x_pcs_select(struct mv88e6xxx_chip *chip, int port,
+					 phy_interface_t mode)
+{
+	struct mv88e639x_pcs *mpcs;
+	struct mv88e6xxx_port *p;
+
+	p = &chip->ports[port];
+	mpcs = p->pcs_private;
+	if (!mpcs)
+		return NULL;
+
+	switch (mode) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		return &mpcs->sgmii_pcs;
+
+	case PHY_INTERFACE_MODE_10GBASER:
+	case PHY_INTERFACE_MODE_XAUI:
+	case PHY_INTERFACE_MODE_RXAUI:
+		return &mpcs->xg_pcs;
+
+	default:
+		return NULL;
+	}
+}
+
+
+/* Marvell 88E6390 Specific support */
+
+static irqreturn_t mv88e6390_xg_handle_irq(struct mv88e639x_pcs *mpcs)
+{
+	u16 int_status;
+	bool link_down;
+	int err;
+
+	err = mv88e639x_read(mpcs, MV88E6390_10G_INT_STATUS, &int_status);
+	if (err)
+		return IRQ_NONE;
+
+	if (int_status & (MV88E6390_10G_INT_LINK_DOWN |
+			  MV88E6390_10G_INT_LINK_UP)) {
+		link_down = !!(int_status & MV88E6390_10G_INT_LINK_DOWN);
+
+		mv88e639x_pcs_link_change(mpcs, link_down);
+
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+static int mv88e6390_xg_control_irq(struct mv88e639x_pcs *mpcs, bool enable)
+{
+	u16 val = 0;
+
+	if (enable)
+		val = MV88E6390_10G_INT_LINK_DOWN | MV88E6390_10G_INT_LINK_UP;
+
+	return mv88e639x_modify(mpcs, MV88E6390_10G_INT_ENABLE,
+				MV88E6390_10G_INT_LINK_DOWN |
+				MV88E6390_10G_INT_LINK_UP, val);
+}
+
+static int mv88e6390_xg_pcs_enable(struct phylink_pcs *pcs)
+{
+	struct mv88e639x_pcs *mpcs = xg_pcs_to_mv88e639x_pcs(pcs);
+	int err;
+
+	err = mv88e639x_xg_pcs_enable(mpcs);
+	if (err)
+		return err;
+
+	mpcs->handle_irq = mv88e6390_xg_handle_irq;
+
+	return mv88e6390_xg_control_irq(mpcs, !!mpcs->irq);
+}
+
+static void mv88e6390_xg_pcs_disable(struct phylink_pcs *pcs)
+{
+	struct mv88e639x_pcs *mpcs = xg_pcs_to_mv88e639x_pcs(pcs);
+
+	mv88e6390_xg_control_irq(mpcs, false);
+	mv88e639x_xg_pcs_disable(mpcs);
+}
+
+static const struct phylink_pcs_ops mv88e6390_xg_pcs_ops = {
+	.pcs_enable = mv88e6390_xg_pcs_enable,
+	.pcs_disable = mv88e6390_xg_pcs_disable,
+	.pcs_get_state = mv88e639x_xg_pcs_get_state,
+	.pcs_config = mv88e639x_xg_pcs_config,
+};
+
+static int mv88e6390_pcs_enable_checker(struct mv88e639x_pcs *mpcs)
+{
+	return mv88e639x_modify(mpcs, MV88E6390_PG_CONTROL,
+				MV88E6390_PG_CONTROL_ENABLE_PC,
+				MV88E6390_PG_CONTROL_ENABLE_PC);
+}
+
+int mv88e6390_pcs_init(struct mv88e6xxx_chip *chip, int port)
+{
+	struct mv88e639x_pcs *mpcs;
+	struct mii_bus *bus;
+	struct device *dev;
+	int lane, err;
+
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
+	if (lane < 0)
+		return 0;
+
+	bus = mv88e6xxx_default_mdio_bus(chip);
+	dev = chip->dev;
+
+	mpcs = mv88e639x_pcs_alloc(dev, bus, lane, port);
+	if (!mpcs)
+		return -ENOMEM;
+
+	mpcs->port = &chip->ports[port];
+	mpcs->sgmii_pcs.ops = &mv88e639x_sgmii_pcs_ops;
+	mpcs->xg_pcs.ops = &mv88e6390_xg_pcs_ops;
+
+	err = mv88e639x_pcs_setup_irq(mpcs, chip, port);
+	if (err)
+		return err;
+
+	/* 6390 and 6380x has the checker, 6393 doesn't appear to? */
+	/* This is to enable gathering the statistics. Maybe this
+	 * should call out to a helper? Or we could do this at init time.
+	 */
+	err = mv88e6390_pcs_enable_checker(mpcs);
+	if (err)
+		return err;
+
+	mpcs->port->pcs_private = mpcs;
+
+	return 0;
+}
+
+
+/* Marvell 88E6393X Specific support */
+
+static int mv88e6393x_power_up(struct mv88e639x_pcs *mpcs)
+{
+	return mv88e639x_modify(mpcs, MV88E6393X_SERDES_CTRL1,
+				MV88E6393X_SERDES_CTRL1_TX_PDOWN |
+				MV88E6393X_SERDES_CTRL1_RX_PDOWN, 0);
+}
+
+static int mv88e6393x_power_down(struct mv88e639x_pcs *mpcs)
+{
+	return mv88e639x_modify(mpcs, MV88E6393X_SERDES_CTRL1,
+				MV88E6393X_SERDES_CTRL1_TX_PDOWN |
+				MV88E6393X_SERDES_CTRL1_RX_PDOWN,
+				MV88E6393X_SERDES_CTRL1_TX_PDOWN |
+				MV88E6393X_SERDES_CTRL1_RX_PDOWN);
+}
+
+/* mv88e6393x family errata 4.6:
+ * Cannot clear PwrDn bit on SERDES if device is configured CPU_MGD mode or
+ * P0_mode is configured for [x]MII.
+ * Workaround: Set SERDES register 4.F002 bit 5=0 and bit 15=1.
+ *
+ * It seems that after this workaround the SERDES is automatically powered up
+ * (the bit is cleared), so power it down.
+ */
+static int mv88e6393x_erratum_4_6(struct mv88e639x_pcs *mpcs)
+{
+	int err;
+
+	err = mv88e639x_modify(mpcs, MV88E6393X_SERDES_POC,
+			       MV88E6393X_SERDES_POC_PDOWN |
+			       MV88E6393X_SERDES_POC_RESET,
+			       MV88E6393X_SERDES_POC_RESET);
+	if (err)
+		return err;
+
+	err = mv88e639x_modify(mpcs, MV88E6390_SGMII_BMCR,
+			       BMCR_PDOWN, BMCR_PDOWN);
+	if (err)
+		return err;
+
+	return mv88e6393x_power_down(mpcs);
+}
+
+/* mv88e6393x family errata 4.8:
+ * When a SERDES port is operating in 1000BASE-X or SGMII mode link may not
+ * come up after hardware reset or software reset of SERDES core. Workaround
+ * is to write SERDES register 4.F074.14=1 for only those modes and 0 in all
+ * other modes.
+ */
+static int mv88e6393x_erratum_4_8(struct mv88e639x_pcs *mpcs)
+{
+	u16 reg, poc;
+	int err;
+
+	err = mv88e639x_read(mpcs, MV88E6393X_SERDES_POC, &poc);
+	if (err)
+		return err;
+
+	poc &= MV88E6393X_SERDES_POC_PCS_MASK;
+	if (poc == MV88E6393X_SERDES_POC_PCS_1000BASEX ||
+	    poc == MV88E6393X_SERDES_POC_PCS_SGMII_PHY ||
+	    poc == MV88E6393X_SERDES_POC_PCS_SGMII_MAC)
+		reg = MV88E6393X_ERRATA_4_8_BIT;
+	else
+		reg = 0;
+
+	return mv88e639x_modify(mpcs, MV88E6393X_ERRATA_4_8_REG,
+				MV88E6393X_ERRATA_4_8_BIT, reg);
+}
+
+/* mv88e6393x family errata 5.2:
+ * For optimal signal integrity the following sequence should be applied to
+ * SERDES operating in 10G mode. These registers only apply to 10G operation
+ * and have no effect on other speeds.
+ */
+static int mv88e6393x_erratum_5_2(struct mv88e639x_pcs *mpcs)
+{
+	static const struct {
+		u16 dev, reg, val, mask;
+	} fixes[] = {
+		{ MDIO_MMD_VEND1, 0x8093, 0xcb5a, 0xffff },
+		{ MDIO_MMD_VEND1, 0x8171, 0x7088, 0xffff },
+		{ MDIO_MMD_VEND1, 0x80c9, 0x311a, 0xffff },
+		{ MDIO_MMD_VEND1, 0x80a2, 0x8000, 0xff7f },
+		{ MDIO_MMD_VEND1, 0x80a9, 0x0000, 0xfff0 },
+		{ MDIO_MMD_VEND1, 0x80a3, 0x0000, 0xf8ff },
+		{ MDIO_MMD_PHYXS, MV88E6393X_SERDES_POC,
+		  MV88E6393X_SERDES_POC_RESET, MV88E6393X_SERDES_POC_RESET },
+	};
+	int err, i;
+
+	for (i = 0; i < ARRAY_SIZE(fixes); ++i) {
+		u32 reg_c45 = mdiobus_c45_addr(fixes[i].dev, fixes[i].reg);
+
+		err = mdiodev_modify(&mpcs->mdio, reg_c45, fixes[i].mask,
+				     fixes[i].val);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+/* Inband AN is broken on Amethyst in 2500base-x mode when set by standard
+ * mechanism (via cmode).
+ * We can get around this by configuring the PCS mode to 1000base-x and then
+ * writing value 0x58 to register 1e.8000. (This must be done while SerDes
+ * receiver and transmitter are disabled, which is, when this function is
+ * called.)
+ * It seem that when we do this configuration to 2500base-x mode (by changing
+ * PCS mode to 1000base-x and frequency to 3.125 GHz from 1.25 GHz) and then
+ * configure to sgmii or 1000base-x, the device thinks that it already has
+ * SerDes at 1.25 GHz and does not change the 1e.8000 register, leaving SerDes
+ * at 3.125 GHz.
+ * To avoid this, change PCS mode back to 2500base-x when disabling SerDes from
+ * 2500base-x mode.
+ */
+static int mv88e6393x_fix_2500basex_an(struct mv88e639x_pcs *mpcs, bool on)
+{
+	u16 reg;
+	int err;
+
+	if (on)
+		reg = MV88E6393X_SERDES_POC_PCS_1000BASEX |
+		      MV88E6393X_SERDES_POC_AN;
+	else
+		reg = MV88E6393X_SERDES_POC_PCS_2500BASEX;
+
+	reg |= MV88E6393X_SERDES_POC_RESET;
+
+	err = mv88e639x_modify(mpcs, MV88E6393X_SERDES_POC,
+			       MV88E6393X_SERDES_POC_PCS_MASK |
+			       MV88E6393X_SERDES_POC_AN |
+			       MV88E6393X_SERDES_POC_RESET, reg);
+	if (err)
+		return err;
+
+	return mdiodev_write(&mpcs->mdio,
+			     mdiobus_c45_addr(MDIO_MMD_VEND1, 0x8000), 0x58);
+}
+
+static void mv88e6393x_sgmii_pcs_disable(struct phylink_pcs *pcs)
+{
+	struct mv88e639x_pcs *mpcs = xg_pcs_to_mv88e639x_pcs(pcs);
+	int err;
+
+	mv88e6393x_power_down(mpcs);
+
+	if (mpcs->interface == PHY_INTERFACE_MODE_2500BASEX) {
+		err = mv88e6393x_fix_2500basex_an(mpcs, false);
+		if (err)
+			dev_err(mpcs->mdio.dev.parent,
+				"failed to disable 2500basex fix: %pe\n",
+				ERR_PTR(err));
+	}
+}
+
+static void mv88e6393x_sgmii_pcs_pre_config(struct phylink_pcs *pcs,
+					    phy_interface_t interface)
+{
+	mv88e6393x_sgmii_pcs_disable(pcs);
+}
+
+static int mv88e6393x_sgmii_pcs_post_config(struct phylink_pcs *pcs,
+					     phy_interface_t interface)
+{
+	struct mv88e639x_pcs *mpcs = xg_pcs_to_mv88e639x_pcs(pcs);
+	int err;
+
+	err = mv88e6393x_erratum_4_8(mpcs);
+	if (err)
+		return err;
+
+	if (interface == PHY_INTERFACE_MODE_2500BASEX) {
+		err = mv88e6393x_fix_2500basex_an(mpcs, true);
+		if (err)
+			return err;
+	}
+
+	return mv88e6393x_power_up(mpcs);
+}
+
+static const struct phylink_pcs_ops mv88e6393x_sgmii_pcs_ops = {
+	.pcs_disable = mv88e6393x_sgmii_pcs_disable,
+	.pcs_pre_config = mv88e6393x_sgmii_pcs_pre_config,
+	.pcs_post_config = mv88e6393x_sgmii_pcs_post_config,
+	.pcs_get_state = mv88e639x_sgmii_pcs_get_state,
+	.pcs_an_restart = mv88e639x_sgmii_pcs_an_restart,
+	.pcs_config = mv88e639x_sgmii_pcs_config,
+	.pcs_link_up = mv88e639x_sgmii_pcs_link_up,
+};
+
+static irqreturn_t mv88e6393x_xg_handle_irq(struct mv88e639x_pcs *mpcs)
+{
+	u16 int_status, stat1;
+	bool link_down;
+	int err;
+
+	err = mv88e639x_read(mpcs, MV88E6393X_10G_INT_STATUS, &int_status);
+	if (err)
+		return IRQ_NONE;
+
+	if (int_status & MV88E6393X_10G_INT_LINK_CHANGE) {
+		err = mv88e639x_read(mpcs, MV88E6390_10G_STAT1, &stat1);
+		if (err)
+			return IRQ_NONE;
+
+		link_down = !(stat1 & MDIO_STAT1_LSTATUS);
+
+		mv88e639x_pcs_link_change(mpcs, link_down);
+
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+static int mv88e6393x_xg_control_irq(struct mv88e639x_pcs *mpcs, bool enable)
+{
+	u16 val = 0;
+
+	if (enable)
+		val = MV88E6393X_10G_INT_LINK_CHANGE;
+
+	return mv88e639x_modify(mpcs, MV88E6393X_10G_INT_ENABLE,
+				MV88E6393X_10G_INT_LINK_CHANGE, val);
+}
+
+static int mv88e6393x_xg_pcs_enable(struct phylink_pcs *pcs)
+{
+	struct mv88e639x_pcs *mpcs = xg_pcs_to_mv88e639x_pcs(pcs);
+
+	mpcs->handle_irq = mv88e6393x_xg_handle_irq;
+
+	return mv88e6393x_xg_control_irq(mpcs, !!mpcs->irq);
+}
+
+static void mv88e6393x_xg_pcs_disable(struct phylink_pcs *pcs)
+{
+	struct mv88e639x_pcs *mpcs = xg_pcs_to_mv88e639x_pcs(pcs);
+
+	mv88e6393x_xg_control_irq(mpcs, false);
+	mv88e6393x_power_down(mpcs);
+}
+
+/* The PCS has to be powered down while CMODE is changed */
+static void mv88e6393x_xg_pcs_pre_config(struct phylink_pcs *pcs,
+					 phy_interface_t interface)
+{
+	struct mv88e639x_pcs *mpcs = xg_pcs_to_mv88e639x_pcs(pcs);
+
+	mv88e6393x_power_down(mpcs);
+}
+
+static int mv88e6393x_xg_pcs_post_config(struct phylink_pcs *pcs,
+					 phy_interface_t interface)
+{
+	struct mv88e639x_pcs *mpcs = xg_pcs_to_mv88e639x_pcs(pcs);
+	int err;
+
+	err = mv88e6393x_erratum_4_8(mpcs);
+	if (err)
+		return err;
+
+	if (interface == PHY_INTERFACE_MODE_10GBASER) {
+		err = mv88e6393x_erratum_5_2(mpcs);
+		if (err)
+			return err;
+	}
+
+	return mv88e6393x_power_up(mpcs);
+}
+
+static const struct phylink_pcs_ops mv88e6393x_xg_pcs_ops = {
+	.pcs_enable = mv88e6393x_xg_pcs_enable,
+	.pcs_disable = mv88e6393x_xg_pcs_disable,
+	.pcs_pre_config = mv88e6393x_xg_pcs_pre_config,
+	.pcs_post_config = mv88e6393x_xg_pcs_post_config,
+	.pcs_get_state = mv88e639x_xg_pcs_get_state,
+	.pcs_config = mv88e639x_xg_pcs_config,
+};
+
+int mv88e6393x_pcs_init(struct mv88e6xxx_chip *chip, int port)
+{
+	struct mv88e639x_pcs *mpcs;
+	struct mii_bus *bus;
+	struct device *dev;
+	int lane, err;
+
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
+	if (lane < 0)
+		return 0;
+
+	bus = mv88e6xxx_default_mdio_bus(chip);
+	dev = chip->dev;
+
+	mpcs = mv88e639x_pcs_alloc(dev, bus, lane, port);
+	if (!mpcs)
+		return -ENOMEM;
+
+	mpcs->port = &chip->ports[port];
+	mpcs->sgmii_pcs.ops = &mv88e6393x_sgmii_pcs_ops;
+	mpcs->xg_pcs.ops = &mv88e6393x_xg_pcs_ops;
+
+	err = mv88e6393x_erratum_4_6(mpcs);
+	if (err)
+		return err;
+
+	err = mv88e639x_pcs_setup_irq(mpcs, chip, port);
+	if (err)
+		return err;
+
+	mpcs->port->pcs_private = mpcs;
+
+	return 0;
+}
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index fea71117d631..29f0c08b9649 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -41,19 +41,12 @@ static int mv88e6390_serdes_read(struct mv88e6xxx_chip *chip,
 	return mv88e6xxx_phy_read(chip, lane, reg_c45, val);
 }
 
-static int mv88e6390_serdes_write(struct mv88e6xxx_chip *chip,
-				  int lane, int device, int reg, u16 val)
-{
-	int reg_c45 = MII_ADDR_C45 | device << 16 | reg;
-
-	return mv88e6xxx_phy_write(chip, lane, reg_c45, val);
-}
-
 u16 mv88e6xxx_encode_forced_bmcr(int speed, int duplex)
 {
 	u16 bmcr;
 
 	switch (speed) {
+	case SPEED_2500:
 	case SPEED_1000:
 		bmcr = BMCR_SPEED1000;
 		break;
@@ -407,57 +400,6 @@ int mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 	return lane;
 }
 
-/* Set power up/down for 10GBASE-R and 10GBASE-X4/X2 */
-static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, int lane,
-				      bool up)
-{
-	u16 val, new_val;
-	int err;
-
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_10G_CTRL1, &val);
-
-	if (err)
-		return err;
-
-	if (up)
-		new_val = val & ~(MDIO_CTRL1_RESET |
-				  MDIO_PCS_CTRL1_LOOPBACK |
-				  MDIO_CTRL1_LPOWER);
-	else
-		new_val = val | MDIO_CTRL1_LPOWER;
-
-	if (val != new_val)
-		err = mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-					     MV88E6390_10G_CTRL1, new_val);
-
-	return err;
-}
-
-/* Set power up/down for SGMII and 1000Base-X */
-static int mv88e6390_serdes_power_sgmii(struct mv88e6xxx_chip *chip, int lane,
-					bool up)
-{
-	u16 val, new_val;
-	int err;
-
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_SGMII_BMCR, &val);
-	if (err)
-		return err;
-
-	if (up)
-		new_val = val & ~(BMCR_RESET | BMCR_LOOPBACK | BMCR_PDOWN);
-	else
-		new_val = val | BMCR_PDOWN;
-
-	if (val != new_val)
-		err = mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-					     MV88E6390_SGMII_BMCR, new_val);
-
-	return err;
-}
-
 struct mv88e6390_serdes_hw_stat {
 	char string[ETH_GSTRING_LEN];
 	int reg;
@@ -531,444 +473,6 @@ int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 	return ARRAY_SIZE(mv88e6390_serdes_hw_stats);
 }
 
-static int mv88e6390_serdes_enable_checker(struct mv88e6xxx_chip *chip, int lane)
-{
-	u16 reg;
-	int err;
-
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_PG_CONTROL, &reg);
-	if (err)
-		return err;
-
-	reg |= MV88E6390_PG_CONTROL_ENABLE_PC;
-	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-				      MV88E6390_PG_CONTROL, reg);
-}
-
-int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
-			   bool up)
-{
-	u8 cmode = chip->ports[port].cmode;
-	int err;
-
-	switch (cmode) {
-	case MV88E6XXX_PORT_STS_CMODE_SGMII:
-	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
-	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
-		err = mv88e6390_serdes_power_sgmii(chip, lane, up);
-		break;
-	case MV88E6XXX_PORT_STS_CMODE_XAUI:
-	case MV88E6XXX_PORT_STS_CMODE_RXAUI:
-		err = mv88e6390_serdes_power_10g(chip, lane, up);
-		break;
-	default:
-		err = -EINVAL;
-		break;
-	}
-
-	if (!err && up)
-		err = mv88e6390_serdes_enable_checker(chip, lane);
-
-	return err;
-}
-
-int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
-				int lane, unsigned int mode,
-				phy_interface_t interface,
-				const unsigned long *advertise)
-{
-	u16 val, bmcr, adv;
-	bool changed;
-	int err;
-
-	switch (interface) {
-	case PHY_INTERFACE_MODE_SGMII:
-		adv = 0x0001;
-		break;
-
-	case PHY_INTERFACE_MODE_1000BASEX:
-		adv = linkmode_adv_to_mii_adv_x(advertise,
-					ETHTOOL_LINK_MODE_1000baseX_Full_BIT);
-		break;
-
-	case PHY_INTERFACE_MODE_2500BASEX:
-		adv = linkmode_adv_to_mii_adv_x(advertise,
-					ETHTOOL_LINK_MODE_2500baseX_Full_BIT);
-		break;
-
-	default:
-		return 0;
-	}
-
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_SGMII_ADVERTISE, &val);
-	if (err)
-		return err;
-
-	changed = val != adv;
-	if (changed) {
-		err = mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-					     MV88E6390_SGMII_ADVERTISE, adv);
-		if (err)
-			return err;
-	}
-
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_SGMII_BMCR, &val);
-	if (err)
-		return err;
-
-	if (phylink_autoneg_inband(mode))
-		bmcr = val | BMCR_ANENABLE;
-	else
-		bmcr = val & ~BMCR_ANENABLE;
-
-	/* setting ANENABLE triggers a restart of negotiation */
-	if (bmcr == val)
-		return changed;
-
-	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-				      MV88E6390_SGMII_BMCR, bmcr);
-}
-
-static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
-	int port, int lane, struct phylink_link_state *state)
-{
-	u16 bmsr, lpa, status;
-	int err;
-
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_SGMII_BMSR, &bmsr);
-	if (err) {
-		dev_err(chip->dev, "can't read Serdes PHY BMSR: %d\n", err);
-		return err;
-	}
-
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_SGMII_PHY_STATUS, &status);
-	if (err) {
-		dev_err(chip->dev, "can't read Serdes PHY status: %d\n", err);
-		return err;
-	}
-
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_SGMII_LPA, &lpa);
-	if (err) {
-		dev_err(chip->dev, "can't read Serdes PHY LPA: %d\n", err);
-		return err;
-	}
-
-	return mv88e6xxx_pcs_decode_state(chip->dev, bmsr, lpa, status, state);
-}
-
-static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
-	int port, int lane, struct phylink_link_state *state)
-{
-	u16 status;
-	int err;
-
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_10G_STAT1, &status);
-	if (err)
-		return err;
-
-	state->link = !!(status & MDIO_STAT1_LSTATUS);
-	if (state->link) {
-		state->speed = SPEED_10000;
-		state->duplex = DUPLEX_FULL;
-	}
-
-	return 0;
-}
-
-static int mv88e6393x_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
-					       int port, int lane,
-					       struct phylink_link_state *state)
-{
-	u16 status;
-	int err;
-
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_10G_STAT1, &status);
-	if (err)
-		return err;
-
-	state->link = !!(status & MDIO_STAT1_LSTATUS);
-	if (state->link) {
-		if (state->interface == PHY_INTERFACE_MODE_5GBASER)
-			state->speed = SPEED_5000;
-		else
-			state->speed = SPEED_10000;
-		state->duplex = DUPLEX_FULL;
-	}
-
-	return 0;
-}
-
-int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
-				   int lane, struct phylink_link_state *state)
-{
-	switch (state->interface) {
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_1000BASEX:
-	case PHY_INTERFACE_MODE_2500BASEX:
-		return mv88e6390_serdes_pcs_get_state_sgmii(chip, port, lane,
-							    state);
-	case PHY_INTERFACE_MODE_XAUI:
-	case PHY_INTERFACE_MODE_RXAUI:
-		return mv88e6390_serdes_pcs_get_state_10g(chip, port, lane,
-							  state);
-
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-int mv88e6393x_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
-				    int lane, struct phylink_link_state *state)
-{
-	switch (state->interface) {
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_1000BASEX:
-	case PHY_INTERFACE_MODE_2500BASEX:
-		return mv88e6390_serdes_pcs_get_state_sgmii(chip, port, lane,
-							    state);
-	case PHY_INTERFACE_MODE_5GBASER:
-	case PHY_INTERFACE_MODE_10GBASER:
-		return mv88e6393x_serdes_pcs_get_state_10g(chip, port, lane,
-							   state);
-
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-int mv88e6390_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
-				    int lane)
-{
-	u16 bmcr;
-	int err;
-
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_SGMII_BMCR, &bmcr);
-	if (err)
-		return err;
-
-	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-				      MV88E6390_SGMII_BMCR,
-				      bmcr | BMCR_ANRESTART);
-}
-
-int mv88e6390_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
-				 int lane, int speed, int duplex)
-{
-	u16 val, bmcr;
-	int err;
-
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_SGMII_BMCR, &val);
-	if (err)
-		return err;
-
-	bmcr = val & ~(BMCR_SPEED100 | BMCR_FULLDPLX | BMCR_SPEED1000);
-	switch (speed) {
-	case SPEED_2500:
-	case SPEED_1000:
-		bmcr |= BMCR_SPEED1000;
-		break;
-	case SPEED_100:
-		bmcr |= BMCR_SPEED100;
-		break;
-	case SPEED_10:
-		break;
-	}
-
-	if (duplex == DUPLEX_FULL)
-		bmcr |= BMCR_FULLDPLX;
-
-	if (bmcr == val)
-		return 0;
-
-	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-				      MV88E6390_SGMII_BMCR, bmcr);
-}
-
-static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
-					    int port, int lane)
-{
-	u16 bmsr;
-	int err;
-
-	/* If the link has dropped, we want to know about it. */
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_SGMII_BMSR, &bmsr);
-	if (err) {
-		dev_err(chip->dev, "can't read Serdes BMSR: %d\n", err);
-		return;
-	}
-
-	dsa_port_phylink_mac_change(chip->ds, port, !!(bmsr & BMSR_LSTATUS));
-}
-
-static void mv88e6393x_serdes_irq_link_10g(struct mv88e6xxx_chip *chip,
-					   int port, u8 lane)
-{
-	u16 status;
-	int err;
-
-	/* If the link has dropped, we want to know about it. */
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_10G_STAT1, &status);
-	if (err) {
-		dev_err(chip->dev, "can't read Serdes STAT1: %d\n", err);
-		return;
-	}
-
-	dsa_port_phylink_mac_change(chip->ds, port, !!(status & MDIO_STAT1_LSTATUS));
-}
-
-static int mv88e6390_serdes_irq_enable_sgmii(struct mv88e6xxx_chip *chip,
-					     int lane, bool enable)
-{
-	u16 val = 0;
-
-	if (enable)
-		val |= MV88E6390_SGMII_INT_LINK_DOWN |
-			MV88E6390_SGMII_INT_LINK_UP;
-
-	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-				      MV88E6390_SGMII_INT_ENABLE, val);
-}
-
-int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
-				bool enable)
-{
-	u8 cmode = chip->ports[port].cmode;
-
-	switch (cmode) {
-	case MV88E6XXX_PORT_STS_CMODE_SGMII:
-	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
-	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
-		return mv88e6390_serdes_irq_enable_sgmii(chip, lane, enable);
-	}
-
-	return 0;
-}
-
-static int mv88e6390_serdes_irq_status_sgmii(struct mv88e6xxx_chip *chip,
-					     int lane, u16 *status)
-{
-	int err;
-
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_SGMII_INT_STATUS, status);
-
-	return err;
-}
-
-static int mv88e6393x_serdes_irq_enable_10g(struct mv88e6xxx_chip *chip,
-					    u8 lane, bool enable)
-{
-	u16 val = 0;
-
-	if (enable)
-		val |= MV88E6393X_10G_INT_LINK_CHANGE;
-
-	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-				      MV88E6393X_10G_INT_ENABLE, val);
-}
-
-int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
-				 int lane, bool enable)
-{
-	u8 cmode = chip->ports[port].cmode;
-
-	switch (cmode) {
-	case MV88E6XXX_PORT_STS_CMODE_SGMII:
-	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
-	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
-		return mv88e6390_serdes_irq_enable_sgmii(chip, lane, enable);
-	case MV88E6393X_PORT_STS_CMODE_5GBASER:
-	case MV88E6393X_PORT_STS_CMODE_10GBASER:
-		return mv88e6393x_serdes_irq_enable_10g(chip, lane, enable);
-	}
-
-	return 0;
-}
-
-static int mv88e6393x_serdes_irq_status_10g(struct mv88e6xxx_chip *chip,
-					    u8 lane, u16 *status)
-{
-	int err;
-
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6393X_10G_INT_STATUS, status);
-
-	return err;
-}
-
-irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
-					 int lane)
-{
-	u8 cmode = chip->ports[port].cmode;
-	irqreturn_t ret = IRQ_NONE;
-	u16 status;
-	int err;
-
-	switch (cmode) {
-	case MV88E6XXX_PORT_STS_CMODE_SGMII:
-	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
-	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
-		err = mv88e6390_serdes_irq_status_sgmii(chip, lane, &status);
-		if (err)
-			return ret;
-		if (status & (MV88E6390_SGMII_INT_LINK_DOWN |
-			      MV88E6390_SGMII_INT_LINK_UP)) {
-			ret = IRQ_HANDLED;
-			mv88e6390_serdes_irq_link_sgmii(chip, port, lane);
-		}
-		break;
-	case MV88E6393X_PORT_STS_CMODE_5GBASER:
-	case MV88E6393X_PORT_STS_CMODE_10GBASER:
-		err = mv88e6393x_serdes_irq_status_10g(chip, lane, &status);
-		if (err)
-			return err;
-		if (status & MV88E6393X_10G_INT_LINK_CHANGE) {
-			ret = IRQ_HANDLED;
-			mv88e6393x_serdes_irq_link_10g(chip, port, lane);
-		}
-		break;
-	}
-
-	return ret;
-}
-
-irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
-					int lane)
-{
-	u8 cmode = chip->ports[port].cmode;
-	irqreturn_t ret = IRQ_NONE;
-	u16 status;
-	int err;
-
-	switch (cmode) {
-	case MV88E6XXX_PORT_STS_CMODE_SGMII:
-	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
-	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
-		err = mv88e6390_serdes_irq_status_sgmii(chip, lane, &status);
-		if (err)
-			return ret;
-		if (status & (MV88E6390_SGMII_INT_LINK_DOWN |
-			      MV88E6390_SGMII_INT_LINK_UP)) {
-			ret = IRQ_HANDLED;
-			mv88e6390_serdes_irq_link_sgmii(chip, port, lane);
-		}
-	}
-
-	return ret;
-}
-
 unsigned int mv88e6390_serdes_irq_mapping(struct mv88e6xxx_chip *chip, int port)
 {
 	return irq_find_mapping(chip->g2_irq.domain, port);
@@ -1067,257 +571,3 @@ int mv88e6352_serdes_set_tx_amplitude(struct mv88e6xxx_chip *chip, int port,
 
 	return mv88e6352_serdes_write(chip, MV88E6352_SERDES_SPEC_CTRL2, ctrl);
 }
-
-static int mv88e6393x_serdes_power_lane(struct mv88e6xxx_chip *chip, int lane,
-					bool on)
-{
-	u16 reg;
-	int err;
-
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6393X_SERDES_CTRL1, &reg);
-	if (err)
-		return err;
-
-	if (on)
-		reg &= ~(MV88E6393X_SERDES_CTRL1_TX_PDOWN |
-			 MV88E6393X_SERDES_CTRL1_RX_PDOWN);
-	else
-		reg |= MV88E6393X_SERDES_CTRL1_TX_PDOWN |
-		       MV88E6393X_SERDES_CTRL1_RX_PDOWN;
-
-	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-				      MV88E6393X_SERDES_CTRL1, reg);
-}
-
-static int mv88e6393x_serdes_erratum_4_6(struct mv88e6xxx_chip *chip, int lane)
-{
-	u16 reg;
-	int err;
-
-	/* mv88e6393x family errata 4.6:
-	 * Cannot clear PwrDn bit on SERDES if device is configured CPU_MGD
-	 * mode or P0_mode is configured for [x]MII.
-	 * Workaround: Set SERDES register 4.F002 bit 5=0 and bit 15=1.
-	 *
-	 * It seems that after this workaround the SERDES is automatically
-	 * powered up (the bit is cleared), so power it down.
-	 */
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6393X_SERDES_POC, &reg);
-	if (err)
-		return err;
-
-	reg &= ~MV88E6393X_SERDES_POC_PDOWN;
-	reg |= MV88E6393X_SERDES_POC_RESET;
-
-	err = mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-				     MV88E6393X_SERDES_POC, reg);
-	if (err)
-		return err;
-
-	err = mv88e6390_serdes_power_sgmii(chip, lane, false);
-	if (err)
-		return err;
-
-	return mv88e6393x_serdes_power_lane(chip, lane, false);
-}
-
-int mv88e6393x_serdes_setup_errata(struct mv88e6xxx_chip *chip)
-{
-	int err;
-
-	err = mv88e6393x_serdes_erratum_4_6(chip, MV88E6393X_PORT0_LANE);
-	if (err)
-		return err;
-
-	err = mv88e6393x_serdes_erratum_4_6(chip, MV88E6393X_PORT9_LANE);
-	if (err)
-		return err;
-
-	return mv88e6393x_serdes_erratum_4_6(chip, MV88E6393X_PORT10_LANE);
-}
-
-static int mv88e6393x_serdes_erratum_4_8(struct mv88e6xxx_chip *chip, int lane)
-{
-	u16 reg, pcs;
-	int err;
-
-	/* mv88e6393x family errata 4.8:
-	 * When a SERDES port is operating in 1000BASE-X or SGMII mode link may
-	 * not come up after hardware reset or software reset of SERDES core.
-	 * Workaround is to write SERDES register 4.F074.14=1 for only those
-	 * modes and 0 in all other modes.
-	 */
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6393X_SERDES_POC, &pcs);
-	if (err)
-		return err;
-
-	pcs &= MV88E6393X_SERDES_POC_PCS_MASK;
-
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6393X_ERRATA_4_8_REG, &reg);
-	if (err)
-		return err;
-
-	if (pcs == MV88E6393X_SERDES_POC_PCS_1000BASEX ||
-	    pcs == MV88E6393X_SERDES_POC_PCS_SGMII_PHY ||
-	    pcs == MV88E6393X_SERDES_POC_PCS_SGMII_MAC)
-		reg |= MV88E6393X_ERRATA_4_8_BIT;
-	else
-		reg &= ~MV88E6393X_ERRATA_4_8_BIT;
-
-	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-				      MV88E6393X_ERRATA_4_8_REG, reg);
-}
-
-static int mv88e6393x_serdes_erratum_5_2(struct mv88e6xxx_chip *chip, int lane,
-					 u8 cmode)
-{
-	static const struct {
-		u16 dev, reg, val, mask;
-	} fixes[] = {
-		{ MDIO_MMD_VEND1, 0x8093, 0xcb5a, 0xffff },
-		{ MDIO_MMD_VEND1, 0x8171, 0x7088, 0xffff },
-		{ MDIO_MMD_VEND1, 0x80c9, 0x311a, 0xffff },
-		{ MDIO_MMD_VEND1, 0x80a2, 0x8000, 0xff7f },
-		{ MDIO_MMD_VEND1, 0x80a9, 0x0000, 0xfff0 },
-		{ MDIO_MMD_VEND1, 0x80a3, 0x0000, 0xf8ff },
-		{ MDIO_MMD_PHYXS, MV88E6393X_SERDES_POC,
-		  MV88E6393X_SERDES_POC_RESET, MV88E6393X_SERDES_POC_RESET },
-	};
-	int err, i;
-	u16 reg;
-
-	/* mv88e6393x family errata 5.2:
-	 * For optimal signal integrity the following sequence should be applied
-	 * to SERDES operating in 10G mode. These registers only apply to 10G
-	 * operation and have no effect on other speeds.
-	 */
-	if (cmode != MV88E6393X_PORT_STS_CMODE_10GBASER)
-		return 0;
-
-	for (i = 0; i < ARRAY_SIZE(fixes); ++i) {
-		err = mv88e6390_serdes_read(chip, lane, fixes[i].dev,
-					    fixes[i].reg, &reg);
-		if (err)
-			return err;
-
-		reg &= ~fixes[i].mask;
-		reg |= fixes[i].val;
-
-		err = mv88e6390_serdes_write(chip, lane, fixes[i].dev,
-					     fixes[i].reg, reg);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
-static int mv88e6393x_serdes_fix_2500basex_an(struct mv88e6xxx_chip *chip,
-					      int lane, u8 cmode, bool on)
-{
-	u16 reg;
-	int err;
-
-	if (cmode != MV88E6XXX_PORT_STS_CMODE_2500BASEX)
-		return 0;
-
-	/* Inband AN is broken on Amethyst in 2500base-x mode when set by
-	 * standard mechanism (via cmode).
-	 * We can get around this by configuring the PCS mode to 1000base-x
-	 * and then writing value 0x58 to register 1e.8000. (This must be done
-	 * while SerDes receiver and transmitter are disabled, which is, when
-	 * this function is called.)
-	 * It seem that when we do this configuration to 2500base-x mode (by
-	 * changing PCS mode to 1000base-x and frequency to 3.125 GHz from
-	 * 1.25 GHz) and then configure to sgmii or 1000base-x, the device
-	 * thinks that it already has SerDes at 1.25 GHz and does not change
-	 * the 1e.8000 register, leaving SerDes at 3.125 GHz.
-	 * To avoid this, change PCS mode back to 2500base-x when disabling
-	 * SerDes from 2500base-x mode.
-	 */
-	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6393X_SERDES_POC, &reg);
-	if (err)
-		return err;
-
-	reg &= ~(MV88E6393X_SERDES_POC_PCS_MASK | MV88E6393X_SERDES_POC_AN);
-	if (on)
-		reg |= MV88E6393X_SERDES_POC_PCS_1000BASEX |
-		       MV88E6393X_SERDES_POC_AN;
-	else
-		reg |= MV88E6393X_SERDES_POC_PCS_2500BASEX;
-	reg |= MV88E6393X_SERDES_POC_RESET;
-
-	err = mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-				     MV88E6393X_SERDES_POC, reg);
-	if (err)
-		return err;
-
-	err = mv88e6390_serdes_write(chip, lane, MDIO_MMD_VEND1, 0x8000, 0x58);
-	if (err)
-		return err;
-
-	return 0;
-}
-
-int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
-			    bool on)
-{
-	u8 cmode = chip->ports[port].cmode;
-	int err;
-
-	if (port != 0 && port != 9 && port != 10)
-		return -EOPNOTSUPP;
-
-	if (on) {
-		err = mv88e6393x_serdes_erratum_4_8(chip, lane);
-		if (err)
-			return err;
-
-		err = mv88e6393x_serdes_erratum_5_2(chip, lane, cmode);
-		if (err)
-			return err;
-
-		err = mv88e6393x_serdes_fix_2500basex_an(chip, lane, cmode,
-							 true);
-		if (err)
-			return err;
-
-		err = mv88e6393x_serdes_power_lane(chip, lane, true);
-		if (err)
-			return err;
-	}
-
-	switch (cmode) {
-	case MV88E6XXX_PORT_STS_CMODE_SGMII:
-	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
-	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
-		err = mv88e6390_serdes_power_sgmii(chip, lane, on);
-		break;
-	case MV88E6393X_PORT_STS_CMODE_5GBASER:
-	case MV88E6393X_PORT_STS_CMODE_10GBASER:
-		err = mv88e6390_serdes_power_10g(chip, lane, on);
-		break;
-	default:
-		err = -EINVAL;
-		break;
-	}
-
-	if (err)
-		return err;
-
-	if (!on) {
-		err = mv88e6393x_serdes_power_lane(chip, lane, false);
-		if (err)
-			return err;
-
-		err = mv88e6393x_serdes_fix_2500basex_an(chip, lane, cmode,
-							 false);
-	}
-
-	return err;
-}
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 9199ca23d792..d29d4d10a16d 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -46,6 +46,10 @@ struct phylink_link_state;
 /* 10GBASE-R and 10GBASE-X4/X2 */
 #define MV88E6390_10G_CTRL1		(0x1000 + MDIO_CTRL1)
 #define MV88E6390_10G_STAT1		(0x1000 + MDIO_STAT1)
+#define MV88E6390_10G_INT_ENABLE	0x9001
+#define MV88E6390_10G_INT_LINK_DOWN	BIT(3)
+#define MV88E6390_10G_INT_LINK_UP	BIT(2)
+#define MV88E6390_10G_INT_STATUS	0x9003
 #define MV88E6393X_10G_INT_ENABLE	0x9000
 #define MV88E6393X_10G_INT_LINK_CHANGE	BIT(2)
 #define MV88E6393X_10G_INT_STATUS	0x9001
@@ -113,35 +117,10 @@ int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
-int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
-				int lane, unsigned int mode,
-				phy_interface_t interface,
-				const unsigned long *advertise);
-int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
-				   int lane, struct phylink_link_state *state);
-int mv88e6393x_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
-				    int lane, struct phylink_link_state *state);
-int mv88e6390_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
-				    int lane);
-int mv88e6390_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
-				 int lane, int speed, int duplex);
 unsigned int mv88e6352_serdes_irq_mapping(struct mv88e6xxx_chip *chip,
 					  int port);
 unsigned int mv88e6390_serdes_irq_mapping(struct mv88e6xxx_chip *chip,
 					  int port);
-int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
-			   bool on);
-int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
-			    bool on);
-int mv88e6393x_serdes_setup_errata(struct mv88e6xxx_chip *chip);
-int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
-				bool enable);
-int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
-				 int lane, bool enable);
-irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
-					int lane);
-irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
-					 int lane);
 int mv88e6352_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_get_strings(struct mv88e6xxx_chip *chip,
 				 int port, uint8_t *data);
@@ -230,4 +209,11 @@ int mv88e6185_pcs_init(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_pcs_init(struct mv88e6xxx_chip *chip, int port);
 void mv88e6352_pcs_teardown(struct mv88e6xxx_chip *chip, int port);
 
+int mv88e6390_pcs_init(struct mv88e6xxx_chip *chip, int port);
+int mv88e6393x_pcs_init(struct mv88e6xxx_chip *chip, int port);
+void mv88e639x_pcs_teardown(struct mv88e6xxx_chip *chip, int port);
+
+struct phylink_pcs *mv88e639x_pcs_select(struct mv88e6xxx_chip *chip, int port,
+					 phy_interface_t mode);
+
 #endif
-- 
2.30.2

