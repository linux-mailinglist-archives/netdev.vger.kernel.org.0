Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D010417FED
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 08:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347909AbhIYGMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 02:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237935AbhIYGMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 02:12:30 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B84C061571
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 23:10:56 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so11238598pjc.3
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 23:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TmpginhE56GfTA3Y/sew6GC1tUGzSMzver7XcWXzMKw=;
        b=ZKzs/SuLqGFQ/gK/lqx15O1MSL29gPXp5wAihVmKpcjGASHci0RYEQYKEhFx02P+De
         RPiQLpm1w2vkcAQcOiNKyLBDdnO6Fg/9VFeWluKcJesQT0iHdOktfNyF/wOJvxRZLoGc
         RrgiGWA6nPiT3hnnQ5rH0Q17JzLD8cXQdAky9yCQuYycWgOyUL8PQQMxLsPAS9iE783/
         GgJEdZpISuawLlVOPfnSI+j0tztsWFKgHNL+xh5jmLn9u/XgQrhZ1hvW1o6cKD7wEbXv
         3KpmMgVjR4LjIBq5o35ImDdrEEc7r1vcSZJNM3OOv/EOFapUpHvJ0sApm+ueaPggDz6N
         aQlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TmpginhE56GfTA3Y/sew6GC1tUGzSMzver7XcWXzMKw=;
        b=2i7hFWKM+uw/Gub4+yV2RhLNe+FqdxtcXDIOE+iBLT2rFHQ/qyigL0E4hA56CxL3aT
         sWzQeF/ui5beHQkONQNyFnz8yDY4s1hFPJVC7CpBSZUXwziXB2hH9GrlYmSSuwmy9nhZ
         6yQ9V/syMk89RucLORNPSLaH3WZKRv7Gm2oecCGXmUKzUEyzRqxxXIntj4Ejjq7eAQMx
         DZSTHXSgYzeHqVPFgXhiMHzvswa4ZDp3kBgPIAVCkgKAHYlBbAT0HLMOhSxMKIiD/4do
         SLr1mRFyjsxrkqu0mRXegRK2vHtys6mhfyMFt1S089snmzzpB6H25r+igiPL75rtFo+x
         ul8Q==
X-Gm-Message-State: AOAM533mBtmE0YoGemP5f6QRRxXhQN4/MCUhs7+At/RI6MxsjyNH506w
        9eJI3cdLUBNx6hlBTydrsys=
X-Google-Smtp-Source: ABdhPJzN4z4M0+DTpFoozCLC2uN5a/zoxZZoOxXJN/NFdgy2DFktOTfKDt5xxDR1FBuO0z4Em9s7tg==
X-Received: by 2002:a17:90a:514b:: with SMTP id k11mr6813319pjm.152.1632550256201;
        Fri, 24 Sep 2021 23:10:56 -0700 (PDT)
Received: from localhost.localdomain ([1.234.131.174])
        by smtp.googlemail.com with ESMTPSA id s10sm12948169pjn.38.2021.09.24.23.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 23:10:55 -0700 (PDT)
From:   MichelleJin <shjy180909@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, johannes@sipsolutions.net
Cc:     saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        paulb@nvidia.com, ozsh@nvidia.com, vladbu@nvidia.com,
        lariel@nvidia.com, cmi@nvidia.com, netdev@vger.kernel.org
Subject: [PATCH net-next v3 2/3] net: ipv6: check return value of rhashtable_init
Date:   Sat, 25 Sep 2021 06:10:36 +0000
Message-Id: <20210925061037.4555-3-shjy180909@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210925061037.4555-1-shjy180909@gmail.com>
References: <20210925061037.4555-1-shjy180909@gmail.com>
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

 net/ipv6/ila/ila_xlat.c | 6 +++++-
 net/ipv6/seg6.c         | 6 +++++-
 net/ipv6/seg6_hmac.c    | 6 +++++-
 3 files changed, 15 insertions(+), 3 deletions(-)

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
index e412817fba2f..89a87da141b6 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -374,7 +374,11 @@ static int __net_init seg6_net_init(struct net *net)
 	net->ipv6.seg6_data = sdata;
 
 #ifdef CONFIG_IPV6_SEG6_HMAC
-	seg6_hmac_net_init(net);
+	if (seg6_hmac_net_init(net)) {
+		kfree(sdata);
+		kfree(sdata->tun_src);
+		return -ENOMEM;
+	};
 #endif
 
 	return 0;
diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 687d95dce085..a78554993163 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -403,9 +403,13 @@ EXPORT_SYMBOL(seg6_hmac_init);
 
 int __net_init seg6_hmac_net_init(struct net *net)
 {
+	int err;
+
 	struct seg6_pernet_data *sdata = seg6_pernet(net);
 
-	rhashtable_init(&sdata->hmac_infos, &rht_params);
+	err = rhashtable_init(&sdata->hmac_infos, &rht_params);
+	if (err)
+		return err;
 
 	return 0;
 }
-- 
2.25.1

