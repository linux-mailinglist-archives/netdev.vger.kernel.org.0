Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22054B82A1
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 09:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiBPIJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 03:09:11 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiBPIJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 03:09:07 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A3224310C
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 00:08:55 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v4so1762108pjh.2
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 00:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gCe0OI6kcHN1H667YWzFpDyE89e9i4+tQIOs2sQ4kMs=;
        b=ojUGh/t6RuzMHlUAJU0PnKSKwNXd0OW5i6OAkRDgNkggZIEbjcV9a+F+AJLUeq2WLq
         uSH3NA4gN4tWN+8weQlzW7fV92e0GI9mOINqRCOHYioYHQSjrtWaQXbka0opI46jN3PN
         m1DKyQ77cU9Adgq/qdEwd2ZvmitCoRw0WT0hiqTFIZXyGLt303it0NWqoeCTy9bHhu9N
         4mNPUcQaDRObtIEALy+wNJ0E0r4RtBWHjlvQzxPLldNPTBgTwa8Td9S5cJh11DFgJAci
         3u+tuin9zhkjXDE5vvVJcF4Et9C1lLNBpWvcttbyhDu32kjCW8kE1LfJaBL+S4wOn9I5
         XkNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gCe0OI6kcHN1H667YWzFpDyE89e9i4+tQIOs2sQ4kMs=;
        b=ICcmrHNmUTkz7fD4/ZZ0GwBe7s84hkz2vJG1bwI8V6+mN9t/TqwT0LiNiGiSU4JJyc
         lzvW/xHs2Xr6LHecDgoZlWVKIvky9MTXuAYIpdB4UOZJoK5cVkBLjoUyuY9lgWykVH52
         9nep9t4MzfUrmP+lOmd5LLml3rIqKFB4u/BkNmqMxnD8g7bidaAP7m0MHF/8DV6qHhwa
         O8/RVqXMPUnPu6HBxFEmQr67RAVBZQn1hBoaSAlwwGlziW0sImKZNg564ki9JRIyafME
         eJmsxME77c5y4Cc1bml1epy5sL90UcDFbsB8dTQRCt0q5U6zPg7hIVHvTxOcd1XCa7ix
         earQ==
X-Gm-Message-State: AOAM532QGp8apeqR01X9SmgEWjdegaZ+P94aM8Y27ZVXZ8G/eqtJH4uE
        D7Ga5hghNvr3iUs7d9I0eADUKd8Zt5s=
X-Google-Smtp-Source: ABdhPJwNbdazxzv1GKL/0/D0+NUS24sGQdHlNZoara1K3nsAljstSioUPGqA29WoHuOzb/D9AKSjOw==
X-Received: by 2002:a17:90b:181:b0:1b9:e1a6:d47b with SMTP id t1-20020a17090b018100b001b9e1a6d47bmr419447pjs.148.1644998934689;
        Wed, 16 Feb 2022 00:08:54 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s15sm4635662pgn.30.2022.02.16.00.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 00:08:54 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next 1/5] ipv6: separate ndisc_ns_create() from ndisc_send_ns()
Date:   Wed, 16 Feb 2022 16:08:34 +0800
Message-Id: <20220216080838.158054-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220216080838.158054-1-liuhangbin@gmail.com>
References: <20220216080838.158054-1-liuhangbin@gmail.com>
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

This patch separate NS message allocation steps from ndisc_send_ns(),
so it could be used in other places, like bonding, to allocate and
send IPv6 NS message.

Also export ndisc_send_skb() and ndisc_ns_create() for later bonding usage.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/net/ndisc.h |  5 +++++
 net/ipv6/ndisc.c    | 49 +++++++++++++++++++++++++++++----------------
 2 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 53cb8de0e589..aac3a42de432 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -447,10 +447,15 @@ void ndisc_cleanup(void);
 
 int ndisc_rcv(struct sk_buff *skb);
 
+struct sk_buff *ndisc_ns_create(struct net_device *dev, const struct in6_addr *solicit,
+				const struct in6_addr *saddr, u64 nonce);
 void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
 		   const struct in6_addr *daddr, const struct in6_addr *saddr,
 		   u64 nonce);
 
+void ndisc_send_skb(struct sk_buff *skb, const struct in6_addr *daddr,
+		    const struct in6_addr *saddr);
+
 void ndisc_send_rs(struct net_device *dev,
 		   const struct in6_addr *saddr, const struct in6_addr *daddr);
 void ndisc_send_na(struct net_device *dev, const struct in6_addr *daddr,
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 1c06d0cd02f7..fcb288b0ae13 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -466,9 +466,8 @@ static void ip6_nd_hdr(struct sk_buff *skb,
 	hdr->daddr = *daddr;
 }
 
-static void ndisc_send_skb(struct sk_buff *skb,
-			   const struct in6_addr *daddr,
-			   const struct in6_addr *saddr)
+void ndisc_send_skb(struct sk_buff *skb, const struct in6_addr *daddr,
+		    const struct in6_addr *saddr)
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct net *net = dev_net(skb->dev);
@@ -515,6 +514,7 @@ static void ndisc_send_skb(struct sk_buff *skb,
 
 	rcu_read_unlock();
 }
+EXPORT_SYMBOL(ndisc_send_skb);
 
 void ndisc_send_na(struct net_device *dev, const struct in6_addr *daddr,
 		   const struct in6_addr *solicited_addr,
@@ -598,22 +598,16 @@ static void ndisc_send_unsol_na(struct net_device *dev)
 	in6_dev_put(idev);
 }
 
-void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
-		   const struct in6_addr *daddr, const struct in6_addr *saddr,
-		   u64 nonce)
+struct sk_buff *ndisc_ns_create(struct net_device *dev, const struct in6_addr *solicit,
+				const struct in6_addr *saddr, u64 nonce)
 {
-	struct sk_buff *skb;
-	struct in6_addr addr_buf;
 	int inc_opt = dev->addr_len;
-	int optlen = 0;
+	struct sk_buff *skb;
 	struct nd_msg *msg;
+	int optlen = 0;
 
-	if (!saddr) {
-		if (ipv6_get_lladdr(dev, &addr_buf,
-				   (IFA_F_TENTATIVE|IFA_F_OPTIMISTIC)))
-			return;
-		saddr = &addr_buf;
-	}
+	if (!saddr)
+		return NULL;
 
 	if (ipv6_addr_any(saddr))
 		inc_opt = false;
@@ -625,7 +619,7 @@ void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
 
 	skb = ndisc_alloc_skb(dev, sizeof(*msg) + optlen);
 	if (!skb)
-		return;
+		return NULL;
 
 	msg = skb_put(skb, sizeof(*msg));
 	*msg = (struct nd_msg) {
@@ -647,7 +641,28 @@ void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
 		memcpy(opt + 2, &nonce, 6);
 	}
 
-	ndisc_send_skb(skb, daddr, saddr);
+	return skb;
+}
+EXPORT_SYMBOL(ndisc_ns_create);
+
+void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
+		   const struct in6_addr *daddr, const struct in6_addr *saddr,
+		   u64 nonce)
+{
+	struct in6_addr addr_buf;
+	struct sk_buff *skb;
+
+	if (!saddr) {
+		if (ipv6_get_lladdr(dev, &addr_buf,
+				    (IFA_F_TENTATIVE | IFA_F_OPTIMISTIC)))
+			return;
+		saddr = &addr_buf;
+	}
+
+	skb = ndisc_ns_create(dev, solicit, saddr, nonce);
+
+	if (skb)
+		ndisc_send_skb(skb, daddr, saddr);
 }
 
 void ndisc_send_rs(struct net_device *dev, const struct in6_addr *saddr,
-- 
2.31.1

