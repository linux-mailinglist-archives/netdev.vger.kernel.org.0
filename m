Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE9842D432
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 09:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhJNH4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 03:56:52 -0400
Received: from mail-dm6nam12on2067.outbound.protection.outlook.com ([40.107.243.67]:58335
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230010AbhJNH4v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 03:56:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cxgruQYVWjzwZQqKnyEQP6Tq8FI3Txi9aBZwB3Xqq3bPeKYD+iSx/ztoXFw9dv+A5tNj3YHvJGIGIK1joKLChx5iwskvZ/Fnnu4y22SWlDNpdZ81CHaJatC4pafDDd3ODzDh4zJCNZMeH+SehoQFbSIQ7mPHNa1cyUJMpg/Oix79Z76IwCHmBd1Q0ir5VBmV1eutaAisEV5jPmecAp1HCuepkkXFfLWLjcdVlzTuDGWRuZobHpOJtlkWphM6nsYZRFOQv9FjLnREfIUJUBfhiJd2yijrJC7cwS5jKYKyvBUTekx8Jqth1jrzYL0HyGJc9a6ZtPqhipjyETUf58F3zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uCma/3dfxAGsXuA2hOg4BZlo00a83VbvVxoGmR3vyPA=;
 b=kxiNOjgCUpXq7MJjMXlrEaPcxRvN/RNMMAOKINgZ7PxLBphSHzcX097oLRZ+/n6IBOp82JluYFfPrVhsbB+gV5Is7jzngixvTe1kxxZtJ+AtAnmMQhBsgweLJ5b9tAblZpk997Y7MsOkp9pA6rCXDbQAmL9IIlataCsWtD8k98l47vL0RotXgqgw2Vvl84i56l40Z/tOWznkpgCTSOa/eeMiwhVz4jy3q0plX0QOHddCLewuRNDevKsr3StrS4fvFYCqoAa5xUnEIYqQPjR+KAZw36iZtREuhGUCwiq1c6kZJKP6Mp3E7P41clg82ubh92o2DXDowDvAVbzCsWodXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uCma/3dfxAGsXuA2hOg4BZlo00a83VbvVxoGmR3vyPA=;
 b=VCWZmnqSihQk5V1S0YjbZKGQ2gKXqX6/h+AUu62MQoipePLoaUR57+peP/vyQw6vj9lm4Pl8NORT699l92iZve2vKIslRKJyRLThqDFvjem2GbKqIsk5HQd84h86WURoE8iHvVkXLoRLf/eSIdQ3acCVg1UEK9Z7/C7ChzoaE7U1VGl6POBWqC03Llr5OFAuJqvZuTEW0VK6wG6bwPAzKtzKennbe/Zbv20iSzj/pEbwp+9pA8L1ajshI9Sx0kXygplskPG3PzzVcnstauLrZ5hT8DLfrky4u7ocUSu1gY54qEuiwwuahCGRocJyEPb5a/uFHNg1OAnY7yD2Vo/o1Q==
Received: from DS7PR03CA0139.namprd03.prod.outlook.com (2603:10b6:5:3b4::24)
 by SA0PR12MB4528.namprd12.prod.outlook.com (2603:10b6:806:9e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Thu, 14 Oct
 2021 07:54:45 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::e0) by DS7PR03CA0139.outlook.office365.com
 (2603:10b6:5:3b4::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Thu, 14 Oct 2021 07:54:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 07:54:45 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 14 Oct
 2021 07:54:43 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 14 Oct 2021 00:54:41 -0700
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <dsahern@gmail.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH iproute2-next v1 2/3] rdma: Add stat "mode" support
Date:   Thu, 14 Oct 2021 10:53:57 +0300
Message-ID: <20211014075358.239708-3-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20211014075358.239708-1-markzhang@nvidia.com>
References: <20211014075358.239708-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f86ea7ec-4420-4e64-3b61-08d98ee7e36a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4528:
X-Microsoft-Antispam-PRVS: <SA0PR12MB45286925BE05BD0F6394020BC7B89@SA0PR12MB4528.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:94;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5hAZdj4eRLGHCgoqr4rdHGxqEgjqAL4WBB7+Mdwyf8DBnsGNopUD4u0pG2kozjMwzRJT8RqDnHe2+pOwFFGKK4HWGFT4jxC5mcS6bvVdWJV8TEnLeMQ2sx8BhdP27W/JuHH9vqqEvcKaMywHd/xztGhadzWVJKrono2Xj6TaHLOxyXn8Q1LQQHikj8m948xKem7zp/oU2uoRpKArowK9dhr3oa2eY+Kz9ohiEWlmq2DftKwyDsmvF7Bt3JixTGtpfjfGLRgswvhUDv4Hji2blLCIbGngVeYK7PWKxT8N2DuOlrkv6ZPABoCrniOzEtM39eXDgX9c64uebrEXtaArmDwQxxmytE3vwRJggOWUFpxIMts6IhjrcB9kVGR4a7b1Qi668Ye/GYfyGaM0ztt7FnDObBQm3hy9TNfwc47Z4c6FHKQVqRvllm9cI1xjl+T/07fn6DasSXbFZHbNN8RlkCbHhE2uJ4UoiPgZVtSmX7D2m/ZvVh9hKr2jVlFDxW4pQM0n9QwnESDGBuK0Qs0GpLBtGjPADoArAyjhvXTOI2vY5kgDe0euG4zwKQw06MjG/4AWF8u7VbW1/pQ+HqiLdQeVH6Opbt8bGVwkO0dO9HCYZztwUc++UKrb5Il5hYSTak39pO/PSLejeju6QHV/zvL09rRuEAFkZMTK4Ni2HU3l4WZtRHEUFjt4dlSDV3sl24kE3sHWjUMqYaozc3oaClZYEwyGQY7BYpHvxT0uT5Y=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36860700001)(186003)(36756003)(6666004)(70586007)(336012)(70206006)(107886003)(356005)(7636003)(4326008)(83380400001)(2906002)(7696005)(26005)(1076003)(54906003)(110136005)(5660300002)(8676002)(2616005)(426003)(8936002)(47076005)(316002)(82310400003)(86362001)(508600001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 07:54:45.2616
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f86ea7ec-4420-4e64-3b61-08d98ee7e36a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4528
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neta Ostrovsky <netao@nvidia.com>

This patch introduces the "mode" command, which presents the enabled or
supported (when the "supported" argument is available) optional
counters.

An optional counter is a vendor-specific counter that may be
dynamically enabled/disabled. This enhancement of hwcounters allows
exposing of counters which are for example mutual exclusive and cannot
be enabled at the same time, counters that might degrades performance,
optional debug counters, etc.

Examples:
To present currently enabled optional counters on link rocep8s0f0/1:
    $ rdma statistic mode link rocep8s0f0/1
    link rocep8s0f0/1 optional-counters cc_rx_ce_pkts

To present supported optional counters on link rocep8s0f0/1:
    $ rdma statistic mode supported link rocep8s0f0/1
    link rocep8s0f0/1 supported optional-counters cc_rx_ce_pkts,cc_rx_cnp_pkts,cc_tx_cnp_pkts

Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 man/man8/rdma-statistic.8 |  23 ++++++
 rdma/stat.c               | 163 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 186 insertions(+)

diff --git a/man/man8/rdma-statistic.8 b/man/man8/rdma-statistic.8
index 7160bcdf..885769bc 100644
--- a/man/man8/rdma-statistic.8
+++ b/man/man8/rdma-statistic.8
@@ -58,6 +58,13 @@ rdma-statistic \- RDMA statistic counter configuration
 .RI "[ " COUNTER-ID " ]"
 .RI "[ " OBJECT-ID " ]"
 
+.ti -8
+.B rdma statistic
+.B mode
+.B "[" supported "]"
+.B link
+.RI "[ " DEV/PORT_INDEX " ]"
+
 .ti -8
 .IR COUNTER_SCOPE " := "
 .RB "{ " link " | " dev " }"
@@ -100,6 +107,10 @@ When unbound the statistics of this object are no longer available in this count
 - specifies the id of the counter to be bound.
 If this argument is omitted then a new counter will be allocated.
 
+.SS rdma statistic mode - Display the enabled optional counters for each link.
+
+.SS rdma statistic mode supported - Display the supported optional counters for each link.
+
 .SH "EXAMPLES"
 .PP
 rdma statistic show
@@ -186,6 +197,16 @@ rdma statistic show mr mrn 6
 .RS 4
 Dump a specific MR statistics with mrn 6. Dumps nothing if does not exists.
 .RE
+.PP
+rdma statistic mode link mlx5_2/1
+.RS 4
+Display the optional counters that was enabled on mlx5_2/1.
+.RE
+.PP
+rdma statistic mode supported link mlx5_2/1
+.RS 4
+Display the optional counters that mlx5_2/1 supports.
+.RE
 
 .SH SEE ALSO
 .BR rdma (8),
@@ -198,3 +219,5 @@ Dump a specific MR statistics with mrn 6. Dumps nothing if does not exists.
 Mark Zhang <markz@mellanox.com>
 .br
 Erez Alfasi <ereza@mellanox.com>
+.br
+Neta Ostrovsky <netao@nvidia.com>
diff --git a/rdma/stat.c b/rdma/stat.c
index 8edf7bf1..7d645d8f 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -20,6 +20,8 @@ static int stat_help(struct rd *rd)
 	pr_out("       %s statistic OBJECT unbind COUNTER_SCOPE [DEV/PORT_INDEX] [COUNTER-ID]\n", rd->filename);
 	pr_out("       %s statistic show\n", rd->filename);
 	pr_out("       %s statistic show link [ DEV/PORT_INDEX ]\n", rd->filename);
+	pr_out("       %s statistic mode [ supported ]\n", rd->filename);
+	pr_out("       %s statistic mode [ supported ] link [ DEV/PORT_INDEX ]\n", rd->filename);
 	pr_out("where  OBJECT: = { qp }\n");
 	pr_out("       CRITERIA : = { type }\n");
 	pr_out("       COUNTER_SCOPE: = { link | dev }\n");
@@ -37,6 +39,10 @@ static int stat_help(struct rd *rd)
 	pr_out("       %s statistic qp unbind link mlx5_2/1 cntn 4 lqpn 178\n", rd->filename);
 	pr_out("       %s statistic show\n", rd->filename);
 	pr_out("       %s statistic show link mlx5_2/1\n", rd->filename);
+	pr_out("       %s statistic mode\n", rd->filename);
+	pr_out("       %s statistic mode link mlx5_2/1\n", rd->filename);
+	pr_out("       %s statistic mode supported\n", rd->filename);
+	pr_out("       %s statistic mode supported link mlx5_2/1\n", rd->filename);
 
 	return 0;
 }
@@ -715,6 +721,162 @@ static int stat_qp(struct rd *rd)
 	return rd_exec_cmd(rd, cmds, "parameter");
 }
 
+static int do_stat_mode_parse_cb(const struct nlmsghdr *nlh, void *data,
+				 bool supported)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct nlattr *nla_entry;
+	const char *dev, *name;
+	struct rd *rd = data;
+	int enabled, err = 0;
+	bool isfirst = true;
+	uint32_t port;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
+	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX] ||
+	    !tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS])
+		return MNL_CB_ERROR;
+
+	dev = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	port = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
+
+	mnl_attr_for_each_nested(nla_entry,
+				 tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS]) {
+		struct nlattr *cnt[RDMA_NLDEV_ATTR_MAX] = {};
+
+		err  = mnl_attr_parse_nested(nla_entry, rd_attr_cb, cnt);
+		if ((err != MNL_CB_OK) ||
+		    (!cnt[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME]))
+			return -EINVAL;
+
+		if (!cnt[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC])
+			continue;
+
+		enabled = mnl_attr_get_u8(cnt[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC]);
+		name = mnl_attr_get_str(cnt[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME]);
+		if (supported || enabled) {
+			if (isfirst) {
+				open_json_object(NULL);
+				print_color_string(PRINT_ANY, COLOR_NONE,
+						   "ifname", "link %s/", dev);
+				print_color_uint(PRINT_ANY, COLOR_NONE, "port",
+						 "%u ", port);
+				if (supported)
+					open_json_array(PRINT_ANY,
+						"supported optional-counters");
+				else
+					open_json_array(PRINT_ANY,
+							"optional-counters");
+				print_color_string(PRINT_FP, COLOR_NONE, NULL,
+						   " ", NULL);
+				isfirst = false;
+			} else {
+				print_color_string(PRINT_FP, COLOR_NONE, NULL,
+						   ",", NULL);
+			}
+			if (rd->pretty_output && !rd->json_output)
+				newline_indent(rd);
+
+			print_color_string(PRINT_ANY, COLOR_NONE, NULL, "%s",
+					   name);
+		}
+	}
+
+	if (!isfirst) {
+		close_json_array(PRINT_JSON, NULL);
+		newline(rd);
+	}
+
+	return 0;
+}
+
+static int stat_mode_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	return do_stat_mode_parse_cb(nlh, data, false);
+}
+
+static int stat_mode_parse_cb_supported(const struct nlmsghdr *nlh, void *data)
+{
+	return do_stat_mode_parse_cb(nlh, data, true);
+}
+
+static int stat_one_link_get_status_req(struct rd *rd, uint32_t *seq)
+{
+	int flags = NLM_F_REQUEST | NLM_F_ACK;
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_STAT_GET_STATUS, seq,  flags);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_PORT_INDEX, rd->port_idx);
+
+	return rd_send_msg(rd);
+}
+
+static int stat_one_link_get_mode(struct rd *rd)
+{
+	uint32_t seq;
+	int err;
+
+	if (!rd->port_idx)
+		return 0;
+
+	err = stat_one_link_get_status_req(rd, &seq);
+	if (err)
+		return err;
+
+	return rd_recv_msg(rd, stat_mode_parse_cb, rd, seq);
+}
+
+static int stat_one_link_get_mode_supported(struct rd *rd)
+{
+	uint32_t seq;
+	int err;
+
+	if (!rd->port_idx)
+		return 0;
+
+	err = stat_one_link_get_status_req(rd, &seq);
+	if (err)
+		return err;
+
+	return rd_recv_msg(rd, stat_mode_parse_cb_supported, rd, seq);
+}
+
+static int stat_link_get_mode(struct rd *rd)
+{
+	return rd_exec_link(rd, stat_one_link_get_mode, false);
+}
+
+static int stat_link_get_mode_supported(struct rd *rd)
+{
+	return rd_exec_link(rd, stat_one_link_get_mode_supported, false);
+}
+
+static int stat_mode_supported(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		stat_link_get_mode_supported },
+		{ "link",	stat_link_get_mode_supported },
+		{ "help",	stat_help },
+		{ 0 },
+	};
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
+static int stat_mode(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		stat_link_get_mode },
+		{ "link",	stat_link_get_mode },
+		{ "show",	stat_link_get_mode },
+		{ "supported",	stat_mode_supported },
+		{ "help",	stat_help },
+		{ 0 },
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
 static int stat_show_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
@@ -786,6 +948,7 @@ int cmd_stat(struct rd *rd)
 		{ "help",	stat_help },
 		{ "qp",		stat_qp },
 		{ "mr",		stat_mr },
+		{ "mode",	stat_mode },
 		{ 0 }
 	};
 
-- 
2.26.2

