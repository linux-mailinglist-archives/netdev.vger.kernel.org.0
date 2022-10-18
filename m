Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490BF602B38
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiJRMHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbiJRMGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:06:47 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B587A537
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:06:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LbgerNDFw9I0p0qIot/cDfOjjjDCH/LAMsveut1rE1mtJErVjcWcpk3ocDlVTgEgOoFM3QgwxmEdBgnP6wx3K4y/fAdB+U2ZMdngq7QRCAC6R2+5YprcHPA6R1AiKuNJutdlmeSWinziMuSx6ywXl2b15aByexs4JRUMkRXqVORJApB/TQeAe9P2hQ0mjXmX71w1NpJjkhyg/vD036tHNu5MtxQ662t5snKr8f9kor+kOjNLgkXRppx00Dr4sOcXK+XZnoE69oXC6mBNR1yBNZn0II/fF8+xVOUE8vFvaWM3IiAFy9g2b3RTZRHORva8tPkIbY3V2TyKi5R7OxVaPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=osLKPcm17h6ifVTy4t+AKITNCG0OSYf4BrOSyz36crE=;
 b=Ke72zf8eKkI2iI3U27/qwlSiRxwUgPsCszkcP3Yz62Xxm2bR3Rqk2rqn5s6p2QFOP/Q3/WXFf+oIM+u7IW/C6TsIC7q5U2UXDpbkl/YUKp4WX9BA3KlgrsR8MWMi4jkgoiz0sBgVeCtArvOVClmpEDX9WJWGHFs2Fv6ZRiPTGCxpNaO/haDj+WiBH+hZksmOVO0ZJi9WuCvaMnLyckr5TjtfsxZe6+cL8pxHiJzYtup2PmtmL93I3/7QuV1+MLnJpJAe1EjaqYyVDQozpTyJ3bHfB/4jRkXMeX2CCXFjxfQ9lnRaBOq4uhLnYdshOGUTkrWDdvETQOXVUzx6OCm2HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=osLKPcm17h6ifVTy4t+AKITNCG0OSYf4BrOSyz36crE=;
 b=WJAECdYMVgFbJvqmwZNNNJnvMSFqgEaGIHtKLkbm81kKkwx3eWamyH31KVSyixe5gk4PxvBLYmIsVpZUF8uw1sttxxkVq8ZU4RAXcFSWzhgMA2bd4gTLq0MjvnZg3/eqlnA8SnKstQoHkXR8L6czOQEECHu+LukP1bsNPUYbBJXibnBwTSLH490FcFpcB8cQqIu7kxw66DVbluuuIjA0Wrt/5jAH/8AP+eVuWRzwdEHikMYiY1iFOVv+oyYh3vytQoT5pC+jA9+Pfw9Q7mZftgJ48QM55nQkU7T/kWQAvEwBRfoTJo95bFxi3lqRAm1cw/gN6SozKjiRnZaKnQxTkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY5PR12MB6406.namprd12.prod.outlook.com (2603:10b6:930:3d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Tue, 18 Oct
 2022 12:05:40 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 12:05:40 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 05/19] bridge: mcast: Use MDB group key from configuration structure
Date:   Tue, 18 Oct 2022 15:04:06 +0300
Message-Id: <20221018120420.561846-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018120420.561846-1-idosch@nvidia.com>
References: <20221018120420.561846-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0104.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::45) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CY5PR12MB6406:EE_
X-MS-Office365-Filtering-Correlation-Id: dbb67d66-cfa6-4c21-80bd-08dab101130c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PidhJ1YYxCUuT3DJGO3HgSs9PQ3lvf/DkoLDXOPTq9BXF3Ijc0u9axCvBpcWFkwprUVj8AICH0AJj55jFw1U3U2gBHeOxNL8B8uaevPigThK4H7Pd8S+ALKFRiq79xpStMSIQ2iGxxRIDrP4IurNmGAD3eDq8D/vKKE5w9zjM4y+AtK1SYPECXXPNlIW9UeUDZ8MFBqJDa3D0XXhjLtGAtHB53+3ubifff2SGFYc6jzJdI48Lh7UoTFZ8WI8PPTNTvUHwz3eHxTs5NOxz8B/9lXWyvlY+2AiGV2TUE9qzS2/AkTuttwLGOuoqHv1ZHxsSK9s6v9/c1qsDQg7moZnGEXlost/ybbVH/AsJEApvPHcNC80iO5+rMY6o9Jtk2kmiU9f8YPbMpLQqOODO9W0F5gcIMrUNKGFUrH95CK0KWy/gjjHIpuNowmgOnZsrogCvP1pRe9G150qKQiwHBqCgYDgmJDqwVMfj2Ko1wLndn61d3h9vRYCSipUZv5p6vEFfMJx4RghlXyJR83BboHHBu1qvOV81Dh2d/yOhvNxqHK0K3V1Q1m4nm17OQtYg4ckNCWm0+R3jxV3omNa25FmTuP7qy8dy59BhOSWUZhwe5kzfV1pq9FZVzam2YCaPp5DmFagxCDfoU4LRjqoHIIGhTebdAC+R3IJNC6lCMHGf8oTxQJ5fvfknwjJXo5ew9MeDDiy/kNGwoOHP7Aq99iayg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199015)(36756003)(86362001)(38100700002)(1076003)(186003)(5660300002)(107886003)(2616005)(6506007)(6666004)(26005)(6512007)(478600001)(83380400001)(2906002)(6486002)(316002)(66946007)(66556008)(8676002)(66476007)(41300700001)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ts2ebdKs8SGNC/DszKabpC+oJxM9Kz9T1BFkxHNmhdR4xyuBhWFAkt3T9nA5?=
 =?us-ascii?Q?kFPwfvKysWalQ+qR6ylhJcXm+BDZgKuvnp0sgsKoIDAjS1bZPnoOgOQTvqZK?=
 =?us-ascii?Q?Q2vof1m1jL+QxSVfHqu80z9RO/qZK9A2179YJZwNyH11Nk0+w3mkjhW8sLxe?=
 =?us-ascii?Q?ZJvJ2umbnPug6uzlGvikcdLIP+izZEqiDMcC53WSKwXSvjAOvc27x0paD3Ek?=
 =?us-ascii?Q?6oMRBxCn+SKL9pJOCxqNe3yTuTpWgZRxcUTp6Z3cJTQQvQ/RBzI++dmT8gKT?=
 =?us-ascii?Q?X5A3g7wl/YekM5RLOGhgOtrZnoMbURBTkgmdII7Vf2kp6hXuCO2zqr+KGIK6?=
 =?us-ascii?Q?GOCEEqG99A0RIWckE8ZNEp36UKVHX/V1pyUJSSKjXBhjbFk3dGANvCHXJwMk?=
 =?us-ascii?Q?acyHoNWLD07ryRdyhVy23xT0H+8EpEU6r4+AbFIh7fGW1GCGD32QaXhPan3M?=
 =?us-ascii?Q?mvUf0v2HonwzZJnJgpqmhrh3f/rW+pekO9H3PSlvW1xgcTMbEcEbtjMmi45y?=
 =?us-ascii?Q?ibqNbn+ZdO8qecOZd+4bxByVAjU9bzr028nXvl/Hqty04zr4P+6DYur1z9KT?=
 =?us-ascii?Q?tsVSBJ8PoGy6fK2TM92U0pzTfqd8nJTskJ4hlgHcxsgUIkv6ffBFKgDEI7XD?=
 =?us-ascii?Q?1imTd4QuL7qJHpbJXXeGnKLscMdbVIeWVf7Kc8uBpqCS3vqQll1JdItPVUZh?=
 =?us-ascii?Q?tXdr2LttHmavrwav1bafcSwXHZRywBd8PvXVs8s57ABam3nWDZ9iqY5Yzf9Z?=
 =?us-ascii?Q?n3GwB7BbPxxYzXc9tm6XmRiSEGGoKZQO8rFZRWOzC0AZEZugMlbwN8B+Ye5Q?=
 =?us-ascii?Q?xbqYxZL24plsOpLtkb1dE561qoUVoL658zGljzNG9oxkakrviy1yoqhA8ziY?=
 =?us-ascii?Q?K4KgYAK3dpuVm2GSO0YN4kIe/V38pvlxDNrrKh4DXznnS/kupmV0uG6sKZ0y?=
 =?us-ascii?Q?mYoE5prdhjCLyuzX4tApDFbgUYjGWp/GgX5/xuxVVVbEtlSBWouig3WYa8Dj?=
 =?us-ascii?Q?HD7zFbZXBLf0ifRUtaMY51IHdAxAv6R43V+geZuWfjgb34gnOHMv5hf5Eulr?=
 =?us-ascii?Q?TJjfqBvIHc5xF4tUdI8XeV5xA4jpcZhHL7caXN9qt3/HL2gIi4jrnj9f8kF+?=
 =?us-ascii?Q?HF2nPv6kPwsFoZZCechyvrkHAmu9JSSkzThgSAfTMxFce9fG7B5RMXq5Ul0q?=
 =?us-ascii?Q?KQFcWn8LvFZliI80VUXA5ec416CaGcENNcEyRojXeZSNrRyMtmXPnGi2dTXv?=
 =?us-ascii?Q?TByRadG6EC614QDcD1WtOEnNZFem/ku1xLL9kZxLOAvPqHFyKcNdhTO5/ryp?=
 =?us-ascii?Q?ZX4PTVNzy3vrUn1IMOVr5zGN37ANFNWXCRAjIrBGx1YlwySGLbLRQ5rBhhuX?=
 =?us-ascii?Q?nMuVOG4ZaIxyvlRU7UZkzI4X9RMPcK/7zpF6tDSNA41CZa9TmMnQYPFiVJrO?=
 =?us-ascii?Q?h3aAfRqqG1AubBdcW2AerduXJFneOjug+DBoDXB6X+BX/ocLzANDBcX7hYJt?=
 =?us-ascii?Q?Lxoy1A+PBix6r1Wzc39ij+vQP7UW6KFJhTEAjPFBRgaY7mNHRsE/fmtKLq26?=
 =?us-ascii?Q?rKvEWT5d3EZyJdRTeBIBUjt7FkYDXDx97HIZhR4P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbb67d66-cfa6-4c21-80bd-08dab101130c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 12:05:40.1359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D6TYqo+9ZKS3ckWMWs2zNHnAZfRjClvkLFFRgwOhGEJ4btQosmTagzXe6gaWzzG0EoCiHU2gG1pNVKTTMfDgRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6406
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

