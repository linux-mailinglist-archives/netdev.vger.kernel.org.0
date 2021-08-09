Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF343E42EE
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbhHIJfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbhHIJfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 05:35:37 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE13C061799
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 02:35:17 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id by4so4833620edb.0
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 02:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R8nPDlZ8MIDkJQ2qkzTmbl3dcManmeczWh/bnjgLMVI=;
        b=OJWw8If8eUJX/1o8BHkJ3jcN6fHCR8vVBjKDYajxsg2E5xub9TtztBSzpu147bvKaG
         0aI58UN62MjGAdmuV/uWicHe2G5gwrqIqUm+246Egdnsdd4vTb49/g98J2/WfBIkjDCG
         P+wbVrDxeCq4ctNdUTVFUq1DbOlds9p/ROk3Vo8aw6wKPJDGqJejvubAsUZWpeIhWguB
         WVGL/KCObOUx+VtZZJskFZCIFsyxmd815JT3FXQR2BELGce81kBzV1iNpvS/1iXhTKLh
         2zx4TDRUNFM2F2W/7KeJz1piJYP2/Mkr4lOPU2KNV9Q/UyE2DjR/Jczy8bf7dReEqDc2
         qAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R8nPDlZ8MIDkJQ2qkzTmbl3dcManmeczWh/bnjgLMVI=;
        b=sptV+NPCahlwPvyMopST2GU2k8wHpVDYvBoa2/5qw78XLJBd/6JYPDauoXdZ/nDnPV
         pXw6M76OFbg8GQn+6gjwn3TvwBibW5KwI6JrMNlRsHfJj3j3TBgAI/rU8qdmKj+DGKXa
         xTtC/a+J0eyjrtvxkB5DCE4+ykU9ja/H2KVzFvVffWrVGEluAnA0TYqdnor6fqhbaCZI
         5uyacOTbCBbzgulbhQ4SQRHUoBQgTDbfnjLjiLlBIzIottwwko95CBxNT/xafwR8gQV+
         H75firOAFHlfMDlKsmtTVfnpInnUjdP002MaNj5AWZqbNGgGx81rNO1Dlo+8BR1innG1
         0+KQ==
X-Gm-Message-State: AOAM533zQUKZnchdRuHzX8UE7d1bd75t7H+L/7ecSVSnF2Pka0nOCsp8
        6XF3FqXpRyD1umejr1C4Wg4ZBg==
X-Google-Smtp-Source: ABdhPJzjUGd0t7g3ba5yr7i3vWuv/aPgvCA+VCrgqtGO73BQBNvPUR6zOYdWoOWtky9wyqx3QW737w==
X-Received: by 2002:aa7:da52:: with SMTP id w18mr11638224eds.48.1628501715756;
        Mon, 09 Aug 2021 02:35:15 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id c8sm1989732ejp.124.2021.08.09.02.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 02:35:15 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        illusionist.neo@gmail.com, zlim.lnx@gmail.com,
        paulburton@kernel.org, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, luke.r.nels@gmail.com, bjorn@kernel.org,
        iii@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        davem@davemloft.net, udknight@gmail.com,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next 6/7] mips: bpf: Fix off-by-one in tail call count limiting
Date:   Mon,  9 Aug 2021 11:34:36 +0200
Message-Id: <20210809093437.876558-7-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809093437.876558-1-johan.almbladh@anyfinetworks.com>
References: <20210809093437.876558-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before, the eBPF JIT allowed up to MAX_TAIL_CALL_CNT + 1 tail calls.
Now, precisely MAX_TAIL_CALL_CNT is allowed, which is in line with the
behaviour of the interpreter. Verified with the test_bpf test suite
on qemu-system-mips64.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 arch/mips/net/ebpf_jit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index 3a73e9375712..a93121d71c80 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -617,14 +617,14 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx, int this_idx)
 	b_off = b_imm(this_idx + 1, ctx);
 	emit_instr(ctx, bne, MIPS_R_AT, MIPS_R_ZERO, b_off);
 	/*
-	 * if (TCC-- < 0)
+	 * if (TCC-- <= 0)
 	 *     goto out;
 	 */
 	/* Delay slot */
 	tcc_reg = (ctx->flags & EBPF_TCC_IN_V1) ? MIPS_R_V1 : MIPS_R_S4;
 	emit_instr(ctx, daddiu, MIPS_R_T5, tcc_reg, -1);
 	b_off = b_imm(this_idx + 1, ctx);
-	emit_instr(ctx, bltz, tcc_reg, b_off);
+	emit_instr(ctx, blez, tcc_reg, b_off);
 	/*
 	 * prog = array->ptrs[index];
 	 * if (prog == NULL)
-- 
2.25.1

