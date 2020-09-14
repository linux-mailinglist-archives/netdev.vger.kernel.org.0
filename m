Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6733426917C
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgINQ1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:27:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39453 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726530AbgINQNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 12:13:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600100015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9f/6eHNeg0s6Jj9GHDvmuH44xs14vn5rt2HXh2zzaBw=;
        b=G4zmWMfVimUi5m6dlTfxTZ56x+6obO9GaQyNcEFyfdidB/HJw+lX16z13c7JcwaGFub5ti
        mwauQpkcqn9az8u1yO+JAycExoOgX/bamF3ZWmvQYgVNFzTQohf9oNiAMfVnplNUHke4lw
        GK1EW1YmKj26e/Rs9F00tH0HhgEekt8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-V3gV_euhO0-y1qzcrD6e8w-1; Mon, 14 Sep 2020 12:13:33 -0400
X-MC-Unique: V3gV_euhO0-y1qzcrD6e8w-1
Received: by mail-wr1-f71.google.com with SMTP id o6so69881wrp.1
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 09:13:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=9f/6eHNeg0s6Jj9GHDvmuH44xs14vn5rt2HXh2zzaBw=;
        b=Vz5E1e8Z0LVpwuyts815eqDS3iCPYCCOO2wIqOk6ymsv0JCYVefMpvnAkIonE+/2ry
         7ec3HMAk8yuHWvAL0pLp1A/2i/W3L/1afVXD0GECoh4jSepU2/HdKHhfRg2PsNu1IvHS
         I6wjuLfA+ca3htH394tvm7UuN4baDjUZhgLjbtWwAUPh1p/zBVOTWkZBNBLfr6NLmndO
         I5etS6ovSHmF1yt1H6e/0rNET/8L5St4pyTUf6WMDPTMnpHDPuctKjtuDmJwKDqRE17M
         03jPNzb3J8vJHy21+YsUYWFK2ad03waqdNcA+tMLYfyxyMf0mkSZ1wiqysiDhjXVGAlp
         qfyA==
X-Gm-Message-State: AOAM530Gsyv6iRxQTlGE5ssxHFL6d0YL19EJs/Fy8x5pX2DeqcUwPsFA
        3866J+OQTTz1V5mqGkrA9oAkaCPmqDBN126u+lyPc6dASd33DusSa99PtRXf0sP4dV4CMTVrnSO
        a/B8HA0xD7F5xbPxl
X-Received: by 2002:a1c:5641:: with SMTP id k62mr140748wmb.13.1600100012238;
        Mon, 14 Sep 2020 09:13:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwn/ZzaeyRCvdvuzJbKR1HGb02jJVhYS7uM04z+mwEoWqgSzLqU3CLahrPJzKhW4BurvRSpEw==
X-Received: by 2002:a1c:5641:: with SMTP id k62mr140727wmb.13.1600100011976;
        Mon, 14 Sep 2020 09:13:31 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id s11sm21466824wrt.43.2020.09.14.09.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 09:13:30 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8947F1829CB; Mon, 14 Sep 2020 18:13:30 +0200 (CEST)
Subject: [PATCH bpf-next v4 7/8] selftests: add test for multiple attachments
 of freplace program
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:13:30 +0200
Message-ID: <160010001045.80898.5387223996308187525.stgit@toke.dk>
In-Reply-To: <160010000272.80898.13117015273092905112.stgit@toke.dk>
References: <160010000272.80898.13117015273092905112.stgit@toke.dk>
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
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |  171 ++++++++++++++++----
 .../selftests/bpf/progs/freplace_get_constant.c    |   15 ++
 2 files changed, 154 insertions(+), 32 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_get_constant.c

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index eda682727787..3621d66e47dd 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -2,36 +2,79 @@
 /* Copyright (c) 2019 Facebook */
 #include <test_progs.h>
 #include <network_helpers.h>
+#include <bpf/btf.h>
+
+typedef int (*test_cb)(struct bpf_object *obj);
+
+static int check_data_map(struct bpf_object *obj, int prog_cnt, bool reset)
+{
+	struct bpf_map *data_map = NULL, *map;
+	__u64 *result = NULL;
+	const int zero = 0;
+	__u32 duration = 0;
+	int ret = -1, i;
+
+	result = malloc((prog_cnt + 32 /* spare */) * sizeof(__u64));
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
+		if (CHECK(result[i] != 1, "result",
+			  "fexit_bpf2bpf result[%d] failed err %llu\n",
+			  i, result[i]))
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
-	struct bpf_link **link = NULL;
+	struct bpf_object *obj = NULL, *tgt_obj;
 	struct bpf_program **prog = NULL;
+	struct bpf_link **link = NULL;
 	__u32 duration = 0, retval;
-	struct bpf_map *data_map;
-	const int zero = 0;
-	__u64 *result = NULL;
+	int err, tgt_fd, i;
 
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
-	result = malloc((prog_cnt + 32 /* spare */) * sizeof(__u64));
-	if (CHECK(!link || !prog || !result, "alloc_memory",
-		  "failed to alloc memory"))
+	if (CHECK(!link || !prog, "alloc_memory", "failed to alloc memory"))
 		goto close_prog;
 
 	obj = bpf_object__open_file(obj_file, &opts);
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
-		if (CHECK(result[i] != 1, "result", "fexit_bpf2bpf failed err %llu\n",
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
@@ -128,7 +165,7 @@ static void test_func_replace(void)
 	test_fexit_bpf2bpf_common("./fexit_bpf2bpf.o",
 				  "./test_pkt_access.o",
 				  ARRAY_SIZE(prog_name),
-				  prog_name, true);
+				  prog_name, true, NULL);
 }
 
 static void test_func_replace_verify(void)
@@ -139,7 +176,75 @@ static void test_func_replace_verify(void)
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
+	struct btf *btf;
+
+	prog = bpf_object__find_program_by_title(obj, prog_name);
+	if (CHECK(!prog, "find_prog", "prog %s not found\n", prog_name))
+		return -ENOENT;
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
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
+			    .target_btf_id = tgt_btf_id,
+			   );
+	link_fd = bpf_link_create(bpf_program__fd(prog), tgt_fd,
+				  BPF_TRACE_FREPLACE, &opts);
+	if (CHECK(link_fd < 0, "second_link", "err %d errno %d",
+		  link_fd, errno)) {
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
 
 static void test_func_sockmap_update(void)
@@ -150,7 +255,7 @@ static void test_func_sockmap_update(void)
 	test_fexit_bpf2bpf_common("./freplace_cls_redirect.o",
 				  "./test_cls_redirect.o",
 				  ARRAY_SIZE(prog_name),
-				  prog_name, false);
+				  prog_name, false, NULL);
 }
 
 static void test_obj_load_failure_common(const char *obj_file,
@@ -222,4 +327,6 @@ void test_fexit_bpf2bpf(void)
 		test_func_replace_return_code();
 	if (test__start_subtest("func_map_prog_compatibility"))
 		test_func_map_prog_compatibility();
+	if (test__start_subtest("func_replace_multi"))
+		test_func_replace_multi();
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

