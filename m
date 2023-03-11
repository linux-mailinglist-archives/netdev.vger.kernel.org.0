Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF4E6B5A34
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 10:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjCKJnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 04:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbjCKJmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 04:42:52 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545FB13F56F;
        Sat, 11 Mar 2023 01:42:27 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id p23-20020a05600c1d9700b003ead4835046so5737925wms.0;
        Sat, 11 Mar 2023 01:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678527745;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=icwaBQpU3isAjPs0PsIO348TEf2ba5GwNw/8dGnNFhE=;
        b=qUkJFQhX+1tkimfn/9AuCcQEbxUco93VmE7zMDsKgjC4YW3RnDGfj4S15KCBCIAlJl
         PW5oY8M+rOQzZWBFfBI1cCrmvXzjcX+49F5nPPc8fcLZr+K1TrZpuOa1ROacTiTc7CRu
         c3ebxVPL70gXWLx93TOr2ya44yDeGWpMgTI4fyE1Gz/ZKQV8/pq1o7Tp/iA/Qau9kJ62
         IbMv8uYRQdJJ5saj3+vKeCkVSUmzHSRZPglA48iMVeDBlVKaaXP3jVjlFwv/2XcI70v8
         v6boWVSXc6RQoaTRrMMSpUwvIVHNJjvEb7BG6YzJRrSL+PzUz7h6QkM1MDJlM4xjXsSZ
         zRRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678527745;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=icwaBQpU3isAjPs0PsIO348TEf2ba5GwNw/8dGnNFhE=;
        b=eTwfKIdRel7sGFxwJb0cxuGtXt7GcmQx1l9QDSTtFC3P7bWR+C/GTwcuKqI8Zq47Dy
         N5BuGF/gs4k6JTH850N7LDLRE2rmdhDvoslmNPKJRju07SYGynzGda6lEew4hL2RUDMK
         mG1iD5xLGM7/vL2ZEZ3H7lZccmREUuRPv8i6mEs4xx/7qrpGOWhqfW1VVFRXf3Si7I/o
         LyYk6hv84kD7MwbP/jFfYVbsQHpgvOQHo26Q0H9Dp4pcRe0W1GjYxVf10BACCspQWUJ6
         TcE6ojZVVr6sOwWCVJfVYvLY1GwxNN8lgj8vQG00QhdNhWQYfDzTll7Crp+AXzyyhhJw
         a3jQ==
X-Gm-Message-State: AO0yUKU365xVOF/aKun09jMaF1/bcrHH7/t0hA1dZW8y2OfgSgTMbTMJ
        4DKdzH+JFDn/sqMMwmlYB4A=
X-Google-Smtp-Source: AK7set8k7bhbF79MpPFv+eE9yrV6aL1T97VvBm8tOT4/Th3ZCSSxTe11ibLoA7OG+fjyU9tPBeaSwA==
X-Received: by 2002:a05:600c:1c96:b0:3eb:3300:1d13 with SMTP id k22-20020a05600c1c9600b003eb33001d13mr5135569wms.14.1678527745499;
        Sat, 11 Mar 2023 01:42:25 -0800 (PST)
Received: from mars.. ([2a02:168:6806:0:c51d:786:86a8:fd19])
        by smtp.gmail.com with ESMTPSA id n19-20020a1c7213000000b003eb39e60ec9sm2275043wmc.36.2023.03.11.01.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 01:42:25 -0800 (PST)
From:   Klaus Kudielka <klaus.kudielka@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Klaus Kudielka <klaus.kudielka@gmail.com>
Subject: [PATCH 1/2] net: dsa: mv88e6xxx: re-order functions
Date:   Sat, 11 Mar 2023 10:41:40 +0100
Message-Id: <20230311094141.34578-1-klaus.kudielka@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move mv88e6xxx_setup() below mv88e6xxx_mdios_register(), so that we are
able to call the latter one from here. Do the same thing for the
inverse functions.

Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 358 +++++++++++++++----------------
 1 file changed, 179 insertions(+), 179 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 0a5d6c7bb1..496015baac 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3672,185 +3672,6 @@ static int mv88e6390_setup_errata(struct mv88e6xxx_chip *chip)
 	return mv88e6xxx_software_reset(chip);
 }
 
-static void mv88e6xxx_teardown(struct dsa_switch *ds)
-{
-	mv88e6xxx_teardown_devlink_params(ds);
-	dsa_devlink_resources_unregister(ds);
-	mv88e6xxx_teardown_devlink_regions_global(ds);
-}
-
-static int mv88e6xxx_setup(struct dsa_switch *ds)
-{
-	struct mv88e6xxx_chip *chip = ds->priv;
-	u8 cmode;
-	int err;
-	int i;
-
-	chip->ds = ds;
-	ds->slave_mii_bus = mv88e6xxx_default_mdio_bus(chip);
-
-	/* Since virtual bridges are mapped in the PVT, the number we support
-	 * depends on the physical switch topology. We need to let DSA figure
-	 * that out and therefore we cannot set this at dsa_register_switch()
-	 * time.
-	 */
-	if (mv88e6xxx_has_pvt(chip))
-		ds->max_num_bridges = MV88E6XXX_MAX_PVT_SWITCHES -
-				      ds->dst->last_switch - 1;
-
-	mv88e6xxx_reg_lock(chip);
-
-	if (chip->info->ops->setup_errata) {
-		err = chip->info->ops->setup_errata(chip);
-		if (err)
-			goto unlock;
-	}
-
-	/* Cache the cmode of each port. */
-	for (i = 0; i < mv88e6xxx_num_ports(chip); i++) {
-		if (chip->info->ops->port_get_cmode) {
-			err = chip->info->ops->port_get_cmode(chip, i, &cmode);
-			if (err)
-				goto unlock;
-
-			chip->ports[i].cmode = cmode;
-		}
-	}
-
-	err = mv88e6xxx_vtu_setup(chip);
-	if (err)
-		goto unlock;
-
-	/* Must be called after mv88e6xxx_vtu_setup (which flushes the
-	 * VTU, thereby also flushing the STU).
-	 */
-	err = mv88e6xxx_stu_setup(chip);
-	if (err)
-		goto unlock;
-
-	/* Setup Switch Port Registers */
-	for (i = 0; i < mv88e6xxx_num_ports(chip); i++) {
-		if (dsa_is_unused_port(ds, i))
-			continue;
-
-		/* Prevent the use of an invalid port. */
-		if (mv88e6xxx_is_invalid_port(chip, i)) {
-			dev_err(chip->dev, "port %d is invalid\n", i);
-			err = -EINVAL;
-			goto unlock;
-		}
-
-		err = mv88e6xxx_setup_port(chip, i);
-		if (err)
-			goto unlock;
-	}
-
-	err = mv88e6xxx_irl_setup(chip);
-	if (err)
-		goto unlock;
-
-	err = mv88e6xxx_mac_setup(chip);
-	if (err)
-		goto unlock;
-
-	err = mv88e6xxx_phy_setup(chip);
-	if (err)
-		goto unlock;
-
-	err = mv88e6xxx_pvt_setup(chip);
-	if (err)
-		goto unlock;
-
-	err = mv88e6xxx_atu_setup(chip);
-	if (err)
-		goto unlock;
-
-	err = mv88e6xxx_broadcast_setup(chip, 0);
-	if (err)
-		goto unlock;
-
-	err = mv88e6xxx_pot_setup(chip);
-	if (err)
-		goto unlock;
-
-	err = mv88e6xxx_rmu_setup(chip);
-	if (err)
-		goto unlock;
-
-	err = mv88e6xxx_rsvd2cpu_setup(chip);
-	if (err)
-		goto unlock;
-
-	err = mv88e6xxx_trunk_setup(chip);
-	if (err)
-		goto unlock;
-
-	err = mv88e6xxx_devmap_setup(chip);
-	if (err)
-		goto unlock;
-
-	err = mv88e6xxx_pri_setup(chip);
-	if (err)
-		goto unlock;
-
-	/* Setup PTP Hardware Clock and timestamping */
-	if (chip->info->ptp_support) {
-		err = mv88e6xxx_ptp_setup(chip);
-		if (err)
-			goto unlock;
-
-		err = mv88e6xxx_hwtstamp_setup(chip);
-		if (err)
-			goto unlock;
-	}
-
-	err = mv88e6xxx_stats_setup(chip);
-	if (err)
-		goto unlock;
-
-unlock:
-	mv88e6xxx_reg_unlock(chip);
-
-	if (err)
-		return err;
-
-	/* Have to be called without holding the register lock, since
-	 * they take the devlink lock, and we later take the locks in
-	 * the reverse order when getting/setting parameters or
-	 * resource occupancy.
-	 */
-	err = mv88e6xxx_setup_devlink_resources(ds);
-	if (err)
-		return err;
-
-	err = mv88e6xxx_setup_devlink_params(ds);
-	if (err)
-		goto out_resources;
-
-	err = mv88e6xxx_setup_devlink_regions_global(ds);
-	if (err)
-		goto out_params;
-
-	return 0;
-
-out_params:
-	mv88e6xxx_teardown_devlink_params(ds);
-out_resources:
-	dsa_devlink_resources_unregister(ds);
-
-	return err;
-}
-
-static int mv88e6xxx_port_setup(struct dsa_switch *ds, int port)
-{
-	return mv88e6xxx_setup_devlink_regions_port(ds, port);
-}
-
-static void mv88e6xxx_port_teardown(struct dsa_switch *ds, int port)
-{
-	mv88e6xxx_teardown_devlink_regions_port(ds, port);
-}
-
 /* prod_id for switch families which do not have a PHY model number */
 static const u16 family_prod_id_table[] = {
 	[MV88E6XXX_FAMILY_6341] = MV88E6XXX_PORT_SWITCH_ID_PROD_6341,
@@ -4054,6 +3875,185 @@ static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip,
 	return 0;
 }
 
+static void mv88e6xxx_teardown(struct dsa_switch *ds)
+{
+	mv88e6xxx_teardown_devlink_params(ds);
+	dsa_devlink_resources_unregister(ds);
+	mv88e6xxx_teardown_devlink_regions_global(ds);
+}
+
+static int mv88e6xxx_setup(struct dsa_switch *ds)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	u8 cmode;
+	int err;
+	int i;
+
+	chip->ds = ds;
+	ds->slave_mii_bus = mv88e6xxx_default_mdio_bus(chip);
+
+	/* Since virtual bridges are mapped in the PVT, the number we support
+	 * depends on the physical switch topology. We need to let DSA figure
+	 * that out and therefore we cannot set this at dsa_register_switch()
+	 * time.
+	 */
+	if (mv88e6xxx_has_pvt(chip))
+		ds->max_num_bridges = MV88E6XXX_MAX_PVT_SWITCHES -
+				      ds->dst->last_switch - 1;
+
+	mv88e6xxx_reg_lock(chip);
+
+	if (chip->info->ops->setup_errata) {
+		err = chip->info->ops->setup_errata(chip);
+		if (err)
+			goto unlock;
+	}
+
+	/* Cache the cmode of each port. */
+	for (i = 0; i < mv88e6xxx_num_ports(chip); i++) {
+		if (chip->info->ops->port_get_cmode) {
+			err = chip->info->ops->port_get_cmode(chip, i, &cmode);
+			if (err)
+				goto unlock;
+
+			chip->ports[i].cmode = cmode;
+		}
+	}
+
+	err = mv88e6xxx_vtu_setup(chip);
+	if (err)
+		goto unlock;
+
+	/* Must be called after mv88e6xxx_vtu_setup (which flushes the
+	 * VTU, thereby also flushing the STU).
+	 */
+	err = mv88e6xxx_stu_setup(chip);
+	if (err)
+		goto unlock;
+
+	/* Setup Switch Port Registers */
+	for (i = 0; i < mv88e6xxx_num_ports(chip); i++) {
+		if (dsa_is_unused_port(ds, i))
+			continue;
+
+		/* Prevent the use of an invalid port. */
+		if (mv88e6xxx_is_invalid_port(chip, i)) {
+			dev_err(chip->dev, "port %d is invalid\n", i);
+			err = -EINVAL;
+			goto unlock;
+		}
+
+		err = mv88e6xxx_setup_port(chip, i);
+		if (err)
+			goto unlock;
+	}
+
+	err = mv88e6xxx_irl_setup(chip);
+	if (err)
+		goto unlock;
+
+	err = mv88e6xxx_mac_setup(chip);
+	if (err)
+		goto unlock;
+
+	err = mv88e6xxx_phy_setup(chip);
+	if (err)
+		goto unlock;
+
+	err = mv88e6xxx_pvt_setup(chip);
+	if (err)
+		goto unlock;
+
+	err = mv88e6xxx_atu_setup(chip);
+	if (err)
+		goto unlock;
+
+	err = mv88e6xxx_broadcast_setup(chip, 0);
+	if (err)
+		goto unlock;
+
+	err = mv88e6xxx_pot_setup(chip);
+	if (err)
+		goto unlock;
+
+	err = mv88e6xxx_rmu_setup(chip);
+	if (err)
+		goto unlock;
+
+	err = mv88e6xxx_rsvd2cpu_setup(chip);
+	if (err)
+		goto unlock;
+
+	err = mv88e6xxx_trunk_setup(chip);
+	if (err)
+		goto unlock;
+
+	err = mv88e6xxx_devmap_setup(chip);
+	if (err)
+		goto unlock;
+
+	err = mv88e6xxx_pri_setup(chip);
+	if (err)
+		goto unlock;
+
+	/* Setup PTP Hardware Clock and timestamping */
+	if (chip->info->ptp_support) {
+		err = mv88e6xxx_ptp_setup(chip);
+		if (err)
+			goto unlock;
+
+		err = mv88e6xxx_hwtstamp_setup(chip);
+		if (err)
+			goto unlock;
+	}
+
+	err = mv88e6xxx_stats_setup(chip);
+	if (err)
+		goto unlock;
+
+unlock:
+	mv88e6xxx_reg_unlock(chip);
+
+	if (err)
+		return err;
+
+	/* Have to be called without holding the register lock, since
+	 * they take the devlink lock, and we later take the locks in
+	 * the reverse order when getting/setting parameters or
+	 * resource occupancy.
+	 */
+	err = mv88e6xxx_setup_devlink_resources(ds);
+	if (err)
+		return err;
+
+	err = mv88e6xxx_setup_devlink_params(ds);
+	if (err)
+		goto out_resources;
+
+	err = mv88e6xxx_setup_devlink_regions_global(ds);
+	if (err)
+		goto out_params;
+
+	return 0;
+
+out_params:
+	mv88e6xxx_teardown_devlink_params(ds);
+out_resources:
+	dsa_devlink_resources_unregister(ds);
+
+	return err;
+}
+
+static int mv88e6xxx_port_setup(struct dsa_switch *ds, int port)
+{
+	return mv88e6xxx_setup_devlink_regions_port(ds, port);
+}
+
+static void mv88e6xxx_port_teardown(struct dsa_switch *ds, int port)
+{
+	mv88e6xxx_teardown_devlink_regions_port(ds, port);
+}
+
 static int mv88e6xxx_get_eeprom_len(struct dsa_switch *ds)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
-- 
2.39.2

