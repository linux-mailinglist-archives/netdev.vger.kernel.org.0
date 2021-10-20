Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9071C435230
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhJTSBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:01:37 -0400
Received: from mail-eopbgr130070.outbound.protection.outlook.com ([40.107.13.70]:56736
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230311AbhJTSBc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 14:01:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KaorPMVOIIAkLaeaqKPADDPPG65s/rYTWy24cQMCQ3GeQEZmB/cDWvzcg26BmduDUvws5W3ZMgit2HxCGp/qouce+0H2ENNvX8LbhTfngxsaAu3XIvzSazNbWcZvSg4Q+42jbPVOdQ97YzVciZGGmRRJL27tAqDGlMvw0Z8cdSyz6sbD6D23M0XEK5rVum0axkJcCS1xMfyuoi3JqU31CoNRkWbxWcHgdb4XQlDWowoJ94WGGJMylsz38JJNf63BHlFpLPuxpsbGR1Y6A8q2En0+RsucecaJZc/jWtSI6qY2fOaDytI8LP0GlTe9dHGKRmiJfxi50MrDlDs8TWRfzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yrLPg/9tJIOPOJ4UAWkvIaGH9dST0P0p22beECty2ro=;
 b=O5ly6N7FIzsmkorsRmSVPRctgfnI2pQTSyMxwHRL7ZXPzW4QPsMEilpkqh7W00qCwXByzoaYthGW2xqxTYkzEs+CrFQcCsOzEOG9D+SQ+9dqPeM0h53WqM41b7uPxKrdA8UZ1PIqVQGXscI89t4HEkyrl+tqi8R/2EMnUalt+Mp5uEMGxglhEWYwep1VLpC2FeSj5j6W50QR9HL8LBrK85QbCkF8VFCRnPpP7/AH7tEtA9wFh8mhgA4P+47+gZDXvpr6BtKGue1mhtXsSTxAX+U/MmnhhMvHtFq0S6zUxvjQW4toMLxuygnlCW7cEown1TSmpl2B319YFDUbccnrBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrLPg/9tJIOPOJ4UAWkvIaGH9dST0P0p22beECty2ro=;
 b=DA2FX5pQAR4RYhJiuiQHlIq5VNGSEuEYGhzKcZgJFGjJ6RsRzxLgSMF9sbjGPrFUgtfQeJpNIoa3Tbi8l0X+oCPqmgaSCTA6iNZGLKWxT4QT9+jkm8FeyKczYeDQycmBv007qQtn4X5hKt/T4r2J1ySzzbF7CN4A6C+mikt6R3E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4685.eurprd04.prod.outlook.com (2603:10a6:803:70::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 17:59:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 17:59:14 +0000
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
Subject: [PATCH v2 net-next 2/5] net: mscc: ocelot: convert the VLAN masks to a list
Date:   Wed, 20 Oct 2021 20:58:49 +0300
Message-Id: <20211020175852.1127042-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020175852.1127042-1-vladimir.oltean@nxp.com>
References: <20211020175852.1127042-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0019.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::32) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR08CA0019.eurprd08.prod.outlook.com (2603:10a6:208:d2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 20 Oct 2021 17:59:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84e67429-c0fa-4a17-2e4d-08d993f353ce
X-MS-TrafficTypeDiagnostic: VI1PR04MB4685:
X-Microsoft-Antispam-PRVS: <VI1PR04MB468509624AFA546BF6A3ABAEE0BE9@VI1PR04MB4685.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c5MnVv75X7/YToLK8Riu4k4/I3C2QnLIvja600DA9TXlRN83zWHSLooMITdxjYNajkxK8htljZlMJ8tc+A2Vwp0/2f4FLFjBNmzA+IAEjqLgL3J3UFXRcpoGJLzJcFClxFMyeCw4+jFGvQ5iauNN1j5eEbobVzrUSPF5u4gAJkcxbx110KfI5VZHR3eS3mT7TMqubOPoUsNIjKY0Vd2/sEBdzGNz3Z78cL73XAGWb1YLwKIkH5w9Cz+VNl3BVhQ2P8TGHd3jbFM8mcq1L4n8ypuBxRvvxNNfptq8yHsv/EU9ZvEaNj8W8rKXSJ65l/0rxYNY7UvABSXl/uKjViCl5rbgfKfSaWwN8VwLchIV0IawNKfex4C233GQLMJav7eMH9nMuAGGGVNEzClDJzrlBfHAbcejyGdfoVACngnw0CvidCGIrpvwbGGb77M546d4OnkASudj8RO4Eo9yL3sqO/E3m8MJM1tGxpYjSnhlWV6EFSgA/f3YHxGQLB987BJQsxiQDvKMkkkYYDto4Bu7/0abaKlp2maLAKU9vjXzeDyWe6pQoqQmlstoNdluWlGkhiXh14LajkL31a4NiVd5aLjIRnaUSSQbZU1aOWe2SFjf8XghLRlFHVgt8hfPs2+qmevbUeKfQ2RWTPEwVJ7t0HJVgWxlq8DxAqm/mJbyVUxRUgZLSeMroe7D2XHzYFGQd1PyTRerM+bw/vLBG5xivQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(110136005)(5660300002)(186003)(6506007)(52116002)(38350700002)(66476007)(66556008)(6666004)(38100700002)(54906003)(1076003)(26005)(6486002)(86362001)(6512007)(956004)(66946007)(83380400001)(8676002)(36756003)(6636002)(2906002)(8936002)(2616005)(44832011)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2JhsousTVGNsDYEDiNmXKZHsQdrZHZWGq6cPeejTiMrt/wLerNvwnPuusTn/?=
 =?us-ascii?Q?mkrwc5BboRNuu+UYswdvn4H+f/k8mNbV67M15pGqaPB9PKWec7eFZabaXjug?=
 =?us-ascii?Q?lNKoq8s2fSq2/u/vl2yJQTRHR/tTMPzyz8OtRn3XKEs3vAeDEBGHKZ126S/Z?=
 =?us-ascii?Q?pekf6H4T6PngapgeVRGieH0A7rt0Yh8wJ2bsHK1PWY4Evvc7FUUyUyoBbajX?=
 =?us-ascii?Q?b49RGi5YoeUJO1BhAXiQ3BlG01jS6JDnNASNuGalJlDRTXyoabedWdiIed2X?=
 =?us-ascii?Q?df7javSp0QKAJe8EFR7eMoDF/ueVuR4dgc+C7JED01fHslrbVs0FdRs/3g83?=
 =?us-ascii?Q?2XzdP5S26EHjPLsq7lhCjMuQbGl1aifTLeNvtxSX2EUn6zrC5sI4G6M155xm?=
 =?us-ascii?Q?qTqzabfcl0QfuM0B/jrcKyWm4yQo9YC1Vh+lqTpAGu7ERaEc7y+akolLI9iB?=
 =?us-ascii?Q?JUk2cN/yL6va6uxHWdouR4usucj0C8e03CEG/GXY+7c1cIhggdkpi5f3zrj0?=
 =?us-ascii?Q?Xn3p800EYppW02lKsfdctxJcnSFRpcmd9qxvVFR0FhYTHZ4Rh53j8X6KRGYv?=
 =?us-ascii?Q?XoWF9eTkTdRy7wfAfhdaf0jEdIk+vi1lweDeLByOjKg72igTHSqXROgqMnII?=
 =?us-ascii?Q?1oSM6ZpszOorrGRGbXesOOCRrta6MZ+d65LxFzY5Wd9q168NuVahJeEbURi5?=
 =?us-ascii?Q?thHZK6gxdw8OP08Tf+QCW74l2biR0b2B5eNb8jTeqr+TrWxUIoAi0L+Em7p/?=
 =?us-ascii?Q?LgtKEHGMl4+kqZ6FC5taMkBpbND41q8/hlhm+mh7vLH59mFP2HDs9GXiDRLD?=
 =?us-ascii?Q?SNG8O2A7vYSpVxsRs4NwLapj2GQdUl1DHIRQHw4KHi43UsA2KMsdQWLvzdH7?=
 =?us-ascii?Q?YM/rY7ndwPN9VQ2B12c4uoqrFIQdx3oqvxEyySEsjagH5agUjXnq0DZiU4Db?=
 =?us-ascii?Q?++HTccovrxnFZZAjFyXoEvrpJZ5m79cPWVo8iH1UoIYFQvxygGkOt43hE2Hx?=
 =?us-ascii?Q?vM3cd153CbIYhqfRr54rhGx5sZkHEhQaA0TmrzwZiVhR4kbMj7tL8BaJyNeb?=
 =?us-ascii?Q?WxcaPKrOgK00wGXYxOBv2KtAvvFb26QU9Rz+H5PVJukqwSqbGRc1mpQBWviF?=
 =?us-ascii?Q?Mc3tRajowwaY4ppJXhlO6drCqEpTbYmiUSCMr8OiD95SQKhZSDwX6fs5wnBo?=
 =?us-ascii?Q?qO03Ho8Hm08Z1lBUVDc/tkDPRr84bzV592RBbZv8LEnValGSXviQyovbVtIr?=
 =?us-ascii?Q?RjR7TrsJ+F6Sd+eozmqaHx16vBdkw9uZuYPpzCAa4+XWFSR5TvyI6rvKiFTw?=
 =?us-ascii?Q?EUkR/C48jOKa6VPNGyqS6q7N5WZfWdGfjxZB+26f6Zooc9ZBM2Sj1+5Jgg90?=
 =?us-ascii?Q?rDEA7g9cAfgt9EJk0KZ7pqdFSecJ0Wbm97k9tUg77ZH5pE+5fc5xtvVAtyK4?=
 =?us-ascii?Q?vLgsbu6fX7Vn5U88i4BUyE3ZrXG1Ey+MWBMBzn2naxFu3ZoX7CrrwAZJchFR?=
 =?us-ascii?Q?4wGlSXolVKf+qySvkIHJVJ9qc/UXtNZUJirLASFn6Nqo5AHnaCdw/80zatnq?=
 =?us-ascii?Q?LeKHG+XmSkGWdp8ZUQ50X1efqGu9gDmHzCIlMhixUb2ex+k3RIX5CLLoWZLk?=
 =?us-ascii?Q?WQQ1qKTOKF5kfVQJdcSI5gA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84e67429-c0fa-4a17-2e4d-08d993f353ce
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:59:14.4371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aX3VPvk6/DT49/3hwExt1VCCBgKc43C3oAaR0g9k+nuu3lt7QvoPSDI8YoVik2L8XSEAwcnVcQ81/YLOLZXHyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First and foremost, the driver currently allocates a constant sized
4K * u32 (16KB memory) array for the VLAN masks. However, a typical
application might not need so many VLANs, so if we dynamically allocate
the memory as needed, we might actually save some space.

Secondly, we'll need to keep more advanced bookkeeping of the VLANs we
have, notably we'll have to check how many untagged and how many tagged
VLANs we have. This will have to stay in a structure, and allocating
another 16 KB array for that is again a bit too much.

So refactor the bridge VLANs in a linked list of structures.

The hook points inside the driver are ocelot_vlan_member_add() and
ocelot_vlan_member_del(), which previously used to operate on the
ocelot->vlan_mask[vid] array element.

ocelot_vlan_member_add() and ocelot_vlan_member_del() used to call
ocelot_vlan_member_set() to commit to the ocelot->vlan_mask.
Additionally, we had two calls to ocelot_vlan_member_set() from outside
those callers, and those were directly from ocelot_vlan_init().
Those calls do not set up bridging service VLANs, instead they:

- clear the VLAN table on reset
- set the port pvid to the value used by this driver for VLAN-unaware
  standalone port operation (VID 0)

So now, when we have a structure which represents actual bridge VLANs,
VID 0 doesn't belong in that structure, since it is not part of the
bridging layer.

So delete the middle man, ocelot_vlan_member_set(), and let
ocelot_vlan_init() call directly ocelot_vlant_set_mask() which forgoes
any data structure and writes directly to hardware, which is all that we
need.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/mscc/ocelot.c | 81 ++++++++++++++++++++++++------
 include/soc/mscc/ocelot.h          |  9 +++-
 2 files changed, 72 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b09929970273..c8c0b0f0dd59 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -219,31 +219,79 @@ static void ocelot_port_set_pvid(struct ocelot *ocelot, int port,
 		       ANA_PORT_DROP_CFG, port);
 }
 
-static int ocelot_vlan_member_set(struct ocelot *ocelot, u32 vlan_mask, u16 vid)
+static struct ocelot_bridge_vlan *ocelot_bridge_vlan_find(struct ocelot *ocelot,
+							  u16 vid)
 {
-	int err;
+	struct ocelot_bridge_vlan *vlan;
 
-	err = ocelot_vlant_set_mask(ocelot, vid, vlan_mask);
-	if (err)
-		return err;
+	list_for_each_entry(vlan, &ocelot->vlans, list)
+		if (vlan->vid == vid)
+			return vlan;
 
-	ocelot->vlan_mask[vid] = vlan_mask;
-
-	return 0;
+	return NULL;
 }
 
 static int ocelot_vlan_member_add(struct ocelot *ocelot, int port, u16 vid)
 {
-	return ocelot_vlan_member_set(ocelot,
-				      ocelot->vlan_mask[vid] | BIT(port),
-				      vid);
+	struct ocelot_bridge_vlan *vlan = ocelot_bridge_vlan_find(ocelot, vid);
+	unsigned long portmask;
+	int err;
+
+	if (vlan) {
+		portmask = vlan->portmask | BIT(port);
+
+		err = ocelot_vlant_set_mask(ocelot, vid, portmask);
+		if (err)
+			return err;
+
+		vlan->portmask = portmask;
+
+		return 0;
+	}
+
+	vlan = kzalloc(sizeof(*vlan), GFP_KERNEL);
+	if (!vlan)
+		return -ENOMEM;
+
+	portmask = BIT(port);
+
+	err = ocelot_vlant_set_mask(ocelot, vid, portmask);
+	if (err) {
+		kfree(vlan);
+		return err;
+	}
+
+	vlan->vid = vid;
+	vlan->portmask = portmask;
+	INIT_LIST_HEAD(&vlan->list);
+	list_add_tail(&vlan->list, &ocelot->vlans);
+
+	return 0;
 }
 
 static int ocelot_vlan_member_del(struct ocelot *ocelot, int port, u16 vid)
 {
-	return ocelot_vlan_member_set(ocelot,
-				      ocelot->vlan_mask[vid] & ~BIT(port),
-				      vid);
+	struct ocelot_bridge_vlan *vlan = ocelot_bridge_vlan_find(ocelot, vid);
+	unsigned long portmask;
+	int err;
+
+	if (!vlan)
+		return 0;
+
+	portmask = vlan->portmask & ~BIT(port);
+
+	err = ocelot_vlant_set_mask(ocelot, vid, portmask);
+	if (err)
+		return err;
+
+	vlan->portmask = portmask;
+	if (vlan->portmask)
+		return 0;
+
+	list_del(&vlan->list);
+	kfree(vlan);
+
+	return 0;
 }
 
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
@@ -369,13 +417,13 @@ static void ocelot_vlan_init(struct ocelot *ocelot)
 
 	/* Configure the port VLAN memberships */
 	for (vid = 1; vid < VLAN_N_VID; vid++)
-		ocelot_vlan_member_set(ocelot, 0, vid);
+		ocelot_vlant_set_mask(ocelot, vid, 0);
 
 	/* Because VLAN filtering is enabled, we need VID 0 to get untagged
 	 * traffic.  It is added automatically if 8021q module is loaded, but
 	 * we can't rely on it since module may be not loaded.
 	 */
-	ocelot_vlan_member_set(ocelot, all_ports, 0);
+	ocelot_vlant_set_mask(ocelot, 0, all_ports);
 
 	/* Set vlan ingress filter mask to all ports but the CPU port by
 	 * default.
@@ -2127,6 +2175,7 @@ int ocelot_init(struct ocelot *ocelot)
 
 	INIT_LIST_HEAD(&ocelot->multicast);
 	INIT_LIST_HEAD(&ocelot->pgids);
+	INIT_LIST_HEAD(&ocelot->vlans);
 	ocelot_detect_features(ocelot);
 	ocelot_mact_init(ocelot);
 	ocelot_vlan_init(ocelot);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 0568b25c8659..9f2ea7995075 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -568,6 +568,12 @@ struct ocelot_vlan {
 	u16 vid;
 };
 
+struct ocelot_bridge_vlan {
+	u16 vid;
+	unsigned long portmask;
+	struct list_head list;
+};
+
 enum ocelot_port_tag_config {
 	/* all VLANs are egress-untagged */
 	OCELOT_PORT_TAG_DISABLED = 0,
@@ -646,8 +652,7 @@ struct ocelot {
 
 	u8				base_mac[ETH_ALEN];
 
-	/* Keep track of the vlan port masks */
-	u32				vlan_mask[VLAN_N_VID];
+	struct list_head		vlans;
 
 	/* Switches like VSC9959 have flooding per traffic class */
 	int				num_flooding_pgids;
-- 
2.25.1

