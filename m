Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C2E4BEFB8
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239435AbiBVCxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:53:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239399AbiBVCxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:53:25 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6244225C77
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 18:53:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlwHM5XpzfrnfhlnyGqjBaE8ubGx3OE01Pb9alyA5Zm9gI22i/E+LYl/5/Nqap9O5oqOFgsZethn32sO4SuCbkanvHFLyfhqbrZZcXLTuiKBS9Ixu2gnAV9ToIdPfe+QoYgfjxoeuA5iowHzqQlGmh6CAC9N3jiwPEMPohO9ejGHnvQaT0KV703NuM+GJSXribYxzdAOE9EV6uZaCV2IlmAy4yhyQqD9Wy0o+pUae3Yf/A8F0kjqwR/Tofwvea3yvmpsh6FkkzW2H9TTjPLPjv2IHBfdBDg6Shrstw2uwe6JOCcmDgp1mq6052uwBbgryD3hvgAJYvrneQcpCC6O9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PikUqXLmbvWU1t7Gnu6Wbd5UJ+x6rlKnStRBV34txoQ=;
 b=oH7ybykRlleLCDiCG5S/50Y0/tZ60XUEMGW8t6FOUB3AIJwvL1v51atIjg+ZmsOJ6lRiFCW1s8STpEV7RTYNlAQoMCHyPos840D3oXefQV6ICOZA+MoKVrkyHnDtJXIvFKLhfyCHyhKI89TNvwedKtUDQoN2nctu0l8Acs8jvWu9wR2pWoBAiwKTqI9WZstgCX+OuR43oTRv6eHWHjWdjuqdy4jRorBVJGHe8XM5UFD7urb4g+ssQ4OvuXnel3H5wcfqXK9BLnWhLWJkyIKY/PfKEyM2VxAdLFHDXZG4Mvdc8etiG60povqnsSJ0Ae9F9eJWMuyncwPSIzZhvpd00A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PikUqXLmbvWU1t7Gnu6Wbd5UJ+x6rlKnStRBV34txoQ=;
 b=LU1eM++JH5oPNW6VAeq83a2hmzaPl/CdWQRnj+6ta3xNfDmDYn84ColhUS++TU7j3A29kekfDj8owsAwpuOctDrmPrF/MfMFjE5z9lljlwYLpCHnbtRD8XiFrPd3VF+C6sAv9jc6G4zPieRG3QQQBYopd+NXoajaeGcnWCtXWWW+shHP5yr8Ducz48kp80SnMAHNY6Ohm6kN8L+E5G/O6ssc0GzI0rP5o4AcyaBdiVfuAmnm0TqY++ZHJhGGGXDfK4oS55DS5eFoNFKAzdSYFoHpRsrBqJ5qMs3uvc+oKD12l3eKJUGj8EpHk3zsZ8HoVyFKYJsAkEPeGuAeLDqRbQ==
Received: from DS7PR03CA0121.namprd03.prod.outlook.com (2603:10b6:5:3b4::6) by
 MN2PR12MB3423.namprd12.prod.outlook.com (2603:10b6:208:cb::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.16; Tue, 22 Feb 2022 02:52:59 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::9e) by DS7PR03CA0121.outlook.office365.com
 (2603:10b6:5:3b4::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.19 via Frontend
 Transport; Tue, 22 Feb 2022 02:52:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 02:52:58 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 02:52:57 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 21 Feb 2022
 18:52:57 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 21 Feb 2022 18:52:56 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v2 12/12] drivers: vxlan: vnifilter: add support for stats dumping
Date:   Tue, 22 Feb 2022 02:52:30 +0000
Message-ID: <20220222025230.2119189-13-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220222025230.2119189-1-roopa@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d78c213-afe9-41bd-c837-08d9f5ae6f1d
X-MS-TrafficTypeDiagnostic: MN2PR12MB3423:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3423D054E2F7A44B89531FDACB3B9@MN2PR12MB3423.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N1bNnrAK/F+tPFta6BaIRUxNK2uol6mEpEnEKp6d1elG8mqcr+aj96m4iBev1MiBKANQ8+R4BU1jq5xNsJ1zwG675OmCxptwjFDlGiAHneAzz8WFMdebt4egHD3x8wlR+IYhsyPVGkVkFbGYGNNqLVy/p+b1KPwlOqKaHZBFS7LDOX7vJ5JiwG4yNvjyv3HQ4DSvnqy8Ib7mh5nIhj080P0K64CxB1rTX41CCPc4FkPDy3TN9HCndHC9m8MNvaqVVm3je9LSM0xQXK+FtF/4I4runn/WDwxBuVl/jrHNbeGyPT/bFlcuz3KISDWMVDFrxenEMRTIrH+2Opna2ywnZTjErZJYmkd3OtgEDEjOg5QJRRUnyi09zv13p7l+Ag3O1qlFhOiYMv3LIvVzmRlIWcm1bVLrLdxQ9dXB1NXBWNtZfSDbJGA1UtYTUbph1qyyBipHrH5NFqDrgXVd5+DLGqmpGsAkfAGhYIxSAf19tRbGfKYqYPvpDs87esJ0IDz32epvK3fcmbxs0Zp5UmKDSAHeXZsCmm6y94x5z68yhpSMvMvKrZkCFfg/xp5Qezyg1m7VS9dKdvD7FsLaxqvBE2hib4FwiXauq1nrSVWxIuDvf9kboqVey/BybwPmxQjmV0PR71NWp4UVvdme83pRMwSbJPiPJFMeIF36nzwpBMGUw1iwRfyPZiPWP31+gW4pkn/adBDZnsAMkos5jh7ihA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36756003)(6666004)(2616005)(40460700003)(508600001)(107886003)(47076005)(2906002)(36860700001)(1076003)(5660300002)(110136005)(54906003)(26005)(8936002)(186003)(316002)(356005)(82310400004)(426003)(86362001)(81166007)(336012)(70586007)(70206006)(83380400001)(4326008)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 02:52:58.5879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d78c213-afe9-41bd-c837-08d9f5ae6f1d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3423
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support for VXLAN vni filter entries' stats dumping

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 drivers/net/vxlan/vxlan_vnifilter.c | 59 ++++++++++++++++++++++++++---
 include/uapi/linux/if_link.h        | 23 ++++++++++-
 2 files changed, 75 insertions(+), 7 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_vnifilter.c b/drivers/net/vxlan/vxlan_vnifilter.c
index 30534391948b..867b4e90f6b7 100644
--- a/drivers/net/vxlan/vxlan_vnifilter.c
+++ b/drivers/net/vxlan/vxlan_vnifilter.c
@@ -186,9 +186,48 @@ static size_t vxlan_vnifilter_entry_nlmsg_size(void)
 		+ nla_total_size(sizeof(struct in6_addr));/* VXLAN_VNIFILTER_ENTRY_GROUP{6} */
 }
 
+static int __vnifilter_entry_fill_stats(struct sk_buff *skb,
+					const struct vxlan_vni_node *vbegin)
+{
+	struct vxlan_vni_stats vstats;
+	struct nlattr *vstats_attr;
+
+	vstats_attr = nla_nest_start(skb, VXLAN_VNIFILTER_ENTRY_STATS);
+	if (!vstats_attr)
+		goto out_stats_err;
+
+	vxlan_vnifilter_stats_get(vbegin, &vstats);
+	if (nla_put_u64_64bit(skb, VNIFILTER_ENTRY_STATS_RX_BYTES,
+			      vstats.rx_bytes, VNIFILTER_ENTRY_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, VNIFILTER_ENTRY_STATS_RX_PKTS,
+			      vstats.rx_packets, VNIFILTER_ENTRY_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, VNIFILTER_ENTRY_STATS_RX_DROPS,
+			      vstats.rx_drops, VNIFILTER_ENTRY_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, VNIFILTER_ENTRY_STATS_RX_ERRORS,
+			      vstats.rx_errors, VNIFILTER_ENTRY_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, VNIFILTER_ENTRY_STATS_TX_BYTES,
+			      vstats.tx_bytes, VNIFILTER_ENTRY_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, VNIFILTER_ENTRY_STATS_TX_PKTS,
+			      vstats.tx_packets, VNIFILTER_ENTRY_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, VNIFILTER_ENTRY_STATS_TX_DROPS,
+			      vstats.tx_drops, VNIFILTER_ENTRY_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, VNIFILTER_ENTRY_STATS_TX_ERRORS,
+			      vstats.tx_errors, VNIFILTER_ENTRY_STATS_PAD))
+		goto out_stats_err;
+
+	nla_nest_end(skb, vstats_attr);
+
+	return 0;
+
+out_stats_err:
+	nla_nest_cancel(skb, vstats_attr);
+	return -EMSGSIZE;
+}
+
 static bool vxlan_fill_vni_filter_entry(struct sk_buff *skb,
 					struct vxlan_vni_node *vbegin,
-					struct vxlan_vni_node *vend)
+					struct vxlan_vni_node *vend,
+					bool fill_stats)
 {
 	struct nlattr *ventry;
 	u32 vs = be32_to_cpu(vbegin->vni);
@@ -221,6 +260,9 @@ static bool vxlan_fill_vni_filter_entry(struct sk_buff *skb,
 		}
 	}
 
+	if (fill_stats && __vnifilter_entry_fill_stats(skb, vbegin))
+		goto out_err;
+
 	nla_nest_end(skb, ventry);
 
 	return true;
@@ -253,7 +295,7 @@ static void vxlan_vnifilter_notify(const struct vxlan_dev *vxlan,
 	tmsg->family = AF_BRIDGE;
 	tmsg->ifindex = vxlan->dev->ifindex;
 
-	if (!vxlan_fill_vni_filter_entry(skb, vninode, vninode))
+	if (!vxlan_fill_vni_filter_entry(skb, vninode, vninode, false))
 		goto out_err;
 
 	nlmsg_end(skb, nlh);
@@ -273,10 +315,11 @@ static int vxlan_vnifilter_dump_dev(const struct net_device *dev,
 {
 	struct vxlan_vni_node *tmp, *v, *vbegin = NULL, *vend = NULL;
 	struct vxlan_dev *vxlan = netdev_priv(dev);
-	struct tunnel_msg *new_tmsg;
+	struct tunnel_msg *new_tmsg, *tmsg;
 	int idx = 0, s_idx = cb->args[1];
 	struct vxlan_vni_group *vg;
 	struct nlmsghdr *nlh;
+	bool dump_stats;
 	int err = 0;
 
 	if (!(vxlan->cfg.flags & VXLAN_F_VNIFILTER))
@@ -287,6 +330,9 @@ static int vxlan_vnifilter_dump_dev(const struct net_device *dev,
 	if (!vg || !vg->num_vnis)
 		return 0;
 
+	tmsg = nlmsg_data(cb->nlh);
+	dump_stats = !!(tmsg->flags & TUNNEL_MSG_FLAG_STATS);
+
 	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
 			RTM_NEWTUNNEL, sizeof(*new_tmsg), NLM_F_MULTI);
 	if (!nlh)
@@ -306,11 +352,12 @@ static int vxlan_vnifilter_dump_dev(const struct net_device *dev,
 			vend = v;
 			continue;
 		}
-		if (vnirange(vend, v) == 1 &&
+		if (!dump_stats && vnirange(vend, v) == 1 &&
 		    vxlan_addr_equal(&v->remote_ip, &vend->remote_ip)) {
 			goto update_end;
 		} else {
-			if (!vxlan_fill_vni_filter_entry(skb, vbegin, vend)) {
+			if (!vxlan_fill_vni_filter_entry(skb, vbegin, vend,
+							 dump_stats)) {
 				err = -EMSGSIZE;
 				break;
 			}
@@ -322,7 +369,7 @@ static int vxlan_vnifilter_dump_dev(const struct net_device *dev,
 	}
 
 	if (!err && vbegin) {
-		if (!vxlan_fill_vni_filter_entry(skb, vbegin, vend))
+		if (!vxlan_fill_vni_filter_entry(skb, vbegin, vend, dump_stats))
 			err = -EMSGSIZE;
 	}
 
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 3343514db47d..a45a7a7f23dd 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -715,18 +715,39 @@ enum ipvlan_mode {
 /* Tunnel RTM header */
 struct tunnel_msg {
 	__u8 family;
-	__u8 reserved1;
+	__u8 flags;
 	__u16 reserved2;
 	__u32 ifindex;
 };
 
 /* VXLAN section */
+
+/* include statistics in the dump */
+#define TUNNEL_MSG_FLAG_STATS	0x01
+
+/* Embedded inside VXLAN_VNIFILTER_ENTRY_STATS */
+enum {
+	VNIFILTER_ENTRY_STATS_UNSPEC,
+	VNIFILTER_ENTRY_STATS_RX_BYTES,
+	VNIFILTER_ENTRY_STATS_RX_PKTS,
+	VNIFILTER_ENTRY_STATS_RX_DROPS,
+	VNIFILTER_ENTRY_STATS_RX_ERRORS,
+	VNIFILTER_ENTRY_STATS_TX_BYTES,
+	VNIFILTER_ENTRY_STATS_TX_PKTS,
+	VNIFILTER_ENTRY_STATS_TX_DROPS,
+	VNIFILTER_ENTRY_STATS_TX_ERRORS,
+	VNIFILTER_ENTRY_STATS_PAD,
+	__VNIFILTER_ENTRY_STATS_MAX
+};
+#define VNIFILTER_ENTRY_STATS_MAX (__VNIFILTER_ENTRY_STATS_MAX - 1)
+
 enum {
 	VXLAN_VNIFILTER_ENTRY_UNSPEC,
 	VXLAN_VNIFILTER_ENTRY_START,
 	VXLAN_VNIFILTER_ENTRY_END,
 	VXLAN_VNIFILTER_ENTRY_GROUP,
 	VXLAN_VNIFILTER_ENTRY_GROUP6,
+	VXLAN_VNIFILTER_ENTRY_STATS,
 	__VXLAN_VNIFILTER_ENTRY_MAX
 };
 #define VXLAN_VNIFILTER_ENTRY_MAX	(__VXLAN_VNIFILTER_ENTRY_MAX - 1)
-- 
2.25.1

