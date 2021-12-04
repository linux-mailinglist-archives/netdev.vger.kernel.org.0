Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC90468766
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 21:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236996AbhLDUPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 15:15:38 -0500
Received: from mail-eopbgr70074.outbound.protection.outlook.com ([40.107.7.74]:17024
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234221AbhLDUPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 15:15:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B9X4mpd6raA3SuKUAGElZSzYTJuOJIBXdvcgN8b7WTgzBmtmF6DqD4RIml6A/0EvDdTlAdgjCY0FowLYG8+XLkW93hDNcbDT6mX4sbtKPVp0Uraa+LXyJNKePa5CIBeT8V2vTt0eevrYuN9MEzYFf3lYeFFiBgo8YS4yRiD3/CGVhKrUt2wtjKD6RtLC4nkB27xOpjg0sU1ykFe7OK7dRtga2AA4MePbvVG1RjkusiKHnW5olqdYaTOpe/2hwS37XXWxagdGekLHNwPY7rqXSVINSohvTXFp9c6QdTGq8uBKZPMtVqv4KgcJPIuIwx5Be7rhnGfOgK11K4eQJcCCrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lrjq9kZjaVxTZ+KziOx4F1q7geJBlNcEZpIB4ESHSLI=;
 b=EXTt5YDDlsqR4fg0Stov5OW5LTiKW1vTUW+WBpr/YfCYd6tlgdei6/Q00g1Ps4xrzsfUacqdWgNhnnMP5b0DPz0nuOrufkb3z69CQkgns49tmZ1cNHB4GJ0CWMBlXmnymyawvqVi8wf0xUJpXJEYRJXcFAhCyG3i2N+ApkRJH9a9XKUZhNoA6wy4O2GX5CNO+9DPXgFiaKI65TtzQ4YHdAHjpvbkxDCre0DSmNq/fGlWD80Qb8Wd54DjqkWu6d6KwuQdvwUKZmx6j9iS/NFappwf3y9pg8aRvIa+YWEuFYr8HST6OoDoid4m1yW5/rMvnPTGV5W+qKXcgbtaL1k8jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lrjq9kZjaVxTZ+KziOx4F1q7geJBlNcEZpIB4ESHSLI=;
 b=nI0bvgPIAVQG3UAsRYCxfoqiiK3Dh5zNe7pWxcM/0aGmLjgAOw2FDnXL2eJeyVDvcbTn9eKmtMGknha0VBRqJ4j5VBXJYEtd8NE5b9BEm812BO8s2IlXdnWC41B9lKRLI9hElzQliCeVw1tXir5R1p1umnPcKUh/0FDCtiKoAbg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR0402MB3651.eurprd04.prod.outlook.com (2603:10a6:208:5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 4 Dec
 2021 20:12:03 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208%6]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 20:12:03 +0000
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
Subject: [PATCH v2 net-next 4/7] net: dsa: rename dsa_port_offloads_bridge to dsa_port_offloads_bridge_dev
Date:   Sat,  4 Dec 2021 22:11:43 +0200
Message-Id: <20211204201146.4088103-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204201146.4088103-1-vladimir.oltean@nxp.com>
References: <20211204201146.4088103-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9P194CA0030.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:46d::26) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AS9P194CA0030.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:46d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Sat, 4 Dec 2021 20:12:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db542366-36d2-4859-7547-08d9b7625624
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3651:
X-Microsoft-Antispam-PRVS: <AM0PR0402MB365149EAA132E6ECA98E5167E06B9@AM0PR0402MB3651.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZHN2S/aJCfYgQNOBvH+2kKADWSsnx8M5GzolbLeMent5xi2osmwK50LeF0lLhyKIIAFOd7H0uHPQdoa7YAUSvkEsuOretnNmaHA9mgRgIRRHWUoTimPLqtWzOL/xi0qxQtA7UZnQjniSJ/AEimQT7HnltdCuC+Cxj11n6eajEPH0hhOaoxR1Y4fDjBx2OvGVtGlKafgiFVAsGQJTiuYnq47Rq+zLUeU5Lcx/NDcSWDVY7Wc5uUyo8UwAvkTaKjfW4ZKKWSK730GYxgPyDQ8hMyHg4COZfSoNDXtuUdr4VJuf1dCzDnnVIpRCv5A2FuXPURRV15fyQQTXSPLv9xMWW4U0prEl4wavptR4l9PxdWYKlbylwM73oHkaC0WtU0qsPL9jJzQN/wziEg1F78UksfeK0ssRezB5w9YOgYNGE2UIr/bCHFVpUbqOB+YpRKnxp6xrpL6BXrKWAxB3cmhRy0c7mv8gd5zcP/nJ9vjJMHD1bQUcXHon8fzf/evMGDlQscxebGjuGJSyyPlAYh6CjbhYJVf52Ud4oeSKRXki8M+bu+16jKBNRqjXmMsj6e663lxDDhcCKLWvOTYTwILZU8qHxT45N+8xHIh3rfB68vC1WdZvm4x1+iF37dCK0KOIvejIvNln71LzbTdYDVPtKooYAw0Vm6vi/FFI/dLRwE4BPaghij7Q8NZO2j7F15Z8mkmAuI+iF9WxaF87ARpi9QgW+r1rOoNuKQ+LntBzt1w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8676002)(6506007)(4326008)(6486002)(6666004)(66556008)(8936002)(508600001)(54906003)(2906002)(44832011)(66476007)(316002)(6512007)(86362001)(66946007)(7416002)(52116002)(1076003)(83380400001)(38100700002)(6916009)(2616005)(38350700002)(186003)(956004)(26005)(5660300002)(334744004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ampOOHZsdXUxL3NvRkltd0dOYktOV3p4azZUT0ppL2hUTGV3d3l1VG4xUVl4?=
 =?utf-8?B?SVFkV2d1U2FTRFJ3WXUwWnp1aStDano2NU9HNGEvTE9oMkVia3dyR1ZyWk5I?=
 =?utf-8?B?ZWVpR3FlR1VXR05WaU1hR09wYmdQaHhyVXlMUUVFUkpVVS95NzQxT2daWTNl?=
 =?utf-8?B?UWR6dkdGd2VhMlpLbHFySlVCMmp5MFp1dU1sZTlNSDJEcU91U29xS01MeHYw?=
 =?utf-8?B?YjJQSTM4WkxncGVnUnE1UGRLcHVKempDZEFUZ0N0WmV0TG8waENkeTdkTC9W?=
 =?utf-8?B?Q3VqajFOamtoS3VrWGJPQk5VQjQwLzBJMjBTUjgwZERTREljTEZRWTZzUVFk?=
 =?utf-8?B?UjlaYmJuYndkSG90Rnp2a1BEb3g5YXUrUmZmRUc1ZWJzTGlPaUFPWDlqK2FN?=
 =?utf-8?B?aCt2WU5kUXUrUndPZWpaYXpXd0VJdnltQmM3Q1k3UHJMSEZpOXJhd1RpRFR4?=
 =?utf-8?B?NC9rMVVGTGRva1Q2OTlDN25la0ttaXZrWlJxcnRsZGRzajFLMUZwaFlKTWNw?=
 =?utf-8?B?ajE0bG9lSDJFMHA0Z2hIdXU5WmFTRm1yUno0WlJObWtSOHllZTQvTzNUTG43?=
 =?utf-8?B?bWxLY0x2TGd5V0s4bnNtZFpJZzJTV0REUThCUDdSQzdPanFWcTlMN1FuMDJp?=
 =?utf-8?B?bU9xbTR1enR3QUVLL3pyZDZacmE0V3lTdFpYQnU3ZzB5cGlINTYrWlZPNzRF?=
 =?utf-8?B?bEE1VWNoVFhzREhFVVdMa0orTzUxRXRvSEp3Q1gvTHM3bmNWYlBxVWJYL1Rl?=
 =?utf-8?B?anBpUjlzS0VnNVYzRkFuQjE5SERIN1hIdW5WdzlRZ2RzNnE1Y0JvWHFiZEw1?=
 =?utf-8?B?YWJWYngrY1l3YTZwTjBGQVFhazhJejhzMnhDUVVIOE5BRnI3TUJMbURHbTkr?=
 =?utf-8?B?YkE2RTdSTldmam16dlNGVTQxWVlOTUxNQlp4ODBjUFFTZi93dXB3dEFDeU9y?=
 =?utf-8?B?VzNQazJXb1BnTDQzQ2VYQlVOUm5maGZSSkJZZlhidHI0cFpZMGdVMkNXZGFM?=
 =?utf-8?B?ZGx1Nk1yQVBQTkhkdWYwV1UyenpKb3pnTzBoalZnM3I3bHJaVG5vcWRieHJl?=
 =?utf-8?B?WmMyTUtFR0Rvb251alFGSGhKQTBpSS9kay9mTm9WOU5JK2FPVXhHSmViM0hY?=
 =?utf-8?B?UjAwRWF1dmtiMVBPamo0RC9YaEhuQ1pMTFdRNWV0WEZnNzJuNGZmaGZRYzZv?=
 =?utf-8?B?b01GMGlaVFJETGxzczZJcHlVcGJja2thUXgvTDdiNnpwalFnZXo2YXpDc0Jv?=
 =?utf-8?B?UEhobm03WnloM2QyWU1IMWpEd0NJQWVBOXphdlVCMlo0R29vblZDWTUybUht?=
 =?utf-8?B?TkJaM216d25pRVhVNGxwMmEzbTMrdHdFU202bEpRdWZ1Q2tSU3FpcldtdzlI?=
 =?utf-8?B?WWMrdnBaK3NZOTZXMUpwRnRoYy9aVTRobS94U1Bscml6bzZYL3Z3YTJLYk5N?=
 =?utf-8?B?YTAxd25jdnhVdU5NTGlWUWVOMysxMlBUVjY3bmE2T2xnK0M0b29HU2dDbm9x?=
 =?utf-8?B?N1pubVVJNjZCQlgybGNFMVJDTEZSc3pPTjl0eEtiTTZpZkw1SWNvK0huRkpB?=
 =?utf-8?B?Kzg2L0wxZ3phd096bmx6Q3hWaU00QW5QV3RSNWxzMzJLNzRpNk1KVFhrUC9H?=
 =?utf-8?B?ZWRUZFpZZU5QcU00SUhtNHp1UHl2OXNZUUV5Z0E2QnVGd2ZyZThHODdtU0p6?=
 =?utf-8?B?cWxYVTdmSXlqckVkSWZicUZ0THFyNkp0Q0dZSEtpZUJ5MEMxeFVST09ZVXN5?=
 =?utf-8?B?eWZLUC9HLzlZRlFMd0l4RktWTm1MWHRNb3R4clQzb0l0d3FMcGphU2JXLzFW?=
 =?utf-8?B?bFp4UisyMTFDK2V0UXJLendhTmVsZTJNd0ZOTDV1KzA3cit4bit1cXZBN0tO?=
 =?utf-8?B?dXhXdllnMFhHeTlNMDdTMTI4a2dORTNUR21HWUJUcXM0emZLRUYzWUY4aW45?=
 =?utf-8?B?Tjc2N2RjUlV0ZTBrT0pUUzNBb0tjUzNVN2E0SmJXZ2tzV2YzRWhNSFpudnpQ?=
 =?utf-8?B?Wk9YRzE5a1RoMERQQWZVMlN0M3NrY29ITkxJUkt3WjVFb2taM21nVnJ3OFYw?=
 =?utf-8?B?Y2d3cVdwcHVNWWs3bzF5aGtnV3FnK2oxUHNoN0JtanpudG5GVlZkTG9WZXZi?=
 =?utf-8?B?bVh6ZDByNk1ld3pvdVhTYzhBVlRBSS9QWTNUd1E0djdSc1U3NlFHbHJ0OEhS?=
 =?utf-8?Q?KSHtb+3SLrIvR0Qv9g8Cd6U=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db542366-36d2-4859-7547-08d9b7625624
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 20:12:03.1022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NayE1dQisaKwIOoroXRNSsFj25C/jcbwtKpAbow67a8oPXHITF5jbG3X0fWrBncOGHKzgZOIlaSHbCH+6aj1gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3651
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
v1->v2: none

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
index 283029ba70b3..7c7aea19db08 100644
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
@@ -2451,7 +2451,7 @@ static bool dsa_foreign_dev_check(const struct net_device *dev,
 	struct dsa_switch_tree *dst = dp->ds->dst;
 
 	if (netif_is_bridge_master(foreign_dev))
-		return !dsa_tree_offloads_bridge(dst, foreign_dev);
+		return !dsa_tree_offloads_bridge_dev(dst, foreign_dev);
 
 	if (netif_is_bridge_port(foreign_dev))
 		return !dsa_tree_offloads_bridge_port(dst, foreign_dev);
-- 
2.25.1

