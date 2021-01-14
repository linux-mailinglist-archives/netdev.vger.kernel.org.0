Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526D92F5ED4
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 11:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbhANKcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 05:32:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:58998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728360AbhANKce (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 05:32:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3ACF723A52;
        Thu, 14 Jan 2021 10:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610620313;
        bh=gVwcAqksC8774I0xStSE+R/m4VUu3bJL+MR3Q0MK8Ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M9hELuS/Nw8tDC8RBMpdYTqUdIpp8zflaelOmaexRdPTGa4ihloUQuB2CNXW6/huP
         gPV/EcPVLrgZ/AZd0n/fWWW3uHEjWDhSJ8vkyh+mkTcfRzgRLRrzSxzuZhq5CSjXH9
         xEjiL4f8POColYHwh/4cup8XzxS2fz/ynrVCvOmKXvUmUyyewnfbNTOc19no26cGek
         rXgZuPhvooRFxxoo6A/IpCXCycTXqVuMT2fWw9qoJc1HjcsmYer/AGEAtmNrKzE5H1
         r3x92GD9kKRIQkNFW7IHNRz09yHnRuBxmjjx6ETs5kQwR0KohPVnhMkcFPKSWsdsYC
         yvTNLlNyIqQXQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH mlx5-next v2 3/5] net/mlx5: Add dynamic MSI-X capabilities bits
Date:   Thu, 14 Jan 2021 12:31:38 +0200
Message-Id: <20210114103140.866141-4-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210114103140.866141-1-leon@kernel.org>
References: <20210114103140.866141-1-leon@kernel.org>
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

