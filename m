Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32882F67D4
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbhANRfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727525AbhANRfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 12:35:46 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1E0C061757
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 09:35:06 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ga15so9404874ejb.4
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 09:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mZS2GyN/TEWRzguftUVVBWdTiAblnzhFmmjYlRH5Qmo=;
        b=WGJYOn9UiA7HzTR0+CJADNLdySq+qIi4lhxnUAZy7Ju1Jwu7pTQmkr9LD9tA3iGUp5
         XLdDy11OyeE4FLIKjIpVpisxVIjR1NQvNM01MYnybJgkdWYhXIPL1jinPFWrLq2phyea
         uC6d5k1z7qhYCkjjMQcL3VAAlZUpOnt8mntaQAbVwuLnE4oQhYLjyxliFGeFNZzkOsMe
         ZFuozyt/RwFms7jDOAwHmHjpUSUO5KIBkWtyyYbQ55spOXVdOtx9aLpJlnTYnZlmOP3g
         6ngUAaFjQFVatWwf6X6fuUB8Mb62olbBrzdm58n2ZxVLptm6tZ1v5uacJyh+X6GB9sLY
         /PTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mZS2GyN/TEWRzguftUVVBWdTiAblnzhFmmjYlRH5Qmo=;
        b=nMvdl65X7PtiN3GgR7BK71VLymHVJIT0+48hthDLDjvxDdeSoHcOaOOfEnSfBhJNvk
         ghqD4VYnV3xUbtYnCXt76/TjvM3VD/wZV0leQ8+N16zPAFBuAiYK2izKDc7ovnmcKGGV
         QiCcdcHFehi87Uxoj8AN4vj64lQq8tmg8TzQ9H5w6cUDRg/MGgzX0+IebakmGi0FIDde
         sydd7t4Aip58liDKPu8poY9Gljr6t+eyVp6uud2zpDV9kEXc+iQXpmjaHTRmhBza/4f2
         peAHn3UDb+KlF83n5cCYceT4iU4fpG3bKVipt/V4PHpTFrW/N9HoxoOmLckewl7s1ux7
         LOyw==
X-Gm-Message-State: AOAM531UBwHNkydnZRUwILq3wbdvOw6Gy8Kb4bD3s5sWDFCmyAOgSE9D
        WdhrniRDDYa3rSsRO8zPgZk=
X-Google-Smtp-Source: ABdhPJyNCyiMvVaBJsqzmvmaqrwYOjEcGTnakPrtfMZM/YQtuGSdqWCMxT5BQK+wnowyLfmnO2kx9Q==
X-Received: by 2002:a17:907:175c:: with SMTP id lf28mr5756736ejc.110.1610645704887;
        Thu, 14 Jan 2021 09:35:04 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k6sm2188618ejb.84.2021.01.14.09.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 09:35:04 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH net-next] net: dsa: set configure_vlan_while_not_filtering to true by default
Date:   Thu, 14 Jan 2021 19:34:26 +0200
Message-Id: <20210114173426.2731780-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

The Broadcom Starfighter 2 driver calls the common b53_switch_alloc and
therefore also inherits the configure_vlan_while_not_filtering=true
behavior.

Also, print a message through netlink extack every time a VLAN has been
skipped. This is mildly annoying on purpose, so that (a) it is at least
clear that VLANs are being skipped - the legacy behavior in itself is
confusing, and the extack should be much more difficult to miss, unlike
kernel logs - and (b) people have one more incentive to convert to the
new behavior.

No behavior change except for the added prints is intended at this time.

$ ip link add br0 type bridge vlan_filtering 0
$ ip link set sw0p2 master br0
[   60.315148] br0: port 1(sw0p2) entered blocking state
[   60.320350] br0: port 1(sw0p2) entered disabled state
[   60.327839] device sw0p2 entered promiscuous mode
[   60.334905] br0: port 1(sw0p2) entered blocking state
[   60.340142] br0: port 1(sw0p2) entered forwarding state
Warning: dsa_core: skipping configuration of VLAN. # This was the pvid
$ bridge vlan add dev sw0p2 vid 100
Warning: dsa_core: skipping configuration of VLAN.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_common.c       | 3 +--
 drivers/net/dsa/dsa_loop.c             | 1 -
 drivers/net/dsa/hirschmann/hellcreek.c | 5 -----
 drivers/net/dsa/lantiq_gswip.c         | 3 +++
 drivers/net/dsa/microchip/ksz8795.c    | 2 ++
 drivers/net/dsa/microchip/ksz9477.c    | 2 ++
 drivers/net/dsa/mt7530.c               | 2 --
 drivers/net/dsa/mv88e6xxx/chip.c       | 1 -
 drivers/net/dsa/ocelot/felix.c         | 1 -
 drivers/net/dsa/qca/ar9331.c           | 2 ++
 drivers/net/dsa/qca8k.c                | 1 -
 drivers/net/dsa/rtl8366rb.c            | 2 ++
 drivers/net/dsa/sja1105/sja1105_main.c | 2 --
 net/dsa/dsa2.c                         | 2 ++
 net/dsa/slave.c                        | 9 ++++++---
 15 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 5d6d9f91d40a..a238ded354c2 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2602,9 +2602,8 @@ struct b53_device *b53_switch_alloc(struct device *base,
 	dev->priv = priv;
 	dev->ops = ops;
 	ds->ops = &b53_switch_ops;
-	ds->configure_vlan_while_not_filtering = true;
 	ds->untag_bridge_pvid = true;
-	dev->vlan_enabled = ds->configure_vlan_while_not_filtering;
+	dev->vlan_enabled = true;
 	mutex_init(&dev->reg_mutex);
 	mutex_init(&dev->stats_mutex);
 
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index be61ce93a377..5f69216376fe 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -323,7 +323,6 @@ static int dsa_loop_drv_probe(struct mdio_device *mdiodev)
 	ds->dev = &mdiodev->dev;
 	ds->ops = &dsa_loop_driver;
 	ds->priv = ps;
-	ds->configure_vlan_while_not_filtering = true;
 	ps->bus = mdiodev->bus;
 
 	dev_set_drvdata(&mdiodev->dev, ds);
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 205249504289..9a1921e653e8 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1033,11 +1033,6 @@ static int hellcreek_setup(struct dsa_switch *ds)
 	/* Configure PCP <-> TC mapping */
 	hellcreek_setup_tc_identity_mapping(hellcreek);
 
-	/* Allow VLAN configurations while not filtering which is the default
-	 * for new DSA drivers.
-	 */
-	ds->configure_vlan_while_not_filtering = true;
-
 	/* The VLAN awareness is a global switch setting. Therefore, mixed vlan
 	 * filtering setups are not supported.
 	 */
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 244729ee3bdb..9fec97773a15 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -827,6 +827,9 @@ static int gswip_setup(struct dsa_switch *ds)
 	}
 
 	gswip_port_enable(ds, cpu_port, NULL);
+
+	ds->configure_vlan_while_not_filtering = false;
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index d639f9476bd9..37a73421e2cc 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1094,6 +1094,8 @@ static int ksz8795_setup(struct dsa_switch *ds)
 
 	ksz_init_mib_timer(dev);
 
+	ds->configure_vlan_while_not_filtering = false;
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 71cf24f20252..00e38c8e0d01 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1381,6 +1381,8 @@ static int ksz9477_setup(struct dsa_switch *ds)
 
 	ksz_init_mib_timer(dev);
 
+	ds->configure_vlan_while_not_filtering = false;
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 199a135125b2..d2196197d920 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1639,7 +1639,6 @@ mt7530_setup(struct dsa_switch *ds)
 	 * as two netdev instances.
 	 */
 	dn = dsa_to_port(ds, MT7530_CPU_PORT)->master->dev.of_node->parent;
-	ds->configure_vlan_while_not_filtering = true;
 	ds->mtu_enforcement_ingress = true;
 
 	if (priv->id == ID_MT7530) {
@@ -1878,7 +1877,6 @@ mt7531_setup(struct dsa_switch *ds)
 			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 
-	ds->configure_vlan_while_not_filtering = true;
 	ds->mtu_enforcement_ingress = true;
 
 	/* Flush the FDB table */
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 4aa7d0a8f197..20ed433b55df 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2858,7 +2858,6 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 
 	chip->ds = ds;
 	ds->slave_mii_bus = mv88e6xxx_default_mdio_bus(chip);
-	ds->configure_vlan_while_not_filtering = true;
 
 	mv88e6xxx_reg_lock(chip);
 
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 768a74dc462a..8492151f8133 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -599,7 +599,6 @@ static int felix_setup(struct dsa_switch *ds)
 			 ANA_PGID_PGID, PGID_UC);
 
 	ds->mtu_enforcement_ingress = true;
-	ds->configure_vlan_while_not_filtering = true;
 	ds->assisted_learning_on_cpu_port = true;
 
 	return 0;
diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index 1e3706054ae1..ca2ad77b71f1 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -402,6 +402,8 @@ static int ar9331_sw_setup(struct dsa_switch *ds)
 	if (ret)
 		goto error;
 
+	ds->configure_vlan_while_not_filtering = false;
+
 	return 0;
 error:
 	dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index f54e8b6c8621..6127823d6c2e 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1431,7 +1431,6 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 
 	priv->ds->dev = &mdiodev->dev;
 	priv->ds->num_ports = QCA8K_NUM_PORTS;
-	priv->ds->configure_vlan_while_not_filtering = true;
 	priv->ds->priv = priv;
 	priv->ops = qca8k_switch_ops;
 	priv->ds->ops = &priv->ops;
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index 896978568716..c6cc4938897c 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -972,6 +972,8 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 		return -ENODEV;
 	}
 
+	ds->configure_vlan_while_not_filtering = false;
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 050b1260f358..282253543f3b 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2901,8 +2901,6 @@ static int sja1105_setup(struct dsa_switch *ds)
 
 	ds->mtu_enforcement_ingress = true;
 
-	ds->configure_vlan_while_not_filtering = true;
-
 	rc = sja1105_devlink_setup(ds);
 	if (rc < 0)
 		return rc;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 01f21b0b379a..194e09234648 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -448,6 +448,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	if (err)
 		goto unregister_devlink_ports;
 
+	ds->configure_vlan_while_not_filtering = true;
+
 	err = ds->ops->setup(ds);
 	if (err < 0)
 		goto unregister_notifier;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5a1769602e65..b9fd171e1805 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -323,7 +323,8 @@ dsa_slave_vlan_check_for_8021q_uppers(struct net_device *slave,
 }
 
 static int dsa_slave_vlan_add(struct net_device *dev,
-			      const struct switchdev_obj *obj)
+			      const struct switchdev_obj *obj,
+			      struct netlink_ext_ack *extack)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -333,8 +334,10 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
 
-	if (dsa_port_skip_vlan_configuration(dp))
+	if (dsa_port_skip_vlan_configuration(dp)) {
+		NL_SET_ERR_MSG_MOD(extack, "skipping configuration of VLAN");
 		return 0;
+	}
 
 	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
 
@@ -386,7 +389,7 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 		err = dsa_port_mdb_add(dp->cpu_dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		err = dsa_slave_vlan_add(dev, obj);
+		err = dsa_slave_vlan_add(dev, obj, extack);
 		break;
 	default:
 		err = -EOPNOTSUPP;
-- 
2.25.1

