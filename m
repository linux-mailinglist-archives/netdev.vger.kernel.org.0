Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA4F6EA117
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbjDUBjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbjDUBjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:39:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8863C04
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:39:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91F3B642F7
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1E4C433D2;
        Fri, 21 Apr 2023 01:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041151;
        bh=x4KhejvEt7vAofniF25B8pz+Ldg9oRXaLs7ehc02Sp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KARj7/hVEKsIebZmFTQQ0YypBvcOeOrjpEfJ50zGYdqzv7oseRQuBMEutr0BZu3Wl
         a4WvYHcWfBc4zuzxBYLnWLg+DpRz79O6Ynd9kY2TwEKdNw65e+s7kcIB96No2eca8z
         vBRRbHTGiwZhbYouwyh7yY+skSu8GoPP9RLtrXa/HYfrdnR9sNwzk/ziblJYWppJdW
         8uQ4wYAlnmlvKjrBBd65GyC2+IX2UnlAP0W1d5WZ5x9p+huEIh1QMip1dqvyas7Np2
         bwDtJ+JCoZRLuMNANaH/XURehlesXcQVNKhU+JeqRKx5mHWdicpDI+xet4WyAUmeVd
         btiCgl1PnrddQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 03/15] net/mlx5: DR, Add more info in domain dbg dump
Date:   Thu, 20 Apr 2023 18:38:38 -0700
Message-Id: <20230421013850.349646-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421013850.349646-1-saeed@kernel.org>
References: <20230421013850.349646-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add additinal items to domain info dump: Linux version and device name.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
index ea9f27db4c74..552c7857ca1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
@@ -4,6 +4,7 @@
 #include <linux/debugfs.h>
 #include <linux/kernel.h>
 #include <linux/seq_file.h>
+#include <linux/version.h>
 #include "dr_types.h"
 
 #define DR_DBG_PTR_TO_ID(p) ((u64)(uintptr_t)(p) & 0xFFFFFFFFULL)
@@ -632,9 +633,15 @@ dr_dump_domain(struct seq_file *file, struct mlx5dr_domain *dmn)
 	u64 domain_id = DR_DBG_PTR_TO_ID(dmn);
 	int ret;
 
-	seq_printf(file, "%d,0x%llx,%d,0%x,%d,%s\n", DR_DUMP_REC_TYPE_DOMAIN,
+	seq_printf(file, "%d,0x%llx,%d,0%x,%d,%u.%u.%u,%s,%d\n",
+		   DR_DUMP_REC_TYPE_DOMAIN,
 		   domain_id, dmn->type, dmn->info.caps.gvmi,
-		   dmn->info.supp_sw_steering, pci_name(dmn->mdev->pdev));
+		   dmn->info.supp_sw_steering,
+		   /* package version */
+		   LINUX_VERSION_MAJOR, LINUX_VERSION_PATCHLEVEL,
+		   LINUX_VERSION_SUBLEVEL,
+		   pci_name(dmn->mdev->pdev),
+		   0); /* domain flags */
 
 	ret = dr_dump_domain_info(file, &dmn->info, domain_id);
 	if (ret < 0)
-- 
2.39.2

