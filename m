Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE029516119
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 02:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238236AbiEAAPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 20:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238097AbiEAAPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 20:15:34 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E702B393DF
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 17:12:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2Uggl7gwej792ukDzFf/Mf4zMyA571Yj6rJRENkMzUDFitSWPRBnm6irAhwQ9XWIxPjOWJyHnYFPbvVCk7T65iJKW567SMxvk3AnZLvFHdmRVzvOSJRJVKyhIUvZ8Fwp2OBblzV6oZ3LC7d8Hh0S08ABTRgg7NIm9UKgtwVgiVCxlfs0S0XWXe3n4J8oE34jWBkrpbkaEODvKamFDa5pfER6B1lElebiDAAs9Q17+Q3XYER7kdDwVjaxmQD7CMCwF4PZyJhiwDxrDjL8HOIkfPpFgdWsLPqkQnYQK45d5HQhbtfWJ658uzCArbuQM7DkUkj0Z695El8BefMXLSlmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PKB0OtmpOzRXsRFV3n0IFj1LXCXshTsRezJhNX2KCKY=;
 b=MZPcv3O/48a9zjMLjKixRJeEyDbo/IVT2azQZ2BSa6OBCVjUu8F5Yhi+1A9tIPKGxFtejyR9BpPINipy3/pNsNa1p10v9iuqkimQHB286ety2zcEu8HKke3NwpexZr2dRJZTlzHVUhdN4sb8z/7bgNT5TRS5uxY45ZXqVfwO5TFhET2JaKU4a+I94Zuu3Vxhs429A6oDEDdOzDIR6JwxajFwOVL890vDYw/jJ0naid9QRatKyQ+Z/1xkutUiupWN0Q8Yc3C0iZkF2uJWIdj36oKA3DEVDlaxTmaaXOEZWNEykg3c5BW9JWSTup2ZP52B8HhiK03QD3FE7gg4Hp2xMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PKB0OtmpOzRXsRFV3n0IFj1LXCXshTsRezJhNX2KCKY=;
 b=Qj/G1uI4V0q0MqoI86a2cGNwuQ03qSlVyCEaAnIZvH/F0Xk3v4vUiRNDmiJOOCRmF81Q1wTaLRcUw+eVHsxhw2HmbnOsDULlew5jEvVZUXwBgCa5bGcn+gyvrepHcExRq5KZqg9Tx9Os2qrl9kD0bsO9htkGEgxR6HLJ9MW7PVXBa086Acgmj2I29gtwplUoY8uCamRLjB7Xu/w9u6doJ+AaOhXa15SgKKG4yt01EaEbXV6rrzSu6OviSPWXAKdboGP9JJsb3sP/xybgMfJjbYpNyrs9eBbAeiSLmVj23Vh+qVqE7n37z0KK+XfAU5wvdfsGDvRP4HNcddPhLQrNew==
Received: from MW2PR16CA0065.namprd16.prod.outlook.com (2603:10b6:907:1::42)
 by CY4PR12MB1656.namprd12.prod.outlook.com (2603:10b6:910:d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.23; Sun, 1 May
 2022 00:12:08 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::c7) by MW2PR16CA0065.outlook.office365.com
 (2603:10b6:907:1::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14 via Frontend
 Transport; Sun, 1 May 2022 00:12:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Sun, 1 May 2022 00:12:07 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Sun, 1 May 2022 00:12:07 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Sat, 30 Apr 2022 17:12:06 -0700
Received: from localhost.localdomain (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Sat, 30 Apr 2022 17:12:06 -0700
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <razor@blackwall.org>
Subject: [PATCH iproute2 net-next 1/3] bridge: vxlan device vnifilter support
Date:   Sun, 1 May 2022 00:12:03 +0000
Message-ID: <20220501001205.33782-2-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220501001205.33782-1-roopa@nvidia.com>
References: <20220501001205.33782-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 151b2cea-f5d3-405d-5648-08da2b073ad2
X-MS-TrafficTypeDiagnostic: CY4PR12MB1656:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB165678B6F1FD21938B71B4DBCBFE9@CY4PR12MB1656.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ztL6Wj1ZCjK+68Thp77Kl0DGq0UvGpYEk/VCbFCW5RPaUTHpmEOfPQgWDY95JLVCiqwQkiqYV3KHBtGiYx8XETrGjVixZFwh+vJveWC573ac6T3sMYJ7od9pBLa+u8QxoGfyvYRGBgW/2rqdEtb3Va6AMwmtmL4cN+sGMsiwBOjAWrZHLzyT2v8zzrje5kWFYRtvHpFYRG3OSG8tVwBb9OzgG/4PiFPgr65PwleRsDpt9lLuWgm8FI9VpYPmN3tGcyvZQ6DdJ5pQGcbFO0JJw3/gEYODysvadsncxV4NNsn1C27nyY4YCyR9rpRkagN1tNlctCW4jqG57A/ihGT3iPk+b85egV0savm4nVXqnjriNc2s7AHgZl/DxXxaT5IEESrMWp0ipiBvakl/seo08knKGWgV6G944q+GcNPUAcq/rXG2dCIDBDAEI6ra3YqYclQHBS19RsWhB45LVLnsK8rrhKC+JD0b2Ebw1B68paNicQUaN6B+C1cj8EGYC3n44th57a44ab0rfTwS2OXJK1vnU27vo32IoFIn0Zb5z6ceYDLNfSMFCkC59d+CzAKhNjXiyibBu1kOIfeNSyAs3go1vs/Mat4+QomcBpsJtAaQ1xLUh7gYZJD2lwdfsgrXKT8C0yksCMd6h4Fzl/lEikyg9hwRANV61AXjubD+ZnHZhPV1tQQfs/8c4URxOIbJx/AZTFa6V3SMfSpgezdnxg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(54906003)(6916009)(5660300002)(81166007)(30864003)(83380400001)(316002)(82310400005)(4326008)(8676002)(70206006)(70586007)(86362001)(8936002)(36860700001)(40460700003)(47076005)(66574015)(336012)(426003)(1076003)(2616005)(26005)(36756003)(186003)(2906002)(508600001)(356005)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2022 00:12:07.6412
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 151b2cea-f5d3-405d-5648-08da2b073ad2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1656
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
index 845e221a..2784e93e 100644
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
+		} else if (matches(*argv, "vni") == 0) {
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
index 00000000..65939b34
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
+		} else if (!matches(*argv, "group")) {
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
+		} else if (!matches(*argv, "remote")) {
+			if (group_present)
+				invarg("duplicate group", *argv);
+			NEXT_ARG();
+			get_addr(&daddr, *argv, AF_UNSPEC);
+			group_present = true;
+		} else {
+			if (matches(*argv, "help") == 0)
+				NEXT_ARG();
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
+		if (matches(*argv, "add") == 0)
+			return vni_modify(RTM_NEWTUNNEL, argc-1, argv+1);
+		if (matches(*argv, "delete") == 0)
+			return vni_modify(RTM_DELTUNNEL, argc-1, argv+1);
+		if (matches(*argv, "show") == 0 ||
+		    matches(*argv, "lst") == 0 ||
+		    matches(*argv, "list") == 0)
+			return vni_show(argc-1, argv+1);
+		if (matches(*argv, "help") == 0)
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

