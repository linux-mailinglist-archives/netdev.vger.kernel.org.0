Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965A133123C
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 16:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhCHPb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 10:31:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:60388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230143AbhCHPbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 10:31:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FC046526A;
        Mon,  8 Mar 2021 15:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615217507;
        bh=rBXxC8/mFp2BQnzNE6T+rEcZQc82cTFW4yo+076vbxw=;
        h=From:To:Cc:Subject:Date:From;
        b=m+Ps+9nEv9uFc5MDr/0u9dcTL9Q6e2obPLGnjvjx7bsdeKRRVUGLrPWuNXArW+tI0
         1Cxap6sOv3dthh4XE0DK/6B/nf4y8phjPltzFCfPnxJ3/GlQQxHxDeUbif9eFkai71
         9ibpxkS/oS38pA6HQJFaXQSJpBdXLHMYNk8ZIZ9ovn0Ql43WA05NuIO4nVSd8/LQHq
         Am58qSsO+89E9KOXcxvLzv1X/K3VFZJHFO25qTsOSuMKD5EXzaGnnpyiIzPz0ArkHk
         jno3R1CYqWDp//GCKsxORGiGZvwKcX/5vM9FQxrTFMPIx8YUHOkTYHjAuQdi+p/zYQ
         5kB0AQBF30ZjA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Roi Dayan <roid@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5e: include net/nexthop.h where needed
Date:   Mon,  8 Mar 2021 16:31:20 +0100
Message-Id: <20210308153143.2392122-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1510:12: error: implicit declaration of function 'fib_info_nh' [-Werror,-Wimplicit-function-declaration]
        fib_dev = fib_info_nh(fen_info->fi, 0)->fib_nh_dev;
                  ^
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1510:12: note: did you mean 'fib_info_put'?
include/net/ip_fib.h:529:20: note: 'fib_info_put' declared here
static inline void fib_info_put(struct fib_info *fi)
                   ^

Fixes: 8914add2c9e5 ("net/mlx5e: Handle FIB events to update tunnel endpoint device")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 6a116335bb21..32d06fe94acc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2021 Mellanox Technologies. */
 
 #include <net/fib_notifier.h>
+#include <net/nexthop.h>
 #include "tc_tun_encap.h"
 #include "en_tc.h"
 #include "tc_tun.h"
-- 
2.29.2

