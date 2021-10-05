Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473C74220CD
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhJEIdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbhJEIdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 04:33:13 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2028C061745;
        Tue,  5 Oct 2021 01:31:23 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id np13so3526493pjb.4;
        Tue, 05 Oct 2021 01:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0vOpPFSSAKxNlwx3QHOSMlCuTCb3URMfQFvAF0txKJ4=;
        b=CfosujBa/4JwNAB8WcZDL/oa/QlmnyT8I+zR9lRan+iLW2TMdNkMW3s3maB8L4GkZ7
         i5rVx9vwpn5Vw+ri0rIygne4doaqrWMQ8RmnIPVIFVAVz0J2NzpYalFPAKmZEHFFs7l7
         fg/AzWdjAs4xDMnyvctFyhbSC1sm8SZyZJqpdgM3wDJeoEmYdeSlJJJGo3pYil3ZiSNG
         +CLkW6cAvgtdQf2SsvmEaZrjtqhv/UBeU3BE/iayKFJl4PeicV4Wtjtl2wKOVmb8cAo7
         7WoyqYX6+ykdeq8nb6ftXrL78LQ6d9FCnCDov9IRbkoeqZKaQyE0RSYnv8d/SEqlYYBw
         9emQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0vOpPFSSAKxNlwx3QHOSMlCuTCb3URMfQFvAF0txKJ4=;
        b=J6WNAGon8DqFrgmHOClGAlEmKOfYAUo9sWaQj+elMBaovQVPkvhmQXXMe3gSXv1c89
         BXNpaCShM26EofLG0GY6KuSt+K2txut9G6D7W+dRVS1GSMQ9GP9aNUThd58JutEeZWvM
         NgZdPL4wFfuMLKkh8/+PmHjR5iiaVa0PzgOiD3hFzjfyk/2DjaeNA958iYP2TzzbOALm
         V3RqnnhfdIFIy6fjGKcGxMD+e0bHQ/Rd+n+QaB+edmAhcukrhtI9u7JYIqACmPqkbEHz
         SCPGc/nha3/BORm/X2XpwL3Ml4bUJxQqEitrmnrEoW9IdR//BXemav66eVh3zg84LvdC
         YnPg==
X-Gm-Message-State: AOAM5330itpkoZNVuPKlFC8LMTDEi8x2iXvatlWShbjoJiaLwkpl0IFM
        WooDM8UJxV8Zz3HXdhe0GJ0=
X-Google-Smtp-Source: ABdhPJz+TUhiFSR80/1njDH7LkPnLoejQesZP+h3Qfm7y4T9y3JAEeFkgTki3zQ/Oja4FjPstU9HRA==
X-Received: by 2002:a17:90a:4a04:: with SMTP id e4mr2247240pjh.51.1633422683340;
        Tue, 05 Oct 2021 01:31:23 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:78ba:4bcc:a59a:2284])
        by smtp.gmail.com with ESMTPSA id a15sm4941257pfg.53.2021.10.05.01.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 01:31:23 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next v2 09/16] MIPS: eBPF: drop src_reg restriction in BPF_LD|BPF_DW|BPF_IMM
Date:   Tue,  5 Oct 2021 01:26:53 -0700
Message-Id: <eeefbbe7ca50b6553eea32bbee08e70fcc25e9c8.1633392335.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633392335.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com> <cover.1633392335.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop enforcing (insn->src_reg == 0) and allow special verifier insns such
as "BPF_LD_MAP_FD(BPF_REG_2, 0)", used to refer to a process-local map fd
and introduced in 0246e64d9a5f ("bpf: handle pseudo BPF_LD_IMM64 insn").

This is consistent with other JITs such as riscv32 and also used by
test_verifier (e.g. "runtime/jit: tail_call within bounds, prog once").

Fixes: b6bd53f9c4e8 ("MIPS: Add missing file for eBPF JIT.")
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 arch/mips/net/ebpf_jit.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index 7252cd44ff63..7fbd4e371c80 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -1303,8 +1303,6 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		emit_instr(ctx, nop);
 		break;
 	case BPF_LD | BPF_DW | BPF_IMM:
-		if (insn->src_reg != 0)
-			return -EINVAL;
 		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
 		if (dst < 0)
 			return dst;
-- 
2.25.1

