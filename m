Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F29455A31
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344005AbhKRL3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:29:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37489 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343945AbhKRL2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:28:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CFr165JXVPF9+YogBDBOFblIaG2/JxmtopNnbedaeug=;
        b=i9HhJpQ91OJnTkdcYBy34hlH99eaEbNPia6OJs34KpoLPKval3W2Gn8TTAxRSUZi4rBTWb
        bzLZKy6yfGoaInZQ+F/duFSSEsgEycYZXbAO9floy3Jl7SdnN6S/wVnky8aQFIYJulhB2D
        ZjjiCWk5pO2twjek+Y7bNcNq6M8/w6s=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-FRo2zJKTPiO9_BbRxlFpJA-1; Thu, 18 Nov 2021 06:25:40 -0500
X-MC-Unique: FRo2zJKTPiO9_BbRxlFpJA-1
Received: by mail-ed1-f70.google.com with SMTP id w18-20020a056402071200b003e61cbafdb4so5001923edx.4
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 03:25:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CFr165JXVPF9+YogBDBOFblIaG2/JxmtopNnbedaeug=;
        b=JSMPDg8FK97EFiSfX3jKm0czguVp+sitR48K12q3nRmiQk5aHtet9g/+giABv94XXw
         3dOMU5gDCy/GBRLy2ixdY06yXT5puZhQ37EKJC0AUOWvtEfJ04pReCGwZ4JEVi/s+5t2
         NL8vfBz33bcdh41cqpxx/2NKph84RwRNs2sG4lL7c+7UXH4zyoJr74aLUmGb2oqsCuxG
         2a7dzlDYFbezZFWgWrhO0bcmJtxzCGKJTIRPOxDFeqpomQB7fZ6CPuytYxHThJU6NU+h
         o0Ku0AmbkPtxX5XWDdxDIZ8lMCMxNB2ZtZcDo2RMqbQGKgXnuvoq1UJFSsP0gUU57JCr
         DMpA==
X-Gm-Message-State: AOAM532VZvfawX+rUs1uzK1RGr3/R06uix5HWTQLc/H6zitSn2GH/48d
        FhjiBzZ4ympsApWWY51gTtYktZuUtqUA1GoACHgRprw8Q2Lw3Dmt9CN8pnR/RIMUvuPE9bs+t47
        BUCRZr/pgSM7EMiZj
X-Received: by 2002:a05:6402:278e:: with SMTP id b14mr10176262ede.354.1637234739240;
        Thu, 18 Nov 2021 03:25:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwGAjtFRa/W1pUQDowtevr45KxolZl62BgECbGerO7oi7QNztVAFKosWxzDXCEbjwZNK6H+qg==
X-Received: by 2002:a05:6402:278e:: with SMTP id b14mr10176236ede.354.1637234739120;
        Thu, 18 Nov 2021 03:25:39 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id q2sm1362615edh.44.2021.11.18.03.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:25:38 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 07/29] bpf, x64: Allow to use caller address from stack
Date:   Thu, 18 Nov 2021 12:24:33 +0100
Message-Id: <20211118112455.475349-8-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118112455.475349-1-jolsa@kernel.org>
References: <20211118112455.475349-1-jolsa@kernel.org>
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
index 67e8ac9aaf0d..d87001073033 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2035,10 +2035,15 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
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
index cc7a0c36e7df..77c76e2fa9ff 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -594,6 +594,11 @@ struct btf_func_model {
 /* Return the return value of fentry prog. Only used by bpf_struct_ops. */
 #define BPF_TRAMP_F_RET_FENTRY_RET	BIT(4)
 
+/* Get original function from stack instead of from provided direct address.
+ * Makes sense for fexit programs only.
+ */
+#define BPF_TRAMP_F_ORIG_STACK		BIT(5)
+
 /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
  * bytes on x86.  Pick a number to fit into BPF_IMAGE_SIZE / 2
  */
-- 
2.31.1

