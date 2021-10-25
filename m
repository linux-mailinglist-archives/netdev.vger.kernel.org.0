Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CDF43A672
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbhJYW1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:27:03 -0400
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:57392
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230246AbhJYW06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 18:26:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rlu08zwWk34jZy0lj7cnjocu8ttAyWInn7JA2lyfbPVraY499FWqSkkRYt/ZV4OKCpamAZ7g4qpA/IzkWf3vCAOM4MWBKY0c7Y7OISeiwP5S/h8MrhKuudg7+RjA3qgSnKY6riWGICaGnJ8qBblsJkHMyBk3/6oyi67gNMgrqLulb+F+p6R7gUmMiLDM8ei8+izCZjsGq6Hoh6s1HzqRc6+Hfso1y0JB3Ch+ByD15SlAHBOasbZhkhvsrQbhq7eLLPzIF5v0hYESbpiji5wOqvR0U0yhOlfePHwu8o4LzA7Bm1VQg0fZT7Kq2cTbJZonuat1X3wFQxuX9B8TNlTL9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gEw3BJkpVNZBcPPWZmDpjbH1L4qg03bWgN93s9Wo+K0=;
 b=LgjmHN0UF05zRqA2kErthVtBZH6H+1svKzYepzRJqJPS+bjSY77rW/bYUfGAX4Jk81vckJEtUcKOittGSuJuhYPP/HHQCQl19wYx4vV2tm0BqyaJrMZ0BXRyPHYSNN6W4zdvRIL9kvy/ottSk+kEnn8XUND2xuEN7cRnPUWHdDBIhqEzvR2OiWqO71t/hwOpLAbXDGtCGhAO8S3jNB9SEPqvefGeQ4UEetFOThMB69xyhKsu0VctxkfvO89x7L+JrihnvkB92zojIvLCdDiznyg+utiYgphfN+1Zd3IOSJKS6p19H5gDDz9niH2quLSIODoWFlyUxOk8w0LJV+ZtJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gEw3BJkpVNZBcPPWZmDpjbH1L4qg03bWgN93s9Wo+K0=;
 b=j85K/CCSGNjeyn3eE4OhNiPmKwve0I5fEUXj5N3+9FunXb9Hm3QtxGxKS6Ju0mqJxhK/6IyiNfBNRg6d/nFdUKtTfFFtKH10/WUgcTV57lmp08WkUXPayAiiX8BTxzpWaQbwociJ4pc3YMpD5CyauU5fkc2YAxy3dSKsfGFfnIY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Mon, 25 Oct
 2021 22:24:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 22:24:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [RFC PATCH net-next 03/15] net: bridge: rename fdb_insert to fdb_add_local
Date:   Tue, 26 Oct 2021 01:24:03 +0300
Message-Id: <20211025222415.983883-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025222415.983883-1-vladimir.oltean@nxp.com>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:207:8::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0137.eurprd07.prod.outlook.com (2603:10a6:207:8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12 via Frontend Transport; Mon, 25 Oct 2021 22:24:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77407c90-fe53-4656-df80-08d99806384d
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2304:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB23044B0C4799705F3977770EE0839@VI1PR0401MB2304.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ET/BMM4b/rmeegXQHTAlmjH5HcyXJSG1cfIimysrPf2BSWzKqk3iYRFl7NQTLjardFxLfAZ+mWBGh+FCaMih8dPfPSrpIzeQ2wH3IleaFX1HoQ3RgDHaiESWR2Ypu6O0w3LWBV6Y5xnDo+DzHjSsUT+5TxDxfutMsFauR2moBab0IAgDpCHD6ft29KCsi+RAri7IFPqT5nwQMADZaWE7V3Y2fBTkyPJfuq+w2Wfa3PTWHbLCAFi2DlTL7zLBOWB+RFBSRiNoWGWJePdDsMl7M6+6FOBjumHILX30g5i+aZnGtHPoBAunykutiojZiNcvlzlofGjnyM9Y34JBt0JbFpmh8+Yr2Ugq/Hx1lzSBXGUzXJaQHEls7e+J9OICY3Ov0raOX9CurPxJAwyRyzvVAIFbg8RDzcp7tKdiy2SZFXlZe8Dpi9FRRzhcHAO1q57dfANMZ29D+BDj2mL403iAn2UFadfUSdtxRNfuRkHK7iFsSgwRxfMMlVUp7FN6yCIAzd2WJC5m7/c9sg1N9aSLcNyVOzjUqZ0SaQEdy3kNaxCAFfcLRnQS8rKTCyheJmoRWvfIKlkmpQjNUv6/rib3oer/oOzD7TbXPzeo/lGRdoxgKa/t76+ZVHCvNIcQT3gP8upgEqcyEd2D8lHLpLNHxhDDSX5bi7l0LBq2xyc1Jk+1EOcaeiLEqZX4uD5j2AykQyNesZugOQsACvxBeW2hNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(38100700002)(26005)(38350700002)(6486002)(186003)(8936002)(7416002)(956004)(2616005)(66476007)(36756003)(8676002)(44832011)(5660300002)(6512007)(6506007)(508600001)(83380400001)(52116002)(54906003)(316002)(6666004)(4326008)(110136005)(66946007)(1076003)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fCXwTTfLBThL/4hKVRfsBlw7edUyRRyWqoD486xAFdZOjf5jYb3TRfFsLx+2?=
 =?us-ascii?Q?lZuuPRaUXJaD/2/aOf8vEO/CfImZlZTpGvUTnAC5sSAJi8ZhaHnH+fCquig9?=
 =?us-ascii?Q?b5SsEDhELLi1G7QsARSYXPOHAmWNFPkh4c5QPWi1btBk4q7gufuqNATFrXVb?=
 =?us-ascii?Q?q7sVhbHakZQ60+uSPRTtH9KU91vT59tu/M+bhM4s9IzdEdnDRZotjai/fR7d?=
 =?us-ascii?Q?/HX8yFvYf2RuhI0J4YMOth32RNcoTljQ7nA+cbF6QWmgBb4ePwH+WGUECKVH?=
 =?us-ascii?Q?6NW97FoSsaB5SEWPsdZDAsG4hAf4v0LV1Y6BGWGvj69Sb8EBAD3c/0yC2OoH?=
 =?us-ascii?Q?GM4125wz3p4UUeeR/gwl+yhQCaYgeP0OETxxYkZI5LoM+VZfkffL2x3eC2T6?=
 =?us-ascii?Q?L1yTyv3rVp1mVs/ioSpJcP8h4I7JJFOcREs6B+iHLsp6P4rrH2P02wb2QR0O?=
 =?us-ascii?Q?E9NywSSvNca4e/0kFUtjhdaFdBUePvwwamj0y9NREul9jE6NzK9NqPXTve2+?=
 =?us-ascii?Q?ZUUiOKLR4An+tbNTkl7CAEhX0zujLdz3vjhHwBHkkktx1BlvBtZJJSHCsmwC?=
 =?us-ascii?Q?1VkmQA7MKGVVVhxb2twG143BB5zAzxbdl1bvR4W2xUeg/QZNiIW0vf9z01y6?=
 =?us-ascii?Q?8+bZrKSOfd3QHOcTAwCjiWWU+hEm6joUxfbRx4DlLGKVDGauKDn+7DIlFlBq?=
 =?us-ascii?Q?4CtILQ1uc544NtFxk7Xf2RVaptMyuQvHesI3+dnsJJWDOgvMtbsO+mtalFEG?=
 =?us-ascii?Q?Mo5qYq9mhk87iUVSXaf72xdLow02TZukuI31b/RPAS93TAW6QeaunFsgvbla?=
 =?us-ascii?Q?no8AO3lPR2mwZ92Hk8llB0f2f83e2Nu/2h5+UAEHuL44gT7FH5z+QuZoFAHu?=
 =?us-ascii?Q?RG0x2SgqgFXoWVaVlXeJKI5A7rZbtoOkyTJhX+IEnJ1l1HMpFyF7QyeLWzSS?=
 =?us-ascii?Q?BCR1H/SY8vfCIugt5uqODxBrGneQoEpZs3WCoWHekjx4iqITTWcrDEnL1fWk?=
 =?us-ascii?Q?CO7CiOcjJHJTfVO2IDGYoEZzg8PUrK7/7/Y0/YOXhrH2hSzkoFGcwUwBPPS9?=
 =?us-ascii?Q?IPtmBsKpmses2zEQMPPvVG/0G0Z7NUsLYz2jegA5glJ+sIT2lXuYkeoowlPo?=
 =?us-ascii?Q?06SeBbPdDgnsEMUrOKrpa47d914PY/jEdMyo8bQXMegQ5JgB9c/vXiiIpzd+?=
 =?us-ascii?Q?TRagcAdU2U53UUwNPt64jyoV+HHpgQ8oBMWAyuqqKOtgViMY3onbYYlDTvvC?=
 =?us-ascii?Q?IKvvaIg+5SDlwEwqekNJxphXQkMhd7DGOcaRaTe9eAcgWiMSju2WynNL8YlD?=
 =?us-ascii?Q?2aUauToJoZ++6eFIw+pYM5M+wOhqbHf8/E0mC8W0UOzqkgJ3G8Um7aEk5z3r?=
 =?us-ascii?Q?vjPd+wsaAW/8IdKEOk75OD6ojZHGGrK8m5r7NKKulVCrIGiTYq5vMUOEaq7u?=
 =?us-ascii?Q?4nKGfvDSzDHOTOnGUWg/tsFD5+u65yNuUbhr57HmT/Rwon/pjj5WbZjZO0XU?=
 =?us-ascii?Q?R293/n0FF8ekNxO1Nptg7v1gCkW5V5X77JgWF0oE1KNaofu+xNAfw+0wYOOs?=
 =?us-ascii?Q?EcLfgJI2TpaQmuzuLTmwRMJfvtU/6XSks/7BMlKIctA6CV8eErnYr/4u4qpD?=
 =?us-ascii?Q?mhHbsEIbFSD5BbMAWN5UJRo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77407c90-fe53-4656-df80-08d99806384d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 22:24:33.2628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wgAkz4uxWVsiGXUPsJAElvtcnxlNNzpoOJZL4oKUU8kKrAqDW3+it7+0s5790Xe8RtIggmvcXWUYwk/e4uabQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fdb_insert() is not a descriptive name for this function, and also easy
to confuse with __br_fdb_add(), fdb_add_entry(), br_fdb_update().
Even more confusingly, it is not even related in any way with those
functions, neither one calls the other.

Since fdb_insert() basically deals with the creation of a BR_FDB_LOCAL
entry and is called only from functions where that is the intention:

- br_fdb_changeaddr
- br_fdb_change_mac_address
- br_fdb_insert

then rename it to fdb_add_local(), because its removal counterpart is
called fdb_delete_local().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 4fe2e958573e..0d6fb25c2ab2 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -402,8 +402,8 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
 	return fdb;
 }
 
-static int fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
-		      const unsigned char *addr, u16 vid)
+static int fdb_add_local(struct net_bridge *br, struct net_bridge_port *source,
+			 const unsigned char *addr, u16 vid)
 {
 	struct net_bridge_fdb_entry *fdb;
 
@@ -458,7 +458,7 @@ void br_fdb_changeaddr(struct net_bridge_port *p, const unsigned char *newaddr)
 
 insert:
 	/* insert new address,  may fail if invalid address or dup. */
-	fdb_insert(br, p, newaddr, 0);
+	fdb_add_local(br, p, newaddr, 0);
 
 	if (!vg || !vg->num_vlans)
 		goto done;
@@ -468,7 +468,7 @@ void br_fdb_changeaddr(struct net_bridge_port *p, const unsigned char *newaddr)
 	 * from under us.
 	 */
 	list_for_each_entry(v, &vg->vlan_list, vlist)
-		fdb_insert(br, p, newaddr, v->vid);
+		fdb_add_local(br, p, newaddr, v->vid);
 
 done:
 	spin_unlock_bh(&br->hash_lock);
@@ -488,7 +488,7 @@ void br_fdb_change_mac_address(struct net_bridge *br, const u8 *newaddr)
 	    !f->dst && !test_bit(BR_FDB_ADDED_BY_USER, &f->flags))
 		fdb_delete_local(br, NULL, f);
 
-	fdb_insert(br, NULL, newaddr, 0);
+	fdb_add_local(br, NULL, newaddr, 0);
 	vg = br_vlan_group(br);
 	if (!vg || !vg->num_vlans)
 		goto out;
@@ -503,7 +503,7 @@ void br_fdb_change_mac_address(struct net_bridge *br, const u8 *newaddr)
 		if (f && test_bit(BR_FDB_LOCAL, &f->flags) &&
 		    !f->dst && !test_bit(BR_FDB_ADDED_BY_USER, &f->flags))
 			fdb_delete_local(br, NULL, f);
-		fdb_insert(br, NULL, newaddr, v->vid);
+		fdb_add_local(br, NULL, newaddr, v->vid);
 	}
 out:
 	spin_unlock_bh(&br->hash_lock);
@@ -685,7 +685,7 @@ int br_fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
 	int ret;
 
 	spin_lock_bh(&br->hash_lock);
-	ret = fdb_insert(br, source, addr, vid);
+	ret = fdb_add_local(br, source, addr, vid);
 	spin_unlock_bh(&br->hash_lock);
 	return ret;
 }
-- 
2.25.1

