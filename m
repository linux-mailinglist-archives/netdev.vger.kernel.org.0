Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884B7315052
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 14:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhBINfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 08:35:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:43812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229772AbhBINff (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 08:35:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AEC964ED4;
        Tue,  9 Feb 2021 13:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612877694;
        bh=9u4XcR+je2ELj6DNgC77h551MxruUIms4e+LHa1FoSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrJmH1upy+82Oe/cFOe/qvRbN4r6clUtQYV5P/5f4m6appd/nhEfVErQbHc/Yucp2
         O3C6k0PzxBV8a+mkEoeZvpoKTq6Islr0M3PL4epPe9bXylStAehtCXX08XZbDJbNEs
         SPMekFtGjI17J+r+ohqCfD83e0wsOftNMBMFc/H/j67Mvk9kTv5/YeH4t9je5JbCpK
         456IbBZNIGUO/ihSJ3W3m+j07CYXVUc1FBehz7OcGcB9ge/Q3pzgioNpNgpke2g0ft
         ld63Ofji1xsqLg+K563dcT7plwUCld1ZN9KaUMzDqSyApl0K5K/5Mlj/nj41pxk55H
         3NulUtlZUp2ag==
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH mlx5-next v6 2/4] net/mlx5: Add dynamic MSI-X capabilities bits
Date:   Tue,  9 Feb 2021 15:34:43 +0200
Message-Id: <20210209133445.700225-3-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210209133445.700225-1-leon@kernel.org>
References: <20210209133445.700225-1-leon@kernel.org>
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
index 77051bd5c1cf..ffe2c7231ae4 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1677,7 +1677,16 @@ struct mlx5_ifc_cmd_hca_cap_bits {
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

