Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C373468A95A
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 11:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbjBDKJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 05:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbjBDKJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 05:09:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97F869B1E
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 02:09:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2FF660C03
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 10:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10310C4339B;
        Sat,  4 Feb 2023 10:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675505368;
        bh=3hF9IsS9PdAq+H9832Ntqu/oHf0XlfYBl3dbUJbJsI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=plubZMhl0KnJ14+9bc/Cx4APnquOmSWez1zcrJT79K6ByyPZJlouX/+TzvW8tyXdG
         jaYDL7JN7Y+jVfTHhPNBUmb02sJ6plIJ6raRf0Xp7Rb6oDa++jgW929j5ED0pCoxkM
         A7oo5KioTYMk919h9EbAPxupr1bVY1QxK3Jxa9i2hPqBGZto/+SZEJQ+xtzjM4q7UL
         ATnYt3xncksgTsNd0FbkHJHEb6xWpx3D7KCTbmuwo/Fbs5rQKPUHLsZ9E3CykESwFI
         sk0jrYB0piMxebKjRKISiTPaavpJf1fjRcD7RddWfMECqLabRjL6lDwIhWP0FBS+72
         Quq5/qJYoMldQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Dragos Tatulea <dtatulea@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: IPoIB, Add support for XDR speed
Date:   Sat,  4 Feb 2023 02:08:52 -0800
Message-Id: <20230204100854.388126-14-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230204100854.388126-1-saeed@kernel.org>
References: <20230204100854.388126-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dragos Tatulea <dtatulea@nvidia.com>

Add XDR IB PTYS coding and XDR speed 200Gbps.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index eff92dc0927c..11fefb99d685 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -172,6 +172,7 @@ enum mlx5_ptys_rate {
 	MLX5_PTYS_RATE_EDR	= 1 << 5,
 	MLX5_PTYS_RATE_HDR	= 1 << 6,
 	MLX5_PTYS_RATE_NDR	= 1 << 7,
+	MLX5_PTYS_RATE_XDR	= 1 << 8,
 };
 
 static inline int mlx5_ptys_rate_enum_to_int(enum mlx5_ptys_rate rate)
@@ -185,6 +186,7 @@ static inline int mlx5_ptys_rate_enum_to_int(enum mlx5_ptys_rate rate)
 	case MLX5_PTYS_RATE_EDR:   return 25000;
 	case MLX5_PTYS_RATE_HDR:   return 50000;
 	case MLX5_PTYS_RATE_NDR:   return 100000;
+	case MLX5_PTYS_RATE_XDR:   return 200000;
 	default:		   return -1;
 	}
 }
-- 
2.39.1

