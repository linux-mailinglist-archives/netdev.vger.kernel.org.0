Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB5146A205
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbhLFRIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:08:13 -0500
Received: from mail-eopbgr70045.outbound.protection.outlook.com ([40.107.7.45]:64823
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348564AbhLFRB4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 12:01:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZVLECPM0uHwVPtL40g7Mh5eMVH6EBJr7JXa3YQWbv/MfKy7QYERFyyorlmGzAKIUdRZ8Pk+kz4r/i2/35kXy+DM/i8r8I6Hj7iK16HNv7LjMfagB1IbkgtkrCqBiHeRxwKB54015FVda39uMeVp+WcA0mhbz9AoAHVPldUOFw/MlaM4LGDzC+vNF1Hg1erPSzKNKZyauPl7Zq2OvvylA4x0gF2OTSPGaH8XnbOADpESXfnywhSDELtPeiEvNBCYWNjYoa7Py3ubeXbBaIlwV38ADveFjT9X5yCbE0Vo4LKsZF3ct95foGRcZx+BIKPc6/Un8MmD6rV7xYmBpODZ3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5tn00FuUzqaPcJWEhk4QL/H157X2/cNtBrANMRcCWsQ=;
 b=ezH68lul8FrJa/waZh8ZLRY5UpBXVCaW7O+dak+Nd16PO0/01wcq7bDbdHImfMlW14Z2l1Nly9iMfCxcD0nurrk2P/g6XB5btcB4+6MvNck9qjO7pmejnE1TnJJI4dJnagsPuE+RP+wci3J36MBPk2QTobc0n96cmaSxhN3zrM7HV4e1p0K4mjaGCsWvpPVSBwXcEP0V0zQymKUMBj5cBaS9LFF0lXFptbUz+tH8ECh0ISACkdNm9Ealz5NPp4h4Ar4CxDzlrkVQiG2lz5M/4dG6CHIiaW4V+vwpKf1HssIsE+N/aMYjjqlzCZMSzqN+7LFsW7U2404W3qYGYKi+WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5tn00FuUzqaPcJWEhk4QL/H157X2/cNtBrANMRcCWsQ=;
 b=slaD4nnglQndM6cOY7IKeGY/KGZ5anTG35+wGJQ8O1v7wUBy28YLt1Jxt/lvWApaqnenC4LOB5AgsrJLSQDFNr7K9hRxyoH6h+iC/w8bOLkVZbOtbUwQKu9zUac/nlThpLYlepQ2PpjE9gQpGN5PsOrWT32nzl0EDiRB1RoUpaU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4912.eurprd04.prod.outlook.com (2603:10a6:803:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 16:58:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 16:58:25 +0000
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
Subject: [PATCH v3 net-next 06/12] net: dsa: hide dp->bridge_dev and dp->bridge_num in the core behind helpers
Date:   Mon,  6 Dec 2021 18:57:52 +0200
Message-Id: <20211206165758.1553882-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
References: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0062.eurprd05.prod.outlook.com
 (2603:10a6:200:68::30) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM4PR0501CA0062.eurprd05.prod.outlook.com (2603:10a6:200:68::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Mon, 6 Dec 2021 16:58:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1c73a41-6951-411e-c8e2-08d9b8d99e51
X-MS-TrafficTypeDiagnostic: VI1PR04MB4912:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB491249749B214EBF83B4CBC3E06D9@VI1PR04MB4912.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YaEoQUzFBRrfkWo0YAYX8/6BzKAekibUUt9gdpus/Rgt2UaqHROXVexC2ktKHT6jts5QXAlBTIqWRFbjlHMfLGHlGaCcgjsAzAEkWYouH4dTw3OvWIpmd/B4NkpJ7k8v7LNlAnLmCxBc8s4E80ZkDMlerFzItvQ8tAw/lKbeFEhlKfy/Fh7ho+qFkhl2rqLBP3q7nia2LjqIeZubxGVthfroT+K3Xiqk9Dfk7aw6jZjjnyF4Xu+Q3mE5czzHX+SNbbdz+ThAZBa9KonjiiL5cVWRKNPVQSWm+jozOzbQSWHh2mMbiJF2FJm9T9ItY/t+iaHaklyMUTeeBbYQUiB/juaIeJJ0hLEEJTNxfcY7h5sNTZVelfbllm7p7H51TfYhkjymnjKTtK+v4lPRK/HG+LCN5uWBKfICxcpSfTFQLBx6wWLRhiKyUZ7vzZbkc6FhjPmIDX+qL48lQG2VfHwNfW/d+AYpBVKcB19J3l3+jcHAt/nPMuI7+eJqBcd7gl4jlNaPiLeT/fzD5W+d4heB7GyOeLZpckYfKvZSyQ6IhloK6EezGOAjfDHFcpbIx577aECZ0VaoUYxJp0vNNg8u4pX7sPSzMELquRX+p4kMg8TkquCys+/l3deaAoaWRkMVqFKHJ5tQsX11k4zDFbvsh87bIyEGWQGBI4knN7PvifZ1sR4XKwYepD4n/pQ3LUR9UEG5yuLgjSYAM4EieAaS3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(6506007)(1076003)(54906003)(30864003)(66946007)(4326008)(6666004)(5660300002)(7416002)(508600001)(316002)(52116002)(6512007)(83380400001)(86362001)(2616005)(36756003)(26005)(6916009)(38350700002)(186003)(6486002)(2906002)(38100700002)(44832011)(8676002)(8936002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9V+Qg8LCb0DLVTNciPU3zdeV9wmrhgCpmw7OFRizwNF4w+MKLTdj7udGWYY9?=
 =?us-ascii?Q?h8AUf0/vMtZH/rscqw/GwruGgtevtqrw2b6d7Tl1/4ehcYKfg1wnvwnMhqzD?=
 =?us-ascii?Q?yAUPeEk+Ba+KUS0z87HiQkLxAjRCc/qA0OXC8+SikCmj+MS3Jp3sLosbHglw?=
 =?us-ascii?Q?KZEwHFgO/t5uyFTBMLPpOQUB/BmXBxQAKmf8igrQJW/yLPkRSDxOnKz2VB/E?=
 =?us-ascii?Q?n+2MRSt0jqenkL70Q44UpJX0EsYsuTW3YlD57lWzZrgbo7hVflnMNcA46MfQ?=
 =?us-ascii?Q?lI/JHvvlOnpqn9qjgSyIYzqDmvT8OhCYjrysygC5N/aNUWc9GpPAF0gwtJ/b?=
 =?us-ascii?Q?Gc1iRsjTVGvZu4M9mECZvNg908JKrJ92FkprkRCOxy15tD0GWIlyJfcZnHGJ?=
 =?us-ascii?Q?oqFw2Sy8iaD/DYvY4m/RFA1wNdsF/TQLpCr3qL9cnaiJpfU41lVjWz86GNgd?=
 =?us-ascii?Q?1+RXWWKFF8J4al5EAWd2OOidToBrZJaTVA1TebMuz1vZYc3AUtcWTLZ1xCyF?=
 =?us-ascii?Q?Va2hkMISFSF7260e14RDCjrOSFOh0zwwSan3QrHnshohPbsapRT69amyMLp5?=
 =?us-ascii?Q?NT6jDAeag/9u3o9VHj+dwpxmdHSzQtun9qIIu0P0+Ow5wT51Y6mjq+HMPYVC?=
 =?us-ascii?Q?PDv6auv7FTENfCYu4of8BjXQyt4iqUcIuT6n8Ma+vTDnJ/OuArfpR2GEEddW?=
 =?us-ascii?Q?yAEkXIa2U5RWBd2aJAbFJFvPKfv0eroA7OJpB4zLVkWavGLS8hSHvv6uYWZ4?=
 =?us-ascii?Q?meUvqrjtKOGASXQx3jekSvxJxIp65rhBz2DgM/Fo1N7M1HrEXNqjyNVnuxz0?=
 =?us-ascii?Q?4wPKHLDh9gG+y2eEu7R1kobIy8FjYhzSxmSUlckDg8WO9rPpO6T+sBsV7cJi?=
 =?us-ascii?Q?fayFXI6fK/xXJp6dQNj1yToGYh4KmCl34hQIM2RoIzQybgFtHjyvPk17Hi8H?=
 =?us-ascii?Q?qAzHzOXtsNGMncT/hxXvruzGnHwjc7Ssvlon9uFoDG3W6YQLBHefXZnonvtR?=
 =?us-ascii?Q?l7tqlulIm1vge90TC4ACOtgxpBSeeMoK/nuz4GrZ5kQBvD6LK1diUzT02cjY?=
 =?us-ascii?Q?l3qa8Naxes4Qhuv+5WInIVbJD4mw1wVZeNvRQYLUREKft8tq3dDuVc++Kucz?=
 =?us-ascii?Q?ZQUUeN2GxZXx3e0hgh16PyGSAxSlMDV4/QOwznXK5SliS/MHq1zj3VaLCGik?=
 =?us-ascii?Q?bw4uUBYpqiij680J6ZJbTyZIbg321B2psE0AaxoXfJzt3mtTZA1/dtZD//he?=
 =?us-ascii?Q?oqEdIEPODMj928D8HcAFoTxO3xoex238meNNJmY92G2nmDY4P/UQHVasDxWG?=
 =?us-ascii?Q?AZzRVr0CmffGextRC3YAEVGiBDojodTJArNlgdT36mif8cPHTRAAwkSZM2E9?=
 =?us-ascii?Q?lGT7dSGRUFtLNFxz8KTvbzXMvr9aJe8f9qxdNedEw5T8MuhzcxKjYQUn3fmK?=
 =?us-ascii?Q?6ULIL3u5Dku3OC3FMDyYE2w47hUBg6rqK5AH9rJz2KeaVJSMTWXPqXrJ0GdS?=
 =?us-ascii?Q?WMvSnQICCprn6UN4XzzZ678IWoUFZYYqPro6FS4YqEbholy3J35j53W6htRv?=
 =?us-ascii?Q?Hik0TdO3yDmx5giJDjr5EruHvlK7h0jiTquwQLe2Kmy8uRMFC8RixyALmtd0?=
 =?us-ascii?Q?bwibdiVS2brLQfBuAQgBbLQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1c73a41-6951-411e-c8e2-08d9b8d99e51
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 16:58:25.5084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w1fHtEFr61SLpKdAHZKXbTcGH2sJb/6X6QaLlZzxnpyo855h/KSYMDFgBXF5ggjAjYNo877K5gGsutoH5VZiNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The location of the bridge device pointer and number is going to change.
It is not going to be kept individually per port, but in a common
structure allocated dynamically and which will have lockdep validation.

Create helpers to access these elements so that we have a migration path
to the new organization.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3:
- removed as many non-trivial changes as possible (split into other
  changes)
v1->v2:
- make dsa_port_bridge_dev_get take const struct dsa_port * arguments.
- make dsa_port_bridge_same return false for two standalone ports.

 include/net/dsa.h     | 21 +++++++++++++++++++++
 net/dsa/dsa_priv.h    |  4 ++--
 net/dsa/port.c        | 35 ++++++++++++++++++-----------------
 net/dsa/slave.c       | 13 +++++++------
 net/dsa/switch.c      |  6 ++----
 net/dsa/tag_8021q.c   |  2 +-
 net/dsa/tag_dsa.c     |  5 +++--
 net/dsa/tag_ocelot.c  |  2 +-
 net/dsa/tag_sja1105.c | 11 +++++++----
 9 files changed, 62 insertions(+), 37 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 00fbd87ae4ff..18bce0383267 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -599,6 +599,27 @@ struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
 	return dp->slave;
 }
 
+static inline struct net_device *
+dsa_port_bridge_dev_get(const struct dsa_port *dp)
+{
+	return dp->bridge_dev;
+}
+
+static inline unsigned int dsa_port_bridge_num_get(struct dsa_port *dp)
+{
+	return dp->bridge_num;
+}
+
+static inline bool dsa_port_bridge_same(const struct dsa_port *a,
+					const struct dsa_port *b)
+{
+	struct net_device *br_a = dsa_port_bridge_dev_get(a);
+	struct net_device *br_b = dsa_port_bridge_dev_get(b);
+
+	/* Standalone ports are not in the same bridge with one another */
+	return (!br_a || !br_b) ? false : (br_a == br_b);
+}
+
 typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
 			      bool is_static, void *data);
 struct dsa_switch_ops {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 70c4a5b36a8b..46a0adfb03cd 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -278,7 +278,7 @@ static inline bool dsa_port_offloads_bridge(struct dsa_port *dp,
 	/* DSA ports connected to a bridge, and event was emitted
 	 * for the bridge.
 	 */
-	return dp->bridge_dev == bridge_dev;
+	return dsa_port_bridge_dev_get(dp) == bridge_dev;
 }
 
 /* Returns true if any port of this tree offloads the given net_device */
@@ -345,7 +345,7 @@ dsa_slave_to_master(const struct net_device *dev)
 static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
 {
 	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
-	struct net_device *br = dp->bridge_dev;
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	struct net_device *dev = skb->dev;
 	struct net_device *upper_dev;
 	u16 vid, pvid, proto;
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 199a56faf460..f6ea41cbcdd5 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -221,7 +221,7 @@ static int dsa_port_switchdev_sync_attrs(struct dsa_port *dp,
 					 struct netlink_ext_ack *extack)
 {
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
-	struct net_device *br = dp->bridge_dev;
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	int err;
 
 	err = dsa_port_inherit_brport_flags(dp, extack);
@@ -372,7 +372,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 		goto out_rollback;
 
 	tx_fwd_offload = dsa_port_bridge_tx_fwd_offload(dp, br,
-							dp->bridge_num);
+							dsa_port_bridge_num_get(dp));
 
 	err = switchdev_bridge_port_offload(brport_dev, dev, dp,
 					    &dsa_slave_switchdev_notifier,
@@ -415,13 +415,13 @@ void dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br)
 
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 {
+	unsigned int bridge_num = dsa_port_bridge_num_get(dp);
 	struct dsa_notifier_bridge_info info = {
 		.tree_index = dp->ds->dst->index,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.br = br,
 	};
-	int bridge_num = dp->bridge_num;
 	int err;
 
 	/* Here the port is already unbridged. Reflect the current configuration
@@ -507,12 +507,15 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag,
 
 void dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag)
 {
-	if (dp->bridge_dev)
-		dsa_port_pre_bridge_leave(dp, dp->bridge_dev);
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
+
+	if (br)
+		dsa_port_pre_bridge_leave(dp, br);
 }
 
 void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
 {
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	struct dsa_notifier_lag_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
@@ -526,8 +529,8 @@ void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
 	/* Port might have been part of a LAG that in turn was
 	 * attached to a bridge.
 	 */
-	if (dp->bridge_dev)
-		dsa_port_bridge_leave(dp, dp->bridge_dev);
+	if (br)
+		dsa_port_bridge_leave(dp, br);
 
 	dp->lag_tx_enabled = false;
 	dp->lag_dev = NULL;
@@ -556,8 +559,8 @@ static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 	 * as long as we have 8021q uppers.
 	 */
 	if (vlan_filtering && dsa_port_is_user(dp)) {
+		struct net_device *br = dsa_port_bridge_dev_get(dp);
 		struct net_device *upper_dev, *slave = dp->slave;
-		struct net_device *br = dp->bridge_dev;
 		struct list_head *iter;
 
 		netdev_for_each_upper_dev_rcu(slave, upper_dev, iter) {
@@ -591,17 +594,15 @@ static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 	 * different setting than what is being requested.
 	 */
 	dsa_switch_for_each_port(other_dp, ds) {
-		struct net_device *other_bridge;
+		struct net_device *other_br = dsa_port_bridge_dev_get(other_dp);
 
-		other_bridge = other_dp->bridge_dev;
-		if (!other_bridge)
-			continue;
 		/* If it's the same bridge, it also has same
 		 * vlan_filtering setting => no need to check
 		 */
-		if (other_bridge == dp->bridge_dev)
+		if (!other_br || other_br == dsa_port_bridge_dev_get(dp))
 			continue;
-		if (br_vlan_enabled(other_bridge) != vlan_filtering) {
+
+		if (br_vlan_enabled(other_br) != vlan_filtering) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "VLAN filtering is a global setting");
 			return false;
@@ -685,13 +686,13 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
  */
 bool dsa_port_skip_vlan_configuration(struct dsa_port *dp)
 {
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	struct dsa_switch *ds = dp->ds;
 
-	if (!dp->bridge_dev)
+	if (!br)
 		return false;
 
-	return (!ds->configure_vlan_while_not_filtering &&
-		!br_vlan_enabled(dp->bridge_dev));
+	return !ds->configure_vlan_while_not_filtering && !br_vlan_enabled(br);
 }
 
 int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 33b54eadc641..99068ce21cfe 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -363,7 +363,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	/* Deny adding a bridge VLAN when there is already an 802.1Q upper with
 	 * the same VID.
 	 */
-	if (br_vlan_enabled(dp->bridge_dev)) {
+	if (br_vlan_enabled(dsa_port_bridge_dev_get(dp))) {
 		rcu_read_lock();
 		err = dsa_slave_vlan_check_for_8021q_uppers(dev, &vlan);
 		rcu_read_unlock();
@@ -1580,7 +1580,7 @@ static void dsa_bridge_mtu_normalization(struct dsa_port *dp)
 			if (other_dp->type != DSA_PORT_TYPE_USER)
 				continue;
 
-			if (other_dp->bridge_dev != dp->bridge_dev)
+			if (!dsa_port_bridge_same(dp, other_dp))
 				continue;
 
 			if (!other_dp->ds->mtu_enforcement_ingress)
@@ -2220,7 +2220,7 @@ dsa_prevent_bridging_8021q_upper(struct net_device *dev,
 				 struct netdev_notifier_changeupper_info *info)
 {
 	struct netlink_ext_ack *ext_ack;
-	struct net_device *slave;
+	struct net_device *slave, *br;
 	struct dsa_port *dp;
 
 	ext_ack = netdev_notifier_info_to_extack(&info->info);
@@ -2233,11 +2233,12 @@ dsa_prevent_bridging_8021q_upper(struct net_device *dev,
 		return NOTIFY_DONE;
 
 	dp = dsa_slave_to_port(slave);
-	if (!dp->bridge_dev)
+	br = dsa_port_bridge_dev_get(dp);
+	if (!br)
 		return NOTIFY_DONE;
 
 	/* Deny enslaving a VLAN device into a VLAN-aware bridge */
-	if (br_vlan_enabled(dp->bridge_dev) &&
+	if (br_vlan_enabled(br) &&
 	    netif_is_bridge_master(info->upper_dev) && info->linking) {
 		NL_SET_ERR_MSG_MOD(ext_ack,
 				   "Cannot enslave VLAN device into VLAN aware bridge");
@@ -2252,7 +2253,7 @@ dsa_slave_check_8021q_upper(struct net_device *dev,
 			    struct netdev_notifier_changeupper_info *info)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct net_device *br = dp->bridge_dev;
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	struct bridge_vlan_info br_info;
 	struct netlink_ext_ack *extack;
 	int err = NOTIFY_DONE;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index bb155a16d454..7993192fe769 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -151,11 +151,9 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 	 */
 	if (change_vlan_filtering && ds->vlan_filtering_is_global) {
 		dsa_switch_for_each_port(dp, ds) {
-			struct net_device *bridge_dev;
+			struct net_device *br = dsa_port_bridge_dev_get(dp);
 
-			bridge_dev = dp->bridge_dev;
-
-			if (bridge_dev && br_vlan_enabled(bridge_dev)) {
+			if (br && br_vlan_enabled(br)) {
 				change_vlan_filtering = false;
 				break;
 			}
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index df59f16436a5..e9d5e566973c 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -337,7 +337,7 @@ dsa_port_tag_8021q_bridge_match(struct dsa_port *dp,
 		return false;
 
 	if (dsa_port_is_user(dp))
-		return dp->bridge_dev == info->br;
+		return dsa_port_bridge_dev_get(dp) == info->br;
 
 	return false;
 }
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index a7d70ae7cc97..8abf39dcac64 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -132,6 +132,7 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 	u8 *dsa_header;
 
 	if (skb->offload_fwd_mark) {
+		unsigned int bridge_num = dsa_port_bridge_num_get(dp);
 		struct dsa_switch_tree *dst = dp->ds->dst;
 
 		cmd = DSA_CMD_FORWARD;
@@ -140,7 +141,7 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 		 * packets on behalf of a virtual switch device with an index
 		 * past the physical switches.
 		 */
-		tag_dev = dst->last_switch + dp->bridge_num;
+		tag_dev = dst->last_switch + bridge_num;
 		tag_port = 0;
 	} else {
 		cmd = DSA_CMD_FROM_CPU;
@@ -165,7 +166,7 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 			dsa_header[2] &= ~0x10;
 		}
 	} else {
-		struct net_device *br = dp->bridge_dev;
+		struct net_device *br = dsa_port_bridge_dev_get(dp);
 		u16 vid;
 
 		vid = br ? MV88E6XXX_VID_BRIDGED : MV88E6XXX_VID_STANDALONE;
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index de1c849a0a70..4ba460c5a880 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -12,7 +12,7 @@
 static void ocelot_xmit_get_vlan_info(struct sk_buff *skb, struct dsa_port *dp,
 				      u64 *vlan_tci, u64 *tag_type)
 {
-	struct net_device *br = READ_ONCE(dp->bridge_dev);
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	struct vlan_ethhdr *hdr;
 	u16 proto, tci;
 
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 262c8833a910..6c293c2a3008 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -159,14 +159,16 @@ static u16 sja1105_xmit_tpid(struct dsa_port *dp)
 	 * need to find it.
 	 */
 	dsa_switch_for_each_port(other_dp, ds) {
-		if (!other_dp->bridge_dev)
+		struct net_device *br = dsa_port_bridge_dev_get(other_dp);
+
+		if (!br)
 			continue;
 
 		/* Error is returned only if CONFIG_BRIDGE_VLAN_FILTERING,
 		 * which seems pointless to handle, as our port cannot become
 		 * VLAN-aware in that case.
 		 */
-		br_vlan_get_proto(other_dp->bridge_dev, &proto);
+		br_vlan_get_proto(br, &proto);
 
 		return proto;
 	}
@@ -180,7 +182,8 @@ static struct sk_buff *sja1105_imprecise_xmit(struct sk_buff *skb,
 					      struct net_device *netdev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
-	struct net_device *br = dp->bridge_dev;
+	unsigned int bridge_num = dsa_port_bridge_num_get(dp);
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	u16 tx_vid;
 
 	/* If the port is under a VLAN-aware bridge, just slide the
@@ -196,7 +199,7 @@ static struct sk_buff *sja1105_imprecise_xmit(struct sk_buff *skb,
 	 * TX VLAN that targets the bridge's entire broadcast domain,
 	 * instead of just the specific port.
 	 */
-	tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(dp->bridge_num);
+	tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
 
 	return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp), tx_vid);
 }
-- 
2.25.1

