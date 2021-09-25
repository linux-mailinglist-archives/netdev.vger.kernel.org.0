Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83229417FEC
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 08:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347893AbhIYGM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 02:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237935AbhIYGM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 02:12:27 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E482BC061571
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 23:10:52 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id v19so8505476pjh.2
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 23:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=evgpOq/tUT6luz1Zb6y56qQqUaFaphWVWqgD8ctVR2k=;
        b=jhNizGgxkoyqoTZsv3bByEnduxFC0rYXOBzvZxg2SECp5uSC4WtDwWWbXJIq0IDdpy
         YX6fB+NjKg5hxp2n1+dvZF9Q6pNUiDBuk8kF+B1OjmfkUZCQ8MzZNjloiOU/lC/IKQc4
         aTjLMMt2dzxGjR9CYnmrVs4oB2+TKmG+tiCOQor/iED5peYS8MfhGxAdjILNb6uB2yBV
         A/L7/MeGuV7qrmU5imgzpOr9FMstFYnKmTW5RWTg+6NwnR0s563nJAVtdOCnUhPAcoV4
         FrCZch/raTZSwSIqy/9Oa6j84M1kNwYK76yGggsHp2eZRFYKP0975Hm1yrU/+iXhMDyW
         nXuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=evgpOq/tUT6luz1Zb6y56qQqUaFaphWVWqgD8ctVR2k=;
        b=lKYi+DDmwkcho07/O2qNZFeBuKmzhR3VxLYPqRrIXi3a3VyIrtlxxUZH8giX+uP/15
         F5ZI7f7wYdSQWD3TSFyaFnaDppnN0NxtSyD1GirZWXva7sd8AuT5RuAqS/vm+rWmBj3D
         vj+aT5I2cxG1g1MQrLFAZzwU5uQqh4wd9y1FI+ub9oNy/LqcMECSffUMuCfvO7SnrA7i
         K42QC67Fi7EBixSker515zTVb2B5xt5YA9bq+JxZmGZzSmsJoDvNXjZThjQbvIKr2+r8
         6tXeqO6pVmy9WOsLYXf4gm1O3XOOZC3bcYJjKzg57Qj02KgXOR9xCoqvv/pFUXST7Vyn
         RVAg==
X-Gm-Message-State: AOAM530Enw+hlaS3QSNXwgUq+nMEig61YmpET3Bh2h0bqdLd1u8fmTkT
        l56VLMGPwr41PY32usWI5fo=
X-Google-Smtp-Source: ABdhPJzApWVxV32XdQay9wHRb3dSucZT6EZ4FSQQChmtOW6zPjHuAWgTbGs7CeCQb9FFUVVY2dtzSQ==
X-Received: by 2002:a17:90a:f190:: with SMTP id bv16mr6786714pjb.76.1632550252448;
        Fri, 24 Sep 2021 23:10:52 -0700 (PDT)
Received: from localhost.localdomain ([1.234.131.174])
        by smtp.googlemail.com with ESMTPSA id s10sm12948169pjn.38.2021.09.24.23.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 23:10:52 -0700 (PDT)
From:   MichelleJin <shjy180909@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, johannes@sipsolutions.net
Cc:     saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        paulb@nvidia.com, ozsh@nvidia.com, vladbu@nvidia.com,
        lariel@nvidia.com, cmi@nvidia.com, netdev@vger.kernel.org
Subject: [PATCH net-next v3 1/3] net/mlx5e: check return value of rhashtable_init
Date:   Sat, 25 Sep 2021 06:10:35 +0000
Message-Id: <20210925061037.4555-2-shjy180909@gmail.com>
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
 - fix unneeded destroying of ht
v2->v3:
 - nothing changed

 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

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
-- 
2.25.1

