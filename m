Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34F76E6013
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbjDRLkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbjDRLkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:40:15 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2074.outbound.protection.outlook.com [40.107.14.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9366588
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:40:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6/IvhIjbruDZN8oIVoAMQvIxfNFToqKyMfl2bU1L4udOuxmkI5hls1+0oa3AxpWYsYiXAC+tACzjguoYa2WpwvdhFDiuQo3VLCtIrubLFKhqWedx4wuS/zMBlRzlnK9wPz8X0lM7opIPqEzXNJF0uL/DbHmE1i/juAtYj1K9Tlz7RhICzorjqDexJ6Vb6Caen3XjOhERmT+CHxZ8iTgh3Yl284/aYzK2iw1z9B7qOSA8BuThaItcoPcbZSTyXfZ+AhnU3nReMHA4CQ3Afu/xdR5s4dcMMYscW9XgbloYgzAtT6SM6c9naJ6+oESWvAEzXqLZrTfV1T9BAWI7eHqqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B4kCcLJF5HqiC0hhqDQ/lL4g+vy+vtxFCLDXtUKHLB8=;
 b=P1WZEO6Yfdc7bS9Ti7L6XngO5lNEpK8m2k1V/VD0wyxN4WE71Ssjt2hm+AaNwKMUNkyImY5cxOXrbTKd3u8Ix9Mb55DRT7bwdUAFpuZfp2T64re4pqa1QgpkZZT/MFZDnstq0fcdV6mKFxwzpjYVlEk6GC6hfWmKKR7op6uXTyHK0tLstYnmu+oiUNuiMiLRw8+qlaTcHxSgjBkyoMTppkYdzA4K3QcBzFdFh2lNpu4tqS7bPIkSrGyUlOYHMgDSdG6snTseZyChXPk9VfEg8Yw7AXuACJjTo26ap3pqLQfSqGEF/W289gd0XI7tF/ThVlONvNMpMr+gvM2S5zCNcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4kCcLJF5HqiC0hhqDQ/lL4g+vy+vtxFCLDXtUKHLB8=;
 b=rf+FqSSjOyfu6S5bfhWcS5sZk4f6E1t7ZKb+Vd7fPkWRjIKXiY2x7/aICcp5R/s9609Hht9KeYAlQB/q5GyC1pHJDuXc26U3wZtRKzIgC9dUxlNIUSP1Q7OHIbCRpFZsEMh+uJlHBTuMy5xcGaNTchq1/mkQ2r7hR8fBngKi020=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8557.eurprd04.prod.outlook.com (2603:10a6:102:214::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Tue, 18 Apr
 2023 11:40:10 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:40:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 07/10] Update kernel headers
Date:   Tue, 18 Apr 2023 14:39:50 +0300
Message-Id: <20230418113953.818831-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418113953.818831-1-vladimir.oltean@nxp.com>
References: <20230418113953.818831-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0003.eurprd05.prod.outlook.com
 (2603:10a6:800:92::13) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8557:EE_
X-MS-Office365-Filtering-Correlation-Id: be47db24-8920-4bfc-9395-08db4001aa28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UKPlZoupvoKo+sxKQ15BGNTzPyWg+sufkmFrEJIOxoaTiBi/PpRvYMnviMnGrA0T7Y3cfpkLoSaA/DnYj/8NeW5xNPyc46a+9/+Q96XUoG5oUYIHg/InllxVaIXo0BsKHGAlVomUe0T2Hs5H16jrrhqCaWbgQuFlWcNiw5n7rC4K6FvQ5RLwLXYGIq7W8oyiJnmumJtPX25PcQAyLU9fSOR8nMu44rGSuhKJqmWRGhcpOgu8dQ+qD7uNT3QSyWXM1amOe5KhugFzA8WXFZmu6z8S5pA6VAwL+eZi8IVB9R6Kw4kk7oC2rbaKp78WDu5hw7p4gg6qStJjnHSdfSQQqNsjusUMyXVx/t6ZvzQlJ6EinbvG9oShEaK3yH2w3QDagJerjrSSPi766NfgSDYZlOrII0UJd5qptEpc8UpJXqH03kyhC22cKVierSOvg4tuCN4Vsmv9E8QeFHjUvO0bTzKeXJl+Q3q1hKJAbK3GqiRwntIl4i8+JbIKQ8JzzGVJMPz5Nj0Ygo1lWu8g1QvXDr1qd2TZtdRh11D14AOsTd11bbV/P8bGVIKZPFX/7JKYtefIpB6jU4rhHDeDKAT3S/A1H8cf0fYIdb1lK4s3iT/eGCPjCs1qgHnUFmW8hiig
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199021)(316002)(4326008)(66946007)(66556008)(66476007)(6916009)(478600001)(54906003)(8936002)(8676002)(5660300002)(44832011)(15650500001)(41300700001)(38100700002)(38350700002)(186003)(83380400001)(2616005)(6486002)(6666004)(52116002)(6512007)(6506007)(1076003)(26005)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pz9wm7IYESFE3Mp+f/ZpSa/yV519J/4mctvqKs4iCjZM10Po1rMYTgFey4GD?=
 =?us-ascii?Q?omupvNMqKOmOfcO3hTSAYGnc5EKAcNaqfOuVYbPnX0XbU7IbMFh51sqT2wGY?=
 =?us-ascii?Q?Yd9r/2lNXUi6paH84rWQqf1WVTinv1m3Lck2ADhLjzqy+ql/dgxTt5BzVMSh?=
 =?us-ascii?Q?t3LJ4OUZicF+iZj8JESSpIsnP+dMRVwxoSjr08kpQpYUv4PLAkHgPo0QjkTX?=
 =?us-ascii?Q?mZl5t/XFYgjt8/zga3327+SrUKAtELo9rOTf9XMsQjLIND39KzH9el1Ky3JX?=
 =?us-ascii?Q?Iu8cAzrLhBb0Q0pyTelBNHWwPTxJ4FItkPE/yy+Lndjp+KC4xN0aS0S53hTQ?=
 =?us-ascii?Q?nNhppOcrG6Q8LO9h+LwirZjGPxdFiN2SWClWgdXgahnDBuHRO8GT/f81u+ie?=
 =?us-ascii?Q?qJ/PX3D50sPhO83xajwT8sFfVFjoaphfBXBINZdG/wKkluTlmkKwVeBNsIZj?=
 =?us-ascii?Q?mLxuVfg1EbXyYjsa+QGoqN9/hx3YC7Mzpr5VnSXhJuNj0r2LGNW2RW/pOtNk?=
 =?us-ascii?Q?ARq3UlRbaZlvb3lxHVuwKvwfLV1Xg13QhR6D4au8JNo8GyRZHje/21cwwY5o?=
 =?us-ascii?Q?BZIrGjxchL9N7NBNBHPeeDyRMwfNtxJ7iJfjVV8FlTGmgP7uSWDhJ0KqflBq?=
 =?us-ascii?Q?X1f1a9u9J7+FQLt7OqEkQEGW+JxNmm63G4TKjMX5+jAMh2oLcvtvekSYpd8W?=
 =?us-ascii?Q?pYeLcF4Piw1xLSUOLAaqN/JaLleGbwv9+xs/dh4qpY0z6pvUjDI4WZL6+Saj?=
 =?us-ascii?Q?3oMYsAzEjdyrn41i0TOTfmCoa6HRiszb+O5rL9iIR6tWTNs3negvJ736aUGF?=
 =?us-ascii?Q?/66UeljFppIVp3IcbyIkj77ci2SRq+dCds6HZBKCSX9CkmDMHx3Ei2qWLQ1f?=
 =?us-ascii?Q?LlGAmQITtvMVHmJ9zixkZ9Oa8W94FimKFbZuEqE6mm2UWBBg/Y7vrqtCyDwq?=
 =?us-ascii?Q?F+XH1GRtEtT5+XQJrsBQ3JGRuZ9M8v2jhsOubD29qK0roNORXRTqWz+iQgt8?=
 =?us-ascii?Q?k+LKXKSbNyirQ2Lasd6AixURhGBZL1pScsp+WLKGb/HYgvo901dGtjukxdi3?=
 =?us-ascii?Q?P3r1kwm2GM/vc+V4cJlYtisErpYaPaiW0p7IFhHQ/MgxF4bO7F2Kz7qPd0ic?=
 =?us-ascii?Q?Dt06eBQcFGLUervwQfLSiHynEaV4VUD4BivWp13VonXHus5yHrEn2n9Jf0qc?=
 =?us-ascii?Q?jpv1HtI7QgWhCNRzk3xHwHsik7aGOLqP8vUf8i4xYUc6fYYejHLb6apZUsld?=
 =?us-ascii?Q?+SugOdW5zKcvravdmjao4FprDtNVylDfQDmQ5YDBNn2VpMB29bfeK/ZiP1dI?=
 =?us-ascii?Q?8twaTJRvgmbOHesUql76CtRz6+bfNxDbDoLQYtXfM1p9hXJ4BdUgbUmXudlQ?=
 =?us-ascii?Q?IdvpEms5b9FnRhenN8BhfAkNhM6rl+U6A0bawkMqjPpTf77tTOXZExdE/3JS?=
 =?us-ascii?Q?3PCrDG9LxY7cTTwqNKzOi55CCosG9H9BUeIKlcRHyrSnCVzC5xPscnAIPPx4?=
 =?us-ascii?Q?566XBTI721eZA7Zix8OUUyjXKDgkb351ibjb8CohLIrqYt/PlaNxqgr4Y/5/?=
 =?us-ascii?Q?x3MLSx28LXXbr+UmGGcK0SJW9MOWMElx8SUoCQq4A4w6UU9mA+I5BuNsrjad?=
 =?us-ascii?Q?Ag=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be47db24-8920-4bfc-9395-08db4001aa28
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:40:09.8632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QHXSSqd16oxIEaPk5jFMeZEc3aRqjEdlBehHX+G+C/pX9dW+ZCHEFToO0Di8pAdSbcNuZee+mKZIXNWsNRUS6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8557
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update kernel headers to commit:
    3684a23b5aff ("Merge branch 'ocelot-felix-driver-support-for-preemptible-traffic-classes'")

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: delta generated automatically

 include/uapi/linux/bpf.h       | 61 ++++++++++++++++++++++++++++------
 include/uapi/linux/pkt_sched.h | 17 ++++++++++
 2 files changed, 67 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index eb0588567cf8..a0a2273d7974 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1033,6 +1033,7 @@ enum bpf_attach_type {
 	BPF_PERF_EVENT,
 	BPF_TRACE_KPROBE_MULTI,
 	BPF_LSM_CGROUP,
+	BPF_STRUCT_OPS,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1108,7 +1109,7 @@ enum bpf_link_type {
  */
 #define BPF_F_STRICT_ALIGNMENT	(1U << 0)
 
-/* If BPF_F_ANY_ALIGNMENT is used in BPF_PROF_LOAD command, the
+/* If BPF_F_ANY_ALIGNMENT is used in BPF_PROG_LOAD command, the
  * verifier will allow any alignment whatsoever.  On platforms
  * with strict alignment requirements for loads ands stores (such
  * as sparc and mips) the verifier validates that all loads and
@@ -1266,6 +1267,9 @@ enum {
 
 /* Create a map that is suitable to be an inner map with dynamic max entries */
 	BPF_F_INNER_MAP		= (1U << 12),
+
+/* Create a map that will be registered/unregesitered by the backed bpf_link */
+	BPF_F_LINK		= (1U << 13),
 };
 
 /* Flags for BPF_PROG_QUERY. */
@@ -1403,6 +1407,11 @@ union bpf_attr {
 		__aligned_u64	fd_array;	/* array of FDs */
 		__aligned_u64	core_relos;
 		__u32		core_relo_rec_size; /* sizeof(struct bpf_core_relo) */
+		/* output: actual total log contents size (including termintaing zero).
+		 * It could be both larger than original log_size (if log was
+		 * truncated), or smaller (if log buffer wasn't filled completely).
+		 */
+		__u32		log_true_size;
 	};
 
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
@@ -1488,6 +1497,11 @@ union bpf_attr {
 		__u32		btf_size;
 		__u32		btf_log_size;
 		__u32		btf_log_level;
+		/* output: actual total log contents size (including termintaing zero).
+		 * It could be both larger than original log_size (if log was
+		 * truncated), or smaller (if log buffer wasn't filled completely).
+		 */
+		__u32		btf_log_true_size;
 	};
 
 	struct {
@@ -1507,7 +1521,10 @@ union bpf_attr {
 	} task_fd_query;
 
 	struct { /* struct used by BPF_LINK_CREATE command */
-		__u32		prog_fd;	/* eBPF program to attach */
+		union {
+			__u32		prog_fd;	/* eBPF program to attach */
+			__u32		map_fd;		/* struct_ops to attach */
+		};
 		union {
 			__u32		target_fd;	/* object to attach to */
 			__u32		target_ifindex; /* target ifindex */
@@ -1548,12 +1565,23 @@ union bpf_attr {
 
 	struct { /* struct used by BPF_LINK_UPDATE command */
 		__u32		link_fd;	/* link fd */
-		/* new program fd to update link with */
-		__u32		new_prog_fd;
+		union {
+			/* new program fd to update link with */
+			__u32		new_prog_fd;
+			/* new struct_ops map fd to update link with */
+			__u32           new_map_fd;
+		};
 		__u32		flags;		/* extra flags */
-		/* expected link's program fd; is specified only if
-		 * BPF_F_REPLACE flag is set in flags */
-		__u32		old_prog_fd;
+		union {
+			/* expected link's program fd; is specified only if
+			 * BPF_F_REPLACE flag is set in flags.
+			 */
+			__u32		old_prog_fd;
+			/* expected link's map fd; is specified only
+			 * if BPF_F_REPLACE flag is set.
+			 */
+			__u32           old_map_fd;
+		};
 	} link_update;
 
 	struct {
@@ -1647,17 +1675,17 @@ union bpf_attr {
  * 	Description
  * 		This helper is a "printk()-like" facility for debugging. It
  * 		prints a message defined by format *fmt* (of size *fmt_size*)
- * 		to file *\/sys/kernel/debug/tracing/trace* from DebugFS, if
+ * 		to file *\/sys/kernel/tracing/trace* from TraceFS, if
  * 		available. It can take up to three additional **u64**
  * 		arguments (as an eBPF helpers, the total number of arguments is
  * 		limited to five).
  *
  * 		Each time the helper is called, it appends a line to the trace.
- * 		Lines are discarded while *\/sys/kernel/debug/tracing/trace* is
- * 		open, use *\/sys/kernel/debug/tracing/trace_pipe* to avoid this.
+ * 		Lines are discarded while *\/sys/kernel/tracing/trace* is
+ * 		open, use *\/sys/kernel/tracing/trace_pipe* to avoid this.
  * 		The format of the trace is customizable, and the exact output
  * 		one will get depends on the options set in
- * 		*\/sys/kernel/debug/tracing/trace_options* (see also the
+ * 		*\/sys/kernel/tracing/trace_options* (see also the
  * 		*README* file under the same directory). However, it usually
  * 		defaults to something like:
  *
@@ -6379,6 +6407,9 @@ struct bpf_link_info {
 		struct {
 			__u32 ifindex;
 		} xdp;
+		struct {
+			__u32 map_id;
+		} struct_ops;
 	};
 } __attribute__((aligned(8)));
 
@@ -7112,4 +7143,12 @@ enum {
 	BPF_F_TIMER_ABS = (1ULL << 0),
 };
 
+/* BPF numbers iterator state */
+struct bpf_iter_num {
+	/* opaque iterator state; having __u64 here allows to preserve correct
+	 * alignment requirements in vmlinux.h, generated from BTF
+	 */
+	__u64 __opaque[1];
+} __attribute__((aligned(8)));
+
 #endif /* __LINUX_BPF_H__ */
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 000eec106856..51a7addc56c6 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -719,6 +719,11 @@ enum {
 
 #define __TC_MQPRIO_SHAPER_MAX (__TC_MQPRIO_SHAPER_MAX - 1)
 
+enum {
+	TC_FP_EXPRESS = 1,
+	TC_FP_PREEMPTIBLE = 2,
+};
+
 struct tc_mqprio_qopt {
 	__u8	num_tc;
 	__u8	prio_tc_map[TC_QOPT_BITMASK + 1];
@@ -732,12 +737,23 @@ struct tc_mqprio_qopt {
 #define TC_MQPRIO_F_MIN_RATE		0x4
 #define TC_MQPRIO_F_MAX_RATE		0x8
 
+enum {
+	TCA_MQPRIO_TC_ENTRY_UNSPEC,
+	TCA_MQPRIO_TC_ENTRY_INDEX,		/* u32 */
+	TCA_MQPRIO_TC_ENTRY_FP,			/* u32 */
+
+	/* add new constants above here */
+	__TCA_MQPRIO_TC_ENTRY_CNT,
+	TCA_MQPRIO_TC_ENTRY_MAX = (__TCA_MQPRIO_TC_ENTRY_CNT - 1)
+};
+
 enum {
 	TCA_MQPRIO_UNSPEC,
 	TCA_MQPRIO_MODE,
 	TCA_MQPRIO_SHAPER,
 	TCA_MQPRIO_MIN_RATE64,
 	TCA_MQPRIO_MAX_RATE64,
+	TCA_MQPRIO_TC_ENTRY,
 	__TCA_MQPRIO_MAX,
 };
 
@@ -1236,6 +1252,7 @@ enum {
 	TCA_TAPRIO_TC_ENTRY_UNSPEC,
 	TCA_TAPRIO_TC_ENTRY_INDEX,		/* u32 */
 	TCA_TAPRIO_TC_ENTRY_MAX_SDU,		/* u32 */
+	TCA_TAPRIO_TC_ENTRY_FP,			/* u32 */
 
 	/* add new constants above here */
 	__TCA_TAPRIO_TC_ENTRY_CNT,
-- 
2.34.1

