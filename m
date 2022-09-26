Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A772D5EB399
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 23:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiIZVux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 17:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiIZVuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 17:50:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80838B14E7;
        Mon, 26 Sep 2022 14:50:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D30986134E;
        Mon, 26 Sep 2022 21:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C30C433D6;
        Mon, 26 Sep 2022 21:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664229049;
        bh=wjVBM2rtaXLU9XIzfLnEkRHuZJyfInxhvNz/xCYz1NU=;
        h=Date:From:To:Cc:Subject:From;
        b=RlLDMnwX600IDLVy4DKLv+JQ3x8lUPQHI0OVDGSIvtVJObTkGDWVflfS6Hyt0XcY6
         IH1ZpuIzvaKogZty98eGLQV9M0qyQ806nQimmSI6aqCPGJ6COh3uQMYjgkdZLtaPMc
         c/sZnjriBgFCn8jxYXHNGE9OpQPgkMoDbF229eMK9vs/z+PWgdDA6ZUqf+8vwh+2IH
         Nq5Aq6GbevgyjEKiI6MuSblMnpF8aiR5Jki5BSk3Daqb07ODS8qWqN6sBjI5jsDHY5
         GdGgkXcRDrAilJwo32A4dlcbe/4Qg81P8Qxh1hTWUA4je1Rw6JSQX22qDhBhhAvehO
         KfUkh0akqf9Cg==
Date:   Mon, 26 Sep 2022 16:50:42 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net/mlx5e: Replace zero-length arrays with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <YzIestBCo0RL7sVi@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays are deprecated and we are moving towards adopting
C99 flexible-array members, instead. So, replace zero-length arrays
declarations in anonymous union with the new DECLARE_FLEX_ARRAY()
helper macro.

This helper allows for flexible-array members in unions.

Link: https://github.com/KSPP/linux/issues/193
Link: https://github.com/KSPP/linux/issues/222
Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
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
2.34.1

