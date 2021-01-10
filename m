Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11AD2F07D3
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 16:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbhAJPIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 10:08:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbhAJPIX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 10:08:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48B7622AB9;
        Sun, 10 Jan 2021 15:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610291263;
        bh=N0L/ajUl+DqT7TvFkBOc02XrqsPAylqRsuZMrgq1oaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W55XoPCErWSZSz+8HAAPCZoMjXgP/Qks0O73ttoZOY6BYp7BC9T396spKZq626GeE
         nsQ+YTh5bRniOajc4+Yc4IRcx8DHrj0n44vMz5O4DILpCpCLvaTqSHcLT3h56fEcT4
         IGpWn+SO12JRiWcL416rP0iuZFs7z7ocZzghMN/llwjJ2lE7A6//PzMwF+JqMc82oe
         RfZineHueSIdpJP4upAtI8EHD4sjoAzu7Af8DoepRflkbvj0qsZRxFU7LHUXeS3qSa
         aiN8jNh2h404Wu8ZMRk/hYCTWAIN2hPdPoEdU0GH8H2QCu8C1ALd8j7nz0NSKlngFV
         uN3T+ihOQhadA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH mlx5-next v1 3/5] net/mlx5: Add dynamic MSI-X capabilities bits
Date:   Sun, 10 Jan 2021 17:07:25 +0200
Message-Id: <20210110150727.1965295-4-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110150727.1965295-1-leon@kernel.org>
References: <20210110150727.1965295-1-leon@kernel.org>
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

