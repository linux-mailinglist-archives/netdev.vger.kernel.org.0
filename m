Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB156640EFA
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbiLBUP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234804AbiLBUPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:15:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F6073F6E
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:15:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D32F3CE1FA6
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5BAC433C1;
        Fri,  2 Dec 2022 20:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670012118;
        bh=MnUh2Fcy/iHgetl3SXMZVAKdAtTQTJOiJZMfHYezmks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFdE7FqlgRvA3GxgBM8TIa2hIE17cwXpR7pTovQHNEN9Et0c39kz5LvTYH9PDhRQE
         QQo1HsK14veGq72RDd+oM6fAOsBhDHlyBYGkJZoMZh9dmFgbZjXNnyTCblFUaQaCb3
         PjTrwGnjosQJH4jwPXxcAW7l+P5sEZJlbpYoJsVYfFuyG01KDJ3GKtZBjwy/Bro2Hx
         TMGOmvDRl6W/8MipghILwSLbjCWUVN6aIqDroOCL4UPAbushgXSq2fhAFfarP9kLuE
         otUSeoXYt67x0oqgJq13DszJ4OJVSO+X6VH3vA2mSbcFuIj62S6ssbcygMT6l+VfbR
         UAy9EnLMAXJmQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 03/13] net/mlx5e: Use same coding pattern for Rx and Tx flows
Date:   Fri,  2 Dec 2022 22:14:47 +0200
Message-Id: <18d9cd5a19350ed10569e2df59dfd7b1a97ec1ad.1670011885.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011885.git.leonro@nvidia.com>
References: <cover.1670011885.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Remove intermediate variable in favor of having similar coding style
for Rx and Tx add rule functions.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 27f866a158de..893c1862e211 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -482,7 +482,6 @@ static int setup_modify_header(struct mlx5_core_dev *mdev, u32 val, u8 dir,
 
 static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
-	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
 	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
@@ -532,8 +531,8 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	}
 	kvfree(spec);
 
-	ipsec_rule->rule = rule;
-	ipsec_rule->modify_hdr = flow_act.modify_hdr;
+	sa_entry->ipsec_rule.rule = rule;
+	sa_entry->ipsec_rule.modify_hdr = flow_act.modify_hdr;
 	return 0;
 
 err_add_flow:
-- 
2.38.1

