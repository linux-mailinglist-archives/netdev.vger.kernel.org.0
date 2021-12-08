Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6C946D5CA
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbhLHOiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235224AbhLHOiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:38:10 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3627EC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 06:34:39 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id b13so1660682plg.2
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 06:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TW88ZYfqECxihaZG2wRwSDQZ3RpnTkkuxVf5gea+Zq0=;
        b=JdD08A/EkT3d3ScvGtQ5OTJKWlTTo6dsZiylWvxRe0yih3yKjVKky4gaa2aKf38f5I
         SwoxX8zSius69F/OIRyHbMQNCZXWN9pC/FPXKeg7GYVoilyiI1Q1kIAvkzTYB9UXIqNk
         eGvEAm/9VHlM1Ui99/FzNHss7TjYhkVXhUD4HHAgsxhOuU5JtUu+Us6x4LmJFWG98PF2
         zQfVLGCHe38AQXs0hhLabXW0dvcYuE/KQ5maJBdynkOF1PMR39OsYikdtlN4TJQkuTks
         d+QJrnKQeGNekYb0eVRgjTWtEulCokoFHMS7vFxJ65F2GFuzIsmFmXgXplnlTasmCkX2
         V34Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TW88ZYfqECxihaZG2wRwSDQZ3RpnTkkuxVf5gea+Zq0=;
        b=PdKYLFQPA0sHh6F5K/TgLdalybsxMtExJeFQllUdUTjUAYrBmc9b+KnT1zJbVbUpg4
         UeX8OH1qx6yi+ibIZabd/UTJrnjuoY1NUjz00tNwGPRP7tSZjCjaPxX5shgdVw69h2YR
         cn87Ctq9YEKP90V0a4PvMQ4yWC5a/n1JjcMWcEeavBwf0f+J4GC/3/EmyXHy5C/SIiRt
         BWCQ90Z1yXGHXVHaXLKRZ16roXkI5fpKBkhAmNUFU6WqD0Pu4ONhNsCJ26FzRd1Qf42q
         tcYuqORA+CemzsVIjqxHPwvhLyMxwfVVpnPOggetiT/zNRJopUSEWxDp22rylflG7wc/
         w/Ww==
X-Gm-Message-State: AOAM531Iwh4ZDZwkxihpmb1dhLHI40X97m8SMwZW7E6IMoDa8v74alUz
        pW6iWTrzflNVvK56ZxjxQ2qlETBiz7oO3Q==
X-Google-Smtp-Source: ABdhPJz+0GPnj06vW+NraTqHvP5rKl4Adw18dlzK79TMH9ir2zK4ogn4Pz5Hpkh+7+cJLmpE+Zo8Eg==
X-Received: by 2002:a17:902:d114:b0:142:3934:be82 with SMTP id w20-20020a170902d11400b001423934be82mr59090465plw.40.1638974078097;
        Wed, 08 Dec 2021 06:34:38 -0800 (PST)
Received: from bogon.localdomain ([111.201.150.233])
        by smtp.gmail.com with ESMTPSA id g18sm4160123pfj.142.2021.12.08.06.34.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Dec 2021 06:34:37 -0800 (PST)
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
Subject: [net-next v2 1/2] net: sched: use queue_mapping to pick tx queue
Date:   Wed,  8 Dec 2021 22:34:07 +0800
Message-Id: <20211208143408.7047-2-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20211208143408.7047-1-xiangxia.m.yue@gmail.com>
References: <20211208143408.7047-1-xiangxia.m.yue@gmail.com>
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

