Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68BA34220C1
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbhJEIci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbhJEIce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 04:32:34 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4E0C061760;
        Tue,  5 Oct 2021 01:30:44 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id u7so16739932pfg.13;
        Tue, 05 Oct 2021 01:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0qfPr+t/+gvCFeroYYa6+cQZP2abmSI5vv080z1ELL4=;
        b=O0n8t2sTB1QY2tNqoK3WMNgRGHTfcpwbjiBUjvCP3PMXTK56gk1+ScMSupxUaZOQVy
         iOof4U78vD9QnNGxO0DyQM7d3vqp5AeiJiaq/baAWiEM8yuIoYpClTyWMsG6c0y5U6bf
         9v2qOUkqPDs+8m6KzBP1Wqn5ZSZq7Lq+nYVOQ1kWHZMcWp2Pe9irg+OfqMty4owzILHM
         Wnzk4evor8JKaTUkvSGW44OkTA29/uGyHCV8r76dYIYnsdJuJK8TyIDt6dMHq5L5MUbe
         vruikwMpFVHhiCNKqt1jEaofPv/Q5UTH4zF76V0ZHOY5cXcI9T/oI2fgT/cBsa7SQAGL
         hs/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0qfPr+t/+gvCFeroYYa6+cQZP2abmSI5vv080z1ELL4=;
        b=JdKoJWG8LYy+9TXrz4U8KCSyJUYPb1WINep4OBLiUz9Nu6EXmXzKvasXqCpFGaIZ/O
         /KZjQYa+HPFziegDKkD0lYpZ5gLYUaP6A1X8xkL40mr0XEunLnV0wErElWBq1PZDMGnG
         j+AMGaItYuEuscKn3cz+yfXDTZBM9q6ALK8O4jfUwyfddVvMpz4VbFS+FP7xApCUvuSg
         Jb/6+MQEL9f1dNYGAWZ6/36TK7/yz7PznIt8KZ5dDAA2TgwZKAxtVxS9mUcQ6mLQ35H5
         vcNl46vdvFrvc2grbfieTDk8fy3yCVVzHJSBzkdhiol0R1Zhq8guXcU5vYUDQ6QpCInb
         ztaA==
X-Gm-Message-State: AOAM531ifiZRXmdOqC9olGHTHLqn3IN/W9AmWceHLaSwTjF3vZJpuGgM
        NTGslCfeR/dz36Yti49NV7U=
X-Google-Smtp-Source: ABdhPJw+PHqLUKzhmcgXiLynAZiC4lepD11qnAgaBvzWHaTQNcFxJ9B3/wT772P03lgTTaZUIsT8VA==
X-Received: by 2002:a62:3881:0:b0:44b:6639:6c20 with SMTP id f123-20020a623881000000b0044b66396c20mr29442728pfa.78.1633422643878;
        Tue, 05 Oct 2021 01:30:43 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:78ba:4bcc:a59a:2284])
        by smtp.gmail.com with ESMTPSA id a15sm4941257pfg.53.2021.10.05.01.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 01:30:43 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next v2 05/16] MIPS: eBPF: fix system hang with verifier dead-code patching
Date:   Tue,  5 Oct 2021 01:26:49 -0700
Message-Id: <97887c36e932374626a3022f5d84e527414d106c.1633392335.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633392335.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com> <cover.1633392335.git.Tony.Ambardar@gmail.com>
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
index dbde5d6eefa6..0928d86cb3b0 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -1694,6 +1694,14 @@ static int reg_val_propagate_range(struct jit_ctx *ctx, u64 initial_rvt,
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

