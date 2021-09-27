Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3EA1418DF8
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 05:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbhI0Dg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 23:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbhI0Dgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 23:36:55 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2657C061570;
        Sun, 26 Sep 2021 20:35:17 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id h12so1084489pjj.1;
        Sun, 26 Sep 2021 20:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VHvBgXQTEmDe94oFEb/1mhIUaXdt/Kv7BDHynzU+GkM=;
        b=b1XQjFtBLOyS9/Un8W4eCeIgeARpoBY1O9JSqsQTSpuObf7/XmEUXkv/8Kg66Mr4jB
         pdd6OVomEq9RjDBu/SNyjUuOjMY+jPW/ZatqNKlTKFoCCWKe9ajQb1mZLkmKrjsVhg84
         n+MEw4NMxIaevmHwa0wtG7SipAxr0oh5E1jrhKRTreBEj+AT86duvWrCgXE7xocyp5W1
         en3az1zM9b5IPd9ExdCnHYP+WAAnwisgWmzRTAdF1hxTK2Rr0sFxv3Hvug16dARHjQH2
         2RMg7byNgVIqzEiYI8BUuCNzAN5M05R0GsPgfxsZff+Wzzqs4kLnE7tqEQhmp49BgC/5
         u4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VHvBgXQTEmDe94oFEb/1mhIUaXdt/Kv7BDHynzU+GkM=;
        b=hWq5GuUl6bw2Uxi1Bbri8r/behv1F1oty++EEWcwVGxh1HPnxNeyZNgSjMcwPPgkqI
         D1h5yorlS1UFOqEUUfGCwl7CW8cfUPBbAbP1qnG+K6Qr1fOAJZ0Z1lkyNz1Rrg6zPqU4
         /R/1ArDcYXgX/U1RMh1LljGyfKFE7/OUZwdeduaRcx2KbMszN/3hWmrRRPbhQFpHfRG4
         +trXy6ul/ZJJxwwuVF0xDShLAmLLainWGgK1rgipIgfPtiSgQWObm9sE8fQDJ3nYHtQ2
         1PumT3Y+D4di43p1dZgL8lYiHJXcNkQ2cjq0lIvPRUlvDfDdwZgCSK0tBwPZEIOCOvLa
         mnbQ==
X-Gm-Message-State: AOAM530A0JfUiFFi7hdj/eaWl8P9HxwKi0CVXEvPgMsYoVQnmeyjinps
        XjtRjOL3dMUHHTM6a1jtaPc=
X-Google-Smtp-Source: ABdhPJzqekQ+Zq9/ZFV7pY7+1JxGzAW31Y7dDpg537PtjQ+u5rZ9S0bRlhE6Ti9AXzKewkwM2jxoAA==
X-Received: by 2002:a17:903:1112:b0:13d:ce49:e275 with SMTP id n18-20020a170903111200b0013dce49e275mr20905901plh.5.1632713717447;
        Sun, 26 Sep 2021 20:35:17 -0700 (PDT)
Received: from localhost.localdomain ([210.99.160.97])
        by smtp.googlemail.com with ESMTPSA id r206sm1404320pfc.218.2021.09.26.20.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 20:35:17 -0700 (PDT)
From:   MichelleJin <shjy180909@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, johannes@sipsolutions.net
Cc:     saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        paulb@nvidia.com, ozsh@nvidia.com, lariel@nvidia.com,
        cmi@nvidia.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH net-next v4 2/3] net: ipv6: check return value of rhashtable_init
Date:   Mon, 27 Sep 2021 03:34:56 +0000
Message-Id: <20210927033457.1020967-3-shjy180909@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927033457.1020967-1-shjy180909@gmail.com>
References: <20210927033457.1020967-1-shjy180909@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When rhashtable_init() fails, it returns -EINVAL.
However, since error return value of rhashtable_init is not checked,
it can cause use of uninitialized pointers.
So, fix unhandled errors of rhashtable_init.

Signed-off-by: MichelleJin <shjy180909@gmail.com>
---

v1->v2:
 - change commit message
 - fix possible memory leaks
v2->v3:
 - nothing changed
v3->v4:
 - fix newly created warnings due to patches

 net/ipv6/ila/ila_xlat.c | 6 +++++-
 net/ipv6/seg6.c         | 8 ++++++--
 net/ipv6/seg6_hmac.c    | 4 +---
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/ila/ila_xlat.c b/net/ipv6/ila/ila_xlat.c
index a1ac0e3d8c60..47447f0241df 100644
--- a/net/ipv6/ila/ila_xlat.c
+++ b/net/ipv6/ila/ila_xlat.c
@@ -610,7 +610,11 @@ int ila_xlat_init_net(struct net *net)
 	if (err)
 		return err;
 
-	rhashtable_init(&ilan->xlat.rhash_table, &rht_params);
+	err = rhashtable_init(&ilan->xlat.rhash_table, &rht_params);
+	if (err) {
+		free_bucket_spinlocks(ilan->xlat.locks);
+		return err;
+	}
 
 	return 0;
 }
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index e412817fba2f..65744f2d38da 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -374,7 +374,11 @@ static int __net_init seg6_net_init(struct net *net)
 	net->ipv6.seg6_data = sdata;
 
 #ifdef CONFIG_IPV6_SEG6_HMAC
-	seg6_hmac_net_init(net);
+	if (seg6_hmac_net_init(net)) {
+		kfree(sdata);
+		kfree(rcu_dereference_raw(sdata->tun_src));
+		return -ENOMEM;
+	};
 #endif
 
 	return 0;
@@ -388,7 +392,7 @@ static void __net_exit seg6_net_exit(struct net *net)
 	seg6_hmac_net_exit(net);
 #endif
 
-	kfree(sdata->tun_src);
+	kfree(rcu_dereference_raw(sdata->tun_src));
 	kfree(sdata);
 }
 
diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 687d95dce085..29bc4e7c3046 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -405,9 +405,7 @@ int __net_init seg6_hmac_net_init(struct net *net)
 {
 	struct seg6_pernet_data *sdata = seg6_pernet(net);
 
-	rhashtable_init(&sdata->hmac_infos, &rht_params);
-
-	return 0;
+	return rhashtable_init(&sdata->hmac_infos, &rht_params);
 }
 EXPORT_SYMBOL(seg6_hmac_net_init);
 
-- 
2.25.1

