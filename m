Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5958E539D7D
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 08:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349963AbiFAGyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 02:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344194AbiFAGyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 02:54:33 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4D54A3D2;
        Tue, 31 May 2022 23:54:32 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id x12so1045733pgj.7;
        Tue, 31 May 2022 23:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jd7+8GVGKJIme5bPTDGopeujqWDguTX/rh6wwJYY+v0=;
        b=REjGSbGF/5kHkWzt5VWzCobLR/c6p1waV8RiCKieVYHXQ+JGAWtEVRBnnoZf4aoCsE
         lUbKYDVtWNuI7vtTv+XcsK4+Di3cfincrf5UhNf8ViOe9ETdxhXfVhH1+UdLnW3EGK5o
         ogXZq5BuEh1mLqDKjG+F/BQW3oWaOrVOmfZM1MS3ujwQgtq+M44uMVG8oh7zQiIIVkzf
         BNx/PCYM325TTVw91LOFCUe0zOD+AoMditDGtsyjewH8SOkWyfQO1L8UV4x8Y/mlnnpZ
         wGH2/JX4oiK5itvcrvk1h1uRTN91DP2MAhMMPpSuTbk4r15hYya9CfA03ir/zihiohBC
         pYZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jd7+8GVGKJIme5bPTDGopeujqWDguTX/rh6wwJYY+v0=;
        b=Hq2hjqUfgMPX2JhrLO4SoGp0bUpo2x8nQYYxbNgLBEDoA0olKf1OBDeBjMO9S29B9H
         GZgXWi2Hsrct7v9P1YF6N5BHcJfVETQKbb+XWw3O7FMQG68HoivS/bTikKGz9nDMbv1k
         DzTyFlD3VeWB1HQO3610WoQp3Iw0tP2jAJfTY8vxaLDArpArSXSz8dCvopqwI0a9CjXW
         4SJiyWH6Q1ZSRL5fth+WUC5z+MebPDCZHxMrSPR8t0ASnTHjZuqfPZGZID2CK65Qxrq8
         zPr7upaUXnb45oiGtkEGIGIym94pwt7lF9OWiIU7L77BxvI09Oumfgc6ZiJk+5p+W9pk
         msWQ==
X-Gm-Message-State: AOAM530MvfauTpFodOTPcTz/yF35wGbzNU3gG6lYcBnd8mkjcsdHKUVV
        7/hV6OduSfNVYPCNEF5n7V8=
X-Google-Smtp-Source: ABdhPJyn3DmFJCqDW1U8HPI7/NO7/pRmPID4kYrn35IlNNHlh31f3rnTRAJV/2ijsqHDPRo/OlzpWQ==
X-Received: by 2002:a63:2a44:0:b0:3f9:d9fa:a268 with SMTP id q65-20020a632a44000000b003f9d9faa268mr46124991pgq.289.1654066471561;
        Tue, 31 May 2022 23:54:31 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id b11-20020a170902d50b00b0015e8d4eb276sm671460plg.192.2022.05.31.23.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 23:54:31 -0700 (PDT)
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
Subject: [PATCH net-next v3 1/3] net: skb: move enum skb_drop_reason to standalone header file
Date:   Wed,  1 Jun 2022 14:52:36 +0800
Message-Id: <20220601065238.1357624-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220601065238.1357624-1-imagedong@tencent.com>
References: <20220601065238.1357624-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

As the skb drop reasons are getting more and more, move the enum
'skb_drop_reason' and related function to the standalone header
'dropreason.h', as Jakub Kicinski suggested.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- move dropreason.h from include/linux/ to include/net/ (Jakub Kicinski)
---
 include/linux/skbuff.h   | 179 +------------------------------------
 include/net/dropreason.h | 184 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 185 insertions(+), 178 deletions(-)
 create mode 100644 include/net/dropreason.h

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index da96f0d3e753..69cd1c6f1862 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -43,6 +43,7 @@
 #include <linux/netfilter/nf_conntrack_common.h>
 #endif
 #include <net/net_debug.h>
+#include <net/dropreason.h>
 
 /**
  * DOC: skb checksums
@@ -337,184 +338,6 @@ struct sk_buff_head {
 
 struct sk_buff;
 
-/* The reason of skb drop, which is used in kfree_skb_reason().
- * en...maybe they should be splited by group?
- *
- * Each item here should also be in 'TRACE_SKB_DROP_REASON', which is
- * used to translate the reason to string.
- */
-enum skb_drop_reason {
-	SKB_NOT_DROPPED_YET = 0,
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
-};
-
-#define SKB_DR_INIT(name, reason)				\
-	enum skb_drop_reason name = SKB_DROP_REASON_##reason
-#define SKB_DR(name)						\
-	SKB_DR_INIT(name, NOT_SPECIFIED)
-#define SKB_DR_SET(name, reason)				\
-	(name = SKB_DROP_REASON_##reason)
-#define SKB_DR_OR(name, reason)					\
-	do {							\
-		if (name == SKB_DROP_REASON_NOT_SPECIFIED ||	\
-		    name == SKB_NOT_DROPPED_YET)		\
-			SKB_DR_SET(name, reason);		\
-	} while (0)
-
 /* To allow 64K frame to be packed as single skb without frag_list we
  * require 64K/PAGE_SIZE pages plus 1 additional page to allow for
  * buffers which do not start on a page boundary.
diff --git a/include/net/dropreason.h b/include/net/dropreason.h
new file mode 100644
index 000000000000..ecd18b7b1364
--- /dev/null
+++ b/include/net/dropreason.h
@@ -0,0 +1,184 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _LINUX_DROPREASON_H
+#define _LINUX_DROPREASON_H
+
+/* The reason of skb drop, which is used in kfree_skb_reason().
+ * en...maybe they should be splited by group?
+ *
+ * Each item here should also be in 'TRACE_SKB_DROP_REASON', which is
+ * used to translate the reason to string.
+ */
+enum skb_drop_reason {
+	SKB_NOT_DROPPED_YET = 0,
+	SKB_DROP_REASON_NOT_SPECIFIED,	/* drop reason is not specified */
+	SKB_DROP_REASON_NO_SOCKET,	/* socket not found */
+	SKB_DROP_REASON_PKT_TOO_SMALL,	/* packet size is too small */
+	SKB_DROP_REASON_TCP_CSUM,	/* TCP checksum error */
+	SKB_DROP_REASON_SOCKET_FILTER,	/* dropped by socket filter */
+	SKB_DROP_REASON_UDP_CSUM,	/* UDP checksum error */
+	SKB_DROP_REASON_NETFILTER_DROP,	/* dropped by netfilter */
+	SKB_DROP_REASON_OTHERHOST,	/* packet don't belong to current
+					 * host (interface is in promisc
+					 * mode)
+					 */
+	SKB_DROP_REASON_IP_CSUM,	/* IP checksum error */
+	SKB_DROP_REASON_IP_INHDR,	/* there is something wrong with
+					 * IP header (see
+					 * IPSTATS_MIB_INHDRERRORS)
+					 */
+	SKB_DROP_REASON_IP_RPFILTER,	/* IP rpfilter validate failed.
+					 * see the document for rp_filter
+					 * in ip-sysctl.rst for more
+					 * information
+					 */
+	SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST, /* destination address of L2
+						  * is multicast, but L3 is
+						  * unicast.
+						  */
+	SKB_DROP_REASON_XFRM_POLICY,	/* xfrm policy check failed */
+	SKB_DROP_REASON_IP_NOPROTO,	/* no support for IP protocol */
+	SKB_DROP_REASON_SOCKET_RCVBUFF,	/* socket receive buff is full */
+	SKB_DROP_REASON_PROTO_MEM,	/* proto memory limition, such as
+					 * udp packet drop out of
+					 * udp_memory_allocated.
+					 */
+	SKB_DROP_REASON_TCP_MD5NOTFOUND,	/* no MD5 hash and one
+						 * expected, corresponding
+						 * to LINUX_MIB_TCPMD5NOTFOUND
+						 */
+	SKB_DROP_REASON_TCP_MD5UNEXPECTED,	/* MD5 hash and we're not
+						 * expecting one, corresponding
+						 * to LINUX_MIB_TCPMD5UNEXPECTED
+						 */
+	SKB_DROP_REASON_TCP_MD5FAILURE,	/* MD5 hash and its wrong,
+					 * corresponding to
+					 * LINUX_MIB_TCPMD5FAILURE
+					 */
+	SKB_DROP_REASON_SOCKET_BACKLOG,	/* failed to add skb to socket
+					 * backlog (see
+					 * LINUX_MIB_TCPBACKLOGDROP)
+					 */
+	SKB_DROP_REASON_TCP_FLAGS,	/* TCP flags invalid */
+	SKB_DROP_REASON_TCP_ZEROWINDOW,	/* TCP receive window size is zero,
+					 * see LINUX_MIB_TCPZEROWINDOWDROP
+					 */
+	SKB_DROP_REASON_TCP_OLD_DATA,	/* the TCP data reveived is already
+					 * received before (spurious retrans
+					 * may happened), see
+					 * LINUX_MIB_DELAYEDACKLOST
+					 */
+	SKB_DROP_REASON_TCP_OVERWINDOW,	/* the TCP data is out of window,
+					 * the seq of the first byte exceed
+					 * the right edges of receive
+					 * window
+					 */
+	SKB_DROP_REASON_TCP_OFOMERGE,	/* the data of skb is already in
+					 * the ofo queue, corresponding to
+					 * LINUX_MIB_TCPOFOMERGE
+					 */
+	SKB_DROP_REASON_TCP_RFC7323_PAWS, /* PAWS check, corresponding to
+					   * LINUX_MIB_PAWSESTABREJECTED
+					   */
+	SKB_DROP_REASON_TCP_INVALID_SEQUENCE, /* Not acceptable SEQ field */
+	SKB_DROP_REASON_TCP_RESET,	/* Invalid RST packet */
+	SKB_DROP_REASON_TCP_INVALID_SYN, /* Incoming packet has unexpected SYN flag */
+	SKB_DROP_REASON_TCP_CLOSE,	/* TCP socket in CLOSE state */
+	SKB_DROP_REASON_TCP_FASTOPEN,	/* dropped by FASTOPEN request socket */
+	SKB_DROP_REASON_TCP_OLD_ACK,	/* TCP ACK is old, but in window */
+	SKB_DROP_REASON_TCP_TOO_OLD_ACK, /* TCP ACK is too old */
+	SKB_DROP_REASON_TCP_ACK_UNSENT_DATA, /* TCP ACK for data we haven't sent yet */
+	SKB_DROP_REASON_TCP_OFO_QUEUE_PRUNE, /* pruned from TCP OFO queue */
+	SKB_DROP_REASON_TCP_OFO_DROP,	/* data already in receive queue */
+	SKB_DROP_REASON_IP_OUTNOROUTES,	/* route lookup failed */
+	SKB_DROP_REASON_BPF_CGROUP_EGRESS,	/* dropped by
+						 * BPF_PROG_TYPE_CGROUP_SKB
+						 * eBPF program
+						 */
+	SKB_DROP_REASON_IPV6DISABLED,	/* IPv6 is disabled on the device */
+	SKB_DROP_REASON_NEIGH_CREATEFAIL,	/* failed to create neigh
+						 * entry
+						 */
+	SKB_DROP_REASON_NEIGH_FAILED,	/* neigh entry in failed state */
+	SKB_DROP_REASON_NEIGH_QUEUEFULL,	/* arp_queue for neigh
+						 * entry is full
+						 */
+	SKB_DROP_REASON_NEIGH_DEAD,	/* neigh entry is dead */
+	SKB_DROP_REASON_TC_EGRESS,	/* dropped in TC egress HOOK */
+	SKB_DROP_REASON_QDISC_DROP,	/* dropped by qdisc when packet
+					 * outputting (failed to enqueue to
+					 * current qdisc)
+					 */
+	SKB_DROP_REASON_CPU_BACKLOG,	/* failed to enqueue the skb to
+					 * the per CPU backlog queue. This
+					 * can be caused by backlog queue
+					 * full (see netdev_max_backlog in
+					 * net.rst) or RPS flow limit
+					 */
+	SKB_DROP_REASON_XDP,		/* dropped by XDP in input path */
+	SKB_DROP_REASON_TC_INGRESS,	/* dropped in TC ingress HOOK */
+	SKB_DROP_REASON_UNHANDLED_PROTO,	/* protocol not implemented
+						 * or not supported
+						 */
+	SKB_DROP_REASON_SKB_CSUM,	/* sk_buff checksum computation
+					 * error
+					 */
+	SKB_DROP_REASON_SKB_GSO_SEG,	/* gso segmentation error */
+	SKB_DROP_REASON_SKB_UCOPY_FAULT,	/* failed to copy data from
+						 * user space, e.g., via
+						 * zerocopy_sg_from_iter()
+						 * or skb_orphan_frags_rx()
+						 */
+	SKB_DROP_REASON_DEV_HDR,	/* device driver specific
+					 * header/metadata is invalid
+					 */
+	/* the device is not ready to xmit/recv due to any of its data
+	 * structure that is not up/ready/initialized, e.g., the IFF_UP is
+	 * not set, or driver specific tun->tfiles[txq] is not initialized
+	 */
+	SKB_DROP_REASON_DEV_READY,
+	SKB_DROP_REASON_FULL_RING,	/* ring buffer is full */
+	SKB_DROP_REASON_NOMEM,		/* error due to OOM */
+	SKB_DROP_REASON_HDR_TRUNC,      /* failed to trunc/extract the header
+					 * from networking data, e.g., failed
+					 * to pull the protocol header from
+					 * frags via pskb_may_pull()
+					 */
+	SKB_DROP_REASON_TAP_FILTER,     /* dropped by (ebpf) filter directly
+					 * attached to tun/tap, e.g., via
+					 * TUNSETFILTEREBPF
+					 */
+	SKB_DROP_REASON_TAP_TXFILTER,	/* dropped by tx filter implemented
+					 * at tun/tap, e.g., check_filter()
+					 */
+	SKB_DROP_REASON_ICMP_CSUM,	/* ICMP checksum error */
+	SKB_DROP_REASON_INVALID_PROTO,	/* the packet doesn't follow RFC
+					 * 2211, such as a broadcasts
+					 * ICMP_TIMESTAMP
+					 */
+	SKB_DROP_REASON_IP_INADDRERRORS,	/* host unreachable, corresponding
+						 * to IPSTATS_MIB_INADDRERRORS
+						 */
+	SKB_DROP_REASON_IP_INNOROUTES,	/* network unreachable, corresponding
+					 * to IPSTATS_MIB_INADDRERRORS
+					 */
+	SKB_DROP_REASON_PKT_TOO_BIG,	/* packet size is too big (maybe exceed
+					 * the MTU)
+					 */
+	SKB_DROP_REASON_MAX,
+};
+
+#define SKB_DR_INIT(name, reason)				\
+	enum skb_drop_reason name = SKB_DROP_REASON_##reason
+#define SKB_DR(name)						\
+	SKB_DR_INIT(name, NOT_SPECIFIED)
+#define SKB_DR_SET(name, reason)				\
+	(name = SKB_DROP_REASON_##reason)
+#define SKB_DR_OR(name, reason)					\
+	do {							\
+		if (name == SKB_DROP_REASON_NOT_SPECIFIED ||	\
+		    name == SKB_NOT_DROPPED_YET)		\
+			SKB_DR_SET(name, reason);		\
+	} while (0)
+
+#endif
-- 
2.36.1

