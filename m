Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4C74F116
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 01:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbfFUXRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 19:17:25 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:37717 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbfFUXRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 19:17:11 -0400
Received: by mail-yb1-f201.google.com with SMTP id z4so7391778ybo.4
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 16:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rj82FQVe1sxehS1oKg3PuFxZ1lm7MWUrxe2hdxNBH9E=;
        b=ejwl+xG1axIiX3s05MG5iOCBdiQJwCRP/hHzUbUllzw29ytDqE0pElJwSom0wYfra5
         5MjJoFegVuAk+nZ+WyyCb71ze2pMC/TRJ/yaPQoExGYuQt73bUOo2qzqrLCjSbZ9QeUs
         tNhEJ+I+L7smjvdoVUqOaTJWHTryAq4t1n6bGYN4pk6vL9lkBW7uwFAn1/BafF6fsSQ7
         1oMc0vxtdOeh7BS+RnQxScDeREIzxslQIhUVwQzTFrzGrV05ok6Ctx2+dCbswF8vSUvO
         /3WICH5e7MoPGRoXCWn6Vfsi9QxwkjH37852nSbRIT6TEeJGIyJKnDktMvggJfpn8OZe
         5a3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rj82FQVe1sxehS1oKg3PuFxZ1lm7MWUrxe2hdxNBH9E=;
        b=VMphY2bXqhXeLE0+z6BA2trHkRPvPw+uPR/rG37mccZ/cF/YEomqEEC2mJ7q4vTglW
         baMOlz102/7gvrLW4QED8WPpgqGwImrfXvOVQjn8dm7ERUSl2SSBWHQQccFa6CY1Aj9z
         isb1zr3X+xZRXyouwjslseooXKbOgVgbnV3s7tt6XJ/aigOPA7sJqiYNBdB1lOR+jGAi
         8Hg4oRLLACgzqbFya83bKb6ENOoI/JagkVUMTc+VorJ+vubRnNDe3MkNFJoHsmHVb6zi
         ZNBGqnGFGoNFdZW1fu9v/IFJCLi7OM5u5Hl71g3oelBT9EPgWl4BSYIbLy0BQYHZzs+4
         yHDQ==
X-Gm-Message-State: APjAAAXiu62C50VRfx2AM2zyJdEjTWn0qL52VEo3b8SCzNWl4b4tM4Dx
        G6mJAs/Ux8aoOgk/gSyBqq/5BoT81uPv
X-Google-Smtp-Source: APXvYqwnZIYW8EbMmvFA3ezPe/btCstszKmgy97/QK5tX6I3VWoMKPPbHx4CxRSv6t2Xwc8Z0LcuzBuSxgCt
X-Received: by 2002:a0d:e1c1:: with SMTP id k184mr67567296ywe.153.1561159030572;
 Fri, 21 Jun 2019 16:17:10 -0700 (PDT)
Date:   Fri, 21 Jun 2019 16:16:49 -0700
In-Reply-To: <20190621231650.32073-1-brianvv@google.com>
Message-Id: <20190621231650.32073-6-brianvv@google.com>
Mime-Version: 1.0
References: <20190621231650.32073-1-brianvv@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [RFC PATCH 5/6] selftests/bpf: test BPF_MAP_DUMP command on a bpf hashmap
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
 tools/testing/selftests/bpf/test_maps.c | 70 ++++++++++++++++++++++++-
 1 file changed, 68 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index a3fbc571280a9..3df72b46fd1d9 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -309,6 +309,73 @@ static void test_hashmap_walk(unsigned int task, void *data)
 	close(fd);
 }
 
+static void test_hashmap_dump(void)
+{
+	int fd, i, max_entries = 3;
+	uint64_t keys[max_entries], values[max_entries];
+	uint64_t key, value, next_key;
+	bool next_key_valid = true;
+	void *buf, *elem, *prev_key;
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
+	prev_key = NULL;
+	i = 0;
+	assert(bpf_map_dump(fd, prev_key, buf, &buf_len) == 0 &&
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
+	/* Continue reading from map and verify buf_len only contains 1 element
+	 * even though buf_len is 2 elem_size.
+	 */
+	prev_key = elem;
+	assert(bpf_map_dump(fd, prev_key, buf, &buf_len) == 0 &&
+	       buf_len == elem_size);
+	elem = buf;
+	assert((*(uint64_t *)elem) == keys[i] &&
+	       (*(uint64_t *)(elem + sizeof(key))) == values[i]);
+
+	// Check that there are no more entries after last_key
+	prev_key = &keys[i];
+	assert(bpf_map_dump(fd, prev_key, buf, &buf_len) == -1 &&
+	       errno == ENOENT);
+
+	free(buf);
+	close(fd);
+}
+
 static void test_hashmap_zero_seed(void)
 {
 	int i, first, second, old_flags;
@@ -1668,6 +1735,7 @@ static void run_all_tests(void)
 	test_hashmap_percpu(0, NULL);
 	test_hashmap_walk(0, NULL);
 	test_hashmap_zero_seed();
+	test_hashmap_dump();
 
 	test_arraymap(0, NULL);
 	test_arraymap_percpu(0, NULL);
@@ -1705,11 +1773,9 @@ int main(void)
 
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
2.22.0.410.gd8fdbe21b5-goog

