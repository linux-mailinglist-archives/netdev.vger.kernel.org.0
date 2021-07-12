Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E963C407D
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 02:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbhGLAid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 20:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbhGLAiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 20:38:25 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED53C0613E9;
        Sun, 11 Jul 2021 17:35:36 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 62so16506067pgf.1;
        Sun, 11 Jul 2021 17:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i+Gabeg7gBRlgfLEH6jm47+oAGtcKCXKDUoYmp14LZk=;
        b=f71Qw1xyigLXDaFJo/m7+YMnVEcTiHPENXPAj/xcWL8vIHRy/0VbpzrlKFkQqF4GoV
         hEYhe5AtLucPFJtN6Lij3yrgGSiqwhdSYHzZELWCfOu/mP/t5oZV7zZ7D2GC2N2+mDC1
         p+b0O88B1qK3WYQH5o0r6KkTi3y3ggxTzdhzePSohUmMq9ZuT+XlEaEMd3KbwOrMsOqA
         woF2HWyWDqEhnG9OZ8f5OO0eMgO2CoareYbAiDs/OVEXcVkrv58Xo4flwkI96o5uf4Wg
         lkQDvnm7paD/mfZjM0VulRyhY26zf/bR25NhX/jJIdYDHyHq3MkafP9c2zXcoTbp62MC
         pg3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i+Gabeg7gBRlgfLEH6jm47+oAGtcKCXKDUoYmp14LZk=;
        b=CxfIPfHrzW+nZx6Ls3o++ORIyW2IBRxh1uackupcVWK+s/L1zM8UZLC7Wqvxei/riU
         Pvro+R0XBYXVSMQ+VT6lHOjdACefbM9PQCAEuQhyVKGLQiQjQvWFgOLbvHA64AQG3Y7x
         KNzlEC9/tKjzSKRFDC3WSf7C2ViCwNbcNU0zTLh2JUrUt9L7PNicWZU0GZl5N5u+GybZ
         lE6AE+0DAql5X9WO3R+NtRtrkmlgMsaiWvnqTV6N7EiE4e/TIR13qhN42Y075t2TgC+j
         45Joa5GQLUBLMqmxJ534MFywUh2foDA/fZGGzGhl/06qGnTFBq5CcgF2qIiXOFwXAwL8
         tkAw==
X-Gm-Message-State: AOAM5322UrjuAsolzdDOI/9GamVdkTowwDS3HoXwSH8qgjej4xjG7rvJ
        1KWHPPMfal54IP8CqV9xRn4=
X-Google-Smtp-Source: ABdhPJywamGR/Ym0qxdUshaPf4U0mClZS9ejbnhwFzUXqUkIWQWSFYHb+lehOW9cCG2SPg/mi7L0KA==
X-Received: by 2002:aa7:8112:0:b029:328:70bc:3307 with SMTP id b18-20020aa781120000b029032870bc3307mr18193320pfi.67.1626050136575;
        Sun, 11 Jul 2021 17:35:36 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:4039:6c0e:1168:cc74])
        by smtp.gmail.com with ESMTPSA id c24sm15588447pgj.11.2021.07.11.17.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 17:35:36 -0700 (PDT)
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
        Hassan Naveed <hnaveed@wavecomp.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [RFC PATCH bpf-next v1 08/14] MIPS: eBPF: support long jump for BPF_JMP|EXIT
Date:   Sun, 11 Jul 2021 17:34:54 -0700
Message-Id: <068c7d433d5ca78e791827f93275474fec64ef6d.1625970384.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625970383.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com>
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
index e8c403c6cfa3..f510c692975e 100644
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

