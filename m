Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6B0535A3A
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 09:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345911AbiE0HSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 03:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345750AbiE0HR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 03:17:58 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DF113D48;
        Fri, 27 May 2022 00:17:56 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id c14so3662558pfn.2;
        Fri, 27 May 2022 00:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7vUCkoZchnIxnCLvMDvt10iL7+ruc8HuTm4ENAiltrA=;
        b=l/d30eG1k6ZZ2kPIUYoR7atGaJsdqGYytRJiL57bWWXcRqUlFlCrvdF471c1558uKC
         2gWz7h7FsbyO2Y0h7723yGlAMv8Uft252HzD57AMuXbo8C5psOYKVMNEKzPS2evMYGN5
         P6AB6iWySpCgjlmgiP5IsOG7FIv/COlVbpLpm7V400xw/h2BwNrmE2IlpTBcCM4Hm2B5
         ybtUQ9PK3fYYjb5f9vow66EuvmTkFdrg7e5YTU0P2CWSEwDJJEoo7OgWHBRfNHqm2oxT
         Du8cRFojw90RCWcqLbdgZcVuH4c5VOSbESQlf6tjKjWc2D5RIc30sqlQEGRbIL9sZVJl
         Iz6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7vUCkoZchnIxnCLvMDvt10iL7+ruc8HuTm4ENAiltrA=;
        b=mIE5lzTtcQ/WWZ5B6D7ewph5kDNu/6w8LOG/eML/0sWYCX99MXlErmquj5d7jEc8RH
         NBTu+/zKpYVXR4+L2iYIxm0qmdJE7svO06DU338RT5eRHWnXAFIBAfMVN/QC/D0yn0Xl
         k/iX4GYnynFZRIwYDT8z4uNeAGzQKZZTnP1ltI+1ncU5dP7Wguloci3jtB0uBt7/r1Yv
         4m8Ep1qzttXUPa0m45ZE1YZ7uBXlVmbPe5TslUu8y26/D1P3q+XgW9HX4WJ+ow4RLsGg
         aHte44D1alv+iOmxaUIH3ri3oahTv9eQLFLHGpW2zt0nwItF63kPNzqGfRuEPXdX9oGF
         tHhQ==
X-Gm-Message-State: AOAM531CY1X4FIkerV2tfVQkgJTTgbAcXMtLGzyN9aW5ZCnjiCeIxGF8
        /rOXWq9D6ILUte6Q6Ld73Vs=
X-Google-Smtp-Source: ABdhPJwpU7D2Kbc9/1EqQdidXoDWv9/uYg7/fe0+oemxFXFSmOSkIiKdNzMGF7GxxqCT6WovvcMIyQ==
X-Received: by 2002:a63:5f4a:0:b0:3f5:d34e:dd44 with SMTP id t71-20020a635f4a000000b003f5d34edd44mr35439451pgb.567.1653635876580;
        Fri, 27 May 2022 00:17:56 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.15])
        by smtp.gmail.com with ESMTPSA id p11-20020a1709028a8b00b00163247b64bfsm2805577plo.115.2022.05.27.00.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 00:17:56 -0700 (PDT)
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
Subject: [PATCH net-next 2/3] net: skb: use auto-generation to convert skb drop reason to string
Date:   Fri, 27 May 2022 15:15:21 +0800
Message-Id: <20220527071522.116422-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527071522.116422-1-imagedong@tencent.com>
References: <20220527071522.116422-1-imagedong@tencent.com>
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

The new header 'dropreason_str.h' will be generated, and the
__DEFINE_SKB_DROP_REASON() in it can do the converting job. Meanwhile,
we use a global array to store these string, which can be used both
in drop_monitor and 'kfree_skb' tracepoint.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/dropreason.h |  2 +
 include/trace/events/skb.h | 89 +-------------------------------------
 net/core/.gitignore        |  1 +
 net/core/Makefile          | 14 ++++++
 net/core/drop_monitor.c    | 13 ------
 net/core/skbuff.c          | 12 +++++
 6 files changed, 30 insertions(+), 101 deletions(-)
 create mode 100644 net/core/.gitignore

diff --git a/include/linux/dropreason.h b/include/linux/dropreason.h
index ecd18b7b1364..013ff0f2543e 100644
--- a/include/linux/dropreason.h
+++ b/include/linux/dropreason.h
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
index 000000000000..2148db0574dc
--- /dev/null
+++ b/net/core/.gitignore
@@ -0,0 +1 @@
+dropreason_str.h
\ No newline at end of file
diff --git a/net/core/Makefile b/net/core/Makefile
index a8e4f737692b..73b8d5f4fa09 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -39,3 +39,17 @@ obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
 obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
 obj-$(CONFIG_OF)	+= of_net.o
+
+clean-files := dropreason_str.h
+
+quiet_cmd_dropreason_str = GEN     $@
+cmd_dropreason_str = echo '\n\#define __DEFINE_SKB_DROP_REASON(FN) \' > $@;\
+	sed -e '/enum skb_drop_reason {/,/}/!d' $< | \
+	awk -F ',' '/SKB_DROP_REASON_/{printf "	FN(%s) \\\n", substr($$1, 18)}' >> $@;\
+	echo '' >> $@
+
+$(obj)/dropreason_str.h: $(srctree)/include/linux/dropreason.h
+	$(call cmd,dropreason_str)
+
+$(obj)/skbuff.o: $(obj)/dropreason_str.h
+
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
index 1d10bb4adec1..a4f4d3316a03 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -82,6 +82,7 @@
 
 #include "dev.h"
 #include "sock_destructor.h"
+#include "dropreason_str.h"
 
 struct kmem_cache *skbuff_head_cache __ro_after_init;
 static struct kmem_cache *skbuff_fclone_cache __ro_after_init;
@@ -91,6 +92,17 @@ static struct kmem_cache *skbuff_ext_cache __ro_after_init;
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
+EXPORT_SYMBOL(drop_reasons);
+
 /**
  *	skb_panic - private function for out-of-line support
  *	@skb:	buffer
-- 
2.36.1

