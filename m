Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA1946F940
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 03:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhLJCk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 21:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhLJCk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 21:40:26 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D238FC061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 18:36:52 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so8392470pjb.5
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 18:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TW88ZYfqECxihaZG2wRwSDQZ3RpnTkkuxVf5gea+Zq0=;
        b=ob4fS1RGK5CaoJFyax+0V+afb6kZHJtCmk03B6Tz1RDyticG8NFDE3tSv8dcURdFzS
         iBbNxLnYTCWqC24WIG/foCpJlEDxUi6x+aVsO/18kTRx5wHbyBD5zmf4R0mHlvlhaegB
         GUqcF0bnHg4XC6HW9ahTxRiewyB4+euxkC8i2AG1xtUO89vIoH3xiG7+w98z4RvjmjqI
         2eCkmNpgEF1b1bL6D05gSmX0+lff6PhDFdiZxVRXk1C0w6Nm3hl3H7QgpE5uhdfOlEmV
         XQ1tjaZ13N1iDhKAM+kgbhhItnCwNENl+8W/6r6KsDitw81GwbBm0qJsJvzQ/o5bOesX
         6RdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TW88ZYfqECxihaZG2wRwSDQZ3RpnTkkuxVf5gea+Zq0=;
        b=QJFDvI/3UQmZhUEx+413DqDYGztea8UyL3KJq1ocU6780CT3Spev+kYnIwid9W3tGk
         d0Ce84wi6atIkHcpBp4ZZWCxoZ04aQ8oxmPJAuZOcr6lhB4DqDJFGTRBzDoNURvBrFaK
         8+FUxgxFo90ENZN/JvkbPAfVW2bWQhfaPUCHVCTlHUxEIAnCL6Vl52lA8P+TUYRMvf/d
         LqzHaCuD2X/u255gXKWWl1vyWMCdz1c4QVYqkDRaWGxqq5qKJDLwxDNWgStMNnviW000
         +WxwDr0Uq2NSvxRmspp37o60Ngn2JADUBxK5FYG0Auo9G6Lb8aajq0dt7pcN4YgaInpa
         KjQg==
X-Gm-Message-State: AOAM5319h0qp6iDbjxt1X4ea7poU8KMEFjhkVoYYXn9iz47ZlnoAQWrG
        +S7sI/flvA2hk3MU0M8VXDfEYZBMlTCS2Q==
X-Google-Smtp-Source: ABdhPJw4z9AFMdjBtRNggWbECeJLaNHQhcGG6BI5lnTb1uH7QO2pEo9+wyeSbx+RwzaPhxFBFsvwDw==
X-Received: by 2002:a17:90a:be0c:: with SMTP id a12mr20818313pjs.204.1639103812013;
        Thu, 09 Dec 2021 18:36:52 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.100])
        by smtp.gmail.com with ESMTPSA id g17sm861677pgh.46.2021.12.09.18.36.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Dec 2021 18:36:51 -0800 (PST)
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
Subject: [net-next v3 1/2] net: sched: use queue_mapping to pick tx queue
Date:   Fri, 10 Dec 2021 10:36:25 +0800
Message-Id: <20211210023626.20905-2-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20211210023626.20905-1-xiangxia.m.yue@gmail.com>
References: <20211210023626.20905-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This patch fix issue:
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

  The skip txqueue flag will be cleared to avoid picking Tx queue in
  next netdev, for example (not usual case):

  eth0 (macvlan in Pod, skbedit queue_mapping) -> eth0.3 (vlan in Host)
  -> eth0 (ixgbe in Host).

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
 include/linux/netdevice.h | 21 +++++++++++++++++++++
 net/core/dev.c            |  6 +++++-
 net/sched/act_skbedit.c   |  4 +++-
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 65117f01d5f2..64f12a819246 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2997,6 +2997,7 @@ struct softnet_data {
 	/* written and read only by owning cpu: */
 	struct {
 		u16 recursion;
+		u8  skip_txqueue;
 		u8  more;
 	} xmit;
 #ifdef CONFIG_RPS
@@ -4633,6 +4634,26 @@ static inline netdev_tx_t netdev_start_xmit(struct sk_buff *skb, struct net_devi
 	return rc;
 }
 
+static inline void netdev_xmit_skip_txqueue(void)
+{
+	__this_cpu_write(softnet_data.xmit.skip_txqueue, 1);
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
+       /* Take effect only on current netdev. */
+       __this_cpu_write(softnet_data.xmit.skip_txqueue, 0);
+       return netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, qm));
+}
+
 int netdev_class_create_file_ns(const struct class_attribute *class_attr,
 				const void *ns);
 void netdev_class_remove_file_ns(const struct class_attribute *class_attr,
diff --git a/net/core/dev.c b/net/core/dev.c
index aba8acc1238c..a64297a4cc89 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4069,7 +4069,11 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
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

