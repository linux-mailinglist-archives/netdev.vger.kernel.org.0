Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF3D6BBA06
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 17:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbjCOQlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 12:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbjCOQlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 12:41:07 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766A010CD;
        Wed, 15 Mar 2023 09:39:57 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso1699382wmo.0;
        Wed, 15 Mar 2023 09:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678898353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SKVRMB5BJ3/mPmCndwc4TZq7o7ayvF8yXJpP+m6AseI=;
        b=jy9/Smt3vGOi0D1C/8Nw7Hr+3cWytF5NcVK9/FgtKfhvOTVPsyLOly1cwpy1d2vVWA
         0E60oBPTMSxEbREKdtAPArR4Mm6GZcY9rOBhOldq9P6TDGpynVjYbG4U2fj6SkUpF0EB
         37rt4kS9oB2yDP7fkNRGPF7T4P59abXHEIR2kSfdUdyO/+nv3HnrBABEmSc95syFQTVz
         RRtnznbLMa9FJ39oPGlBovnFPzJ5UxDUozOEaWF7VAd0THBv1YoweUXsbGgpkYnQjcZd
         AYHAhiZLSh0Dc3k6yNfxrF3y6evzIVG7+Wjd/axtM627Cl8F0rR4cxWBepkXOFF3EAKP
         vsNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678898353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SKVRMB5BJ3/mPmCndwc4TZq7o7ayvF8yXJpP+m6AseI=;
        b=XADF+0QsrtevOpiyCdVDeHHQ0iRH4TECrxi3HYDmdmuymv4+d7ZAo73MNUmAwLamBQ
         TjyGm3ulOZEN9x9TAUDDSfDat6CrcoE8K7/5vSIXDqjqV7zzhPVqwmugjqJ25txTl1O7
         aVYrsyAUpu3ODBQlE/3j/B152SWPAjF1BJz/aZ+Xl3QNzXltfBhY58LIY2tqZLgwsAJo
         XnlfaxfqVojdrQpG9oaXpufNggxVFR/5k1sY70ICl7MntC/I9c6XszaBYvKIGXHnroqj
         /Gxa8DF3gnJsPlGWiQX+PUpD/L75wufMte41I6+oB62RCg/Cot4GnAWQ5+C9vsDn7YK6
         3+ow==
X-Gm-Message-State: AO0yUKVx/XmUasLOHQ2gB+OFpx6eSLPH4GQsS7JqdxjRMiqSpKWQScjJ
        UJL6TgGqOnNyKCheJ9yam+4=
X-Google-Smtp-Source: AK7set+xSrVmKpV5biY6fYt9R7znaQmKVVIQdJEvsP+4FZZBjTaI12wFwaOu4dEa//WOJ+q6u/nbiA==
X-Received: by 2002:a05:600c:4ed0:b0:3e2:20c7:6553 with SMTP id g16-20020a05600c4ed000b003e220c76553mr18258946wmq.13.1678898352718;
        Wed, 15 Mar 2023 09:39:12 -0700 (PDT)
Received: from mars.. ([2a02:168:6806:0:839a:f879:3eb0:8b4e])
        by smtp.gmail.com with ESMTPSA id z17-20020a5d4d11000000b002c5a1bd527dsm5039595wrt.96.2023.03.15.09.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 09:39:12 -0700 (PDT)
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
Subject: [PATCH net-next v4 2/4] net: dsa: mv88e6xxx: re-order functions
Date:   Wed, 15 Mar 2023 17:38:44 +0100
Message-Id: <20230315163846.3114-3-klaus.kudielka@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315163846.3114-1-klaus.kudielka@gmail.com>
References: <20230315163846.3114-1-klaus.kudielka@gmail.com>
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

