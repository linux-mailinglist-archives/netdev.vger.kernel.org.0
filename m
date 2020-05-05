Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EB11C624F
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbgEEUuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729252AbgEEUuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:50:10 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BBE8C061A0F;
        Tue,  5 May 2020 13:50:10 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id i16so3604862ils.12;
        Tue, 05 May 2020 13:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=12bygBM+mkahz2GI0FFNBfRVoeqCAGiChx6eJjNUc8w=;
        b=QWdXKWX4kguKyYQ5M8yPMjdzSfgv+KGgOcfc+lAoJ2q/lg6b3SpL+5EElFYp7aFOah
         tAZg7yHCB6Eg0YuuZYa8+/cxo4QnBqHke0y0Wm0Re7vbos5HWckGhYL7gy3Dx/AHN1Np
         QFq+qlawjWdVRNnzG/ekOJFYstIymRSeeKZdMqKisjrAJkOmeyDXKlDhXlgK4zdALfCz
         6HoO28IfPQOLGrNOlJmvsKLgRX2JJb1h7nucHFtlWXB8q8xqcw7spFKRdfiZp88nt9Qr
         YfGVKjMN2707veLYAWJpT2usIsfBSLBFY3dbiyhZzD2lHjElLKKNpuTuThQxULfgORjp
         iTzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=12bygBM+mkahz2GI0FFNBfRVoeqCAGiChx6eJjNUc8w=;
        b=NKO9qOeORcCT5Z6GrU0bNpEUC9T79UmV+Qys7+B0AjHnLnQgBpR0iodajZGjAdF4K6
         E2H30bdk2cSYQYzB+ro5XFmsu6hLKUoPO0tNwiXxP8S9AL6RKotnql66xkmQp4bNohx6
         Pn63KocOBU4R9kW4x2B7Q+X3wWapFOWluO+2EQ9LHGtZc/5rlNfH3LmP+4+ebcEfOC/X
         opeMg/GaQZiW+/C5fOi02haEuyLRm9jGUDzpLtlgIqdO/U4xVHbNQQuvNGTAD7FpfKeF
         xm/vJMYdiaFtPkVZ7ONzOZc5NjIL1jvjaHRMA+wO8ja6458iCbepjM9UAhxOwUi7/a7+
         EHsQ==
X-Gm-Message-State: AGi0PuYB7wCVLowq2t32gNsVFI4BphvLK4SNOCQTG0N2a48KowwrF6Ln
        EbuoIEXpqK6d1s30csf3rpc=
X-Google-Smtp-Source: APiQypJ1uHP7TLu6kCl2PeFh5fX5mRGyHWMk1qGuaaJBMZbWMixqaSnBRGB1Iqwbwm1xXA5Jo0CbQg==
X-Received: by 2002:a92:3c0f:: with SMTP id j15mr5730124ila.201.1588711809609;
        Tue, 05 May 2020 13:50:09 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id o22sm2049752iow.25.2020.05.05.13.50.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 13:50:08 -0700 (PDT)
Subject: [bpf-next PATCH 01/10] bpf: selftests,
 move sockmap bpf prog header into progs
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Tue, 05 May 2020 13:49:56 -0700
Message-ID: <158871179665.7537.16914134484622185292.stgit@john-Precision-5820-Tower>
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

Moves test_sockmap_kern.h into progs directory but does not change
code at all.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/progs/test_sockmap_kern.h        |  451 ++++++++++++++++++++
 tools/testing/selftests/bpf/test_sockmap_kern.h    |  451 --------------------
 2 files changed, 451 insertions(+), 451 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_kern.h
 delete mode 100644 tools/testing/selftests/bpf/test_sockmap_kern.h

diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_kern.h b/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
new file mode 100644
index 0000000..9b4d3a6
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
@@ -0,0 +1,451 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2017-2018 Covalent IO, Inc. http://covalent.io */
+#include <stddef.h>
+#include <string.h>
+#include <linux/bpf.h>
+#include <linux/if_ether.h>
+#include <linux/if_packet.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/in.h>
+#include <linux/udp.h>
+#include <linux/tcp.h>
+#include <linux/pkt_cls.h>
+#include <sys/socket.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+/* Sockmap sample program connects a client and a backend together
+ * using cgroups.
+ *
+ *    client:X <---> frontend:80 client:X <---> backend:80
+ *
+ * For simplicity we hard code values here and bind 1:1. The hard
+ * coded values are part of the setup in sockmap.sh script that
+ * is associated with this BPF program.
+ *
+ * The bpf_printk is verbose and prints information as connections
+ * are established and verdicts are decided.
+ */
+
+struct {
+	__uint(type, TEST_MAP_TYPE);
+	__uint(max_entries, 20);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+} sock_map SEC(".maps");
+
+struct {
+	__uint(type, TEST_MAP_TYPE);
+	__uint(max_entries, 20);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+} sock_map_txmsg SEC(".maps");
+
+struct {
+	__uint(type, TEST_MAP_TYPE);
+	__uint(max_entries, 20);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+} sock_map_redir SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, int);
+	__type(value, int);
+} sock_apply_bytes SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, int);
+	__type(value, int);
+} sock_cork_bytes SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 6);
+	__type(key, int);
+	__type(value, int);
+} sock_bytes SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, int);
+	__type(value, int);
+} sock_redir_flags SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, int);
+	__type(value, int);
+} sock_skb_opts SEC(".maps");
+
+SEC("sk_skb1")
+int bpf_prog1(struct __sk_buff *skb)
+{
+	return skb->len;
+}
+
+SEC("sk_skb2")
+int bpf_prog2(struct __sk_buff *skb)
+{
+	__u32 lport = skb->local_port;
+	__u32 rport = skb->remote_port;
+	int len, *f, ret, zero = 0;
+	__u64 flags = 0;
+
+	if (lport == 10000)
+		ret = 10;
+	else
+		ret = 1;
+
+	len = (__u32)skb->data_end - (__u32)skb->data;
+	f = bpf_map_lookup_elem(&sock_skb_opts, &zero);
+	if (f && *f) {
+		ret = 3;
+		flags = *f;
+	}
+
+	bpf_printk("sk_skb2: redirect(%iB) flags=%i\n",
+		   len, flags);
+#ifdef SOCKMAP
+	return bpf_sk_redirect_map(skb, &sock_map, ret, flags);
+#else
+	return bpf_sk_redirect_hash(skb, &sock_map, &ret, flags);
+#endif
+
+}
+
+SEC("sockops")
+int bpf_sockmap(struct bpf_sock_ops *skops)
+{
+	__u32 lport, rport;
+	int op, err = 0, index, key, ret;
+
+
+	op = (int) skops->op;
+
+	switch (op) {
+	case BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB:
+		lport = skops->local_port;
+		rport = skops->remote_port;
+
+		if (lport == 10000) {
+			ret = 1;
+#ifdef SOCKMAP
+			err = bpf_sock_map_update(skops, &sock_map, &ret,
+						  BPF_NOEXIST);
+#else
+			err = bpf_sock_hash_update(skops, &sock_map, &ret,
+						   BPF_NOEXIST);
+#endif
+			bpf_printk("passive(%i -> %i) map ctx update err: %d\n",
+				   lport, bpf_ntohl(rport), err);
+		}
+		break;
+	case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:
+		lport = skops->local_port;
+		rport = skops->remote_port;
+
+		if (bpf_ntohl(rport) == 10001) {
+			ret = 10;
+#ifdef SOCKMAP
+			err = bpf_sock_map_update(skops, &sock_map, &ret,
+						  BPF_NOEXIST);
+#else
+			err = bpf_sock_hash_update(skops, &sock_map, &ret,
+						   BPF_NOEXIST);
+#endif
+			bpf_printk("active(%i -> %i) map ctx update err: %d\n",
+				   lport, bpf_ntohl(rport), err);
+		}
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+SEC("sk_msg1")
+int bpf_prog4(struct sk_msg_md *msg)
+{
+	int *bytes, zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5;
+	int *start, *end, *start_push, *end_push, *start_pop, *pop;
+
+	bytes = bpf_map_lookup_elem(&sock_apply_bytes, &zero);
+	if (bytes)
+		bpf_msg_apply_bytes(msg, *bytes);
+	bytes = bpf_map_lookup_elem(&sock_cork_bytes, &zero);
+	if (bytes)
+		bpf_msg_cork_bytes(msg, *bytes);
+	start = bpf_map_lookup_elem(&sock_bytes, &zero);
+	end = bpf_map_lookup_elem(&sock_bytes, &one);
+	if (start && end)
+		bpf_msg_pull_data(msg, *start, *end, 0);
+	start_push = bpf_map_lookup_elem(&sock_bytes, &two);
+	end_push = bpf_map_lookup_elem(&sock_bytes, &three);
+	if (start_push && end_push)
+		bpf_msg_push_data(msg, *start_push, *end_push, 0);
+	start_pop = bpf_map_lookup_elem(&sock_bytes, &four);
+	pop = bpf_map_lookup_elem(&sock_bytes, &five);
+	if (start_pop && pop)
+		bpf_msg_pop_data(msg, *start_pop, *pop, 0);
+	return SK_PASS;
+}
+
+SEC("sk_msg2")
+int bpf_prog5(struct sk_msg_md *msg)
+{
+	int zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5;
+	int *start, *end, *start_push, *end_push, *start_pop, *pop;
+	int *bytes, len1, len2 = 0, len3, len4;
+	int err1 = -1, err2 = -1;
+
+	bytes = bpf_map_lookup_elem(&sock_apply_bytes, &zero);
+	if (bytes)
+		err1 = bpf_msg_apply_bytes(msg, *bytes);
+	bytes = bpf_map_lookup_elem(&sock_cork_bytes, &zero);
+	if (bytes)
+		err2 = bpf_msg_cork_bytes(msg, *bytes);
+	len1 = (__u64)msg->data_end - (__u64)msg->data;
+	start = bpf_map_lookup_elem(&sock_bytes, &zero);
+	end = bpf_map_lookup_elem(&sock_bytes, &one);
+	if (start && end) {
+		int err;
+
+		bpf_printk("sk_msg2: pull(%i:%i)\n",
+			   start ? *start : 0, end ? *end : 0);
+		err = bpf_msg_pull_data(msg, *start, *end, 0);
+		if (err)
+			bpf_printk("sk_msg2: pull_data err %i\n",
+				   err);
+		len2 = (__u64)msg->data_end - (__u64)msg->data;
+		bpf_printk("sk_msg2: length update %i->%i\n",
+			   len1, len2);
+	}
+
+	start_push = bpf_map_lookup_elem(&sock_bytes, &two);
+	end_push = bpf_map_lookup_elem(&sock_bytes, &three);
+	if (start_push && end_push) {
+		int err;
+
+		bpf_printk("sk_msg2: push(%i:%i)\n",
+			   start_push ? *start_push : 0,
+			   end_push ? *end_push : 0);
+		err = bpf_msg_push_data(msg, *start_push, *end_push, 0);
+		if (err)
+			bpf_printk("sk_msg2: push_data err %i\n", err);
+		len3 = (__u64)msg->data_end - (__u64)msg->data;
+		bpf_printk("sk_msg2: length push_update %i->%i\n",
+			   len2 ? len2 : len1, len3);
+	}
+	start_pop = bpf_map_lookup_elem(&sock_bytes, &four);
+	pop = bpf_map_lookup_elem(&sock_bytes, &five);
+	if (start_pop && pop) {
+		int err;
+
+		bpf_printk("sk_msg2: pop(%i@%i)\n",
+			   start_pop, pop);
+		err = bpf_msg_pop_data(msg, *start_pop, *pop, 0);
+		if (err)
+			bpf_printk("sk_msg2: pop_data err %i\n", err);
+		len4 = (__u64)msg->data_end - (__u64)msg->data;
+		bpf_printk("sk_msg2: length pop_data %i->%i\n",
+			   len1 ? len1 : 0,  len4);
+	}
+
+	bpf_printk("sk_msg2: data length %i err1 %i err2 %i\n",
+		   len1, err1, err2);
+	return SK_PASS;
+}
+
+SEC("sk_msg3")
+int bpf_prog6(struct sk_msg_md *msg)
+{
+	int zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5, key = 0;
+	int *bytes, *start, *end, *start_push, *end_push, *start_pop, *pop, *f;
+	__u64 flags = 0;
+
+	bytes = bpf_map_lookup_elem(&sock_apply_bytes, &zero);
+	if (bytes)
+		bpf_msg_apply_bytes(msg, *bytes);
+	bytes = bpf_map_lookup_elem(&sock_cork_bytes, &zero);
+	if (bytes)
+		bpf_msg_cork_bytes(msg, *bytes);
+
+	start = bpf_map_lookup_elem(&sock_bytes, &zero);
+	end = bpf_map_lookup_elem(&sock_bytes, &one);
+	if (start && end)
+		bpf_msg_pull_data(msg, *start, *end, 0);
+
+	start_push = bpf_map_lookup_elem(&sock_bytes, &two);
+	end_push = bpf_map_lookup_elem(&sock_bytes, &three);
+	if (start_push && end_push)
+		bpf_msg_push_data(msg, *start_push, *end_push, 0);
+
+	start_pop = bpf_map_lookup_elem(&sock_bytes, &four);
+	pop = bpf_map_lookup_elem(&sock_bytes, &five);
+	if (start_pop && pop)
+		bpf_msg_pop_data(msg, *start_pop, *pop, 0);
+
+	f = bpf_map_lookup_elem(&sock_redir_flags, &zero);
+	if (f && *f) {
+		key = 2;
+		flags = *f;
+	}
+#ifdef SOCKMAP
+	return bpf_msg_redirect_map(msg, &sock_map_redir, key, flags);
+#else
+	return bpf_msg_redirect_hash(msg, &sock_map_redir, &key, flags);
+#endif
+}
+
+SEC("sk_msg4")
+int bpf_prog7(struct sk_msg_md *msg)
+{
+	int *bytes, *start, *end, *start_push, *end_push, *start_pop, *pop, *f;
+	int zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5;
+	int len1, len2 = 0, len3, len4;
+	int err1 = 0, err2 = 0, key = 0;
+	__u64 flags = 0;
+
+		int err;
+	bytes = bpf_map_lookup_elem(&sock_apply_bytes, &zero);
+	if (bytes)
+		err1 = bpf_msg_apply_bytes(msg, *bytes);
+	bytes = bpf_map_lookup_elem(&sock_cork_bytes, &zero);
+	if (bytes)
+		err2 = bpf_msg_cork_bytes(msg, *bytes);
+	len1 = (__u64)msg->data_end - (__u64)msg->data;
+
+	start = bpf_map_lookup_elem(&sock_bytes, &zero);
+	end = bpf_map_lookup_elem(&sock_bytes, &one);
+	if (start && end) {
+		bpf_printk("sk_msg2: pull(%i:%i)\n",
+			   start ? *start : 0, end ? *end : 0);
+		err = bpf_msg_pull_data(msg, *start, *end, 0);
+		if (err)
+			bpf_printk("sk_msg2: pull_data err %i\n",
+				   err);
+		len2 = (__u64)msg->data_end - (__u64)msg->data;
+		bpf_printk("sk_msg2: length update %i->%i\n",
+			   len1, len2);
+	}
+
+	start_push = bpf_map_lookup_elem(&sock_bytes, &two);
+	end_push = bpf_map_lookup_elem(&sock_bytes, &three);
+	if (start_push && end_push) {
+		bpf_printk("sk_msg4: push(%i:%i)\n",
+			   start_push ? *start_push : 0,
+			   end_push ? *end_push : 0);
+		err = bpf_msg_push_data(msg, *start_push, *end_push, 0);
+		if (err)
+			bpf_printk("sk_msg4: push_data err %i\n",
+				   err);
+		len3 = (__u64)msg->data_end - (__u64)msg->data;
+		bpf_printk("sk_msg4: length push_update %i->%i\n",
+			   len2 ? len2 : len1, len3);
+	}
+
+	start_pop = bpf_map_lookup_elem(&sock_bytes, &four);
+	pop = bpf_map_lookup_elem(&sock_bytes, &five);
+	if (start_pop && pop) {
+		int err;
+
+		bpf_printk("sk_msg4: pop(%i@%i)\n",
+			   start_pop, pop);
+		err = bpf_msg_pop_data(msg, *start_pop, *pop, 0);
+		if (err)
+			bpf_printk("sk_msg4: pop_data err %i\n", err);
+		len4 = (__u64)msg->data_end - (__u64)msg->data;
+		bpf_printk("sk_msg4: length pop_data %i->%i\n",
+			   len1 ? len1 : 0,  len4);
+	}
+
+
+	f = bpf_map_lookup_elem(&sock_redir_flags, &zero);
+	if (f && *f) {
+		key = 2;
+		flags = *f;
+	}
+	bpf_printk("sk_msg3: redirect(%iB) flags=%i err=%i\n",
+		   len1, flags, err1 ? err1 : err2);
+#ifdef SOCKMAP
+	err = bpf_msg_redirect_map(msg, &sock_map_redir, key, flags);
+#else
+	err = bpf_msg_redirect_hash(msg, &sock_map_redir, &key, flags);
+#endif
+	bpf_printk("sk_msg3: err %i\n", err);
+	return err;
+}
+
+SEC("sk_msg5")
+int bpf_prog8(struct sk_msg_md *msg)
+{
+	void *data_end = (void *)(long) msg->data_end;
+	void *data = (void *)(long) msg->data;
+	int ret = 0, *bytes, zero = 0;
+
+	bytes = bpf_map_lookup_elem(&sock_apply_bytes, &zero);
+	if (bytes) {
+		ret = bpf_msg_apply_bytes(msg, *bytes);
+		if (ret)
+			return SK_DROP;
+	} else {
+		return SK_DROP;
+	}
+	return SK_PASS;
+}
+SEC("sk_msg6")
+int bpf_prog9(struct sk_msg_md *msg)
+{
+	void *data_end = (void *)(long) msg->data_end;
+	void *data = (void *)(long) msg->data;
+	int ret = 0, *bytes, zero = 0;
+
+	bytes = bpf_map_lookup_elem(&sock_cork_bytes, &zero);
+	if (bytes) {
+		if (((__u64)data_end - (__u64)data) >= *bytes)
+			return SK_PASS;
+		ret = bpf_msg_cork_bytes(msg, *bytes);
+		if (ret)
+			return SK_DROP;
+	}
+	return SK_PASS;
+}
+
+SEC("sk_msg7")
+int bpf_prog10(struct sk_msg_md *msg)
+{
+	int *bytes, *start, *end, *start_push, *end_push, *start_pop, *pop;
+	int zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5;
+
+	bytes = bpf_map_lookup_elem(&sock_apply_bytes, &zero);
+	if (bytes)
+		bpf_msg_apply_bytes(msg, *bytes);
+	bytes = bpf_map_lookup_elem(&sock_cork_bytes, &zero);
+	if (bytes)
+		bpf_msg_cork_bytes(msg, *bytes);
+	start = bpf_map_lookup_elem(&sock_bytes, &zero);
+	end = bpf_map_lookup_elem(&sock_bytes, &one);
+	if (start && end)
+		bpf_msg_pull_data(msg, *start, *end, 0);
+	start_push = bpf_map_lookup_elem(&sock_bytes, &two);
+	end_push = bpf_map_lookup_elem(&sock_bytes, &three);
+	if (start_push && end_push)
+		bpf_msg_push_data(msg, *start_push, *end_push, 0);
+	start_pop = bpf_map_lookup_elem(&sock_bytes, &four);
+	pop = bpf_map_lookup_elem(&sock_bytes, &five);
+	if (start_pop && pop)
+		bpf_msg_pop_data(msg, *start_pop, *pop, 0);
+	bpf_printk("return sk drop\n");
+	return SK_DROP;
+}
+
+int _version SEC("version") = 1;
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_sockmap_kern.h b/tools/testing/selftests/bpf/test_sockmap_kern.h
deleted file mode 100644
index 9b4d3a6..0000000
--- a/tools/testing/selftests/bpf/test_sockmap_kern.h
+++ /dev/null
@@ -1,451 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (c) 2017-2018 Covalent IO, Inc. http://covalent.io */
-#include <stddef.h>
-#include <string.h>
-#include <linux/bpf.h>
-#include <linux/if_ether.h>
-#include <linux/if_packet.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <linux/in.h>
-#include <linux/udp.h>
-#include <linux/tcp.h>
-#include <linux/pkt_cls.h>
-#include <sys/socket.h>
-#include <bpf/bpf_helpers.h>
-#include <bpf/bpf_endian.h>
-
-/* Sockmap sample program connects a client and a backend together
- * using cgroups.
- *
- *    client:X <---> frontend:80 client:X <---> backend:80
- *
- * For simplicity we hard code values here and bind 1:1. The hard
- * coded values are part of the setup in sockmap.sh script that
- * is associated with this BPF program.
- *
- * The bpf_printk is verbose and prints information as connections
- * are established and verdicts are decided.
- */
-
-struct {
-	__uint(type, TEST_MAP_TYPE);
-	__uint(max_entries, 20);
-	__uint(key_size, sizeof(int));
-	__uint(value_size, sizeof(int));
-} sock_map SEC(".maps");
-
-struct {
-	__uint(type, TEST_MAP_TYPE);
-	__uint(max_entries, 20);
-	__uint(key_size, sizeof(int));
-	__uint(value_size, sizeof(int));
-} sock_map_txmsg SEC(".maps");
-
-struct {
-	__uint(type, TEST_MAP_TYPE);
-	__uint(max_entries, 20);
-	__uint(key_size, sizeof(int));
-	__uint(value_size, sizeof(int));
-} sock_map_redir SEC(".maps");
-
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__uint(max_entries, 1);
-	__type(key, int);
-	__type(value, int);
-} sock_apply_bytes SEC(".maps");
-
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__uint(max_entries, 1);
-	__type(key, int);
-	__type(value, int);
-} sock_cork_bytes SEC(".maps");
-
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__uint(max_entries, 6);
-	__type(key, int);
-	__type(value, int);
-} sock_bytes SEC(".maps");
-
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__uint(max_entries, 1);
-	__type(key, int);
-	__type(value, int);
-} sock_redir_flags SEC(".maps");
-
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__uint(max_entries, 1);
-	__type(key, int);
-	__type(value, int);
-} sock_skb_opts SEC(".maps");
-
-SEC("sk_skb1")
-int bpf_prog1(struct __sk_buff *skb)
-{
-	return skb->len;
-}
-
-SEC("sk_skb2")
-int bpf_prog2(struct __sk_buff *skb)
-{
-	__u32 lport = skb->local_port;
-	__u32 rport = skb->remote_port;
-	int len, *f, ret, zero = 0;
-	__u64 flags = 0;
-
-	if (lport == 10000)
-		ret = 10;
-	else
-		ret = 1;
-
-	len = (__u32)skb->data_end - (__u32)skb->data;
-	f = bpf_map_lookup_elem(&sock_skb_opts, &zero);
-	if (f && *f) {
-		ret = 3;
-		flags = *f;
-	}
-
-	bpf_printk("sk_skb2: redirect(%iB) flags=%i\n",
-		   len, flags);
-#ifdef SOCKMAP
-	return bpf_sk_redirect_map(skb, &sock_map, ret, flags);
-#else
-	return bpf_sk_redirect_hash(skb, &sock_map, &ret, flags);
-#endif
-
-}
-
-SEC("sockops")
-int bpf_sockmap(struct bpf_sock_ops *skops)
-{
-	__u32 lport, rport;
-	int op, err = 0, index, key, ret;
-
-
-	op = (int) skops->op;
-
-	switch (op) {
-	case BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB:
-		lport = skops->local_port;
-		rport = skops->remote_port;
-
-		if (lport == 10000) {
-			ret = 1;
-#ifdef SOCKMAP
-			err = bpf_sock_map_update(skops, &sock_map, &ret,
-						  BPF_NOEXIST);
-#else
-			err = bpf_sock_hash_update(skops, &sock_map, &ret,
-						   BPF_NOEXIST);
-#endif
-			bpf_printk("passive(%i -> %i) map ctx update err: %d\n",
-				   lport, bpf_ntohl(rport), err);
-		}
-		break;
-	case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:
-		lport = skops->local_port;
-		rport = skops->remote_port;
-
-		if (bpf_ntohl(rport) == 10001) {
-			ret = 10;
-#ifdef SOCKMAP
-			err = bpf_sock_map_update(skops, &sock_map, &ret,
-						  BPF_NOEXIST);
-#else
-			err = bpf_sock_hash_update(skops, &sock_map, &ret,
-						   BPF_NOEXIST);
-#endif
-			bpf_printk("active(%i -> %i) map ctx update err: %d\n",
-				   lport, bpf_ntohl(rport), err);
-		}
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-}
-
-SEC("sk_msg1")
-int bpf_prog4(struct sk_msg_md *msg)
-{
-	int *bytes, zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5;
-	int *start, *end, *start_push, *end_push, *start_pop, *pop;
-
-	bytes = bpf_map_lookup_elem(&sock_apply_bytes, &zero);
-	if (bytes)
-		bpf_msg_apply_bytes(msg, *bytes);
-	bytes = bpf_map_lookup_elem(&sock_cork_bytes, &zero);
-	if (bytes)
-		bpf_msg_cork_bytes(msg, *bytes);
-	start = bpf_map_lookup_elem(&sock_bytes, &zero);
-	end = bpf_map_lookup_elem(&sock_bytes, &one);
-	if (start && end)
-		bpf_msg_pull_data(msg, *start, *end, 0);
-	start_push = bpf_map_lookup_elem(&sock_bytes, &two);
-	end_push = bpf_map_lookup_elem(&sock_bytes, &three);
-	if (start_push && end_push)
-		bpf_msg_push_data(msg, *start_push, *end_push, 0);
-	start_pop = bpf_map_lookup_elem(&sock_bytes, &four);
-	pop = bpf_map_lookup_elem(&sock_bytes, &five);
-	if (start_pop && pop)
-		bpf_msg_pop_data(msg, *start_pop, *pop, 0);
-	return SK_PASS;
-}
-
-SEC("sk_msg2")
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
-int bpf_prog6(struct sk_msg_md *msg)
-{
-	int zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5, key = 0;
-	int *bytes, *start, *end, *start_push, *end_push, *start_pop, *pop, *f;
-	__u64 flags = 0;
-
-	bytes = bpf_map_lookup_elem(&sock_apply_bytes, &zero);
-	if (bytes)
-		bpf_msg_apply_bytes(msg, *bytes);
-	bytes = bpf_map_lookup_elem(&sock_cork_bytes, &zero);
-	if (bytes)
-		bpf_msg_cork_bytes(msg, *bytes);
-
-	start = bpf_map_lookup_elem(&sock_bytes, &zero);
-	end = bpf_map_lookup_elem(&sock_bytes, &one);
-	if (start && end)
-		bpf_msg_pull_data(msg, *start, *end, 0);
-
-	start_push = bpf_map_lookup_elem(&sock_bytes, &two);
-	end_push = bpf_map_lookup_elem(&sock_bytes, &three);
-	if (start_push && end_push)
-		bpf_msg_push_data(msg, *start_push, *end_push, 0);
-
-	start_pop = bpf_map_lookup_elem(&sock_bytes, &four);
-	pop = bpf_map_lookup_elem(&sock_bytes, &five);
-	if (start_pop && pop)
-		bpf_msg_pop_data(msg, *start_pop, *pop, 0);
-
-	f = bpf_map_lookup_elem(&sock_redir_flags, &zero);
-	if (f && *f) {
-		key = 2;
-		flags = *f;
-	}
-#ifdef SOCKMAP
-	return bpf_msg_redirect_map(msg, &sock_map_redir, key, flags);
-#else
-	return bpf_msg_redirect_hash(msg, &sock_map_redir, &key, flags);
-#endif
-}
-
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
-int bpf_prog8(struct sk_msg_md *msg)
-{
-	void *data_end = (void *)(long) msg->data_end;
-	void *data = (void *)(long) msg->data;
-	int ret = 0, *bytes, zero = 0;
-
-	bytes = bpf_map_lookup_elem(&sock_apply_bytes, &zero);
-	if (bytes) {
-		ret = bpf_msg_apply_bytes(msg, *bytes);
-		if (ret)
-			return SK_DROP;
-	} else {
-		return SK_DROP;
-	}
-	return SK_PASS;
-}
-SEC("sk_msg6")
-int bpf_prog9(struct sk_msg_md *msg)
-{
-	void *data_end = (void *)(long) msg->data_end;
-	void *data = (void *)(long) msg->data;
-	int ret = 0, *bytes, zero = 0;
-
-	bytes = bpf_map_lookup_elem(&sock_cork_bytes, &zero);
-	if (bytes) {
-		if (((__u64)data_end - (__u64)data) >= *bytes)
-			return SK_PASS;
-		ret = bpf_msg_cork_bytes(msg, *bytes);
-		if (ret)
-			return SK_DROP;
-	}
-	return SK_PASS;
-}
-
-SEC("sk_msg7")
-int bpf_prog10(struct sk_msg_md *msg)
-{
-	int *bytes, *start, *end, *start_push, *end_push, *start_pop, *pop;
-	int zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5;
-
-	bytes = bpf_map_lookup_elem(&sock_apply_bytes, &zero);
-	if (bytes)
-		bpf_msg_apply_bytes(msg, *bytes);
-	bytes = bpf_map_lookup_elem(&sock_cork_bytes, &zero);
-	if (bytes)
-		bpf_msg_cork_bytes(msg, *bytes);
-	start = bpf_map_lookup_elem(&sock_bytes, &zero);
-	end = bpf_map_lookup_elem(&sock_bytes, &one);
-	if (start && end)
-		bpf_msg_pull_data(msg, *start, *end, 0);
-	start_push = bpf_map_lookup_elem(&sock_bytes, &two);
-	end_push = bpf_map_lookup_elem(&sock_bytes, &three);
-	if (start_push && end_push)
-		bpf_msg_push_data(msg, *start_push, *end_push, 0);
-	start_pop = bpf_map_lookup_elem(&sock_bytes, &four);
-	pop = bpf_map_lookup_elem(&sock_bytes, &five);
-	if (start_pop && pop)
-		bpf_msg_pop_data(msg, *start_pop, *pop, 0);
-	bpf_printk("return sk drop\n");
-	return SK_DROP;
-}
-
-int _version SEC("version") = 1;
-char _license[] SEC("license") = "GPL";

