Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8ACA3C81EC
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 11:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238919AbhGNJrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 05:47:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25362 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238923AbhGNJrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 05:47:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626255853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=js7ItpLeBG6341HxQnnXIxzAVMeXbOzDGxLGSYjQe08=;
        b=EoxHcs2fIOcmbgqNkbxEmAh9O9c9MeZDQCIubqV4lj7hEqH+amDcdDl5HlzOzSH1RGAQaL
        eKySBWaVDu6L+4h0Ur9G9R1b6L8BMt8eza1VLABQx/XWkUpQvwjSTlqrXJefwwquvodsDt
        SQwOEkP6weX+Fzdo8ORkDFCrh6iebDg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-OYkSWKfBMyWLiFGlTPex3Q-1; Wed, 14 Jul 2021 05:44:12 -0400
X-MC-Unique: OYkSWKfBMyWLiFGlTPex3Q-1
Received: by mail-wr1-f71.google.com with SMTP id r18-20020adff1120000b029013e2b4ee624so1239126wro.1
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 02:44:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=js7ItpLeBG6341HxQnnXIxzAVMeXbOzDGxLGSYjQe08=;
        b=oeS0AJ3PteOhOjjaA4+PZpN02W8/JHCMVDGCmFPK7R9NkfXVNF2oVYNctL2IPmwedO
         6iZMA4+fm1FFRH+0mEpi8FOnRWa/Ia3DPLoKj/i6jHvSBsv6iGicu82R9ubY3pWIpgaw
         kqvap9T7VCCRVEd4UW2oksx0VlBkCiWnrfXAvDHrzf+ulGNGy/ECXCW4f3IcrxvJcaF2
         fKlNoQrQ5mze2bRSC6Vaf2eakybK/alx05hyXgSqSMNxjyGIyPwIWcOUu4gAbflTiKUT
         XkYEPDtifm+0NkqqUTNWr23Uf2ZXuTM6XkDsdNehNI1EmqeXE48/WmIkVUuJVgWr3M+X
         5W8w==
X-Gm-Message-State: AOAM530gvYOMpiqeyW+vGG6AxpwRS3dczN0xt1dQah43C3pUQBnAis+q
        8ACZmlMnONKUrQ6t37MqdZBA8FxzuPZYMUy2hxYXKzG/eQPlRS8jts696A9ZSP41Vo7KTGhOQOA
        YNV3MEr7VFMns4IVs
X-Received: by 2002:a05:6000:551:: with SMTP id b17mr11631514wrf.32.1626255851343;
        Wed, 14 Jul 2021 02:44:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9wxWDgLR+XvYeobeH3N2tpea63Gzr0Is8aqeGRFYHharxAcPTxU0MECVMqK95yblgf8g04w==
X-Received: by 2002:a05:6000:551:: with SMTP id b17mr11631497wrf.32.1626255851148;
        Wed, 14 Jul 2021 02:44:11 -0700 (PDT)
Received: from krava.redhat.com ([5.171.203.6])
        by smtp.gmail.com with ESMTPSA id g15sm1502900wmh.44.2021.07.14.02.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 02:44:10 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCHv4 bpf-next 1/8] bpf, x86: Store caller's ip in trampoline stack
Date:   Wed, 14 Jul 2021 11:43:53 +0200
Message-Id: <20210714094400.396467-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714094400.396467-1-jolsa@kernel.org>
References: <20210714094400.396467-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Storing caller's ip in trampoline's stack. Trampoline programs
can reach the IP in (ctx - 8) address, so there's no change in
program's arguments interface.

The IP address is takes from [fp + 8], which is return address
from the initial 'call fentry' call to trampoline.

This IP address will be returned via bpf_get_func_ip helper
helper, which is added in following patches.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 19 +++++++++++++++++++
 include/linux/bpf.h         |  5 +++++
 2 files changed, 24 insertions(+)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index e835164189f1..c320b3ce7b58 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1951,6 +1951,9 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	if (flags & BPF_TRAMP_F_CALL_ORIG)
 		stack_size += 8; /* room for return value of orig_call */
 
+	if (flags & BPF_TRAMP_F_IP_ARG)
+		stack_size += 8; /* room for IP address argument */
+
 	if (flags & BPF_TRAMP_F_SKIP_FRAME)
 		/* skip patched call instruction and point orig_call to actual
 		 * body of the kernel function.
@@ -1964,6 +1967,22 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	EMIT4(0x48, 0x83, 0xEC, stack_size); /* sub rsp, stack_size */
 	EMIT1(0x53);		 /* push rbx */
 
+	if (flags & BPF_TRAMP_F_IP_ARG) {
+		/* Store IP address of the traced function:
+		 * mov rax, QWORD PTR [rbp + 8]
+		 * sub rax, X86_PATCH_SIZE
+		 * mov QWORD PTR [rbp - stack_size], rax
+		 */
+		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
+		EMIT4(0x48, 0x83, 0xe8, X86_PATCH_SIZE);
+		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -stack_size);
+
+		/* Continue with stack_size for regs storage, stack will
+		 * be correctly restored with 'leave' instruction.
+		 */
+		stack_size -= 8;
+	}
+
 	save_regs(m, &prog, nr_args, stack_size);
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4afbff308ca3..1ebb7690af91 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -554,6 +554,11 @@ struct btf_func_model {
  */
 #define BPF_TRAMP_F_SKIP_FRAME		BIT(2)
 
+/* Store IP address of the caller on the trampoline stack,
+ * so it's available for trampoline's programs.
+ */
+#define BPF_TRAMP_F_IP_ARG		BIT(3)
+
 /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
  * bytes on x86.  Pick a number to fit into BPF_IMAGE_SIZE / 2
  */
-- 
2.31.1

