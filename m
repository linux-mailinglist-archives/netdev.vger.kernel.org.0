Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9CC5376D6
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 10:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbiE3IOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 04:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbiE3IOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 04:14:05 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C79762B1;
        Mon, 30 May 2022 01:14:02 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j191so2273790pgd.3;
        Mon, 30 May 2022 01:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zTAkmR1xt0IqweruxMy4CCG6yGPCH+Z8P4d1xg/rcYc=;
        b=iYW9DqpIF8gaw14j/xwj3roo6jkLWMKCMomV8rrCmgD/WBNy+ja8u4RrkYfn/Er6zw
         twhEX3nISQhNhR3nwu0E6AjRxwbm1ZFNIj/PV4RDqBHusC5/d46m4MyYF63OSAXagPy0
         zRRQbS7PdIA+kCJTpSu6GO2c8Uz/ZRGEXiFsVJ2St0kDXUNdzY9Onsx0Xo9VJn+RM4Ww
         tM2lGAny+KwrLE9gBhMoy4vjY/uCI7j47o+vLGkv/6s3OHthmMsvE2wFIPzX6I+03y8I
         0psz+8dxayPREKf0+4V7zoPMPgaJb79YCDa/7l4+3PeeKNOskHxfm3VgWIThkczkwZNd
         sy9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zTAkmR1xt0IqweruxMy4CCG6yGPCH+Z8P4d1xg/rcYc=;
        b=TkeOLq2T5Csv7SKE/wvdwW510eXJtoPFRvzeIIY029JxstYeDffa7lSuxK3HwN5yu/
         IdFW7ZYvjDvTQ3w/Vtkp0BkBFWIdzEWOQYmMjUnCPOI23Y9xUlQYfpohm2H4iRQ7qVDn
         gOuKklljgLOqmEDBxJ1TZAeBJp7Kk2ZDCvyUWiWFnIdpb5XvaKj8cK2rjMVb6MN8280I
         4gm122sob07ZmWkZi6rUui6CDflXkixzBqerM1WLCtCGEp4vRXm4aoetQIRNhodimN4F
         PlUU7uH7NbZR/HIBPTL2vAH04XndJkmnkWLtlKvX3Ar9sJAgqqQffeimFePm/to+2OQi
         cNNA==
X-Gm-Message-State: AOAM531hOt+26i7JFMH2oIFU3WglkjhXWGI1p3i1nqPUau4FFTvrwvw7
        u8TeC8WwW3jbtb40eLQRdjk=
X-Google-Smtp-Source: ABdhPJw0wHfe9FiHxJcW1+qk1xWT2KbPQ4fTvrvZxrNp90kmTQGyBq1M/lLDWWOy0sZM3w/zAOsDnA==
X-Received: by 2002:a63:a06:0:b0:3c2:3345:bf99 with SMTP id 6-20020a630a06000000b003c23345bf99mr47674563pgk.477.1653898441920;
        Mon, 30 May 2022 01:14:01 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.10])
        by smtp.gmail.com with ESMTPSA id i10-20020a17090332ca00b0016156e0c3cbsm8624331plr.156.2022.05.30.01.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 01:14:01 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, nhorman@tuxdriver.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        imagedong@tencent.com, dsahern@kernel.org, talalahmad@google.com,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH net-next v2 3/3] net: dropreason: reformat the comment fo skb drop reasons
Date:   Mon, 30 May 2022 16:12:01 +0800
Message-Id: <20220530081201.10151-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220530081201.10151-1-imagedong@tencent.com>
References: <20220530081201.10151-1-imagedong@tencent.com>
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

To make the code clear, reformat the comment in dropreason.h to k-doc
style.

Now, the comment can pass the check of kernel-doc without warnning:

$ ./scripts/kernel-doc -v -none include/linux/dropreason.h
include/linux/dropreason.h:7: info: Scanning doc for enum skb_drop_reason

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- make the comment inline (Jakub Kicinski)
---
 include/net/dropreason.h | 383 +++++++++++++++++++++++----------------
 1 file changed, 227 insertions(+), 156 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index 460de425297c..e461a03936f8 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -5,168 +5,239 @@
 
 #include <linux/kernel.h>
 
-/* The reason of skb drop, which is used in kfree_skb_reason().
- * en...maybe they should be splited by group?
+/**
+ * enum skb_drop_reason - the reasons of skb drops
  *
- * Each item here should also be in 'TRACE_SKB_DROP_REASON', which is
- * used to translate the reason to string.
+ * The reason of skb drop, which is used in kfree_skb_reason().
+ * en...maybe they should be splited by group?
  */
 enum skb_drop_reason {
+	/**
+	 * @SKB_NOT_DROPPED_YET: skb is not dropped yet (used for no-drop case)
+	 */
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
+	/** @SKB_DROP_REASON_NOT_SPECIFIED: drop reason is not specified */
+	SKB_DROP_REASON_NOT_SPECIFIED,
+	/** @SKB_DROP_REASON_NO_SOCKET: socket not found */
+	SKB_DROP_REASON_NO_SOCKET,
+	/** @SKB_DROP_REASON_PKT_TOO_SMALL: packet size is too small */
+	SKB_DROP_REASON_PKT_TOO_SMALL,
+	/** @SKB_DROP_REASON_TCP_CSUM: TCP checksum error */
+	SKB_DROP_REASON_TCP_CSUM,
+	/** @SKB_DROP_REASON_SOCKET_FILTER: dropped by socket filter */
+	SKB_DROP_REASON_SOCKET_FILTER,
+	/** @SKB_DROP_REASON_UDP_CSUM: UDP checksum error */
+	SKB_DROP_REASON_UDP_CSUM,
+	/** @SKB_DROP_REASON_NETFILTER_DROP: dropped by netfilter */
+	SKB_DROP_REASON_NETFILTER_DROP,
+	/**
+	 * @SKB_DROP_REASON_OTHERHOST: packet don't belong to current host
+	 * (interface is in promisc mode)
+	 */
+	SKB_DROP_REASON_OTHERHOST,
+	/** @SKB_DROP_REASON_IP_CSUM: IP checksum error */
+	SKB_DROP_REASON_IP_CSUM,
+	/**
+	 * @SKB_DROP_REASON_IP_INHDR: there is something wrong with IP header (see
+	 * IPSTATS_MIB_INHDRERRORS)
+	 */
+	SKB_DROP_REASON_IP_INHDR,
+	/**
+	 * @SKB_DROP_REASON_IP_RPFILTER: IP rpfilter validate failed. see the
+	 * document for rp_filter in ip-sysctl.rst for more information
+	 */
+	SKB_DROP_REASON_IP_RPFILTER,
+	/**
+	 * @SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST: destination address of L2 is
+	 * multicast, but L3 is unicast.
+	 */
+	SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST,
+	/** @SKB_DROP_REASON_XFRM_POLICY: xfrm policy check failed */
+	SKB_DROP_REASON_XFRM_POLICY,
+	/** @SKB_DROP_REASON_IP_NOPROTO: no support for IP protocol */
+	SKB_DROP_REASON_IP_NOPROTO,
+	/** @SKB_DROP_REASON_SOCKET_RCVBUFF: socket receive buff is full */
+	SKB_DROP_REASON_SOCKET_RCVBUFF,
+	/**
+	 * @SKB_DROP_REASON_PROTO_MEM: proto memory limition, such as udp packet
+	 * drop out of udp_memory_allocated.
+	 */
+	SKB_DROP_REASON_PROTO_MEM,
+	/**
+	 * @SKB_DROP_REASON_TCP_MD5NOTFOUND: no MD5 hash and one expected,
+	 * corresponding to LINUX_MIB_TCPMD5NOTFOUND
+	 */
+	SKB_DROP_REASON_TCP_MD5NOTFOUND,
+	/**
+	 * @SKB_DROP_REASON_TCP_MD5UNEXPECTED: MD5 hash and we're not expecting
+	 * one, corresponding to LINUX_MIB_TCPMD5UNEXPECTED
+	 */
+	SKB_DROP_REASON_TCP_MD5UNEXPECTED,
+	/**
+	 * @SKB_DROP_REASON_TCP_MD5FAILURE: MD5 hash and its wrong, corresponding
+	 * to LINUX_MIB_TCPMD5FAILURE
+	 */
+	SKB_DROP_REASON_TCP_MD5FAILURE,
+	/**
+	 * @SKB_DROP_REASON_SOCKET_BACKLOG: failed to add skb to socket backlog (
+	 * see LINUX_MIB_TCPBACKLOGDROP)
+	 */
+	SKB_DROP_REASON_SOCKET_BACKLOG,
+	/** @SKB_DROP_REASON_TCP_FLAGS: TCP flags invalid */
+	SKB_DROP_REASON_TCP_FLAGS,
+	/**
+	 * @SKB_DROP_REASON_TCP_ZEROWINDOW: TCP receive window size is zero,
+	 * see LINUX_MIB_TCPZEROWINDOWDROP
+	 */
+	SKB_DROP_REASON_TCP_ZEROWINDOW,
+	/**
+	 * @SKB_DROP_REASON_TCP_OLD_DATA: the TCP data reveived is already
+	 * received before (spurious retrans may happened), see
+	 * LINUX_MIB_DELAYEDACKLOST
+	 */
+	SKB_DROP_REASON_TCP_OLD_DATA,
+	/**
+	 * @SKB_DROP_REASON_TCP_OVERWINDOW: the TCP data is out of window,
+	 * the seq of the first byte exceed the right edges of receive
+	 * window
+	 */
+	SKB_DROP_REASON_TCP_OVERWINDOW,
+	/**
+	 * @SKB_DROP_REASON_TCP_OFOMERGE: the data of skb is already in the ofo
+	 * queue, corresponding to LINUX_MIB_TCPOFOMERGE
+	 */
+	SKB_DROP_REASON_TCP_OFOMERGE,
+	/**
+	 * @SKB_DROP_REASON_TCP_RFC7323_PAWS: PAWS check, corresponding to
+	 * LINUX_MIB_PAWSESTABREJECTED
+	 */
+	SKB_DROP_REASON_TCP_RFC7323_PAWS,
+	/** @SKB_DROP_REASON_TCP_INVALID_SEQUENCE: Not acceptable SEQ field */
+	SKB_DROP_REASON_TCP_INVALID_SEQUENCE,
+	/** @SKB_DROP_REASON_TCP_RESET: Invalid RST packet */
+	SKB_DROP_REASON_TCP_RESET,
+	/**
+	 * @SKB_DROP_REASON_TCP_INVALID_SYN: Incoming packet has unexpected
+	 * SYN flag
+	 */
+	SKB_DROP_REASON_TCP_INVALID_SYN,
+	/** @SKB_DROP_REASON_TCP_CLOSE: TCP socket in CLOSE state */
+	SKB_DROP_REASON_TCP_CLOSE,
+	/** @SKB_DROP_REASON_TCP_FASTOPEN: dropped by FASTOPEN request socket */
+	SKB_DROP_REASON_TCP_FASTOPEN,
+	/** @SKB_DROP_REASON_TCP_OLD_ACK: TCP ACK is old, but in window */
+	SKB_DROP_REASON_TCP_OLD_ACK,
+	/** @SKB_DROP_REASON_TCP_TOO_OLD_ACK: TCP ACK is too old */
+	SKB_DROP_REASON_TCP_TOO_OLD_ACK,
+	/**
+	 * @SKB_DROP_REASON_TCP_ACK_UNSENT_DATA: TCP ACK for data we haven't
+	 * sent yet
+	 */
+	SKB_DROP_REASON_TCP_ACK_UNSENT_DATA,
+	/** @SKB_DROP_REASON_TCP_OFO_QUEUE_PRUNE: pruned from TCP OFO queue */
+	SKB_DROP_REASON_TCP_OFO_QUEUE_PRUNE,
+	/** @SKB_DROP_REASON_TCP_OFO_DROP: data already in receive queue */
+	SKB_DROP_REASON_TCP_OFO_DROP,
+	/** @SKB_DROP_REASON_IP_OUTNOROUTES: route lookup failed */
+	SKB_DROP_REASON_IP_OUTNOROUTES,
+	/**
+	 * @SKB_DROP_REASON_BPF_CGROUP_EGRESS: dropped by BPF_PROG_TYPE_CGROUP_SKB
+	 * eBPF program
+	 */
+	SKB_DROP_REASON_BPF_CGROUP_EGRESS,
+	/** @SKB_DROP_REASON_IPV6DISABLED: IPv6 is disabled on the device */
+	SKB_DROP_REASON_IPV6DISABLED,
+	/** @SKB_DROP_REASON_NEIGH_CREATEFAIL: failed to create neigh entry */
+	SKB_DROP_REASON_NEIGH_CREATEFAIL,
+	/** @SKB_DROP_REASON_NEIGH_FAILED: neigh entry in failed state */
+	SKB_DROP_REASON_NEIGH_FAILED,
+	/** @SKB_DROP_REASON_NEIGH_QUEUEFULL: arp_queue for neigh entry is full */
+	SKB_DROP_REASON_NEIGH_QUEUEFULL,
+	/** @SKB_DROP_REASON_NEIGH_DEAD: neigh entry is dead */
+	SKB_DROP_REASON_NEIGH_DEAD,
+	/** @SKB_DROP_REASON_TC_EGRESS: dropped in TC egress HOOK */
+	SKB_DROP_REASON_TC_EGRESS,
+	/**
+	 * @SKB_DROP_REASON_QDISC_DROP: dropped by qdisc when packet outputting (
+	 * failed to enqueue to current qdisc)
+	 */
+	SKB_DROP_REASON_QDISC_DROP,
+	/**
+	 * @SKB_DROP_REASON_CPU_BACKLOG: failed to enqueue the skb to the per CPU
+	 * backlog queue. This can be caused by backlog queue full (see
+	 * netdev_max_backlog in net.rst) or RPS flow limit
+	 */
+	SKB_DROP_REASON_CPU_BACKLOG,
+	/** @SKB_DROP_REASON_XDP: dropped by XDP in input path */
+	SKB_DROP_REASON_XDP,
+	/** @SKB_DROP_REASON_TC_INGRESS: dropped in TC ingress HOOK */
+	SKB_DROP_REASON_TC_INGRESS,
+	/** @SKB_DROP_REASON_UNHANDLED_PROTO: protocol not implemented or not supported */
+	SKB_DROP_REASON_UNHANDLED_PROTO,
+	/** @SKB_DROP_REASON_SKB_CSUM: sk_buff checksum computation error */
+	SKB_DROP_REASON_SKB_CSUM,
+	/** @SKB_DROP_REASON_SKB_GSO_SEG: gso segmentation error */
+	SKB_DROP_REASON_SKB_GSO_SEG,
+	/**
+	 * @SKB_DROP_REASON_SKB_UCOPY_FAULT: failed to copy data from user space,
+	 * e.g., via zerocopy_sg_from_iter() or skb_orphan_frags_rx()
+	 */
+	SKB_DROP_REASON_SKB_UCOPY_FAULT,
+	/** @SKB_DROP_REASON_DEV_HDR: device driver specific header/metadata is invalid */
+	SKB_DROP_REASON_DEV_HDR,
+	/**
+	 * @SKB_DROP_REASON_DEV_READY: the device is not ready to xmit/recv due to
+	 * any of its data structure that is not up/ready/initialized,
+	 * e.g., the IFF_UP is not set, or driver specific tun->tfiles[txq]
+	 * is not initialized
 	 */
 	SKB_DROP_REASON_DEV_READY,
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
+	/** @SKB_DROP_REASON_FULL_RING: ring buffer is full */
+	SKB_DROP_REASON_FULL_RING,
+	/** @SKB_DROP_REASON_NOMEM: error due to OOM */
+	SKB_DROP_REASON_NOMEM,
+	/**
+	 * @SKB_DROP_REASON_HDR_TRUNC: failed to trunc/extract the header from
+	 * networking data, e.g., failed to pull the protocol header from
+	 * frags via pskb_may_pull()
+	 */
+	SKB_DROP_REASON_HDR_TRUNC,
+	/**
+	 * @SKB_DROP_REASON_TAP_FILTER: dropped by (ebpf) filter directly attached
+	 * to tun/tap, e.g., via TUNSETFILTEREBPF
+	 */
+	SKB_DROP_REASON_TAP_FILTER,
+	/**
+	 * @SKB_DROP_REASON_TAP_TXFILTER: dropped by tx filter implemented at
+	 * tun/tap, e.g., check_filter()
+	 */
+	SKB_DROP_REASON_TAP_TXFILTER,
+	/** @SKB_DROP_REASON_ICMP_CSUM: ICMP checksum error */
+	SKB_DROP_REASON_ICMP_CSUM,
+	/**
+	 * @SKB_DROP_REASON_INVALID_PROTO: the packet doesn't follow RFC 2211,
+	 * such as a broadcasts ICMP_TIMESTAMP
+	 */
+	SKB_DROP_REASON_INVALID_PROTO,
+	/**
+	 * @SKB_DROP_REASON_IP_INADDRERRORS: host unreachable, corresponding to
+	 * IPSTATS_MIB_INADDRERRORS
+	 */
+	SKB_DROP_REASON_IP_INADDRERRORS,
+	/**
+	 * @SKB_DROP_REASON_IP_INNOROUTES: network unreachable, corresponding to
+	 * IPSTATS_MIB_INADDRERRORS
+	 */
+	SKB_DROP_REASON_IP_INNOROUTES,
+	/**
+	 * @SKB_DROP_REASON_PKT_TOO_BIG: packet size is too big (maybe exceed the
+	 * MTU)
+	 */
+	SKB_DROP_REASON_PKT_TOO_BIG,
+	/**
+	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
+	 * used as a real 'reason'
+	 */
 	SKB_DROP_REASON_MAX,
 };
 
-- 
2.36.1

