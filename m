Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7153D93AD
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhG1Q47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhG1Q44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 12:56:56 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CC9C061757;
        Wed, 28 Jul 2021 09:56:54 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so4988381pji.5;
        Wed, 28 Jul 2021 09:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UsRKk/kgv9ypw74n2nr/jKl7mPBu6wUMfNH6VO8/lBQ=;
        b=UPqP9Lb5laawQjWm6pPL40EThwROcEEzxs+kDW7kvYq0wkuvMxh+4l656sAYgKrLIl
         PaVxa0fPfqv4pRncHp+TxcaoIWdAOwPLvpANZEpqeTOnvvAmCZAMzfhSMW9ILz3fQOxU
         1vGY6/JUNWwIbiVpyI6R9UofnGHnPqcvJ+XoXMS0f3/Ao/HS25mF8eguPuAf5wI9aeAd
         /P7a7Yo8fc0mZ7sboL2F790Z3lYjbFG1hoC+VAWFT8oTPi8MT9EZGrGd4jC4IbicVVzv
         rxsN/x8OyUTSKweSbsB50y3eqY/7ngYdMYPu4YHCAwna9KB1w4SjLNPs1/HQquA7mRaa
         WESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UsRKk/kgv9ypw74n2nr/jKl7mPBu6wUMfNH6VO8/lBQ=;
        b=cvaZtD4ISC2Czl3zmEOgcIWQiIIh+dTpyxpIxd/AxuAF/osh6EQEVJx7oA/paBbjlf
         faPYMVWwd3BZBwRGY4Wxd50Gr48ekeFR679HhBro/xrN/OlmghOP0kp5XrOkyiv0g8mH
         SacDaGBhzcxJfe4aA93EDJhtZ9v3M+j4XWg2RkOSQbKt51q9+VxW9/DqEuisrYzQ6RWC
         c+G781yhMMRf1wBUQCWLd2SJcfDwKUFtJR0TjEMCe3Fquaz5fxHn06STZbTnKXRnwP7t
         C3DQCr6KuwJDtEjW7q5nxBXQgsYbjmdPhq7pKZiEiXQn5SyJ9kWHBbsPz1AZV2JLdY8/
         GgnQ==
X-Gm-Message-State: AOAM5334+c6xrIxTTjLm5wcSyC7REyaUsir/Vruj8QBnIo03lpch4abq
        /TEixpDCUXQ8eYIqb9aqAHtG9uSK7a+8cQ==
X-Google-Smtp-Source: ABdhPJxGQqMrvDIq3ZMdP0hKCLge1jEBNSujFmP5yON4JoE7v3tyivSM3mwM1FCmG/w7bRt0uECxMQ==
X-Received: by 2002:a17:902:7d8f:b029:116:4b69:c7c5 with SMTP id a15-20020a1709027d8fb02901164b69c7c5mr697016plm.58.1627491413545;
        Wed, 28 Jul 2021 09:56:53 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0bb:dc30:f309:2f53:5818])
        by smtp.gmail.com with ESMTPSA id mr18sm267224pjb.39.2021.07.28.09.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 09:56:53 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 3/8] samples: bpf: Add BPF support for XDP samples helper
Date:   Wed, 28 Jul 2021 22:25:47 +0530
Message-Id: <20210728165552.435050-4-memxor@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210728165552.435050-1-memxor@gmail.com>
References: <20210728165552.435050-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These eBPF tracepoint programs export data that is consumed by the
helpers added in the previous commit.

Also add support int the Makefile to generate a vmlinux.h header that
would be used by other bpf.c files in later commits.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile         |  25 ++++
 samples/bpf/xdp_sample.bpf.c | 267 +++++++++++++++++++++++++++++++++++
 samples/bpf/xdp_sample.bpf.h |  62 ++++++++
 3 files changed, 354 insertions(+)
 create mode 100644 samples/bpf/xdp_sample.bpf.c
 create mode 100644 samples/bpf/xdp_sample.bpf.h

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index d8fc3e6930f9..4a3151fa163f 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -277,6 +277,11 @@ $(LIBBPF): FORCE
 	$(MAKE) -C $(dir $@) RM='rm -rf' EXTRA_CFLAGS="$(TPROGS_CFLAGS)" \
 		LDFLAGS=$(TPROGS_LDFLAGS) srctree=$(BPF_SAMPLES_PATH)/../../ O=
 
+BPFTOOLDIR := $(TOOLS_PATH)/bpf/bpftool
+BPFTOOL := $(BPFTOOLDIR)/bpftool
+$(BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)
+	    $(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../
+
 $(obj)/syscall_nrs.h:	$(obj)/syscall_nrs.s FORCE
 	$(call filechk,offsets,__SYSCALL_NRS_H__)
 
@@ -314,6 +319,26 @@ $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 
 -include $(BPF_SAMPLES_PATH)/Makefile.target
 
+VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
+		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
+		     ../../../../vmlinux				\
+		     /sys/kernel/btf/vmlinux				\
+		     /boot/vmlinux-$(shell uname -r)
+VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
+
+ifeq ($(VMLINUX_BTF),)
+$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
+endif
+
+$(obj)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL)
+ifeq ($(VMLINUX_H),)
+	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
+else
+	$(Q)cp "$(VMLINUX_H)" $@
+endif
+
+clean-files += vmlinux.h
+
 # asm/sysreg.h - inline assembly used by it is incompatible with llvm.
 # But, there is no easy way to fix it, so just exclude it since it is
 # useless for BPF samples.
diff --git a/samples/bpf/xdp_sample.bpf.c b/samples/bpf/xdp_sample.bpf.c
new file mode 100644
index 000000000000..d714776edd72
--- /dev/null
+++ b/samples/bpf/xdp_sample.bpf.c
@@ -0,0 +1,267 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  GPLv2, Copyright(c) 2017 Jesper Dangaard Brouer, Red Hat, Inc. */
+#include "xdp_sample.bpf.h"
+
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+#include <bpf/bpf_helpers.h>
+
+struct sample_data sample_data;
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_HASH);
+	__uint(max_entries, 32 * 32);
+	__type(key, u64);
+	__type(value, struct datarec);
+} devmap_xmit_cnt_multi SEC(".maps");
+
+/* These can be set before loading so that redundant comparisons can be DCE'd by
+ * the verifier, and only actual matches are tried after loading tp_btf program.
+ * This allows sample to filter tracepoint stats based on net_device.
+ */
+const volatile int from_match[32] = {};
+const volatile int to_match[32] = {};
+
+int cpumap_map_id = 0;
+
+/* Find if b is part of set a, but if a is empty set then evaluate to true */
+#define IN_SET(a, b)                                                 \
+	({                                                           \
+		bool __res = !(a)[0];                                \
+		for (int i = 0; i < ELEMENTS_OF(a) && (a)[i]; i++) { \
+			__res = (a)[i] == (b);                       \
+			if (__res)                                   \
+				break;                               \
+		}                                                    \
+		__res;                                               \
+	})
+
+static __always_inline __u32 xdp_get_err_key(int err)
+{
+	switch (err) {
+	case 0:
+		return 0;
+	case -EINVAL:
+		return 2;
+	case -ENETDOWN:
+		return 3;
+	case -EMSGSIZE:
+		return 4;
+	case -EOPNOTSUPP:
+		return 5;
+	case -ENOSPC:
+		return 6;
+	default:
+		return 1;
+	}
+}
+
+static __always_inline int xdp_redirect_collect_stat(int from, int err)
+{
+	u32 cpu = bpf_get_smp_processor_id();
+	u32 key = XDP_REDIRECT_ERROR;
+	struct datarec *rec;
+	u32 idx;
+
+	if (!IN_SET(from_match, from))
+		return 0;
+
+	key = xdp_get_err_key(err);
+
+	idx = key * MAX_CPUS + cpu;
+	if (idx >= ELEMENTS_OF(sample_data.redirect_err_cnt))
+		return 0;
+
+	rec = &sample_data.redirect_err_cnt[idx];
+	if (key)
+		NO_TEAR_INC(rec->dropped);
+	else
+		NO_TEAR_INC(rec->processed);
+	return 0; /* Indicate event was filtered (no further processing)*/
+	/*
+	 * Returning 1 here would allow e.g. a perf-record tracepoint
+	 * to see and record these events, but it doesn't work well
+	 * in-practice as stopping perf-record also unload this
+	 * bpf_prog.  Plus, there is additional overhead of doing so.
+	 */
+}
+
+SEC("tp_btf/xdp_redirect_err")
+int BPF_PROG(tp_xdp_redirect_err, const struct net_device *dev,
+	     const struct bpf_prog *xdp, const void *tgt, int err,
+	     const struct bpf_map *map, u32 index)
+{
+	return xdp_redirect_collect_stat(dev->ifindex, err);
+}
+
+SEC("tp_btf/xdp_redirect_map_err")
+int BPF_PROG(tp_xdp_redirect_map_err, const struct net_device *dev,
+	     const struct bpf_prog *xdp, const void *tgt, int err,
+	     const struct bpf_map *map, u32 index)
+{
+	return xdp_redirect_collect_stat(dev->ifindex, err);
+}
+
+SEC("tp_btf/xdp_redirect")
+int BPF_PROG(tp_xdp_redirect, const struct net_device *dev,
+	     const struct bpf_prog *xdp, const void *tgt, int err,
+	     const struct bpf_map *map, u32 index)
+{
+	return xdp_redirect_collect_stat(dev->ifindex, err);
+}
+
+SEC("tp_btf/xdp_redirect_map")
+int BPF_PROG(tp_xdp_redirect_map, const struct net_device *dev,
+	     const struct bpf_prog *xdp, const void *tgt, int err,
+	     const struct bpf_map *map, u32 index)
+{
+	return xdp_redirect_collect_stat(dev->ifindex, err);
+}
+
+SEC("tp_btf/xdp_exception")
+int BPF_PROG(tp_xdp_exception, const struct net_device *dev,
+	     const struct bpf_prog *xdp, u32 act)
+{
+	u32 cpu = bpf_get_smp_processor_id();
+	struct datarec *rec;
+	u32 key = act, idx;
+
+	if (!IN_SET(from_match, dev->ifindex))
+		return 0;
+	if (!IN_SET(to_match, dev->ifindex))
+		return 0;
+
+	if (key > XDP_REDIRECT)
+		key = XDP_REDIRECT + 1;
+
+	idx = key * MAX_CPUS + cpu;
+	if (idx >= ELEMENTS_OF(sample_data.exception_cnt))
+		return 0;
+
+	rec = &sample_data.exception_cnt[idx];
+	NO_TEAR_INC(rec->dropped);
+
+	return 0;
+}
+
+SEC("tp_btf/xdp_cpumap_enqueue")
+int BPF_PROG(tp_xdp_cpumap_enqueue, int map_id, unsigned int processed,
+	     unsigned int drops, int to_cpu)
+{
+	u32 cpu = bpf_get_smp_processor_id();
+	struct datarec *rec;
+	u32 idx;
+
+	if (cpumap_map_id && cpumap_map_id != map_id)
+		return 0;
+
+	idx = to_cpu * MAX_CPUS + cpu;
+	if (idx >= ELEMENTS_OF(sample_data.cpumap_enqueue_cnt))
+		return 0;
+
+	rec = &sample_data.cpumap_enqueue_cnt[idx];
+	NO_TEAR_ADD(rec->processed, processed);
+	NO_TEAR_ADD(rec->dropped, drops);
+	/* Record bulk events, then userspace can calc average bulk size */
+	if (processed > 0)
+		NO_TEAR_INC(rec->issue);
+	/* Inception: It's possible to detect overload situations, via
+	 * this tracepoint.  This can be used for creating a feedback
+	 * loop to XDP, which can take appropriate actions to mitigate
+	 * this overload situation.
+	 */
+	return 0;
+}
+
+SEC("tp_btf/xdp_cpumap_kthread")
+int BPF_PROG(tp_xdp_cpumap_kthread, int map_id, unsigned int processed,
+	     unsigned int drops, int sched, struct xdp_cpumap_stats *xdp_stats)
+{
+	struct datarec *rec;
+	u32 cpu;
+
+	if (cpumap_map_id && cpumap_map_id != map_id)
+		return 0;
+
+	/* XXX: Moving assignment for index before map_id check fails
+	 * verification when compiled using clang-12, likewise for other places.
+	 */
+	cpu = bpf_get_smp_processor_id();
+	if (cpu >= ELEMENTS_OF(sample_data.cpumap_kthread_cnt))
+		return 0;
+
+	rec = &sample_data.cpumap_kthread_cnt[cpu];
+	NO_TEAR_ADD(rec->processed, processed);
+	NO_TEAR_ADD(rec->dropped, drops);
+	NO_TEAR_ADD(rec->xdp_pass, xdp_stats->pass);
+	NO_TEAR_ADD(rec->xdp_drop, xdp_stats->drop);
+	NO_TEAR_ADD(rec->xdp_redirect, xdp_stats->redirect);
+	/* Count times kthread yielded CPU via schedule call */
+	if (sched)
+		NO_TEAR_INC(rec->issue);
+	return 0;
+}
+
+SEC("tp_btf/xdp_devmap_xmit")
+int BPF_PROG(tp_xdp_devmap_xmit, const struct net_device *from_dev,
+	     const struct net_device *to_dev, int sent, int drops, int err)
+{
+	struct datarec *rec;
+	int idx_in, idx_out;
+	u32 cpu;
+
+	idx_in = from_dev->ifindex;
+	idx_out = to_dev->ifindex;
+
+	if (!IN_SET(from_match, idx_in))
+		return 0;
+	if (!IN_SET(to_match, idx_out))
+		return 0;
+
+	cpu = bpf_get_smp_processor_id();
+	if (cpu >= ELEMENTS_OF(sample_data.devmap_xmit_cnt))
+		return 0;
+
+	rec = &sample_data.devmap_xmit_cnt[cpu];
+	NO_TEAR_ADD(rec->processed, sent);
+	NO_TEAR_ADD(rec->dropped, drops);
+	/* Record bulk events, then userspace can calc average bulk size */
+	NO_TEAR_INC(rec->info);
+	/* Record error cases, where no frame were sent */
+	/* Catch API error of drv ndo_xdp_xmit sent more than count */
+	if (err || drops < 0)
+		NO_TEAR_INC(rec->issue);
+	return 0;
+}
+
+SEC("tp_btf/xdp_devmap_xmit")
+int BPF_PROG(tp_xdp_devmap_xmit_multi, const struct net_device *from_dev,
+	     const struct net_device *to_dev, int sent, int drops, int err)
+{
+	struct datarec empty = {};
+	struct datarec *rec;
+	int idx_in, idx_out;
+	u64 idx;
+
+	idx_in = from_dev->ifindex;
+	idx_out = to_dev->ifindex;
+	idx = idx_in;
+	idx = idx << 32 | idx_out;
+
+	if (!IN_SET(from_match, idx_in))
+		return 0;
+	if (!IN_SET(to_match, idx_out))
+		return 0;
+
+	bpf_map_update_elem(&devmap_xmit_cnt_multi, &idx, &empty, BPF_NOEXIST);
+	rec = bpf_map_lookup_elem(&devmap_xmit_cnt_multi, &idx);
+	if (!rec)
+		return 0;
+
+	NO_TEAR_ADD(rec->processed, sent);
+	NO_TEAR_ADD(rec->dropped, drops);
+	NO_TEAR_INC(rec->info);
+	if (err || drops < 0)
+		NO_TEAR_INC(rec->issue);
+	return 0;
+}
diff --git a/samples/bpf/xdp_sample.bpf.h b/samples/bpf/xdp_sample.bpf.h
new file mode 100644
index 000000000000..20a7ae25167b
--- /dev/null
+++ b/samples/bpf/xdp_sample.bpf.h
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef _XDP_SAMPLE_BPF_H
+#define _XDP_SAMPLE_BPF_H
+
+#include "vmlinux.h"
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+#include <bpf/bpf_helpers.h>
+
+#include "xdp_sample_shared.h"
+
+#define ETH_ALEN 6
+#define ETH_P_802_3_MIN 0x0600
+#define ETH_P_8021Q 0x8100
+#define ETH_P_8021AD 0x88A8
+#define ETH_P_IP 0x0800
+#define ETH_P_IPV6 0x86DD
+#define ETH_P_ARP 0x0806
+#define IPPROTO_ICMPV6 58
+
+#define EINVAL 22
+#define ENETDOWN 100
+#define EMSGSIZE 90
+#define EOPNOTSUPP 95
+#define ENOSPC 28
+
+extern struct sample_data sample_data;
+
+enum {
+	XDP_REDIRECT_SUCCESS = 0,
+	XDP_REDIRECT_ERROR = 1
+};
+
+static __always_inline void swap_src_dst_mac(void *data)
+{
+	unsigned short *p = data;
+	unsigned short dst[3];
+
+	dst[0] = p[0];
+	dst[1] = p[1];
+	dst[2] = p[2];
+	p[0] = p[3];
+	p[1] = p[4];
+	p[2] = p[5];
+	p[3] = dst[0];
+	p[4] = dst[1];
+	p[5] = dst[2];
+}
+
+#if defined(__BYTE_ORDER__) && defined(__ORDER_LITTLE_ENDIAN__) && \
+	__BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+#define bpf_ntohs(x)		__builtin_bswap16(x)
+#define bpf_htons(x)		__builtin_bswap16(x)
+#elif defined(__BYTE_ORDER__) && defined(__ORDER_BIG_ENDIAN__) && \
+	__BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+#define bpf_ntohs(x)		(x)
+#define bpf_htons(x)		(x)
+#else
+# error "Endianness detection needs to be set up for your compiler?!"
+#endif
+
+#endif
-- 
2.32.0

