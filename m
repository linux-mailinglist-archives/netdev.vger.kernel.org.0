Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582E0369597
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 17:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242895AbhDWPGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 11:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242953AbhDWPGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 11:06:49 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8888C06174A;
        Fri, 23 Apr 2021 08:06:12 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id u11so19608140pjr.0;
        Fri, 23 Apr 2021 08:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P8E+pwMUoLE6f61Wrr9Ey6d3R2dStVY1LynDckGed5o=;
        b=hZb2GzhMWQ6xYC7yFJE3Nz9983rG7eNoXa2vc0uQOZoMUMOVGb9qXne2bwdGU+Mmte
         izAm1oouy+Ywd0WOarHKQBMYSguA0ReYivXMROvyRG3cnh7uClWlZ4BQmc4U2+6RcmuZ
         4id3fPASSefN8G1ah2vfp+fERorYyKu0qsy7A7s/1UJ/DUZgZ+xEoPuRrSBrgp0JUbqy
         9K9Pio8GPSiFRzWSdwYLZebgm6ug4UqnvmcKkTwuSWbzqFjJBpJZw0k4sOs1/Tznzh8j
         Yz2rdg6yobp8UwOFmRjBy/Cp28nqE6WFUqk0N4dXZ0YetfZGQQRfvQIEKzcPgoosYDhT
         19xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P8E+pwMUoLE6f61Wrr9Ey6d3R2dStVY1LynDckGed5o=;
        b=MwludU9amwlz+9c3y9rVUFMTIfZDjnSx9SqxvHg40rSgjlZyedLCDkEAkeIYv0U2Sj
         c1qoxv1jqRmq2YXAwSASPocv0Y0bWDVIATkxg/WkVlV2Ang0UhSADOvO7MIQd62pez4V
         Z+dLfZD9Ofnyjoxq2Lkea2WoG4YJjKXS3Dmpfy8KQyLbF8a0liQKZRC4+wHmBzxgtwRC
         UoWB5QF7mZscZ+vu05PZB0hXtGka6JEX0FKYSCrhMW3lOtyWSzErRX0KueBFMobnKUe4
         RcxtXAk2xdMr1HmhoWe3vJWAs6dDMgclI23fF3Pa6CIhUe1Z6jqZrqHOACiviVvt9T/a
         a8lQ==
X-Gm-Message-State: AOAM53303t9m8EpeTPRB6Gdiz4/rbKoLM9U7kYBJbgOCuvsRzjnWIBQC
        UdXaVz65u009Lmv6Sd/eh0fsDKMmzoYBag==
X-Google-Smtp-Source: ABdhPJyljrOWIQXtLNg8w+2FCN5pvMt6moVv1iCxukMvHYz4ajkcAtPIR3PZpC7xd+E0//6QHVJiJg==
X-Received: by 2002:a17:902:6a88:b029:eb:3ea5:58c3 with SMTP id n8-20020a1709026a88b02900eb3ea558c3mr4179618plk.55.1619190371808;
        Fri, 23 Apr 2021 08:06:11 -0700 (PDT)
Received: from localhost ([112.79.255.145])
        by smtp.gmail.com with ESMTPSA id 12sm4839780pfi.204.2021.04.23.08.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 08:06:11 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 2/3] libbpf: add low level TC-BPF API
Date:   Fri, 23 Apr 2021 20:35:59 +0530
Message-Id: <20210423150600.498490-3-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423150600.498490-1-memxor@gmail.com>
References: <20210423150600.498490-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds functions that wrap the netlink API used for adding,
manipulating, and removing traffic control filters.

An API summary:

bpf_tc_ctx_init may be used to create a context structure represented by
the opaque struct bpf_tc_ctx pointer returned to the caller. A bpf
context represents the attach point for a filter, which means it takes
the ifindex of the device user is attaching to, and an attach point that
translates to the parent of the filter. When specifying BPF_TC_INGRESS
or BPF_TC_EGRESS, the ctx initialization will automatically setup the
clsact qdisc if possible, and also clean it up if it was created during
ctx_init and there are no more remaining filters. A custom parent value
can be set in opts during filter attach and indicated by setting
BPF_TC_CUSTOM_PARENT during ctx initialization.

bpf_tc_ctx_destroy is used to release a bpf_tc_ctx object and remove any
qdiscs owned by it. Note that there is a small race between the checking
of existing filters and removal of qdisc. The chances of this happening
are quite slim however, as we only remove a qdisc we set up.

bpf_tc_attach may be used to attach, and replace a filter and bind a
SCHED_CLS prog as its bpf classifier. Direct action mode is always
enabled, and protocol is always set to ETH_P_ALL. The filter is attached
to the main chain with index 0.

bpf_tc_detach may be used to delete existing filter and detach the
SCHED_CLS filter.

Example (using bpf skeleton infrastructure):

BPF program (test_tc_bpf.c):
	#include <linux/bpf.h>
	#include <bpf/bpf_helpers.h>

	SEC("classifier")
	int cls(struct __sk_buff *skb)
	{
		return 0;
	}

Userspace loader:
	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, 0);
	struct test_tc_bpf *skel;
	struct bpf_tc_ctx *ctx;
	int fd, r;

	skel = test_tc_bpf__open_and_load();
	if (!skel)
		return -ENOMEM;

	fd = bpf_program__fd(skel->progs.cls);

	ctx = bpf_tc_ctx_init(if_nametoindex("lo"),
			      BPF_TC_INGRESS, NULL);
	if (!ctx)
		return -ENOMEM;

	r = bpf_tc_attach(ctx, fd, &opts);
	if (r < 0)
		return r;

... which is roughly equivalent to:
  # tc qdisc add dev lo clsact
  # tc filter add dev lo ingress bpf obj foo.o sec classifier da

To replace an existing filter (e.g. the one we just created):

	/* opts.{handle, parent, priority, prog_id} was filled
	 * in by attach.
	 */
	opts.replace = true;
	/* clear fields that must be unset, we must also clear parent as
	   our attach point is ingress hook */
	opts.parent = opts.prog_id = 0;
	r = bpf_tc_attach(ctx, fd, &opts);
	if (r < 0)
		return r;

To obtain info of a particular filter:

	/* Find info for filter with handle 1 and priority 50 */
	DECLARE_LIBBPF_OPTS(bpf_tc_opts, info_opts, .handle = 1,
			    .priority = 50, .parent = opts.parent)
	r = bpf_tc_query(ctx, &info_opts);
	if (r < 0 && r == -ENOENT)
		printf("Filter not found\n");
	else
		return r;

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/libbpf.h   |  92 ++++++++
 tools/lib/bpf/libbpf.map |   5 +
 tools/lib/bpf/netlink.c  | 478 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 574 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index bec4e6a6e31d..1c717c07b66e 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -775,6 +775,98 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filen
 LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
 LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);

+enum bpf_tc_attach_point {
+	BPF_TC_INGRESS,
+	BPF_TC_EGRESS,
+	BPF_TC_CUSTOM_PARENT,
+	_BPF_TC_PARENT_MAX,
+};
+
+/* The opts structure is also used to return the created filters attributes
+ * (e.g. in case the user left them unset). Some of the options that were left
+ * out default to a reasonable value, documented below.
+ *
+ *	protocol - ETH_P_ALL
+ *	chain index - 0
+ *	class_id - 0 (can be set by bpf program using skb->tc_classid)
+ *	bpf_flags - TCA_BPF_FLAG_ACT_DIRECT (direct action mode)
+ *	bpf_flags_gen - 0
+ *
+ *	The user must fulfill documented requirements for each function.
+ */
+struct bpf_tc_opts {
+	size_t sz;
+	__u32 handle;
+	__u32 parent;
+	__u16 priority;
+	__u32 prog_id;
+	bool replace;
+	size_t :0;
+};
+
+#define bpf_tc_opts__last_field replace
+
+struct bpf_tc_ctx;
+
+struct bpf_tc_ctx_opts {
+	size_t sz;
+};
+
+#define bpf_tc_ctx_opts__last_field sz
+
+/* Requirements */
+/*
+ * @ifindex: Must be > 0.
+ * @parent: Must be one of the enum constants < _BPF_TC_PARENT_MAX
+ * @opts: Can be NULL, currently no options are supported.
+ */
+LIBBPF_API struct bpf_tc_ctx *bpf_tc_ctx_init(__u32 ifindex,
+					      enum bpf_tc_attach_point parent,
+					      struct bpf_tc_ctx_opts *opts);
+/*
+ * @ctx: Can be NULL, if not, must point to a valid object.
+ *	 If the qdisc was attached during ctx_init, it will be deleted if no
+ *	 filters are attached to it.
+ *	 When ctx == NULL, this is a no-op.
+ */
+LIBBPF_API int bpf_tc_ctx_destroy(struct bpf_tc_ctx *ctx);
+/*
+ * @ctx: Cannot be NULL.
+ * @fd: Must be >= 0.
+ * @opts: Cannot be NULL, prog_id must be unset, all other fields can be
+ *	  optionally set. All fields except replace  will be set as per created
+ *        filter's attributes. parent must only be set when attach_point of ctx is
+ *        BPF_TC_CUSTOM_PARENT, otherwise parent must be unset.
+ *
+ * Fills the following fields in opts:
+ *	handle
+ *	parent
+ *	priority
+ *	prog_id
+ */
+LIBBPF_API int bpf_tc_attach(struct bpf_tc_ctx *ctx, int fd,
+			     struct bpf_tc_opts *opts);
+/*
+ * @ctx: Cannot be NULL.
+ * @opts: Cannot be NULL, replace and prog_id must be unset, all other fields
+ *	  must be set.
+ */
+LIBBPF_API int bpf_tc_detach(struct bpf_tc_ctx *ctx,
+			     const struct bpf_tc_opts *opts);
+/*
+ * @ctx: Cannot be NULL.
+ * @opts: Cannot be NULL, replace and prog_id must be unset, all other fields
+ *	  must be set.
+ *
+ * Fills the following fields in opts:
+ *	handle
+ *	parent
+ *	priority
+ *	prog_id
+ */
+LIBBPF_API int bpf_tc_query(struct bpf_tc_ctx *ctx,
+			    struct bpf_tc_opts *opts);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index b9b29baf1df8..f6490d521601 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -361,4 +361,9 @@ LIBBPF_0.4.0 {
 		bpf_linker__new;
 		bpf_map__inner_map;
 		bpf_object__set_kversion;
+		bpf_tc_ctx_init;
+		bpf_tc_ctx_destroy;
+		bpf_tc_attach;
+		bpf_tc_detach;
+		bpf_tc_query;
 } LIBBPF_0.3.0;
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index c79e30484e81..a389e1151391 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -4,7 +4,11 @@
 #include <stdlib.h>
 #include <memory.h>
 #include <unistd.h>
+#include <inttypes.h>
+#include <arpa/inet.h>
 #include <linux/bpf.h>
+#include <linux/if_ether.h>
+#include <linux/pkt_cls.h>
 #include <linux/rtnetlink.h>
 #include <sys/socket.h>
 #include <errno.h>
@@ -73,6 +77,11 @@ static int libbpf_netlink_open(__u32 *nl_pid)
 	return ret;
 }

+enum {
+	BPF_NL_CONT,
+	BPF_NL_NEXT,
+};
+
 static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 			    __dump_nlmsg_t _fn, libbpf_dump_nlmsg_t fn,
 			    void *cookie)
@@ -84,6 +93,7 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 	int len, ret;

 	while (multipart) {
+start:
 		multipart = false;
 		len = recv(sock, buf, sizeof(buf), 0);
 		if (len < 0) {
@@ -121,8 +131,16 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 			}
 			if (_fn) {
 				ret = _fn(nh, fn, cookie);
-				if (ret)
+				if (ret < 0)
+					return ret;
+				switch (ret) {
+				case BPF_NL_CONT:
+					break;
+				case BPF_NL_NEXT:
+					goto start;
+				default:
 					return ret;
+				}
 			}
 		}
 	}
@@ -131,6 +149,21 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 	return ret;
 }

+/* In TC-BPF we use seqnum to form causal order of operations on shared ctx
+ * socket, so we want to skip messages older than the one we are looking for,
+ * in case they are left in socket buffer for some reason (e.g. errors). */
+static int bpf_netlink_recv_skip(int sock, __u32 nl_pid, int seq, __dump_nlmsg_t fn,
+				 void *cookie)
+{
+	int ret;
+
+restart:
+	ret = bpf_netlink_recv(sock, nl_pid, seq, fn, NULL, cookie);
+	if (ret < 0 && ret == -LIBBPF_ERRNO__INVSEQ)
+		goto restart;
+	return ret;
+}
+
 static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
 					 __u32 flags)
 {
@@ -365,3 +398,446 @@ int libbpf_nl_get_link(int sock, unsigned int nl_pid,
 	return bpf_netlink_recv(sock, nl_pid, seq, __dump_link_nlmsg,
 				dump_link_nlmsg, cookie);
 }
+
+/* TC-CTX */
+
+struct bpf_tc_ctx {
+	__u32 ifindex;
+	enum bpf_tc_attach_point parent;
+	int sock;
+	__u32 nl_pid;
+	__u32 seq;
+	bool created_qdisc;
+};
+
+typedef int (*qdisc_config_t)(struct nlmsghdr *nh, struct tcmsg *t,
+			      size_t maxsz);
+
+static int clsact_config(struct nlmsghdr *nh, struct tcmsg *t, size_t maxsz)
+{
+	int ret;
+
+	t->tcm_parent = TC_H_CLSACT;
+	t->tcm_handle = TC_H_MAKE(TC_H_CLSACT, 0);
+
+	ret = nlattr_add(nh, maxsz, TCA_KIND, "clsact", sizeof("clsact"));
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static const qdisc_config_t parent_to_qdisc[_BPF_TC_PARENT_MAX] = {
+	[BPF_TC_INGRESS] = &clsact_config,
+	[BPF_TC_EGRESS] = &clsact_config,
+	[BPF_TC_CUSTOM_PARENT] = NULL,
+};
+
+static int tc_qdisc_modify(struct bpf_tc_ctx *ctx, int cmd, int flags,
+			   qdisc_config_t config)
+{
+	int ret = 0;
+	struct {
+		struct nlmsghdr nh;
+		struct tcmsg t;
+		char buf[256];
+	} req;
+
+	if (!ctx || !config)
+		return -EINVAL;
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcmsg));
+	req.nh.nlmsg_flags =
+		NLM_F_REQUEST | NLM_F_ACK | flags;
+	req.nh.nlmsg_type = cmd;
+	req.nh.nlmsg_pid = 0;
+	req.nh.nlmsg_seq = ++ctx->seq;
+	req.t.tcm_family = AF_UNSPEC;
+	req.t.tcm_ifindex = ctx->ifindex;
+
+	ret = config(&req.nh, &req.t, sizeof(req));
+	if (ret < 0)
+		return ret;
+
+	ret = send(ctx->sock, &req.nh, req.nh.nlmsg_len, 0);
+	if (ret < 0)
+		return ret;
+
+	return bpf_netlink_recv_skip(ctx->sock, ctx->nl_pid, ctx->seq, NULL, NULL);
+}
+
+static int tc_qdisc_create_excl(struct bpf_tc_ctx *ctx, qdisc_config_t config)
+{
+	return tc_qdisc_modify(ctx, RTM_NEWQDISC, NLM_F_CREATE | NLM_F_EXCL, config);
+}
+
+static int tc_qdisc_delete(struct bpf_tc_ctx *ctx, qdisc_config_t config)
+{
+	return tc_qdisc_modify(ctx, RTM_DELQDISC, 0, config);
+}
+
+struct bpf_tc_ctx *bpf_tc_ctx_init(__u32 ifindex, enum bpf_tc_attach_point parent,
+				   struct bpf_tc_ctx_opts *opts)
+{
+	struct bpf_tc_ctx *ctx = NULL;
+	qdisc_config_t config;
+	int ret, sock;
+	__u32 nl_pid;
+
+	if (!ifindex || parent >= _BPF_TC_PARENT_MAX ||
+	    !OPTS_VALID(opts, bpf_tc_ctx_opts)) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	sock = libbpf_netlink_open(&nl_pid);
+	if (sock < 0) {
+		errno = -sock;
+		return NULL;
+	}
+
+	ctx = calloc(1, sizeof(*ctx));
+	if (!ctx) {
+		errno = ENOMEM;
+		goto end_sock;
+	}
+
+	ctx->ifindex = ifindex;
+	ctx->parent = parent;
+	ctx->seq = time(NULL);
+	ctx->nl_pid = nl_pid;
+	ctx->sock = sock;
+
+	config = parent_to_qdisc[parent];
+	if (config) {
+		ret = tc_qdisc_create_excl(ctx, config);
+		if (ret < 0 && ret != -EEXIST) {
+			errno = -ret;
+			goto end_ctx;
+		}
+		ctx->created_qdisc = ret == 0;
+	}
+
+	return ctx;
+
+end_ctx:
+	free(ctx);
+end_sock:
+	close(sock);
+	return NULL;
+}
+
+struct pass_info {
+	struct bpf_tc_opts *opts;
+	bool processed;
+};
+
+static int __tc_query(struct bpf_tc_ctx *ctx,
+	              struct bpf_tc_opts *opts);
+
+int bpf_tc_ctx_destroy(struct bpf_tc_ctx *ctx)
+{
+	qdisc_config_t config;
+	int ret = 0;
+
+	if (!ctx)
+		return 0;
+
+	config = parent_to_qdisc[ctx->parent];
+	if (ctx->created_qdisc && config) {
+		/* ctx->parent cannot be BPF_TC_CUSTOM_PARENT, as this doesn't
+		 * map to a qdisc that can be created, so opts being NULL won't
+		 * be an error (e.g. in tc_ctx_get_tcm_parent).
+		 */
+		if (__tc_query(ctx, NULL) == -ENOENT)
+			ret = tc_qdisc_delete(ctx, config);
+	}
+
+	close(ctx->sock);
+	free(ctx);
+	return ret;
+}
+
+static long long int tc_ctx_get_tcm_parent(enum bpf_tc_attach_point type,
+					   __u32 parent)
+{
+	long long int ret;
+
+	switch (type) {
+	case BPF_TC_INGRESS:
+		ret = TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS);
+		if (parent && parent != ret)
+			return -EINVAL;
+		break;
+	case BPF_TC_EGRESS:
+		ret = TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS);
+		if (parent && parent != ret)
+			return -EINVAL;
+		break;
+	case BPF_TC_CUSTOM_PARENT:
+		if (!parent)
+			return -EINVAL;
+		ret = parent;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	return ret;
+}
+
+/* TC-BPF */
+
+static int tc_bpf_add_fd_and_name(struct nlmsghdr *nh, size_t maxsz, int fd)
+{
+	struct bpf_prog_info info = {};
+	__u32 info_len = sizeof(info);
+	char name[256] = {};
+	int len, ret;
+
+	ret = bpf_obj_get_info_by_fd(fd, &info, &info_len);
+	if (ret < 0)
+		return ret;
+
+	ret = nlattr_add(nh, maxsz, TCA_BPF_FD, &fd, sizeof(fd));
+	if (ret < 0)
+		return ret;
+
+	len = snprintf(name, sizeof(name), "%s:[%" PRIu32 "]", info.name,
+		       info.id);
+	if (len < 0 || len >= sizeof(name))
+		return len < 0 ? -EINVAL : -ENAMETOOLONG;
+
+	return nlattr_add(nh, maxsz, TCA_BPF_NAME, name, len + 1);
+}
+
+static int tc_cls_bpf_modify(struct bpf_tc_ctx *ctx, int fd, int cmd, int flags,
+			     struct bpf_tc_opts *opts, __dump_nlmsg_t fn)
+{
+	unsigned int bpf_flags = 0;
+	struct pass_info info = {};
+	__u32 protocol, priority;
+	long long int tcm_parent;
+	struct nlattr *nla;
+	int ret;
+	struct {
+		struct nlmsghdr nh;
+		struct tcmsg t;
+		char buf[256];
+	} req;
+
+	if (cmd == RTM_NEWTFILTER)
+		flags |= OPTS_GET(opts, replace, false) ? NLM_F_REPLACE :
+								NLM_F_EXCL;
+	priority = OPTS_GET(opts, priority, 0);
+	protocol = ETH_P_ALL;
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcmsg));
+	req.nh.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK | flags;
+	req.nh.nlmsg_type = cmd;
+	req.nh.nlmsg_pid = 0;
+	req.nh.nlmsg_seq = ++ctx->seq;
+	req.t.tcm_family = AF_UNSPEC;
+	req.t.tcm_handle = OPTS_GET(opts, handle, 0);
+	req.t.tcm_ifindex = ctx->ifindex;
+	req.t.tcm_info = TC_H_MAKE(priority << 16, htons(protocol));
+
+	tcm_parent = tc_ctx_get_tcm_parent(ctx->parent, OPTS_GET(opts, parent, 0));
+	if (tcm_parent < 0)
+		return tcm_parent;
+	req.t.tcm_parent = tcm_parent;
+
+	ret = nlattr_add(&req.nh, sizeof(req), TCA_KIND, "bpf", sizeof("bpf"));
+	if (ret < 0)
+		return ret;
+
+	nla = nlattr_begin_nested(&req.nh, sizeof(req), TCA_OPTIONS);
+	if (!nla)
+		return -EMSGSIZE;
+
+	if (cmd != RTM_DELTFILTER) {
+		ret = tc_bpf_add_fd_and_name(&req.nh, sizeof(req), fd);
+		if (ret < 0)
+			return ret;
+
+		/* direct action mode is always enabled */
+		bpf_flags |= TCA_BPF_FLAG_ACT_DIRECT;
+		ret = nlattr_add(&req.nh, sizeof(req), TCA_BPF_FLAGS,
+				 &bpf_flags, sizeof(bpf_flags));
+		if (ret < 0)
+			return ret;
+	}
+
+	nlattr_end_nested(&req.nh, nla);
+
+	ret = send(ctx->sock, &req.nh, req.nh.nlmsg_len, 0);
+	if (ret < 0)
+		return ret;
+
+	info.opts = opts;
+	ret = bpf_netlink_recv_skip(ctx->sock, ctx->nl_pid, ctx->seq, fn,
+				    &info);
+	if (ret < 0)
+		return ret;
+
+	/* Failed to process unicast response */
+	if (fn && !info.processed)
+		ret = -ENOENT;
+
+	return ret;
+}
+
+static int cls_get_info(struct nlmsghdr *nh, libbpf_dump_nlmsg_t fn,
+			void *cookie);
+
+int bpf_tc_attach(struct bpf_tc_ctx *ctx, int fd,
+		  struct bpf_tc_opts *opts)
+{
+	if (!ctx || fd < 0 || !opts)
+		return -EINVAL;
+
+	if (!OPTS_VALID(opts, bpf_tc_opts) || OPTS_GET(opts, prog_id, 0))
+		return -EINVAL;
+
+	if (OPTS_GET(opts, parent, 0) && ctx->parent < BPF_TC_CUSTOM_PARENT)
+		return -EINVAL;
+
+	return tc_cls_bpf_modify(ctx, fd, RTM_NEWTFILTER,
+				 NLM_F_ECHO | NLM_F_CREATE,
+				 opts, cls_get_info);
+}
+
+int bpf_tc_detach(struct bpf_tc_ctx *ctx,
+		  const struct bpf_tc_opts *opts)
+{
+	if (!ctx || !opts)
+		return -EINVAL;
+
+	if (!OPTS_VALID(opts, bpf_tc_opts) || !OPTS_GET(opts, handle, 0) ||
+	    !OPTS_GET(opts, priority, 0) || !OPTS_GET(opts, parent, 0) ||
+	    OPTS_GET(opts, replace, false) || OPTS_GET(opts, prog_id, 0))
+		return -EINVAL;
+
+	/* Won't write to opts when fn is NULL */
+	return tc_cls_bpf_modify(ctx, 0, RTM_DELTFILTER, 0,
+				 (struct bpf_tc_opts *)opts, NULL);
+}
+
+static int __cls_get_info(void *cookie, void *msg, struct nlattr **tb,
+			  bool unicast)
+{
+	struct nlattr *tbb[TCA_BPF_MAX + 1];
+	struct pass_info *info = cookie;
+	struct tcmsg *t = msg;
+
+	if (!info)
+		return -EINVAL;
+	if (unicast && info->processed)
+		return -EINVAL;
+	/* We use BPF_NL_CONT even after finding the filter to consume all
+	 * remaining multipart messages.
+	 */
+	if (info->processed || !tb[TCA_OPTIONS])
+		return BPF_NL_CONT;
+
+	libbpf_nla_parse_nested(tbb, TCA_BPF_MAX, tb[TCA_OPTIONS], NULL);
+	if (!tbb[TCA_BPF_ID])
+		return BPF_NL_CONT;
+
+	OPTS_SET(info->opts, handle, t->tcm_handle);
+	OPTS_SET(info->opts, parent, t->tcm_parent);
+	OPTS_SET(info->opts, priority, TC_H_MAJ(t->tcm_info) >> 16);
+	OPTS_SET(info->opts, prog_id, libbpf_nla_getattr_u32(tbb[TCA_BPF_ID]));
+
+	info->processed = true;
+	return unicast ? BPF_NL_NEXT : BPF_NL_CONT;
+}
+
+static int cls_get_info(struct nlmsghdr *nh, libbpf_dump_nlmsg_t fn,
+			void *cookie)
+{
+	struct tcmsg *t = NLMSG_DATA(nh);
+	struct nlattr *tb[TCA_MAX + 1];
+
+	libbpf_nla_parse(tb, TCA_MAX,
+			 (struct nlattr *)((char *)t + NLMSG_ALIGN(sizeof(*t))),
+			 NLMSG_PAYLOAD(nh, sizeof(*t)), NULL);
+	if (!tb[TCA_KIND])
+		return BPF_NL_CONT;
+
+	return __cls_get_info(cookie, t, tb, nh->nlmsg_flags & NLM_F_ECHO);
+}
+
+/* This is the less strict internal helper used to get dump for more than one
+ * filter, used to determine if there are any filters attach for a bpf_tc_ctx.
+ *
+ */
+static int __tc_query(struct bpf_tc_ctx *ctx,
+	              struct bpf_tc_opts *opts)
+{
+	struct pass_info pinfo = {};
+	__u32 priority, protocol;
+	long long int tcm_parent;
+	int ret;
+	struct {
+		struct nlmsghdr nh;
+		struct tcmsg t;
+		char buf[256];
+	} req = {
+		.nh.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcmsg)),
+		.nh.nlmsg_type = RTM_GETTFILTER,
+		.nh.nlmsg_flags = NLM_F_REQUEST | NLM_F_DUMP,
+		.t.tcm_family = AF_UNSPEC,
+	};
+
+	if (!ctx)
+		return -EINVAL;
+
+	priority = OPTS_GET(opts, priority, 0);
+	protocol = ETH_P_ALL;
+
+	req.nh.nlmsg_seq = ++ctx->seq;
+	req.t.tcm_ifindex = ctx->ifindex;
+	req.t.tcm_handle = OPTS_GET(opts, handle, 0);
+	req.t.tcm_info = TC_H_MAKE(priority << 16, htons(protocol));
+
+	tcm_parent = tc_ctx_get_tcm_parent(ctx->parent, OPTS_GET(opts, parent, 0));
+	if (tcm_parent < 0)
+		return tcm_parent;
+	req.t.tcm_parent = tcm_parent;
+
+	ret = nlattr_add(&req.nh, sizeof(req), TCA_KIND, "bpf", sizeof("bpf"));
+	if (ret < 0)
+		return ret;
+
+	ret = send(ctx->sock, &req.nh, req.nh.nlmsg_len, 0);
+	if (ret < 0)
+		return ret;
+
+	pinfo.opts = opts;
+	ret = bpf_netlink_recv_skip(ctx->sock, ctx->nl_pid, ctx->seq,
+				    cls_get_info, &pinfo);
+	if (ret < 0)
+		return ret;
+
+	if (!pinfo.processed)
+		ret = -ENOENT;
+
+	return ret;
+}
+
+int bpf_tc_query(struct bpf_tc_ctx *ctx,
+		 struct bpf_tc_opts *opts)
+{
+	if (!ctx || !opts)
+		return -EINVAL;
+
+	if (!OPTS_VALID(opts, bpf_tc_opts) || !OPTS_GET(opts, handle, 0) ||
+	    !OPTS_GET(opts, priority, 0) || !OPTS_GET(opts, parent, 0) ||
+	    OPTS_GET(opts, replace, false) || OPTS_GET(opts, prog_id, 0))
+		return -EINVAL;
+
+	return __tc_query(ctx, opts);
+}
--
2.30.2

