Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535E5260495
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 20:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730175AbgIGSaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 14:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729989AbgIGS3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 14:29:30 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F3AC061757
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 11:29:28 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id z22so19257595ejl.7
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 11:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Ps3PxhHjd/PVa0haOcvBJPLEGvt7wuhy6VTU6LLRHk=;
        b=HWd6jYc0dzWajnQV597aEZze4Yg/otuvkwYhoSIB27PBKN5+/vGpCpzC6skr/R2xFq
         0El3pxD59afXFNGPl3AjFIe6Wd46aKqfnTZKoQH+iKCBPT36TneW3nJsV8138AUolRZE
         864phscTckC2mEtiyj9JJ8uaVqalhHzZgVv2pqz/FcUlr5/PKzf76Zu+ur6HvLtCZkE/
         HPoVmrffsnNzkMT2Y5D1OshecoJZlw0saXecq4MUlN4aViGnNKppVd5ZaI+Ud55fglWD
         5H4+RPneLH+8pKDxPuxYJ5V/sIce6ZviqujpC2WBeQMiEybGstMPRmQAQzbwwCmZOre1
         pSMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Ps3PxhHjd/PVa0haOcvBJPLEGvt7wuhy6VTU6LLRHk=;
        b=llo+Zbno7jhknow4d5G5Oa8Q0NiuRro25lxeSdyZhNCgNGfram3wEZPXDsBGqKdlKI
         djye9vkFu8W0m08Y8viiS/iFSjAbljJEDdczgoFKIZ34IurZtfazIZP0PBx5GoGYpINt
         BYQAvBdX22hEasJoqI5E9J9ACsm4H10yz0IY0LnzAd9tLPHIF2SNuDNI9z5F9m5D07Qh
         ZZitkURZOUMroe+V0Etsl2UhzhjoAodG7Ssij4KB4AM7OJTb7B9Ri04H8hIm/hjcV6wy
         /g1Xq3unQ3m5Hwea/srRXXP4HH1r70EDR34I20LGpmdQCYFEdbY2nRAVFKWUj+Afgn5B
         1MsQ==
X-Gm-Message-State: AOAM531eM42z7LizerEt4Cwzqhl32Ndx6pFU7tu+wKkcdFYab0HstX53
        2iC16/6pj152EIqU6/7GgTU=
X-Google-Smtp-Source: ABdhPJz6bh8GlvEVoe0rOQzkwBnpI4x//xHPx4cmZ5+q4VtPUkRJ9LQbvKn9ZR+CTaNYCdetflaB2A==
X-Received: by 2002:a17:906:2b97:: with SMTP id m23mr22718897ejg.61.1599503367061;
        Mon, 07 Sep 2020 11:29:27 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id g24sm11746816edy.51.2020.09.07.11.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 11:29:26 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: [PATCH net-next 4/4] net: dsa: set configure_vlan_while_not_filtering to true by default
Date:   Mon,  7 Sep 2020 21:29:10 +0300
Message-Id: <20200907182910.1285496-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907182910.1285496-1-olteanv@gmail.com>
References: <20200907182910.1285496-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

As explained in commit 54a0ed0df496 ("net: dsa: provide an option for
drivers to always receive bridge VLANs"), DSA has historically been
skipping VLAN switchdev operations when the bridge wasn't in
vlan_filtering mode, but the reason why it was doing that has never been
clear. So the configure_vlan_while_not_filtering option is there merely
to preserve functionality for existing drivers. It isn't some behavior
that drivers should opt into. Ideally, when all drivers leave this flag
set, we can delete the dsa_port_skip_vlan_configuration() function.

New drivers always seem to omit setting this flag, for some reason. So
let's reverse the logic: the DSA core sets it by default to true before
the .setup() callback, and legacy drivers can turn it off. This way, new
drivers get the new behavior by default, unless they explicitly set the
flag to false, which is more obvious during review.

Remove the assignment from drivers which were setting it to true, and
add the assignment to false for the drivers that didn't previously have
it. This way, it should be easier to see how many we have left.

The following drivers: lan9303, mv88e6060 were skipped from setting this
flag to false, because they didn't have any VLAN offload ops in the
first place.

Also, print a message to the console every time a VLAN has been skipped.
This is mildly annoying on purpose, so that (a) it is at least clear
that VLANs are being skipped - the legacy behavior in itself is
confusing - and (b) people have one more incentive to convert to the new
behavior.

No behavior change except for the added prints is intended at this time.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_common.c       |  1 +
 drivers/net/dsa/bcm_sf2.c              |  1 +
 drivers/net/dsa/dsa_loop.c             |  1 -
 drivers/net/dsa/lantiq_gswip.c         |  3 +++
 drivers/net/dsa/microchip/ksz8795.c    |  2 ++
 drivers/net/dsa/microchip/ksz9477.c    |  2 ++
 drivers/net/dsa/mt7530.c               |  1 -
 drivers/net/dsa/mv88e6xxx/chip.c       |  1 +
 drivers/net/dsa/ocelot/felix.c         |  1 -
 drivers/net/dsa/qca/ar9331.c           |  2 ++
 drivers/net/dsa/qca8k.c                |  1 -
 drivers/net/dsa/rtl8366rb.c            |  2 ++
 drivers/net/dsa/sja1105/sja1105_main.c |  2 --
 net/dsa/dsa2.c                         |  2 ++
 net/dsa/slave.c                        | 29 +++++++++++++++++++-------
 15 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 26fcff85d881..d127cdda16e8 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1011,6 +1011,7 @@ static int b53_setup(struct dsa_switch *ds)
 	 * devices. (not hardware supported)
 	 */
 	ds->vlan_filtering_is_global = true;
+	ds->configure_vlan_while_not_filtering = false;
 
 	return ret;
 }
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 3263e8a0ae67..f9587a73fe54 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1242,6 +1242,7 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 
 	/* Advertise the 8 egress queues */
 	ds->num_tx_queues = SF2_NUM_EGRESS_QUEUES;
+	ds->configure_vlan_while_not_filtering = false;
 
 	dev_set_drvdata(&pdev->dev, priv);
 
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index b588614d1e5e..65b5c1a50282 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -343,7 +343,6 @@ static int dsa_loop_drv_probe(struct mdio_device *mdiodev)
 	ds->dev = &mdiodev->dev;
 	ds->ops = &dsa_loop_driver;
 	ds->priv = ps;
-	ds->configure_vlan_while_not_filtering = true;
 	ps->bus = mdiodev->bus;
 
 	dev_set_drvdata(&mdiodev->dev, ds);
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 521ebc072903..8622d836cbd3 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -837,6 +837,9 @@ static int gswip_setup(struct dsa_switch *ds)
 	}
 
 	gswip_port_enable(ds, cpu_port, NULL);
+
+	ds->configure_vlan_while_not_filtering = false;
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 8f1d15ea15d9..03d65dc5a304 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1087,6 +1087,8 @@ static int ksz8795_setup(struct dsa_switch *ds)
 
 	ksz_init_mib_timer(dev);
 
+	ds->configure_vlan_while_not_filtering = false;
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 3cb22d149813..fea265ca6f82 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1357,6 +1357,8 @@ static int ksz9477_setup(struct dsa_switch *ds)
 
 	ksz_init_mib_timer(dev);
 
+	ds->configure_vlan_while_not_filtering = false;
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 1aaf47a0da2b..4698e740f8fc 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1220,7 +1220,6 @@ mt7530_setup(struct dsa_switch *ds)
 	 * as two netdev instances.
 	 */
 	dn = dsa_to_port(ds, MT7530_CPU_PORT)->master->dev.of_node->parent;
-	ds->configure_vlan_while_not_filtering = true;
 
 	if (priv->id == ID_MT7530) {
 		regulator_set_voltage(priv->core_pwr, 1000000, 1000000);
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 15b97a4f8d93..6948c6980092 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3090,6 +3090,7 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 
 	chip->ds = ds;
 	ds->slave_mii_bus = mv88e6xxx_default_mdio_bus(chip);
+	ds->configure_vlan_while_not_filtering = false;
 
 	mv88e6xxx_reg_lock(chip);
 
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a1e1d3824110..2032c046a056 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -612,7 +612,6 @@ static int felix_setup(struct dsa_switch *ds)
 				 ANA_FLOODING, tc);
 
 	ds->mtu_enforcement_ingress = true;
-	ds->configure_vlan_while_not_filtering = true;
 
 	return 0;
 }
diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index e24a99031b80..20ac64219df2 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -328,6 +328,8 @@ static int ar9331_sw_setup(struct dsa_switch *ds)
 	if (ret)
 		goto error;
 
+	ds->configure_vlan_while_not_filtering = false;
+
 	return 0;
 error:
 	dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index f1e484477e35..e05b9cc39231 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1442,7 +1442,6 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 
 	priv->ds->dev = &mdiodev->dev;
 	priv->ds->num_ports = QCA8K_NUM_PORTS;
-	priv->ds->configure_vlan_while_not_filtering = true;
 	priv->ds->priv = priv;
 	priv->ops = qca8k_switch_ops;
 	priv->ds->ops = &priv->ops;
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index f763f93f600f..c518ab49b968 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -958,6 +958,8 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 		return -ENODEV;
 	}
 
+	ds->configure_vlan_while_not_filtering = false;
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 045077252799..e2cee36f578f 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3047,8 +3047,6 @@ static int sja1105_setup(struct dsa_switch *ds)
 
 	ds->mtu_enforcement_ingress = true;
 
-	ds->configure_vlan_while_not_filtering = true;
-
 	rc = sja1105_setup_devlink_params(ds);
 	if (rc < 0)
 		return rc;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index c0ffc7a2b65f..4a5e2832009b 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -414,6 +414,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	if (err)
 		goto unregister_devlink;
 
+	ds->configure_vlan_while_not_filtering = true;
+
 	err = ds->ops->setup(ds);
 	if (err < 0)
 		goto unregister_notifier;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index e429c71df854..e0c86e97bb78 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -314,11 +314,14 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
 
-	if (dsa_port_skip_vlan_configuration(dp))
-		return 0;
-
 	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
 
+	if (dsa_port_skip_vlan_configuration(dp)) {
+		netdev_warn(dev, "skipping configuration of VLAN %d-%d\n",
+			    vlan.vid_begin, vlan.vid_end);
+		return 0;
+	}
+
 	err = dsa_port_vlan_add(dp, &vlan, trans);
 	if (err)
 		return err;
@@ -377,17 +380,23 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 			      const struct switchdev_obj *obj)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct switchdev_obj_port_vlan *vlan;
 
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
 
-	if (dsa_port_skip_vlan_configuration(dp))
+	vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
+
+	if (dsa_port_skip_vlan_configuration(dp)) {
+		netdev_warn(dev, "skipping deletion of VLAN %d-%d\n",
+			    vlan->vid_begin, vlan->vid_end);
 		return 0;
+	}
 
 	/* Do not deprogram the CPU port as it may be shared with other user
 	 * ports which can be members of this VLAN as well.
 	 */
-	return dsa_port_vlan_del(dp, SWITCHDEV_OBJ_PORT_VLAN(obj));
+	return dsa_port_vlan_del(dp, vlan);
 }
 
 static int dsa_slave_port_obj_del(struct net_device *dev,
@@ -1248,8 +1257,11 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	 * need to emulate the switchdev prepare + commit phase.
 	 */
 	if (dp->bridge_dev) {
-		if (dsa_port_skip_vlan_configuration(dp))
+		if (dsa_port_skip_vlan_configuration(dp)) {
+			netdev_warn(dev, "skipping configuration of VLAN %d\n",
+				    vid);
 			return 0;
+		}
 
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
 		 * device, respectively the VID is not found, returning
@@ -1302,8 +1314,11 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	 * need to emulate the switchdev prepare + commit phase.
 	 */
 	if (dp->bridge_dev) {
-		if (dsa_port_skip_vlan_configuration(dp))
+		if (dsa_port_skip_vlan_configuration(dp)) {
+			netdev_warn(dev, "skipping deletion of VLAN %d\n",
+				    vid);
 			return 0;
+		}
 
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
 		 * device, respectively the VID is not found, returning
-- 
2.25.1

