Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D02ED11BFED
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfLKWfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:35:00 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:45919 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbfLKWe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 17:34:56 -0500
Received: by mail-pg1-f201.google.com with SMTP id q1so195453pge.12
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 14:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8o/gH5+XtBu0HLbIWnLVKRhI0lP1MZucRfi5Tmg/xRY=;
        b=Eyd6oFgU0FP4KZyu8nqFCWnRZchPcb0LpmERtUx8e1gv/ydKT7FXBUchFFk5qH/fDd
         TUT8iNU4a5QqDEtbaZEellLni1I9USQJ6xlATerYxYrzSYIptvHfZNhdF2Ecz9l+Z4tU
         5Kp4DwPpwv2SqPfTeKp20p1EM9TajUbTZdzjiHQLUfNFWNHoOrmZD7PrkigIK1JyWgyF
         90a2VBoKQTotfyBC5IMlcpGcAtGCyJpFeqRMRrxHGTkirubWd0VJzxUB+sNrpRgQHlV/
         Xrf981ANJGJO/S+gxji7MUi+7DPadyY8vsFjrmkPj3Ppz4SOL52BIg2v3CpEFwji4uER
         16zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8o/gH5+XtBu0HLbIWnLVKRhI0lP1MZucRfi5Tmg/xRY=;
        b=YBHtYCe8u/c4rVHXBwpYAcnzjYMAdxwC2pB12WEKr8fWh7fqzZCS4TNOulCRXySu2O
         CB82ipU+xJN7W/kR8LBdwA0aVVd0ndwvQlB2UIEBUk5xX3xkqVC5x6dgM1l52qT+pSSP
         qX2xT/MzWsIP7Ndomk5RKgY6T6E28Qt0Qk6DbU+u3rk0SPt86DI2Z8eyCA3wH2HUxzYC
         4qCooRj3xiqPj2Kn17puhQ4joHAGU7aohPoYTFPPex3Yjjd3rbEKcEzxZFDPS9xkVYkB
         X1XhPOTLSgt9JN3Ey9NtwhjxSoLP5MS5BPAnoZ/bTHPynlIXa/KiQYwgAVkuO+2zaThd
         utOQ==
X-Gm-Message-State: APjAAAXA4ai90xH1MxzJc8bAZCIOexn5Iikm355VJum/x5fAjJFwuuUM
        LD+dbg1RJjh11do4nWVKB6hYud28YRZW
X-Google-Smtp-Source: APXvYqxObxrz8PVMK/qpJIMpBiWoG4fHVWKf1Xe97COULRdaIlJkya4XQdXiB7u3TErXYh4FybcBGTvSThHh
X-Received: by 2002:a63:647:: with SMTP id 68mr6841026pgg.202.1576103695389;
 Wed, 11 Dec 2019 14:34:55 -0800 (PST)
Date:   Wed, 11 Dec 2019 14:33:44 -0800
In-Reply-To: <20191211223344.165549-1-brianvv@google.com>
Message-Id: <20191211223344.165549-12-brianvv@google.com>
Mime-Version: 1.0
References: <20191211223344.165549-1-brianvv@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH v3 bpf-next 11/11] selftests/bpf: add batch ops testing to
 lpm_trie bpf map
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>, Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested bpf_map_batch_ops functionality.

  $ ./test_maps
  ...
  test_trie_map_batch_ops:PASS
  ...

Signed-off-by: Brian Vazquez <brianvv@google.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../bpf/map_tests/trie_map_batch_ops.c        | 235 ++++++++++++++++++
 1 file changed, 235 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/map_tests/trie_map_batch_ops.c

diff --git a/tools/testing/selftests/bpf/map_tests/trie_map_batch_ops.c b/tools/testing/selftests/bpf/map_tests/trie_map_batch_ops.c
new file mode 100644
index 0000000000000..927e898bea2d0
--- /dev/null
+++ b/tools/testing/selftests/bpf/map_tests/trie_map_batch_ops.c
@@ -0,0 +1,235 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+#include <arpa/inet.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include <bpf_util.h>
+#include <test_maps.h>
+
+static void map_batch_update(int map_fd, __u32 max_entries)
+{
+	int i, err;
+	struct bpf_lpm_trie_key *key_helper;
+	void *key, *values;
+	size_t key_size;
+
+	key_size = sizeof(*key_helper) + sizeof(__u32);
+	key = alloca(max_entries * key_size);
+	values = alloca(max_entries * sizeof(int));
+
+	for (i = 0; i < max_entries; i++) {
+		key_helper = (struct bpf_lpm_trie_key *)(key + i * key_size);
+		inet_pton(AF_INET, "192.168.0.0", key_helper->data);
+		key_helper->data[3] = i;
+		key_helper->prefixlen = 16 + i;
+		((int *)values)[i] = i + 1;
+	}
+
+	err = bpf_map_update_batch(map_fd, key, values, &max_entries, 0, 0);
+	CHECK(err, "bpf_map_update_batch()", "error:%s\n", strerror(errno));
+}
+
+static void map_batch_verify(int *visited, __u32 max_entries,
+			     void *keys, void *values)
+{
+	struct bpf_lpm_trie_key *key;
+	size_t key_size;
+	int i;
+
+	memset(visited, 0, max_entries * sizeof(*visited));
+	key_size = sizeof(*key) + sizeof(__u32);
+
+	for (i = 0; i < max_entries; i++) {
+		key = keys + i * key_size;
+		CHECK(key->data[3] + 1 != ((int *)values)[i],
+		      "key/value checking",
+		      "error: i %d key %d.%d.%d.%d value %d\n", i, key->data[0],
+		      key->data[1], key->data[2], key->data[3],
+		      ((int *)values)[i]);
+
+		visited[i] = 1;
+
+	}
+	for (i = 0; i < max_entries; i++) {
+		CHECK(visited[i] != 1, "visited checking",
+		      "error: keys array at index %d missing\n", i);
+	}
+}
+
+void __test_trie_map_lookup_and_delete_batch(void)
+{
+	struct bpf_lpm_trie_key *batch, *key_p;
+	size_t key_size = sizeof(*key_p) + sizeof(__u32);
+	struct bpf_create_map_attr xattr = {
+		.name = "lpm_trie_map",
+		.map_type = BPF_MAP_TYPE_LPM_TRIE,
+		.key_size = key_size,
+		.value_size = sizeof(int),
+	};
+	__u32 count, total, total_success;
+	const __u32 max_entries = 10;
+	int map_fd, *visited, key;
+	int err, i, step;
+	int *values;
+	void *keys;
+
+	xattr.max_entries = max_entries;
+	xattr.map_flags = BPF_F_NO_PREALLOC;
+	map_fd = bpf_create_map_xattr(&xattr);
+	CHECK(map_fd == -1,
+	      "bpf_create_map_xattr()", "error:%s\n", strerror(errno));
+
+	keys = malloc(max_entries * key_size);
+	batch = malloc(key_size);
+	values = malloc(max_entries * sizeof(int));
+	visited = malloc(max_entries * sizeof(int));
+	CHECK(!keys || !values || !visited, "malloc()",
+	      "error:%s\n", strerror(errno));
+
+	/* test 1: lookup/delete an empty hash table, -ENOENT */
+	count = max_entries;
+	err = bpf_map_lookup_and_delete_batch(map_fd, NULL, batch, keys,
+					      values, &count, 0, 0);
+	CHECK((err && errno != ENOENT), "empty map",
+	      "error: %s\n", strerror(errno));
+
+	/* populate elements to the map */
+	map_batch_update(map_fd, max_entries);
+
+	/* test 2: lookup/delete with count = 0, success */
+	count = 0;
+	err = bpf_map_lookup_and_delete_batch(map_fd, NULL, batch, keys,
+					      values, &count, 0, 0);
+	CHECK(err, "count = 0", "error: %s\n", strerror(errno));
+
+	/* test 3: lookup/delete with count = max_entries, success */
+	memset(keys, 0, max_entries * key_size);
+	memset(values, 0, max_entries * sizeof(int));
+	count = max_entries;
+	err = bpf_map_lookup_and_delete_batch(map_fd, NULL, batch, keys,
+					      values, &count, 0, 0);
+	CHECK((err && errno != ENOENT), "count = max_entries",
+	       "error: %s\n", strerror(errno));
+	CHECK(count != max_entries, "count = max_entries",
+	      "count = %u, max_entries = %u\n", count, max_entries);
+	map_batch_verify(visited, max_entries, keys, values);
+
+	/* bpf_map_get_next_key() should return -ENOENT for an empty map. */
+	err = bpf_map_get_next_key(map_fd, NULL, &key);
+	CHECK(!err, "bpf_map_get_next_key()", "error: %s\n", strerror(errno));
+
+	/* test 4: lookup/delete in a loop with various steps. */
+	total_success = 0;
+	for (step = 4; step < max_entries; step++) {
+		map_batch_update(map_fd, max_entries);
+		memset(keys, 0, max_entries * key_size);
+		memset(values, 0, max_entries * sizeof(int));
+		total = 0;
+		/* iteratively lookup elements with 'step'
+		 * elements each
+		 */
+		count = step;
+		while (true) {
+			err = bpf_map_lookup_batch(map_fd,
+						   total ? batch : NULL,
+						   batch,
+						   keys + total * key_size,
+						   values + total,
+						   &count, 0, 0);
+			/* It is possible that we are failing due to buffer size
+			 * not big enough. In such cases, let us just exit and
+			 * go with large steps. Not that a buffer size with
+			 * max_entries should always work.
+			 */
+			CHECK((err && errno != ENOENT), "lookup with steps",
+			      "error: %s\n", strerror(errno));
+
+			total += count;
+			if (err)
+				break;
+		}
+
+		CHECK(total != max_entries, "lookup with steps",
+		      "total = %u, max_entries = %u\n", total, max_entries);
+		map_batch_verify(visited, max_entries, keys, values);
+
+		total = 0;
+		while (true) {
+			err = bpf_map_delete_batch(map_fd,
+						   keys + total * key_size,
+						   &count, 0, 0);
+			/* It is possible that we are failing due to buffer size
+			 * not big enough. In such cases, let us just exit and
+			 * go with large steps. Not that a buffer size with
+			 * max_entries should always work.
+			 */
+			CHECK((err && errno != ENOENT), "lookup with steps",
+			      "error: %s\n", strerror(errno));
+			total += count;
+			if (err)
+				break;
+		}
+
+		CHECK(total != max_entries, "delete with steps",
+		      "total = %u, max_entries = %u\n", total, max_entries);
+
+		/* check map is empty, errno == -ENOENT */
+		err = bpf_map_get_next_key(map_fd, NULL, keys);
+		CHECK(!err || errno != ENOENT, "bpf_map_get_next_key()",
+		      "error: %s\n", strerror(errno));
+
+		map_batch_update(map_fd, max_entries);
+		memset(keys, 0, max_entries * key_size);
+		memset(values, 0, max_entries * sizeof(int));
+		total = 0;
+		i = 0;
+		/* iteratively lookup/delete elements with 'step'
+		 * elements each
+		 */
+		count = step;
+		while (true) {
+			err = bpf_map_lookup_and_delete_batch(map_fd,
+							total ? batch : NULL,
+							batch,
+							keys + total * key_size,
+							values + total,
+							&count, 0, 0);
+
+			CHECK((err && errno != ENOENT), "lookup with steps",
+			      "error: %s\n", strerror(errno));
+
+			total += count;
+			if (err)
+				break;
+			i++;
+		}
+
+		CHECK(total != max_entries, "lookup/delete with steps",
+		      "total = %u, max_entries = %u\n", total, max_entries);
+
+		map_batch_verify(visited, max_entries, keys, values);
+		err = bpf_map_get_next_key(map_fd, NULL, &key);
+		CHECK(!err, "bpf_map_get_next_key()", "error: %s\n",
+		      strerror(errno));
+
+		total_success++;
+	}
+
+	CHECK(total_success == 0, "check total_success",
+	      "unexpected failure\n");
+}
+
+void trie_map_batch_ops(void)
+{
+	__test_trie_map_lookup_and_delete_batch();
+	printf("test_%s:PASS\n", __func__);
+}
+
+void test_trie_map_batch_ops(void)
+{
+	trie_map_batch_ops();
+}
-- 
2.24.1.735.g03f4e72817-goog

