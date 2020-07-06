Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099B22156F1
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 14:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbgGFMB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 08:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgGFMB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 08:01:56 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B12C061794
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 05:01:55 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d10so3218516pll.3
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 05:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=AfvBQQpaxXBM6ALmspsd728BDFD27ASd9KwM5twos2o=;
        b=GscvUQEeG+SW618Cg5Lrel0kwY9gKaTgk0waJkGwRDGu0FFCg6dHQUlcA+cp0XYmsw
         7xQDkK6u4SodTsV3ATfYNpKVc2TWgz7DdDqmI3UvzjxqTqRRjHTYZ8mfmRDc15dDztkp
         QLZDspjxOcmVHUxeEcngr2fZAxAIru3qwCxUO4lpxImR+Z9PFgfemc2UVrHlHADd+ag/
         VInySRbyZFfa7hE1yD0+ZA4ntMWte/MvCZFoHi8DLcJqOlCTOMQeHp+Nzjir4ecZQtBX
         xXQhDAUjesAXKXJ6FSoFKPKh9ABdyH5jMPOXfX5g/MM8QQcLoa7Ds9J5TondZfQYODYA
         K7qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=AfvBQQpaxXBM6ALmspsd728BDFD27ASd9KwM5twos2o=;
        b=kkEBKIrEN96HBRTpC+jYOcEl7BmFdpKggP6KFNpWtEWSO9z8BDF+M6cCyScRiZSL0T
         NSfMGNbn7gPIz0pkw4NoSWnavkKWHKMrRmcW8zoQs6Pi45NCsTSnKyckQUV2hR5lgo5t
         qx/402Fo7f0HYC6J8MmSzws/+6Y/Fw8YV0C6npGYprqyk46jXrHligIykxyob0xiekoW
         oJG90SvDbb3f2I2WlDMc0GCF3KnO63/o5/9u9ynZWu6tz/CzmkZ2MApz8UhIW+HtFpo9
         IzlwSS1NnJqbnvWELEfn8gpljuxc4wZ3aFrO9e62bTAFlcDVzP/qoc2SURpB5uhgXWEg
         6Vew==
X-Gm-Message-State: AOAM533BHwFC6tzNi9r+6HGn68mVtW3cDakyp01Mj2lRcJLKssFKGeog
        1lBO7rA7qmnmcScTzEdi+54838qD+3A=
X-Google-Smtp-Source: ABdhPJytE4cLXy/suHGhgiaB6Ofrv/zf9gAkJfxlXtPLbYJNveysQRlgNYsV2FOY93QCkfWOjw/riQ==
X-Received: by 2002:a17:90a:7846:: with SMTP id y6mr8560348pjl.89.1594036915082;
        Mon, 06 Jul 2020 05:01:55 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d18sm18507996pjz.11.2020.07.06.05.01.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jul 2020 05:01:54 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv3 ipsec-next 01/10] xfrm: add is_ipip to struct xfrm_input_afinfo
Date:   Mon,  6 Jul 2020 20:01:29 +0800
Message-Id: <2fa6dda741a8a315405989bf3276d9158f4d92e2.1594036709.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
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

