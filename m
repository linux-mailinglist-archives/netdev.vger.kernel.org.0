Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE3A374487
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236389AbhEEQ6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236591AbhEEQyf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:54:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 269C66198F;
        Wed,  5 May 2021 16:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232718;
        bh=RCxLgN7/gkXsKhym5ThqqgbVTx9xWZPHnifZLnamMSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCwafsOkYp72QEq723Ye10qkIkqtsggLkCi0nwbGONXm/MSu8a4OXEYqwukNWKSY7
         xbQ6bDSFfeSixytn3gVP86dM8kvfv0hdZxhCbiWWPIRdNk8RI9XkjUpZ2YAmfRvs1o
         NCfSJxDY5vsqEfxvt6E4WGUKC2BDUMI7QOghOwHBp2ol1rJI9vGedJoCWlSg6+JEZL
         PQeGNzLpPBvz5Vaava5JzFjHLRHJVPFYjNc1Vu7T3xUaYUZWXzIZP018MtZWw4KJx/
         rBESJqw91i7OHE2eS0GS72tuUkDWRuy0kS1/kx4djLCkd56ln5XSq5dua3Op/K+kVq
         qbgJ09FTjnrAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Assmann <sassmann@kpanic.de>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 75/85] iavf: remove duplicate free resources calls
Date:   Wed,  5 May 2021 12:36:38 -0400
Message-Id: <20210505163648.3462507-75-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

[ Upstream commit 1a0e880b028f97478dc689e2900b312741d0d772 ]

Both iavf_free_all_tx_resources() and iavf_free_all_rx_resources() have
already been called in the very same function.
Remove the duplicate calls.

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index dc5b3c06d1e0..ebd08543791b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3899,8 +3899,6 @@ static void iavf_remove(struct pci_dev *pdev)
 
 	iounmap(hw->hw_addr);
 	pci_release_regions(pdev);
-	iavf_free_all_tx_resources(adapter);
-	iavf_free_all_rx_resources(adapter);
 	iavf_free_queues(adapter);
 	kfree(adapter->vf_res);
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
-- 
2.30.2

