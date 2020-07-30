Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68DF233040
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 12:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgG3KWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 06:22:39 -0400
Received: from mail-eopbgr60041.outbound.protection.outlook.com ([40.107.6.41]:55650
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728946AbgG3KWc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 06:22:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=armaY5I4ahA1TPlFg9riNIHzJJHBOuPI1nnGxa76befnXbGAXSnsKxm1jsnKGfgrCUaJr0w7Qy9NEXefp8RHQjlfXLSoqfbAPD6cOPNtvktY2E3b5m8+DLQiqIzEWtfQy7DErhpKGc9NDfv7EnUQLxoOSxyvb7vSvBDVl2SJeYUHFsWA/hTZmXUDzPfdxeip2mnuhNUxjlJJysnqNBSrODjFf4A0K61r58A55JhmTXvcAC+Tc2Ip6EHlEm0/Ed7zRLY0QuUDRoMV3LDVyTP3SddDuPC1V1/cGok/hT/dQQjdf7Ia4JO9L2OoI+4O4OOFPKHvnoitqTO+ApYjXJSvBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NjWV5GZ1V83jI03cmxsnzqx1fXPLmeGEyHTjd4//7Dk=;
 b=Bi3oi/VgKj6eAPU2qDldiFKwFJXQ8cg8qsPxxCUCoGTEEf8JLg5vctWIDmgB1YHZbk49qrr68AyykWUUJiVRVy1QK98tysuSgdv4r/N80CcNxCEPk3IA0gJfsFZvwNV6gMkyHgBXHq/2txP12HHf2dF1DtD49zD2Dbdb9GbKpKkPaSgXDzyVAg69cKWrEKxwoNjwDc61/gtl1JP0GVQepEVKHtl63SaKUhX+pZuHbXA+glrclP8HilOB+tP/H5guuIdQrflK+mGQISIOBRUMXuwDKUpAcHnEx3bFstBwRLWatzmamvW4oRm5bZ3qx6nyP3hmXGlrRkP6d/f0MkGADw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NjWV5GZ1V83jI03cmxsnzqx1fXPLmeGEyHTjd4//7Dk=;
 b=HM+3wIaPuBphnPYiTzuB0K9tUnbK8MQfNdK0O71VJToWi/9QNy0iVCGDXG+7eFemBvj1saol+IVyT9//GmXdwQjw8GYgYO/RfPXpFV9ybKWX1jpxfNtcw3EikCjR2jUXy7REwzvBKV5vwfH2odA1bf4nhLM2+mP/gbediYkwHnU=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from DB7PR04MB5099.eurprd04.prod.outlook.com (2603:10a6:10:18::30)
 by DB8PR04MB6924.eurprd04.prod.outlook.com (2603:10a6:10:11e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Thu, 30 Jul
 2020 10:22:27 +0000
Received: from DB7PR04MB5099.eurprd04.prod.outlook.com
 ([fe80::f801:51e:28:f2a3]) by DB7PR04MB5099.eurprd04.prod.outlook.com
 ([fe80::f801:51e:28:f2a3%4]) with mapi id 15.20.3239.019; Thu, 30 Jul 2020
 10:22:27 +0000
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
        UNGLinuxDriver@microchip.com, ivecera@redhat.com
Cc:     "hongbo.wang" <hongbo.wang@nxp.com>
Subject: [PATCH v4 2/2] net: dsa: ocelot: Add support for QinQ Operation
Date:   Thu, 30 Jul 2020 18:25:05 +0800
Message-Id: <20200730102505.27039-3-hongbo.wang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200730102505.27039-1-hongbo.wang@nxp.com>
References: <20200730102505.27039-1-hongbo.wang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0019.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::31)
 To DB7PR04MB5099.eurprd04.prod.outlook.com (2603:10a6:10:18::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from whb-OptiPlex-790.ap.freescale.net (119.31.174.73) by SGBP274CA0019.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Thu, 30 Jul 2020 10:22:20 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 25233653-1eb7-4ae9-cd79-08d83472757a
X-MS-TrafficTypeDiagnostic: DB8PR04MB6924:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB69244277350173899307EE43E1710@DB8PR04MB6924.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mvixJ9JcC2w3c0ai02REm/4fwAS1Fja6TeoeNvg4R6R9G16Flsy/UVKrQLqrcb/zJ9K0l5ddd1x3ujWzVhOhtRbjmO2xyYJ/e9e4axDa20S4zhhi/QcWOIGWxIdyw2d3kyRnS77bQLkqsdQ301Ai3RT45g32h37BU4ikZNmt6FYcqVSzbI4ovfK4Dqxk9RwPNiIlrcbjml1t2LY4Oqv0h+MM7QV77fa/xQ4yaa92Sidkp/4o8zfr52NrYrqm2DI+McyatqRlMSEzu1PFYhv9ahhfQyhNT+FYg7Qo1vsueo0yyYfGn4xGUDzqByS2SeCyrNMBvjvEZFSUYPJV2L1jsY+rphnQ6y/6VZmsIRsL38Mjwg5Rzp/QaceNpLoXTLTM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5099.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(2906002)(83380400001)(36756003)(66476007)(66946007)(4326008)(6666004)(66556008)(6486002)(7416002)(52116002)(8676002)(316002)(86362001)(6506007)(6512007)(9686003)(1076003)(26005)(2616005)(956004)(478600001)(186003)(5660300002)(8936002)(16526019)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: r3j+YGbGc4CtzTIvRbTinNxL1q1n6G2jFl8AvkajbK81EyFY95b2lziElwEy2qmoc8HJEJtMewWBVAB0oxX26oMrjUW5C5XYdiM1k7Dq1Fnk4WvRQcpv3LJ8nVnyJM7i1ZWxMvdgXLeI14GkLRVzElCVso/B0U0U0GrcdSjBF9R8dY8muApuQvDO/iDQIg0atlfZfQ7w+nSj5gWy4LrJx6BHch185JAgqwSsj02/n6Z9o4MlnkGv1CzKo9paAGzIuiNWra4e606XauTFU+Jnn0cZ/npVCcFT1tzzxql1Rbaob74Nr9Es02vkH2M3CS422/+cag6/h7/sUEloVbxuzsIi1IEp/gdK6YMWbP/5Is5hkDOleVLbhuqxgLC9I0JeSNUaO44XbP5AvAt97jjN6MnCajOZF9Jb0zypvYmdolWOv7pp7aMgEq/8v78lihZwQt1/P74WlDpZyhBcalFtpetF4gxWYjMT7rPoevxlsVfl0nq/b3jhmwYPapj6Sqlb8s4NnDzqfkLFK7ZfknVGke6R6P0+D4PNGlmYrwmYHmVUYNZf/YWHsKOgsUhdnWpHvAjFtN+tFhdd3dFpy+lZrybOXPnzPgdv5bWOTgf6D41KnlfIgQNxb56uhLPimiHVUjGQ2vJ7a2Ovqjcs9PObug==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25233653-1eb7-4ae9-cd79-08d83472757a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5099.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 10:22:27.7462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4aaOPbEIFTuo0zxqbfBqqzmpKItoBndg7WrZAgtL3YMLoGNFRubYengyq92/NbxBE84mZbJmsiMG8tE9nA6C9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6924
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
ip link set dev swp1 master br0
ip link set br0 type bridge vlan_protocol 802.1ad
ip link set dev swp0 master br0

2.
ip link set dev br0 type bridge vlan_filtering 1
bridge vlan add dev swp0 vid 100 pvid
bridge vlan add dev swp1 vid 100
Result:
Customer(tpid:8100 vid:111) -> swp0 -> swp1 -> ISP(STAG \
                tpid:88A8 vid:100, CTAG tpid:8100 vid:111)

3.
bridge vlan del dev swp0 vid 1 pvid
bridge vlan add dev swp0 vid 100 pvid untagged
Result:
ISP(tpid:88A8 vid:100 tpid:8100 vid:222) -> swp1 -> swp0 ->\
		Customer(tpid:8100 vid:222)

Signed-off-by: hongbo.wang <hongbo.wang@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c     | 12 +++++++
 drivers/net/ethernet/mscc/ocelot.c | 53 +++++++++++++++++++++++++-----
 include/soc/mscc/ocelot.h          |  2 ++
 3 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index c69d9592a2b7..72a27b61080e 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -131,10 +131,16 @@ static void felix_vlan_add(struct dsa_switch *ds, int port,
 			   const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u16 flags = vlan->flags;
 	u16 vid;
 	int err;
 
+	if (vlan->proto == ETH_P_8021AD) {
+		ocelot->enable_qinq = true;
+		ocelot_port->qinq_mode = true;
+	}
+
 	if (dsa_is_cpu_port(ds, port))
 		flags &= ~BRIDGE_VLAN_INFO_UNTAGGED;
 
@@ -154,9 +160,15 @@ static int felix_vlan_del(struct dsa_switch *ds, int port,
 			  const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u16 vid;
 	int err;
 
+	if (vlan->proto == ETH_P_8021AD) {
+		ocelot->enable_qinq = false;
+		ocelot_port->qinq_mode = false;
+	}
+
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
 		err = ocelot_vlan_del(ocelot, port, vid);
 		if (err) {
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index f2d94b026d88..b5fec6855afd 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -143,6 +143,8 @@ static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 				       u16 vid)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	u32 port_tpid = 0;
+	u32 tag_tpid = 0;
 	u32 val = 0;
 
 	if (ocelot_port->vid != vid) {
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
@@ -204,6 +228,15 @@ void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 		      ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1);
 	else
 		val = 0;
+
+	/* if switch is enabled for QinQ, the port for LAN should set
+	 * VLAN_CFG.VLAN_POP_CNT=0 && VLAN_CFG.VLAN_AWARE_ENA=0.
+	 * the port for MAN should set VLAN_CFG.VLAN_POP_CNT=1 &&
+	 * VLAN_CFG.VLAN_AWARE_ENA=1. referring to 4.3.3 in VSC9959_1_00_TS.pdf
+	 */
+	if (ocelot->enable_qinq && !ocelot_port->qinq_mode)
+		val = 0;
+
 	ocelot_rmw_gix(ocelot, val,
 		       ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
 		       ANA_PORT_VLAN_CFG_VLAN_POP_CNT_M,
@@ -217,10 +250,14 @@ EXPORT_SYMBOL(ocelot_port_vlan_filtering);
 static void ocelot_port_set_pvid(struct ocelot *ocelot, int port, u16 pvid)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	u32 tag_type = 0;
+
+	if (ocelot_port->qinq_mode)
+		tag_type = ANA_PORT_VLAN_CFG_VLAN_TAG_TYPE;
 
 	ocelot_rmw_gix(ocelot,
-		       ANA_PORT_VLAN_CFG_VLAN_VID(pvid),
-		       ANA_PORT_VLAN_CFG_VLAN_VID_M,
+		       ANA_PORT_VLAN_CFG_VLAN_VID(pvid) | tag_type,
+		       ANA_PORT_VLAN_CFG_VLAN_VID_M | tag_type,
 		       ANA_PORT_VLAN_CFG, port);
 
 	ocelot_port->pvid = pvid;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index da369b12005f..59020bb8fe68 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -556,6 +556,7 @@ struct ocelot_port {
 	struct regmap			*target;
 
 	bool				vlan_aware;
+	bool				qinq_mode;
 
 	/* Ingress default VLAN (pvid) */
 	u16				pvid;
@@ -632,6 +633,7 @@ struct ocelot {
 	/* Protects the PTP clock */
 	spinlock_t			ptp_clock_lock;
 	struct ptp_pin_desc		ptp_pins[OCELOT_PTP_PINS_NUM];
+	bool				enable_qinq;
 };
 
 struct ocelot_policer {
-- 
2.17.1

