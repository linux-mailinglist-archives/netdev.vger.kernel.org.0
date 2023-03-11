Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4360E6B6088
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 21:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjCKUcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 15:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjCKUcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 15:32:22 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B38A6EB80;
        Sat, 11 Mar 2023 12:32:21 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id bw19so7989807wrb.13;
        Sat, 11 Mar 2023 12:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678566739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sa8Viko7R2yiIEdvUmLiKMrQqnXj/8f/7Yb3WNadgBE=;
        b=ZEu4wx49OgDa69bbgN58Fary1rVTxN2vAfurmq13lyT0q3i7Xv1xq2OLKS283to7/x
         dGZZN9Ctqx3K+JdBfJJtj/gCrU/mVlpxTnax4p6REToMui6yqvQty5C4bTGYCd+gTOnn
         M13tSegRVtzUIIFaJCYM3sF0If6Xbmbj4j9/GzpgcjMHjZWNsqYosgILz2e3eqbg5hz6
         xez8uLM3P7mePOeP1m44gqCRC12Z8Hk45yaHNUqy5noiNp73nH6mZzdMVnXWuu4aXfGS
         Ccr/xjMQS7esuKWhmFuyh7a2MjLpglcjTVVWbcJSm5qwmqsnn2pDFfuj7HCxtdRAaC5h
         WxKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678566739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sa8Viko7R2yiIEdvUmLiKMrQqnXj/8f/7Yb3WNadgBE=;
        b=6obxyTZIf+0hFmowDXeOD0hM1QWPcD1vR0TY3AfcNn8pzqsuTnEYpq76B0FYDDsotl
         zb8jA5sJ7dtWJuUk7+xenBPi85jwuFatuQo7RVU2oGtciHPiudzsK+VljjH3YaNZbDRr
         H4FIrNtUsSza4WLBQ6CkY2vHP1Og9/FmZIljqrKeZGumdOdiXhULtAyMY55+3RMRSv63
         KPSACpcSOsaLXVdV1jrezuygJ6M8O4oVTOJYiL8xy0noaz5/SJ1HmLQ4Udx6/AMRmypd
         8CqOeJSZd3zlAKXw6HnO+blo+dsuCJtIq8NpTD9u2MnMj1Ag6waOfYhYGdQJuAzQsMg4
         XYaQ==
X-Gm-Message-State: AO0yUKWK1NtltPqR9Rf/r5lHGJcXPH2zQS2bLEwgL1AX0XFWaEwhPyWK
        WfAzc099qS87cHUgzsCU9Y8=
X-Google-Smtp-Source: AK7set8ivvycNRkTSMQUh37rJELg21KjM6gllfEcoCjWTsLSrP7/eF0HaC12t9lOVxmlUAXzwvgRWA==
X-Received: by 2002:a5d:4289:0:b0:2ce:a250:df68 with SMTP id k9-20020a5d4289000000b002cea250df68mr1693846wrq.28.1678566739370;
        Sat, 11 Mar 2023 12:32:19 -0800 (PST)
Received: from mars.. ([2a02:168:6806:0:cb1:a328:ee29:2bd6])
        by smtp.gmail.com with ESMTPSA id t17-20020a05600c451100b003dc434b39c7sm4524319wmo.0.2023.03.11.12.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 12:32:19 -0800 (PST)
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
Subject: [PATCH net-next v2 1/3] net: dsa: mv88e6xxx: re-order functions
Date:   Sat, 11 Mar 2023 21:31:30 +0100
Message-Id: <20230311203132.156467-2-klaus.kudielka@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230311203132.156467-1-klaus.kudielka@gmail.com>
References: <20230311203132.156467-1-klaus.kudielka@gmail.com>
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
v2: No change

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

