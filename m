Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C4550B2F9
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 10:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445536AbiDVIe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 04:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445533AbiDVIeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 04:34:46 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2060.outbound.protection.outlook.com [40.107.96.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A4752E7B
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 01:31:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OP4kQZq/KO+kCEUEBUvdzeu0eRxBLgYyTgMZ3R+0vmOunMGf8zG9a09gHT3qEu0xYsnYINZKXtNsj9V9G1aUn6CRrCe5b810J/WMymmIhlaPx/18s/2xI6FKGyRa4X09hsyi+ZvuHDDfHi6OaBYayDbRp/BESaYDvpWNllyw2Fqh/ss1NFGr+x9W48erT0qSpHOmA46ctMbsL0jfHcmnk0tp1lXI0Mr6W99OVzXckK6J+5Tsx+hWKRIS3FpNiWfACAkgBsrgd2eyHHxBnG4Luo8nk8uc57ze+UUH8wW8O3bKdc93hTy0jCUyCTDyYnn0+soGpV4gRHawBGUKdIqb0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8MZaotlU4/qHIPhORc8Jz17PTSwXR6nwJyPkX4SyxpA=;
 b=G4gPO04hBB64+rIrv46Q8r10wtO+fMqsKB+eNnEj9CF3S5q4hboM70gGkXH90N0/mCJGSlGKKzQvjBlzFy17AGTqqp2sQsm3WQ3uHlfmrCtasPgTVOLIpjL83YEJvabLJTetvdrjfEGvWKTI2TOHn9lbjhHNaNyUPkFBbepJouVSXBvTkyTclzRoTri9eVGe4Se1+TEowxWp+xokiUaY04x3wzl36No7QnlkZe6fERCJeVCL83n4sSWvPqpevihwGeSS6BsseAGtQH36blKvI4uQjmSEJ/gJ6KI3uK2EHnkbkZuAiunGvcK7TmJWEG82wgslJva7iZsRGB/GWTlUpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8MZaotlU4/qHIPhORc8Jz17PTSwXR6nwJyPkX4SyxpA=;
 b=l5QbIX0QQgEVBDZtpe/CNGnR+FQgm927PniS0q7DI+xx9xtIyMki3+5wKLc8FppBkRjLIXBkC+Tk7uKw8NTykufy0Hy/KnOWxYmREilNoEpJFzIhjzKq+ZwgitD01BtTGqW9YqaKdFoykk5tL8N6zv4Ut5V3g0NjGcM9ZvWsdmDmAUJkj1Apm6/3cSakOY9mkjYed8ayf/mu2xGXQICytpO45aTVKiKHkzwMBPBQdVAfzdlf60HQx3ig3f/3zWK2uhV8omzLoteLK5ovQ+/q+d6PqhzfaqEmMj2pBgSPnDu89KbLB/a01opt6eu55uyEsnWeMgpHawzBYUOJc67iyw==
Received: from DM6PR06CA0016.namprd06.prod.outlook.com (2603:10b6:5:120::29)
 by DM6PR12MB5022.namprd12.prod.outlook.com (2603:10b6:5:20e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Fri, 22 Apr
 2022 08:31:48 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::ab) by DM6PR06CA0016.outlook.office365.com
 (2603:10b6:5:120::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Fri, 22 Apr 2022 08:31:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 08:31:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 22 Apr
 2022 08:31:48 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 22 Apr
 2022 01:31:46 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 11/11] man: Add man pages for the "stats" functions
Date:   Fri, 22 Apr 2022 10:31:00 +0200
Message-ID: <e68f18edd6272fa583894cf2676439baf9eb8c5a.1650615982.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7e0d93bb-8e05-4941-0922-08da243a8b1a
X-MS-TrafficTypeDiagnostic: DM6PR12MB5022:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB50220440227C9FB98B8CC44AD6F79@DM6PR12MB5022.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mSV0PfrO7X45Sw4y5074sA/Kk6Ag973KU1UdCQJjxjkEe6c0wuGtIpSKMsYv7TluoBgv2ILviUH1dDp3a8jP+VCxCvHZN3YAFRtzL8LJtU1v1zv7I3X4KLEaKGiF+UIIDm/oS/nCrIM9v72yXsnUZ9PwtQIhvSXzxQkfwzBiDks/giNWUbTGNmQKmVq0FfkOnENysPDX4ePYQy91zFEEpWwkP9fgWxJx38JlKA8pXs5+rqInPWQeqPPVNWZH4u1L0rPLqd2c78jQu6wlQ10O1XDWeQY//k/f65QHRYuxVdgknGpwTArMgFYkDwfDcEfi87J/R1f7jNz7Fwtqtswgi3gv5sljcZ4/261zyKfAHzb3M8ph2ua7Rteklw3SI+n7FTmyzMJoxKJyEJzzj8B7QrHpQT7NVHD/ASNZbmaa/Jb9tnb1a6OP1fme43bvNgfvTKFu2ux8ka1kuwd9xEQV1BQc0sBAmOS5rVEg9B7zOlzZsKVBD2NNQrauSCEOxSM2jB31bdP1Mh1P9bbkmDiV5dR5ccbi51D+iDjPZOc+UnFgMjtmcs+A2nTWTzU9PBNtGcrt6+scx21WH/95SQguA+497IxyXjRnYBIcwr08SKjtL1eA3Kb6GV4ZLJsVBBrJFc2KDl65BIYwCrnez6r0p2xhCNpOhWNGVRfL+RWCQSQUcIJ0klPb4A5m8Ty+Y4+9/4cG2aZ0ErVzrGqt5YCZzQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(36860700001)(47076005)(2906002)(83380400001)(426003)(26005)(82310400005)(316002)(336012)(36756003)(186003)(16526019)(107886003)(6916009)(2616005)(54906003)(8936002)(6666004)(8676002)(4326008)(81166007)(5660300002)(508600001)(86362001)(70206006)(70586007)(356005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 08:31:48.5538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e0d93bb-8e05-4941-0922-08da243a8b1a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5022
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a man page for the new "stats" command.
Also mention the new "stats" group in ip-monitor.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 man/man8/ip-monitor.8 |   2 +-
 man/man8/ip-stats.8   | 160 ++++++++++++++++++++++++++++++++++++++++++
 man/man8/ip.8         |   7 +-
 3 files changed, 167 insertions(+), 2 deletions(-)
 create mode 100644 man/man8/ip-stats.8

diff --git a/man/man8/ip-monitor.8 b/man/man8/ip-monitor.8
index f886d31b..ec033c69 100644
--- a/man/man8/ip-monitor.8
+++ b/man/man8/ip-monitor.8
@@ -55,7 +55,7 @@ command is the first in the command line and then the object list follows:
 is the list of object types that we want to monitor.
 It may contain
 .BR link ", " address ", " route ", " mroute ", " prefix ", "
-.BR neigh ", " netconf ", "  rule ", " nsid " and " nexthop "."
+.BR neigh ", " netconf ", "  rule ", " stats ", " nsid " and " nexthop "."
 If no
 .B file
 argument is given,
diff --git a/man/man8/ip-stats.8 b/man/man8/ip-stats.8
new file mode 100644
index 00000000..7eaaf122
--- /dev/null
+++ b/man/man8/ip-stats.8
@@ -0,0 +1,160 @@
+.TH IP\-STATS 8 "16 Mar 2022" "iproute2" "Linux"
+.SH NAME
+ip-stats \- manage and show interface statistics
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+.ti -8
+.B ip
+.B stats
+.RI  " { " COMMAND " | "
+.BR help " }"
+.sp
+
+.ti -8
+.BR "ip stats show"
+.RB "[ " dev
+.IR DEV " ] "
+.RB "[ " group
+.IR GROUP " [ "
+.BI subgroup " SUBGROUP"
+.R " ] ... ] ..."
+
+.ti -8
+.BR "ip stats set"
+.BI dev " DEV"
+.BR l3_stats " { "
+.BR on " | " off " }"
+
+.SH DESCRIPTION
+
+.TP
+.B ip stats set
+is used for toggling whether a certain HW statistics suite is collected on
+a given netdevice. The following statistics suites are supported:
+
+.in 21
+
+.ti 14
+.B l3_stats
+L3 stats reflect traffic that takes place in a HW device on an object that
+corresponds to the given software netdevice.
+
+.TP
+.B ip stats show
+is used for showing stats on a given netdevice, or dumping statistics
+across all netdevices. By default, all stats are requested. It is possible
+to filter which stats are requested by using the
+.B group
+and
+.B subgroup
+keywords.
+
+It is possible to specify several groups, or several subgroups for one
+group. When no subgroups are given for a group, all the subgroups are
+requested.
+
+The following groups are recognized:
+.in 21
+
+.ti 14
+.B group link
+- Link statistics. The same suite that "ip -s link show" shows.
+
+.ti 14
+.B group offload
+- A group that contains a number of HW-oriented statistics. See below for
+individual subgroups within this group.
+
+.TQ
+.BR "group offload " subgroups:
+.in 21
+
+.ti 14
+.B subgroup cpu_hit
+- The
+.B cpu_hit
+statistics suite is useful on hardware netdevices. The
+.B link
+statistics on these devices reflect both the hardware- and
+software-datapath traffic. The
+.B cpu_hit
+statistics then only reflect software-datapath traffic.
+
+.ti 14
+.B subgroup hw_stats_info
+- This suite does not include traffic statistics, but rather communicates
+the state of other statistics. Through this subgroup, it is possible to
+discover whether a given statistic was enabled, and when it was, whether
+any device driver actually configured its device to collect these
+statistics. For example,
+.B l3_stats
+was enabled in the following case, but no driver has installed it:
+
+# ip stats show dev swp1 group offload subgroup hw_stats_info
+.br
+56: swp1: group offload subgroup hw_stats_info
+.br
+    l3_stats on used off
+
+After an L3 address is added to the netdevice, the counter will be
+installed:
+
+# ip addr add dev swp1 192.0.2.1/28
+.br
+# ip stats show dev swp1 group offload subgroup hw_stats_info
+.br
+56: swp1: group offload subgroup hw_stats_info
+.br
+    l3_stats on used on
+
+.ti 14
+.B subgroup l3_stats
+- These statistics reflect L3 traffic that takes place in HW on an object
+that corresponds to the netdevice. Note that this suite is disabled by
+default and needs to be first enabled through
+.B ip stats set\fR.
+
+For example:
+
+# ip stats show dev swp2.200 group offload subgroup l3_stats
+.br
+112: swp2.200: group offload subgroup l3_stats on used on
+.br
+    RX:  bytes packets errors dropped   mcast
+.br
+          8900      72      2       0       3
+.br
+    TX:  bytes packets errors dropped
+.br
+          7176      58      0       0
+
+Note how the l3_stats_info for the selected group is also part of the dump.
+
+.SH EXAMPLES
+.PP
+# ip stats set dev swp1 l3_stats on
+.RS
+Enables collection of L3 HW statistics on swp1.
+.RE
+
+.PP
+# ip stats show group offload
+.RS
+Shows all offload statistics on all netdevices.
+.RE
+
+.PP
+# ip stats show dev swp1 group link
+.RS
+Shows link statistics on the given netdevice.
+.RE
+
+.SH SEE ALSO
+.br
+.BR ip (8),
+.BR ip-link (8),
+
+.SH AUTHOR
+Manpage by Petr Machata.
diff --git a/man/man8/ip.8 b/man/man8/ip.8
index 2a4848b7..f6adbc77 100644
--- a/man/man8/ip.8
+++ b/man/man8/ip.8
@@ -22,7 +22,7 @@ ip \- show / manipulate routing, network devices, interfaces and tunnels
 .BR link " | " address " | " addrlabel " | " route " | " rule " | " neigh " | "\
  ntable " | " tunnel " | " tuntap " | " maddress " | "  mroute " | " mrule " | "\
  monitor " | " xfrm " | " netns " | "  l2tp " | "  tcp_metrics " | " token " | "\
- macsec " | " vrf " | " mptcp " | " ioam " }"
+ macsec " | " vrf " | " mptcp " | " ioam " | " stats " }"
 .sp
 
 .ti -8
@@ -302,6 +302,10 @@ readability.
 .B rule
 - rule in routing policy database.
 
+.TP
+.B stats
+- manage and show interface statistics.
+
 .TP
 .B tcp_metrics/tcpmetrics
 - manage TCP Metrics
@@ -419,6 +423,7 @@ was written by Alexey N. Kuznetsov and added in Linux 2.2.
 .BR ip-ntable (8),
 .BR ip-route (8),
 .BR ip-rule (8),
+.BR ip-stats (8)
 .BR ip-tcp_metrics (8),
 .BR ip-token (8),
 .BR ip-tunnel (8),
-- 
2.31.1

