Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D6319042A
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbgCXEIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:08:37 -0400
Received: from mail-eopbgr130051.outbound.protection.outlook.com ([40.107.13.51]:30567
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727267AbgCXEIe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 00:08:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jBkyQk3LLr74NDof3WZB5PhO1B8md9xl+VXL40XtprOd4YfKY0WP8FzonOQbnzXbwOUPYT62dKC8/vJxWKuR37MbqAld81VgK5FaqZIeLvjB0ZGGxVLZ1nk8WMPzXwlRyBL/5M2aiw1912Z2QkuJUEoczjZ1zJZ3HhsW7XGrl9b7oAAf8NPiJ0v32t4epWy8V38RLzJd/Rc75d4Jb9Wv9hHHBPRO4IelbplN50PZ6NY5CDOVxaMtwyd7DZwe7DSO+ftYYXcCsqhMdMqgPCFZVip1esmSZSXLhelSiwBHYQBKh4dce4loVWYeQK/J+YGwk72n9lmWwQvd+tRbZ5v69g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6d8bCbSibbV9yXoAGjtoeJij1At8dpH2TRAw849q7I=;
 b=GONbIZlz9Yjh0JdQo/UQJxv4fJxNvVmIiUUrNdlGzVvwxrZo5iO8ttKeAw2IqP/ik63oJZMSONTjHbIXenjIX737SYVNiKq82Lh2MaHu3u/XkdnnRgf99WaMpJ68bxjN8GxVnBizXhtFJIkIUasDAt5b3k/orEaOarvwBqhhtBdWSQU+73Ch6LqkxMeNcYsHjXTawS139gGywMQTkc/5vbQPtN3ceRZW5e3OErhPfduXCDnI1Xwfdg5MrqSjlgDdWmfV0uYgjedQ1R7ue6f+Qdgev9Cc22oWkAkm3g2ZnEbqWDLGPb/o+/UG8eWSQ7EGD7bGGpMhexLmLgEZCIOY6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6d8bCbSibbV9yXoAGjtoeJij1At8dpH2TRAw849q7I=;
 b=Rhd6tBqfRgCJdTqrUxg4CK4g5SZREeNM/1gY/sJRbd4enol6zd/ZuQrbVKcobBRkp2sbHlfa2VkN57AuAGIkvjo9DP+31ehqblSE1XYsm43rcyWGpL73FnZ2z4rwzrnJ52YM6WXe7jVReynVegCZ5ZmzKHU3XOychbjCJTCXNBg=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6413.eurprd04.prod.outlook.com (20.179.232.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Tue, 24 Mar 2020 04:08:22 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 04:08:22 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, roy.zang@nxp.com, mingkai.hu@nxp.com,
        jerry.huang@nxp.com, leoyang.li@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org,
        Po Liu <Po.Liu@nxp.com>
Subject: [v1,iproute2  2/2] iproute2: add gate action man page
Date:   Tue, 24 Mar 2020 11:47:45 +0800
Message-Id: <20200324034745.30979-8-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324034745.30979-1-Po.Liu@nxp.com>
References: <20200306125608.11717-11-Po.Liu@nxp.com>
 <20200324034745.30979-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0204.apcprd06.prod.outlook.com (2603:1096:4:1::36)
 To VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR06CA0204.apcprd06.prod.outlook.com (2603:1096:4:1::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Tue, 24 Mar 2020 04:08:13 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 13cc7079-cca5-4f60-d8d5-08d7cfa8fe18
X-MS-TrafficTypeDiagnostic: VE1PR04MB6413:|VE1PR04MB6413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6413D7B1C53366864A58AB5492F10@VE1PR04MB6413.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(136003)(39860400002)(346002)(16526019)(26005)(86362001)(69590400007)(1076003)(478600001)(52116002)(6506007)(186003)(4326008)(7416002)(6512007)(6486002)(8936002)(81166006)(8676002)(81156014)(2906002)(316002)(66556008)(6666004)(956004)(66476007)(5660300002)(66946007)(36756003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6413;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4fppHO/rHZh5O6y3Tjn21RFUHhnwvIeE+wBG2uSOZ+xlLO94HfGJni2qQvG/r8n/ksb1efCO1Rg17+kxVRkfOsQHQIt6XzbKUQGRsjuKBf6ez9/b0B7WmNqyjJfXy8+mkk4G0Uq+i8SIPmwWvOYsG1mFU1lj+A2srnN7e1QMp2a7P2DN9LOvtbrDNGPevxuV2fV76cIPg4HHYVbgxz+4XUbz5R7X62LnBYk1THlb9BSkiILBjxcbbX1WrPxp5v+m0zmqYczcrkf46Wuu4e3UqA3xpwmT51OOqy8CWX/whGKPqSNJH8n+iwZQRhfo03wMpoFBdUdKtkDamF5T/BxPFOz7G2VnCET8cQOBCM5TVtEVzifKBQUBhGSJWWMqc18qNGKWbfap8JYT46tTZsYFO5Sf6+N8N4Wwn4xmvwameEwAJ7enBxfNH1SbTZsjg8ouagvNNK8qcNVKtpxxHBGkMB8h20y79V/nK6XHKdRmzn1c0FpzhqCSW05Q034iCcJu
X-MS-Exchange-AntiSpam-MessageData: zpIvVW88NfwSsf7Zjy3liFQvfwTFwmcae5uipmR6ibm0YYrs0NXE1P5Q86Yu8+gi58PjBVhPvE0tbROHG1qW7G4vvJMd6nBFLRTZFdLVgWGKXF5gamJqY40fUKbXNvXPpTiIkyCWfOaOuaYMZ/Qg1A==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13cc7079-cca5-4f60-d8d5-08d7cfa8fe18
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 04:08:22.4249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m0j5rAPCgsJW8+0Q5/7Tb2tRDK5/goeYBdS0jibgjb98UUSAPvZKO1TBLhLi2Ba8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6413
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 man/man8/tc-gate.8 | 106 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)
 create mode 100644 man/man8/tc-gate.8

diff --git a/man/man8/tc-gate.8 b/man/man8/tc-gate.8
new file mode 100644
index 0000000..2b2d101
--- /dev/null
+++ b/man/man8/tc-gate.8
@@ -0,0 +1,106 @@
+.TH GATE 8 "12 Mar 2020" "iproute2" "Linux"
+.SH NAME
+gate \- Stream Gate Action
+.SH SYNOPSIS
+.B tc " ... " action gate
+.ti +8
+.B [ base-time
+BASETIME ]
+.B [ clockid
+CLOCKID ]
+.ti +8
+.B sched-entry
+<gate state> <interval 1> <internal priority> <max octets>
+.ti +8
+.B sched-entry
+<gate state> <interval 2> <internal priority> <max octets>
+.ti +8
+.B sched-entry
+<gate state> <interval 3> <internal priority> <max octets>
+.ti +8
+.B ......
+.ti +8
+.B sched-entry
+<gate state> <interval N> <internal priority> <max octets>
+
+.SH DESCRIPTION
+GATE action would provide a gate list to control when traffic keep
+open/close state. when the gate open state, the flow could pass but
+not when gate state is close. The driver would repeat the gate list
+periodically. User also could assign a time point to start the gate
+list by the basetime parameter. if the basetime has passed current
+time, start time would calculate by the cycletime of the gate list.
+
+.SH PARAMETERS
+
+.TP
+base-time
+.br
+Specifies the instant in nanoseconds, defining the time when the schedule
+starts. If 'base-time' is a time in the past, the schedule will start at
+
+base-time + (N * cycle-time)
+
+where N is the smallest integer so the resulting time is greater than
+"now", and "cycle-time" is the sum of all the intervals of the entries
+in the schedule. Without base-time specified, will default to be 0.
+
+.TP
+clockid
+.br
+Specifies the clock to be used by qdisc's internal timer for measuring
+time and scheduling events. Not valid if using for offloading filter.
+For example, tc filter command with
+.B skip_sw parameter.
+
+.TP
+sched-entry
+.br
+There may multiple
+.B sched-entry
+parameters in a single schedule. Each one has the format:
+
+sched-entry <gate state> <interval> <internal priority> <max octets>
+
+.br
+<gate state> means gate states. 'OPEN' keep gate open, 'CLOSE' keep gate close.
+.br
+<interval> means how much nano seconds for this time slot.
+.br
+<internal priority> means internal priority value. Present of the
+internal receiving queue for this stream. "-1" means wildcard.
+.br
+<max octets> means how many octets size for this time slot. Dropped
+if overlimited. "-1" means wildcard.
+
+.SH EXAMPLES
+
+The following example shows tc filter frames source ip match to the
+192.168.0.20 will be passed at offset time 0 last 200000000ns and will
+be dropped at the offset time 200000000ns and last 100000000ns. Then
+run the gate periodically. The schedule will start at instant 200000000000
+using the reference CLOCK_TAI. The schedule is composed of three entries
+each of 300us duration.
+
+.EX
+# tc filter add dev eth0 parent ffff: protocol ip \\
+           flower skip_hw src_ip 192.168.0.20 \\
+           action gate index 2 clockid CLOCK_TAI \\
+           base-time 200000000000 \\
+           sched-entry OPEN 200000000 -1 -1 \\
+           sched-entry CLOSE 100000000 -1 -1
+
+.EE
+
+Following is an example to filter a stream source mac match to the
+10:00:80:00:00:00 will be dropped at any time.
+
+.EX
+#tc filter add dev eth0 parent ffff: protocol ip chain 14 \\
+	flower skip_sw dst_mac 10:00:80:00:00:00 \\
+	action gate index 12 sched-entry close 200000000 -1 -1
+
+.EE
+
+.SH AUTHORS
+Po Liu <Po.Liu@nxp.com>
-- 
2.17.1

