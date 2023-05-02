Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686BC6F47C6
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbjEBPw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234657AbjEBPwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:52:38 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89455E43;
        Tue,  2 May 2023 08:52:26 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1ab032d9266so17107625ad.0;
        Tue, 02 May 2023 08:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683042746; x=1685634746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MpxzIylC0O+QIhlCGWKD1562wl2qGt79MOUaYG3771U=;
        b=IWkOuCvOvSOoHtlBSzvjbDpUQxZIqeICFKFK7IjyYu8QSSEcflrzUwbmC3H9jFisyY
         TsygpRduFfFgGV1KCq+Zut9vPsumgJOwoyq4GwsfDBuBbsUQ9cmx9DFiQoChQVxPfc3f
         QwNp8YBRFmSLRaV2l4h9IXmEJl3KPu6Ak3QF4mQ3WeVz6kmeJxW+hloa809NM2daZMJ4
         FFg/UCsWq2cL98E09LWeKPZv0ikkw5cKEILV1/zbRjDTw3MxZKu1RsG4GE7s7EmfVKCI
         BVAuh/EJM5P/i7tEDUAiMITQbfNpeiDa6v1ENzRzVRx9LdVUyhA/712tBA5GCtW4e9Jm
         wbLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683042746; x=1685634746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MpxzIylC0O+QIhlCGWKD1562wl2qGt79MOUaYG3771U=;
        b=TH/hkKetmMgCrDkvIGE0YiZUsdf+A/SBaYGd2kGepXAXX2cir5it6yerBK6BnvQGak
         c4EiGb12JXptWQWsHnQ5dWAhaBH3viVs0XINIo5cr8GYnSSm8Z6pxsgUfvAwMl2oigLd
         w11JCYEh/We58QkRmwnzLo84fjViJUT0dJb4b+uXcFm8XpZvTXRjK83Zywl3qJMHg5RE
         /0LvW+rk7BV7Yun2twE9MOHgWskpmgpXt+Rr01CpIUz6khaZQjEGU7X/BdpcHcQh6tR4
         LxFLPKGWmSxfvZh8ybxdHiZhyjSbuShTob9G2lTBTbL3S9har0/BZQjlrg8L45G/7IAg
         BzFA==
X-Gm-Message-State: AC+VfDwdBmVcZ17KOqgoLi+zX2wIDaFoI8oy0BPc8gxedEPtTBTsypGt
        wpsQCbhUEMLBXUXjEiSb8+0=
X-Google-Smtp-Source: ACHHUZ4o6kv1fV8esdNJp9gbSLuyFj/Q85tFM8b6qBGR3aPHrR1YW6+lQ9G4mOfq2Yb6yNEGO/cYAQ==
X-Received: by 2002:a17:902:c948:b0:1a0:6690:d3d1 with SMTP id i8-20020a170902c94800b001a06690d3d1mr24274661pla.6.1683042745894;
        Tue, 02 May 2023 08:52:25 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:62ab:a7fd:a4e3:bd70])
        by smtp.gmail.com with ESMTPSA id o3-20020a170902778300b001a1a07d04e6sm19917212pll.77.2023.05.02.08.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 08:52:25 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v7 13/13] bpf: sockmap, test FIONREAD returns correct bytes in rx buffer with drops
Date:   Tue,  2 May 2023 08:51:59 -0700
Message-Id: <20230502155159.305437-14-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230502155159.305437-1-john.fastabend@gmail.com>
References: <20230502155159.305437-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When BPF program drops pkts the sockmap logic 'eats' the packet and
updates copied_seq. In the PASS case where the sk_buff is accepted
we update copied_seq from recvmsg path so we need a new test to
handle the drop case.

Original patch series broke this resulting in

test_sockmap_skb_verdict_fionread:PASS:ioctl(FIONREAD) error 0 nsec
test_sockmap_skb_verdict_fionread:FAIL:ioctl(FIONREAD) unexpected ioctl(FIONREAD): actual 1503041772 != expected 256
#176/17  sockmap_basic/sockmap skb_verdict fionread on drop:FAIL

After updated patch with fix.

#176/16  sockmap_basic/sockmap skb_verdict fionread:OK
#176/17  sockmap_basic/sockmap skb_verdict fionread on drop:OK

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 47 ++++++++++++++-----
 .../bpf/progs/test_sockmap_drop_prog.c        | 32 +++++++++++++
 2 files changed, 66 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_drop_prog.c

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index 322b5a135740..10112a1ab443 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -11,6 +11,7 @@
 #include "test_sockmap_skb_verdict_attach.skel.h"
 #include "test_sockmap_progs_query.skel.h"
 #include "test_sockmap_pass_prog.skel.h"
+#include "test_sockmap_drop_prog.skel.h"
 #include "bpf_iter_sockmap.skel.h"
 
 #include "sockmap_helpers.h"
@@ -416,19 +417,31 @@ static void test_sockmap_skb_verdict_shutdown(void)
 	test_sockmap_pass_prog__destroy(skel);
 }
 
-static void test_sockmap_skb_verdict_fionread(void)
+static void test_sockmap_skb_verdict_fionread(bool pass_prog)
 {
+	int expected, zero = 0, sent, recvd, avail;
 	int err, map, verdict, s, c0, c1, p0, p1;
-	struct test_sockmap_pass_prog *skel;
-	int zero = 0, sent, recvd, avail;
+	struct test_sockmap_pass_prog *pass;
+	struct test_sockmap_drop_prog *drop;
 	char buf[256] = "0123456789";
 
-	skel = test_sockmap_pass_prog__open_and_load();
-	if (!ASSERT_OK_PTR(skel, "open_and_load"))
-		return;
+	if (pass_prog) {
+		pass = test_sockmap_pass_prog__open_and_load();
+		if (!ASSERT_OK_PTR(pass, "open_and_load"))
+			return;
+		verdict = bpf_program__fd(pass->progs.prog_skb_verdict);
+		map = bpf_map__fd(pass->maps.sock_map_rx);
+		expected = sizeof(buf);
+	} else {
+		drop = test_sockmap_drop_prog__open_and_load();
+		if (!ASSERT_OK_PTR(drop, "open_and_load"))
+			return;
+		verdict = bpf_program__fd(drop->progs.prog_skb_verdict);
+		map = bpf_map__fd(drop->maps.sock_map_rx);
+		/* On drop data is consumed immediately and copied_seq inc'd */
+		expected = 0;
+	}
 
-	verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
-	map = bpf_map__fd(skel->maps.sock_map_rx);
 
 	err = bpf_prog_attach(verdict, map, BPF_SK_SKB_STREAM_VERDICT, 0);
 	if (!ASSERT_OK(err, "bpf_prog_attach"))
@@ -449,9 +462,12 @@ static void test_sockmap_skb_verdict_fionread(void)
 	ASSERT_EQ(sent, sizeof(buf), "xsend(p0)");
 	err = ioctl(c1, FIONREAD, &avail);
 	ASSERT_OK(err, "ioctl(FIONREAD) error");
-	ASSERT_EQ(avail, sizeof(buf), "ioctl(FIONREAD)");
-	recvd = recv_timeout(c1, &buf, sizeof(buf), SOCK_NONBLOCK, IO_TIMEOUT_SEC);
-	ASSERT_EQ(recvd, sizeof(buf), "recv_timeout(c0)");
+	ASSERT_EQ(avail, expected, "ioctl(FIONREAD)");
+	/* On DROP test there will be no data to read */
+	if (pass_prog) {
+		recvd = recv_timeout(c1, &buf, sizeof(buf), SOCK_NONBLOCK, IO_TIMEOUT_SEC);
+		ASSERT_EQ(recvd, sizeof(buf), "recv_timeout(c0)");
+	}
 
 out_close:
 	close(c0);
@@ -459,7 +475,10 @@ static void test_sockmap_skb_verdict_fionread(void)
 	close(c1);
 	close(p1);
 out:
-	test_sockmap_pass_prog__destroy(skel);
+	if (pass_prog)
+		test_sockmap_pass_prog__destroy(pass);
+	else
+		test_sockmap_drop_prog__destroy(drop);
 }
 
 void test_sockmap_basic(void)
@@ -499,5 +518,7 @@ void test_sockmap_basic(void)
 	if (test__start_subtest("sockmap skb_verdict shutdown"))
 		test_sockmap_skb_verdict_shutdown();
 	if (test__start_subtest("sockmap skb_verdict fionread"))
-		test_sockmap_skb_verdict_fionread();
+		test_sockmap_skb_verdict_fionread(true);
+	if (test__start_subtest("sockmap skb_verdict fionread on drop"))
+		test_sockmap_skb_verdict_fionread(false);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_drop_prog.c b/tools/testing/selftests/bpf/progs/test_sockmap_drop_prog.c
new file mode 100644
index 000000000000..29314805ce42
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_drop_prog.c
@@ -0,0 +1,32 @@
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 20);
+	__type(key, int);
+	__type(value, int);
+} sock_map_rx SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 20);
+	__type(key, int);
+	__type(value, int);
+} sock_map_tx SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 20);
+	__type(key, int);
+	__type(value, int);
+} sock_map_msg SEC(".maps");
+
+SEC("sk_skb")
+int prog_skb_verdict(struct __sk_buff *skb)
+{
+	return SK_DROP;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.33.0

