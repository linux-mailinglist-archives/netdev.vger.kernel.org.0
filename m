Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57BC21CA946
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 13:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgEHLLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 07:11:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47843 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727995AbgEHLLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 07:11:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588936296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bOIT+50UaskstZKzUohgylRkHvdR91qp4pnNKr6BjiM=;
        b=fjVtWBTwn/OClE5gVbyksolb307e4yoeZj9F+80OySO7DW0r0W46qaaERRI9JmXY5xwRPg
        +Uh4Rjr7+xE4DQ6pSSj1CPMz5/3ZKPNlFyAv4ogKaIKvQdE8+dVaFr1rUQBW5kxO/RhI9k
        7YllEuSFA1YLrzPPclkzKsctgBofsPU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-H0Tb5uKRNWKidBY3CtbQRg-1; Fri, 08 May 2020 07:11:32 -0400
X-MC-Unique: H0Tb5uKRNWKidBY3CtbQRg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38A921005510;
        Fri,  8 May 2020 11:11:30 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5F02649D5;
        Fri,  8 May 2020 11:11:29 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id BA54E300020FB;
        Fri,  8 May 2020 13:11:28 +0200 (CEST)
Subject: [PATCH net-next v3 32/33] selftests/bpf: adjust BPF selftest for
 xdp_adjust_tail
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Date:   Fri, 08 May 2020 13:11:28 +0200
Message-ID: <158893628868.2321140.6908513247514543586.stgit@firesoul>
In-Reply-To: <158893607924.2321140.16117992313983615627.stgit@firesoul>
References: <158893607924.2321140.16117992313983615627.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current selftest for BPF-helper xdp_adjust_tail only shrink tail.
Make it more clear that this is a shrink test case.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |    9 +++++-
 .../testing/selftests/bpf/progs/test_adjust_tail.c |   30 --------------------
 .../bpf/progs/test_xdp_adjust_tail_shrink.c        |   30 ++++++++++++++++++++
 3 files changed, 37 insertions(+), 32 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/progs/test_adjust_tail.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_shrink.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
index 3744196d7cba..d258f979d5ef 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
@@ -1,9 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
 
-void test_xdp_adjust_tail(void)
+void test_xdp_adjust_tail_shrink(void)
 {
-	const char *file = "./test_adjust_tail.o";
+	const char *file = "./test_xdp_adjust_tail_shrink.o";
 	struct bpf_object *obj;
 	char buf[128];
 	__u32 duration, retval, size;
@@ -27,3 +27,8 @@ void test_xdp_adjust_tail(void)
 	      err, errno, retval, size);
 	bpf_object__close(obj);
 }
+
+void test_xdp_adjust_tail(void)
+{
+	test_xdp_adjust_tail_shrink();
+}
diff --git a/tools/testing/selftests/bpf/progs/test_adjust_tail.c b/tools/testing/selftests/bpf/progs/test_adjust_tail.c
deleted file mode 100644
index b7fc85769bdc..000000000000
--- a/tools/testing/selftests/bpf/progs/test_adjust_tail.c
+++ /dev/null
@@ -1,30 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Copyright (c) 2018 Facebook
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of version 2 of the GNU General Public
- * License as published by the Free Software Foundation.
- */
-#include <linux/bpf.h>
-#include <linux/if_ether.h>
-#include <bpf/bpf_helpers.h>
-
-int _version SEC("version") = 1;
-
-SEC("xdp_adjust_tail")
-int _xdp_adjust_tail(struct xdp_md *xdp)
-{
-	void *data_end = (void *)(long)xdp->data_end;
-	void *data = (void *)(long)xdp->data;
-	int offset = 0;
-
-	if (data_end - data == 54)
-		offset = 256;
-	else
-		offset = 20;
-	if (bpf_xdp_adjust_tail(xdp, 0 - offset))
-		return XDP_DROP;
-	return XDP_TX;
-}
-
-char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_shrink.c b/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_shrink.c
new file mode 100644
index 000000000000..c8a7c17b54f4
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_shrink.c
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0
+ * Copyright (c) 2018 Facebook
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+#include <linux/bpf.h>
+#include <linux/if_ether.h>
+#include <bpf/bpf_helpers.h>
+
+int _version SEC("version") = 1;
+
+SEC("xdp_adjust_tail_shrink")
+int _xdp_adjust_tail_shrink(struct xdp_md *xdp)
+{
+	void *data_end = (void *)(long)xdp->data_end;
+	void *data = (void *)(long)xdp->data;
+	int offset = 0;
+
+	if (data_end - data == 54) /* sizeof(pkt_v4) */
+		offset = 256; /* shrink too much */
+	else
+		offset = 20;
+	if (bpf_xdp_adjust_tail(xdp, 0 - offset))
+		return XDP_DROP;
+	return XDP_TX;
+}
+
+char _license[] SEC("license") = "GPL";


