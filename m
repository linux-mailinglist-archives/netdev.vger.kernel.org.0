Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B275AC937
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 05:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbiIEDu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 23:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbiIEDu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 23:50:26 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FE417582;
        Sun,  4 Sep 2022 20:50:24 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso11003952pjk.0;
        Sun, 04 Sep 2022 20:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=PzzlxoDD0gwMbgIt54iifLiktjUm4ME8kopVopYW44g=;
        b=DbdhYATM1wJP4Tk73rr8pWbvq2OPyd/Dj1s9xBJzNLlXWTUK9xKqCqf35l+NwAyWXn
         IYFpa/aVFUgKRjiR+6s9LEcjdHwFn6cFPuw3cD2oGPv61Wgj1vl977QohjG4IUvxCz8b
         bvFDpV+Wg4ZGfSz9hSr3u8EYgYGRShqOsYWv7ln210ePKiQwjZTR8iLE8YqIqt/AKiW3
         MgylES9M7c2pXHRFNp2miu/TgOmMo2dnZ3C88VqyAqlp0qwS87E/Il3lUF/RSF5CDwQv
         1aPcHnCkVvIMsqySxqN1t2/rknzr0huhQY3rP8IwSvUcFBqB+TJF0pAFkeWprwrclrnS
         a0VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=PzzlxoDD0gwMbgIt54iifLiktjUm4ME8kopVopYW44g=;
        b=o9GA1IoxQ1Nl/8FQ6jCa95OGlexQSDdZe27nDORlaO91CW8URHuDS316wXRjdLSFLY
         2GOydO14IlBZfRgec+7Ecf5QEw5fMUVRuMnBmTj4ysq814fCNM5K2lgKy9w2JNSogKYP
         efmmz9htKQ57tzyV94kRgi8YcQ39YbVaGDp5naa09a+nWFFPrWKAtFvqbmCxtsVg3eR8
         wnYH5UwtiTZNq5bMcsulYV0q5v48kBGTOiwTMxFm5V940v9GteDy1oH6LjgHOpyh+XHB
         6g7FG8IprhH8gR2Oo/nuYwtglIZe/OQEa8Y5JjwfnVjzlasOoucOW7DydTbaJqNoBG0i
         WELw==
X-Gm-Message-State: ACgBeo2MIU5GFOjy9fLbc54DG5E4RZXaNUfjyCHPYkQKoYszP7dTdjMX
        n4s15o6N0emaAX6CQsIGwsI=
X-Google-Smtp-Source: AA6agR5QPUhDCuZ7OVO7f4zAAMkzkkzMXIJfS2I7H+BkaIO+mcAZeOUNMCCkE0jsFJPK0ZnJibCyiA==
X-Received: by 2002:a17:902:f641:b0:172:e2f8:7efb with SMTP id m1-20020a170902f64100b00172e2f87efbmr45707640plg.140.1662349824317;
        Sun, 04 Sep 2022 20:50:24 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.25])
        by smtp.gmail.com with ESMTPSA id e126-20020a621e84000000b00535c4b7f1eesm6416663pfe.87.2022.09.04.20.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Sep 2022 20:50:23 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com, kuba@kernel.org
Cc:     davem@davemloft.net, pabeni@redhat.com, rostedt@goodmis.org,
        mingo@redhat.com, imagedong@tencent.com, dsahern@kernel.org,
        flyingpeng@tencent.com, dongli.zhang@oracle.com, robh@kernel.org,
        asml.silence@gmail.com, luiz.von.dentz@intel.com,
        vasily.averin@linux.dev, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net v3] net: skb: export skb drop reaons to user by TRACE_DEFINE_ENUM
Date:   Mon,  5 Sep 2022 11:50:15 +0800
Message-Id: <20220905035015.1130730-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.37.2
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

As Eric reported, the 'reason' field is not presented when trace the
kfree_skb event by perf:

$ perf record -e skb:kfree_skb -a sleep 10
$ perf script
  ip_defrag 14605 [021]   221.614303:   skb:kfree_skb:
  skbaddr=0xffff9d2851242700 protocol=34525 location=0xffffffffa39346b1
  reason:

The cause seems to be passing kernel address directly to TP_printk(),
which is not right. As the enum 'skb_drop_reason' is not exported to
user space through TRACE_DEFINE_ENUM(), perf can't get the drop reason
string from the 'reason' field, which is a number.

Therefore, we introduce the macro DEFINE_DROP_REASON(), which is used
to define the trace enum by TRACE_DEFINE_ENUM(). With the help of
DEFINE_DROP_REASON(), now we can remove the auto-generate that we
introduced in the commit ec43908dd556
("net: skb: use auto-generation to convert skb drop reason to string"),
and define the string array 'drop_reasons'.

Hmmmm...now we come back to the situation that have to maintain drop
reasons in both enum skb_drop_reason and DEFINE_DROP_REASON. But they
are both in dropreason.h, which makes it easier.

After this commit, now the format of kfree_skb is like this:

$ cat /tracing/events/skb/kfree_skb/format
name: kfree_skb
ID: 1524
format:
        field:unsigned short common_type;       offset:0;       size:2; signed:0;
        field:unsigned char common_flags;       offset:2;       size:1; signed:0;
        field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
        field:int common_pid;   offset:4;       size:4; signed:1;

        field:void * skbaddr;   offset:8;       size:8; signed:0;
        field:void * location;  offset:16;      size:8; signed:0;
        field:unsigned short protocol;  offset:24;      size:2; signed:0;
        field:enum skb_drop_reason reason;      offset:28;      size:4; signed:0;

print fmt: "skbaddr=%p protocol=%u location=%p reason: %s", REC->skbaddr, REC->protocol, REC->location, __print_symbolic(REC->reason, { 1, "NOT_SPECIFIED" }, { 2, "NO_SOCKET" } ......

Fixes: ec43908dd556 ("net: skb: use auto-generation to convert skb drop reason to string")
Link: https://lore.kernel.org/netdev/CANn89i+bx0ybvE55iMYf5GJM48WwV1HNpdm9Q6t-HaEstqpCSA@mail.gmail.com/
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v3:
- add missing Fixes and Link tags (Eric Dumazet)

v2:
- undef FN/FNe after use it (Jakub Kicinski)
---
 include/net/dropreason.h   | 67 ++++++++++++++++++++++++++++++++++++++
 include/trace/events/skb.h | 15 ++++++++-
 net/core/.gitignore        |  1 -
 net/core/Makefile          | 22 +------------
 net/core/skbuff.c          |  6 +++-
 5 files changed, 87 insertions(+), 24 deletions(-)
 delete mode 100644 net/core/.gitignore

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index fae9b40e54fa..c1cbcdbaf149 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -3,6 +3,73 @@
 #ifndef _LINUX_DROPREASON_H
 #define _LINUX_DROPREASON_H
 
+#define DEFINE_DROP_REASON(FN, FNe)	\
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
+	FNe(MAX)
+
 /**
  * enum skb_drop_reason - the reasons of skb drops
  *
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 45264e4bb254..50a974f7dfb4 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -9,6 +9,15 @@
 #include <linux/netdevice.h>
 #include <linux/tracepoint.h>
 
+#undef FN
+#define FN(reason)	TRACE_DEFINE_ENUM(SKB_DROP_REASON_##reason);
+DEFINE_DROP_REASON(FN, FN)
+
+#undef FN
+#undef FNe
+#define FN(reason)	{ SKB_DROP_REASON_##reason, #reason },
+#define FNe(reason)	{ SKB_DROP_REASON_##reason, #reason }
+
 /*
  * Tracepoint for free an sk_buff:
  */
@@ -35,9 +44,13 @@ TRACE_EVENT(kfree_skb,
 
 	TP_printk("skbaddr=%p protocol=%u location=%p reason: %s",
 		  __entry->skbaddr, __entry->protocol, __entry->location,
-		  drop_reasons[__entry->reason])
+		  __print_symbolic(__entry->reason,
+				   DEFINE_DROP_REASON(FN, FNe)))
 );
 
+#undef FN
+#undef FNe
+
 TRACE_EVENT(consume_skb,
 
 	TP_PROTO(struct sk_buff *skb),
diff --git a/net/core/.gitignore b/net/core/.gitignore
deleted file mode 100644
index df1e74372cce..000000000000
--- a/net/core/.gitignore
+++ /dev/null
@@ -1 +0,0 @@
-dropreason_str.c
diff --git a/net/core/Makefile b/net/core/Makefile
index e8ce3bd283a6..5857cec87b83 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -5,7 +5,7 @@
 
 obj-y := sock.o request_sock.o skbuff.o datagram.o stream.o scm.o \
 	 gen_stats.o gen_estimator.o net_namespace.o secure_seq.o \
-	 flow_dissector.o dropreason_str.o
+	 flow_dissector.o
 
 obj-$(CONFIG_SYSCTL) += sysctl_net_core.o
 
@@ -40,23 +40,3 @@ obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
 obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
 obj-$(CONFIG_OF)	+= of_net.o
-
-clean-files := dropreason_str.c
-
-quiet_cmd_dropreason_str = GEN     $@
-cmd_dropreason_str = awk -F ',' 'BEGIN{ print "\#include <net/dropreason.h>\n"; \
-	print "const char * const drop_reasons[] = {" }\
-	/^enum skb_drop/ { dr=1; }\
-	/^\};/ { dr=0; }\
-	/^\tSKB_DROP_REASON_/ {\
-		if (dr) {\
-			sub(/\tSKB_DROP_REASON_/, "", $$1);\
-			printf "\t[SKB_DROP_REASON_%s] = \"%s\",\n", $$1, $$1;\
-		}\
-	}\
-	END{ print "};" }' $< > $@
-
-$(obj)/dropreason_str.c: $(srctree)/include/net/dropreason.h
-	$(call cmd,dropreason_str)
-
-$(obj)/dropreason_str.o: $(obj)/dropreason_str.c
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 48ecfbf29174..f1b8b20fc20b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -91,7 +91,11 @@ static struct kmem_cache *skbuff_ext_cache __ro_after_init;
 int sysctl_max_skb_frags __read_mostly = MAX_SKB_FRAGS;
 EXPORT_SYMBOL(sysctl_max_skb_frags);
 
-/* The array 'drop_reasons' is auto-generated in dropreason_str.c */
+#undef FN
+#define FN(reason) [SKB_DROP_REASON_##reason] = #reason,
+const char * const drop_reasons[] = {
+	DEFINE_DROP_REASON(FN, FN)
+};
 EXPORT_SYMBOL(drop_reasons);
 
 /**
-- 
2.37.2

