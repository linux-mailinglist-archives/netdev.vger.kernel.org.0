Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F121B3741B9
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbhEEQko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234226AbhEEQjB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:39:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E05861584;
        Wed,  5 May 2021 16:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232432;
        bh=RCxLgN7/gkXsKhym5ThqqgbVTx9xWZPHnifZLnamMSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCRXPAVVo91idZGYVRactZBDhC/7TPoPCX1qWMhvrOwAcOTnze8m8Y9aqbasAK9rG
         BCInBF7lgkCDFTTTxeqE5MVsYES1aY95slQ6/hKVhidnanhkZDQt59ra+NnJ7FmaXm
         k8074hIaMrzroFDLBK5HyXkYH1UC2sxErqaE40Sy3v+44va2IIGKQ5YBt06FehWfpX
         0L+K2kciJE6qNqKRq3qk8Fx1qFqmrwYXeFu+oP3sDkoe+5fsYbhJTG6PIdP50x1BzL
         YVAmjU1w5TGc1m+ytC02J6RNrsrfX5UQUp9KZ9S/EkrsI9LrHZz1t06R9BOYE7oI0Y
         TmLsnb6/JtBfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Assmann <sassmann@kpanic.de>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 104/116] iavf: remove duplicate free resources calls
Date:   Wed,  5 May 2021 12:31:12 -0400
Message-Id: <20210505163125.3460440-104-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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

