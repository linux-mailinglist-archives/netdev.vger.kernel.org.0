Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502F6483DCD
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbiADIKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:10:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36132 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233996AbiADIKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 03:10:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641283836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d9dNAaTWcvbIp4vHuV0yxIeciw50tXTE8p33fm7sGes=;
        b=Cv397FB+u/d4skte4TTvo6XFvmTEjAi/zabY+gpFhMS2XU0HZ50G1r/euhkHDnKebOz18H
        NzkWiKIlxncEEQZEd3ac/hZUGWfK2Mkkt6lpnVuXN7y2OoGAxmObgx6moIeQUatYmBBQQB
        2K4Mb3f/FLuYNl5iYjpFHhnBbnR0Kp4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-326-uNiPLcijMDWsgh8lii5mMw-1; Tue, 04 Jan 2022 03:10:34 -0500
X-MC-Unique: uNiPLcijMDWsgh8lii5mMw-1
Received: by mail-ed1-f70.google.com with SMTP id g2-20020a056402424200b003f8ee03207eso17850948edb.7
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 00:10:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d9dNAaTWcvbIp4vHuV0yxIeciw50tXTE8p33fm7sGes=;
        b=K4kbw2pzZOP3gXQAvXaD4NN2FUwnM5v6Pmb/10asWtEVDDALg6gu/mwzkgpPSVE6rO
         sIzYpLN8BLD0PEGOfJUrOGu4KBz7S14P1IjIkgsR1ARiyR4eYTAibH/4Ec+xqepjtr6K
         x75dvbw37FzXC3gXcZpfxYs8UPCQd+4IbhpoX+nqdaXRWZvpv4/mdh9JWOwzeqHR/DgT
         cP80+s7gS2Wl19YqxCTxtu4EG5KSKRHBh9+WPp0nv+FBVWoGj4P2pSO5whW9+YmGwAQ3
         iaoXDQ0zzIPriMoVIFWvURiBXMvqB8ve7gxzir7CR4zI1odBpcicnJZPJPN+jvCvhBP3
         v/hA==
X-Gm-Message-State: AOAM532dqr/cj/Youk5A8ptjtovYZN1lGw8Kz5/SL7uL0lnOjaGiIwQU
        EMblTT3o7VszpGMqZ6w65wKu+aywACR9+9WGSSsqYAXtJu0PjEhkGHSN5KsZUnEh0itpP5+05r7
        HvsrQgVVyW3x4rsxu
X-Received: by 2002:a05:6402:26c8:: with SMTP id x8mr48451573edd.149.1641283833514;
        Tue, 04 Jan 2022 00:10:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyQypSKunCsrhQU8Y396D/mlBqh08hdLEKOlVGSjC9sDM2Zp3llwS8LfSli6cij6nxfwCzcOA==
X-Received: by 2002:a05:6402:26c8:: with SMTP id x8mr48451552edd.149.1641283833298;
        Tue, 04 Jan 2022 00:10:33 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id zh8sm11174574ejb.1.2022.01.04.00.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 00:10:33 -0800 (PST)
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
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 08/13] bpf: Add kprobe link for attaching raw kprobes
Date:   Tue,  4 Jan 2022 09:09:38 +0100
Message-Id: <20220104080943.113249-9-jolsa@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220104080943.113249-1-jolsa@kernel.org>
References: <20220104080943.113249-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding new link type BPF_LINK_TYPE_KPROBE to attach kprobes
directly through register_kprobe/kretprobe API.

Adding new attach type BPF_TRACE_RAW_KPROBE that enables
such link for kprobe program.

The new link allows to create multiple kprobes link by using
new link_create interface:

  struct {
    __aligned_u64   addrs;
    __u32           cnt;
    __u64           bpf_cookie;
  } kprobe;

Plus new flag BPF_F_KPROBE_RETURN for link_create.flags to
create return probe.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf_types.h      |   1 +
 include/uapi/linux/bpf.h       |  12 +++
 kernel/bpf/syscall.c           | 191 ++++++++++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h |  12 +++
 4 files changed, 211 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 48a91c51c015..a9000feab34e 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -140,3 +140,4 @@ BPF_LINK_TYPE(BPF_LINK_TYPE_XDP, xdp)
 #ifdef CONFIG_PERF_EVENTS
 BPF_LINK_TYPE(BPF_LINK_TYPE_PERF_EVENT, perf)
 #endif
+BPF_LINK_TYPE(BPF_LINK_TYPE_KPROBE, kprobe)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b0383d371b9a..5216b333c688 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -995,6 +995,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT,
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
+	BPF_TRACE_RAW_KPROBE,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1009,6 +1010,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
 	BPF_LINK_TYPE_PERF_EVENT = 7,
+	BPF_LINK_TYPE_KPROBE = 8,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1111,6 +1113,11 @@ enum bpf_link_type {
  */
 #define BPF_F_SLEEPABLE		(1U << 4)
 
+/* link_create flags used in LINK_CREATE command for BPF_TRACE_RAW_KPROBE
+ * attach type.
+ */
+#define BPF_F_KPROBE_RETURN	(1U << 0)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
@@ -1465,6 +1472,11 @@ union bpf_attr {
 				 */
 				__u64		bpf_cookie;
 			} perf_event;
+			struct {
+				__aligned_u64	addrs;
+				__u32		cnt;
+				__u64		bpf_cookie;
+			} kprobe;
 		};
 	} link_create;
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index fa4505f9b611..7e5be63c820f 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -32,6 +32,7 @@
 #include <linux/bpf-netns.h>
 #include <linux/rcupdate_trace.h>
 #include <linux/memcontrol.h>
+#include <linux/kprobes.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
 			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -3014,8 +3015,178 @@ static int bpf_perf_link_attach(const union bpf_attr *attr, struct bpf_prog *pro
 	fput(perf_file);
 	return err;
 }
+#else
+static int bpf_perf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	return -ENOTSUPP;
+}
 #endif /* CONFIG_PERF_EVENTS */
 
+#ifdef CONFIG_HAVE_KPROBES_MULTI_ON_FTRACE
+
+struct bpf_kprobe_link {
+	struct bpf_link link;
+	struct kretprobe rp;
+	bool is_return;
+	kprobe_opcode_t **addrs;
+	u32 cnt;
+	u64 bpf_cookie;
+};
+
+static void bpf_kprobe_link_release(struct bpf_link *link)
+{
+	struct bpf_kprobe_link *kprobe_link;
+
+	kprobe_link = container_of(link, struct bpf_kprobe_link, link);
+
+	if (kprobe_link->is_return)
+		unregister_kretprobe(&kprobe_link->rp);
+	else
+		unregister_kprobe(&kprobe_link->rp.kp);
+}
+
+static void bpf_kprobe_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_kprobe_link *kprobe_link;
+
+	kprobe_link = container_of(link, struct bpf_kprobe_link, link);
+	kfree(kprobe_link->addrs);
+	kfree(kprobe_link);
+}
+
+static const struct bpf_link_ops bpf_kprobe_link_lops = {
+	.release = bpf_kprobe_link_release,
+	.dealloc = bpf_kprobe_link_dealloc,
+};
+
+static int kprobe_link_prog_run(struct bpf_kprobe_link *kprobe_link,
+				struct pt_regs *regs)
+{
+	struct bpf_trace_run_ctx run_ctx;
+	struct bpf_run_ctx *old_run_ctx;
+	int err;
+
+	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
+		err = 0;
+		goto out;
+	}
+
+	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
+	run_ctx.bpf_cookie = kprobe_link->bpf_cookie;
+
+	rcu_read_lock();
+	migrate_disable();
+	err = bpf_prog_run(kprobe_link->link.prog, regs);
+	migrate_enable();
+	rcu_read_unlock();
+
+	bpf_reset_run_ctx(old_run_ctx);
+
+ out:
+	__this_cpu_dec(bpf_prog_active);
+	return err;
+}
+
+static int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
+{
+	struct bpf_kprobe_link *kprobe_link;
+
+	kprobe_link = container_of(kp, struct bpf_kprobe_link, rp.kp);
+	return kprobe_link_prog_run(kprobe_link, regs);
+}
+
+static int
+kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
+{
+	struct kretprobe *rp = get_kretprobe(ri);
+	struct bpf_kprobe_link *kprobe_link;
+
+	kprobe_link = container_of(rp, struct bpf_kprobe_link, rp);
+	return kprobe_link_prog_run(kprobe_link, regs);
+}
+
+static int bpf_kprobe_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	struct bpf_link_primer link_primer;
+	struct bpf_kprobe_link *link;
+	kprobe_opcode_t **addrs;
+	u32 flags, cnt, size;
+	void __user *uaddrs;
+	u64 **tmp;
+	int err;
+
+	flags = attr->link_create.flags;
+	if (flags & ~BPF_F_KPROBE_RETURN)
+		return -EINVAL;
+
+	uaddrs = u64_to_user_ptr(attr->link_create.kprobe.addrs);
+	cnt = attr->link_create.kprobe.cnt;
+	size = cnt * sizeof(*tmp);
+
+	tmp = kzalloc(size, GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+
+	if (copy_from_user(tmp, uaddrs, size)) {
+		err = -EFAULT;
+		goto error;
+	}
+
+	/* TODO add extra copy for 32bit archs */
+	if (sizeof(u64) != sizeof(void *))
+		return -EINVAL;
+
+	addrs = (kprobe_opcode_t **) tmp;
+
+	link = kzalloc(sizeof(*link), GFP_KERNEL);
+	if (!link)
+		return -ENOMEM;
+
+	bpf_link_init(&link->link, BPF_LINK_TYPE_KPROBE, &bpf_kprobe_link_lops, prog);
+
+	err = bpf_link_prime(&link->link, &link_primer);
+	if (err) {
+		kfree(link);
+		goto error;
+	}
+
+	INIT_HLIST_NODE(&link->rp.kp.hlist);
+	INIT_LIST_HEAD(&link->rp.kp.list);
+	link->is_return = flags & BPF_F_KPROBE_RETURN;
+	link->addrs = addrs;
+	link->cnt = cnt;
+	link->bpf_cookie = attr->link_create.kprobe.bpf_cookie;
+
+	link->rp.kp.multi.addrs = addrs;
+	link->rp.kp.multi.cnt = cnt;
+
+	if (link->is_return)
+		link->rp.handler = kretprobe_dispatcher;
+	else
+		link->rp.kp.pre_handler = kprobe_dispatcher;
+
+	if (link->is_return)
+		err = register_kretprobe(&link->rp);
+	else
+		err = register_kprobe(&link->rp.kp);
+
+	if (err) {
+		bpf_link_cleanup(&link_primer);
+		return err;
+	}
+	return bpf_link_settle(&link_primer);
+
+error:
+	kfree(tmp);
+	return err;
+}
+#else /* !CONFIG_HAVE_KPROBES_MULTI_ON_FTRACE */
+static int bpf_kprobe_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	return -ENOTSUPP;
+}
+#endif
+
 #define BPF_RAW_TRACEPOINT_OPEN_LAST_FIELD raw_tracepoint.prog_fd
 
 static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
@@ -4242,7 +4413,7 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
 	return -EINVAL;
 }
 
-#define BPF_LINK_CREATE_LAST_FIELD link_create.iter_info_len
+#define BPF_LINK_CREATE_LAST_FIELD link_create.kprobe.bpf_cookie
 static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 {
 	enum bpf_prog_type ptype;
@@ -4266,7 +4437,6 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 		ret = tracing_bpf_link_attach(attr, uattr, prog);
 		goto out;
 	case BPF_PROG_TYPE_PERF_EVENT:
-	case BPF_PROG_TYPE_KPROBE:
 	case BPF_PROG_TYPE_TRACEPOINT:
 		if (attr->link_create.attach_type != BPF_PERF_EVENT) {
 			ret = -EINVAL;
@@ -4274,6 +4444,14 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 		}
 		ptype = prog->type;
 		break;
+	case BPF_PROG_TYPE_KPROBE:
+		if (attr->link_create.attach_type != BPF_PERF_EVENT &&
+		    attr->link_create.attach_type != BPF_TRACE_RAW_KPROBE) {
+			ret = -EINVAL;
+			goto out;
+		}
+		ptype = prog->type;
+		break;
 	default:
 		ptype = attach_type_to_prog_type(attr->link_create.attach_type);
 		if (ptype == BPF_PROG_TYPE_UNSPEC || ptype != prog->type) {
@@ -4305,13 +4483,16 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
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
+			ret = bpf_kprobe_link_attach(attr, prog);
+		break;
 	default:
 		ret = -EINVAL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b0383d371b9a..5216b333c688 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -995,6 +995,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT,
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
+	BPF_TRACE_RAW_KPROBE,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1009,6 +1010,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
 	BPF_LINK_TYPE_PERF_EVENT = 7,
+	BPF_LINK_TYPE_KPROBE = 8,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1111,6 +1113,11 @@ enum bpf_link_type {
  */
 #define BPF_F_SLEEPABLE		(1U << 4)
 
+/* link_create flags used in LINK_CREATE command for BPF_TRACE_RAW_KPROBE
+ * attach type.
+ */
+#define BPF_F_KPROBE_RETURN	(1U << 0)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
@@ -1465,6 +1472,11 @@ union bpf_attr {
 				 */
 				__u64		bpf_cookie;
 			} perf_event;
+			struct {
+				__aligned_u64	addrs;
+				__u32		cnt;
+				__u64		bpf_cookie;
+			} kprobe;
 		};
 	} link_create;
 
-- 
2.33.1

