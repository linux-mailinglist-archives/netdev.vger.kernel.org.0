Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C40529BDB
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242564AbiEQIMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242527AbiEQILy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:11:54 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DC33CA57;
        Tue, 17 May 2022 01:11:52 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 137so16301845pgb.5;
        Tue, 17 May 2022 01:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qSi6S3M6hUob0GWOOxB6gDONEJlCHyD3XkZQid/wuws=;
        b=PMnJNleIpy37YTNvv5ff7xIrlmIxC3I4r5UL0n9mbXd2I1iIDfvpW5Ie7iHnK9crXW
         6dx+nzX1t1uau5q5Zz7+Q4BM6r9xItM1ZaPocRDr8HNrWDN297aa/D/5HEqTcwQmU8aX
         9qcYd7zfsEkog2ex4UPchekWPL6cz66vF6xHkLe0Gl9uLer/WtqJFlG3884WtUX6Hd6h
         d8F1hTVcoCIG6wJNVKCWVa85GN5lLcr3y6T2kHLWJcy4qO49HMR5uXHk8Hc5wOaz8gh9
         1L05h9wgz1sYZ3iqdz5oLacwvnHBNdVMTZXrcal8OTOR8vFnv/6EgTlhb+3s6hZ4cVFS
         ykbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qSi6S3M6hUob0GWOOxB6gDONEJlCHyD3XkZQid/wuws=;
        b=VX9AgDuaoN153LKjEqd0obz4AnVZZebShnYErqOeH3Lf4AJppIDkkhg6dCSfFaxIwz
         EhF4FE2nCiZIio7c7ZLdpLt6CRQyT274DwdkLg1NZ708MsIPsdcfyQCzsZxj/bt6k5zN
         Ks2JNTUlLACcgbz56x65SXIVF6WNJ6VoPjb/Dt+aRXtk9RZ/j4BdNGVAiVZRw0MYjzdS
         Sirhe2OXY56L+Ja20aKGhoTSqyIjWeyd81N6r6M8bKhVp7wBAjXrHg7WChW5ma4MGZqd
         leFb0yJ5JYP+xxKOrXbL0AMkidqfcUTOYr5ObtCx58SF9tkLTzrbRir1mlTE9Dxp/IDt
         GDrA==
X-Gm-Message-State: AOAM5327MlX5oTpuJplFHbfXFYd4XsR/3innzAJApPPhnyKr4Yl8aTxC
        jJWS+qXsxCqQVQQW1xx9T/A=
X-Google-Smtp-Source: ABdhPJzEo8O0t9RSZnIyikzKdNI7TQcKYq6sorCBI1gr2QXrUxMZZx/KomUpwIv62aJhKLSjnPRu+g==
X-Received: by 2002:a63:d145:0:b0:3c1:4ba0:d890 with SMTP id c5-20020a63d145000000b003c14ba0d890mr18495572pgj.607.1652775111671;
        Tue, 17 May 2022 01:11:51 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.20])
        by smtp.gmail.com with ESMTPSA id c14-20020a170902c2ce00b0015e8d4eb2easm8336306pla.308.2022.05.17.01.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 01:11:51 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: [PATCH net-next v2 1/9] net: skb: introduce __DEFINE_SKB_DROP_REASON() to simply the code
Date:   Tue, 17 May 2022 16:10:00 +0800
Message-Id: <20220517081008.294325-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220517081008.294325-1-imagedong@tencent.com>
References: <20220517081008.294325-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

It is annoying to add new skb drop reasons to 'enum skb_drop_reason'
and TRACE_SKB_DROP_REASON in trace/event/skb.h, and it's easy to forget
to add the new reasons we added to TRACE_SKB_DROP_REASON.

TRACE_SKB_DROP_REASON is used to convert drop reason of type number
to string. For now, the string we passed to user space is exactly the
same as the name in 'enum skb_drop_reason' with a 'SKB_DROP_REASON_'
prefix. So why not make them togather by define a macro?

Therefore, introduce __DEFINE_SKB_DROP_REASON() and use it for 'enum
skb_drop_reason' definition and string converting.

Now, what should we with the document for the reasons? How about follow
__BPF_FUNC_MAPPER() and make these document togather?

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 444 ++++++++++++++++++++++++-------------
 include/trace/events/skb.h |  89 +-------
 net/core/drop_monitor.c    |  13 --
 net/core/skbuff.c          |  10 +
 4 files changed, 297 insertions(+), 259 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4db3f4a33580..dfc568844df2 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -337,169 +337,295 @@ struct sk_buff_head {
 
 struct sk_buff;
 
+/*
+ * SKB_DROP_REASON_NOT_SPECIFIED
+ *	drop reason is not specified
+ *
+ * SKB_DROP_REASON_NO_SOCKET
+ *	socket not found
+ *
+ * SKB_DROP_REASON_PKT_TOO_SMALL
+ *	packet size is too small
+ *
+ * SKB_DROP_REASON_TCP_CSUM
+ *	TCP checksum error
+ *
+ * SKB_DROP_REASON_SOCKET_FILTER
+ *	dropped by socket filter
+ *
+ * SKB_DROP_REASON_UDP_CSUM
+ *	UDP checksum error
+ *
+ * SKB_DROP_REASON_NETFILTER_DROP
+ *	dropped by netfilter
+ *
+ * SKB_DROP_REASON_OTHERHOST
+ *	packet don't belong to current host (interface is in promisc
+ *	mode)
+ *
+ * SKB_DROP_REASON_IP_CSUM
+ *	IP checksum error
+ *
+ * SKB_DROP_REASON_IP_INHDR
+ *	there is something wrong with IP header (see
+ *	IPSTATS_MIB_INHDRERRORS)
+ *
+ * SKB_DROP_REASON_IP_RPFILTER
+ *	IP rpfilter validate failed. see the document for rp_filter
+ *	in ip-sysctl.rst for more information
+ *
+ * SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST
+ *	destination address of L2 is multicast, but L3 is unicast.
+ *
+ * SKB_DROP_REASON_XFRM_POLICY
+ *	xfrm policy check failed
+ *
+ * SKB_DROP_REASON_IP_NOPROTO
+ *	no support for IP protocol
+ *
+ * SKB_DROP_REASON_SOCKET_RCVBUFF
+ *	socket receive buff is full
+ *
+ * SKB_DROP_REASON_PROTO_MEM
+ *	proto memory limition, such as udp packet drop out of
+ *	udp_memory_allocated.
+ *
+ * SKB_DROP_REASON_TCP_MD5NOTFOUND
+ *	no MD5 hash and one expected, corresponding to
+ *	LINUX_MIB_TCPMD5NOTFOUND
+ *
+ * SKB_DROP_REASON_TCP_MD5UNEXPECTED
+ *	MD5 hash and we're not expecting one, corresponding to
+ *	LINUX_MIB_TCPMD5UNEXPECTED
+ *
+ * SKB_DROP_REASON_TCP_MD5FAILURE
+ *	MD5 hash and its wrong, corresponding to LINUX_MIB_TCPMD5FAILURE
+ *
+ * SKB_DROP_REASON_SOCKET_BACKLOG
+ *	failed to add skb to socket backlog (see LINUX_MIB_TCPBACKLOGDROP)
+ *
+ * SKB_DROP_REASON_TCP_FLAGS
+ *	TCP flags invalid
+ *
+ * SKB_DROP_REASON_TCP_ZEROWINDOW
+ *	TCP receive window size is zero, see LINUX_MIB_TCPZEROWINDOWDROP
+ *
+ * SKB_DROP_REASON_TCP_OLD_DATA
+ *	the TCP data reveived is already received before (spurious
+ *	retrans may happened), see LINUX_MIB_DELAYEDACKLOST
+ *
+ * SKB_DROP_REASON_TCP_OVERWINDOW
+ *	the TCP data is out of window, the seq of the first byte exceed
+ *	the right edges of receive window
+ *
+ * SKB_DROP_REASON_TCP_OFOMERGE
+ *	the data of skb is already in the ofo queue, corresponding to
+ *	LINUX_MIB_TCPOFOMERGE
+ *
+ * SKB_DROP_REASON_TCP_RFC7323_PAWS
+ *	PAWS check, corresponding to LINUX_MIB_PAWSESTABREJECTED
+ *
+ * SKB_DROP_REASON_TCP_INVALID_SEQUENCE
+ *	Not acceptable SEQ field
+ *
+ * SKB_DROP_REASON_TCP_RESET
+ *	Invalid RST packet
+ *
+ * SKB_DROP_REASON_TCP_INVALID_SYN
+ *	Incoming packet has unexpected SYN flag
+ *
+ * SKB_DROP_REASON_TCP_CLOSE
+ *	TCP socket in CLOSE state
+ *
+ * SKB_DROP_REASON_TCP_FASTOPEN
+ *	dropped by FASTOPEN request socket
+ *
+ * SKB_DROP_REASON_TCP_OLD_ACK
+ *	TCP ACK is old, but in window
+ *
+ * SKB_DROP_REASON_TCP_TOO_OLD_ACK
+ *	TCP ACK is too old
+ *
+ * SKB_DROP_REASON_TCP_ACK_UNSENT_DATA
+ *	TCP ACK for data we haven't sent yet
+ *
+ * SKB_DROP_REASON_TCP_OFO_QUEUE_PRUNE
+ *	pruned from TCP OFO queue
+ *
+ * SKB_DROP_REASON_TCP_OFO_DROP
+ *	data already in receive queue
+ *
+ * SKB_DROP_REASON_IP_OUTNOROUTES
+ *	route lookup failed
+ *
+ * SKB_DROP_REASON_BPF_CGROUP_EGRESS
+ *	dropped by BPF_PROG_TYPE_CGROUP_SKB eBPF program
+ *
+ * SKB_DROP_REASON_IPV6DISABLED
+ *	IPv6 is disabled on the device
+ *
+ * SKB_DROP_REASON_NEIGH_CREATEFAIL
+ *	failed to create neigh entry
+ *
+ * SKB_DROP_REASON_NEIGH_FAILED
+ *	neigh entry in failed state
+ *
+ * SKB_DROP_REASON_NEIGH_QUEUEFULL
+ *	arp_queue for neigh entry is full
+ *
+ * SKB_DROP_REASON_NEIGH_DEAD
+ *	neigh entry is dead
+ *
+ * SKB_DROP_REASON_TC_EGRESS
+ *	dropped in TC egress HOOK
+ *
+ * SKB_DROP_REASON_QDISC_DROP
+ *	dropped by qdisc when packet outputting (failed to enqueue to
+ *	current qdisc)
+ *
+ * SKB_DROP_REASON_CPU_BACKLOG
+ *	failed to enqueue the skb to the per CPU backlog queue. This
+ *	can be caused by backlog queue full (see netdev_max_backlog in
+ *	net.rst) or RPS flow limit
+ *
+ * SKB_DROP_REASON_XDP
+ *	dropped by XDP in input path
+ *
+ * SKB_DROP_REASON_TC_INGRESS
+ *	dropped in TC ingress HOOK
+ *
+ * SKB_DROP_REASON_UNHANDLED_PROTO
+ *	protocol not implemented or not supported
+ *
+ * SKB_DROP_REASON_SKB_CSUM
+ *	sk_buff checksum computation error
+ *
+ * SKB_DROP_REASON_SKB_GSO_SEG
+ *	gso segmentation error
+ *
+ * SKB_DROP_REASON_SKB_UCOPY_FAULT
+ *	failed to copy data from user space, e.g., via
+ *	zerocopy_sg_from_iter() or skb_orphan_frags_rx()
+ *
+ * SKB_DROP_REASON_DEV_HDR
+ *	device driver specific header/metadata is invalid
+ *
+ * SKB_DROP_REASON_DEV_READY
+ *	the device is not ready to xmit/recv due to any of its data
+ *	structure that is not up/ready/initialized, e.g., the IFF_UP is
+ *	not set, or driver specific tun->tfiles[txq] is not initialized
+ *
+ * SKB_DROP_REASON_FULL_RING
+ *	ring buffer is full
+ *
+ * SKB_DROP_REASON_NOMEM
+ *	error due to OOM
+ *
+ * SKB_DROP_REASON_HDR_TRUNC
+ *	failed to trunc/extract the header from networking data, e.g.,
+ *	failed to pull the protocol header from frags via
+ *	pskb_may_pull()
+ *
+ * SKB_DROP_REASON_TAP_FILTER
+ *	dropped by (ebpf) filter directly attached to tun/tap, e.g., via
+ *	TUNSETFILTEREBPF
+ *
+ * SKB_DROP_REASON_TAP_TXFILTER
+ *	dropped by tx filter implemented at tun/tap, e.g., check_filter()
+ *
+ * SKB_DROP_REASON_ICMP_CSUM
+ *	ICMP checksum error
+ *
+ * SKB_DROP_REASON_INVALID_PROTO
+ *	the packet doesn't follow RFC 2211, such as a broadcasts
+ *	ICMP_TIMESTAMP
+ *
+ * SKB_DROP_REASON_IP_INADDRERRORS
+ *	host unreachable, corresponding to IPSTATS_MIB_INADDRERRORS
+ *
+ * SKB_DROP_REASON_IP_INNOROUTES
+ *	network unreachable, corresponding to IPSTATS_MIB_INADDRERRORS
+ *
+ * SKB_DROP_REASON_PKT_TOO_BIG
+ *	packet size is too big (maybe exceed the MTU)
+ */
+#define __DEFINE_SKB_DROP_REASON(FN)	\
+	FN(NOT_SPECIFIED)		\
+	FN(NO_SOCKET)			\
+	FN(PKT_TOO_SMALL)		\
+	FN(TCP_CSUM)			\
+	FN(SOCKET_FILTER)		\
+	FN(UDP_CSUM)			\
+	FN(NETFILTER_DROP)		\
+	FN(OTHERHOST)			\
+	FN(IP_CSUM)			\
+	FN(IP_INHDR)			\
+	FN(IP_RPFILTER)			\
+	FN(UNICAST_IN_L2_MULTICAST)	\
+	FN(XFRM_POLICY)			\
+	FN(IP_NOPROTO)			\
+	FN(SOCKET_RCVBUFF)		\
+	FN(PROTO_MEM)			\
+	FN(TCP_MD5NOTFOUND)		\
+	FN(TCP_MD5UNEXPECTED)		\
+	FN(TCP_MD5FAILURE)		\
+	FN(SOCKET_BACKLOG)		\
+	FN(TCP_FLAGS)			\
+	FN(TCP_ZEROWINDOW)		\
+	FN(TCP_OLD_DATA)		\
+	FN(TCP_OVERWINDOW)		\
+	FN(TCP_OFOMERGE)		\
+	FN(TCP_RFC7323_PAWS)		\
+	FN(TCP_INVALID_SEQUENCE)	\
+	FN(TCP_RESET)			\
+	FN(TCP_INVALID_SYN)		\
+	FN(TCP_CLOSE)			\
+	FN(TCP_FASTOPEN)		\
+	FN(TCP_OLD_ACK)			\
+	FN(TCP_TOO_OLD_ACK)		\
+	FN(TCP_ACK_UNSENT_DATA)		\
+	FN(TCP_OFO_QUEUE_PRUNE)		\
+	FN(TCP_OFO_DROP)		\
+	FN(IP_OUTNOROUTES)		\
+	FN(BPF_CGROUP_EGRESS)		\
+	FN(IPV6DISABLED)		\
+	FN(NEIGH_CREATEFAIL)		\
+	FN(NEIGH_FAILED)		\
+	FN(NEIGH_QUEUEFULL)		\
+	FN(NEIGH_DEAD)			\
+	FN(TC_EGRESS)			\
+	FN(QDISC_DROP)			\
+	FN(CPU_BACKLOG)			\
+	FN(XDP)				\
+	FN(TC_INGRESS)			\
+	FN(UNHANDLED_PROTO)		\
+	FN(SKB_CSUM)			\
+	FN(SKB_GSO_SEG)			\
+	FN(SKB_UCOPY_FAULT)		\
+	FN(DEV_HDR)			\
+	FN(DEV_READY)			\
+	FN(FULL_RING)			\
+	FN(NOMEM)			\
+	FN(HDR_TRUNC)			\
+	FN(TAP_FILTER)			\
+	FN(TAP_TXFILTER)		\
+	FN(ICMP_CSUM)			\
+	FN(INVALID_PROTO)		\
+	FN(IP_INADDRERRORS)		\
+	FN(IP_INNOROUTES)		\
+	FN(PKT_TOO_BIG)			\
+	FN(MAX)
+
 /* The reason of skb drop, which is used in kfree_skb_reason().
  * en...maybe they should be splited by group?
- *
- * Each item here should also be in 'TRACE_SKB_DROP_REASON', which is
- * used to translate the reason to string.
  */
 enum skb_drop_reason {
 	SKB_NOT_DROPPED_YET = 0,
-	SKB_DROP_REASON_NOT_SPECIFIED,	/* drop reason is not specified */
-	SKB_DROP_REASON_NO_SOCKET,	/* socket not found */
-	SKB_DROP_REASON_PKT_TOO_SMALL,	/* packet size is too small */
-	SKB_DROP_REASON_TCP_CSUM,	/* TCP checksum error */
-	SKB_DROP_REASON_SOCKET_FILTER,	/* dropped by socket filter */
-	SKB_DROP_REASON_UDP_CSUM,	/* UDP checksum error */
-	SKB_DROP_REASON_NETFILTER_DROP,	/* dropped by netfilter */
-	SKB_DROP_REASON_OTHERHOST,	/* packet don't belong to current
-					 * host (interface is in promisc
-					 * mode)
-					 */
-	SKB_DROP_REASON_IP_CSUM,	/* IP checksum error */
-	SKB_DROP_REASON_IP_INHDR,	/* there is something wrong with
-					 * IP header (see
-					 * IPSTATS_MIB_INHDRERRORS)
-					 */
-	SKB_DROP_REASON_IP_RPFILTER,	/* IP rpfilter validate failed.
-					 * see the document for rp_filter
-					 * in ip-sysctl.rst for more
-					 * information
-					 */
-	SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST, /* destination address of L2
-						  * is multicast, but L3 is
-						  * unicast.
-						  */
-	SKB_DROP_REASON_XFRM_POLICY,	/* xfrm policy check failed */
-	SKB_DROP_REASON_IP_NOPROTO,	/* no support for IP protocol */
-	SKB_DROP_REASON_SOCKET_RCVBUFF,	/* socket receive buff is full */
-	SKB_DROP_REASON_PROTO_MEM,	/* proto memory limition, such as
-					 * udp packet drop out of
-					 * udp_memory_allocated.
-					 */
-	SKB_DROP_REASON_TCP_MD5NOTFOUND,	/* no MD5 hash and one
-						 * expected, corresponding
-						 * to LINUX_MIB_TCPMD5NOTFOUND
-						 */
-	SKB_DROP_REASON_TCP_MD5UNEXPECTED,	/* MD5 hash and we're not
-						 * expecting one, corresponding
-						 * to LINUX_MIB_TCPMD5UNEXPECTED
-						 */
-	SKB_DROP_REASON_TCP_MD5FAILURE,	/* MD5 hash and its wrong,
-					 * corresponding to
-					 * LINUX_MIB_TCPMD5FAILURE
-					 */
-	SKB_DROP_REASON_SOCKET_BACKLOG,	/* failed to add skb to socket
-					 * backlog (see
-					 * LINUX_MIB_TCPBACKLOGDROP)
-					 */
-	SKB_DROP_REASON_TCP_FLAGS,	/* TCP flags invalid */
-	SKB_DROP_REASON_TCP_ZEROWINDOW,	/* TCP receive window size is zero,
-					 * see LINUX_MIB_TCPZEROWINDOWDROP
-					 */
-	SKB_DROP_REASON_TCP_OLD_DATA,	/* the TCP data reveived is already
-					 * received before (spurious retrans
-					 * may happened), see
-					 * LINUX_MIB_DELAYEDACKLOST
-					 */
-	SKB_DROP_REASON_TCP_OVERWINDOW,	/* the TCP data is out of window,
-					 * the seq of the first byte exceed
-					 * the right edges of receive
-					 * window
-					 */
-	SKB_DROP_REASON_TCP_OFOMERGE,	/* the data of skb is already in
-					 * the ofo queue, corresponding to
-					 * LINUX_MIB_TCPOFOMERGE
-					 */
-	SKB_DROP_REASON_TCP_RFC7323_PAWS, /* PAWS check, corresponding to
-					   * LINUX_MIB_PAWSESTABREJECTED
-					   */
-	SKB_DROP_REASON_TCP_INVALID_SEQUENCE, /* Not acceptable SEQ field */
-	SKB_DROP_REASON_TCP_RESET,	/* Invalid RST packet */
-	SKB_DROP_REASON_TCP_INVALID_SYN, /* Incoming packet has unexpected SYN flag */
-	SKB_DROP_REASON_TCP_CLOSE,	/* TCP socket in CLOSE state */
-	SKB_DROP_REASON_TCP_FASTOPEN,	/* dropped by FASTOPEN request socket */
-	SKB_DROP_REASON_TCP_OLD_ACK,	/* TCP ACK is old, but in window */
-	SKB_DROP_REASON_TCP_TOO_OLD_ACK, /* TCP ACK is too old */
-	SKB_DROP_REASON_TCP_ACK_UNSENT_DATA, /* TCP ACK for data we haven't sent yet */
-	SKB_DROP_REASON_TCP_OFO_QUEUE_PRUNE, /* pruned from TCP OFO queue */
-	SKB_DROP_REASON_TCP_OFO_DROP,	/* data already in receive queue */
-	SKB_DROP_REASON_IP_OUTNOROUTES,	/* route lookup failed */
-	SKB_DROP_REASON_BPF_CGROUP_EGRESS,	/* dropped by
-						 * BPF_PROG_TYPE_CGROUP_SKB
-						 * eBPF program
-						 */
-	SKB_DROP_REASON_IPV6DISABLED,	/* IPv6 is disabled on the device */
-	SKB_DROP_REASON_NEIGH_CREATEFAIL,	/* failed to create neigh
-						 * entry
-						 */
-	SKB_DROP_REASON_NEIGH_FAILED,	/* neigh entry in failed state */
-	SKB_DROP_REASON_NEIGH_QUEUEFULL,	/* arp_queue for neigh
-						 * entry is full
-						 */
-	SKB_DROP_REASON_NEIGH_DEAD,	/* neigh entry is dead */
-	SKB_DROP_REASON_TC_EGRESS,	/* dropped in TC egress HOOK */
-	SKB_DROP_REASON_QDISC_DROP,	/* dropped by qdisc when packet
-					 * outputting (failed to enqueue to
-					 * current qdisc)
-					 */
-	SKB_DROP_REASON_CPU_BACKLOG,	/* failed to enqueue the skb to
-					 * the per CPU backlog queue. This
-					 * can be caused by backlog queue
-					 * full (see netdev_max_backlog in
-					 * net.rst) or RPS flow limit
-					 */
-	SKB_DROP_REASON_XDP,		/* dropped by XDP in input path */
-	SKB_DROP_REASON_TC_INGRESS,	/* dropped in TC ingress HOOK */
-	SKB_DROP_REASON_UNHANDLED_PROTO,	/* protocol not implemented
-						 * or not supported
-						 */
-	SKB_DROP_REASON_SKB_CSUM,	/* sk_buff checksum computation
-					 * error
-					 */
-	SKB_DROP_REASON_SKB_GSO_SEG,	/* gso segmentation error */
-	SKB_DROP_REASON_SKB_UCOPY_FAULT,	/* failed to copy data from
-						 * user space, e.g., via
-						 * zerocopy_sg_from_iter()
-						 * or skb_orphan_frags_rx()
-						 */
-	SKB_DROP_REASON_DEV_HDR,	/* device driver specific
-					 * header/metadata is invalid
-					 */
-	/* the device is not ready to xmit/recv due to any of its data
-	 * structure that is not up/ready/initialized, e.g., the IFF_UP is
-	 * not set, or driver specific tun->tfiles[txq] is not initialized
-	 */
-	SKB_DROP_REASON_DEV_READY,
-	SKB_DROP_REASON_FULL_RING,	/* ring buffer is full */
-	SKB_DROP_REASON_NOMEM,		/* error due to OOM */
-	SKB_DROP_REASON_HDR_TRUNC,      /* failed to trunc/extract the header
-					 * from networking data, e.g., failed
-					 * to pull the protocol header from
-					 * frags via pskb_may_pull()
-					 */
-	SKB_DROP_REASON_TAP_FILTER,     /* dropped by (ebpf) filter directly
-					 * attached to tun/tap, e.g., via
-					 * TUNSETFILTEREBPF
-					 */
-	SKB_DROP_REASON_TAP_TXFILTER,	/* dropped by tx filter implemented
-					 * at tun/tap, e.g., check_filter()
-					 */
-	SKB_DROP_REASON_ICMP_CSUM,	/* ICMP checksum error */
-	SKB_DROP_REASON_INVALID_PROTO,	/* the packet doesn't follow RFC
-					 * 2211, such as a broadcasts
-					 * ICMP_TIMESTAMP
-					 */
-	SKB_DROP_REASON_IP_INADDRERRORS,	/* host unreachable, corresponding
-						 * to IPSTATS_MIB_INADDRERRORS
-						 */
-	SKB_DROP_REASON_IP_INNOROUTES,	/* network unreachable, corresponding
-					 * to IPSTATS_MIB_INADDRERRORS
-					 */
-	SKB_DROP_REASON_PKT_TOO_BIG,	/* packet size is too big (maybe exceed
-					 * the MTU)
-					 */
-	SKB_DROP_REASON_MAX,
+
+#undef FN
+#define FN(name) SKB_DROP_REASON_##name,
+	__DEFINE_SKB_DROP_REASON(FN)
+#undef FN
 };
 
 #define SKB_DR_INIT(name, reason)				\
@@ -515,6 +641,8 @@ enum skb_drop_reason {
 			SKB_DR_SET(name, reason);		\
 	} while (0)
 
+extern const char * const drop_reasons[];
+
 /* To allow 64K frame to be packed as single skb without frag_list we
  * require 64K/PAGE_SIZE pages plus 1 additional page to allow for
  * buffers which do not start on a page boundary.
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index a477bf907498..45264e4bb254 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -9,92 +9,6 @@
 #include <linux/netdevice.h>
 #include <linux/tracepoint.h>
 
-#define TRACE_SKB_DROP_REASON					\
-	EM(SKB_DROP_REASON_NOT_SPECIFIED, NOT_SPECIFIED)	\
-	EM(SKB_DROP_REASON_NO_SOCKET, NO_SOCKET)		\
-	EM(SKB_DROP_REASON_PKT_TOO_SMALL, PKT_TOO_SMALL)	\
-	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
-	EM(SKB_DROP_REASON_SOCKET_FILTER, SOCKET_FILTER)	\
-	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
-	EM(SKB_DROP_REASON_NETFILTER_DROP, NETFILTER_DROP)	\
-	EM(SKB_DROP_REASON_OTHERHOST, OTHERHOST)		\
-	EM(SKB_DROP_REASON_IP_CSUM, IP_CSUM)			\
-	EM(SKB_DROP_REASON_IP_INHDR, IP_INHDR)			\
-	EM(SKB_DROP_REASON_IP_RPFILTER, IP_RPFILTER)		\
-	EM(SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST,		\
-	   UNICAST_IN_L2_MULTICAST)				\
-	EM(SKB_DROP_REASON_XFRM_POLICY, XFRM_POLICY)		\
-	EM(SKB_DROP_REASON_IP_NOPROTO, IP_NOPROTO)		\
-	EM(SKB_DROP_REASON_SOCKET_RCVBUFF, SOCKET_RCVBUFF)	\
-	EM(SKB_DROP_REASON_PROTO_MEM, PROTO_MEM)		\
-	EM(SKB_DROP_REASON_TCP_MD5NOTFOUND, TCP_MD5NOTFOUND)	\
-	EM(SKB_DROP_REASON_TCP_MD5UNEXPECTED,			\
-	   TCP_MD5UNEXPECTED)					\
-	EM(SKB_DROP_REASON_TCP_MD5FAILURE, TCP_MD5FAILURE)	\
-	EM(SKB_DROP_REASON_SOCKET_BACKLOG, SOCKET_BACKLOG)	\
-	EM(SKB_DROP_REASON_TCP_FLAGS, TCP_FLAGS)		\
-	EM(SKB_DROP_REASON_TCP_ZEROWINDOW, TCP_ZEROWINDOW)	\
-	EM(SKB_DROP_REASON_TCP_OLD_DATA, TCP_OLD_DATA)		\
-	EM(SKB_DROP_REASON_TCP_OVERWINDOW, TCP_OVERWINDOW)	\
-	EM(SKB_DROP_REASON_TCP_OFOMERGE, TCP_OFOMERGE)		\
-	EM(SKB_DROP_REASON_TCP_OFO_DROP, TCP_OFO_DROP)		\
-	EM(SKB_DROP_REASON_TCP_RFC7323_PAWS, TCP_RFC7323_PAWS)	\
-	EM(SKB_DROP_REASON_TCP_INVALID_SEQUENCE,		\
-	   TCP_INVALID_SEQUENCE)				\
-	EM(SKB_DROP_REASON_TCP_RESET, TCP_RESET)		\
-	EM(SKB_DROP_REASON_TCP_INVALID_SYN, TCP_INVALID_SYN)	\
-	EM(SKB_DROP_REASON_TCP_CLOSE, TCP_CLOSE)		\
-	EM(SKB_DROP_REASON_TCP_FASTOPEN, TCP_FASTOPEN)		\
-	EM(SKB_DROP_REASON_TCP_OLD_ACK, TCP_OLD_ACK)		\
-	EM(SKB_DROP_REASON_TCP_TOO_OLD_ACK, TCP_TOO_OLD_ACK)	\
-	EM(SKB_DROP_REASON_TCP_ACK_UNSENT_DATA,			\
-	   TCP_ACK_UNSENT_DATA)					\
-	EM(SKB_DROP_REASON_TCP_OFO_QUEUE_PRUNE,			\
-	  TCP_OFO_QUEUE_PRUNE)					\
-	EM(SKB_DROP_REASON_IP_OUTNOROUTES, IP_OUTNOROUTES)	\
-	EM(SKB_DROP_REASON_BPF_CGROUP_EGRESS,			\
-	   BPF_CGROUP_EGRESS)					\
-	EM(SKB_DROP_REASON_IPV6DISABLED, IPV6DISABLED)		\
-	EM(SKB_DROP_REASON_NEIGH_CREATEFAIL, NEIGH_CREATEFAIL)	\
-	EM(SKB_DROP_REASON_NEIGH_FAILED, NEIGH_FAILED)		\
-	EM(SKB_DROP_REASON_NEIGH_QUEUEFULL, NEIGH_QUEUEFULL)	\
-	EM(SKB_DROP_REASON_NEIGH_DEAD, NEIGH_DEAD)		\
-	EM(SKB_DROP_REASON_TC_EGRESS, TC_EGRESS)		\
-	EM(SKB_DROP_REASON_QDISC_DROP, QDISC_DROP)		\
-	EM(SKB_DROP_REASON_CPU_BACKLOG, CPU_BACKLOG)		\
-	EM(SKB_DROP_REASON_XDP, XDP)				\
-	EM(SKB_DROP_REASON_TC_INGRESS, TC_INGRESS)		\
-	EM(SKB_DROP_REASON_UNHANDLED_PROTO, UNHANDLED_PROTO)	\
-	EM(SKB_DROP_REASON_SKB_CSUM, SKB_CSUM)			\
-	EM(SKB_DROP_REASON_SKB_GSO_SEG, SKB_GSO_SEG)		\
-	EM(SKB_DROP_REASON_SKB_UCOPY_FAULT, SKB_UCOPY_FAULT)	\
-	EM(SKB_DROP_REASON_DEV_HDR, DEV_HDR)			\
-	EM(SKB_DROP_REASON_DEV_READY, DEV_READY)		\
-	EM(SKB_DROP_REASON_FULL_RING, FULL_RING)		\
-	EM(SKB_DROP_REASON_NOMEM, NOMEM)			\
-	EM(SKB_DROP_REASON_HDR_TRUNC, HDR_TRUNC)		\
-	EM(SKB_DROP_REASON_TAP_FILTER, TAP_FILTER)		\
-	EM(SKB_DROP_REASON_TAP_TXFILTER, TAP_TXFILTER)		\
-	EM(SKB_DROP_REASON_ICMP_CSUM, ICMP_CSUM)		\
-	EM(SKB_DROP_REASON_INVALID_PROTO, INVALID_PROTO)	\
-	EM(SKB_DROP_REASON_IP_INADDRERRORS, IP_INADDRERRORS)	\
-	EM(SKB_DROP_REASON_IP_INNOROUTES, IP_INNOROUTES)	\
-	EM(SKB_DROP_REASON_PKT_TOO_BIG, PKT_TOO_BIG)		\
-	EMe(SKB_DROP_REASON_MAX, MAX)
-
-#undef EM
-#undef EMe
-
-#define EM(a, b)	TRACE_DEFINE_ENUM(a);
-#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
-
-TRACE_SKB_DROP_REASON
-
-#undef EM
-#undef EMe
-#define EM(a, b)	{ a, #b },
-#define EMe(a, b)	{ a, #b }
-
 /*
  * Tracepoint for free an sk_buff:
  */
@@ -121,8 +35,7 @@ TRACE_EVENT(kfree_skb,
 
 	TP_printk("skbaddr=%p protocol=%u location=%p reason: %s",
 		  __entry->skbaddr, __entry->protocol, __entry->location,
-		  __print_symbolic(__entry->reason,
-				   TRACE_SKB_DROP_REASON))
+		  drop_reasons[__entry->reason])
 );
 
 TRACE_EVENT(consume_skb,
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 41cac0e4834e..4ad1decce724 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -48,19 +48,6 @@
 static int trace_state = TRACE_OFF;
 static bool monitor_hw;
 
-#undef EM
-#undef EMe
-
-#define EM(a, b)	[a] = #b,
-#define EMe(a, b)	[a] = #b
-
-/* drop_reasons is used to translate 'enum skb_drop_reason' to string,
- * which is reported to user space.
- */
-static const char * const drop_reasons[] = {
-	TRACE_SKB_DROP_REASON
-};
-
 /* net_dm_mutex
  *
  * An overall lock guarding every operation coming from userspace.
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index fab791b0c59e..e677c052b459 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -90,6 +90,16 @@ static struct kmem_cache *skbuff_ext_cache __ro_after_init;
 int sysctl_max_skb_frags __read_mostly = MAX_SKB_FRAGS;
 EXPORT_SYMBOL(sysctl_max_skb_frags);
 
+/* drop_reasons is used to translate 'enum skb_drop_reason' to string,
+ * which is reported to user space.
+ */
+const char * const drop_reasons[] = {
+#undef FN
+#define FN(name) [SKB_DROP_REASON_##name] = #name,
+	__DEFINE_SKB_DROP_REASON(FN)
+#undef FN
+};
+
 /**
  *	skb_panic - private function for out-of-line support
  *	@skb:	buffer
-- 
2.36.1

