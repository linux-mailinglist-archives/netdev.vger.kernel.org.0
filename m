Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BFA41F6FD
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 23:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355786AbhJAVea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 17:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355627AbhJAVeV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 17:34:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40B4761AFA;
        Fri,  1 Oct 2021 21:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633123956;
        bh=9GVMcokCaHAF1/pks7IyV3D1gr+p8AVSWWEtNr1TnFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2Xc9MGI2p6bagmJgwjW2Py5M07UbRf7p8WFNm+KSN+cxHFV822TpqToc+RvQ6Wqo
         SYgDEEwazmIDiQYpSyjC3SWJmLm88rUFnFaVhEi0lxk8pOUZzd+zbidqD5i6YDVWVL
         cYOtwAE6J0Dlp+7/DIaA2ALNc6tOVT4XL/cN/6itcJuteLPCgJEfGjZSlhXjJp59kR
         PPgsU9mDAuBjaateeuwqF+AQG6hCF8PvIzU56BBdcFjOQ3K2gJAYkt+RNQAnrxauaA
         Mjt6uSUtxvdPQwudo6h/S313qdXI6iwzsYx9kdLbLlnxDdLoSA/DbNigXDJ87rPExj
         b5TK76MfqcoWw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jon Mason <jdmason@kudzu.us>
Subject: [PATCH net-next 09/11] ethernet: s2io: use eth_hw_addr_set()
Date:   Fri,  1 Oct 2021 14:32:26 -0700
Message-Id: <20211001213228.1735079-10-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001213228.1735079-1-kuba@kernel.org>
References: <20211001213228.1735079-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Manual conversions because we need to get to the member
which is inside an array to have a u8 pointer which
eth_hw_addr_set() expects.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: Jon Mason <jdmason@kudzu.us>
---
 drivers/net/ethernet/neterion/s2io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 09c0e839cca5..7e325d1697a9 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -7954,7 +7954,7 @@ s2io_init_nic(struct pci_dev *pdev, const struct pci_device_id *pre)
 
 	/*  Set the factory defined MAC address initially   */
 	dev->addr_len = ETH_ALEN;
-	memcpy(dev->dev_addr, sp->def_mac_addr, ETH_ALEN);
+	eth_hw_addr_set(dev, sp->def_mac_addr[0].mac_addr);
 
 	/* initialize number of multicast & unicast MAC entries variables */
 	if (sp->device_type == XFRAME_I_DEVICE) {
-- 
2.31.1

