Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37223C4080
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 02:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhGLAif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 20:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbhGLAiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 20:38:24 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2EAC0613E5;
        Sun, 11 Jul 2021 17:35:35 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o3-20020a17090a6783b0290173ce472b8aso604975pjj.2;
        Sun, 11 Jul 2021 17:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q0geXsZXheKEHM8d15RpPNNDAHbeW46Q8E7QaxBLS+M=;
        b=ESlm4qm3b9pM2Ema1X3lBBtoUYUdjvbym4FFIthfGdiW8igMml7VM/Zx0kp2oua++j
         kIi2hmmGUmybJvwi3uPvTduF1o/UEeAlMu0mOiiPFsjY/n30xhRxB11drPRPQwdKzlgG
         00L2IOvL7tLSTILp5cPaXa9TnAcJAJnBWWynjaeQZNZ9yGpQ5cAl6j/+cq3V9KC9oEiq
         VxjwIfiN1l+UvQBlhuCcBX3tj/GU6w17+HCiprRkdoLUgy8/YdNSkK9obqTXsE7tRgRZ
         JZ1yovbf3bec1cT/HkWxNkB8NPAVidT18PFj1B0zzO8Bog4WR1uKcB9eLDg3z1e3oJy+
         DrtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q0geXsZXheKEHM8d15RpPNNDAHbeW46Q8E7QaxBLS+M=;
        b=mBwbjnq80m1wTDu2bH24rhY1/MK/bCOaQ9plVH7glPIUw1VcZAb+LzpoqTI9C7EMOn
         ELJI2t2Dx96hCZJJBrcwMK+d5qxXv7ZgsMPHU5QdNrhW7Y2RwuVFMo9jdOFs3HTMBcYN
         b2RpDKv69vammvgnl+UeLmSOd6NIbHl5u6MlYM+3+v1W0vSzF/Qjo+cRyGjRhnxI3JqQ
         OmcK+bkackANmCKiuyGlo9LIAjjKVPRFDitgtbKWyv5mEKhhNU1RAAijapoI8fz0G9qi
         O3/hQes9M58qe/XsOGAPwsZa0hTCQoGq7nsq2VK/pVE/ku+zirsnbxfXobrG+2SAPniQ
         /qyg==
X-Gm-Message-State: AOAM532P/YXOJYgTAuuib1MzLg1XwdSfvzst366EUS7VrgPsjD+R7Uv/
        lZ9pbwE1j6clVPWy7CNC8Io=
X-Google-Smtp-Source: ABdhPJxkpAuKJDR6C65UnC6SeiFHOh8kLmtl7Ep47m+YiLk4+LDahq6FEPR3ppc+HHSBDuq3k0K7sw==
X-Received: by 2002:a17:90a:cd01:: with SMTP id d1mr11517767pju.106.1626050130351;
        Sun, 11 Jul 2021 17:35:30 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:4039:6c0e:1168:cc74])
        by smtp.gmail.com with ESMTPSA id c24sm15588447pgj.11.2021.07.11.17.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 17:35:30 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next v1 02/14] MIPS: eBPF: mask 32-bit index for tail calls
Date:   Sun, 11 Jul 2021 17:34:48 -0700
Message-Id: <306525292b0b4959873301b8e62b10c8d4d60ff3.1625970384.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625970383.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The program array index for tail-calls should be 32-bit, so zero-extend to
sanitize the value. This fixes failures seen for test_verifier test:

  852/p runtime/jit: pass > 32bit index to tail_call FAIL retval 2 != 42

Fixes: b6bd53f9c4e8 ("MIPS: Add missing file for eBPF JIT.")
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 arch/mips/net/ebpf_jit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index ed47a10d533f..64f76c7191b1 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -611,6 +611,8 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx, int this_idx)
 	 * if (index >= array->map.max_entries)
 	 *     goto out;
 	 */
+	/* Mask index as 32-bit */
+	emit_instr(ctx, dinsu, MIPS_R_A2, MIPS_R_ZERO, 32, 32);
 	off = offsetof(struct bpf_array, map.max_entries);
 	emit_instr(ctx, lwu, MIPS_R_T5, off, MIPS_R_A1);
 	emit_instr(ctx, sltu, MIPS_R_AT, MIPS_R_T5, MIPS_R_A2);
-- 
2.25.1

