Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB1442CA78
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 21:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238371AbhJMT6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 15:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236791AbhJMT6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 15:58:14 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB2FC061746
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 12:56:11 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id y15so16802971lfk.7
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 12:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=qKH85f/X/bTM1HBd2jb8yR7hV1r7tXpdbyJxEIUbYFg=;
        b=IrFtpUHHjhCjoRTsTIuTweLrfzJObNtGoSCXCsaLWFNHKsTRzgvJ055GYOlkux+FY2
         SL4/Ct2NU4cOXVX5KzbrkO6L4NU3buaYTu0n+RExjMKoh6AkQGFyikPxpPpxolnvDRZv
         /aLUPlSU3vyjEA+TSWAzjLCAYqNpOPqtkCQgg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=qKH85f/X/bTM1HBd2jb8yR7hV1r7tXpdbyJxEIUbYFg=;
        b=2OBCBcNsk4MQnHF6rbQLvCT+sLsjXLcyQ792DzSjW8+NhuOAAOznDHDmyN6ADNV9HY
         SmWjP9GALacyi6r9YueaiV+dbyvcrvKLor9G5QHtL1nlld6CWzlExgV4UigPuVYJbj9P
         Cw104764g24dWDgYEhblMe/rnKmsIrKgDPD2Exf5ez8di/e1F1AHI3Jy1ZaeyAszuxhG
         WjQ7uCpUEw5VStLuqU9N9lnbJ5KIAB1aWQbFxZ5K+aM5dEPtQWJhttzQTfTcBIn/MwQ0
         3bwn247lxNYy9TRYvCJH8RUmkXwdVIO8NThk0haFsrlgYcwqe3uij97PHXONNkOcg2Rz
         eO5A==
X-Gm-Message-State: AOAM531Ug5mHyDZR1hcPklUpQOT4daBlC5riQ3niqH+k/NTteBGf1OuC
        POSYxIX3+yq1Z8dxw/E7rP3xCA==
X-Google-Smtp-Source: ABdhPJwHphrDVmMbMJ7FNjq5CHkLWjARm6t6dQ3Imk/b5ETfBXq/2tEXlahAHUelGKMPUbS6bJZYhQ==
X-Received: by 2002:a05:6512:4029:: with SMTP id br41mr961117lfb.233.1634154969452;
        Wed, 13 Oct 2021 12:56:09 -0700 (PDT)
Received: from cloudflare.com ([2a01:110f:480d:6f00:ff34:bf12:ef2:5071])
        by smtp.gmail.com with ESMTPSA id d19sm47867ljl.87.2021.10.13.12.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 12:56:09 -0700 (PDT)
References: <20211012135935.37054-1-lmb@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     nicolas.dichtel@6wind.com, luke.r.nels@gmail.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com, linux-riscv@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Fix up bpf_jit_limit some more
In-reply-to: <20211012135935.37054-1-lmb@cloudflare.com>
Date:   Wed, 13 Oct 2021 21:56:08 +0200
Message-ID: <87wnmgg0mf.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 03:59 PM CEST, Lorenz Bauer wrote:
> Some more cleanups around bpf_jit_limit to make it readable via sysctl.
>
> Jakub raised the point that a sysctl toggle is UAPI and therefore
> can't be easily changed later on. I tried to find another place to stick
> the info, but couldn't find a good one. All the current BPF knobs are in
> sysctl.
>
> There are examples of read only sysctls:
> $ sudo find /proc/sys -perm 0444 | wc -l
> 90
>
> There are no examples of sysctls with mode 0400 however:
> $ sudo find /proc/sys -perm 0400 | wc -l
> 0
>
> Thoughts?

I threw this idea out there during LPC already, that it would be cool to
use BPF iterators for that. Pinned/preloaded iterators were made for
dumping kernel data on demand after all.

What is missing is a BPF iterator type that would run the program just
once (there is just one thing to print), and a BPF helper to lookup
symbol's address.

I thought this would require a bit of work, but actually getting a PoC
(see below) to work was rather pleasntly straightforward.

Perhaps a bit of a hack but I'd consider it as an alternative.

-- >8 --

From bef52bec926ea08ccd32a3421d195210ae7d3b38 Mon Sep 17 00:00:00 2001
From: Jakub Sitnicki <jakub@cloudflare.com>
Date: Wed, 13 Oct 2021 18:54:12 +0200
Subject: [PATCH] RFC: BPF iterator that always runs the program just once

The test iterator loads the value of bpf_jit_current kernel global:

 # bpftool iter pin tools/testing/selftests/bpf/bpf_iter_once.o /sys/fs/bpf/bpf_jit_current
 libbpf: elf: skipping unrecognized data section(6) .rodata.str1.1
 # cat /sys/fs/bpf/bpf_jit_current
 2
 # for ((i=0; i<10; i++)); do iptables -A OUTPUT -m bpf --bytecode '1,6 0 0 0' -j ACCEPT; done
 # cat /sys/fs/bpf/bpf_jit_current
 12
 # iptables -F OUTPUT
 # cat /sys/fs/bpf/bpf_jit_current
 2

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/uapi/linux/bpf.h                      |  7 ++
 kernel/bpf/Makefile                           |  2 +-
 kernel/bpf/helpers.c                          | 22 ++++++
 kernel/bpf/once_iter.c                        | 76 +++++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  7 ++
 .../selftests/bpf/progs/bpf_iter_once.c       | 33 ++++++++
 6 files changed, 146 insertions(+), 1 deletion(-)
 create mode 100644 kernel/bpf/once_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_once.c

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6fc59d61937a..ec117ebd3d58 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4909,6 +4909,12 @@ union bpf_attr {
  *	Return
  *		The number of bytes written to the buffer, or a negative error
  *		in case of failure.
+ *
+ * long bpf_kallsyms_lookup_name(const char *name, u32 name_size)
+ *	Description
+ *		Lookup the address for a symbol.
+ *	Return
+ *		Returns 0 if not found.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5089,6 +5095,7 @@ union bpf_attr {
 	FN(task_pt_regs),		\
 	FN(get_branch_snapshot),	\
 	FN(trace_vprintk),		\
+	FN(kallsyms_lookup_name),	\
 	/* */

 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 7f33098ca63f..f2dc86ea0f2d 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -6,7 +6,7 @@ cflags-nogcse-$(CONFIG_X86)$(CONFIG_CC_IS_GCC) := -fno-gcse
 endif
 CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)

-obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
+obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o once_iter.o
 obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
 obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 1ffd469c217f..d2524df54ab5 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -15,6 +15,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/proc_ns.h>
 #include <linux/security.h>
+#include <linux/kallsyms.h>

 #include "../../lib/kstrtox.h"

@@ -1328,6 +1329,25 @@ void bpf_timer_cancel_and_free(void *val)
 	kfree(t);
 }

+BPF_CALL_2(bpf_kallsyms_lookup_name, const char *, name, u32, name_size)
+{
+	const char *name_end;
+
+	name_end = strnchr(name, name_size, 0);
+	if (!name_end)
+		return -EINVAL;
+
+	return kallsyms_lookup_name(name);
+}
+
+static const struct bpf_func_proto bpf_kallsyms_lookup_name_proto = {
+	.func		= bpf_kallsyms_lookup_name,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_CONST_SIZE,
+};
+
 const struct bpf_func_proto bpf_get_current_task_proto __weak;
 const struct bpf_func_proto bpf_get_current_task_btf_proto __weak;
 const struct bpf_func_proto bpf_probe_read_user_proto __weak;
@@ -1404,6 +1424,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_timer_start_proto;
 	case BPF_FUNC_timer_cancel:
 		return &bpf_timer_cancel_proto;
+	case BPF_FUNC_kallsyms_lookup_name:
+		return &bpf_kallsyms_lookup_name_proto;
 	default:
 		break;
 	}
diff --git a/kernel/bpf/once_iter.c b/kernel/bpf/once_iter.c
new file mode 100644
index 000000000000..f2635f1b0043
--- /dev/null
+++ b/kernel/bpf/once_iter.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021 Cloudflare, Inc. */
+
+#include <linux/bpf.h>
+#include <linux/init.h>
+#include <linux/seq_file.h>
+
+static struct {} empty;
+
+static void *once_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	if (*pos == 0)
+		++*pos;
+	return &empty;
+}
+
+static void *once_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	++*pos;
+	return NULL;
+}
+
+struct bpf_iter__once {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+};
+
+DEFINE_BPF_ITER_FUNC(once, struct bpf_iter_meta *meta)
+
+static int once_seq_show(struct seq_file *seq, void *v)
+{
+	return 0;
+}
+
+static void once_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpf_iter_meta meta;
+	struct bpf_iter__once ctx;
+	struct bpf_prog *prog;
+
+	meta.seq = seq;
+	prog = bpf_iter_get_info(&meta, true);
+	if (!prog)
+		return;
+
+	meta.seq = seq;
+	ctx.meta = &meta;
+	bpf_iter_run_prog(prog, &ctx);
+}
+
+static const struct seq_operations once_seq_ops = {
+	.start	= once_seq_start,
+	.next	= once_seq_next,
+	.stop	= once_seq_stop,
+	.show	= once_seq_show,
+};
+
+static const struct bpf_iter_seq_info once_seq_info = {
+	.seq_ops		= &once_seq_ops,
+	.init_seq_private	= NULL,
+	.fini_seq_private	= NULL,
+	.seq_priv_size		= 0,
+};
+
+static struct bpf_iter_reg once_reg_info = {
+	.target			= "once",
+	.feature		= 0,
+	.ctx_arg_info_size	= 0,
+	.ctx_arg_info		= {},
+	.seq_info		= &once_seq_info,
+};
+
+static int __init once_iter_init(void)
+{
+	return bpf_iter_reg_target(&once_reg_info);
+}
+late_initcall(once_iter_init);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 6fc59d61937a..ec117ebd3d58 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4909,6 +4909,12 @@ union bpf_attr {
  *	Return
  *		The number of bytes written to the buffer, or a negative error
  *		in case of failure.
+ *
+ * long bpf_kallsyms_lookup_name(const char *name, u32 name_size)
+ *	Description
+ *		Lookup the address for a symbol.
+ *	Return
+ *		Returns 0 if not found.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5089,6 +5095,7 @@ union bpf_attr {
 	FN(task_pt_regs),		\
 	FN(get_branch_snapshot),	\
 	FN(trace_vprintk),		\
+	FN(kallsyms_lookup_name),	\
 	/* */

 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_once.c b/tools/testing/selftests/bpf/progs/bpf_iter_once.c
new file mode 100644
index 000000000000..e5e6d779eb51
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_once.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Cloudflare, Inc. */
+
+#include "bpf_iter.h"
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") = "GPL";
+
+SEC("iter/once")
+int dump_once(struct bpf_iter__once *ctx)
+{
+	const char sym_name[] = "bpf_jit_current";
+	struct seq_file *seq = ctx->meta->seq;
+	unsigned long sym_addr;
+	s64 value = 0;
+	int err;
+
+	sym_addr = bpf_kallsyms_lookup_name(sym_name, sizeof(sym_name));
+	if (!sym_addr) {
+		BPF_SEQ_PRINTF(seq, "failed to find %s address\n", sym_name);
+		return 0;
+	}
+
+	err = bpf_probe_read_kernel(&value, sizeof(value), (void *)sym_addr);
+	if (err) {
+		BPF_SEQ_PRINTF(seq, "failed to read from %s address\n", sym_name);
+		return 0;
+	}
+
+	BPF_SEQ_PRINTF(seq, "%ld\n", value);
+
+	return 0;
+}
--
2.31.1
