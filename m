Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E04042D434
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 09:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhJNH44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 03:56:56 -0400
Received: from mail-mw2nam10on2072.outbound.protection.outlook.com ([40.107.94.72]:9825
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230010AbhJNH4x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 03:56:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XBVaLLZD1HJTR1KruKB86a2xyOgXMujMSmhI9zazxJqxOLToszHOK93cAoK+MR0E6cT5Ue6w/D50/ib2q0d2mrGzdAKBbi/YBIduhvf9s+aeQeAWkAvlrqonqHQUmtOAuDGfMbMFSjjRdTe237a48DF4IaKnysSiuHRoer7yZg9QuZ6jCGtwotphOlidagbrmCT0owafByuxsQCiMGWV5+mccyb6LfKoTw2977G6TuYImcMZGMBZYN6yOAZ1Y9LylhC8EMmXb/QlVyM3eTrn56oWafhGTQ18jmM2WjqYP1GIPfUTH4/pplBcHNiVqEnGik16OzSRDWkFmKjpTs6Dhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nvzR34DTpSlDedTQKv89Q2n9S2M3uBt7kCejDzDAtAw=;
 b=RrtgcLD4vRsydM+/1v8SjltZs/0uf+jZVt9ag+1vS1T3xMB2qf2hcmSbkGPxfU6t8SIWsZyZ5EKVA6XDZsn8egLyLKWHDhuqh20OFIpuoZ6kdKUqS14XygxqrwBDeuNb5czfRnPunb6+0WhwoAEz2/TxnUq4erjOPJaMqA8HrqJrAmIWgRuQpIojR4UAZLiSRpnTmu/QWSTaMoY01e6s/jWyg66lGJpJV95aa+wsTs1YpiDMwMd/y184zV9G9I4panul1CbHu0aLwLv6gEu9BCD8r/AVTpzYnDayrMxnnh5F1q3X00qvT831crpPzBJrybFyys1ycnyB9RlAmM9omA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvzR34DTpSlDedTQKv89Q2n9S2M3uBt7kCejDzDAtAw=;
 b=s/M9zEZrh+0gGFTV4j3AEKnfxaAvEgQwIkSt0gl2mV6zUSv4GdrOkIWOCgbLW2dzc0gtjbCcDuSR/JUyOxGFmKF004wj3k9lX734x/C6+PHRVNn3jt0R1Z24+e/TKyuyVDzopaGYgkC199RfB3PhJBwyAz4e4iFFO75SWu+jGCObeWa5RMotY6OtgfZ6il6BJkzKj226nXtmBudWBvpctbykyOwDytvPDQB6046RlflXWXIXSHET0bsd6zM8kFFZL7sO9hkB+cQOxChRtlSCG5vMrj+ET7RuTLhXIZER6EimY3OQdYoFC2f4iSknELDIY0W5cmQ4RFsx3r3mLes3pg==
Received: from DM6PR07CA0099.namprd07.prod.outlook.com (2603:10b6:5:337::32)
 by BL0PR12MB4660.namprd12.prod.outlook.com (2603:10b6:207:34::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Thu, 14 Oct
 2021 07:54:48 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::9f) by DM6PR07CA0099.outlook.office365.com
 (2603:10b6:5:337::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend
 Transport; Thu, 14 Oct 2021 07:54:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 07:54:47 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 14 Oct
 2021 07:54:46 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 14 Oct 2021 00:54:44 -0700
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <dsahern@gmail.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH iproute2-next v1 3/3] rdma: Add optional-counters set/unset support
Date:   Thu, 14 Oct 2021 10:53:58 +0300
Message-ID: <20211014075358.239708-4-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20211014075358.239708-1-markzhang@nvidia.com>
References: <20211014075358.239708-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ef44f52-95bb-4605-a011-08d98ee7e4d0
X-MS-TrafficTypeDiagnostic: BL0PR12MB4660:
X-Microsoft-Antispam-PRVS: <BL0PR12MB4660806C5D3B0C4AA574FE8BC7B89@BL0PR12MB4660.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xSSdaiURP/KElI9Vcp+aPHFcxeuV6UPRrjfrKHwTT5DBgFb2u2AIobpmAfUQr5txPg4ZWdaI7+wx/Npcnq7nBCNAUqQQrNQeVTIVk0PG39h8iMOTz1Mn+sfWS0u3FJ9UgZivTCCi11elbsCMufVWqQdo97c4uFirtL8ed1E+e63ITUBGlh2Du5ifOGwqgTuysNAzHa7qDlc1avME0aV69fCq1WpJveE/SD8aFVqUi3gUE0OjQ2BtThJMy5qGppj8wkgtAq2uU0ksyOLh5cInHGR4PeJHEdZlZCCfdJx+AApv66+HBrjV8O++PwXavuS4PK9oxd6J6CmwlcwiA7FIeqi7r9AiENzZSNpeqx56/5oJXw7GzHnSyHlis1NIqPN5zrpJSgd2bk/yTcUXPZoH1cYXoWZoHKaxcFq827pAAkazV+ZTFBe7IuJm1lArjvbfwnQGAWC4wxh3HBnbCH+XhnfbSxus/ih2ntVXLUcQhRToAy286GBRvNPm7o8Lz4OFKMksv1A8J60axUPDsQMTpny2sSpQqGWogQ33Ve+BlyX+lH2kKhLjLqd9RSKDBd/o20yajApwEQm0K2cVvQkkBC/WIVc67g19ZoQ8nBGuDIpjNdtdH6XekietiGfOGkt3JfaIJBR0X2WYgmgH1ZggaCzspxAPONaZ/53L5ILd1tCdCqw7egBPiCqcfAHXd7RRUtSWRj09UUN1eQEL5pNjFAGmyjdZjr5l8HcJFBwdnjk=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8936002)(70586007)(7696005)(47076005)(86362001)(336012)(83380400001)(8676002)(2616005)(70206006)(82310400003)(110136005)(54906003)(356005)(316002)(508600001)(1076003)(426003)(4326008)(186003)(2906002)(6666004)(7636003)(26005)(36860700001)(36756003)(107886003)(5660300002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 07:54:47.5873
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ef44f52-95bb-4605-a011-08d98ee7e4d0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4660
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neta Ostrovsky <netao@nvidia.com>

This patch provides an extension to the rdma statistics tool
that allows to set/unset optional counters set dynamically,
using new netlink commands.
Note that the optional counter statistic implementation is
driver-specific and may impact the performance.

Examples:
To enable a set of optional counters on link rocep8s0f0/1:
    $ sudo rdma statistic set link rocep8s0f0/1 optional-counters cc_rx_ce_pkts,cc_rx_cnp_pkts
To disable all optional counters on link rocep8s0f0/1:
    $ sudo rdma statistic unset link rocep8s0f0/1 optional-counters

Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 man/man8/rdma-statistic.8 |  32 +++++++
 rdma/stat.c               | 178 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 210 insertions(+)

diff --git a/man/man8/rdma-statistic.8 b/man/man8/rdma-statistic.8
index 885769bc..7dd2b02c 100644
--- a/man/man8/rdma-statistic.8
+++ b/man/man8/rdma-statistic.8
@@ -65,6 +65,21 @@ rdma-statistic \- RDMA statistic counter configuration
 .B link
 .RI "[ " DEV/PORT_INDEX " ]"
 
+.ti -8
+.B rdma statistic
+.B set
+.B link
+.RI "[ " DEV/PORT_INDEX " ]"
+.B optional-counters
+.RI "[ " OPTIONAL-COUNTERS " ]"
+
+.ti -8
+.B rdma statistic
+.B unset
+.B link
+.RI "[ " DEV/PORT_INDEX " ]"
+.B optional-counters
+
 .ti -8
 .IR COUNTER_SCOPE " := "
 .RB "{ " link " | " dev " }"
@@ -111,6 +126,13 @@ If this argument is omitted then a new counter will be allocated.
 
 .SS rdma statistic mode supported - Display the supported optional counters for each link.
 
+.SS rdma statistic set - Enable a set of optional counters for a specific device/port.
+
+.I "OPTIONAL-COUNTERS"
+- specifies the name of the optional counters to enable. Optional counters that are not specified will be disabled. Note that optional counters are driver-specific.
+
+.SS rdma statistic unset - Disable all optional counters for a specific device/port.
+
 .SH "EXAMPLES"
 .PP
 rdma statistic show
@@ -207,6 +229,16 @@ rdma statistic mode supported link mlx5_2/1
 .RS 4
 Display the optional counters that mlx5_2/1 supports.
 .RE
+.PP
+rdma statistic set link mlx5_2/1 optional-counters cc_rx_ce_pkts,cc_rx_cnp_pkts
+.RS 4
+Enable the cc_rx_ce_pkts,cc_rx_cnp_pkts counters on device mlx5_2 port 1.
+.RE
+.PP
+rdma statistic unset link mlx5_2/1 optional-counters
+.RS 4
+Disable all the optional counters on device mlx5_2 port 1.
+.RE
 
 .SH SEE ALSO
 .BR rdma (8),
diff --git a/rdma/stat.c b/rdma/stat.c
index 7d645d8f..adfcd34a 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -22,6 +22,8 @@ static int stat_help(struct rd *rd)
 	pr_out("       %s statistic show link [ DEV/PORT_INDEX ]\n", rd->filename);
 	pr_out("       %s statistic mode [ supported ]\n", rd->filename);
 	pr_out("       %s statistic mode [ supported ] link [ DEV/PORT_INDEX ]\n", rd->filename);
+	pr_out("       %s statistic set link [ DEV/PORT_INDEX ] optional-counters [ OPTIONAL-COUNTERS ]\n", rd->filename);
+	pr_out("       %s statistic unset link [ DEV/PORT_INDEX ] optional-counters\n", rd->filename);
 	pr_out("where  OBJECT: = { qp }\n");
 	pr_out("       CRITERIA : = { type }\n");
 	pr_out("       COUNTER_SCOPE: = { link | dev }\n");
@@ -43,6 +45,8 @@ static int stat_help(struct rd *rd)
 	pr_out("       %s statistic mode link mlx5_2/1\n", rd->filename);
 	pr_out("       %s statistic mode supported\n", rd->filename);
 	pr_out("       %s statistic mode supported link mlx5_2/1\n", rd->filename);
+	pr_out("       %s statistic set link mlx5_2/1 optional-counters cc_rx_ce_pkts,cc_rx_cnp_pkts\n", rd->filename);
+	pr_out("       %s statistic unset link mlx5_2/1 optional-counters\n", rd->filename);
 
 	return 0;
 }
@@ -499,6 +503,30 @@ static int stat_qp_set(struct rd *rd)
 	return rd_exec_cmd(rd, cmds, "parameter");
 }
 
+static int stat_get_arg_str(struct rd *rd, const char *arg, char **value, bool allow_empty)
+{
+	int len = 0;
+
+	if (strcmpx(rd_argv(rd), arg) != 0) {
+		pr_err("Unknown parameter '%s'.\n", rd_argv(rd));
+		return -EINVAL;
+	}
+
+	rd_arg_inc(rd);
+	if (!rd_no_arg(rd)) {
+		*value = strdup(rd_argv(rd));
+		len = strlen(*value);
+		rd_arg_inc(rd);
+	}
+
+	if ((allow_empty && len) || (!allow_empty && !len)) {
+		stat_help(rd);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int stat_get_arg(struct rd *rd, const char *arg)
 {
 	int value = 0;
@@ -877,6 +905,154 @@ static int stat_mode(struct rd *rd)
 	return rd_exec_cmd(rd, cmds, "parameter");
 }
 
+static int stat_one_set_link_opcounters(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct nlattr *nla_entry, *tb_set;
+	int ret, flags = NLM_F_REQUEST | NLM_F_ACK;
+	char *opcnt, *opcnts;
+	struct rd *rd = data;
+	uint32_t seq;
+	bool found;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS])
+		return MNL_CB_ERROR;
+
+	if (rd_no_arg(rd)) {
+		stat_help(rd);
+		return -EINVAL;
+	}
+
+	ret = stat_get_arg_str(rd, "optional-counters", &opcnts, false);
+	if (ret)
+		return ret;
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_STAT_SET, &seq, flags);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX,
+			 rd->dev_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_PORT_INDEX,
+			 rd->port_idx);
+
+	tb_set = mnl_attr_nest_start(rd->nlh, RDMA_NLDEV_ATTR_STAT_HWCOUNTERS);
+
+	opcnt = strtok(opcnts, ",");
+	while (opcnt) {
+		found = false;
+		mnl_attr_for_each_nested(nla_entry,
+					 tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS]) {
+			struct nlattr *cnt[RDMA_NLDEV_ATTR_MAX] = {}, *nm, *id;
+
+			if (mnl_attr_parse_nested(nla_entry, rd_attr_cb,
+						  cnt) != MNL_CB_OK)
+				return -EINVAL;
+
+			nm = cnt[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME];
+			id = cnt[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_INDEX];
+			if (!nm || ! id)
+				return -EINVAL;
+
+			if (!cnt[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC])
+				continue;
+
+			if (strcmp(opcnt, mnl_attr_get_str(nm)) == 0) {
+				mnl_attr_put_u32(rd->nlh,
+						 RDMA_NLDEV_ATTR_STAT_HWCOUNTER_INDEX,
+						 mnl_attr_get_u32(id));
+				found = true;
+			}
+		}
+
+		if (!found)
+			return -EINVAL;
+
+		opcnt = strtok(NULL, ",");
+	}
+	mnl_attr_nest_end(rd->nlh, tb_set);
+
+	return rd_sendrecv_msg(rd, seq);
+}
+
+static int stat_one_set_link(struct rd *rd)
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
+	return rd_recv_msg(rd, stat_one_set_link_opcounters, rd, seq);
+}
+
+static int stat_set_link(struct rd *rd)
+{
+	return rd_exec_link(rd, stat_one_set_link, true);
+}
+
+static int stat_set(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		stat_help },
+		{ "link",	stat_set_link },
+		{ "help",	stat_help },
+		{ 0 },
+	};
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
+static int stat_one_unset_link_opcounters(struct rd *rd)
+{
+	int ret, flags = NLM_F_REQUEST | NLM_F_ACK;
+	struct nlattr *tbl;
+	uint32_t seq;
+	char *opcnts;
+
+	if (rd_no_arg(rd)) {
+		stat_help(rd);
+		return -EINVAL;
+	}
+
+	ret = stat_get_arg_str(rd, "optional-counters", &opcnts, true);
+	if (ret)
+		return ret;
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_STAT_SET, &seq, flags);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX,
+			 rd->dev_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_PORT_INDEX,
+			 rd->port_idx);
+
+	tbl = mnl_attr_nest_start(rd->nlh, RDMA_NLDEV_ATTR_STAT_HWCOUNTERS);
+	mnl_attr_nest_end(rd->nlh, tbl);
+
+	return rd_sendrecv_msg(rd, seq);
+}
+
+static int stat_one_unset_link(struct rd *rd)
+{
+	return stat_one_unset_link_opcounters(rd);
+}
+
+static int stat_unset_link(struct rd *rd)
+{
+	return rd_exec_link(rd, stat_one_unset_link, true);
+}
+
+static int stat_unset(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		stat_help },
+		{ "link",	stat_unset_link },
+		{ "help",	stat_help },
+		{ 0 },
+	};
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
 static int stat_show_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
@@ -949,6 +1125,8 @@ int cmd_stat(struct rd *rd)
 		{ "qp",		stat_qp },
 		{ "mr",		stat_mr },
 		{ "mode",	stat_mode },
+		{ "set",	stat_set },
+		{ "unset",	stat_unset },
 		{ 0 }
 	};
 
-- 
2.26.2

