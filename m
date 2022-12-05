Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E199F6423C6
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbiLEHoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbiLEHnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:43:46 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2047.outbound.protection.outlook.com [40.107.100.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA78D140C6
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 23:43:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HdL2NBRV4Y9z5aS1IKiicgAmzJAEvSLzLcEWRTSKyGYnSiHc6KS3lgslL/d2reJIo27Ui9+3Y0NIShDb0wW9QIzBwkMP40MJbtzdlvWQFOu+Wp+7PLxBHBFE0+kzj3eVUCGKAKJo+Pz94xH3wyExItuxHSOu3RxFQ6TGqP1ZQwofdEjSAcGcVXR5OamsRZcsjG5g7X4bYYNP7gZ68eodLAJKxIisyBWvG95qhl/eETYzn4IuBG6AoJ4nC7IVMWdB/BZBPtVaFr0rN2ZCLPI8L6e/4TYPgEcrHcf0Ab565NlsiNvVtN/la5fbanY1sRWmKjg5wYnyk31d1srEQTjyvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=osLKPcm17h6ifVTy4t+AKITNCG0OSYf4BrOSyz36crE=;
 b=X85nQXeB8GlQa3zfSOqom5i2PIuLmnrJ2rCUejlGQGtZqtOEoPVNJEZ/1brKFSKwVH7ysdyV67YK7kU99wDQ20fznLi79CMnNKRgzWnMA7dkNzxT67kk5wIDV6K/k7sKczomdxxKP0xW+6lak/Ru6cIXNQjK4qDU8A/Pxwp9UxZ3plGk3eTZFJ8FMx+VOtwUL3MPSoIhmjwK5rOEX8sOhvnnmEVDhVaEOZkcXiNC5k3qJ1PN4CukDxSxGURbc4C4OqIQz7U7Oq3imJ9+L7iasK7+sjbe/Zz44WMhH75/qMOPp7JyPc4n+R4Ztdc5/wghMGI9WjTTQciQkRSrdaQD3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=osLKPcm17h6ifVTy4t+AKITNCG0OSYf4BrOSyz36crE=;
 b=GRgYn5V2SJL5ja2XllKreGL1/HwONt3/GUtJUE15HlkonMfgaBdAkdIQhjyxlV16z/9VHB9FXv3UACiWyz0OXHZr1d4+qDraw36WipdRI+N24LwQI8smMmcbpv1ry79IOkhcTwzXuf+2OWSdcrfZ1Sr6oXtalUHqEiQcP1BXxEYB1Usr/8jAr6/XB6FfacRQBLXoprob6Z5ZOcS49Z4p+r01ILzScZ3krZdObLAW0bAsZKMhmrA3QGKnIWZdlx+/TMkZssBQVJb88fY6n/DOlc7bcNOX/5dwvPYvkvJN2MdADFkoP9K2qejMs3u8fLD1jtKh8su77E9i5aFhWpR+lw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by PH0PR12MB5607.namprd12.prod.outlook.com (2603:10b6:510:142::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 07:43:44 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::193d:487e:890f:a91d]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::193d:487e:890f:a91d%4]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 07:43:43 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/8] bridge: mcast: Use MDB group key from configuration structure
Date:   Mon,  5 Dec 2022 09:42:48 +0200
Message-Id: <20221205074251.4049275-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221205074251.4049275-1-idosch@nvidia.com>
References: <20221205074251.4049275-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0031.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::19) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6163:EE_|PH0PR12MB5607:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c707734-1aa0-4b1a-f3ef-08dad6946f53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8sXjbNbwKvdefJd961yfB4zrxeQwtU7Qvd3x9vw/zgC9cd7/irZng66DaeZ8vB9aCXNMf7U5iKKPRxrA6cjrflgSvotZ2PYCivjvtsyNX5F6HgjBusI2g09C+7EvJ8m/djB+0kh5VxMOw+wqXFThCxgupajKgNqxZ6Oyi7mZ9zB6RLN1e1NPONv1YMyY1mTKhuhP/9OkBtYQCR4pNnBTrOo/67FV8VCtRV3lbqFYYxsTfEV6/gnT4sty+p4MwdzjFM1RPIjpM4KgnXjEQ1hY1Ez/h8R1iqca5klY6TEaNhccrXF0FoqyXWKqdaZMk2alJw5vib8vPgXA+gHYisteQDowNToWGCtzHGzDA3OIF5FK2LJC/kSgCB1K/NNywZVzqUsERH9eT+AwcGW5ayjUQW/P8YdVRJtww+lvi6j+kddhf7QPSauv0T8RzAlcbPMrWQZr6aAm7DErmeWm4ntHkbONZsKtK3XawfCEvS2udfmVevI2uQ6N/ssvzWq+iZ9oGKCoemGJn9tfABIbOhPA2EMzSDvc9/6Mq0fbbPgT7IUIIef5AfNm3pkaFxdKwPbdev2sIrC5kbO8xpmPeDhaLKWIpAfjdJzRCow4eP7oeKgkbMQX13YkWoitJR2gRxZWpQNV/Ty1BC7CXh36oKKLfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199015)(36756003)(38100700002)(86362001)(5660300002)(2906002)(41300700001)(8936002)(4326008)(83380400001)(66476007)(66946007)(66556008)(478600001)(6486002)(316002)(2616005)(8676002)(107886003)(1076003)(186003)(6506007)(26005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5aMdULAIG+aAbRgS49TQqpMTefBLWQFwZEE/hmMW1C4D7gTCYfya5WP41Dgg?=
 =?us-ascii?Q?x0utHVJEPQsluX33JSFHheU6i60NNfgnTyBCLBC4E7Bie1W9TzsCqf4d1Ov5?=
 =?us-ascii?Q?AcdbuLIzM5qBVsnwOm1JGQpcwc6RJgIvtFwy2T2/KzwKV4a1gCQYytZE0qSJ?=
 =?us-ascii?Q?o354Rt8wZb+y0JBSwdS5riTTWsfPZhKUqO6qbEXJw6LObUoTbZu6WDe3hNcw?=
 =?us-ascii?Q?4upv3b0EwevQN8cpBHkNsm41iW2042R3T5lbiFSvTQWgFyCH+MIDrbYkphLi?=
 =?us-ascii?Q?JPjLFvtZ+mBO8iB5SlLhfYhpHCrit25m96FEqRwDEWs2aQXEHjb0J68cbUzs?=
 =?us-ascii?Q?V593XOiaUzxcRLMf83aIlUvPMaorxuPJxueR1p1k+rg01+KsDS5jrCIJRk6i?=
 =?us-ascii?Q?UkuIBVjFeYaBgPCXR/qjCKFvoJ5q5xF9dhH3uiHv94liQmkz3VtZDPRGL+/k?=
 =?us-ascii?Q?nMPd65co02j7C96r3AaZX7YudUqgPN+zLpLxpZriqxJcim/k/fH39a+wg4YF?=
 =?us-ascii?Q?GXBUzedWjMphHR4WBejxKAC2UvW7tSYk1fR1ZKRxxoqURH/z8oX1BOih0KSk?=
 =?us-ascii?Q?wT7Y32JhQ95MafpTA2LdcnIFmN9O+3svI4dCDUrAmXijcTAJ/XQVRepv9wsy?=
 =?us-ascii?Q?LGME/eg5Fd9gCBegw5dPtl330B7HvGv0oSHNr7+WJ7I4GOcxWXrDJbHhwalV?=
 =?us-ascii?Q?dr3hBli012Ualuavm0Aj+/0pphvTCSae+9TfkrMCgtxR+rdfZo1PMC2WE9Jg?=
 =?us-ascii?Q?/RwQtY+XlWXSNWouFg7H/ATRFINoQ+7OwXj47TpCLaDvmqK50VhlE75qmyjL?=
 =?us-ascii?Q?XPMnMrZtplLjjBIXDzs8Fren80iO5lkNXQM04yuc0Xg3OL6JQKQ7gszjNJMx?=
 =?us-ascii?Q?OT8gwE/ad2szRMrzEL6vgNtEWvrMjrxVN/1OzMTsruXPngAyaE2VKxErMw7S?=
 =?us-ascii?Q?XfEtjP710i5UZzoAF4yrFzFIR0si6OH7iKfVWQXwuVWFlv3Ke7K4cXqFGmLg?=
 =?us-ascii?Q?p6fctruM9YO8Zl8OniJyOXH/Upms/82iRI+UMXgXsQ+kSH91W4KbKDU/SY37?=
 =?us-ascii?Q?rmHJtHYVuOoMZFCmKrSiZmPrDpFOHgVXZKUJRlZNah6tytBMpeXZ9rSfW/bN?=
 =?us-ascii?Q?PyVymDf2fVwAdd0K9loGxSj7h2GgkHoh3p6r1aW5mLgrveBH+xHd5bUk68Si?=
 =?us-ascii?Q?8Si8kSQDlXHUvDwnl1WCD4NO/zaOs0qn8OY46f6WEJB0kVb1T0RPXqck6NqR?=
 =?us-ascii?Q?LGnb5MSg89jTMnewK5K5NA4a2OekVvsi9OgsUg/GPJs1KWZPDpt6d0xr9nX1?=
 =?us-ascii?Q?CrAbq+CpeBYLxk3j82HqbPD9k4DagaqYv3yWlAT7T9FSnQKVrm0mMSgMmHhy?=
 =?us-ascii?Q?+VROndON24RUhDEIE+fg/I7Gg/a8Ia8PYJoyhELECpP1uS1U1LlLiKe+LW5z?=
 =?us-ascii?Q?U64/jW8Ap5INnRCa0yoWIcyokQCUV0DyjdDMJqicN2eP9i64NYSjbVyEO7X2?=
 =?us-ascii?Q?/dv65QJ9vnHOKcn6+7H4vXOx27hiSGu/qhoO04I1/tCpnJNjU2uRX74/BxKe?=
 =?us-ascii?Q?8zknj76rvIj/vwh06GOup7Cbb60svJcqJ4Od9WjO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c707734-1aa0-4b1a-f3ef-08dad6946f53
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 07:43:43.8716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Tc0c83/K7ebycMAoo5bg3npROUxwHD/cvPN90okAox5ckP2uFJ1HHcleAjfgdeu56jYnZmRDUsQRbHEr1Wldw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5607
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MDB group key (i.e., {source, destination, protocol, VID}) is
currently determined under the multicast lock from the netlink
attributes. Instead, use the group key from the MDB configuration
structure that was prepared before acquiring the lock.

No functional changes intended.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 2f9b192500a3..cb4fd27f118f 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -855,20 +855,19 @@ __br_mdb_choose_context(struct net_bridge *br,
 
 static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 			    struct br_mdb_entry *entry,
-			    struct nlattr **mdb_attrs,
+			    struct br_mdb_config *cfg,
 			    struct netlink_ext_ack *extack)
 {
 	struct net_bridge_mdb_entry *mp, *star_mp;
 	struct net_bridge_port_group __rcu **pp;
 	struct net_bridge_port_group *p;
 	struct net_bridge_mcast *brmctx;
-	struct br_ip group, star_group;
+	struct br_ip group = cfg->group;
 	unsigned long now = jiffies;
 	unsigned char flags = 0;
+	struct br_ip star_group;
 	u8 filter_mode;
 
-	__mdb_entry_to_br_ip(entry, &group, mdb_attrs);
-
 	brmctx = __br_mdb_choose_context(br, entry, extack);
 	if (!brmctx)
 		return -EINVAL;
@@ -966,7 +965,7 @@ static int __br_mdb_add(struct br_mdb_config *cfg,
 	int ret;
 
 	spin_lock_bh(&cfg->br->multicast_lock);
-	ret = br_mdb_add_group(cfg->br, cfg->p, cfg->entry, mdb_attrs, extack);
+	ret = br_mdb_add_group(cfg->br, cfg->p, cfg->entry, cfg, extack);
 	spin_unlock_bh(&cfg->br->multicast_lock);
 
 	return ret;
@@ -1118,6 +1117,7 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
 			cfg.entry->vid = v->vid;
+			cfg.group.vid = v->vid;
 			err = __br_mdb_add(&cfg, mdb_attrs, extack);
 			if (err)
 				break;
@@ -1137,11 +1137,9 @@ static int __br_mdb_del(struct br_mdb_config *cfg,
 	struct net_bridge_mdb_entry *mp;
 	struct net_bridge_port_group *p;
 	struct net_bridge_port_group __rcu **pp;
-	struct br_ip ip;
+	struct br_ip ip = cfg->group;
 	int err = -EINVAL;
 
-	__mdb_entry_to_br_ip(entry, &ip, mdb_attrs);
-
 	spin_lock_bh(&br->multicast_lock);
 	mp = br_mdb_ip_get(br, &ip);
 	if (!mp)
@@ -1204,6 +1202,7 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
 			cfg.entry->vid = v->vid;
+			cfg.group.vid = v->vid;
 			err = __br_mdb_del(&cfg, mdb_attrs);
 		}
 	} else {
-- 
2.37.3

