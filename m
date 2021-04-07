Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4E6356242
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhDGEGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229484AbhDGEGu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:06:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9841613CC;
        Wed,  7 Apr 2021 04:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617768402;
        bh=0joVPW8G512/GtWQQNpFi1x7lUiGxA4A6hs6tXo53WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uXNCwlxDrsXa/Up2HCcJeNcSBXbrSBn27cZKUKPf4eUmvzmPW8vEBmijZLZPmr9YU
         ep8upKsjBKSejo24vcoTVRf8m+56/JKhvAS97w1y1g32nlnZGKp6fae64xHgnO7V7r
         +3sPHknPW/pd+CswktAN/L3BntYVICFrlNRVkfx3Xy5/pn4WQ7N/J1aRkMyuHf2qcO
         TWQNsR1Gq3zAQ+PCJssIF1oEkFZQJVmZCyDzD0vrWDI4FN9WZ7CE1gK0eQ0RKWYsAo
         ZfqnfWFZ8ZLiMQt/xv5KoMpdA4eMiboFKqO4LwHwdnPqdOo7jCG71HDiVPMu4u9RCk
         pT4Vmm2xIO1Lg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 3/5] net/mlx5: Fix PPLM register mapping
Date:   Tue,  6 Apr 2021 21:06:18 -0700
Message-Id: <20210407040620.96841-4-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407040620.96841-1-saeed@kernel.org>
References: <20210407040620.96841-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add reserved mapping to cover all the register in order to avoid
setting arbitrary values to newer FW which implements the reserved
fields.

Fixes: a58837f52d43 ("net/mlx5e: Expose FEC feilds and related capability bit")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 1ccedb7816d0..9940070cda8f 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -8835,6 +8835,8 @@ struct mlx5_ifc_pplm_reg_bits {
 
 	u8         fec_override_admin_100g_2x[0x10];
 	u8         fec_override_admin_50g_1x[0x10];
+
+	u8         reserved_at_140[0x140];
 };
 
 struct mlx5_ifc_ppcnt_reg_bits {
-- 
2.30.2

