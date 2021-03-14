Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01C133A4CD
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 13:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbhCNMnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 08:43:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235212AbhCNMnF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Mar 2021 08:43:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 669A664EE8;
        Sun, 14 Mar 2021 12:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615725785;
        bh=rhEe2dBamJv23d9TM+f5H89U9NqElev9B1Ept6zpHmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CvGz4Q29VNFJ/o+PvHTr/vnd+Tv8kxra5fk/oRoybNy9Fx3zAUQQXwed0akrtaNH7
         hSzjx3lY/zFFcENtM8F7UBf+oOqt1dpxgzafBSbSfmepjrFx0Tp6gyFqBnggeyECB+
         YDThyVpr0xkkiue/xgyXt8VDMOQUJ5Ztaj+0pcep0A10+TAgPEsj96ivZwGGFpC7J6
         Ul9eYErkNxYiajkFcv6StGkzNlDZlCDl8ZASKaaHnrc+UvrMhtv3Uia23MMpgqwxxy
         Ye50+DyiAYdd6puX7zp1QhVgEzSfNhRqt7YYLLj2GT1YgayN8dw60gawzYKSGUdsCG
         lwm6nOT4bahYg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH mlx5-next v8 2/4] net/mlx5: Add dynamic MSI-X capabilities bits
Date:   Sun, 14 Mar 2021 14:42:54 +0200
Message-Id: <20210314124256.70253-3-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210314124256.70253-1-leon@kernel.org>
References: <20210314124256.70253-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index df5d91c8b2d4..c0ce1c2e1e57 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1680,7 +1680,16 @@ struct mlx5_ifc_cmd_hca_cap_bits {
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
2.30.2

