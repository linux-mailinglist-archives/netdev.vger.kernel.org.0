Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5B41FBD1C
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 19:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731104AbgFPRgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 13:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729113AbgFPRgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 13:36:52 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A500CC061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:36:52 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id u8so1739848pje.4
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=B9hXhRsmOU2I2Ul+h5EHdpmY0NsRHpe4vaSlkGqUhFM=;
        b=LDWYgVpoZO0d2AYfMKbFLhxl535s5ghFsrparPJ2Nd1qCYnCmfPCha44rILFZI7oyN
         57/Mj6MRHcZ5oA68P3rXm7Pz57EAz5duvlgHtivBbHffrwA8P5R35n2l+nih6fo744gc
         0K9zAeqjfwsJi/np5VbWxhxvglCsXKQKgQkgWjK+7N/c9iHZFpo8zIzhbGrsme8p9pNQ
         KUl6+PNQnm567z1cqaVyquVCknyq8tzC2m2b6XDXycGDnfWMt5/Q5SNhsfXUlflhw5nX
         /Wlz2S9V9UDeiYgNz2hfVcAzkHOj6VtWlHjzTS4OO1U8PJ6KgtZZXXTx/ONgote7wKDr
         8FgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=B9hXhRsmOU2I2Ul+h5EHdpmY0NsRHpe4vaSlkGqUhFM=;
        b=WdLpVtcd0dX/PpAF/7nuPklqBBf84e71vo0DSckLiAmuVfLgNz2IKzsQ8eP9fJ/+DE
         2a9sPjsQ7GrLS/yaOyDuNpuIFzkarwCAOKKjKZH9xg65Cit6XnpRB5gIC1YMIXsB6Ywb
         FK7DKR5LP0RfKvmuYXXT7IdN+U/l759GTFnF6QojtGOTRKmBDaj0LVLLV1gwHMUsAGH0
         TKRfepTJOf118C3BAHHjDSTvOn477bkNtymp8DOsuv4hmbSdmiYI/SEJbs9LGhjH8UDx
         n0P0zH4Tlf7m/YQ8RBh5SPc0hO5p/zAaYGlVQ74fmlzadWrY68BynFXNTKJi2Rje82SB
         pWJA==
X-Gm-Message-State: AOAM532M0mppR7eFDI2zhWW9344Ntvzu1hk/YMuz9UzAeBrfT5cMsnFH
        OG5jBV8eU2mCwqoLdAkgcQvTkPQ07Tk=
X-Google-Smtp-Source: ABdhPJwNnqezddQZhMOH7Q3jr3bItjwneG1GqIKJ0AEh7872oSbGPJ5Kfc4ryvooUfUhy9lNxmuiiA==
X-Received: by 2002:a17:90a:297:: with SMTP id w23mr4039008pja.140.1592329011894;
        Tue, 16 Jun 2020 10:36:51 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y136sm17364363pfg.55.2020.06.16.10.36.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jun 2020 10:36:51 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 01/10] xfrm: add is_ipip to struct xfrm_input_afinfo
Date:   Wed, 17 Jun 2020 01:36:26 +0800
Message-Id: <84bcb772ea1b68f3b150106b9db1825b65742cef.1592328814.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add a new member is_ipip to struct xfrm_input_afinfo,
to allow another group family of callback functions to be registered
with is_ipip set.

This will be used for doing a callback for struct xfrm(6)_tunnel of
ipip/ipv6 tunnels in xfrm_input() by calling xfrm_rcv_cb(), which is
needed by ipip/ipv6 tunnels' support in ip(6)_vti and xfrm interface
in the next patches.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/xfrm.h    |  3 ++-
 net/xfrm/xfrm_input.c | 24 +++++++++++++-----------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 094fe68..4aa118d 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -372,7 +372,8 @@ struct xfrm_state_afinfo *xfrm_state_get_afinfo(unsigned int family);
 struct xfrm_state_afinfo *xfrm_state_afinfo_get_rcu(unsigned int family);
 
 struct xfrm_input_afinfo {
-	unsigned int		family;
+	u8			family;
+	bool			is_ipip;
 	int			(*callback)(struct sk_buff *skb, u8 protocol,
 					    int err);
 };
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index bd984ff..37456d0 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -42,7 +42,7 @@ struct xfrm_trans_cb {
 #define XFRM_TRANS_SKB_CB(__skb) ((struct xfrm_trans_cb *)&((__skb)->cb[0]))
 
 static DEFINE_SPINLOCK(xfrm_input_afinfo_lock);
-static struct xfrm_input_afinfo const __rcu *xfrm_input_afinfo[AF_INET6 + 1];
+static struct xfrm_input_afinfo const __rcu *xfrm_input_afinfo[2][AF_INET6 + 1];
 
 static struct gro_cells gro_cells;
 static struct net_device xfrm_napi_dev;
@@ -53,14 +53,14 @@ int xfrm_input_register_afinfo(const struct xfrm_input_afinfo *afinfo)
 {
 	int err = 0;
 
-	if (WARN_ON(afinfo->family >= ARRAY_SIZE(xfrm_input_afinfo)))
+	if (WARN_ON(afinfo->family > AF_INET6))
 		return -EAFNOSUPPORT;
 
 	spin_lock_bh(&xfrm_input_afinfo_lock);
-	if (unlikely(xfrm_input_afinfo[afinfo->family] != NULL))
+	if (unlikely(xfrm_input_afinfo[afinfo->is_ipip][afinfo->family]))
 		err = -EEXIST;
 	else
-		rcu_assign_pointer(xfrm_input_afinfo[afinfo->family], afinfo);
+		rcu_assign_pointer(xfrm_input_afinfo[afinfo->is_ipip][afinfo->family], afinfo);
 	spin_unlock_bh(&xfrm_input_afinfo_lock);
 	return err;
 }
@@ -71,11 +71,11 @@ int xfrm_input_unregister_afinfo(const struct xfrm_input_afinfo *afinfo)
 	int err = 0;
 
 	spin_lock_bh(&xfrm_input_afinfo_lock);
-	if (likely(xfrm_input_afinfo[afinfo->family] != NULL)) {
-		if (unlikely(xfrm_input_afinfo[afinfo->family] != afinfo))
+	if (likely(xfrm_input_afinfo[afinfo->is_ipip][afinfo->family])) {
+		if (unlikely(xfrm_input_afinfo[afinfo->is_ipip][afinfo->family] != afinfo))
 			err = -EINVAL;
 		else
-			RCU_INIT_POINTER(xfrm_input_afinfo[afinfo->family], NULL);
+			RCU_INIT_POINTER(xfrm_input_afinfo[afinfo->is_ipip][afinfo->family], NULL);
 	}
 	spin_unlock_bh(&xfrm_input_afinfo_lock);
 	synchronize_rcu();
@@ -83,15 +83,15 @@ int xfrm_input_unregister_afinfo(const struct xfrm_input_afinfo *afinfo)
 }
 EXPORT_SYMBOL(xfrm_input_unregister_afinfo);
 
-static const struct xfrm_input_afinfo *xfrm_input_get_afinfo(unsigned int family)
+static const struct xfrm_input_afinfo *xfrm_input_get_afinfo(u8 family, bool is_ipip)
 {
 	const struct xfrm_input_afinfo *afinfo;
 
-	if (WARN_ON_ONCE(family >= ARRAY_SIZE(xfrm_input_afinfo)))
+	if (WARN_ON_ONCE(family > AF_INET6))
 		return NULL;
 
 	rcu_read_lock();
-	afinfo = rcu_dereference(xfrm_input_afinfo[family]);
+	afinfo = rcu_dereference(xfrm_input_afinfo[is_ipip][family]);
 	if (unlikely(!afinfo))
 		rcu_read_unlock();
 	return afinfo;
@@ -100,9 +100,11 @@ static const struct xfrm_input_afinfo *xfrm_input_get_afinfo(unsigned int family
 static int xfrm_rcv_cb(struct sk_buff *skb, unsigned int family, u8 protocol,
 		       int err)
 {
+	bool is_ipip = (protocol == IPPROTO_IPIP || protocol == IPPROTO_IPV6);
+	const struct xfrm_input_afinfo *afinfo;
 	int ret;
-	const struct xfrm_input_afinfo *afinfo = xfrm_input_get_afinfo(family);
 
+	afinfo = xfrm_input_get_afinfo(family, is_ipip);
 	if (!afinfo)
 		return -EAFNOSUPPORT;
 
-- 
2.1.0

