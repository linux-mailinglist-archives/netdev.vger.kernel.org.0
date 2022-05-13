Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A94B5265B7
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348958AbiEMPMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348766AbiEMPMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:12:36 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA00F53711
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 08:12:31 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id AB52C206A6;
        Fri, 13 May 2022 17:12:29 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FD8yEmXb-2_w; Fri, 13 May 2022 17:12:29 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 9363A2067A;
        Fri, 13 May 2022 17:12:27 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 8E68980004A;
        Fri, 13 May 2022 17:12:27 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 13 May 2022 17:12:27 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 13 May
 2022 17:12:26 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 5BFF23182D48; Fri, 13 May 2022 17:12:26 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 7/8] net/mlx5e: Use XFRM state direction instead of flags
Date:   Fri, 13 May 2022 17:12:17 +0200
Message-ID: <20220513151218.4010119-8-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220513151218.4010119-1-steffen.klassert@secunet.com>
References: <20220513151218.4010119-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Convert mlx5 driver to use XFRM state direction.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c   | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 35e2bb301c26..2a8fd7020622 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -172,9 +172,9 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	}
 
 	/* action */
-	attrs->action = (!(x->xso.flags & XFRM_OFFLOAD_INBOUND)) ?
-			MLX5_ACCEL_ESP_ACTION_ENCRYPT :
-			MLX5_ACCEL_ESP_ACTION_DECRYPT;
+	attrs->action = (x->xso.dir == XFRM_DEV_OFFLOAD_OUT) ?
+				MLX5_ACCEL_ESP_ACTION_ENCRYPT :
+				      MLX5_ACCEL_ESP_ACTION_DECRYPT;
 	/* flags */
 	attrs->flags |= (x->props.mode == XFRM_MODE_TRANSPORT) ?
 			MLX5_ACCEL_ESP_FLAGS_TRANSPORT :
@@ -306,7 +306,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	if (err)
 		goto err_hw_ctx;
 
-	if (x->xso.flags & XFRM_OFFLOAD_INBOUND) {
+	if (x->xso.dir == XFRM_DEV_OFFLOAD_IN) {
 		err = mlx5e_ipsec_sadb_rx_add(sa_entry);
 		if (err)
 			goto err_add_rule;
@@ -333,7 +333,7 @@ static void mlx5e_xfrm_del_state(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
 
-	if (x->xso.flags & XFRM_OFFLOAD_INBOUND)
+	if (x->xso.dir == XFRM_DEV_OFFLOAD_IN)
 		mlx5e_ipsec_sadb_rx_del(sa_entry);
 }
 
-- 
2.25.1

