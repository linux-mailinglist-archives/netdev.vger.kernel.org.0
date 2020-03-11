Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA8381824FE
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387544AbgCKWdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731330AbgCKWdN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 18:33:13 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 227892074F;
        Wed, 11 Mar 2020 22:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583965992;
        bh=IoBZ+maS4nexZK8c5eWbXLy/jh2CjB2l9DEus+/uqfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BPbTGmBXjnWvFHkYZb+9FbGlGB0VUQouThc0vvKmdQRbjw9Se1VbEObnNdkQnJ37O
         7EWeTyjOgXSa9x5qxW7R2zqsy+QdFrazrKjzGv5LasuupgdX/wb0+T6w+XCUXOXTDE
         /yBuBw7r32pz+7lDi6hruWqnOYDHFdmMGqHivneU=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        madalin.bucur@nxp.com, fugang.duan@nxp.com, claudiu.manoil@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 03/15] net: fec: reject unsupported coalescing params
Date:   Wed, 11 Mar 2020 15:32:50 -0700
Message-Id: <20200311223302.2171564-4-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200311223302.2171564-1-kuba@kernel.org>
References: <20200311223302.2171564-1-kuba@kernel.org>
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
 drivers/net/ethernet/freescale/fec_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index af7653e341f2..ce154695f67c 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2641,6 +2641,8 @@ fec_enet_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 }
 
 static const struct ethtool_ops fec_enet_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES,
 	.get_drvinfo		= fec_enet_get_drvinfo,
 	.get_regs_len		= fec_enet_get_regs_len,
 	.get_regs		= fec_enet_get_regs,
-- 
2.24.1

