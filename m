Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF3B575E20
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 11:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbiGOIvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 04:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbiGOIvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 04:51:08 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAF1823B4
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 01:50:51 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id y11so6770889lfs.6
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 01:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fezBfQAJ2Jc7g4+Nk8PG5Lswj+jW8kXFPL2QSLPMg9I=;
        b=rzw3ryPC9hPJVQEddHD6sIN07bCLWZ+7xexAZCwSN0fdkxSWGggvu0wwZABHG7Zxlz
         fOXQZxWSI6Z9FkWwoztaKyinsqC45qiKqWLO/hpg84vEbYAviBeQBSPoGs3G8itffhJV
         Sspi+9GSj6/4bTv26ly7dufqYaJmq7mz/9ntQnO6H0w9ghdOS2nnog5CQ+Ixo1U0QNkk
         w9hZpbjPcHXsE+r5bYuCi2FrnbtUCvTadE+CCt+YWwfpNuT9H1TnKAC2qDHKICNRA1Xg
         eVvltOXKfcZ8rxHC+6lJS4hrLKeBA4lGH+DFT+rBLz0MFfyFUJKpgCQdM24bgB2Kai0e
         nbuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fezBfQAJ2Jc7g4+Nk8PG5Lswj+jW8kXFPL2QSLPMg9I=;
        b=CXUmZQmvMCj8NfpyGQSX+RonT8jbEuZ3e2PJKY0VJA0fEMLjAeJSRmhSGEMXWEaRXK
         He9F9fyWDJ+fZM/YTDOVBW+llo4R0Y38GJmbKWlzkI1TbucstvuLkxVE+4GW36A+d9Lk
         12bvLqkNJty+IL1PidxJhF1f2/rJBz0oSKuIqS72eV4SLqYbheD9WYvi3SkcyDYHh3xs
         8ePZJ/xmJQFET4az4cqbKVGbxyZdg50SH4+juvEeQ3WLkLIVUACa/NDwOwvzaT4ii6Nd
         Zdzox8TTrpQy+2KrOiUPVqvFYf0SS6yY7k8wNL90GSjMDdX5duA4gHpX06Qq1ywtmnxo
         tF+Q==
X-Gm-Message-State: AJIora+kWrNV3Z7+hWkTy5tYDzHEMbiikZpcKzZwt2w3bFxeCzvSfmkw
        T6mHZbZO6hu8dEF1Sc66wLINIw==
X-Google-Smtp-Source: AGRyM1tJ2ITwJs8M2KuFzKSj3rn0UjsLc2ZbkOPICf/e+RhQbzA1sT5YPMhqJIgUjJPuYr/DjTxafg==
X-Received: by 2002:a05:6512:2527:b0:489:ec08:7ada with SMTP id be39-20020a056512252700b00489ec087adamr7203114lfb.621.1657875050824;
        Fri, 15 Jul 2022 01:50:50 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e4-20020a2e9e04000000b0025d773448basm667846ljk.23.2022.07.15.01.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 01:50:50 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        mw@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: [net-next: PATCH v2 8/8] net: dsa: mv88e6xxx: switch to device_/fwnode_ APIs
Date:   Fri, 15 Jul 2022 10:50:12 +0200
Message-Id: <20220715085012.2630214-9-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220715085012.2630214-1-mw@semihalf.com>
References: <20220715085012.2630214-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support both DT and ACPI in future, modify the
mv88e6xx driver  code to use device_/fwnode_ equivalent routines.
No functional change is introduced by this patch.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 57 ++++++++++----------
 1 file changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 1baf07b3284b..ca9ae691573e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3312,7 +3312,7 @@ static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
 
 static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 {
-	struct device_node *phy_handle = NULL;
+	struct fwnode_handle *phy_handle = NULL;
 	struct dsa_switch *ds = chip->ds;
 	struct dsa_port *dp;
 	int tx_amp;
@@ -3499,15 +3499,15 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 
 	if (chip->info->ops->serdes_set_tx_amplitude) {
 		if (dp)
-			phy_handle = of_parse_phandle(to_of_node(dp->fwnode), "phy-handle", 0);
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
@@ -3891,10 +3891,11 @@ static int mv88e6xxx_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val)
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
@@ -3973,18 +3974,18 @@ static void mv88e6xxx_mdios_unregister(struct mv88e6xxx_chip *chip)
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
 
@@ -3992,13 +3993,13 @@ static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip,
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
@@ -6975,20 +6976,16 @@ static SIMPLE_DEV_PM_OPS(mv88e6xxx_pm_ops, mv88e6xxx_suspend, mv88e6xxx_resume);
 static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 {
 	struct dsa_mv88e6xxx_pdata *pdata = mdiodev->dev.platform_data;
+	struct fwnode_handle *fwnode = dev_fwnode(&mdiodev->dev);
 	const struct mv88e6xxx_info *compat_info = NULL;
 	struct device *dev = &mdiodev->dev;
-	struct device_node *np = dev->of_node;
 	struct mv88e6xxx_chip *chip;
 	int port;
 	int err;
 
-	if (!np && !pdata)
-		return -EINVAL;
-
-	if (np)
-		compat_info = of_device_get_match_data(dev);
-
-	if (pdata) {
+	if (fwnode)
+		compat_info = device_get_match_data(dev);
+	else if (pdata) {
 		compat_info = pdata_device_get_match_data(dev);
 
 		if (!pdata->netdev)
@@ -7045,9 +7042,9 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
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
@@ -7058,8 +7055,8 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 	if (err)
 		goto out;
 
-	if (np) {
-		chip->irq = of_irq_get(np, 0);
+	if (fwnode) {
+		chip->irq = fwnode_irq_get(fwnode, 0);
 		if (chip->irq == -EPROBE_DEFER) {
 			err = chip->irq;
 			goto out;
@@ -7097,7 +7094,7 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 	if (err)
 		goto out_g1_atu_prob_irq;
 
-	err = mv88e6xxx_mdios_register(chip, np);
+	err = mv88e6xxx_mdios_register(chip, fwnode);
 	if (err)
 		goto out_g1_vtu_prob_irq;
 
-- 
2.29.0

