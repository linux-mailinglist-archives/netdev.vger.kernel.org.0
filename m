Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0124220B8
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbhJEIcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbhJEIcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 04:32:04 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D7EC061745;
        Tue,  5 Oct 2021 01:30:14 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id b22so1827385pls.1;
        Tue, 05 Oct 2021 01:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zzGe5Wy3mDkKEKYCT9h+VBJHOg/ijD2uRySpX5DGZX4=;
        b=LDJs7JXie2s8SUMGrGQq0hEMaanjTjMnRkTtWaBRu1FZSWgF9Dx1nnAMLm2+QYU8dq
         jNVwoVPuuv6zHydYnMfH5iGuI8LE6O/5s8t1mJ7+/ZXRxbKTLinSoniLfOVqUBPlqI9z
         zAWmwvkWgmeRJtYILVfZOzEnrWyVYgyh5uXIZ++WKMZUzDw4QHPYHjkGc4gROCpry342
         qXn17Ropc0dmtt3OybtFms7D8pinUvVKIfVwPN305DpR8M6HSZIGky5BNl8kcDh8eq8W
         WQ5mUv5YrXmXGWT9lmqURmoWrIAUM+7JAgiaO0KyOdGiFPiregxVSmnCIUl8ibLhDXqG
         AOoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zzGe5Wy3mDkKEKYCT9h+VBJHOg/ijD2uRySpX5DGZX4=;
        b=xkeYGI3hySRqzfmUFb8aa7t/Tx8TH9RliTANda5TgJb1ntGWByZ91wJCwLualxvTFG
         l/b+860o0uHI2LqH7aDjDTB3EIUeCgis3vm1vkNiaNrpjf0YXu5zLe5OhCfskZbM6wN6
         c9za1BDZZHLJIm8uQZWFn81yiLPPw3/6ubS1ORXvBA89QTse2J91s39Ez3a40lEVmso8
         iKlg/UjL5WO8TikrZ7ty5eyOHskzXr4HaeVjMh2mLMiP/vKcrwBf05na3o3Yh7+7BMWV
         37oDNs0z8D8krkv/RcWJ1s1yLqZMWcuELLF4ewynHbHyKVUxdaXv0QlZCbDNPfdlY+Q8
         //JA==
X-Gm-Message-State: AOAM5310+LlP4yQa25E75ORmwMPS67GGlSMmCidWbhDzV2DO25Fz3cRV
        wYBLUe5Qia8DMxmGrZQzI/M=
X-Google-Smtp-Source: ABdhPJzrq+Z2N/ppb2aKdvI31i8JGUgD1xJW9WP49KjOZpIHNwyQa9rjT21w/d2v6Qkd02EQPI/uEg==
X-Received: by 2002:a17:90a:9f91:: with SMTP id o17mr2263689pjp.225.1633422614497;
        Tue, 05 Oct 2021 01:30:14 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:78ba:4bcc:a59a:2284])
        by smtp.gmail.com with ESMTPSA id a15sm4941257pfg.53.2021.10.05.01.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 01:30:14 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next v2 02/16] MIPS: eBPF: mask 32-bit index for tail calls
Date:   Tue,  5 Oct 2021 01:26:46 -0700
Message-Id: <15d2aab0133231aea254bd7422528d4a765d5f0f.1633392335.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633392335.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com> <cover.1633392335.git.Tony.Ambardar@gmail.com>
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
index 0e99cb790564..82ea20399b70 100644
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

