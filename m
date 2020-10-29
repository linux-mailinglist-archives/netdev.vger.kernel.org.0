Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDE229EF60
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 16:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgJ2PMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 11:12:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25679 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728141AbgJ2PMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 11:12:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603984347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=syjyKdKip0QBjAPuUGeulpKPY5woLitoOo5uSEyqW5Q=;
        b=OwK1zLlUzAc3GzNNhpdGUYeEwP3qlB9A2oZ8dgOYZZQVcoUZnEitHZvIDEJLtWXwP06QGf
        yNXIImMH8FHjoRjEKTYHW4M4ntwtQAwCMLoeDR/0PFJcCdXG/VVgJhqrcIHud1Wre9OLFv
        yEXD2hZ16NCIYHiyMbLigLgbIrzcN4M=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-cpu8sYfmMbaDcdTz8lI5Nw-1; Thu, 29 Oct 2020 11:12:25 -0400
X-MC-Unique: cpu8sYfmMbaDcdTz8lI5Nw-1
Received: by mail-pf1-f199.google.com with SMTP id e7so2406664pfh.14
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 08:12:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=syjyKdKip0QBjAPuUGeulpKPY5woLitoOo5uSEyqW5Q=;
        b=Jl/apBhrqA3nNmwIcYADM66yQJKtmGNgjmY96cBEB/qB12gdSIFRnPWimRc6bvlOqG
         T0ctHOqD8Ck+wC41XyWnfbGhmNbZDr4cpvQ78SaP5yjt3bKIbr0Oevy/ZH3I2pQKj7mP
         gnnIiALF0HFTm+KN2Cqp2SIeocrvVOlC8lDAlVH7fEcfwuRzWqj9Pxcyt4IsVE0/4Xtb
         17B26TUucQT+NWYKhPmTjnnD8Te61rDCL9yWYJxlm2A8frspziPIPq0Magl0FtF6gPm2
         D0tc+SBtAtu1MAybK+os97KZuWZM29n8FPDMUyFe9MALbiKZWOfNul4pADIlS/88yg6i
         ueaw==
X-Gm-Message-State: AOAM531Hq1jZJAuTg6RU5E+w83nfzNLVA838jeNigXr9WeIkFsLt+DV2
        meKX+OszRULL4CEE11n5KMkvPOG+QuQxpg8h3DEl53YZbNCxH5nClr7VXjjLNyTqYqRi61XovvI
        T8UCtZL46Z5AbFZg=
X-Received: by 2002:a17:902:8e89:b029:d5:fefd:9637 with SMTP id bg9-20020a1709028e89b02900d5fefd9637mr4241325plb.39.1603984343859;
        Thu, 29 Oct 2020 08:12:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGjdysDHM7hL9tHXC0xTIaIn4fYB0RA9juoCCM6XRZx4faYrZI2McEU3+5p6Ip6zcTRMfi6w==
X-Received: by 2002:a17:902:8e89:b029:d5:fefd:9637 with SMTP id bg9-20020a1709028e89b02900d5fefd9637mr4241296plb.39.1603984343529;
        Thu, 29 Oct 2020 08:12:23 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 3sm3305435pfv.92.2020.10.29.08.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 08:12:23 -0700 (PDT)
From:   Hangbin Liu <haliu@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <haliu@redhat.com>
Subject: [PATCHv3 iproute2-next 3/5] lib: add libbpf support
Date:   Thu, 29 Oct 2020 23:11:44 +0800
Message-Id: <20201029151146.3810859-4-haliu@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201029151146.3810859-1-haliu@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch converts iproute2 to use libbpf for loading and attaching
BPF programs when it is available, which is started by Toke's
implementation[1]. With libbpf iproute2 could correctly process BTF
information and support the new-style BTF-defined maps, while keeping
compatibility with the old internal map definition syntax.

The old iproute2 bpf code is kept and will be used if no suitable libbpf
is available. When using libbpf, wrapper code in bpf_legacy.c ensures that
iproute2 will still understand the old map definition format, including
populating map-in-map and tail call maps before load.

In bpf_libbpf.c, we init iproute2 ctx and elf info first to check the
legacy bytes. When handling the legacy maps, for map-in-maps, we create
them manually and re-use the fd as they are associated with id/inner_id.
For pin maps, we only set the pin path and let libbp load to handle it.
For tail calls, we find it first and update the element after prog load.

Other maps/progs will be loaded by libbpf directly.

[1] https://lore.kernel.org/bpf/20190820114706.18546-1-toke@redhat.com/

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Hangbin Liu <haliu@redhat.com>

---
v3:
Add a new function get_bpf_program__section_name() to choose whether
use bpf_program__title() or not.

v2:
Remove self defined IS_ERR_OR_NULL and use libbpf_get_error() instead.
Add ipvrf with libbpf support.
---
 include/bpf_util.h |  11 ++
 ip/ipvrf.c         |  15 ++
 lib/Makefile       |   4 +
 lib/bpf_legacy.c   | 178 +++++++++++++++++++++++
 lib/bpf_libbpf.c   | 341 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 549 insertions(+)
 create mode 100644 lib/bpf_libbpf.c

diff --git a/include/bpf_util.h b/include/bpf_util.h
index 72d3a32c..e200c107 100644
--- a/include/bpf_util.h
+++ b/include/bpf_util.h
@@ -300,4 +300,15 @@ static inline int bpf_recv_map_fds(const char *path, int *fds,
 	return -1;
 }
 #endif /* HAVE_ELF */
+
+#ifdef HAVE_LIBBPF
+int iproute2_bpf_elf_ctx_init(struct bpf_cfg_in *cfg);
+int iproute2_bpf_fetch_ancillary(void);
+int iproute2_get_root_path(char *root_path, size_t len);
+bool iproute2_is_pin_map(const char *libbpf_map_name, char *pathname);
+bool iproute2_is_map_in_map(const char *libbpf_map_name, struct bpf_elf_map *imap,
+			    struct bpf_elf_map *omap, char *omap_name);
+int iproute2_find_map_name_by_id(unsigned int map_id, char *name);
+int iproute2_load_libbpf(struct bpf_cfg_in *cfg);
+#endif /* HAVE_LIBBPF */
 #endif /* __BPF_UTIL__ */
diff --git a/ip/ipvrf.c b/ip/ipvrf.c
index 33150ac2..afaf1de7 100644
--- a/ip/ipvrf.c
+++ b/ip/ipvrf.c
@@ -28,8 +28,14 @@
 #include "rt_names.h"
 #include "utils.h"
 #include "ip_common.h"
+
 #include "bpf_util.h"
 
+#ifdef HAVE_LIBBPF
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#endif
+
 #define CGRP_PROC_FILE  "/cgroup.procs"
 
 static struct link_filter vrf_filter;
@@ -256,8 +262,13 @@ static int prog_load(int idx)
 		BPF_EXIT_INSN(),
 	};
 
+#ifdef HAVE_LIBBPF
+	return bpf_load_program(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
+				"GPL", 0, bpf_log_buf, sizeof(bpf_log_buf));
+#else
 	return bpf_prog_load_buf(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
 			         "GPL", bpf_log_buf, sizeof(bpf_log_buf));
+#endif
 }
 
 static int vrf_configure_cgroup(const char *path, int ifindex)
@@ -288,7 +299,11 @@ static int vrf_configure_cgroup(const char *path, int ifindex)
 		goto out;
 	}
 
+#ifdef HAVE_LIBBPF
+	if (bpf_prog_attach(prog_fd, cg_fd, BPF_CGROUP_INET_SOCK_CREATE, 0)) {
+#else
 	if (bpf_prog_attach_fd(prog_fd, cg_fd, BPF_CGROUP_INET_SOCK_CREATE)) {
+#endif
 		fprintf(stderr, "Failed to attach prog to cgroup: '%s'\n",
 			strerror(errno));
 		goto out;
diff --git a/lib/Makefile b/lib/Makefile
index a326fb9f..82d6e465 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -7,6 +7,10 @@ UTILOBJ = utils.o rt_names.o ll_map.o ll_types.o ll_proto.o ll_addr.o \
 	inet_proto.o namespace.o json_writer.o json_print.o \
 	names.o color.o bpf_legacy.o exec.o fs.o cg_map.o
 
+ifeq ($(HAVE_LIBBPF),y)
+UTILOBJ += bpf_libbpf.o
+endif
+
 NLOBJ=libgenl.o libnetlink.o
 
 all: libnetlink.a libutil.a
diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index 2e6e0602..c5ff3e32 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -940,6 +940,9 @@ static int bpf_do_parse(struct bpf_cfg_in *cfg, const bool *opt_tbl)
 static int bpf_do_load(struct bpf_cfg_in *cfg)
 {
 	if (cfg->mode == EBPF_OBJECT) {
+#ifdef HAVE_LIBBPF
+		return iproute2_load_libbpf(cfg);
+#endif
 		cfg->prog_fd = bpf_obj_open(cfg->object, cfg->type,
 					    cfg->section, cfg->ifindex,
 					    cfg->verbose);
@@ -3165,3 +3168,178 @@ int bpf_recv_map_fds(const char *path, int *fds, struct bpf_map_aux *aux,
 	return ret;
 }
 #endif /* HAVE_ELF */
+
+#ifdef HAVE_LIBBPF
+/* The following functions are wrapper functions for libbpf code to be
+ * compatible with the legacy format. So all the functions have prefix
+ * with iproute2_
+ */
+int iproute2_bpf_elf_ctx_init(struct bpf_cfg_in *cfg)
+{
+	struct bpf_elf_ctx *ctx = &__ctx;
+
+	return bpf_elf_ctx_init(ctx, cfg->object, cfg->type, cfg->ifindex, cfg->verbose);
+}
+
+int iproute2_bpf_fetch_ancillary(void)
+{
+	struct bpf_elf_ctx *ctx = &__ctx;
+	struct bpf_elf_sec_data data;
+	int i, ret = 0;
+
+	for (i = 1; i < ctx->elf_hdr.e_shnum; i++) {
+		ret = bpf_fill_section_data(ctx, i, &data);
+		if (ret < 0)
+			continue;
+
+		if (data.sec_hdr.sh_type == SHT_PROGBITS &&
+		    !strcmp(data.sec_name, ELF_SECTION_MAPS))
+			ret = bpf_fetch_maps_begin(ctx, i, &data);
+		else if (data.sec_hdr.sh_type == SHT_SYMTAB &&
+			 !strcmp(data.sec_name, ".symtab"))
+			ret = bpf_fetch_symtab(ctx, i, &data);
+		else if (data.sec_hdr.sh_type == SHT_STRTAB &&
+			 !strcmp(data.sec_name, ".strtab"))
+			ret = bpf_fetch_strtab(ctx, i, &data);
+		if (ret < 0) {
+			fprintf(stderr, "Error parsing section %d! Perhaps check with readelf -a?\n",
+				i);
+			return ret;
+		}
+	}
+
+	if (bpf_has_map_data(ctx)) {
+		ret = bpf_fetch_maps_end(ctx);
+		if (ret < 0) {
+			fprintf(stderr, "Error fixing up map structure, incompatible struct bpf_elf_map used?\n");
+			return ret;
+		}
+	}
+
+	return ret;
+}
+
+int iproute2_get_root_path(char *root_path, size_t len)
+{
+	struct bpf_elf_ctx *ctx = &__ctx;
+	int ret = 0;
+
+	snprintf(root_path, len, "%s/%s",
+		 bpf_get_work_dir(ctx->type), BPF_DIR_GLOBALS);
+
+	ret = mkdir(root_path, S_IRWXU);
+	if (ret && errno != EEXIST) {
+		fprintf(stderr, "mkdir %s failed: %s\n", root_path, strerror(errno));
+		return ret;
+	}
+
+	return 0;
+}
+
+bool iproute2_is_pin_map(const char *libbpf_map_name, char *pathname)
+{
+	struct bpf_elf_ctx *ctx = &__ctx;
+	const char *map_name, *tmp;
+	unsigned int pinning;
+	int i, ret = 0;
+
+	for (i = 0; i < ctx->map_num; i++) {
+		if (ctx->maps[i].pinning == PIN_OBJECT_NS &&
+		    ctx->noafalg) {
+			fprintf(stderr, "Missing kernel AF_ALG support for PIN_OBJECT_NS!\n");
+			return false;
+		}
+
+		map_name = bpf_map_fetch_name(ctx, i);
+		if (!map_name) {
+			return false;
+		}
+
+		if (strcmp(libbpf_map_name, map_name))
+			continue;
+
+		pinning = ctx->maps[i].pinning;
+
+		if (bpf_no_pinning(ctx, pinning) || !bpf_get_work_dir(ctx->type))
+			return false;
+
+		if (pinning == PIN_OBJECT_NS)
+			ret = bpf_make_obj_path(ctx);
+		else if ((tmp = bpf_custom_pinning(ctx, pinning)))
+			ret = bpf_make_custom_path(ctx, tmp);
+		if (ret < 0)
+			return false;
+
+		bpf_make_pathname(pathname, PATH_MAX, map_name, ctx, pinning);
+
+		return true;
+	}
+
+	return false;
+}
+
+bool iproute2_is_map_in_map(const char *libbpf_map_name, struct bpf_elf_map *imap,
+			    struct bpf_elf_map *omap, char *omap_name)
+{
+	struct bpf_elf_ctx *ctx = &__ctx;
+	const char *inner_map_name, *outer_map_name;
+	int i, j;
+
+	for (i = 0; i < ctx->map_num; i++) {
+		inner_map_name = bpf_map_fetch_name(ctx, i);
+		if (!inner_map_name) {
+			return false;
+		}
+
+		if (strcmp(libbpf_map_name, inner_map_name))
+			continue;
+
+		if (!ctx->maps[i].id ||
+		    ctx->maps[i].inner_id ||
+		    ctx->maps[i].inner_idx == -1)
+			continue;
+
+		*imap = ctx->maps[i];
+
+		for (j = 0; j < ctx->map_num; j++) {
+			if (!bpf_is_map_in_map_type(&ctx->maps[j]))
+				continue;
+			if (ctx->maps[j].inner_id != ctx->maps[i].id)
+				continue;
+
+			*omap = ctx->maps[j];
+			outer_map_name = bpf_map_fetch_name(ctx, j);
+			memcpy(omap_name, outer_map_name, strlen(outer_map_name) + 1);
+
+			return true;
+		}
+	}
+
+	return false;
+}
+
+int iproute2_find_map_name_by_id(unsigned int map_id, char *name)
+{
+	struct bpf_elf_ctx *ctx = &__ctx;
+	const char *map_name;
+	int i, idx = -1;
+
+	for (i = 0; i < ctx->map_num; i++) {
+		if (ctx->maps[i].id == map_id &&
+		    ctx->maps[i].type == BPF_MAP_TYPE_PROG_ARRAY) {
+			idx = i;
+			break;
+		}
+	}
+
+	if (idx < 0)
+		return -1;
+
+	map_name = bpf_map_fetch_name(ctx, idx);
+	if (!map_name)
+		return -1;
+
+	memcpy(name, map_name, strlen(map_name) + 1);
+	return 0;
+}
+#endif /* HAVE_LIBBPF */
diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
new file mode 100644
index 00000000..4fe0bc4b
--- /dev/null
+++ b/lib/bpf_libbpf.c
@@ -0,0 +1,341 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <errno.h>
+#include <fcntl.h>
+
+#include <libelf.h>
+#include <gelf.h>
+
+#include <bpf/libbpf.h>
+#include <bpf/bpf.h>
+
+#include "bpf_util.h"
+
+static int verbose_print(enum libbpf_print_level level, const char *format, va_list args)
+{
+	return vfprintf(stderr, format, args);
+}
+
+static int silent_print(enum libbpf_print_level level, const char *format, va_list args)
+{
+	if (level > LIBBPF_WARN)
+		return 0;
+
+	/* Skip warning from bpf_object__init_user_maps() for legacy maps */
+	if (strstr(format, "has unrecognized, non-zero options"))
+		return 0;
+
+	return vfprintf(stderr, format, args);
+}
+
+static const char *get_bpf_program__section_name(const struct bpf_program *prog)
+{
+#ifdef HAVE_LIBBPF_SECTION_NAME
+	return bpf_program__section_name(prog);
+#else
+	return bpf_program__title(prog, false);
+#endif
+}
+
+static int create_map(const char *name, struct bpf_elf_map *map,
+		      __u32 ifindex, int inner_fd)
+{
+	struct bpf_create_map_attr map_attr = {};
+
+	map_attr.name = name;
+	map_attr.map_type = map->type;
+	map_attr.map_flags = map->flags;
+	map_attr.key_size = map->size_key;
+	map_attr.value_size = map->size_value;
+	map_attr.max_entries = map->max_elem;
+	map_attr.map_ifindex = ifindex;
+	map_attr.inner_map_fd = inner_fd;
+
+	return bpf_create_map_xattr(&map_attr);
+}
+
+static int create_map_in_map(struct bpf_object *obj, struct bpf_map *map,
+			     struct bpf_elf_map *elf_map, int inner_fd,
+			     bool *reuse_pin_map)
+{
+	char pathname[PATH_MAX];
+	const char *map_name;
+	bool pin_map = false;
+	int map_fd, ret = 0;
+
+	map_name = bpf_map__name(map);
+
+	if (iproute2_is_pin_map(map_name, pathname)) {
+		pin_map = true;
+
+		/* Check if there already has a pinned map */
+		map_fd = bpf_obj_get(pathname);
+		if (map_fd > 0) {
+			if (reuse_pin_map)
+				*reuse_pin_map = true;
+			close(map_fd);
+			return bpf_map__set_pin_path(map, pathname);
+		}
+	}
+
+	map_fd = create_map(map_name, elf_map, bpf_map__ifindex(map), inner_fd);
+	if (map_fd < 0) {
+		fprintf(stderr, "create map %s failed\n", map_name);
+		return map_fd;
+	}
+
+	ret = bpf_map__reuse_fd(map, map_fd);
+	if (ret < 0) {
+		fprintf(stderr, "map %s reuse fd failed\n", map_name);
+		goto err_out;
+	}
+
+	if (pin_map) {
+		ret = bpf_map__set_pin_path(map, pathname);
+		if (ret < 0)
+			goto err_out;
+	}
+
+	return 0;
+err_out:
+	close(map_fd);
+	return ret;
+}
+
+static int
+handle_legacy_map_in_map(struct bpf_object *obj, struct bpf_map *inner_map,
+			 const char *inner_map_name)
+{
+	int inner_fd, outer_fd, inner_idx, ret = 0;
+	struct bpf_elf_map imap, omap;
+	struct bpf_map *outer_map;
+	/* What's the size limit of map name? */
+	char outer_map_name[128];
+	bool reuse_pin_map = false;
+
+	/* Deal with map-in-map */
+	if (iproute2_is_map_in_map(inner_map_name, &imap, &omap, outer_map_name)) {
+		ret = create_map_in_map(obj, inner_map, &imap, -1, NULL);
+		if (ret < 0)
+			return ret;
+
+		inner_fd = bpf_map__fd(inner_map);
+		outer_map = bpf_object__find_map_by_name(obj, outer_map_name);
+		ret = create_map_in_map(obj, outer_map, &omap, inner_fd, &reuse_pin_map);
+		if (ret < 0)
+			return ret;
+
+		if (!reuse_pin_map) {
+			inner_idx = imap.inner_idx;
+			outer_fd = bpf_map__fd(outer_map);
+			ret = bpf_map_update_elem(outer_fd, &inner_idx, &inner_fd, 0);
+			if (ret < 0)
+				fprintf(stderr, "Cannot update inner_idx into outer_map\n");
+		}
+	}
+
+	return ret;
+}
+
+static int find_legacy_tail_calls(struct bpf_program *prog, struct bpf_object *obj)
+{
+	unsigned int map_id, key_id;
+	const char *sec_name;
+	struct bpf_map *map;
+	char map_name[128];
+	int ret;
+
+	/* Handle iproute2 tail call */
+	sec_name = get_bpf_program__section_name(prog);
+	ret = sscanf(sec_name, "%i/%i", &map_id, &key_id);
+	if (ret != 2)
+		return -1;
+
+	ret = iproute2_find_map_name_by_id(map_id, map_name);
+	if (ret < 0) {
+		fprintf(stderr, "unable to find map id %u for tail call\n", map_id);
+		return ret;
+	}
+
+	map = bpf_object__find_map_by_name(obj, map_name);
+	if (!map)
+		return -1;
+
+	/* Save the map here for later updating */
+	bpf_program__set_priv(prog, map, NULL);
+
+	return 0;
+}
+
+static int update_legacy_tail_call_maps(struct bpf_object *obj)
+{
+	int prog_fd, map_fd, ret = 0;
+	unsigned int map_id, key_id;
+	struct bpf_program *prog;
+	const char *sec_name;
+	struct bpf_map *map;
+
+	bpf_object__for_each_program(prog, obj) {
+		map = bpf_program__priv(prog);
+		if (!map)
+			continue;
+
+		prog_fd = bpf_program__fd(prog);
+		if (prog_fd < 0)
+			continue;
+
+		sec_name = get_bpf_program__section_name(prog);
+		ret = sscanf(sec_name, "%i/%i", &map_id, &key_id);
+		if (ret != 2)
+			continue;
+
+		map_fd = bpf_map__fd(map);
+		ret = bpf_map_update_elem(map_fd, &key_id, &prog_fd, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Cannot update map key for tail call!\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int handle_legacy_maps(struct bpf_object *obj)
+{
+	char pathname[PATH_MAX];
+	struct bpf_map *map;
+	const char *map_name;
+	int map_fd, ret = 0;
+
+	bpf_object__for_each_map(map, obj) {
+		map_name = bpf_map__name(map);
+
+		ret = handle_legacy_map_in_map(obj, map, map_name);
+		if (ret)
+			return ret;
+
+		/* If it is a iproute2 legacy pin maps, just set pin path
+		 * and let bpf_object__load() to deal with the map creation.
+		 * We need to ignore map-in-maps which have pinned maps manually
+		 */
+		map_fd = bpf_map__fd(map);
+		if (map_fd < 0 && iproute2_is_pin_map(map_name, pathname)) {
+			ret = bpf_map__set_pin_path(map, pathname);
+			if (ret) {
+				fprintf(stderr, "map '%s': couldn't set pin path.\n", map_name);
+				break;
+			}
+		}
+
+	}
+
+	return ret;
+}
+
+static int load_bpf_object(struct bpf_cfg_in *cfg)
+{
+	struct bpf_program *p, *prog = NULL;
+	struct bpf_object *obj;
+	char root_path[PATH_MAX];
+	struct bpf_map *map;
+	int prog_fd, ret = 0;
+
+	ret = iproute2_get_root_path(root_path, PATH_MAX);
+	if (ret)
+		return ret;
+
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, open_opts,
+			.relaxed_maps = true,
+			.pin_root_path = root_path,
+	);
+
+	obj = bpf_object__open_file(cfg->object, &open_opts);
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return -ENOENT;
+	}
+
+	bpf_object__for_each_program(p, obj) {
+		/* Only load the programs that will either be subsequently
+		 * attached or inserted into a tail call map */
+		if (find_legacy_tail_calls(p, obj) < 0 && cfg->section &&
+		    strcmp(get_bpf_program__section_name(p), cfg->section)) {
+			ret = bpf_program__set_autoload(p, false);
+			if (ret)
+				return -EINVAL;
+			continue;
+		}
+
+		bpf_program__set_type(p, cfg->type);
+		bpf_program__set_ifindex(p, cfg->ifindex);
+		if (!prog)
+			prog = p;
+	}
+
+	bpf_object__for_each_map(map, obj) {
+		if (!bpf_map__is_offload_neutral(map))
+			bpf_map__set_ifindex(map, cfg->ifindex);
+	}
+
+	if (!prog) {
+		fprintf(stderr, "object file doesn't contain sec %s\n", cfg->section);
+		return -ENOENT;
+	}
+
+	/* Handle iproute2 legacy pin maps and map-in-maps */
+	ret = handle_legacy_maps(obj);
+	if (ret)
+		goto unload_obj;
+
+	ret = bpf_object__load(obj);
+	if (ret)
+		goto unload_obj;
+
+	ret = update_legacy_tail_call_maps(obj);
+	if (ret)
+		goto unload_obj;
+
+	prog_fd = fcntl(bpf_program__fd(prog), F_DUPFD_CLOEXEC, 1);
+	if (prog_fd < 0)
+		ret = -errno;
+	else
+		cfg->prog_fd = prog_fd;
+
+unload_obj:
+	/* Close obj as we don't need it */
+	bpf_object__close(obj);
+	return ret;
+}
+
+/* Load ebpf and return prog fd */
+int iproute2_load_libbpf(struct bpf_cfg_in *cfg)
+{
+	int ret = 0;
+
+	if (cfg->verbose)
+		libbpf_set_print(verbose_print);
+	else
+		libbpf_set_print(silent_print);
+
+	ret = iproute2_bpf_elf_ctx_init(cfg);
+	if (ret < 0) {
+		fprintf(stderr, "Cannot initialize ELF context!\n");
+		return ret;
+	}
+
+	ret = iproute2_bpf_fetch_ancillary();
+	if (ret < 0) {
+		fprintf(stderr, "Error fetching ELF ancillary data!\n");
+		return ret;
+	}
+
+	ret = load_bpf_object(cfg);
+	if (ret)
+		return ret;
+
+	return cfg->prog_fd;
+}
-- 
2.25.4

