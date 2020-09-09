Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5CD2635E0
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgIISYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgIISYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:24:22 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E87C061796
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:24:16 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id t127so3050873ybf.16
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 11:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=b0qCV0C2cjdPMv4ejLiY/AMfUzUSAd07vJk0w5XDbZE=;
        b=T1fjKqnynJhcVChZR80gQuP+D+tCnKgekk2pvC+8d8lezX9nqtC4Pfi1V7EsmB1QaN
         aKZBdm1t/eGzrpRGrgv9iDYvFkQE1W4B/Jdc/b1J/TFXBF0GVrZQI4Ugl6MEnWxm7JRn
         AaToExAzcF23Ox76hH+yTAGyauJX7Y0mVZ56jIuFIyGXDhNiDFnFrVvqe6FnHiddLt0x
         /1TMbfwZZDz5V5UVP3KHs78F3+h3VrQKkvJWyYbcOeSPZocb/AUMAovBJsiM1KuW3zj4
         RnEAkbEMAPO4/O7N/dXkmZVxREe9gEiL5kWKYS94OTSXY7utkf3eF48UzrkGEthlR/8g
         dDQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=b0qCV0C2cjdPMv4ejLiY/AMfUzUSAd07vJk0w5XDbZE=;
        b=lYpPURAtsHJBgc68aIKqedE1qAPs8l6hLW/ZHgTNWaJMwmuSy394nZVxjf+CjGjDNY
         MO7Q8lvb3ofv26fag+pm05WE4whUCV2Fa0fKCcZ2PNmMMUtWhry63e6T8Q1Kc4uMlnS/
         G1NT2uTSgqd8irCNf5HomkZrjSXU9Y3qYRfGe3RvDWz7YG/GDAnf94i3val0XWWuOmMH
         l5tz7xuVUwYo5VgmMFHdiSTmwJJllZn9z3jwJULpP+9qUUdOfTM+OmEiqwt3mxtysHJc
         Nzh5AV1FFLAEl261f13UVY87jJIl4tZUKiWXNLsZFjHFJru59AfPn8gblDONVRMFbGhs
         hF+g==
X-Gm-Message-State: AOAM533aXgZ6XiB9oh7UtwS2H6ISGuPvS7SNOSVejHaAQ4X9h+4zdRoz
        dVc0OSba9u1hzZIX7tvdnl3cNtEIvGt614QuxkPpInebVzQ4YavqWVS6WsYtqvyQeFiDygqpVv4
        2ykyo+jlALePPZvdR1M+Jbv/oQXPtUPYwNgIdNQZlJCvPtyC+lC557w==
X-Google-Smtp-Source: ABdhPJy7KgmqOZMSgq+Dbb9B/W9oXpEERO9XLv8Oj6xqefNb3AHWo9v0NhRCQ7thZWLQ3NAqhLVIzAA=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a05:6902:4e3:: with SMTP id
 w3mr8272813ybs.172.1599675855681; Wed, 09 Sep 2020 11:24:15 -0700 (PDT)
Date:   Wed,  9 Sep 2020 11:24:05 -0700
In-Reply-To: <20200909182406.3147878-1-sdf@google.com>
Message-Id: <20200909182406.3147878-5-sdf@google.com>
Mime-Version: 1.0
References: <20200909182406.3147878-1-sdf@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH bpf-next v4 4/5] bpftool: support dumping metadata
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YiFei Zhu <zhuyifei@google.com>

Dump metadata in the 'bpftool prog' list if it's present.
For some formatting some BTF code is put directly in the
metadata dumping. Sanity checks on the map and the kind of the btf_type
to make sure we are actually dumping what we are expecting.

A helper jsonw_reset is added to json writer so we can reuse the same
json writer without having extraneous commas.

Sample output:

  $ bpftool prog
  6: cgroup_skb  name prog  tag bcf7977d3b93787c  gpl
  [...]
  	btf_id 4
  	metadata:
  		a = "foo"
  		b = 1

  $ bpftool prog --json --pretty
  [{
          "id": 6,
  [...]
          "btf_id": 4,
          "metadata": {
              "a": "foo",
              "b": 1
          }
      }
  ]

Cc: YiFei Zhu <zhuyifei1999@gmail.com>
Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/bpf/bpftool/json_writer.c |   6 +
 tools/bpf/bpftool/json_writer.h |   3 +
 tools/bpf/bpftool/prog.c        | 222 ++++++++++++++++++++++++++++++++
 3 files changed, 231 insertions(+)

diff --git a/tools/bpf/bpftool/json_writer.c b/tools/bpf/bpftool/json_writer.c
index 86501cd3c763..7fea83bedf48 100644
--- a/tools/bpf/bpftool/json_writer.c
+++ b/tools/bpf/bpftool/json_writer.c
@@ -119,6 +119,12 @@ void jsonw_pretty(json_writer_t *self, bool on)
 	self->pretty = on;
 }
 
+void jsonw_reset(json_writer_t *self)
+{
+	assert(self->depth == 0);
+	self->sep = '\0';
+}
+
 /* Basic blocks */
 static void jsonw_begin(json_writer_t *self, int c)
 {
diff --git a/tools/bpf/bpftool/json_writer.h b/tools/bpf/bpftool/json_writer.h
index 35cf1f00f96c..8ace65cdb92f 100644
--- a/tools/bpf/bpftool/json_writer.h
+++ b/tools/bpf/bpftool/json_writer.h
@@ -27,6 +27,9 @@ void jsonw_destroy(json_writer_t **self_p);
 /* Cause output to have pretty whitespace */
 void jsonw_pretty(json_writer_t *self, bool on);
 
+/* Reset separator to create new JSON */
+void jsonw_reset(json_writer_t *self);
+
 /* Add property name */
 void jsonw_name(json_writer_t *self, const char *name);
 
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index f7923414a052..ca264dc22434 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -29,6 +29,9 @@
 #include "main.h"
 #include "xlated_dumper.h"
 
+#define BPF_METADATA_PREFIX "bpf_metadata_"
+#define BPF_METADATA_PREFIX_LEN strlen(BPF_METADATA_PREFIX)
+
 const char * const prog_type_name[] = {
 	[BPF_PROG_TYPE_UNSPEC]			= "unspec",
 	[BPF_PROG_TYPE_SOCKET_FILTER]		= "socket_filter",
@@ -151,6 +154,221 @@ static void show_prog_maps(int fd, __u32 num_maps)
 	}
 }
 
+static int bpf_prog_find_metadata(int prog_fd, int *map_id)
+{
+	struct bpf_prog_info prog_info = {};
+	struct bpf_map_info map_info;
+	__u32 prog_info_len;
+	__u32 map_info_len;
+	int saved_errno;
+	__u32 *map_ids;
+	int nr_maps;
+	int map_fd;
+	int ret;
+	__u32 i;
+
+	prog_info_len = sizeof(prog_info);
+
+	ret = bpf_obj_get_info_by_fd(prog_fd, &prog_info, &prog_info_len);
+	if (ret)
+		return ret;
+
+	if (!prog_info.nr_map_ids) {
+		errno = ENOENT;
+		return -1;
+	}
+
+	map_ids = calloc(prog_info.nr_map_ids, sizeof(__u32));
+	if (!map_ids) {
+		errno = ENOMEM;
+		return -1;
+	}
+
+	nr_maps = prog_info.nr_map_ids;
+	memset(&prog_info, 0, sizeof(prog_info));
+	prog_info.nr_map_ids = nr_maps;
+	prog_info.map_ids = ptr_to_u64(map_ids);
+	prog_info_len = sizeof(prog_info);
+
+	ret = bpf_obj_get_info_by_fd(prog_fd, &prog_info, &prog_info_len);
+	if (ret)
+		goto free_map_ids;
+
+	for (i = 0; i < prog_info.nr_map_ids; i++) {
+		map_fd = bpf_map_get_fd_by_id(map_ids[i]);
+		if (map_fd < 0) {
+			ret = -1;
+			goto free_map_ids;
+		}
+
+		memset(&map_info, 0, sizeof(map_info));
+		map_info_len = sizeof(map_info);
+		ret = bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len);
+
+		saved_errno = errno;
+		close(map_fd);
+		errno = saved_errno;
+		if (ret)
+			goto free_map_ids;
+
+		if (map_info.type != BPF_MAP_TYPE_ARRAY)
+			continue;
+		if (map_info.key_size != sizeof(int))
+			continue;
+		if (map_info.max_entries != 1)
+			continue;
+		if (!map_info.btf_value_type_id)
+			continue;
+		if (!strstr(map_info.name, ".rodata"))
+			continue;
+
+		*map_id = map_ids[i];
+		goto free_map_ids;
+	}
+
+	ret = -1;
+	errno = ENOENT;
+
+free_map_ids:
+	saved_errno = errno;
+	free(map_ids);
+	errno = saved_errno;
+	return ret;
+}
+
+static bool has_metadata_prefix(const char *s)
+{
+	return strstr(s, BPF_METADATA_PREFIX) == s;
+}
+
+static void show_prog_metadata(int fd, __u32 num_maps)
+{
+	const struct btf_type *t_datasec, *t_var;
+	struct bpf_map_info map_info = {};
+	struct btf_var_secinfo *vsi;
+	bool printed_header = false;
+	struct btf *btf = NULL;
+	unsigned int i, vlen;
+	__u32 map_info_len;
+	void *value = NULL;
+	const char *name;
+	int map_id = 0;
+	int key = 0;
+	int map_fd;
+	int err;
+
+	if (!num_maps)
+		return;
+
+	err = bpf_prog_find_metadata(fd, &map_id);
+	if (err < 0)
+		return;
+
+	map_fd = bpf_map_get_fd_by_id(map_id);
+	if (map_fd < 0)
+		return;
+
+	map_info_len = sizeof(map_info);
+	err = bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len);
+	if (err)
+		goto out_close;
+
+	value = malloc(map_info.value_size);
+	if (!value)
+		goto out_close;
+
+	if (bpf_map_lookup_elem(map_fd, &key, value))
+		goto out_free;
+
+	err = btf__get_from_id(map_info.btf_id, &btf);
+	if (err || !btf)
+		goto out_free;
+
+	t_datasec = btf__type_by_id(btf, map_info.btf_value_type_id);
+	if (!btf_is_datasec(t_datasec))
+		goto out_free;
+
+	vlen = btf_vlen(t_datasec);
+	vsi = btf_var_secinfos(t_datasec);
+
+	/* We don't proceed to check the kinds of the elements of the DATASEC.
+	 * The verifier enforces them to be BTF_KIND_VAR.
+	 */
+
+	if (json_output) {
+		struct btf_dumper d = {
+			.btf = btf,
+			.jw = json_wtr,
+			.is_plain_text = false,
+		};
+
+		for (i = 0; i < vlen; i++, vsi++) {
+			t_var = btf__type_by_id(btf, vsi->type);
+			name = btf__name_by_offset(btf, t_var->name_off);
+
+			if (!has_metadata_prefix(name))
+				continue;
+
+			if (!printed_header) {
+				jsonw_name(json_wtr, "metadata");
+				jsonw_start_object(json_wtr);
+				printed_header = true;
+			}
+
+			jsonw_name(json_wtr, name + BPF_METADATA_PREFIX_LEN);
+			err = btf_dumper_type(&d, t_var->type, value + vsi->offset);
+			if (err) {
+				p_err("btf dump failed: %d", err);
+				break;
+			}
+		}
+		if (printed_header)
+			jsonw_end_object(json_wtr);
+	} else {
+		json_writer_t *btf_wtr = jsonw_new(stdout);
+		struct btf_dumper d = {
+			.btf = btf,
+			.jw = btf_wtr,
+			.is_plain_text = true,
+		};
+		if (!btf_wtr) {
+			p_err("jsonw alloc failed");
+			goto out_free;
+		}
+
+		for (i = 0; i < vlen; i++, vsi++) {
+			t_var = btf__type_by_id(btf, vsi->type);
+			name = btf__name_by_offset(btf, t_var->name_off);
+
+			if (!has_metadata_prefix(name))
+				continue;
+
+			if (!printed_header) {
+				printf("\tmetadata:");
+				printed_header = true;
+			}
+
+			printf("\n\t\t%s = ", name + BPF_METADATA_PREFIX_LEN);
+
+			jsonw_reset(btf_wtr);
+			err = btf_dumper_type(&d, t_var->type, value + vsi->offset);
+			if (err) {
+				p_err("btf dump failed: %d", err);
+				break;
+			}
+		}
+		if (printed_header)
+			jsonw_destroy(&btf_wtr);
+	}
+
+out_free:
+	btf__free(btf);
+	free(value);
+
+out_close:
+	close(map_fd);
+}
+
 static void print_prog_header_json(struct bpf_prog_info *info)
 {
 	jsonw_uint_field(json_wtr, "id", info->id);
@@ -228,6 +446,8 @@ static void print_prog_json(struct bpf_prog_info *info, int fd)
 
 	emit_obj_refs_json(&refs_table, info->id, json_wtr);
 
+	show_prog_metadata(fd, info->nr_map_ids);
+
 	jsonw_end_object(json_wtr);
 }
 
@@ -297,6 +517,8 @@ static void print_prog_plain(struct bpf_prog_info *info, int fd)
 	emit_obj_refs_plain(&refs_table, info->id, "\n\tpids ");
 
 	printf("\n");
+
+	show_prog_metadata(fd, info->nr_map_ids);
 }
 
 static int show_prog(int fd)
-- 
2.28.0.526.ge36021eeef-goog

