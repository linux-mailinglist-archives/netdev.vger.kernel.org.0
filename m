Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7067F50B2FA
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 10:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445526AbiDVIef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 04:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445518AbiDVIea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 04:34:30 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3997A52E58
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 01:31:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OpSaw2W5moXt2miMViT056+mzQhUf63b2+gIo9kmAO/aT5ZGzQ3aNFWBMO96L8QfG9KXopbjx+KaJNGJz5f/knsjM35SNbaWltqZMh0N7HCA4I6ChpsSydggyrVVrciDcwsl6JEPhE3Tz4Kmb4O2S/eHEWleiLOP64dY6jUPIjioeXH0TcRdLO4gPbgjL24SAKE/Zv1w/x9EcifhI557l4vJQ1DRbXyE+vN7SK6CFt3ZcKLZjj615gimFwWTtC61XfCu0X3+XU6onF5X5ISMEn9eSYFDI7BctBRFeOOFa9f+AJNiRAGicBZ3oDOUimDKvF9gJ+mYYQTT+pOyBsUgiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oab3wxmzgmtNk9LXxQ3TKvAeMVU+VR2R7JtNC+DBzjc=;
 b=Z4K+pyMHqtwbx1kzp+m/ClYof4ua/DUDQk6vQOHXQtsZWZ1Z2NUXxrCefuyle4295lphTkTgyjxHaCaZYeNIbkXQJcHk/WSe4IrNCrtzXwOtTZ9kRmKNVpvZvAkBc6ogVIrekpvBViQau52+frZ73CdDEEisYObUC4Ildyywv/CAKBeJdVH35dU7yBYbuncEQ52giEwd74glD8d+RsRpzmnwyIYgmifdoh5o9tGAj8NUV0CBg65v3yAWXNf4G8teU+Bi/Wei5nm+g8c6usVDgfJfp+UReBQqNtRIhLNoVeSMKPadNWLx5sLC05MK/sWS6Q+kc7qas7S5X2iKmHObfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oab3wxmzgmtNk9LXxQ3TKvAeMVU+VR2R7JtNC+DBzjc=;
 b=DckXdja1fPDuXe5s9UQtFjfdYaDIbCGtbE1IfmyA8YKRfpmKe8pya6H/Hnk3xzh/KAfr8/CZwcUiv83p3HF4u/Lg1Z3+KP4yh6DIJFRjDQSL3Xw924oLpS56vW+/qcOfG4A2xDiv3ZGYt2zRZNF9adeMBmA7+gMMfblMbV1ZJ71mWWTMa7JcYX4ozr/nhUMYhsrwQvpAbIQwLF5qsjztwN7SGWSp9dmjoZtKyjs1yN2ChtXNORNidFowdBZBN/rqnzPo8tNjnIabQbia2ks/xgJlXOlH8oE64Nt9d4j01GesMuDFYSh7RtK+7RnrNRS1uzO0w6be27u06ed9kPdjAA==
Received: from MW4PR04CA0191.namprd04.prod.outlook.com (2603:10b6:303:86::16)
 by CY5PR12MB6129.namprd12.prod.outlook.com (2603:10b6:930:27::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 08:31:34 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::ff) by MW4PR04CA0191.outlook.office365.com
 (2603:10b6:303:86::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Fri, 22 Apr 2022 08:31:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 08:31:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 22 Apr
 2022 08:31:33 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 22 Apr
 2022 01:31:31 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 03/11] ip: Add a new family of commands, "stats"
Date:   Fri, 22 Apr 2022 10:30:52 +0200
Message-ID: <fe2cbab58f3114095afdc0780dee75a8b8156529.1650615982.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1650615982.git.petrm@nvidia.com>
References: <cover.1650615982.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31a44c9c-c407-47d6-f2bd-08da243a82b5
X-MS-TrafficTypeDiagnostic: CY5PR12MB6129:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB6129E8DE08B52FA92362B254D6F79@CY5PR12MB6129.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kVWuOBxgi+lV7/MYoRGHB+TJ0bi5VOjMY9ag7Zbs/U3zQr0bKOJGLM9z7Wpxh97l9lu0RqDOJwQjvjapvxibO5Y1Ws4CEEg2LG5/Rl16t/+6R9t0zBzSHpfo1gl6xFAhvQ8H/YX7Ois67+MpyUWcv42yhJCDDa2AQhxuu/bky2pMWZol4kzIA2LOUgUimvw51BOZowvvz7kHwtZG3ZPXXNqUnUHOuoSRUnIG7qCiWvUHU4sYcDL42s7CxOLyP871gSepCZVoVDE9rVYqkOO/EuN2zsz4PvHbtH7itOvfv+xkgke4dARtdNMaI4BCEu4Q2NX9zx23MAPBoM/emAz6dz7dOxP01wVFuhEHLnqUNhTCNWiuG9pnVXOiN5DoSycGF2Tjb5rs/xiotvK8JucjHb6HJfN+YSISQQeMZSJtkYCV/qGfslpgeIGRGpqnTe4nHIsx4zc6MS33YxBHGgMwhAWhLfTHFOiZH4Rmzp8MEa2eOqVSd5/GTxUTIxHLlMNiPmw8tRKGhSjBqkXrGrTYrVzn8Cm6SNKRhntCqYoQL5pm/xZgoQRW7kdJCHX3riNoZJ8djhwtg/XHMn77LU5wgc1qOQWT8T3SgXdPZe3i8Vo0HgnRuvvgs3H9SPw9bR8zYTbMpi//6sMzZkTMyxejwy6p9Ljo4Vp/pRnPvVjgGhB5yukM6q1uVe44iEa3C7Dm/LaxJLZdMs1ozwYaAAMhKw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(186003)(26005)(16526019)(82310400005)(36756003)(316002)(4326008)(2906002)(5660300002)(47076005)(336012)(107886003)(36860700001)(8936002)(6666004)(426003)(2616005)(83380400001)(86362001)(8676002)(81166007)(40460700003)(54906003)(356005)(508600001)(70206006)(6916009)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 08:31:34.4605
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31a44c9c-c407-47d6-f2bd-08da243a82b5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6129
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a core of a new frontend tool for interfacing with the RTM_*STATS
family of messages. The following patches will add subcommands for showing
and setting individual statistics suites.

Note that in this patch, "ip stats" is made to be an invalid command line.
This will be changed in later patches to default to "show" when that is
introduced.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/Makefile    |  3 ++-
 ip/ip.c        |  1 +
 ip/ip_common.h |  1 +
 ip/ipstats.c   | 31 +++++++++++++++++++++++++++++++
 4 files changed, 35 insertions(+), 1 deletion(-)
 create mode 100644 ip/ipstats.c

diff --git a/ip/Makefile b/ip/Makefile
index e06a7c84..6c2e0720 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -12,7 +12,8 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
     iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
     ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
     ipnexthop.o ipmptcp.o iplink_bareudp.o iplink_wwan.o ipioam6.o \
-    iplink_amt.o iplink_batadv.o iplink_gtp.o iplink_virt_wifi.o
+    iplink_amt.o iplink_batadv.o iplink_gtp.o iplink_virt_wifi.o \
+    ipstats.o
 
 RTMONOBJ=rtmon.o
 
diff --git a/ip/ip.c b/ip/ip.c
index c784f819..82282bab 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -123,6 +123,7 @@ static const struct cmd {
 	{ "mptcp",	do_mptcp },
 	{ "ioam",	do_ioam6 },
 	{ "help",	do_help },
+	{ "stats",	do_ipstats },
 	{ 0 }
 };
 
diff --git a/ip/ip_common.h b/ip/ip_common.h
index 51a7edc7..53866d7a 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -90,6 +90,7 @@ int do_seg6(int argc, char **argv);
 int do_ipnh(int argc, char **argv);
 int do_mptcp(int argc, char **argv);
 int do_ioam6(int argc, char **argv);
+int do_ipstats(int argc, char **argv);
 
 int iplink_get(char *name, __u32 filt_mask);
 int iplink_ifla_xstats(int argc, char **argv);
diff --git a/ip/ipstats.c b/ip/ipstats.c
new file mode 100644
index 00000000..099e18a2
--- /dev/null
+++ b/ip/ipstats.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0+
+#include "utils.h"
+#include "ip_common.h"
+
+static int do_help(void)
+{
+	fprintf(stderr,
+		"Usage: ip stats help\n"
+		);
+
+	return 0;
+}
+
+int do_ipstats(int argc, char **argv)
+{
+	int rc;
+
+	if (argc == 0) {
+		do_help();
+		rc = -1;
+	} else if (strcmp(*argv, "help") == 0) {
+		do_help();
+		rc = 0;
+	} else {
+		fprintf(stderr, "Command \"%s\" is unknown, try \"ip stats help\".\n",
+			*argv);
+		rc = -1;
+	}
+
+	return rc;
+}
-- 
2.31.1

