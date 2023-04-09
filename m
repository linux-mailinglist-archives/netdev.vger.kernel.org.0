Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 926406DBF17
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 09:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjDIHsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 03:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjDIHsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 03:48:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE54B4ED4
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 00:48:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BC4460B80
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 07:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04101C433D2;
        Sun,  9 Apr 2023 07:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681026530;
        bh=dojCTeewzm7AIfWw8FOjfghikl4OOaq/mLUzvXf3QgI=;
        h=From:To:Cc:Subject:Date:From;
        b=a99UV+bvxeOdxnUcfiDUT/llsDMbIMg5NGOE9+C36f35VCzpCUEdgRmU8Vjq0xqUV
         1VRC5XVZMQeHAwdSyX5ICQh5Q5NPYL0O86WItquHT5O23IZ+KlKYk1RdBHraKrGRQW
         2AuR4Q61XXs4NvWAG4HtK04A7FimZMkViOTh2XfwA57jl3RHVpZ39A1lOAVWKwt98H
         os2asJhD5ETO3RoiY1ZYoozmv1/WdvkpYSajMUr58HgPiZrQtApaDC0FVUNXBlGVdV
         bUk92TU+/l+bJj1X8EaqgIctYrMg8IEpKIOrWxJM62SWqo9I5BsQgbADpdek5itoXN
         YtQRObnKNSF1Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next] net/mlx5: Include proper PCI headers file to fix compilation error
Date:   Sun,  9 Apr 2023 10:48:43 +0300
Message-Id: <33205aa15efbafa9330a00f2f6f8651add551f49.1681026343.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Fix the following compilation error, which happens due to missing pci.h
include.

 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c:148:31: error: implicit declaration of function
'pci_msix_can_alloc_dyn' [-Werror=implicit-function-declaration]

Fixes: 3354822cde5a ("net/mlx5: Use dynamic msix vectors allocation")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index e12e528c09f5..bb97d6ff8135 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -5,6 +5,7 @@
 #include <linux/notifier.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/vport.h>
+#include <linux/pci.h>
 #include "mlx5_core.h"
 #include "mlx5_irq.h"
 #include "pci_irq.h"
-- 
2.39.2

