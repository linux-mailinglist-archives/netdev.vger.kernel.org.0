Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FEC47D184
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 13:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244817AbhLVMJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 07:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240406AbhLVMJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 07:09:30 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DCFC061574
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 04:09:30 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id l10-20020a17090a384a00b001b22190e075so411707pjf.3
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 04:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JG27UivwSlWEDIzNkRGCS2yPkY4fPWhfzpx30/KoFw8=;
        b=O3oohxhabOVek3Jp8r6/gSp+2PubyK3HPWq9a5nXSmWuLYVskgJbjgP9/yqbN4EYGP
         hSbUqrS6WPeNzlIhiX8KYpXd8fyeNgHrN9VLPnuPCZtBEtjyNkl4X7HzzSxhL6R9Os/k
         Fjhxl5800vZ+lxTPOWscVly01CPgub+Cqddw9UCTdE0JjFLrHh/TlsbU+OPLCoONfqBG
         DAXsPIvv6aIAwbGVaG+iB1YIfMnl5tJAFY2URvOpSpb1OqhPMnd5QIDi8DXrLAcr5/yH
         PEVVvyPJ41OQLx/rapMxZ82CLsQix1lnYbaKxtZtrDN+FMYyGbVcmNrUzhsSsxB7PD8D
         cVCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JG27UivwSlWEDIzNkRGCS2yPkY4fPWhfzpx30/KoFw8=;
        b=VRmStgPuTm1Bl+6ZVb0fAT2DW49Q+UiHWusdvTSXuR7I2ta+jXh5/CzyJx4hSWBbS2
         ESd4UkfKwTURi0daon4BewbltH3ZzvMiTeZlIME6VeBblvmUoqFYi8t8z2rniRy1QES+
         HwNUP1ZvaGjMhxUFVVZTlxGytdP8o7QD+Ef3WtL2DG+6El/xSeirjtQiNX8+hHgbz2NL
         HxxHA3RjdT3Nutp7jqlbEk3Q6CwJ7ArXBQLayFfT7gwq8qqVdUmErVndubqeKwE0F25G
         9o+qdl6LyYnb1GuFNqgcF2w63pnMXg02dd6DNUQf9beMZwXDNPjr6vMb679wpp1mQb9C
         rEJQ==
X-Gm-Message-State: AOAM530CocQbWYSaNwWQg8beFprOH9c0Pj6q0PUZ6SNXbwBRXrUc+9Sj
        moi+8BjkErA4wmYnfMNMaDwJtfviVEWRCw==
X-Google-Smtp-Source: ABdhPJxjT6yJ4hL/PXWhhoWNBfVXRXCkXYsuyLFO+2r1d68DJLy/p7tJOz9FNFc42arA9OdFo/GJqw==
X-Received: by 2002:a17:90b:4a09:: with SMTP id kk9mr992516pjb.230.1640174969946;
        Wed, 22 Dec 2021 04:09:29 -0800 (PST)
Received: from localhost.localdomain ([111.201.150.233])
        by smtp.gmail.com with ESMTPSA id y128sm2598517pfb.24.2021.12.22.04.09.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Dec 2021 04:09:29 -0800 (PST)
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
Subject: [net-next v6 1/2] net: sched: use queue_mapping to pick tx queue
Date:   Wed, 22 Dec 2021 20:08:08 +0800
Message-Id: <20211222120809.2222-2-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20211222120809.2222-1-xiangxia.m.yue@gmail.com>
References: <20211222120809.2222-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This patch fixes issue:
* If we install tc filters with act_skbedit in clsact hook.
  It doesn't work, because netdev_core_pick_tx() overwrites
  queue_mapping.

  $ tc filter ... action skbedit queue_mapping 1

And this patch is useful:
* We can use FQ + EDT to implement efficient policies. Tx queues
  are picked by xps, ndo_select_queue of netdev driver, or skb hash
  in netdev_core_pick_tx(). In fact, the netdev driver, and skb
  hash are _not_ under control. xps uses the CPUs map to select Tx
  queues, but we can't figure out which task_struct of pod/containter
  running on this cpu in most case. We can use clsact filters to classify
  one pod/container traffic to one Tx queue. Why ?

  In containter networking environment, there are two kinds of pod/
  containter/net-namespace. One kind (e.g. P1, P2), the high throughput
  is key in these applications. But avoid running out of network resource,
  the outbound traffic of these pods is limited, using or sharing one
  dedicated Tx queues assigned HTB/TBF/FQ Qdisc. Other kind of pods
  (e.g. Pn), the low latency of data access is key. And the traffic is not
  limited. Pods use or share other dedicated Tx queues assigned FIFO Qdisc.
  This choice provides two benefits. First, contention on the HTB/FQ Qdisc
  lock is significantly reduced since fewer CPUs contend for the same queue.
  More importantly, Qdisc contention can be eliminated completely if each
  CPU has its own FIFO Qdisc for the second kind of pods.

  There must be a mechanism in place to support classifying traffic based on
  pods/container to different Tx queues. Note that clsact is outside of Qdisc
  while Qdisc can run a classifier to select a sub-queue under the lock.

  In general recording the decision in the skb seems a little heavy handed.
  This patch introduces a per-CPU variable, suggested by Eric.

  The xmit.skip_txqueue flag is firstly cleared in __dev_queue_xmit().
  - Tx Qdisc may install that skbedit actions, then xmit.skip_txqueue flag
    is set in qdisc->enqueue() though tx queue has been selected in
    netdev_tx_queue_mapping() or netdev_core_pick_tx(). That flag is cleared
    firstly in __dev_queue_xmit(), is useful:
  - Avoid picking Tx queue with netdev_tx_queue_mapping() in next netdev
    in such case: eth0 macvlan - eth0.3 vlan - eth0 ixgbe-phy:
    For example, eth0, macvlan in pod, which root Qdisc install skbedit
    queue_mapping, send packets to eth0.3, vlan in host. In __dev_queue_xmit() of
    eth0.3, clear the flag, does not select tx queue according to skb->queue_mapping
    because there is no filters in clsact or tx Qdisc of this netdev.
    Same action taked in eth0, ixgbe in Host.
  - Avoid picking Tx queue for next packet. If we set xmit.skip_txqueue
    in tx Qdisc (qdisc->enqueue()), the proper way to clear it is clearing it
    in __dev_queue_xmit when processing next packets.

  For performance reasons, use the static key. If user does not config the NET_EGRESS,
  the patch will not be compiled.

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
    | q0        | q1        | qn
    v           v           v
  HTB/FQ      HTB/FQ  ...  FIFO

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
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 include/linux/netdevice.h |  3 +++
 include/linux/rtnetlink.h |  3 +++
 net/core/dev.c            | 44 ++++++++++++++++++++++++++++++++++++++-
 net/sched/act_skbedit.c   | 18 ++++++++++++++--
 4 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8b0bdeb4734e..708e9f4cca01 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3010,6 +3010,9 @@ struct softnet_data {
 	struct {
 		u16 recursion;
 		u8  more;
+#ifdef CONFIG_NET_EGRESS
+		u8  skip_txqueue;
+#endif
 	} xmit;
 #ifdef CONFIG_RPS
 	/* input_queue_head should be written by cpu owning this struct,
diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index bb9cb84114c1..256bf78daea6 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -100,6 +100,9 @@ void net_dec_ingress_queue(void);
 #ifdef CONFIG_NET_EGRESS
 void net_inc_egress_queue(void);
 void net_dec_egress_queue(void);
+void net_inc_queue_mapping(void);
+void net_dec_queue_mapping(void);
+void netdev_xmit_skip_txqueue(bool skip);
 #endif
 
 void rtnetlink_init(void);
diff --git a/net/core/dev.c b/net/core/dev.c
index a855e41bbe39..b197dabcd721 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1998,6 +1998,20 @@ void net_dec_egress_queue(void)
 	static_branch_dec(&egress_needed_key);
 }
 EXPORT_SYMBOL_GPL(net_dec_egress_queue);
+
+static DEFINE_STATIC_KEY_FALSE(txqueue_needed_key);
+
+void net_inc_queue_mapping(void)
+{
+	static_branch_inc(&txqueue_needed_key);
+}
+EXPORT_SYMBOL_GPL(net_inc_queue_mapping);
+
+void net_dec_queue_mapping(void)
+{
+	static_branch_dec(&txqueue_needed_key);
+}
+EXPORT_SYMBOL_GPL(net_dec_queue_mapping);
 #endif
 
 static DEFINE_STATIC_KEY_FALSE(netstamp_needed_key);
@@ -3860,6 +3874,25 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 
 	return skb;
 }
+
+static inline struct netdev_queue *
+netdev_tx_queue_mapping(struct net_device *dev, struct sk_buff *skb)
+{
+       int qm = skb_get_queue_mapping(skb);
+
+       return netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, qm));
+}
+
+static inline bool netdev_xmit_txqueue_skipped(void)
+{
+	return __this_cpu_read(softnet_data.xmit.skip_txqueue);
+}
+
+void netdev_xmit_skip_txqueue(bool skip)
+{
+	__this_cpu_write(softnet_data.xmit.skip_txqueue, skip);
+}
+EXPORT_SYMBOL_GPL(netdev_xmit_skip_txqueue);
 #endif /* CONFIG_NET_EGRESS */
 
 #ifdef CONFIG_XPS
@@ -4052,6 +4085,9 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	skb->tc_at_ingress = 0;
 #endif
 #ifdef CONFIG_NET_EGRESS
+	if (static_branch_unlikely(&txqueue_needed_key))
+		netdev_xmit_skip_txqueue(false);
+
 	if (static_branch_unlikely(&egress_needed_key)) {
 		if (nf_hook_egress_active()) {
 			skb = nf_hook_egress(skb, &rc, dev);
@@ -4064,7 +4100,14 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 			goto out;
 		nf_skip_egress(skb, false);
 	}
+
+	if (static_branch_unlikely(&txqueue_needed_key) &&
+	    netdev_xmit_txqueue_skipped())
+		txq = netdev_tx_queue_mapping(dev, skb);
+	else
 #endif
+		txq = netdev_core_pick_tx(dev, skb, sb_dev);
+
 	/* If device/qdisc don't need skb->dst, release it right now while
 	 * its hot in this cpu cache.
 	 */
@@ -4073,7 +4116,6 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	else
 		skb_dst_force(skb);
 
-	txq = netdev_core_pick_tx(dev, skb, sb_dev);
 	q = rcu_dereference_bh(txq->qdisc);
 
 	trace_net_dev_queue(skb);
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index ceba11b198bb..325991080a8a 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -58,8 +58,12 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 		}
 	}
 	if (params->flags & SKBEDIT_F_QUEUE_MAPPING &&
-	    skb->dev->real_num_tx_queues > params->queue_mapping)
+	    skb->dev->real_num_tx_queues > params->queue_mapping) {
+#ifdef CONFIG_NET_EGRESS
+		netdev_xmit_skip_txqueue(true);
+#endif
 		skb_set_queue_mapping(skb, params->queue_mapping);
+	}
 	if (params->flags & SKBEDIT_F_MARK) {
 		skb->mark &= ~params->mask;
 		skb->mark |= params->mark & params->mask;
@@ -225,6 +229,11 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 
+#ifdef CONFIG_NET_EGRESS
+	if (flags & SKBEDIT_F_QUEUE_MAPPING)
+		net_inc_queue_mapping();
+#endif
+
 	return ret;
 put_chain:
 	if (goto_ch)
@@ -295,8 +304,13 @@ static void tcf_skbedit_cleanup(struct tc_action *a)
 	struct tcf_skbedit_params *params;
 
 	params = rcu_dereference_protected(d->params, 1);
-	if (params)
+	if (params) {
+#ifdef CONFIG_NET_EGRESS
+		if (params->flags & SKBEDIT_F_QUEUE_MAPPING)
+			net_dec_queue_mapping();
+#endif
 		kfree_rcu(params, rcu);
+	}
 }
 
 static int tcf_skbedit_walker(struct net *net, struct sk_buff *skb,
-- 
2.27.0

