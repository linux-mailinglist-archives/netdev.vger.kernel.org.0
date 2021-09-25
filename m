Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DA5417FE7
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 08:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347867AbhIYGHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 02:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbhIYGHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 02:07:44 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F84CC061571
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 23:06:10 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id j15so6589462plh.7
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 23:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=evgpOq/tUT6luz1Zb6y56qQqUaFaphWVWqgD8ctVR2k=;
        b=o6UYET0m6/EGTZhXQJs9jFTUoGILkzXqXQ06fN926yglZGorBjh48J7jz6vmgINR+s
         ClrRwjEUUyYlxcBitlxK2+3bcf5s8mZRjqCWE+ykfX9J33CDomRBVlngRtbkhChjJyAR
         RYKmepU186lTTfOUptg2PS9/3+XCMc47Ojr47Xg+4uxDVJiBVZOrcqCjgIZAQLtNJuk2
         OiBX1JeQBsCUKCU/PpHDUP95tm2iuLZDfh59i6iX7TXmbbq9nNoJfjmfhbosNA+KTZBz
         MD1vjV6CJ3pOChCfDRUp575mTERUk3CHQW/d8NS9/P/hc8BWJVmkUgi5LvDkAvBh4HjJ
         7yRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=evgpOq/tUT6luz1Zb6y56qQqUaFaphWVWqgD8ctVR2k=;
        b=HwuKP2GexAL4hJK2Q3Qms80Dp8DuWezvg7zJwaUosWC18y4mqsBT5CuR6tPVsJXNhE
         iPMWuzNjT8U57hdF5RAXtpcgIk2WPI6Kh9WbnyvR+mFD9ga/a39a93b58DySDpADP7qe
         nAIf1NRyX3h/hGhXuLKml+I/hOmXLKoepbGTFUNpECPrRCc86Vn6grDv0TGLqpQB2IG+
         1NpytpZTXDZf8sAwpdSjrx9xC0Mk7IM6LUGmkwjM0Fepl0RNWjRIzSqhtTqVsilK3s1b
         a5EmWXNXSBXQpUPSgkCJ9bTkgAXu18oGKOuj7zx22FyWix58vf6bqJTtLw9YRDFJTh/G
         KZPw==
X-Gm-Message-State: AOAM533GwjiNZrDxaeB2RmICKwsIYXVZI+V1BMqE/6kDDrSZEm7XxQWU
        Zyo8Ri4C7NrzcP0o55z64XA=
X-Google-Smtp-Source: ABdhPJydeE/VQbCpPz480tNiOpUzOdK5gfL/ynkfKcy5JMaMz8euRz6dsIUfASorGI9G5QEUlTeMtw==
X-Received: by 2002:a17:90b:3904:: with SMTP id ob4mr6805805pjb.148.1632549969988;
        Fri, 24 Sep 2021 23:06:09 -0700 (PDT)
Received: from localhost.localdomain ([1.234.131.174])
        by smtp.googlemail.com with ESMTPSA id 26sm13650587pgx.72.2021.09.24.23.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 23:06:09 -0700 (PDT)
From:   MichelleJin <shjy180909@gmail.com>
To:     avem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, johannes@sipsolutions.net
Cc:     saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        paulb@nvidia.com, ozsh@nvidia.com, vladbu@nvidia.com,
        lariel@nvidia.com, cmi@nvidia.com, netdev@vger.kernel.org
Subject: [PATCH net-next v3 1/3] net/mlx5e: check return value of rhashtable_init
Date:   Sat, 25 Sep 2021 06:05:07 +0000
Message-Id: <20210925060509.4297-2-shjy180909@gmail.com>
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

