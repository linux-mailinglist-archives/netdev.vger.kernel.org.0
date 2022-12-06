Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E736441B8
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbiLFLAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234567AbiLFK73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:59:29 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B4423BD6
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:59:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hNwgZICqwPM3Us+g0CMvD4Wiu/Zd1QVi/fqiBH0d3eeZ4YVG0cBnPfWXAk51GaLBw4CENb9gjamZMWsfcSSY51kmSoDm0zaWzOuVms2H4vROWLwr3vgewdZRFe1oeldpPnJkSo36iLrvbhiqXAJSelaDTmYZNd253iLr51L42C5lMuuGdg3uaezgPaq2xE5ilS8CkL0Um0iDFSl42lG2WlpShT1uQhFn84Vle87oOJIONZN3P93LwR9L0RX/XEDgjyzaSJIeLRG1GtaL+6gwnDxiE/XN83y2YFqk0VNFJLpWfJU0hadBXPzM5SSaeA++eGnzgj9CwktSzkdT2YborA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m2UuOzLm+cUz3HNhxRPB+Jh5RI2DyHSGrhLikshtd8c=;
 b=Dzs2Pvv41kesIzRxWOKl3RLv12l61DW9u96MuYfJn3s4/Ypmx4+zos4nbwo1L4k5ZDb/CiPwIeAsYY1cmqi8RZQBaRw/OClvDNU4cB4Z1adHn32tzHAdLZwYxrRCon+2ZWqhRn7MA6mmiODaqKaEgTmjGLZeSolJwaLYIgM/DNrNE0cpueQw4vlKA9mxhMKMGhDeAapHbtO1fScYEU5jHZPYJA/SOI9cUyyzaZB9uytZeyYnZ6Pl/E0ahspur5WTFaZwidBLdNSeFZZHB6ZMb4qaGKflZNWnh/KspBMkr/9f37mtPKWjA4LlL2VcUVdIcZsIP2oAFAQ6ak6NlmZ9Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m2UuOzLm+cUz3HNhxRPB+Jh5RI2DyHSGrhLikshtd8c=;
 b=tQ+f56NUmYJZ0viQdjupaatD1/nZswbEaRhH/swvOXfNj3VeAZlW3KHTOwaxZlGFtVficdlznWuMZT98iZ9QEAwurDrQGpf6Px6G4GDVxDWk2fR+JybMJxz3/g9lLZ8ge6vItxROAFrePb7krHvGh4seJi+1j7VoxsShMW8/M1yUHawyKX+7TAAJYKzk3l8oWn5S0PcN+dX5IXYvo+c9Nepf8yZv4R6V6XC2sBX266H2CwsRJdqcWe6T7UbmMwYExkcDNbyuZGQi8zDx1YQz/Vu5N/M4SBhB073c3VITmJm9Qd1bA4ZMZa2uVcs7O+UD7lErsIlVb6X2YBLL7BUhTw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN9PR12MB5131.namprd12.prod.outlook.com (2603:10b6:408:118::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 10:59:10 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 10:59:10 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 5/9] bridge: mcast: Use MDB group key from configuration structure
Date:   Tue,  6 Dec 2022 12:58:05 +0200
Message-Id: <20221206105809.363767-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221206105809.363767-1-idosch@nvidia.com>
References: <20221206105809.363767-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0072.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::25) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BN9PR12MB5131:EE_
X-MS-Office365-Filtering-Correlation-Id: 5da5200e-42ed-4625-b816-08dad778e738
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Pp3jHRi8qiJATssVkgaFvUVKVfel8UoEIt0k+ZuzMitvYZCrfMTrZlfmVeSgYNgb33WM/2aT7Il+cvI8QhmBn9IvnQP1JkgFR6CgYk9to0DWuOHXqoIOJt+fSFVUZU1ObR6PFx7TUGrXC2D+nySUWFk2g7k8/RLGKgoVxOAGoG/zQNYLNMaPNNqTP+v5a7K65mDV2Tly2tWsOEfok6EJLb5aDdlmePOwmy/bDYdPFRXHNAIQ/8tyHp2bmIjkwJhIRd/5P5EM75gvEBdBquD5+ZyozviCZh/s+coNsUbKCmzSPOpcOHv4nqT47FCvCeKF5frEW/loyHOZolFRCBDos1iII9VTs9zADF7CbnJVfLXUxlXBzj+egWE/tcXeoG5lxtpjym2KacaI/7dogcCBGTg/NXozEvwGsbp2eH1TgG8fk3P0iz3gNQFHxuACsKpNhxxxqYt7iww6H8WRLj/8xTRBfYZwGZMMWVn+BO9HpklsZBY4CtV16rjmLOTXQC3iwMlnhbA/AGP5H9L+csoLclkcjifr3GV3qQqsc+5yUwXqSj1RmDX3xHSKfVixAQqgLY0onDoNcY0+N8t90Ip54qT2lXag4n4/SiQiN9ndZrWUe7hZ40sttO5GGgXpc1Xaw7kfa7k8GoamUTLH0+BDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199015)(36756003)(86362001)(38100700002)(6486002)(478600001)(6506007)(6512007)(26005)(186003)(107886003)(8676002)(6666004)(5660300002)(4326008)(2906002)(316002)(66556008)(41300700001)(8936002)(66476007)(66946007)(1076003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1EPWoz0pl8gVfSl5nZ4qkv1W+XNntOfl5CNk3jhZNb1iDd9Bwr1Yc43avLzL?=
 =?us-ascii?Q?d9rRnk67z7lPsxdlGuKpPnOMojmu3Jzx3pSAoU3KHqjQ+bovnCNa0s/YYfJS?=
 =?us-ascii?Q?6ehDkYN3B1ame5XgRXmYtfsb2tEzAr9eKxoeHkDwB/1s2f/H9E8LCeNuizdh?=
 =?us-ascii?Q?G1yLn7+DoqYVuLAzQof7jZmAikX0WzF6ulkXeBHLo1jHHkcGmzwZmT8RxoBW?=
 =?us-ascii?Q?+NyDtIgFiMUAf3KLmV9T0f44HfKRJGAoBhTLnukIaMnIURzayIDMLen4xrhl?=
 =?us-ascii?Q?tCYSPgyZ9WbRMk9OPlwS9P8ZPaYw1P+3NyxIEu6DuYCuUCEhZ7WCgfS8w53y?=
 =?us-ascii?Q?ovtdITsAjM1yYYMeaUHmActK13bfPQ953SXTtxsPXDDpP32xcn2usdtV8Iry?=
 =?us-ascii?Q?u71x5igetFhfTirjIQzX61wlZz/XY7YrENTcy38joSF32trUVDtB3kXddMdp?=
 =?us-ascii?Q?v4Wu2pg9CbaiYF6fv9YkCIzEVhtdqR5rPZ+mFHxaG9W47hdPNRk3hGoMutqT?=
 =?us-ascii?Q?+U3VvRNgC8uXWCoICUotJxL+7qb1WCBHmdtpOQ7AW4+J1q4+UQjOHvMVjSMa?=
 =?us-ascii?Q?Zu9mWDyiU2YWJebsVZk0UOp/rEvTw1/vdUB6uVLCnxaALX3DBRqQX+NvXMVy?=
 =?us-ascii?Q?VUStXiI0rCoA7CuC9EoeBD3Ke5Q8EyfjuA+IOxVfZB95XE5b/vDo1RvUySwB?=
 =?us-ascii?Q?mPvnkQMrLC6Wnz1tQRL0gLNMoPTvAEYEB86qO8Jd6aaG/RSOcoJyQzSaqzmd?=
 =?us-ascii?Q?xI4qBOscree8s4O7lGRxMkeFZf8xeRrG5Dq/WZqeGyvLd75zv5lTpDnVrTel?=
 =?us-ascii?Q?B3qLtiO8ux75un5d14Q3IJor23zsLkDqh5j1aoEjDP+THvJOsOxeyphho/Cm?=
 =?us-ascii?Q?HlG/ubmx1ozZKfMtP/t/hiHCEq9vg3YRv6/hWvHHp8RJjZvCew5OC47XPBTy?=
 =?us-ascii?Q?xa1xtBx2aMKPEhAw9tEiPJdT4Fak1v0nZzsTroDp8rrR8toeTY+CWvX850NR?=
 =?us-ascii?Q?pwPK1vLlgpNckOTGk1HY3CWUtH+aTl/sOUe1GWjCnCcVCUKJyVEHAI6DRkFa?=
 =?us-ascii?Q?VDlyuTZ5WGLaSEm+MNQ/nKwRg6zHu5Pmm8yPPmizuP5bW/LlBedGn/wDRyxu?=
 =?us-ascii?Q?ecrmImgqWchYZzOLOdo2IRuD9VNDB2F9dAoRXmiuXPycOAMZCczH73AfZXiX?=
 =?us-ascii?Q?lx5CYLdix8MoKABeR1f/K68d19lC0FZLTNY5VBiqTii2NGVjQqJXEekPF9F9?=
 =?us-ascii?Q?c2PQcs4WXVVneuT6Nj0Ph2r2Lxzmk2il8MDm4bRnGpfJSF7e5D9FdhVZRuHM?=
 =?us-ascii?Q?+AOSXvuz4wZUvb2aE2UQ1njgznlTJyCifwYj6PAO/0wMrrqYbfjCrEgRbe8h?=
 =?us-ascii?Q?q1qChJy3PNaMhaYTMd+ePuACI3ZPCilH4fK0c4fEQCcm2YVLjz28I43NGOBR?=
 =?us-ascii?Q?ZbhEFEMZlAOa3Ygrke7X046Jm6afzRuXEDK+6Zli6qdI89La5k1OowWtxdqL?=
 =?us-ascii?Q?mp0ErqQiaMRTl9uNQHANk823fPSVu6ue3xbaJV+7JIj9FCfGLvTBnpJ2e0Yj?=
 =?us-ascii?Q?QnW6gkzRcpcuAiGffx81P4VzDuy6Efdop2Bd6zVv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5da5200e-42ed-4625-b816-08dad778e738
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 10:59:10.2585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gT8gFYxegB0O1rMfq+UIQZlnYlZURqW2+1x/DvBi9Cu2AFuWEizk+ebPNbLwprE+tfr5Tsj+VAJd9G+cC8niyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5131
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---

Notes:
    v2:
    * Pass 'cfg' as 'const'.

 net/bridge/br_mdb.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 6017bff8316a..b459886af675 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -855,20 +855,19 @@ __br_mdb_choose_context(struct net_bridge *br,
 
 static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 			    struct br_mdb_entry *entry,
-			    struct nlattr **mdb_attrs,
+			    const struct br_mdb_config *cfg,
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
@@ -966,7 +965,7 @@ static int __br_mdb_add(const struct br_mdb_config *cfg,
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
@@ -1137,11 +1137,9 @@ static int __br_mdb_del(const struct br_mdb_config *cfg,
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

