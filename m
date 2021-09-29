Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5654541D04F
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347806AbhI3AB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347773AbhI3ABS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:01:18 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54280C06176C;
        Wed, 29 Sep 2021 16:59:37 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id lp15-20020a17090b4a8f00b0019f4059bd90so1832419pjb.3;
        Wed, 29 Sep 2021 16:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ifxOhfW5lYsfzC5Na1x7HEvoaDW+CN5gEDZf9GoLaHQ=;
        b=IDsMF/2+Y0Gc5DjIusdimLGodte03s4zzxtvIE17YkFplL8avtVBAGQvnNI77SNgkq
         788ID9tiRyKedDN0PEzosrCb4IHHqcp+yBr4qbpFmQzZ19Ne5g9CEbp2+AP1+NEH6/8Y
         LlD8YIwFWlpQgwszM0S8S70WoV2rUB9B9oOxYYNSHRrHCrxfZA1An0UQbZWoPwoDYPvI
         kBApr6kfQew31aAT0xDJOGe0UioRs6UEQqSOtUXRz9gyqzjHiFg7LowSuALicOITOPFS
         z9ECPZ0Efwkr/xgXae7pMHnnDz5ra1TAONA7CNvmjquDLLrPyG2/kqeOzPzoDYvOlRH6
         lcKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ifxOhfW5lYsfzC5Na1x7HEvoaDW+CN5gEDZf9GoLaHQ=;
        b=8Cv0ah/t+QRx0j5QnCkoTwxSqH7GLyrr6yhXAcXlnGdT2VuKVQy0V6PCnAT9Y5rQMM
         YhIRLimTWLfqQy0LLIEfg/CYEkUBXlD1SCAPJWd5KfeKWjHnOvIH25DC85la1zLYKs7r
         ey2y68DiCmdhisw5+XgCAszDYfpQey+IVKSBVmM0tdrk9vDeYLkCv74u+zf9G2r7rail
         09F850ZXJElV9qRhA0Kzzn7mE6+I1UBqNZVf7a/oWdD6EEE2618ekrLxRxkxthEACHF6
         eqoPlPWpE0zazq2B4hudSG3VzYl2NHBTTrJthPllHY4X66HtlL7y5KCvJDvvz/JSjBBc
         K10w==
X-Gm-Message-State: AOAM530ifgfST4JFj/3BBVRHEGSPGrN/GY0g2iL+RNwfaAzWgdQksVGu
        s/IAdvIYha5oBDo9oeox0w==
X-Google-Smtp-Source: ABdhPJxLr9tMEXC9jWmAc64f6FsJ+FDyvq+2jsXAkBPxVGyBC/CNCwKegIh7Ur4FSpd1i4RlRggGDA==
X-Received: by 2002:a17:902:8494:b0:13b:9365:6f12 with SMTP id c20-20020a170902849400b0013b93656f12mr1132742plo.19.1632959976872;
        Wed, 29 Sep 2021 16:59:36 -0700 (PDT)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mr18sm681907pjb.17.2021.09.29.16.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 16:59:36 -0700 (PDT)
From:   Joe Burton <jevburton.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Joe Burton <jevburton@google.com>
Subject: [RFC PATCH v2 08/13] libbpf: Support BPF_TRACE_MAP
Date:   Wed, 29 Sep 2021 23:59:05 +0000
Message-Id: <20210929235910.1765396-9-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

Programs may be now loaded with libbpf. Sections with the prefix
"map_trace/" will use the new attach type.

Signed-off-by: Joe Burton <jevburton@google.com>
---
 tools/include/uapi/linux/bpf.h |  22 ++++++
 tools/lib/bpf/bpf.c            |  13 ++--
 tools/lib/bpf/bpf.h            |   4 +-
 tools/lib/bpf/libbpf.c         | 118 +++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h         |  11 +++
 tools/lib/bpf/libbpf.map       |   1 +
 6 files changed, 163 insertions(+), 6 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 6fc59d61937a..3d5d3dafc066 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -93,6 +93,20 @@ union bpf_iter_link_info {
 	} map;
 };
 
+enum bpf_map_trace_type {
+	BPF_MAP_TRACE_UPDATE_ELEM = 0,
+	BPF_MAP_TRACE_DELETE_ELEM = 1,
+
+	MAX_BPF_MAP_TRACE_TYPE,
+};
+
+struct bpf_map_trace_link_info {
+	__u32   map_fd;
+	enum bpf_map_trace_type trace_type;
+};
+
+#define BPF_MAP_TRACE_FUNC(trace_type) "bpf_map_trace__" #trace_type
+
 /* BPF syscall commands, see bpf(2) man-page for more details. */
 /**
  * DOC: eBPF Syscall Preamble
@@ -994,6 +1008,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT,
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
+	BPF_TRACE_MAP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1008,6 +1023,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
 	BPF_LINK_TYPE_PERF_EVENT = 7,
+	BPF_LINK_TYPE_MAP_TRACE = 8,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1455,6 +1471,12 @@ union bpf_attr {
 				 */
 				__u64		bpf_cookie;
 			} perf_event;
+			struct {
+				/* extra bpf_map_trace_link_info */
+				__aligned_u64	map_trace_info;
+				/* map_trace_info length */
+				__u32		map_trace_info_len;
+			};
 		};
 	} link_create;
 
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 2401fad090c5..e18ddd362052 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -674,7 +674,7 @@ int bpf_link_create(int prog_fd, int target_fd,
 		    enum bpf_attach_type attach_type,
 		    const struct bpf_link_create_opts *opts)
 {
-	__u32 target_btf_id, iter_info_len;
+	__u32 target_btf_id, iter_info_len, map_trace_info_len;
 	union bpf_attr attr;
 	int fd;
 
@@ -682,13 +682,12 @@ int bpf_link_create(int prog_fd, int target_fd,
 		return libbpf_err(-EINVAL);
 
 	iter_info_len = OPTS_GET(opts, iter_info_len, 0);
+	map_trace_info_len = OPTS_GET(opts, map_trace_info_len, 0);
 	target_btf_id = OPTS_GET(opts, target_btf_id, 0);
 
 	/* validate we don't have unexpected combinations of non-zero fields */
-	if (iter_info_len || target_btf_id) {
-		if (iter_info_len && target_btf_id)
-			return libbpf_err(-EINVAL);
-		if (!OPTS_ZEROED(opts, target_btf_id))
+	if (iter_info_len || map_trace_info_len || target_btf_id) {
+		if ((iter_info_len || map_trace_info_len) && target_btf_id)
 			return libbpf_err(-EINVAL);
 	}
 
@@ -713,6 +712,10 @@ int bpf_link_create(int prog_fd, int target_fd,
 		if (!OPTS_ZEROED(opts, perf_event))
 			return libbpf_err(-EINVAL);
 		break;
+	case BPF_TRACE_MAP:
+		attr.link_create.map_trace_info = ptr_to_u64(OPTS_GET(opts, map_trace_info, (void *)0));
+		attr.link_create.map_trace_info_len = map_trace_info_len;
+		break;
 	default:
 		if (!OPTS_ZEROED(opts, flags))
 			return libbpf_err(-EINVAL);
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 6fffb3cdf39b..deb276ad489f 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -183,8 +183,10 @@ struct bpf_link_create_opts {
 		} perf_event;
 	};
 	size_t :0;
+	struct bpf_map_trace_link_info *map_trace_info;
+	__u32 map_trace_info_len;
 };
-#define bpf_link_create_opts__last_field perf_event
+#define bpf_link_create_opts__last_field map_trace_info_len
 
 LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
 			       enum bpf_attach_type attach_type,
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1c859b32968d..a82126c0b969 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7987,6 +7987,7 @@ static struct bpf_link *attach_raw_tp(const struct bpf_program *prog, long cooki
 static struct bpf_link *attach_trace(const struct bpf_program *prog, long cookie);
 static struct bpf_link *attach_lsm(const struct bpf_program *prog, long cookie);
 static struct bpf_link *attach_iter(const struct bpf_program *prog, long cookie);
+static struct bpf_link *attach_map_trace(const struct bpf_program *prog, long cookie);
 
 static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("socket",		SOCKET_FILTER, 0, SEC_NONE | SEC_SLOPPY_PFX),
@@ -8014,6 +8015,7 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("lsm/",			LSM, BPF_LSM_MAC, SEC_ATTACH_BTF, attach_lsm),
 	SEC_DEF("lsm.s/",		LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
 	SEC_DEF("iter/",		TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
+	SEC_DEF("map_trace/",		TRACING, BPF_TRACE_MAP, SEC_ATTACH_BTF, attach_map_trace),
 	SEC_DEF("syscall",		SYSCALL, 0, SEC_SLEEPABLE),
 	SEC_DEF("xdp_devmap/",		XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
 	SEC_DEF("xdp_cpumap/",		XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
@@ -8311,6 +8313,7 @@ static int bpf_object__collect_st_ops_relos(struct bpf_object *obj,
 #define BTF_TRACE_PREFIX "btf_trace_"
 #define BTF_LSM_PREFIX "bpf_lsm_"
 #define BTF_ITER_PREFIX "bpf_iter_"
+#define BTF_MAP_TRACE_PREFIX "bpf_map_trace__BPF_MAP_TRACE_"
 #define BTF_MAX_NAME_SIZE 128
 
 void btf_get_kernel_prefix_kind(enum bpf_attach_type attach_type,
@@ -8329,6 +8332,10 @@ void btf_get_kernel_prefix_kind(enum bpf_attach_type attach_type,
 		*prefix = BTF_ITER_PREFIX;
 		*kind = BTF_KIND_FUNC;
 		break;
+	case BPF_TRACE_MAP:
+		*prefix = BTF_MAP_TRACE_PREFIX;
+		*kind = BTF_KIND_FUNC;
+		break;
 	default:
 		*prefix = "";
 		*kind = BTF_KIND_FUNC;
@@ -8464,6 +8471,15 @@ static int libbpf_find_attach_btf_id(struct bpf_program *prog, const char *attac
 	__u32 attach_prog_fd = prog->attach_prog_fd;
 	int err = 0;
 
+	if (attach_type == BPF_TRACE_MAP) {
+		while (*attach_name && *attach_name != '/')
+			++attach_name;
+		if (!*attach_name || !*(++attach_name)) {
+			pr_warn("failed to parse trace type from ELF section name '%s'\n", prog->sec_name);
+			return -EINVAL;
+		}
+	}
+
 	/* BPF program's BTF ID */
 	if (attach_prog_fd) {
 		err = libbpf_find_prog_btf_id(attach_name, attach_prog_fd);
@@ -9951,6 +9967,108 @@ static struct bpf_link *attach_iter(const struct bpf_program *prog, long cookie)
 	return bpf_program__attach_iter(prog, NULL);
 }
 
+struct bpf_link *
+bpf_program__attach_map_trace(const struct bpf_program *prog,
+			      const struct bpf_map_trace_attach_opts *opts)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, link_create_opts);
+	char errmsg[STRERR_BUFSIZE];
+	struct bpf_link *link;
+	int prog_fd, link_fd;
+	__u32 target_fd = 0;
+
+	if (!OPTS_VALID(opts, bpf_map_trace_attach_opts))
+		return ERR_PTR(-EINVAL);
+
+	link_create_opts.map_trace_info = OPTS_GET(opts, link_info, (void *)0);
+	link_create_opts.map_trace_info_len = OPTS_GET(opts, link_info_len, 0);
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
+	link_fd = bpf_link_create(prog_fd, target_fd, BPF_TRACE_MAP,
+				  &link_create_opts);
+	if (link_fd < 0) {
+		link_fd = -errno;
+		free(link);
+		pr_warn("prog '%s': failed to attach to map: %s\n",
+			prog->name, libbpf_strerror_r(link_fd, errmsg, sizeof(errmsg)));
+		return ERR_PTR(link_fd);
+	}
+	link->fd = link_fd;
+	return link;
+}
+
+static struct bpf_link *attach_map_trace(const struct bpf_program *prog,
+					 long cookie)
+{
+	struct bpf_map_trace_attach_opts map_trace_opts;
+	struct bpf_map_trace_link_info link_info;
+	enum bpf_map_trace_type trace_type;
+	const char *trace_name = prog->sec_name;
+	const char *map_name = prog->sec_name;
+	char *map_name_cstr;
+	size_t map_name_len;
+	struct bpf_map *map;
+	int slash_seen = 0;
+
+	/*
+	 * Map tracing sections are named like this:
+	 *   map_trace/map_name/trace_type
+	 * Assign trace_name and map_name to the beginning of their names.
+	 */
+	while (*map_name && *trace_name && slash_seen < 2) {
+		if (slash_seen < 1)
+			map_name++;
+		if (slash_seen < 2)
+			trace_name++;
+		if (*trace_name == '/')
+			slash_seen++;
+	}
+	if (*map_name)
+		++map_name;
+	if (*trace_name)
+		++trace_name;
+	if (!*map_name || !*trace_name || slash_seen < 2)
+		return ERR_PTR(-EINVAL);
+
+	if (!strcmp(trace_name, "UPDATE_ELEM"))
+		trace_type = BPF_MAP_TRACE_UPDATE_ELEM;
+	else if (!strcmp(trace_name, "DELETE_ELEM"))
+		trace_type = BPF_MAP_TRACE_DELETE_ELEM;
+	else
+		return ERR_PTR(-EINVAL);
+
+	map_name_len = (trace_name - map_name) - 1;
+	map_name_cstr = malloc(map_name_len + 1);
+	if (!map_name_cstr)
+		return ERR_PTR(-ENOMEM);
+	map_name_cstr[map_name_len] = 0;
+	strncpy(map_name_cstr, map_name, map_name_len);
+	pr_warn("map name cstr: %s\n", map_name_cstr);
+	map = bpf_object__find_map_by_name(prog->obj, map_name_cstr);
+	free(map_name_cstr);
+	if (!map)
+		return ERR_PTR(-EINVAL);
+
+	memset(&link_info, 0, sizeof(link_info));
+	link_info.map_fd = bpf_map__fd(map);
+	link_info.trace_type = trace_type;
+	memset(&map_trace_opts, 0, sizeof(map_trace_opts));
+	map_trace_opts.sz = sizeof(map_trace_opts);
+	map_trace_opts.link_info = &link_info;
+	map_trace_opts.link_info_len = sizeof(link_info);
+	return bpf_program__attach_map_trace(prog, &map_trace_opts);
+}
+
 struct bpf_link *bpf_program__attach(const struct bpf_program *prog)
 {
 	if (!prog->sec_def || !prog->sec_def->attach_fn)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index e35490c54eb3..418b65918639 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -358,6 +358,17 @@ LIBBPF_API struct bpf_link *
 bpf_program__attach_iter(const struct bpf_program *prog,
 			 const struct bpf_iter_attach_opts *opts);
 
+struct bpf_map_trace_attach_opts {
+	size_t sz; /* size of this struct for forward/backward compatibility */
+	struct bpf_map_trace_link_info *link_info;
+	__u32 link_info_len;
+};
+#define bpf_map_trace_attach_opts__last_field link_info_len
+
+LIBBPF_API struct bpf_link *
+bpf_program__attach_map_trace(const struct bpf_program *prog,
+			      const struct bpf_map_trace_attach_opts *opts);
+
 struct bpf_insn;
 
 /*
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 9e649cf9e771..84f728b6bd4b 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -384,6 +384,7 @@ LIBBPF_0.5.0 {
 		btf__load_module_btf;
 		btf__load_vmlinux_btf;
 		btf_dump__dump_type_data;
+		bpf_program__attach_map_trace;
 		libbpf_set_strict_mode;
 } LIBBPF_0.4.0;
 
-- 
2.33.0.685.g46640cef36-goog

