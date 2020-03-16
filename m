Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A85F8187433
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 21:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732609AbgCPUr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 16:47:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732602AbgCPUr1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 16:47:27 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 658DF20736;
        Mon, 16 Mar 2020 20:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584391646;
        bh=05sPixts01WaYedUXMEihCusrO1iqQpFTSN9kYfKPuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=koyEqcBamf5FLsveBuaubrWnh7EBT8OvIsQFiEY6QAVAm4lziR1IcWjS+/3Ilq30S
         fYnimo2mnehNKji7mGnHWDGkbJ/GZlSQ1RWrceQnWcJEv85FfyFPDz8nsbr4wktbey
         0E7bmtvBISQxfCiLXebmrB2ppUl2cShjSVtDr+zw=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        ecree@solarflare.com, mhabets@solarflare.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        Jose.Abreu@synopsys.com, andy@greyhouse.net,
        grygorii.strashko@ti.com, andrew@lunn.ch, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/9] net: cpsw: reject unsupported coalescing params
Date:   Mon, 16 Mar 2020 13:47:08 -0700
Message-Id: <20200316204712.3098382-6-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200316204712.3098382-1-kuba@kernel.org>
References: <20200316204712.3098382-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->supported_coalesce_params to let
the core reject unsupported coalescing parameters.

This driver did not previously reject unsupported parameters.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/ti/cpsw.c     | 1 +
 drivers/net/ethernet/ti/cpsw_new.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 6ae4a72e6f43..c2c5bf87da01 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1211,6 +1211,7 @@ static int cpsw_set_channels(struct net_device *ndev,
 }
 
 static const struct ethtool_ops cpsw_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS,
 	.get_drvinfo	= cpsw_get_drvinfo,
 	.get_msglevel	= cpsw_get_msglevel,
 	.set_msglevel	= cpsw_set_msglevel,
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 71215db7934b..9209e613257d 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1175,6 +1175,7 @@ static int cpsw_set_channels(struct net_device *ndev,
 }
 
 static const struct ethtool_ops cpsw_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS,
 	.get_drvinfo		= cpsw_get_drvinfo,
 	.get_msglevel		= cpsw_get_msglevel,
 	.set_msglevel		= cpsw_set_msglevel,
-- 
2.24.1

