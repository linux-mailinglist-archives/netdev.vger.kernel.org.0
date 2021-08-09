Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47473E42E5
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbhHIJfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbhHIJff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 05:35:35 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B82C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 02:35:14 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id b7so23628293edu.3
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 02:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4iS6lRKIwb+H10UNVM+WiLO7lEaIzX0B59TM+au6wcw=;
        b=x1V+cagpq3wEGAJilDAKJQcSJGRsCCB/uIe2wAhFp5isaA2ACd6+KXpzIZ5JNKZh09
         LNpCcPX8fePyollrGcX5JgiBfntG2JJ/yp/wh9r361sToCdDP93GB+GSeG9RpgSHIf/k
         57ypxzAEKI5E297XqDfRr3ldN7a1gRAKvS/KVqzfVMBaR2hn/o/cOnCsMvrOMjvMGLlw
         idfW1YI9czbxhEjdJckwQeQN6bhznTHRlbuW5Ak3HC7IrQNkMk9KFIB+8l0X0etk0s9L
         3B7t4bWarXMZn23t8XkUfRoxBKphiy2jkKR2AVIM7DfyRcc7iGOzFsOC6z/mXa6HTo1I
         w6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4iS6lRKIwb+H10UNVM+WiLO7lEaIzX0B59TM+au6wcw=;
        b=qgnp+NIGYrPlBpTyL4yoegyrvl43+xLT8kjnwKjoJKIIJepa3m/DY/h/36kmtfzwOK
         1qKPN1WL2OeY2YnM1CazrUHczkSO12RMuFcmzsBNU6kgL8M//Jh7tE4rPKaf0U9UWf0p
         +JHmzlmSmo4LqnfHUOOhmCd/KIdl8snUzc0IeMY+MbrRTimDcFmzwn/UVKvZ6IDPamrG
         o8HchMTPJ+FAJE9wfLmIkBszioDYroppDNPQN4CfhsIygTTzuOj/t3yKAJ4vbPsOlC/Y
         cGAKoBzOuDK1uZbrlS+EAqvIKQpZpesLi4MfcakxW/2JheQEKoVHv+p3l5pI+pI3SCUE
         1RvQ==
X-Gm-Message-State: AOAM533mpFbfaEZnRSC8EK/VC2QmgeurVVQlIKxWOD3yd4c8gsJ1z8Jz
        fvClXFqmgu2/s/WeqxOaNsOGwA==
X-Google-Smtp-Source: ABdhPJwiy2AKXZpcwV2uYAGh60iTXCl2cnz4TRR2Q491uFzgpMgRHbDLtElSFveFDXwO1Y5XlnSGuQ==
X-Received: by 2002:a05:6402:b88:: with SMTP id cf8mr1997348edb.281.1628501713083;
        Mon, 09 Aug 2021 02:35:13 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id c8sm1989732ejp.124.2021.08.09.02.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 02:35:12 -0700 (PDT)
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
Subject: [PATCH bpf-next 4/7] s390: bpf: Fix off-by-one in tail call count limiting
Date:   Mon,  9 Aug 2021 11:34:34 +0200
Message-Id: <20210809093437.876558-5-johan.almbladh@anyfinetworks.com>
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
on qemu-system-s390x.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 arch/s390/net/bpf_jit_comp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 88419263a89a..f6cdf13285ed 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1363,7 +1363,7 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 				 jit->prg);
 
 		/*
-		 * if (tail_call_cnt++ > MAX_TAIL_CALL_CNT)
+		 * if (tail_call_cnt++ >= MAX_TAIL_CALL_CNT)
 		 *         goto out;
 		 */
 
@@ -1377,8 +1377,8 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 		EMIT6_DISP_LH(0xeb000000, 0x00fa, REG_W1, REG_W0, REG_15, off);
 		/* clij %w1,MAX_TAIL_CALL_CNT,0x2,out */
 		patch_2_clij = jit->prg;
-		EMIT6_PCREL_RIEC(0xec000000, 0x007f, REG_W1, MAX_TAIL_CALL_CNT,
-				 2, jit->prg);
+		EMIT6_PCREL_RIEC(0xec000000, 0x007f, REG_W1,
+				 MAX_TAIL_CALL_CNT - 1, 2, jit->prg);
 
 		/*
 		 * prog = array->ptrs[index];
-- 
2.25.1

