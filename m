Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425F846F941
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 03:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbhLJCkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 21:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhLJCkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 21:40:32 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41871C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 18:36:58 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id n8so5326120plf.4
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 18:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VjJv16kmpXK9Vx6W/Jxt9RtFrqrsWnhvawZ4ZFN9ong=;
        b=mIIrPaxLloqSScTzkCViqUAVU+aQ6/m2N4kU4p10PqjLJEayofzPF9ErkkpR88CbSF
         fXwq1BDYc6oMSvWVpeVmRZHcwv66dYzQvLZY+sV8GLHxuLlowIWvpVuDDnj8E/W7Uzuu
         CAtuIf9DxQTSTPJavnQWQD8vsk8uuQytl4TjyS4ffAh/gNGRYwL2/pgIxEsaikQwxIC/
         updXYP4lZgYd5b0YKrVcLeDWhk6d5A+XfAPrZLIOdUSBn3lH1TT+vIvFXdXMK4GNi8E0
         R4LLIuavTGI2xlV4FKOgPyUVbGjCx92unFXWQz9xBVhzmtBoZ20o2Qhjga6jqs1xGUTN
         QdfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VjJv16kmpXK9Vx6W/Jxt9RtFrqrsWnhvawZ4ZFN9ong=;
        b=yZ2YJIv8g0f2Q+4yYwf/TV4QcE7u/CCC2ZRZj7kZ1pc/85hjxPuGUkXE04r/cEwSZM
         2AAjSN7n+1vdJ7uwCk+awtKJ31ZYy9rciZtrZEF9rdVPcOVNTWkpVrWZR06kiW+ePtiU
         wWnfw16PHJuTcoKGwAtD+y+cBw1FY79F4jjxQfFp7b4damA4s1YfRN9PuQLYoL4AsKlD
         BW8yI9rCmMvV2YOm8amvrkkoCmvVWj95smnaDQNMg1jhrOS6YIDwcgjKLcU1LRWA4Bkn
         4GmaU9u8KkDo8+tfIvnSdwr8374fDKSfY0dmfhJKpZQqERakDRjhulO2rcpHGmbBrSjj
         rY4g==
X-Gm-Message-State: AOAM532tmGX3OE15aTYaXJP0xDCQ40DEuUw1hHsFyPra5SYvNRzfUPE9
        Oh7IH+sOPjgN4daMvpr2PJMZboOP0/W8EA==
X-Google-Smtp-Source: ABdhPJwboFSBLjR7oSDS+mUazYOv3rubNrlYnyp1WMOE07w6o+a4d/hu7uZUEdAkfnkg0mBlDkO4QQ==
X-Received: by 2002:a17:90b:4b4e:: with SMTP id mi14mr20629640pjb.122.1639103817468;
        Thu, 09 Dec 2021 18:36:57 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.100])
        by smtp.gmail.com with ESMTPSA id g17sm861677pgh.46.2021.12.09.18.36.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Dec 2021 18:36:57 -0800 (PST)
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
Subject: [net-next v3 2/2] net: sched: support hash/classid/cpuid selecting tx queue
Date:   Fri, 10 Dec 2021 10:36:26 +0800
Message-Id: <20211210023626.20905-3-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20211210023626.20905-1-xiangxia.m.yue@gmail.com>
References: <20211210023626.20905-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This patch allows users to select queue_mapping, range
from A to B. And users can use skb-hash, cgroup classid
and cpuid to select Tx queues. Then we can load balance
packets from A to B queue. The range is an unsigned 16bit
value in decimal format.

$ tc filter ... action skbedit queue_mapping hash-type normal A B

"skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit") is
enhanced with flags:
* SKBEDIT_F_QUEUE_MAPPING_HASH
* SKBEDIT_F_QUEUE_MAPPING_CLASSID
* SKBEDIT_F_QUEUE_MAPPING_CPUID

Use skb->hash, cgroup classid, or cpuid to distribute packets.
Then same range of tx queues can be shared for different flows,
cgroups, or CPUs in a variety of scenarios.

For example, flows F1 may share range R1 with flows F2. The best
way to do that is to set flag to SKBEDIT_F_QUEUE_MAPPING_HASH.
If cgroup C1 share the R1 with cgroup C2 .. Cn, use the
SKBEDIT_F_QUEUE_MAPPING_CLASSID. Of course, in some other scenario,
C1 uses R1, while Cn can use Rn.

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
 net/sched/act_skbedit.c                | 74 ++++++++++++++++++++++++--
 3 files changed, 79 insertions(+), 4 deletions(-)

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
index 800e93377218..5642b095d206 100644
--- a/include/uapi/linux/tc_act/tc_skbedit.h
+++ b/include/uapi/linux/tc_act/tc_skbedit.h
@@ -29,6 +29,13 @@
 #define SKBEDIT_F_PTYPE			0x8
 #define SKBEDIT_F_MASK			0x10
 #define SKBEDIT_F_INHERITDSFIELD	0x20
+#define SKBEDIT_F_QUEUE_MAPPING_HASH	0x40
+#define SKBEDIT_F_QUEUE_MAPPING_CLASSID	0x80
+#define SKBEDIT_F_QUEUE_MAPPING_CPUID	0x100
+
+#define SKBEDIT_F_QUEUE_MAPPING_HASH_MASK (SKBEDIT_F_QUEUE_MAPPING_HASH | \
+					   SKBEDIT_F_QUEUE_MAPPING_CLASSID | \
+					   SKBEDIT_F_QUEUE_MAPPING_CPUID)
 
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
index 498feedad70a..0b0d65d7112e 100644
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
@@ -23,6 +24,37 @@
 static unsigned int skbedit_net_id;
 static struct tc_action_ops act_skbedit_ops;
 
+static u16 tcf_skbedit_hash(struct tcf_skbedit_params *params,
+			    struct sk_buff *skb)
+{
+	u16 queue_mapping = params->queue_mapping;
+	u16 mapping_mod = params->mapping_mod;
+	u32 mapping_hash_type = params->flags &
+				SKBEDIT_F_QUEUE_MAPPING_HASH_MASK;
+	u32 hash = 0;
+
+	if (!mapping_hash_type)
+		return netdev_cap_txqueue(skb->dev, queue_mapping);
+
+	switch (mapping_hash_type) {
+	case SKBEDIT_F_QUEUE_MAPPING_CLASSID:
+		hash = jhash_1word(task_get_classid(skb), 0);
+		break;
+	case SKBEDIT_F_QUEUE_MAPPING_HASH:
+		hash = skb_get_hash(skb);
+		break;
+	case SKBEDIT_F_QUEUE_MAPPING_CPUID:
+		hash = raw_smp_processor_id();
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
@@ -57,10 +89,9 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
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
@@ -94,6 +125,7 @@ static const struct nla_policy skbedit_policy[TCA_SKBEDIT_MAX + 1] = {
 	[TCA_SKBEDIT_PTYPE]		= { .len = sizeof(u16) },
 	[TCA_SKBEDIT_MASK]		= { .len = sizeof(u32) },
 	[TCA_SKBEDIT_FLAGS]		= { .len = sizeof(u64) },
+	[TCA_SKBEDIT_QUEUE_MAPPING_MAX]	= { .len = sizeof(u16) },
 };
 
 static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
@@ -110,6 +142,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	struct tcf_skbedit *d;
 	u32 flags = 0, *priority = NULL, *mark = NULL, *mask = NULL;
 	u16 *queue_mapping = NULL, *ptype = NULL;
+	u16 mapping_mod = 0;
 	bool exists = false;
 	int ret = 0, err;
 	u32 index;
@@ -154,7 +187,30 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 
 	if (tb[TCA_SKBEDIT_FLAGS] != NULL) {
 		u64 *pure_flags = nla_data(tb[TCA_SKBEDIT_FLAGS]);
+		u64 mapping_hash_type = *pure_flags &
+					SKBEDIT_F_QUEUE_MAPPING_HASH_MASK;
+		if (mapping_hash_type) {
+			u16 *queue_mapping_max;
+
+			/* Hash types are mutually exclusive. */
+			if (mapping_hash_type & (mapping_hash_type - 1))
+				return -EINVAL;
+
+			if (!tb[TCA_SKBEDIT_QUEUE_MAPPING_MAX])
+				return -EINVAL;
 
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
+			flags |= mapping_hash_type;
+		}
 		if (*pure_flags & SKBEDIT_F_INHERITDSFIELD)
 			flags |= SKBEDIT_F_INHERITDSFIELD;
 	}
@@ -206,8 +262,10 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
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
@@ -274,6 +332,14 @@ static int tcf_skbedit_dump(struct sk_buff *skb, struct tc_action *a,
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

