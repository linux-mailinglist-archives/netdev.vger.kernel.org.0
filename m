Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEDD36604F
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 21:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbhDTTi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 15:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233776AbhDTTiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 15:38:24 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479E0C06174A;
        Tue, 20 Apr 2021 12:37:52 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id m12so6662343pgr.9;
        Tue, 20 Apr 2021 12:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UJ49Ky4Ne+BPVSGhY/nJQ0JKnt9i7GAQhVqUgjzvGTs=;
        b=WV+VyrZyMAGsldNYF0HsW4yqNADarjM+oFW9QW+7pVxqRplGoAsr/Nn66pozz1aVV3
         wE/yp+p8fMIj9JSikxttFuv2nuLxmKUPUSSAr3GbgAVmn3gDZLj30E7ch1pd6SVuoEF3
         vQiMMrL+Q2fUvsAqD6AODyfG5QYeZCvsa/58FyQB6fZM5xIdrCh0Gq3F5WeJ/yW9ffuU
         ueXghAXDYkxTdZzG/LuH0mn6QZqwnpMYpJPTlRbCEPLmq9mnx9kZd0ZB20pomP3xkNiL
         wX9nrIRjwpXH2+3P8zT7Aoc/kqBM0C2viE9pVuczlaPHuDzV2VdpDPp667uyadaBtfB5
         90mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UJ49Ky4Ne+BPVSGhY/nJQ0JKnt9i7GAQhVqUgjzvGTs=;
        b=j1NlkHZLWsTDdutXZ5Uy1ouCrbYf7rABfv2Jxr0jDuivZ7UUkYu7FdRLXmb07tvHnb
         1lIBLRsOEhzFfn81SSsTBBVJ0E3u/jjod85c0iZzh8IbMELxwMmI8OZ81L1ujFCv5Rbo
         wH+/i8CCq0+2Xh/G7C8AGjk3vD1rFk7Lp7t/YmnHf0/oAyxl/3QoD86K9XirvRXADMfV
         bCsVUQ06SXcwZcLH5Gv3nYas3gdLmzLrhz3FsXirij/3WPtr5q7fre1qzex4TMSu5i0k
         bj4iZvPxfMoG1RM80JvkasfMfYPB0HMwJhJEaB630kRNIxPf9UVmppIk825ww5sjmOHW
         u8uw==
X-Gm-Message-State: AOAM530FwMIyXzhnq9+k9Ei8N5LPoVMawSOQxMw+RzsBcEgVJpwFldOJ
        GcqIAgP5iGXWE2HHqKhbCDzWFYT1KgrwvQ==
X-Google-Smtp-Source: ABdhPJxGW2V7XFCapTpfsuY2+5ZEQOIb+/fkYfr0kTyjYEJ6cPq51VRSX2hHnNST/pGZSIIu4vv76w==
X-Received: by 2002:a63:1425:: with SMTP id u37mr17965611pgl.227.1618947471439;
        Tue, 20 Apr 2021 12:37:51 -0700 (PDT)
Received: from localhost ([112.79.227.195])
        by smtp.gmail.com with ESMTPSA id w9sm6074749pfn.213.2021.04.20.12.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 12:37:51 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 2/3] libbpf: add low level TC-BPF API
Date:   Wed, 21 Apr 2021 01:07:39 +0530
Message-Id: <20210420193740.124285-3-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420193740.124285-1-memxor@gmail.com>
References: <20210420193740.124285-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds functions that wrap the netlink API used for adding,
manipulating, and removing traffic control filters. These functions
operate directly on the loaded prog's fd, and return a handle to the
filter using an out parameter named id.

The basic featureset is covered to allow for attaching and removal of
filters. Some additional features like TCA_BPF_POLICE and TCA_RATE for
the API have been omitted. These can added on top later by extending the
bpf_tc_opts struct.

Support for binding actions directly to a classifier by passing them in
during filter creation has also been omitted for now. These actions have
an auto clean up property because their lifetime is bound to the filter
they are attached to. This can be added later, but was omitted for now
as direct action mode is a better alternative to it, which is enabled by
default.

An API summary:

bpf_tc_attach may be used to attach, and replace SCHED_CLS bpf
classifier. The protocol is always set as ETH_P_ALL. The replace option
in bpf_tc_opts is used to control replacement behavior.  Attachment
fails if filter with existing attributes already exists.

bpf_tc_detach may be used to detach existing SCHED_CLS filter. The
bpf_tc_attach_id object filled in during attach must be passed in to the
detach functions for them to remove the filter and its attached
classififer correctly.

bpf_tc_get_info is a helper that can be used to obtain attributes
for the filter and classififer.

Examples:

	struct bpf_tc_attach_id id = {};
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

	r = bpf_tc_attach(fd, if_nametoindex("lo"),
			  BPF_TC_CLSACT_INGRESS,
			  NULL, &id);
	if (r < 0)
		return r;

... which is roughly equivalent to:
  # tc qdisc add dev lo clsact
  # tc filter add dev lo ingress bpf obj foo.o sec classifier da

... as direct action mode is always enabled.

To replace an existing filter:

	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = id.handle,
			    .priority = id.priority, .replace = true);
	r = bpf_tc_attach(fd, if_nametoindex("lo"),
			  BPF_TC_CLSACT_INGRESS,
			  &opts, &id);
	if (r < 0)
		return r;

To obtain info of a particular filter, the example above can be extended
as follows:

	struct bpf_tc_info info = {};

	r = bpf_tc_get_info(if_nametoindex("lo"),
			    BPF_TC_CLSACT_INGRESS,
			    &id, &info);
	if (r < 0)
		return r;

... where id corresponds to the bpf_tc_attach_id filled in during an
attach operation.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/libbpf.h   |  44 ++++++
 tools/lib/bpf/libbpf.map |   3 +
 tools/lib/bpf/netlink.c  | 319 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 360 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index bec4e6a6e31d..b4ed6a41ea70 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -16,6 +16,8 @@
 #include <stdbool.h>
 #include <sys/types.h>  // for size_t
 #include <linux/bpf.h>
+#include <linux/pkt_sched.h>
+#include <linux/tc_act/tc_bpf.h>
 
 #include "libbpf_common.h"
 
@@ -775,6 +777,48 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filen
 LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
 LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
 
+/* Convenience macros for the clsact attach hooks */
+#define BPF_TC_CLSACT_INGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS)
+#define BPF_TC_CLSACT_EGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)
+
+struct bpf_tc_opts {
+	size_t sz;
+	__u32 handle;
+	__u32 class_id;
+	__u16 priority;
+	bool replace;
+	size_t :0;
+};
+
+#define bpf_tc_opts__last_field replace
+
+/* Acts as a handle for an attached filter */
+struct bpf_tc_attach_id {
+	__u32 handle;
+	__u16 priority;
+};
+
+struct bpf_tc_info {
+	struct bpf_tc_attach_id id;
+	__u16 protocol;
+	__u32 chain_index;
+	__u32 prog_id;
+	__u8 tag[BPF_TAG_SIZE];
+	__u32 class_id;
+	__u32 bpf_flags;
+	__u32 bpf_flags_gen;
+};
+
+/* id is out parameter that will be written to, it must not be NULL */
+LIBBPF_API int bpf_tc_attach(int fd, __u32 ifindex, __u32 parent_id,
+			     const struct bpf_tc_opts *opts,
+			     struct bpf_tc_attach_id *id);
+LIBBPF_API int bpf_tc_detach(__u32 ifindex, __u32 parent_id,
+			     const struct bpf_tc_attach_id *id);
+LIBBPF_API int bpf_tc_get_info(__u32 ifindex, __u32 parent_id,
+			       const struct bpf_tc_attach_id *id,
+			       struct bpf_tc_info *info);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index b9b29baf1df8..686444fbb838 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -361,4 +361,7 @@ LIBBPF_0.4.0 {
 		bpf_linker__new;
 		bpf_map__inner_map;
 		bpf_object__set_kversion;
+		bpf_tc_attach;
+		bpf_tc_detach;
+		bpf_tc_get_info;
 } LIBBPF_0.3.0;
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index c79e30484e81..71109dcea9e4 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -4,7 +4,10 @@
 #include <stdlib.h>
 #include <memory.h>
 #include <unistd.h>
+#include <inttypes.h>
+#include <arpa/inet.h>
 #include <linux/bpf.h>
+#include <linux/if_ether.h>
 #include <linux/rtnetlink.h>
 #include <sys/socket.h>
 #include <errno.h>
@@ -344,6 +347,20 @@ int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
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
@@ -356,12 +373,302 @@ int libbpf_nl_get_link(int sock, unsigned int nl_pid,
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
+static int tc_setup_clsact_excl(int sock, __u32 nl_pid, __u32 ifindex)
+{
+	int seq = 0, ret = 0;
+	struct {
+		struct nlmsghdr nh;
+		struct tcmsg t;
+		char buf[256];
+	} req;
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcmsg));
+	req.nh.nlmsg_flags =
+		NLM_F_REQUEST | NLM_F_CREATE | NLM_F_ACK | NLM_F_EXCL;
+	req.nh.nlmsg_type = RTM_NEWQDISC;
+	req.nh.nlmsg_pid = 0;
+	req.nh.nlmsg_seq = ++seq;
+	req.t.tcm_family = AF_UNSPEC;
+	req.t.tcm_ifindex = ifindex;
+	req.t.tcm_parent = TC_H_CLSACT;
+	req.t.tcm_handle = TC_H_MAKE(TC_H_CLSACT, 0);
+
+	ret = nlattr_add(&req.nh, sizeof(req), TCA_KIND, "clsact",
+			 sizeof("clsact"));
+	if (ret < 0)
+		return ret;
+
+	ret = send(sock, &req.nh, req.nh.nlmsg_len, 0);
+	if (ret < 0)
+		return ret;
+
+	return bpf_netlink_recv(sock, nl_pid, seq, NULL, NULL, NULL);
+}
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
+static int cls_get_info(struct nlmsghdr *nh, libbpf_dump_nlmsg_t fn,
+			void *cookie);
+
+static int tc_cls_bpf_modify(int fd, int cmd, unsigned int flags, __u32 ifindex,
+			     __u32 parent_id, const struct bpf_tc_opts *opts,
+			     __dump_nlmsg_t fn, struct bpf_tc_attach_id *id)
+{
+	__u32 nl_pid = 0, protocol, priority;
+	struct bpf_tc_info info = {};
+	unsigned int bpf_flags = 0;
+	int sock, seq = 0, ret;
+	struct nlattr *nla;
+	struct {
+		struct nlmsghdr nh;
+		struct tcmsg t;
+		char buf[256];
+	} req;
+
+	sock = libbpf_netlink_open(&nl_pid);
+	if (sock < 0)
+		return sock;
+
+	if ((parent_id == BPF_TC_CLSACT_INGRESS ||
+	     parent_id == BPF_TC_CLSACT_EGRESS) &&
+	    flags & NLM_F_CREATE) {
+		ret = tc_setup_clsact_excl(sock, nl_pid, ifindex);
+		/* Attachment can still fail if ingress qdisc is installed, and
+		 * we're trying attach on egress as parent. Ignore in that case
+		 * as well.
+		 */
+		if (ret < 0 && ret != -EEXIST)
+			goto end;
+	}
+
+	priority = OPTS_GET(opts, priority, 0);
+	protocol = ETH_P_ALL;
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
+	req.t.tcm_info = TC_H_MAKE(priority << 16, htons(protocol));
+
+	ret = nlattr_add(&req.nh, sizeof(req), TCA_KIND, "bpf", sizeof("bpf"));
+	if (ret < 0)
+		goto end;
+
+	nla = nlattr_begin_nested(&req.nh, sizeof(req), TCA_OPTIONS);
+	if (!nla) {
+		ret = -EMSGSIZE;
+		goto end;
+	}
+
+	if (OPTS_GET(opts, class_id, TC_H_UNSPEC)) {
+		ret = nlattr_add(&req.nh, sizeof(req), TCA_BPF_CLASSID,
+				 &opts->class_id, sizeof(opts->class_id));
+		if (ret < 0)
+			goto end;
+	}
+
+	if (cmd != RTM_DELTFILTER) {
+		ret = tc_bpf_add_fd_and_name(&req.nh, sizeof(req), fd);
+		if (ret < 0)
+			goto end;
+
+		/* direct action is always set */
+		bpf_flags |= TCA_BPF_FLAG_ACT_DIRECT;
+		ret = nlattr_add(&req.nh, sizeof(req), TCA_BPF_FLAGS,
+				 &bpf_flags, sizeof(bpf_flags));
+		if (ret < 0)
+			goto end;
+	}
+
+	nlattr_end_nested(&req.nh, nla);
+
+	ret = send(sock, &req.nh, req.nh.nlmsg_len, 0);
+	if (ret < 0)
+		goto end;
+
+	ret = bpf_netlink_recv(sock, nl_pid, seq, fn, NULL, &info);
+
+	if (fn) {
+		*id = info.id;
+		ret = ret < 0 ? ret : 0;
+	}
+
+end:
+	close(sock);
+	return ret;
+}
+
+int bpf_tc_attach(int fd, __u32 ifindex, __u32 parent_id,
+		  const struct bpf_tc_opts *opts,
+		  struct bpf_tc_attach_id *id)
+{
+	if (fd < 0 || !OPTS_VALID(opts, bpf_tc_opts) || !id)
+		return -EINVAL;
+
+	return tc_cls_bpf_modify(fd, RTM_NEWTFILTER,
+				 NLM_F_ECHO | NLM_F_CREATE |
+			         (OPTS_GET(opts, replace, false) ?
+					NLM_F_REPLACE : NLM_F_EXCL),
+				 ifindex, parent_id, opts, cls_get_info, id);
+}
+
+int bpf_tc_detach(__u32 ifindex, __u32 parent_id,
+		  const struct bpf_tc_attach_id *id)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, 0);
+
+	if (!id)
+		return -EINVAL;
+
+	opts.handle = id->handle;
+	opts.priority = id->priority;
+
+	return tc_cls_bpf_modify(-1, RTM_DELTFILTER, 0, ifindex, parent_id,
+				 &opts, NULL, NULL);
+}
+
+static int __cls_get_info(void *cookie, void *msg, struct nlattr **tb)
+{
+	struct nlattr *tbb[TCA_BPF_MAX + 1];
+	struct bpf_tc_info *info = cookie;
+	struct tcmsg *t = msg;
+
+	if (!tb[TCA_OPTIONS])
+		return 0;
+
+	libbpf_nla_parse_nested(tbb, TCA_BPF_MAX, tb[TCA_OPTIONS], NULL);
+	if (!tbb[TCA_BPF_ID])
+		return 0;
+
+	info->protocol = ntohs(TC_H_MIN(t->tcm_info));
+	info->id.priority = TC_H_MAJ(t->tcm_info) >> 16;
+	info->id.handle = t->tcm_handle;
+
+	if (tb[TCA_CHAIN])
+		info->chain_index = libbpf_nla_getattr_u32(tb[TCA_CHAIN]);
+	else
+		info->chain_index = 0;
+
+	if (tbb[TCA_BPF_FLAGS])
+		info->bpf_flags = libbpf_nla_getattr_u32(tbb[TCA_BPF_FLAGS]);
+
+	if (tbb[TCA_BPF_FLAGS_GEN])
+		info->bpf_flags_gen =
+			libbpf_nla_getattr_u32(tbb[TCA_BPF_FLAGS_GEN]);
+
+	if (tbb[TCA_BPF_ID])
+		info->prog_id = libbpf_nla_getattr_u32(tbb[TCA_BPF_ID]);
+
+	if (tbb[TCA_BPF_TAG])
+		memcpy(info->tag, libbpf_nla_getattr_str(tbb[TCA_BPF_TAG]),
+		       sizeof(info->tag));
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
+static int tc_cls_get_info(__u32 ifindex, __u32 parent_id,
+			   const struct bpf_tc_attach_id *id,
+			   struct bpf_tc_info *info)
+{
+	__u32 nl_pid = 0, protocol;
+	__u32 priority;
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
+	priority = id->priority;
+	protocol = ETH_P_ALL;
+
+	req.t.tcm_parent = parent_id;
+	req.t.tcm_ifindex = ifindex;
+	req.t.tcm_handle = id->handle;
+	req.t.tcm_info = TC_H_MAKE(priority << 16, htons(protocol));
+
+	sock = libbpf_netlink_open(&nl_pid);
+	if (sock < 0)
+		return sock;
+
+	ret = nlattr_add(&req.nh, sizeof(req), TCA_KIND, "bpf", sizeof("bpf"));
+	if (ret < 0)
+		goto end;
+
+	req.nh.nlmsg_seq = time(NULL);
+
+	ret = bpf_nl_get_ext(&req.nh, sock, nl_pid, cls_get_info, NULL, info);
+	if (ret < 0)
+		goto end;
+	/* 1 denotes a match */
+	ret = ret == 1 ? 0 : -ESRCH;
+end:
+	close(sock);
+	return ret;
+}
+
+int bpf_tc_get_info(__u32 ifindex, __u32 parent_id,
+		    const struct bpf_tc_attach_id *id,
+		    struct bpf_tc_info *info)
+{
+	if (!id || !info)
+		return -EINVAL;
+
+	return tc_cls_get_info(ifindex, parent_id, id, info);
 }
-- 
2.30.2

