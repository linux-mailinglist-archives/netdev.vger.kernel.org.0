Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB52F1824F9
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387505AbgCKWdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:33:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387491AbgCKWdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 18:33:22 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05C4D20756;
        Wed, 11 Mar 2020 22:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583966002;
        bh=NciDB0rXj/F5X4M+azZ2hqsHjFDZfxuYSBq+z/wVRRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zytAZtJlu+bGgHAPJGergb+rfC2BMIsZ/yOkegx9L+wy/jXyZM6mYj4n9CxglL46Y
         xGCOmc+PQi3pMBVzmwjDU2ZKnENl4YVr/driGfXvcm7AhPOYE/9hrTu8dgv2KpCy45
         v0w19wjrsz3GFmep4Yd1zeGvE+mQ8Md7TiF7SPYo=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        madalin.bucur@nxp.com, fugang.duan@nxp.com, claudiu.manoil@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 15/15] net: ixgbevf: reject unsupported coalescing params
Date:   Wed, 11 Mar 2020 15:33:02 -0700
Message-Id: <20200311223302.2171564-16-kuba@kernel.org>
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
 drivers/net/ethernet/intel/ixgbevf/ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ethtool.c b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
index f7f309c96fa8..988fa49fa99a 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
@@ -968,6 +968,7 @@ static int ixgbevf_set_priv_flags(struct net_device *netdev, u32 priv_flags)
 }
 
 static const struct ethtool_ops ixgbevf_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS,
 	.get_drvinfo		= ixgbevf_get_drvinfo,
 	.get_regs_len		= ixgbevf_get_regs_len,
 	.get_regs		= ixgbevf_get_regs,
-- 
2.24.1

