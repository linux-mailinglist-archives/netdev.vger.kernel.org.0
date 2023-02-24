Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0A76A2154
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjBXSTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjBXSTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:19:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532884D625
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:19:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE34961964
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 18:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEB1C433D2;
        Fri, 24 Feb 2023 18:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677262752;
        bh=fgxt61cwRmoWeU4Pt8WWLREDEajCI+zVsHYj7utxcQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xq7OrgT8klgoTu4CYQwBUYgH1suSsVcjcSOLL9Zhg2bbUkuDZT6/QY+dGdKS2I1BB
         dQkTTFFvaxDHFMcySVFQRZEymv8tCVGxNIHhuqiw5W8K7vz6ftlAODMlFWVzDTeDkd
         WShq+mQHLH8renOGpTVQW8PeawPySzC6C6CiealHzsd3RtVYeE3DdoGe3O+sPEi1zx
         rKXxFrg+sYYbePVWRfO2KJAgIIKJPo9FJ4wxtGccqp+WU9iarq04tMGFqwe0Z4wy2j
         gIjt8CVyNXBSa4g5rW5xpLD85WYy49/xb9onxQA/uczimbIjU+yNPuld8o94Avnxjw
         WUegtfo4pUkig==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [net V2 1/7] net/mlx5: Remove NULL check before dev_{put, hold}
Date:   Fri, 24 Feb 2023 10:18:58 -0800
Message-Id: <20230224181904.671473-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230224181904.671473-1-saeed@kernel.org>
References: <20230224181904.671473-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

The call netdev_{put, hold} of dev_{put, hold} will check NULL,
so there is no need to check before using dev_{put, hold},
remove it to silence the warning：

./drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c:714:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4174
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index e24b46953542..8f7452dc00ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -710,8 +710,7 @@ void mlx5e_rep_tc_receive(struct mlx5_cqe64 *cqe, struct mlx5e_rq *rq,
 	else
 		napi_gro_receive(rq->cq.napi, skb);
 
-	if (tc_priv.fwd_dev)
-		dev_put(tc_priv.fwd_dev);
+	dev_put(tc_priv.fwd_dev);
 
 	return;
 
-- 
2.39.1

