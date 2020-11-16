Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB0A2B3D61
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 07:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgKPGx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 01:53:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50506 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727106AbgKPGx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 01:53:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605509635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RZvNnFWikEiWtvWgEBZfA0jt6sKdEVijzLEqbAEWZCk=;
        b=UV85c/Oz6vVuwfOOWKVo8BDA2rqAr5+hFtmHI11jOdKDMLWhL8GZCRjLdmM5h4KrZnCjVy
        sk+/l5mFgKxquEqdfblFk56j7He6VmxStSnlM0l0NEq0TGhuTFSK5elUIxNjpeeJISctse
        izJ237R+kVxL2mo3cTIlvvs6Iy9jTE4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-t10i_R-BP32aWRV21Rubug-1; Mon, 16 Nov 2020 01:53:52 -0500
X-MC-Unique: t10i_R-BP32aWRV21Rubug-1
Received: by mail-pl1-f198.google.com with SMTP id g20so8554208plj.10
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 22:53:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RZvNnFWikEiWtvWgEBZfA0jt6sKdEVijzLEqbAEWZCk=;
        b=jZfkwfv4G4XZqDp7TdjuQiSQEs+Qs5JkNt0S4lYj6iGdlPQw0BGQDt3BBn02Gbde4w
         flvk6bq0UjD/TrYcwRjqzUvjrfPYOnRThh3cjpY8wjIxUzDsj2K3OT9TXGUjO0mQZnHN
         8jM1du7Ury7I6O3SIJKSgW1aNjz2YyEJa4MsmojrI8MlJWCrUem+vOXufAEsvnb1N0WG
         sHhorVpO7nTskT0PY4Y/L1919dPVDG5yjHRHWhdLYSJ6ivkWd+Mvyb3lb9GZAuXbLs96
         o5nNnXw1IyCHP357S85ve35xXEsNBukoPeA7Wi/LVP9zHY4AWvobq39MabVqD8jV+FUW
         dHmw==
X-Gm-Message-State: AOAM5337DFDpvBUXPNkOumSfrmd1R+YThe2bB5+EsUEKxdQIEhf4jnak
        KAoyztctI3YMwWs5A5uPdawtRqSVysKzeOleEvYom6oTrm8xSTxhbX9A7mSKaHfuPXv6QOi+Gg6
        QWBQ9GiWgODOK/cM=
X-Received: by 2002:a17:90a:aa8f:: with SMTP id l15mr2318703pjq.135.1605509631150;
        Sun, 15 Nov 2020 22:53:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwDqq5TVuAven52BENNtCmxY/kvpkaZZxd+8lcziF0FukT2P0/rDLHTopAPVXL6cVTJwR8phw==
X-Received: by 2002:a17:90a:aa8f:: with SMTP id l15mr2318678pjq.135.1605509630853;
        Sun, 15 Nov 2020 22:53:50 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 16sm18645837pjf.36.2020.11.15.22.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 22:53:50 -0800 (PST)
From:   Hangbin Liu <haliu@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <haliu@redhat.com>
Subject: [PATCHv5 iproute2-next 3/5] lib: add libbpf support
Date:   Mon, 16 Nov 2020 14:53:03 +0800
Message-Id: <20201116065305.1010651-4-haliu@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201116065305.1010651-1-haliu@redhat.com>
References: <20201109070802.3638167-1-haliu@redhat.com>
 <20201116065305.1010651-1-haliu@redhat.com>
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
v4:
Move ipvrf code to patch 02
Move HAVE_LIBBPF inside HAVE_ELF definition as libbpf depends on elf.

v3:
Add a new function get_bpf_program__section_name() to choose whether
use bpf_program__title() or not.

v2:
Remove self defined IS_ERR_OR_NULL and use libbpf_get_error() instead.
Add ipvrf with libbpf support.
---
 include/bpf_util.h |  11 ++
 lib/Makefile       |   4 +
 lib/bpf_legacy.c   | 178 +++++++++++++++++++++++
 lib/bpf_libbpf.c   | 353 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 546 insertions(+)
 create mode 100644 lib/bpf_libbpf.c

diff --git a/include/bpf_util.h b/include/bpf_util.h
index 82217cc6..d4f66de9 100644
--- a/include/bpf_util.h
+++ b/include/bpf_util.h
@@ -304,4 +304,15 @@ static inline int bpf_recv_map_fds(const char *path, int *fds,
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
diff --git a/lib/Makefile b/lib/Makefile
index 7c8a197c..fb6c31ec 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -7,6 +7,10 @@ UTILOBJ = utils.o rt_names.o ll_map.o ll_types.o ll_proto.o ll_addr.o \
 	inet_proto.o namespace.o json_writer.o json_print.o \
 	names.o color.o bpf_legacy.o bpf_glue.o exec.o fs.o cg_map.o
 
+ifeq ($(HAVE_LIBBPF),y)
+UTILOBJ += bpf_libbpf.o
+endif
+
 NLOBJ=libgenl.o libnetlink.o mnl_utils.o
 
 all: libnetlink.a libutil.a
diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index 4246fb76..bc869c3f 100644
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
@@ -3155,4 +3158,179 @@ int bpf_recv_map_fds(const char *path, int *fds, struct bpf_map_aux *aux,
 	close(fd);
 	return ret;
 }
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
 #endif /* HAVE_ELF */
diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
new file mode 100644
index 00000000..26694b43
--- /dev/null
+++ b/lib/bpf_libbpf.c
@@ -0,0 +1,353 @@
+/*
+ * bpf_libbpf.c	BPF code relay on libbpf
+ *
+ *		This program is free software; you can redistribute it and/or
+ *		modify it under the terms of the GNU General Public License
+ *		as published by the Free Software Foundation; either version
+ *		2 of the License, or (at your option) any later version.
+ *
+ * Authors:	Hangbin Liu <haliu@redhat.com>
+ *
+ */
+
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

