Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82344349172
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhCYMCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhCYMCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 08:02:12 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE434C06174A;
        Thu, 25 Mar 2021 05:02:11 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id m11so1802255pfc.11;
        Thu, 25 Mar 2021 05:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HadcF0Rh2J9KQ9fQEkDQTK8DcpUyn4fd3MrWygpEydw=;
        b=Cq4nNEjLpdCbsS66Lv/VoeKrZEXDjZZNGj6sV3rAnvMD3Q3OGVRVmh2eLrY3/fHlbK
         UYX/389CU4mzYfWBbMwWlqp3Fjv5WUQu5PR09/L2s1EWGKwP7UkxCmGPXXD/ruCnjncI
         4LQwsrwh607Yc3DReMFK9cKvmfTjioNsqAhmaHjfry01cX5yVeTCzqVZrB75L5ab8MRq
         3N8+GWrLRlKUtEAkfCzLFaLuMQhKlWhIgeE/gsdVSG0Buy11UhtnW2NDXHf6L/CFfwlz
         J2opzthYUaYCZQiED7sZ9jfx4vD1xP8noeNYVUnK1uC2tTT9TC+S4mbpcN+gN/jDwfPU
         7uJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HadcF0Rh2J9KQ9fQEkDQTK8DcpUyn4fd3MrWygpEydw=;
        b=JdgXrT3GnVhgXzX+2scLOTYz2cJHwgpflstWrHfa/rECe0h6Pv+p/k7wl7txnlGQWH
         SaGQ9czWUiAES0HxbggcKsbEkzUYA/8y0SaXkGS/tU6TtKODPzXS+e8QdF89n1SBz68s
         tZ0ed4qCHx0WECzn2Wb8oDthJ4RwlIDQ27T9j7+D9zaOYs+L0DbHUWGJ3pJlo9Fw7z8c
         ZMtorO8xlV8gEh1/w4F5r/4YJB+IL8ddYfnVBrkKaHcLDa5B7OG/Q7ZB28T1vRlQwzh3
         0Dx9ZoimeBstZh5ytl6kMZf1Qgr4981l9RyWmq/NgQPFGx0cW8bO4w136cTg7782YgPA
         mKTg==
X-Gm-Message-State: AOAM533zzKcN9uw8LwqElGgwXYbZvz5fYakBd4zfveY3O4g3Y1OjVAGM
        21TWeaxTZPpZLPjvAd3RQhBM5/esWbjVdw==
X-Google-Smtp-Source: ABdhPJzCtF7PlFTbyczwVZy7FjE0nHjbVtDUGGUHqfFvTzJIF1ogDVYIykvxnuquIdrxfFQnkPV/hA==
X-Received: by 2002:a63:5f0c:: with SMTP id t12mr7237127pgb.381.1616673730635;
        Thu, 25 Mar 2021 05:02:10 -0700 (PDT)
Received: from localhost ([112.79.237.176])
        by smtp.gmail.com with ESMTPSA id a29sm2616916pfg.130.2021.03.25.05.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 05:02:10 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     brouer@redhat.com, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
Date:   Thu, 25 Mar 2021 17:30:01 +0530
Message-Id: <20210325120020.236504-4-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325120020.236504-1-memxor@gmail.com>
References: <20210325120020.236504-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds functions that wrap the netlink API used for adding,
manipulating, and removing filters and actions. These functions operate
directly on the loaded prog's fd, and return a handle to the filter and
action using an out parameter (id for tc_cls, and index for tc_act).

The basic featureset is covered to allow for attaching, manipulation of
properties, and removal of filters and actions. Some additional features
like TCA_BPF_POLICE and TCA_RATE for tc_cls have been omitted. These can
added on top later by extending the bpf_tc_cls_opts struct.

Support for binding actions directly to a classifier by passing them in
during filter creation has also been omitted for now. These actions
have an auto clean up property because their lifetime is bound to the
filter they are attached to. This can be added later, but was omitted
for now as direct action mode is a better alternative to it.

An API summary:

The BPF TC-CLS API

bpf_tc_act_{attach, change, replace}_{dev, block} may be used to attach,
change, and replace SCHED_CLS bpf classifiers. Separate set of functions
are provided for network interfaces and shared filter blocks.

bpf_tc_cls_detach_{dev, block} may be used to detach existing SCHED_CLS
filter. The bpf_tc_cls_attach_id object filled in during attach,
change, or replace must be passed in to the detach functions for them to
remove the filter and its attached classififer correctly.

bpf_tc_cls_get_info is a helper that can be used to obtain attributes
for the filter and classififer. The opts structure may be used to
choose the granularity of search, such that info for a specific filter
corresponding to the same loaded bpf program can be obtained. By
default, the first match is returned to the user.

Examples:

	struct bpf_tc_cls_attach_id id = {};
	struct bpf_object *obj;
	struct bpf_program *p;
	int fd, r;

	obj = bpf_object_open("foo.o");
	if (IS_ERR_OR_NULL(obj))
		return PTR_ERR(obj);

	p = bpf_object__find_program_by_title(obj, "classifier");
	if (IS_ERR_OR_NULL(p))
		return PTR_ERR(p);

	if (bpf_object__load(obj) < 0)
		return -1;

	fd = bpf_program__fd(p);

	r = bpf_tc_cls_attach_dev(fd, if_nametoindex("lo"),
				  BPF_TC_CLSACT_INGRESS, ETH_P_IP,
				  NULL, &id);
	if (r < 0)
		return r;

... which is roughly equivalent to (after clsact qdisc setup):
  # tc filter add dev lo ingress bpf obj /home/kkd/foo.o sec classifier

If a user wishes to modify existing options on an attached filter, the
bpf_tc_cls_change_{dev, block} API may be used. Parameters like
chain_index, priority, and handle are ignored in the bpf_tc_cls_opts
struct as they cannot be modified after attaching a filter.

Example:

	/* Optional parameters necessary to select the right filter */
	DECLARE_LIBBPF_OPTS(bpf_tc_cls_opts, opts,
			    .handle = id.handle,
			    .priority = id.priority,
			    .chain_index = id.chain_index)
	/* Turn on direct action mode */
	opts.direct_action = true;
	r = bpf_tc_cls_change_dev(fd, id.ifindex, id.parent_id,
			          id.protocol, &opts, &id);
	if (r < 0)
		return r;

	/* Verify that the direct action mode has been set */
	struct bpf_tc_cls_info info = {};
	r = bpf_tc_cls_get_info_dev(fd, id.ifindex, id.parent_id,
			            id.protocol, &opts, &info);
	if (r < 0)
		return r;

	assert(info.bpf_flags & TCA_BPF_FLAG_ACT_DIRECT);

This would be roughly equivalent to doing:
  # tc filter change dev lo egress prio <p> handle <h> bpf obj /home/kkd/foo.o section classifier da

... except a new bpf program will be loaded and replace existing one.

If a user wishes to either replace an existing filter, or create a new
one with the same properties, they can use bpf_tc_cls_replace_dev. The
benefit of bpf_tc_cls_change is that it fails if no matching filter
exists.

The BPF TC-ACT API

bpf_tc_act_{attach, replace} may be used to attach and replace already
attached SCHED_ACT actions. Passing an index of 0 has special meaning,
in that an index will be automatically chosen by the kernel. The index
chosen by the kernel is the return value of these functions in case of
success.

bpf_tc_act_detach may be used to detach a SCHED_ACT action prog
identified by the index parameter. The index 0 again has a special
meaning, in that passing it will flush all existing SCHED_ACT actions
loaded using the ACT API.

bpf_tc_act_get_info is a helper to get the required attributes of a
loaded program to be able to manipulate it futher, by passing them
into the aforementioned functions.

Example:

	struct bpf_object *obj;
	struct bpf_program *p;
	__u32 index;
	int fd, r;

	obj = bpf_object_open("foo.o");
	if (IS_ERR_OR_NULL(obj))
		return PTR_ERR(obj);

	p = bpf_object__find_program_by_title(obj, "action");
	if (IS_ERR_OR_NULL(p))
		return PTR_ERR(p);

	if (bpf_object__load(obj) < 0)
		return -1;

	fd = bpf_program__fd(p);

	r = bpf_tc_act_attach(fd, NULL, &index);
	if (r < 0)
		return r;

	if (bpf_tc_act_detach(index))
		return -1;

... which is equivalent to the following sequence:
	tc action add action bpf obj /home/kkd/foo.o sec action
	tc action del action bpf index <idx>

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/libbpf.h   | 118 +++++++
 tools/lib/bpf/libbpf.map |  14 +
 tools/lib/bpf/netlink.c  | 715 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 841 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index a1a424b9b8ff..63baef6045b1 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -16,6 +16,9 @@
 #include <stdbool.h>
 #include <sys/types.h>  // for size_t
 #include <linux/bpf.h>
+#include <linux/pkt_cls.h>
+#include <linux/pkt_sched.h>
+#include <linux/tc_act/tc_bpf.h>
 
 #include "libbpf_common.h"
 
@@ -773,6 +776,121 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filen
 LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
 LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
 
+/*
+ * Requirements:
+ *  If choosing hw offload mode (skip_sw = true), ifindex during prog load must be set.
+ */
+
+/* Convenience macros for the clsact attach hooks */
+#define BPF_TC_CLSACT_INGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS)
+#define BPF_TC_CLSACT_EGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)
+
+struct bpf_tc_cls_opts {
+	size_t sz;
+	__u32 chain_index;
+	__u32 handle;
+	__u32 priority;
+	__u32 class_id;
+	bool direct_action;
+	bool skip_sw;
+	bool skip_hw;
+	size_t :0;
+};
+
+#define bpf_tc_cls_opts__last_field skip_hw
+
+/* Acts as a handle for an attached filter */
+struct bpf_tc_cls_attach_id {
+	__u32 ifindex;
+	union {
+		__u32 block_index;
+		__u32 parent_id;
+	};
+	__u32 protocol;
+	__u32 chain_index;
+	__u32 handle;
+	__u32 priority;
+};
+
+struct bpf_tc_cls_info {
+	struct bpf_tc_cls_attach_id id;
+	__u32 class_id;
+	__u32 bpf_flags;
+	__u32 bpf_flags_gen;
+};
+
+/* id is out parameter that will be written to, it must not be NULL */
+LIBBPF_API int bpf_tc_cls_attach_dev(int fd, __u32 ifindex, __u32 parent_id,
+				     __u32 protocol,
+				     const struct bpf_tc_cls_opts *opts,
+				     struct bpf_tc_cls_attach_id *id);
+LIBBPF_API int bpf_tc_cls_change_dev(int fd, __u32 ifindex, __u32 parent_id,
+				     __u32 protocol,
+				     const struct bpf_tc_cls_opts *opts,
+				     struct bpf_tc_cls_attach_id *id);
+/* This replaces an existing filter with the same attributes, so the arguments
+ * can be filled in from an existing attach_id when replacing, and otherwise be
+ * used like bpf_tc_cls_attach_dev.
+ */
+LIBBPF_API int bpf_tc_cls_replace_dev(int fd, __u32 ifindex, __u32 parent_id,
+				      __u32 protocol,
+				      const struct bpf_tc_cls_opts *opts,
+				      struct bpf_tc_cls_attach_id *id);
+LIBBPF_API int bpf_tc_cls_detach_dev(const struct bpf_tc_cls_attach_id *id);
+LIBBPF_API int bpf_tc_cls_get_info_dev(int fd, __u32 ifindex, __u32 parent_id,
+				       __u32 protocol,
+				       const struct bpf_tc_cls_opts *opts,
+				       struct bpf_tc_cls_info *info);
+
+/* id is out parameter that will be written to, it must not be NULL */
+LIBBPF_API int bpf_tc_cls_attach_block(int fd, __u32 block_index,
+				       __u32 protocol,
+				       const struct bpf_tc_cls_opts *opts,
+				       struct bpf_tc_cls_attach_id *id);
+LIBBPF_API int bpf_tc_cls_change_block(int fd, __u32 block_index,
+				       __u32 protocol,
+				       const struct bpf_tc_cls_opts *opts,
+				       struct bpf_tc_cls_attach_id *id);
+/* This replaces an existing filter with the same attributes, so the arguments
+ * can be filled in from an existing attach_id when replacing, and otherwise be
+ * used like bpf_tc_cls_attach_block.
+ */
+LIBBPF_API int bpf_tc_cls_replace_block(int fd, __u32 block_index,
+					__u32 protocol,
+					const struct bpf_tc_cls_opts *opts,
+					struct bpf_tc_cls_attach_id *id);
+LIBBPF_API int bpf_tc_cls_detach_block(const struct bpf_tc_cls_attach_id *id);
+LIBBPF_API int bpf_tc_cls_get_info_block(int fd, __u32 block_index,
+					 __u32 protocol,
+					 const struct bpf_tc_cls_opts *opts,
+					 struct bpf_tc_cls_info *info);
+
+struct bpf_tc_act_opts {
+	size_t sz;
+	__u32 index;
+	int action;
+	void *cookie;
+	size_t cookie_len;
+	__u8 hw_stats_type;
+	bool no_percpu;
+	size_t :0;
+};
+
+#define bpf_tc_act_opts__last_field no_percpu
+
+struct bpf_tc_act_info {
+	__u32 index;
+	__u32 capab;
+	int action;
+	int refcnt;
+	int bindcnt;
+};
+
+LIBBPF_API int bpf_tc_act_attach(int fd, const struct bpf_tc_act_opts *opts, __u32 *index);
+LIBBPF_API int bpf_tc_act_replace(int fd, const struct bpf_tc_act_opts *opts, __u32 *index);
+LIBBPF_API int bpf_tc_act_detach(__u32 index);
+LIBBPF_API int bpf_tc_act_get_info(int fd, struct bpf_tc_act_info *info);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 279ae861f568..72022b45a8b9 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -359,4 +359,18 @@ LIBBPF_0.4.0 {
 		bpf_linker__finalize;
 		bpf_linker__free;
 		bpf_linker__new;
+		bpf_tc_act_attach;
+		bpf_tc_act_replace;
+		bpf_tc_act_detach;
+		bpf_tc_act_get_info;
+		bpf_tc_cls_attach_block;
+		bpf_tc_cls_attach_dev;
+		bpf_tc_cls_change_block;
+		bpf_tc_cls_change_dev;
+		bpf_tc_cls_detach_block;
+		bpf_tc_cls_detach_dev;
+		bpf_tc_cls_replace_block;
+		bpf_tc_cls_replace_dev;
+		bpf_tc_cls_get_info_dev;
+		bpf_tc_cls_get_info_block;
 } LIBBPF_0.3.0;
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index f448c29de76d..bd196d184341 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -4,8 +4,13 @@
 #include <stdlib.h>
 #include <memory.h>
 #include <unistd.h>
+#include <inttypes.h>
+#include <arpa/inet.h>
 #include <linux/bpf.h>
+#include <linux/atm.h>
+#include <linux/pkt_cls.h>
 #include <linux/rtnetlink.h>
+#include <linux/tc_act/tc_bpf.h>
 #include <sys/socket.h>
 #include <errno.h>
 #include <time.h>
@@ -344,6 +349,20 @@ int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
 	return ret;
 }
 
+static int bpf_nl_get_ext(struct nlmsghdr *nh, int sock, unsigned int nl_pid,
+			  __dump_nlmsg_t dump_link_nlmsg_p,
+			  libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie)
+{
+	int seq = time(NULL);
+
+	nh->nlmsg_seq = seq;
+	if (send(sock, nh, nh->nlmsg_len, 0) < 0)
+		return -errno;
+
+	return bpf_netlink_recv(sock, nl_pid, seq, dump_link_nlmsg_p,
+				dump_link_nlmsg, cookie);
+}
+
 int libbpf_nl_get_link(int sock, unsigned int nl_pid,
 		       libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie)
 {
@@ -356,12 +375,696 @@ int libbpf_nl_get_link(int sock, unsigned int nl_pid,
 		.nlh.nlmsg_flags = NLM_F_DUMP | NLM_F_REQUEST,
 		.ifm.ifi_family = AF_PACKET,
 	};
-	int seq = time(NULL);
 
-	req.nlh.nlmsg_seq = seq;
-	if (send(sock, &req, req.nlh.nlmsg_len, 0) < 0)
-		return -errno;
+	return bpf_nl_get_ext(&req.nlh, sock, nl_pid, __dump_link_nlmsg,
+			      dump_link_nlmsg, cookie);
+}
 
-	return bpf_netlink_recv(sock, nl_pid, seq, __dump_link_nlmsg,
-				dump_link_nlmsg, cookie);
+static int tc_bpf_add_fd_and_name(struct nlmsghdr *nh, size_t maxsz, int fd,
+				  enum bpf_prog_type type)
+{
+	int len, ret, bpf_fd_type, bpf_name_type;
+	struct bpf_prog_info info = {};
+	__u32 info_len = sizeof(info);
+	char name[64] = {};
+
+	switch (type) {
+	case BPF_PROG_TYPE_SCHED_CLS:
+		bpf_fd_type = TCA_BPF_FD;
+		bpf_name_type = TCA_BPF_NAME;
+		break;
+	case BPF_PROG_TYPE_SCHED_ACT:
+		bpf_fd_type = TCA_ACT_BPF_FD;
+		bpf_name_type = TCA_ACT_BPF_NAME;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = bpf_obj_get_info_by_fd(fd, &info, &info_len);
+	if (ret < 0 || type != info.type)
+		return ret;
+
+	ret = add_nlattr(nh, maxsz, bpf_fd_type, &fd, sizeof(fd));
+	if (ret < 0)
+		return ret;
+
+	len = snprintf(name, sizeof(name), "%s:[%" PRIu32 "]", info.name,
+		       info.id);
+	if (len < 0 || len >= sizeof(name))
+		return len < 0 ? -EINVAL : -ENAMETOOLONG;
+
+	return add_nlattr(nh, maxsz, bpf_name_type, name, len + 1);
+}
+
+struct pass_info {
+	void *info;
+	__u32 prog_id;
+};
+
+static int cls_get_info(struct nlmsghdr *nh, libbpf_dump_nlmsg_t fn,
+			void *cookie);
+
+static int tc_cls_bpf_modify(int fd, int cmd, unsigned int flags, __u32 ifindex,
+			     __u32 parent_id, __u32 protocol,
+			     const struct bpf_tc_cls_opts *opts,
+			     __dump_nlmsg_t fn, struct bpf_tc_cls_attach_id *id)
+{
+	unsigned int bpf_flags = 0, bpf_flags_gen = 0;
+	struct bpf_tc_cls_info info = {};
+	int sock, seq = 0, ret;
+	struct nlattr *nla;
+	__u32 nl_pid = 0;
+	struct {
+		struct nlmsghdr nh;
+		struct tcmsg t;
+		char buf[256];
+	} req;
+
+	if (OPTS_GET(opts, priority, 0) > 0xFFFF)
+		return -EINVAL;
+
+	sock = libbpf_netlink_open(&nl_pid);
+	if (sock < 0)
+		return sock;
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcmsg));
+	req.nh.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK | flags;
+	req.nh.nlmsg_type = cmd;
+	req.nh.nlmsg_pid = 0;
+	req.nh.nlmsg_seq = ++seq;
+	req.t.tcm_family = AF_UNSPEC;
+	req.t.tcm_handle = OPTS_GET(opts, handle, 0);
+	req.t.tcm_parent = parent_id;
+	req.t.tcm_ifindex = ifindex;
+	req.t.tcm_info =
+		TC_H_MAKE(OPTS_GET(opts, priority, 0UL) << 16, htons(protocol));
+
+	if (OPTS_HAS(opts, chain_index)) {
+		ret = add_nlattr(&req.nh, sizeof(req), TCA_CHAIN,
+				 &opts->chain_index, sizeof(opts->chain_index));
+		if (ret < 0)
+			goto end;
+	}
+
+	ret = add_nlattr(&req.nh, sizeof(req), TCA_KIND, "bpf", sizeof("bpf"));
+	if (ret < 0)
+		goto end;
+
+	nla = begin_nlattr_nested(&req.nh, sizeof(req), TCA_OPTIONS);
+	if (!nla) {
+		ret = -EMSGSIZE;
+		goto end;
+	}
+
+	if (OPTS_GET(opts, class_id, TC_H_UNSPEC)) {
+		ret = add_nlattr(&req.nh, sizeof(req), TCA_BPF_CLASSID,
+				 &opts->class_id, sizeof(opts->class_id));
+		if (ret < 0)
+			goto end;
+	}
+
+	if (cmd != RTM_DELTFILTER) {
+		ret = tc_bpf_add_fd_and_name(&req.nh, sizeof(req), fd,
+					     BPF_PROG_TYPE_SCHED_CLS);
+		if (ret < 0)
+			goto end;
+
+		if (OPTS_GET(opts, skip_hw, false))
+			bpf_flags_gen |= TCA_CLS_FLAGS_SKIP_HW;
+		if (OPTS_GET(opts, skip_sw, false))
+			bpf_flags_gen |= TCA_CLS_FLAGS_SKIP_SW;
+		if (OPTS_GET(opts, direct_action, false))
+			bpf_flags |= TCA_BPF_FLAG_ACT_DIRECT;
+
+		if (bpf_flags_gen) {
+			ret = add_nlattr(&req.nh, sizeof(req),
+					 TCA_BPF_FLAGS_GEN, &bpf_flags_gen,
+					 sizeof(bpf_flags_gen));
+			if (ret < 0)
+				goto end;
+		}
+
+		if (bpf_flags) {
+			ret = add_nlattr(&req.nh, sizeof(req), TCA_BPF_FLAGS,
+					 &bpf_flags, sizeof(bpf_flags));
+			if (ret < 0)
+				goto end;
+		}
+	}
+
+	end_nlattr_nested(&req.nh, nla);
+
+	ret = send(sock, &req.nh, req.nh.nlmsg_len, 0);
+	if (ret < 0)
+		goto end;
+
+	ret = bpf_netlink_recv(sock, nl_pid, seq, fn, NULL,
+			       &(struct pass_info){ &info, 0 });
+
+	if (fn)
+		*id = info.id;
+
+end:
+	close(sock);
+	return ret;
+}
+
+int bpf_tc_cls_attach_dev(int fd, __u32 ifindex, __u32 parent_id,
+			  __u32 protocol, const struct bpf_tc_cls_opts *opts,
+			  struct bpf_tc_cls_attach_id *id)
+{
+	if (fd < 1 || !OPTS_VALID(opts, bpf_tc_cls_opts) || !id)
+		return -EINVAL;
+
+	return tc_cls_bpf_modify(fd, RTM_NEWTFILTER,
+				 NLM_F_ECHO | NLM_F_EXCL | NLM_F_CREATE,
+				 ifindex, parent_id, protocol, opts,
+				 cls_get_info, id);
+}
+
+int bpf_tc_cls_change_dev(int fd, __u32 ifindex, __u32 parent_id,
+			  __u32 protocol, const struct bpf_tc_cls_opts *opts,
+			  struct bpf_tc_cls_attach_id *id)
+{
+	if (fd < 1 || !OPTS_VALID(opts, bpf_tc_cls_opts) || !id)
+		return -EINVAL;
+
+	return tc_cls_bpf_modify(fd, RTM_NEWTFILTER, NLM_F_ECHO, ifindex,
+				 parent_id, protocol, opts, cls_get_info, id);
+}
+
+int bpf_tc_cls_replace_dev(int fd, __u32 ifindex, __u32 parent_id,
+			   __u32 protocol, const struct bpf_tc_cls_opts *opts,
+			   struct bpf_tc_cls_attach_id *id)
+{
+	if (fd < 1 || !OPTS_VALID(opts, bpf_tc_cls_opts) || !id)
+		return -EINVAL;
+
+	return tc_cls_bpf_modify(fd, RTM_NEWTFILTER, NLM_F_ECHO | NLM_F_CREATE,
+				 ifindex, parent_id, protocol, opts,
+				 cls_get_info, id);
+}
+
+int bpf_tc_cls_detach_dev(const struct bpf_tc_cls_attach_id *id)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_cls_opts, opts, 0);
+
+	if (!id)
+		return -EINVAL;
+
+	opts.chain_index = id->chain_index;
+	opts.handle = id->handle;
+	opts.priority = id->priority;
+
+	return tc_cls_bpf_modify(-1, RTM_DELTFILTER, 0, id->ifindex,
+				 id->parent_id, id->protocol, &opts, NULL,
+				 NULL);
+}
+
+int bpf_tc_cls_attach_block(int fd, __u32 block_index, __u32 protocol,
+			    const struct bpf_tc_cls_opts *opts,
+			    struct bpf_tc_cls_attach_id *id)
+{
+	return bpf_tc_cls_attach_dev(fd, TCM_IFINDEX_MAGIC_BLOCK, block_index,
+				     protocol, opts, id);
+}
+
+int bpf_tc_cls_change_block(int fd, __u32 block_index, __u32 protocol,
+			    const struct bpf_tc_cls_opts *opts,
+			    struct bpf_tc_cls_attach_id *id)
+{
+	return bpf_tc_cls_attach_dev(fd, TCM_IFINDEX_MAGIC_BLOCK, block_index,
+				     protocol, opts, id);
+}
+
+int bpf_tc_cls_replace_block(int fd, __u32 block_index, __u32 protocol,
+			     const struct bpf_tc_cls_opts *opts,
+			     struct bpf_tc_cls_attach_id *id)
+{
+	return bpf_tc_cls_attach_dev(fd, TCM_IFINDEX_MAGIC_BLOCK, block_index,
+				     protocol, opts, id);
+}
+
+int bpf_tc_cls_detach_block(const struct bpf_tc_cls_attach_id *id)
+{
+	return bpf_tc_cls_detach_dev(id);
+}
+
+static int __cls_get_info(void *cookie, void *msg, struct nlattr **tb)
+{
+	struct nlattr *tbb[TCA_BPF_MAX + 1];
+	struct pass_info *cinfo = cookie;
+	struct bpf_tc_cls_info *info;
+	struct tcmsg *t = msg;
+	__u32 prog_id;
+
+	info = cinfo->info;
+
+	if (!tb[TCA_OPTIONS])
+		return 0;
+
+	libbpf_nla_parse_nested(tbb, TCA_BPF_MAX, tb[TCA_OPTIONS], NULL);
+	if (!tbb[TCA_BPF_ID])
+		return 0;
+
+	prog_id = libbpf_nla_getattr_u32(tbb[TCA_BPF_ID]);
+	if (cinfo->prog_id && cinfo->prog_id != prog_id)
+		return 0;
+
+	info->id.parent_id = t->tcm_parent;
+	info->id.ifindex = t->tcm_ifindex;
+	info->id.protocol = ntohs(TC_H_MIN(t->tcm_info));
+	info->id.priority = TC_H_MAJ(t->tcm_info) >> 16;
+	info->id.handle = t->tcm_handle;
+
+	if (tb[TCA_CHAIN])
+		info->id.chain_index = libbpf_nla_getattr_u32(tb[TCA_CHAIN]);
+	else
+		info->id.chain_index = 0;
+
+	if (tbb[TCA_BPF_FLAGS])
+		info->bpf_flags = libbpf_nla_getattr_u32(tbb[TCA_BPF_FLAGS]);
+
+	if (tbb[TCA_BPF_FLAGS_GEN])
+		info->bpf_flags_gen =
+			libbpf_nla_getattr_u32(tbb[TCA_BPF_FLAGS_GEN]);
+
+	if (tbb[TCA_BPF_CLASSID])
+		info->class_id = libbpf_nla_getattr_u32(tbb[TCA_BPF_CLASSID]);
+
+	return 1;
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
+		return -EINVAL;
+
+	return __cls_get_info(cookie, t, tb);
+}
+
+static int tc_cls_get_info(int fd, __u32 ifindex, __u32 parent_id,
+			   __u32 protocol, const struct bpf_tc_cls_opts *opts,
+			   struct bpf_tc_cls_info *info)
+{
+	__u32 nl_pid, info_len = sizeof(struct bpf_prog_info);
+	struct bpf_prog_info prog_info = {};
+	int sock, ret;
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
+	if (!OPTS_VALID(opts, bpf_tc_cls_opts))
+		return -EINVAL;
+
+	req.t.tcm_parent = parent_id;
+	req.t.tcm_ifindex = ifindex;
+	req.t.tcm_handle = OPTS_GET(opts, handle, 0);
+	req.t.tcm_info =
+		TC_H_MAKE(OPTS_GET(opts, priority, 0UL) << 16, htons(protocol));
+
+	ret = bpf_obj_get_info_by_fd(fd, &prog_info, &info_len);
+	if (ret < 0)
+		return ret;
+
+	sock = libbpf_netlink_open(&nl_pid);
+	if (sock < 0)
+		return sock;
+
+	ret = add_nlattr(&req.nh, sizeof(req), TCA_KIND, "bpf", sizeof("bpf"));
+	if (ret < 0)
+		goto end;
+
+	if (OPTS_HAS(opts, chain_index)) {
+		ret = add_nlattr(&req.nh, sizeof(req), TCA_CHAIN,
+				 &opts->chain_index, sizeof(opts->chain_index));
+		if (ret < 0)
+			goto end;
+	}
+
+	req.nh.nlmsg_seq = time(NULL);
+
+	ret = bpf_nl_get_ext(&req.nh, sock, nl_pid, cls_get_info, NULL,
+			     &(struct pass_info){ info, prog_info.id });
+	if (ret < 0)
+		goto end;
+	/* 1 denotes a match */
+	ret = ret == 1 ? 0 : -ESRCH;
+end:
+	close(sock);
+	return ret;
+}
+
+int bpf_tc_cls_get_info_dev(int fd, __u32 ifindex, __u32 parent_id,
+			    __u32 protocol, const struct bpf_tc_cls_opts *opts,
+			    struct bpf_tc_cls_info *info)
+{
+	return tc_cls_get_info(fd, ifindex, parent_id, protocol, opts, info);
+}
+
+int bpf_tc_cls_get_info_block(int fd, __u32 block_index, __u32 protocol,
+			      const struct bpf_tc_cls_opts *opts,
+			      struct bpf_tc_cls_info *info)
+{
+	return bpf_tc_cls_get_info_dev(fd, TCM_IFINDEX_MAGIC_BLOCK, block_index,
+				       protocol, opts, info);
+}
+
+static int tc_act_add_action(struct nlmsghdr *nh, size_t maxsz, int type,
+			     int fd, const struct bpf_tc_act_opts *opts)
+{
+	struct nlattr *nla, *nla_opt, *nla_subopt;
+	struct tc_act_bpf param = {};
+	int ret;
+
+	nla = begin_nlattr_nested(nh, maxsz, type);
+	if (!nla)
+		return -EMSGSIZE;
+
+	nla_opt = begin_nlattr_nested(nh, maxsz, 1);
+	if (!nla_opt)
+		return -EMSGSIZE;
+
+	ret = add_nlattr(nh, maxsz, TCA_ACT_KIND, "bpf", sizeof("bpf"));
+	if (ret < 0)
+		return ret;
+
+	ret = add_nlattr(nh, maxsz, TCA_ACT_INDEX,
+			 OPTS_HAS(opts, index) ? &opts->index : &(__u32){ 0 },
+			 sizeof(opts->index));
+
+	if (ret < 0)
+		return ret;
+
+	nla_subopt = begin_nlattr_nested(nh, maxsz, TCA_ACT_OPTIONS);
+	if (!nla)
+		return -EMSGSIZE;
+
+	if (fd > 0) {
+		ret = tc_bpf_add_fd_and_name(nh, maxsz, fd,
+					     BPF_PROG_TYPE_SCHED_ACT);
+		if (ret < 0)
+			return ret;
+	}
+
+	param.index = OPTS_GET(opts, index, 0);
+	param.action = OPTS_GET(opts, action, TC_ACT_UNSPEC);
+
+	ret = add_nlattr(nh, maxsz, TCA_ACT_BPF_PARMS, &param, sizeof(param));
+	if (ret < 0)
+		return ret;
+
+	if (OPTS_GET(opts, cookie, NULL) && OPTS_GET(opts, cookie_len, 0)) {
+		if (opts->cookie_len > TC_COOKIE_MAX_SIZE)
+			return -E2BIG;
+
+		ret = add_nlattr(nh, maxsz, TCA_ACT_COOKIE, opts->cookie,
+				 opts->cookie_len);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (OPTS_GET(opts, hw_stats_type, 0)) {
+		struct nla_bitfield32 hw_stats_bf = {
+			.value = opts->hw_stats_type,
+			.selector = opts->hw_stats_type,
+		};
+
+		ret = add_nlattr(nh, maxsz, TCA_ACT_HW_STATS, &hw_stats_bf,
+				 sizeof(hw_stats_bf));
+		if (ret < 0)
+			return ret;
+	}
+
+	if (OPTS_GET(opts, no_percpu, false)) {
+		struct nla_bitfield32 flags = {
+			TCA_ACT_FLAGS_NO_PERCPU_STATS,
+			TCA_ACT_FLAGS_NO_PERCPU_STATS,
+		};
+
+		ret = add_nlattr(nh, maxsz, TCA_ACT_FLAGS, &flags,
+				 sizeof(flags));
+		if (ret < 0)
+			return ret;
+	}
+
+	end_nlattr_nested(nh, nla_subopt);
+	end_nlattr_nested(nh, nla_opt);
+	end_nlattr_nested(nh, nla);
+
+	return 0;
+}
+
+static int tc_act_modify(int cmd, unsigned int flags, int fd, int action,
+			 const struct bpf_tc_act_opts *opts, __dump_nlmsg_t fn,
+			 __u32 *index)
+{
+	struct bpf_tc_act_info info = {};
+	int sock, seq = 0, ret;
+	__u32 nl_pid = 0;
+	struct {
+		struct nlmsghdr nh;
+		struct tcamsg t;
+		char buf[256];
+	} req;
+
+	sock = libbpf_netlink_open(&nl_pid);
+	if (sock < 0)
+		return sock;
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcamsg));
+	req.nh.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK | flags;
+	req.nh.nlmsg_type = cmd;
+	req.nh.nlmsg_pid = 0;
+	req.nh.nlmsg_seq = ++seq;
+	req.t.tca_family = AF_UNSPEC;
+
+	/* gcc complains when using req.nh here */
+	ret = tc_act_add_action((struct nlmsghdr *)&req, sizeof(req),
+				TCA_ACT_TAB, fd, opts);
+	if (ret < 0)
+		goto end;
+
+	ret = send(sock, &req.nh, req.nh.nlmsg_len, 0);
+	if (ret < 0)
+		goto end;
+
+	ret = bpf_netlink_recv(sock, nl_pid, seq, fn, NULL,
+			       &(struct pass_info){ &info, 0 });
+	if (ret < 0)
+		goto end;
+
+	if (fn) {
+		if (info.index) {
+			*index = info.index;
+			ret = 0;
+		} else
+			ret = -ESRCH;
+	}
+
+end:
+	close(sock);
+	return ret;
+}
+
+static int get_act_info(struct nlmsghdr *nh, libbpf_dump_nlmsg_t fn,
+			void *cookie);
+
+int bpf_tc_act_attach(int fd, const struct bpf_tc_act_opts *opts, __u32 *index)
+{
+	if (fd < 1 || !OPTS_VALID(opts, bpf_tc_act_opts) || !index)
+		return -EINVAL;
+
+	return tc_act_modify(RTM_NEWACTION, NLM_F_ECHO | NLM_F_EXCL, fd,
+			     OPTS_GET(opts, action, TCA_ACT_UNSPEC), opts,
+			     get_act_info, index);
+}
+
+int bpf_tc_act_replace(int fd, const struct bpf_tc_act_opts *opts, __u32 *index)
+{
+	if (fd < 1 || !OPTS_VALID(opts, bpf_tc_act_opts) || !index)
+		return -EINVAL;
+
+	return tc_act_modify(RTM_NEWACTION, NLM_F_ECHO | NLM_F_REPLACE, fd,
+			     OPTS_GET(opts, action, TCA_ACT_UNSPEC), opts,
+			     get_act_info, index);
+}
+
+int bpf_tc_act_detach(__u32 index)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_act_opts, opts, .index = index);
+
+	return tc_act_modify(RTM_DELACTION, index ? 0 : NLM_F_ROOT, -1,
+			     TC_ACT_UNSPEC, &opts, NULL, NULL);
+}
+
+static int __get_act_info(void *cookie, void *msg, struct nlattr *nla)
+{
+	struct nlattr *tbb[TCA_ACT_BPF_MAX + 1];
+	struct pass_info *ainfo = cookie;
+	struct bpf_tc_act_info *info;
+	struct tc_act_bpf parm;
+	__u32 prog_id;
+
+	info = ainfo->info;
+
+	if (!nla)
+		return -EINVAL;
+
+	libbpf_nla_parse_nested(tbb, TCA_ACT_BPF_MAX, nla, NULL);
+
+	if (!tbb[TCA_ACT_BPF_PARMS] || !tbb[TCA_ACT_BPF_ID])
+		return -ESRCH;
+
+	prog_id = libbpf_nla_getattr_u32(tbb[TCA_ACT_BPF_ID]);
+	if (ainfo->prog_id && ainfo->prog_id != prog_id)
+		return 0;
+
+	/* Found a match */
+	memcpy(&parm, libbpf_nla_data(tbb[TCA_ACT_BPF_PARMS]),
+	       sizeof(parm));
+
+	info->index = parm.index;
+	info->capab = parm.capab;
+	info->action = parm.action;
+	info->refcnt = parm.refcnt;
+	info->bindcnt = parm.bindcnt;
+
+	return 1;
+}
+
+static int get_act_info_msg(struct nlmsghdr *nh, libbpf_dump_nlmsg_t fn,
+			    void *cookie, __u32 total, struct nlattr *nla)
+{
+	struct nlattr *tbb[TCA_ACT_MAX + 1];
+	struct tcamsg *t = NLMSG_DATA(nh);
+	struct nlattr *tb[total + 1];
+	int ret;
+
+	libbpf_nla_parse_nested(tb, total, nla, NULL);
+
+	for (int i = 0; i <= total; i++) {
+		if (tb[i]) {
+			nla = tb[i];
+			libbpf_nla_parse_nested(tbb, TCA_ACT_MAX, nla, NULL);
+
+			if (!tbb[TCA_ACT_KIND])
+				return -EINVAL;
+
+			ret = __get_act_info(cookie, t, tbb[TCA_ACT_OPTIONS]);
+			if (ret < 0)
+				return ret;
+
+			if (ret > 0)
+				return 1;
+		}
+	}
+
+	return 0;
+}
+
+static int get_act_info(struct nlmsghdr *nh, libbpf_dump_nlmsg_t fn,
+			void *cookie)
+{
+	struct nlattr *nla, *tb[TCA_ROOT_MAX + 1];
+	__u32 total = 0;
+
+	nla = NLMSG_DATA(nh) + NLMSG_ALIGN(sizeof(struct tcamsg));
+	libbpf_nla_parse(tb, TCA_ROOT_MAX, nla,
+			 NLMSG_PAYLOAD(nh, sizeof(struct tcamsg)), NULL);
+
+	if (tb[TCA_ROOT_COUNT])
+		total = libbpf_nla_getattr_u32(tb[TCA_ROOT_COUNT]);
+
+	total = total ?: TCA_ACT_MAX_PRIO;
+
+	return get_act_info_msg(nh, fn, cookie, total, tb[TCA_ACT_TAB]);
+}
+
+static int tc_act_get_info(int sock, unsigned int nl_pid, int fd,
+			   struct bpf_tc_act_info *info)
+{
+	struct bpf_prog_info prog_info = {};
+	__u32 info_len = sizeof(prog_info);
+	struct nlattr *nla, *nla_opt;
+	struct {
+		struct nlmsghdr nh;
+		struct tcamsg t;
+		char buf[256];
+	} req = {
+		.nh.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcamsg)),
+		.nh.nlmsg_type = RTM_GETACTION,
+		.nh.nlmsg_flags = NLM_F_REQUEST | NLM_F_DUMP,
+		.t.tca_family = AF_UNSPEC,
+	};
+	int ret;
+
+	if (fd < 1)
+		return -EINVAL;
+
+	ret = bpf_obj_get_info_by_fd(fd, &prog_info, &info_len);
+	if (ret < 0)
+		return ret;
+
+	nla = begin_nlattr_nested(&req.nh, sizeof(req), TCA_ACT_TAB);
+	if (!nla)
+		return -EMSGSIZE;
+
+	nla_opt = begin_nlattr_nested(&req.nh, sizeof(req), 1);
+	if (!nla_opt)
+		return -EMSGSIZE;
+
+	ret = add_nlattr(&req.nh, sizeof(req), TCA_ACT_KIND, "bpf",
+			 sizeof("bpf"));
+	if (ret < 0)
+		return ret;
+
+	end_nlattr_nested(&req.nh, nla_opt);
+	end_nlattr_nested(&req.nh, nla);
+
+	req.nh.nlmsg_seq = time(NULL);
+
+	/* Pass prog id the info is to be returned for */
+	return bpf_nl_get_ext(&req.nh, sock, nl_pid, get_act_info, NULL,
+			      &(struct pass_info){ info, prog_info.id });
+}
+
+int bpf_tc_act_get_info(int fd, struct bpf_tc_act_info *info)
+{
+	int sock, ret;
+	__u32 nl_pid;
+
+	if (fd < 1 || !info)
+		return -EINVAL;
+
+	sock = libbpf_netlink_open(&nl_pid);
+	if (sock < 0)
+		return sock;
+
+	ret = tc_act_get_info(sock, nl_pid, fd, info);
+	if (ret < 0)
+		goto end;
+
+	if (!info->index)
+		ret = -ESRCH;
+end:
+	close(sock);
+	return ret;
 }
-- 
2.30.2

