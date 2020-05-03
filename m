Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0F31C2A71
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 08:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgECGyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 02:54:04 -0400
Received: from mail-eopbgr130051.outbound.protection.outlook.com ([40.107.13.51]:28205
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727116AbgECGyC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 May 2020 02:54:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CkJAxZhKUWrZ3Fe708UzO5QjUaKpuu1Iw4b5+4Bv7NELz0/13EzoYaTW87+aWwGu0pOhJVBczoUnC+UgNammURAOQSRe3l2bplOj5vEx/drm+DIiO2e7l0fm2hZqJBtbWv3MFFzBlFWun105QRllD6mdj70D7HTvdqjQa93OmBjAlvTL75fxnq+TBdSKwqdHRrCv7aQNPOSDLdCEaweLIzSi6uklzia/3dC93xpVT7U5WZmApH/wZrnGKUZRrlEqKwVVt9oj4nnO2D3pnsdXnNxSG7xehkKzuTG2oLGUbl8sYaZAwf4EAERuuhFNl1Ih60qfYHukY4LwJf4sTO+p6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TmngGAtUUC5JVgLmg6ST+bC8VQlUKVvOgwc8NPyGcY=;
 b=gPY7QdEdHHui8ez3Wjou0GztxSbHMgXpO3Tx/yO7ZLbyzQJcpZSk5k3dfPvD2xEiPHNBtc33loSSmx8m6VADtnOItVNY9k01mbUEB48IMCyXJQjiybKBT9MUx6ZVeuYsrlUas4ozwHmuDhetxDKDNq/i9vBzrPjAF19aMoTA7oMG0NoMurWCmwxXkF0TJvCdNMcWXh9COpi0x/ytLxcKMmOEhaRnLSywaKRYPqjAAWYg2EWQFRMk8/LeL3QAW+bsfKvJVoHUIAPRCw5vSv+4H5tcZQdMq+5m8gl7JC/11NXkoxFFjLvOrLiZoL8HBKKkjmw1qh05FtfEI4x/bFzhsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TmngGAtUUC5JVgLmg6ST+bC8VQlUKVvOgwc8NPyGcY=;
 b=WBgXCjLd257z2+Arj2c6kucVtJ1/8bcdH0MpSwSr7fKChI0z5cJLG9Ew05WePXSN6G6z3hmGjnRDXP3uWafAK3+Ouxuw/oUt1TFflDmVTGk5c3AAhCbm6/9Mi3UpeSO7n48Iy9qK4zKiiBrbf0sZWyl2CQogfm50hDHlNn2mWt8=
Authentication-Results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6656.eurprd04.prod.outlook.com (2603:10a6:803:126::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.27; Sun, 3 May
 2020 06:53:57 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2958.029; Sun, 3 May 2020
 06:53:57 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     stephen@networkplumber.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, vlad@buslov.dev, po.liu@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, Po Liu <Po.Liu@nxp.com>
Subject: [v3,iproute2 2/2] iproute2: add gate action man page
Date:   Sun,  3 May 2020 14:32:51 +0800
Message-Id: <20200503063251.10915-2-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200503063251.10915-1-Po.Liu@nxp.com>
References: <20200501005318.21334-5-Po.Liu@nxp.com>
 <20200503063251.10915-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0121.apcprd03.prod.outlook.com
 (2603:1096:4:91::25) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR03CA0121.apcprd03.prod.outlook.com (2603:1096:4:91::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.14 via Frontend Transport; Sun, 3 May 2020 06:53:50 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 443c11db-7c12-454a-043f-08d7ef2ec058
X-MS-TrafficTypeDiagnostic: VE1PR04MB6656:|VE1PR04MB6656:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB66560E3DCFA6923392D262EF92A90@VE1PR04MB6656.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0392679D18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GAhvfnBrmBdaL+TS8+xbBpw+UoNnb4y1emUJeElYS8a+Bx4Hpg/lrc8vxAR0rTiHTwBL/yPtvCWl2J2Ebe+FLCcj+GAREEFb8ep8MSV6rCFSydcUOVJZfEWRf+KIEYOKK3uVO4of0t1bmk/ZYxz5tsRCPxsPNBVTqvbXYI4t5GDJ1/MJBTrn1/HshxERLUbG3OFB8MoIfwMKdzvr14YEjmSeB0aDYW/i85NRgcqUj8hdr7xWpegnetpqDSOxI8imxWtUqf73UtUdo2fKZVoFTJG9qkOHECBxdOZvvwaMFGttzwky5VXek3f/SJrBVVxifxhnU3oPXKysi5H27r4PHPH5oeAqW8SAMvP99P6khNHidHjEy3rQWq1LhjxtvYHamWpiB6ph+MjYnfbZPWwhJQqoKq+XLpkDD7Frq1vmeGYJpFqmpij2bC7eTwhn27Rjc2A5A7XBmIrT6AmOMizquBgHnGdTDy/1c4SmFWVF+RUQGveG0Pp3z+6LuNgnaBjh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(5660300002)(6506007)(26005)(52116002)(6486002)(66556008)(2906002)(36756003)(66476007)(66946007)(69590400007)(7416002)(86362001)(8936002)(956004)(186003)(4326008)(16526019)(1076003)(6512007)(2616005)(316002)(478600001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +566IFz3ms8MmMSLoSbpE6w7yoCcE4/Dc8IUC/LAFTALSESXClY2+gx5QEHlmfyJoksjLWIbYgkE6TkmKY+b4sYOMTc2Qbqjq3nFdxKgs6mJQi1WqyGoECPpYTrFaR6knEqdzboJT/koond6rmnut3WKoXYNCz922ulQrwkA+viUyKyoL3fKnVy16S28wMSdXs7Agyj9X37E4Spp7x2DBRBx9eRJyI+RUI3xsG3711a5Gpvkqv6BNSnFiYBL78aaCJb3Je5kQg3H9bdUi2waO4YhejDxLeK7Przuu4M39eum0go7+f9/sLhcTt+runTsdaMZHNlvaVsh3GeSlEe/a2B/H4iZSVcxehcQfMkZGRWzJomdzhS1k+qgG6ImXtyzffkBXYy2g63Wb7HlJPb046Ab6/ct/BHA0mXx8DeVO3zUZ9mtm4zs7FRMb9DKn8g9M/w2h+e1kJInMjNVXvL/ONvzQH//e9LRD7NBmeW/im0rihcqSwSngLMbpl+R6zkU6NHd/3lToMbMdIHO9yTfmmnBq2DN6pcGY3QPPoLJHAa7yZAec1gxfpWTKAmjj2QN2wnYixyrTWrKG35aaWSWwpjJuoj5pNZLJ6vJ/zftHIONzMgSWrrcM+rRDjq8QoIinpQmyJwpWwzd/vbqK8GkRc4j5oAGOAtBd1nfFFxZSzUqhWZcDrlemSmnAB7dt6RV3ExFkapo7vmTSu+l60rxvb5oFo9rMEXl7WVsLRgrM/YqqPBgX/sK5oV4/Ofk8A/2Ubc86EathNZq/HYkdzf1V7V+euP7/+XIJEHem9At5ZU=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 443c11db-7c12-454a-043f-08d7ef2ec058
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2020 06:53:57.3040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Sp1J9Y/hXR8TELCzdeniZDG/L/pjSYQ0ZhFE2S0q1sptIiX1brHFKOFUT+tFfG9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6656
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add the man page for the tc gate action.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 man/man8/tc-gate.8 | 123 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)
 create mode 100644 man/man8/tc-gate.8

diff --git a/man/man8/tc-gate.8 b/man/man8/tc-gate.8
new file mode 100644
index 00000000..0f48d7f3
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
+<max octets> means how many octets size for this time slot. Dropped
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
+           base-time 200000000000 \\
+           sched-entry open 200000000 -1 8000000 \\
+           sched-entry close 100000000
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
+	action gate index 12 sched-entry close 200000000
+
+.EE
+
+.SH AUTHORS
+Po Liu <Po.Liu@nxp.com>
-- 
2.17.1

