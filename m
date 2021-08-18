Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F60F3F033C
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbhHRMGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:06:09 -0400
Received: from mail-vi1eur05on2074.outbound.protection.outlook.com ([40.107.21.74]:54881
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235979AbhHRMD5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:03:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQEDaNK8UlqR3fGkpNwuKr3/CGjL7CLQjJcoMUdTde7QKZE2JOt0KINDSBto9khX/txQ9oWb92QElafAPNFfrVRIl+cZSuqU7ah9a89JNb/oWMC3/SAqatwvud+ymryn/RNs9O1sJgO4s9j8fbXd7+ppaMpqBwAZfQKFcFEPDmrGkdmrKOBHKgXdvEQPFNdWkI55ibrYRfX9Y/hrmU56rBuR/f9SLZtBLMLInnb9ftZNkwV/DMFgQZv+sWUnTZNlgsw9jysprqb5VBKziP49OPPkbgMC9nI1jr0yQPERBkh57ZC24Qzi0SO5dffscVhZmXYI9vRhV41DUIX6/e34FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3WQCwH5GbFPvs5E2VGIWrR+dDYLsA6Qori/cPxi4Lqo=;
 b=crY2ccXAEJNfsuDESqKVIWwIiweIMEwRn3So4HPvCXb2rSzI9z2K70GpwOq1NdmMivSFgIyP0X7hc0iGkanHdhlh9te62Hdnh0Rl9MYLLXnZlJ7zREFxKfvkVWcyw4w33k7iPC6+F+ycp8PBbwkyqhSjATZIxyrSkzMlKh1LtTTRyBE8N4XhH5gWuDMmwkFkyJcquSplVb2egTT/8HkRjHN8DLL0TBdjmNOynNeROM+IZjA2GR5jUH8FVkQfXItkyCxuzzDzUqEIKzwSeBBgFw2xo963avp56ENYxMdlFj4ZWp2Yo9ZV2Uq01RWq7FuPIvOvQqbiyrdO13hzRtD43g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3WQCwH5GbFPvs5E2VGIWrR+dDYLsA6Qori/cPxi4Lqo=;
 b=qIkmTYrt5wdO94G6kPQgFsFRL6huGM1rx+4kuzXV9el+Ze6SjbHiJFNfHfG6KmO2B6hzGjxpP4Vhv3XzTN91nUOAa4WHPfrJSZEwOz3rn/YlEvebeZXg3aOvm6Rle7TpAf2SbpHM9dMEzRU2p3b7wc+vsUS9ycZMShUtrSB6arc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Wed, 18 Aug
 2021 12:03:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:03:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [RFC PATCH net-next 17/20] net: mscc: ocelot: transmit the "native VLAN" error via extack
Date:   Wed, 18 Aug 2021 15:01:47 +0300
Message-Id: <20210818120150.892647-18-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210818120150.892647-1-vladimir.oltean@nxp.com>
References: <20210818120150.892647-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0134.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:03:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aee6f6a7-3ad7-4cfa-a952-08d962402828
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB42224C1AE619856E3CDDA39AE0FF9@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1x0rOXuaNSjATNW91O1Xcw2ftV75uMjcpS6EPVWdfqd2lA5N2UEfo422ynrosueej1Hr37bBt5jjZTTvvL5NskdcC17UtHaIf04Qv6ILjTlZ1FrWPRrDkOXmjnetmN1AtbAMAdKpHYtONX5aV25sILOCHgD74d9blafy8KWA4s9FPEsEx8ZFPRq9Ebpe0r/fDeUyqGzKXMrkQAkaNRCVFi8vFH4GIU4gu7zX/i4fCfDddPpsAOPiKVSdZT0GXcxrB8zBI3yvb+Q1RKeDHcNLFlqFWOMf1/om3H+vc8tGfFvE+QjofAvWncBe7JaGJgGdO8U+UK1B50qpFfw03TLtq3GZlNjdGrKKURFRvyx0Ebt6BL316JH6JrZkPBV2/rPpUS5JxbXUjf5Ba6U8INYL2ZhkwekN5Tsl46kckC49Ns0jJ6qiNcsq4+Bnkqu32RnBz/bivTw+BdCCWVj732Xne/DMTAwbhO89ilzbG39Qw/tIHjPaYq43h2zS9/HeOWMvRRXRchM9Y5e6RLkZ6Nj25H/y7+BPheqCA4sbRiT+zfHeIqPPQzN6gXg/WIZjf5vtT6rpZYErbPmsjikM/08Sm/UlzrAbeeTu4mk/u0FHLfVb8YGA93GaoKDY+fnhx4EwrYhzOCSVCLOo2aFx7FlFx7GqN3qFqCOUIjsUQAduXUMA+lrOQWicxTf7m8Q0hgjS9LSlBFJrZARfvpJZySNopg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(366004)(376002)(6486002)(52116002)(2616005)(44832011)(4326008)(5660300002)(26005)(1076003)(6666004)(54906003)(956004)(6512007)(6506007)(186003)(38350700002)(38100700002)(86362001)(36756003)(110136005)(316002)(83380400001)(8936002)(478600001)(8676002)(66476007)(7416002)(7406005)(66946007)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vkm6QxaSYXwxHB/zZmsAxqI3hyAYaYm0E0ld/OZuoHf7X0IhDLtpRNzIvbNp?=
 =?us-ascii?Q?3jez7j8zSc/CkI6ARDOWVqrcBJZiR3CjJ2CKJS4Yx8ms1PmdCXNd9t2MEx9n?=
 =?us-ascii?Q?ITbvjQpfGlSYzbsPw6LKei2T7HXpw4hyoXHjvTjpHBgz5xZ8RnhpU1x+vLXu?=
 =?us-ascii?Q?q4BV6J9mT9Uu981zHsGwwS52+rJ1Bsx383u0QQNTJsDApXcnWsJKOcPVnHAB?=
 =?us-ascii?Q?NfZQD/OsIy6L7YKmn22qXG9pTz73aDN/lwoOJ3aEbfMA7oZdJMX4d//9QtdN?=
 =?us-ascii?Q?jFmCxf++mytxKUvY/Tp48tkXgbF//hEHzwoOmfu9eONajUpd3dhrE/p5yZcE?=
 =?us-ascii?Q?bIu7YkJKNj1lQAx1YP5H0qKM18+9KNQ8aoRDZQkD+MokwUOHyXnNlGxyrd3l?=
 =?us-ascii?Q?6IdgiS8duaczkdAKaqvUnHOtGHghlt9wd6UsBO541A2V3K7Cefm2HT2MFjz4?=
 =?us-ascii?Q?cT2z3dprWvFL+c/C00s8ynSqYVeRzAX9gv6RJUvQAE3C+eOy9M5tUAsUJ72U?=
 =?us-ascii?Q?BFnm2/2CXFeXQj3dubrz11+7pXlTWX4h1XiY/d2vJ69jhkLBQXQ0wTzLkMDL?=
 =?us-ascii?Q?Vs2ivm4ANVrhHyzkTKoctMexi2Ak/+vTCuXD5sdoG79ErVC+dJVBnWzcrxK8?=
 =?us-ascii?Q?9P5ioBjTSUvmZz8JGr94kUKobcl49B8ciJWS1VwRJHeezDSL3uyHLQN40LA7?=
 =?us-ascii?Q?ov0ONSIGqxbdOTu7Skyjiq8cvzd/swWF2o/0a1Myk1iGMw8NR8rqk09HJ7NG?=
 =?us-ascii?Q?FaVMkbJULtaQ/VKxV/7W26mRDr6J/DICSNLMc0gdODKLu+oP/gQ0jpThsinT?=
 =?us-ascii?Q?3KhI2kIo69XkRzEzs5ozvnJq+5/R740ueqIyvASRZYcINA9bpL48ycl1Qlg2?=
 =?us-ascii?Q?rzHRnMaKD/5sM6kYpgx+aCDJ0bRCW8vz5BfrPKI1DJeLd+LLUKw2woRIvKD/?=
 =?us-ascii?Q?I5A9qwXVtBtzhLBCkHd/Esn6NLq2oQvXRp6T13tUG2MsAOq8S8rGiQBTK7pi?=
 =?us-ascii?Q?9DooDgNmJiKqglOnC2rS2FeJxeZL8Z1JSn1KKdIfYGKvIplJs9Y6+HZuMMJM?=
 =?us-ascii?Q?Mq/cCpshRaF5LZGUKPSsfb1WKM0/HTy5C/iYAbr6K0XT3vXBzlYI71GFV3Ai?=
 =?us-ascii?Q?AzMUC1NauYtA8x4De7FAdrswT6bigH+EyRJlfDoDc5pbe/EE6HXXpOg21jaI?=
 =?us-ascii?Q?Hny7NrTcn1PcXaRWja0nF7kSs+Tx335UL9ziPs01CWyPikH39bDNec+gncDs?=
 =?us-ascii?Q?MrePG2kpdXivUL6lVuCVGMYeqVbK91mCVMqXpVBZ/hDrv6Jbxjd1FRElJMjN?=
 =?us-ascii?Q?wst4rDTCS8XRQbx442lbTOaU?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aee6f6a7-3ad7-4cfa-a952-08d962402828
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:03:14.3076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: waFRrkcPU65M/yRdgvFpHNS48wTlSSxJd9k7Z9F2/jlfUvd2vTq+nqlEEFNVl7ZqkAttFnKnms9mK6NzpmWUSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to reject some more configurations in future patches, convert
the existing one to netlink extack.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         |  8 ++++---
 drivers/net/ethernet/mscc/ocelot.c     |  7 +++---
 drivers/net/ethernet/mscc/ocelot_net.c | 30 ++++++++++++++------------
 include/soc/mscc/ocelot.h              |  2 +-
 4 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index e764d8646d0b..0b3f7345d13d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -740,7 +740,8 @@ static int felix_lag_change(struct dsa_switch *ds, int port)
 }
 
 static int felix_vlan_prepare(struct dsa_switch *ds, int port,
-			      const struct switchdev_obj_port_vlan *vlan)
+			      const struct switchdev_obj_port_vlan *vlan,
+			      struct netlink_ext_ack *extack)
 {
 	struct ocelot *ocelot = ds->priv;
 	u16 flags = vlan->flags;
@@ -758,7 +759,8 @@ static int felix_vlan_prepare(struct dsa_switch *ds, int port,
 
 	return ocelot_vlan_prepare(ocelot, port, vlan->vid,
 				   flags & BRIDGE_VLAN_INFO_PVID,
-				   flags & BRIDGE_VLAN_INFO_UNTAGGED);
+				   flags & BRIDGE_VLAN_INFO_UNTAGGED,
+				   extack);
 }
 
 static int felix_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
@@ -777,7 +779,7 @@ static int felix_vlan_add(struct dsa_switch *ds, int port,
 	u16 flags = vlan->flags;
 	int err;
 
-	err = felix_vlan_prepare(ds, port, vlan);
+	err = felix_vlan_prepare(ds, port, vlan, extack);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 8ec194178aa2..ccb8a9863890 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -259,16 +259,15 @@ int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 EXPORT_SYMBOL(ocelot_port_vlan_filtering);
 
 int ocelot_vlan_prepare(struct ocelot *ocelot, int port, u16 vid, bool pvid,
-			bool untagged)
+			bool untagged, struct netlink_ext_ack *extack)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
 	/* Deny changing the native VLAN, but always permit deleting it */
 	if (untagged && ocelot_port->native_vlan.vid != vid &&
 	    ocelot_port->native_vlan.valid) {
-		dev_err(ocelot->dev,
-			"Port already has a native VLAN: %d\n",
-			ocelot_port->native_vlan.vid);
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port already has a native VLAN");
 		return -EBUSY;
 	}
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 04ca55ff0fd0..133634852ecf 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -385,17 +385,6 @@ static int ocelot_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	return 0;
 }
 
-static int ocelot_vlan_vid_prepare(struct net_device *dev, u16 vid, bool pvid,
-				   bool untagged)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot_port *ocelot_port = &priv->port;
-	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
-
-	return ocelot_vlan_prepare(ocelot, port, vid, pvid, untagged);
-}
-
 static int ocelot_vlan_vid_add(struct net_device *dev, u16 vid, bool pvid,
 			       bool untagged)
 {
@@ -943,14 +932,26 @@ static int ocelot_port_attr_set(struct net_device *dev, const void *ctx,
 	return err;
 }
 
+static int ocelot_vlan_vid_prepare(struct net_device *dev, u16 vid, bool pvid,
+				   bool untagged, struct netlink_ext_ack *extack)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = priv->chip_port;
+
+	return ocelot_vlan_prepare(ocelot, port, vid, pvid, untagged, extack);
+}
+
 static int ocelot_port_obj_add_vlan(struct net_device *dev,
-				    const struct switchdev_obj_port_vlan *vlan)
+				    const struct switchdev_obj_port_vlan *vlan,
+				    struct netlink_ext_ack *extack)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	int ret;
 
-	ret = ocelot_vlan_vid_prepare(dev, vlan->vid, pvid, untagged);
+	ret = ocelot_vlan_vid_prepare(dev, vlan->vid, pvid, untagged, extack);
 	if (ret)
 		return ret;
 
@@ -1038,7 +1039,8 @@ static int ocelot_port_obj_add(struct net_device *dev, const void *ctx,
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		ret = ocelot_port_obj_add_vlan(dev,
-					       SWITCHDEV_OBJ_PORT_VLAN(obj));
+					       SWITCHDEV_OBJ_PORT_VLAN(obj),
+					       extack);
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 		ret = ocelot_port_obj_add_mdb(dev, SWITCHDEV_OBJ_PORT_MDB(obj));
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index fb5681f7e61b..ac072303dadf 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -825,7 +825,7 @@ int ocelot_fdb_add(struct ocelot *ocelot, int port,
 int ocelot_fdb_del(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid);
 int ocelot_vlan_prepare(struct ocelot *ocelot, int port, u16 vid, bool pvid,
-			bool untagged);
+			bool untagged, struct netlink_ext_ack *extack);
 int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 		    bool untagged);
 int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid);
-- 
2.25.1

