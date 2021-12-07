Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6F846C7DA
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 23:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242314AbhLGXBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 18:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhLGXBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 18:01:53 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56057C061574;
        Tue,  7 Dec 2021 14:58:22 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id y13so1767989edd.13;
        Tue, 07 Dec 2021 14:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DR+C0VgKU3YiSLjKaSxBhVacM0Ha9yIihcP8AimqUpo=;
        b=p9GZzhM0S5JIOsTAevdhn/R90s+xP55dPIjZ4GLtILt3rsjPTNQtmc8veeZD0poyYn
         D5rEOSfd4GRFv7xXFuva6nwaOrhNNckItcGFLR4HTNISPQPjk6GXPKxxmI1E2f6L0G1j
         Dgru18Y6qwzAPb/UaZvDujxcUjPHFMjDntUzq5EOJWa/tS1Fs+r7cUXT6i2OqhMoBqy4
         VCd62mP5XWnsoMfjLyM+9eUPoQMlf97jMVtEbKTh+unjR5mCywbNOYyRrIKEY39WBaLB
         F6CHRBXt497cz0mTQHVDr+iBL80vwru0sPuOb97BwztileVnN1WembNuMkdBQWK9O/Jb
         hckg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DR+C0VgKU3YiSLjKaSxBhVacM0Ha9yIihcP8AimqUpo=;
        b=Nec8LTY75Q4oHuZ9RsMNgzx8feVHaJQMvQWFg3Xn7Oh/ujk26wV7tgaYDjkaq8HAEz
         uAJAgl1Mdaszgd5u/LbHuFQjH9i/Ijd6qq43SnPti7Z9YiNxX2cqqOYb5HRnFAsd6ROP
         sQe0AgRykn1UqfmPPxqFPaAKQ0t7a3c6QRfZwcbsPC5TKlE4GTJMo/GPSs/hPQwdKSYe
         0q1G0z66RW3v0Z9s9VnAQvv0sIZvcEGS2BU4QdehT1rwidlUQdsSjDFqJTbVWYCvYgTp
         hAyI2M67cMHc4+a5GF+mhV9p23F1F8cb6qvw2bpXRWnb3KDA/BSOkZe0E1bzU9dsjVIH
         THAw==
X-Gm-Message-State: AOAM531dwDaTvych3/HzN02hBCcbHTokEFygXtgp2MIL9X5h6pfIAnFu
        CT577R2PusakU/xIyfblj2CfpUkO+EipGg==
X-Google-Smtp-Source: ABdhPJwKIERTWec748bK/0dJb4oHmiOOktmqcnckHV6uYoZV6x6vnXbiPRuZ0mRVqAbwfAkoZUwJ6g==
X-Received: by 2002:a17:907:1c0a:: with SMTP id nc10mr2823981ejc.211.1638917900548;
        Tue, 07 Dec 2021 14:58:20 -0800 (PST)
Received: from localhost.localdomain ([2a02:a03f:c062:a800:5f01:482d:95e2:b968])
        by smtp.gmail.com with ESMTPSA id q17sm763554edd.10.2021.12.07.14.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 14:58:19 -0800 (PST)
From:   Mathieu Jadin <mathjadin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Mathieu Jadin <mathjadin@gmail.com>, KP Singh <kpsingh@kernel.org>,
        netdev@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Joe Stringer <joe@cilium.io>, David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH bpf-next v2 1/3] net: Parse IPv6 ext headers from TCP sock_ops
Date:   Tue,  7 Dec 2021 23:56:33 +0100
Message-Id: <20211207225635.113904-1-mathjadin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1638916136; l=6400; s=20211207; h=from:subject; bh=O3IKAtE92hFjtYfj793ecpJ7UeU50Fv21BEpunzo1Hc=; b=j/SFdPM3itqZL7RdC7lzly11AUIcv4RKjdSGRarnR5Bp1iVOPS3jUvr7o4TbRE0PdZuZCPhE385i 0AF5A3oMDEo1lMzcv+m7D0EYNwHi1cfOj2I/bDWqiiupOozgdvUn
X-Developer-Key: i=mathjadin@gmail.com; a=ed25519; pk=LX0wKHMKZralQziQacrPu4w5BceQsC7CocWV714TPRU=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a flag that, if set, triggers the call of eBPF program for each
packet holding an IPv6 extension header. Also add a sock_ops operator
that identifies such call.

This change uses skb_data and skb_data_end introduced for TCP options'
parsing but these pointer cover the IPv6 header and its extension
headers.

For instance, this change allows to read an eBPF sock_ops program to
read complex Segment Routing Headers carrying complex messages in TLV or
observing its intermediate segments as soon as they are received.

Signed-off-by: Mathieu Jadin <mathjadin@gmail.com>
---
 include/uapi/linux/bpf.h       | 26 +++++++++++++++++++++++++-
 net/ipv6/tcp_ipv6.c            | 26 ++++++++++++++++++++++++--
 tools/include/uapi/linux/bpf.h | 26 +++++++++++++++++++++++++-
 3 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c26871263f1f..34e48f5727a4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5849,6 +5849,10 @@ struct bpf_sock_ops {
 	 *					the 3WHS.
 	 *
 	 * bpf_load_hdr_opt() can also be used to read a particular option.
+	 *
+	 * Under sock_ops->op ==  BPF_SOCK_OPS_PARSE_IP6_HDR_CB,
+	 * [skb_data, skb_data_end] covers the whole IPv6 header
+	 * with its extension headers.
 	 */
 	__bpf_md_ptr(void *, skb_data);
 	__bpf_md_ptr(void *, skb_data_end);
@@ -5917,8 +5921,15 @@ enum {
 	 * options first before the BPF program does.
 	 */
 	BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG = (1<<6),
+	/* Call bpf for all received IPv6 extension headers.  The bpf prog will
+	 * be called under sock_ops->op == BPF_SOCK_OPS_PARSE_IPV6_HDR_CB and
+	 * will be able to parse the IPv6 header and its extension headers.
+	 *
+	 * The bpf prog will usually turn this off in the common cases.
+	 */
+	BPF_SOCK_OPS_PARSE_IPV6_HDR_CB_FLAG = (1<<7),
 /* Mask of all currently supported cb flags */
-	BPF_SOCK_OPS_ALL_CB_FLAGS       = 0x7F,
+	BPF_SOCK_OPS_ALL_CB_FLAGS       = 0xFF,
 };
 
 /* List of known BPF sock_ops operators.
@@ -6031,6 +6042,19 @@ enum {
 					 * by the kernel or the
 					 * earlier bpf-progs.
 					 */
+	BPF_SOCK_OPS_PARSE_IPV6_HDR_CB,	/* Parse the IPv6 extension
+					 * header option.
+					 * It will be called to handle
+					 * the packets received at
+					 * an already established
+					 * connection with an extension
+					 * header.
+					 *
+					 * sock_ops->skb_data:
+					 * Referring to the received skb.
+					 * It covers the IPv6 header and
+					 * its extension headers only.
+					 */
 };
 
 /* List of TCP states. There is a build check in net/ipv4/tcp.c to detect
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 551fce49841d..6b47c973f776 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1470,7 +1470,7 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 {
 	struct ipv6_pinfo *np = tcp_inet6_sk(sk);
 	struct sk_buff *opt_skb = NULL;
-	struct tcp_sock *tp;
+	struct tcp_sock *tp = tcp_sk(sk);
 
 	/* Imagine: socket is IPv6. IPv4 packet arrives,
 	   goes to IPv4 receive handler and backlogged.
@@ -1518,6 +1518,29 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 			}
 		}
 
+		/* Call ebpf on packets with extension headers */
+		if (BPF_SOCK_OPS_TEST_FLAG(tp, BPF_SOCK_OPS_PARSE_IPV6_HDR_CB_FLAG) &&
+		    ipv6_hdr(skb)->nexthdr != IPPROTO_TCP) {
+			struct bpf_sock_ops_kern sock_ops;
+			void *old_data_ptr;
+
+			memset(&sock_ops, 0,
+			       offsetof(struct bpf_sock_ops_kern, temp));
+			if (sk_fullsock(sk)) {
+				sock_ops.is_fullsock = 1;
+				sock_owned_by_me(sk);
+			}
+			sock_ops.op = BPF_SOCK_OPS_PARSE_IPV6_HDR_CB;
+			sock_ops.sk = sk;
+			sock_ops.skb = skb;
+			/* Temporary use the network header as skb data */
+			sock_ops.skb_data_end = skb_transport_header(skb);
+			old_data_ptr = skb->data;
+			skb->data = skb_network_header(skb);
+			BPF_CGROUP_RUN_PROG_SOCK_OPS(&sock_ops);
+			skb->data = old_data_ptr;
+		}
+
 		tcp_rcv_established(sk, skb);
 		if (opt_skb)
 			goto ipv6_pktoptions;
@@ -1571,7 +1594,6 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 	   3. socket is not in passive state.
 	   4. Finally, it really contains options, which user wants to receive.
 	 */
-	tp = tcp_sk(sk);
 	if (TCP_SKB_CB(opt_skb)->end_seq == tp->rcv_nxt &&
 	    !((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN))) {
 		if (np->rxopt.bits.rxinfo || np->rxopt.bits.rxoinfo)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index c26871263f1f..34e48f5727a4 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5849,6 +5849,10 @@ struct bpf_sock_ops {
 	 *					the 3WHS.
 	 *
 	 * bpf_load_hdr_opt() can also be used to read a particular option.
+	 *
+	 * Under sock_ops->op ==  BPF_SOCK_OPS_PARSE_IP6_HDR_CB,
+	 * [skb_data, skb_data_end] covers the whole IPv6 header
+	 * with its extension headers.
 	 */
 	__bpf_md_ptr(void *, skb_data);
 	__bpf_md_ptr(void *, skb_data_end);
@@ -5917,8 +5921,15 @@ enum {
 	 * options first before the BPF program does.
 	 */
 	BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG = (1<<6),
+	/* Call bpf for all received IPv6 extension headers.  The bpf prog will
+	 * be called under sock_ops->op == BPF_SOCK_OPS_PARSE_IPV6_HDR_CB and
+	 * will be able to parse the IPv6 header and its extension headers.
+	 *
+	 * The bpf prog will usually turn this off in the common cases.
+	 */
+	BPF_SOCK_OPS_PARSE_IPV6_HDR_CB_FLAG = (1<<7),
 /* Mask of all currently supported cb flags */
-	BPF_SOCK_OPS_ALL_CB_FLAGS       = 0x7F,
+	BPF_SOCK_OPS_ALL_CB_FLAGS       = 0xFF,
 };
 
 /* List of known BPF sock_ops operators.
@@ -6031,6 +6042,19 @@ enum {
 					 * by the kernel or the
 					 * earlier bpf-progs.
 					 */
+	BPF_SOCK_OPS_PARSE_IPV6_HDR_CB,	/* Parse the IPv6 extension
+					 * header option.
+					 * It will be called to handle
+					 * the packets received at
+					 * an already established
+					 * connection with an extension
+					 * header.
+					 *
+					 * sock_ops->skb_data:
+					 * Referring to the received skb.
+					 * It covers the IPv6 header and
+					 * its extension headers only.
+					 */
 };
 
 /* List of TCP states. There is a build check in net/ipv4/tcp.c to detect
-- 
2.32.0

