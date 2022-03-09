Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C214D358B
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236430AbiCIQfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238727AbiCIQbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:31:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B289B19E09C;
        Wed,  9 Mar 2022 08:26:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FC61B821FD;
        Wed,  9 Mar 2022 16:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FE6C340E8;
        Wed,  9 Mar 2022 16:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646843173;
        bh=xJBSn76E9PKCTLlarn4j0dJ68y7h4PCKxgMJLeDjSko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+6cCVJg2cgVPG+x8vBMAB7AILDZmPfZgocXCTUXFtSeKKinfAGWiJvWDuSrl1IGA
         SQaEkz+NRq0AKHIw2G5ocv4HnYSf5BBRmFX923Wgb9QUJXrm7H0TU5t/a0W6RKMbw1
         kdjUtUftndNhDDl0Pje9FXx6Go1NBrlfbuZIHpEOn+f3aAXpBAkcrckA+QKEvdjPzA
         OCC/vAS0T1sf+GGCI9j++Gw+slCk3HVnOueDYe7qRhAuXIDcNM2rSCCtlG6w3Yd6cT
         Byjzp2ijW4EfMI/Yfvo0oSpPFK71iXYthaaWu0RZdawfGbOalhTXmsqxHcZEsUdUf4
         8lD/N8oUBWntw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, rmody@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/14] bnx2: Fix an error message
Date:   Wed,  9 Mar 2022 11:25:06 -0500
Message-Id: <20220309162508.137035-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309162508.137035-1-sashal@kernel.org>
References: <20220309162508.137035-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 8ccffe9ac3239e549beaa0a9d5e1a1eac94e866c ]

Fix an error message and report the correct failing function.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 9993f1162ac6..65acffc90010 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -8235,7 +8235,7 @@ bnx2_init_board(struct pci_dev *pdev, struct net_device *dev)
 		rc = pci_set_consistent_dma_mask(pdev, persist_dma_mask);
 		if (rc) {
 			dev_err(&pdev->dev,
-				"pci_set_consistent_dma_mask failed, aborting\n");
+				"dma_set_coherent_mask failed, aborting\n");
 			goto err_out_unmap;
 		}
 	} else if ((rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) != 0) {
-- 
2.34.1

