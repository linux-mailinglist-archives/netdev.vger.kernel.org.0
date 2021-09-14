Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861CC40B465
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 18:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbhINQU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 12:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhINQU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 12:20:28 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F67C061764;
        Tue, 14 Sep 2021 09:19:11 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r2so13192968pgl.10;
        Tue, 14 Sep 2021 09:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SPe9Gq3rQeNmjwlopYRqoVmk2NhxavVv7k/FHKOjP9U=;
        b=l9bTCaAKabfMQeg+UC5FYFsUZ6EE+yKH8m1kdgxUElTSNojq8BH7eaIDZp8VSOgNS1
         ltDbe5Nxo8NzstfDicJgXFj/dgZEBF8w0nHjRQHL5nkB1o75X+AHgJXTWMEQezJUg+xc
         21dmSUkSiUQ08/vvJOXpTrkCKKqcu0BUprL2DDSBW9BFuMH82UJ0hodG59kieRgX0hV9
         eH5O1wp4w9ixxF9MjZxkmxiHwRzEL9v/kapAeeFJPbJubHHDQue6p+Q3KI5tJU6bJjK8
         7chBEHbpuA3JN5ki5C4ijuKYSZnEWFHo5klE6HmrFQIcNDc6IK1uy63f8bRS3XzDlm+W
         GQqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SPe9Gq3rQeNmjwlopYRqoVmk2NhxavVv7k/FHKOjP9U=;
        b=1aOKsJlDPu723M5WPUoxN/9CHk4PdEava3+u+qgHyPEpBbb7xUyKxp4c/y+jujH1Tp
         FrHXDSDd6i5RcnuDykt2ITerXvemXpKCOVijUMDenEYN8V7Zm8Pl6eAVGD41qygMx8JY
         MKRZd9jRacqZZZjQksR1qlodrlCa13PElqbxl3QH+JcUvSi9XKMCDuZNZty48qZchd13
         ATQQEYwL373eNXwZQwWq6rGrcRgERrpeHPspg79AB+y8kWmqh1/OWTeG5Fc8zmzgo/K7
         q5Z2oJhJr0yiwYufov/zALQKxPacRJq+0KyzMG45x8IEOwtouTrrpTh8W2vXQ+7cUWSH
         +Ehg==
X-Gm-Message-State: AOAM532RVEz6o9FUpbD8nrzpdDIvqfCGbwFG/T2NCYgVmA5lAOGww/wB
        2MBonWlEFYq9nEFWOanigXk=
X-Google-Smtp-Source: ABdhPJz6cL93BvhyRqSwtPTBvS3LdxvtkwjlUHEaGb7pz+LOIxnmennP90VFJs0BQpX45kX+YOcdhQ==
X-Received: by 2002:a05:6a00:1881:b0:3fa:7d56:c611 with SMTP id x1-20020a056a00188100b003fa7d56c611mr5571749pfh.8.1631636350656;
        Tue, 14 Sep 2021 09:19:10 -0700 (PDT)
Received: from localhost.localdomain ([223.39.130.38])
        by smtp.googlemail.com with ESMTPSA id ga24sm2141476pjb.41.2021.09.14.09.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 09:19:10 -0700 (PDT)
From:   MichelleJin <shjy180909@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, johannes@sipsolutions.net
Cc:     saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        paulb@nvidia.com, lariel@nvidia.com, ozsh@nvidia.com,
        vladbu@nvidia.com, cmi@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH net-next] net: check return value of rhashtable_init
Date:   Tue, 14 Sep 2021 16:18:53 +0000
Message-Id: <20210914161853.4305-1-shjy180909@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handling errors of rhashtable_init.

When rhashtable_init fails, it returns -EINVAL.

Signed-off-by: MichelleJin <shjy180909@gmail.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc_ct.c    | 15 ++++++++++++---
 net/ipv6/ila/ila_xlat.c                           |  4 +++-
 net/ipv6/seg6_hmac.c                              |  6 +++++-
 net/mac80211/mesh_pathtbl.c                       |  3 ++-
 4 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 6c949abcd2e1..5ae3b97df10e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -2127,12 +2127,21 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 
 	ct_priv->post_act = post_act;
 	mutex_init(&ct_priv->control_lock);
-	rhashtable_init(&ct_priv->zone_ht, &zone_params);
-	rhashtable_init(&ct_priv->ct_tuples_ht, &tuples_ht_params);
-	rhashtable_init(&ct_priv->ct_tuples_nat_ht, &tuples_nat_ht_params);
+	if (rhashtable_init(&ct_priv->zone_ht, &zone_params))
+		goto err_ct_zone_ht;
+	if (rhashtable_init(&ct_priv->ct_tuples_ht, &tuples_ht_params))
+		goto err_ct_tuples_ht;
+	if (rhashtable_init(&ct_priv->ct_tuples_nat_ht, &tuples_nat_ht_params))
+		goto err_ct_tuples_nat_ht;
 
 	return ct_priv;
 
+err_ct_tuples_nat_ht:
+	rhashtable_destroy(&ct_priv->ct_tuples_nat_ht);
+err_ct_tuples_ht:
+	rhashtable_destroy(&ct_priv->ct_tuples_ht);
+err_ct_zone_ht:
+	rhashtable_destroy(&ct_priv->zone_ht);
 err_ct_nat_tbl:
 	mlx5_chains_destroy_global_table(chains, ct_priv->ct);
 err_ct_tbl:
diff --git a/net/ipv6/ila/ila_xlat.c b/net/ipv6/ila/ila_xlat.c
index a1ac0e3d8c60..481d475353ea 100644
--- a/net/ipv6/ila/ila_xlat.c
+++ b/net/ipv6/ila/ila_xlat.c
@@ -610,7 +610,9 @@ int ila_xlat_init_net(struct net *net)
 	if (err)
 		return err;
 
-	rhashtable_init(&ilan->xlat.rhash_table, &rht_params);
+	err = rhashtable_init(&ilan->xlat.rhash_table, &rht_params);
+	if (err)
+		return err;
 
 	return 0;
 }
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
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index efbefcbac3ac..3ef5d6e00410 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -60,7 +60,8 @@ static struct mesh_table *mesh_table_alloc(void)
 	atomic_set(&newtbl->entries,  0);
 	spin_lock_init(&newtbl->gates_lock);
 	spin_lock_init(&newtbl->walk_lock);
-	rhashtable_init(&newtbl->rhead, &mesh_rht_params);
+	if (rhashtable_init(&newtbl->rhead, &mesh_rht_params))
+		return NULL;
 
 	return newtbl;
 }
-- 
2.25.1

