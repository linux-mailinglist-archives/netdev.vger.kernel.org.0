Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369C44BCEFB
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 15:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243956AbiBTOGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 09:06:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243944AbiBTOGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 09:06:20 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E328635DEB
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 06:05:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xes4G13gGN45zFsy/ibaQanJj+Sdptgw6CoPfKRRBGnXoAhN6n1PuQiBBVB/PLCjzPWGJbzDBdPeFJ8i2wd04j5Tt0ynvc5CaezkhP6JrN8Yi4qqvEnb/htZ2wljyTyVVJx1/zNP9lAR7FYC8qQgCMfJI6IaiB02+pb3HLNWwtlYGV911wjHjhA7/yBsIH7u7lh27MoKPDZN6nrfMXjvmtCx3OTuZHygZ7lUFrYXinlGa0LhmlRl5vq6JOMOoKmtJE8GVoRpcVCW1IR1PnnrvWsvzLTiZ6A8YiM67OoQaJR9Rjuk1IQMV88harAgrR9fDOxYdu9a03lKMNIE53jPZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ffbhZ/z313XQtGQko3uO+TXBMsAslpkbbWJrcH2U4R4=;
 b=T1Yva8xglhktDNQAvHEXpB0LUwQ3MC7ForMCS7MDRu3ck0uIQRckP2ieWWpz6WpVa6ez4UvQ3psDwMhxxmH2+nLV0kjsiruLaf9HEnv/AXapeOts/7z6OkDwHWR0p1xaBHfmLVfbn6WJclyaEg3R+pGHRFjan/D7xhfwF84tEo2LICg5yjWCabwJyZlZWKHjHxtV3qR+0t7gEwy7dJN4/gVG69/bjQlkxn26MZisqCF9t2fhPcr0wx63z6S+1ePuYcElnvNF7WJa7XaEaxjIppN3YEbGlxcLLE0YjiCmpv2WmPzymx2XH8NkGbybcM+kAczxzhxNo/kPUtrpZAPYXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffbhZ/z313XQtGQko3uO+TXBMsAslpkbbWJrcH2U4R4=;
 b=EuzydHsOTH6GDoyiOL99yGQV2CNpbv+cnowMQY4vjvJFBRk8B7RlNaiJlb8+XRKk/ZaZ8HyBSpbDpBFnjPNsSFeXJINUDS3DtslTnRgLAL2OF6hkqzkiOIF0SRJ8WnYOz+SU9WwCszBq5wi7WclOOlcrQllgLPV4oFp8otJVMRFaTTXxfrgwPa08C8RQg+Pizp8KMBQ1794ZpmR1lnAV4N8exoCHNAmYWY5OfvloS9mNytV+KpBuPgTfqoVRZU0D+ZgpDnhokzjs5dYHeAVIDX8nJDp3Lv2emKyoRHjjNp5jtS2+/ok7chPnKcH5lR8JDmIBL1dyHkUg7C69jjo9fA==
Received: from BN9PR03CA0355.namprd03.prod.outlook.com (2603:10b6:408:f6::30)
 by BN6PR1201MB0243.namprd12.prod.outlook.com (2603:10b6:405:50::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15; Sun, 20 Feb
 2022 14:05:50 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::35) by BN9PR03CA0355.outlook.office365.com
 (2603:10b6:408:f6::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Sun, 20 Feb 2022 14:05:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 14:05:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 14:05:49 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 06:05:47 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 20 Feb 2022 06:05:46 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>
Subject: [PATCH net-next 12/12] drivers: vxlan: vnifilter: add support for stats dumping
Date:   Sun, 20 Feb 2022 14:04:05 +0000
Message-ID: <20220220140405.1646839-13-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220220140405.1646839-1-roopa@nvidia.com>
References: <20220220140405.1646839-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8635ea9-31c6-4571-dbe4-08d9f47a1994
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0243:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB024384B8FA752514286C3A8FCB399@BN6PR1201MB0243.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m8jUwuuPjwWAGvVA6sO+Kthx70B4KBrXpGI0RXKXQn50HC4xekIpUDyvecUuOsfyCNeUUvdr+W0Qk+Q2bLrBydpXaGS4uXr3ua7z9pbrJFsWS1RANTPELurVKZdQrcm/8ooh4ebuvmAxpVnVnuLe/xuol4yNswiMm3JCNgNkeo4VYFvcfOUKRBk+1l96J2qq/JdM82zbF/Whhdve/Sox831wNBchXBfwnqo4DmPFQNEgt72C3/z/ACtAKLjbzJ14vgTrNXqv1wcN1CRzir/WHZDVqsKb5ISOJe/261CiDE+HlHP0PXrhaDyf6mBXNKMqZsHJJ3QVYDg8AgCU4GG6a4IqPKE9jXw6TmM7hBESUtcMZ75boE7byxW+M6EV7ItHPtyBviTiZH07wBMLqCb0IUGrYgTteAhRf5qK1Yv+7TLtbcts4um4OLbeoPaKhCPpQQQdro3dnfcnIkXQ31XK+aJ2DKHEYwpBEx67tAVYa4ZogL1UBzfAjC3L2c9tq55WK6TE2h7w36BFPdW5PJv8JhF8cUpwa7Z4nYmYGsFxpVL/Cbbq0JYSZX6YZ49oGdHDgjIgAsbFeUgiTRkVmDZ9i60hMldATf9hn4O2eOq7zpaVuOMcoUrz/vCAkH3LJnAmqHY8kGnv0dhYPHb+DQyC9nbJvJDm7/3F59elCP5Fyoo8peMDt/NjgP1qp5raJkkKNrXbCM/WUZIf+zILJD6aEA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(54906003)(110136005)(356005)(5660300002)(86362001)(82310400004)(4326008)(8936002)(40460700003)(81166007)(70586007)(8676002)(83380400001)(6666004)(316002)(70206006)(2616005)(36756003)(1076003)(336012)(426003)(186003)(26005)(508600001)(47076005)(36860700001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 14:05:50.0290
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8635ea9-31c6-4571-dbe4-08d9f47a1994
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0243
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support for VXLAN vni filter entries' stats dumping.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 drivers/net/vxlan/vxlan_vnifilter.c | 55 ++++++++++++++++++++++++++---
 include/uapi/linux/if_link.h        | 30 +++++++++++++++-
 2 files changed, 79 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_vnifilter.c b/drivers/net/vxlan/vxlan_vnifilter.c
index 935f3007f348..861f7195fe58 100644
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
@@ -277,6 +319,7 @@ static int vxlan_vnifilter_dump_dev(const struct net_device *dev,
 	int idx = 0, s_idx = cb->args[1];
 	struct vxlan_vni_group *vg;
 	struct nlmsghdr *nlh;
+	bool dump_stats;
 	int err = 0;
 
 	if (!(vxlan->cfg.flags & VXLAN_F_VNIFILTER))
@@ -288,6 +331,7 @@ static int vxlan_vnifilter_dump_dev(const struct net_device *dev,
 		return 0;
 
 	tmsg = nlmsg_data(cb->nlh);
+	dump_stats = !!(tmsg->flags & TUNNEL_MSG_FLAG_STATS);
 
 	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
 			RTM_NEWTUNNEL, sizeof(*new_tmsg), NLM_F_MULTI);
@@ -308,11 +352,12 @@ static int vxlan_vnifilter_dump_dev(const struct net_device *dev,
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
@@ -324,7 +369,7 @@ static int vxlan_vnifilter_dump_dev(const struct net_device *dev,
 	}
 
 	if (!err && vbegin) {
-		if (!vxlan_fill_vni_filter_entry(skb, vbegin, vend))
+		if (!vxlan_fill_vni_filter_entry(skb, vbegin, vend, dump_stats))
 			err = -EMSGSIZE;
 	}
 
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index eb046a82188d..1a362c2a8e4b 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -715,17 +715,37 @@ enum ipvlan_mode {
 /* Tunnel RTM header */
 struct tunnel_msg {
 	__u8 family;
-	__u8 reserved1;
+	__u8 flags;
 	__u16 reserved2;
 	__u32 ifindex;
 };
 
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
@@ -737,6 +757,14 @@ enum {
 };
 #define VXLAN_VNIFILTER_MAX	(__VXLAN_VNIFILTER_MAX - 1)
 
+/* Embedded inside LINK_XSTATS_TYPE_VXLAN */
+enum {
+	VXLAN_XSTATS_UNSPEC,
+	VXLAN_XSTATS_VNIFILTER,
+	__VXLAN_XSTATS_MAX
+};
+#define VXLAN_XSTATS_MAX (__VXLAN_XSTATS_MAX - 1)
+
 /* VXLAN section */
 enum {
 	IFLA_VXLAN_UNSPEC,
-- 
2.25.1

