Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5376E41452B
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 11:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbhIVJdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 05:33:03 -0400
Received: from mail-mw2nam10on2073.outbound.protection.outlook.com ([40.107.94.73]:2048
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234405AbhIVJcq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 05:32:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YW40VzUFq+N25RxI/xmc/OK8SwsA5a8GomZlpTSVzm9hBotUFuF2zZFMzhdEg6GCBs4YLcbZ9Va5pPt71VNEhkSIFyvb3eBqRxHdYvnuLckhcxECX6qFjN0om0z7+cf26NhduRZH7LmGbbtXxq2NyBSictB3tg4o9ypSu6jsrHVcr72mOIc5MxMJfNbZSvD14UXJTKeD0VAe5K0DYazNjDUgd7rpvELAR7sPDwnC6N4gtz5jOAa+VXj9SkXooV/Pfx3P5cHTRk/ytDBEbtGSrDqZMCF9S2kO73AO+PVEo37EvkwbPR62PM4QcPUlyTd892/roFvW5HUHQU9K9NOggw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ak015dCLhFT9HUZ+614RoSyGTvLmgkWSQVqt3U7rULo=;
 b=PNHr2/lyCNxSV/whyeSfy/BcCy7K60db6uYcFixv75HvE94wtM/JarAtsIvhUqgrvIllaI64BujYqEs1u43Co3pJ5cCuIBrIRsVjFcAM8WmzUCrVNDFKCIHDD+uY+I7w9XTUFrIKOe03Z8JI9EF4k1zl2fjtRqQAifzPirJY9PZbpExJNN6xJUrwqcj5E+5vGsL3WTKpDx2dwRd1LZ5GruWLd2AzDxQ25PTLhFFkePvqaPZsumHpJHZlK80bX7YfAXF39OXXkk+8vOmz/9V7FZwzLyUYlOrWElFu3Q5vIyJo8SNRnILClTqbs9dMY8cXF5k2K/0fy3uMh4UsmmoCHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ak015dCLhFT9HUZ+614RoSyGTvLmgkWSQVqt3U7rULo=;
 b=a5S/KE+/nULbVChPOexd8qeyTXdXpelUsprkc+lZDuf2tpAHk9RtK/YkkCiMN/sMhTtsdzAzcVYWPUYqJ9TDSYlHKFYGmCkYxJ8hqJZwUBEw563X/v1MaBpp69TBSMSl0RSyvlRb2CAU+g9vreg2AlklkERj2D/8pr97RfZ9gT4//3PBLIs8lQV6zGAY5uJKo8sskUhupAOJlG9dyIxm6VViAYsWV10emzFRZzpysuOCtU6pu/LXCaq8xsI6MkSNmKQYr6Y6UdO+rgwJpzxEraVJay7a/vfiZhKAudT6TlhtO6NviZTFhMkoCEJMV+dA1VSAz2QF5QEf/CVE1HSdrg==
Received: from BN6PR13CA0065.namprd13.prod.outlook.com (2603:10b6:404:11::27)
 by SN1PR12MB2414.namprd12.prod.outlook.com (2603:10b6:802:2e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Wed, 22 Sep
 2021 09:31:15 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:11:cafe::c5) by BN6PR13CA0065.outlook.office365.com
 (2603:10b6:404:11::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.7 via Frontend
 Transport; Wed, 22 Sep 2021 09:31:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 09:31:14 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 22 Sep
 2021 09:31:14 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 22 Sep 2021 09:31:10 +0000
From:   Mark Zhang <markzhang@nvidia.com>
To:     <dsahern@gmail.com>, <jgg@nvidia.com>, <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH RESEND iproute2-next 2/3] rdma: Add stat "mode" support
Date:   Wed, 22 Sep 2021 12:30:37 +0300
Message-ID: <20210922093038.141905-3-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20210922093038.141905-1-markzhang@nvidia.com>
References: <20210922093038.141905-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a27c589-6581-406c-a638-08d97dabb92b
X-MS-TrafficTypeDiagnostic: SN1PR12MB2414:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2414845464FE361BB73A9B1EC7A29@SN1PR12MB2414.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:94;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GBUNI97uI67I0j5+BHlJ9wkBUuJcBYBp2xle5S5jd3KhoMY4ZmBTTGWg3TkK8L7gBtFjpWF2HuBRXNPzePcrkGRoSW36W0A7VKCxCkdanAHqKPopvc03a76mRFhTV5Z2lXWqcAvWzTJHfj2CN1e4qWCcfVdx5ck4YkL3y89INgmx7wWFz4z9EUniCQq3esx19OwHQh1qyDf1yJjDwPLP8GiYIRN472TtqUDwemF7KL+ztcFDs0RWsnOfXIK9PRBxLVD96/5o6iecXcSQN35v4ICqj0Ml5qHmUhcxr1nYb7QsuIuJLv6ssXz1xMo+N7bkT0cMo6qB6pM2/3oK70WXXJdyYHC1Jpm9PezX869ZWm7QHde1TqyUgsCQ+rAzWN/0LCpZATkcjp/bO0/e+JsxpY0FTu23G8T060yORvQSxmYP3xC6RSPsqiDGBBeWrEGOHRp4jMQB1adHpHPA639lP5kGUwMPrFaXd9q/5FytxTR7Ghot9MD1VbRiG2/5KnyQUBcJSshGh6E2Dl5tXt75uZiRjmU/cf4oSG/BMdwwC9P5QIu9XNC5z7G0OD3coxnQP2XDSfw7IM2eQUBRGpby9XU8B2rBf6YZ5cMDS3Gvq6VF7qwpQJD9lFTJaTqAX1jcr2XG5hklXExm3KJx/1F2vgTdcSsSAw6J9bmAxM90WKbN/EIGaoYTpTmdrWRVMMxN13G7aZtZQqntze1xPNn+gQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(356005)(7696005)(110136005)(508600001)(54906003)(2616005)(336012)(1076003)(83380400001)(26005)(8676002)(36860700001)(7636003)(70206006)(70586007)(107886003)(6666004)(316002)(5660300002)(36756003)(426003)(36906005)(8936002)(2906002)(86362001)(47076005)(82310400003)(186003)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 09:31:14.7441
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a27c589-6581-406c-a638-08d97dabb92b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2414
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
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 man/man8/rdma-statistic.8 |  23 ++++++
 rdma/stat.c               | 164 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 187 insertions(+)

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
index 8edf7bf1..157b23bf 100644
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
@@ -715,6 +721,163 @@ static int stat_qp(struct rd *rd)
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
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_STAT_GET, seq,  flags);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_PORT_INDEX, rd->port_idx);
+	mnl_attr_put_u8(rd->nlh, RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC, 1);
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
@@ -786,6 +949,7 @@ int cmd_stat(struct rd *rd)
 		{ "help",	stat_help },
 		{ "qp",		stat_qp },
 		{ "mr",		stat_mr },
+		{ "mode",	stat_mode },
 		{ 0 }
 	};
 
-- 
2.26.2

