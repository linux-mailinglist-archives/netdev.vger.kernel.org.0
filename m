Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10904220B5
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhJEIbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhJEIbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 04:31:52 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A59C061745;
        Tue,  5 Oct 2021 01:30:02 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id b22so1827034pls.1;
        Tue, 05 Oct 2021 01:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l/X3D8axCR8R6Iv8FHRMGZCljg4SY7rI3XtaUgh1lNc=;
        b=Nsn0Y4fntJPCapUQIivLcByF5/yz08ne98pBVKNURr5S119buvbXXVg9Cg+PfiAVCY
         vW+yUX0rm/dZGQakisBI9WGHB+vNJrGwMzAviJhZLWr9+HK1ZGssZnld/VH1jle8/xRB
         mhe2b1ahLM0qCBkU00C0RUjQksK4eH1aD/kLSWqCLIKHugqKeNB6Ad8xXG0s+JZJG1RL
         X11K+FvTfr35PJT6RTlhU9BZRSx5zkD0Ip8R7sehA5HkeXbjnmQvBKCqA4jbc7vagCQu
         aQjc6+sUDnRcjkLrd/rvZOF6H9WJZXXkaXyREkU44S7Bgvik3YRF2arPWG8Y7lutlZxX
         uojg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l/X3D8axCR8R6Iv8FHRMGZCljg4SY7rI3XtaUgh1lNc=;
        b=wm8006xIDXIudvGYhM1S2MZnliuPGSJx00RsJjTp4/5KvGAEGy5XVGS7VOU/Uku9s/
         ycZmF2zVG72A4Bx/yxj3L1Dzck3yKxzbZOnU6OYxGIka+LlOnQfsknknkdgqYCYCMNJb
         3tagraf+BJq+YZBDV4VWBhTZUMojNt+pZdkYnF2wNczQr4k58/MT1VdXfEx2sbwc9Vfu
         p9VpJQ1JO/MTOLRv90PyOhnnryI8fQgS5y3sTzB4YP8ak3eesMkV+LKmVZ/lv24LdPzT
         MaYI2pbinqOY2mJ3EZMh0RqtQ3ZlJVv0dYIg3yBu+QDv1BoKHXd7jq7a9QuY/H/LyjNF
         hhHQ==
X-Gm-Message-State: AOAM530eMXHqbUmR0erg0q10RllW/NUNHouhhu1tnPBuQlvJtPLXb48/
        J9PAZpJk0ZX4q4+hyUJWYQk=
X-Google-Smtp-Source: ABdhPJxo2Q4SBzL3ZP1UWnJkgImTo3uNqIpC7e6zID71Bvd0KWgJm6FHNjNaqLW/NTgEhxBVDUvr6g==
X-Received: by 2002:a17:902:8a83:b0:13d:9572:86c2 with SMTP id p3-20020a1709028a8300b0013d957286c2mr4173829plo.48.1633422602452;
        Tue, 05 Oct 2021 01:30:02 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:78ba:4bcc:a59a:2284])
        by smtp.gmail.com with ESMTPSA id a15sm4941257pfg.53.2021.10.05.01.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 01:30:02 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next v2 01/16] MIPS: eBPF: support BPF_TAIL_CALL in JIT static analysis
Date:   Tue,  5 Oct 2021 01:26:45 -0700
Message-Id: <05a0d17bef1394521e0aec4b33d2ea3c29c715e5.1633392335.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633392335.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com> <cover.1633392335.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support in reg_val_propagate_range() for BPF_TAIL_CALL, fixing many
kernel log WARNINGs ("Unhandled BPF_JMP case") seen during JIT testing.
Treat BPF_TAIL_CALL like a NOP, falling through as if the tail call failed.

Fixes: b6bd53f9c4e8 ("MIPS: Add missing file for eBPF JIT.")
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 arch/mips/net/ebpf_jit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index 3a73e9375712..0e99cb790564 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -1717,6 +1717,9 @@ static int reg_val_propagate_range(struct jit_ctx *ctx, u64 initial_rvt,
 				for (reg = BPF_REG_0; reg <= BPF_REG_5; reg++)
 					set_reg_val_type(&exit_rvt, reg, REG_64BIT);
 
+				rvt[idx] |= RVT_DONE;
+				break;
+			case BPF_TAIL_CALL:
 				rvt[idx] |= RVT_DONE;
 				break;
 			default:
-- 
2.25.1

