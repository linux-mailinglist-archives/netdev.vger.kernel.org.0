Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E993E33BB
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 08:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhHGGVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 02:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhHGGVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 02:21:30 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD635C0613CF;
        Fri,  6 Aug 2021 23:21:12 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso21305722pjo.1;
        Fri, 06 Aug 2021 23:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m2cqmq90O7bUx6WnzE787bEO9ZOPXuPJtWAxQVGTmx4=;
        b=Py6Y955oz6HI1f43MbKUetr8rs+3ZJ6lB8q0Qf5Opr/7xJTeHo+rODYHo3BN9XFHEz
         IU85n4Dk9qBDKSBldSV9znRV07mYtKnIS4ZVLjg3QkbjzU7ggFanCAMiF04TDJ8Fh/FZ
         i9auyoj0NYc2LlwSNbsoSHru5iyH7MOxxxWPidSjU8yrYp03ZV6IdZIa0IXfvXNGlodD
         76gTaBUxCnfWToWZBPjzWLAR1S0rfG3SVznjj4GXBapDBRDg+7bgpv9GreHyvYgqudtc
         r24o043IlEzBMLGqwyuAf3h62uATtvaNqnj3NkIa3wDyExg7HePpBCwqgOwsDzVPvhYE
         gg6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m2cqmq90O7bUx6WnzE787bEO9ZOPXuPJtWAxQVGTmx4=;
        b=Fl/r/+/dGZy1JY8ZQ1zuyYJF9drSwBm96qld2hPRDoXR19T2ugxBxEpno8jgCkIwDa
         xfYySNvq5GxLwrdb7JdzbHLW3T7X1EyT6KsyvZUzjSqiVeVA+o1UGKfvsuJ7JZI4JxQO
         R8P52uvhHpDtGAZRATW4burFO1qLTkelR9MeP3Kq/nH8HIeO1iJCrN1MOW+F9TaEknOR
         9EQ/m+GEfA+g7wQsEth021PdfBPBCcm4IAjhxZ7eW0zktZsw4MpX51J5dptWs3X8r8c0
         NITGqS1QsikQdrwEZJNwnNWklO72pDIIEiffXWzOBOCBT2f6HadFL3+XqUM7WX4l5IQ2
         Pyzg==
X-Gm-Message-State: AOAM533sPfXg+QnScsyf/tdVR1JhFvM/TAj/oePwUGcnErq8OerVPROV
        8thIDS7mfq3IO65ZnKAkmN4=
X-Google-Smtp-Source: ABdhPJwJOiCK3vqkQxeVgeIXyYL9YVCNVjrzLHcjv41inI2KjVSwGPFUPOTv1Jgbttk8NY778o/Rqg==
X-Received: by 2002:a63:e214:: with SMTP id q20mr11413pgh.134.1628317272349;
        Fri, 06 Aug 2021 23:21:12 -0700 (PDT)
Received: from localhost.localdomain ([1.240.193.107])
        by smtp.googlemail.com with ESMTPSA id y4sm10985287pjw.57.2021.08.06.23.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 23:21:11 -0700 (PDT)
From:   Kangmin Park <l4stpr0gr4m@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: remove duplicate code
Date:   Sat,  7 Aug 2021 15:21:06 +0900
Message-Id: <20210807062106.2563-1-l4stpr0gr4m@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nf_nat_ipv4_fn() and nf_nat_ipv6_fn() call nf_nat_inet_fn().
Those two functions are already contains routine that gets nf_conn
object and checks the untrackable situation.
So, the following code is duplicated.

```
ct = nf_ct_get(skb, &ctinfo);
if (!ct)
        return NF_ACCEPT;
```

Therefore, define a function __nf_nat_inet_fn() that has the same
contents as the nf_nat_inet_fn() except for routine gets and checks
the nf_conn object.
Then, separate the nf_nat_inet_fn() into a routine that gets a
nf_conn object and a routine that calls the __nf_nat_inet_fn().

Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
---
 include/net/netfilter/nf_nat.h |  5 +++++
 net/netfilter/nf_nat_core.c    | 37 ++++++++++++++++++++++------------
 net/netfilter/nf_nat_proto.c   |  4 ++--
 3 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 987111ae5240..a66f617c5054 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -100,6 +100,11 @@ void nf_nat_ipv6_unregister_fn(struct net *net, const struct nf_hook_ops *ops);
 int nf_nat_inet_register_fn(struct net *net, const struct nf_hook_ops *ops);
 void nf_nat_inet_unregister_fn(struct net *net, const struct nf_hook_ops *ops);
 
+unsigned int
+__nf_nat_inet_fn(void *priv, struct sk_buff *skb,
+		 const struct nf_hook_state *state, struct nf_conn *ct,
+		 enum ip_conntrack_info ctinfo);
+
 unsigned int
 nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state);
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 7de595ead06a..98ebba2c0f6d 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -682,25 +682,15 @@ unsigned int nf_nat_packet(struct nf_conn *ct,
 }
 EXPORT_SYMBOL_GPL(nf_nat_packet);
 
 unsigned int
-nf_nat_inet_fn(void *priv, struct sk_buff *skb,
-	       const struct nf_hook_state *state)
+__nf_nat_inet_fn(void *priv, struct sk_buff *skb,
+		 const struct nf_hook_state *state, struct nf_conn *ct,
+		 enum ip_conntrack_info ctinfo)
 {
-	struct nf_conn *ct;
-	enum ip_conntrack_info ctinfo;
 	struct nf_conn_nat *nat;
 	/* maniptype == SRC for postrouting. */
 	enum nf_nat_manip_type maniptype = HOOK2MANIP(state->hook);
 
-	ct = nf_ct_get(skb, &ctinfo);
-	/* Can't track?  It's not due to stress, or conntrack would
-	 * have dropped it.  Hence it's the user's responsibilty to
-	 * packet filter it out, or implement conntrack/NAT for that
-	 * protocol. 8) --RR
-	 */
-	if (!ct)
-		return NF_ACCEPT;
-
 	nat = nfct_nat(ct);
 
 	switch (ctinfo) {
@@ -755,6 +745,26 @@ nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 	nf_ct_kill_acct(ct, ctinfo, skb);
 	return NF_DROP;
 }
+EXPORT_SYMBOL_GPL(__nf_nat_inet_fn);
+
+unsigned int
+nf_nat_inet_fn(void *priv, struct sk_buff *skb,
+	       const struct nf_hook_state *state)
+{
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	/* Can't track?  It's not due to stress, or conntrack would
+	 * have dropped it.  Hence it's the user's responsibilty to
+	 * packet filter it out, or implement conntrack/NAT for that
+	 * protocol. 8) --RR
+	 */
+	if (!ct)
+		return NF_ACCEPT;
+
+	return __nf_nat_inet_fn(priv, skb, state, ct, ctinfo);
+}
 EXPORT_SYMBOL_GPL(nf_nat_inet_fn);
 
 struct nf_nat_proto_clean {
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 48cc60084d28..897859730078 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -642,7 +642,7 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
 		}
 	}
 
-	return nf_nat_inet_fn(priv, skb, state);
+	return __nf_nat_inet_fn(priv, skb, state, ct, ctinfo);
 }
 
 static unsigned int
@@ -934,7 +934,7 @@ nf_nat_ipv6_fn(void *priv, struct sk_buff *skb,
 		}
 	}
 
-	return nf_nat_inet_fn(priv, skb, state);
+	return __nf_nat_inet_fn(priv, skb, state, ct, ctinfo);
 }
 
 static unsigned int
-- 
2.26.2

