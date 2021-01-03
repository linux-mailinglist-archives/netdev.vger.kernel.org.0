Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606F92E8B64
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 09:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbhACIZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 03:25:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:43734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbhACIZl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 03:25:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D65BE20B1F;
        Sun,  3 Jan 2021 08:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609662300;
        bh=gVwcAqksC8774I0xStSE+R/m4VUu3bJL+MR3Q0MK8Ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jC5hl8tfurdMm9BvElka/Eo79VbDWgSBc7czE/p8F1hyK33HGlElF8vK68dNNqj7s
         8qfrpTm0y0asB2T7gfG2C9PS2qI9KjhsdiZnmMvFvjKjFQox9WsIwjfSIw1LzaHcba
         9pDTW12RU/tpbV2e3t7Wf1hG8GgzciLHwF69IDiAIj83jJLTDaLtK0GTXK3IDYaXRH
         DSR46LD9wz8IKvcNa6a+2pMyfl2T4+fmlJ5GPWSldUrZi3bAH36Z12BI0s258bMevy
         Y3akwwljE0i9NS9Uw3JZBbhH7dWd+a5YscVq7UbhgbFoatk/479F3zI7efH4wReklk
         7z6opCmD7NV5A==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 2/4] net/mlx5: Add dynamic MSI-X capabilities bits
Date:   Sun,  3 Jan 2021 10:24:38 +0200
Message-Id: <20210103082440.34994-3-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210103082440.34994-1-leon@kernel.org>
References: <20210103082440.34994-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

These new fields declare the number of MSI-X vectors that is
possible to allocate on the VF through PF configuration.

Value must be in range defined by min_dynamic_vf_msix_table_size
and max_dynamic_vf_msix_table_size.

The driver should continue to query its MSI-X table through PCI
configuration header.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 8c5d5fe58051..7ac614bc592a 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1656,7 +1656,16 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8	   reserved_at_6e0[0x10];
 	u8	   sf_base_id[0x10];
 
-	u8	   reserved_at_700[0x80];
+	u8	   reserved_at_700[0x8];
+	u8	   num_total_dynamic_vf_msix[0x18];
+	u8	   reserved_at_720[0x14];
+	u8	   dynamic_msix_table_size[0xc];
+	u8	   reserved_at_740[0xc];
+	u8	   min_dynamic_vf_msix_table_size[0x4];
+	u8	   reserved_at_750[0x4];
+	u8	   max_dynamic_vf_msix_table_size[0xc];
+
+	u8	   reserved_at_760[0x20];
 	u8	   vhca_tunnel_commands[0x40];
 	u8	   reserved_at_7c0[0x40];
 };
-- 
2.29.2

