Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BE846C0A4
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 17:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239612AbhLGQ04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 11:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbhLGQ04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 11:26:56 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAA2C061574;
        Tue,  7 Dec 2021 08:23:25 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z5so59454602edd.3;
        Tue, 07 Dec 2021 08:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9oqp5gC4U1yrXlRrtiPB4tXMkDh4iQAs6I6nnm3mqO8=;
        b=kO0b4ER6FijjDN8tDAJ7ruTvoFD7ZZkn88ok2u2dejMkqoep294mEJm8g/6j9rgzxn
         JAuHmnzb+FDRDObsecCzWVlC5ZonJWrweFH/bOgHoPvzsFvB2eaecyry8J9cyq6mkBr7
         0FeDz7TDMVTIumxwsluVdZ2ZsBPExJX6Ud44+PScVRV8+TVXjTTBWFhe2kpt+Q6m8k7p
         h3WW2/wZVLHn3YVg+lMQd2qKPgNqhDZUkYWCbKuvgK0n7WQQWK3Zr3PxpWExa/FOv2vw
         8B0Vbd2zoW4MlmAzH2Z8t4lQ6LlmpSfJCmS6cQU8PQr+efWRMjowDud7mSXmj8sZVu74
         i4GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9oqp5gC4U1yrXlRrtiPB4tXMkDh4iQAs6I6nnm3mqO8=;
        b=AsPnquwloIfBgPaHPJPkyiUg6hsiuOfVLhM26zKoSmi1XCO3oSPmV3fQAutl8ZTicb
         mmn5v/cVRHu6Nk7ZnU1ZZel6wzgRrxRVaVZ1DLzSkcpYbpK2FqEQXdqArY/uBJUpFTJG
         j6/nQZbj8JhNVPOhsve8NYSrtJvDtOlpVRdrYcBOreV/GW6/gwQLZzQj4jDsN/KF2t43
         C1zvuVCSsSnbtvJSLSZ1K7/xGrtaOtY+66tD9gBgzGLDoUNqFD2P8YHY9zmwLPJP77bE
         8nx3AD2O/8AJfVvihWBfKD38aRJjtwiCPSSYPBj/R6RtsOtaxfOZFM+zzkrKFlejsEbl
         pbNQ==
X-Gm-Message-State: AOAM532hk9MiUylkIQH5SARPNay3fkrxGw7ax/UQCGigGHq32Z1SLC0E
        jbF4ASMgsJFIl6YKT3UwIJWDAIAssQEYMQ==
X-Google-Smtp-Source: ABdhPJyPxTek5oNwUyRQ+DNariL93gXY+vKD7Bb2FN5kDQMTN+X5lENaDqFZVrZz4NkhNweWDr62OA==
X-Received: by 2002:a05:6402:350a:: with SMTP id b10mr10480098edd.184.1638894203661;
        Tue, 07 Dec 2021 08:23:23 -0800 (PST)
Received: from localhost.localdomain ([2a02:a03f:c062:a800:5f01:482d:95e2:b968])
        by smtp.gmail.com with ESMTPSA id i10sm6757ejw.48.2021.12.07.08.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 08:23:23 -0800 (PST)
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
Subject: [PATCH bpf-next 1/2] net: Parse IPv6 ext headers from TCP sock_ops
Date:   Tue,  7 Dec 2021 17:22:48 +0100
Message-Id: <20211207162249.301625-1-mathjadin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1638889208; l=6379; s=20211207; h=from:subject; bh=Bbe+Ohrqkxx2Esa6K60Lj8KpTgrNAl2MtOL5pnFIxJA=; b=ADKvUBYU3JNs/3Ly25B5Uku40eDgaoCoijxMdA4IhJ2QveiRDwAWcCSou8+/cuHOO2lnWrxNSgGu FbfEG0giBX0wTdy5Qvjxi/s9ubUC7KzjoNVR2VwqVGzEf11nNOQX
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
index 6297eafdc40f..79968e57b0b0 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5822,6 +5822,10 @@ struct bpf_sock_ops {
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
@@ -5890,8 +5894,15 @@ enum {
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
@@ -6004,6 +6015,19 @@ enum {
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
index 3b7d6ede1364..20c83c089ebf 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1471,7 +1471,7 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 {
 	struct ipv6_pinfo *np = tcp_inet6_sk(sk);
 	struct sk_buff *opt_skb = NULL;
-	struct tcp_sock *tp;
+	struct tcp_sock *tp = tcp_sk(sk);
 
 	/* Imagine: socket is IPv6. IPv4 packet arrives,
 	   goes to IPv4 receive handler and backlogged.
@@ -1519,6 +1519,29 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
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
@@ -1572,7 +1595,6 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 	   3. socket is not in passive state.
 	   4. Finally, it really contains options, which user wants to receive.
 	 */
-	tp = tcp_sk(sk);
 	if (TCP_SKB_CB(opt_skb)->end_seq == tp->rcv_nxt &&
 	    !((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN))) {
 		if (np->rxopt.bits.rxinfo || np->rxopt.bits.rxoinfo)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 6297eafdc40f..79968e57b0b0 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5822,6 +5822,10 @@ struct bpf_sock_ops {
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
@@ -5890,8 +5894,15 @@ enum {
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
@@ -6004,6 +6015,19 @@ enum {
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

