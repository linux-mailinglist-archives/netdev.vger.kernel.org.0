Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CBF49CC60
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 15:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242162AbiAZOcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 09:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbiAZOcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 09:32:23 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A28C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 06:32:23 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id 192so19332404pfz.3
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 06:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ucFPx9Ax7UaActBSj4s8rx+N1Jq9f5Fxoxrjk3KTC8g=;
        b=R6pPzuE1QWtkFSrLvXD0LhhdkUZbTe3BZ4WJRo9OiOwl/ScR8XrwcKPb6GCXAV/hFL
         KvBLEVmARe4ix+bNb1KDLnA9CZ1jCH7TSW5T2d9QvInQ0KGJyZOgMdMRHkLTLy42Sipx
         sPTMvDp+Ft8B07qYtVtvHz2LmN18E6/QQeT5hYe4Z2lq+dm9DGZnNUM3pxlO3JnTCSxK
         SNNasgNlosmdu3DdV7DHXsk5ZVROss6Kg8/HaLyCom61C0/ZOL/KBAnaSh4B9IRyeMdk
         hN6SSWNJDJkI+cyF06aJLwG9EzPGzHYwEeDXNjzxyexuFHQNhOMaEesIACvnfD62tg/2
         qxvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ucFPx9Ax7UaActBSj4s8rx+N1Jq9f5Fxoxrjk3KTC8g=;
        b=OaFaXwezssKiQFgoVMQ9m8iVu6Qnb0Zd0PZfuCHsW4iVX70XYMPNPRrn67db8qTRgp
         kHHkW4OyY/x3lGCFXXygtqXBS1U3VaoOuUkJEeoQWMezsgasXa9uo0g+wU49+eiR92p+
         iNKwAsD3+YBHqjx4B4iogvLPyHd572SPPis7EVUTYiQxs1Eo4C0TTIleVv8C61gbQr3j
         VYzWs8mJg600D+q3/mXVBcCsfLxtDHX6wlouRmcMvCGnGttdwjPVaiy1ahJe9CPQfWEZ
         fGCRD786RZ8JnyAQsDpmecDUtAk7FjBt5J3zdjOyz64F2pBDdLrg/yGHDbvcXZEbg5aO
         pxIA==
X-Gm-Message-State: AOAM531COf5MvGIMOubiOImYsIivuJDYuJBAAcyB6brTJC0HYqyjzjl5
        nKON8n/kphciYmcVEJ5is7/6CZi9P+RF2Q==
X-Google-Smtp-Source: ABdhPJwVb3gBwKMBV/qGR+K9S1wy/qmqnI8/m9Jbjeh+byg+DZi5g2ZG821RH75uaTBWC/AXAhNsQw==
X-Received: by 2002:a63:2a11:: with SMTP id q17mr18786853pgq.394.1643207542821;
        Wed, 26 Jan 2022 06:32:22 -0800 (PST)
Received: from bogon.xiaojukeji.com ([111.201.150.233])
        by smtp.gmail.com with ESMTPSA id n4sm5268501pjf.0.2022.01.26.06.32.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jan 2022 06:32:22 -0800 (PST)
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
Subject: [net-next v8 1/2] net: sched: use queue_mapping to pick tx queue
Date:   Wed, 26 Jan 2022 22:32:05 +0800
Message-Id: <20220126143206.23023-2-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
References: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
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
 include/linux/rtnetlink.h |  1 +
 net/core/dev.c            | 31 +++++++++++++++++++++++++++++--
 net/sched/act_skbedit.c   |  6 +++++-
 4 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e490b84732d1..60e14b2b091d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3015,6 +3015,9 @@ struct softnet_data {
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
index bb9cb84114c1..e87c2dccc4d5 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -100,6 +100,7 @@ void net_dec_ingress_queue(void);
 #ifdef CONFIG_NET_EGRESS
 void net_inc_egress_queue(void);
 void net_dec_egress_queue(void);
+void netdev_xmit_skip_txqueue(bool skip);
 #endif
 
 void rtnetlink_init(void);
diff --git a/net/core/dev.c b/net/core/dev.c
index 1baab07820f6..842473fa8e9f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3860,6 +3860,25 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 
 	return skb;
 }
+
+static struct netdev_queue *
+netdev_tx_queue_mapping(struct net_device *dev, struct sk_buff *skb)
+{
+	int qm = skb_get_queue_mapping(skb);
+
+	return netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, qm));
+}
+
+static bool netdev_xmit_txqueue_skipped(void)
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
@@ -4030,7 +4049,7 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
 static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 {
 	struct net_device *dev = skb->dev;
-	struct netdev_queue *txq;
+	struct netdev_queue *txq = NULL;
 	struct Qdisc *q;
 	int rc = -ENOMEM;
 	bool again = false;
@@ -4058,11 +4077,17 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 			if (!skb)
 				goto out;
 		}
+
+		netdev_xmit_skip_txqueue(false);
+
 		nf_skip_egress(skb, true);
 		skb = sch_handle_egress(skb, &rc, dev);
 		if (!skb)
 			goto out;
 		nf_skip_egress(skb, false);
+
+		if (netdev_xmit_txqueue_skipped())
+			txq = netdev_tx_queue_mapping(dev, skb);
 	}
 #endif
 	/* If device/qdisc don't need skb->dst, release it right now while
@@ -4073,7 +4098,9 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	else
 		skb_dst_force(skb);
 
-	txq = netdev_core_pick_tx(dev, skb, sb_dev);
+	if (likely(!txq))
+		txq = netdev_core_pick_tx(dev, skb, sb_dev);
+
 	q = rcu_dereference_bh(txq->qdisc);
 
 	trace_net_dev_queue(skb);
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index ceba11b198bb..d5799b4fc499 100644
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
-- 
2.27.0

