Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866FC349174
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhCYMCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhCYMCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 08:02:34 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A21C06174A;
        Thu, 25 Mar 2021 05:02:34 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r17so1601012pgi.0;
        Thu, 25 Mar 2021 05:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NL4DiOKg00UDQaQxeDVdzlsM4CnwHYQ4poPpm4WQmLg=;
        b=hdaTm1dl1Z9gfZmGpJ0j5Yy2/E5R4loK5MiRH9GoQl3kyQMHqA2HtSAzIGm1c5A5Wl
         q9f5K7biYOXXtYcXiW3rzliG3zyUwuWO5ZsDC8A1sEoea1GnsI3iX6zblcj+JqMwBYCv
         ebOlFmEFy5YAuBK8yrInVv/EoUVIgUM46iqEcAHcKXsWCYmfuQy3fQNaFWFAxyn1lCMT
         m+XvnN03WCdTcqIXO1Yuyx6uT27R/DKc6sMQiGdy+WoK4Bi1aFW3Q+8fQvb/tSsxfQQw
         B3+PG8C5KjLg99/+QqjeaT/w4IsvZ3z+nOUIOHlrmZsq/mANUyRq3QzOAzcYrfq5VVkx
         xvOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NL4DiOKg00UDQaQxeDVdzlsM4CnwHYQ4poPpm4WQmLg=;
        b=Btle65Fub4ZxwkOkbUBgLGQqozEupbSnLoSosSF2J27CLrdoH69kWUw7WBiHVXkmAd
         k1UnkowS5zJHFGbyx9bINBbpCYxO/B7Kr6doB6njG2fARrhd4JtZGoiGQk/1SAgNiC7p
         QRdiES2prl45Up8Ij3th78hRPTyafrik5cmG5L/oLxR86X+2ene8gxNuyFtjoKF5ueMa
         5Lnuhz1Eq7RBjXMRZNAO0HNLoP800LELYwTM21QHS26mGuGvFzL3bGpuHpEyiUiyqM0E
         LuLnE6hzRISMGAgAZOE5BwlZBNYNyF24OTJV8cp2ZxhHalOENnMDx0xkYAFS8Tdr7SVG
         4U1A==
X-Gm-Message-State: AOAM530ZLn7gC5C23t4LZ3U0+b1gTblx/BmvakaSUDUI8glqzRZOqD5f
        rtoQvYr4eyvp01Ne/aXEm2tLjv6sEGr+UQ==
X-Google-Smtp-Source: ABdhPJyxKfmDHcC1e+UmEsp9XK3agpb2ofdq3+p29uHufxN+PA8aqHnTBlLn4DqiLtqtOAsoxFuxpw==
X-Received: by 2002:a65:5289:: with SMTP id y9mr6539883pgp.447.1616673754082;
        Thu, 25 Mar 2021 05:02:34 -0700 (PDT)
Received: from localhost ([112.79.237.176])
        by smtp.gmail.com with ESMTPSA id h19sm5876594pfc.172.2021.03.25.05.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 05:02:33 -0700 (PDT)
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
Subject: [PATCH bpf-next 4/5] libbpf: add high level TC-BPF API
Date:   Thu, 25 Mar 2021 17:30:02 +0530
Message-Id: <20210325120020.236504-5-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325120020.236504-1-memxor@gmail.com>
References: <20210325120020.236504-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A high level API is provided using the aforementioned routines internally,
and these return a bpf_link object to the user. These are limited to just
attach for now, and can be extended to change/replace if the use case
arises in the future. It is also possible to call bpf_link__disconnect
on the link and switch to managing the filter/action manually if the
need arises. In most cases, the higher level API should suffice.

Example:

	struct bpf_tc_cls_info info = {};
	struct bpf_object *obj;
	struct bpf_program *p;
	struct bpf_link *link;
	__u32 index;
	int fd, r;

	obj = bpf_object_open("foo.o");
	if (IS_ERR_OR_NULL(obj))
		return PTR_ERR(obj);

	p = bpf_object__find_program_by_title(obj, "classifier");
	if (IS_ERR_OR_NULL(p))
		return PTR_ERR(p);

	DECLARE_LIBBPF_OPTS(bpf_tc_cls_opts, opts, .handle = 1);
	link = bpf_program__attach_tc_cls_dev(p, if_nametoindex("lo"),
					      BPF_TC_CLSACT_INGRESS,
					      ETH_P_IP, &opts);
	if (IS_ERR_OR_NULL(link))
		return PTR_ERR(link);

	/* We want to take ownership of the filter, so we disconnect the
	 * link and detach it on our own
	 */
	bpf_link__disconnect(link);

	r = bpf_tc_cls_get_info_dev(bpf_program__fd(fd),
				    if_nametoindex("lo"),
				    BPF_TC_CLSACT_INGRESS,
				    ETH_P_IP, &opts, &info);
	if (r < 0)
		return r;

	/* We get the attach_id in the info struct, pass it to detach */
	bpf_tc_cls_detach_dev(&info.id);

	bpf_link__destroy(link);

Example:

	struct bpf_object *obj;
	struct bpf_program *p;
	struct bpf_link *link;
	__u32 index;
	int fd, r;

	obj = bpf_object_open("foo.o");
	if (IS_ERR_OR_NULL(obj))
		return PTR_ERR(obj);

	p = bpf_object__find_program_by_title(obj, "action");
	if (IS_ERR_OR_NULL(p))
		return PTR_ERR(p);

	/* A simple example that attaches a SCHED_ACT prog */
	link = bpf_program__attach_tc_act(p, NULL);
	if (IS_ERR_OR_NULL(link))
		return PTR_ERR(link);

	bpf_link__destroy(link);

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/libbpf.c   | 110 ++++++++++++++++++++++++++++++++++++++-
 tools/lib/bpf/libbpf.h   |  15 ++++++
 tools/lib/bpf/libbpf.map |   3 ++
 3 files changed, 127 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 058b643cbcb1..cc5c200a661d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -33,6 +33,7 @@
 #include <linux/filter.h>
 #include <linux/list.h>
 #include <linux/limits.h>
+#include <linux/rtnetlink.h>
 #include <linux/perf_event.h>
 #include <linux/ring_buffer.h>
 #include <linux/version.h>
@@ -6847,7 +6848,7 @@ static int bpf_object__collect_relos(struct bpf_object *obj)
 
 	for (i = 0; i < obj->nr_programs; i++) {
 		struct bpf_program *p = &obj->programs[i];
-		
+
 		if (!p->nr_reloc)
 			continue;
 
@@ -9443,6 +9444,10 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 struct bpf_link {
 	int (*detach)(struct bpf_link *link);
 	int (*destroy)(struct bpf_link *link);
+	union {
+		struct bpf_tc_cls_attach_id *tc_cls_id;
+		__u32 tc_act_index;
+	};
 	char *pin_path;		/* NULL, if not pinned */
 	int fd;			/* hook FD, -1 if not applicable */
 	bool disconnected;
@@ -10199,6 +10204,109 @@ struct bpf_link *bpf_map__attach_struct_ops(struct bpf_map *map)
 	return link;
 }
 
+static int bpf_link__detach_tc_cls(struct bpf_link *link)
+{
+	return bpf_tc_cls_detach_dev(link->tc_cls_id);
+}
+
+static int bpf_link__destroy_tc_cls(struct bpf_link *link)
+{
+	zfree(&link->tc_cls_id);
+	return 0;
+}
+
+struct bpf_link *bpf_program__attach_tc_cls_dev(struct bpf_program *prog,
+						__u32 ifindex, __u32 parent_id,
+						__u32 protocol,
+						const struct bpf_tc_cls_opts *opts)
+{
+	struct bpf_tc_cls_attach_id *id = NULL;
+	struct bpf_link *link = NULL;
+	char errmsg[STRERR_BUFSIZE];
+	int prog_fd, err;
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
+	link->detach = &bpf_link__detach_tc_cls;
+	link->destroy = &bpf_link__destroy_tc_cls;
+	link->fd = -1;
+
+	id = calloc(1, sizeof(*id));
+	if (!id) {
+		err = -ENOMEM;
+		goto end;
+	}
+
+	err = bpf_tc_cls_attach_dev(prog_fd, ifindex, parent_id, protocol, opts, id);
+	if (err < 0) {
+		pr_warn("prog '%s': failed to attach classifier: %s\n",
+			prog->name,
+			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+		goto end;
+	}
+
+	link->tc_cls_id = id;
+	return link;
+
+end:
+	free(id);
+	free(link);
+	return ERR_PTR(err);
+}
+
+struct bpf_link *bpf_program__attach_tc_cls_block(struct bpf_program *prog,
+						  __u32 block_index, __u32 protocol,
+						  const struct bpf_tc_cls_opts *opts)
+{
+	return bpf_program__attach_tc_cls_dev(prog, TCM_IFINDEX_MAGIC_BLOCK, block_index,
+					      protocol, opts);
+}
+
+static int bpf_link__detach_tc_act(struct bpf_link *link)
+{
+	return bpf_tc_act_detach(link->tc_act_index);
+}
+
+struct bpf_link *bpf_program__attach_tc_act(struct bpf_program *prog,
+					    const struct bpf_tc_act_opts *opts)
+{
+	struct bpf_link *link = NULL;
+	char errmsg[STRERR_BUFSIZE];
+	int prog_fd, err;
+
+	prog_fd = bpf_program__fd(prog);
+	if (prog_fd < 0) {
+		pr_warn("prog '%s': can't attach before loading\n", prog->name);
+		return ERR_PTR(-EINVAL);
+	}
+
+	link = calloc(1, sizeof(*link));
+	if (!link)
+		return ERR_PTR(-ENOMEM);
+	link->detach = &bpf_link__detach_tc_act;
+	link->fd = -1;
+
+	err = bpf_tc_act_attach(prog_fd, opts, &link->tc_act_index);
+	if (err < 0) {
+		pr_warn("prog '%s': failed to attach action: %s\n", prog->name,
+			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+		goto end;
+	}
+
+	return link;
+
+end:
+	free(link);
+	return ERR_PTR(err);
+}
+
 enum bpf_perf_event_ret
 bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
 			   void **copy_mem, size_t *copy_size,
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 63baef6045b1..e33720d0b672 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -268,6 +268,21 @@ LIBBPF_API struct bpf_link *
 bpf_program__attach_freplace(struct bpf_program *prog,
 			     int target_fd, const char *attach_func_name);
 
+struct bpf_tc_cls_opts;
+struct bpf_tc_act_opts;
+
+LIBBPF_API struct bpf_link *
+bpf_program__attach_tc_cls_dev(struct bpf_program *prog, __u32 ifindex,
+			       __u32 parent_id, __u32 protocol,
+			       const struct bpf_tc_cls_opts *opts);
+LIBBPF_API struct bpf_link *
+bpf_program__attach_tc_cls_block(struct bpf_program *prog, __u32 block_index,
+				 __u32 protocol,
+				 const struct bpf_tc_cls_opts *opts);
+LIBBPF_API struct bpf_link *
+bpf_program__attach_tc_act(struct bpf_program *prog,
+			   const struct bpf_tc_act_opts *opts);
+
 struct bpf_map;
 
 LIBBPF_API struct bpf_link *bpf_map__attach_struct_ops(struct bpf_map *map);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 72022b45a8b9..2e1390e4ebf0 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -373,4 +373,7 @@ LIBBPF_0.4.0 {
 		bpf_tc_cls_replace_dev;
 		bpf_tc_cls_get_info_dev;
 		bpf_tc_cls_get_info_block;
+		bpf_program__attach_tc_cls_dev;
+		bpf_program__attach_tc_cls_block;
+		bpf_program__attach_tc_act;
 } LIBBPF_0.3.0;
-- 
2.30.2

