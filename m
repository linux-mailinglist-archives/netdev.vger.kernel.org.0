Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECB763CE93
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbiK3FMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbiK3FME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:12:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E31654EA
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:12:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43EEEB81886
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 05:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBFBC433C1;
        Wed, 30 Nov 2022 05:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669785120;
        bh=QG27laM/ERu17Bh5Eb82M7V64R7lOjhYo0MlblWrarE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/dyxO9bUL6nGZ1TBjjY2RkGqjWA4ACxFF1Gj4iSbV7tUmIbJ+ccwj3xVYulVZx2r
         nEfUa4hEHMHCAcU9ntwSfIL4GQCgRUWvr+Cxkmmpy0jH/9uQGXMeVES/ai25exk60e
         e6JJVjCHwBHJ2Q1qSpqgrJRfip6LmlF0mQbEmNCGFzeldG2ir7ROCDA+3TFJ5a2x3k
         cqT1U4DtK7VR1S6Ui8ffr40XCx9Wiq8LR1zEF47VGLy329ra2vRstoeST1K3cijsAj
         Odz7kbbx5uLdzVNaiS41ZBb62ZHomfs/vd/mc1CwyPcllmapiqdEE/VguPcYuyGE3m
         nvnJZR2df7q/Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [net-next 02/15] net/mlx5e: Replace zero-length arrays with DECLARE_FLEX_ARRAY() helper
Date:   Tue, 29 Nov 2022 21:11:39 -0800
Message-Id: <20221130051152.479480-3-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130051152.479480-1-saeed@kernel.org>
References: <20221130051152.479480-1-saeed@kernel.org>
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

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

Zero-length arrays are deprecated and we are moving towards adopting
C99 flexible-array members, instead. So, replace zero-length arrays
declarations in anonymous union with the new DECLARE_FLEX_ARRAY()
helper macro.

This helper allows for flexible-array members in unions.

Link: https://github.com/KSPP/linux/issues/193
Link: https://github.com/KSPP/linux/issues/222
Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 48241317a535..0db41fa4a9a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -97,8 +97,8 @@ struct mlx5_flow_attr {
 	} lag;
 	/* keep this union last */
 	union {
-		struct mlx5_esw_flow_attr esw_attr[0];
-		struct mlx5_nic_flow_attr nic_attr[0];
+		DECLARE_FLEX_ARRAY(struct mlx5_esw_flow_attr, esw_attr);
+		DECLARE_FLEX_ARRAY(struct mlx5_nic_flow_attr, nic_attr);
 	};
 };
 
-- 
2.38.1

