Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7333C301C11
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 14:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbhAXNMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 08:12:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:42278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbhAXNMo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 08:12:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2807822D2C;
        Sun, 24 Jan 2021 13:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611493897;
        bh=aHBmFnfLyG43e7CqSIxZ36xVHHd++9BQh2pCJmoqnr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C5XQosOH9gXH2dshXEXIFJYYImstVT3WfEC7Zzc0YFbGMSFs1wJfcqtHkx2ub/zSY
         aAmtz08sf2jmrPM9kzReqsOeCpGhJEK6BQd4ly/GXnBnHUj2hCLSb7GjkVNRD1qXqg
         0/1dyL+7QnAi5m7A8fNmgQB/EACW9Oyk/IgsTiMk83uq8j3hXS8nNX3eV8C3PXgK57
         lCVBJoVMHTQ7hLPjngaczoXdLGGr+dMWWM7gyaVEOdG4n2tmzYnTW1PK4LxwZsuYGY
         U2iJ3TH2LlV+TRayVA/S1YVg4gVik+y00150Hy21KGLG00FP6PoPI+irgbkyjZwMXU
         y00gOmZDKMx0A==
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
Subject: [PATCH mlx5-next v4 2/4] net/mlx5: Add dynamic MSI-X capabilities bits
Date:   Sun, 24 Jan 2021 15:11:17 +0200
Message-Id: <20210124131119.558563-3-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210124131119.558563-1-leon@kernel.org>
References: <20210124131119.558563-1-leon@kernel.org>
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

