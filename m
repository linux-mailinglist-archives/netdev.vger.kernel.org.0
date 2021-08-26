Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687203F8F00
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243570AbhHZTmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:42:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42721 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243574AbhHZTmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:42:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/wdRRB3BbU0zTebKEzNMBHGnZzjSnqwp9yN08+1iPjU=;
        b=XTCAJin1neNHFLzJvlySZ/iYT40ae8hFSZJkZURFEHf6vx9IVA08Yk6gXyNzsdp/hXFjPf
        HS8+ckPLzzqvCR7Tsjsm/usVX0QU5nEvkHHHvsslnZnLPq3jFoqeV1zaxmONl5KIn25uRj
        W8StGtpN6vLep/qQ8VemdSyCFsAKgFU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-P-sgEwFcNKGVcLvjhEtTmg-1; Thu, 26 Aug 2021 15:41:24 -0400
X-MC-Unique: P-sgEwFcNKGVcLvjhEtTmg-1
Received: by mail-wr1-f71.google.com with SMTP id b7-20020a5d4d87000000b001575d1053d2so1180801wru.23
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:41:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/wdRRB3BbU0zTebKEzNMBHGnZzjSnqwp9yN08+1iPjU=;
        b=Qg0ZInbm1yKXJ4gtBQeZpPq4McvB8qqUXD2Iu3SfR4Ooi7iTjguO/liILGiR23u6Tj
         FypV52ijpd32CYLE4g3DSszwBLAdqdeOqK3s2OGYYVNqBvBXE93+/zYsmL4xnHgJ7MOO
         UdyQeQ58u7Fn7FDhY6de5tllhjwFUCPSSVzpUuPK3rXxW5MBGUQKoeoLWL9dUdX68QS8
         mZh3c/vaUIqPYrtGm6dJ113oakJdxuVOoDBpEpCZqIKzohSRs91ZW+TEvcclkvHrwbJK
         ufsIX8xlzSwEfmFwz9qxxKJ5OazXfG2SpLaa3i+ll0wyB/ezMOyO3WZqLh5l2geCtppC
         mQXg==
X-Gm-Message-State: AOAM531tHUWuoFNl+BIKazTtXUqXYvZhn6epdLv4JTJSAfhIXVIvc5VS
        ylsyhFQhh1zUuVL6tg/VzOJQBQVdLK8lprd3xn4N29n2LmhM1sLRISG9QEG8xF+NElmeCp1ePyP
        eVRUI09VlLM6d1U5+
X-Received: by 2002:a05:6000:1808:: with SMTP id m8mr5842527wrh.272.1630006882351;
        Thu, 26 Aug 2021 12:41:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhi28xOo8akRuWYI1q+XExG6E1iNF4UXfPNErBo+zAHkd2rbEd372edPEF5IYB7n7bBmLlLA==
X-Received: by 2002:a05:6000:1808:: with SMTP id m8mr5842503wrh.272.1630006882147;
        Thu, 26 Aug 2021 12:41:22 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id l21sm3356742wmh.31.2021.08.26.12.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:41:21 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 19/27] bpf: Attach multi trampoline with ftrace_ops
Date:   Thu, 26 Aug 2021 21:39:14 +0200
Message-Id: <20210826193922.66204-20-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding struct ftrace_ops object to bpf_trampoline_multi
struct and setting it up with all the requested function
addresses.

Adding is_multi_trampoline(tr) hooks to installing functions
to actually install multiple bpf trampoline via ftrace_ops.

I had to add -DCC_USING_FENTRY to several places because
arch/x86/include/asm/ftrace.h would fail the compilation
if it's not defined. Perhaps there's a better way.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 arch/x86/Makefile                     |  7 +++++
 arch/x86/boot/compressed/Makefile     |  4 +++
 drivers/firmware/efi/libstub/Makefile |  3 +++
 include/linux/bpf.h                   |  2 ++
 kernel/bpf/trampoline.c               | 37 +++++++++++++++++++++++++++
 5 files changed, 53 insertions(+)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 307fd0000a83..72986eb38d0b 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -34,6 +34,9 @@ REALMODE_CFLAGS += -fno-stack-protector
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -Wno-address-of-packed-member)
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), $(cc_stack_align4))
 REALMODE_CFLAGS += $(CLANG_FLAGS)
+ifdef CONFIG_DYNAMIC_FTRACE
+     REALMODE_CFLAGS += -DCC_USING_FENTRY
+endif
 export REALMODE_CFLAGS
 
 # BITS is used as extension for files which are available in a 32 bit
@@ -54,6 +57,10 @@ KBUILD_CFLAGS += $(call cc-option,-mno-avx,)
 # Intel CET isn't enabled in the kernel
 KBUILD_CFLAGS += $(call cc-option,-fcf-protection=none)
 
+ifdef CONFIG_DYNAMIC_FTRACE
+     KBUILD_CFLAGS += -DCC_USING_FENTRY
+endif
+
 ifeq ($(CONFIG_X86_32),y)
         BITS := 32
         UTS_MACHINE := i386
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 431bf7f846c3..a93dcbda4de2 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -49,6 +49,10 @@ KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mrelax-relocations=no)
 KBUILD_CFLAGS += -include $(srctree)/include/linux/hidden.h
 KBUILD_CFLAGS += $(CLANG_FLAGS)
 
+ifdef CONFIG_DYNAMIC_FTRACE
+     KBUILD_CFLAGS += -DCC_USING_FENTRY
+endif
+
 # sev.c indirectly inludes inat-table.h which is generated during
 # compilation and stored in $(objtree). Add the directory to the includes so
 # that the compiler finds it even with out-of-tree builds (make O=/some/path).
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index d0537573501e..2fd5d6f55e24 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -15,6 +15,9 @@ cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ \
 				   $(call cc-disable-warning, gnu) \
 				   -fno-asynchronous-unwind-tables \
 				   $(CLANG_FLAGS)
+ifdef CONFIG_DYNAMIC_FTRACE
+     cflags-$(CONFIG_X86)	+= -DCC_USING_FENTRY
+endif
 
 # arm64 uses the full KBUILD_CFLAGS so it's necessary to explicitly
 # disable the stackleak plugin
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 373f45ae7dce..52cbec23665c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/percpu-refcount.h>
 #include <linux/bpfptr.h>
+#include <linux/ftrace.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -703,6 +704,7 @@ struct bpf_trampoline_multi {
 	struct list_head list;
 	u32 *ids;
 	u32 ids_cnt;
+	struct ftrace_ops ops;
 	int tr_cnt;
 	struct bpf_trampoline *tr[];
 };
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 308d58e698be..82e7545a7426 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -179,11 +179,38 @@ static int is_ftrace_location(void *ip)
 	return 1;
 }
 
+static int register_ftrace_multi(struct bpf_trampoline *tr, void *new_addr)
+{
+	struct bpf_trampoline_multi *multi;
+
+	multi = container_of(tr, struct bpf_trampoline_multi, main);
+	return register_ftrace_direct_multi(&multi->ops, (long)new_addr);
+}
+
+static int unregister_ftrace_multi(struct bpf_trampoline *tr, void *old_addr)
+{
+	struct bpf_trampoline_multi *multi;
+
+	multi = container_of(tr, struct bpf_trampoline_multi, main);
+	return unregister_ftrace_direct_multi(&multi->ops);
+}
+
+static int modify_ftrace_multi(struct bpf_trampoline *tr, void *new_addr)
+{
+	struct bpf_trampoline_multi *multi;
+
+	multi = container_of(tr, struct bpf_trampoline_multi, main);
+	return modify_ftrace_direct_multi(&multi->ops, (long)new_addr);
+}
+
 static int unregister_fentry(struct bpf_trampoline *tr, void *old_addr)
 {
 	void *ip = tr->func.addr;
 	int ret;
 
+	if (is_multi_trampoline(tr))
+		return unregister_ftrace_multi(tr, old_addr);
+
 	if (tr->func.ftrace_managed)
 		ret = unregister_ftrace_direct((long)ip, (long)old_addr);
 	else
@@ -199,6 +226,9 @@ static int modify_fentry(struct bpf_trampoline *tr, void *old_addr, void *new_ad
 	void *ip = tr->func.addr;
 	int ret;
 
+	if (is_multi_trampoline(tr))
+		return modify_ftrace_multi(tr, new_addr);
+
 	if (tr->func.ftrace_managed)
 		ret = modify_ftrace_direct((long)ip, (long)old_addr, (long)new_addr);
 	else
@@ -212,6 +242,9 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 	void *ip = tr->func.addr;
 	int ret;
 
+	if (is_multi_trampoline(tr))
+		return register_ftrace_multi(tr, new_addr);
+
 	ret = is_ftrace_location(ip);
 	if (ret < 0)
 		return ret;
@@ -703,6 +736,10 @@ struct bpf_trampoline_multi *bpf_trampoline_multi_get(struct bpf_prog *prog,
 		if (!is_ftrace_location((void *) tgt_info.tgt_addr))
 			goto out_free;
 
+		err = ftrace_set_filter_ip(&multi->ops, tgt_info.tgt_addr, 0, 0);
+		if (err)
+			goto out_free;
+
 		if (nr_args < tgt_info.fmodel.nr_args)
 			nr_args = tgt_info.fmodel.nr_args;
 	}
-- 
2.31.1

