Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010813C4064
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 02:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbhGLAiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 20:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbhGLAiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 20:38:17 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AFAC0613E5;
        Sun, 11 Jul 2021 17:35:29 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id j3so6318579plx.7;
        Sun, 11 Jul 2021 17:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pq5zfFYvJRJp/wFGTGQ6c/E4wNoaWHlEdO1OBbdRBdc=;
        b=EWbU54tmOwmJPHgIKjujeR9uuTq+dJh14Zn3GkZe7AJ+ebrGN21BQozej+t2qPttFT
         HhM2l0ylPSc4t1t6jeEppHcgkEd7zVJaFaQB07uDsg5O7OqzhY5GixKquhqRQcn2kSY+
         QeLiGg0WXCnb0VhlJMFg7sXnqyZq0256Vi9nB36fXlQtXumOCQoELzy+rVTlKCINhnBO
         x27E0GadNDK9vXFMq19cnPsyt+fClTKMLEE6xrcGd2fHDU2H2TxqqdGPbpLNSA3/0WJ3
         bXdQEZz/Wet+7KQw4yv51WyQZ9Uo8rXvs6S/Sdy+NDg/8AssIeJt6cTrCq6Ev4OzCOzS
         jJDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pq5zfFYvJRJp/wFGTGQ6c/E4wNoaWHlEdO1OBbdRBdc=;
        b=ahtVn+5TaWSaOczPQbpqCKhSEolTVrbGitNKO1OgLfS6VqAd3qYteSFv7tbcXJ0ImI
         TONyPyuusDzC+gFwQW1AK+ja2bf5gR4df4LF6E4ZFePgzWKHnasR9lNkdSC8BgpdIIfp
         05+Gf7+UiM7AQy3Jib+B/vOMLtJwNfjCEhq8ij5rW1fvrBdB2Kxzy0Sj1lcewz9FJdZu
         55nuat2TnAOeKvXCeG28oByzjOKTgZuLSsTOmFtw6x12xBW8eNC76H+KJls3CUQe0f6j
         hMp0TZbxn1GwSwPMXScgs375qYTkmJ2dB/KHqWc6R3M8EhHV4xJKCbwc+goWxqXFXCRy
         XJoQ==
X-Gm-Message-State: AOAM533zOFbDxAxPSS9bPvGEt5tqXcNe3lycyRiqsetOcLIkHuaCTdaJ
        FmMfNu5kvY8W4eW/TGZH3Uk=
X-Google-Smtp-Source: ABdhPJxVPCrDqfktMD/mzYKEPeAO4zTe+4jFdAOyVMjP4bjytDpWrBV1exym7bFScf7LfgwHUK5q3A==
X-Received: by 2002:a17:90a:1f43:: with SMTP id y3mr28259256pjy.0.1626050129292;
        Sun, 11 Jul 2021 17:35:29 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:4039:6c0e:1168:cc74])
        by smtp.gmail.com with ESMTPSA id c24sm15588447pgj.11.2021.07.11.17.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 17:35:29 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next v1 01/14] MIPS: eBPF: support BPF_TAIL_CALL in JIT static analysis
Date:   Sun, 11 Jul 2021 17:34:47 -0700
Message-Id: <c19e3b68eb7ff1356a941a0180f7ec2d3a3efa02.1625970384.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625970383.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com>
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
index 939dd06764bc..ed47a10d533f 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -1714,6 +1714,9 @@ static int reg_val_propagate_range(struct jit_ctx *ctx, u64 initial_rvt,
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

