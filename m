Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D0746853D
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 15:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385150AbhLDOKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 09:10:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1385141AbhLDOKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 09:10:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638626831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xC5TlLzwbkcTpEZr+hM0vqzDlSjsPdxa1/NV8DPky6A=;
        b=AsHAvH0W1Deio9gEDKkUUucxdZYl3dSwp4FZBEz98msGqw2+YWj+7sBQUpxd17PxkrXlid
        sWCHUecy0TfohMUaN2E35CrtgPReyjy1gETjTd545AncvA35djs3NeU2erXFXbGf2Ty0vn
        wSLr64eR+QId9MZ6ttHzMF7wJ0+U/4M=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-UxURjlN9McuUDxfneVHi5g-1; Sat, 04 Dec 2021 09:07:10 -0500
X-MC-Unique: UxURjlN9McuUDxfneVHi5g-1
Received: by mail-wr1-f72.google.com with SMTP id h7-20020adfaa87000000b001885269a937so1141204wrc.17
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 06:07:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xC5TlLzwbkcTpEZr+hM0vqzDlSjsPdxa1/NV8DPky6A=;
        b=rgWTgYkiRrHKFg67MbFAuBvvlIWWAcmfp+4KDtDBtxoYT3uigOP0bQjmoHh7a55qej
         42fMNR9rh+RxsG6LNoI/Kh+bNbSRB5IWzdqtRQYcbAWB0n60dPsz69rlzr06BAC9KceA
         +qDGgGTQYtDQFMKmf+2DMm5dCqHdtIV2dd2wWc/U7PyYWKstN0ufp83nUYtrTD0MctH3
         Y4MIKb/FzYuYcZhfo9Md63mHHLAYMN2l5AJM9W0a2qj2ueYf2B4mbagXhxPFAPqbGSLe
         NO0Uj8dNE+z4RZgAU40gD74sn4e/ph0KMtJtjcutoru6GQUD4r7jLxZBHkGVmZn/iF8x
         VLHg==
X-Gm-Message-State: AOAM533BZV9a53XROXiz/OaG3MajZGbrCK/jLscfiDP5Km6AMYMKLloq
        McMEn1c/pUMFAhL86G1zWeDO1RimAktI4DhtxS/p/ZaTDShA5+TQIi9vdko7b8OT9WIuZp7zirO
        0aHV9qENpDgAkx37S
X-Received: by 2002:adf:e742:: with SMTP id c2mr28822987wrn.498.1638626828675;
        Sat, 04 Dec 2021 06:07:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxbgROHKllqA4ySneHTl8ueKHAtkM5JydXYnQG7cZNwwpwWUbNGJ6j+i4xWD7D04SSAyjOeiA==
X-Received: by 2002:adf:e742:: with SMTP id c2mr28822964wrn.498.1638626828494;
        Sat, 04 Dec 2021 06:07:08 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id u2sm6333175wrs.17.2021.12.04.06.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 06:07:08 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 1/3] bpf, x64: Replace some stack_size usage with offset variables
Date:   Sat,  4 Dec 2021 15:06:58 +0100
Message-Id: <20211204140700.396138-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211204140700.396138-1-jolsa@kernel.org>
References: <20211204140700.396138-1-jolsa@kernel.org>
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
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 42 ++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 1d7b0c69b644..b106e80e8d9c 100644
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
+	 * RBP - regs_off  [ reg_arg1        ]
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

