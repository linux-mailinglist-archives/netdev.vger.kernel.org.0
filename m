Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAFE865E9C7
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 12:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbjAELYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 06:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbjAELYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 06:24:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D5150066;
        Thu,  5 Jan 2023 03:23:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C18FE619CC;
        Thu,  5 Jan 2023 11:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57CBC433EF;
        Thu,  5 Jan 2023 11:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672917838;
        bh=gbAB2Gn23E8leswuTQLuvlYJsRqaa3JIwQbl5Qfzczs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MCz2Jmk9jYpCfI2BdZ8WKLHBrIDc9QaD604pK/P4L+8PktuIFK4xTFELVIeA06956
         vItkrzPHPaJ7str6KmW4oG19nPWWDpDQW+oxOZI+7HMR+VXbJfppQiwE6AVaNybtx6
         mBLdG9VvahJt2UJiHwGr//ogVC3tlSh/XKWekZ6P6dGoE02vGB2xJCjdOjv2iS62o1
         Brnht5bfsigccihJSrb31OU1BseqVzGLRZ0sqStuQT7NAhkmc4UCowy6rn/bJzQzfo
         abYv8j+DVCUCLv9iacCKbYyAYDbGaysVp7cSU5ihnJ41fi88KjON411yMufPWU5398
         BqDtw68NejeQQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Or Har-Toov <ohartoov@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next v1 1/4] net/mlx5: Expose bits for querying special mkeys
Date:   Thu,  5 Jan 2023 13:23:45 +0200
Message-Id: <3c7243648f72aaed7953bf976110e41068e22dc1.1672917578.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672917578.git.leonro@nvidia.com>
References: <cover.1672917578.git.leonro@nvidia.com>
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

From: Or Har-Toov <ohartoov@nvidia.com>

Add needed HW bits to query the values of all special mkeys.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index f3d1c62c98dd..a2ed927c8f9f 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1479,7 +1479,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         relaxed_ordering_write[0x1];
 	u8         relaxed_ordering_read[0x1];
 	u8         log_max_mkey[0x6];
-	u8         reserved_at_f0[0x8];
+	u8         reserved_at_f0[0x6];
+	u8	   terminate_scatter_list_mkey[0x1];
+	u8	   repeated_mkey[0x1];
 	u8         dump_fill_mkey[0x1];
 	u8         reserved_at_f9[0x2];
 	u8         fast_teardown[0x1];
@@ -5197,7 +5199,11 @@ struct mlx5_ifc_query_special_contexts_out_bits {
 
 	u8         null_mkey[0x20];
 
-	u8         reserved_at_a0[0x60];
+	u8	   terminate_scatter_list_mkey[0x20];
+
+	u8	   repeated_mkey[0x20];
+
+	u8         reserved_at_a0[0x20];
 };
 
 struct mlx5_ifc_query_special_contexts_in_bits {
-- 
2.38.1

