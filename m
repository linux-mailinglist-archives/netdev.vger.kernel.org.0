Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C3B4BF733
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 12:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiBVLYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 06:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbiBVLYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 06:24:15 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C2713196F
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 03:23:50 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id om7so18107478pjb.5
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 03:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qJ+Y4atPSPLq3bd5q6EsfX7vVURAhXQyT9m9RHYcU/s=;
        b=bsD+6Hq5r/s3ZqcDOTdAXRMZdZDL2W8RW/mupk1uGcALy3GQkPb9pnu4ms/88hjDKP
         mn+zPYavTpumX4dU8P1QYOkx5R56FdxvyOguByrcqTggcG0z1JJSU5Ssdh6UFmWmx9rZ
         qhsf9zywWBt/+WgjwB3ZJStPCb+LycW53bD5NKXWbDSY7kKQK0YMqvbvcbeyt3Sa8B8s
         detA1VPYQzFduui7tUfxtGN20xkpYYFyMuNPfL4NGJ2cOf93TvdtiYf8r7UkMxD67cFe
         4C+cGjT6d0fXToPyaGJdWQ118GFIsxEzWI3DggEvzgjdvINNkFUSWhS88kJd7pvyGGjm
         5wMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qJ+Y4atPSPLq3bd5q6EsfX7vVURAhXQyT9m9RHYcU/s=;
        b=zJDcxE0vGHG4f05/eV3+O9HFtZhG6QTCc6R9+dRKw3j4IqLBKU+/qvR46SeuxOv5ik
         dUUGAFoa/VdKkxN/czHXjt9QgzEQGALDkoliG/LkkOzgnQDBkD75SxFNrQokCdRrzSRz
         H9eEj2UJkgQaNWQmOv8i16HsrM5uSmbdamJWDkYqD2JZD1eL5PGwp8PYpI4q8tNT3fpH
         UkJ3KwZJsh8Ek7QlxlYd7cx0uHsr9pWHBLnxVLPxkH7UGs53s5Deir2lp45Urr5xPWQ+
         /ZmEqHjaoKnNHpXYPTahRNrV3BqCa0u+Np2eJle1H/DDFrM93BN2tseQL0a4RP5btyfh
         JyZw==
X-Gm-Message-State: AOAM532gojHMqxV389PWzL2aeN26oFfb3VKD/7Seo/XmCmJd39IDL4De
        vJu2ADHH4cJZ/UlWG3wamTqKEOWK4M0FIg==
X-Google-Smtp-Source: ABdhPJyUqrOOopPITGTO3So03mI4wMw91h5dhCEVnhDJ02RbGPvntsm0QqiUd94uvmSYouZ7mNexjA==
X-Received: by 2002:a17:90b:250f:b0:1b8:f257:c39 with SMTP id ns15-20020a17090b250f00b001b8f2570c39mr3598613pjb.135.1645529029148;
        Tue, 22 Feb 2022 03:23:49 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id v10sm17331511pfu.38.2022.02.22.03.23.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Feb 2022 03:23:48 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [net-next v9 2/2] net: sched: support hash/classid/cpuid selecting tx queue
Date:   Tue, 22 Feb 2022 19:23:26 +0800
Message-Id: <20220222112326.15070-3-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220222112326.15070-1-xiangxia.m.yue@gmail.com>
References: <20220222112326.15070-1-xiangxia.m.yue@gmail.com>
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

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This patch allows users to pick queue_mapping, range
from A to B. And users can use skbhash, cgroup classid
and cpuid to pick Tx queues. Then we can load balance
packets from A to B tx queue. The range is an unsigned 16bit
value in decimal format.

$ tc filter ... action skbedit queue_mapping skbhash A B

"skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit")
is enhanced with flags:
* SKBEDIT_F_TXQ_SKBHASH
* SKBEDIT_F_TXQ_CLASSID
* SKBEDIT_F_TXQ_CPUID

Use skb->hash, cgroup classid, or cpuid to distribute packets.
Then same range of tx queues can be shared for different flows,
cgroups, or CPUs in a variety of scenarios.

  +----+      +----+      +----+
  | P1 |      | P2 |      | Pn |
  +----+      +----+      +----+
    |           |           |
    +-----------+-----------+
                |
                | clsact/skbedit
                |      MQ
                v
    +-----------+-----------+
    | q0        | qn        | qm
    v           v           v
  HTB/FQ       FIFO   ...  FIFO

For example:
If P1 sends out packets to different Pods on other
host, and we want distribute flows from qn - qm. Then we can use
the SKBEDIT_F_TXQ_HASH skb->hash as hash.

If P1 pinned on CPU1, and P2 pinned CPU2 share the txqueue range,
we can use the cpuid as hash to select txqueue.

setup commands:
$ NETDEV=eth0
$ ip netns add n1
$ ip link add ipv1 link $NETDEV type ipvlan mode l2
$ ip link set ipv1 netns n1
$ ip netns exec n1 ifconfig ipv1 2.2.2.100/24 up

$ tc qdisc add dev $NETDEV clsact
$ tc filter add dev $NETDEV egress protocol ip prio 1 \
	flower skip_hw src_ip 2.2.2.100 action skbedit queue_mapping skbhash 2 6
$ tc qdisc add dev $NETDEV handle 1: root mq
$ tc qdisc add dev $NETDEV parent 1:1 handle 2: htb
$ tc class add dev $NETDEV parent 2: classid 2:1 htb rate 100kbit
$ tc class add dev $NETDEV parent 2: classid 2:2 htb rate 200kbit
$ tc qdisc add dev $NETDEV parent 1:2 tbf rate 100mbit burst 100mb latency 1
$ tc qdisc add dev $NETDEV parent 1:3 pfifo
$ tc qdisc add dev $NETDEV parent 1:4 pfifo
$ tc qdisc add dev $NETDEV parent 1:5 pfifo
$ tc qdisc add dev $NETDEV parent 1:6 pfifo
$ tc qdisc add dev $NETDEV parent 1:7 pfifo

$ ip netns exec n1 iperf3 -c 2.2.2.1 -i 1 -t 10 -P 10

pick txqueue from 2 - 6:
$ ethtool -S $NETDEV | grep -i tx_queue_[0-9]_bytes
     tx_queue_0_bytes: 42
     tx_queue_1_bytes: 0
     tx_queue_2_bytes: 11442586444
     tx_queue_3_bytes: 7383615334
     tx_queue_4_bytes: 3981365579
     tx_queue_5_bytes: 3983235051
     tx_queue_6_bytes: 6706236461
     tx_queue_7_bytes: 42
     tx_queue_8_bytes: 0
     tx_queue_9_bytes: 0

txqueues 2 - 6 are mapped to classid 1:3 - 1:7
$ tc -s class show dev $NETDEV
...
class mq 1:3 root leaf 8002:
 Sent 11949133672 bytes 7929798 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:4 root leaf 8003:
 Sent 7710449050 bytes 5117279 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:5 root leaf 8004:
 Sent 4157648675 bytes 2758990 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:6 root leaf 8005:
 Sent 4159632195 bytes 2759990 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:7 root leaf 8006:
 Sent 7003169603 bytes 4646912 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
...

Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Talal Ahmad <talalahmad@google.com>
Cc: Kevin Hao <haokexin@gmail.com>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Antoine Tenart <atenart@kernel.org>
Cc: Wei Wang <weiwan@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 include/net/tc_act/tc_skbedit.h        |  1 +
 include/uapi/linux/tc_act/tc_skbedit.h |  8 +++
 net/sched/act_skbedit.c                | 78 +++++++++++++++++++++++++-
 3 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/include/net/tc_act/tc_skbedit.h b/include/net/tc_act/tc_skbedit.h
index 00bfee70609e..ee96e0fa6566 100644
--- a/include/net/tc_act/tc_skbedit.h
+++ b/include/net/tc_act/tc_skbedit.h
@@ -17,6 +17,7 @@ struct tcf_skbedit_params {
 	u32 mark;
 	u32 mask;
 	u16 queue_mapping;
+	u16 mapping_mod;
 	u16 ptype;
 	struct rcu_head rcu;
 };
diff --git a/include/uapi/linux/tc_act/tc_skbedit.h b/include/uapi/linux/tc_act/tc_skbedit.h
index 800e93377218..5ea1438a4d88 100644
--- a/include/uapi/linux/tc_act/tc_skbedit.h
+++ b/include/uapi/linux/tc_act/tc_skbedit.h
@@ -29,6 +29,13 @@
 #define SKBEDIT_F_PTYPE			0x8
 #define SKBEDIT_F_MASK			0x10
 #define SKBEDIT_F_INHERITDSFIELD	0x20
+#define SKBEDIT_F_TXQ_SKBHASH		0x40
+#define SKBEDIT_F_TXQ_CLASSID		0x80
+#define SKBEDIT_F_TXQ_CPUID		0x100
+
+#define SKBEDIT_F_TXQ_HASH_MASK (SKBEDIT_F_TXQ_SKBHASH | \
+				 SKBEDIT_F_TXQ_CLASSID | \
+				 SKBEDIT_F_TXQ_CPUID)
 
 struct tc_skbedit {
 	tc_gen;
@@ -45,6 +52,7 @@ enum {
 	TCA_SKBEDIT_PTYPE,
 	TCA_SKBEDIT_MASK,
 	TCA_SKBEDIT_FLAGS,
+	TCA_SKBEDIT_QUEUE_MAPPING_MAX,
 	__TCA_SKBEDIT_MAX
 };
 #define TCA_SKBEDIT_MAX (__TCA_SKBEDIT_MAX - 1)
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index d5799b4fc499..4c209689f8de 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
 #include <linux/rtnetlink.h>
+#include <net/cls_cgroup.h>
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/ip.h>
@@ -23,6 +24,38 @@
 static unsigned int skbedit_net_id;
 static struct tc_action_ops act_skbedit_ops;
 
+static u16 tcf_skbedit_hash(struct tcf_skbedit_params *params,
+			    struct sk_buff *skb)
+{
+	u32 mapping_hash_type = params->flags & SKBEDIT_F_TXQ_HASH_MASK;
+	u16 queue_mapping = params->queue_mapping;
+	u16 mapping_mod = params->mapping_mod;
+	u32 hash = 0;
+
+	switch (mapping_hash_type) {
+	case SKBEDIT_F_TXQ_CLASSID:
+		hash = task_get_classid(skb);
+		break;
+	case SKBEDIT_F_TXQ_SKBHASH:
+		hash = skb_get_hash(skb);
+		break;
+	case SKBEDIT_F_TXQ_CPUID:
+		hash = raw_smp_processor_id();
+		break;
+	case 0:
+		/* Hash type isn't specified. In this case:
+		 * hash % mapping_mod == 0
+		 */
+		break;
+	default:
+		net_warn_ratelimited("The type of queue_mapping hash is not supported. 0x%x\n",
+				     mapping_hash_type);
+	}
+
+	queue_mapping = queue_mapping + hash % mapping_mod;
+	return netdev_cap_txqueue(skb->dev, queue_mapping);
+}
+
 static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 			   struct tcf_result *res)
 {
@@ -62,7 +95,7 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 #ifdef CONFIG_NET_EGRESS
 		netdev_xmit_skip_txqueue(true);
 #endif
-		skb_set_queue_mapping(skb, params->queue_mapping);
+		skb_set_queue_mapping(skb, tcf_skbedit_hash(params, skb));
 	}
 	if (params->flags & SKBEDIT_F_MARK) {
 		skb->mark &= ~params->mask;
@@ -96,6 +129,7 @@ static const struct nla_policy skbedit_policy[TCA_SKBEDIT_MAX + 1] = {
 	[TCA_SKBEDIT_PTYPE]		= { .len = sizeof(u16) },
 	[TCA_SKBEDIT_MASK]		= { .len = sizeof(u32) },
 	[TCA_SKBEDIT_FLAGS]		= { .len = sizeof(u64) },
+	[TCA_SKBEDIT_QUEUE_MAPPING_MAX]	= { .len = sizeof(u16) },
 };
 
 static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
@@ -112,6 +146,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	struct tcf_skbedit *d;
 	u32 flags = 0, *priority = NULL, *mark = NULL, *mask = NULL;
 	u16 *queue_mapping = NULL, *ptype = NULL;
+	u16 mapping_mod = 1;
 	bool exists = false;
 	int ret = 0, err;
 	u32 index;
@@ -156,7 +191,34 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 
 	if (tb[TCA_SKBEDIT_FLAGS] != NULL) {
 		u64 *pure_flags = nla_data(tb[TCA_SKBEDIT_FLAGS]);
-
+		u64 mapping_hash_type;
+
+		mapping_hash_type = *pure_flags & SKBEDIT_F_TXQ_HASH_MASK;
+		if (mapping_hash_type) {
+			u16 *queue_mapping_max;
+
+			/* Hash types are mutually exclusive. */
+			if (mapping_hash_type & (mapping_hash_type - 1)) {
+				NL_SET_ERR_MSG_MOD(extack, "Multi types of hash are specified.");
+				return -EINVAL;
+			}
+
+			if (!tb[TCA_SKBEDIT_QUEUE_MAPPING] ||
+			    !tb[TCA_SKBEDIT_QUEUE_MAPPING_MAX]) {
+				NL_SET_ERR_MSG_MOD(extack, "Missing required range of queue_mapping.");
+				return -EINVAL;
+			}
+
+			queue_mapping_max =
+				nla_data(tb[TCA_SKBEDIT_QUEUE_MAPPING_MAX]);
+			if (*queue_mapping_max < *queue_mapping) {
+				NL_SET_ERR_MSG_MOD(extack, "The range of queue_mapping is invalid, max < min.");
+				return -EINVAL;
+			}
+
+			mapping_mod = *queue_mapping_max - *queue_mapping + 1;
+			flags |= mapping_hash_type;
+		}
 		if (*pure_flags & SKBEDIT_F_INHERITDSFIELD)
 			flags |= SKBEDIT_F_INHERITDSFIELD;
 	}
@@ -208,8 +270,10 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	params_new->flags = flags;
 	if (flags & SKBEDIT_F_PRIORITY)
 		params_new->priority = *priority;
-	if (flags & SKBEDIT_F_QUEUE_MAPPING)
+	if (flags & SKBEDIT_F_QUEUE_MAPPING) {
 		params_new->queue_mapping = *queue_mapping;
+		params_new->mapping_mod = mapping_mod;
+	}
 	if (flags & SKBEDIT_F_MARK)
 		params_new->mark = *mark;
 	if (flags & SKBEDIT_F_PTYPE)
@@ -276,6 +340,13 @@ static int tcf_skbedit_dump(struct sk_buff *skb, struct tc_action *a,
 		goto nla_put_failure;
 	if (params->flags & SKBEDIT_F_INHERITDSFIELD)
 		pure_flags |= SKBEDIT_F_INHERITDSFIELD;
+	if (params->flags & SKBEDIT_F_TXQ_HASH_MASK) {
+		if (nla_put_u16(skb, TCA_SKBEDIT_QUEUE_MAPPING_MAX,
+				params->queue_mapping + params->mapping_mod - 1))
+			goto nla_put_failure;
+
+		pure_flags |= params->flags & SKBEDIT_F_TXQ_HASH_MASK;
+	}
 	if (pure_flags != 0 &&
 	    nla_put(skb, TCA_SKBEDIT_FLAGS, sizeof(pure_flags), &pure_flags))
 		goto nla_put_failure;
@@ -325,6 +396,7 @@ static size_t tcf_skbedit_get_fill_size(const struct tc_action *act)
 	return nla_total_size(sizeof(struct tc_skbedit))
 		+ nla_total_size(sizeof(u32)) /* TCA_SKBEDIT_PRIORITY */
 		+ nla_total_size(sizeof(u16)) /* TCA_SKBEDIT_QUEUE_MAPPING */
+		+ nla_total_size(sizeof(u16)) /* TCA_SKBEDIT_QUEUE_MAPPING_MAX */
 		+ nla_total_size(sizeof(u32)) /* TCA_SKBEDIT_MARK */
 		+ nla_total_size(sizeof(u16)) /* TCA_SKBEDIT_PTYPE */
 		+ nla_total_size(sizeof(u32)) /* TCA_SKBEDIT_MASK */
-- 
2.27.0

