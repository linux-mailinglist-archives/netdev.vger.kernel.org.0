Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0CB6B9E55
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjCNS2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjCNS2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:28:39 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3365B4F79;
        Tue, 14 Mar 2023 11:28:06 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id c8-20020a05600c0ac800b003ed2f97a63eso942826wmr.3;
        Tue, 14 Mar 2023 11:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678818484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XjgfVrrzqzZG1qqVxNM9bM9LJAcqmVcDeMqlw6Kxzgg=;
        b=aD6NxyzRFngsopmrdASrjcU0vQ8iim1I31ReP2hBX64zvFL5W8+0S7zrnVxPbAnEaX
         Vhzz+MWrztqfY2vG1x3xG7FIhapwhI2uaRKkquK/I83zcvipG4qmbZtHnYDCQBg9ygzW
         3vhlxjngcI3YTG/L9G15ZICGiPcTGnVj4acsgCAu+453FOiOUUtWy89QMAOsKeSVPArc
         JwOwOIr5usvQJG46BS1K62oecZmSFvnovQT6XxZoAvxPd0a7tHz8328alimpTnC9oPo+
         ZYvdFhgEZEr1UyNuC/v2/0dEz3g7l3qE4Hqq3Rwc4/EnXWZMrM/SkQ31bW8ck8xIefCO
         AAnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678818484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XjgfVrrzqzZG1qqVxNM9bM9LJAcqmVcDeMqlw6Kxzgg=;
        b=hZpxweL9G+97Fzif5dqcrCRazqzD+WiYhW0PftKYhQFl54kHAuUoVLKWXla5UjbxEo
         L3Th6icHMtaovek/+GOlYH5DG+CnWlqYXOn+mWPCpFx4WOQE+ka1koCop65UALJD70PM
         pSQAbp791dEhq8DXh4m9jGGJ7W2OOXA45hkGdIAvw+INBnN40RUF9Aon42LPQYrsxLZo
         mMUX5IG9Gq6h/rdrDobjPx2An+vGvZebQ9MFXNDhGwYRXvzi9ZKfg4SZmPSgdiA7hUhy
         tum7Mf3ZiIpfcgVczfv6ZMy4twVrENRLtVrrXuSElJcVm4QQpfpcvo+hGfgE9IoNs1R9
         YSYw==
X-Gm-Message-State: AO0yUKUZ9ymoweuJD+I75RGPgMU7yVn2alqf182E3xaYIe7IoG9AaKQI
        gnHb0a6FgZkuDDHnOtkuSqg=
X-Google-Smtp-Source: AK7set/848at0crloBLbVrsau93TK46DK5Atd/Uh6tA9eqD/xyvv/pgIBlouHZypcgcl2N3E2OsjKw==
X-Received: by 2002:a05:600c:19d4:b0:3ed:22b3:627a with SMTP id u20-20020a05600c19d400b003ed22b3627amr8505728wmq.1.1678818483993;
        Tue, 14 Mar 2023 11:28:03 -0700 (PDT)
Received: from mars.. ([2a02:168:6806:0:5862:40de:7045:5e1b])
        by smtp.gmail.com with ESMTPSA id u7-20020a7bc047000000b003e206cc7237sm3443490wmc.24.2023.03.14.11.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 11:28:03 -0700 (PDT)
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
Subject: [PATCH net-next v3 2/4] net: dsa: mv88e6xxx: re-order functions
Date:   Tue, 14 Mar 2023 19:26:57 +0100
Message-Id: <20230314182659.63686-3-klaus.kudielka@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314182659.63686-1-klaus.kudielka@gmail.com>
References: <20230314182659.63686-1-klaus.kudielka@gmail.com>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
v2: No change
v3: No change

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

