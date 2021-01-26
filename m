Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807473044B3
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 18:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390209AbhAZRH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 12:07:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390589AbhAZI6d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 03:58:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77DC2230FD;
        Tue, 26 Jan 2021 08:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611651459;
        bh=aHBmFnfLyG43e7CqSIxZ36xVHHd++9BQh2pCJmoqnr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mqHq3lnWsnnIxbEmR84cNJohLvSC5dUSmBmQxCkkLT7XXPcjO/xjPRazHUq7V2xOC
         4xajUQZU4H+h5erutEjIZzB1E2YWHzj8MU3OuTa5lHtl7uVFWaopo8i5vgxuuoZvOc
         zRNeoLK/qu6r97znPWCbF0Au2BztUt285cvXCdwjwZfbEnC8i2s/mghelbIroG0kLZ
         byk0Elahede/Jg0PbcciYPTaskFPAvZJWkP/kJCv3f0cdlgBPTdDQf7SR8GSh3Tkld
         zDXzx7434AhBCF/Dnqn5Jd4SXkhvfyhTJabApJRb7PzGXNBhsXorLT33i/3Tq7tkF4
         QA8KNQW8nDqsQ==
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
Subject: [PATCH mlx5-next v5 2/4] net/mlx5: Add dynamic MSI-X capabilities bits
Date:   Tue, 26 Jan 2021 10:57:28 +0200
Message-Id: <20210126085730.1165673-3-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126085730.1165673-1-leon@kernel.org>
References: <20210126085730.1165673-1-leon@kernel.org>
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
index b96f99f1198e..31e6eac67f51 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1657,7 +1657,16 @@ struct mlx5_ifc_cmd_hca_cap_bits {
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

