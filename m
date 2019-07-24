Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C71A73467
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 18:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387661AbfGXQ6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 12:58:53 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:43568 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728533AbfGXQ6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 12:58:39 -0400
Received: by mail-pg1-f201.google.com with SMTP id p29so20463782pgm.10
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 09:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1tJN/OG1NU+LcE8k1olHxJVBbmDDdzToejoDtp6IxoE=;
        b=ttSizfIUX852pbuQqkoRYrU31qBiP2arQzJJnPHCO8oLFLDMyA4R8eilHNC1gUbyMc
         LVaegQTPgggspcFsqbfxXy3tWH5yB8LBw5YDmMqXtTJBYMDZt1doXnY9KyoDv9kwJgcR
         DmLo4m72uamj1T7sqJxj7DrhkVqZWjAzDRcaexno9w6tfTbzxV2ZIAQZgbZC+SuzTALZ
         W6qPhnzQa67Xp87AeTIhvus9AQS1PrShJzeh6E7LPcn8yHJwKJ9v08ccpkRsS18zNxlD
         cmjASiRla7C+k6xKVn/HdqMICDTqqkgZGxY36QcePw9WbXmAom8WrhVD0whs6Y+WGmt3
         nwRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1tJN/OG1NU+LcE8k1olHxJVBbmDDdzToejoDtp6IxoE=;
        b=Rg46XzRfHgykCS3ITGht9g0vqcaf7L8Wh14/TOk1fRaOv+xHRv5i0PwUjczStw7MrJ
         RCYpgatSjsGHvmA94qKfaYwoPXcFj4O+wSPUq2bRbfvvqY0fBvpeTAacIsXTO8n1zGUb
         m5u0z9588guIDTqNmvZB6CDra6kB/Y/unakfMqVdi/3hZS5tnCvgeBVl5G0sz9wgC2GA
         zYZXqDKtPuOIGf1hKEqv15JToDIF2yN0etqpi4H5K4nkDxcoWG1GJ0uj1QbA9BaG/GWF
         ctIrxnzMD19IQh21ztS8xFUwB1vCJOTZxQKOgPMj9ASOkM0l4Gy8KfbbCyckbVpfWQuk
         HyXw==
X-Gm-Message-State: APjAAAUVw/vhspJh3Af2D1gpoZxoqfX5H/FyPCgCzKI14xBxtiEHNB73
        02HIxjqk49ESA83xFJJUxQhXxRmWmVRg
X-Google-Smtp-Source: APXvYqyRPD/QPT5agrTZw3GtgEgVpkOaTvf+sUpcgn4birz1fO6FMoLqfdylzjJSnd352i20oIQQfL2Jns5c
X-Received: by 2002:a63:7455:: with SMTP id e21mr77221768pgn.439.1563987518569;
 Wed, 24 Jul 2019 09:58:38 -0700 (PDT)
Date:   Wed, 24 Jul 2019 09:58:02 -0700
In-Reply-To: <20190724165803.87470-1-brianvv@google.com>
Message-Id: <20190724165803.87470-6-brianvv@google.com>
Mime-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH bpf-next 5/6] selftests/bpf: test BPF_MAP_DUMP command on a
 bpf hashmap
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Brian Vazquez <brianvv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This tests exercise the new command on a bpf hashmap and make sure it
works as expected.

Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 tools/testing/selftests/bpf/test_maps.c | 83 ++++++++++++++++++++++++-
 1 file changed, 81 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 5443b9bd75ed7..f7ab401399d40 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -309,6 +309,86 @@ static void test_hashmap_walk(unsigned int task, void *data)
 	close(fd);
 }
 
+static void test_hashmap_dump(void)
+{
+	int fd, i, max_entries = 5;
+	uint64_t keys[max_entries], values[max_entries];
+	uint64_t key, value, next_key, prev_key;
+	bool next_key_valid = true;
+	void *buf, *elem;
+	u32 buf_len;
+	const int elem_size = sizeof(key) + sizeof(value);
+
+	fd = helper_fill_hashmap(max_entries);
+
+	// Get the elements in the hashmap, and store them in that order
+	assert(bpf_map_get_next_key(fd, NULL, &key) == 0);
+	i = 0;
+	keys[i] = key;
+	for (i = 1; next_key_valid; i++) {
+		next_key_valid = bpf_map_get_next_key(fd, &key, &next_key) == 0;
+		assert(bpf_map_lookup_elem(fd, &key, &values[i - 1]) == 0);
+		keys[i-1] = key;
+		key = next_key;
+	}
+
+	// Alloc memory for the whole table
+	buf = malloc(elem_size * max_entries);
+	assert(buf != NULL);
+
+	// Check that buf_len < elem_size returns EINVAL
+	buf_len = elem_size-1;
+	errno = 0;
+	assert(bpf_map_dump(fd, NULL, buf, &buf_len) == -1 && errno == EINVAL);
+
+	// Check that it returns the first two elements
+	errno = 0;
+	buf_len = elem_size * 2;
+	i = 0;
+	assert(bpf_map_dump(fd, NULL, buf, &buf_len) == 0 &&
+	       buf_len == 2*elem_size);
+	elem = buf;
+	assert((*(uint64_t *)elem) == keys[i] &&
+	       (*(uint64_t *)(elem + sizeof(key))) == values[i]);
+	elem = buf + elem_size;
+	i++;
+	assert((*(uint64_t *)elem) == keys[i] &&
+	       (*(uint64_t *)(elem + sizeof(key))) == values[i]);
+	i++;
+
+	/* Check that prev_key contains key from last_elem retrieved in previous
+	 * call
+	 */
+	prev_key = *((uint64_t *)elem);
+	assert(bpf_map_dump(fd, &prev_key, buf, &buf_len) == 0 &&
+	       buf_len == elem_size*2);
+	elem = buf;
+	assert((*(uint64_t *)elem) == keys[i] &&
+	       (*(uint64_t *)(elem + sizeof(key))) == values[i]);
+	elem = buf + elem_size;
+	i++;
+	assert((*(uint64_t *)elem) == keys[i] &&
+	       (*(uint64_t *)(elem + sizeof(key))) == values[i]);
+	i++;
+	assert(prev_key == (*(uint64_t *)elem));
+
+	/* Continue reading from map and verify buf_len only contains 1 element
+	 * even though buf_len is 2 elem_size and it returns err = 0.
+	 */
+	assert(bpf_map_dump(fd, &prev_key, buf, &buf_len) == 0 &&
+	       buf_len == elem_size);
+	elem = buf;
+	assert((*(uint64_t *)elem) == keys[i] &&
+	       (*(uint64_t *)(elem + sizeof(key))) == values[i]);
+
+	// Verify there's no more entries and err = ENOENT
+	assert(bpf_map_dump(fd, &prev_key, buf, &buf_len) == -1 &&
+	       errno == ENOENT);
+
+	free(buf);
+	close(fd);
+}
+
 static void test_hashmap_zero_seed(void)
 {
 	int i, first, second, old_flags;
@@ -1677,6 +1757,7 @@ static void run_all_tests(void)
 	test_hashmap_percpu(0, NULL);
 	test_hashmap_walk(0, NULL);
 	test_hashmap_zero_seed();
+	test_hashmap_dump();
 
 	test_arraymap(0, NULL);
 	test_arraymap_percpu(0, NULL);
@@ -1714,11 +1795,9 @@ int main(void)
 
 	map_flags = BPF_F_NO_PREALLOC;
 	run_all_tests();
-
 #define CALL
 #include <map_tests/tests.h>
 #undef CALL
-
 	printf("test_maps: OK, %d SKIPPED\n", skips);
 	return 0;
 }
-- 
2.22.0.657.g960e92d24f-goog

