Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4EA71824F4
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387469AbgCKWdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:33:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387412AbgCKWdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 18:33:18 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEC5220768;
        Wed, 11 Mar 2020 22:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583965998;
        bh=JLJTfmLMhvgovHL3TFJY94u6dR2CKasrJ+XunuPsEnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vwPszCMKOi30PFTnJCaq8YA+BvZ4qaw+OcszPU+2BFkktGyUkYVlXrvLNLohTn6yj
         w3LfQerjQd6ke1hHaJlcKlMEK5S0rOvZA0LkZ8VYkT0ArDvaZRrSxwLHB5Z8bT091F
         Var7al4EaCMMiLPWZ1h6qZwboz/vsgp8dv213G54=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        madalin.bucur@nxp.com, fugang.duan@nxp.com, claudiu.manoil@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 10/15] net: iavf: reject unsupported coalescing params
Date:   Wed, 11 Mar 2020 15:32:57 -0700
Message-Id: <20200311223302.2171564-11-kuba@kernel.org>
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
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index f807e2c7597f..2c39d46b6138 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -996,6 +996,10 @@ static int iavf_set_rxfh(struct net_device *netdev, const u32 *indir,
 }
 
 static const struct ethtool_ops iavf_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_MAX_FRAMES_IRQ |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE,
 	.get_drvinfo		= iavf_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
 	.get_ringparam		= iavf_get_ringparam,
-- 
2.24.1

