Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8143C4082
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 02:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhGLAii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 20:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbhGLAi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 20:38:26 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86FFC0613EE;
        Sun, 11 Jul 2021 17:35:37 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id w15so16459308pgk.13;
        Sun, 11 Jul 2021 17:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xV2HdIRH4UfRrAHXN/H9DTR/2ZGLXLPOFFF8iUGihdI=;
        b=iqGS6jwOogU85vAVz7EzI0ONnzoVCWpt1kgujjjWx61sWmyIA5vYT/NRuvRzjIPHE7
         tLq66ltpEdsOMDVjdrL6OtHPfggRcmn8sdzW9n0ZxoLwq+3OxNBcVxAe0N+GUKYDcOYo
         wIVG1yf4GlQXQlT0w+xPAcRgl/2LHvHAr5hCzwzzWbaGEvpaGD6xZLUMvOGxYQtr71IO
         bJuilMU5bvtxsqCIFMOveMUdrtlbm9l53CJ7LWwqvqFvgRSVsLq8XJTEAsFf9zoAibHM
         4KbDb4IV36q06RYdvRULfBIC9p34CeIOP8/+50LZAf4W8b5YZ8xW6D/u+CZZPMTi+ub4
         TqSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xV2HdIRH4UfRrAHXN/H9DTR/2ZGLXLPOFFF8iUGihdI=;
        b=RBUF1TU8DVgEnVPiK0wFwdGknArfqBIhzZtueodKdrUfKgtzN2OI9GYTP+oV/jSyGO
         MpX4zk/YOfoGPrFCyulttCG8hysa56Ek/0Pz6eudfRAuU9H5voLYm2Kj4OTfpBpDjEEu
         E5aFULoSf2Glad7Z0LhpNcjhVZzsL6VBgKBuntzGZUjok9iq8MvdxpdGp+B+IRiaQvsE
         47GWdq8KEOpsbOqiU3o8/lMEo04+rltEeC7J4aUAsHvwruMkLqm6qZcZ/A/+W2VZaEQY
         Zwp8ta6Cy0LvwMMpDnlts5HHdz1kmaOSaKSjaPtbink1AiHRZSwH+jJIYjr2onggQ5OC
         1oWQ==
X-Gm-Message-State: AOAM530Mu5p92zJdZledb43bTl9AWELsqDuRnWm5IV+QIu4/64llU/FW
        w6iFMIFVGYZfhmqmBPNLp6HWNshIkPo8ww==
X-Google-Smtp-Source: ABdhPJzrIt6Zodpqq8ncxTnLEq+8L79neCI209zuG0wLSWubTeFeUK2CKj7bygFajsasyqIWvvUsSw==
X-Received: by 2002:a62:e90b:0:b029:30e:4530:8dca with SMTP id j11-20020a62e90b0000b029030e45308dcamr50228994pfh.17.1626050137560;
        Sun, 11 Jul 2021 17:35:37 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:4039:6c0e:1168:cc74])
        by smtp.gmail.com with ESMTPSA id c24sm15588447pgj.11.2021.07.11.17.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 17:35:37 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next v1 09/14] MIPS: eBPF: drop src_reg restriction in BPF_LD|BPF_DW|BPF_IMM
Date:   Sun, 11 Jul 2021 17:34:55 -0700
Message-Id: <e2c64e0121959db6216e1f6c23447c06ce2b14a3.1625970384.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625970383.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com>
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
index f510c692975e..bba41f334d07 100644
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

