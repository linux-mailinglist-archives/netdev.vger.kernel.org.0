Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6042A4A724A
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 14:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344455AbiBBNxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 08:53:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231912AbiBBNxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 08:53:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643810023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iTqwruTWPfHMFTIBAKX8hnY20kDuzrc4oApkYAdRO6g=;
        b=iRI0cYP1pUemaRfko4RHOvJP0M//SqkNTd2mz7b+lUYyUn4PYctsilYSCoh9THo4J4LYnm
        mCVPSzHNY08NIGhpdySu4ZddtgIedmahyacLUTIkf+LE7uEzU7ma2CS+3gjEW3eFV3ByTj
        vGu8mslNKm0Vn9PhAUkdz96V4JmBXmw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-NK7eBgTIOeKZeNDtwaxH2Q-1; Wed, 02 Feb 2022 08:53:42 -0500
X-MC-Unique: NK7eBgTIOeKZeNDtwaxH2Q-1
Received: by mail-ed1-f69.google.com with SMTP id l16-20020aa7c3d0000000b004070ea10e7fso10366264edr.3
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 05:53:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iTqwruTWPfHMFTIBAKX8hnY20kDuzrc4oApkYAdRO6g=;
        b=rr8kkcL62EvpWFwxs3UwNxzRGl6VhjpuW4mH2INJtDGs7BdkJTjsFF/idqX5WOR4sa
         omsd3ZRuKCcNH2pvZPIYttdlVKzH+2nO5jko/D4o1JhxWToTZfUY8cFg5ReqdvMoPWId
         rJ3CKERw+6Ckv0I7VGfKlr1hzeIAHBK7T+qD+V86BuoBIcxBazLw5+UPnCkvcQEx+Epy
         jBfjq7YDm2Dl71Zs7m/q/Sc8DJ0zX88ZHDFpW3vBUQ20qW6CDQrLczlW0n1OVRjwms6U
         L4vt+b/qOOfH91OAIz3g6C6GDFrlBmwhhNQ0kL/YfQGZWBDZ/zW4hAYc3MvfbytSdPez
         ACBg==
X-Gm-Message-State: AOAM532087M/nqNtPcNrFZ3poUS17k4B+Wi2yc73Tukg/JtkueCCDkoo
        APfiXuRD4f5cPQbRmZK8ZgZ3caOmuziJnUauU7SyFRm5Uh1f+KGiAl7IaZsTtMWatE1ORIwnQxe
        Y6GTIJoQMq3lQsHQg
X-Received: by 2002:a17:906:3602:: with SMTP id q2mr24970101ejb.331.1643810021162;
        Wed, 02 Feb 2022 05:53:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyXzqoQS1ZvJxxLsZ+BwuIIPfRrZtm3dn+Sy3pGMKpT/12UlVJwv5gPSUhL3DCYSekTahKqjg==
X-Received: by 2002:a17:906:3602:: with SMTP id q2mr24970087ejb.331.1643810020887;
        Wed, 02 Feb 2022 05:53:40 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id a18sm2368808edu.31.2022.02.02.05.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 05:53:40 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
Subject: [PATCH 1/8] bpf: Add support to attach kprobe program with fprobe
Date:   Wed,  2 Feb 2022 14:53:26 +0100
Message-Id: <20220202135333.190761-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202135333.190761-1-jolsa@kernel.org>
References: <20220202135333.190761-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding new link type BPF_LINK_TYPE_FPROBE that attaches kprobe program
through fprobe API.

The fprobe API allows to attach probe on multiple functions at once very
fast, because it works on top of ftrace. On the other hand this limits
the probe point to the function entry or return.

The kprobe program gets the same pt_regs input ctx as when it's attached
through the perf API.

Adding new attach type BPF_TRACE_FPROBE that enables such link for kprobe
program.

User provides array of addresses or symbols with count to attach the kprobe
program to. The new link_create uapi interface looks like:

  struct {
          __aligned_u64   syms;
          __aligned_u64   addrs;
          __u32           cnt;
          __u32           flags;
  } fprobe;

The flags field allows single BPF_F_FPROBE_RETURN bit to create return fprobe.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf_types.h      |   1 +
 include/uapi/linux/bpf.h       |  13 ++
 kernel/bpf/syscall.c           | 248 ++++++++++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h |  13 ++
 4 files changed, 270 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 48a91c51c015..e279cea46653 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -140,3 +140,4 @@ BPF_LINK_TYPE(BPF_LINK_TYPE_XDP, xdp)
 #ifdef CONFIG_PERF_EVENTS
 BPF_LINK_TYPE(BPF_LINK_TYPE_PERF_EVENT, perf)
 #endif
+BPF_LINK_TYPE(BPF_LINK_TYPE_FPROBE, fprobe)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a7f0ddedac1f..c0912f0a3dfe 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -997,6 +997,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT,
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
+	BPF_TRACE_FPROBE,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1011,6 +1012,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
 	BPF_LINK_TYPE_PERF_EVENT = 7,
+	BPF_LINK_TYPE_FPROBE = 8,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1118,6 +1120,11 @@ enum bpf_link_type {
  */
 #define BPF_F_XDP_HAS_FRAGS	(1U << 5)
 
+/* link_create.fprobe.flags used in LINK_CREATE command for
+ * BPF_TRACE_FPROBE attach type to create return probe.
+ */
+#define BPF_F_FPROBE_RETURN	(1U << 0)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
@@ -1472,6 +1479,12 @@ union bpf_attr {
 				 */
 				__u64		bpf_cookie;
 			} perf_event;
+			struct {
+				__aligned_u64	syms;
+				__aligned_u64	addrs;
+				__u32		cnt;
+				__u32		flags;
+			} fprobe;
 		};
 	} link_create;
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 72ce1edde950..0cfbb112c8e1 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -32,6 +32,7 @@
 #include <linux/bpf-netns.h>
 #include <linux/rcupdate_trace.h>
 #include <linux/memcontrol.h>
+#include <linux/fprobe.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
 			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -3015,8 +3016,235 @@ static int bpf_perf_link_attach(const union bpf_attr *attr, struct bpf_prog *pro
 	fput(perf_file);
 	return err;
 }
+#else
+static int bpf_perf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_PERF_EVENTS */
 
+#ifdef CONFIG_FPROBE
+
+struct bpf_fprobe_link {
+	struct bpf_link link;
+	struct fprobe fp;
+	unsigned long *addrs;
+};
+
+static void bpf_fprobe_link_release(struct bpf_link *link)
+{
+	struct bpf_fprobe_link *fprobe_link;
+
+	fprobe_link = container_of(link, struct bpf_fprobe_link, link);
+	unregister_fprobe(&fprobe_link->fp);
+}
+
+static void bpf_fprobe_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_fprobe_link *fprobe_link;
+
+	fprobe_link = container_of(link, struct bpf_fprobe_link, link);
+	kfree(fprobe_link->addrs);
+	kfree(fprobe_link);
+}
+
+static const struct bpf_link_ops bpf_fprobe_link_lops = {
+	.release = bpf_fprobe_link_release,
+	.dealloc = bpf_fprobe_link_dealloc,
+};
+
+static int fprobe_link_prog_run(struct bpf_fprobe_link *fprobe_link,
+				struct pt_regs *regs)
+{
+	int err;
+
+	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
+		err = 0;
+		goto out;
+	}
+
+	rcu_read_lock();
+	migrate_disable();
+	err = bpf_prog_run(fprobe_link->link.prog, regs);
+	migrate_enable();
+	rcu_read_unlock();
+
+ out:
+	__this_cpu_dec(bpf_prog_active);
+	return err;
+}
+
+static void fprobe_link_entry_handler(struct fprobe *fp, unsigned long entry_ip,
+				      struct pt_regs *regs)
+{
+	unsigned long saved_ip = instruction_pointer(regs);
+	struct bpf_fprobe_link *fprobe_link;
+
+	/*
+	 * Because fprobe's regs->ip is set to the next instruction of
+	 * dynamic-ftrace insturction, correct entry ip must be set, so
+	 * that the bpf program can access entry address via regs as same
+	 * as kprobes.
+	 */
+	instruction_pointer_set(regs, entry_ip);
+
+	fprobe_link = container_of(fp, struct bpf_fprobe_link, fp);
+	fprobe_link_prog_run(fprobe_link, regs);
+
+	instruction_pointer_set(regs, saved_ip);
+}
+
+static void fprobe_link_exit_handler(struct fprobe *fp, unsigned long entry_ip,
+				     struct pt_regs *regs)
+{
+	unsigned long saved_ip = instruction_pointer(regs);
+	struct bpf_fprobe_link *fprobe_link;
+
+	instruction_pointer_set(regs, entry_ip);
+
+	fprobe_link = container_of(fp, struct bpf_fprobe_link, fp);
+	fprobe_link_prog_run(fprobe_link, regs);
+
+	instruction_pointer_set(regs, saved_ip);
+}
+
+static int fprobe_resolve_syms(const void *usyms, u32 cnt,
+			       unsigned long *addrs)
+{
+	unsigned long addr, size;
+	const char **syms;
+	int err = -ENOMEM;
+	unsigned int i;
+	char *func;
+
+	size = cnt * sizeof(*syms);
+	syms = kzalloc(size, GFP_KERNEL);
+	if (!syms)
+		return -ENOMEM;
+
+	func = kzalloc(KSYM_NAME_LEN, GFP_KERNEL);
+	if (!func)
+		goto error;
+
+	if (copy_from_user(syms, usyms, size)) {
+		err = -EFAULT;
+		goto error;
+	}
+
+	for (i = 0; i < cnt; i++) {
+		err = strncpy_from_user(func, syms[i], KSYM_NAME_LEN);
+		if (err == KSYM_NAME_LEN)
+			err = -E2BIG;
+		if (err < 0)
+			goto error;
+
+		err = -EINVAL;
+		if (func[0] == '\0')
+			goto error;
+		addr = kallsyms_lookup_name(func);
+		if (!addr)
+			goto error;
+		if (!kallsyms_lookup_size_offset(addr, &size, NULL))
+			size = MCOUNT_INSN_SIZE;
+		addr = ftrace_location_range(addr, addr + size - 1);
+		if (!addr)
+			goto error;
+		addrs[i] = addr;
+	}
+
+	err = 0;
+error:
+	kfree(syms);
+	kfree(func);
+	return err;
+}
+
+static int bpf_fprobe_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	struct bpf_fprobe_link *link = NULL;
+	struct bpf_link_primer link_primer;
+	unsigned long *addrs;
+	u32 flags, cnt, size;
+	void __user *uaddrs;
+	void __user *usyms;
+	int err;
+
+	/* no support for 32bit archs yet */
+	if (sizeof(u64) != sizeof(void *))
+		return -EINVAL;
+
+	if (prog->expected_attach_type != BPF_TRACE_FPROBE)
+		return -EINVAL;
+
+	flags = attr->link_create.fprobe.flags;
+	if (flags & ~BPF_F_FPROBE_RETURN)
+		return -EINVAL;
+
+	uaddrs = u64_to_user_ptr(attr->link_create.fprobe.addrs);
+	usyms = u64_to_user_ptr(attr->link_create.fprobe.syms);
+	if ((!uaddrs && !usyms) || (uaddrs && usyms))
+		return -EINVAL;
+
+	cnt = attr->link_create.fprobe.cnt;
+	if (!cnt)
+		return -EINVAL;
+
+	size = cnt * sizeof(*addrs);
+	addrs = kzalloc(size, GFP_KERNEL);
+	if (!addrs)
+		return -ENOMEM;
+
+	if (uaddrs) {
+		if (copy_from_user(addrs, uaddrs, size)) {
+			err = -EFAULT;
+			goto error;
+		}
+	} else {
+		err = fprobe_resolve_syms(usyms, cnt, addrs);
+		if (err)
+			goto error;
+	}
+
+	link = kzalloc(sizeof(*link), GFP_KERNEL);
+	if (!link) {
+		err = -ENOMEM;
+		goto error;
+	}
+
+	bpf_link_init(&link->link, BPF_LINK_TYPE_FPROBE,
+		      &bpf_fprobe_link_lops, prog);
+
+	err = bpf_link_prime(&link->link, &link_primer);
+	if (err)
+		goto error;
+
+	if (flags & BPF_F_FPROBE_RETURN)
+		link->fp.exit_handler = fprobe_link_exit_handler;
+	else
+		link->fp.entry_handler = fprobe_link_entry_handler;
+
+	link->addrs = addrs;
+
+	err = register_fprobe_ips(&link->fp, addrs, cnt);
+	if (err) {
+		bpf_link_cleanup(&link_primer);
+		return err;
+	}
+
+	return bpf_link_settle(&link_primer);
+
+error:
+	kfree(link);
+	kfree(addrs);
+	return err;
+}
+#else /* !CONFIG_FPROBE */
+static int bpf_fprobe_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 #define BPF_RAW_TRACEPOINT_OPEN_LAST_FIELD raw_tracepoint.prog_fd
 
 static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
@@ -4248,7 +4476,7 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
 	return -EINVAL;
 }
 
-#define BPF_LINK_CREATE_LAST_FIELD link_create.iter_info_len
+#define BPF_LINK_CREATE_LAST_FIELD link_create.fprobe.flags
 static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 {
 	enum bpf_prog_type ptype;
@@ -4272,7 +4500,6 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 		ret = tracing_bpf_link_attach(attr, uattr, prog);
 		goto out;
 	case BPF_PROG_TYPE_PERF_EVENT:
-	case BPF_PROG_TYPE_KPROBE:
 	case BPF_PROG_TYPE_TRACEPOINT:
 		if (attr->link_create.attach_type != BPF_PERF_EVENT) {
 			ret = -EINVAL;
@@ -4280,6 +4507,14 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 		}
 		ptype = prog->type;
 		break;
+	case BPF_PROG_TYPE_KPROBE:
+		if (attr->link_create.attach_type != BPF_PERF_EVENT &&
+		    attr->link_create.attach_type != BPF_TRACE_FPROBE) {
+			ret = -EINVAL;
+			goto out;
+		}
+		ptype = prog->type;
+		break;
 	default:
 		ptype = attach_type_to_prog_type(attr->link_create.attach_type);
 		if (ptype == BPF_PROG_TYPE_UNSPEC || ptype != prog->type) {
@@ -4311,13 +4546,16 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 		ret = bpf_xdp_link_attach(attr, prog);
 		break;
 #endif
-#ifdef CONFIG_PERF_EVENTS
 	case BPF_PROG_TYPE_PERF_EVENT:
 	case BPF_PROG_TYPE_TRACEPOINT:
-	case BPF_PROG_TYPE_KPROBE:
 		ret = bpf_perf_link_attach(attr, prog);
 		break;
-#endif
+	case BPF_PROG_TYPE_KPROBE:
+		if (attr->link_create.attach_type == BPF_PERF_EVENT)
+			ret = bpf_perf_link_attach(attr, prog);
+		else
+			ret = bpf_fprobe_link_attach(attr, prog);
+		break;
 	default:
 		ret = -EINVAL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a7f0ddedac1f..c0912f0a3dfe 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -997,6 +997,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT,
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
+	BPF_TRACE_FPROBE,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1011,6 +1012,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
 	BPF_LINK_TYPE_PERF_EVENT = 7,
+	BPF_LINK_TYPE_FPROBE = 8,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1118,6 +1120,11 @@ enum bpf_link_type {
  */
 #define BPF_F_XDP_HAS_FRAGS	(1U << 5)
 
+/* link_create.fprobe.flags used in LINK_CREATE command for
+ * BPF_TRACE_FPROBE attach type to create return probe.
+ */
+#define BPF_F_FPROBE_RETURN	(1U << 0)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
@@ -1472,6 +1479,12 @@ union bpf_attr {
 				 */
 				__u64		bpf_cookie;
 			} perf_event;
+			struct {
+				__aligned_u64	syms;
+				__aligned_u64	addrs;
+				__u32		cnt;
+				__u32		flags;
+			} fprobe;
 		};
 	} link_create;
 
-- 
2.34.1

