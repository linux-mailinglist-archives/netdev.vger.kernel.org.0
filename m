Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469E537455D
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238154AbhEEREy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:04:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237191AbhEEQ7W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:59:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6FC4619AF;
        Wed,  5 May 2021 16:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232799;
        bh=XG8G87TVuOVi6GUNhXNTYQqH9ntP4FqUcblCmqCe8+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCBGBth4MDCveYo8KusoaQSdJ+LEH0EsRqgAf0os0BeLKPlqtlc2IWE5e39/JXfr5
         OKqyP0oNI00B3dnV1EnEE7tllIB2uNcIkJboQHlPURqiDqrdABWYIKvFRWMGpdULFW
         2giNWimHm9CP1ujhtaY1mLOdN6S/7PouA2tIHmuDgh+6utcx3/NHtGD12GUfE502z+
         Dto6KELWMWVuL6mIme3Qv9sGp87Sgkt139mRdtgDFMpsXCpX2KRLgowkLBdtyHZrs6
         MAckw9Qm8mT4jHWjByaNtL5ANlF1a+6u+Qfv1Y30sYEz3buxrzAgmPKecB1U5UaB3b
         TbDE6Fvib+T8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Assmann <sassmann@kpanic.de>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 43/46] iavf: remove duplicate free resources calls
Date:   Wed,  5 May 2021 12:38:53 -0400
Message-Id: <20210505163856.3463279-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163856.3463279-1-sashal@kernel.org>
References: <20210505163856.3463279-1-sashal@kernel.org>
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
index cffc8c1044f2..a97e1f9ca1ed 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3906,8 +3906,6 @@ static void iavf_remove(struct pci_dev *pdev)
 
 	iounmap(hw->hw_addr);
 	pci_release_regions(pdev);
-	iavf_free_all_tx_resources(adapter);
-	iavf_free_all_rx_resources(adapter);
 	iavf_free_queues(adapter);
 	kfree(adapter->vf_res);
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
-- 
2.30.2

