Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A754220CA
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbhJEIdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbhJEIdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 04:33:06 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F3CC061745;
        Tue,  5 Oct 2021 01:31:15 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id l6so1808276plh.9;
        Tue, 05 Oct 2021 01:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AF+nX8jdqSnU6pR8M/rTaNNAOHPmdiA0ekgYVMAQg7U=;
        b=VuWemK4OU4D/CDs2SLRYR8s2Vou6A3r15u9bTN2BBh4Hdqah6uEWajAXp4Y5wfK4R5
         1Df6KCYU8g+PxcFOLMaOs/v3H1SdG91JfrE9+3zDqldvS3OleKR2sKYu8J4L9ooyWE8N
         0Mqmq008yZapjhwfraTFU8bzdRSDTyD3IpIe2ISFYvDh/DR+uUAYdTkF+6rNfNWZnTFu
         KWWjwZs62SpXdZmI+gEDZRw9WSUn4cyQsuoOTIoZTN+4nwmgkkb6gsHkJ2R+y5fO0duG
         V9URrQxc7PI2LMkXgVTow9BYHLcIYP0ODBI3kIyqvAwcJRCTjcahOnPHB96pYk1sU/vw
         BhuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AF+nX8jdqSnU6pR8M/rTaNNAOHPmdiA0ekgYVMAQg7U=;
        b=PsaalxM3FscRvYmavqqeCtMhoYYfTQY7OWMdFlyp6yheMwZVTeRvi5bM0RAr52PAxw
         c7cilt3hbpHMkqtojFU0aBWLPsG0hLMUtjRyRIlP2vRHB54wAnXBC5TYeUtncsRls+xl
         Tk/d6+Cd3/XMp1oQ7Z5WJ+RfoYveoFMzKIzdTr7K9QgVSx2ZO0JfqjpUDxQNCf3RxvWJ
         gbByMCr1toZkvX98mP6+qtcivPdjSPMPRy31nL2Obv3FcTV51ML1vrqUjI+NXNo4zDqN
         5W/XQhd4RITHbZ9DVdhAsM0X+cNwbXecNKAioyQbDHPdrbz+7AsS5K9vP1XtFgW5vnHN
         xnGw==
X-Gm-Message-State: AOAM532E0diGaIzgTRPJQXIicaBMiLlAaM7oLaZdaNQzdbMR1hunrb8C
        DQT5M3ROOTbuTkk8u3Y07u8=
X-Google-Smtp-Source: ABdhPJyj+7wBDt83NXZwPR2zsCsc5Ncr8NwQgxrP/zDbR5bWN/UxB9GvDiYMcxeGmYzH1bdCSHBg1w==
X-Received: by 2002:a17:90a:9f91:: with SMTP id o17mr2268834pjp.225.1633422675254;
        Tue, 05 Oct 2021 01:31:15 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:78ba:4bcc:a59a:2284])
        by smtp.gmail.com with ESMTPSA id a15sm4941257pfg.53.2021.10.05.01.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 01:31:14 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next v2 08/16] MIPS: eBPF: support long jump for BPF_JMP|EXIT
Date:   Tue,  5 Oct 2021 01:26:52 -0700
Message-Id: <8f7207410035a7d2b1f5e0d87695880313f5adf6.1633392335.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633392335.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com> <cover.1633392335.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Existing JIT code supports only short (18-bit) branches for BPF EXIT, and
results in some tests from module test_bpf not being jited. Update code
to fall back to long (28-bit) jumps if short branches are insufficient.

Before:
  test_bpf: #296 BPF_MAXINSNS: exec all MSH jited:0 1556004 PASS
  test_bpf: #297 BPF_MAXINSNS: ld_abs+get_processor_id jited:0 824957 PASS
  test_bpf: Summary: 378 PASSED, 0 FAILED, [364/366 JIT'ed]

After:
  test_bpf: #296 BPF_MAXINSNS: exec all MSH jited:1 221998 PASS
  test_bpf: #297 BPF_MAXINSNS: ld_abs+get_processor_id jited:1 490507 PASS
  test_bpf: Summary: 378 PASSED, 0 FAILED, [366/366 JIT'ed]

Fixes: b6bd53f9c4e8 ("MIPS: Add missing file for eBPF JIT.")
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 arch/mips/net/ebpf_jit.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index 00dc20bc0def..7252cd44ff63 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -994,9 +994,14 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_JMP | BPF_EXIT:
 		if (this_idx + 1 < exit_idx) {
 			b_off = b_imm(exit_idx, ctx);
-			if (is_bad_offset(b_off))
-				return -E2BIG;
-			emit_instr(ctx, beq, MIPS_R_ZERO, MIPS_R_ZERO, b_off);
+			if (is_bad_offset(b_off)) {
+				target = j_target(ctx, exit_idx);
+				if (target == (unsigned int)-1)
+					return -E2BIG;
+				emit_instr(ctx, j, target);
+			} else {
+				emit_instr(ctx, b, b_off);
+			}
 			emit_instr(ctx, nop);
 		}
 		break;
-- 
2.25.1

