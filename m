Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0F0229610
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732177AbgGVK3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:29:21 -0400
Received: from mail-eopbgr50064.outbound.protection.outlook.com ([40.107.5.64]:47332
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730296AbgGVK3T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 06:29:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FikTcYS22f8jEf2Bsy775cHJk5qmP6qnQ12ptC+j17WTz7XTyVUTgquUgIcQ3n29Zfqq9cuhihyAuUG15D/wourkMqDgmjDlVYQbLNecB//n4YumNgRQ6UX7mNmCgcdYoMpdeWIpp/wLRrqlGuvLkBE2UOmsu5r7GDbE47kWKVd+hfK9Ey2uX9p98Qm0sTJLCQUF7fbbkfPSQSXc+od//kLmhMn1SxCBIseynIaJ9Q1WpEfYj095P3/6aZXYQyIAb9J7zopxgOYr9IUaYTwGDawcDGu2RLq5w4YZqanXvrV4gLSPgQ5iGe4476LbKYY0sVvDpeWSlC990ssg2ZRNgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYWwqWPtvv7UD3rHyfAFJM2/UVBbRfO1quttY+Vu8Jc=;
 b=OOsiLudkJsRGOZNigBKc5ViaoWkiPwwO9exr4AzzPUMJ6iZkTVsdIqcfAExACN7MXUbUUupx40Cps5QCyBjfR8/vqnRYT9DOU5YIAGaftxzRPOI41x5hFjq+l5FNUbCGGZL/hUw60pzFwT5jfvX/wMTeamBK2rrfxniRB7Ahm/VIXVe6aOQpjf0V6r0i72Jl1Cnc3eMMEpXYmaLFnELzwjnIyjtDo4CjDf9TSy02LEps6gFuBmG3P5fYBDPzD9Rhlfl4VquZM1Nb/YyMXe9kmLozBnx59b0xgV7qwnwFPe/xuvenLJc1Q3779iptirGZbcCtZQUPoKIlGhLHiZdjOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYWwqWPtvv7UD3rHyfAFJM2/UVBbRfO1quttY+Vu8Jc=;
 b=LHtAoZ0GaOXbOEpj1sCBQgGnhixrFU5f0yOcLqajI5KxzsOZvOP8cS+7TT8dKLfJtw0JtsXQKLUvY8AQRsrY+7JedWOYwPirmGc70/IYdHXQya3HtVgmOzli2zJYWyqAgcxYN0GE479Ys5dZ9Bd4KNscc47njAwD1YWN+GNoj4o=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
 by VI1PR04MB3151.eurprd04.prod.outlook.com (2603:10a6:802:6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Wed, 22 Jul
 2020 10:29:15 +0000
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7]) by VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7%2]) with mapi id 15.20.3216.022; Wed, 22 Jul 2020
 10:29:15 +0000
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
Subject: [PATCH v3 2/2] net: dsa: ocelot: Add support for QinQ Operation
Date:   Wed, 22 Jul 2020 18:32:00 +0800
Message-Id: <20200722103200.15395-3-hongbo.wang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200722103200.15395-1-hongbo.wang@nxp.com>
References: <20200722103200.15395-1-hongbo.wang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0159.apcprd04.prod.outlook.com (2603:1096:4::21)
 To VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from whb-OptiPlex-790.ap.freescale.net (119.31.174.73) by SG2PR04CA0159.apcprd04.prod.outlook.com (2603:1096:4::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Wed, 22 Jul 2020 10:29:07 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ab40c089-aca2-48c5-f48e-08d82e2a14f0
X-MS-TrafficTypeDiagnostic: VI1PR04MB3151:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB31519DA94CE11C1814654592E1790@VI1PR04MB3151.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OtjPiNUaCuQQt5sP3plxovPVs+bPHfj+DdSuMMURJObHctzwvEKg6OIiFPxKSAMfmdGCcicrla2BbEcKkfKVvJnBr6BReVOesVVUkIe397kmkLyVRWKmihDlpDuH1XA+eLeLSkSpATLHQ6ysgFZkDKgdemXs+TOtojZ25nxv2SgIIUEPA/IYiAh6QWMhvqRX780pkQuBwAoTT2qcw0jEO06Px5YRzsq3QgPFA/g3SVD6pmt422Nwnh3epRW+rBBGEDP7MVmIUqmKtrX+sLkGlVeZl2PWDk00ZGLkviNhcwMnbdEs3duCHYk0uk4SrnVlVQRiAaFUfOyC8kqb7ldN8NFMjbeVVMaSIU1UCwcEVv/tJIDByix/4jMubQlO3yjw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5103.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(8936002)(7416002)(6666004)(2906002)(66476007)(66556008)(66946007)(8676002)(83380400001)(1076003)(6486002)(36756003)(6512007)(316002)(5660300002)(9686003)(6506007)(478600001)(86362001)(2616005)(956004)(16526019)(186003)(26005)(4326008)(52116002)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6lcgBH2e4s6qplpElsnp8b7Iij9sqXpP6vB84raFNRlcPCy6ANh/7f+kegsXbK3GdMqTFGZrNumPC+qeJfshA/pGw7n1w7BNZ2weXKR5/gX+oglc8yAbzwgL0gi+0Hrzls1w6mFQ5NUfSkUzhdqbedBvraHP1LgnEsOUZ9k2+nX8EN9oXkeq/LDUF75i3+a3SGmUj2sI8hdPuyYuI6JXQ4k1ULS0vEG2E6m/nVn9evWRuG3d1laIhCd0KwAQirQh0RiWiowew/osJPo5Yv1ggthEg6BNsKYrB6vG2ApSc8Jrq7KRMl9K1ccuZJwTKMh6kE6xzrwF7R8nYT1lhsWCMIjsppdBYfV1RDiAs3r8gq1yHQtszm2p3pgv933GqipLnBwmlFBdptRsKW3wiqGwQvctMmzphNGMAMftR8INiVm+JFzA8FxRfAXQsEyND8WeKe12mqP0b8zR2lwvtaMTKkVQarkYkNOOXuurE5HIPwib69mQNrzjAkXAYNqDVBhV
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab40c089-aca2-48c5-f48e-08d82e2a14f0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5103.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2020 10:29:14.9813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +SBtWYKs//syPOBrx3wFKbOI7rN1ll7SRjT24YT2wsVgAHjuzNJWuys1LvIhIIy0crrJjTkHmEjf25SX8nOOdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3151
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

