Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDF4469127
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 09:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238871AbhLFII4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 03:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238716AbhLFIIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 03:08:55 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50B0C0613F8
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 00:05:27 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b13so6557849plg.2
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 00:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K14zWgtsUTCQfzykwYkpCG3ItSI3waYsU5ZRB/ODMgQ=;
        b=oQPyrsTFUZKvegBtLMDHknvB7ma5W2CbTN59/3Z/WKc33prGCTWhBS14ZCtdDo+zqq
         cgmDsc2GvmOFSnhJFwO4nNnJVTNXBMdFHLakRbVL4fUZMA2sRXQkfxFb/YBV5c9JP6CG
         bXy46+piZQfdR2hBZzmgEa5VckE8oAz8ok3bQVrCK7sXm9CVJVUJf2b8wlyDeXz+cQ31
         bSz28FuS3oJdTZGEwoAv2ISpKfYCEJeaHtOqWLUr/n8yZqqfLhHwOkQwWoLHZVIdNQQv
         /TZ9rd7dNFUEH0iP4X/Cme150DYrKOICuLKic+P8W5nGQyiTJ1Pv9Bem2bLo9cK4hINF
         S+4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K14zWgtsUTCQfzykwYkpCG3ItSI3waYsU5ZRB/ODMgQ=;
        b=YOMbURYMvkM2y0jqFGskXb/p6udxRYuahi3PykGrIihER/Jxf/Tw4vJO2UB57OOjBv
         l4g6ZsA0rfb/26qlB49k3l3agtWPSIyYaHlYXSIjZiT1DnP7HQ3AxsBP+nA8UM2Z57N4
         Lsf4olYyvFQmRByvgs95dXx5TddL8TTeRXMuXSgOu78ze+UVmu1qFqVBMOYapC10hOVt
         8E2EVU2Fo3PrRZiJk6AFoVdN7VTz4m96EcPr34GLGfdC1kUIb21Uu8sJmiDepnntH/vB
         xwjLDtVv+TjLi6R5crcauNZHHvIw/PkQ93HMp8zA4nEHptlD7JYbAe6QIsPU64AeqdsU
         01Kg==
X-Gm-Message-State: AOAM530DGbaMIXU1zb/DSTRdibdGxoozN/NuiAhGUzC7/SRLTHH4fNEy
        DP9rVgkBfooktrUJljJLvH9snYwsC5WKYw==
X-Google-Smtp-Source: ABdhPJxhNryhiWOgHQ16sJqYsiM+Ary4RdkFqz2rJ90Kg+e8t+46KkskkUaZ3/krH01Tc1ik9zscvw==
X-Received: by 2002:a17:90b:3b4c:: with SMTP id ot12mr35758763pjb.196.1638777926878;
        Mon, 06 Dec 2021 00:05:26 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id e15sm11148798pfv.131.2021.12.06.00.05.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Dec 2021 00:05:26 -0800 (PST)
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
Subject: [net-next v1 1/2] net: sched: use queue_mapping to pick tx queue
Date:   Mon,  6 Dec 2021 16:05:11 +0800
Message-Id: <20211206080512.36610-2-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20211206080512.36610-1-xiangxia.m.yue@gmail.com>
References: <20211206080512.36610-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This patch fix issue:
* If we install tc filters with act_skbedit in clsact hook.
  It doesn't work, because *netdev_core_pick_tx will overwrite
  queue_mapping.

  $ tc filter add dev $NETDEV egress .. action skbedit queue_mapping 1

And this patch is useful:
* In containter networking environment, one kind of pod/containter/
  net-namespace (e.g. P1, P2) which outbound traffic limited, can
  use one specific tx queue which used HTB/TBF Qdisc. But other kind
  of pods (e.g. Pn) can use other specific tx queue too, which used fifio
  Qdisc. Then the lock contention of HTB/TBF Qdisc will not affect Pn.

  +----+      +----+      +----+
  | P1 |      | P2 |      | Pn |
  +----+      +----+      +----+
    |           |           |
    +-----------+-----------+
                |
                | clsact/skbedit
                |    MQ
                v
    +-----------+-----------+
    | q0        | q1        | qn
    v           v           v
   HTB         HTB   ...   FIFO

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
 include/linux/skbuff.h  |  1 +
 net/core/dev.c          | 12 +++++++++---
 net/sched/act_skbedit.c |  4 +++-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index eae4bd3237a4..b6ea4b920409 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -856,6 +856,7 @@ struct sk_buff {
 #endif
 #ifdef CONFIG_NET_CLS_ACT
 	__u8			tc_skip_classify:1;
+	__u8			tc_skip_txqueue:1;
 	__u8			tc_at_ingress:1;
 #endif
 	__u8			redirected:1;
diff --git a/net/core/dev.c b/net/core/dev.c
index aba8acc1238c..fb9d4eee29ee 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3975,10 +3975,16 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
 {
 	int queue_index = 0;
 
-#ifdef CONFIG_XPS
-	u32 sender_cpu = skb->sender_cpu - 1;
+#ifdef CONFIG_NET_CLS_ACT
+	if (skb->tc_skip_txqueue) {
+		queue_index = netdev_cap_txqueue(dev,
+						 skb_get_queue_mapping(skb));
+		return netdev_get_tx_queue(dev, queue_index);
+	}
+#endif
 
-	if (sender_cpu >= (u32)NR_CPUS)
+#ifdef CONFIG_XPS
+	if ((skb->sender_cpu - 1) >= (u32)NR_CPUS)
 		skb->sender_cpu = raw_smp_processor_id() + 1;
 #endif
 
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index d30ecbfc8f84..940091a7c7f0 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -58,8 +58,10 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 		}
 	}
 	if (params->flags & SKBEDIT_F_QUEUE_MAPPING &&
-	    skb->dev->real_num_tx_queues > params->queue_mapping)
+	    skb->dev->real_num_tx_queues > params->queue_mapping) {
+		skb->tc_skip_txqueue = 1;
 		skb_set_queue_mapping(skb, params->queue_mapping);
+	}
 	if (params->flags & SKBEDIT_F_MARK) {
 		skb->mark &= ~params->mask;
 		skb->mark |= params->mark & params->mask;
-- 
2.27.0

