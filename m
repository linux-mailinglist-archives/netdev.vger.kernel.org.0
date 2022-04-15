Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4989D502DD5
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 18:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355892AbiDOQnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 12:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355896AbiDOQnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 12:43:35 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B68CD30B
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 09:41:06 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 32so7688743pgl.4
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 09:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pi2p9s+7ockuAfhrzEFX26mtKh7CLuNVCsy4MKBs+0A=;
        b=joaIqEfP9X+4vMjl7KWx6hzI5qg0RY4vxPCynj2wWO58LVVm7KslIHY9NlPQcvYrdx
         1d4gPCvaffIlxycb+2nE32s//+iaWpMum1VO50/syRK0LpImF0BxvV8MXHGcN/syiNGh
         3+iLQ3U0C8gooxksM1V40FkK4EFNXu/B0wwNgXdTh0BTMaCt8EXDtVeMP1RxkSYBwXmi
         fEISl8WCkDFk3zWDd3KGHudxIFJl/iC5ceM39JxtfokWdDEfJDFyr9JjppAgcGTVb9Ok
         GyBape6hNEeB/5rMk9hoCBbKWBBH3uD5oEA7nsXgPoi3VG6AFDnMSt7dBjWDGGVBjjIU
         2Q9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pi2p9s+7ockuAfhrzEFX26mtKh7CLuNVCsy4MKBs+0A=;
        b=4EjPmhBxH5xOIgMnz/PImKRVYfZXVLtvo0GmrT/gZmOzzmsZ7ma0up4IBl/SgWke6T
         Eb7agXXSFRAq1OOQ5w/Vv2YH4FHDBD8hQkn/sT14LyYe+Iy0Z7my0KlI4EpGnp1BqSRF
         tcNjpH0lPlBuwqqI2CWn9aYKvvw3cxNwx1gi/xczyjdjj+qVcDryXIsSQi1znjOMn+jB
         7hSXPPfYw8YNVk0WVA47lOmicgLzrQwNRc8UzdC3/vXP33ldiX+/xOdsfzJSSe+Ciwc1
         NmQ3t+75uHBr208ClWi9jEixddOcPTRfoJChAognHTnoklXMaEfjWFru4MvB5xSDI7Nm
         +rbw==
X-Gm-Message-State: AOAM533Vz5bCRoB3x77QedODy4z/0NCWx5mMCOhufjF8jqQP4k5LtIS3
        i1bTrMGl+Kw/3ZjRhJadlLe2/xlYF3wH3Vwd
X-Google-Smtp-Source: ABdhPJzMB1w6zmYwGxuvv1ItAsg62ji6u3UB1Car0vPq6UsygesfjrOiEFSDovJkV+TUbrudStCYQQ==
X-Received: by 2002:a05:6a00:b8e:b0:505:8d7e:cb02 with SMTP id g14-20020a056a000b8e00b005058d7ecb02mr9577268pfj.68.1650040865862;
        Fri, 15 Apr 2022 09:41:05 -0700 (PDT)
Received: from localhost.localdomain ([111.201.148.136])
        by smtp.gmail.com with ESMTPSA id w123-20020a623081000000b005056a4d71e3sm3322171pfw.77.2022.04.15.09.41.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Apr 2022 09:41:05 -0700 (PDT)
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
Subject: [net-next RESEND v11 2/2] net: sched: support hash selecting tx queue
Date:   Sat, 16 Apr 2022 00:40:46 +0800
Message-Id: <20220415164046.26636-3-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220415164046.26636-1-xiangxia.m.yue@gmail.com>
References: <20220415164046.26636-1-xiangxia.m.yue@gmail.com>
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
from A to B. Then we can load balance packets from A
to B tx queue. The range is an unsigned 16bit value
in decimal format.

$ tc filter ... action skbedit queue_mapping skbhash A B

"skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit")
is enhanced with flags: SKBEDIT_F_TXQ_SKBHASH

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
If P1 sends out packets to different Pods on other host, and
we want distribute flows from qn - qm. Then we can use skb->hash
as hash.

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
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/tc_act/tc_skbedit.h        |  1 +
 include/uapi/linux/tc_act/tc_skbedit.h |  2 ++
 net/sched/act_skbedit.c                | 49 ++++++++++++++++++++++++--
 3 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/include/net/tc_act/tc_skbedit.h b/include/net/tc_act/tc_skbedit.h
index cab8229b9bed..dc1079f28e13 100644
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
index 800e93377218..6cb6101208d0 100644
--- a/include/uapi/linux/tc_act/tc_skbedit.h
+++ b/include/uapi/linux/tc_act/tc_skbedit.h
@@ -29,6 +29,7 @@
 #define SKBEDIT_F_PTYPE			0x8
 #define SKBEDIT_F_MASK			0x10
 #define SKBEDIT_F_INHERITDSFIELD	0x20
+#define SKBEDIT_F_TXQ_SKBHASH		0x40
 
 struct tc_skbedit {
 	tc_gen;
@@ -45,6 +46,7 @@ enum {
 	TCA_SKBEDIT_PTYPE,
 	TCA_SKBEDIT_MASK,
 	TCA_SKBEDIT_FLAGS,
+	TCA_SKBEDIT_QUEUE_MAPPING_MAX,
 	__TCA_SKBEDIT_MAX
 };
 #define TCA_SKBEDIT_MAX (__TCA_SKBEDIT_MAX - 1)
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 1c5fdb6e7c2f..e3bd11dfe1ca 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -23,6 +23,20 @@
 static unsigned int skbedit_net_id;
 static struct tc_action_ops act_skbedit_ops;
 
+static u16 tcf_skbedit_hash(struct tcf_skbedit_params *params,
+			    struct sk_buff *skb)
+{
+	u16 queue_mapping = params->queue_mapping;
+
+	if (params->flags & SKBEDIT_F_TXQ_SKBHASH) {
+		u32 hash = skb_get_hash(skb);
+
+		queue_mapping += hash % params->mapping_mod;
+	}
+
+	return netdev_cap_txqueue(skb->dev, queue_mapping);
+}
+
 static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 			   struct tcf_result *res)
 {
@@ -62,7 +76,7 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 #ifdef CONFIG_NET_EGRESS
 		netdev_xmit_skip_txqueue(true);
 #endif
-		skb_set_queue_mapping(skb, params->queue_mapping);
+		skb_set_queue_mapping(skb, tcf_skbedit_hash(params, skb));
 	}
 	if (params->flags & SKBEDIT_F_MARK) {
 		skb->mark &= ~params->mask;
@@ -96,6 +110,7 @@ static const struct nla_policy skbedit_policy[TCA_SKBEDIT_MAX + 1] = {
 	[TCA_SKBEDIT_PTYPE]		= { .len = sizeof(u16) },
 	[TCA_SKBEDIT_MASK]		= { .len = sizeof(u32) },
 	[TCA_SKBEDIT_FLAGS]		= { .len = sizeof(u64) },
+	[TCA_SKBEDIT_QUEUE_MAPPING_MAX]	= { .len = sizeof(u16) },
 };
 
 static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
@@ -112,6 +127,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	struct tcf_skbedit *d;
 	u32 flags = 0, *priority = NULL, *mark = NULL, *mask = NULL;
 	u16 *queue_mapping = NULL, *ptype = NULL;
+	u16 mapping_mod = 1;
 	bool exists = false;
 	int ret = 0, err;
 	u32 index;
@@ -157,6 +173,25 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	if (tb[TCA_SKBEDIT_FLAGS] != NULL) {
 		u64 *pure_flags = nla_data(tb[TCA_SKBEDIT_FLAGS]);
 
+		if (*pure_flags & SKBEDIT_F_TXQ_SKBHASH) {
+			u16 *queue_mapping_max;
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
+			flags |= SKBEDIT_F_TXQ_SKBHASH;
+		}
 		if (*pure_flags & SKBEDIT_F_INHERITDSFIELD)
 			flags |= SKBEDIT_F_INHERITDSFIELD;
 	}
@@ -208,8 +243,10 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
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
@@ -276,6 +313,13 @@ static int tcf_skbedit_dump(struct sk_buff *skb, struct tc_action *a,
 		goto nla_put_failure;
 	if (params->flags & SKBEDIT_F_INHERITDSFIELD)
 		pure_flags |= SKBEDIT_F_INHERITDSFIELD;
+	if (params->flags & SKBEDIT_F_TXQ_SKBHASH) {
+		if (nla_put_u16(skb, TCA_SKBEDIT_QUEUE_MAPPING_MAX,
+				params->queue_mapping + params->mapping_mod - 1))
+			goto nla_put_failure;
+
+		pure_flags |= SKBEDIT_F_TXQ_SKBHASH;
+	}
 	if (pure_flags != 0 &&
 	    nla_put(skb, TCA_SKBEDIT_FLAGS, sizeof(pure_flags), &pure_flags))
 		goto nla_put_failure;
@@ -325,6 +369,7 @@ static size_t tcf_skbedit_get_fill_size(const struct tc_action *act)
 	return nla_total_size(sizeof(struct tc_skbedit))
 		+ nla_total_size(sizeof(u32)) /* TCA_SKBEDIT_PRIORITY */
 		+ nla_total_size(sizeof(u16)) /* TCA_SKBEDIT_QUEUE_MAPPING */
+		+ nla_total_size(sizeof(u16)) /* TCA_SKBEDIT_QUEUE_MAPPING_MAX */
 		+ nla_total_size(sizeof(u32)) /* TCA_SKBEDIT_MARK */
 		+ nla_total_size(sizeof(u16)) /* TCA_SKBEDIT_PTYPE */
 		+ nla_total_size(sizeof(u32)) /* TCA_SKBEDIT_MASK */
-- 
2.27.0

