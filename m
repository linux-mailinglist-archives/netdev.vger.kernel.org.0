Return-Path: <netdev+bounces-9902-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1966F72B178
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 12:51:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AD2128120B
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 10:51:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 870FF846A;
	Sun, 11 Jun 2023 10:51:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D6115BE
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 10:51:42 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89161713
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 03:51:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VxhGIZ9fGm3Bg4ml83w0LTB0scAU5XmWYZ4GurC8RzJ24izJeP8YhierGKPxXSl47MkA9L0aue8cSDYf5t9CdJRpWNFL7Www6D2+2guDr72SWWXfp5AUSYzt0PvJMqwzic/dk5sXVzhjHCPy1xtB1SsG0BQQKIH8y+Kf361e4zMDWcp/dNiWcv0Nyb+rlNrBLYIJJ1fJ5BG320P653XRTFTaOnSFRF3CH5FFFuGNjOPdV1yzUxzLkH2ZOlBqh7nH7Q9pqhV9hlX3atcfOM2wk51PaxwGL1KfGJGC8g+95kL4IbQyAsmItHlOu7x+IuQ98SE4XQFoGEuLbOjaxGB38w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HL0YcYdQ/l6q17s8CmAgXEjr0BqwsEAoOwVKeCcSAsU=;
 b=iWiCvHATgKh4z5d5E64lk+0LCQlWQK+SrERzDecLmXRDplZIQ4Cr9uHxHb710cLg5T7rZyb3rniNUf3tqmLwopzyRG2UnHTtr3d9NDlG7wfDh4tuaVvvdksp6/QYagRu4HXdXsUVssk/qfx0WcLYsDdeilIlNHJ7soX5lGmeZCzTkHfIyLB36YPOp6vzvMBAyqDfZOQJs2eNP/LIZM2WusCw59EkueiskNZ24yAnC6RmU5IHLbc9gwkm4R7uCCDiKaGJuCQsAukKo9i6rvCvCLLZd3bqwEwZ5YbwsbgCGH3YHMxUDdjqm6S75FKyi5V1aPRz2qliAk/er/llsMJZzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HL0YcYdQ/l6q17s8CmAgXEjr0BqwsEAoOwVKeCcSAsU=;
 b=eZdG3AIAfz27OL5q4L82G6j9shWnv4scSBN5Ne6tpY7YYhjYAHvb3yqE2D6CyGch8Jo1i4QRuwt+PTAPv4jpi0TAVFR3O+N1PJ1XzEfo7y28sxzvpm/BfHVu4d0lnjgfg2OCk54MfaHllIi6xH8xFoYdSG25V/J1o8J8vhoiuOkqzBps48nOefoTixX8sGJ+4xd23ywTytsCG8uaSJ9UY1+7KNoNhHgzdMgx5pCoqdKrX9YZrwFrwbGS3X0/5Xmh3zaIq47g/9nT/XwAqAXorVfLcqSV4dAxahnU3604Pzeqld4QUEF302gAeByR0F1EQdNr0Em0sQm4xw3zpoZVBg==
Received: from MW4PR04CA0186.namprd04.prod.outlook.com (2603:10b6:303:86::11)
 by DM4PR12MB5389.namprd12.prod.outlook.com (2603:10b6:5:39e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Sun, 11 Jun
 2023 10:51:36 +0000
Received: from CO1PEPF000044FD.namprd21.prod.outlook.com
 (2603:10b6:303:86:cafe::76) by MW4PR04CA0186.outlook.office365.com
 (2603:10b6:303:86::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.32 via Frontend
 Transport; Sun, 11 Jun 2023 10:51:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044FD.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6521.3 via Frontend Transport; Sun, 11 Jun 2023 10:51:36 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 11 Jun 2023
 03:51:25 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Sun, 11 Jun
 2023 03:51:24 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Sun, 11 Jun
 2023 03:51:21 -0700
From: Gal Pressman <gal@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
CC: David Ahern <dsahern@gmail.com>, Stephen Hemminger
	<stephen@networkplumber.org>, Michal Kubecek <mkubecek@suse.cz>,
	<netdev@vger.kernel.org>, Edwin Peer <edwin.peer@broadcom.com>, Edwin Peer
	<espeer@gmail.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net-next] rtnetlink: extend RTEXT_FILTER_SKIP_STATS to IFLA_VF_INFO
Date: Sun, 11 Jun 2023 13:51:08 +0300
Message-ID: <20230611105108.122586-1-gal@nvidia.com>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FD:EE_|DM4PR12MB5389:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c2b6942-58ce-4c7b-e49d-08db6a69d3f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Az22N3hOZBvmrTSBVBgVo5N89U79av1Hd4ufIIeh9S1x1KJy9SflWeZwM7qEewhfbvU4dAO6C67ipZUkorcTg66SFbpfLx7+5iE1kOg+Yzpa7Bg0llptGVSXkiqlVtFy7bYcOmxVBpD496UQ5BQnNJnJuUidQXtK1E/K42kPuPQj4UJeDiqey2aUs9S0IvwSdNqHEEqL00I7MUFOnkO/3mBelUb+0+gFBzZGgqPwLuzkgq2dBaC5SWsYQzuBVhIzeid4kh4WMgI7BJQPmSP6X9VDqs1qFjY+csEJ8KeQ3zsvAlj3Rcp9KE3/oOuJw3mrVzzUbZNCWNM4Q6XNyBhfUW3lILqmcvAxekUR/Sq/H12Fl4fj2+82VPVUvntFv3WX+NrtYLC4V7vhO6SZd8JnNr+sKamC7wEwBknuQI0OoicejG9HNiN6sjVBX+EvRaj0yH85uBzRZ/uZYX3AqNlCk7NhcRBQ3d8YU+y6G0Qb6zfYrYCnAsRnlYklgFs7Hf8H6kIGT+h03Dt2rPUp4By1tD+9hylo00EHlhb6oz6JwoNa/BbcrdN6UrQLVDoxDTejuuNGxzWN2mnsv2/u+E0Ih57HKs418do8MGh6iC02m56pSjEsQVoGSxF6cMTebF+q13gcgNA51JHXkr2emw8ejmqtnFea/KqSDM2sWprudP3PUQjsJIcjRQlaQqGNyXUc2m0HUMJfv31N4t1NFY+K8HodP3E64KUqnkL/uMhg2TqYpDTTGbAD4FOx/CcAayTo0x7T7s2+Q3d7RKoTlnT1ve2JBJKfdH3NNAOzm3ea45Q=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(376002)(39860400002)(451199021)(40470700004)(36840700001)(46966006)(5660300002)(8936002)(8676002)(2906002)(70206006)(70586007)(4326008)(54906003)(110136005)(6666004)(7696005)(966005)(107886003)(1076003)(26005)(41300700001)(316002)(186003)(36860700001)(356005)(7636003)(82740400003)(336012)(426003)(47076005)(83380400001)(2616005)(40460700003)(478600001)(40480700001)(36756003)(86362001)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2023 10:51:36.2130
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c2b6942-58ce-4c7b-e49d-08db6a69d3f9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5389
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Edwin Peer <edwin.peer@broadcom.com>

This filter already exists for excluding IPv6 SNMP stats. Extend its
definition to also exclude IFLA_VF_INFO stats in RTM_GETLINK.

This patch constitutes a partial fix for a netlink attribute nesting
overflow bug in IFLA_VFINFO_LIST. By excluding the stats when the
requester doesn't need them, the truncation of the VF list is avoided.

While it was technically only the stats added in commit c5a9f6f0ab40
("net/core: Add drop counters to VF statistics") breaking the camel's
back, the appreciable size of the stats data should never have been
included without due consideration for the maximum number of VFs
supported by PCI.

Fixes: 3b766cd83232 ("net/core: Add reading VF statistics through the PF netdevice")
Fixes: c5a9f6f0ab40 ("net/core: Add drop counters to VF statistics")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Cc: Edwin Peer <espeer@gmail.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
Following our discussion in:
https://lore.kernel.org/netdev/20230607093324.2b7712d9@kernel.org/

I've rebased and testesd this single patch by Edwin.
It is only a partial "fix", but increases the number of VFs presented
before the truncation occurs.
---
 net/core/rtnetlink.c | 96 +++++++++++++++++++++++---------------------
 1 file changed, 51 insertions(+), 45 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 41de3a2f29e1..d1815122298d 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -961,24 +961,27 @@ static inline int rtnl_vfinfo_size(const struct net_device *dev,
 			 nla_total_size(sizeof(struct ifla_vf_rate)) +
 			 nla_total_size(sizeof(struct ifla_vf_link_state)) +
 			 nla_total_size(sizeof(struct ifla_vf_rss_query_en)) +
-			 nla_total_size(0) + /* nest IFLA_VF_STATS */
-			 /* IFLA_VF_STATS_RX_PACKETS */
-			 nla_total_size_64bit(sizeof(__u64)) +
-			 /* IFLA_VF_STATS_TX_PACKETS */
-			 nla_total_size_64bit(sizeof(__u64)) +
-			 /* IFLA_VF_STATS_RX_BYTES */
-			 nla_total_size_64bit(sizeof(__u64)) +
-			 /* IFLA_VF_STATS_TX_BYTES */
-			 nla_total_size_64bit(sizeof(__u64)) +
-			 /* IFLA_VF_STATS_BROADCAST */
-			 nla_total_size_64bit(sizeof(__u64)) +
-			 /* IFLA_VF_STATS_MULTICAST */
-			 nla_total_size_64bit(sizeof(__u64)) +
-			 /* IFLA_VF_STATS_RX_DROPPED */
-			 nla_total_size_64bit(sizeof(__u64)) +
-			 /* IFLA_VF_STATS_TX_DROPPED */
-			 nla_total_size_64bit(sizeof(__u64)) +
 			 nla_total_size(sizeof(struct ifla_vf_trust)));
+		if (~ext_filter_mask & RTEXT_FILTER_SKIP_STATS) {
+			size += num_vfs *
+				(nla_total_size(0) + /* nest IFLA_VF_STATS */
+				 /* IFLA_VF_STATS_RX_PACKETS */
+				 nla_total_size_64bit(sizeof(__u64)) +
+				 /* IFLA_VF_STATS_TX_PACKETS */
+				 nla_total_size_64bit(sizeof(__u64)) +
+				 /* IFLA_VF_STATS_RX_BYTES */
+				 nla_total_size_64bit(sizeof(__u64)) +
+				 /* IFLA_VF_STATS_TX_BYTES */
+				 nla_total_size_64bit(sizeof(__u64)) +
+				 /* IFLA_VF_STATS_BROADCAST */
+				 nla_total_size_64bit(sizeof(__u64)) +
+				 /* IFLA_VF_STATS_MULTICAST */
+				 nla_total_size_64bit(sizeof(__u64)) +
+				 /* IFLA_VF_STATS_RX_DROPPED */
+				 nla_total_size_64bit(sizeof(__u64)) +
+				 /* IFLA_VF_STATS_TX_DROPPED */
+				 nla_total_size_64bit(sizeof(__u64)));
+		}
 		return size;
 	} else
 		return 0;
@@ -1270,7 +1273,8 @@ static noinline_for_stack int rtnl_fill_stats(struct sk_buff *skb,
 static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 					       struct net_device *dev,
 					       int vfs_num,
-					       struct nlattr *vfinfo)
+					       struct nlattr *vfinfo,
+					       u32 ext_filter_mask)
 {
 	struct ifla_vf_rss_query_en vf_rss_query_en;
 	struct nlattr *vf, *vfstats, *vfvlanlist;
@@ -1376,33 +1380,35 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 		goto nla_put_vf_failure;
 	}
 	nla_nest_end(skb, vfvlanlist);
-	memset(&vf_stats, 0, sizeof(vf_stats));
-	if (dev->netdev_ops->ndo_get_vf_stats)
-		dev->netdev_ops->ndo_get_vf_stats(dev, vfs_num,
-						&vf_stats);
-	vfstats = nla_nest_start_noflag(skb, IFLA_VF_STATS);
-	if (!vfstats)
-		goto nla_put_vf_failure;
-	if (nla_put_u64_64bit(skb, IFLA_VF_STATS_RX_PACKETS,
-			      vf_stats.rx_packets, IFLA_VF_STATS_PAD) ||
-	    nla_put_u64_64bit(skb, IFLA_VF_STATS_TX_PACKETS,
-			      vf_stats.tx_packets, IFLA_VF_STATS_PAD) ||
-	    nla_put_u64_64bit(skb, IFLA_VF_STATS_RX_BYTES,
-			      vf_stats.rx_bytes, IFLA_VF_STATS_PAD) ||
-	    nla_put_u64_64bit(skb, IFLA_VF_STATS_TX_BYTES,
-			      vf_stats.tx_bytes, IFLA_VF_STATS_PAD) ||
-	    nla_put_u64_64bit(skb, IFLA_VF_STATS_BROADCAST,
-			      vf_stats.broadcast, IFLA_VF_STATS_PAD) ||
-	    nla_put_u64_64bit(skb, IFLA_VF_STATS_MULTICAST,
-			      vf_stats.multicast, IFLA_VF_STATS_PAD) ||
-	    nla_put_u64_64bit(skb, IFLA_VF_STATS_RX_DROPPED,
-			      vf_stats.rx_dropped, IFLA_VF_STATS_PAD) ||
-	    nla_put_u64_64bit(skb, IFLA_VF_STATS_TX_DROPPED,
-			      vf_stats.tx_dropped, IFLA_VF_STATS_PAD)) {
-		nla_nest_cancel(skb, vfstats);
-		goto nla_put_vf_failure;
+	if (~ext_filter_mask & RTEXT_FILTER_SKIP_STATS) {
+		memset(&vf_stats, 0, sizeof(vf_stats));
+		if (dev->netdev_ops->ndo_get_vf_stats)
+			dev->netdev_ops->ndo_get_vf_stats(dev, vfs_num,
+							  &vf_stats);
+		vfstats = nla_nest_start_noflag(skb, IFLA_VF_STATS);
+		if (!vfstats)
+			goto nla_put_vf_failure;
+		if (nla_put_u64_64bit(skb, IFLA_VF_STATS_RX_PACKETS,
+				      vf_stats.rx_packets, IFLA_VF_STATS_PAD) ||
+		    nla_put_u64_64bit(skb, IFLA_VF_STATS_TX_PACKETS,
+				      vf_stats.tx_packets, IFLA_VF_STATS_PAD) ||
+		    nla_put_u64_64bit(skb, IFLA_VF_STATS_RX_BYTES,
+				      vf_stats.rx_bytes, IFLA_VF_STATS_PAD) ||
+		    nla_put_u64_64bit(skb, IFLA_VF_STATS_TX_BYTES,
+				      vf_stats.tx_bytes, IFLA_VF_STATS_PAD) ||
+		    nla_put_u64_64bit(skb, IFLA_VF_STATS_BROADCAST,
+				      vf_stats.broadcast, IFLA_VF_STATS_PAD) ||
+		    nla_put_u64_64bit(skb, IFLA_VF_STATS_MULTICAST,
+				      vf_stats.multicast, IFLA_VF_STATS_PAD) ||
+		    nla_put_u64_64bit(skb, IFLA_VF_STATS_RX_DROPPED,
+				      vf_stats.rx_dropped, IFLA_VF_STATS_PAD) ||
+		    nla_put_u64_64bit(skb, IFLA_VF_STATS_TX_DROPPED,
+				      vf_stats.tx_dropped, IFLA_VF_STATS_PAD)) {
+			nla_nest_cancel(skb, vfstats);
+			goto nla_put_vf_failure;
+		}
+		nla_nest_end(skb, vfstats);
 	}
-	nla_nest_end(skb, vfstats);
 	nla_nest_end(skb, vf);
 	return 0;
 
@@ -1435,7 +1441,7 @@ static noinline_for_stack int rtnl_fill_vf(struct sk_buff *skb,
 		return -EMSGSIZE;
 
 	for (i = 0; i < num_vfs; i++) {
-		if (rtnl_fill_vfinfo(skb, dev, i, vfinfo))
+		if (rtnl_fill_vfinfo(skb, dev, i, vfinfo, ext_filter_mask))
 			return -EMSGSIZE;
 	}
 
-- 
2.39.1


