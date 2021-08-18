Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A791D3F02A6
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 13:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235875AbhHRL0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 07:26:23 -0400
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:19905
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235864AbhHRL0R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 07:26:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBjBLtAMy53OieEDWQh0K+tvN5jxBn4DNcBfd1FzpfA65o2xP2aHLKBcgzAt+uPi49qcv4ctqXmPwXVbAqsyGzyJAbXt2y9kRkTkdksBnOg17mobU5nkEatnsfJw/RBtuBBvTVTAXH9xlHlns5xoqOEGJzabSvEXt91NMjIcdxx3X+vGZqa8JDhSYTP9qbZ5EhegLrAp9TOeIPlnhZonY7J+sOSbcSA+AqngiVJQs6+WoWFZvkk03KXP+H8amKL/SWhSjddasBaSMWd7jF2bDZDbDyHO5ukS/ZqYyZc5qaIwog98XNKt6zfbvqB4ukaAgU4xgmlWV1Vk37bxBlfmlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TphZ9TFmuUhBaGXXstZod0+QTvSbJ9F+HzzTaQnyN/o=;
 b=RnJCZ2JDJNrQwd5ZT2sb4AuhsmEYWJo4JIkhwLYo/lCEw+dAwPmI0BTXUZJ0EmhDXaJ79RgeanUV2rv0GNl2sKT+UC/Fm1jIgLfJAugu4aOSEoVaXXko9i9PxXp3KE1cYz0CLXWR/15dCHZn2ix89xBsEcq3tnkM+eT+CjRH8mPsyr25varFi/2vY/T0tAPj69ygHph5aF93viMsQyQNTWo+07AFsKVRS6F9mt+UTsLEC8FSAAWCSD0ZSg7/aIsBBwTJroBCn+x5cX3g7azlBPh1EcqRu6xvnl1u+7np4NtwxZ7YvnpEnWRI20X8QydA4L8T9V8uutoD1XcbYJqkPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TphZ9TFmuUhBaGXXstZod0+QTvSbJ9F+HzzTaQnyN/o=;
 b=EWf5Mwm542IiD/Cgg6Dof6sHahU36+Fxcvhux7wiX1iFUyEPrMqSCmFkj8ga1ze6KP8Cdl4SZqRboaiAoMg0D3HPxUde68PYKdViN76tCVl1chw0DBHSaOmFMKAgwsqJgHlQkCzzoAfjQj5nD7AgkcfbePfqYs8oUdDhp8Sejbl1wkXEkYJ3inruPaUEHjC5RkTXn1Q7K6nmCnVY4zUowzdTJQZvUYxMcrF5DrHbv8kp2U4Dwux3uTgi9nxOgWPVlUnG1tau9KWRWJA95rOU0uYWok0w8ILAJfV4lFC0/vmZiJOJ3eV0J8LBB5I2lgYS0RLpSOOPJem0VskemNaIlQ==
Received: from BN9PR03CA0224.namprd03.prod.outlook.com (2603:10b6:408:f8::19)
 by BYAPR12MB2664.namprd12.prod.outlook.com (2603:10b6:a03:69::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Wed, 18 Aug
 2021 11:25:40 +0000
Received: from BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::de) by BN9PR03CA0224.outlook.office365.com
 (2603:10b6:408:f8::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT062.mail.protection.outlook.com (10.13.177.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 11:25:40 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 11:25:39 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 11:25:38 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:36 +0000
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <saeedm@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH rdma-next 10/10] RDMA/nldev: Add support to get current enabled optional counters
Date:   Wed, 18 Aug 2021 14:24:28 +0300
Message-ID: <20210818112428.209111-11-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20210818112428.209111-1-markzhang@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd8f90b0-d71d-48d9-a582-08d9623ae8d2
X-MS-TrafficTypeDiagnostic: BYAPR12MB2664:
X-Microsoft-Antispam-PRVS: <BYAPR12MB26645D17B06F9A62F71D2A46C7FF9@BYAPR12MB2664.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MzJNIQxeXPKKrH4ZLWYEu7q4UgTaz6AYJQ8paS00ie/KMv4r8eNdLFw6rg/53JhbZ6Wnsck5m0PD0Q/B6Nge69KmtOYfRNAwaIwRs62rbKfdK1DnTBAmwyQDh6i89h+v+iMH+/032Jx2GpYeBq1xOT4ArMW7NyyI/WUUBTT49RFaJixqL4+I+X5068O5gjyMbFKQyP9zaBkFh27Mmfl/xjQXdEpjRTS7D5YZjDHknLBXcrcj8x5ZOMVB16kIHIpEXOXakKjcN5QsU4ESyD5YvQGBXHBiCtvYBoQe1lLl3Bgsyno4/UgTG7xkdMKsBxJCIPcVgsasGIlKDjnFVVPyFV3dgWwkvPKjAVXUi3tQYdvpArWUYa60zYDv8dPyFTnmvgLwap2l0064S9C8MOIUBT2p/puAbfzSAYgAByev1lAdifzovHa3ZcKfcCK6PUeuAb50TT+nkqHCDraPhB6ZI1AiqIYFfi1D8KhxqyqZHeEta9B1mUIS9P2KRVlhe7xQtKK8xmNxaDv+20mOKr6oDBtMnynX2YJDYGJ91EeGCjgTBkVHGQuckyfLjgbVBkKhB0/MhMuD5qB8vYr34zV7qba/GzqTgENo4Dje9voWzq2vwerFFaD9ZP799kNPmZTMpjiuIWKUTPUV97zS0iM7oylppvBfNU5Xm0m3XMD5tl7i2qEZtYvuUG+bBe4aihr5IMAWb9K9lrDnmmPn6+2tIw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(36840700001)(46966006)(336012)(36756003)(426003)(82740400003)(186003)(107886003)(5660300002)(54906003)(1076003)(26005)(70206006)(36860700001)(70586007)(47076005)(4326008)(2906002)(8936002)(2616005)(6666004)(316002)(7636003)(6636002)(110136005)(7696005)(82310400003)(86362001)(478600001)(83380400001)(356005)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 11:25:40.1401
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd8f90b0-d71d-48d9-a582-08d9623ae8d2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2664
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

This patch adds the ability to show the added and supported optional
counters for each link through RDMA netlink.

Examples:

$ rdma statistic mode
link rocep8s0f0/1
    Optional-set: cc_rx_ce_pkts

$ rdma statistic mode supported
link rocep8s0f0/1
    Optional-set: cc_rx_ce_pkts cc_rx_cnp_pkts cc_tx_cnp_pkts
link rocep8s0f1/1
    Optional-set: cc_rx_ce_pkts cc_rx_cnp_pkts cc_tx_cnp_pkts

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 drivers/infiniband/core/nldev.c  | 91 +++++++++++++++++++++++++++++++-
 include/uapi/rdma/rdma_netlink.h |  2 +
 2 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index b665651dfb1d..611e4fe6a244 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -159,6 +159,8 @@ static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_NAME] = { .type = NLA_NUL_STRING,
 				  .len = RDMA_NLDEV_ATTR_OPCOUNTER_NAME_SIZE },
 	[RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_VALUE] = { .type = NLA_U64 },
+	[RDMA_NLDEV_ATTR_STAT_OP_MODE_LIST]	= { .type = NLA_U8 },
+	[RDMA_NLDEV_ATTR_STAT_OP_MODE_LIST_SUPPORTED] = { .type = NLA_U8 },
 };
 
 static int put_driver_name_print_type(struct sk_buff *msg, const char *name,
@@ -946,7 +948,7 @@ int rdma_nl_stat_hwcounter_entry(struct sk_buff *msg, const char *name,
 EXPORT_SYMBOL(rdma_nl_stat_hwcounter_entry);
 
 static int rdma_nl_stat_opcounter_entry(struct sk_buff *msg, const char *name,
-					u64 value)
+					u64 value, bool send_value)
 {
 	struct nlattr *entry_attr;
 
@@ -960,6 +962,12 @@ static int rdma_nl_stat_opcounter_entry(struct sk_buff *msg, const char *name,
 	if (nla_put_u64_64bit(msg, RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_VALUE,
 			      value, RDMA_NLDEV_ATTR_PAD))
 		goto err;
+	if (send_value) {
+		if (nla_put_u64_64bit(msg,
+				      RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_VALUE,
+				      value, RDMA_NLDEV_ATTR_PAD))
+			goto err;
+	}
 
 	nla_nest_end(msg, entry_attr);
 	return 0;
@@ -2148,6 +2156,79 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return ret;
 }
 
+static int stat_get_doit_list_opstats(struct sk_buff *skb,
+				      struct nlmsghdr *nlh,
+				      struct netlink_ext_ack *extack,
+				      struct nlattr *tb[], u32 index,
+				      struct ib_device *device, u32 port)
+{
+	struct rdma_op_stats *opstats;
+	struct nlattr *opstats_list;
+	bool list_supported = false;
+	struct sk_buff *msg;
+	int i, ret;
+
+	if (tb[RDMA_NLDEV_ATTR_STAT_OP_MODE_LIST_SUPPORTED])
+		list_supported = true;
+
+	opstats = device->port_data[port].port_counter.opstats;
+	if (!opstats)
+		return -EOPNOTSUPP;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
+			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
+					 RDMA_NLDEV_CMD_STAT_GET),
+			0, 0);
+
+	if (fill_nldev_handle(msg, device) ||
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port)) {
+		ret = -EMSGSIZE;
+		goto err_msg;
+	}
+
+	opstats_list =
+		nla_nest_start(msg, RDMA_NLDEV_ATTR_STAT_OPCOUNTERS);
+
+	if (!opstats_list) {
+		ret = -EMSGSIZE;
+		goto err_msg;
+	}
+
+	mutex_lock(&opstats->lock);
+
+	for (i = 0; i < opstats->num_opcounters; i++) {
+		if (!opstats->opcounters[i].enabled && !list_supported)
+			continue;
+		ret = rdma_nl_stat_opcounter_entry(msg,
+						   opstats->opcounters[i].name,
+						   0, false);
+		if (ret)
+			goto err_opstats_msg;
+	}
+	nla_nest_end(msg, opstats_list);
+
+	mutex_unlock(&opstats->lock);
+
+	nlmsg_end(msg, nlh);
+	ib_device_put(device);
+	return rdma_nl_unicast(sock_net(skb->sk), msg, NETLINK_CB(skb).portid);
+
+err_opstats_msg:
+	nla_nest_cancel(msg, opstats_list);
+	mutex_unlock(&opstats->lock);
+err_msg:
+	nlmsg_free(msg);
+err:
+	ib_device_put(device);
+	return ret;
+}
+
 static int stat_get_optional_counter(struct sk_buff *msg,
 				     struct ib_device *device, u32 port)
 {
@@ -2172,7 +2253,8 @@ static int stat_get_optional_counter(struct sk_buff *msg,
 			continue;
 		ret = rdma_nl_stat_opcounter_entry(msg,
 						   opstats->opcounters[i].name,
-						   opstats->opcounters[i].value);
+						   opstats->opcounters[i].value,
+						   true);
 		if (ret)
 			goto err;
 	}
@@ -2212,6 +2294,11 @@ static int stat_get_doit_default_counter(struct sk_buff *skb,
 		goto err;
 	}
 
+	if (tb[RDMA_NLDEV_ATTR_STAT_OP_MODE_LIST] ||
+	    tb[RDMA_NLDEV_ATTR_STAT_OP_MODE_LIST_SUPPORTED])
+		return stat_get_doit_list_opstats(skb, nlh, extack, tb,
+						  index, device, port);
+
 	if (!device->ops.alloc_hw_port_stats || !device->ops.get_hw_stats) {
 		ret = -EINVAL;
 		goto err;
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 79e6ca87d2e0..57f39d8fe434 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -557,6 +557,8 @@ enum rdma_nldev_attr {
 	RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY,	/* nested table */
 	RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_NAME,	/* string */
 	RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_VALUE,	/* u64 */
+	RDMA_NLDEV_ATTR_STAT_OP_MODE_LIST,		/* u8 */
+	RDMA_NLDEV_ATTR_STAT_OP_MODE_LIST_SUPPORTED,	/* u8 */
 
 	/*
 	 * Always the end
-- 
2.26.2

