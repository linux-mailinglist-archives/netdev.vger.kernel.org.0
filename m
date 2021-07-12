Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4B93C4078
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 02:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhGLAic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 20:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbhGLAiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 20:38:22 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A866FC0613DD;
        Sun, 11 Jul 2021 17:35:33 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id v7so16488178pgl.2;
        Sun, 11 Jul 2021 17:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EalCyecMW2572H9VkyfBPRqHeeHC2CH2d/QT1GKpwg8=;
        b=IxkDm8adSbqtlwlgLCgDUo/NkLyJX1d3cErtYIdhRp2jaFasDIrnFLpNHvUxis3oh1
         UPRVgcXYwvFHHFALsBhFld5paL+DhSm+ZauQUaD1sjZvl4kbSLf3BBZzrQqLQn2d/hmH
         kSeK6xqeAUywe+dXEfGmBApHKOtUvxNrXmgPbFwCSh4GG+QXOmc34TYSoeNTFGFReDzR
         iQAOK0zVMSt+w854SWzCucGf7R2KPoVvkw3Wj4skqnXpI8W1rIsypl9++rShBcOXQwvp
         e9sFVctgLtf6h49qhJgtNl7xYvwCoYP2Yf90niANP2qOBUYl4TYzIB8L5OSha9AErbZO
         4CnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EalCyecMW2572H9VkyfBPRqHeeHC2CH2d/QT1GKpwg8=;
        b=R1/P9wFXB/mwXeu3N1OocTsu1jpYjQakAwpSavO5Na8I0iwc38oaLa19HPZvBO4jdM
         EXD3ggULcHr/r60Q5O4BCqrva4WMJU1bc4UibMzbGoQgBjrP+gm/w8R9WfjWtGLo9Axh
         i+L0lvwvXesQc5jVBXPzdWq+36PyfpfTyxc92aWyul7gyRx+WxAEcHjqEPZNv1O2PwwV
         c1Y76zZZyNoIbcwrUR7ugqB8pimbNFBbFsFlVEo/4Q5TgS1YDrZMJkZ02rv1HpOgdZiE
         GP1z2D/pMjKs3x5fAnC9uR9pa2H72qFInesKjAzR8jM/WTkXmeA74x8EBMl2F8rBqTPV
         ZAFQ==
X-Gm-Message-State: AOAM530xweC8R4LfKWPS3MwQscpGzFOGvfJ2m/zvHV2VZED2E0h6O6Eb
        paWsXd5N4DV6V9XlfrR9+vg=
X-Google-Smtp-Source: ABdhPJwlhW+6BbknidrHJtpLhO+5/xNKE9xfj4mRa+aQVwFpEp8XjIsJAGJckvT9u5fZegcdfEgtAQ==
X-Received: by 2002:a62:3344:0:b029:24c:735c:4546 with SMTP id z65-20020a6233440000b029024c735c4546mr50583458pfz.1.1626050133301;
        Sun, 11 Jul 2021 17:35:33 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:4039:6c0e:1168:cc74])
        by smtp.gmail.com with ESMTPSA id c24sm15588447pgj.11.2021.07.11.17.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 17:35:33 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next v1 05/14] MIPS: eBPF: fix system hang with verifier dead-code patching
Date:   Sun, 11 Jul 2021 17:34:51 -0700
Message-Id: <9d192df017fd2fb79030477508e7de88f21c6b4e.1625970384.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625970383.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2a5418a13fcf changed verifier dead code handling from patching with
NOPs to using a loop trap made with BPF_JMP_IMM(BPF_JA, 0, 0, -1). This
confuses the JIT static analysis, which follows the loop assuming the
verifier passed safe code, and results in a system hang and RCU stall.
Update reg_val_propagate_range() to fall through these trap insns.

Trigger the bug using test_verifier "check known subreg with unknown reg".

Fixes: 2a5418a13fcf ("bpf: improve dead code sanitizing")
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 arch/mips/net/ebpf_jit.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index ad0e54a842fc..e60a089ee3b3 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -1691,6 +1691,14 @@ static int reg_val_propagate_range(struct jit_ctx *ctx, u64 initial_rvt,
 				return idx;
 			case BPF_JA:
 				rvt[idx] |= RVT_DONE;
+				/*
+				 * Verifier dead code patching can use
+				 * infinite-loop traps, causing hangs and
+				 * RCU stalls here. Treat traps as nops
+				 * if detected and fall through.
+				 */
+				if (insn->off == -1)
+					break;
 				idx += insn->off;
 				break;
 			case BPF_JEQ:
-- 
2.25.1

