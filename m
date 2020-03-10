Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE66717EE73
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgCJCP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:15:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726643AbgCJCPV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 22:15:21 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7381924676;
        Tue, 10 Mar 2020 02:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583806520;
        bh=zF94QLxW4m8csMdnIN9U+WLinBfOUFO91FDuzOcdbQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZ3TgEaLKtLYDJF8PXu1MnzLHDTYXuCvneJxSAI0EvXNsWElwyagr0t/WMRm5ccQz
         SmHCYrptzmMcShtEUoSh5JKL5bhlYVJd+lVhEae2ULU+YI26SYReM0YUjsvsk99xns
         QXWD0LWxmkelS9FhieMK4IWWycqqHgMjjlnrAGvk=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, akiyano@amazon.com, netanel@amazon.com,
        gtzalik@amazon.com, irusskikh@marvell.com, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, rmody@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, aelior@marvell.com,
        skalluru@marvell.com, GR-everest-linux-l2@marvell.com,
        opendmb@gmail.com, siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, tariqt@mellanox.com, vishal@chelsio.com,
        leedom@chelsio.com, ulli.kroll@googlemail.com,
        linus.walleij@linaro.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 04/15] net: bnx2: reject unsupported coalescing params
Date:   Mon,  9 Mar 2020 19:15:01 -0700
Message-Id: <20200310021512.1861626-5-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310021512.1861626-1-kuba@kernel.org>
References: <20200310021512.1861626-1-kuba@kernel.org>
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
 drivers/net/ethernet/broadcom/bnx2.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 62e44f52580d..e1c236cab2a7 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -7812,6 +7812,11 @@ static int bnx2_set_channels(struct net_device *dev,
 }
 
 static const struct ethtool_ops bnx2_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_USECS_IRQ |
+				     ETHTOOL_COALESCE_MAX_FRAMES_IRQ |
+				     ETHTOOL_COALESCE_STATS_BLOCK_USECS,
 	.get_drvinfo		= bnx2_get_drvinfo,
 	.get_regs_len		= bnx2_get_regs_len,
 	.get_regs		= bnx2_get_regs,
-- 
2.24.1

