Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0642356243
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhDGEGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:06:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229588AbhDGEGv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:06:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 516ED613CB;
        Wed,  7 Apr 2021 04:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617768402;
        bh=JdLGnglztrfYgoF8dUBl3BI/fsCw5ruutkpdDQ3SQA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1U9lm07sZuvaGc91AlhYkq2EBuY3nzJa+VnyiGxwkf9zNVrhobQLcSCbc6TpDCp5
         84T0flN7KLIZ1Sur9liptPIujtkINP+WW02sxhvmXWk2O27wGJwoZ+GjDiAuEUgi2N
         /7k238KLAFRkVoO0OHYgsod4+PRlkJ50AjJT8/ABoPx0DJSylNVMYx4OES/aUYdFgM
         q/bG3VPNUvuIGCI4ov6ZdGf2Yoh28Ftq7SyJbIh6GZ1Dhhzrp8jvHv7RxhglFWRHyZ
         +1kJmVVU5rmROZMMbKdrkPtDAJFxSCS+eZVAC2U4yCACcAxdr9tYWdIjwCBlUIqzZr
         Whn/0a7TOJing==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 4/5] net/mlx5: Fix PBMC register mapping
Date:   Tue,  6 Apr 2021 21:06:19 -0700
Message-Id: <20210407040620.96841-5-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407040620.96841-1-saeed@kernel.org>
References: <20210407040620.96841-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add reserved mapping to cover all the register in order to avoid setting
arbitrary values to newer FW which implements the reserved fields.

Fixes: 50b4a3c23646 ("net/mlx5: PPTB and PBMC register firmware command support")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 9940070cda8f..9c68b2da14c6 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -10200,7 +10200,7 @@ struct mlx5_ifc_pbmc_reg_bits {
 
 	struct mlx5_ifc_bufferx_reg_bits buffer[10];
 
-	u8         reserved_at_2e0[0x40];
+	u8         reserved_at_2e0[0x80];
 };
 
 struct mlx5_ifc_qtct_reg_bits {
-- 
2.30.2

