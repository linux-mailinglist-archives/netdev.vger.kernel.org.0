Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 081F613CC61
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 19:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbgAOSnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 13:43:47 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:43092 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729457AbgAOSnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 13:43:45 -0500
Received: by mail-pg1-f201.google.com with SMTP id d9so10801755pgd.10
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 10:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CjoqkXpvMMXTZKEQf/w0i8b/juoj1r/E3J2QNyeJ/9M=;
        b=TqC5xz12UjURima8lfp1XbZtXfz5BlbKfHLb2rtwpYfKXcWnW1o/E0/a79pp6vPt86
         bSy4ScDBNz2cQpHVG8SM55ZnATHhNBSHfaZe/x8JQM5OgMTOKq/iuNqAOuPi0TWhhQNr
         rN/EqE86buKkiMeX/zrNcG8h9rjJt+XInft1rm5tA4zfYaVQpmiBEi3VFxfpETEiS3Rr
         SIenzw0Yd04dIXL7p8WgcNWZRPe+dBVtBCa8pcSXF6WnDqDeEi44xszrKW4NT9zkySmN
         Zaba+4T+olDYco+0wuUZcnDi1U1/VO05mBXM66N609TMTnFcACohqtJQz53c+3xau9L1
         e99Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CjoqkXpvMMXTZKEQf/w0i8b/juoj1r/E3J2QNyeJ/9M=;
        b=BWNM3xtoP4UOFC6HOjbCQ1Vs8Z4IOwt2S34MWC2og0zITdvSxm8AeqWqpnlMe8o3Kd
         /oyUbDnIO97lDHYyZypiiH1p57iCF7/j9em/aqgXe+AaKH1K+BNKQfEPwh6QmANC+9Y4
         C73ZX9XMkVw0FbvUrFqrSq//8F8mAcukFef17AyfWA3zLx5+DQp3tgXDtWWNTB4vc6N/
         W+ThnHzOtYpt1L9dK9ULsVFIBgPmfMwLeAuA+PSUQp+sOAns/KUwAB8kDyiXjFm1LESk
         Yrtmwka3YpRQhqebzJvQfz9M4V7PpJAK7PrCQyRMyA3TxgGIgxwMOvKGoeXsijThBwm1
         WR2A==
X-Gm-Message-State: APjAAAUCOz2FSuDH6kpsUxaWXnyW5wEHlO3tBDO9byoWbPpq8dvfUMqk
        RbiZY+H5jYBJbZohpHjTpy6c4Wlmnfhs
X-Google-Smtp-Source: APXvYqycDVWqkbUZr8RQhY8T/gDGCqw3Zs5lR9QZEKkr7AtGovXy64qQcceBV2uWlcb4hOFSBkfp3MY1nHtd
X-Received: by 2002:a63:181:: with SMTP id 123mr33985878pgb.36.1579113824307;
 Wed, 15 Jan 2020 10:43:44 -0800 (PST)
Date:   Wed, 15 Jan 2020 10:43:08 -0800
In-Reply-To: <20200115184308.162644-1-brianvv@google.com>
Message-Id: <20200115184308.162644-10-brianvv@google.com>
Mime-Version: 1.0
References: <20200115184308.162644-1-brianvv@google.com>
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH v5 bpf-next 9/9] selftests/bpf: add batch ops testing to array
 bpf map
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested bpf_map_lookup_batch() and bpf_map_update_batch()
functionality.

  $ ./test_maps
      ...
        test_array_map_batch_ops:PASS
      ...

Signed-off-by: Brian Vazquez <brianvv@google.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../bpf/map_tests/array_map_batch_ops.c       | 129 ++++++++++++++++++
 1 file changed, 129 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c

diff --git a/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c b/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
new file mode 100644
index 0000000000000..f0a64d8ac59a5
--- /dev/null
+++ b/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include <test_maps.h>
+
+static void map_batch_update(int map_fd, __u32 max_entries, int *keys,
+			     int *values)
+{
+	int i, err;
+	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
+		.elem_flags = 0,
+		.flags = 0,
+	);
+
+	for (i = 0; i < max_entries; i++) {
+		keys[i] = i;
+		values[i] = i + 1;
+	}
+
+	err = bpf_map_update_batch(map_fd, keys, values, &max_entries, &opts);
+	CHECK(err, "bpf_map_update_batch()", "error:%s\n", strerror(errno));
+}
+
+static void map_batch_verify(int *visited, __u32 max_entries,
+			     int *keys, int *values)
+{
+	int i;
+
+	memset(visited, 0, max_entries * sizeof(*visited));
+	for (i = 0; i < max_entries; i++) {
+		CHECK(keys[i] + 1 != values[i], "key/value checking",
+		      "error: i %d key %d value %d\n", i, keys[i], values[i]);
+		visited[i] = 1;
+	}
+	for (i = 0; i < max_entries; i++) {
+		CHECK(visited[i] != 1, "visited checking",
+		      "error: keys array at index %d missing\n", i);
+	}
+}
+
+void test_array_map_batch_ops(void)
+{
+	struct bpf_create_map_attr xattr = {
+		.name = "array_map",
+		.map_type = BPF_MAP_TYPE_ARRAY,
+		.key_size = sizeof(int),
+		.value_size = sizeof(int),
+	};
+	int map_fd, *keys, *values, *visited;
+	__u32 count, total, total_success;
+	const __u32 max_entries = 10;
+	bool nospace_err;
+	__u64 batch = 0;
+	int err, step;
+	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
+		.elem_flags = 0,
+		.flags = 0,
+	);
+
+	xattr.max_entries = max_entries;
+	map_fd = bpf_create_map_xattr(&xattr);
+	CHECK(map_fd == -1,
+	      "bpf_create_map_xattr()", "error:%s\n", strerror(errno));
+
+	keys = malloc(max_entries * sizeof(int));
+	values = malloc(max_entries * sizeof(int));
+	visited = malloc(max_entries * sizeof(int));
+	CHECK(!keys || !values || !visited, "malloc()", "error:%s\n",
+	      strerror(errno));
+
+	/* populate elements to the map */
+	map_batch_update(map_fd, max_entries, keys, values);
+
+	/* test 1: lookup in a loop with various steps. */
+	total_success = 0;
+	for (step = 1; step < max_entries; step++) {
+		map_batch_update(map_fd, max_entries, keys, values);
+		map_batch_verify(visited, max_entries, keys, values);
+		memset(keys, 0, max_entries * sizeof(*keys));
+		memset(values, 0, max_entries * sizeof(*values));
+		batch = 0;
+		total = 0;
+		/* iteratively lookup/delete elements with 'step'
+		 * elements each.
+		 */
+		count = step;
+		nospace_err = false;
+		while (true) {
+			err = bpf_map_lookup_batch(map_fd,
+						total ? &batch : NULL, &batch,
+						keys + total,
+						values + total,
+						&count, &opts);
+
+			CHECK((err && errno != ENOENT), "lookup with steps",
+			      "error: %s\n", strerror(errno));
+
+			total += count;
+			if (err)
+				break;
+
+		}
+
+		if (nospace_err == true)
+			continue;
+
+		CHECK(total != max_entries, "lookup with steps",
+		      "total = %u, max_entries = %u\n", total, max_entries);
+
+		map_batch_verify(visited, max_entries, keys, values);
+
+		total_success++;
+	}
+
+	CHECK(total_success == 0, "check total_success",
+	      "unexpected failure\n");
+
+	printf("%s:PASS\n", __func__);
+
+	free(keys);
+	free(values);
+	free(visited);
+}
-- 
2.25.0.rc1.283.g88dfdc4193-goog

