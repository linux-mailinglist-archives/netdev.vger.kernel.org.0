Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1236151EBD8
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 06:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbiEHE5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 00:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbiEHE5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 00:57:35 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B070AE0BE
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 21:53:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a0eFW18rBnf1K66t6WcesuXYHhdHsuAaxCrM/Umj+2UxSrTv9pwhpfYJ+PIAU7Z6c0iwPMDe9nwHg0RAsbWv3TY2J7lUR2jcs1y8yZqbvJbdRwpNTxz5APoyclOVus8eS1XH1GgTMzeY5gMu5VNjB7refXgDHda5YjFLXU7rz8Xvl22iJq6JjKVG/lKWvFQtll/qIjqnhdAHHLhuarjn2R5aUC9KU3la90V9/9+U1alTIcUb+dBCYuzTxhUVgvKgbVMEr0264FHUvjENzqsY5s5smtJrHDLKXjRcpkThwtver6Tn0E7NuYGFTn7SHQyjhz0FSHUXjGzCZKnzUKJTPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Un6WOh0CpKavYrR99Ale9J//fUqpn/HMg+JOGWmz3m8=;
 b=D9uZA2WBI0e3hpnzzjFusAXv2kMxAbZoCLasY261iF8bhbSc9ngYlCsmHR4HjgS4qs5QBHlT5HbgnJraE6HbSoFeoTmL3celPd7D3kMsq6OSiN5rOceJlaGkFHJPQT4xN1v89IyaGWGUw8hb4zwKeVihxGguMdiIapzJqQA2PAHEq2lcz7TX+IueOPQXYdTL/wQaJ2QoHEO5RcgnA1UL7tgI9uvHU5KTE2YQgdlEXMWwpyIMT2WRyPtFVn8/8nt23DXClBOcFtbLbGhnDY8PYyPE/J7L6PDhW57MekNfd8dxvBT8ASFmQX/4o7LB2qHUNCZfjCR2gV4wL/WJA/QEEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Un6WOh0CpKavYrR99Ale9J//fUqpn/HMg+JOGWmz3m8=;
 b=S42fD3M22X8ZOwiWhHaNktC85W0SZv3X/08gwAHI8ofhNcUvNX4IDFoAF16lvklfg/4wTk2LrNgdTAguAylmgf5XFyrLWfqzWODFVMrCGFHII9+8/pr0X292czTJrnCgpnZFrKE3R0Qu+BJTYlt+kRHVzsuy+G4srBZ39BdhHjScfyuOlHr7uvqJlHWvH1QE6wkIGNKaskDN5SBKKdZu3JEtD9OmNNyZS9CyyzJqZO1vs/z8iCa97fIoqKqF9g7WGeAtkgIqhzGFSYgiwPxEl4egAbcBeT4S/ZpNgOmJXx3SP8zcHYHUzlIXCE5ph6DVdDxEwPGTTE4Sp/3AsvxFxg==
Received: from DS7PR03CA0345.namprd03.prod.outlook.com (2603:10b6:8:55::29) by
 DM5PR1201MB2473.namprd12.prod.outlook.com (2603:10b6:3:e2::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.24; Sun, 8 May 2022 04:53:43 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:55:cafe::df) by DS7PR03CA0345.outlook.office365.com
 (2603:10b6:8:55::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20 via Frontend
 Transport; Sun, 8 May 2022 04:53:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 04:53:42 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Sun, 8 May 2022 04:53:39 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Sat, 7 May 2022 21:53:38 -0700
Received: from localhost.localdomain (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Sat, 7 May 2022 21:53:38 -0700
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <razor@blackwall.org>
Subject: [PATCH iproute2 net-next v2 1/3] bridge: vxlan device vnifilter support
Date:   Sun, 8 May 2022 04:53:38 +0000
Message-ID: <20220508045340.120653-2-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508045340.120653-1-roopa@nvidia.com>
References: <20220508045340.120653-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9a83fc2-62e4-42d7-833a-08da30aeba10
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2473:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB2473B0445457B02499FE4A62CBC79@DM5PR1201MB2473.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JV4yxMPYjyrpJD+NgTehUW/VD1qagBDZeEzdNOlZlp+toCLg6YAbS7MRLP7iGBQsqLK5+uA1o74j1uxhF3lO57reOnDNe2T7PxLbgn2Hm4o9x+qa8/403P1ThJ+nMACtWpcYrIDh2WRMNiyrjsZqDUh8DZQVuT3GYlONhUZ/N49nxKEwJ9Hr4FBUoArodNfYKWd96SS2QbtbDKBd4hqaAtwtBwTdyEOxrSt4S9tzTnUfAZeOJzc4gL836qjMiWT7rIhqY6k25dRgCvGORg82DfHvgDu0ut+YCaFeoIBAuZ5QwMXiqmgb0fve/aRlOIANgx43RCL/Y48IH6SAbD0RznD+8zchJ7tFhrIzPvw+3LJcr6j4WRK8xaM6w9lE0p/zlhe4cNY1eNJaaoTjben1owuYHJ+YQNHHyTJOflaUKiRiXFDKMSEUEHqtflsXGNTNBoS/ZRrZC+YxuqQrHWdf+17dZDXEObwHrpyVGmB8X9j4qZfP/c0hgWYGCyUDGSRU/waP87jXXPfkriAxuxcDbWCIPodUZLMoY62+oTsumYjF45gPH9AkEG1yEfYjGlabMX/fy696h+HI0YrsaBm/kV8O+Qmgv/PFB7ZEeqXCzRh3q+4Li6Eg2yHKS+r53kpmjHo+x1pT82bzBZFZdVHIy9rqPKNxoNPNw4OB+zqD4xSfHEGVJ1QCsWifyT06fmHZWt9E2/M6EKDkx24vWQBs5g==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(47076005)(66574015)(1076003)(83380400001)(186003)(81166007)(426003)(336012)(356005)(82310400005)(316002)(36860700001)(86362001)(2906002)(5660300002)(70586007)(30864003)(6916009)(54906003)(70206006)(4326008)(8676002)(2616005)(8936002)(508600001)(40460700003)(26005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 04:53:42.8871
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9a83fc2-62e4-42d7-833a-08da30aeba10
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2473
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds bridge command to manage
recently added vnifilter on a collect metadata
vxlan device.

examples:
$bridge vni add dev vxlan0 vni 400

$bridge vni add dev vxlan0 vni 200 group 239.1.1.101

$bridge vni del dev vxlan0 vni 400

$bridge vni show

$bridge -s vni show

Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 bridge/Makefile      |   2 +-
 bridge/br_common.h   |   2 +
 bridge/bridge.c      |   1 +
 bridge/monitor.c     |  28 +++-
 bridge/vni.c         | 380 +++++++++++++++++++++++++++++++++++++++++++
 include/libnetlink.h |   8 +
 lib/libnetlink.c     |  18 ++
 man/man8/bridge.8    |  77 ++++++++-
 8 files changed, 513 insertions(+), 3 deletions(-)
 create mode 100644 bridge/vni.c

diff --git a/bridge/Makefile b/bridge/Makefile
index c6b7d08d..01f8a455 100644
--- a/bridge/Makefile
+++ b/bridge/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-BROBJ = bridge.o fdb.o monitor.o link.o mdb.o vlan.o
+BROBJ = bridge.o fdb.o monitor.o link.o mdb.o vlan.o vni.o
 
 include ../config.mk
 
diff --git a/bridge/br_common.h b/bridge/br_common.h
index 610e83f6..841f0594 100644
--- a/bridge/br_common.h
+++ b/bridge/br_common.h
@@ -14,6 +14,7 @@ void print_stp_state(__u8 state);
 int parse_stp_state(const char *arg);
 int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor,
 		   bool global_only);
+int print_vnifilter_rtm(struct nlmsghdr *n, void *arg, bool monitor);
 void br_print_router_port_stats(struct rtattr *pattr);
 
 int do_fdb(int argc, char **argv);
@@ -21,6 +22,7 @@ int do_mdb(int argc, char **argv);
 int do_monitor(int argc, char **argv);
 int do_vlan(int argc, char **argv);
 int do_link(int argc, char **argv);
+int do_vni(int argc, char **argv);
 
 extern int preferred_family;
 extern int show_stats;
diff --git a/bridge/bridge.c b/bridge/bridge.c
index f3a4f08f..704be50c 100644
--- a/bridge/bridge.c
+++ b/bridge/bridge.c
@@ -58,6 +58,7 @@ static const struct cmd {
 	{ "fdb",	do_fdb },
 	{ "mdb",	do_mdb },
 	{ "vlan",	do_vlan },
+	{ "vni",	do_vni },
 	{ "monitor",	do_monitor },
 	{ "help",	do_help },
 	{ 0 }
diff --git a/bridge/monitor.c b/bridge/monitor.c
index 845e221a..f17c1906 100644
--- a/bridge/monitor.c
+++ b/bridge/monitor.c
@@ -31,10 +31,20 @@ static int prefix_banner;
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: bridge monitor [file | link | fdb | mdb | vlan | all]\n");
+	fprintf(stderr, "Usage: bridge monitor [file | link | fdb | mdb | vlan | vni | all]\n");
 	exit(-1);
 }
 
+static int print_tunnel_rtm(struct nlmsghdr *n, void *arg, bool monitor)
+{
+	struct tunnel_msg *tmsg = NLMSG_DATA(n);
+
+	if (tmsg->family == PF_BRIDGE)
+		return print_vnifilter_rtm(n, arg, monitor);
+
+	return 0;
+}
+
 static int accept_msg(struct rtnl_ctrl_data *ctrl,
 		      struct nlmsghdr *n, void *arg)
 {
@@ -73,6 +83,12 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,
 			fprintf(fp, "[VLAN]");
 		return print_vlan_rtm(n, arg, true, false);
 
+	case RTM_NEWTUNNEL:
+	case RTM_DELTUNNEL:
+		if (prefix_banner)
+			fprintf(fp, "[TUNNEL]");
+		return print_tunnel_rtm(n, arg, true);
+
 	default:
 		return 0;
 	}
@@ -86,6 +102,7 @@ int do_monitor(int argc, char **argv)
 	int lneigh = 0;
 	int lmdb = 0;
 	int lvlan = 0;
+	int lvni = 0;
 
 	rtnl_close(&rth);
 
@@ -105,9 +122,13 @@ int do_monitor(int argc, char **argv)
 		} else if (matches(*argv, "vlan") == 0) {
 			lvlan = 1;
 			groups = 0;
+		} else if (strcmp(*argv, "vni") == 0) {
+			lvni = 1;
+			groups = 0;
 		} else if (strcmp(*argv, "all") == 0) {
 			groups = ~RTMGRP_TC;
 			lvlan = 1;
+			lvni = 1;
 			prefix_banner = 1;
 		} else if (matches(*argv, "help") == 0) {
 			usage();
@@ -151,6 +172,11 @@ int do_monitor(int argc, char **argv)
 		exit(1);
 	}
 
+	if (lvni && rtnl_add_nl_group(&rth, RTNLGRP_TUNNEL) < 0) {
+		fprintf(stderr, "Failed to add bridge vni group to list\n");
+		exit(1);
+	}
+
 	ll_init_map(&rth);
 
 	if (rtnl_listen(&rth, accept_msg, stdout) < 0)
diff --git a/bridge/vni.c b/bridge/vni.c
new file mode 100644
index 00000000..79dff005
--- /dev/null
+++ b/bridge/vni.c
@@ -0,0 +1,380 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Command to manage vnifiltering on a vxlan device
+ *
+ * Authors:     Roopa Prabhu <roopa@nvidia.com>
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <fcntl.h>
+#include <sys/socket.h>
+#include <net/if.h>
+#include <netinet/in.h>
+#include <linux/if_link.h>
+#include <linux/if_bridge.h>
+#include <linux/if_ether.h>
+
+#include "json_print.h"
+#include "libnetlink.h"
+#include "br_common.h"
+#include "utils.h"
+
+static unsigned int filter_index;
+
+#define VXLAN_ID_LEN 15
+
+#define __stringify_1(x...) #x
+#define __stringify(x...) __stringify_1(x)
+
+static void usage(void)
+{
+	fprintf(stderr,
+		"Usage: bridge vni { add | del } vni VNI\n"
+		"		[ { group | remote } IP_ADDRESS ]\n"
+	        "		[ dev DEV ]\n"
+		"       bridge vni { show }\n"
+		"\n"
+		"Where:	VNI	:= 0-16777215\n"
+	       );
+	exit(-1);
+}
+
+static int parse_vni_filter(const char *argv, struct nlmsghdr *n, int reqsize,
+			    inet_prefix *group)
+{
+	char *vnilist = strdupa(argv);
+	char *vni = strtok(vnilist, ",");
+	int group_type = AF_UNSPEC;
+	struct rtattr *nlvlist_e;
+	char *v;
+	int i;
+
+	if (group && is_addrtype_inet(group))
+		group_type = (group->family == AF_INET) ?  VXLAN_VNIFILTER_ENTRY_GROUP :
+						     VXLAN_VNIFILTER_ENTRY_GROUP6;
+
+	for (i = 0; vni; i++) {
+		__u32 vni_start = 0, vni_end = 0;
+
+		v = strchr(vni, '-');
+		if (v) {
+			*v = '\0';
+			v++;
+			vni_start = atoi(vni);
+			vni_end = atoi(v);
+		} else {
+			vni_start = atoi(vni);
+		}
+		nlvlist_e = addattr_nest(n, reqsize, VXLAN_VNIFILTER_ENTRY |
+					 NLA_F_NESTED);
+		addattr32(n, 1024, VXLAN_VNIFILTER_ENTRY_START, vni_start);
+		if (vni_end)
+			addattr32(n, 1024, VXLAN_VNIFILTER_ENTRY_END, vni_end);
+		if (group)
+			addattr_l(n, 1024, group_type, group->data, group->bytelen);
+		addattr_nest_end(n, nlvlist_e);
+		vni = strtok(NULL, ",");
+	}
+
+	return 0;
+}
+
+static int vni_modify(int cmd, int argc, char **argv)
+{
+	struct {
+		struct nlmsghdr	n;
+		struct tunnel_msg	tmsg;
+		char			buf[1024];
+	} req = {
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct tunnel_msg)),
+		.n.nlmsg_flags = NLM_F_REQUEST,
+		.n.nlmsg_type = cmd,
+		.tmsg.family = PF_BRIDGE,
+	};
+	bool group_present = false;
+	inet_prefix daddr;
+	char *vni = NULL;
+	char *d = NULL;
+
+	while (argc > 0) {
+		if (strcmp(*argv, "dev") == 0) {
+			NEXT_ARG();
+			d = *argv;
+		} else if (strcmp(*argv, "vni") == 0) {
+			NEXT_ARG();
+			if (vni)
+				invarg("duplicate vni", *argv);
+			vni = *argv;
+		} else if (strcmp(*argv, "group") == 0) {
+			if (group_present)
+				invarg("duplicate group", *argv);
+			if (is_addrtype_inet_not_multi(&daddr)) {
+				fprintf(stderr, "vxlan: both group and remote");
+				fprintf(stderr, " cannot be specified\n");
+				return -1;
+			}
+			NEXT_ARG();
+			get_addr(&daddr, *argv, AF_UNSPEC);
+			if (!is_addrtype_inet_multi(&daddr))
+				invarg("invalid group address", *argv);
+			group_present = true;
+		} else if (strcmp(*argv, "remote") == 0) {
+			if (group_present)
+				invarg("duplicate group", *argv);
+			NEXT_ARG();
+			get_addr(&daddr, *argv, AF_UNSPEC);
+			group_present = true;
+		} else {
+			if (strcmp(*argv, "help") == 0)
+				usage();
+		}
+		argc--; argv++;
+	}
+
+	if (d == NULL || vni == NULL) {
+		fprintf(stderr, "Device and VNI ID are required arguments.\n");
+		return -1;
+	}
+
+	if (!vni && group_present) {
+		fprintf(stderr, "Group can only be specified with a vni\n");
+		return -1;
+	}
+
+	if (vni)
+		parse_vni_filter(vni, &req.n, sizeof(req),
+				 (group_present ? &daddr : NULL));
+
+	req.tmsg.ifindex = ll_name_to_index(d);
+	if (req.tmsg.ifindex == 0) {
+		fprintf(stderr, "Cannot find vxlan device \"%s\"\n", d);
+		return -1;
+	}
+
+	if (rtnl_talk(&rth, &req.n, NULL) < 0)
+		return -1;
+
+	return 0;
+}
+
+static void open_vni_port(int ifi_index, const char *fmt)
+{
+	open_json_object(NULL);
+	print_color_string(PRINT_ANY, COLOR_IFNAME, "ifname",
+			   "%-" __stringify(IFNAMSIZ) "s  ",
+			   ll_index_to_name(ifi_index));
+	open_json_array(PRINT_JSON, "vnis");
+}
+
+static void close_vni_port(void)
+{
+	close_json_array(PRINT_JSON, NULL);
+	close_json_object();
+}
+
+static void print_range(const char *name, __u32 start, __u32 id)
+{
+	char end[64];
+
+	snprintf(end, sizeof(end), "%sEnd", name);
+
+	print_uint(PRINT_ANY, name, " %u", start);
+	if (start != id)
+		print_uint(PRINT_ANY, end, "-%-14u ", id);
+
+}
+
+static void print_vni(struct rtattr *t, int ifindex)
+{
+	struct rtattr *ttb[VXLAN_VNIFILTER_ENTRY_MAX+1];
+	__u32 vni_start = 0;
+	__u32 vni_end = 0;
+
+	parse_rtattr_flags(ttb, VXLAN_VNIFILTER_ENTRY_MAX, RTA_DATA(t),
+			   RTA_PAYLOAD(t), NLA_F_NESTED);
+
+	if (ttb[VXLAN_VNIFILTER_ENTRY_START])
+		vni_start = rta_getattr_u32(ttb[VXLAN_VNIFILTER_ENTRY_START]);
+
+	if (ttb[VXLAN_VNIFILTER_ENTRY_END])
+		vni_end = rta_getattr_u32(ttb[VXLAN_VNIFILTER_ENTRY_END]);
+
+	if (vni_end)
+		print_range("vni", vni_start, vni_end);
+	else
+		print_uint(PRINT_ANY, "vni", " %-14u", vni_start);
+
+	if (ttb[VXLAN_VNIFILTER_ENTRY_GROUP]) {
+		__be32 addr = rta_getattr_u32(ttb[VXLAN_VNIFILTER_ENTRY_GROUP]);
+
+		if (addr) {
+			if (IN_MULTICAST(ntohl(addr)))
+				print_string(PRINT_ANY,
+					     "group",
+					     " %s",
+					     format_host(AF_INET, 4, &addr));
+			else
+				print_string(PRINT_ANY,
+					     "remote",
+					     " %s",
+					     format_host(AF_INET, 4, &addr));
+		}
+	} else if (ttb[VXLAN_VNIFILTER_ENTRY_GROUP6]) {
+		struct in6_addr addr;
+
+		memcpy(&addr, RTA_DATA(ttb[VXLAN_VNIFILTER_ENTRY_GROUP6]), sizeof(struct in6_addr));
+		if (!IN6_IS_ADDR_UNSPECIFIED(&addr)) {
+			if (IN6_IS_ADDR_MULTICAST(&addr))
+				print_string(PRINT_ANY,
+					     "group",
+					     " %s",
+					     format_host(AF_INET6,
+							 sizeof(struct in6_addr),
+							 &addr));
+			else
+				print_string(PRINT_ANY,
+					     "remote",
+					     " %s",
+					     format_host(AF_INET6,
+							 sizeof(struct in6_addr),
+							 &addr));
+		}
+	}
+	close_json_object();
+	print_string(PRINT_FP, NULL, "%s", _SL_);
+}
+
+int print_vnifilter_rtm(struct nlmsghdr *n, void *arg, bool monitor)
+{
+	struct tunnel_msg *tmsg = NLMSG_DATA(n);
+	int len = n->nlmsg_len;
+	bool first = true;
+	struct rtattr *t;
+	int rem;
+
+	if (n->nlmsg_type != RTM_NEWTUNNEL &&
+	    n->nlmsg_type != RTM_DELTUNNEL &&
+	    n->nlmsg_type != RTM_GETTUNNEL) {
+		fprintf(stderr, "Unknown vni tunnel rtm msg: %08x %08x %08x\n",
+			n->nlmsg_len, n->nlmsg_type, n->nlmsg_flags);
+		return 0;
+	}
+
+	len -= NLMSG_LENGTH(sizeof(*tmsg));
+	if (len < 0) {
+		fprintf(stderr, "BUG: wrong nlmsg len %d\n", len);
+		return -1;
+	}
+
+	if (tmsg->family != AF_BRIDGE)
+		return 0;
+
+	if (filter_index && filter_index != tmsg->ifindex)
+		return 0;
+
+	if (n->nlmsg_type == RTM_DELTUNNEL)
+		print_bool(PRINT_ANY, "deleted", "Deleted ", true);
+
+	rem = len;
+	for (t = TUNNEL_RTA(tmsg); RTA_OK(t, rem); t = RTA_NEXT(t, rem)) {
+		unsigned short rta_type = t->rta_type & NLA_TYPE_MASK;
+
+		if (rta_type != VXLAN_VNIFILTER_ENTRY)
+			continue;
+		if (first) {
+			open_vni_port(tmsg->ifindex, "%s");
+			open_json_object(NULL);
+			first = false;
+		} else {
+			open_json_object(NULL);
+			print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s  ", "");
+		}
+
+		print_vni(t, tmsg->ifindex);
+	}
+	close_vni_port();
+
+	print_string(PRINT_FP, NULL, "%s", _SL_);
+
+	fflush(stdout);
+	return 0;
+}
+
+static int print_vnifilter_rtm_filter(struct nlmsghdr *n, void *arg)
+{
+	return print_vnifilter_rtm(n, arg, false);
+}
+
+static int vni_show(int argc, char **argv)
+{
+	char *filter_dev = NULL;
+	int ret = 0;
+
+	while (argc > 0) {
+		if (strcmp(*argv, "dev") == 0) {
+			NEXT_ARG();
+			if (filter_dev)
+				duparg("dev", *argv);
+			filter_dev = *argv;
+		}
+		argc--; argv++;
+	}
+
+	if (filter_dev) {
+		filter_index = ll_name_to_index(filter_dev);
+		if (!filter_index)
+			return nodev(filter_dev);
+	}
+
+	new_json_obj(json);
+
+	if (!show_stats) {
+		if (rtnl_tunneldump_req(&rth, PF_BRIDGE, filter_index) < 0) {
+			perror("Cannot send dump request");
+			exit(1);
+		}
+
+		if (!is_json_context()) {
+			printf("%-" __stringify(IFNAMSIZ) "s  %-"
+			       __stringify(VXLAN_ID_LEN) "s  %-"
+			       __stringify(15) "s",
+			       "dev", "vni", "group/remote");
+			printf("\n");
+		}
+
+		ret = rtnl_dump_filter(&rth, print_vnifilter_rtm_filter, NULL);
+		if (ret < 0) {
+			fprintf(stderr, "Dump ternminated\n");
+			exit(1);
+		}
+	}
+
+	delete_json_obj();
+	fflush(stdout);
+	return 0;
+}
+
+int do_vni(int argc, char **argv)
+{
+	ll_init_map(&rth);
+
+	if (argc > 0) {
+		if (strcmp(*argv, "add") == 0)
+			return vni_modify(RTM_NEWTUNNEL, argc-1, argv+1);
+		if (strcmp(*argv, "delete") == 0)
+			return vni_modify(RTM_DELTUNNEL, argc-1, argv+1);
+		if (strcmp(*argv, "show") == 0 ||
+		    strcmp(*argv, "lst") == 0 ||
+		    strcmp(*argv, "list") == 0)
+			return vni_show(argc-1, argv+1);
+		if (strcmp(*argv, "help") == 0)
+			usage();
+	} else {
+		return vni_show(0, NULL);
+	}
+
+	fprintf(stderr, "Command \"%s\" is unknown, try \"bridge vni help\".\n", *argv);
+	exit(-1);
+}
diff --git a/include/libnetlink.h b/include/libnetlink.h
index 372c3706..a1ec91ec 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -112,6 +112,9 @@ int rtnl_nexthop_bucket_dump_req(struct rtnl_handle *rth, int family,
 				 req_filter_fn_t filter_fn)
 	__attribute__((warn_unused_result));
 
+int rtnl_tunneldump_req(struct rtnl_handle *rth, int family, int ifindex)
+	__attribute__((warn_unused_result));
+
 struct rtnl_ctrl_data {
 	int	nsid;
 };
@@ -331,6 +334,11 @@ int rtnl_from_file(FILE *, rtnl_listen_filter_t handler,
 	((struct rtattr *)(((char *)(r)) + NLMSG_ALIGN(sizeof(struct br_vlan_msg))))
 #endif
 
+#ifndef TUNNEL_RTA
+#define TUNNEL_RTA(r) \
+	((struct rtattr *)(((char *)(r)) + NLMSG_ALIGN(sizeof(struct tunnel_msg))))
+#endif
+
 /* User defined nlmsg_type which is used mostly for logging netlink
  * messages from dump file */
 #define NLMSG_TSTAMP	15
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index 4d33e4dd..b3c3d0ba 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -1609,3 +1609,21 @@ void nl_print_policy(const struct rtattr *attr, FILE *fp)
 		}
 	}
 }
+
+int rtnl_tunneldump_req(struct rtnl_handle *rth, int family, int ifindex)
+{
+	struct {
+		struct nlmsghdr nlh;
+		struct tunnel_msg tmsg;
+		char buf[256];
+	} req = {
+		.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct tunnel_msg)),
+		.nlh.nlmsg_type = RTM_GETTUNNEL,
+		.nlh.nlmsg_flags = NLM_F_DUMP | NLM_F_REQUEST,
+		.nlh.nlmsg_seq = rth->dump = ++rth->seq,
+		.tmsg.family = family,
+		.tmsg.ifindex = ifindex,
+	};
+
+	return send(rth->fd, &req, sizeof(req), 0);
+}
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 2fa4f3d6..d8923d2e 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -13,7 +13,7 @@ bridge \- show / manipulate bridge addresses and devices
 
 .ti -8
 .IR OBJECT " := { "
-.BR link " | " fdb " | " mdb " | " vlan " | " monitor " }"
+.BR link " | " fdb " | " mdb " | " vlan " | " vni " | " monitor " }"
 .sp
 
 .ti -8
@@ -196,6 +196,25 @@ bridge \- show / manipulate bridge addresses and devices
 .B vid
 .IR VID " ]"
 
+.ti -8
+.BR "bridge vlan" " show " [ "
+.B dev
+.IR DEV " ]"
+
+.ti -8
+.BR "bridge vni" " { " add " | " del " } "
+.B dev
+.I DEV
+.B vni
+.IR VNI " [ { "
+.B group | remote "} "
+.IR IPADDR " ] "
+
+.ti -8
+.BR "bridge vni" " show " [ "
+.B dev
+.IR DEV " ]"
+
 .ti -8
 .BR "bridge monitor" " [ " all " | " neigh " | " link " | " mdb " | " vlan " ]"
 
@@ -303,6 +322,10 @@ the output.
 .B vlan
 - VLAN filter list.
 
+.TP
+.B vni
+- VNI filter list.
+
 .SS
 .I COMMAND
 
@@ -1084,6 +1107,58 @@ all bridge interfaces.
 the VLAN ID only whose global options should be listed. Default is to list
 all vlans.
 
+.SH bridge vni - VNI filter list
+
+.B vni
+objects contain known VNI IDs for a dst metadata vxlan link.
+
+.P
+The corresponding commands display vni filter entries, add new entries,
+and delete old ones.
+
+.SS bridge vni add - add a new vni filter entry
+
+This command creates a new vni filter entry.
+
+.TP
+.BI dev " NAME"
+the interface with which this vni is associated.
+
+.TP
+.BI vni " VNI"
+the VNI ID that identifies the vni.
+
+.TP
+.BI remote " IPADDR"
+specifies the unicast destination IP address to use in outgoing packets
+when the destination link layer address is not known in the VXLAN device
+forwarding database. This parameter cannot be specified with the group.
+
+.TP
+.BI group " IPADDR"
+specifies the multicast IP address to join for this VNI
+
+.SS bridge vni del - delete a new vni filter entry
+
+This command removes an existing vni filter entry.
+
+.PP
+The arguments are the same as with
+.BR "bridge vni add".
+
+.SS bridge vni show - list vni filtering configuration.
+
+This command displays the current vni filter table.
+
+.PP
+With the
+.B -statistics
+option, the command displays per-vni traffic statistics.
+
+.TP
+.BI dev " NAME"
+shows vni filtering table associated with the vxlan device
+
 .SH bridge monitor - state monitoring
 
 The
-- 
2.25.1

