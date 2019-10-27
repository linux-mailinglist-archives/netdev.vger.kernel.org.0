Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6206E656D
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 21:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbfJ0UxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 16:53:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56048 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbfJ0UxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 16:53:24 -0400
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com [209.85.208.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 120C059455
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 20:53:23 +0000 (UTC)
Received: by mail-lj1-f199.google.com with SMTP id f24so1511567ljc.12
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 13:53:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=7/hXNSDM8e/13IlYxPwx4PGhsfz+ooqFjXHNel7DAaA=;
        b=e2Pa4ZmFwopeBaG5mkjiOqkALiqpSOFQySVvvEiJj7YwHdb3rQfkf75HkwsiSdmLmt
         A2i47WQA3NjWjnmlk1sBuat5UbYXKkolNqJdSTlV6cvHBbMrEst8NgjtLpWz83+7bkCp
         EGX+1cpWhQzF/uiogzyP+jij+WmIkxmS4esB7P3k92WhoDGD5s88lJDhBMAL4xmj9iG8
         Oh82fuQEc8FmY98KNekYvFVSZuFDJMQe9Jx8biUsg8OTQPGeEWjcfNv0AQcMdszqG8wR
         QPaOqas/qSpExQwmgIITd4PGJMjvXAUIXfiuMLMm0HGvIUf6bNA7aP+JPpGa/NnRcGGG
         2keQ==
X-Gm-Message-State: APjAAAWDIQflg3PY97HQs2wEM+BLQIZSXaE36ZGbb0QbBaGsQhFiYOLh
        M9jz6lX3quEj2FsDlgs5Bz2FoHTG7BA3PK4AmKXuKyUNzR+NbCxBgF1sut6/aF6aQvkwuC7d6xM
        KfgbF1+hBwiZbpmZF
X-Received: by 2002:a2e:998a:: with SMTP id w10mr2669453lji.152.1572209601584;
        Sun, 27 Oct 2019 13:53:21 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxD+iOz6+pySiESIn/D8IK+ZRVf+5HxDjpK2nY3kx/hkCa1l211FIqaEXqiNvqLaouvBOeF+Q==
X-Received: by 2002:a2e:998a:: with SMTP id w10mr2669446lji.152.1572209601393;
        Sun, 27 Oct 2019 13:53:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id k10sm4209867lfo.76.2019.10.27.13.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 13:53:20 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DF8B61818B8; Sun, 27 Oct 2019 21:53:19 +0100 (CET)
Subject: [PATCH bpf-next v3 4/4] selftests: Add tests for automatic map
 pinning
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Sun, 27 Oct 2019 21:53:19 +0100
Message-ID: <157220959980.48922.12100884213362040360.stgit@toke.dk>
In-Reply-To: <157220959547.48922.6623938299823744715.stgit@toke.dk>
References: <157220959547.48922.6623938299823744715.stgit@toke.dk>
User-Agent: StGit/0.20
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds a new BPF selftest to exercise the new automatic map pinning
code.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/prog_tests/pinning.c |   91 ++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_pinning.c |   29 +++++++
 2 files changed, 120 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/pinning.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_pinning.c

diff --git a/tools/testing/selftests/bpf/prog_tests/pinning.c b/tools/testing/selftests/bpf/prog_tests/pinning.c
new file mode 100644
index 000000000000..d4a63de72f5a
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/pinning.c
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <test_progs.h>
+
+__u32 get_map_id(struct bpf_object *obj, const char *name)
+{
+	__u32 map_info_len, duration, retval;
+	struct bpf_map_info map_info = {};
+	struct bpf_map *map;
+	int err;
+
+	map_info_len = sizeof(map_info);
+
+	map = bpf_object__find_map_by_name(obj, name);
+	if (!CHECK(!map, "find map", "NULL map")) {
+		err = bpf_obj_get_info_by_fd(bpf_map__fd(map),
+					     &map_info, &map_info_len);
+		CHECK(err, "get map info", "err %d errno %d", err, errno);
+		return map_info.id;
+	}
+	return 0;
+}
+
+void test_pinning(void)
+{
+	__u32 duration, retval, size, map_id, map_id2;
+	const char *custpinpath = "/sys/fs/bpf/custom/pinmap";
+	const char *nopinpath = "/sys/fs/bpf/nopinmap";
+	const char *custpath = "/sys/fs/bpf/custom";
+	const char *pinpath = "/sys/fs/bpf/pinmap";
+	const char *file = "./test_pinning.o";
+	struct stat statbuf = {};
+	struct bpf_object *obj;
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
+		.auto_pin_path = custpath,
+	);
+
+	int err;
+	obj = bpf_object__open_file(file, NULL);
+	if (CHECK_FAIL(libbpf_get_error(obj)))
+		return;
+
+	err = bpf_object__load(obj);
+	CHECK(err, "default load", "err %d errno %d\n", err, errno);
+
+	/* check that pinmap was pinned */
+	err = stat(pinpath, &statbuf);
+	CHECK(err, "stat pinpath", "err %d errno %d\n", err, errno);
+
+        /* check that nopinmap was *not* pinned */
+	err = stat(nopinpath, &statbuf);
+	CHECK(errno != ENOENT, "stat nopinpath", "err %d errno %d\n", err, errno);
+
+        map_id = get_map_id(obj, "pinmap");
+	bpf_object__close(obj);
+
+	obj = bpf_object__open_file(file, NULL);
+	if (CHECK_FAIL(libbpf_get_error(obj)))
+		return;
+
+	err = bpf_object__load(obj);
+	CHECK(err, "default load", "err %d errno %d\n", err, errno);
+
+	/* check that same map ID was reused for second load */
+	map_id2 = get_map_id(obj, "pinmap");
+	CHECK(map_id != map_id2, "check reuse",
+	      "err %d errno %d id %d id2 %d\n", err, errno, map_id, map_id2);
+	unlink(pinpath);
+	bpf_object__close(obj);
+
+	err = mkdir(custpath, 0700);
+	CHECK(err, "mkdir custpath",  "err %d errno %d\n", err, errno);
+
+	obj = bpf_object__open_file(file, &opts);
+	if (CHECK_FAIL(libbpf_get_error(obj)))
+		return;
+
+	err = bpf_object__load(obj);
+	CHECK(err, "custom load", "err %d errno %d\n", err, errno);
+
+	/* check that pinmap was pinned at the custom path */
+	err = stat(custpinpath, &statbuf);
+	CHECK(err, "stat custpinpath", "err %d errno %d\n", err, errno);
+
+	unlink(custpinpath);
+	rmdir(custpath);
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_pinning.c b/tools/testing/selftests/bpf/progs/test_pinning.c
new file mode 100644
index 000000000000..ff2d7447777e
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_pinning.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+int _version SEC("version") = 1;
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+	__uint(pinning, LIBBPF_PIN_BY_NAME);
+} pinmap SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+} nopinmap SEC(".maps");
+
+SEC("xdp_prog")
+int _xdp_prog(struct xdp_md *xdp)
+{
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";

