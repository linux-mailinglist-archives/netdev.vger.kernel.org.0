Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738494D3ADF
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 21:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237270AbiCIUQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 15:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238010AbiCIUQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 15:16:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243D5A76CF
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 12:15:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B57FBB82370
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 20:15:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6871C340F5;
        Wed,  9 Mar 2022 20:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646856924;
        bh=TmDr5aDRm2V28VnjPBvH76ehIHVr/NkyuhY/Zu2NeXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lhyvSiWFI5iCtoHl+SnrbM+kUYGMQ88t7BVIoKMK/atyfMjsKp6g60+hXYZorz7Jr
         cr263TnVgXfMRy2nCK2tRTk89H+Foykjr0hjAPuDHc9Wzl1QnJFWO7gLgNaJADj9x1
         BonnLT1UO8gspodcxmUtPPJmMXHiAOofKMDD0i1UvTOdKFft+CXNkFJt8iamKAGUZ4
         wlm4qQFi1ulORG5geW3IEvNg4GSRrRac92BWUl5vngjQwGC27EA54m4Vp3qA5oUCXN
         rWxrsmDaWg/CU5jo1mdcOp76+6xNfqpK0bT/1rQJCEmB7Z3OuU9rTZifVLg+1gDWlA
         VnrjKpV9wj9Sg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Mohammad Kabat <mohammadkab@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 1/5] net/mlx5: Fix size field in bufferx_reg struct
Date:   Wed,  9 Mar 2022 12:15:13 -0800
Message-Id: <20220309201517.589132-2-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309201517.589132-1-saeed@kernel.org>
References: <20220309201517.589132-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mohammad Kabat <mohammadkab@nvidia.com>

According to HW spec the field "size" should be 16 bits
in bufferx register.

Fixes: e281682bf294 ("net/mlx5_core: HW data structs/types definitions cleanup")
Signed-off-by: Mohammad Kabat <mohammadkab@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 598ac3bcc901..5743f5b3414b 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9900,8 +9900,8 @@ struct mlx5_ifc_bufferx_reg_bits {
 	u8         reserved_at_0[0x6];
 	u8         lossy[0x1];
 	u8         epsb[0x1];
-	u8         reserved_at_8[0xc];
-	u8         size[0xc];
+	u8         reserved_at_8[0x8];
+	u8         size[0x10];
 
 	u8         xoff_threshold[0x10];
 	u8         xon_threshold[0x10];
-- 
2.35.1

