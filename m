Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3621D426ABE
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241534AbhJHM2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:28:36 -0400
Received: from mail-dm6nam11on2062.outbound.protection.outlook.com ([40.107.223.62]:59392
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241510AbhJHM2V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 08:28:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UHUnRZOmxAqU/c7CKLCowK1DOjJwekm/AlZ+A4ziHs9cX/qYEfpt2ASqrLknDRKKNqo+O1RXri/RPgCHat8UFUTXbXpNiSwxLzL/vmXhHdT8/z9Ar/e5dFKTToaWWjlE0Bu1jrCplLgkWziQXzkV6NfONMg8zpz1GCq1fJPlaCtD4DFquObz3oPlUD3S8Jw2iryrudVJIQ3k2SxQVIDvfbkeOs123wQnIL5vJR/DQG+dUaqPEoB3lg48LrEzhgCzlZcNld9CpQj6Z7ZWjg3/C2XTg+Eafl4mPce+IYbHzNDnv+xZ7wQQe0uZ++bSFntYb8q/esPcNNKzu0KCByFZ1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZuBrAnYasxb+S6ALBNwEy3sRS3Sh+HWNJkXrPYJrGNU=;
 b=Zr7wQmuWd4ZoWoGvFz/amd6K9cQKZ4ohvu4EBoIWq8EMGt8U7/KpSME6BlpQD9W5JLoICcpW8mdfcq+0wxqtuHG7AdEeHbnW71GKUTXloxjRBK2D+veRJdzu+M/UI+pmrZyP9E8sF+T+DwDfK/zlX5m3TL7EgLtc/rHA1Pu3d7fs4iO+TQ/+gPmPu7p9UkhFR4KgD+hhWK2LUGrNLs2I0ya7sxlN1xFNIcwgkyFj2PKuPhxxr3qi5dtakY0Zpi6ct6g71c/Xmf7ntJXhl6vRVPY4yg2ftgXlP2k/D8WWqdtm3qktqkljjvOdpS7tAGIAMIrxBjhOF/FizW1Ib4Z68A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=chelsio.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZuBrAnYasxb+S6ALBNwEy3sRS3Sh+HWNJkXrPYJrGNU=;
 b=IyO0g8sxr/dI+de3CZ7DPT+HX4yFWwWRSNVqs5ke7++2+M+4srtKl0vbS6hH+MOO4LpS1EnbdWmozwDx8pZOI9dsiNJLlpcQ+/DI5zTDnnVzwK2rmm9FujNosywh17QAJPJ9rQMIWZjZ2Q1JFI2IvPGwIKvqC7U1Cp1/Gg00wK8VLEjGetEdt72XJmkqIx1AIhir9bXR9wn6VN0HNzi6vlgroS/l/Vot0StHxt8YS6edrweu/Cf9j2DOZLPFpc9Ut1pEyyiy9JlQaDnH70nXNlWktjXVWsPD8sNfzLyA4mK8Oq6jPkq5OspkHKMrtYrmRMww1SS7ZyRPwIeoXpKRMA==
Received: from BN9P222CA0014.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::19)
 by DM6PR12MB4944.namprd12.prod.outlook.com (2603:10b6:5:1ba::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Fri, 8 Oct
 2021 12:26:25 +0000
Received: from BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::29) by BN9P222CA0014.outlook.office365.com
 (2603:10b6:408:10c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend
 Transport; Fri, 8 Oct 2021 12:26:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; chelsio.com; dkim=none (message not signed)
 header.d=none;chelsio.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT033.mail.protection.outlook.com (10.13.177.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 12:26:24 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 12:26:23 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 05:26:18 -0700
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <saeedm@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        <dennis.dalessandro@cornelisnetworks.com>, <galpress@amazon.com>,
        <kuba@kernel.org>, <maorg@nvidia.com>,
        <mike.marciniszyn@cornelisnetworks.com>,
        <mustafa.ismail@intel.com>, <bharat@chelsio.com>,
        <selvin.xavier@broadcom.com>, <shiraz.saleem@intel.com>,
        <yishaih@nvidia.com>, <zyjzyj2000@gmail.com>,
        "Mark Zhang" <markzhang@nvidia.com>
Subject: [PATCH rdma-next v4 07/13] RDMA/nldev: Add support to get status of all counters
Date:   Fri, 8 Oct 2021 15:24:33 +0300
Message-ID: <20211008122439.166063-8-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20211008122439.166063-1-markzhang@nvidia.com>
References: <20211008122439.166063-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb2bc597-f562-45b8-92ff-08d98a56d803
X-MS-TrafficTypeDiagnostic: DM6PR12MB4944:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4944D178E51400D0A957B51AC7B29@DM6PR12MB4944.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J/D320qVVmpt0IjYyGJXA4U3Kvbizkg/VJmiCjlvy5h8rRxDcnPS8K7Xv1Ym9ai78Xooyp1s9Adp2PXWhUu64V/ejAz9sbuVPp/9UO12krj3pFDHdgvYJQvupd05kxtgDfTOWm+V/U/eAnKFoaGcT7BkcPwY9HeW347JeKABMMb5ErioqEEA98aTQqpxWAc5O3G7x2kxlv9ETEIkC6mWZzpNlCGIbSAmvN3BLmKGkJB1ZNtb9sOWhtWQhResQfiqGJjeKM2RMWnvIULX5XL4eanMJN1MxD//KlIfsRkNMTgi/CDUb3uxZ9WrAPiKKvoz+TYlbDlIHVhxWlbefPEBLCx+R/OpJslC+jA4fihP6laGC6UeO0fxYeEpkAo27W6Cv/yXetelw2FTrZfiU+aPZM6fm9IzTgxrhv+FLWYjDijjI98GogKoM4Qe2ad2On7OhWQ9mjiGF7vcv3GM3uHObmxzz2hGREVVC8ED2QJrWUf7N2TDRqmtXogc2jQyqvLozXWZ3pf3UNjf6XXmS2QE6egBruvCmacHGRbHgzAbelK1DlXIU275Bhd42bZbRKVFB40S0s3YArrYxRbvb9qcGTIPsnKkxZLBIXMFLLCsIC1ldrsdX3s0AR3pOddzl9LxVUt5fdf0pt3jHPoondOpL1BPcd0PLb4teymowOgqGw6E2283ThP+wgxLP1GmAvyNjqes9CKoGou9PbGTPipLzQ==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(508600001)(2616005)(70206006)(6666004)(70586007)(54906003)(36756003)(426003)(36860700001)(107886003)(83380400001)(8676002)(4326008)(7696005)(2906002)(8936002)(5660300002)(6636002)(316002)(26005)(1076003)(7416002)(110136005)(356005)(82310400003)(86362001)(47076005)(336012)(7636003)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 12:26:24.3860
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb2bc597-f562-45b8-92ff-08d98a56d803
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4944
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

This patch adds the ability to get the name, index and status of all
counters for each link through RDMA netlink. This can be used for
user-space to get the current optional-counter mode.

Examples:
$ rdma statistic mode
link rocep8s0f0/1 optional-counters cc_rx_ce_pkts

$ rdma statistic mode supported
link rocep8s0f0/1 supported optional-counters cc_rx_ce_pkts,cc_rx_cnp_pkts,cc_tx_cnp_pkts
link rocep8s0f1/1 supported optional-counters cc_rx_ce_pkts,cc_rx_cnp_pkts,cc_tx_cnp_pkts

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 drivers/infiniband/core/nldev.c  | 98 ++++++++++++++++++++++++++++++++
 include/uapi/rdma/rdma_netlink.h |  5 ++
 2 files changed, 103 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 67519730b1ac..210057fef7bd 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -154,6 +154,8 @@ static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_NET_NS_FD]			= { .type = NLA_U32 },
 	[RDMA_NLDEV_SYS_ATTR_NETNS_MODE]	= { .type = NLA_U8 },
 	[RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK]	= { .type = NLA_U8 },
+	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_INDEX]	= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC] = { .type = NLA_U8 },
 };
 
 static int put_driver_name_print_type(struct sk_buff *msg, const char *name,
@@ -2264,6 +2266,99 @@ static int nldev_stat_get_dumpit(struct sk_buff *skb,
 	return ret;
 }
 
+static int nldev_stat_get_counter_status_doit(struct sk_buff *skb,
+					      struct nlmsghdr *nlh,
+					      struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX], *table, *entry;
+	struct rdma_hw_stats *stats;
+	struct ib_device *device;
+	struct sk_buff *msg;
+	u32 devid, port;
+	int ret, i;
+
+	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+			  nldev_policy, extack);
+	if (ret || !tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
+	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
+		return -EINVAL;
+
+	devid = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	device = ib_device_get_by_index(sock_net(skb->sk), devid);
+	if (!device)
+		return -EINVAL;
+
+	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
+	if (!rdma_is_port_valid(device, port)) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	stats = ib_get_hw_stats_port(device, port);
+	if (!stats) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	nlh = nlmsg_put(
+		msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
+		RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_STAT_GET_STATUS),
+		0, 0);
+
+	ret = -EMSGSIZE;
+	if (fill_nldev_handle(msg, device) ||
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port))
+		goto err_msg;
+
+	table = nla_nest_start(msg, RDMA_NLDEV_ATTR_STAT_HWCOUNTERS);
+	if (!table)
+		goto err_msg;
+
+	mutex_lock(&stats->lock);
+	for (i = 0; i < stats->num_counters; i++) {
+		entry = nla_nest_start(msg,
+				       RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY);
+		if (!entry)
+			goto err_msg_table;
+
+		if (nla_put_string(msg,
+				   RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME,
+				   stats->descs[i].name) ||
+		    nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_HWCOUNTER_INDEX, i))
+			goto err_msg_entry;
+
+		if ((stats->descs[i].flags & IB_STAT_FLAG_OPTIONAL) &&
+		    (nla_put_u8(msg, RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC,
+				!test_bit(i, stats->is_disabled))))
+			goto err_msg_entry;
+
+		nla_nest_end(msg, entry);
+	}
+	mutex_unlock(&stats->lock);
+
+	nla_nest_end(msg, table);
+	nlmsg_end(msg, nlh);
+	ib_device_put(device);
+	return rdma_nl_unicast(sock_net(skb->sk), msg, NETLINK_CB(skb).portid);
+
+err_msg_entry:
+	nla_nest_cancel(msg, entry);
+err_msg_table:
+	mutex_unlock(&stats->lock);
+	nla_nest_cancel(msg, table);
+err_msg:
+	nlmsg_free(msg);
+err:
+	ib_device_put(device);
+	return ret;
+}
+
 static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
 	[RDMA_NLDEV_CMD_GET] = {
 		.doit = nldev_get_doit,
@@ -2353,6 +2448,9 @@ static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
 		.dump = nldev_res_get_mr_raw_dumpit,
 		.flags = RDMA_NL_ADMIN_PERM,
 	},
+	[RDMA_NLDEV_CMD_STAT_GET_STATUS] = {
+		.doit = nldev_stat_get_counter_status_doit,
+	},
 };
 
 void __init nldev_init(void)
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 75a1ae2311d8..e50c357367db 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -297,6 +297,8 @@ enum rdma_nldev_command {
 
 	RDMA_NLDEV_CMD_RES_SRQ_GET, /* can dump */
 
+	RDMA_NLDEV_CMD_STAT_GET_STATUS,
+
 	RDMA_NLDEV_NUM_OPS
 };
 
@@ -549,6 +551,9 @@ enum rdma_nldev_attr {
 
 	RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK,	/* u8 */
 
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_INDEX,	/* u32 */
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC, /* u8 */
+
 	/*
 	 * Always the end
 	 */
-- 
2.26.2

