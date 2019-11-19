Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B02B9102CA7
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 20:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfKSTbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 14:31:09 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:56968 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727578AbfKSTbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 14:31:07 -0500
Received: by mail-pl1-f201.google.com with SMTP id x11so13671499plr.23
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 11:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vOGdWKkLZw+fnwsKztc5Xhx6sgiytcIM3uQq3wSpoPY=;
        b=fD0abG5cMWtSthF8awD7gX4qx8kK59gTADR0EBrVD3nGRiZz614u+uZbjqr8zK9cVB
         x/tmy4rL3RFbOn3vTIO0GRrW4g86Py4+f3LKH9m5b79UdcN7Hu3WOK6fJO3gsjGNPpoD
         ok32+N3PNMkNiHCZm3rWij8ThooSDjZL2xjqebbx/yezL5DUA54NVw2GSC1kyurUylUj
         51ZCEs2ivNGVNgWr7CWru9Aj9aKlZ05iUWE+P+HrutQITPGAJKiKvqWCU7RRLWZnInDM
         2MiNXX9sCX7QezWEE9D92nEoDLZ3HjlzLG8thxkQB15LGo9PG1F0XlHljRipxC/8sS0g
         W+YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vOGdWKkLZw+fnwsKztc5Xhx6sgiytcIM3uQq3wSpoPY=;
        b=DuiXJCeu6fN0FlXG8DvMWT4av7fhFI2QWmH784mWt4UdFtjDNSMB3DuZWbK6FH6TuV
         WIevt5fZWjmgdxCsI+d0GppvNV6xe29iTMvZ9CZibaPv31j6pH03+YYAtnYMK+flEDoH
         IUPfvDRl6NWL1dmjQkhpzg6T9LrTAr+Iiao9m2/8RCyOv86kQgBntdNergRjI2YxxBqa
         UKW5xX6sxIdhR1bTuw8nUY4VNse1QvCHPqP3vBdCh46T3Q1JEcHl4ZMu7mYhC/WLQ867
         10zR1tRrNik8X8+fuU2Bw+zwmkM87YvDOTosFykQ8+QuSNg6gxjUho535gMC1QgJyoKA
         6VBQ==
X-Gm-Message-State: APjAAAVJ6FJhsGrf/LWdayJAwt0VKls92aSVZHPxjsKRnczfxFuglNln
        Tsr449a91wvC/itxfnngVL1h5IrMoHdL
X-Google-Smtp-Source: APXvYqyso4pIsRCIKj+mbEI/YKn/Jx2s4xp+YSqDX8EfM1n3NV90GXmXRfHtR/JpSzL7iTSU3F76PyGumonF
X-Received: by 2002:a63:596:: with SMTP id 144mr7644456pgf.207.1574191866162;
 Tue, 19 Nov 2019 11:31:06 -0800 (PST)
Date:   Tue, 19 Nov 2019 11:30:36 -0800
In-Reply-To: <20191119193036.92831-1-brianvv@google.com>
Message-Id: <20191119193036.92831-10-brianvv@google.com>
Mime-Version: 1.0
References: <20191119193036.92831-1-brianvv@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v2 bpf-next 9/9] selftests/bpf: add batch ops testing to array
 bpf map
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>, Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Brian Vazquez <brianvv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested bpf_map_lookup_batch() and bpf_map_update_batch()
functionality.

  $ ./test_maps
      ...
        test_map_lookup_and_delete_batch_array:PASS
      ...

Signed-off-by: Brian Vazquez <brianvv@google.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../map_lookup_and_delete_batch_array.c       | 119 ++++++++++++++++++
 1 file changed, 119 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_array.c

diff --git a/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_array.c b/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_array.c
new file mode 100644
index 0000000000000..cbec72ad38609
--- /dev/null
+++ b/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_array.c
@@ -0,0 +1,119 @@
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
+
+	for (i = 0; i < max_entries; i++) {
+		keys[i] = i;
+		values[i] = i + 1;
+	}
+
+	err = bpf_map_update_batch(map_fd, keys, values, &max_entries, 0, 0);
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
+void test_map_lookup_and_delete_batch_array(void)
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
+	int err, i, step;
+	bool nospace_err;
+	__u64 batch = 0;
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
+		memset(keys, 0, max_entries * sizeof(*keys));
+		memset(values, 0, max_entries * sizeof(*values));
+		batch = 0;
+		total = 0;
+		i = 0;
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
+						&count, 0, 0);
+
+			CHECK((err && errno != ENOENT), "lookup with steps",
+			      "error: %s\n", strerror(errno));
+
+			total += count;
+
+			if (err)
+				break;
+
+			i++;
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
+}
-- 
2.24.0.432.g9d3f5f5b63-goog

