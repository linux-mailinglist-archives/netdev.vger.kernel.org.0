Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1527331581C
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbhBIUxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:53:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233686AbhBIUj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 15:39:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16512614A7;
        Tue,  9 Feb 2021 20:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612903086;
        bh=UCVCf7yUcekAeACjiviGcShpRA/ElW6S8Ut0FNZ9g+0=;
        h=From:To:Cc:Subject:Date:From;
        b=iqCG3ICItorPiwC1uoUrkOzVMrzvnF8ZhKXBjrGofak9qodkRCQPOK07MoOHwLWiT
         KCFUp3dR/2bSPcKc9nSTbo+54fsKxDNhOqGs906KOwt1318a/PtwQCOkPdIJ9ARMbm
         cuzxde4Yd2B6kymhTTJfC7o9UPidgMQV5u3C8NU/9wms3g9Ii8F5SbtWfRUZ3yZdRA
         C6Avnswzb81kRKWFyzNrxABparnTfn2HjEp9csip+T/PsiqDwwKBNCWhIw8CYZBTe8
         Ad/o4UkfHNJj6yqilkPoSXmJbaf5EclIhp53w1g73g0IOOGX+8L7xma2BZa21XkC2L
         KluuItrVi+LTw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next] net/mlx5e: Fix tc_tun.h to verify MLX5_ESWITCH config
Date:   Tue,  9 Feb 2021 12:37:22 -0800
Message-Id: <20210209203722.12387-1-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Exclude contents of tc_tun.h header when CONFIG_MLX5_ESWITCH is disabled to
prevent compile-time errors when compiling with such config.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
index fa992e869044..67de2bf36861 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
@@ -11,6 +11,8 @@
 #include "en.h"
 #include "en_rep.h"
 
+#ifdef CONFIG_MLX5_ESWITCH
+
 enum {
 	MLX5E_TC_TUNNEL_TYPE_UNKNOWN,
 	MLX5E_TC_TUNNEL_TYPE_VXLAN,
@@ -99,4 +101,6 @@ int mlx5e_tc_tun_parse_udp_ports(struct mlx5e_priv *priv,
 				 void *headers_c,
 				 void *headers_v);
 
+#endif /* CONFIG_MLX5_ESWITCH */
+
 #endif //__MLX5_EN_TC_TUNNEL_H__
-- 
2.29.2

