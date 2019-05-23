Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27979273E4
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbfEWBUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:20:55 -0400
Received: from mail-eopbgr140079.outbound.protection.outlook.com ([40.107.14.79]:16354
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729451AbfEWBUy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 21:20:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AssAJrGNL8nRQXoHd1zgVg3ofuOLLb0yrJNgF9SXLjU=;
 b=qv2FtLWmZbCLKMAU9NG7m0oKKrHpaoV2eIukSYl7hEVrFnbuAC6WdtwX1LC7+mpsWiWC4PuO9yx9Tx4e1hWFDm4xuFsyqjeo32eE1FV1033B6e8k4j8kyzkMEUGEsyAEb/N3F1jDeldLhIwE/3+IaeTuAW7amf/rKC/QJJtxxqg=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3677.eurprd04.prod.outlook.com (52.134.15.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Thu, 23 May 2019 01:20:40 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 01:20:40 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RFC PATCH net-next 5/9] net: phylink: Add phylink_create_raw
Thread-Topic: [RFC PATCH net-next 5/9] net: phylink: Add phylink_create_raw
Thread-Index: AQHVEQW8O+LbHNLMy02dz0XkU/eeIQ==
Date:   Thu, 23 May 2019 01:20:40 +0000
Message-ID: <20190523011958.14944-6-ioana.ciornei@nxp.com>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
In-Reply-To: <20190523011958.14944-1-ioana.ciornei@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1P18901CA0009.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::19) To VI1PR0402MB2800.eurprd04.prod.outlook.com
 (2603:10a6:800:b8::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.21.0
x-originating-ip: [5.12.225.227]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c40025e5-06a6-42d2-80bc-08d6df1cde59
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3677;
x-ms-traffictypediagnostic: VI1PR0402MB3677:
x-microsoft-antispam-prvs: <VI1PR0402MB3677C304E6724C69611C1588E0010@VI1PR0402MB3677.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:462;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(366004)(346002)(376002)(199004)(189003)(25786009)(6512007)(316002)(2201001)(26005)(186003)(86362001)(2501003)(30864003)(1076003)(36756003)(71200400001)(256004)(71190400001)(5660300002)(4326008)(66066001)(6486002)(14444005)(6436002)(3846002)(7736002)(305945005)(71446004)(99286004)(52116002)(50226002)(81156014)(8676002)(81166006)(8936002)(54906003)(110136005)(2906002)(6116002)(478600001)(68736007)(102836004)(76176011)(53936002)(486006)(2616005)(66446008)(6506007)(386003)(66946007)(73956011)(66556008)(44832011)(14454004)(476003)(11346002)(66476007)(64756008)(446003)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3677;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1oxLQ/4O+CXE1gfmF90yaiF05F3gxn5mIdK9v9kjDsOiTUL+lwNZTz6dqc+/Q7uHakvbIPB7ClHfUJ4bMi/JY8TH4omiItvD2ctCMjyTMq5QCXSYbzkWqFjTb/OjRwNhspYV+ei6DxR/ZGH3JXNptxGui6x8n+MiiFxHfXmMC1p4hQ7SgO5yClZ4Zx7KKg9g3h+fBBSsMimUtk1/HL3fUPHpFlkiPIITds5K9OCu57aK4GiUUkAyRKV04lsU89o5VWFcLaA5Ox6Icnd3KFFj6OCyI2ouOT/q1cYrM4ozQfyWg0RLta6sz9DR4/5E/DVEqsBhHqSAFNir48u0GYrHtZ3HRhwhd9WsdHVUNJjViF+TP0ylAJTrMx0J8ZPOD4XgenRA8UlnSoVf1Kj6nox+wuflD7//plj1K7gw2s/VECQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <61D3FD4078656942A67DA5088A845916@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c40025e5-06a6-42d2-80bc-08d6df1cde59
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 01:20:40.5923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3677
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a new entry point to PHYLINK that does not require a
net_device structure.

The main intended use are DSA ports that do not have net devices
registered for them (mainly because doing so would be redundant - see
Documentation/networking/dsa/dsa.rst for details). So far DSA has been
using PHYLIB fixed PHYs for these ports, driven manually with genphy
instead of starting a full PHY state machine, but this does not scale
well when there are actual PHYs that need a driver on those ports, or
when a fixed-link is requested in DT that has a speed unsupported by the
fixed PHY C22 emulation (such as SGMII-2500).

The proposed solution comes in the form of a notifier chain owned by the
PHYLINK instance, and the passing of phylink_notifier_info structures
back to the driver through a blocking notifier call.

The event API exposed by the new notifier mechanism is a 1:1 mapping to
the existing PHYLINK mac_ops, plus the PHYLINK fixed-link callback.

Both the standard phylink_create() function, as well as its raw variant,
call the same underlying function which initializes either the netdev
field or the notifier block of the PHYLINK instance.

All PHYLINK driver callbacks have been extended to call the notifier
chain in case the instance is a raw one.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/phy/phylink.c | 189 ++++++++++++++++++++++++++++++--------
 include/linux/phylink.h   |  21 +++++
 2 files changed, 174 insertions(+), 36 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 68cfe31240cc..7b6b233c1a07 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -18,6 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
+#include <linux/notifier.h>
=20
 #include "sfp.h"
 #include "swphy.h"
@@ -41,6 +42,8 @@ struct phylink {
 	/* private: */
 	struct net_device *netdev;
 	const struct phylink_mac_ops *ops;
+	struct notifier_block *nb;
+	struct blocking_notifier_head notifier_chain;
=20
 	unsigned long phylink_disable_state; /* bitmask of disables */
 	struct phy_device *phydev;
@@ -111,7 +114,16 @@ static const char *phylink_an_mode_str(unsigned int mo=
de)
 static int phylink_validate(struct phylink *pl, unsigned long *supported,
 			    struct phylink_link_state *state)
 {
-	pl->ops->validate(pl->netdev, supported, state);
+	struct phylink_notifier_info info =3D {
+		.supported =3D supported,
+		.state =3D state,
+	};
+
+	if (pl->ops)
+		pl->ops->validate(pl->netdev, supported, state);
+	else
+		blocking_notifier_call_chain(&pl->notifier_chain,
+					     PHYLINK_VALIDATE, &info);
=20
 	return phylink_is_empty_linkmode(supported) ? -EINVAL : 0;
 }
@@ -290,6 +302,12 @@ static int phylink_parse_mode(struct phylink *pl, stru=
ct fwnode_handle *fwnode)
 static void phylink_mac_config(struct phylink *pl,
 			       const struct phylink_link_state *state)
 {
+	struct phylink_notifier_info info =3D {
+		.link_an_mode =3D pl->link_an_mode,
+		/* Discard const pointer */
+		.state =3D (struct phylink_link_state *)state,
+	};
+
 	netdev_dbg(pl->netdev,
 		   "%s: mode=3D%s/%s/%s/%s adv=3D%*pb pause=3D%02x link=3D%u an=3D%u\n",
 		   __func__, phylink_an_mode_str(pl->link_an_mode),
@@ -299,7 +317,12 @@ static void phylink_mac_config(struct phylink *pl,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS, state->advertising,
 		   state->pause, state->link, state->an_enabled);
=20
-	pl->ops->mac_config(pl->netdev, pl->link_an_mode, state);
+	if (pl->ops)
+		pl->ops->mac_config(pl->netdev, pl->link_an_mode, state);
+	else
+		blocking_notifier_call_chain(&pl->notifier_chain,
+					     PHYLINK_MAC_CONFIG, &info);
+
 }
=20
 static void phylink_mac_config_up(struct phylink *pl,
@@ -311,13 +334,22 @@ static void phylink_mac_config_up(struct phylink *pl,
=20
 static void phylink_mac_an_restart(struct phylink *pl)
 {
-	if (pl->link_config.an_enabled &&
-	    phy_interface_mode_is_8023z(pl->link_config.interface))
+	if (!pl->link_config.an_enabled &&
+	    !phy_interface_mode_is_8023z(pl->link_config.interface))
+		return;
+
+	if (pl->ops)
 		pl->ops->mac_an_restart(pl->netdev);
+	else
+		blocking_notifier_call_chain(&pl->notifier_chain,
+					     PHYLINK_MAC_AN_RESTART, NULL);
 }
=20
 static int phylink_get_mac_state(struct phylink *pl, struct phylink_link_s=
tate *state)
 {
+	struct phylink_notifier_info info =3D {
+		.state =3D state,
+	};
 	struct net_device *ndev =3D pl->netdev;
=20
 	linkmode_copy(state->advertising, pl->link_config.advertising);
@@ -330,7 +362,12 @@ static int phylink_get_mac_state(struct phylink *pl, s=
truct phylink_link_state *
 	state->an_complete =3D 0;
 	state->link =3D 1;
=20
-	return pl->ops->mac_link_state(ndev, state);
+	if (pl->ops)
+		return pl->ops->mac_link_state(ndev, state);
+	else
+		return blocking_notifier_call_chain(&pl->notifier_chain,
+						    PHYLINK_MAC_LINK_STATE,
+						    &info);
 }
=20
 /* The fixed state is... fixed except for the link state,
@@ -338,9 +375,17 @@ static int phylink_get_mac_state(struct phylink *pl, s=
truct phylink_link_state *
  */
 static void phylink_get_fixed_state(struct phylink *pl, struct phylink_lin=
k_state *state)
 {
+	struct phylink_notifier_info info =3D {
+		.state =3D state,
+	};
+
 	*state =3D pl->link_config;
 	if (pl->get_fixed_state)
 		pl->get_fixed_state(pl->netdev, state);
+	else if (pl->nb)
+		blocking_notifier_call_chain(&pl->notifier_chain,
+					     PHYLINK_GET_FIXED_STATE,
+					     &info);
 	else if (pl->link_gpio)
 		state->link =3D !!gpiod_get_value_cansleep(pl->link_gpio);
 }
@@ -399,28 +444,54 @@ static void phylink_mac_link_up(struct phylink *pl,
 				struct phylink_link_state link_state)
 {
 	struct net_device *ndev =3D pl->netdev;
+	struct phylink_notifier_info info =3D {
+		.link_an_mode =3D pl->link_an_mode,
+		.interface =3D pl->phy_state.interface,
+		.phydev =3D pl->phydev,
+	};
=20
-	pl->ops->mac_link_up(ndev, pl->link_an_mode,
+	if (pl->ops) {
+		pl->ops->mac_link_up(ndev, pl->link_an_mode,
 			     pl->phy_state.interface,
 			     pl->phydev);
=20
-	netif_carrier_on(ndev);
+		netif_carrier_on(ndev);
=20
-	netdev_info(ndev,
-		    "Link is Up - %s/%s - flow control %s\n",
-		    phy_speed_to_str(link_state.speed),
-		    phy_duplex_to_str(link_state.duplex),
-		    phylink_pause_to_str(link_state.pause));
+		netdev_info(ndev,
+			    "Link is Up - %s/%s - flow control %s\n",
+			    phy_speed_to_str(link_state.speed),
+			    phy_duplex_to_str(link_state.duplex),
+			    phylink_pause_to_str(link_state.pause));
+	} else {
+		blocking_notifier_call_chain(&pl->notifier_chain,
+					     PHYLINK_MAC_LINK_UP, &info);
+		phydev_info(pl->phydev,
+			    "Link is Up - %s/%s - flow control %s\n",
+			    phy_speed_to_str(link_state.speed),
+			    phy_duplex_to_str(link_state.duplex),
+			    phylink_pause_to_str(link_state.pause));
+	}
 }
=20
 static void phylink_mac_link_down(struct phylink *pl)
 {
 	struct net_device *ndev =3D pl->netdev;
+	struct phylink_notifier_info info =3D {
+		.link_an_mode =3D pl->link_an_mode,
+		.interface =3D pl->phy_state.interface,
+		.phydev =3D pl->phydev,
+	};
=20
-	netif_carrier_off(ndev);
-	pl->ops->mac_link_down(ndev, pl->link_an_mode,
+	if (pl->ops) {
+		netif_carrier_off(ndev);
+		pl->ops->mac_link_down(ndev, pl->link_an_mode,
 			       pl->phy_state.interface);
-	netdev_info(ndev, "Link is Down\n");
+		netdev_info(ndev, "Link is Down\n");
+	} else {
+		blocking_notifier_call_chain(&pl->notifier_chain,
+					     PHYLINK_MAC_LINK_DOWN, &info);
+		phydev_info(pl->phydev, "Link is Down\n");
+	}
 }
=20
 static void phylink_resolve(struct work_struct *w)
@@ -477,7 +548,10 @@ static void phylink_resolve(struct work_struct *w)
 		}
 	}
=20
-	if (link_state.link !=3D netif_carrier_ok(ndev)) {
+	/* Take the branch without checking the carrier status
+	 * if there is no netdevice.
+	 */
+	if (!pl->ops || link_state.link !=3D netif_carrier_ok(ndev)) {
 		if (!link_state.link)
 			phylink_mac_link_down(pl);
 		else
@@ -546,24 +620,12 @@ static int phylink_register_sfp(struct phylink *pl,
 	return 0;
 }
=20
-/**
- * phylink_create() - create a phylink instance
- * @ndev: a pointer to the &struct net_device
- * @fwnode: a pointer to a &struct fwnode_handle describing the network
- *	interface
- * @iface: the desired link mode defined by &typedef phy_interface_t
- * @ops: a pointer to a &struct phylink_mac_ops for the MAC.
- *
- * Create a new phylink instance, and parse the link parameters found in @=
np.
- * This will parse in-band modes, fixed-link or SFP configuration.
- *
- * Returns a pointer to a &struct phylink, or an error-pointer value. User=
s
- * must use IS_ERR() to check for errors from this function.
- */
-struct phylink *phylink_create(struct net_device *ndev,
-			       struct fwnode_handle *fwnode,
-			       phy_interface_t iface,
-			       const struct phylink_mac_ops *ops)
+static inline struct phylink *
+__phylink_create_raw(struct net_device *ndev,
+		     struct notifier_block *nb,
+		     struct fwnode_handle *fwnode,
+		     phy_interface_t iface,
+		     const struct phylink_mac_ops *ops)
 {
 	struct phylink *pl;
 	int ret;
@@ -574,7 +636,17 @@ struct phylink *phylink_create(struct net_device *ndev=
,
=20
 	mutex_init(&pl->state_mutex);
 	INIT_WORK(&pl->resolve, phylink_resolve);
-	pl->netdev =3D ndev;
+
+	if (ndev) {
+		pl->netdev =3D ndev;
+	} else if (nb) {
+		BLOCKING_INIT_NOTIFIER_HEAD(&pl->notifier_chain);
+		blocking_notifier_chain_register(&pl->notifier_chain, nb);
+		pl->nb =3D nb;
+	} else {
+		return ERR_PTR(-EINVAL);
+	}
+
 	pl->phy_state.interface =3D iface;
 	pl->link_interface =3D iface;
 	if (iface =3D=3D PHY_INTERFACE_MODE_MOCA)
@@ -616,8 +688,52 @@ struct phylink *phylink_create(struct net_device *ndev=
,
=20
 	return pl;
 }
+
+/**
+ * phylink_create() - create a phylink instance
+ * @ndev: a pointer to the &struct net_device
+ * @fwnode: a pointer to a &struct fwnode_handle describing the network
+ *	interface
+ * @iface: the desired link mode defined by &typedef phy_interface_t
+ * @ops: a pointer to a &struct phylink_mac_ops for the MAC.
+ *
+ * Create a new phylink instance, and parse the link parameters found in @=
np.
+ * This will parse in-band modes, fixed-link or SFP configuration.
+ *
+ * Returns a pointer to a &struct phylink, or an error-pointer value. User=
s
+ * must use IS_ERR() to check for errors from this function.
+ */
+struct phylink *phylink_create(struct net_device *ndev,
+			       struct fwnode_handle *fwnode,
+			       phy_interface_t iface,
+			       const struct phylink_mac_ops *ops)
+{
+	return __phylink_create_raw(ndev, NULL, fwnode, iface, ops);
+}
 EXPORT_SYMBOL_GPL(phylink_create);
=20
+/**
+ * phylink_create_raw() - create a raw phylink instance
+ * @nb: a pointer to a struct notifier_block which which will be called on
+ *	on phylink events
+ * @fwnode: a pointer to a &struct fwnode_handle describing the network
+ *	interface
+ * @iface: the desired link mode defined by &typedef phy_interface_t
+ *
+ * Create a new raw phylink instance, and parse the link parameters found =
in
+ * @np.  This will parse in-band modes, fixed-link or SFP configuration.
+ *
+ * Returns a pointer to a &struct phylink, or an error-pointer value. User=
s
+ * must use IS_ERR() to check for errors from this function.
+ */
+struct phylink *phylink_create_raw(struct notifier_block *nb,
+				   struct fwnode_handle *fwnode,
+				   phy_interface_t iface)
+{
+	return __phylink_create_raw(NULL, nb, fwnode, iface, NULL);
+}
+EXPORT_SYMBOL_GPL(phylink_create_raw);
+
 /**
  * phylink_destroy() - cleanup and destroy the phylink instance
  * @pl: a pointer to a &struct phylink returned from phylink_create()
@@ -909,7 +1025,8 @@ void phylink_start(struct phylink *pl)
 		    phy_modes(pl->link_config.interface));
=20
 	/* Always set the carrier off */
-	netif_carrier_off(pl->netdev);
+	if (pl->netdev)
+		netif_carrier_off(pl->netdev);
=20
 	/* Apply the link configuration to the MAC when starting. This allows
 	 * a fixed-link to start with the correct parameters, and also
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6411c624f63a..d171156eab4e 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -54,6 +54,24 @@ struct phylink_link_state {
 	unsigned int an_complete:1;
 };
=20
+enum phylink_cmd {
+	PHYLINK_VALIDATE =3D 1,
+	PHYLINK_MAC_LINK_STATE,
+	PHYLINK_MAC_AN_RESTART,
+	PHYLINK_MAC_CONFIG,
+	PHYLINK_MAC_LINK_DOWN,
+	PHYLINK_MAC_LINK_UP,
+	PHYLINK_GET_FIXED_STATE,
+};
+
+struct phylink_notifier_info {
+	struct phylink_link_state *state;
+	unsigned long *supported;
+	u8 link_an_mode;
+	phy_interface_t interface;
+	struct phy_device *phydev;
+};
+
 /**
  * struct phylink_mac_ops - MAC operations structure.
  * @validate: Validate and update the link configuration.
@@ -200,6 +218,9 @@ void mac_link_up(struct net_device *ndev, unsigned int =
mode,
=20
 struct phylink *phylink_create(struct net_device *, struct fwnode_handle *=
,
 	phy_interface_t iface, const struct phylink_mac_ops *ops);
+struct phylink *phylink_create_raw(struct notifier_block *nb,
+				   struct fwnode_handle *fwnode,
+				   phy_interface_t iface);
 void phylink_destroy(struct phylink *);
=20
 int phylink_connect_phy(struct phylink *, struct phy_device *);
--=20
2.21.0

