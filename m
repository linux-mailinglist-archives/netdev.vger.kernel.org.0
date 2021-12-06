Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6947B469128
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 09:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238883AbhLFIJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 03:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238716AbhLFIJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 03:09:00 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F82C0613F8
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 00:05:32 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id y8so6561068plg.1
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 00:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JdvpH7hqZ8LDXKkoiDH/2JwIH8yu9+WV/0GhoP2/m0M=;
        b=KkBrPmZrbqPLsp4nTspt8feNGOQbwbcExZhaisyeXsbgGtUsF798jdNIOBjw73v6ld
         BfhdUSJ56+NOOdh/aakpmxVJiAUhwCO9dEzTCt9V69RTfREIQGPpiv5GwhU+NV5m4AEz
         /ZCJBaPyOWVDI5XP2gWxnJGFPGQQOypiqEyjQGWXlKbhpe7gcOQYdYYUjgPa4ZHEOnG0
         O3AHFHuKflXhC58VVITPJ1O/OMYeXZTbRMPlMSegt0S1lMm/+5E1RyBhIkbuY/ksNZ8t
         0jzBfMpu6rO+TQzrm+l0iqitoZRNBkHjrpMAF5rYKUIcPGGETK4+JvTFHYT56QQaG5J+
         Gu1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JdvpH7hqZ8LDXKkoiDH/2JwIH8yu9+WV/0GhoP2/m0M=;
        b=WOdNC5AzzBuQRauIXxtVfrvk0oPJz4Jo89oRvPMqN0IGhM0A3GO8dysy20OXyjGagW
         FnjlCw5DPxVbPRZfoPl9AhNLLxake+1CVWXx4mtH+/jQ7qVkz4PIxNKU1I3Cs7J2hILa
         kQD7ozhIe09AF2MR/Qz4Sg3vS5Yxcr3KTLN+LSfRDaKxkcIXK6HroKOb2UEtjTFeqD3U
         yf8NCHp07eZ2+z+ozutYEy4WZIeeEa0FEzu4yqrl9E9wNqonfbCUFVckvkKSTekIA4s+
         RuJnP22gz2mw3rEDyPug5TcFbIK8L+MKhgDNVkunENt6vxiBgBI7iahUZP4LZzKDUotY
         ZRsQ==
X-Gm-Message-State: AOAM531wgOx1XlU4Lxfo1Gr0kEA/mVdR25tkds3v/dKGpGGdKCtKzrAZ
        dY7QnhwRodUqHjc5qMkBqT75TqRiSY/8+Q==
X-Google-Smtp-Source: ABdhPJze6b8WIE6l6wAwNpW8Ii6uylYKntV8ozibFReagH2Yu5PAVSStDW6j6nWhp5G3tgkbDMbkWQ==
X-Received: by 2002:a17:90a:8049:: with SMTP id e9mr35181752pjw.229.1638777931690;
        Mon, 06 Dec 2021 00:05:31 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id e15sm11148798pfv.131.2021.12.06.00.05.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Dec 2021 00:05:31 -0800 (PST)
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
Subject: [net-next v1 2/2] net: sched: support hash/classid selecting queue_mapping
Date:   Mon,  6 Dec 2021 16:05:12 +0800
Message-Id: <20211206080512.36610-3-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20211206080512.36610-1-xiangxia.m.yue@gmail.com>
References: <20211206080512.36610-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This patch allows users to select queue_mapping, range
from A to B. And users can use skb-hash or cgroup classid
to select queues. Then the packets can load balance from A to
B queue.

$ tc filter ... action skbedit queue_mapping hash-type normal 0 4

"skbedit queue_mapping QUEUE_MAPPING"[0] is enhanced with two flags:
SKBEDIT_F_QUEUE_MAPPING_HASH, SKBEDIT_F_QUEUE_MAPPING_CLASSID.
The range is an unsigned 8bit value in decimal format.

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
 include/uapi/linux/tc_act/tc_skbedit.h |  5 +++
 net/sched/act_skbedit.c                | 48 +++++++++++++++++++++++---
 3 files changed, 50 insertions(+), 4 deletions(-)

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
index 800e93377218..badb58ec84ef 100644
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
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 940091a7c7f0..9cb65bcce001 100644
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
+	u32 hash = 0;
+
+	if (!(params->flags & SKBEDIT_F_QUEUE_MAPPING_HASH_MASK))
+		return netdev_cap_txqueue(skb->dev, queue_mapping);
+
+	if (params->flags & SKBEDIT_F_QUEUE_MAPPING_CLASSID)
+		hash = jhash_1word(task_get_classid(skb), 0);
+	else if (params->flags & SKBEDIT_F_QUEUE_MAPPING_HASH)
+		hash = skb_get_hash(skb);
+
+	queue_mapping= (queue_mapping & 0xff) + hash % mapping_mod;
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
 		skb->tc_skip_txqueue = 1;
-		skb_set_queue_mapping(skb, params->queue_mapping);
+		skb_set_queue_mapping(skb, tcf_skbedit_hash(params, skb));
 	}
 	if (params->flags & SKBEDIT_F_MARK) {
 		skb->mark &= ~params->mask;
@@ -110,6 +129,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	struct tcf_skbedit *d;
 	u32 flags = 0, *priority = NULL, *mark = NULL, *mask = NULL;
 	u16 *queue_mapping = NULL, *ptype = NULL;
+	u16 mapping_mod = 0;
 	bool exists = false;
 	int ret = 0, err;
 	u32 index;
@@ -157,6 +177,21 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 
 		if (*pure_flags & SKBEDIT_F_INHERITDSFIELD)
 			flags |= SKBEDIT_F_INHERITDSFIELD;
+		if (*pure_flags & SKBEDIT_F_QUEUE_MAPPING_HASH_MASK) {
+			u16 max, min;
+
+			if (!queue_mapping)
+				return -EINVAL;
+
+			max = *queue_mapping >> 8;
+			min = *queue_mapping & 0xff;
+			if (max < min)
+				return -EINVAL;
+
+			mapping_mod = max - min + 1;
+			flags |= *pure_flags &
+				 SKBEDIT_F_QUEUE_MAPPING_HASH_MASK;
+		}
 	}
 
 	parm = nla_data(tb[TCA_SKBEDIT_PARMS]);
@@ -206,8 +241,10 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
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
@@ -274,6 +311,9 @@ static int tcf_skbedit_dump(struct sk_buff *skb, struct tc_action *a,
 		goto nla_put_failure;
 	if (params->flags & SKBEDIT_F_INHERITDSFIELD)
 		pure_flags |= SKBEDIT_F_INHERITDSFIELD;
+	if (params->flags & SKBEDIT_F_QUEUE_MAPPING_HASH_MASK)
+		pure_flags |= params->flags &
+			      SKBEDIT_F_QUEUE_MAPPING_HASH_MASK;
 	if (pure_flags != 0 &&
 	    nla_put(skb, TCA_SKBEDIT_FLAGS, sizeof(pure_flags), &pure_flags))
 		goto nla_put_failure;
-- 
2.27.0

