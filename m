Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EACE3F02A3
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 13:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235606AbhHRL0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 07:26:20 -0400
Received: from mail-sn1anam02on2046.outbound.protection.outlook.com ([40.107.96.46]:27774
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235709AbhHRL0L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 07:26:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TNPfI4wwLJBw4qxgQgDjU9kGFfap3xdGG+Qm8paMSFbzUTNEewo7Dq4n2FRc/fzKMeL5wCGSDuo5Ef2EUmeLOoJE3RaMZkd3yyrgSEOkIfgS3xebpnElcqJC9wm3twoPsjuHIpw66DB7te/dzbK5OLhsWGwgIoD2SDkZKq/9KnFLSZjq7TqtLopk61fw1KstltD1IgAOfU7TB+oB+8Hdy/zV6ViV1Fe/z+yG19Z1q8e8SphonP+Gy+ou4MIK/IQbCqUGuD52qZVt28uRggOM7EvOxBjYqBmF+Cg5PV8F+eQ0acC5BA2q8AMxBOIb1Zia9AcOo/lwJiIO1vh2J0qXCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e0qTpYCBbafYorgLi7WM6IJBFyfRjA9j0yk5BhSLePM=;
 b=fn0snc/+4omVlU9cBkQLTHYhhRuk3Tx7YdLn+LGqD84P6/NgjkwYS+NKqjXilyuJ7pWnleUJDSl+BRwbupSUuOaG8wrZAwKC+AlWyZEVaWgY1x0SNCDFSIBQxStDnzcgNiIABeGRZUykhfG+EDDLOiClQGsCkleHSuCg1T63rhGbUVdO+wyHwA65bSafwKJLBNUCTcfskN3rPRS9OdnWfmx/t0wkeBj1k1LxmO56Cax8vEEOGUm8x6keG8nvuUtUfr8nUvbnxL2umdLQPAOKizk3XFaB9TpYQIMEofS1gIsb+jo/aQQt3dXojzdTqyFadO0D8f1vejt4i5rK1nx/MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e0qTpYCBbafYorgLi7WM6IJBFyfRjA9j0yk5BhSLePM=;
 b=BzfNE0umQhCAYw4m7njJCVvXPyzBtxptslEg17W730e5DpOqqAVjWSxQ5pux3AS/N76s6WQTuBJJxwdkjRypCJ4rOX/mB3mJLIttJ60iFbsi8hP81/0DjGME8Pl+1LAIUuaSykrvy/XAgLingsl89gfaDOGkOREqWqu4+oHAwFOWf3u8VVzBlQeMVVvtBfhrdbi79AmwVX7dPqLD6HrkB+9r2oGnFSMLQrKm3jnkdzNrsjHW7gv+Uz3QnWiB5QXEVHeK6x1jRBspdtFBiW7yJBbtXNW8GKW0jh4M6vfxKaIivEtjUAjUG29pFIMdNFPXZlQu+COdvQwcfoB5Xlb38w==
Received: from BN9P220CA0023.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::28)
 by MN2PR12MB4815.namprd12.prod.outlook.com (2603:10b6:208:1bf::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 18 Aug
 2021 11:25:35 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::54) by BN9P220CA0023.outlook.office365.com
 (2603:10b6:408:13e::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4415.16 via Frontend Transport; Wed, 18 Aug 2021 11:25:34 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 11:25:33 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:31 +0000
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <saeedm@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH rdma-next 08/10] RDMA/nldev: Add support to get optional counters statistics
Date:   Wed, 18 Aug 2021 14:24:26 +0300
Message-ID: <20210818112428.209111-9-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20210818112428.209111-1-markzhang@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0551f29-9306-4e5a-b8b6-08d9623ae577
X-MS-TrafficTypeDiagnostic: MN2PR12MB4815:
X-Microsoft-Antispam-PRVS: <MN2PR12MB48159B8B8445708E1115B193C7FF9@MN2PR12MB4815.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DatsRmEAuZZajaYDUOZ7d/kzYjLT5N9aMq0iXU1EkasCUa9ayLysJwcBYrxzjRCqr7LG6WsTZ4+g/KIrccTSY9hX21xDNNXZRJiw7WiuxeF2RAYLRkwJt6YMD7bFEGHjPZR2WJGJ87bgz9OOtxmtcPaqNiPaLJgqukBtF8CVbzdP7IYIeGpMt9AoLJNV4EGKgkjPfz51AR2NRdQXjf98afMMy6ozRaBVKunMaoecSgCUPadl+rPeCb3cXPt8tJ/zUMVoMnXIeWi7YCCzpqLHVvk+1SDM2YQketpq+rXt4HGSOiQGdGsEEaG7s02QQcNm8t01psTfTfVZ6s/vfVu0jn7nRy6bt4l2hWQcZHQTzf3FztcluxWgcmHJre/vGt4fEkEbpmTVWQ7s7VO4AKH1Q9IyF0KsctrCW6FYSghmngjWVwMdtsgkaDniMSQbH7ttNr8fgilcxmeUwGeyI0DYERkDlJNC4r6PeaXjxB7FPg8Q+00LiiNoIRHYbLvGSzCGVAkBXDGF3kmLJ9N7n94js9k1Fz8gHaesKdTZM+7y2/2iEOIiGORUfQMqUlD8BF9/i6w/aYPCK9M1CqgxHpjG455SL6P1PHQoOHTQCE7jH+3Ctwbc4fewZKi9rFDO0crip1AqvKeBEgNWzc3RAd0VP9FnE6aI9C6PoSx+iVbDwWtc4ttF+pkYDpLxpkY+QkotYR1rSLja1ek0tzg7Pfaa+A==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(39860400002)(46966006)(36840700001)(70586007)(70206006)(47076005)(5660300002)(83380400001)(186003)(26005)(6636002)(2906002)(2616005)(7696005)(36756003)(426003)(478600001)(1076003)(36860700001)(336012)(82740400003)(86362001)(7636003)(356005)(8936002)(6666004)(82310400003)(4326008)(8676002)(54906003)(107886003)(110136005)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 11:25:34.4790
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0551f29-9306-4e5a-b8b6-08d9623ae577
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4815
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neta Ostrovsky <netao@nvidia.com>

This patch adds the ability to return per-port optional counter
statistisc through RDMA netlink.

Examples:

$ rdma statistic show link rocep8s0f0/1
link rocep8s0f0/1 rx_write_requests 0 rx_read_requests 0 rx_atomic_requests 0 out_of_buffer 0
out_of_sequence 0 duplicate_request 0 rnr_nak_retry_err 0 packet_seq_err 0 implied_nak_seq_err 0
local_ack_timeout_err 0 resp_local_length_error 0 resp_cqe_error 0 req_cqe_error 0
req_remote_invalid_request 0 req_remote_access_errors 0 resp_remote_access_errors 0
resp_cqe_flush_error 0 req_cqe_flush_error 0 roce_adp_retrans 0 roce_adp_retrans_to 0
roce_slow_restart 0 roce_slow_restart_cnps 0 roce_slow_restart_trans 0 rp_cnp_ignored 0
rp_cnp_handled 0 np_ecn_marked_roce_packets 0 np_cnp_sent 0 rx_icrc_encapsulated 0
    Optional-set: cc_rx_ce_pkts 0

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 drivers/infiniband/core/counters.c |  18 +++++
 drivers/infiniband/core/device.c   |   1 +
 drivers/infiniband/core/nldev.c    | 117 +++++++++++++++++++++++------
 include/rdma/ib_verbs.h            |   3 +
 include/rdma/rdma_counter.h        |   3 +
 5 files changed, 119 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index fa04178aa0eb..5f7a12b8f1bb 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -459,6 +459,24 @@ u64 rdma_counter_get_hwstat_value(struct ib_device *dev, u32 port, u32 index)
 	return sum;
 }
 
+/*
+ * rdma_opcounter_query_stats - Query the per-port optional counter values
+ */
+int rdma_opcounter_query_stats(struct rdma_op_stats *opstats,
+			       struct ib_device *dev, u32 port)
+{
+	int ret = 0;
+
+	if (!dev->ops.get_op_stats)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&opstats->lock);
+	ret = dev->ops.get_op_stats(dev, port, opstats);
+	mutex_unlock(&opstats->lock);
+
+	return ret;
+}
+
 static struct ib_qp *rdma_counter_get_qp(struct ib_device *dev, u32 qp_num)
 {
 	struct rdma_restrack_entry *res = NULL;
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index b9138f20f9a8..efd4b75b7752 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2657,6 +2657,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, get_link_layer);
 	SET_DEVICE_OP(dev_ops, get_netdev);
 	SET_DEVICE_OP(dev_ops, get_numa_node);
+	SET_DEVICE_OP(dev_ops, get_op_stats);
 	SET_DEVICE_OP(dev_ops, get_port_immutable);
 	SET_DEVICE_OP(dev_ops, get_vector_affinity);
 	SET_DEVICE_OP(dev_ops, get_vf_config);
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 17d55d89f11c..b665651dfb1d 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -945,6 +945,30 @@ int rdma_nl_stat_hwcounter_entry(struct sk_buff *msg, const char *name,
 }
 EXPORT_SYMBOL(rdma_nl_stat_hwcounter_entry);
 
+static int rdma_nl_stat_opcounter_entry(struct sk_buff *msg, const char *name,
+					u64 value)
+{
+	struct nlattr *entry_attr;
+
+	entry_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY);
+	if (!entry_attr)
+		return -EMSGSIZE;
+
+	if (nla_put_string(msg, RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_NAME,
+			   name))
+		goto err;
+	if (nla_put_u64_64bit(msg, RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_VALUE,
+			      value, RDMA_NLDEV_ATTR_PAD))
+		goto err;
+
+	nla_nest_end(msg, entry_attr);
+	return 0;
+
+err:
+	nla_nest_cancel(msg, entry_attr);
+	return -EMSGSIZE;
+}
+
 static int fill_stat_mr_entry(struct sk_buff *msg, bool has_cap_net_admin,
 			      struct rdma_restrack_entry *res, uint32_t port)
 {
@@ -2124,15 +2148,52 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return ret;
 }
 
+static int stat_get_optional_counter(struct sk_buff *msg,
+				     struct ib_device *device, u32 port)
+{
+	struct rdma_op_stats *opstats;
+	struct nlattr *opstats_table;
+	int i, ret = 0;
+
+	opstats = device->port_data[port].port_counter.opstats;
+	if (!opstats)
+		return 0;
+
+	ret = rdma_opcounter_query_stats(opstats, device, port);
+	if (ret)
+		return ret;
+
+	opstats_table = nla_nest_start(msg, RDMA_NLDEV_ATTR_STAT_OPCOUNTERS);
+	if (!opstats_table)
+		return -EMSGSIZE;
+
+	for (i = 0; i < opstats->num_opcounters; i++) {
+		if (!(opstats->opcounters[i].enabled))
+			continue;
+		ret = rdma_nl_stat_opcounter_entry(msg,
+						   opstats->opcounters[i].name,
+						   opstats->opcounters[i].value);
+		if (ret)
+			goto err;
+	}
+	nla_nest_end(msg, opstats_table);
+
+	return 0;
+
+err:
+	nla_nest_cancel(msg, opstats_table);
+	return ret;
+}
+
 static int stat_get_doit_default_counter(struct sk_buff *skb,
 					 struct nlmsghdr *nlh,
 					 struct netlink_ext_ack *extack,
 					 struct nlattr *tb[])
 {
-	struct rdma_hw_stats *stats;
-	struct nlattr *table_attr;
+	struct rdma_hw_stats *hwstats;
+	struct nlattr *hwstats_table;
 	struct ib_device *device;
-	int ret, num_cnts, i;
+	int ret, num_hwstats, i;
 	struct sk_buff *msg;
 	u32 index, port;
 	u64 v;
@@ -2145,14 +2206,19 @@ static int stat_get_doit_default_counter(struct sk_buff *skb,
 	if (!device)
 		return -EINVAL;
 
+	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
+	if (!rdma_is_port_valid(device, port)) {
+		ret = -EINVAL;
+		goto err;
+	}
+
 	if (!device->ops.alloc_hw_port_stats || !device->ops.get_hw_stats) {
 		ret = -EINVAL;
 		goto err;
 	}
 
-	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
-	stats = ib_get_hw_stats_port(device, port);
-	if (!stats) {
+	hwstats = ib_get_hw_stats_port(device, port);
+	if (!hwstats) {
 		ret = -EINVAL;
 		goto err;
 	}
@@ -2174,38 +2240,43 @@ static int stat_get_doit_default_counter(struct sk_buff *skb,
 		goto err_msg;
 	}
 
-	mutex_lock(&stats->lock);
+	mutex_lock(&hwstats->lock);
 
-	num_cnts = device->ops.get_hw_stats(device, stats, port, 0);
-	if (num_cnts < 0) {
+	num_hwstats = device->ops.get_hw_stats(device, hwstats, port, 0);
+	if (num_hwstats < 0) {
 		ret = -EINVAL;
-		goto err_stats;
+		goto err_hwstats;
 	}
 
-	table_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_STAT_HWCOUNTERS);
-	if (!table_attr) {
+	hwstats_table = nla_nest_start(msg, RDMA_NLDEV_ATTR_STAT_HWCOUNTERS);
+	if (!hwstats_table) {
 		ret = -EMSGSIZE;
-		goto err_stats;
+		goto err_hwstats;
 	}
-	for (i = 0; i < num_cnts; i++) {
-		v = stats->value[i] +
+	for (i = 0; i < num_hwstats; i++) {
+		v = hwstats->value[i] +
 			rdma_counter_get_hwstat_value(device, port, i);
-		if (rdma_nl_stat_hwcounter_entry(msg, stats->names[i], v)) {
+		if (rdma_nl_stat_hwcounter_entry(msg, hwstats->names[i], v)) {
 			ret = -EMSGSIZE;
-			goto err_table;
+			goto err_hwstats_table;
 		}
 	}
-	nla_nest_end(msg, table_attr);
+	nla_nest_end(msg, hwstats_table);
+
+	mutex_unlock(&hwstats->lock);
+
+	ret = stat_get_optional_counter(msg, device, port);
+	if (ret)
+		goto err_msg;
 
-	mutex_unlock(&stats->lock);
 	nlmsg_end(msg, nlh);
 	ib_device_put(device);
 	return rdma_nl_unicast(sock_net(skb->sk), msg, NETLINK_CB(skb).portid);
 
-err_table:
-	nla_nest_cancel(msg, table_attr);
-err_stats:
-	mutex_unlock(&stats->lock);
+err_hwstats_table:
+	nla_nest_cancel(msg, hwstats_table);
+err_hwstats:
+	mutex_unlock(&hwstats->lock);
 err_msg:
 	nlmsg_free(msg);
 err:
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index fa9e668b9b14..d85f2e842a1d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2602,6 +2602,9 @@ struct ib_device_ops {
 			   int optional_stat);
 	int (*remove_op_stat)(struct ib_device *device, u32 port,
 			      int optional_stat);
+	int (*get_op_stats)(struct ib_device *device, u32 port,
+			    struct rdma_op_stats *stats);
+
 	/**
 	 * Allows rdma drivers to add their own restrack attributes.
 	 */
diff --git a/include/rdma/rdma_counter.h b/include/rdma/rdma_counter.h
index 48086a7248ac..31686a234c77 100644
--- a/include/rdma/rdma_counter.h
+++ b/include/rdma/rdma_counter.h
@@ -67,5 +67,8 @@ int rdma_opcounter_add(struct ib_device *dev, u32 port,
 		       const char *name);
 int rdma_opcounter_remove(struct ib_device *dev, u32 port,
 			  const char *name);
+int rdma_opcounter_query_stats(struct rdma_op_stats *opstats,
+			       struct ib_device *dev, u32 port);
+
 
 #endif /* _RDMA_COUNTER_H_ */
-- 
2.26.2

