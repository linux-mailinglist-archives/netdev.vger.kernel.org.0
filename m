Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998C84C82CB
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 06:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiCAFGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 00:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbiCAFGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 00:06:16 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23D674607
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:04:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6PR4UpTn573OYmyxE6hOiDWhW4cJA2aHJC18JkR46bk0W70pFmGWRPhvuDmOW1qXDnNI/HOvJ+UGoYvCpVoSZ8oksdqfBzOS/hJsWiQ88DKjr503ofAEEwfgk0rH8vVqqDV58lETM18C6aUvrK442P17SQF8GdLLhiGhxAtK1uPLkhCMF0P6MGFQKvC4j+JtWHsOJYiwvEIE8bVZDgoEHdTA5c3Tdd0t9KvE4AfpgTNt0XMT3ZGtLw0uKpCJEzyWLz5MYoqQXY3X50qPoKBqVnvQUdWCmkbG6/fiZ1/zSiqIY8+f2yS2UIZ5SHZvjPmaNBe1Pakrt+oEtssPq14hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3okl5Vq7KYWRwEdqzyNN5vnU1xpjtpEhspAanHYLHlo=;
 b=TX67MnvcSCcw7SrhiM4XmMGvwRHtbP5GHEFWt3qOZAab1+yqsmrS6cEYYrja3fvbmDZq5qLtWjVInP1vg3+LLJ78vVIgq/5ZlgYdVNp3HT1OYnssVXHhDHL3Wmvun8Y7d9VahKrTpnLagfSrBGc8Vd9FLjEId2XYnO+I62Pnldnsj0nNzwpqA2Sqz87mR8c+SVTqkq4QGOU4LsFIhKVJsvytJ83s2ziEf0GGn4WJw/wlEssXdxlt+CJWdgYNEYAw5NpH/qneyt0SXoNd2QffZtoNJPLeHZq0O7Wpj4IUaLXfkNvCEHcvB3lhJkXz6tQCisaROuSjb7SReGc1CeELxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3okl5Vq7KYWRwEdqzyNN5vnU1xpjtpEhspAanHYLHlo=;
 b=hJ2y3eDEIS+l+XYJoJ3gWI04pfEo2rNjpxLQWLaGyilEH3UI6va7aRleVFcYbC9ysShCvanUOZZFomAK6FGnQ3XFt0p6idMlc5x083A0MPVhA6nI7rHbI9OWZTvf/sybLPZCUgYUdj+ob4q2LChR8qtldpKM5AxpTvcyMNUFF0dRdImTkte9n88NcmoIJJ0GDGg/wbLlrE45BoaMu35OvmVOqdvBFZXZKWtnBnpoBqDpHagyPlS8spfhaivS1kGJJX3sf3fXwM1Rs3En6CtoPcwgv66zO2i3F+hFlBg+VFVwUpEDsO7Il0oxcrj+07fEkLusIvlFVHjl6mm/sJSU/Q==
Received: from DM5PR07CA0102.namprd07.prod.outlook.com (2603:10b6:4:ae::31) by
 PH7PR12MB5927.namprd12.prod.outlook.com (2603:10b6:510:1da::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.26; Tue, 1 Mar 2022 05:04:52 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::24) by DM5PR07CA0102.outlook.office365.com
 (2603:10b6:4:ae::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Tue, 1 Mar 2022 05:04:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 05:04:51 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Mar
 2022 05:04:50 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 28 Feb 2022
 21:04:49 -0800
Received: from localhost.localdomain (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 28 Feb 2022 21:04:49 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v3 12/12] drivers: vxlan: vnifilter: add support for stats dumping
Date:   Tue, 1 Mar 2022 05:04:39 +0000
Message-ID: <20220301050439.31785-13-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301050439.31785-1-roopa@nvidia.com>
References: <20220301050439.31785-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a15c3fb0-8fa7-4df5-f365-08d9fb41048a
X-MS-TrafficTypeDiagnostic: PH7PR12MB5927:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB5927F6B26C7C23E2A7D092B9CB029@PH7PR12MB5927.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4WT7X5UPXcXXD3SmpgkP05VAV1Dur/7y6qpFx3ZbiZi00VbxY+aKC7rWX80E7D42CwkI8IaXfzcS6iLf+R5ZYHtXx9OBYB+5Ov84YD2Mi/IpHrZUvPjWF3yLLDt5cYM32wcQuG9yTZBItyUgiFCjWvWMw6DCEyL9Pc3+woz/sWy2z5DwZmu7kBcdWh1ugpP5UtsiR9bWYsgipEL68HdrOtpHTAuajNS9gbmqFhgC2TKQBx0+IZGp1TrgwZekV2TIafUz/kHdllgTmfQyrQwSHJXLIb2/CEFN0Kip5bQsD6XRFNcKj2D7CEan6Y3sjeIuiQ39cLsUhbxr1MMe3ypUSsyJnKhhLraBcaReO+jVW4PsBOYDDH7+F1jE26RwAmurbamq5Olo/+XSuIBrsvL2CL8yog1qIOWRrY05gEn6T4kToPQL3jUgJHkt64T1oXQxNbKnE640h9xaHrurKnL+bs7FbBMbUgx8sVR4Zq79pUYdZ6N9jhVAXxKw5Pe2/pbRadNKtuKaWBZ9RwespBHpHrZBBOwH6ytLFbcC/Bc9Vuwv1Gk+v3pCVXbKW38TqW9Zhip4gz3TEnUArJ5xtYwglRWcL9kgtN+H9wh/y6ilEbnlkilqcDe/4bzYHJquAubeDxDcWJSJ1iuvcBfcIvXuo68uJZShH71s5LvmGx8gCLEfdfFhOIaph6smgM+2ixwKSMMvXVWOJTb/PDvglfnWKA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(186003)(5660300002)(26005)(2906002)(508600001)(6666004)(1076003)(107886003)(110136005)(2616005)(54906003)(8936002)(70206006)(4326008)(8676002)(70586007)(82310400004)(36756003)(81166007)(83380400001)(40460700003)(356005)(426003)(336012)(36860700001)(47076005)(316002)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 05:04:51.5890
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a15c3fb0-8fa7-4df5-f365-08d9fb41048a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5927
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/net/vxlan/vxlan_vnifilter.c | 92 +++++++++++++++++++++++++++--
 include/uapi/linux/if_link.h        | 25 +++++++-
 2 files changed, 110 insertions(+), 7 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_vnifilter.c b/drivers/net/vxlan/vxlan_vnifilter.c
index 2d23312f4f62..9f28d0b6a6b2 100644
--- a/drivers/net/vxlan/vxlan_vnifilter.c
+++ b/drivers/net/vxlan/vxlan_vnifilter.c
@@ -116,6 +116,34 @@ void vxlan_vs_del_vnigrp(struct vxlan_dev *vxlan)
 	spin_unlock(&vn->sock_lock);
 }
 
+static void vxlan_vnifilter_stats_get(const struct vxlan_vni_node *vninode,
+				      struct vxlan_vni_stats *dest)
+{
+	int i;
+
+	memset(dest, 0, sizeof(*dest));
+	for_each_possible_cpu(i) {
+		struct vxlan_vni_stats_pcpu *pstats;
+		struct vxlan_vni_stats temp;
+		unsigned int start;
+
+		pstats = per_cpu_ptr(vninode->stats, i);
+		do {
+			start = u64_stats_fetch_begin_irq(&pstats->syncp);
+			memcpy(&temp, &pstats->stats, sizeof(temp));
+		} while (u64_stats_fetch_retry_irq(&pstats->syncp, start));
+
+		dest->rx_packets += temp.rx_packets;
+		dest->rx_bytes += temp.rx_bytes;
+		dest->rx_drops += temp.rx_drops;
+		dest->rx_errors += temp.rx_errors;
+		dest->tx_packets += temp.tx_packets;
+		dest->tx_bytes += temp.tx_bytes;
+		dest->tx_drops += temp.tx_drops;
+		dest->tx_errors += temp.tx_errors;
+	}
+}
+
 static void vxlan_vnifilter_stats_add(struct vxlan_vni_node *vninode,
 				      int type, unsigned int len)
 {
@@ -182,9 +210,48 @@ static size_t vxlan_vnifilter_entry_nlmsg_size(void)
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
@@ -217,6 +284,9 @@ static bool vxlan_fill_vni_filter_entry(struct sk_buff *skb,
 		}
 	}
 
+	if (fill_stats && __vnifilter_entry_fill_stats(skb, vbegin))
+		goto out_err;
+
 	nla_nest_end(skb, ventry);
 
 	return true;
@@ -249,7 +319,7 @@ static void vxlan_vnifilter_notify(const struct vxlan_dev *vxlan,
 	tmsg->family = AF_BRIDGE;
 	tmsg->ifindex = vxlan->dev->ifindex;
 
-	if (!vxlan_fill_vni_filter_entry(skb, vninode, vninode))
+	if (!vxlan_fill_vni_filter_entry(skb, vninode, vninode, false))
 		goto out_err;
 
 	nlmsg_end(skb, nlh);
@@ -269,10 +339,11 @@ static int vxlan_vnifilter_dump_dev(const struct net_device *dev,
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
@@ -283,6 +354,9 @@ static int vxlan_vnifilter_dump_dev(const struct net_device *dev,
 	if (!vg || !vg->num_vnis)
 		return 0;
 
+	tmsg = nlmsg_data(cb->nlh);
+	dump_stats = !!(tmsg->flags & TUNNEL_MSG_FLAG_STATS);
+
 	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
 			RTM_NEWTUNNEL, sizeof(*new_tmsg), NLM_F_MULTI);
 	if (!nlh)
@@ -302,11 +376,12 @@ static int vxlan_vnifilter_dump_dev(const struct net_device *dev,
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
@@ -318,7 +393,7 @@ static int vxlan_vnifilter_dump_dev(const struct net_device *dev,
 	}
 
 	if (!err && vbegin) {
-		if (!vxlan_fill_vni_filter_entry(skb, vbegin, vend))
+		if (!vxlan_fill_vni_filter_entry(skb, vbegin, vend, dump_stats))
 			err = -EMSGSIZE;
 	}
 
@@ -338,6 +413,11 @@ static int vxlan_vnifilter_dump(struct sk_buff *skb, struct netlink_callback *cb
 
 	tmsg = nlmsg_data(cb->nlh);
 
+	if (tmsg->flags & ~TUNNEL_MSG_VALID_USER_FLAGS) {
+		NL_SET_ERR_MSG(cb->extack, "Invalid tunnelmsg flags in ancillary header");
+		return -EINVAL;
+	}
+
 	rcu_read_lock();
 	if (tmsg->ifindex) {
 		dev = dev_get_by_index_rcu(net, tmsg->ifindex);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 3dfc9ff2ec9b..e315e53125f4 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -716,18 +716,41 @@ enum ipvlan_mode {
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
+#define TUNNEL_MSG_VALID_USER_FLAGS TUNNEL_MSG_FLAG_STATS
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

