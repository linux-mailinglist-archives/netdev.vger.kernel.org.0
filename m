Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F8A552045
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244783AbiFTPOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241912AbiFTPMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:12:15 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD82F656E
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:57 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id s10so12206500ljh.12
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sH5mdU0J82lSBubyPIxIw/XIt0m9sm0DajZ7R0PZmFM=;
        b=knaJ8eJAzYF2U1LYJ1OxeeM1p3RjFGe574cRemVmlbNHTejes4i6AYL3jRMyvOtZ7v
         1fS4SAr4Ktc0OTo4P7z+pflNDq1ID5JQ5zbdvjnjbnqUlHXsw9MlMA5FczYtmZj2sHWQ
         O7mgMEC7mlsws04CCUl8x2lUlBCwkCGFbZFLp1jUEEl+cL/3LRPWzTOLZM9FWqk7aEMQ
         zvdRX+UGVNE/Iodgbp8j90mjh8ubaeFxf0o2H6gHJCxY4AmfEr6aMBzLQ5gXb7C6E78K
         noaqIpK0dNrMiLMvv2XiuoprCbOcqEbg1QjkDRvAjLjty+GuuiAGmy+wj+Yz1aug2bd9
         TAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sH5mdU0J82lSBubyPIxIw/XIt0m9sm0DajZ7R0PZmFM=;
        b=RThxgledE0a9M8EvQ/fZGzUS40vPN52Q54XTrGSG2oex5kxhGy0eisW4+/zdybo64Z
         7eGoE9gmiUtQ4c6FWxsZaeOis6CMtylGN3sETJOQV8MLHxMaGzwJtKvSpbCMSBMAkxe9
         SRWcnwVxvCcTxeWH977pRnq7rsMRsj2OSSRdiYjFaST60/jP7wTJKC8HKE0lkjIOMp6x
         9qemdjL7wWIDSG1HVTlzf5n8Yk0aiF29k1qrgm9Cm70vrPZupgsDXwKn1PZoUKWutVeY
         8zpeMwTq6fbWRFecT9F3dZDdpPrRmeqqB6HqCUmnIVsRO8ovzDff1+WVyHW/FJ7Sm/Cg
         FOlg==
X-Gm-Message-State: AJIora/EE6Jmhdy/V5zTreD5Zs0whpOp4Fv5haFdvmrb6/MvEB5gZqd6
        x8G7ln/Ox149+ctDC9SZWgFQa9ewtKNhZw==
X-Google-Smtp-Source: AGRyM1uiyaR+g5NXDERpjkMHAfHMuJYfDGHDxYxby94uVCwaSCkyGa0OMkqKgsg6hF0M/5asgijo4A==
X-Received: by 2002:a05:651c:4d1:b0:255:c269:da49 with SMTP id e17-20020a05651c04d100b00255c269da49mr12310504lji.54.1655737377262;
        Mon, 20 Jun 2022 08:02:57 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e19-20020a05651236d300b0047f79f7758asm17564lfs.22.2022.06.20.08.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 08:02:56 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        lenb@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        mw@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: [net-next: PATCH 11/12] net: dsa: mv88e6xxx: switch to device_/fwnode_ APIs
Date:   Mon, 20 Jun 2022 17:02:24 +0200
Message-Id: <20220620150225.1307946-12-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220620150225.1307946-1-mw@semihalf.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support both ACPI and DT, modify the generic
DSA code to use device_/fwnode_ equivalent routines.
No functional change is introduced by this patch.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 53 ++++++++++----------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 0b49d243e00b..556defa4379d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3278,7 +3278,7 @@ static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
 
 static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 {
-	struct device_node *phy_handle = NULL;
+	struct fwnode_handle *phy_handle = NULL;
 	struct dsa_switch *ds = chip->ds;
 	struct dsa_port *dp;
 	int tx_amp;
@@ -3475,15 +3475,15 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	if (chip->info->ops->serdes_set_tx_amplitude) {
 		dp = dsa_to_port(ds, port);
 		if (dp)
-			phy_handle = of_parse_phandle(dp->dn, "phy-handle", 0);
+			phy_handle = fwnode_find_reference(dp->fwnode, "phy-handle", 0);
 
-		if (phy_handle && !of_property_read_u32(phy_handle,
-							"tx-p2p-microvolt",
-							&tx_amp))
+		if (!IS_ERR(phy_handle) && !fwnode_property_read_u32(phy_handle,
+								     "tx-p2p-microvolt",
+								     &tx_amp))
 			err = chip->info->ops->serdes_set_tx_amplitude(chip,
 								port, tx_amp);
-		if (phy_handle) {
-			of_node_put(phy_handle);
+		if (!IS_ERR(phy_handle)) {
+			fwnode_handle_put(phy_handle);
 			if (err)
 				return err;
 		}
@@ -3867,10 +3867,11 @@ static int mv88e6xxx_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val)
 }
 
 static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
-				   struct device_node *np,
+				   struct fwnode_handle *fwnode,
 				   bool external)
 {
 	static int index;
+	struct device_node *np = to_of_node(fwnode);
 	struct mv88e6xxx_mdio_bus *mdio_bus;
 	struct mii_bus *bus;
 	int err;
@@ -3949,18 +3950,18 @@ static void mv88e6xxx_mdios_unregister(struct mv88e6xxx_chip *chip)
 }
 
 static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip,
-				    struct device_node *np)
+				    struct fwnode_handle *fwnode)
 {
-	struct device_node *child;
+	struct fwnode_handle *child;
 	int err;
 
 	/* Always register one mdio bus for the internal/default mdio
 	 * bus. This maybe represented in the device tree, but is
 	 * optional.
 	 */
-	child = of_get_child_by_name(np, "mdio");
+	child = fwnode_get_named_child_node(fwnode, "mdio");
 	err = mv88e6xxx_mdio_register(chip, child, false);
-	of_node_put(child);
+	fwnode_handle_put(child);
 	if (err)
 		return err;
 
@@ -3968,13 +3969,13 @@ static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip,
 	 * which say they are compatible with the external mdio
 	 * bus.
 	 */
-	for_each_available_child_of_node(np, child) {
-		if (of_device_is_compatible(
-			    child, "marvell,mv88e6xxx-mdio-external")) {
+	fwnode_for_each_available_child_node(fwnode, child) {
+		if (fwnode_property_match_string(child, "compatible",
+						 "marvell,mv88e6xxx-mdio-external") == 0) {
 			err = mv88e6xxx_mdio_register(chip, child, true);
 			if (err) {
 				mv88e6xxx_mdios_unregister(chip);
-				of_node_put(child);
+				fwnode_handle_put(child);
 				return err;
 			}
 		}
@@ -6962,16 +6963,16 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 	struct dsa_mv88e6xxx_pdata *pdata = mdiodev->dev.platform_data;
 	const struct mv88e6xxx_info *compat_info = NULL;
 	struct device *dev = &mdiodev->dev;
-	struct device_node *np = dev->of_node;
+	struct fwnode_handle *fwnode = dev->fwnode;
 	struct mv88e6xxx_chip *chip;
 	int port;
 	int err;
 
-	if (!np && !pdata)
+	if (!fwnode && !pdata)
 		return -EINVAL;
 
-	if (np)
-		compat_info = of_device_get_match_data(dev);
+	if (fwnode)
+		compat_info = device_get_match_data(dev);
 
 	if (pdata) {
 		compat_info = pdata_device_get_match_data(dev);
@@ -7030,9 +7031,9 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 	mv88e6xxx_phy_init(chip);
 
 	if (chip->info->ops->get_eeprom) {
-		if (np)
-			of_property_read_u32(np, "eeprom-length",
-					     &chip->eeprom_len);
+		if (fwnode)
+			device_property_read_u32(dev, "eeprom-length",
+						 &chip->eeprom_len);
 		else
 			chip->eeprom_len = pdata->eeprom_len;
 	}
@@ -7043,8 +7044,8 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 	if (err)
 		goto out;
 
-	if (np) {
-		chip->irq = of_irq_get(np, 0);
+	if (fwnode) {
+		chip->irq = fwnode_irq_get(fwnode, 0);
 		if (chip->irq == -EPROBE_DEFER) {
 			err = chip->irq;
 			goto out;
@@ -7082,7 +7083,7 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 	if (err)
 		goto out_g1_atu_prob_irq;
 
-	err = mv88e6xxx_mdios_register(chip, np);
+	err = mv88e6xxx_mdios_register(chip, fwnode);
 	if (err)
 		goto out_g1_vtu_prob_irq;
 
-- 
2.29.0

