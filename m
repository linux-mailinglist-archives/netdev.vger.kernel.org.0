Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E52A595A0B
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234528AbiHPL0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233935AbiHPL0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:26:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C13E8309
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:41:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74427B8169C
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B51BC433C1;
        Tue, 16 Aug 2022 10:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646465;
        bh=ABTs+YNaAJRKcKFsvUq9IV2SM39Q33pp0EyotdAKAr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AGid7ioj80HQ+xmzObNNkCH85+Rhbs3oHoCfScEKvxZY/QgGFXlAAkisJQYfXo2nV
         SCJEb3uTHgN8UN3CN5N6hJjYMGlCbw8eWHilMbxhvQDnD8kJE8Yelhow4glW7942gn
         a6wJ5zmrQVnh7mS/3sv6u764wTm5nM6tGrlh2E1Na7a/FIkMV2AA0hiYcQlPIeYRuD
         hv4QcVi1HXpCcjckftnVJ6Fs3wtWJ0gZELApRdHg/xL8EwiQZ/6vwAOy/UZXSFti8e
         6zZW28j8kNDfCQCopVbO3PcrxQbKm8UknvSI6QFxlBQeqbAIUKfBIQYX4AFHsVNJyg
         9DxKXKLXnjakw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 21/26] net/mlx5e: Use same coding pattern for Rx and Tx flows
Date:   Tue, 16 Aug 2022 13:38:09 +0300
Message-Id: <3a8d57c990569d05ccd3573ebf2e86bd8f222bcb.1660641154.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1660641154.git.leonro@nvidia.com>
References: <cover.1660641154.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Remove intermediate variable in favour of having similar coding style
for Rx and Tx add rule functions.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index eb08175f41b8..6911f0b962ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -486,7 +486,6 @@ static int setup_modify_header(struct mlx5_core_dev *mdev, u32 val, u8 dir,
 
 static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
-	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
 	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
@@ -535,8 +534,8 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	}
 	kvfree(spec);
 
-	ipsec_rule->rule = rule;
-	ipsec_rule->modify_hdr = flow_act.modify_hdr;
+	sa_entry->ipsec_rule.rule = rule;
+	sa_entry->ipsec_rule.modify_hdr = flow_act.modify_hdr;
 	return 0;
 
 err_add_flow:
-- 
2.37.2

