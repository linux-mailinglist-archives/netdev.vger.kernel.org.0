Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0949621E13B
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 22:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgGMUMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 16:12:36 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:47770 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726898AbgGMUMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 16:12:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594671152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vTIQaOPIQ+MaCndHFRhBSVSQrsv7BpdyNa0iaL4KcwE=;
        b=QnWb5tzSAt/38d2Caqzp1F2Re0pcyChCUgAA3Egp4TQqfG5cPtcDCjajT9caV//g0DC4HX
        P5wb4Jjvvn4RXkvYUO4mPiZ/ycmAQR5AEPE17mVLv4Xupey67j/N8J7oPbMOXCtm/4UYWa
        ao3wyczCZqQ5r9Aa+RQ7vC3piG5vA74=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-qZH0kP8MMNulz9QFsLSBQw-1; Mon, 13 Jul 2020 16:12:30 -0400
X-MC-Unique: qZH0kP8MMNulz9QFsLSBQw-1
Received: by mail-qt1-f200.google.com with SMTP id d45so10948098qte.12
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 13:12:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vTIQaOPIQ+MaCndHFRhBSVSQrsv7BpdyNa0iaL4KcwE=;
        b=bDsxlQcFtxk31cDVBL9FyCLawjkB5Igfv+xBrDTpJ+um21rGG2K1+nqtLGYiotVnRG
         nJ4L+SeY8ALXI0HZUgncB7QzqwTkrY5fxYouRwJcCIzS4OzX+hd3Wg3eNlmt9HNM3BxH
         7Kln7PWs/7wWDL2FjgQ8+trHfiuCTE45mRlHfzK38bKLaM8I0IVFr55NKZRRnDtZtH0k
         bH8yep8Exvfl7zkQu+bdOKC0WTltlGPNM3WpPDxZdhzFd5kgm1Okw2BkqH81bdkJoY/a
         Ktc4RtlZuj2O8SsCDDA0EYX3vg6I6vSRgS12A7Lg0W1jMi4PgbF7FCyIfckUGWxtupjl
         C+6g==
X-Gm-Message-State: AOAM533nYhiZvOKVSl9ZKkj7ad+v8+EXF9+ZLk8bf3kU7/urLSVBQvSa
        FLxQn4fV8Zodsst2U16NPLPok8aB3Pu/SzkIp4/3kHqg+xdS4dSVNSXiJBGfnctXoMb6NaC98zr
        Zq3tzP92+JwbffnVr
X-Received: by 2002:a37:27d3:: with SMTP id n202mr1284503qkn.95.1594671149818;
        Mon, 13 Jul 2020 13:12:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkhVhM5EO8L7DniR0AoGbGc/Ta0NnTHf3EpE/4+IZeDr1C7+lZJC0hGRzBzUJufUV3AxyBig==
X-Received: by 2002:a37:27d3:: with SMTP id n202mr1284483qkn.95.1594671149466;
        Mon, 13 Jul 2020 13:12:29 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 16sm19015248qkn.106.2020.07.13.13.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 13:12:27 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 49E4F180653; Mon, 13 Jul 2020 22:12:26 +0200 (CEST)
Subject: [PATCH bpf-next 6/6] selftests: add test for multiple attachments of
 freplace program
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Mon, 13 Jul 2020 22:12:26 +0200
Message-ID: <159467114624.370286.16399454779226567555.stgit@toke.dk>
In-Reply-To: <159467113970.370286.17656404860101110795.stgit@toke.dk>
References: <159467113970.370286.17656404860101110795.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds a selftest for attaching an freplace program to multiple targets
simultaneously.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |  174 +++++++++++++++++---
 .../selftests/bpf/progs/freplace_get_constant.c    |   15 ++
 2 files changed, 160 insertions(+), 29 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_get_constant.c

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index a895bfed55db..60cf3e44a6ef 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -2,35 +2,78 @@
 /* Copyright (c) 2019 Facebook */
 #include <test_progs.h>
 #include <network_helpers.h>
+#include <bpf/btf.h>
+
+typedef int (*test_cb)(struct bpf_object *obj);
+
+static int check_data_map(struct bpf_object *obj, int prog_cnt, bool reset)
+{
+	struct bpf_map *data_map, *map;
+	const int zero = 0;
+	u64 *result = NULL;
+	__u32 duration = 0;
+	int ret = -1, i;
+
+	result = malloc((prog_cnt + 32 /* spare */) * sizeof(u64));
+	if (CHECK(!result, "alloc_memory", "failed to alloc memory"))
+		return -ENOMEM;
+
+	bpf_object__for_each_map(map, obj)
+		if (bpf_map__is_internal(map)) {
+			data_map = map;
+			break;
+		}
+	if (CHECK(!data_map, "find_data_map", "data map not found\n"))
+		goto out;
+
+	ret = bpf_map_lookup_elem(bpf_map__fd(data_map), &zero, result);
+	if (CHECK(ret, "get_result",
+		  "failed to get output data: %d\n", ret))
+		goto out;
+
+	for (i = 0; i < prog_cnt; i++) {
+		if (CHECK(result[i] != 1, "result", "fexit_bpf2bpf failed err %ld\n",
+			  result[i]))
+			goto out;
+		result[i] = 0;
+	}
+	if (reset) {
+		ret = bpf_map_update_elem(bpf_map__fd(data_map), &zero, result, 0);
+		if (CHECK(ret, "reset_result", "failed to reset result\n"))
+			goto out;
+	}
+
+	ret = 0;
+out:
+	free(result);
+	return ret;
+}
 
 static void test_fexit_bpf2bpf_common(const char *obj_file,
 				      const char *target_obj_file,
 				      int prog_cnt,
 				      const char **prog_name,
-				      bool run_prog)
+				      bool run_prog,
+				      test_cb cb)
 {
-	struct bpf_object *obj = NULL, *pkt_obj;
-	int err, pkt_fd, i;
+	struct bpf_object *obj = NULL, *tgt_obj;
+	int err, tgt_fd, i;
 	struct bpf_link **link = NULL;
 	struct bpf_program **prog = NULL;
 	__u32 duration = 0, retval;
-	struct bpf_map *data_map;
-	const int zero = 0;
-	u64 *result = NULL;
 
 	err = bpf_prog_load(target_obj_file, BPF_PROG_TYPE_UNSPEC,
-			    &pkt_obj, &pkt_fd);
+			    &tgt_obj, &tgt_fd);
 	if (CHECK(err, "tgt_prog_load", "file %s err %d errno %d\n",
 		  target_obj_file, err, errno))
 		return;
 	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
-			    .attach_prog_fd = pkt_fd,
+			    .attach_prog_fd = tgt_fd,
 			   );
 
 	link = calloc(sizeof(struct bpf_link *), prog_cnt);
 	prog = calloc(sizeof(struct bpf_program *), prog_cnt);
-	result = malloc((prog_cnt + 32 /* spare */) * sizeof(u64));
-	if (CHECK(!link || !prog || !result, "alloc_memory",
+	if (CHECK(!link || !prog, "alloc_memory",
 		  "failed to alloc memory"))
 		goto close_prog;
 
@@ -53,39 +96,33 @@ static void test_fexit_bpf2bpf_common(const char *obj_file,
 			goto close_prog;
 	}
 
-	if (!run_prog)
-		goto close_prog;
+	if (cb) {
+		err = cb(obj);
+		if (err)
+			goto close_prog;
+	}
 
-	data_map = bpf_object__find_map_by_name(obj, "fexit_bp.bss");
-	if (CHECK(!data_map, "find_data_map", "data map not found\n"))
+	if (!run_prog)
 		goto close_prog;
 
-	err = bpf_prog_test_run(pkt_fd, 1, &pkt_v6, sizeof(pkt_v6),
+	err = bpf_prog_test_run(tgt_fd, 1, &pkt_v6, sizeof(pkt_v6),
 				NULL, NULL, &retval, &duration);
 	CHECK(err || retval, "ipv6",
 	      "err %d errno %d retval %d duration %d\n",
 	      err, errno, retval, duration);
 
-	err = bpf_map_lookup_elem(bpf_map__fd(data_map), &zero, result);
-	if (CHECK(err, "get_result",
-		  "failed to get output data: %d\n", err))
+	if (check_data_map(obj, prog_cnt, false))
 		goto close_prog;
 
-	for (i = 0; i < prog_cnt; i++)
-		if (CHECK(result[i] != 1, "result", "fexit_bpf2bpf failed err %ld\n",
-			  result[i]))
-			goto close_prog;
-
 close_prog:
 	for (i = 0; i < prog_cnt; i++)
 		if (!IS_ERR_OR_NULL(link[i]))
 			bpf_link__destroy(link[i]);
 	if (!IS_ERR_OR_NULL(obj))
 		bpf_object__close(obj);
-	bpf_object__close(pkt_obj);
+	bpf_object__close(tgt_obj);
 	free(link);
 	free(prog);
-	free(result);
 }
 
 static void test_target_no_callees(void)
@@ -96,7 +133,7 @@ static void test_target_no_callees(void)
 	test_fexit_bpf2bpf_common("./fexit_bpf2bpf_simple.o",
 				  "./test_pkt_md_access.o",
 				  ARRAY_SIZE(prog_name),
-				  prog_name, true);
+				  prog_name, true, NULL);
 }
 
 static void test_target_yes_callees(void)
@@ -110,7 +147,7 @@ static void test_target_yes_callees(void)
 	test_fexit_bpf2bpf_common("./fexit_bpf2bpf.o",
 				  "./test_pkt_access.o",
 				  ARRAY_SIZE(prog_name),
-				  prog_name, true);
+				  prog_name, true, NULL);
 }
 
 static void test_func_replace(void)
@@ -127,7 +164,7 @@ static void test_func_replace(void)
 	test_fexit_bpf2bpf_common("./fexit_bpf2bpf.o",
 				  "./test_pkt_access.o",
 				  ARRAY_SIZE(prog_name),
-				  prog_name, true);
+				  prog_name, true, NULL);
 }
 
 static void test_func_replace_verify(void)
@@ -138,7 +175,85 @@ static void test_func_replace_verify(void)
 	test_fexit_bpf2bpf_common("./freplace_connect4.o",
 				  "./connect4_prog.o",
 				  ARRAY_SIZE(prog_name),
-				  prog_name, false);
+				  prog_name, false, NULL);
+}
+
+static int test_second_attach(struct bpf_object *obj)
+{
+	const char *prog_name = "freplace/get_constant";
+	const char *tgt_name = prog_name + 9; /* cut off freplace/ */
+	const char *tgt_obj_file = "./test_pkt_access.o";
+	int err = 0, tgt_fd, tgt_btf_id, link_fd = -1;
+	struct bpf_program *prog = NULL;
+	struct bpf_object *tgt_obj;
+	__u32 duration = 0, retval;
+	size_t log_buf_sz = 1024;
+	char *log_buf = NULL;
+	struct btf *btf;
+
+	prog = bpf_object__find_program_by_title(obj, prog_name);
+	if (CHECK(!prog, "find_prog", "prog %s not found\n", prog_name))
+		return -ENOENT;
+
+	log_buf = calloc(log_buf_sz, 1);
+	if (!log_buf)
+		return -ENOMEM;
+
+	err = bpf_prog_load(tgt_obj_file, BPF_PROG_TYPE_UNSPEC,
+			    &tgt_obj, &tgt_fd);
+	if (CHECK(err, "second_prog_load", "file %s err %d errno %d\n",
+		  tgt_obj_file, err, errno))
+		return err;
+
+	btf = bpf_object__btf(tgt_obj);
+	tgt_btf_id = btf__find_by_name_kind(btf, tgt_name, BTF_KIND_FUNC);
+	if (CHECK(tgt_btf_id < 0, "find_btf", "no BTF ID found for func %s\n", prog_name)) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	DECLARE_LIBBPF_OPTS(bpf_raw_tracepoint_opts, opts,
+			    .tgt_prog_fd = tgt_fd,
+			    .tgt_btf_id = tgt_btf_id,
+			    .log_buf = log_buf,
+			    .log_buf_sz = log_buf_sz,
+			    .log_level = 7,
+			   );
+	link_fd = bpf_raw_tracepoint_open_opts(NULL, bpf_program__fd(prog), &opts);
+	if (CHECK(link_fd < 0, "second_link", "err %d errno %d log %s",
+		  link_fd, errno, log_buf)) {
+		err = link_fd;
+		goto out;
+	}
+
+	err = bpf_prog_test_run(tgt_fd, 1, &pkt_v6, sizeof(pkt_v6),
+				NULL, NULL, &retval, &duration);
+	if (CHECK(err || retval, "ipv6",
+		  "err %d errno %d retval %d duration %d\n",
+		  err, errno, retval, duration))
+		goto out;
+
+	err = check_data_map(obj, 1, true);
+	if (err)
+		goto out;
+
+out:
+	if (link_fd >= 0)
+		close(link_fd);
+	bpf_object__close(tgt_obj);
+	free(log_buf);
+	return err;
+}
+
+static void test_func_replace_multi(void)
+{
+	const char *prog_name[] = {
+		"freplace/get_constant",
+	};
+	test_fexit_bpf2bpf_common("./freplace_get_constant.o",
+				  "./test_pkt_access.o",
+				  ARRAY_SIZE(prog_name),
+				  prog_name, true, test_second_attach);
 }
 
 void test_fexit_bpf2bpf(void)
@@ -147,4 +262,5 @@ void test_fexit_bpf2bpf(void)
 	test_target_yes_callees();
 	test_func_replace();
 	test_func_replace_verify();
+	test_func_replace_multi();
 }
diff --git a/tools/testing/selftests/bpf/progs/freplace_get_constant.c b/tools/testing/selftests/bpf/progs/freplace_get_constant.c
new file mode 100644
index 000000000000..8f0ecf94e533
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/freplace_get_constant.c
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+volatile __u64 test_get_constant = 0;
+SEC("freplace/get_constant")
+int new_get_constant(long val)
+{
+	if (val != 123)
+		return 0;
+	test_get_constant = 1;
+	return test_get_constant; /* original get_constant() returns val - 122 */
+}
+char _license[] SEC("license") = "GPL";

