Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6716746DC4C
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 20:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbhLHTgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 14:36:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:34810 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239598AbhLHTgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 14:36:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638991989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fl1TARx7BmZXoN5URwsP72iDs197DSpJifXLFHu4wWo=;
        b=I9pT6relAJkYFoW6WQSi1kL8gQ5Z2utFWS6d3u6+2NR5mf/4L9UAEGmCHYczRiYT1+bFJL
        /Q7F1zJhkx33jK6HEck+Dh2mJ7143Mgxt2/mUmKgssvJzphJt8EAKXRJVzvR/YeobDOCOR
        4kz7agspmQxRVqiSDZmIouJHyA6gTNw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-XJ5jH3gqMuukhu2yHE1PTA-1; Wed, 08 Dec 2021 14:33:08 -0500
X-MC-Unique: XJ5jH3gqMuukhu2yHE1PTA-1
Received: by mail-wm1-f70.google.com with SMTP id 145-20020a1c0197000000b0032efc3eb9bcso3551534wmb.0
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 11:33:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fl1TARx7BmZXoN5URwsP72iDs197DSpJifXLFHu4wWo=;
        b=PKSKkSRQQhFfmbzzuGvFDnmahJ0rRVIOL4ODuoMEZTpMRVkjXi05JDwSMr6IT/g7kQ
         utuwlkIPbcpE2gMlF2CEJchn0KgU+NXql8hEZD1Gcc8HKFHe5uPU2m6UjnRec+uf2tHF
         +3yJKAou+lApPBFMAaB/B2qppotzxTBpdiJ+d+PiSYrjUfrsijALDiE3weIMOWEc/yDk
         /Q+gUToxSzWiN/ZmpJZ7wGmywV2pmS12KJ8MZ07r0agSh2XQYiOtuGczH4hR8OEMs0m2
         jNTvfJRKFf727apB41MYY9yV5R6weJpvioOUWoU8STz+QpT7ArYQgwhiQveD4So2WVr+
         HaVg==
X-Gm-Message-State: AOAM531lXgnt0pf9XO88rHfOMgKimqT1RqFQZeBd0v2TafgRbzITzlnb
        CY0ifuWIiJ/NGaXinjZcNfaXWaMff99HX3Cu5z8x7US8ekux/52ydsfgz4jq7I3zvWSHWy9r0WY
        v0RfNTv3/4LBSUS50
X-Received: by 2002:a05:600c:4104:: with SMTP id j4mr778078wmi.178.1638991987175;
        Wed, 08 Dec 2021 11:33:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxRK2DnOgkAzntcTMP0OdqLddSs7VPjEp+IUVikE3hDCCgntPShhKDYT8ceNaS/rWSlds2z9g==
X-Received: by 2002:a05:600c:4104:: with SMTP id j4mr778052wmi.178.1638991986976;
        Wed, 08 Dec 2021 11:33:06 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id l8sm8031264wmc.40.2021.12.08.11.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 11:33:06 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCHv2 bpf-next 3/5] bpf, x64: Replace some stack_size usage with offset variables
Date:   Wed,  8 Dec 2021 20:32:43 +0100
Message-Id: <20211208193245.172141-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211208193245.172141-1-jolsa@kernel.org>
References: <20211208193245.172141-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As suggested by Andrii, adding variables for registers and ip
address offsets, which makes the code more clear, rather than
abusing single stack_size variable for everything.

Also describing the stack layout in the comment.

There is no function change.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 42 ++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 1d7b0c69b644..10fab8cb3fb5 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1941,7 +1941,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 				void *orig_call)
 {
 	int ret, i, nr_args = m->nr_args;
-	int stack_size = nr_args * 8;
+	int regs_off, ip_off, stack_size = nr_args * 8;
 	struct bpf_tramp_progs *fentry = &tprogs[BPF_TRAMP_FENTRY];
 	struct bpf_tramp_progs *fexit = &tprogs[BPF_TRAMP_FEXIT];
 	struct bpf_tramp_progs *fmod_ret = &tprogs[BPF_TRAMP_MODIFY_RETURN];
@@ -1956,14 +1956,33 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	if (!is_valid_bpf_tramp_flags(flags))
 		return -EINVAL;
 
+	/* Generated trampoline stack layout:
+	 *
+	 * RBP + 8         [ return address  ]
+	 * RBP + 0         [ RBP             ]
+	 *
+	 * RBP - 8         [ return value    ]  BPF_TRAMP_F_CALL_ORIG or
+	 *                                      BPF_TRAMP_F_RET_FENTRY_RET flags
+	 *
+	 *                 [ reg_argN        ]  always
+	 *                 [ ...             ]
+	 * RBP - regs_off  [ reg_arg1        ]  program's ctx pointer
+	 *
+	 * RBP - ip_off    [ traced function ]  BPF_TRAMP_F_IP_ARG flag
+	 */
+
 	/* room for return value of orig_call or fentry prog */
 	save_ret = flags & (BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_RET_FENTRY_RET);
 	if (save_ret)
 		stack_size += 8;
 
+	regs_off = stack_size;
+
 	if (flags & BPF_TRAMP_F_IP_ARG)
 		stack_size += 8; /* room for IP address argument */
 
+	ip_off = stack_size;
+
 	if (flags & BPF_TRAMP_F_SKIP_FRAME)
 		/* skip patched call instruction and point orig_call to actual
 		 * body of the kernel function.
@@ -1981,19 +2000,14 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 		/* Store IP address of the traced function:
 		 * mov rax, QWORD PTR [rbp + 8]
 		 * sub rax, X86_PATCH_SIZE
-		 * mov QWORD PTR [rbp - stack_size], rax
+		 * mov QWORD PTR [rbp - ip_off], rax
 		 */
 		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
 		EMIT4(0x48, 0x83, 0xe8, X86_PATCH_SIZE);
-		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -stack_size);
-
-		/* Continue with stack_size for regs storage, stack will
-		 * be correctly restored with 'leave' instruction.
-		 */
-		stack_size -= 8;
+		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -ip_off);
 	}
 
-	save_regs(m, &prog, nr_args, stack_size);
+	save_regs(m, &prog, nr_args, regs_off);
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
 		/* arg1: mov rdi, im */
@@ -2005,7 +2019,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	}
 
 	if (fentry->nr_progs)
-		if (invoke_bpf(m, &prog, fentry, stack_size,
+		if (invoke_bpf(m, &prog, fentry, regs_off,
 			       flags & BPF_TRAMP_F_RET_FENTRY_RET))
 			return -EINVAL;
 
@@ -2015,7 +2029,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 		if (!branches)
 			return -ENOMEM;
 
-		if (invoke_bpf_mod_ret(m, &prog, fmod_ret, stack_size,
+		if (invoke_bpf_mod_ret(m, &prog, fmod_ret, regs_off,
 				       branches)) {
 			ret = -EINVAL;
 			goto cleanup;
@@ -2023,7 +2037,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	}
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
-		restore_regs(m, &prog, nr_args, stack_size);
+		restore_regs(m, &prog, nr_args, regs_off);
 
 		/* call original function */
 		if (emit_call(&prog, orig_call, prog)) {
@@ -2053,13 +2067,13 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	}
 
 	if (fexit->nr_progs)
-		if (invoke_bpf(m, &prog, fexit, stack_size, false)) {
+		if (invoke_bpf(m, &prog, fexit, regs_off, false)) {
 			ret = -EINVAL;
 			goto cleanup;
 		}
 
 	if (flags & BPF_TRAMP_F_RESTORE_REGS)
-		restore_regs(m, &prog, nr_args, stack_size);
+		restore_regs(m, &prog, nr_args, regs_off);
 
 	/* This needs to be done regardless. If there were fmod_ret programs,
 	 * the return value is only updated on the stack and still needs to be
-- 
2.33.1

