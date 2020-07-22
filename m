Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19310229010
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 07:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgGVFr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 01:47:56 -0400
Received: from mail-am6eur05on2078.outbound.protection.outlook.com ([40.107.22.78]:10592
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726696AbgGVFrz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 01:47:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9kW/Djg9D5PNkShtZK2KWHNJeH1+FXrPHKYec7yuWKlUfxxcqqtoH0iG1bNRziZ9pJk9lMXpstjJB248nqQieoViNgjj41NbsQP0rKg0oyiCac5lY9v0F+MI0Oa0F1dmrxjNdp9KHixFYV5fFaY1IEbobSMsy9lEfL9Gg2s/AunGuYsQxb20GOxOYc6PSYHwXLZaVQWTXDyAGTF5OpO4z/7lzKyv2FSN47rp/kqjX/4BBaqAJcl24rkX5lWXAnMwkZLcHdbzfqqmfY69OCj/LBD8jD2Em5Ba5w2lUUAdOChKql6nVX4otowiDDenvQrSr+z1V1NgW/fyOG50BuZ1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYWwqWPtvv7UD3rHyfAFJM2/UVBbRfO1quttY+Vu8Jc=;
 b=YLXkPZc5Pmn7k0mE9HqEvdYyGVCQHX7Lxzn1iJMRku58yPj0/hYfTw8y7ef+KDSYNRqk9lKue2Frbq/MITIqcpdMI5jqA85ok5oM/LIfvqdwk6xt7zRxDAHJeGtCX4iQgWj6LyoMKfIlXnol36ujFWR/L1KuSRJokEch/h8ay44jiWjSG3SI+4DkMX6ldOws7MmUQQiRMkguWSBdPwaMXtkbEWy5vfzJzt26S3BK37lFQST4R7jtCMJJkm31QD4uzfBkUZ7Q+t2mvrdviuq+QjWHVaAK+2wxcmfmRGm5+Ux6x5CHGm/KmXvxsy/uO0ftw54lF5C0TxJ09gYlQv/1tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYWwqWPtvv7UD3rHyfAFJM2/UVBbRfO1quttY+Vu8Jc=;
 b=SR4z5E0mvg/b1Jw8WiQ+6t+JG9Mgy/8AbA83V3jcae7tm2cJKz4eximcAkObROLHcwn/jY+MZv0a9blH1EvWk2yPNlazpphslBpnRFat8SPewXjmoHsv6VpiYAYtcptPOREGKlZefGiZnw11Z0TGHNGNJ4L3LRnwd8jTYRCJB18=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
 by VI1PR04MB5104.eurprd04.prod.outlook.com (2603:10a6:803:5a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Wed, 22 Jul
 2020 05:47:51 +0000
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7]) by VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7%2]) with mapi id 15.20.3216.022; Wed, 22 Jul 2020
 05:47:51 +0000
From:   hongbo.wang@nxp.com
To:     xiaoliang.yang_1@nxp.com, allan.nielsen@microchip.com,
        po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, linux-devel@linux.nxdi.nxp.com
Cc:     "hongbo.wang" <hongbo.wang@nxp.com>
Subject: [PATCH] net: dsa: ocelot: Add support for QinQ Operation
Date:   Wed, 22 Jul 2020 13:50:48 +0800
Message-Id: <20200722055048.6129-1-hongbo.wang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0207.apcprd06.prod.outlook.com
 (2603:1096:4:68::15) To VI1PR04MB5103.eurprd04.prod.outlook.com
 (2603:10a6:803:51::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from whb-OptiPlex-790.ap.freescale.net (119.31.174.73) by SG2PR06CA0207.apcprd06.prod.outlook.com (2603:1096:4:68::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Wed, 22 Jul 2020 05:47:43 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 43688d52-fa06-4f65-3dae-08d82e02c534
X-MS-TrafficTypeDiagnostic: VI1PR04MB5104:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB51046079FF8BBBE7822A0211E1790@VI1PR04MB5104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pXYTQbR/ARbMDrNM9VTIHQcy+loJU/YeivNQYzoEWPjfmMnBUItG5V8bBWYpgopOrQXytcq/mWrOKNbu+syHLTrLV0pT6JoqRHet3+ZhOxrH63bYSxQD2VjOTMqSXXEWUJrpWjZEAerZI1aWITywTSLslpyEJh23HpMkJo0FpRINi9KM5r/f0xoKi23bSaVHf182kpUEf1flGHKAuGm8KmmyjKxIqxKheeo3G3Kpz6muNE0iw25RRbD+BORxB7BZBiE+InLYIbW/21zCt3y2TFz8odG2PKbeOVQtGq/SPP3xmG/RWZNDJlFfuzC1FuN3veeLkMzsH+nQLDK0JAM54Dj42cuzbcEAHjP85AnokrlBY+yaXUIRpEmSSVTnuMne
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5103.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(2616005)(956004)(6506007)(36756003)(26005)(1076003)(8676002)(86362001)(186003)(16526019)(4326008)(83380400001)(8936002)(66476007)(66946007)(66556008)(6512007)(9686003)(6486002)(5660300002)(7416002)(478600001)(2906002)(52116002)(316002)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cfWVFmSfiFF0ZDW+PexLDwr/0C+Gpw+mJGxx8iKy/9Xy11JUyVzbxY4f6XPmX3rqvU7Ky1Pjj0noWWloiPijpUkehZZagi+R+tbsuvPZZXKVCb/jn+/dOXqnYAFv+ZWKeXQGg+QXt8eXUrDl6GQRvNhPQUqaJoAwifc9NvY84Fm7JIAOyRpJd1zQxhR+BD/QfrnFQ7P0dsNRPI/+d1jArTvb2K/VJ5lmpsYiZI3K0DobveFQeiRj8atzHDC0lQfd3lGDfhR1+EjIElFwyWn4WKurpleAoCWpjurPhytpNvAAodEjYvm++cKSE2iBIQCItROHBVZRg0eOSogEDGHFLT28r4Y5nEantS1Ku7M81MVslu/deZWLub4/yPSF/EHa1vJdaltod+ZNPWnijjiHbca3d9tcU/KN9ZHco6rDl/ossbOl0CZcmUHluWLr2FMOXiUv7lNiq7OuQryL1klb8D4zcN2z+LwJ/xsO3AhN2MU=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43688d52-fa06-4f65-3dae-08d82e02c534
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5103.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2020 05:47:50.9960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9N0I2jsS8jT6Bo8kFk8KdwPLr6XzCuQJxuz2xFJpdu4DbEU3hMi7oHdmG5nh9W9xd8R7TsCiQO+wWRNi2V/HBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5104
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "hongbo.wang" <hongbo.wang@nxp.com>

This featue can be test using network test tools
    TX-tool -----> swp0  -----> swp1 -----> RX-tool

TX-tool simulates Customer that will send and receive packets with single
VLAN tag(CTAG), RX-tool simulates Service-Provider that will send and
receive packets with double VLAN tag(STAG and CTAG). This refers to
"4.3.3 Provider Bridges and Q-in-Q Operation" in VSC99599_1_00_TS.pdf.

The related test commands:
1.
ip link add dev br0 type bridge
ip link set dev swp0 master br0
ip link set dev swp1 master br0
2.
ip link add link swp0 name swp0.111 type vlan id 111
ip link add link swp1 name swp1.111 type vlan protocol 802.1ad id 111
3.
bridge vlan add dev swp0 vid 100 pvid
bridge vlan add dev swp1 vid 100
bridge vlan del dev swp1 vid 1 pvid
bridge vlan add dev swp1 vid 200 pvid untagged
Result:
Customer(tpid:8100 vid:111) -> swp0 -> swp1 -> Service-Provider(STAG \
                    tpid:88A8 vid:100, CTAG tpid:8100 vid:111)

Signed-off-by: hongbo.wang <hongbo.wang@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c     |  8 ++++++
 drivers/net/ethernet/mscc/ocelot.c | 44 ++++++++++++++++++++++++------
 include/soc/mscc/ocelot.h          |  1 +
 3 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index c69d9592a2b7..12b46cb6549c 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -132,9 +132,13 @@ static void felix_vlan_add(struct dsa_switch *ds, int port,
 {
 	struct ocelot *ocelot = ds->priv;
 	u16 flags = vlan->flags;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u16 vid;
 	int err;
 
+	if (vlan->proto == ETH_P_8021AD)
+		ocelot_port->qinq_mode = true;
+
 	if (dsa_is_cpu_port(ds, port))
 		flags &= ~BRIDGE_VLAN_INFO_UNTAGGED;
 
@@ -154,9 +158,13 @@ static int felix_vlan_del(struct dsa_switch *ds, int port,
 			  const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u16 vid;
 	int err;
 
+	if (vlan->proto == ETH_P_8021AD)
+		ocelot_port->qinq_mode = false;
+
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
 		err = ocelot_vlan_del(ocelot, port, vid);
 		if (err) {
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index f2d94b026d88..621277e875a5 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -144,6 +144,8 @@ static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u32 val = 0;
+	u32 tag_tpid = 0;
+	u32 port_tpid = 0;
 
 	if (ocelot_port->vid != vid) {
 		/* Always permit deleting the native VLAN (vid = 0) */
@@ -156,8 +158,14 @@ static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 		ocelot_port->vid = vid;
 	}
 
-	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_VID(vid),
-		       REW_PORT_VLAN_CFG_PORT_VID_M,
+	if (ocelot_port->qinq_mode)
+		port_tpid = REW_PORT_VLAN_CFG_PORT_TPID(ETH_P_8021AD);
+	else
+		port_tpid = REW_PORT_VLAN_CFG_PORT_TPID(ETH_P_8021Q);
+
+	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_VID(vid) | port_tpid,
+		       REW_PORT_VLAN_CFG_PORT_VID_M |
+		       REW_PORT_VLAN_CFG_PORT_TPID_M,
 		       REW_PORT_VLAN_CFG, port);
 
 	if (ocelot_port->vlan_aware && !ocelot_port->vid)
@@ -180,12 +188,28 @@ static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 		else
 			/* Tag all frames */
 			val = REW_TAG_CFG_TAG_CFG(3);
+
+		if (ocelot_port->qinq_mode)
+			tag_tpid = REW_TAG_CFG_TAG_TPID_CFG(1);
+		else
+			tag_tpid = REW_TAG_CFG_TAG_TPID_CFG(0);
 	} else {
-		/* Port tagging disabled. */
-		val = REW_TAG_CFG_TAG_CFG(0);
+		if (ocelot_port->qinq_mode) {
+			if (ocelot_port->vid)
+				val = REW_TAG_CFG_TAG_CFG(1);
+			else
+				val = REW_TAG_CFG_TAG_CFG(3);
+
+			tag_tpid = REW_TAG_CFG_TAG_TPID_CFG(1);
+		} else {
+			/* Port tagging disabled. */
+			val = REW_TAG_CFG_TAG_CFG(0);
+			tag_tpid = REW_TAG_CFG_TAG_TPID_CFG(0);
+		}
 	}
-	ocelot_rmw_gix(ocelot, val,
-		       REW_TAG_CFG_TAG_CFG_M,
+
+	ocelot_rmw_gix(ocelot, val | tag_tpid,
+		       REW_TAG_CFG_TAG_CFG_M | REW_TAG_CFG_TAG_TPID_CFG_M,
 		       REW_TAG_CFG, port);
 
 	return 0;
@@ -216,11 +240,15 @@ EXPORT_SYMBOL(ocelot_port_vlan_filtering);
 /* Default vlan to clasify for untagged frames (may be zero) */
 static void ocelot_port_set_pvid(struct ocelot *ocelot, int port, u16 pvid)
 {
+	u32 tag_type = 0;
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
+	if (ocelot_port->qinq_mode)
+		tag_type = ANA_PORT_VLAN_CFG_VLAN_TAG_TYPE;
+
 	ocelot_rmw_gix(ocelot,
-		       ANA_PORT_VLAN_CFG_VLAN_VID(pvid),
-		       ANA_PORT_VLAN_CFG_VLAN_VID_M,
+		       ANA_PORT_VLAN_CFG_VLAN_VID(pvid) | tag_type,
+		       ANA_PORT_VLAN_CFG_VLAN_VID_M | tag_type,
 		       ANA_PORT_VLAN_CFG, port);
 
 	ocelot_port->pvid = pvid;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index da369b12005f..cc394740078e 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -556,6 +556,7 @@ struct ocelot_port {
 	struct regmap			*target;
 
 	bool				vlan_aware;
+	bool				qinq_mode;
 
 	/* Ingress default VLAN (pvid) */
 	u16				pvid;
-- 
2.17.1

