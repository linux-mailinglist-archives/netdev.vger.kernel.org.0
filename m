Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6378C16950A
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgBWCfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:35:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728072AbgBWCWR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 21:22:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17AB020702;
        Sun, 23 Feb 2020 02:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424537;
        bh=wJ2KCp01KlNHuZcLWsvwY7KPtFEgX8jQ/ItsVEsLmVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zTRfBi3fUE1oNyJGw27NZyp6ces1ci1pSmRrZ73Gj3nxCjBYVWcTrapBg5YP6+f52
         0FqwLpdufsOWy5h2wibmZzpR8cNXxtFjqJHmmTPECH/fZDflu+f+gJmhDNoJ5kWYfO
         oY/tTbEEV5qsAoAbsYWiq51OO3c/BIvwdUrv8Ik8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Shelton <benjamin.h.shelton@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 47/58] ice: Use correct netif error function
Date:   Sat, 22 Feb 2020 21:21:08 -0500
Message-Id: <20200223022119.707-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022119.707-1-sashal@kernel.org>
References: <20200223022119.707-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Shelton <benjamin.h.shelton@intel.com>

[ Upstream commit 1d8bd9927234081db15a1d42a7f99505244e3703 ]

Use the correct netif_msg_[tx,rx]_error() function to determine whether to
print the MDD event type.

Signed-off-by: Ben Shelton <benjamin.h.shelton@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c9b35b202639d..7f71f06fa819c 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1235,7 +1235,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 		u16 queue = ((reg & GL_MDET_TX_TCLAN_QNUM_M) >>
 				GL_MDET_TX_TCLAN_QNUM_S);
 
-		if (netif_msg_rx_err(pf))
+		if (netif_msg_tx_err(pf))
 			dev_info(dev, "Malicious Driver Detection event %d on TX queue %d PF# %d VF# %d\n",
 				 event, queue, pf_num, vf_num);
 		wr32(hw, GL_MDET_TX_TCLAN, 0xffffffff);
-- 
2.20.1

