Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5574220BE
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbhJEIc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbhJEIc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 04:32:28 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36FDC061749;
        Tue,  5 Oct 2021 01:30:37 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id v11so6509478pgb.8;
        Tue, 05 Oct 2021 01:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fBG696NEpSwIBlXH0TMuXB909IPwtFq8p/NuyOUiOsc=;
        b=BKMM/GwyCarVz0hwngv5UYK5qMe4WkDZ/1BzG/8T/F9CD1/Hl5nut7LDe/ddtScEOx
         kt2zL4wNzs2P+QjlInsdup5DqqVNx0DLFXN7/rw3i8dGTlRZRv299Xe90KZvKHDM1Pkr
         zwUGf5pTKUCj3afYs51uVZVd3KZqvz1zq6RT5JiSAUmw+MV8cSBMCUIBDiLXAAwyB+bE
         UCuBiLvllVDu5hjAecjbz8a+1KZrjQrmQL0FokivnfSbW60R4tL7JK4ov5+LK7qc5NgA
         MWOzOySfcufv3Twi1vUCYBUuEQN3VLkbAbnUhW8nMbKCNU8cpairduMyCHOIhE/7qWhl
         owjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fBG696NEpSwIBlXH0TMuXB909IPwtFq8p/NuyOUiOsc=;
        b=QxtsAREiX/YwVuTyGU84c1MwLVFmnQ3+XyTfAmnepc0VCUTCwhS0mIy9jZi5dQqwit
         jwO90I8PIZPjXUDuYqg04aLsyBoamEd0FgbIy6dfstogcOVHClbEaw7cXEtT4qTeakg9
         xqMq+NYUGNVcrXytwOLxTClKs0WeB5eC8HN8rVqLMjRiX1d/OteTSETeL0Pd9134c+eP
         uu/BoUjRNP7jq9SU4f0y+h2FPjhTEW29E0EBofeSi/p2VqFhFMmRH2jFRRhC03dfA4Pj
         CQnOxb78FmZtpBUQladmM7aKa2KnVqUe8K/7shXjh9j1HbhdNB4gClB1Zy10JdpUVEyh
         O5KA==
X-Gm-Message-State: AOAM530QwibgBg5w1qawnCGpNyJslDz9/2iVkyisqndV09zLi5vq4ep4
        6AakBc8545XGHyEQKIEx9Kk=
X-Google-Smtp-Source: ABdhPJwhMimbJz9LYq+FXgDCm1WqNWV59ayamwzKcBveNHS/UiEkra2KlzEfbrjeP80lIYeSs6M8ow==
X-Received: by 2002:aa7:9005:0:b0:44b:fa4e:95c2 with SMTP id m5-20020aa79005000000b0044bfa4e95c2mr28003296pfo.29.1633422637435;
        Tue, 05 Oct 2021 01:30:37 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:78ba:4bcc:a59a:2284])
        by smtp.gmail.com with ESMTPSA id a15sm4941257pfg.53.2021.10.05.01.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 01:30:37 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next v2 04/16] MIPS: eBPF: support BPF_JMP32 in JIT static analysis
Date:   Tue,  5 Oct 2021 01:26:48 -0700
Message-Id: <8ca5dfaa9ad749e643f9246d2434c12a1c21150a.1633392335.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633392335.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com> <cover.1633392335.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While the MIPS64 JIT rejects programs with JMP32 insns, it still performs
initial static analysis. Add support in reg_val_propagate_range() for
BPF_JMP32, fixing kernel log WARNINGs ("Unhandled BPF_JMP case") seen
during JIT testing. Handle code BPF_JMP32 the same as BPF_JMP.

Fixes: 092ed0968bb6 ("bpf: verifier support JMP32")
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 arch/mips/net/ebpf_jit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index b41ebcfb90c4..dbde5d6eefa6 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -1686,6 +1686,7 @@ static int reg_val_propagate_range(struct jit_ctx *ctx, u64 initial_rvt,
 			rvt[idx] |= RVT_DONE;
 			break;
 		case BPF_JMP:
+		case BPF_JMP32:
 			switch (BPF_OP(insn->code)) {
 			case BPF_EXIT:
 				rvt[idx] = RVT_DONE | exit_rvt;
-- 
2.25.1

