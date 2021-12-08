Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852EF46D5CD
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbhLHOiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235224AbhLHOiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:38:15 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D70C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 06:34:43 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id q16so2196624pgq.10
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 06:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ygs2akJt0yCgsHrsTHXTQ2RCbRNgVPOo61Ey1APENp4=;
        b=anAPjjswd7RwCD6J3r4/OBcXp64bQYpls3D2tfy55vJr2HgN+fSRDItM+PD8MQLhYr
         aBxNMq9iib/Pebf3i3T8tCXBs8QZIufTOgnj9+g9mAfeqIODG2zUGfb8kD30EbfZIhuH
         bs7YU3OAz5ag6ae/jJHsWS6dsi3l1HH/iIfNLUZRWu13g+EpJtHo96nnXXNBkyMN5pib
         DSjLw+i+AsscLQA02kpEKUwGJbetSkwjyHUx9amnmUBNTbUplaA5KtjUbZ1wB6A9km0y
         NdpAqs2iHjUzKfhothZJAOg4lRqpmKtuIMGbbn931HaUipKcvGu/eUm5L5D+ZFRXLoKL
         hiFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ygs2akJt0yCgsHrsTHXTQ2RCbRNgVPOo61Ey1APENp4=;
        b=ATwuFvws0dX4hZ62BEs8tW0N+FyY/9wO8mQtOXRNJVU7pYj2W/JbEc1Cd3AGrjJNSY
         OIiJ/M4iYnX4pGAjQ3cX2k8WzDMNc18Rtqas27txNDEGXo6JCrxmcDxUdmM0IBcER+ne
         SJiszRM0snroUs266aVKvUwl21v55bQmSs457cqCSkQ1RN4v6mteMV1lN5At1QzhI/ev
         w2YZ6IIXiqx8/KegmO2c34aU988qeLNKbZrWWK9MV+6KY9XtJd8ozspoEk7WZGwrMeic
         Qy6ynoInMGOmfu2wVWdEUfmUMrglPAVBiwqyGujrsvSnMuqeWlN1jM6v6R3Bl1z1SYm+
         NQ6A==
X-Gm-Message-State: AOAM533jMaulnbnvYDucBxWrgS/zvLbn6zbjonCGLnPtfhbONn1v5W+7
        GEy3O4mBiGll5zLGu9TK3Sza6zFxxZ6rqg==
X-Google-Smtp-Source: ABdhPJxcMNbJrtTuZzZ5WMe6+hNY0McqpvTQ9VbUyx4JTNSQS/As7DoVphxEWAE2DvUm0FPiHX+tYw==
X-Received: by 2002:a63:bf4a:: with SMTP id i10mr28863021pgo.196.1638974082999;
        Wed, 08 Dec 2021 06:34:42 -0800 (PST)
Received: from bogon.localdomain ([111.201.150.233])
        by smtp.gmail.com with ESMTPSA id g18sm4160123pfj.142.2021.12.08.06.34.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Dec 2021 06:34:42 -0800 (PST)
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
Subject: [net-next v2 2/2] net: sched: support hash/classid selecting tx queue
Date:   Wed,  8 Dec 2021 22:34:08 +0800
Message-Id: <20211208143408.7047-3-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20211208143408.7047-1-xiangxia.m.yue@gmail.com>
References: <20211208143408.7047-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This patch allows users to select queue_mapping, range
from A to B. And users can use skb-hash or cgroup classid
to select Tx queues. Then the packets can load balance from
A to B queue.

$ tc filter ... action skbedit queue_mapping hash-type normal 0 4

"skbedit queue_mapping QUEUE_MAPPING" [0] is enhanced with two
flags: SKBEDIT_F_QUEUE_MAPPING_HASH, SKBEDIT_F_QUEUE_MAPPING_CLASSID.
The range is an unsigned 16bit value in decimal format.

[0]: https://man7.org/linux/man-pages/man8/tc-skbedit.8.html

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
 include/uapi/linux/tc_act/tc_skbedit.h |  6 +++
 net/sched/act_skbedit.c                | 58 ++++++++++++++++++++++++--
 3 files changed, 61 insertions(+), 4 deletions(-)

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
index 800e93377218..8df288078dde 100644
--- a/include/uapi/linux/tc_act/tc_skbedit.h
+++ b/include/uapi/linux/tc_act/tc_skbedit.h
@@ -29,6 +29,11 @@
 #define SKBEDIT_F_PTYPE			0x8
 #define SKBEDIT_F_MASK			0x10
 #define SKBEDIT_F_INHERITDSFIELD	0x20
+#define SKBEDIT_F_QUEUE_MAPPING_HASH	0x40
+#define SKBEDIT_F_QUEUE_MAPPING_CLASSID	0x80
+
+#define SKBEDIT_F_QUEUE_MAPPING_HASH_MASK (SKBEDIT_F_QUEUE_MAPPING_HASH | \
+					   SKBEDIT_F_QUEUE_MAPPING_CLASSID)
 
 struct tc_skbedit {
 	tc_gen;
@@ -45,6 +50,7 @@ enum {
 	TCA_SKBEDIT_PTYPE,
 	TCA_SKBEDIT_MASK,
 	TCA_SKBEDIT_FLAGS,
+	TCA_SKBEDIT_QUEUE_MAPPING_MAX,
 	__TCA_SKBEDIT_MAX
 };
 #define TCA_SKBEDIT_MAX (__TCA_SKBEDIT_MAX - 1)
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 498feedad70a..355b43999a4a 100644
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
@@ -23,6 +24,25 @@
 static unsigned int skbedit_net_id;
 static struct tc_action_ops act_skbedit_ops;
 
+static u16 tcf_skbedit_hash(struct tcf_skbedit_params *params,
+			    struct sk_buff *skb)
+{
+	u16 queue_mapping = params->queue_mapping;
+	u16 mapping_mod = params->mapping_mod;
+	u32 hash;
+
+	if (!(params->flags & SKBEDIT_F_QUEUE_MAPPING_HASH_MASK))
+		return netdev_cap_txqueue(skb->dev, queue_mapping);
+
+	if (params->flags & SKBEDIT_F_QUEUE_MAPPING_CLASSID)
+		hash = jhash_1word(task_get_classid(skb), 0);
+	else if (params->flags & SKBEDIT_F_QUEUE_MAPPING_HASH)
+		hash = skb_get_hash(skb);
+
+	queue_mapping = queue_mapping + hash % mapping_mod;
+	return netdev_cap_txqueue(skb->dev, queue_mapping);
+}
+
 static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 			   struct tcf_result *res)
 {
@@ -57,10 +77,9 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 			break;
 		}
 	}
-	if (params->flags & SKBEDIT_F_QUEUE_MAPPING &&
-	    skb->dev->real_num_tx_queues > params->queue_mapping) {
+	if (params->flags & SKBEDIT_F_QUEUE_MAPPING) {
 		netdev_xmit_skip_txqueue();
-		skb_set_queue_mapping(skb, params->queue_mapping);
+		skb_set_queue_mapping(skb, tcf_skbedit_hash(params, skb));
 	}
 	if (params->flags & SKBEDIT_F_MARK) {
 		skb->mark &= ~params->mask;
@@ -94,6 +113,7 @@ static const struct nla_policy skbedit_policy[TCA_SKBEDIT_MAX + 1] = {
 	[TCA_SKBEDIT_PTYPE]		= { .len = sizeof(u16) },
 	[TCA_SKBEDIT_MASK]		= { .len = sizeof(u32) },
 	[TCA_SKBEDIT_FLAGS]		= { .len = sizeof(u64) },
+	[TCA_SKBEDIT_QUEUE_MAPPING_MAX]	= { .len = sizeof(u16) },
 };
 
 static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
@@ -110,6 +130,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	struct tcf_skbedit *d;
 	u32 flags = 0, *priority = NULL, *mark = NULL, *mask = NULL;
 	u16 *queue_mapping = NULL, *ptype = NULL;
+	u16 mapping_mod = 0;
 	bool exists = false;
 	int ret = 0, err;
 	u32 index;
@@ -157,6 +178,25 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 
 		if (*pure_flags & SKBEDIT_F_INHERITDSFIELD)
 			flags |= SKBEDIT_F_INHERITDSFIELD;
+		if (*pure_flags & SKBEDIT_F_QUEUE_MAPPING_HASH_MASK) {
+			u16 *queue_mapping_max;
+
+			if (!tb[TCA_SKBEDIT_QUEUE_MAPPING_MAX])
+				return -EINVAL;
+
+			if (!tb[TCA_SKBEDIT_QUEUE_MAPPING])
+				return -EINVAL;
+
+			queue_mapping_max =
+				nla_data(tb[TCA_SKBEDIT_QUEUE_MAPPING_MAX]);
+
+			if (*queue_mapping_max < *queue_mapping)
+				return -EINVAL;
+
+			mapping_mod = *queue_mapping_max - *queue_mapping + 1;
+			flags |= *pure_flags &
+				 SKBEDIT_F_QUEUE_MAPPING_HASH_MASK;
+		}
 	}
 
 	parm = nla_data(tb[TCA_SKBEDIT_PARMS]);
@@ -206,8 +246,10 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
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
@@ -274,6 +316,14 @@ static int tcf_skbedit_dump(struct sk_buff *skb, struct tc_action *a,
 		goto nla_put_failure;
 	if (params->flags & SKBEDIT_F_INHERITDSFIELD)
 		pure_flags |= SKBEDIT_F_INHERITDSFIELD;
+	if (params->flags & SKBEDIT_F_QUEUE_MAPPING_HASH_MASK) {
+		if (nla_put_u16(skb, TCA_SKBEDIT_QUEUE_MAPPING_MAX,
+				params->queue_mapping + params->mapping_mod - 1))
+			goto nla_put_failure;
+
+		pure_flags |= params->flags &
+			      SKBEDIT_F_QUEUE_MAPPING_HASH_MASK;
+	}
 	if (pure_flags != 0 &&
 	    nla_put(skb, TCA_SKBEDIT_FLAGS, sizeof(pure_flags), &pure_flags))
 		goto nla_put_failure;
-- 
2.27.0

