Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305372220F6
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 12:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgGPKw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 06:52:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbgGPKw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 06:52:59 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF6CD206C1;
        Thu, 16 Jul 2020 10:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594896778;
        bh=lh90Dzau8uqKI0WZyEBA+NT1hd/3pudO72xG6M4zfHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fGhrpvwjMtOv/jEd6VirCbz1Klut4ys6G4eQQfRfz9jr0Lqdotj8jexez3SFXAmuB
         k1o9yy+2VPfXJ7UPrNWrVRR1xU0cZ4KcB+ZXqBCo8WRmG5FChAefTVG4pi0ZatsUrO
         aZzPeiWyUCSghNGuHIew0xzlbNINPz9MSK5FzOIg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Meir Lichtinger <meirl@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 1/3] RDMA/mlx5: ConnectX-7 new capabilities to set relaxed ordering by UMR
Date:   Thu, 16 Jul 2020 13:52:46 +0300
Message-Id: <20200716105248.1423452-2-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716105248.1423452-1-leon@kernel.org>
References: <20200716105248.1423452-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Meir Lichtinger <meirl@mellanox.com>

Up to ConnectX-7 setting mkey relaxed ordering read/write attributes
by UMR is not supported. ConnectX-7 supports this option, which is
indicated by two new HCA capabilities - relaxed_ordering_write_umr
and relaxed_ordering_read_umr.

Signed-off-by: Meir Lichtinger <meirl@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
Not based on latest mlx5-next.
---
 include/linux/mlx5/mlx5_ifc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index d22b3ff99b7a..2999a026938a 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1216,7 +1216,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {

 	u8         max_sgl_for_optimized_performance[0x8];
 	u8         log_max_cq_sz[0x8];
-	u8         reserved_at_d0[0xb];
+	u8         relaxed_ordering_write_umr[0x1];
+	u8         relaxed_ordering_read_umr[0x1];
+	u8         reserved_at_d2[0x9];
 	u8         log_max_cq[0x5];

 	u8         log_max_eq_sz[0x8];
--
2.26.2

