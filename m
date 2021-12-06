Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA17846A208
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240101AbhLFRIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:08:20 -0500
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:53123
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348580AbhLFRB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 12:01:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKV79tetCYbwQfEZQmK32Qpyx60bbNGi/0If02yZnVxTdUM4NzKwQktjIb43YmJksPFoqfonjiaJBKobMijPPzspKWBTvZRExo84SQdwGZsBU3M9RAk40ddirb/I/F3mGMKMPeneRsWbtB0MRj8wc5I8+zwbpQwqiDoRqw0pZEVFWYqGvTVXWppRCZl30+FhRFOwOrGlZIpxXpgGWggiYMb2SFYVcbJxTXNLm1FntTtk44nYIO4/+Ln4dLjs0RVbcP5Y2c5psrn5qejvfNJFaMRkucNd2aUMH9pf/gYwMb3oClJdgbF/OWh74QdWMGqvi6hZDF9HQxEg7Et9rhreLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vEmBWcxU/kQrR/6rUQyV3PafL6sAZzjXjfXVuR2BsGA=;
 b=Gj7P1xMtDyjEuxKWSx3nSBG60iz0t/0vScv3Ou2/oRhOaTBwPl/c43y5EapCfN/8RdholD4Y2zzCAYct+nE2/GJ6YbsDN794IVqw5Ra9sKU1wBB8fNz/awWBAaRwU1CyC2NmcS1KTuhsEgR9egg6aSdfrm/MNcF14hi3PXWAfY7Q0EMx7EqrflJtSwrWjIKKhphdSQc8ZrESAzZm0PunVr/Ta8yfZvtjMXy45Zv8blQWDVJHFcom4UrsREq+3UKoHvLg0CesS+okY8FL06TcupQRuGBlQ9DdWRyII+kYYH5JH/rBdq0D7HJzsdJ8DcrhbQZCV0GtNwMnhwPkTYkI+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vEmBWcxU/kQrR/6rUQyV3PafL6sAZzjXjfXVuR2BsGA=;
 b=mXs2ObMflrOdFPWbIzp8hCg9A1mvZOBI9/nBYz8VXfvs9VHWlthp3VgKx5Rc5RuFIZk2YdQC2VjDoaohSvF6YfyQQc9wnqSP+058omGetkQMOPCthJlafj9ueFQ/BNo71XLVYlFeGg3FLsKJVOF+2YfgCnpjJwHKgR30UNG18WA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4912.eurprd04.prod.outlook.com (2603:10a6:803:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 16:58:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 16:58:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v3 net-next 08/12] net: dsa: rename dsa_port_offloads_bridge to dsa_port_offloads_bridge_dev
Date:   Mon,  6 Dec 2021 18:57:54 +0200
Message-Id: <20211206165758.1553882-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
References: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0501CA0062.eurprd05.prod.outlook.com
 (2603:10a6:200:68::30) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM4PR0501CA0062.eurprd05.prod.outlook.com (2603:10a6:200:68::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Mon, 6 Dec 2021 16:58:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc761066-3624-4889-8004-08d9b8d9a059
X-MS-TrafficTypeDiagnostic: VI1PR04MB4912:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB49121570BD2DAF6B033C3B3DE06D9@VI1PR04MB4912.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kej6fm9l69iPBN14xGcK52H0tBF3eimieaRIYD8cMlnWgEItpuA4Pwi+sFpydRUb0SteEkBskzXfJCHMuvn5x4OL1XP9YrPD40fsi61D186it4AbpzsYzxfJlU3bxIRV6+iZI9M+XIKjiPTUhOJtBksV3zFCxa+RsU8etf2YZ5IPo2mSnxzw/d1IjzZlp1UkhiUMOznjNwLLxh/aT69FyJ3SAYkOm7pxjMIvPx0EiEByTEUTm89BbTW3htbd7DDCFviFaUjPbgL8A1pMUmNReBCVgGI2W7qBwnPVQGUcTJNYMBus1n+lMgIuh0OcgU+RKTslJxR/ezwHqD14LNGSSDC+8JpSB/XCLOrjVwGtwpeE0bDPqmUHGycB/Ov3iAiYXBi3/koyRbzET94iKo+k5a04uWc/0YnbjPqFuvKB0BqqpZRFJ6Gu8d4iHD7nUP+q4ycaLX8P5fadDRZwI96VLbnHZHzUlXsemNRWTmd+mlHNt1HmPQmfKi6gS03QqK7Xf2vTGsRFG4S7+95xsdzwKSMPD1vd2pUntD1w4NeaTcnJMfAqK/tWyGtOnncF4VCt3csdBzLn4f+WTmsHBM/K1CjeDczkK9c/CPM+k/3lGCd79JW35EGHe7v7hNm7EF3aq98X+QqBE8+ectPfeS+8dybfk1T8kxtwBrkaWeSECZNjwmVO4KeHeEyG48QUkKbPiHfGVniBEz2XJ9VkMJGF2Pz3UScys/sSeGx8HEve+Yg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(6506007)(1076003)(54906003)(66946007)(4326008)(6666004)(5660300002)(7416002)(508600001)(316002)(52116002)(6512007)(83380400001)(86362001)(2616005)(36756003)(26005)(6916009)(38350700002)(186003)(6486002)(2906002)(38100700002)(44832011)(8676002)(8936002)(956004)(334744004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUh4dURaM0pWalVFQUNjZlFVSFhmM3pwR0NSU0c1WmRURVVmU05IeHJsNVd4?=
 =?utf-8?B?UEtpTThJWmRYNWNyaVN3eWxiRFBuQm81bnE3WDhTRFAybnRIVjI5b2FRb3JJ?=
 =?utf-8?B?YzZ4K2VQZWVKcEFFcjJ1SW5WSFF0TWhibFhYMjFwekQ3VFBEMzQ3MlNMWnRL?=
 =?utf-8?B?U3hIUDVKQXdoaGZoU3FzcTVKYTZxd0Y4UytkSmFDR2FUK0Q5WXBCK1VpL3Ns?=
 =?utf-8?B?YlU1OC8rRXhuSmtJVDd2SVU2YVBmR2VGUytSZDltQlN0dHFqdG02YzZUdW9N?=
 =?utf-8?B?N042YVFUYlF0OTVKTFFGb3NSV2RaRE54SnpGRmZ3cUdRWG0zcUhWZ1hkcW1x?=
 =?utf-8?B?VE8zVHV3ZU13Y0M1RnhJNFMrVzJ4Qm5rOU0zKytuSXJRUFFnVkpGWUliWkVs?=
 =?utf-8?B?ZWYwNWcxT3JhdUczMjNveVZRRFJGamdmbGpVaDE4NE5jdENxdjA3VENyV1gy?=
 =?utf-8?B?ZXN5eXZVTWdlbXlLRThKd2VEY0hqOG5JeGNHMStOKzQrczNGT0x0eWprQlky?=
 =?utf-8?B?aG5JUy9lYmlTVGZKNTcyOS9idkVTTlBSZE1HcEhacDVDNWVtaHVVSWJDMVMy?=
 =?utf-8?B?cnJBeWdGZHcwMWh5YVc1RGVwb3JjVTBLM1d4TS81RnQraHhIbmdQWVpsUXpP?=
 =?utf-8?B?aGttbzI2MG1zQUZKVnpXejVGa0R2aVZWaUlCejBPczZrM1ZOS3dsNjBXVnFC?=
 =?utf-8?B?UkRGaDNrS2dubGhjbTJnRmYzeXBHNFpYZ2pabWkxRkJIdzA1RXl2Z1ZKMGNn?=
 =?utf-8?B?bDBGY3R6MHZZSy92UTZxL0ZwdG9TYzdhQnkyTUQ3OUVjb1RzU0djUUF5dUtr?=
 =?utf-8?B?QlgyL2ZFeGlsL2piaHo1M21Rbm5vbnA4WndZWE83RTBHNThNNmN4bFVOMDlJ?=
 =?utf-8?B?MUdidFEzK29acktHMWJwYWVML0xnelBCb2RQYTVJSFRGcVNKS2hpR2lVOUht?=
 =?utf-8?B?SmMzTFN4UnJUQzc4V0RBUnZuSEVkUFlKbUErNFFIVkVKQU1PUUtVZG1YYjQy?=
 =?utf-8?B?YU9mTGdGb2x2a1duYTNKVE9mWko0ZmNPNm8weGtTZ1VUV2orRmRscWZaQmF5?=
 =?utf-8?B?em0xUEFicFdoa3Ixd1dwYzlYSVpTdFpYZDVCbDVxN1VIdGQxa3pCWEdjV2Qr?=
 =?utf-8?B?ekhxenRaRmdvVFVBUVFwa09XMGJqKzJ5bm4wRVBjbHpMV0JSNlBydGNWYXZJ?=
 =?utf-8?B?VzI1MXN1TWRtaU5nOWlJazc3cTNPOFhNNXZsTnFUNGhOM01TTjBkN0dqSi9l?=
 =?utf-8?B?dE5RWWxOVUMxZHNINXdxV1dpbDZQRUZTdGFuR2laNTlKaWpIWEEybU9FbCsy?=
 =?utf-8?B?YnlTcWR1dnV4NGNsYWwyWHpScVNWNWdmd3RHbGVNOU9wSktMR3BxOUpyNjZt?=
 =?utf-8?B?dVF5L0pXZ0xrak5GNFFEUWpUMGdibHdScDRXbXB1UVYwVXJqbFgzVDhqTkpN?=
 =?utf-8?B?TU1rTHlRWlJYZUg2c3g5THBtL2d0VERENlkyeXo4UDVqelZ4bVFldkRVcmJu?=
 =?utf-8?B?cHJSSHR0cXF5Z3RNclFWMmRZVWtnZmdzZFdxcnAzUk15bnhsSExGSU50Z04r?=
 =?utf-8?B?QkdJOHdUdVpBRVZmSzk5eDhCT1dyTW44TmFuTFNRYU9vb0lxUGsvVjRSMW5N?=
 =?utf-8?B?cDM4ZGJqSGxINUFCcUkwU2pnaTZYZWhnelJaeU1kR3BmaGhFcHZqS2MzY0JE?=
 =?utf-8?B?ODJOZ0Zaa3J0Q1M2N0lzMVBvYXlHd2k5ZE5KU241SWlhWG5rcmpvTE02MEs1?=
 =?utf-8?B?dEZtTDF5eVZ5RXhtUE9welg1cGRUcjRvcWF1RXJsY1JIa01zR1BpVHpjRUtG?=
 =?utf-8?B?OXJEbTZzSmtEdFFtWExFQnc2NnliaUtta2FpZkpZSkpmNHFROUZXelB5ais2?=
 =?utf-8?B?ZDNScTlINFRodUt2cUc1a2pHbmtnZlBFczRyMFFuR016NE9peGhYY04rU3Az?=
 =?utf-8?B?UmlGS0pjcVpVcmpVeUF4clpaWVY4OUZvV1VpSU9KbThkL3dQVEgya2hSam92?=
 =?utf-8?B?Y1lBck5EMWUrMURuUHQ0eU5QU0d4VGRKN2xDRUtsVjlJeHpxM0hIQlg2Uzkz?=
 =?utf-8?B?Q2dSV1RZRkNTQWNkNG9OeXdZeEliTnFKT3ZYZStndW1oMFF4YTR3VkY1MzF2?=
 =?utf-8?B?Zy9TN01SMUdvTFlHV1N1Q21RKzZZZkhZU3M2NjZZeFQ2QWh4eFBSalN6UVVN?=
 =?utf-8?Q?EA2UN5pWj07tjvZZ45uk+nE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc761066-3624-4889-8004-08d9b8d9a059
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 16:58:28.8676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1EgqRNA/6GEdkJCGW4vKhcSYAzEMz4qsiyeHHMm/kOre3xGFqXMc1OWU/v/xKXhsvU8HZY5v2Vxsf2WGxHn5Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the majority of dsa_port_bridge_dev_get() calls in drivers is
just to check whether a port is under the bridge device provided as
argument by the DSA API.

We'd like to change that DSA API so that a more complex structure is
provided as argument. To keep things more generic, and considering that
the new complex structure will be provided by value and not by
reference, direct comparisons between dp->bridge and the provided bridge
will be broken. The generic way to do the checking would simply be to
do something like dsa_port_offloads_bridge(dp, &bridge).

But there's a problem, we already have a function named that way, which
actually takes a bridge_dev net_device as argument. Rename it so that we
can use dsa_port_offloads_bridge for something else.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
v1->v3: none

 net/dsa/dsa_priv.h | 12 +++++++-----
 net/dsa/slave.c    | 18 +++++++++---------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 46a0adfb03cd..33fef1be62a3 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -272,8 +272,9 @@ static inline bool dsa_port_offloads_bridge_port(struct dsa_port *dp,
 	return dsa_port_to_bridge_port(dp) == dev;
 }
 
-static inline bool dsa_port_offloads_bridge(struct dsa_port *dp,
-					    const struct net_device *bridge_dev)
+static inline bool
+dsa_port_offloads_bridge_dev(struct dsa_port *dp,
+			     const struct net_device *bridge_dev)
 {
 	/* DSA ports connected to a bridge, and event was emitted
 	 * for the bridge.
@@ -295,13 +296,14 @@ static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
 }
 
 /* Returns true if any port of this tree offloads the given bridge */
-static inline bool dsa_tree_offloads_bridge(struct dsa_switch_tree *dst,
-					    const struct net_device *bridge_dev)
+static inline bool
+dsa_tree_offloads_bridge_dev(struct dsa_switch_tree *dst,
+			     const struct net_device *bridge_dev)
 {
 	struct dsa_port *dp;
 
 	list_for_each_entry(dp, &dst->ports, list)
-		if (dsa_port_offloads_bridge(dp, bridge_dev))
+		if (dsa_port_offloads_bridge_dev(dp, bridge_dev))
 			return true;
 
 	return false;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 99068ce21cfe..4a4c31cce80d 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -289,14 +289,14 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
 		ret = dsa_port_set_state(dp, attr->u.stp_state, true);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
-		if (!dsa_port_offloads_bridge(dp, attr->orig_dev))
+		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
 			return -EOPNOTSUPP;
 
 		ret = dsa_port_vlan_filtering(dp, attr->u.vlan_filtering,
 					      extack);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
-		if (!dsa_port_offloads_bridge(dp, attr->orig_dev))
+		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
 			return -EOPNOTSUPP;
 
 		ret = dsa_port_ageing_time(dp, attr->u.ageing_time);
@@ -409,7 +409,7 @@ static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
 		err = dsa_port_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
-		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
 		err = dsa_port_host_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
@@ -421,13 +421,13 @@ static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
 		err = dsa_slave_vlan_add(dev, obj, extack);
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
-		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
 		err = dsa_port_mrp_add(dp, SWITCHDEV_OBJ_MRP(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
-		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
 		err = dsa_port_mrp_add_ring_role(dp,
@@ -483,7 +483,7 @@ static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
 		err = dsa_port_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
-		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
 		err = dsa_port_host_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
@@ -495,13 +495,13 @@ static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
 		err = dsa_slave_vlan_del(dev, obj);
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
-		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
 		err = dsa_port_mrp_del(dp, SWITCHDEV_OBJ_MRP(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
-		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
 		err = dsa_port_mrp_del_ring_role(dp,
@@ -2450,7 +2450,7 @@ static bool dsa_foreign_dev_check(const struct net_device *dev,
 	struct dsa_switch_tree *dst = dp->ds->dst;
 
 	if (netif_is_bridge_master(foreign_dev))
-		return !dsa_tree_offloads_bridge(dst, foreign_dev);
+		return !dsa_tree_offloads_bridge_dev(dst, foreign_dev);
 
 	if (netif_is_bridge_port(foreign_dev))
 		return !dsa_tree_offloads_bridge_port(dst, foreign_dev);
-- 
2.25.1

