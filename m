Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14154785D2
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 09:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhLQIB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 03:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhLQIB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 03:01:26 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06771C061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 00:01:26 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id f20so1826309qtb.4
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 00:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0+fa/Qes62ldoHzD8jbUJVgVb9sxBiYU0T848Q/BfPU=;
        b=mcEiso4F8MRM9STIerXMhq8LqjTG/OLEWwmzMcaqbYXQecgO0pfyQzEOApzMMxn0JG
         Yw2sKsEs91csWVxXp8qZoNDxMrteBQWKPUjLo4rHRq3LI4nz5lQaX9+V4LNaN8yGiDXB
         Iis+wT3B+RkuErXS70Ks8Tos9St4KiE18A6BKQHl9aXC6nj2R4xqILIt8WDLoVF1WdqB
         cay59T/UX4U0TBow15K6N/Z8Nf36I0+JsK4t3bpNth6wWEiJuyTJsIzoo8cjvD62iPXj
         whoxVtZ6NJlL0x1MXcwwCSRzdtMaTxZflMRrwePxt/SfJPe92CXFYijPH9kZ2XyZdGBx
         qvig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0+fa/Qes62ldoHzD8jbUJVgVb9sxBiYU0T848Q/BfPU=;
        b=3+wxqlGDA48cHfiNseGeA4LAMIJC6CRo+QVG4+OfA5N8Xm1t0xYtd3aVhUFI+Eb9Ux
         7v+NcIIT7NS61moAkiIRX7+yni7J7mTAavbTVY1G9KdELBS5a7o+Fpqxp8oO94x/enSx
         kwlaFJOlstGmOvvvSHAc82mTUjQqIqu0H3BgAd3b13CGb2qYMvxCVMUPS+mxWLw+dk+X
         AG3gGT506XZyj0XM8zsxS7JqKuIplr5PVAmPu7/2foD+EHtDgefQw7I/TarfDTSSSrOJ
         VfO1OGeeXTZfbX5lwS/6bSTyn+Qca6wv57mrVd2n1grz8m7gsdUYxuh+V5ImlbrcYoA7
         YTdw==
X-Gm-Message-State: AOAM530XA3Eju701/fle69ZDTC+Zs7umoCmdZ3XkO0Z3ZyN3+oQBX2Ep
        jAF4UOxkddJLXW019vp64g+9JvjcsoxsXg==
X-Google-Smtp-Source: ABdhPJzT9BRcoD4U4F/33hmT33fl+1ele2lkB7lhiovus8M+rWDq8WtEVjb1AeozleyonfkMAntPcw==
X-Received: by 2002:ac8:5794:: with SMTP id v20mr1394536qta.60.1639728084456;
        Fri, 17 Dec 2021 00:01:24 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id bk25sm4239922qkb.13.2021.12.17.00.01.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Dec 2021 00:01:24 -0800 (PST)
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
Subject: [net-next v4 1/2] net: sched: use queue_mapping to pick tx queue
Date:   Fri, 17 Dec 2021 16:01:02 +0800
Message-Id: <20211217080103.35454-2-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20211217080103.35454-1-xiangxia.m.yue@gmail.com>
References: <20211217080103.35454-1-xiangxia.m.yue@gmail.com>
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
 include/linux/netdevice.h | 24 ++++++++++++++++++++++++
 net/core/dev.c            |  7 ++++++-
 net/sched/act_skbedit.c   |  4 +++-
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a419718612c6..ca1d17b5fd79 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3008,6 +3008,7 @@ struct softnet_data {
 	/* written and read only by owning cpu: */
 	struct {
 		u16 recursion;
+		u8  skip_txqueue;
 		u8  more;
 	} xmit;
 #ifdef CONFIG_RPS
@@ -4695,6 +4696,29 @@ static inline netdev_tx_t netdev_start_xmit(struct sk_buff *skb, struct net_devi
 	return rc;
 }
 
+static inline void netdev_xmit_skip_txqueue(void)
+{
+	__this_cpu_write(softnet_data.xmit.skip_txqueue, 1);
+}
+
+static inline void netdev_xmit_reset_txqueue(void)
+{
+	__this_cpu_write(softnet_data.xmit.skip_txqueue, 0);
+}
+
+static inline bool netdev_xmit_txqueue_skipped(void)
+{
+	return __this_cpu_read(softnet_data.xmit.skip_txqueue);
+}
+
+static inline struct netdev_queue *
+netdev_tx_queue_mapping(struct net_device *dev, struct sk_buff *skb)
+{
+       int qm = skb_get_queue_mapping(skb);
+
+       return netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, qm));
+}
+
 int netdev_class_create_file_ns(const struct class_attribute *class_attr,
 				const void *ns);
 void netdev_class_remove_file_ns(const struct class_attribute *class_attr,
diff --git a/net/core/dev.c b/net/core/dev.c
index a855e41bbe39..980f9981dbaa 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4048,6 +4048,7 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	skb_update_prio(skb);
 
 	qdisc_pkt_len_init(skb);
+	netdev_xmit_reset_txqueue();
 #ifdef CONFIG_NET_CLS_ACT
 	skb->tc_at_ingress = 0;
 #endif
@@ -4073,7 +4074,11 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	else
 		skb_dst_force(skb);
 
-	txq = netdev_core_pick_tx(dev, skb, sb_dev);
+	if (netdev_xmit_txqueue_skipped())
+		txq = netdev_tx_queue_mapping(dev, skb);
+	else
+		txq = netdev_core_pick_tx(dev, skb, sb_dev);
+
 	q = rcu_dereference_bh(txq->qdisc);
 
 	trace_net_dev_queue(skb);
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index d30ecbfc8f84..498feedad70a 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -58,8 +58,10 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 		}
 	}
 	if (params->flags & SKBEDIT_F_QUEUE_MAPPING &&
-	    skb->dev->real_num_tx_queues > params->queue_mapping)
+	    skb->dev->real_num_tx_queues > params->queue_mapping) {
+		netdev_xmit_skip_txqueue();
 		skb_set_queue_mapping(skb, params->queue_mapping);
+	}
 	if (params->flags & SKBEDIT_F_MARK) {
 		skb->mark &= ~params->mask;
 		skb->mark |= params->mark & params->mask;
-- 
2.27.0

