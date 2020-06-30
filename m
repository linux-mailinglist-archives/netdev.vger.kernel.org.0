Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D151D20EF9E
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 09:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731082AbgF3Hgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 03:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731033AbgF3Hgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 03:36:53 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFBAC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:36:53 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id f6so5062191pjq.5
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=AfvBQQpaxXBM6ALmspsd728BDFD27ASd9KwM5twos2o=;
        b=bPLehMXh8n99rhtirsPDcLyKm67it841VFdWa6QVXgDggxfdv0YPHGgZzMIll24qUN
         IDMe36zT6tIk8nZOo7ZLcco0DI7pbL4J/pJOAOuLc/QBgWb6s88dr9sf+UCxdBCFM9Ud
         +8xDEil0Edh/jX/O3lONCAcIisNaTxSzcM4oorbqdltJSPZONXCgZ0KVVt8x/9CuE50Z
         3vecehk6Tl85Et7TgjJwrzOSQHhTySXNoBucdZZOmFXca5c5AdAiQ8ZHmJjDso8cateQ
         yRPSICyNLUVGW3hpLJMfSq4qNkK75+mnfriCJ1IQg6HbsBrfOG7OM5maKCu6OK1amYe9
         MgMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=AfvBQQpaxXBM6ALmspsd728BDFD27ASd9KwM5twos2o=;
        b=tH1eFWrgX3pPVd0xGRnmKbhvgYpIcTcJoo8tBLs0aBpo5kd/AqMNEkicFqOK6vwNfc
         Lg94A/JUDB7aCXgLaabCqar5UibcgBpAoDLWYELywH5hW4WunviPuJ8qyHP6mOwLcLII
         rV72kVbTjhRRGGkNa8OCwokDIyiZ4zTk4ieaXJtD54eJfPmffZQkgMGTsBWSWKv8XsYA
         42ML8JGhQXmu71sSvMQeq2m3PG36CH1RYLZsTxxqnmZyoTqvp0Hgy367W82iPFjFKblg
         7VJ6RZuVKh/tWoAcxkbAPE/ZCYPa9PjZ3DNmhLmzRGrgbBTZBBWT1cKpH7A7ADbDa29W
         lvyQ==
X-Gm-Message-State: AOAM533eOUnZrhCk1zudC3IFJOS4VuCFMM6Egxy9CSlOkHRWjkRD6chq
        jaGINqQd1mde775B4iXzU/CTG4CG
X-Google-Smtp-Source: ABdhPJwQowO6vM3BKoHvi6AAVw3CTCRBxmBnpkOQgq/vUUdxowHSmEbuXxEQDB8qsUHZ3SMido+cuQ==
X-Received: by 2002:a17:902:aa09:: with SMTP id be9mr15770409plb.206.1593502612185;
        Tue, 30 Jun 2020 00:36:52 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x7sm1734988pfp.96.2020.06.30.00.36.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jun 2020 00:36:51 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv2 ipsec-next 01/10] xfrm: add is_ipip to struct xfrm_input_afinfo
Date:   Tue, 30 Jun 2020 15:36:26 +0800
Message-Id: <348f1f3d64495bde03a9ce0475f4fa7a34584e9c.1593502515.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
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
index e20b2b2..4666bc9 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -373,7 +373,8 @@ struct xfrm_state_afinfo *xfrm_state_get_afinfo(unsigned int family);
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

