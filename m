Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43F339A184
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 14:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhFCMxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 08:53:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230453AbhFCMxr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 08:53:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E48C76124B;
        Thu,  3 Jun 2021 12:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622724722;
        bh=VrR6OyFEYg3e+K1DBiO/OoVYYizbyTEQb6zjKyXpRww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdOmXda/4UCmvbn/E6pTijdhDyl+Ahg4akGZpIujTJnr/7GlkmZUR2Su6LKQEsTsV
         LP5SHec9BcHDJfnKGTvtBAsoK/J2DR/3zcQJUO1kOCj/2tlMRGXeyrS60o98bLBKqP
         8tym1g9WjdbgZK+tZWNdmGeAoyX6B1SXMOuTcmx6rcDANrUUsZeJcBAz1mA8+hf3W/
         GcgZ3Oh+JSAJdGAXTIDl1DSDj4Ow2XizrGn1fLKtNwI8q75k/Z4kqDr/oGwEi3OFrO
         CQF9lIcTx8/IuhV/pWjQejiQFXrWZat9MihZWAQiAaBkmVx4xsZP/wepOu/yL/tFXg
         V00SOVnRbkWMA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lior Nahmanson <liorna@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 1/3] net/mlx5: Add DCS caps & fields support
Date:   Thu,  3 Jun 2021 15:51:48 +0300
Message-Id: <77b62613f56734bac9b490342f7c800b104d0876.1622723815.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1622723815.git.leonro@nvidia.com>
References: <cover.1622723815.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lior Nahmanson <liorna@nvidia.com>

This fields will be needed when adding a support for DCS offload

max_dci_stream_channels - maximum DCI stream channels supported per DCI.
max_dci_errored_streams - maximum DCI error stream channels
supported per DCI before a DCI move to error state.

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 6d16eed6850e..48b2529451eb 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1655,7 +1655,13 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         max_geneve_tlv_option_data_len[0x5];
 	u8         reserved_at_570[0x10];
 
-	u8         reserved_at_580[0x33];
+	u8	   reserved_at_580[0xb];
+	u8	   log_max_dci_stream_channels[0x5];
+	u8	   reserved_at_590[0x3];
+	u8	   log_max_dci_errored_streams[0x5];
+	u8	   reserved_at_598[0x8];
+
+	u8         reserved_at_5a0[0x13];
 	u8         log_max_dek[0x5];
 	u8         reserved_at_5b8[0x4];
 	u8         mini_cqe_resp_stride_index[0x1];
@@ -3013,10 +3019,12 @@ struct mlx5_ifc_qpc_bits {
 	u8         reserved_at_3c0[0x8];
 	u8         next_send_psn[0x18];
 
-	u8         reserved_at_3e0[0x8];
+	u8         reserved_at_3e0[0x3];
+	u8	   log_num_dci_stream_channels[0x5];
 	u8         cqn_snd[0x18];
 
-	u8         reserved_at_400[0x8];
+	u8         reserved_at_400[0x3];
+	u8	   log_num_dci_errored_streams[0x5];
 	u8         deth_sqpn[0x18];
 
 	u8         reserved_at_420[0x20];
-- 
2.31.1

