Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2653947A9
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 22:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhE1UCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 16:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhE1UCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 16:02:38 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8B4C06174A;
        Fri, 28 May 2021 13:01:03 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 27so3344010pgy.3;
        Fri, 28 May 2021 13:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BP/oVZsi8h1dbwVfNCDdeQd8r9+Vki9+KUAn75F4pkk=;
        b=SIsBmdnNfFq74qZpyZC8txLOehqBkeqSM4VImPX9Fb2PcZVNKasR9MQONjvN7k7PqZ
         ni5EGPoePswz56oK9QjhwxyPsLwbV6V3+9ABzhug4+0fQESqyLPgahppqQ7noi2dPVIl
         hLzqTeZjRXi2h8yqk+NmuDmqtOf6C6RzQIWpHLceN29420aunZz5Hn3oWotp6o3sEX4p
         FQeb48ir4hYZ9BfdwdXD+Y8VoEB0ggls2aQfwsuR94qWkWRIpxzqMP29LFzNByIsWVLw
         /Zoy7c0ECgDrIUS3cyhThYPwM9bntofi/PlwNnmEXz+XkWkRhNgg8h5QAJxouup/X8+r
         n8uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BP/oVZsi8h1dbwVfNCDdeQd8r9+Vki9+KUAn75F4pkk=;
        b=ClGDeHTwRXDP7fuqdN8PRNLVbBz4LsLa7386a7N0RRrYrYUL4j/Xm0RHbLHLKoB58d
         P0FgJjuce4VN4rwJKxPq8BnbbsV8sLkc7UWGTflKUIpSbHJPp0CmwYmjdoVr5d3nTQlM
         +kaLS/t8MhrPJbCO7pj8ajhTD/5VKwUpDSEoLENBFx230wXh8e0/HatBBRi52+wEtVXP
         3Ac9kWF2PBoQlgDqyIG+FhNl2YzH0+H1F+R+c+Gvs2kT1tMIxeTvi7VVChsip6RuLiZk
         brJAN/GUDdhdQgmUXtAlzD+BO07zZPaagg0ROp26ZFDpVmew7uAv/9uUoJMpEvM3viX2
         Rjhg==
X-Gm-Message-State: AOAM531b6ni0/0pZnG1nYodAEYnfvl3Buu3IKbf7JXtxycYKlBDrckqM
        U4z7Jig/d7yI8GeQp0J6o1bqIEuPlhE=
X-Google-Smtp-Source: ABdhPJw6d5/evMbmlyVx0Nh0XRzo6T44YEzbVw1OOiYRaqW0xiNnj2Cx/eFzzVzg0qHEac1L2Hmzcw==
X-Received: by 2002:a05:6a00:24d4:b029:2da:8e01:f07f with SMTP id d20-20020a056a0024d4b02902da8e01f07fmr5524659pfv.44.1622232062304;
        Fri, 28 May 2021 13:01:02 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id ft19sm5040987pjb.48.2021.05.28.13.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 13:01:02 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH RFC bpf-next 6/7] libbpf: add bpf_link based TC-BPF management API
Date:   Sat, 29 May 2021 01:29:45 +0530
Message-Id: <20210528195946.2375109-7-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528195946.2375109-1-memxor@gmail.com>
References: <20210528195946.2375109-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds userspace TC-BPF management API based on bpf_link.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/bpf.c      |  5 ++++
 tools/lib/bpf/bpf.h      |  8 +++++-
 tools/lib/bpf/libbpf.c   | 59 ++++++++++++++++++++++++++++++++++++++--
 tools/lib/bpf/libbpf.h   | 17 ++++++++++++
 tools/lib/bpf/libbpf.map |  1 +
 tools/lib/bpf/netlink.c  |  5 ++--
 tools/lib/bpf/netlink.h  |  8 ++++++
 7 files changed, 98 insertions(+), 5 deletions(-)
 create mode 100644 tools/lib/bpf/netlink.h

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 86dcac44f32f..ab2e2e9ccc5e 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -28,6 +28,7 @@
 #include <asm/unistd.h>
 #include <errno.h>
 #include <linux/bpf.h>
+#include <arpa/inet.h>
 #include "bpf.h"
 #include "libbpf.h"
 #include "libbpf_internal.h"
@@ -692,6 +693,10 @@ int bpf_link_create(int prog_fd, int target_fd,
 	attr.link_create.target_fd = target_fd;
 	attr.link_create.attach_type = attach_type;
 	attr.link_create.flags = OPTS_GET(opts, flags, 0);
+	attr.link_create.tc.parent = OPTS_GET(opts, tc.parent, 0);
+	attr.link_create.tc.handle = OPTS_GET(opts, tc.handle, 0);
+	attr.link_create.tc.priority = OPTS_GET(opts, tc.priority, 0);
+	attr.link_create.tc.gen_flags = OPTS_GET(opts, tc.gen_flags, 0);
 
 	if (iter_info_len) {
 		attr.link_create.iter_info =
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 4f758f8f50cd..f2178309e9ea 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -177,8 +177,14 @@ struct bpf_link_create_opts {
 	union bpf_iter_link_info *iter_info;
 	__u32 iter_info_len;
 	__u32 target_btf_id;
+	struct {
+		__u32 parent;
+		__u32 handle;
+		__u32 priority;
+		__u32 gen_flags;
+	} tc;
 };
-#define bpf_link_create_opts__last_field target_btf_id
+#define bpf_link_create_opts__last_field tc.gen_flags
 
 LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
 			       enum bpf_attach_type attach_type,
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1c4e20e75237..7809536980b1 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -55,6 +55,7 @@
 #include "libbpf_internal.h"
 #include "hashmap.h"
 #include "bpf_gen_internal.h"
+#include "netlink.h"
 
 #ifndef BPF_FS_MAGIC
 #define BPF_FS_MAGIC		0xcafe4a11
@@ -7185,7 +7186,7 @@ static int bpf_object__collect_relos(struct bpf_object *obj)
 
 	for (i = 0; i < obj->nr_programs; i++) {
 		struct bpf_program *p = &obj->programs[i];
-		
+
 		if (!p->nr_reloc)
 			continue;
 
@@ -10005,7 +10006,7 @@ struct bpf_link {
 int bpf_link__update_program(struct bpf_link *link, struct bpf_program *prog)
 {
 	int ret;
-	
+
 	ret = bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog), NULL);
 	return libbpf_err_errno(ret);
 }
@@ -10613,6 +10614,60 @@ struct bpf_link *bpf_program__attach_xdp(struct bpf_program *prog, int ifindex)
 	return bpf_program__attach_fd(prog, ifindex, 0, "xdp");
 }
 
+struct bpf_link *bpf_program__attach_tc(struct bpf_program *prog,
+					const struct bpf_tc_hook *hook,
+					const struct bpf_tc_link_opts *opts)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, lopts, 0);
+	char errmsg[STRERR_BUFSIZE];
+	int prog_fd, link_fd, ret;
+	struct bpf_link *link;
+	__u32 parent;
+
+	if (!hook || !OPTS_VALID(hook, bpf_tc_hook) ||
+	    !OPTS_VALID(opts, bpf_tc_link_opts))
+		return ERR_PTR(-EINVAL);
+
+	if (OPTS_GET(hook, ifindex, 0) <= 0 ||
+	    OPTS_GET(opts, priority, 0) > UINT16_MAX)
+		return ERR_PTR(-EINVAL);
+
+	parent = OPTS_GET(hook, parent, 0);
+
+	ret = tc_get_tcm_parent(OPTS_GET(hook, attach_point, 0),
+				&parent);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	lopts.tc.parent = parent;
+	lopts.tc.handle = OPTS_GET(opts, handle, 0);
+	lopts.tc.priority = OPTS_GET(opts, priority, 0);
+	lopts.tc.gen_flags = OPTS_GET(opts, gen_flags, 0);
+
+	prog_fd = bpf_program__fd(prog);
+	if (prog_fd < 0) {
+		pr_warn("prog '%s': can't attach before loaded\n", prog->name);
+		return ERR_PTR(-EINVAL);
+	}
+
+	link = calloc(1, sizeof(*link));
+	if (!link)
+		return ERR_PTR(-ENOMEM);
+	link->detach = &bpf_link__detach_fd;
+
+	link_fd = bpf_link_create(prog_fd, OPTS_GET(hook, ifindex, 0), BPF_TC, &lopts);
+	if (link_fd < 0) {
+		link_fd = -errno;
+		free(link);
+		pr_warn("prog '%s': failed to attach tc filter: %s\n",
+			prog->name, libbpf_strerror_r(link_fd, errmsg, sizeof(errmsg)));
+		return ERR_PTR(link_fd);
+	}
+	link->fd = link_fd;
+
+	return link;
+}
+
 struct bpf_link *bpf_program__attach_freplace(struct bpf_program *prog,
 					      int target_fd,
 					      const char *attach_func_name)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 6e61342ba56c..284a446c6513 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -282,6 +282,23 @@ LIBBPF_API struct bpf_link *
 bpf_program__attach_iter(struct bpf_program *prog,
 			 const struct bpf_iter_attach_opts *opts);
 
+/* TC bpf_link related API */
+struct bpf_tc_hook;
+
+struct bpf_tc_link_opts {
+	size_t sz;
+	__u32 handle;
+	__u32 priority;
+	__u32 gen_flags;
+	size_t :0;
+};
+#define bpf_tc_link_opts__last_field gen_flags
+
+LIBBPF_API struct bpf_link *
+bpf_program__attach_tc(struct bpf_program *prog,
+		       const struct bpf_tc_hook *hook,
+		       const struct bpf_tc_link_opts *opts);
+
 struct bpf_insn;
 
 /*
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index bbe99b1db1a9..ef570a840aca 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -373,5 +373,6 @@ LIBBPF_0.4.0 {
 
 LIBBPF_0.5.0 {
 	global:
+		bpf_program__attach_tc;
 		libbpf_set_strict_mode;
 } LIBBPF_0.4.0;
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index d743c8721aa7..b7ac36fc9c1a 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -17,6 +17,7 @@
 #include "libbpf.h"
 #include "libbpf_internal.h"
 #include "nlattr.h"
+#include "netlink.h"
 
 #ifndef SOL_NETLINK
 #define SOL_NETLINK 270
@@ -405,8 +406,8 @@ static int attach_point_to_config(struct bpf_tc_hook *hook,
 	}
 }
 
-static int tc_get_tcm_parent(enum bpf_tc_attach_point attach_point,
-			     __u32 *parent)
+int tc_get_tcm_parent(enum bpf_tc_attach_point attach_point,
+		      __u32 *parent)
 {
 	switch (attach_point) {
 	case BPF_TC_INGRESS:
diff --git a/tools/lib/bpf/netlink.h b/tools/lib/bpf/netlink.h
new file mode 100644
index 000000000000..c89133d56eb4
--- /dev/null
+++ b/tools/lib/bpf/netlink.h
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+#pragma once
+
+#include <linux/types.h>
+#include "libbpf.h"
+
+int tc_get_tcm_parent(enum bpf_tc_attach_point attach_point,
+		      __u32 *parent);
-- 
2.31.1

