Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEB9415EE1
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241135AbhIWMzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241146AbhIWMz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:55:29 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74815C061757
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 05:53:29 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id me1so4369619pjb.4
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 05:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6S52Ys+pIOFDZrTPYwBj6L1G40TE50YDMH25HW5/Kro=;
        b=Cuzk9Szk5oAqRhMzz16cPwixlKWo5eodDYx913w1Q44IZyRxruVw5MwQN4km5USqfA
         Im+yx2l/ciatPYcRH33F5oTNbrLzHHUcGWuitXffZO0JvdN4INWeIJVRXiiop1sA1c0w
         JmrAtlWiulMbbmh9MUhLhe/BPgPg/B0iUt+sp0imgzIaNJT9ZgJaxCAj+FbRhwyxLLbe
         Cw3sYN+jO2mpRe00FJgSejrT+LB6/dSiyLO8r4y7wqJuduIvsxaT1mZ//QPipcTxLkIM
         wD+xpuCh9EZkmalTnmjt9jxvpSSPZBZ0UBs+8piNhoaEECmiQd1ylH0OWZn3FHHR8qp1
         IEWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6S52Ys+pIOFDZrTPYwBj6L1G40TE50YDMH25HW5/Kro=;
        b=0ClVm9/1NFYrUItzZyiPV5akw0VfGmbetDiMxilrKP76yVxUSLvTlNtVuKDahdBKQa
         FheRQ5B7f9U94RCXWXHw62/qzt3/PyAQC6dEMpE/2OhBj53PnoOls9Pn8Cx0AFlfFrro
         XpK3nGuFuqdjdGszHxH8t6STJl3ZU4hzrmjCFPJd/EbtRAGupuXW+BW3tgNBgPr564Tc
         EjaAeIUg65YKGIiOBv5IDZ4w1AoVBsgpfpms8f4SqmdhDTGsqcVaY0cZJ6fm5neVt2In
         m0bzQDZmEwfu/gDNNCruMPwYioL9YiPJAvE7SjP343Vk3bIn/HBnhy5+F/OL2Z0110F+
         vzcQ==
X-Gm-Message-State: AOAM530waByiLURPsOPrK2eyk+qo1ANH7U5MtmQB3nWLrqn6N6xqwDc2
        FZ1ZK8huq5JZDMz0pTh/jPU=
X-Google-Smtp-Source: ABdhPJwFbucy6oqXx6wVAu8EidsH4kwIawKS+Tisg5dHNGh5vhcbH76QF7GsJf6KdbQfuHwBIFAo1g==
X-Received: by 2002:a17:902:6848:b0:13a:46e1:2195 with SMTP id f8-20020a170902684800b0013a46e12195mr4024459pln.80.1632401608809;
        Thu, 23 Sep 2021 05:53:28 -0700 (PDT)
Received: from localhost.localdomain ([223.62.215.94])
        by smtp.googlemail.com with ESMTPSA id w206sm5776629pfc.45.2021.09.23.05.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 05:53:28 -0700 (PDT)
From:   MichelleJin <shjy180909@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, johannes@sipsolutions.net
Cc:     saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        paulb@nvidia.com, lariel@nvidia.com, ozsh@nvidia.com,
        cmi@nvidia.com, netdev@vger.kernel.org
Subject: [PATCH v2] net: check return value of rhashtable_init
Date:   Thu, 23 Sep 2021 12:53:17 +0000
Message-Id: <20210923125317.9430-1-shjy180909@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When rhashtable_init() fails, it returns -EINVAL.
However, since error return value of rhashtable_init is not checked,
it can cause use of uninitialized pointers.
So, fix unhandled errors of rhashtable_init and possible memory leaks.

Signed-off-by: MichelleJin <shjy180909@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 14 +++++++++++---
 net/ipv6/ila/ila_xlat.c                            |  6 +++++-
 net/ipv6/seg6.c                                    |  6 +++++-
 net/ipv6/seg6_hmac.c                               |  6 +++++-
 net/mac80211/mesh_pathtbl.c                        |  5 ++++-
 5 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 6c949abcd2e1..225748a9e52a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -2127,12 +2127,20 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 
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
+	rhashtable_destroy(&ct_priv->ct_tuples_ht);
+err_ct_tuples_ht:
+	rhashtable_destroy(&ct_priv->zone_ht);
+err_ct_zone_ht:
 err_ct_nat_tbl:
 	mlx5_chains_destroy_global_table(chains, ct_priv->ct);
 err_ct_tbl:
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
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index efbefcbac3ac..7cab1cf09bf1 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -60,7 +60,10 @@ static struct mesh_table *mesh_table_alloc(void)
 	atomic_set(&newtbl->entries,  0);
 	spin_lock_init(&newtbl->gates_lock);
 	spin_lock_init(&newtbl->walk_lock);
-	rhashtable_init(&newtbl->rhead, &mesh_rht_params);
+	if (rhashtable_init(&newtbl->rhead, &mesh_rht_params)) {
+		kfree(newtbl);
+		return NULL;
+	}
 
 	return newtbl;
 }
-- 
2.25.1

