Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705873278BB
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 08:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhCAH4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 02:56:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:41200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232676AbhCAH42 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 02:56:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB06B64E38;
        Mon,  1 Mar 2021 07:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614585348;
        bh=yCHWjJaPT8VcPcdMP71SUt3lFVoga2J+ds6B7mObtYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QaUs2XYJdybQFG2WzrYIIU/aH22pFvdF7WMZuPwOCqaW8kgr2idVqG/AJdm/5AsRx
         6HvdpunNzSXmY4JMdO9Labwb/LiZaXjF2G2h/I6mUY2PdbLeHnULoCljXLVhdrLWRu
         Chyu3UFizW7cg95CaHzaEVIJkw5vMtq2BahnrNXNLp5rZ8QpQCmy3yTwGQ8MX0AA8C
         EVDDOTheWn03/qOHLJPap778TWK8y58yFxFsvAUaYRXrVAqv43SulSRAuomrA+WPSt
         wtkKyr9YlGgTKmOxISwNN7yb3w4Y9Pdr+BPDW9ZisVXoH8babV2AdIvtg1cVS5+QeA
         Op5gz9GNTEC8A==
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
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH mlx5-next v7 2/4] net/mlx5: Add dynamic MSI-X capabilities bits
Date:   Mon,  1 Mar 2021 09:55:22 +0200
Message-Id: <20210301075524.441609-3-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210301075524.441609-1-leon@kernel.org>
References: <20210301075524.441609-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

These new fields declare the number of MSI-X vectors that is possible to
allocate on the VF through PF configuration.

Value must be in range defined by min_dynamic_vf_msix_table_size and
max_dynamic_vf_msix_table_size.

The driver should continue to query its MSI-X table through PCI
configuration header.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 60b97556ee14..4215bb6a6b52 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1685,7 +1685,16 @@ struct mlx5_ifc_cmd_hca_cap_bits {
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

