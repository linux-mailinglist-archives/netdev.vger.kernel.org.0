Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25DC539D83
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 08:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349973AbiFAGyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 02:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344194AbiFAGyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 02:54:38 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334C74ECD5;
        Tue, 31 May 2022 23:54:37 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id n10so1123374pjh.5;
        Tue, 31 May 2022 23:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W1ULdKeyZSjCXgN05SUJJaIcwUqJqqUeVknEzZ7Pgjc=;
        b=jQyRPBw9CUxVik/A6DSi4hp9b9F2Z9c94w00xlagWbH1nyIKJMDFaWj8UxSO/mkxU4
         QsDWMINfcykcs5ShvajfclvvHhSZ2DRaxhMSEBDdM+DV/g5gdnzKH5iXa8EINrFi0HK+
         UhYUSuI2khwKwL7EtVCIdj7+4DepHKan5a64ty5+gncWMFL+hdcrrsqqvy4/UFkev74k
         jcRSZXbZYhmfSp/UcOHU2bifGo+H83KNeFYAmGbGNswsVAdtoHHKxcHne2Rzcg2vVPIX
         uhwwsMi0H+n+EN4sULz0O6MyFYu+s3HAGYkAWfx0YDUoo1xfqT4wd9b8rHCD/Ig+0SIq
         WQcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W1ULdKeyZSjCXgN05SUJJaIcwUqJqqUeVknEzZ7Pgjc=;
        b=oKSyUpse+urVSWPeapeMFA/ZMKSBYv5onIwJzLbYnJFxWQiUgRAkjxD8q9KwHWa0et
         +oy8z383mEUWbF76Ttx655kl9a3Gea8UwkbBC9kHungfDVNz50rc8ZEx18wOrWaQdeG5
         ebHt/Z0+IATazPEVY1G4uyNfYcbDT5GpibP9eLNebbz51WZQjSp/LlmHffepgahbLFG4
         3IVm4SxFTgNbrVSq7PeTfPId2se/JlYS0ysBPOH6kjWAJ8a73O8/m86M4Ep961HvPp0u
         nanxb9DHClXCLMOgwVHOi8q2mGRvyaYKruezclVcBaPTVyj419r+qAisH8mPA93OmmMO
         PRqg==
X-Gm-Message-State: AOAM533/rz0qA/eLvUQ03ewC1wwhaw5ihE8oZd3xbt1184+VKcNTZkQF
        zjOnZTi3+HnbqQbzTlQApsY=
X-Google-Smtp-Source: ABdhPJyYheQ3APBD8uIDvH0hevFKs+8QA4C7+i2c29pxYkR0NA0aG7tuXYd0s+4T1lpqlioA16KyHg==
X-Received: by 2002:a17:902:aa87:b0:162:39b5:3ba3 with SMTP id d7-20020a170902aa8700b0016239b53ba3mr41756169plr.158.1654066476708;
        Tue, 31 May 2022 23:54:36 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id b11-20020a170902d50b00b0015e8d4eb276sm671460plg.192.2022.05.31.23.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 23:54:36 -0700 (PDT)
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
Subject: [PATCH net-next v3 2/3] net: skb: use auto-generation to convert skb drop reason to string
Date:   Wed,  1 Jun 2022 14:52:37 +0800
Message-Id: <20220601065238.1357624-3-imagedong@tencent.com>
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

It is annoying to add new skb drop reasons to 'enum skb_drop_reason'
and TRACE_SKB_DROP_REASON in trace/event/skb.h, and it's easy to forget
to add the new reasons we added to TRACE_SKB_DROP_REASON.

TRACE_SKB_DROP_REASON is used to convert drop reason of type number
to string. For now, the string we passed to user space is exactly the
same as the name in 'enum skb_drop_reason' with a 'SKB_DROP_REASON_'
prefix. Therefore, we can use 'auto-generation' to generate these
drop reasons to string at build time.

The new source 'dropreason_str.c' will be auto generated during build
time, which contains the string array
'const char * const drop_reasons[]'.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v3:
- add new line in the end of .gitignore
- fix awk warning by make '\;' to ';', as ';' is not need to be
  escaped
- export 'drop_reasons' in skbuff.c

v2:
- generate source file instead of header file for drop reasons string
  array (Jakub Kicinski)
---
 include/net/dropreason.h   |  2 +
 include/trace/events/skb.h | 89 +-------------------------------------
 net/core/.gitignore        |  1 +
 net/core/Makefile          | 23 +++++++++-
 net/core/drop_monitor.c    | 13 ------
 net/core/skbuff.c          |  3 ++
 6 files changed, 29 insertions(+), 102 deletions(-)
 create mode 100644 net/core/.gitignore

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index ecd18b7b1364..013ff0f2543e 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -181,4 +181,6 @@ enum skb_drop_reason {
 			SKB_DR_SET(name, reason);		\
 	} while (0)
 
+extern const char * const drop_reasons[];
+
 #endif
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
diff --git a/net/core/.gitignore b/net/core/.gitignore
new file mode 100644
index 000000000000..df1e74372cce
--- /dev/null
+++ b/net/core/.gitignore
@@ -0,0 +1 @@
+dropreason_str.c
diff --git a/net/core/Makefile b/net/core/Makefile
index a8e4f737692b..e8ce3bd283a6 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -4,7 +4,8 @@
 #
 
 obj-y := sock.o request_sock.o skbuff.o datagram.o stream.o scm.o \
-	 gen_stats.o gen_estimator.o net_namespace.o secure_seq.o flow_dissector.o
+	 gen_stats.o gen_estimator.o net_namespace.o secure_seq.o \
+	 flow_dissector.o dropreason_str.o
 
 obj-$(CONFIG_SYSCTL) += sysctl_net_core.o
 
@@ -39,3 +40,23 @@ obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
 obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
 obj-$(CONFIG_OF)	+= of_net.o
+
+clean-files := dropreason_str.c
+
+quiet_cmd_dropreason_str = GEN     $@
+cmd_dropreason_str = awk -F ',' 'BEGIN{ print "\#include <net/dropreason.h>\n"; \
+	print "const char * const drop_reasons[] = {" }\
+	/^enum skb_drop/ { dr=1; }\
+	/^\};/ { dr=0; }\
+	/^\tSKB_DROP_REASON_/ {\
+		if (dr) {\
+			sub(/\tSKB_DROP_REASON_/, "", $$1);\
+			printf "\t[SKB_DROP_REASON_%s] = \"%s\",\n", $$1, $$1;\
+		}\
+	}\
+	END{ print "};" }' $< > $@
+
+$(obj)/dropreason_str.c: $(srctree)/include/net/dropreason.h
+	$(call cmd,dropreason_str)
+
+$(obj)/dropreason_str.o: $(obj)/dropreason_str.c
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
index 1d10bb4adec1..74864e6c1835 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -91,6 +91,9 @@ static struct kmem_cache *skbuff_ext_cache __ro_after_init;
 int sysctl_max_skb_frags __read_mostly = MAX_SKB_FRAGS;
 EXPORT_SYMBOL(sysctl_max_skb_frags);
 
+/* The array 'drop_reasons' is auto-generated in dropreason_str.c */
+EXPORT_SYMBOL(drop_reasons);
+
 /**
  *	skb_panic - private function for out-of-line support
  *	@skb:	buffer
-- 
2.36.1

