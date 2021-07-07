Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B853BF075
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 21:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbhGGTtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 15:49:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39268 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232660AbhGGTtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 15:49:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625687192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QgBr4LV9SR6/Qelufj3zindVEajUhYS2+l3zjx7rHSU=;
        b=LnVMXQFH5pgY3ojaN0hM8HLv970Zpb82XHV+zT1gXHIwUuO8Om/4c/NiWUKOlBAIQ6MLmf
        iVUh+YdUKT6dQeQjT+pIZJzqBvafPFR0JnAaqUtcQo1iI0J5D25R5u1nNnOk7DWQ8Y0+Gv
        mMwfn45MpGDr3HJ7Y1Qc/OD8v9MLjVE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-SArVoU4cOF68W-dbU_wvBg-1; Wed, 07 Jul 2021 15:46:31 -0400
X-MC-Unique: SArVoU4cOF68W-dbU_wvBg-1
Received: by mail-wm1-f71.google.com with SMTP id p4-20020a05600c3584b0290210725ac6bcso2555458wmq.2
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 12:46:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QgBr4LV9SR6/Qelufj3zindVEajUhYS2+l3zjx7rHSU=;
        b=g9WpF5HdG3Jd4+7xSNNtW4J5X1bQT69iUwqvG7IrCSsUe9tugMyz0vRwbwH/DSRtjM
         YxxZMJq+d5+OaRnckuKkNPtsOQpPyqJTxIZLF7rV1Olh20yCRMveALDrX2I7m/z99PxV
         OwAGCJmXxfOWLxckbNfYJ9o/6BzA85Rbhmyba1kBVZwkV34ol/zBFs75xqRsMRJN0Z4J
         OgYALfmWgZhHT5jF59dAMRjE3TwJlNlWPsUKfWNRe3qL16f3F2CoOpI29ntPLlFs85vw
         PEIQYBcHxn3tbdVzc1LlrFlrLv8ZZnBOZ8UYP/+fuRoXt8KTXCed7OyHjRRweBdG5hGX
         Iz8w==
X-Gm-Message-State: AOAM531qFV1nM7OA6V8wZ93MfqC9RrlNm6i+t0Cx543Mkpm/Tcj0VAay
        G4u6eUA/yfWxpmdKXRbdqZ0L/cZWa+NrYIlA0viMcLA7Q2g6pAPlLOkofEsGV8glpTuwCHnvzRc
        qA7lqEjNEa0myKeab
X-Received: by 2002:adf:9084:: with SMTP id i4mr30099347wri.23.1625687190057;
        Wed, 07 Jul 2021 12:46:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLO79EMn3rV783LaMxncMKtw60ZojKfQRrfALZnttyQBWpER13DmAyWOA56j8/XujiSgM20A==
X-Received: by 2002:adf:9084:: with SMTP id i4mr30099335wri.23.1625687189932;
        Wed, 07 Jul 2021 12:46:29 -0700 (PDT)
Received: from krava.redhat.com ([185.153.78.55])
        by smtp.gmail.com with ESMTPSA id b7sm17543795wri.96.2021.07.07.12.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 12:46:29 -0700 (PDT)
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
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH 1/7] bpf, x86: Store caller's ip in trampoline stack
Date:   Wed,  7 Jul 2021 21:46:13 +0200
Message-Id: <20210707194619.151676-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707194619.151676-1-jolsa@kernel.org>
References: <20210707194619.151676-1-jolsa@kernel.org>
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
index f309fc1509f2..6b3da9bc3d16 100644
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

