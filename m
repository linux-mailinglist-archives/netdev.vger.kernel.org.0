Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE90364180
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 14:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239077AbhDSMTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 08:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239167AbhDSMTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 08:19:04 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B49C06138A;
        Mon, 19 Apr 2021 05:18:33 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id u15so9036187plf.10;
        Mon, 19 Apr 2021 05:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d8ApIxvCkT3ID4ARndz1bGNbRQawi7nBmKGI8TB514o=;
        b=ef3Yi5Cns93C/gEDNzqdO+ijkZlhGdifTmuO4tE86rY6iXabgYI6pkyVquZSlUIcMg
         HREYKoYStNfJ0MjbGFVTWKledQjHknEyYWaxfUWCboybaCc/ii8wvBCpimBZ0dOl1Lv5
         lUNlWgfmZlKN1nwmHoC09ffEWw/IWOnBgFfR3/dms1MxQEIjshzNrBhORk6sbvMYtC9L
         ILoRa8iq309ixxac0eQy51LtsWFH5MwxYK++7ZOLXKDU3Gy9K7ZTVTv9A3Tb+p959nSV
         MttNe+hgOvqADOEOgkhtnPEqVKXTlc79mIHwKU37S2+fxhKw0dR6qZdGOzCD2UGk/31u
         k+5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d8ApIxvCkT3ID4ARndz1bGNbRQawi7nBmKGI8TB514o=;
        b=CbYEbtDlm6eiUIIWhTWpuqktHg8+BO/CtsgbztHEm1NCvwj+L+JILVlyTW9K3ccVhj
         IyKcw1NQ/HYtyUW42KkzmSnfd9fqysmm/rW3jyx1nPuL3S64K4qfh6RvDE8S6e5jqyWT
         SLqHtNgLuA9TrLknwW3NWY8ggXIZkqBR2BXAHcaIcO9tkYh0ffjX7nqiOifo/8JpcAFH
         QR6dJIqCyb5s6Hso6edfjV9Lwk78AThdg/eLvGum7xy7JBpa0Z5bg8ZS01oLzpIBInA+
         ssDpMpgJEw3cchgwNRUXllNOwnVzeTRw7RM9D1apXirIsDCKkvM3BeQD2jL2hE3tY14Q
         dp6w==
X-Gm-Message-State: AOAM531tfEjuqDXIbluuQXsErcnZaIK4mYXsTWmOkNqB1lT4XupVJbz5
        P9qoT1rscdbLERpuGzRJhfZ9SYXB+3vgnQ==
X-Google-Smtp-Source: ABdhPJzF8/7eSHsMwjrz4DfF/rRDi0nOjIdc9P7XDz4mBg1S3BNL2ZXWJrOZ5/lCUAWoe4YkYi0e/A==
X-Received: by 2002:a17:90a:eacc:: with SMTP id ev12mr25354859pjb.159.1618834713029;
        Mon, 19 Apr 2021 05:18:33 -0700 (PDT)
Received: from localhost ([112.79.253.181])
        by smtp.gmail.com with ESMTPSA id o3sm6364906pfk.203.2021.04.19.05.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 05:18:32 -0700 (PDT)
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
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 3/4] libbpf: add low level TC-BPF API
Date:   Mon, 19 Apr 2021 17:48:10 +0530
Message-Id: <20210419121811.117400-4-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419121811.117400-1-memxor@gmail.com>
References: <20210419121811.117400-1-memxor@gmail.com>
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

The basic featureset is covered to allow for attaching, manipulation of
properties, and removal of filters. Some additional features like
TCA_BPF_POLICE and TCA_RATE for tc_cls have been omitted. These can
added on top later by extending the bpf_tc_cls_opts struct.

Support for binding actions directly to a classifier by passing them in
during filter creation has also been omitted for now. These actions have
an auto clean up property because their lifetime is bound to the filter
they are attached to. This can be added later, but was omitted for now
as direct action mode is a better alternative to it, which is enabled by
default.

An API summary:

bpf_tc_act_{attach, change, replace} may be used to attach, change, and
replace SCHED_CLS bpf classifier. The protocol field can be set as 0, in
which case it is subsitituted as ETH_P_ALL by default.

The behavior of the three functions is as follows:

attach = create filter if it does not exist, fail otherwise
change = change properties of the classifier of existing filter
replace = create filter, and replace any existing filter

bpf_tc_cls_detach may be used to detach existing SCHED_CLS
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

	r = bpf_tc_cls_attach(fd, if_nametoindex("lo"),
			      BPF_TC_CLSACT_INGRESS,
			      NULL, &id);
	if (r < 0)
		return r;

... which is roughly equivalent to (after clsact qdisc setup):
  # tc filter add dev lo ingress bpf obj foo.o sec classifier da

... as direct action mode is always enabled.

If a user wishes to modify existing options on an attached classifier,
bpf_tc_cls_change API may be used.

Only parameters class_id can be modified, the rest are filled in to
identify the correct filter. protocol can be left out if it was not
chosen explicitly (defaulting to ETH_P_ALL).

Example:

	/* Optional parameters necessary to select the right filter */
	DECLARE_LIBBPF_OPTS(bpf_tc_cls_opts, opts,
			    .handle = id.handle,
			    .priority = id.priority,
			    .chain_index = id.chain_index)
	opts.class_id = TC_H_MAKE(1UL << 16, 12);
	r = bpf_tc_cls_change(fd, if_nametoindex("lo"),
			      BPF_TC_CLSACT_INGRESS,
			      &opts, &id);
	if (r < 0)
		return r;

	struct bpf_tc_cls_info info = {};
	r = bpf_tc_cls_get_info(fd, if_nametoindex("lo"),
			        BPF_TC_CLSACT_INGRESS,
				&opts, &info);
	if (r < 0)
		return r;

	assert(info.class_id == TC_H_MAKE(1UL << 16, 12));

This would be roughly equivalent to doing:
  # tc filter change dev lo egress prio <p> handle <h> bpf obj foo.o sec \
    classifier classid 1:12

... except a new bpf program will be loaded and replace existing one.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/libbpf.h   |  52 ++++++
 tools/lib/bpf/libbpf.map |   5 +
 tools/lib/bpf/netlink.c  | 377 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 428 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index bec4e6a6e31d..2f4a2036cb74 100644
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
 
@@ -775,6 +778,55 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filen
 LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
 LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
 
+/* Convenience macros for the clsact attach hooks */
+#define BPF_TC_CLSACT_INGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS)
+#define BPF_TC_CLSACT_EGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)
+
+struct bpf_tc_cls_opts {
+	size_t sz;
+	__u32 protocol;
+	__u32 handle;
+	__u32 chain_index;
+	__u32 priority;
+	__u32 class_id;
+	size_t :0;
+};
+
+#define bpf_tc_cls_opts__last_field class_id
+
+/* Acts as a handle for an attached filter */
+struct bpf_tc_cls_attach_id {
+	__u32 protocol;
+	__u32 chain_index;
+	__u32 handle;
+	__u32 priority;
+};
+
+struct bpf_tc_cls_info {
+	struct bpf_tc_cls_attach_id id;
+	__u32 prog_id;
+	__u8 tag[BPF_TAG_SIZE];
+	__u32 class_id;
+	__u32 bpf_flags;
+	__u32 bpf_flags_gen;
+};
+
+/* id is out parameter that will be written to, it must not be NULL */
+LIBBPF_API int bpf_tc_cls_attach(int fd, __u32 ifindex, __u32 parent_id,
+				 const struct bpf_tc_cls_opts *opts,
+				 struct bpf_tc_cls_attach_id *id);
+LIBBPF_API int bpf_tc_cls_change(int fd, __u32 ifindex, __u32 parent_id,
+				 const struct bpf_tc_cls_opts *opts,
+				 struct bpf_tc_cls_attach_id *id);
+LIBBPF_API int bpf_tc_cls_replace(int fd, __u32 ifindex, __u32 parent_id,
+				  const struct bpf_tc_cls_opts *opts,
+				  struct bpf_tc_cls_attach_id *id);
+LIBBPF_API int bpf_tc_cls_detach(__u32 ifindex, __u32 parent_id,
+				 const struct bpf_tc_cls_attach_id *id);
+LIBBPF_API int bpf_tc_cls_get_info(int fd, __u32 ifindex, __u32 parent_id,
+				   const struct bpf_tc_cls_opts *opts,
+				   struct bpf_tc_cls_info *info);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index b9b29baf1df8..52e5de1e82ea 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -361,4 +361,9 @@ LIBBPF_0.4.0 {
 		bpf_linker__new;
 		bpf_map__inner_map;
 		bpf_object__set_kversion;
+		bpf_tc_cls_attach;
+		bpf_tc_cls_change;
+		bpf_tc_cls_detach;
+		bpf_tc_cls_replace;
+		bpf_tc_cls_get_info;
 } LIBBPF_0.3.0;
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index c79e30484e81..93cc1e027065 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -4,7 +4,11 @@
 #include <stdlib.h>
 #include <memory.h>
 #include <unistd.h>
+#include <inttypes.h>
+#include <arpa/inet.h>
 #include <linux/bpf.h>
+#include <linux/pkt_cls.h>
+#include <linux/if_ether.h>
 #include <linux/rtnetlink.h>
 #include <sys/socket.h>
 #include <errno.h>
@@ -131,6 +135,41 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 	return ret;
 }
 
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
+	ret = bpf_netlink_recv(sock, nl_pid, seq, NULL, NULL, NULL);
+
+	return ret;
+}
+
 static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
 					 __u32 flags)
 {
@@ -344,6 +383,20 @@ int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
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
@@ -356,12 +409,324 @@ int libbpf_nl_get_link(int sock, unsigned int nl_pid,
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
+struct pass_info {
+	struct bpf_tc_cls_info *info;
+	__u32 prog_id;
+};
+
+static int cls_get_info(struct nlmsghdr *nh, libbpf_dump_nlmsg_t fn,
+			void *cookie);
+
+static int tc_cls_bpf_modify(int fd, int cmd, unsigned int flags, __u32 ifindex,
+			     __u32 parent_id, const struct bpf_tc_cls_opts *opts,
+			     __dump_nlmsg_t fn, struct bpf_tc_cls_attach_id *id)
+{
+	struct bpf_tc_cls_info info = {};
+	unsigned int bpf_flags = 0;
+	__u32 nl_pid = 0, protocol;
+	int sock, seq = 0, ret;
+	struct nlattr *nla;
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
+	if ((parent_id == BPF_TC_CLSACT_INGRESS ||
+	     parent_id == BPF_TC_CLSACT_EGRESS) &&
+	    flags & NLM_F_CREATE) {
+		ret = tc_setup_clsact_excl(sock, nl_pid, ifindex);
+		/* attachment can still fail if ingress qdisc is installed, and
+		 * we're trying attach on egress as parent */
+		if (ret < 0 && ret != -EEXIST)
+			goto end;
+	}
+
+	protocol = OPTS_GET(opts, protocol, 0) ?: ETH_P_ALL;
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
+		ret = nlattr_add(&req.nh, sizeof(req), TCA_CHAIN,
+				 &opts->chain_index, sizeof(opts->chain_index));
+		if (ret < 0)
+			goto end;
+	}
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
+int bpf_tc_cls_attach(int fd, __u32 ifindex, __u32 parent_id,
+		      const struct bpf_tc_cls_opts *opts,
+		      struct bpf_tc_cls_attach_id *id)
+{
+	if (fd < 0 || !OPTS_VALID(opts, bpf_tc_cls_opts) || !id)
+		return -EINVAL;
+
+	return tc_cls_bpf_modify(fd, RTM_NEWTFILTER,
+				 NLM_F_ECHO | NLM_F_EXCL | NLM_F_CREATE,
+				 ifindex, parent_id, opts, cls_get_info, id);
+}
+
+int bpf_tc_cls_change(int fd, __u32 ifindex, __u32 parent_id,
+		      const struct bpf_tc_cls_opts *opts,
+		      struct bpf_tc_cls_attach_id *id)
+{
+	if (fd < 0 || !OPTS_VALID(opts, bpf_tc_cls_opts) || !id)
+		return -EINVAL;
+
+	return tc_cls_bpf_modify(fd, RTM_NEWTFILTER, NLM_F_ECHO, ifindex,
+				 parent_id, opts, cls_get_info, id);
+}
+
+int bpf_tc_cls_replace(int fd, __u32 ifindex, __u32 parent_id,
+		       const struct bpf_tc_cls_opts *opts,
+		       struct bpf_tc_cls_attach_id *id)
+{
+	if (fd < 0 || !OPTS_VALID(opts, bpf_tc_cls_opts) || !id)
+		return -EINVAL;
+
+	return tc_cls_bpf_modify(fd, RTM_NEWTFILTER, NLM_F_ECHO | NLM_F_CREATE,
+				 ifindex, parent_id, opts, cls_get_info, id);
+}
+
+int bpf_tc_cls_detach(__u32 ifindex, __u32 parent_id,
+		      const struct bpf_tc_cls_attach_id *id)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_cls_opts, opts, 0);
+
+	if (!id)
+		return -EINVAL;
+
+	opts.protocol = id->protocol;
+	opts.chain_index = id->chain_index;
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
+static int tc_cls_get_info(int fd, __u32 ifindex, __u32 parent_id,
+			   const struct bpf_tc_cls_opts *opts,
+			   struct bpf_tc_cls_info *info)
+{
+	__u32 nl_pid = 0, protocol, info_len = sizeof(struct bpf_prog_info);
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
+
+	if (!OPTS_VALID(opts, bpf_tc_cls_opts))
+		return -EINVAL;
+
+	protocol = OPTS_GET(opts, protocol, 0) ?: ETH_P_ALL;
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
+	ret = nlattr_add(&req.nh, sizeof(req), TCA_KIND, "bpf", sizeof("bpf"));
+	if (ret < 0)
+		goto end;
+
+	if (OPTS_HAS(opts, chain_index)) {
+		ret = nlattr_add(&req.nh, sizeof(req), TCA_CHAIN,
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
+int bpf_tc_cls_get_info(int fd, __u32 ifindex, __u32 parent_id,
+			const struct bpf_tc_cls_opts *opts,
+			struct bpf_tc_cls_info *info)
+{
+	return tc_cls_get_info(fd, ifindex, parent_id, opts, info);
 }
-- 
2.30.2

