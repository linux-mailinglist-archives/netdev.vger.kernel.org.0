Return-Path: <netdev+bounces-10196-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9478772CC60
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 19:24:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 264991C20B97
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB4EC21CD8;
	Mon, 12 Jun 2023 17:23:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA49C21CD7
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 17:23:15 +0000 (UTC)
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13561B2
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:23:14 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53f6e194e7bso3347536a12.1
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686590593; x=1689182593;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FP8q+5eUSu4wPpJtNuCq9IaYUWNjGUb+IDjkhrKxnb4=;
        b=HMBStsomonxgE+Takijk8DdwhNkorBPxQrJsyO28txFdFFl+ezHVRkSrnprgMs331L
         PLKmPqg7sX3wXQ0EzcwrteWtrgqItBv1Tthf01cK7qhDbGTyH8Cz0Vf9zH4Yf5u3rYQ7
         sh0bumzHOTfdE1BAMSMJPx9fZtstlaKsFoMgRON8Ew8+5gx6n1bYLoKNsL/71glKeriQ
         dRidk/x3tC18Y+nGJa1ZinHJ4io4FnLUW7Z0CtQbsZXCv2EvP+vx8Th+Ltg3YG4oyU78
         QREfWfEBU/VhI5yfRYsu7b/oGGEAPBL3A7KZG2Y8feYPH+3wU+D6jlw5wt7Bm4NgC2Uv
         XpFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686590593; x=1689182593;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FP8q+5eUSu4wPpJtNuCq9IaYUWNjGUb+IDjkhrKxnb4=;
        b=J7IThEauIzsNVJyD3xXOnwWmENJiR+cpPGlW3QLmbBC6pI6TI9szV3Nh1odMipB6ml
         MNFf+h6GbiY3TiZgvl5ZSEjFHArtyF7+8EI522g5bVKmYmPcvVptjpiqw3+UIKG8YyQr
         O4GPdo8MWgGUbEtwjiPJ8SPIFy3d6mzSEWk0njFffIqTvOEQfP77HAurTI4aKHA8d8iA
         r5MrJjFrZNlwEu/lbkQoxl0sUHkkDR/aAxgdglcJv0PVyIUac47tzx+QoVXNqYRqT/+9
         O+aAFlok4UWETI+t/8PZxWCpOYE+/j59gWL9ZBOYx0UfwkKP07nsI52yFvQuMpwH+ty2
         XnJQ==
X-Gm-Message-State: AC+VfDxR3ndIonCvA4RUi8Audt/ZiTM+o+jVp6laINmcE8hKC++QaS43
	ndjcFKre27xly1zExS1WECzk8nM=
X-Google-Smtp-Source: ACHHUZ46VZr3yPfTmWOnupyzuND0woV05E5Xrcx0bKmzQ12URiZIUXnrXE+LyUc+3yeErt6sV3E6Nzk=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:d356:b0:256:335f:d59a with SMTP id
 i22-20020a17090ad35600b00256335fd59amr1633332pjx.3.1686590593535; Mon, 12 Jun
 2023 10:23:13 -0700 (PDT)
Date: Mon, 12 Jun 2023 10:23:03 -0700
In-Reply-To: <20230612172307.3923165-1-sdf@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230612172307.3923165-4-sdf@google.com>
Subject: [RFC bpf-next 3/7] bpf: implement devtx hook points
From: Stanislav Fomichev <sdf@google.com>
To: bpf@vger.kernel.org
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, 
	kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

devtx is a lightweight set of hooks before and after packet transmission.
The hook is supposed to work for both skb and xdp paths by exposing
a light-weight packet wrapper via devtx_frame (header portion + frags).

devtx is implemented as a tracing program which has access to the
XDP-metadata-like kfuncs. The initial set of kfuncs is implemented
in the next patch, but the idea is similar to XDP metadata:
the kfuncs have netdev-specific implementation, but common
interface. Upon loading, the kfuncs are resolved to direct
calls against per-netdev implementation. This can be achieved
by marking devtx-tracing programs as dev-bound (largely
reusing xdp-dev-bound program infrastructure).

Attachment and detachment is implemented via syscall BPF program
by calling bpf_devtx_sb_attach (attach to tx-submission)
or bpf_devtx_cp_attach (attach to tx completion). Right now,
the attachment does not return a link and doesn't support
multiple programs. I plan to switch to Daniel's bpf_mprog infra
once it's available.

Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 MAINTAINERS               |   2 +
 include/linux/netdevice.h |   2 +
 include/net/devtx.h       |  76 ++++++++++++++
 kernel/bpf/offload.c      |   6 ++
 net/core/Makefile         |   1 +
 net/core/dev.c            |   2 +
 net/core/devtx.c          | 208 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 297 insertions(+)
 create mode 100644 include/net/devtx.h
 create mode 100644 net/core/devtx.c

diff --git a/MAINTAINERS b/MAINTAINERS
index c904dba1733b..516529b42e66 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22976,11 +22976,13 @@ L:	bpf@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/*/*/*/*/*xdp*
 F:	drivers/net/ethernet/*/*/*xdp*
+F:	include/net/devtx.h
 F:	include/net/xdp.h
 F:	include/net/xdp_priv.h
 F:	include/trace/events/xdp.h
 F:	kernel/bpf/cpumap.c
 F:	kernel/bpf/devmap.c
+F:	net/core/devtx.c
 F:	net/core/xdp.c
 F:	samples/bpf/xdp*
 F:	tools/testing/selftests/bpf/*/*xdp*
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 08fbd4622ccf..e08e3fd39dfc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2238,6 +2238,8 @@ struct net_device {
 	unsigned int		real_num_rx_queues;
 
 	struct bpf_prog __rcu	*xdp_prog;
+	struct bpf_prog	__rcu	*devtx_sb;
+	struct bpf_prog	__rcu	*devtx_cp;
 	unsigned long		gro_flush_timeout;
 	int			napi_defer_hard_irqs;
 #define GRO_LEGACY_MAX_SIZE	65536u
diff --git a/include/net/devtx.h b/include/net/devtx.h
new file mode 100644
index 000000000000..7eab66d0ce80
--- /dev/null
+++ b/include/net/devtx.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __LINUX_NET_DEVTX_H__
+#define __LINUX_NET_DEVTX_H__
+
+#include <linux/jump_label.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <net/xdp.h>
+
+struct devtx_frame {
+	void *data;
+	u16 len;
+	struct skb_shared_info *sinfo; /* for frags */
+};
+
+#ifdef CONFIG_NET
+void devtx_submit(struct net_device *netdev, struct devtx_frame *ctx);
+void devtx_complete(struct net_device *netdev, struct devtx_frame *ctx);
+bool is_devtx_kfunc(u32 kfunc_id);
+void devtx_shutdown(struct net_device *netdev);
+
+static inline void devtx_frame_from_skb(struct devtx_frame *ctx, struct sk_buff *skb)
+{
+	ctx->data = skb->data;
+	ctx->len = skb_headlen(skb);
+	ctx->sinfo = skb_shinfo(skb);
+}
+
+static inline void devtx_frame_from_xdp(struct devtx_frame *ctx, struct xdp_frame *xdpf)
+{
+	ctx->data = xdpf->data;
+	ctx->len = xdpf->len;
+	ctx->sinfo = xdp_frame_has_frags(xdpf) ? xdp_get_shared_info_from_frame(xdpf) : NULL;
+}
+
+DECLARE_STATIC_KEY_FALSE(devtx_enabled);
+
+static inline bool devtx_submit_enabled(struct net_device *netdev)
+{
+	return static_branch_unlikely(&devtx_enabled) &&
+	       rcu_access_pointer(netdev->devtx_sb);
+}
+
+static inline bool devtx_complete_enabled(struct net_device *netdev)
+{
+	return static_branch_unlikely(&devtx_enabled) &&
+	       rcu_access_pointer(netdev->devtx_cp);
+}
+#else
+static inline void devtx_submit(struct net_device *netdev, struct devtx_frame *ctx)
+{
+}
+
+static inline void devtx_complete(struct net_device *netdev, struct devtx_frame *ctx)
+{
+}
+
+static inline bool is_devtx_kfunc(u32 kfunc_id)
+{
+	return false;
+}
+
+static inline void devtx_shutdown(struct net_device *netdev)
+{
+}
+
+static inline void devtx_frame_from_skb(struct devtx_frame *ctx, struct sk_buff *skb)
+{
+}
+
+static inline void devtx_frame_from_xdp(struct devtx_frame *ctx, struct xdp_frame *xdpf)
+{
+}
+#endif
+
+#endif /* __LINUX_NET_DEVTX_H__ */
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 235d81f7e0ed..9cfe96422c80 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -25,6 +25,7 @@
 #include <linux/rhashtable.h>
 #include <linux/rtnetlink.h>
 #include <linux/rwsem.h>
+#include <net/devtx.h>
 
 /* Protects offdevs, members of bpf_offload_netdev and offload members
  * of all progs.
@@ -228,6 +229,7 @@ int bpf_prog_dev_bound_init(struct bpf_prog *prog, union bpf_attr *attr)
 	int err;
 
 	if (attr->prog_type != BPF_PROG_TYPE_SCHED_CLS &&
+	    attr->prog_type != BPF_PROG_TYPE_TRACING &&
 	    attr->prog_type != BPF_PROG_TYPE_XDP)
 		return -EINVAL;
 
@@ -238,6 +240,10 @@ int bpf_prog_dev_bound_init(struct bpf_prog *prog, union bpf_attr *attr)
 	    attr->prog_flags & BPF_F_XDP_DEV_BOUND_ONLY)
 		return -EINVAL;
 
+	if (attr->prog_type == BPF_PROG_TYPE_TRACING &&
+	    !is_devtx_kfunc(prog->aux->attach_btf_id))
+		return -EINVAL;
+
 	netdev = dev_get_by_index(current->nsproxy->net_ns, attr->prog_ifindex);
 	if (!netdev)
 		return -EINVAL;
diff --git a/net/core/Makefile b/net/core/Makefile
index 8f367813bc68..c1db05ccfac7 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -39,4 +39,5 @@ obj-$(CONFIG_FAILOVER) += failover.o
 obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
 obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
+obj-$(CONFIG_BPF_SYSCALL) += devtx.o
 obj-$(CONFIG_OF)	+= of_net.o
diff --git a/net/core/dev.c b/net/core/dev.c
index 3393c2f3dbe8..ef0e65e68024 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -150,6 +150,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/prandom.h>
 #include <linux/once_lite.h>
+#include <net/devtx.h>
 
 #include "dev.h"
 #include "net-sysfs.h"
@@ -10875,6 +10876,7 @@ void unregister_netdevice_many_notify(struct list_head *head,
 		dev_shutdown(dev);
 
 		dev_xdp_uninstall(dev);
+		devtx_shutdown(dev);
 		bpf_dev_bound_netdev_unregister(dev);
 
 		netdev_offload_xstats_disable_all(dev);
diff --git a/net/core/devtx.c b/net/core/devtx.c
new file mode 100644
index 000000000000..b7cbc26d1c01
--- /dev/null
+++ b/net/core/devtx.c
@@ -0,0 +1,208 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <net/devtx.h>
+#include <linux/filter.h>
+
+DEFINE_STATIC_KEY_FALSE(devtx_enabled);
+EXPORT_SYMBOL_GPL(devtx_enabled);
+
+static void devtx_run(struct net_device *netdev, struct devtx_frame *ctx, struct bpf_prog **pprog)
+{
+	struct bpf_prog *prog;
+	void *real_ctx[1] = {ctx};
+
+	prog = rcu_dereference(*pprog);
+	if (likely(prog))
+		bpf_prog_run(prog, real_ctx);
+}
+
+void devtx_submit(struct net_device *netdev, struct devtx_frame *ctx)
+{
+	rcu_read_lock();
+	devtx_run(netdev, ctx, &netdev->devtx_sb);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(devtx_submit);
+
+void devtx_complete(struct net_device *netdev, struct devtx_frame *ctx)
+{
+	rcu_read_lock();
+	devtx_run(netdev, ctx, &netdev->devtx_cp);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(devtx_complete);
+
+/**
+ * devtx_sb - Called for every egress netdev packet
+ *
+ * Note: this function is never actually called by the kernel and declared
+ * only to allow loading an attaching appropriate tracepoints.
+ */
+__weak noinline void devtx_sb(struct devtx_frame *ctx)
+{
+}
+
+/**
+ * devtx_cp - Called upon egress netdev packet completion
+ *
+ * Note: this function is never actually called by the kernel and declared
+ * only to allow loading an attaching appropriate tracepoints.
+ */
+__weak noinline void devtx_cp(struct devtx_frame *ctx)
+{
+}
+
+BTF_SET8_START(bpf_devtx_hook_ids)
+BTF_ID_FLAGS(func, devtx_sb)
+BTF_ID_FLAGS(func, devtx_cp)
+BTF_SET8_END(bpf_devtx_hook_ids)
+
+static const struct btf_kfunc_id_set bpf_devtx_hook_set = {
+	.owner = THIS_MODULE,
+	.set   = &bpf_devtx_hook_ids,
+};
+
+static DEFINE_MUTEX(devtx_attach_lock);
+
+static int __bpf_devtx_detach(struct net_device *netdev, struct bpf_prog **pprog)
+{
+	if (!*pprog)
+		return -EINVAL;
+	bpf_prog_put(*pprog);
+	*pprog = NULL;
+
+	static_branch_dec(&devtx_enabled);
+	return 0;
+}
+
+static int __bpf_devtx_attach(struct net_device *netdev, int prog_fd,
+			      const char *attach_func_name, struct bpf_prog **pprog)
+{
+	struct bpf_prog *prog;
+	int ret = 0;
+
+	if (prog_fd < 0)
+		return __bpf_devtx_detach(netdev, pprog);
+
+	if (*pprog)
+		return -EBUSY;
+
+	prog = bpf_prog_get(prog_fd);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+
+	if (prog->type != BPF_PROG_TYPE_TRACING ||
+	    prog->expected_attach_type != BPF_TRACE_FENTRY ||
+	    !bpf_prog_is_dev_bound(prog->aux) ||
+	    !bpf_offload_dev_match(prog, netdev) ||
+	    strcmp(prog->aux->attach_func_name, attach_func_name)) {
+		bpf_prog_put(prog);
+		return -EINVAL;
+	}
+
+	*pprog = prog;
+	static_branch_inc(&devtx_enabled);
+
+	return ret;
+}
+
+__diag_push();
+__diag_ignore_all("-Wmissing-prototypes",
+		  "Global functions as their definitions will be in vmlinux BTF");
+
+/**
+ * bpf_devtx_sb_attach - Attach devtx 'packet submit' program
+ * @ifindex: netdev interface index.
+ * @prog_fd: BPF program file descriptor.
+ *
+ * Return:
+ * * Returns 0 on success or ``-errno`` on error.
+ */
+__bpf_kfunc int bpf_devtx_sb_attach(int ifindex, int prog_fd)
+{
+	struct net_device *netdev;
+	int ret;
+
+	netdev = dev_get_by_index(current->nsproxy->net_ns, ifindex);
+	if (!netdev)
+		return -EINVAL;
+
+	mutex_lock(&devtx_attach_lock);
+	ret = __bpf_devtx_attach(netdev, prog_fd, "devtx_sb", &netdev->devtx_sb);
+	mutex_unlock(&devtx_attach_lock);
+
+	dev_put(netdev);
+
+	return ret;
+}
+
+/**
+ * bpf_devtx_cp_attach - Attach devtx 'packet complete' program
+ * @ifindex: netdev interface index.
+ * @prog_fd: BPF program file descriptor.
+ *
+ * Return:
+ * * Returns 0 on success or ``-errno`` on error.
+ */
+__bpf_kfunc int bpf_devtx_cp_attach(int ifindex, int prog_fd)
+{
+	struct net_device *netdev;
+	int ret;
+
+	netdev = dev_get_by_index(current->nsproxy->net_ns, ifindex);
+	if (!netdev)
+		return -EINVAL;
+
+	mutex_lock(&devtx_attach_lock);
+	ret = __bpf_devtx_attach(netdev, prog_fd, "devtx_cp", &netdev->devtx_cp);
+	mutex_unlock(&devtx_attach_lock);
+
+	dev_put(netdev);
+
+	return ret;
+}
+
+__diag_pop();
+
+bool is_devtx_kfunc(u32 kfunc_id)
+{
+	return !!btf_id_set8_contains(&bpf_devtx_hook_ids, kfunc_id);
+}
+
+void devtx_shutdown(struct net_device *netdev)
+{
+	mutex_lock(&devtx_attach_lock);
+	__bpf_devtx_detach(netdev, &netdev->devtx_sb);
+	__bpf_devtx_detach(netdev, &netdev->devtx_cp);
+	mutex_unlock(&devtx_attach_lock);
+}
+
+BTF_SET8_START(bpf_devtx_syscall_kfunc_ids)
+BTF_ID_FLAGS(func, bpf_devtx_sb_attach)
+BTF_ID_FLAGS(func, bpf_devtx_cp_attach)
+BTF_SET8_END(bpf_devtx_syscall_kfunc_ids)
+
+static const struct btf_kfunc_id_set bpf_devtx_syscall_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &bpf_devtx_syscall_kfunc_ids,
+};
+
+static int __init devtx_init(void)
+{
+	int ret;
+
+	ret = register_btf_fmodret_id_set(&bpf_devtx_hook_set);
+	if (ret) {
+		pr_warn("failed to register devtx hooks: %d", ret);
+		return ret;
+	}
+
+	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL, &bpf_devtx_syscall_kfunc_set);
+	if (ret) {
+		pr_warn("failed to register syscall kfuncs: %d", ret);
+		return ret;
+	}
+
+	return 0;
+}
+late_initcall(devtx_init);
-- 
2.41.0.162.gfafddb0af9-goog


