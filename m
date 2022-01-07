Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9BB4876D1
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 12:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347247AbiAGLv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 06:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347204AbiAGLv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 06:51:56 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2680C061245
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 03:51:55 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 8so5241014pgc.10
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 03:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5GBH8VsPkdgGnzzw1li1azuB0PrKfXH2MyZR/EdansI=;
        b=cjgn6FtvaNUvfFqsP4UGwAyjaWKWbTXQBYXMkKOpb3diKF5cO2po/zKBWHoQRYaaSf
         REb3gtpHN7yYAOjzkcE92giqDppD2X0aoHfFtif8pSPztLUo+nkbQ1k2pGGxjdpbsa4V
         gYyt6OjbzzjLXpExrs1MgPAZNbtW1k+n+QiaY4lGo1XMM5/F2jAyVIJZYJZuoKXqHQKk
         PBhF04jr1EmcA0JbsqSpo1L+EWgaRwq7WbBBW77/L2a0K2ewmNzRcQVe8vboGbcLsmci
         0fbGPewV560TbaCohe4wvPEgGFuzYu8URP1e8odCDT6A1RaiLtRPA29IvluqvtAyJxUQ
         jvJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5GBH8VsPkdgGnzzw1li1azuB0PrKfXH2MyZR/EdansI=;
        b=DIYfg45/Qojuv8kidQl7AtZLpm2wpmPKZHL6M7W+TYH5NtT/QunPjsj+PglxsD4v6T
         OIPaICY2T1hDwYczsIa7cliPK3OP0e7sbQMeusyr5qWWeiBfYAXkhWjsg3ybNHpJiFzn
         on2JTc5ygzdiWoDq0Xeogwv10PJSQ9fCbuDQjeWOCuuxCla5Uhagp9tlHUx/R3Fhd6/R
         w3ybwrSiV1gVo7NNJpbP4wCFgcy8raa47Z/Q5kY2FPJoNRT4xfxyssxGrjS0wxS2yVlB
         iZCPoHS0hdYCcwcDo1swAkk9czXk5EmHDivOaIJcpyylYXSu0TjOCBAlQn0jL/fnfeCc
         GpZQ==
X-Gm-Message-State: AOAM533+EfJtJXbr/tZiGIcInMcFim4jO7wy6E+90XwlbEteKMukKTW4
        hDbau2R4l/LNzrO7bskNNesmTk0r9KCh2zac
X-Google-Smtp-Source: ABdhPJw40e1Z7B7Pej7kZay16B0h/TSVMC4KsXR+WYyeJOfb19sCJienJQNh+CF/1ifSW0HX25nGEA==
X-Received: by 2002:a63:450c:: with SMTP id s12mr55563984pga.84.1641556314933;
        Fri, 07 Jan 2022 03:51:54 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id e20sm5744824pfv.219.2022.01.07.03.51.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jan 2022 03:51:54 -0800 (PST)
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
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Tonghao Zhang <xxmy@openvirtualnetworks.org>
Subject: [net-next RESEND v7 2/2] net: sched: support hash/classid/cpuid selecting tx queue
Date:   Fri,  7 Jan 2022 19:51:30 +0800
Message-Id: <20220107115130.51073-3-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220107115130.51073-1-xiangxia.m.yue@gmail.com>
References: <20220107115130.51073-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This patch allows user to select queue_mapping, range
from A to B. And user can use skbhash, cgroup classid
and cpuid to select Tx queues. Then we can load balance
packets from A to B queue. The range is an unsigned 16bit
value in decimal format.

$ tc filter ... action skbedit queue_mapping skbhash A B

"skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit")
is enhanced with flags:
* SKBEDIT_F_TXQ_SKBHASH
* SKBEDIT_F_TXQ_CLASSID
* SKBEDIT_F_TXQ_CPUID

Use skb->hash, cgroup classid, or cpuid to distribute packets.
Then same range of tx queues can be shared for different flows,
cgroups, or CPUs in a variety of scenarios.

For example, F1 may share range R1 with F2. The best way to do
that is to set flag to SKBEDIT_F_TXQ_HASH, using skb->hash to
share the queues. If cgroup C1 want to share the R1 with cgroup
C2 .. Cn, use the SKBEDIT_F_TXQ_CLASSID. Of course, in some other
scenario, C1 use R1, while Cn can use the Rn.

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
Signed-off-by: Tonghao Zhang <xxmy@openvirtualnetworks.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 include/net/tc_act/tc_skbedit.h        |  1 +
 include/uapi/linux/tc_act/tc_skbedit.h |  8 +++
 net/sched/act_skbedit.c                | 78 +++++++++++++++++++++++++-
 3 files changed, 84 insertions(+), 3 deletions(-)

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
index 800e93377218..5ea1438a4d88 100644
--- a/include/uapi/linux/tc_act/tc_skbedit.h
+++ b/include/uapi/linux/tc_act/tc_skbedit.h
@@ -29,6 +29,13 @@
 #define SKBEDIT_F_PTYPE			0x8
 #define SKBEDIT_F_MASK			0x10
 #define SKBEDIT_F_INHERITDSFIELD	0x20
+#define SKBEDIT_F_TXQ_SKBHASH		0x40
+#define SKBEDIT_F_TXQ_CLASSID		0x80
+#define SKBEDIT_F_TXQ_CPUID		0x100
+
+#define SKBEDIT_F_TXQ_HASH_MASK (SKBEDIT_F_TXQ_SKBHASH | \
+				 SKBEDIT_F_TXQ_CLASSID | \
+				 SKBEDIT_F_TXQ_CPUID)
 
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
index d5799b4fc499..4c209689f8de 100644
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
@@ -23,6 +24,38 @@
 static unsigned int skbedit_net_id;
 static struct tc_action_ops act_skbedit_ops;
 
+static u16 tcf_skbedit_hash(struct tcf_skbedit_params *params,
+			    struct sk_buff *skb)
+{
+	u32 mapping_hash_type = params->flags & SKBEDIT_F_TXQ_HASH_MASK;
+	u16 queue_mapping = params->queue_mapping;
+	u16 mapping_mod = params->mapping_mod;
+	u32 hash = 0;
+
+	switch (mapping_hash_type) {
+	case SKBEDIT_F_TXQ_CLASSID:
+		hash = task_get_classid(skb);
+		break;
+	case SKBEDIT_F_TXQ_SKBHASH:
+		hash = skb_get_hash(skb);
+		break;
+	case SKBEDIT_F_TXQ_CPUID:
+		hash = raw_smp_processor_id();
+		break;
+	case 0:
+		/* Hash type isn't specified. In this case:
+		 * hash % mapping_mod == 0
+		 */
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
@@ -62,7 +95,7 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 #ifdef CONFIG_NET_EGRESS
 		netdev_xmit_skip_txqueue(true);
 #endif
-		skb_set_queue_mapping(skb, params->queue_mapping);
+		skb_set_queue_mapping(skb, tcf_skbedit_hash(params, skb));
 	}
 	if (params->flags & SKBEDIT_F_MARK) {
 		skb->mark &= ~params->mask;
@@ -96,6 +129,7 @@ static const struct nla_policy skbedit_policy[TCA_SKBEDIT_MAX + 1] = {
 	[TCA_SKBEDIT_PTYPE]		= { .len = sizeof(u16) },
 	[TCA_SKBEDIT_MASK]		= { .len = sizeof(u32) },
 	[TCA_SKBEDIT_FLAGS]		= { .len = sizeof(u64) },
+	[TCA_SKBEDIT_QUEUE_MAPPING_MAX]	= { .len = sizeof(u16) },
 };
 
 static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
@@ -112,6 +146,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	struct tcf_skbedit *d;
 	u32 flags = 0, *priority = NULL, *mark = NULL, *mask = NULL;
 	u16 *queue_mapping = NULL, *ptype = NULL;
+	u16 mapping_mod = 1;
 	bool exists = false;
 	int ret = 0, err;
 	u32 index;
@@ -156,7 +191,34 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 
 	if (tb[TCA_SKBEDIT_FLAGS] != NULL) {
 		u64 *pure_flags = nla_data(tb[TCA_SKBEDIT_FLAGS]);
-
+		u64 mapping_hash_type;
+
+		mapping_hash_type = *pure_flags & SKBEDIT_F_TXQ_HASH_MASK;
+		if (mapping_hash_type) {
+			u16 *queue_mapping_max;
+
+			/* Hash types are mutually exclusive. */
+			if (mapping_hash_type & (mapping_hash_type - 1)) {
+				NL_SET_ERR_MSG_MOD(extack, "Multi types of hash are specified.");
+				return -EINVAL;
+			}
+
+			if (!tb[TCA_SKBEDIT_QUEUE_MAPPING] ||
+			    !tb[TCA_SKBEDIT_QUEUE_MAPPING_MAX]) {
+				NL_SET_ERR_MSG_MOD(extack, "Missing required range of queue_mapping.");
+				return -EINVAL;
+			}
+
+			queue_mapping_max =
+				nla_data(tb[TCA_SKBEDIT_QUEUE_MAPPING_MAX]);
+			if (*queue_mapping_max < *queue_mapping) {
+				NL_SET_ERR_MSG_MOD(extack, "The range of queue_mapping is invalid, max < min.");
+				return -EINVAL;
+			}
+
+			mapping_mod = *queue_mapping_max - *queue_mapping + 1;
+			flags |= mapping_hash_type;
+		}
 		if (*pure_flags & SKBEDIT_F_INHERITDSFIELD)
 			flags |= SKBEDIT_F_INHERITDSFIELD;
 	}
@@ -208,8 +270,10 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
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
@@ -276,6 +340,13 @@ static int tcf_skbedit_dump(struct sk_buff *skb, struct tc_action *a,
 		goto nla_put_failure;
 	if (params->flags & SKBEDIT_F_INHERITDSFIELD)
 		pure_flags |= SKBEDIT_F_INHERITDSFIELD;
+	if (params->flags & SKBEDIT_F_TXQ_HASH_MASK) {
+		if (nla_put_u16(skb, TCA_SKBEDIT_QUEUE_MAPPING_MAX,
+				params->queue_mapping + params->mapping_mod - 1))
+			goto nla_put_failure;
+
+		pure_flags |= params->flags & SKBEDIT_F_TXQ_HASH_MASK;
+	}
 	if (pure_flags != 0 &&
 	    nla_put(skb, TCA_SKBEDIT_FLAGS, sizeof(pure_flags), &pure_flags))
 		goto nla_put_failure;
@@ -325,6 +396,7 @@ static size_t tcf_skbedit_get_fill_size(const struct tc_action *act)
 	return nla_total_size(sizeof(struct tc_skbedit))
 		+ nla_total_size(sizeof(u32)) /* TCA_SKBEDIT_PRIORITY */
 		+ nla_total_size(sizeof(u16)) /* TCA_SKBEDIT_QUEUE_MAPPING */
+		+ nla_total_size(sizeof(u16)) /* TCA_SKBEDIT_QUEUE_MAPPING_MAX */
 		+ nla_total_size(sizeof(u32)) /* TCA_SKBEDIT_MARK */
 		+ nla_total_size(sizeof(u16)) /* TCA_SKBEDIT_PTYPE */
 		+ nla_total_size(sizeof(u32)) /* TCA_SKBEDIT_MASK */
-- 
2.27.0

