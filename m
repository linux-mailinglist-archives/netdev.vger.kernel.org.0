Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BACC4D8688
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 15:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238512AbiCNORP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 10:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbiCNORO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 10:17:14 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090AC19C14
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 07:16:03 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id bx5so14817968pjb.3
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 07:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HcZ/kcreBBehz7oP7xE6Zw241qWsU3n7BPADIS3EB2g=;
        b=OSYWnEIBdq/uYJ8MJCXlUca8BcaYGByVe0WBar3cg3+rDK2BePv3yrw7RghF5YxMTG
         rkkKciGQwAQVpQTCLyI5WvsHW5fEwpRNgMXRZZm7W9mGXqsPPy0HQ8Ye389oVkHlujr+
         09fjS1Sxco7Q5fDf45TRoWar+nA1HzUbLbApAIyxrd7Oo9Dgge/DCqnIvB4xguQtVS5V
         BASJELx6wWQYJJzhSmZHTLSy0lZR1Zc+Q0XgXEROVy7D9KivMk0fKgf+YZuIcUAxeid1
         vaUUVOZ/k3VWcbqQLKiRCIOPzedNk38lps/VdBzl2dKejFz7djiQ/60INbOxMoxRcda4
         0Ocg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HcZ/kcreBBehz7oP7xE6Zw241qWsU3n7BPADIS3EB2g=;
        b=ZqTEk5FSYk5K5S0z54q+GhhfxkPt9bK0D8LubBgzUjCOW4LEspmmOTcJQuQaYthlH4
         4pvghXsJFnE/T3lznL4CfeeZ0OmEVZq3Xs8CMDI4HXMSCX6Vwimdy4Sz7ARVgwHAG8gj
         PVkrILNFV0EDDlVO7XaaPx3TTmQhF/iQWPlOFVmkUzbb3NI0PDYOAvubknqLHcZcUte4
         nKRgVE37LGxABdxXJDDxZhyqyaNV10wngd48F5IsIh59PJEF1zcFyuSeqimeTTUEwSum
         U1rPZyl7xxnWVZuAjCqJgDeKF+Jlxf/zn37kHlGvPRwP7x6SL3dGQbaCoBgvOKgJQFa3
         6fuQ==
X-Gm-Message-State: AOAM531IedAbL7KBolL6CaAzSmSGyN5J6dl8rabF9jsHgG4ySw1KZjIK
        eN3JZXKp/K4GzC8z+0cx6Qo7R7kVlUIKjQ==
X-Google-Smtp-Source: ABdhPJzm5hYDuRWcX8GIeBPsWFBHB5+oBpiMqwfJvhE30X306nCrLeOA2seMkCoQV8wdKdwApH9cHA==
X-Received: by 2002:a17:902:74c4:b0:153:37a8:7171 with SMTP id f4-20020a17090274c400b0015337a87171mr15896962plt.143.1647267361489;
        Mon, 14 Mar 2022 07:16:01 -0700 (PDT)
Received: from localhost.localdomain ([111.201.151.228])
        by smtp.gmail.com with ESMTPSA id oa12-20020a17090b1bcc00b001bf430c3909sm22540430pjb.32.2022.03.14.07.15.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Mar 2022 07:16:00 -0700 (PDT)
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
Subject: [net-next v10 1/2] net: sched: use queue_mapping to pick tx queue
Date:   Mon, 14 Mar 2022 22:15:07 +0800
Message-Id: <20220314141508.39952-2-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220314141508.39952-1-xiangxia.m.yue@gmail.com>
References: <20220314141508.39952-1-xiangxia.m.yue@gmail.com>
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
index 0d994710b335..f33fb2d6712a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3065,6 +3065,9 @@ struct softnet_data {
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
index 7f970b16da3a..ae2c6a3cec5d 100644
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
index 75bab5b0dbae..8e83b7099977 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3908,6 +3908,25 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 
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
@@ -4078,7 +4097,7 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
 static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 {
 	struct net_device *dev = skb->dev;
-	struct netdev_queue *txq;
+	struct netdev_queue *txq = NULL;
 	struct Qdisc *q;
 	int rc = -ENOMEM;
 	bool again = false;
@@ -4106,11 +4125,17 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
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
@@ -4121,7 +4146,9 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
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

