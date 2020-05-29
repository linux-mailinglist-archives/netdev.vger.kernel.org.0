Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA121E8BC1
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 01:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgE2XHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 19:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgE2XHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 19:07:34 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DE0C03E969;
        Fri, 29 May 2020 16:07:34 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id u5so604102pgn.5;
        Fri, 29 May 2020 16:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ahegbUmm8VvxciEZIBix0OqbWUn4+ZyIXo7tv54cWDk=;
        b=sAMqMMwMu3j2Rl3kdEhyvLSq3+TyYCpMxGQyj0qskJzhvaQj3UijpJVBQ45ZAmHLhA
         5J/kVdMY1F/FVIsuqqpZtWinHX+UFWOQtiv0352P0s2T+6TUPqr8vj1Eena3rvpGS1ut
         Zw9ZsK8DiDG0c3615wimMBY8kbp5gEeeVgY8lUiRLEbqO5ygOCmDxqhLwMF9Mt1f+3rn
         S9sBt28/jTdYmPqO5Bh/plAzJC1/f0cVv8lTSXdU+GflQm2Dd2SZIq1aTPPYhG546E0K
         p/yGg/5UdCCU89rqRCRJoP2KjBr3kfQ2UvwnnoaMHTrN6e5Wuxu/mVCZCL2ArRRvPCXE
         5S2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ahegbUmm8VvxciEZIBix0OqbWUn4+ZyIXo7tv54cWDk=;
        b=PZ+/3pyUEJfYGLG6Vv8bo+RjcvlUxvkGPmcPy1zoq283uIgJmPi5eaDQUfoNE/E+8F
         r4REcGJF9Fp9WspzSH//s86lPaEiT/BndgM3ZI5J2rBJfR2eUBV64L//8+LEtmf59CeX
         mXfLynLRDXxkY8LkYvwXPvPb/flPaYBcfGj95DOMfFY03FO6qzHMjJZ3kTXVaged5iy3
         BIO7FGoQAGL4qKLnRkwVAzmNnJXzEceahs+1j35PYSdXAmT3Y+9VgYsq4f8MsuReE5pH
         29cdNEELs51AhI4Vm3BmiWephFWpHrP5NcdrgImcqMoWIk/FoWneK/x5meLZLPm/ZGDz
         iIdg==
X-Gm-Message-State: AOAM532VIBH38ptjIkFbHxfuHU4xubOpt5ZFOChW3yd4eZN8ZXCrfXZg
        csCiopKcQoqBkQLrRP4o8M8Qe/Fhurs=
X-Google-Smtp-Source: ABdhPJxDQRjxC86GjHIuSub/4dzGas0I5mDGko2W1qIvucX1J3qqMWFI72P8lAMF1k2t1esDt3YR1A==
X-Received: by 2002:a65:6703:: with SMTP id u3mr10078057pgf.179.1590793653106;
        Fri, 29 May 2020 16:07:33 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g7sm384558pjs.48.2020.05.29.16.07.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 May 2020 16:07:32 -0700 (PDT)
Subject: [bpf-next PATCH 3/3] bpf,
 selftests: add test for ktls with skb bpf ingress policy
From:   John Fastabend <john.fastabend@gmail.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Fri, 29 May 2020 16:07:19 -0700
Message-ID: <159079363965.5745.3390806911628980210.stgit@john-Precision-5820-Tower>
In-Reply-To: <159079336010.5745.8538518572099799848.stgit@john-Precision-5820-Tower>
References: <159079336010.5745.8538518572099799848.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a test for bpf ingress policy. To ensure data writes happen
as expected with extra TLS headers we run these tests with data
verification enabled by default. This will test receive packets have
"PASS" stamped into the front of the payload.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/progs/test_sockmap_kern.h        |   46 ++++++
 tools/testing/selftests/bpf/test_sockmap.c         |  163 +++++++++++++++++---
 2 files changed, 187 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_kern.h b/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
index a443d36..057036c 100644
--- a/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
@@ -79,11 +79,18 @@ struct {
 
 struct {
 	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__uint(max_entries, 1);
+	__uint(max_entries, 2);
 	__type(key, int);
 	__type(value, int);
 } sock_skb_opts SEC(".maps");
 
+struct {
+	__uint(type, TEST_MAP_TYPE);
+	__uint(max_entries, 20);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+} tls_sock_map SEC(".maps");
+
 SEC("sk_skb1")
 int bpf_prog1(struct __sk_buff *skb)
 {
@@ -118,6 +125,43 @@ int bpf_prog2(struct __sk_buff *skb)
 
 }
 
+SEC("sk_skb3")
+int bpf_prog3(struct __sk_buff *skb)
+{
+	const int one = 1;
+	int err, *f, ret = SK_PASS;
+	void *data_end;
+	char *c;
+
+	err = bpf_skb_pull_data(skb, 19);
+	if (err)
+		goto tls_out;
+
+	c = (char *)(long)skb->data;
+	data_end = (void *)(long)skb->data_end;
+
+	if (c + 18 < data_end)
+		memcpy(&c[13], "PASS", 4);
+	f = bpf_map_lookup_elem(&sock_skb_opts, &one);
+	if (f && *f) {
+		__u64 flags = 0;
+
+		ret = 0;
+		flags = *f;
+#ifdef SOCKMAP
+		return bpf_sk_redirect_map(skb, &tls_sock_map, ret, flags);
+#else
+		return bpf_sk_redirect_hash(skb, &tls_sock_map, &ret, flags);
+#endif
+	}
+
+	f = bpf_map_lookup_elem(&sock_skb_opts, &one);
+	if (f && *f)
+		ret = SK_DROP;
+tls_out:
+	return ret;
+}
+
 SEC("sockops")
 int bpf_sockmap(struct bpf_sock_ops *skops)
 {
diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index c806438..37695fc 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -63,8 +63,8 @@ int s1, s2, c1, c2, p1, p2;
 int test_cnt;
 int passed;
 int failed;
-int map_fd[8];
-struct bpf_map *maps[8];
+int map_fd[9];
+struct bpf_map *maps[9];
 int prog_fd[11];
 
 int txmsg_pass;
@@ -79,7 +79,10 @@ int txmsg_end_push;
 int txmsg_start_pop;
 int txmsg_pop;
 int txmsg_ingress;
-int txmsg_skb;
+int txmsg_redir_skb;
+int txmsg_ktls_skb;
+int txmsg_ktls_skb_drop;
+int txmsg_ktls_skb_redir;
 int ktls;
 int peek_flag;
 
@@ -104,7 +107,7 @@ static const struct option long_options[] = {
 	{"txmsg_start_pop",  required_argument,	NULL, 'w'},
 	{"txmsg_pop",	     required_argument,	NULL, 'x'},
 	{"txmsg_ingress", no_argument,		&txmsg_ingress, 1 },
-	{"txmsg_skb", no_argument,		&txmsg_skb, 1 },
+	{"txmsg_redir_skb", no_argument,	&txmsg_redir_skb, 1 },
 	{"ktls", no_argument,			&ktls, 1 },
 	{"peek", no_argument,			&peek_flag, 1 },
 	{"whitelist", required_argument,	NULL, 'n' },
@@ -169,7 +172,8 @@ static void test_reset(void)
 	txmsg_start_push = txmsg_end_push = 0;
 	txmsg_pass = txmsg_drop = txmsg_redir = 0;
 	txmsg_apply = txmsg_cork = 0;
-	txmsg_ingress = txmsg_skb = 0;
+	txmsg_ingress = txmsg_redir_skb = 0;
+	txmsg_ktls_skb = txmsg_ktls_skb_drop = txmsg_ktls_skb_redir = 0;
 }
 
 static int test_start_subtest(const struct _test *t, struct sockmap_options *o)
@@ -502,14 +506,41 @@ static int msg_alloc_iov(struct msghdr *msg,
 
 static int msg_verify_data(struct msghdr *msg, int size, int chunk_sz)
 {
-	int i, j, bytes_cnt = 0;
+	int i, j = 0, bytes_cnt = 0;
 	unsigned char k = 0;
 
 	for (i = 0; i < msg->msg_iovlen; i++) {
 		unsigned char *d = msg->msg_iov[i].iov_base;
 
-		for (j = 0;
-		     j < msg->msg_iov[i].iov_len && size; j++) {
+		/* Special case test for skb ingress + ktls */
+		if (i == 0 && txmsg_ktls_skb) {
+			if (msg->msg_iov[i].iov_len < 4)
+				return -EIO;
+			if (txmsg_ktls_skb_redir) {
+				if (memcmp(&d[13], "PASS", 4) != 0) {
+					fprintf(stderr,
+						"detected redirect ktls_skb data error with skb ingress update @iov[%i]:%i \"%02x %02x %02x %02x\" != \"PASS\"\n", i, 0, d[13], d[14], d[15], d[16]);
+					return -EIO;
+				}
+				d[13] = 0;
+				d[14] = 1;
+				d[15] = 2;
+				d[16] = 3;
+				j = 13;
+			} else if (txmsg_ktls_skb) {
+				if (memcmp(d, "PASS", 4) != 0) {
+					fprintf(stderr,
+						"detected ktls_skb data error with skb ingress update @iov[%i]:%i \"%02x %02x %02x %02x\" != \"PASS\"\n", i, 0, d[0], d[1], d[2], d[3]);
+					return -EIO;
+				}
+				d[0] = 0;
+				d[1] = 1;
+				d[2] = 2;
+				d[3] = 3;
+			}
+		}
+
+		for (; j < msg->msg_iov[i].iov_len && size; j++) {
 			if (d[j] != k++) {
 				fprintf(stderr,
 					"detected data corruption @iov[%i]:%i %02x != %02x, %02x ?= %02x\n",
@@ -724,7 +755,7 @@ static int sendmsg_test(struct sockmap_options *opt)
 	rxpid = fork();
 	if (rxpid == 0) {
 		iov_buf -= (txmsg_pop - txmsg_start_pop + 1);
-		if (opt->drop_expected)
+		if (opt->drop_expected || txmsg_ktls_skb_drop)
 			_exit(0);
 
 		if (!iov_buf) /* zero bytes sent case */
@@ -911,8 +942,28 @@ static int run_options(struct sockmap_options *options, int cg_fd,  int test)
 		return err;
 	}
 
+	/* Attach programs to TLS sockmap */
+	if (txmsg_ktls_skb) {
+		err = bpf_prog_attach(prog_fd[0], map_fd[8],
+					BPF_SK_SKB_STREAM_PARSER, 0);
+		if (err) {
+			fprintf(stderr,
+				"ERROR: bpf_prog_attach (TLS sockmap %i->%i): %d (%s)\n",
+				prog_fd[0], map_fd[8], err, strerror(errno));
+			return err;
+		}
+
+		err = bpf_prog_attach(prog_fd[2], map_fd[8],
+				      BPF_SK_SKB_STREAM_VERDICT, 0);
+		if (err) {
+			fprintf(stderr, "ERROR: bpf_prog_attach (TLS sockmap): %d (%s)\n",
+				err, strerror(errno));
+			return err;
+		}
+	}
+
 	/* Attach to cgroups */
-	err = bpf_prog_attach(prog_fd[2], cg_fd, BPF_CGROUP_SOCK_OPS, 0);
+	err = bpf_prog_attach(prog_fd[3], cg_fd, BPF_CGROUP_SOCK_OPS, 0);
 	if (err) {
 		fprintf(stderr, "ERROR: bpf_prog_attach (groups): %d (%s)\n",
 			err, strerror(errno));
@@ -928,15 +979,15 @@ static int run_options(struct sockmap_options *options, int cg_fd,  int test)
 
 	/* Attach txmsg program to sockmap */
 	if (txmsg_pass)
-		tx_prog_fd = prog_fd[3];
-	else if (txmsg_redir)
 		tx_prog_fd = prog_fd[4];
-	else if (txmsg_apply)
+	else if (txmsg_redir)
 		tx_prog_fd = prog_fd[5];
-	else if (txmsg_cork)
+	else if (txmsg_apply)
 		tx_prog_fd = prog_fd[6];
-	else if (txmsg_drop)
+	else if (txmsg_cork)
 		tx_prog_fd = prog_fd[7];
+	else if (txmsg_drop)
+		tx_prog_fd = prog_fd[8];
 	else
 		tx_prog_fd = 0;
 
@@ -1108,7 +1159,35 @@ static int run_options(struct sockmap_options *options, int cg_fd,  int test)
 			}
 		}
 
-		if (txmsg_skb) {
+		if (txmsg_ktls_skb) {
+			int ingress = BPF_F_INGRESS;
+
+			i = 0;
+			err = bpf_map_update_elem(map_fd[8], &i, &p2, BPF_ANY);
+			if (err) {
+				fprintf(stderr,
+					"ERROR: bpf_map_update_elem (c1 sockmap): %d (%s)\n",
+					err, strerror(errno));
+			}
+
+			if (txmsg_ktls_skb_redir) {
+				i = 1;
+				err = bpf_map_update_elem(map_fd[7],
+							  &i, &ingress, BPF_ANY);
+				if (err) {
+					fprintf(stderr,
+						"ERROR: bpf_map_update_elem (txmsg_ingress): %d (%s)\n",
+						err, strerror(errno));
+				}
+			}
+
+			if (txmsg_ktls_skb_drop) {
+				i = 1;
+				err = bpf_map_update_elem(map_fd[7], &i, &i, BPF_ANY);
+			}
+		}
+
+		if (txmsg_redir_skb) {
 			int skb_fd = (test == SENDMSG || test == SENDPAGE) ?
 					p2 : p1;
 			int ingress = BPF_F_INGRESS;
@@ -1123,8 +1202,7 @@ static int run_options(struct sockmap_options *options, int cg_fd,  int test)
 			}
 
 			i = 3;
-			err = bpf_map_update_elem(map_fd[0],
-						  &i, &skb_fd, BPF_ANY);
+			err = bpf_map_update_elem(map_fd[0], &i, &skb_fd, BPF_ANY);
 			if (err) {
 				fprintf(stderr,
 					"ERROR: bpf_map_update_elem (c1 sockmap): %d (%s)\n",
@@ -1158,9 +1236,12 @@ static int run_options(struct sockmap_options *options, int cg_fd,  int test)
 		fprintf(stderr, "unknown test\n");
 out:
 	/* Detatch and zero all the maps */
-	bpf_prog_detach2(prog_fd[2], cg_fd, BPF_CGROUP_SOCK_OPS);
+	bpf_prog_detach2(prog_fd[3], cg_fd, BPF_CGROUP_SOCK_OPS);
 	bpf_prog_detach2(prog_fd[0], map_fd[0], BPF_SK_SKB_STREAM_PARSER);
 	bpf_prog_detach2(prog_fd[1], map_fd[0], BPF_SK_SKB_STREAM_VERDICT);
+	bpf_prog_detach2(prog_fd[0], map_fd[8], BPF_SK_SKB_STREAM_PARSER);
+	bpf_prog_detach2(prog_fd[2], map_fd[8], BPF_SK_SKB_STREAM_VERDICT);
+
 	if (tx_prog_fd >= 0)
 		bpf_prog_detach2(tx_prog_fd, map_fd[1], BPF_SK_MSG_VERDICT);
 
@@ -1229,8 +1310,10 @@ static void test_options(char *options)
 	}
 	if (txmsg_ingress)
 		strncat(options, "ingress,", OPTSTRING);
-	if (txmsg_skb)
-		strncat(options, "skb,", OPTSTRING);
+	if (txmsg_redir_skb)
+		strncat(options, "redir_skb,", OPTSTRING);
+	if (txmsg_ktls_skb)
+		strncat(options, "ktls_skb,", OPTSTRING);
 	if (ktls)
 		strncat(options, "ktls,", OPTSTRING);
 	if (peek_flag)
@@ -1362,6 +1445,40 @@ static void test_txmsg_ingress_redir(int cgrp, struct sockmap_options *opt)
 	test_send(opt, cgrp);
 }
 
+static void test_txmsg_skb(int cgrp, struct sockmap_options *opt)
+{
+	bool data = opt->data_test;
+	int k = ktls;
+
+	opt->data_test = true;
+	ktls = 1;
+
+	txmsg_pass = txmsg_drop = 0;
+	txmsg_ingress = txmsg_redir = 0;
+	txmsg_ktls_skb = 1;
+	txmsg_pass = 1;
+
+	/* Using data verification so ensure iov layout is
+	 * expected from test receiver side. e.g. has enough
+	 * bytes to write test code.
+	 */
+	opt->iov_length = 100;
+	opt->iov_count = 1;
+	opt->rate = 1;
+	test_exec(cgrp, opt);
+
+	txmsg_ktls_skb_drop = 1;
+	test_exec(cgrp, opt);
+
+	txmsg_ktls_skb_drop = 0;
+	txmsg_ktls_skb_redir = 1;
+	test_exec(cgrp, opt);
+
+	opt->data_test = data;
+	ktls = k;
+}
+
+
 /* Test cork with hung data. This tests poor usage patterns where
  * cork can leave data on the ring if user program is buggy and
  * doesn't flush them somehow. They do take some time however
@@ -1542,11 +1659,13 @@ char *map_names[] = {
 	"sock_bytes",
 	"sock_redir_flags",
 	"sock_skb_opts",
+	"tls_sock_map",
 };
 
 int prog_attach_type[] = {
 	BPF_SK_SKB_STREAM_PARSER,
 	BPF_SK_SKB_STREAM_VERDICT,
+	BPF_SK_SKB_STREAM_VERDICT,
 	BPF_CGROUP_SOCK_OPS,
 	BPF_SK_MSG_VERDICT,
 	BPF_SK_MSG_VERDICT,
@@ -1560,6 +1679,7 @@ int prog_attach_type[] = {
 int prog_type[] = {
 	BPF_PROG_TYPE_SK_SKB,
 	BPF_PROG_TYPE_SK_SKB,
+	BPF_PROG_TYPE_SK_SKB,
 	BPF_PROG_TYPE_SOCK_OPS,
 	BPF_PROG_TYPE_SK_MSG,
 	BPF_PROG_TYPE_SK_MSG,
@@ -1620,6 +1740,7 @@ struct _test test[] = {
 	{"txmsg test redirect", test_txmsg_redir},
 	{"txmsg test drop", test_txmsg_drop},
 	{"txmsg test ingress redirect", test_txmsg_ingress_redir},
+	{"txmsg test skb", test_txmsg_skb},
 	{"txmsg test apply", test_txmsg_apply},
 	{"txmsg test cork", test_txmsg_cork},
 	{"txmsg test hanging corks", test_txmsg_cork_hangs},

