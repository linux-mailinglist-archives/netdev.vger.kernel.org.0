Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D403743BE
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbhEEQvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:51:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235461AbhEEQqd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:46:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3505661945;
        Wed,  5 May 2021 16:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232591;
        bh=RCxLgN7/gkXsKhym5ThqqgbVTx9xWZPHnifZLnamMSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0QEA9oWj4Fwps0cxlqZ6ByPOd5hGjfNCOyd7Srk4aeGZMYL0alybHDoD3iHuj+Sa
         n6K+smDRXM4UoqoC6EJVOny2gYE7oXaADHSXSr/STDJSTRTn6nBp1eppxT1otSj+BL
         8/VBm1GP4HnGoNuITpKGJzyJ2XhcnRWp3d3toQ4f/BEUWh6ZwAEuOmLpDhJHjWHql1
         o8bm0hAUMH9X+MgtpC255abq+eHnBadseeZqVon5E00Bh/wmSyktkzsiv8W1/pAWpW
         b3eBcMaNvaw3x8tMQf3rOvXIFU1Hdolg6Hzvqlfc8X2MaAJF0QBVsZtNqYtVY6U7tI
         Auz9VDBkD6EOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Assmann <sassmann@kpanic.de>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 094/104] iavf: remove duplicate free resources calls
Date:   Wed,  5 May 2021 12:34:03 -0400
Message-Id: <20210505163413.3461611-94-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
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

