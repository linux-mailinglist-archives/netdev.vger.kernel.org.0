Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80AE64220BB
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbhJEIcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbhJEIcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 04:32:20 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4D1C061745;
        Tue,  5 Oct 2021 01:30:30 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id cs11-20020a17090af50b00b0019fe3df3dddso1531759pjb.0;
        Tue, 05 Oct 2021 01:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dGdTtYrmJ1H2+tRpCqMyGgjc5iCxgfgYhTTRd7bVUbY=;
        b=LApmQoVGQRm/nto+Z1864v0TQawWYqePSZJO1E2kwEQhXpKjtGZWgx8cjMH1ARXqG2
         x/HvmD4JNIpoKXt7Wwbtt9gGQsTwbdzYFEke9nAi7qv4Rq5AovshjC/L18Dr4GHjsKje
         rFhUIXnrZci+QHORiJxsPQRclgg+beOraJA6+BRZbh0TstyuFwSfHUpuxcEMgEWL/4DC
         v8nAjxEo30toJNgNSPlDYHE78NBYS7CoPwpI7DbHbPzgpZ/jBpXXspYUAH7GIB27O36h
         l+nyT5ItJJUjP9tLncNnGgW6QI6bXqhSzVzN5s2yM3RnNHN+V3ISDPblIM6ojcOo1oQz
         k4XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dGdTtYrmJ1H2+tRpCqMyGgjc5iCxgfgYhTTRd7bVUbY=;
        b=hbA6TeyV/Vl/29oIPoMGq0CaoQazBTtADNJnqpyBwqwTdq9vQe+xgAFZAyPImfh8ya
         79jhilEqv45A3o5d/dLsxF/YoIRllnHmweDDBR1bRDMIyYNZ85e+Oug75uKN0bt+0Kuz
         TPMSFjZc+dNxkmrof0t670pNtQTnmsCP62CER0bdGLFFF9e/M7y/m82PvgKXck5sExIP
         WSYBSdsjBPo14jxknMkpjkR6Ofio8NUdw3H00vzSCvlhLFI7LPQ8Qqfcmx4rueysGAIK
         REWih7NISA/JTRlT49HlVfE1teWwMH3n4EdUzK9/jn2u902WFnYPQHIhZUuxOABCtqn+
         Idwg==
X-Gm-Message-State: AOAM530NsnwM1/rNu8WuQxz5o3d5fyhmsBPR+4/dkkf9IciQqSlqp99f
        Zyi71fyVJklG1DxbOCa99EU=
X-Google-Smtp-Source: ABdhPJyb50NUklWBG1NtqkaFC+LDythq55+NAZsQJiXK6F2yOU48aIpwY/7hwkUqfdSd6Gqp4TRxvw==
X-Received: by 2002:a17:902:7297:b0:13e:6650:a4ca with SMTP id d23-20020a170902729700b0013e6650a4camr4169302pll.37.1633422630289;
        Tue, 05 Oct 2021 01:30:30 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:78ba:4bcc:a59a:2284])
        by smtp.gmail.com with ESMTPSA id a15sm4941257pfg.53.2021.10.05.01.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 01:30:29 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next v2 03/16] MIPS: eBPF: fix BPF_ALU|ARSH handling in JIT static analysis
Date:   Tue,  5 Oct 2021 01:26:47 -0700
Message-Id: <1f88a0febdee93743eb438cfd28b82bbe17c2650.1633392335.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633392335.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com> <cover.1633392335.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update reg_val_propagate_range() to add the missing case for BPF_ALU|ARSH,
otherwise zero-extension breaks for this opcode.

Resolves failures for test_verifier tests:
  963/p arsh32 reg zero extend check FAIL retval -1 != 0
  964/u arsh32 imm zero extend check FAIL retval -1 != 0
  964/p arsh32 imm zero extend check FAIL retval -1 != 0

Fixes: b6bd53f9c4e8 ("MIPS: Add missing file for eBPF JIT.")
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 arch/mips/net/ebpf_jit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index 82ea20399b70..b41ebcfb90c4 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -1590,6 +1590,7 @@ static int reg_val_propagate_range(struct jit_ctx *ctx, u64 initial_rvt,
 			case BPF_AND:
 			case BPF_LSH:
 			case BPF_RSH:
+			case BPF_ARSH:
 			case BPF_NEG:
 			case BPF_MOD:
 			case BPF_XOR:
-- 
2.25.1

