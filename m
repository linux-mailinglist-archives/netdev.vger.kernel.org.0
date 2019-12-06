Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB00114A26
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 01:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfLFAND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 19:13:03 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:51985 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725926AbfLFAND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 19:13:03 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 02D8E86B;
        Thu,  5 Dec 2019 19:12:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 05 Dec 2019 19:13:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm2; bh=fz1pVXQGQqPw7fMZqdwqo5yGT8
        GE1PKnAQW+yVWgJV0=; b=q1u3F8rYdcY9H5WwJeAzUeAIOnOQdgJnFD1/QsYJtl
        RRe7oN6YkdxYmKhApiArgPy7VrHHnNarfFFCOPqr9xKBqICMtgwmbEfxs3wLRjXr
        QTfKgBGkX02Ez1hBmUnoxwIdOMGv+b/h/t8NaACHxc8KGUBf76tNaNlNTV02gBDl
        Wr7xLsaFMbmRG35K0//M1oVAPuNlLfPPU/JG1yRn6pVgRaFEIjGE0ovq8hxwTktU
        UVrt6tqjzavkxgsLOfMVpv4huPgxd4nApRtpbMAsO9K1CBPyHfqIYIrIRGmYGHk0
        ZOp+rn6byY2oyvPkYieaYEMfRFu1oKz7Xrp2P4/J47fg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=fz1pVXQGQqPw7fMZq
        dwqo5yGT8GE1PKnAQW+yVWgJV0=; b=OIfCWXxtwLG8CHraktq8HVxWmHQ/5w+1b
        4kDvQIpauZDx7PBkBB9uYhdg8zqh6Paw3VYzzoMJ9FbAErWjQ1qoG2TV/XrsY1Sb
        ZmdCedq9BVr1NTiu2QzUhxVOD5jxp3vQItiF7M45IRot+4kgLbWu6wIKsWGAyhOD
        tnUiQr7IOg7grDfNQLgfQFEExYiyKqs+7bah0WHMGSpbTdKop50A0Jgt89idoAJK
        MvfZ0KOveVpyNVu8vyr0A/ZLbIdunfGhhEM3O8s5tY0c3cXQcbGDXMVUL12DLO5U
        3s0WqSAnPcqupVXEbFvQ32JWDB7y7jsCkLfqxj26wUR+MmqGuf6wg==
X-ME-Sender: <xms:Cp3pXSB3GFN0nGQV23psR1i7PmDGZfYp7d5-8qrsOq8SLrnjprrfNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudekuddgudekfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceougig
    uhesugiguhhuuhdrgiihiieqnecukfhppeejfedrleefrddvgeejrddufeegnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiiinecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:Cp3pXULxqOWGFrErZbggpanLYLVoGbBQ7vtjpUcFLIgZsiYnJI_bOQ>
    <xmx:Cp3pXVwMUUxTaJXi0fbjUIAG_1RyldRUxwhtOCW4aPYzOP0RXXNNCQ>
    <xmx:Cp3pXYzQLuNzgMnkwhVjbKqzeD058bielN2rtsqPA-STQ3x0vdiWVA>
    <xmx:C53pXX7WjExU2RyRdGAcOCp3yy4rM2zesO_T3lICaLJGOzkjcPRvyRxrKg4>
Received: from localhost.localdomain (c-73-93-247-134.hsd1.ca.comcast.net [73.93.247.134])
        by mail.messagingengine.com (Postfix) with ESMTPA id 12F6180065;
        Thu,  5 Dec 2019 19:12:56 -0500 (EST)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, kafai@fb.com,
        songliubraving@fb.com, andriin@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Daniel Xu <dxu@dxuuu.xyz>, peterz@infradead.org, mingo@redhat.com,
        acme@kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf] bpf: Add LBR data to BPF_PROG_TYPE_PERF_EVENT prog context
Date:   Thu,  5 Dec 2019 16:12:26 -0800
Message-Id: <20191206001226.67825-1-dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Last-branch-record is an intel CPU feature that can be configured to
record certain branches that are taken during code execution. This data
is particularly interesting for profile guided optimizations. perf has
had LBR support for a while but the data collection can be a bit coarse
grained.

We (Facebook) have recently run a lot of experiments with feeding
filtered LBR data to various PGO pipelines. We've seen really good
results (+2.5% throughput with lower cpu util and lower latency) by
feeding high request latency LBR branches to the compiler on a
request-oriented service. We used bpf to read a special request context
ID (which is how we associate branches with latency) from a fixed
userspace address. Reading from the fixed address is why bpf support is
useful.

Aside from this particular use case, having LBR data available to bpf
progs can be useful to get stack traces out of userspace applications
that omit frame pointers.

This patch adds support for LBR data to bpf perf progs.

Some notes:
* We use `__u64 entries[BPF_MAX_LBR_ENTRIES * 3]` instead of
  `struct perf_branch_entry[BPF_MAX_LBR_ENTRIES]` because checkpatch.pl
  warns about including a uapi header from another uapi header

* We define BPF_MAX_LBR_ENTRIES as 32 (instead of using the value from
  arch/x86/events/perf_events.h) because including arch specific headers
  seems wrong and could introduce circular header includes.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 include/uapi/linux/bpf_perf_event.h |  5 ++++
 kernel/trace/bpf_trace.c            | 39 +++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/uapi/linux/bpf_perf_event.h b/include/uapi/linux/bpf_perf_event.h
index eb1b9d21250c..dc87e3d50390 100644
--- a/include/uapi/linux/bpf_perf_event.h
+++ b/include/uapi/linux/bpf_perf_event.h
@@ -10,10 +10,15 @@
 
 #include <asm/bpf_perf_event.h>
 
+#define BPF_MAX_LBR_ENTRIES 32
+
 struct bpf_perf_event_data {
 	bpf_user_pt_regs_t regs;
 	__u64 sample_period;
 	__u64 addr;
+	__u64 nr_lbr;
+	/* Cast to struct perf_branch_entry* before using */
+	__u64 entries[BPF_MAX_LBR_ENTRIES * 3];
 };
 
 #endif /* _UAPI__LINUX_BPF_PERF_EVENT_H__ */
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ffc91d4935ac..96ba7995b3d7 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1259,6 +1259,14 @@ static bool pe_prog_is_valid_access(int off, int size, enum bpf_access_type type
 		if (!bpf_ctx_narrow_access_ok(off, size, size_u64))
 			return false;
 		break;
+	case bpf_ctx_range(struct bpf_perf_event_data, nr_lbr):
+		bpf_ctx_record_field_size(info, size_u64);
+		if (!bpf_ctx_narrow_access_ok(off, size, size_u64))
+			return false;
+		break;
+	case bpf_ctx_range(struct bpf_perf_event_data, entries):
+		/* No narrow loads */
+		break;
 	default:
 		if (size != sizeof(long))
 			return false;
@@ -1273,6 +1281,7 @@ static u32 pe_prog_convert_ctx_access(enum bpf_access_type type,
 				      struct bpf_prog *prog, u32 *target_size)
 {
 	struct bpf_insn *insn = insn_buf;
+	int off;
 
 	switch (si->off) {
 	case offsetof(struct bpf_perf_event_data, sample_period):
@@ -1291,6 +1300,36 @@ static u32 pe_prog_convert_ctx_access(enum bpf_access_type type,
 				      bpf_target_off(struct perf_sample_data, addr, 8,
 						     target_size));
 		break;
+	case offsetof(struct bpf_perf_event_data, nr_lbr):
+		/* Load struct perf_sample_data* */
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_perf_event_data_kern,
+						       data), si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_perf_event_data_kern, data));
+		/* Load struct perf_branch_stack* */
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct perf_sample_data, br_stack),
+				      si->dst_reg, si->dst_reg,
+				      offsetof(struct perf_sample_data, br_stack));
+		/* Load nr */
+		*insn++ = BPF_LDX_MEM(BPF_DW, si->dst_reg, si->dst_reg,
+				      bpf_target_off(struct perf_branch_stack, nr, 8,
+						     target_size));
+		break;
+	case bpf_ctx_range(struct bpf_perf_event_data, entries):
+		off = si->off;
+		off -= offsetof(struct bpf_perf_event_data, entries);
+
+		/* Load struct perf_sample_data* */
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_perf_event_data_kern,
+						       data), si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_perf_event_data_kern, data));
+		/* Load struct perf_branch_stack* */
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct perf_sample_data, br_stack),
+				      si->dst_reg, si->dst_reg,
+				      offsetof(struct perf_sample_data, br_stack));
+		/* Load requested memory */
+		*insn++ = BPF_LDX_MEM(BPF_SIZE(si->code), si->dst_reg, si->dst_reg,
+				      offsetof(struct perf_branch_stack, entries) + off);
+		break;
 	default:
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_perf_event_data_kern,
 						       regs), si->dst_reg, si->src_reg,
-- 
2.24.0

