Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C5D6DB174
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 19:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjDGRSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 13:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjDGRRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 13:17:33 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087A0C169;
        Fri,  7 Apr 2023 10:17:19 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id d22-20020a17090a111600b0023d1b009f52so1887654pja.2;
        Fri, 07 Apr 2023 10:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680887838; x=1683479838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MpxzIylC0O+QIhlCGWKD1562wl2qGt79MOUaYG3771U=;
        b=BDY4y3HwINEx2Pdpu+QdGYGUUa9y4UsEEJIEW/6YTYJE5dND5i8QIffNx5xXxuq8gn
         G4Yp/tJ1UB+UAcGkHl4dHHpHzA09NZgKbQJ5pLUiDcPd0QxfIMmHyVqQt2u6SSw8vECo
         CuOBBliUZAq6e8wnDfjmXN91Tx2r/zqzZnx2oczfkJMckALygm0TE/l9Z+jcITgZ7mAR
         HwJfDfwwHJWFiN8+zB+CS3B2zL5T1Xurr+k2q46+ttgFcQX1UAjL9reVEv5Ctbh2lYWX
         vlnbHQWMpkf/siQ7mDTt0DOR8AA0v5vmo1eKg3BaAgnna3Za4Tyv+jOK+LNCmWuMvFW5
         SIFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680887838; x=1683479838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MpxzIylC0O+QIhlCGWKD1562wl2qGt79MOUaYG3771U=;
        b=XS20RpeTSksuagSVWQnjblC4fMc/mWtFJvAhn7cYMaifHBB4RCfcN0LrMydtY/MT3y
         fQpJnHjrMe4iSlSnW+2jvUlbKbAWNQYt92qyaeXJgg/CpZt3iYLYGGq0Z/JphQ2cOuVA
         c/jbYR0/Hx7Np8f+frYrUg7fNofno0zYCH7UIpQai4bSgxchhMXwPa5ogmm39XufPAaU
         ROKj4hwc4UpOD4UCQgkORqMOwcuBKASQLCCDjoC3l3ELyvIKX3NuXdlDjaqi6D7XKgJv
         JyALvBolQWcBt08a3x0v2vwCs4e5ubihr2IGo8MGAbNDFG+pyGXB8jtKPbsRPBQa2pWA
         qY3A==
X-Gm-Message-State: AAQBX9eeYM0kn0NWrquIdKorHjgNsHWjg8U/MfgHD5SjTnn/j+fTD2ys
        IO9V1tWVjfzkEmiADFniH2Cea9hPAOs=
X-Google-Smtp-Source: AKy350YL1/DS/U7MJhYNU45ZSm573VqvccBYajbMWdAcOiaOa7hoVQ6XrOw+lLG8a1YsDMmorKD9ww==
X-Received: by 2002:a17:902:f9c3:b0:1a1:a90f:6766 with SMTP id kz3-20020a170902f9c300b001a1a90f6766mr2704168plb.52.1680887838387;
        Fri, 07 Apr 2023 10:17:18 -0700 (PDT)
Received: from john.lan ([98.97.116.126])
        by smtp.gmail.com with ESMTPSA id p1-20020a1709028a8100b0019b0937003esm3185425plo.150.2023.04.07.10.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 10:17:17 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v6 12/12] bpf: sockmap, test FIONREAD returns correct bytes in rx buffer with drops
Date:   Fri,  7 Apr 2023 10:16:54 -0700
Message-Id: <20230407171654.107311-13-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230407171654.107311-1-john.fastabend@gmail.com>
References: <20230407171654.107311-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

