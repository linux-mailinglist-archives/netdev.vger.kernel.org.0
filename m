Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E673F8EF5
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhHZTl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:41:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35321 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243605AbhHZTlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:41:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aB69aifL1zI8vrW5XNajMWuHmZ5MVDONIdA/rCm6EsU=;
        b=azZvIdztmZcWTeF9AInXVzFb3l/RSj5oe4Zk7b4yasehrXT75eKzRDl6AqGayuZs3lyvW2
        sbA9Igakf3ePmVnMY/XawaANoOU+tP4nYZ5kWLTQDaSw2VfbjObBbfa7fkzNQAr+I9gKVO
        2AfK5BHtc2zBADGIzwKxQKYV1DQb1Z0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-zW3QaOpUNLe6yOYF1HzUtw-1; Thu, 26 Aug 2021 15:40:59 -0400
X-MC-Unique: zW3QaOpUNLe6yOYF1HzUtw-1
Received: by mail-wr1-f71.google.com with SMTP id r11-20020a5d4e4b000000b001575c5ed4b4so1206744wrt.4
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:40:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aB69aifL1zI8vrW5XNajMWuHmZ5MVDONIdA/rCm6EsU=;
        b=IdiOHa5VbwLrwIftw2w6dgtlBPSZEcsakfjDZaeXyLnOFjf9rRROnrpaPPESEfBvi9
         ktoodgVpI5oAxKpttJBC5mIskR0dbEM0x5QeY42k88ejhlTJhr3IRLlOSpmYLpWNsXFX
         wUhbxodTzzeu6+gWWMepv1FSuzrgvnSPxor0hqX8LQCyyzTkNsmSJacAa4A3zIeqoetv
         0saudLBGLvzcR4v7yYz/SEu39UvCjP4cTTz4+/xyXajz221GxYlfctW8s1DgO28Tch56
         sYmpQ2MwWg1wufP9Ib94c54Ci1xY9OGm11kUOlNsVzpPXuZAPvuQn/q5Fe18nYIjOMaB
         67rw==
X-Gm-Message-State: AOAM53285QhOtbnEZNqwAle2jpz5Gw+s4+eZj1a2LoO9gyI0c0/5Hly7
        BdYxYKekVuKkIbdAOjBgpY0R6uxJGgyx4jOpHaNi39B0FeOy0ONQA5ZEa81sdEAGq8IWkrVXdMQ
        UFYORlb9gHJX7wY2k
X-Received: by 2002:a1c:27c2:: with SMTP id n185mr5120212wmn.20.1630006856789;
        Thu, 26 Aug 2021 12:40:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJximqozMr0/Jm9W8qaJJ+TOp3iu2uH+xdipTy7sLT+cli5O3p4fnfXEZvgGgFYa01EeiwtxAQ==
X-Received: by 2002:a1c:27c2:: with SMTP id n185mr5120188wmn.20.1630006856586;
        Thu, 26 Aug 2021 12:40:56 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id x21sm2507342wmi.15.2021.08.26.12.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:40:56 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCH bpf-next v4 15/27] bpf, x64: Allow to use caller address from stack
Date:   Thu, 26 Aug 2021 21:39:10 +0200
Message-Id: <20210826193922.66204-16-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we call the original function by using the absolute address
given at the JIT generation. That's not usable when having trampoline
attached to multiple functions. In this case we need to take the
return address from the stack.

Adding support to retrieve the original function address from the stack
by adding new BPF_TRAMP_F_ORIG_STACK flag for arch_prepare_bpf_trampoline
function.

Basically we take the return address of the 'fentry' call:

   function + 0: call fentry    # stores 'function + 5' address on stack
   function + 5: ...

The 'function + 5' address will be used as the address for the
original function to call.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 13 +++++++++----
 include/linux/bpf.h         |  5 +++++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 0fe6aacef3db..9f31197780ae 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2024,10 +2024,15 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
 		restore_regs(m, &prog, nr_args, stack_size);
 
-		/* call original function */
-		if (emit_call(&prog, orig_call, prog)) {
-			ret = -EINVAL;
-			goto cleanup;
+		if (flags & BPF_TRAMP_F_ORIG_STACK) {
+			emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
+			EMIT2(0xff, 0xd0); /* call *rax */
+		} else {
+			/* call original function */
+			if (emit_call(&prog, orig_call, prog)) {
+				ret = -EINVAL;
+				goto cleanup;
+			}
 		}
 		/* remember return value in a stack for bpf prog to access */
 		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f0f548f8f391..a5c3307d49c6 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -584,6 +584,11 @@ struct btf_func_model {
  */
 #define BPF_TRAMP_F_IP_ARG		BIT(3)
 
+/* Get original function from stack instead of from provided direct address.
+ * Makes sense for fexit programs only.
+ */
+#define BPF_TRAMP_F_ORIG_STACK		BIT(4)
+
 /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
  * bytes on x86.  Pick a number to fit into BPF_IMAGE_SIZE / 2
  */
-- 
2.31.1

