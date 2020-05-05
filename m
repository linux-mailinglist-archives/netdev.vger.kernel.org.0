Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC2B1C6254
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgEEUub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728660AbgEEUu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:50:29 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFC2C061A41;
        Tue,  5 May 2020 13:50:29 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id f3so3905503ioj.1;
        Tue, 05 May 2020 13:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=kLfBXqmDXtH0NNKUxBcMwLiTGUDUYn2g2eS5zwjK5oI=;
        b=BBSYFrPA6FvhsDQnKBO4nA5xB4tHW3s0EHatI2er4RjHZpqY57mW7o25KP9xbzPCSk
         2qRk37a1AFWOMfJSJXnUnPfh98YWyfiIzNJ0PxE+TURR3WJDw3LfvL9GYDSo5vhyMz1O
         ON0B36BIhD8Rp8WC+Ag1lBDg8li13/QAQ0ZI0pA18Po/tMuNDLTZafqU+pPIohV0a4+V
         2YFdk5KSidrG4QbTJEY4Q2yH7ORL9yyTh1i3lKfmuG2eEQzVhYXmjyeugQqGVG6Lizov
         NcH6PDyZ5gETYjzOBhCAjiBmNX5anycARr7a0a968nOx5F/KSwzGHSNeNKkaVnVwBX9f
         7EnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=kLfBXqmDXtH0NNKUxBcMwLiTGUDUYn2g2eS5zwjK5oI=;
        b=apNQ2OnLm9OXs4mBen2lziVpAxPjYgK9eLPNxeWncem8daO4d7s6FTCGZdHqj++p8i
         eVwUEeY3ctZfFFZnDDVhbtjzP8FnJWKhgJ+YLtPP0+k7tXwQ+uF5LevOl5kYEo/XuayE
         cCn2fwadiYiElF1QEl1xH9qee6Y/O/zUrGFxS+tQgbGfM0KjPhSI9k3FE0/o9sXgNhAg
         I+oyviTlQVu66gmwYVBP3CEeDJOi5ajmHM9OeTN9POxOR+77WRyHEGWiexoK0DkiZvM4
         PWUhKZ9w17QaRoJdoATj7B16MT2P/pXgBe4GSbqiQkAwuu7jzk5fqtQVuNiACnUvzaSu
         B5pg==
X-Gm-Message-State: AGi0PuaJckojvOEd4TI9DyB50/dXH06yd295Dko737PNZLKFcQqeuec2
        lt6pMT7ZcxtF2PLNCxpsED8=
X-Google-Smtp-Source: APiQypLZ9tu9ccp9YoJMNvlue4vsJYKC3kSVnU45MAlMAsLrv/aLDAfCRhwOG7e1mtm2C0Kh/wRn9w==
X-Received: by 2002:a02:9445:: with SMTP id a63mr5623216jai.10.1588711828833;
        Tue, 05 May 2020 13:50:28 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id p1sm2048941ioh.38.2020.05.05.13.50.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 13:50:28 -0700 (PDT)
Subject: [bpf-next PATCH 02/10] bpf: selftests,
 remove prints from sockmap tests
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Tue, 05 May 2020 13:50:15 -0700
Message-ID: <158871181572.7537.14245158294912553414.stgit@john-Precision-5820-Tower>
In-Reply-To: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
References: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The prints in the test_sockmap programs were only useful when we
didn't have enough control over test infrastructure to know from
user program what was being pushed into kernel side.

Now that we have or will shortly have better test controls lets
remove the printers. This means we can remove half the programs
and cleanup bpf side.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/progs/test_sockmap_kern.h        |  158 --------------------
 tools/testing/selftests/bpf/test_sockmap.c         |   25 +--
 2 files changed, 9 insertions(+), 174 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_kern.h b/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
index 9b4d3a6..a443d36 100644
--- a/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
@@ -110,8 +110,6 @@ int bpf_prog2(struct __sk_buff *skb)
 		flags = *f;
 	}
 
-	bpf_printk("sk_skb2: redirect(%iB) flags=%i\n",
-		   len, flags);
 #ifdef SOCKMAP
 	return bpf_sk_redirect_map(skb, &sock_map, ret, flags);
 #else
@@ -143,8 +141,6 @@ int bpf_sockmap(struct bpf_sock_ops *skops)
 			err = bpf_sock_hash_update(skops, &sock_map, &ret,
 						   BPF_NOEXIST);
 #endif
-			bpf_printk("passive(%i -> %i) map ctx update err: %d\n",
-				   lport, bpf_ntohl(rport), err);
 		}
 		break;
 	case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:
@@ -160,8 +156,6 @@ int bpf_sockmap(struct bpf_sock_ops *skops)
 			err = bpf_sock_hash_update(skops, &sock_map, &ret,
 						   BPF_NOEXIST);
 #endif
-			bpf_printk("active(%i -> %i) map ctx update err: %d\n",
-				   lport, bpf_ntohl(rport), err);
 		}
 		break;
 	default:
@@ -199,72 +193,6 @@ int bpf_prog4(struct sk_msg_md *msg)
 }
 
 SEC("sk_msg2")
-int bpf_prog5(struct sk_msg_md *msg)
-{
-	int zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5;
-	int *start, *end, *start_push, *end_push, *start_pop, *pop;
-	int *bytes, len1, len2 = 0, len3, len4;
-	int err1 = -1, err2 = -1;
-
-	bytes = bpf_map_lookup_elem(&sock_apply_bytes, &zero);
-	if (bytes)
-		err1 = bpf_msg_apply_bytes(msg, *bytes);
-	bytes = bpf_map_lookup_elem(&sock_cork_bytes, &zero);
-	if (bytes)
-		err2 = bpf_msg_cork_bytes(msg, *bytes);
-	len1 = (__u64)msg->data_end - (__u64)msg->data;
-	start = bpf_map_lookup_elem(&sock_bytes, &zero);
-	end = bpf_map_lookup_elem(&sock_bytes, &one);
-	if (start && end) {
-		int err;
-
-		bpf_printk("sk_msg2: pull(%i:%i)\n",
-			   start ? *start : 0, end ? *end : 0);
-		err = bpf_msg_pull_data(msg, *start, *end, 0);
-		if (err)
-			bpf_printk("sk_msg2: pull_data err %i\n",
-				   err);
-		len2 = (__u64)msg->data_end - (__u64)msg->data;
-		bpf_printk("sk_msg2: length update %i->%i\n",
-			   len1, len2);
-	}
-
-	start_push = bpf_map_lookup_elem(&sock_bytes, &two);
-	end_push = bpf_map_lookup_elem(&sock_bytes, &three);
-	if (start_push && end_push) {
-		int err;
-
-		bpf_printk("sk_msg2: push(%i:%i)\n",
-			   start_push ? *start_push : 0,
-			   end_push ? *end_push : 0);
-		err = bpf_msg_push_data(msg, *start_push, *end_push, 0);
-		if (err)
-			bpf_printk("sk_msg2: push_data err %i\n", err);
-		len3 = (__u64)msg->data_end - (__u64)msg->data;
-		bpf_printk("sk_msg2: length push_update %i->%i\n",
-			   len2 ? len2 : len1, len3);
-	}
-	start_pop = bpf_map_lookup_elem(&sock_bytes, &four);
-	pop = bpf_map_lookup_elem(&sock_bytes, &five);
-	if (start_pop && pop) {
-		int err;
-
-		bpf_printk("sk_msg2: pop(%i@%i)\n",
-			   start_pop, pop);
-		err = bpf_msg_pop_data(msg, *start_pop, *pop, 0);
-		if (err)
-			bpf_printk("sk_msg2: pop_data err %i\n", err);
-		len4 = (__u64)msg->data_end - (__u64)msg->data;
-		bpf_printk("sk_msg2: length pop_data %i->%i\n",
-			   len1 ? len1 : 0,  len4);
-	}
-
-	bpf_printk("sk_msg2: data length %i err1 %i err2 %i\n",
-		   len1, err1, err2);
-	return SK_PASS;
-}
-
-SEC("sk_msg3")
 int bpf_prog6(struct sk_msg_md *msg)
 {
 	int zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5, key = 0;
@@ -305,86 +233,7 @@ int bpf_prog6(struct sk_msg_md *msg)
 #endif
 }
 
-SEC("sk_msg4")
-int bpf_prog7(struct sk_msg_md *msg)
-{
-	int *bytes, *start, *end, *start_push, *end_push, *start_pop, *pop, *f;
-	int zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5;
-	int len1, len2 = 0, len3, len4;
-	int err1 = 0, err2 = 0, key = 0;
-	__u64 flags = 0;
-
-		int err;
-	bytes = bpf_map_lookup_elem(&sock_apply_bytes, &zero);
-	if (bytes)
-		err1 = bpf_msg_apply_bytes(msg, *bytes);
-	bytes = bpf_map_lookup_elem(&sock_cork_bytes, &zero);
-	if (bytes)
-		err2 = bpf_msg_cork_bytes(msg, *bytes);
-	len1 = (__u64)msg->data_end - (__u64)msg->data;
-
-	start = bpf_map_lookup_elem(&sock_bytes, &zero);
-	end = bpf_map_lookup_elem(&sock_bytes, &one);
-	if (start && end) {
-		bpf_printk("sk_msg2: pull(%i:%i)\n",
-			   start ? *start : 0, end ? *end : 0);
-		err = bpf_msg_pull_data(msg, *start, *end, 0);
-		if (err)
-			bpf_printk("sk_msg2: pull_data err %i\n",
-				   err);
-		len2 = (__u64)msg->data_end - (__u64)msg->data;
-		bpf_printk("sk_msg2: length update %i->%i\n",
-			   len1, len2);
-	}
-
-	start_push = bpf_map_lookup_elem(&sock_bytes, &two);
-	end_push = bpf_map_lookup_elem(&sock_bytes, &three);
-	if (start_push && end_push) {
-		bpf_printk("sk_msg4: push(%i:%i)\n",
-			   start_push ? *start_push : 0,
-			   end_push ? *end_push : 0);
-		err = bpf_msg_push_data(msg, *start_push, *end_push, 0);
-		if (err)
-			bpf_printk("sk_msg4: push_data err %i\n",
-				   err);
-		len3 = (__u64)msg->data_end - (__u64)msg->data;
-		bpf_printk("sk_msg4: length push_update %i->%i\n",
-			   len2 ? len2 : len1, len3);
-	}
-
-	start_pop = bpf_map_lookup_elem(&sock_bytes, &four);
-	pop = bpf_map_lookup_elem(&sock_bytes, &five);
-	if (start_pop && pop) {
-		int err;
-
-		bpf_printk("sk_msg4: pop(%i@%i)\n",
-			   start_pop, pop);
-		err = bpf_msg_pop_data(msg, *start_pop, *pop, 0);
-		if (err)
-			bpf_printk("sk_msg4: pop_data err %i\n", err);
-		len4 = (__u64)msg->data_end - (__u64)msg->data;
-		bpf_printk("sk_msg4: length pop_data %i->%i\n",
-			   len1 ? len1 : 0,  len4);
-	}
-
-
-	f = bpf_map_lookup_elem(&sock_redir_flags, &zero);
-	if (f && *f) {
-		key = 2;
-		flags = *f;
-	}
-	bpf_printk("sk_msg3: redirect(%iB) flags=%i err=%i\n",
-		   len1, flags, err1 ? err1 : err2);
-#ifdef SOCKMAP
-	err = bpf_msg_redirect_map(msg, &sock_map_redir, key, flags);
-#else
-	err = bpf_msg_redirect_hash(msg, &sock_map_redir, &key, flags);
-#endif
-	bpf_printk("sk_msg3: err %i\n", err);
-	return err;
-}
-
-SEC("sk_msg5")
+SEC("sk_msg3")
 int bpf_prog8(struct sk_msg_md *msg)
 {
 	void *data_end = (void *)(long) msg->data_end;
@@ -401,7 +250,7 @@ int bpf_prog8(struct sk_msg_md *msg)
 	}
 	return SK_PASS;
 }
-SEC("sk_msg6")
+SEC("sk_msg4")
 int bpf_prog9(struct sk_msg_md *msg)
 {
 	void *data_end = (void *)(long) msg->data_end;
@@ -419,7 +268,7 @@ int bpf_prog9(struct sk_msg_md *msg)
 	return SK_PASS;
 }
 
-SEC("sk_msg7")
+SEC("sk_msg5")
 int bpf_prog10(struct sk_msg_md *msg)
 {
 	int *bytes, *start, *end, *start_push, *end_push, *start_pop, *pop;
@@ -443,7 +292,6 @@ int bpf_prog10(struct sk_msg_md *msg)
 	pop = bpf_map_lookup_elem(&sock_bytes, &five);
 	if (start_pop && pop)
 		bpf_msg_pop_data(msg, *start_pop, *pop, 0);
-	bpf_printk("return sk drop\n");
 	return SK_DROP;
 }
 
diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 779e11d..6bdacc4 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -68,9 +68,7 @@ struct bpf_map *maps[8];
 int prog_fd[11];
 
 int txmsg_pass;
-int txmsg_noisy;
 int txmsg_redir;
-int txmsg_redir_noisy;
 int txmsg_drop;
 int txmsg_apply;
 int txmsg_cork;
@@ -95,9 +93,7 @@ static const struct option long_options[] = {
 	{"test",	required_argument,	NULL, 't' },
 	{"data_test",   no_argument,		NULL, 'd' },
 	{"txmsg",		no_argument,	&txmsg_pass,  1  },
-	{"txmsg_noisy",		no_argument,	&txmsg_noisy, 1  },
 	{"txmsg_redir",		no_argument,	&txmsg_redir, 1  },
-	{"txmsg_redir_noisy",	no_argument,	&txmsg_redir_noisy, 1},
 	{"txmsg_drop",		no_argument,	&txmsg_drop, 1 },
 	{"txmsg_apply",	required_argument,	NULL, 'a'},
 	{"txmsg_cork",	required_argument,	NULL, 'k'},
@@ -834,19 +830,14 @@ static int run_options(struct sockmap_options *options, int cg_fd,  int test)
 	/* Attach txmsg program to sockmap */
 	if (txmsg_pass)
 		tx_prog_fd = prog_fd[3];
-	else if (txmsg_noisy)
-		tx_prog_fd = prog_fd[4];
 	else if (txmsg_redir)
+		tx_prog_fd = prog_fd[4];
+	else if (txmsg_apply)
 		tx_prog_fd = prog_fd[5];
-	else if (txmsg_redir_noisy)
+	else if (txmsg_cork)
 		tx_prog_fd = prog_fd[6];
 	else if (txmsg_drop)
-		tx_prog_fd = prog_fd[9];
-	/* apply and cork must be last */
-	else if (txmsg_apply)
 		tx_prog_fd = prog_fd[7];
-	else if (txmsg_cork)
-		tx_prog_fd = prog_fd[8];
 	else
 		tx_prog_fd = 0;
 
@@ -870,7 +861,7 @@ static int run_options(struct sockmap_options *options, int cg_fd,  int test)
 			goto out;
 		}
 
-		if (txmsg_redir || txmsg_redir_noisy)
+		if (txmsg_redir)
 			redir_fd = c2;
 		else
 			redir_fd = c1;
@@ -1112,12 +1103,8 @@ static void test_options(char *options)
 
 	if (txmsg_pass)
 		strncat(options, "pass,", OPTSTRING);
-	if (txmsg_noisy)
-		strncat(options, "pass_noisy,", OPTSTRING);
 	if (txmsg_redir)
 		strncat(options, "redir,", OPTSTRING);
-	if (txmsg_redir_noisy)
-		strncat(options, "redir_noisy,", OPTSTRING);
 	if (txmsg_drop)
 		strncat(options, "drop,", OPTSTRING);
 	if (txmsg_apply) {
@@ -1228,7 +1215,7 @@ static int test_txmsg(int cgrp)
 {
 	int err;
 
-	txmsg_pass = txmsg_noisy = txmsg_redir_noisy = txmsg_drop = 0;
+	txmsg_pass = txmsg_drop = 0;
 	txmsg_apply = txmsg_cork = 0;
 	txmsg_ingress = txmsg_skb = 0;
 
@@ -1319,7 +1306,7 @@ static int test_mixed(int cgrp)
 	struct sockmap_options opt = {0};
 	int err;
 
-	txmsg_pass = txmsg_noisy = txmsg_redir_noisy = txmsg_drop = 0;
+	txmsg_pass = txmsg_drop = 0;
 	txmsg_apply = txmsg_cork = 0;
 	txmsg_start = txmsg_end = 0;
 	txmsg_start_push = txmsg_end_push = 0;

