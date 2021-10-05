Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C084220C4
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbhJEIcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbhJEIcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 04:32:41 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57801C061760;
        Tue,  5 Oct 2021 01:30:51 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so1819069pjb.5;
        Tue, 05 Oct 2021 01:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i5TQ/GNjv5Hjjqp29xrTfJl5zRBuzrKjJ4+0fxARHB4=;
        b=TEkGbWWht6AFtnUdWjagkEsYiTdhi0l6fWIL/tVtwmpAfaacCiy0nioxisv5i0fns7
         8PxgIKYmB/QK4OZ8uUZObGpADSi01Ww6VU5+ZYbalZuvaa+codryJhKcrt/FbzL//slW
         0SLCp4iUuz+16nupkmImvU3AAyV2t3t46QAhzsM4v8FNQWWClt9zOWhAFUsRUePXAB5r
         5QZVJfzQZ+S0OnaRheMIZEewdyInN5O+QjGpQAkW6ICtzG9OFYbgR7d9lZKJNV1sts59
         uYuGTtixwnk0uBgAXGGsNXO1PfjWL1fj+ts472O7XG2fpRZaUTdSFOCSKjjLKZi3hKMz
         Zhhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i5TQ/GNjv5Hjjqp29xrTfJl5zRBuzrKjJ4+0fxARHB4=;
        b=aYSpidB/D8qY1lPpCiIZFo8mPI5h+taaBidLH9g4Ud6HsC6sxm96kKH1OspobrnX0H
         tQK2li37qN6Sk3I5m2NNpH5snCyGV7uASekl2H0Jrly3+k5N7nmHf6sGT+i9XAcNKIaP
         ZCQdfOVR+3d9HDkkLsYWr0wHTCmR+V3Cpmb+tVDdWeEr5XyGL0VyVBrNuXj+E3Hq4iZe
         TCX49ki4fGJvxSaNOdv80IsUDiAlSdnZ9hSNRQ1wWsKBva25v/OwpVR9havi7/IAA+Wg
         V6wQJcZ7Motl/wiyZJ5vsirJocQYuEQpF2VcgOkDtXD69WkhPAOC36ReG0TpNniKaFT/
         TGbA==
X-Gm-Message-State: AOAM530ZxNfT8Ab9w90GjkdCA8vBK2QlISfeiLiSpMkCknqMCqIXVetf
        ivNq10CtjSJPR3qltBHlu3I=
X-Google-Smtp-Source: ABdhPJzfWZqsHKyOuRjJE94Hjnly/yfdOhN5F1c+IBzYfDEZxI/EMIq65wLlbPIJXgno3w4B9Ssuig==
X-Received: by 2002:a17:90b:a17:: with SMTP id gg23mr2277722pjb.18.1633422650965;
        Tue, 05 Oct 2021 01:30:50 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:78ba:4bcc:a59a:2284])
        by smtp.gmail.com with ESMTPSA id a15sm4941257pfg.53.2021.10.05.01.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 01:30:50 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-mips@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Hassan Naveed <hnaveed@wavecomp.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [RFC PATCH bpf-next v2 06/16] MIPS: eBPF: fix JIT static analysis hang with bounded loops
Date:   Tue,  5 Oct 2021 01:26:50 -0700
Message-Id: <fa42c09f424b93f6b73d6c3ea42a240cb4b4464a.1633392335.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633392335.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com> <cover.1633392335.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for bounded loops allowed the verifier to output backward jumps
such as BPF_JMP_A(-4). These trap the JIT's static analysis in a loop,
resulting in a system hang and eventual RCU stall.

Fix by updating reg_val_propagate_range() to skip backward jumps when in
fallthrough mode and if the jump target has been visited already.

Trigger the bug using the test_verifier test "bounded loop that jumps out
rather than in".

Fixes: 2589726d12a1 ("bpf: introduce bounded loops")
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 arch/mips/net/ebpf_jit.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index 0928d86cb3b0..b8dc6cebefab 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -1693,6 +1693,10 @@ static int reg_val_propagate_range(struct jit_ctx *ctx, u64 initial_rvt,
 				rvt[prog->len] = exit_rvt;
 				return idx;
 			case BPF_JA:
+			{
+				int tgt = idx + 1 + insn->off;
+				bool visited = (rvt[tgt] & RVT_FALL_THROUGH);
+
 				rvt[idx] |= RVT_DONE;
 				/*
 				 * Verifier dead code patching can use
@@ -1702,8 +1706,16 @@ static int reg_val_propagate_range(struct jit_ctx *ctx, u64 initial_rvt,
 				 */
 				if (insn->off == -1)
 					break;
+				/*
+				 * Bounded loops cause the same issues in
+				 * fallthrough mode; follow only if jump
+				 * target is unvisited to mitigate.
+				 */
+				if (insn->off < 0 && !follow_taken && visited)
+					break;
 				idx += insn->off;
 				break;
+			}
 			case BPF_JEQ:
 			case BPF_JGT:
 			case BPF_JGE:
-- 
2.25.1

