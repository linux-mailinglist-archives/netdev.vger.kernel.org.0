Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB9A1824F5
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387483AbgCKWdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:33:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387476AbgCKWdU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 18:33:20 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 875CC20754;
        Wed, 11 Mar 2020 22:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583966000;
        bh=IZjE32cNPfrCsA261hM6rUQzaWjmB0wOkaX8g0K06oY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vo5LMHFP85w8yvrwET0DAxYkrYVnHBviG0JORjGBR0MzN4BEFsxizK0azZ4FI9sGk
         j9P5s0VWI4/1+r09PojPZJl+wjpV3KO1otf6nMNVcYqGv78j52FgUIF4dE7rAoHtcB
         fdxDgFRKToXxiW5e/zeSeSqYeU47AADBkD1qU99Q=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        madalin.bucur@nxp.com, fugang.duan@nxp.com, claudiu.manoil@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 12/15] net: igbvf: reject unsupported coalescing params
Date:   Wed, 11 Mar 2020 15:32:59 -0700
Message-Id: <20200311223302.2171564-13-kuba@kernel.org>
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
 drivers/net/ethernet/intel/igbvf/ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igbvf/ethtool.c b/drivers/net/ethernet/intel/igbvf/ethtool.c
index 3ae358b35227..9217d150e286 100644
--- a/drivers/net/ethernet/intel/igbvf/ethtool.c
+++ b/drivers/net/ethernet/intel/igbvf/ethtool.c
@@ -424,6 +424,7 @@ static void igbvf_get_strings(struct net_device *netdev, u32 stringset,
 }
 
 static const struct ethtool_ops igbvf_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS,
 	.get_drvinfo		= igbvf_get_drvinfo,
 	.get_regs_len		= igbvf_get_regs_len,
 	.get_regs		= igbvf_get_regs,
-- 
2.24.1

