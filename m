Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B69F435231
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhJTSBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:01:38 -0400
Received: from mail-eopbgr130070.outbound.protection.outlook.com ([40.107.13.70]:56736
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230073AbhJTSBh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 14:01:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dFI5MiVE/T8bk23CD8hTDr5r0toLwSUcnKxS1UFBy21nS87GO1URm6ABwRarUc9l6b/rroDaIJ5VFENdD+T/UwTaWVy6nSBwr1yEQy8ItctjLP6E4Up5hZsa8HcR1kOFt3NCKIuo0mNOpKR1t53cKgK/GgUA6UWjOWA9up4wEPCGIf6P7B6pS+HzsNOWjslUv9L4O4GNnShYwmsPJrCIrIaYc4GrFI3zPisBDdmxzXf9qmH2pcLgQ0hA1Qz8RWCGGHOUtQv35SrJLu4OI9Xf1ucdL/RKninqbtxwKuj7JV00T9LT/Ypgr3lEWUG9B7GJOvq3UR9muXlejmuwBJ8BkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ERwlURNR9HFcjlxY7kOsQskSIHeACG/JvkNQNAnv+mk=;
 b=YCtRysdF+k7Uz9uLLFEJnR/AsHZOS4e4C4D02UktlQRAsoc3qb3G3Zw5QroBJqGjZD043nYGAMQ6XfDF5ESJ66k5aIuVg41Sp440+C+aOUHIlOcPUFXxZRglPR8V4ZLk0VU9ofFbT8psjA84UxCMPXtXQZkgo3qCS2gzo2etifyUhJGVXQr64Cz0pROitpKTKI9Nia/8rrELunrTSDoEpoX6U+oHEU93ZuxwaBA9qFkCIh/NqiL7img7VH/dySATIzdEi5QzbxP3EXOgpPI1SoCVEWg1ujYNbZXMmaqqT1X+q+RNomru2U7IvOz9HM+zv3INlB2uupKYsgKoquX4Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERwlURNR9HFcjlxY7kOsQskSIHeACG/JvkNQNAnv+mk=;
 b=MBSmymoKuJnLBEXtHezU97vCv/AR6fWbnjkRjaassbHwm2v6PKtIx0iLkBFjG0/R0+DprBs2IbvUHPdGBk8zZNgL6Hz53efl7eOpoF1QkcusuxzdJmuahca6tZBIWgyROais4X92+8q2ALQQp5WDGuTuZNqcJEwsGVNZ2i3Ac4g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4685.eurprd04.prod.outlook.com (2603:10a6:803:70::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 17:59:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 17:59:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 3/5] net: mscc: ocelot: allow a config where all bridge VLANs are egress-untagged
Date:   Wed, 20 Oct 2021 20:58:50 +0300
Message-Id: <20211020175852.1127042-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020175852.1127042-1-vladimir.oltean@nxp.com>
References: <20211020175852.1127042-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0019.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::32) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR08CA0019.eurprd08.prod.outlook.com (2603:10a6:208:d2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 20 Oct 2021 17:59:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e98d9368-8103-4f15-66c2-08d993f354c3
X-MS-TrafficTypeDiagnostic: VI1PR04MB4685:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4685BABA025F292D8930F9F2E0BE9@VI1PR04MB4685.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y3KS5kMoV/KIgGMBK/aNdanuKFUDpWG6ZQPfY1buTqzwY3Wti+nnch37YVe4H7J33ccVtISLoxbp1+J2fk0fdVCEjeoDD1hqWRg9Pz4EiAuApesHHEp7WaHmVahPsxxqXfT3ukFXd9Ig4yhgfaf5Z4ComeNL6hbTRV1cbzwVYOZ26F8xHQpY9YIsBJxQOMmfgof1+gpteSU5xd4Udt4NbsSqixkQRaYGtPUgeIaRjVy4Tu53QBgWll8RXmpWAhguslLYoqpvA7lDumSzFlkIG3TSC7mitrg1DbUeRAqvbdnWV60qYh01LKv6UAEUWLxWIHmSJ7q062xJ6Z0UXl3vki28Z4hv6BnS/V+6JR83TFGz63xGrzrv9FCaEk8lMWM9OB/jLoO6wDhjKt9NRzQu8e06pXU9NEiIjE7LFr/u61jvwiYlgy5aJdGCH/w7GJAQSHtB470rEdAEKMcR7uuxSoM0IjLksh1WpnDwXjMApbOt84ClZcslYv/scX4EdN2SWMGIQgKUpzOykJ0VPY68H+CqE5j71UhgxEFapL9dJUosCkJWkOujSgcN3i8H6WMTdUM6xhHrOEmM1528yPbp2cSmguDy2Fyqq0KzBOasX2lT2oS5CA+QmC5/Xe9+boqH0omjhSkcLrXdPFfzmH477B+cRgiVePRQuv1X2Ja90L/mevWnQNAOwvjIVysPwd+/7VioW7xqAYQ8wARLol1HLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(110136005)(316002)(5660300002)(186003)(6506007)(52116002)(38350700002)(66476007)(66556008)(6666004)(38100700002)(54906003)(1076003)(26005)(6486002)(86362001)(6512007)(956004)(66946007)(83380400001)(8676002)(36756003)(6636002)(2906002)(8936002)(2616005)(44832011)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9y+hGSW/UPWfEmdk92+ODvXvZXjvHfl7sdAqmMzzop3otHwNjWq/IdrpdloN?=
 =?us-ascii?Q?hE18D3kt2saZKh0ocUz2NIDYPacflv9bLrt3xOeMn/5tlj4Ft1hXmg2tgG2I?=
 =?us-ascii?Q?GPoO9XTV8cGV8Gq0PdV+nUJMTwjbFnDp4oLi5AYlQtoz7gecESdjlkoI2meS?=
 =?us-ascii?Q?qnNFJE9pP2L6W4vl104vueogtL2FDkwSEwchRjblRqVgCJ/r19iNZ2zAbnQ6?=
 =?us-ascii?Q?7/MN12tkjGFpQimO7azpkLwb5Z2pUPfCFwlRMDAY3+Y6eRvsRH5BQFiM3YCw?=
 =?us-ascii?Q?BJHT3FabwbnxKVowdj1n3OCML5ChI409nJ2mCxZbp5YBWtREcurq0OHTtM7B?=
 =?us-ascii?Q?4EZnjq8GNBERTm0GvisQo4UbJsnzeTPwfmXqkw8DVvgtqf+WT3PiLIwOvTpP?=
 =?us-ascii?Q?BHz0/OVjc8w9+79OZqZZV3x62CtQ6zEoOlWax9aE2b6f1MfnYsUHYTQ7E/m9?=
 =?us-ascii?Q?1vCigw1oLYPfJj8NTgpEhqnsA+Hr41r7dDpzLJMCD8s+se6F1PDW/qHXQDKh?=
 =?us-ascii?Q?1bETX8Yj5l4L6MPN0lyCYZXydTE0gVPeZzHiwNNpwD3Qlbet+xhUQgbdg+V/?=
 =?us-ascii?Q?YFAKxQcjDGMFSWwfspmk+okM49U3KoTywsK+yRi5WRLFtKPemCpBVK2AeOes?=
 =?us-ascii?Q?MO2eq3AC5JVPoZfBAcQ/wZ1Nz7n3qU/uqlj7KJKH9axrKLPTvUtbvrAKrhh6?=
 =?us-ascii?Q?5n6vsquAV4j1+kOIGqNQAowMWYWxWGTgWDBMHFRzZAk0fDdtkqLIrtTztFC1?=
 =?us-ascii?Q?BAZSG9aJju/n4FlUfMZVRCka1PD0veDlTRs7udo9MIsz3mL2DfrRLebCm6dS?=
 =?us-ascii?Q?k9ppDhajzuDv7H5xWozu2fGP3AUV2r4PCVgFb3vF7FCC6plo2hOzY4M+sUYI?=
 =?us-ascii?Q?DeiAqHYu1u6T0zEYqC480J1WW6bgyBNAp/XcD6/tGRwPiYXfLJGgwNvnYvZG?=
 =?us-ascii?Q?DLfRT7Y1USEyvQ8vR0mPfcAIeSk8jcA+N5BNycuIeb8TTgsBQgPjcan9JPG0?=
 =?us-ascii?Q?b2LAgc/M8Nx3/qTQStvNPeIGt+APZxzGiGyvT6TKiAe4vy9iHre0jt7kVqTf?=
 =?us-ascii?Q?MorvIhwPZeSq4lCpCliaJFm/dztDf0LOw5Aby7sRINvVWLxWg6iPYED51/Fx?=
 =?us-ascii?Q?9pbN/r5518JKTllt/YanMh1AbrhnI+LztrNpd0tMkiLgg7q84W39hZ1vyZBE?=
 =?us-ascii?Q?ZCo3FEajMM/dRUQOd1qJH3VtVVhb9+SS6WyPsPhuTw9S3JpJ72IWx0Hhk5mk?=
 =?us-ascii?Q?61KBIzgIMQ77LDyZZLAVOo4Ohpdw9uqgxk8l59uus08ezzIOOfvSsCzVwLwi?=
 =?us-ascii?Q?x/yxHnuGxVdgPUeeX9gsN4xRtc463Qsx55fbidKklfV4C8O/oTevL96ADMII?=
 =?us-ascii?Q?6j0TsqEV+F6U/sj4H0NkZWhwAndywE2RQZ04QwnEdko+gpWzjhuyYuDtjrXK?=
 =?us-ascii?Q?/QRtldzGQRbU5LuOQVQIdXi11bQx0s4XYwL/iEHTCg1FhmKCCqATaOsQ2WyM?=
 =?us-ascii?Q?94grXZ03sVPd6choSBQZqPY8mSPYyGpKNmXPFC3FLU9nRoVDZbgJMLweVSQE?=
 =?us-ascii?Q?tpWrL90qsAdJ9Ao8AFpMFh4zaC67XgcjWr6/ZWtQASssFNykw2AnjlTaepYE?=
 =?us-ascii?Q?P1/8qHVPw2zSXDyp3MN0ogs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e98d9368-8103-4f15-66c2-08d993f354c3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:59:16.1182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dwU4elFJ555nudthFBRpg1buUVJn0GAETJ76uqj1NeGSGcmYb1FJGQ9pd3uSzFPR6qucSoaj2VwBQ7QO2RX+KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At present, the ocelot driver accepts a single egress-untagged bridge
VLAN, meaning that this sequence of operations:

ip link add br0 type bridge vlan_filtering 1
ip link set swp0 master br0
bridge vlan add dev swp0 vid 2 pvid untagged

fails because the bridge automatically installs VID 1 as a pvid & untagged
VLAN, and vid 2 would be the second untagged VLAN on this port. It is
necessary to delete VID 1 before proceeding to add VID 2.

This limitation comes from the fact that we operate the port tag, when
it has an egress-untagged VID, in the OCELOT_PORT_TAG_NATIVE mode.
The ocelot switches do not have full flexibility and can either have one
single VID as egress-untagged, or all of them.

There are use cases for having all VLANs as egress-untagged as well, and
this patch adds support for that.

The change rewrites ocelot_port_set_native_vlan() into a more generic
ocelot_port_manage_port_tag() function. Because the software bridge's
state, transmitted to us via switchdev, can become very complex, we
don't attempt to track all possible state transitions, but instead take
a more declarative approach and just make ocelot_port_manage_port_tag()
figure out which more to operate in:

- port is VLAN-unaware: the classified VLAN (internal, unrelated to the
                        802.1Q header) is not inserted into packets on egress
- port is VLAN-aware:
  - port has tagged VLANs:
    -> port has no untagged VLAN: set up as pure trunk
    -> port has one untagged VLAN: set up as trunk port + native VLAN
    -> port has more than one untagged VLAN: this is an invalid config
       which is rejected by ocelot_vlan_prepare
  - port has no tagged VLANs
    -> set up as pure egress-untagged port

We don't keep the number of tagged and untagged VLANs, we just count the
structures we keep.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/mscc/ocelot.c | 146 ++++++++++++++++++++++-------
 include/soc/mscc/ocelot.h          |   3 +-
 2 files changed, 113 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index c8c0b0f0dd59..bc033e62be97 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -162,29 +162,100 @@ static int ocelot_vlant_set_mask(struct ocelot *ocelot, u16 vid, u32 mask)
 	return ocelot_vlant_wait_for_completion(ocelot);
 }
 
-static void ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
-					struct ocelot_vlan native_vlan)
+static int ocelot_port_num_untagged_vlans(struct ocelot *ocelot, int port)
 {
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	enum ocelot_port_tag_config tag_cfg;
+	struct ocelot_bridge_vlan *vlan;
+	int num_untagged = 0;
+
+	list_for_each_entry(vlan, &ocelot->vlans, list) {
+		if (!(vlan->portmask & BIT(port)))
+			continue;
 
-	ocelot_port->native_vlan = native_vlan;
+		if (vlan->untagged & BIT(port))
+			num_untagged++;
+	}
 
-	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_VID(native_vlan.vid),
-		       REW_PORT_VLAN_CFG_PORT_VID_M,
-		       REW_PORT_VLAN_CFG, port);
+	return num_untagged;
+}
+
+static int ocelot_port_num_tagged_vlans(struct ocelot *ocelot, int port)
+{
+	struct ocelot_bridge_vlan *vlan;
+	int num_tagged = 0;
+
+	list_for_each_entry(vlan, &ocelot->vlans, list) {
+		if (!(vlan->portmask & BIT(port)))
+			continue;
+
+		if (!(vlan->untagged & BIT(port)))
+			num_tagged++;
+	}
+
+	return num_tagged;
+}
+
+/* We use native VLAN when we have to mix egress-tagged VLANs with exactly
+ * _one_ egress-untagged VLAN (_the_ native VLAN)
+ */
+static bool ocelot_port_uses_native_vlan(struct ocelot *ocelot, int port)
+{
+	return ocelot_port_num_tagged_vlans(ocelot, port) &&
+	       ocelot_port_num_untagged_vlans(ocelot, port) == 1;
+}
+
+static struct ocelot_bridge_vlan *
+ocelot_port_find_native_vlan(struct ocelot *ocelot, int port)
+{
+	struct ocelot_bridge_vlan *vlan;
+
+	list_for_each_entry(vlan, &ocelot->vlans, list)
+		if (vlan->portmask & BIT(port) && vlan->untagged & BIT(port))
+			return vlan;
+
+	return NULL;
+}
+
+/* Keep in sync REW_TAG_CFG_TAG_CFG and, if applicable,
+ * REW_PORT_VLAN_CFG_PORT_VID, with the bridge VLAN table and VLAN awareness
+ * state of the port.
+ */
+static void ocelot_port_manage_port_tag(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	enum ocelot_port_tag_config tag_cfg;
+	bool uses_native_vlan = false;
 
 	if (ocelot_port->vlan_aware) {
-		if (native_vlan.valid)
+		uses_native_vlan = ocelot_port_uses_native_vlan(ocelot, port);
+
+		if (uses_native_vlan)
 			tag_cfg = OCELOT_PORT_TAG_NATIVE;
+		else if (ocelot_port_num_untagged_vlans(ocelot, port))
+			tag_cfg = OCELOT_PORT_TAG_DISABLED;
 		else
 			tag_cfg = OCELOT_PORT_TAG_TRUNK;
 	} else {
 		tag_cfg = OCELOT_PORT_TAG_DISABLED;
 	}
+
 	ocelot_rmw_gix(ocelot, REW_TAG_CFG_TAG_CFG(tag_cfg),
 		       REW_TAG_CFG_TAG_CFG_M,
 		       REW_TAG_CFG, port);
+
+	if (uses_native_vlan) {
+		struct ocelot_bridge_vlan *native_vlan;
+
+		/* Not having a native VLAN is impossible, because
+		 * ocelot_port_num_untagged_vlans has returned 1.
+		 * So there is no use in checking for NULL here.
+		 */
+		native_vlan = ocelot_port_find_native_vlan(ocelot, port);
+
+		ocelot_rmw_gix(ocelot,
+			       REW_PORT_VLAN_CFG_PORT_VID(native_vlan->vid),
+			       REW_PORT_VLAN_CFG_PORT_VID_M,
+			       REW_PORT_VLAN_CFG, port);
+	}
 }
 
 /* Default vlan to clasify for untagged frames (may be zero) */
@@ -231,7 +302,8 @@ static struct ocelot_bridge_vlan *ocelot_bridge_vlan_find(struct ocelot *ocelot,
 	return NULL;
 }
 
-static int ocelot_vlan_member_add(struct ocelot *ocelot, int port, u16 vid)
+static int ocelot_vlan_member_add(struct ocelot *ocelot, int port, u16 vid,
+				  bool untagged)
 {
 	struct ocelot_bridge_vlan *vlan = ocelot_bridge_vlan_find(ocelot, vid);
 	unsigned long portmask;
@@ -245,6 +317,14 @@ static int ocelot_vlan_member_add(struct ocelot *ocelot, int port, u16 vid)
 			return err;
 
 		vlan->portmask = portmask;
+		/* Bridge VLANs can be overwritten with a different
+		 * egress-tagging setting, so make sure to override an untagged
+		 * with a tagged VID if that's going on.
+		 */
+		if (untagged)
+			vlan->untagged |= BIT(port);
+		else
+			vlan->untagged &= ~BIT(port);
 
 		return 0;
 	}
@@ -263,6 +343,8 @@ static int ocelot_vlan_member_add(struct ocelot *ocelot, int port, u16 vid)
 
 	vlan->vid = vid;
 	vlan->portmask = portmask;
+	if (untagged)
+		vlan->untagged = BIT(port);
 	INIT_LIST_HEAD(&vlan->list);
 	list_add_tail(&vlan->list, &ocelot->vlans);
 
@@ -324,7 +406,7 @@ int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 		       ANA_PORT_VLAN_CFG, port);
 
 	ocelot_port_set_pvid(ocelot, port, ocelot_port->pvid_vlan);
-	ocelot_port_set_native_vlan(ocelot, port, ocelot_port->native_vlan);
+	ocelot_port_manage_port_tag(ocelot, port);
 
 	return 0;
 }
@@ -333,14 +415,20 @@ EXPORT_SYMBOL(ocelot_port_vlan_filtering);
 int ocelot_vlan_prepare(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 			bool untagged, struct netlink_ext_ack *extack)
 {
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-
-	/* Deny changing the native VLAN, but always permit deleting it */
-	if (untagged && ocelot_port->native_vlan.vid != vid &&
-	    ocelot_port->native_vlan.valid) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Port already has a native VLAN");
-		return -EBUSY;
+	if (untagged) {
+		/* We are adding an egress-tagged VLAN */
+		if (ocelot_port_uses_native_vlan(ocelot, port)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Port with egress-tagged VLANs cannot have more than one egress-untagged (native) VLAN");
+			return -EBUSY;
+		}
+	} else {
+		/* We are adding an egress-tagged VLAN */
+		if (ocelot_port_num_untagged_vlans(ocelot, port) > 1) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Port with more than one egress-untagged VLAN cannot have egress-tagged VLANs");
+			return -EBUSY;
+		}
 	}
 
 	return 0;
@@ -352,7 +440,7 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 {
 	int err;
 
-	err = ocelot_vlan_member_add(ocelot, port, vid);
+	err = ocelot_vlan_member_add(ocelot, port, vid, untagged);
 	if (err)
 		return err;
 
@@ -366,13 +454,7 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 	}
 
 	/* Untagged egress vlan clasification */
-	if (untagged) {
-		struct ocelot_vlan native_vlan;
-
-		native_vlan.vid = vid;
-		native_vlan.valid = true;
-		ocelot_port_set_native_vlan(ocelot, port, native_vlan);
-	}
+	ocelot_port_manage_port_tag(ocelot, port);
 
 	return 0;
 }
@@ -395,11 +477,7 @@ int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
 	}
 
 	/* Egress */
-	if (ocelot_port->native_vlan.vid == vid) {
-		struct ocelot_vlan native_vlan = {0};
-
-		ocelot_port_set_native_vlan(ocelot, port, native_vlan);
-	}
+	ocelot_port_manage_port_tag(ocelot, port);
 
 	return 0;
 }
@@ -1725,12 +1803,12 @@ void ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 			      struct net_device *bridge)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	struct ocelot_vlan pvid = {0}, native_vlan = {0};
+	struct ocelot_vlan pvid = {0};
 
 	ocelot_port->bridge = NULL;
 
 	ocelot_port_set_pvid(ocelot, port, pvid);
-	ocelot_port_set_native_vlan(ocelot, port, native_vlan);
+	ocelot_port_manage_port_tag(ocelot, port);
 	ocelot_apply_bridge_fwd_mask(ocelot);
 }
 EXPORT_SYMBOL(ocelot_port_bridge_leave);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 9f2ea7995075..b8b1ac943b44 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -571,6 +571,7 @@ struct ocelot_vlan {
 struct ocelot_bridge_vlan {
 	u16 vid;
 	unsigned long portmask;
+	unsigned long untagged;
 	struct list_head list;
 };
 
@@ -608,8 +609,6 @@ struct ocelot_port {
 	bool				vlan_aware;
 	/* VLAN that untagged frames are classified to, on ingress */
 	struct ocelot_vlan		pvid_vlan;
-	/* The VLAN ID that will be transmitted as untagged, on egress */
-	struct ocelot_vlan		native_vlan;
 
 	unsigned int			ptp_skbs_in_flight;
 	u8				ptp_cmd;
-- 
2.25.1

