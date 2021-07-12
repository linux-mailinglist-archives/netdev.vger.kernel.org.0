Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83683C4073
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 02:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhGLAia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 20:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbhGLAiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 20:38:19 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5886C0613DD;
        Sun, 11 Jul 2021 17:35:31 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id d12so16455863pgd.9;
        Sun, 11 Jul 2021 17:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PdYhsrqGfOzHQe0K7vA77OCurMz/VH4pNLXIe9BYfjs=;
        b=TcmPHYxBslPI3lbXCEOxmInhmZizPMoy2Ro29mJnAfhOnUpELT0Pc4YcihUwLbC2De
         +rZZrY8M4iRwkxeHUxtWLntKgoOcCiR1MTVZa8QMXI+rlp8htIRvA8i+m38vbiqK5gqI
         q3smbnEhK8npKx3hpJ3ehaTmySrBmZkVPCl162fgmlcLHjP0tutLN8FLLw+qAAnQQgrs
         O3Sq/VGzbQdoLcLfH7IgcnLFyKVPvHJ/u+x9fiWjoCuQ4FUi9lxq2x50ortkGjQ+Xp/P
         NuwVyB+3TPeUh4jIn0ibs0cfD25Lji+3e05WvKsYXseJIQjDFPkG59LNfnvOjhSvVhsG
         lc4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PdYhsrqGfOzHQe0K7vA77OCurMz/VH4pNLXIe9BYfjs=;
        b=HELJetJSp/HJaHT1WnpcQhCrT8+9AIO0Ft+qDOst1NWxNObgoXjZgZqFyKQ9su+8/J
         lBLmTKTdUqTk2MpJC1DfY2MOYTAB2n434FE5d9q1681tQYk2WcJ/el9ay2D36hruAeSz
         yPZxnicBpezYh9Fj0ZhYTdd82VGXCiMpeZKsP5vmcy60PcyEkLNzULk6knYvUic3wWkM
         f/EMXG/JuE7DidT7LAx9zlnofFunAtd4gdLMjNgAILwAz8BB7uvv7diYr8Nde22191Bm
         IfydQ4S7xmmrxj9MJbQ1WMLf21GTyrKQYGVqUPD1H4nW/53Ulp9tLkQHm5jFPChk+CkI
         j/zw==
X-Gm-Message-State: AOAM531sWGDS3Jl7OXbWOxo1IqAC9ezq6+WhLZiWzBYXeyMYNAStO20G
        7pUPADkcGFhuhCbbluWkXR8=
X-Google-Smtp-Source: ABdhPJxsCAQ1+j/Nu6C3zH6Pyxyu7SIV9c7ClPohXeDwxhj23W92lOvEu0XGMFUudP3gm2YPLjTj9g==
X-Received: by 2002:a63:3d08:: with SMTP id k8mr15557220pga.147.1626050131342;
        Sun, 11 Jul 2021 17:35:31 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:4039:6c0e:1168:cc74])
        by smtp.gmail.com with ESMTPSA id c24sm15588447pgj.11.2021.07.11.17.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 17:35:31 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next v1 03/14] MIPS: eBPF: fix BPF_ALU|ARSH handling in JIT static analysis
Date:   Sun, 11 Jul 2021 17:34:49 -0700
Message-Id: <ad3c9df52fadf63586d4efd8f6b3ee601f034654.1625970384.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625970383.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com>
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
index 64f76c7191b1..67b45d502435 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -1587,6 +1587,7 @@ static int reg_val_propagate_range(struct jit_ctx *ctx, u64 initial_rvt,
 			case BPF_AND:
 			case BPF_LSH:
 			case BPF_RSH:
+			case BPF_ARSH:
 			case BPF_NEG:
 			case BPF_MOD:
 			case BPF_XOR:
-- 
2.25.1

