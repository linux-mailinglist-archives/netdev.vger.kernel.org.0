Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FFD1CA524
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 09:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgEHHYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 03:24:21 -0400
Received: from mail-db8eur05on2041.outbound.protection.outlook.com ([40.107.20.41]:62977
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726048AbgEHHYV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 03:24:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iAA5Bct1FD9mCId/nFdmAmA2fiX4SbI93JvWRlQosoD3SUOT/78xfFmhUuG1hicyiK77MGMlAu4LWgfI6wW5a0EF6IzdN36Tx5dGLgS8VGa1uthFjFaEtHseZuTPVR77cY0dR5D9IEcD3r++bRuQshTkZbydZlUwoTzOnAVGsUDuwJu6Mw3+/WOjMb+02xKRm5gR8B9tlN+9icFEg9ezSyuw/4++jBpw9fjqZZgLpoMuLtHo+rFjNHDrodwpY4KaN8xF6hWoYEKzqCM8LcT86jK5zKAVhzJLaPyX9mWghNJpqQnB8428bCwPV9HCAAiC3xsBtLnLra/zgqfJkY7JMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4xVLWhG///qGe0ZYVgQwCt3PBJv4ZWaX6EldxDAb21E=;
 b=LepBLqMhM75XugxX7BsyMlCFRSIrvv1jzfYRocZ2lfc/rQ6SQ95JfOCnvsFhxOVY+VyYP8Uh1cbhUzVjg/q/aK1/7XXwKCp/mgtHt4io4ClfLr5eDQo8R/jwsrpH8+jdqCOqJ7l7ZiYMO3jgTMDrD6L4fzw/50MdvtSKFlocnnyXYef3iOis43HJXjUH9USLm36WLdEPWgKqM1CpEyfh+PziEQIuAVGKBQiJ+YEXb73RGR8riw4FO56D2cc2tWyupml7+xy1Rty11UVHZgvE7mM70fvdidVSA7vQm5yFzSmNu46h0NNieCdAX1LIdRwRAgOE5dwnzEjnVw0IuIXRow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4xVLWhG///qGe0ZYVgQwCt3PBJv4ZWaX6EldxDAb21E=;
 b=jFHkxdZzkdvK9WMxCFcvltwFQjvh9lC/pr9uDSXyvIE2TABSNLOHxOR0xI/Ue8FBQ6qrpOd0kddqcn7no5CNW952HRejrgeneGeJKrIsbhyB19x/5iSo25joPBQIXObKOMOhDoUi9n63t/sD8L8SpLphbFbLm8gDh2bCG0F2ksU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6720.eurprd04.prod.outlook.com (2603:10a6:803:123::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.21; Fri, 8 May
 2020 07:24:17 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2958.034; Fri, 8 May 2020
 07:24:17 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     dsahern@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, stephen@networkplumber.org,
        dcaratti@redhat.com, davem@davemloft.net, vlad@buslov.dev,
        po.liu@nxp.com, claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, Po Liu <Po.Liu@nxp.com>
Subject: [v5,iproute2-next 2/2] iproute2-next: add gate action man page
Date:   Fri,  8 May 2020 15:02:47 +0800
Message-Id: <20200508070247.6084-2-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200508070247.6084-1-Po.Liu@nxp.com>
References: <20200506084020.18106-2-Po.Liu@nxp.com>
 <20200508070247.6084-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0041.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::18) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by BYAPR06CA0041.namprd06.prod.outlook.com (2603:10b6:a03:14b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Fri, 8 May 2020 07:24:10 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 393cd40c-4473-4c33-7cd5-08d7f320d0ed
X-MS-TrafficTypeDiagnostic: VE1PR04MB6720:|VE1PR04MB6720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB67206C1272A68DB778C1CD6B92A20@VE1PR04MB6720.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BiHgFWmJIx76F8QHJlTGz5lvxhbGX892+5EH3nSgZadW1Wk1qsjO3sWIZcX6m7SczpHJ+ORP6l9hC5/K123qb1A+RSDSsh4jMWKtZZJfKf5r/QE9L/zliRbQ8XPTXAOFKHLWtC2Phfqa8pK2sJXg9ElBpG9byJfKAmllKm36MYgW2OFWiG39cnrjZILn5/km7/2RrmLAL8p1mjR/q561qvmWrQTEV4S0/t9u2mvbD444GfgRvqsld59VnM0fjjf7cgSPF+oyS9nd1nWufsZwYrILCxD2+5a4pwcAHMK7It/qSGeJY4tQIgZhKT4yk69ahBSwSbg6iIopAPeMAjTozwACv2cgTOsuN8V6R899sFU6S0IAhj1mbj5NqNiK+j0T7U/2J9LszZMWy3+wqbHziN9v2kypfnWvJua5n07WFuL1ZF4vl5NG56rNn8k6JZxSsbbQ+iOdmiGZfWpz6lsso5oF+p1SRktSwUIG/CNgo1PGnX7BcAKeSc+7SEUCWht8ki8k+BYFdGCNl4Z+MMNlEFcGzAW7scpqRA9RZQys1QuAMO3FRSffzvWash971ca2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(33430700001)(66476007)(66946007)(4326008)(52116002)(26005)(33440700001)(5660300002)(6666004)(6506007)(8676002)(36756003)(1076003)(8936002)(2906002)(6486002)(86362001)(186003)(16526019)(66556008)(478600001)(83320400001)(83290400001)(83280400001)(83310400001)(69590400007)(316002)(956004)(2616005)(83300400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FejOY0/3PtNIa8H2FIAY2rqWGill3+D5wdiqh0NpCMQ8O+GrC+8cRAmglgGeYrqEGtCEp767kemGCpH8wiWCz6I7eMAR6WcNjT8h7ogD3jREoMmJXNn58ibol1drujY8eRdLrTGwLpOO1Uvy7gIxS4RRiXOwJaxj/lhSJWOKU7uSz1rPyTQf5auWmbFKL8UHwDp+5nrDG06GiqmC5CyHn1Zuy19MCzyIy7wVMV5jsc1D3YqXjTo6OtENYdT/AimpIAYavV4Vrg3ZFp8XIrQZmAxrlAWU66adFfPwXlh+JMn7tTUGg1Q2tPdkIoRWlfe+V4cJD0NzwqthqPu4zxr3D9pVW0hJV13Jl5VInaFn3Te1dP/X8cbBqiSra5EyfO4igGeYMd4sS4oXSI/sRrj/Mh6ClvquBIz6lUH0G/LnEEBuaxx5DL/XjkdZggfgl6SexKTEN7AE/aOH24p1YIGLAAxcMOKCO5r1iIB1VocaVi0=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 393cd40c-4473-4c33-7cd5-08d7f320d0ed
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 07:24:17.0379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t7MD+q1T7nB/hDI54JyjdSlcWuIcNjc+F3sGc9wdV3Hb1QkGwskmBbmA6sM46g1B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6720
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add the man page for the tc gate action.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
changes before v4:
No changes.

changes from v4:
- Update the examples with input/output time and size routine support

 man/man8/tc-gate.8 | 123 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)
 create mode 100644 man/man8/tc-gate.8

diff --git a/man/man8/tc-gate.8 b/man/man8/tc-gate.8
new file mode 100644
index 00000000..23d93ca4
--- /dev/null
+++ b/man/man8/tc-gate.8
@@ -0,0 +1,123 @@
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
+<gate state> <interval 1> [ <internal priority> <max octets> ]
+.ti +8
+.B sched-entry
+<gate state> <interval 2> [ <internal priority> <max octets> ]
+.ti +8
+.B sched-entry
+<gate state> <interval 3> [ <internal priority> <max octets> ]
+.ti +8
+.B ......
+.ti +8
+.B sched-entry
+<gate state> <interval N> [ <internal priority> <max octets> ]
+
+.SH DESCRIPTION
+GATE action allows specified ingress frames can be passed at
+specific time slot, or be dropped at specific time slot. Tc filter
+filters the ingress frames, then tc gate action would specify which time
+slot and how many bytes these frames can be passed to device and
+which time slot frames would be dropped.
+Gate action also assign a base-time to tell when the entry list start.
+Then gate action would start to repeat the gate entry list cyclically
+at the start base-time.
+For the software simulation, gate action requires the user assign reference
+time clock type.
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
+time and scheduling events. Not valid if gate action is used for offloading
+filter.
+For example, tc filter command with
+.B skip_sw
+parameter.
+
+.TP
+sched-entry
+.br
+There may multiple
+.B sched-entry
+parameters in a single schedule. Each one has the format:
+
+sched-entry <gate state> <interval> [ <internal priority> <max octets> ]
+
+.br
+<gate state> means gate states. 'open' keep gate open, 'close' keep gate close.
+.br
+<interval> means how much nano seconds for this time slot.
+.br
+<internal priority> means internal priority value. Present of the
+internal receiving queue for this stream. "-1" means wildcard.
+<internal priority> and <max octets> can be omit default to be "-1" which both
+ value to be "-1" for this <sched-entry>.
+.br
+<max octets> means how many octets size could pass in this time slot. Dropped
+if overlimited. "-1" means wildcard. <max octets> can be omit default to be
+"-1" which value to be "-1" for this <sched-entry>.
+.br
+Note that <internal priority> and <max octets> are nothing meaning for gate state
+is "close" in a "sched-entry". All frames are dropped when "sched-entry" with
+"close" state.
+
+.SH EXAMPLES
+
+The following example shows tc filter frames source ip match to the
+192.168.0.20 will keep the gate open for 200ms and limit the traffic to 8MB
+in this sched-entry. Then keep the traffic gate to be close for 100ms.
+Frames arrived at gate close state would be dropped. Then the cycle would
+run the gate entries periodically. The schedule will start at instant 200.0s
+using the reference CLOCK_TAI. The schedule is composed of two entries
+each of 300ms duration.
+
+.EX
+# tc qdisc add dev eth0 ingress
+# tc filter add dev eth0 parent ffff: protocol ip \\
+           flower skip_hw src_ip 192.168.0.20 \\
+           action gate index 2 clockid CLOCK_TAI \\
+           base-time 200000000000ns \\
+           sched-entry open 200000000ns -1 8000000b \\
+           sched-entry close 100000000ns
+
+.EE
+
+Following commands is an example to filter a stream source mac match to the
+10:00:80:00:00:00 icmp frames will be dropped at any time with cycle 200ms.
+With a default basetime 0 and clockid is CLOCK_TAI as default.
+
+.EX
+# tc qdisc add dev eth0 ingress
+# tc filter add dev eth0 parent ffff:  protocol ip \\
+	flower ip_proto icmp dst_mac 10:00:80:00:00:00 \\
+	action gate index 12 sched-entry close 200000000ns
+
+.EE
+
+.SH AUTHORS
+Po Liu <Po.Liu@nxp.com>
-- 
2.17.1

