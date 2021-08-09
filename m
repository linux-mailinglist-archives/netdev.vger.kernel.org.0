Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F693E42E8
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234715AbhHIJfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234688AbhHIJfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 05:35:36 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF78C061798
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 02:35:15 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id oz16so11633722ejc.7
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 02:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3oERsgPvzwB7GwC2qkKhn+IS25jGzMfr+VwIN1gXGn0=;
        b=m9dNA8uh5kZm232vvfEoaTZLzR2LIlZFku02Am3SMwIBCfr5mYXPMIRmZxVq3g1sdR
         o69VF12H7WcvVcOUuakkXGuJL4J6TLZ8UDiKSZ//4ztVa4gCjQ2A4LhODxtyKbdpWtcA
         EFiY1fJotJ5qUH6Js1VchCvRpqA6HoDXkgibXS/uHaUDpTUvIm70bbGWf4NzdRmkBDh6
         zdfliv0ZGITB9drvSS9RMhhJGj2YdfF7qxCe8a0rxofOpgOVyojLDt+39w36McFxI4Zt
         8bYaKgRyFzN6rrv+lzY202w41ElyR5TxNm9g0ttGUBJBfl8YW0byglhBUB59wM+oIkjS
         R8PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3oERsgPvzwB7GwC2qkKhn+IS25jGzMfr+VwIN1gXGn0=;
        b=L86kuvkk2BYf16C/LPFvzKhDE2ZFTFx4eGk9yZWMqFOlJARpkMJwUMNzibSY16CHol
         j3e2MsFtkY6078T/4Nu9oDhZoHDFgxQtzcD88psvLuTgkeRiaFS76RohKQw8BvPgAtZq
         NcMPiOVHbT7OdeaeIaHQNhrvIJ9xn1pa8gTf/DNr8L2iNUX26C6YKGgwrU2FQ9iXknaj
         6SF3vmUK5+y0P64sYBeVbmwW83X3L1z5d0l3gt7gxCNBicILffFrcez9DzwZIackOSNu
         G52iicrWBom119CD8P18beRLRuuHZkBkD1LpWFIN6Rcj/qyWxLgnUZ4dwKBFmch57Z38
         x83w==
X-Gm-Message-State: AOAM5310jSlFPseFp/q7Cy15JsWVm3gTKhg9679n8ExkecfDOTdFf8WD
        yFLKOyE7AmoXDhlOEFJiZpCkQg==
X-Google-Smtp-Source: ABdhPJxMUrgkw5idBC4jX8/Cq44edJLzgtYJYzA+EAEzlFLW84s6xcLSYq+nxax2zYveW18KndP9cg==
X-Received: by 2002:a17:906:c4c:: with SMTP id t12mr7535683ejf.217.1628501714407;
        Mon, 09 Aug 2021 02:35:14 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id c8sm1989732ejp.124.2021.08.09.02.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 02:35:14 -0700 (PDT)
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
Subject: [PATCH bpf-next 5/7] sparc: bpf: Fix off-by-one in tail call count limiting
Date:   Mon,  9 Aug 2021 11:34:35 +0200
Message-Id: <20210809093437.876558-6-johan.almbladh@anyfinetworks.com>
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
on qemu-system-sparc64.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 arch/sparc/net/bpf_jit_comp_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/net/bpf_jit_comp_64.c b/arch/sparc/net/bpf_jit_comp_64.c
index 9a2f20cbd48b..0bfe1c72a0c9 100644
--- a/arch/sparc/net/bpf_jit_comp_64.c
+++ b/arch/sparc/net/bpf_jit_comp_64.c
@@ -867,7 +867,7 @@ static void emit_tail_call(struct jit_ctx *ctx)
 	emit(LD32 | IMMED | RS1(SP) | S13(off) | RD(tmp), ctx);
 	emit_cmpi(tmp, MAX_TAIL_CALL_CNT, ctx);
 #define OFFSET2 13
-	emit_branch(BGU, ctx->idx, ctx->idx + OFFSET2, ctx);
+	emit_branch(BGEU, ctx->idx, ctx->idx + OFFSET2, ctx);
 	emit_nop(ctx);
 
 	emit_alu_K(ADD, tmp, 1, ctx);
-- 
2.25.1

