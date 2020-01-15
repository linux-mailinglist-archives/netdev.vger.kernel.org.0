Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C63F13C6AE
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgAOOzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 09:55:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbgAOOzK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 09:55:10 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B577624671;
        Wed, 15 Jan 2020 14:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579100110;
        bh=zEtCaIfBqmoKo7CziV4rVfVf6VUiH3FkU5d24cGqwR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/waZDFJGlwTeQZ/Qgnt5lT8+t+tILXkLnpFAxI/LrfFO/WZ1qmNO/ZxVMEUd3BcE
         jklv8EiVlZn+NLa/T8RHmHvyKKQ01OfCDsZcKUWAz8LRTY1N+I5LJn7MjYYUXEdORW
         AfblSg6yinqyi3m2fMdd2W/aQc54uMB4VFcLpXhY=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Avihai Horon <avihaih@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 1/2] net/mlx5: Add RoCE accelerator counters
Date:   Wed, 15 Jan 2020 16:54:58 +0200
Message-Id: <20200115145459.83280-2-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115145459.83280-1-leon@kernel.org>
References: <20200115145459.83280-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Add RoCE accelerator definitions.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index c6abaf4f1c55..73d1a6a049fb 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1197,7 +1197,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_130[0xa];
 	u8         log_max_ra_res_dc[0x6];
 
-	u8         reserved_at_140[0xa];
+	u8         reserved_at_140[0x9];
+	u8         roce_accl[0x1];
 	u8         log_max_ra_req_qp[0x6];
 	u8         reserved_at_150[0xa];
 	u8         log_max_ra_res_qp[0x6];
@@ -4746,7 +4747,19 @@ struct mlx5_ifc_query_q_counter_out_bits {
 
 	u8         req_cqe_flush_error[0x20];
 
-	u8         reserved_at_620[0x1e0];
+	u8         reserved_at_620[0x20];
+
+	u8         roce_adp_retrans[0x20];
+
+	u8         roce_adp_retrans_to[0x20];
+
+	u8         roce_slow_restart[0x20];
+
+	u8         roce_slow_restart_cnps[0x20];
+
+	u8         roce_slow_restart_trans[0x20];
+
+	u8         reserved_at_6e0[0x120];
 };
 
 struct mlx5_ifc_query_q_counter_in_bits {
-- 
2.20.1

