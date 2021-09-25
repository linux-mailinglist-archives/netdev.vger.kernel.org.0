Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A25C417FE8
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 08:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhIYGHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 02:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347877AbhIYGHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 02:07:48 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A73AC061571
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 23:06:14 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id bj3-20020a17090b088300b0019e6603fe89so7683037pjb.4
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 23:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TmpginhE56GfTA3Y/sew6GC1tUGzSMzver7XcWXzMKw=;
        b=EbkGTsrLmPkhLa4yw+mlVOqGHfP13yK7nu77wStcGNfoPgpj4OcuoP3OCVxlTUKdqY
         1dHWKnBaNlIIwc2GdXkYfFbPyjzf8B1pgfjEBl19BUpX2ADl3VPGI9zUG4UIDy2pWm6K
         bL3H/E07KOoVmjW01UKrOjGKGUcZH27VDrjy4OGIziXXT7gkd9nIa5kXKbqjHaDn37AK
         k3tnaMWqyi68UCdjfo1YqEdEqBh8ie65WpWgezfsR2Yfcmqbb2LBzwq+n2Pt96ogRTa7
         xUOLEq2LK881Yl7u72/gmhy7Kt+WYvSo4kA0SqOMFsIDkZHHd4twhz+4DIuhlaoHtETd
         /aJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TmpginhE56GfTA3Y/sew6GC1tUGzSMzver7XcWXzMKw=;
        b=7734oU23/Joh+2F/CXM62xhs9BIccPUszJey3KQZjAFIUo/K+krDV4SPrakdt2PUxn
         fBYfUn68j40iQweFVpqk8mCnjv/BkOy1mWYymmctuUq3Sf1lKxBKJJfmTgZ6F0NwUJK4
         AaAUp+2/9jCDRRkaoL6tO4JC9A+skIGzkvFzbX7Q6T49fbtB2ue79vb5Ri6r1C0AFuEw
         x3XHrlH8/E4QYNOu+ornQJC3HUNXRG3V3ZkfZrEdN6437Z1HDvLTFatVfTBjU2R/gYj8
         uAYLGxDpQ0rZvcsZfMHzwpjvMfQX0lJCAGwjmQyOITweLDhkjQp6zS4xWfykHaYXe6Ah
         K8RA==
X-Gm-Message-State: AOAM531VHpjNfRe2/e9iSrXDfkyoIFVO0pgpmInKy9PFNhwZuq/bf4IW
        bW1O2t1jCw8q7XteYwWlU5U=
X-Google-Smtp-Source: ABdhPJw4MtSiKUOJE00oN/F38MpkH6k44WAYehrUETTxlHAiNFz3ajPESRsRw7G6C6R5rxm/hBbxhA==
X-Received: by 2002:a17:90a:5895:: with SMTP id j21mr6611701pji.99.1632549973802;
        Fri, 24 Sep 2021 23:06:13 -0700 (PDT)
Received: from localhost.localdomain ([1.234.131.174])
        by smtp.googlemail.com with ESMTPSA id 26sm13650587pgx.72.2021.09.24.23.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 23:06:13 -0700 (PDT)
From:   MichelleJin <shjy180909@gmail.com>
To:     avem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, johannes@sipsolutions.net
Cc:     saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        paulb@nvidia.com, ozsh@nvidia.com, vladbu@nvidia.com,
        lariel@nvidia.com, cmi@nvidia.com, netdev@vger.kernel.org
Subject: [PATCH net-next v3 2/3] net: ipv6: check return value of rhashtable_init
Date:   Sat, 25 Sep 2021 06:05:08 +0000
Message-Id: <20210925060509.4297-3-shjy180909@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210925060509.4297-1-shjy180909@gmail.com>
References: <20210925060509.4297-1-shjy180909@gmail.com>
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

