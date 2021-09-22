Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF21C41452D
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 11:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234323AbhIVJdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 05:33:04 -0400
Received: from mail-bn8nam11on2081.outbound.protection.outlook.com ([40.107.236.81]:37345
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234294AbhIVJct (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 05:32:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X2cuRhaxoVAVyfXvgcBLzMG92VT0usVlNJd6KnNpTQs5XEW7r8spxCF/VWLBrcLGsnScLPAFX1fSk2b0cEJ23KGuhvM3JpOQ+Cf33/tFUBCGDiSfdCoVDQnFTjFgsFLkKlld1KKpZQa52/R5o9gr6L2dtrHduXngcLtOa5eaejRKKb5VCnqJsjzQVEuulw+JA0Ao4xR8KzYLaD+MCXWm5vsZSgO/AcQZA7nEn+l6zxTC0GTwi1HljWfOZoLnFjNFDZ1XLljPCdCcqWdB8Cv2qtXyoBxkJUa0uysMdvtCKnVI+K+n/8PaR+LSf6alPi6s7pfmPLINujwA4ohqnE3ajA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=VC6Xu5n0iWfU8LdbDGv4y1XSKT2SPG4vutWU7vKEXbg=;
 b=SmW0ndd9WrAJfYPNE1HviGMBx5plqdJaxIctidzRN1SOK58/i+s/WMH7VlUsD3RWL0Nwhqk++brPgEgckKCwf4y5zQX1Sist2clPwx8iR8JLxosjVrygiK+f+VVK8VwtnpNPGCZl7P5OXB6bvUOCOecRuRp64bTMHOc02ZAf/UgDupBly+HQXe536ZZ1xxLoR1nuIl6LlofElRfdBdCk9K8sXMtb4/YzbrumlFr7fjIzpaLeWIE5umaqRRBIdeEXNsayNCah7SPcH8ViZ4bYKeL0+pdX8+lXbnZcISVw1VRdpHDSsGFqR2y1JZPbuamF5y+sfHadjXzQv2i6W4bAdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VC6Xu5n0iWfU8LdbDGv4y1XSKT2SPG4vutWU7vKEXbg=;
 b=N0iFrazyAv7G98mxhG55SExxdjcottDc3iGSSLsbspiuMQASIia0aJW4Y0h3hXujtP4Yykz0ACrIn4dFwgyFUK0gLSbHlKZcaN5qS9RhdYCLurdo1Oj+C7Xok7B9u7DNeLs6HtCWyLjT8Ypb8+uoRHsy9R67gdxtA5daL6g9lED1HMmNJC+b7vjlz1AQppxu4/Gti8OFaHKP5q79sAd4RK3/CHp6gkojVZBi4JJvocUhb089sgdraWCeckm15LmojyTiy2wRxUDRRgDb1eBrsUhd02E2avVABS3xw/enZXhx45rfRNRscVFr9yMJVh3JT3amICTJQsMxqxQb+N1Tkw==
Received: from DM6PR01CA0010.prod.exchangelabs.com (2603:10b6:5:296::15) by
 MN2PR12MB3872.namprd12.prod.outlook.com (2603:10b6:208:168::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 09:31:18 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::58) by DM6PR01CA0010.outlook.office365.com
 (2603:10b6:5:296::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend
 Transport; Wed, 22 Sep 2021 09:31:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 09:31:18 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 22 Sep
 2021 02:31:17 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 22 Sep
 2021 09:31:17 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 22 Sep 2021 09:31:14 +0000
From:   Mark Zhang <markzhang@nvidia.com>
To:     <dsahern@gmail.com>, <jgg@nvidia.com>, <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH RESEND iproute2-next 3/3] rdma: Add optional-counters set/unset support
Date:   Wed, 22 Sep 2021 12:30:38 +0300
Message-ID: <20210922093038.141905-4-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20210922093038.141905-1-markzhang@nvidia.com>
References: <20210922093038.141905-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ac971c6-2ab4-459e-701b-08d97dabbb5a
X-MS-TrafficTypeDiagnostic: MN2PR12MB3872:
X-Microsoft-Antispam-PRVS: <MN2PR12MB38724B2CF8A955CB82D2E5D4C7A29@MN2PR12MB3872.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LzvaPiPbvTm0nj/Y4sarCwNz4NbwpRlUiBtDveVl8kiw/1qyfolfe6g6nBQyj6ehCoFSaucsaKRxOhrA/iLbe+1dbzpOnyQtymL6PcMTUaz/JY3w2jOxSNpto4qnQt9LuedNHmzZrbRwnBEZa5iKJj1/bCIIprKxAXi0ETjMoFhZ11b+nQSkhwJbyZwzjT1xu7rNWYVphGr0XH13dDCV3/uLzzZE1PguCS8veiffWNMgAMVSNNVnpLaEmIbyHwKQtROzghfTWb1GHG5X9EjI66PFZgKJ4tK7JyDyEJ6V6tGUmUL2ZMqMP1O/eLUItajte3zcygj3dIBUpjR52uJyhQMnzwMnmxmYOleJ5jwd0+U7dfPhRhQbv0c8B/r8d3OZsLt9x9YaZ7c8VZJjNglGeJgx8JfvuK6QRpY8S6iJ0i9MLd+24/ZD/93WqvTBLS5KAVjMFI0fE5rk0BmSanURuPWlHv3XSbWHX7ZzL8HZWp2cfi2Il444rLGYq9fnyvoM9r4u9gHGJb/9LkH7yKBDNJ2yHvcAgxqBG91sju44s5TaWEqtOGKEchmSTd2FUBmOZpsZLz4ICxw71ZTle6i8qGfo0VSpIc6mzi+Mdpnqiuwj+wsJwg0rswV+ft3ltIH+Uj3/OstJpruQxFRoRwiJfG03rUor3f6JdMFj0F7UNVUHClhdeIRoob7yQ76ydWKcbyM2IZmdQgL9ruNzoqjX+A==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(186003)(8676002)(26005)(336012)(2616005)(8936002)(426003)(5660300002)(47076005)(7696005)(86362001)(36860700001)(1076003)(316002)(82310400003)(110136005)(83380400001)(54906003)(7636003)(36756003)(70586007)(4326008)(2906002)(70206006)(107886003)(508600001)(6666004)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 09:31:18.3622
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ac971c6-2ab4-459e-701b-08d97dabbb5a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3872
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
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 man/man8/rdma-statistic.8 |  32 ++++++++
 rdma/stat.c               | 163 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 195 insertions(+)

diff --git a/man/man8/rdma-statistic.8 b/man/man8/rdma-statistic.8
index 885769bc..198ce0bf 100644
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
+rdma statistic set link mlx5_2/1 optional-counters cc-rx-ce-pkts,cc_rx_cnp_pkts
+.RS 4
+Enable the cc-rx-ce-pkts,cc_rx_cnp_pkts counters on device mlx5_2 port 1.
+.RE
+.PP
+rdma statistic unset link mlx5_2/1 optional-counters
+.RS 4
+Disable all the optional counters on device mlx5_2 port 1.
+.RE
 
 .SH SEE ALSO
 .BR rdma (8),
diff --git a/rdma/stat.c b/rdma/stat.c
index 157b23bf..b5d1a59f 100644
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
+	pr_out("       %s statistic set link mlx5_2/1 optional-counters cc-rx-ce-pkts,cc_rx_cnp_pkts\n", rd->filename);
+	pr_out("       %s statistic unset link mlx5_2/1 optional-counters\n", rd->filename);
 
 	return 0;
 }
@@ -878,6 +882,163 @@ static int stat_mode(struct rd *rd)
 	return rd_exec_cmd(rd, cmds, "parameter");
 }
 
+static int stat_one_set_link_opcounters(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct nlattr *nla_entry, *tb_set;
+	int flags = NLM_F_REQUEST | NLM_F_ACK;
+	struct rd *rd = data;
+	uint32_t seq;
+	char *opcnt;
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
+	if (strcmpx(rd_argv(rd), "optional-counters") != 0) {
+		pr_err("Unknown parameter '%s'.\n", rd_argv(rd));
+		return -EINVAL;
+	}
+
+	rd_arg_inc(rd);
+	if (rd_no_arg(rd)) {
+		stat_help(rd);
+		return -EINVAL;
+	}
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_STAT_SET, &seq, flags);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX,
+			 rd->dev_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_PORT_INDEX,
+			 rd->port_idx);
+	mnl_attr_put_u8(rd->nlh, RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC, 1);
+
+	tb_set = mnl_attr_nest_start(rd->nlh, RDMA_NLDEV_ATTR_STAT_HWCOUNTERS);
+
+	opcnt = strtok(rd_argv(rd), ",");
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
+	int flags = NLM_F_REQUEST | NLM_F_ACK;
+	struct nlattr *tbl;
+	uint32_t seq;
+
+	if (rd_no_arg(rd)) {
+		stat_help(rd);
+		return -EINVAL;
+	}
+
+	if (strcmpx(rd_argv(rd), "optional-counters") != 0) {
+		pr_err("Unknown parameter '%s'.\n", rd_argv(rd));
+		return -EINVAL;
+	}
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_STAT_SET, &seq, flags);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX,
+			 rd->dev_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_PORT_INDEX,
+			 rd->port_idx);
+	mnl_attr_put_u8(rd->nlh, RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC, 1);
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
@@ -950,6 +1111,8 @@ int cmd_stat(struct rd *rd)
 		{ "qp",		stat_qp },
 		{ "mr",		stat_mr },
 		{ "mode",	stat_mode },
+		{ "set",	stat_set },
+		{ "unset",	stat_unset },
 		{ 0 }
 	};
 
-- 
2.26.2

