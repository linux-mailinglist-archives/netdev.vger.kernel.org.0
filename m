Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBA039B2A7
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 08:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhFDGer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 02:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbhFDGeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 02:34:46 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A86CC06174A;
        Thu,  3 Jun 2021 23:32:45 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso5265920pjb.5;
        Thu, 03 Jun 2021 23:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NuSM2nw7OiKj22dYy2bWK9naZDCqqZDjU97+LGfZFPw=;
        b=ueuAgrQ18VVl2Qq5rgFaUbVpkEIKoKoQU0RXUJ6CrFoGpV4iE4a6V603wE+spP0gAM
         M2jAVttKvr8xllW1uaK6QHnHFMoSmzc6/T0ezy4+e1DSMDYDmflTpoLqZFbH8eTj/NCC
         1htQWPIGHl2mDLYSf6rpiLlZUhTXsGO3jJFiDnpZ0mwbGMkJVQbhrqmnNnv/RwVYIBHx
         fHqVLl2I4lN4OHTMrIzemHNgk2HF144BFGO/To4SEnGOrDzBTlwe0Y8PyhegmbswV61I
         FXDoFDKdYsRpuPzDDjMGQSVIOmFaYQMAuSD1LCtPq2LFh7xzsrPHbwEcGYA6BWaQqzsv
         2ryA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NuSM2nw7OiKj22dYy2bWK9naZDCqqZDjU97+LGfZFPw=;
        b=fT5P/DMtDZ+0qG20Rm4pKi9Q6yYXispaTra6WjzPRHv8pa2GPIyOIBRtlIWZTrpI1S
         qgWKc1kHSbHdSSLTmxhRPr1Rs103zUzJ6tiHPqsn1++hDgtZn41nmGWYPiz9NhsIFK6E
         3CE0RUkAtGfgn+Ipsw2qeSYG4Z/dtOtEeKPl1+DLukROnjdFoIL24vhDUe4uKxIFMzx+
         oh4dKUn5q1cKA0NHatOO2V6aQBBS3FI3webjcv1Am0FQ0lN8hNr7K7H/9m77UQg9RYlD
         45qYAnjpHk5d3SJyqGb6/nX1KJ03BmUbfeDp7iDJ/y1Gq+SeQ0yG2S/o9jvqvb4VZLrw
         qBWQ==
X-Gm-Message-State: AOAM53018naqclVV6hvpCEPNoUVPEbxejynbihCTdLIY0SSwYNQQNBW6
        fzJtGY6/aBCT+bKlzcwBlrRNEh60CL8=
X-Google-Smtp-Source: ABdhPJz9Y0Cw8JfLETsNeGJA/D2nVvZCGknAod11degO//jBupPGoSKF8HvW8j5Naic5UnP9XtB8Ng==
X-Received: by 2002:a17:902:ea0f:b029:10d:6029:780f with SMTP id s15-20020a170902ea0fb029010d6029780fmr2792672plg.66.1622788364507;
        Thu, 03 Jun 2021 23:32:44 -0700 (PDT)
Received: from localhost ([2402:3a80:11cb:b599:c759:2079:3ef5:1764])
        by smtp.gmail.com with ESMTPSA id ca6sm3964707pjb.21.2021.06.03.23.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 23:32:44 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 6/7] libbpf: add bpf_link based TC-BPF management API
Date:   Fri,  4 Jun 2021 12:01:15 +0530
Message-Id: <20210604063116.234316-7-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604063116.234316-1-memxor@gmail.com>
References: <20210604063116.234316-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds userspace TC-BPF management API based on bpf_link.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>.
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/bpf.c      |  8 +++++-
 tools/lib/bpf/bpf.h      |  8 +++++-
 tools/lib/bpf/libbpf.c   | 59 ++++++++++++++++++++++++++++++++++++++--
 tools/lib/bpf/libbpf.h   | 17 ++++++++++++
 tools/lib/bpf/libbpf.map |  1 +
 tools/lib/bpf/netlink.c  |  5 ++--
 tools/lib/bpf/netlink.h  |  8 ++++++
 7 files changed, 100 insertions(+), 6 deletions(-)
 create mode 100644 tools/lib/bpf/netlink.h

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 86dcac44f32f..bebccea9bfd7 100644
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
@@ -693,7 +694,12 @@ int bpf_link_create(int prog_fd, int target_fd,
 	attr.link_create.attach_type = attach_type;
 	attr.link_create.flags = OPTS_GET(opts, flags, 0);
 
-	if (iter_info_len) {
+	if (attach_type == BPF_TC) {
+		attr.link_create.tc.parent = OPTS_GET(opts, tc.parent, 0);
+		attr.link_create.tc.handle = OPTS_GET(opts, tc.handle, 0);
+		attr.link_create.tc.priority = OPTS_GET(opts, tc.priority, 0);
+		attr.link_create.tc.gen_flags = OPTS_GET(opts, tc.gen_flags, 0);
+	} else if (iter_info_len) {
 		attr.link_create.iter_info =
 			ptr_to_u64(OPTS_GET(opts, iter_info, (void *)0));
 		attr.link_create.iter_info_len = iter_info_len;
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
index 944c99d1ded3..5aa2e62b9fc2 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -373,5 +373,6 @@ LIBBPF_0.5.0 {
 		bpf_map__initial_value;
 		bpf_map_lookup_and_delete_elem_flags;
 		bpf_object__gen_loader;
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

