Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB955DBC62
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 07:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503836AbfJRFEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 01:04:01 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40918 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503941AbfJRFEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 01:04:00 -0400
Received: by mail-pf1-f196.google.com with SMTP id x127so3078551pfb.7;
        Thu, 17 Oct 2019 22:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lMPcEYS5xafvLJbpWGK/0vwnzdz9Gd+595jpPJa4b6M=;
        b=aKPUSGeJ8tO7TWXDEqDXkHuu/6OoOeacJGCv3+Vb/evIygU7/YNocEqv3oRBZWmgOH
         7pugRdvKZa8VAgY2S0/vpJe6KnHhfv7Hzkgiw6DuWUWX+DFL3rzg671AhpM9I+EtJB1o
         g+4PLkPqV9nR1nUr/phQ1ju5+KnbzBP5qks2YcRqJidSVw7agLLDf3KoOvHMGnmMNvb0
         ILPpVJyf9nroOaDdqgigVIKvFfxBCQcOx5NUXOajLSrklkD0GWy54nZxsq/qCdc6PkI3
         +wrbw0NyrzHJaOKy+Te8PRI5CERCx9I8/qDNTU3yU2S67oAPYBcGmtZ0vLrUK7G4j6XE
         vh3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lMPcEYS5xafvLJbpWGK/0vwnzdz9Gd+595jpPJa4b6M=;
        b=MHGaruOhbBnVylott96pjiKflt2mEhYKYt7gCPMnxp85M7jiNnkiVkYaE5oKKdpv8r
         GUe8fTkZZSsyk/FvhadoARuEGZr9oMgYMZ51v1uT2dhQP2feMiVzNe1AlaaxH7/9YW0b
         vswaTca/BFcyN2rqNlciqnkjI0PrPzC/RiOnZMfYA1Vxmj4rweksEd+JGByTA15vqx20
         ax3K9R2c7XsLELyk4YA4F6J5nxDPMD3vpOFnzJixEaPGbk2JvEy8cjEmJPKUYNXXtLhn
         BaUwSmhRyRRoPwSkH8PgVCKxECOVURj1Sl6ezSnR2y3CgEBpGv7P4PMc+pnV4+2vj0Q4
         olsg==
X-Gm-Message-State: APjAAAXfH+XAH8aMsdMl98DZZZaN1+IvfF0XOHkVw4QDbkR4gMRTMFFu
        5x8piLX/89vmV1xnaXrS9YFKQ5VX
X-Google-Smtp-Source: APXvYqxI1edhZZlcWSkC5PeziVQhdAHlp8SxvVZDy1qaL8P6Pa3SCfdXVNBU5BFqmAlZu3enRtIO6Q==
X-Received: by 2002:a62:6446:: with SMTP id y67mr4086649pfb.47.1571371708365;
        Thu, 17 Oct 2019 21:08:28 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id d11sm4341680pfo.104.2019.10.17.21.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 21:08:27 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: [RFC PATCH v2 bpf-next 01/15] xdp_flow: Add skeleton of XDP based flow offload driver
Date:   Fri, 18 Oct 2019 13:07:34 +0900
Message-Id: <20191018040748.30593-2-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add flow offload driver, xdp_flow_core.c, and skeleton of UMH handling
mechanism. The driver is not called from anywhere yet.

xdp_flow_setup_block() in xdp_flow_core.c is meant to be called when
a net device is bound to a flow block, e.g. ingress qdisc is added.
It loads xdp_flow kernel module and the kmod provides callbacks for
setup phase and flow insertion phase.

xdp_flow_setup() in the kmod will be called from xdp_flow_setup_block()
when ingress qdisc is added, and xdp_flow_setup_block_cb() will be
called when a tc flower filter is added.

The former will request the UMH to load the eBPF program and the latter
will request the UMH to populate maps for flow tables. In this patch
no actual processing is implemented and the following commits implement
them.

The overall mechanism of UMH handling is written referring to bpfilter.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 net/Kconfig                      |   1 +
 net/Makefile                     |   1 +
 net/xdp_flow/.gitignore          |   1 +
 net/xdp_flow/Kconfig             |  16 +++
 net/xdp_flow/Makefile            |  31 +++++
 net/xdp_flow/msgfmt.h            | 102 ++++++++++++++++
 net/xdp_flow/xdp_flow.h          |  23 ++++
 net/xdp_flow/xdp_flow_core.c     | 127 ++++++++++++++++++++
 net/xdp_flow/xdp_flow_kern_mod.c | 250 +++++++++++++++++++++++++++++++++++++++
 net/xdp_flow/xdp_flow_umh.c      | 116 ++++++++++++++++++
 net/xdp_flow/xdp_flow_umh_blob.S |   7 ++
 11 files changed, 675 insertions(+)
 create mode 100644 net/xdp_flow/.gitignore
 create mode 100644 net/xdp_flow/Kconfig
 create mode 100644 net/xdp_flow/Makefile
 create mode 100644 net/xdp_flow/msgfmt.h
 create mode 100644 net/xdp_flow/xdp_flow.h
 create mode 100644 net/xdp_flow/xdp_flow_core.c
 create mode 100644 net/xdp_flow/xdp_flow_kern_mod.c
 create mode 100644 net/xdp_flow/xdp_flow_umh.c
 create mode 100644 net/xdp_flow/xdp_flow_umh_blob.S

diff --git a/net/Kconfig b/net/Kconfig
index 3101bfcb..369ecd0 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -206,6 +206,7 @@ source "net/bridge/netfilter/Kconfig"
 endif
 
 source "net/bpfilter/Kconfig"
+source "net/xdp_flow/Kconfig"
 
 source "net/dccp/Kconfig"
 source "net/sctp/Kconfig"
diff --git a/net/Makefile b/net/Makefile
index 449fc0b..b78d1ef 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -87,3 +87,4 @@ endif
 obj-$(CONFIG_QRTR)		+= qrtr/
 obj-$(CONFIG_NET_NCSI)		+= ncsi/
 obj-$(CONFIG_XDP_SOCKETS)	+= xdp/
+obj-$(CONFIG_XDP_FLOW)		+= xdp_flow/
diff --git a/net/xdp_flow/.gitignore b/net/xdp_flow/.gitignore
new file mode 100644
index 0000000..8cad817
--- /dev/null
+++ b/net/xdp_flow/.gitignore
@@ -0,0 +1 @@
+xdp_flow_umh
diff --git a/net/xdp_flow/Kconfig b/net/xdp_flow/Kconfig
new file mode 100644
index 0000000..a4d79fa
--- /dev/null
+++ b/net/xdp_flow/Kconfig
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0-only
+menuconfig XDP_FLOW
+	bool "XDP based flow offload engine (XDP_FLOW)"
+	depends on NET && BPF_SYSCALL && MEMFD_CREATE
+	help
+	  This builds experimental xdp_flow framework that is aiming to
+	  provide flow software offload functionality via XDP
+
+if XDP_FLOW
+config XDP_FLOW_UMH
+	tristate "xdp_flow kernel module with user mode helper"
+	depends on $(success,$(srctree)/scripts/cc-can-link.sh $(CC))
+	default m
+	help
+	  This builds xdp_flow kernel module with embedded user mode helper
+endif
diff --git a/net/xdp_flow/Makefile b/net/xdp_flow/Makefile
new file mode 100644
index 0000000..f6138c2
--- /dev/null
+++ b/net/xdp_flow/Makefile
@@ -0,0 +1,31 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_XDP_FLOW) += xdp_flow_core.o
+
+ifeq ($(CONFIG_XDP_FLOW_UMH), y)
+# builtin xdp_flow_umh should be compiled with -static
+# since rootfs isn't mounted at the time of __init
+# function is called and do_execv won't find elf interpreter
+STATIC := -static
+endif
+
+quiet_cmd_cc_user = CC      $@
+      cmd_cc_user = $(CC) -Wall -Wmissing-prototypes -O2 -std=gnu89 \
+		    -I$(srctree)/tools/include/ \
+		    -c -o $@ $<
+
+quiet_cmd_ld_user = LD      $@
+      cmd_ld_user = $(CC) $(STATIC) -o $@ $^
+
+$(obj)/xdp_flow_umh.o: $(src)/xdp_flow_umh.c FORCE
+	$(call if_changed,cc_user)
+
+$(obj)/xdp_flow_umh: $(obj)/xdp_flow_umh.o
+	$(call if_changed,ld_user)
+
+clean-files := xdp_flow_umh
+
+$(obj)/xdp_flow_umh_blob.o: $(obj)/xdp_flow_umh
+
+obj-$(CONFIG_XDP_FLOW_UMH) += xdp_flow.o
+xdp_flow-objs += xdp_flow_kern_mod.o xdp_flow_umh_blob.o
diff --git a/net/xdp_flow/msgfmt.h b/net/xdp_flow/msgfmt.h
new file mode 100644
index 0000000..97d8490
--- /dev/null
+++ b/net/xdp_flow/msgfmt.h
@@ -0,0 +1,102 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NET_XDP_FLOW_MSGFMT_H
+#define _NET_XDP_FLOW_MSGFMT_H
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/if_ether.h>
+#include <linux/in6.h>
+
+#define MAX_XDP_FLOW_ACTIONS 32
+
+enum xdp_flow_action_id {
+	/* ABORT if 0, i.e. uninitialized */
+	XDP_FLOW_ACTION_ACCEPT	= 1,
+	XDP_FLOW_ACTION_DROP,
+	XDP_FLOW_ACTION_REDIRECT,
+	XDP_FLOW_ACTION_VLAN_PUSH,
+	XDP_FLOW_ACTION_VLAN_POP,
+	XDP_FLOW_ACTION_VLAN_MANGLE,
+	XDP_FLOW_ACTION_MANGLE,
+	XDP_FLOW_ACTION_CSUM,
+	NR_XDP_FLOW_ACTION,
+};
+
+struct xdp_flow_action {
+	enum xdp_flow_action_id	id;
+	union {
+		int	ifindex;	/* REDIRECT */
+		struct {		/* VLAN */
+			__be16	proto;
+			__be16	tci;
+		} vlan;
+	};
+};
+
+struct xdp_flow_actions {
+	unsigned int num_actions;
+	struct xdp_flow_action actions[MAX_XDP_FLOW_ACTIONS];
+};
+
+struct xdp_flow_key {
+	struct {
+		__u8	dst[ETH_ALEN] __aligned(2);
+		__u8	src[ETH_ALEN] __aligned(2);
+		__be16	type;
+	} eth;
+	struct {
+		__be16	tpid;
+		__be16	tci;
+	} vlan;
+	struct {
+		__u8	proto;
+		__u8	ttl;
+		__u8	tos;
+		__u8	frag;
+	} ip;
+	union {
+		struct {
+			__be32	src;
+			__be32	dst;
+		} ipv4;
+		struct {
+			struct in6_addr	src;
+			struct in6_addr	dst;
+		} ipv6;
+	};
+	struct {
+		__be16	src;
+		__be16	dst;
+	} l4port;
+	struct {
+		__be16	flags;
+	} tcp;
+} __aligned(BITS_PER_LONG / 8);
+
+struct xdp_flow {
+	struct xdp_flow_key key;
+	struct xdp_flow_key mask;
+	struct xdp_flow_actions actions;
+	__u16 priority;
+};
+
+enum xdp_flow_cmd {
+	XDP_FLOW_CMD_NOOP		= 0,
+	XDP_FLOW_CMD_LOAD,
+	XDP_FLOW_CMD_UNLOAD,
+	XDP_FLOW_CMD_REPLACE,
+	XDP_FLOW_CMD_DELETE,
+};
+
+struct mbox_request {
+	int ifindex;
+	__u8 cmd;
+	struct xdp_flow flow;
+};
+
+struct mbox_reply {
+	int status;
+	__u32 id;
+};
+
+#endif
diff --git a/net/xdp_flow/xdp_flow.h b/net/xdp_flow/xdp_flow.h
new file mode 100644
index 0000000..656ceab
--- /dev/null
+++ b/net/xdp_flow/xdp_flow.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_XDP_FLOW_H
+#define _LINUX_XDP_FLOW_H
+
+#include <linux/netdevice.h>
+#include <linux/umh.h>
+#include <net/flow_offload.h>
+
+struct xdp_flow_umh_ops {
+	struct umh_info info;
+	/* serialize access to this object and UMH */
+	struct mutex lock;
+	flow_setup_cb_t *setup_cb;
+	int (*setup)(struct net_device *dev, bool do_bind,
+		     struct netlink_ext_ack *extack);
+	int (*start)(void);
+	bool stop;
+	struct module *module;
+};
+
+extern struct xdp_flow_umh_ops xdp_flow_ops;
+
+#endif
diff --git a/net/xdp_flow/xdp_flow_core.c b/net/xdp_flow/xdp_flow_core.c
new file mode 100644
index 0000000..8265aef
--- /dev/null
+++ b/net/xdp_flow/xdp_flow_core.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kmod.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include "xdp_flow.h"
+
+struct xdp_flow_umh_ops xdp_flow_ops;
+EXPORT_SYMBOL_GPL(xdp_flow_ops);
+
+static LIST_HEAD(xdp_block_cb_list);
+
+static void xdp_flow_block_release(void *cb_priv)
+{
+	struct net_device *dev = cb_priv;
+	struct netlink_ext_ack extack;
+
+	mutex_lock(&xdp_flow_ops.lock);
+	xdp_flow_ops.setup(dev, false, &extack);
+	module_put(xdp_flow_ops.module);
+	mutex_unlock(&xdp_flow_ops.lock);
+}
+
+int xdp_flow_setup_block(struct net_device *dev, struct flow_block_offload *f)
+{
+	struct flow_block_cb *block_cb;
+	int err = 0;
+
+	/* TODO: Remove this limitation */
+	if (!net_eq(current->nsproxy->net_ns, &init_net))
+		return -EOPNOTSUPP;
+
+	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&xdp_flow_ops.lock);
+	if (!xdp_flow_ops.module) {
+		mutex_unlock(&xdp_flow_ops.lock);
+		if (f->command == FLOW_BLOCK_UNBIND)
+			return -ENOENT;
+		err = request_module("xdp_flow");
+		if (err)
+			return err;
+		mutex_lock(&xdp_flow_ops.lock);
+		if (!xdp_flow_ops.module) {
+			err = -ECHILD;
+			goto out;
+		}
+	}
+	if (xdp_flow_ops.stop) {
+		err = xdp_flow_ops.start();
+		if (err)
+			goto out;
+	}
+
+	f->driver_block_list = &xdp_block_cb_list;
+
+	switch (f->command) {
+	case FLOW_BLOCK_BIND:
+		if (flow_block_cb_is_busy(xdp_flow_ops.setup_cb, dev,
+					  &xdp_block_cb_list)) {
+			err = -EBUSY;
+			goto out;
+		}
+
+		if (!try_module_get(xdp_flow_ops.module)) {
+			err = -ECHILD;
+			goto out;
+		}
+
+		err = xdp_flow_ops.setup(dev, true, f->extack);
+		if (err) {
+			module_put(xdp_flow_ops.module);
+			goto out;
+		}
+
+		block_cb = flow_block_cb_alloc(xdp_flow_ops.setup_cb, dev, dev,
+					       xdp_flow_block_release);
+		if (IS_ERR(block_cb)) {
+			xdp_flow_ops.setup(dev, false, f->extack);
+			module_put(xdp_flow_ops.module);
+			err = PTR_ERR(block_cb);
+			goto out;
+		}
+
+		flow_block_cb_add(block_cb, f);
+		list_add_tail(&block_cb->driver_list, &xdp_block_cb_list);
+		break;
+	case FLOW_BLOCK_UNBIND:
+		block_cb = flow_block_cb_lookup(f->block, xdp_flow_ops.setup_cb,
+						dev);
+		if (!block_cb) {
+			err = -ENOENT;
+			goto out;
+		}
+
+		flow_block_cb_remove(block_cb, f);
+		list_del(&block_cb->driver_list);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+	}
+out:
+	mutex_unlock(&xdp_flow_ops.lock);
+
+	return err;
+}
+
+static void xdp_flow_umh_cleanup(struct umh_info *info)
+{
+	mutex_lock(&xdp_flow_ops.lock);
+	xdp_flow_ops.stop = true;
+	fput(info->pipe_to_umh);
+	fput(info->pipe_from_umh);
+	info->pid = 0;
+	mutex_unlock(&xdp_flow_ops.lock);
+}
+
+static int __init xdp_flow_init(void)
+{
+	mutex_init(&xdp_flow_ops.lock);
+	xdp_flow_ops.stop = true;
+	xdp_flow_ops.info.cmdline = "xdp_flow_umh";
+	xdp_flow_ops.info.cleanup = &xdp_flow_umh_cleanup;
+
+	return 0;
+}
+device_initcall(xdp_flow_init);
diff --git a/net/xdp_flow/xdp_flow_kern_mod.c b/net/xdp_flow/xdp_flow_kern_mod.c
new file mode 100644
index 0000000..14e06ee
--- /dev/null
+++ b/net/xdp_flow/xdp_flow_kern_mod.c
@@ -0,0 +1,250 @@
+// SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/module.h>
+#include <linux/umh.h>
+#include <linux/sched/signal.h>
+#include <linux/rtnetlink.h>
+#include "xdp_flow.h"
+#include "msgfmt.h"
+
+extern char xdp_flow_umh_start;
+extern char xdp_flow_umh_end;
+
+static void shutdown_umh(void)
+{
+	struct task_struct *tsk;
+
+	if (xdp_flow_ops.stop)
+		return;
+
+	tsk = get_pid_task(find_vpid(xdp_flow_ops.info.pid), PIDTYPE_PID);
+	if (tsk) {
+		send_sig(SIGKILL, tsk, 1);
+		put_task_struct(tsk);
+	}
+}
+
+static int transact_umh(struct mbox_request *req, u32 *id)
+{
+	struct mbox_reply reply;
+	int ret = -EFAULT;
+	loff_t pos;
+	ssize_t n;
+
+	if (!xdp_flow_ops.info.pid)
+		goto out;
+
+	n = __kernel_write(xdp_flow_ops.info.pipe_to_umh, req, sizeof(*req),
+			   &pos);
+	if (n != sizeof(*req)) {
+		pr_err("write fail %zd\n", n);
+		shutdown_umh();
+		goto out;
+	}
+
+	pos = 0;
+	n = kernel_read(xdp_flow_ops.info.pipe_from_umh, &reply,
+			sizeof(reply), &pos);
+	if (n != sizeof(reply)) {
+		pr_err("read fail %zd\n", n);
+		shutdown_umh();
+		goto out;
+	}
+
+	ret = reply.status;
+	if (id)
+		*id = reply.id;
+out:
+	return ret;
+}
+
+static int xdp_flow_replace(struct net_device *dev, struct flow_cls_offload *f)
+{
+	return -EOPNOTSUPP;
+}
+
+static int xdp_flow_destroy(struct net_device *dev, struct flow_cls_offload *f)
+{
+	return -EOPNOTSUPP;
+}
+
+static int xdp_flow_setup_flower(struct net_device *dev,
+				 struct flow_cls_offload *f)
+{
+	switch (f->command) {
+	case FLOW_CLS_REPLACE:
+		return xdp_flow_replace(dev, f);
+	case FLOW_CLS_DESTROY:
+		return xdp_flow_destroy(dev, f);
+	case FLOW_CLS_STATS:
+	case FLOW_CLS_TMPLT_CREATE:
+	case FLOW_CLS_TMPLT_DESTROY:
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int xdp_flow_setup_block_cb(enum tc_setup_type type, void *type_data,
+				   void *cb_priv)
+{
+	struct flow_cls_common_offload *common = type_data;
+	struct net_device *dev = cb_priv;
+	int err = 0;
+
+	if (common->chain_index) {
+		NL_SET_ERR_MSG_MOD(common->extack,
+				   "Supports only offload of chain 0");
+		return -EOPNOTSUPP;
+	}
+
+	if (type != TC_SETUP_CLSFLOWER)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&xdp_flow_ops.lock);
+	if (xdp_flow_ops.stop) {
+		err = xdp_flow_ops.start();
+		if (err)
+			goto out;
+	}
+
+	err = xdp_flow_setup_flower(dev, type_data);
+out:
+	mutex_unlock(&xdp_flow_ops.lock);
+	return err;
+}
+
+static int xdp_flow_setup_bind(struct net_device *dev,
+			       struct netlink_ext_ack *extack)
+{
+	struct mbox_request *req;
+	u32 id = 0;
+	int err;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	req->cmd = XDP_FLOW_CMD_LOAD;
+	req->ifindex = dev->ifindex;
+
+	/* Load bpf in UMH and get prog id */
+	err = transact_umh(req, &id);
+
+	/* TODO: id will be used to attach bpf prog to XDP
+	 * As we have rtnl_lock, UMH cannot attach prog to XDP
+	 */
+
+	kfree(req);
+
+	return err;
+}
+
+static int xdp_flow_setup_unbind(struct net_device *dev,
+				 struct netlink_ext_ack *extack)
+{
+	struct mbox_request *req;
+	int err;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	req->cmd = XDP_FLOW_CMD_UNLOAD;
+	req->ifindex = dev->ifindex;
+
+	err = transact_umh(req, NULL);
+
+	kfree(req);
+
+	return err;
+}
+
+static int xdp_flow_setup(struct net_device *dev, bool do_bind,
+			  struct netlink_ext_ack *extack)
+{
+	ASSERT_RTNL();
+
+	if (!net_eq(dev_net(dev), &init_net))
+		return -EINVAL;
+
+	return do_bind ?
+		xdp_flow_setup_bind(dev, extack) :
+		xdp_flow_setup_unbind(dev, extack);
+}
+
+static int xdp_flow_test(void)
+{
+	struct mbox_request *req;
+	int err;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	req->cmd = XDP_FLOW_CMD_NOOP;
+	err = transact_umh(req, NULL);
+
+	kfree(req);
+
+	return err;
+}
+
+static int start_umh(void)
+{
+	int err;
+
+	/* fork usermode process */
+	err = fork_usermode_blob(&xdp_flow_umh_start,
+				 &xdp_flow_umh_end - &xdp_flow_umh_start,
+				 &xdp_flow_ops.info);
+	if (err)
+		return err;
+
+	xdp_flow_ops.stop = false;
+	pr_info("Loaded xdp_flow_umh pid %d\n", xdp_flow_ops.info.pid);
+
+	/* health check that usermode process started correctly */
+	if (xdp_flow_test()) {
+		shutdown_umh();
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int __init load_umh(void)
+{
+	int err = 0;
+
+	mutex_lock(&xdp_flow_ops.lock);
+	if (!xdp_flow_ops.stop) {
+		err = -EFAULT;
+		goto err;
+	}
+
+	err = start_umh();
+	if (err)
+		goto err;
+
+	xdp_flow_ops.setup_cb = &xdp_flow_setup_block_cb;
+	xdp_flow_ops.setup = &xdp_flow_setup;
+	xdp_flow_ops.start = &start_umh;
+	xdp_flow_ops.module = THIS_MODULE;
+err:
+	mutex_unlock(&xdp_flow_ops.lock);
+	return err;
+}
+
+static void __exit fini_umh(void)
+{
+	mutex_lock(&xdp_flow_ops.lock);
+	shutdown_umh();
+	xdp_flow_ops.module = NULL;
+	xdp_flow_ops.start = NULL;
+	xdp_flow_ops.setup = NULL;
+	xdp_flow_ops.setup_cb = NULL;
+	mutex_unlock(&xdp_flow_ops.lock);
+}
+module_init(load_umh);
+module_exit(fini_umh);
+MODULE_LICENSE("GPL");
diff --git a/net/xdp_flow/xdp_flow_umh.c b/net/xdp_flow/xdp_flow_umh.c
new file mode 100644
index 0000000..c642b5b
--- /dev/null
+++ b/net/xdp_flow/xdp_flow_umh.c
@@ -0,0 +1,116 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <errno.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <syslog.h>
+#include "msgfmt.h"
+
+FILE *kmsg;
+
+#define pr_log(fmt, prio, ...) fprintf(kmsg, "<%d>xdp_flow_umh: " fmt, \
+				       LOG_DAEMON | (prio), ##__VA_ARGS__)
+#ifdef DEBUG
+#define pr_debug(fmt, ...) pr_log(fmt, LOG_DEBUG, ##__VA_ARGS__)
+#else
+#define pr_debug(fmt, ...) do {} while (0)
+#endif
+#define pr_info(fmt, ...) pr_log(fmt, LOG_INFO, ##__VA_ARGS__)
+#define pr_warn(fmt, ...) pr_log(fmt, LOG_WARNING, ##__VA_ARGS__)
+#define pr_err(fmt, ...) pr_log(fmt, LOG_ERR, ##__VA_ARGS__)
+
+static int handle_load(const struct mbox_request *req, __u32 *prog_id)
+{
+	*prog_id = 0;
+
+	return 0;
+}
+
+static int handle_unload(const struct mbox_request *req)
+{
+	return 0;
+}
+
+static int handle_replace(struct mbox_request *req)
+{
+	return -EOPNOTSUPP;
+}
+
+static int handle_delete(const struct mbox_request *req)
+{
+	return -EOPNOTSUPP;
+}
+
+static void loop(void)
+{
+	struct mbox_request *req;
+
+	req = malloc(sizeof(struct mbox_request));
+	if (!req) {
+		pr_err("Memory allocation for mbox_request failed\n");
+		return;
+	}
+
+	while (1) {
+		struct mbox_reply reply;
+		int n;
+
+		n = read(0, req, sizeof(*req));
+		if (n < 0) {
+			pr_err("read for mbox_request failed: %s\n",
+			       strerror(errno));
+			break;
+		}
+		if (n != sizeof(*req)) {
+			pr_err("Invalid request size %d\n", n);
+			break;
+		}
+
+		switch (req->cmd) {
+		case XDP_FLOW_CMD_NOOP:
+			reply.status = 0;
+			break;
+		case XDP_FLOW_CMD_LOAD:
+			reply.status = handle_load(req, &reply.id);
+			break;
+		case XDP_FLOW_CMD_UNLOAD:
+			reply.status = handle_unload(req);
+			break;
+		case XDP_FLOW_CMD_REPLACE:
+			reply.status = handle_replace(req);
+			break;
+		case XDP_FLOW_CMD_DELETE:
+			reply.status = handle_delete(req);
+			break;
+		default:
+			pr_err("Invalid command %d\n", req->cmd);
+			reply.status = -EOPNOTSUPP;
+		}
+
+		n = write(1, &reply, sizeof(reply));
+		if (n < 0) {
+			pr_err("write for mbox_reply failed: %s\n",
+			       strerror(errno));
+			break;
+		}
+		if (n != sizeof(reply)) {
+			pr_err("reply written too short: %d\n", n);
+			break;
+		}
+	}
+
+	free(req);
+}
+
+int main(void)
+{
+	kmsg = fopen("/dev/kmsg", "a");
+	setvbuf(kmsg, NULL, _IONBF, 0);
+	pr_info("Started xdp_flow\n");
+	loop();
+	fclose(kmsg);
+
+	return 0;
+}
diff --git a/net/xdp_flow/xdp_flow_umh_blob.S b/net/xdp_flow/xdp_flow_umh_blob.S
new file mode 100644
index 0000000..6edcb0e
--- /dev/null
+++ b/net/xdp_flow/xdp_flow_umh_blob.S
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+	.section .rodata, "a"
+	.global xdp_flow_umh_start
+xdp_flow_umh_start:
+	.incbin "net/xdp_flow/xdp_flow_umh"
+	.global xdp_flow_umh_end
+xdp_flow_umh_end:
-- 
1.8.3.1

