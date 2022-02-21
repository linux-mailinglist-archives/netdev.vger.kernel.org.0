Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520404BD5B9
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 07:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343815AbiBUFzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 00:55:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244634AbiBUFzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 00:55:38 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FD051334
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 21:55:16 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id w37so7009665pga.7
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 21:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gCe0OI6kcHN1H667YWzFpDyE89e9i4+tQIOs2sQ4kMs=;
        b=dURnCRDUiyU4Zk3DI7xgUcooCDvcWSbKAtEQkmYM5QRVxxk7qdqEuQ+pkektO18zzO
         JZRdVTghEUnO6Y03NgMOSsZmnGg8EFU88UqswriJR7WrvSKNSgl2Gx/OE11P85wwOwkd
         TowAivx5oE7glcJk59+QeOj0j5kn7rNelh4OiaiYwzo+hHYfxjHd+eH9rdZzwvZDAIU2
         ECWADXAHSMXQTbmiBZGG8PkMen0uYnyi7lwbHkVACvp9WPtdpV2t25DPkjE8oS6gLt7W
         dKBEwViCv914jxQRIBMV78MKG9FvpquDqc/zIN15dn67dmdN9IduvrmOwSFUcLWU2ODM
         fy1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gCe0OI6kcHN1H667YWzFpDyE89e9i4+tQIOs2sQ4kMs=;
        b=alaU84eKw0Y+TRUgOqYB+cHgDU7RMtZRDdQAKwAs02ccuq2bqyvryixKgv/DoiCyAc
         WB2VlFGTESZtoVBqaUqGltJgwRBT6jhexiBpcgFIIvA3jXZbULbYmUmfn4W1weSBcQ9Z
         M4+tApa1tiTav0exj/aOEEJ1BrgWFKM2z1wlttsqWfz0OykqeJGRzvJ4MgWXyZUHt2O7
         nR/oEOPMihctYMnCHDMopLbgNFO+QNwUj+XxGbQ2/NbO8d2WgKZ35u+ut/pjdLUBY5wA
         ipZceLi1HP6DVJUl0Rsn/0M9Erfes5EJi0dFwMpuYP64rJn5a1ErOBr+RhDxSPeN7goV
         B9cw==
X-Gm-Message-State: AOAM532qL2+D96ru9sboroefoNEdFPvC3FypJ/93g/7cS2poi5Rxbz1r
        Z2Vus/jqBXiPdAufyWX4w+YhOfgbLTc=
X-Google-Smtp-Source: ABdhPJyCJpKcTgotpZhnNM1vkU80ldoKzmttawzWqgr5cxoVcnxRH+QRxznos2TvLc+BVao8mpejjQ==
X-Received: by 2002:a05:6a00:14ce:b0:4ec:aa7a:53c7 with SMTP id w14-20020a056a0014ce00b004ecaa7a53c7mr14876938pfu.62.1645422915514;
        Sun, 20 Feb 2022 21:55:15 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s15sm17359767pgn.30.2022.02.20.21.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 21:55:15 -0800 (PST)
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
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net-next 1/5] ipv6: separate ndisc_ns_create() from ndisc_send_ns()
Date:   Mon, 21 Feb 2022 13:54:53 +0800
Message-Id: <20220221055458.18790-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220221055458.18790-1-liuhangbin@gmail.com>
References: <20220221055458.18790-1-liuhangbin@gmail.com>
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

