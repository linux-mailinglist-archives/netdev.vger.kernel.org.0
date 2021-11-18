Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F1345641F
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 21:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbhKRUcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 15:32:04 -0500
Received: from mail-mw2nam12on2041.outbound.protection.outlook.com ([40.107.244.41]:13192
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233895AbhKRUb6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 15:31:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0hMj4rk06u/kij7N+os4PjyJFKO0l2DDhi5mbOxJUbuJxj+zg+HDAJw3g0j8O2agYudK9qNnxPBleAO57OJgIisjLf/MNKDCtcyV3CHWAHJpJV9VfCbyhIeV9ZerCeS/mIGLEw3q4Vm17nicVpfNo+c6nUR0jZjH+UUzrAAj1MDLnzaBhwHFFq+KbKqjTV/FbnLbr12ccy98fCTg7QGdkfMdRQzFLAwcuzLN0s6OIrirTbgVGwthw0Q94C5L5+lUJDhqCLJnQNsKFVoqSi9rUn86CkHi8LKBoEXXPSHzeDGBXp6o4uzltBYpET4vH7MAG12h32SM0aLYpiS8q02Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zNMAi1WdxhVnAKx+riu3QqHHlJ+TKfyDHX8K1xNetEE=;
 b=fQy7+xyB7cSLNE4tB2FR9ky0LQRTiYLsdg0B4D4Vgvmnl9Lru5Uoq7Sz4IErmBZ8swEfzBmP/WZqwkZ/JMc4u9+M4a+H/s5C14ng+z698AUMr/yPRkUjs5u36h4Q9DxFw7Kkc/fQRvN/awINscJ8OjNsNdOb6yGrZVcu+d/6lPmZwI4pt0bEbvTrf80r+Fh4ilhd1StXC0BlyQnXmyPjtJPi0u9mdm4eKih9vj7jduwN6Rh1GIxmpdh1vKrFnoyQXxbNJq+7TfPR1rshHbKlOY4482mdmW0h+PCAAEPJIwjpEmWho/YVxZSAbx9yscgEI6LiGDGj5W4IhzyJLf24ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNMAi1WdxhVnAKx+riu3QqHHlJ+TKfyDHX8K1xNetEE=;
 b=5TqTqCfvd+8BmSaBqAPtukxZWjL5/LDuG2DsrNn11en8iKpMDJY2dgGjheSYYcQ5mgPbIkzeyUDWnglQQNw0doP33el4b8S8+KtixeXTdAJgalyL3mpPGedVvJwCEfMeMBWhB7XYu3BHoWRMeE5gX/vvgTNnggdRXoRH2BQ4hVU=
Received: from BN9PR03CA0249.namprd03.prod.outlook.com (2603:10b6:408:ff::14)
 by DM4PR12MB5165.namprd12.prod.outlook.com (2603:10b6:5:394::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Thu, 18 Nov
 2021 20:28:55 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::9b) by BN9PR03CA0249.outlook.office365.com
 (2603:10b6:408:ff::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend
 Transport; Thu, 18 Nov 2021 20:28:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4713.20 via Frontend Transport; Thu, 18 Nov 2021 20:28:54 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 18 Nov
 2021 14:28:54 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 18 Nov
 2021 12:28:54 -0800
Received: from yuho-dev.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 18 Nov 2021 14:28:52 -0600
From:   Kenny Ho <Kenny.Ho@amd.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        "Johannes Weiner" <hannes@cmpxchg.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Ingo Molnar" <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        "Namhyung Kim" <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <y2kenny@gmail.com>, <Kenny.Ho@amd.com>,
        <amd-gfx@lists.freedesktop.org>
Subject: [PATCH RFC 3/4] bpf,cgroup,tracing: add new BPF_PROG_TYPE_CGROUP_TRACEPOINT
Date:   Thu, 18 Nov 2021 15:28:39 -0500
Message-ID: <20211118202840.1001787-4-Kenny.Ho@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211118202840.1001787-1-Kenny.Ho@amd.com>
References: <20211118202840.1001787-1-Kenny.Ho@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 395f279e-781e-4e25-18a4-08d9aad20aaf
X-MS-TrafficTypeDiagnostic: DM4PR12MB5165:
X-Microsoft-Antispam-PRVS: <DM4PR12MB51655D5738C6801CA20BCB3E839B9@DM4PR12MB5165.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:792;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xmy7P12GEdvXiwAcGgcttINUgXRCHwWPK9L3Cx2TE21hc9kQ1bjueMkH/4X7Ow+qOb9m4S4iJAhLVh+ro52meoV4Tov90msY0Pm0JgcorIwu2svw1jQQKdWwq4jOiPzdz/tUuq5JzOg40rPRWbIT9QJrj3fUzqy8D41N4scFWDzB/kPa02PYMTFjiqcY7aaa2xOqAgahuivaUAYN3X/cPy7VNAH6s2Qq9pyXib7sTdJ8u0JIerE4Nv90Qt6GJqUs8v7ywclNPsot0ki6YTgxzPsJi5xyiWL4SrafZbGtFMSXVLuVSjCwWOnkjq0Wx4EqATnhlIRKPkgPN0107xEfPimPKznk8uy92Vef64sNAts1Mnj2FWaKaPZdKRSzltjH+U27bdSPjfI7wRe1kPqlSTLmdWSsjHMpEsEyimuMUSM7LZVWSVr8xLTIcfiL0+7tl97eX/6J0lD+kho8gBl9bjeew9wPRM6Fbd1x7JbGGucWUa91wuLZjArkY2YMkkV4d105JQHR4cEos8EKFEOzQVHacDlA79tmCijMZvUf9/rZ3wARz+56MTZPDEpbB0GwI7UC1XjwpBaitxFJK6ZVIjPgewVJuNUkNuOR8X/2JfM8eTrMy3McuHru3hD4idcthXuBpgsmLO6TMt31muNgdqYN/8PnAtYCC1OKSHgO1Uhm0dhMh/9Ul1fgOlDLbjT9j6HGsud5WVFGkJWXVSuacZu82bJKVIgavJ7afUFeUqJJxqNwgtzfq7UtWSYiv63S
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(81166007)(921005)(316002)(6666004)(110136005)(186003)(2906002)(36756003)(26005)(2616005)(36860700001)(336012)(7416002)(82310400003)(83380400001)(5660300002)(356005)(86362001)(8676002)(1076003)(7696005)(426003)(47076005)(70206006)(508600001)(70586007)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 20:28:54.8297
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 395f279e-781e-4e25-18a4-08d9aad20aaf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5165
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change-Id: Ic9727186bb8c76c757e48635143b16e607f2299f
Signed-off-by: Kenny Ho <Kenny.Ho@amd.com>
---
 include/linux/bpf-cgroup.h | 2 ++
 include/linux/bpf_types.h  | 4 ++++
 include/uapi/linux/bpf.h   | 2 ++
 kernel/bpf/syscall.c       | 4 ++++
 kernel/trace/bpf_trace.c   | 8 ++++++++
 5 files changed, 20 insertions(+)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 2746fd804216..a5e4d9b19470 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -48,6 +48,7 @@ enum cgroup_bpf_attach_type {
 	CGROUP_INET4_GETSOCKNAME,
 	CGROUP_INET6_GETSOCKNAME,
 	CGROUP_INET_SOCK_RELEASE,
+	CGROUP_TRACEPOINT,
 	MAX_CGROUP_BPF_ATTACH_TYPE
 };
 
@@ -81,6 +82,7 @@ to_cgroup_bpf_attach_type(enum bpf_attach_type attach_type)
 	CGROUP_ATYPE(CGROUP_INET4_GETSOCKNAME);
 	CGROUP_ATYPE(CGROUP_INET6_GETSOCKNAME);
 	CGROUP_ATYPE(CGROUP_INET_SOCK_RELEASE);
+	CGROUP_ATYPE(CGROUP_TRACEPOINT);
 	default:
 		return CGROUP_BPF_ATTACH_TYPE_INVALID;
 	}
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 9c81724e4b98..c108f498a35e 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -57,6 +57,10 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SYSCTL, cg_sysctl,
 BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SOCKOPT, cg_sockopt,
 	      struct bpf_sockopt, struct bpf_sockopt_kern)
 #endif
+#if defined (CONFIG_BPF_EVENTS) && defined (CONFIG_CGROUP_BPF)
+BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_TRACEPOINT, cg_tracepoint,
+	      __u64, u64)
+#endif
 #ifdef CONFIG_BPF_LIRC_MODE2
 BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2,
 	      __u32, u32)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6fc59d61937a..014ffaa3fc2a 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -949,6 +949,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
 	BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
+	BPF_PROG_TYPE_CGROUP_TRACEPOINT,
 };
 
 enum bpf_attach_type {
@@ -994,6 +995,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT,
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
+	BPF_CGROUP_TRACEPOINT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4e50c0bfdb7d..d77598fa4eb2 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2149,6 +2149,7 @@ static bool is_perfmon_prog_type(enum bpf_prog_type prog_type)
 	case BPF_PROG_TYPE_LSM:
 	case BPF_PROG_TYPE_STRUCT_OPS: /* has access to struct sock */
 	case BPF_PROG_TYPE_EXT: /* extends any prog */
+	case BPF_PROG_TYPE_CGROUP_TRACEPOINT:
 		return true;
 	default:
 		return false;
@@ -3137,6 +3138,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 		return BPF_PROG_TYPE_SK_LOOKUP;
 	case BPF_XDP:
 		return BPF_PROG_TYPE_XDP;
+	case BPF_CGROUP_TRACEPOINT:
+		return BPF_PROG_TYPE_CGROUP_TRACEPOINT;
 	default:
 		return BPF_PROG_TYPE_UNSPEC;
 	}
@@ -3189,6 +3192,7 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
+	case BPF_PROG_TYPE_CGROUP_TRACEPOINT:
 	case BPF_PROG_TYPE_SOCK_OPS:
 		ret = cgroup_bpf_prog_attach(attr, ptype, prog);
 		break;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 8addd10202c2..4ad864a4852a 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1798,6 +1798,14 @@ const struct bpf_verifier_ops perf_event_verifier_ops = {
 const struct bpf_prog_ops perf_event_prog_ops = {
 };
 
+const struct bpf_verifier_ops cg_tracepoint_verifier_ops = {
+	.get_func_proto  = tp_prog_func_proto,
+	.is_valid_access = tp_prog_is_valid_access,
+};
+
+const struct bpf_prog_ops cg_tracepoint_prog_ops = {
+};
+
 static DEFINE_MUTEX(bpf_event_mutex);
 
 #define BPF_TRACE_MAX_PROGS 64
-- 
2.25.1

