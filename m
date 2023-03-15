Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1656BBBE5
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 19:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbjCOSTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 14:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbjCOSTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 14:19:32 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88ACB60412
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 11:19:31 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id c19so17158552qtn.13
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 11:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1678904371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y6P3avYFLfmZWtirttMewFieZIFd8qLJc55Dm6AWaNQ=;
        b=AfJO3WF6GZ+yRdTZNjn5moqlE0pcfcwzJyR8ecGuewfHyPT8CvRJVgvhX9FiypD/QW
         4t/r8YuGdxUFqFX4s51NsQEsnlk7EzA/hmPFQFKgHtdisgnd9MzLrJ6+3B7j282f7ItC
         f4V0U1tDhWGzVLkggiaSkFqTi3L4T7gF+mFrc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678904371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y6P3avYFLfmZWtirttMewFieZIFd8qLJc55Dm6AWaNQ=;
        b=v2jefdgLHkJBREkGzn2ij1ENvcr6QAS+yTaYsa0Wf/Rg/yA9Uqx2kW/DGBHIwhmJ8N
         k5lsLcVCFB/DOEgBOSCYlCyyXYe6kTr3ZZ89UEfxl8KqpIZksaEGMLLFYV9YqSmUPO4x
         ZsRarYd56wcP4M6L1YjnhU/cIpIcg88uU5eh0QiVo6OcdYR9QL3b9HiTvwn7pt8TR9JA
         uW2B3hamK/8sH/dBH+M45aB4Jwv/atHHAao0cotJPkrJpPqYJUV0HjYGUmdBMvTRxiS0
         FiNpc0czzYTJmV/QFQ9TZ9Cmd+0RuLlF78yusGXDpYEt8hnv6EzVescQ4XwRApk600A+
         IWjw==
X-Gm-Message-State: AO0yUKVqst9lzWq3i/MoTUXMAnZDh03kE4qH0bP53HdKf79pbXgRRljA
        drKhwIO1UUUJSp4qkwJBJwnKzw==
X-Google-Smtp-Source: AK7set/KQrtDeKLTF6TrIljAt+eNWc5kdtu2hQ8C4MazFU3GCyoPdEgAjOM7vonPV/MkIpsla8vYNg==
X-Received: by 2002:ac8:5e0c:0:b0:3b8:6a20:675e with SMTP id h12-20020ac85e0c000000b003b86a20675emr1472979qtx.29.1678904370959;
        Wed, 15 Mar 2023 11:19:30 -0700 (PDT)
Received: from joelboxx.c.googlers.com.com (129.239.188.35.bc.googleusercontent.com. [35.188.239.129])
        by smtp.gmail.com with ESMTPSA id v125-20020a379383000000b007458ae32290sm4113974qkd.128.2023.03.15.11.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 11:19:30 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>
Cc:     "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/14] net/mlx5: Rename kfree_rcu() to kfree_rcu_mightsleep()
Date:   Wed, 15 Mar 2023 18:18:53 +0000
Message-Id: <20230315181902.4177819-6-joel@joelfernandes.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230315181902.4177819-1-joel@joelfernandes.org>
References: <20230315181902.4177819-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>

The kfree_rcu() and kvfree_rcu() macros' single-argument forms are
deprecated.  Therefore switch to the new kfree_rcu_mightsleep() and
kvfree_rcu_mightsleep() variants. The goal is to avoid accidental use
of the single-argument forms, which can introduce functionality bugs in
atomic contexts and latency bugs in non-atomic contexts.

Cc: Ariel Levkovich <lariel@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/int_port.c  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/int_port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/int_port.c
index ca834bbcb44f..8afcec0c5d3c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/int_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/int_port.c
@@ -242,7 +242,7 @@ mlx5e_int_port_remove(struct mlx5e_tc_int_port_priv *priv,
 		mlx5_del_flow_rules(int_port->rx_rule);
 	mapping_remove(ctx, int_port->mapping);
 	mlx5e_int_port_metadata_free(priv, int_port->match_metadata);
-	kfree_rcu(int_port);
+	kfree_rcu_mightsleep(int_port);
 	priv->num_ports--;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 08d0929e8260..b811dad7370a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -670,7 +670,7 @@ static int mlx5e_macsec_del_txsa(struct macsec_context *ctx)
 
 	mlx5e_macsec_cleanup_sa(macsec, tx_sa, true);
 	mlx5_destroy_encryption_key(macsec->mdev, tx_sa->enc_key_id);
-	kfree_rcu(tx_sa);
+	kfree_rcu_mightsleep(tx_sa);
 	macsec_device->tx_sa[assoc_num] = NULL;
 
 out:
@@ -849,7 +849,7 @@ static void macsec_del_rxsc_ctx(struct mlx5e_macsec *macsec, struct mlx5e_macsec
 	xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
 	metadata_dst_free(rx_sc->md_dst);
 	kfree(rx_sc->sc_xarray_element);
-	kfree_rcu(rx_sc);
+	kfree_rcu_mightsleep(rx_sc);
 }
 
 static int mlx5e_macsec_del_rxsc(struct macsec_context *ctx)
-- 
2.40.0.rc1.284.g88254d51c5-goog

