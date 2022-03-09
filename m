Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6414D371E
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235491AbiCIQe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239353AbiCIQc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:32:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521492FFE0;
        Wed,  9 Mar 2022 08:27:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 851A8619B9;
        Wed,  9 Mar 2022 16:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC4CC340F3;
        Wed,  9 Mar 2022 16:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646843231;
        bh=GsJT7pC84zhJIAYDDKykhSRzvICLvnRXFMOtZNy5ucA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/w/P6l0fJXlu8/+uqmM1iNrbEb1UaQsmx2anHlwhYHDd5RcNU/x+PbNlWbFTT79b
         mNYwjgEpbhZPBLaVwSyv49uzST4Bq38chGIZWfEmpi2DK4p0+c6Pk7DC9WRgfHXD5/
         13TW3vWl1MW8Pn8OeqYJ23Z459xg1uwmxOOSo6RJBQsK+T6vl9RrYDRnT8t3Be7vZI
         FPzJg2+hetAi3EOkkrPKnJoxUA+8bRL9r1QB9ed/PtFvvwB+unftVm+bcdaVngF9NA
         jQpa/rkKJ3e1XKoD1p5Ja2yro5QiR7POT6l4kUDuOOlvBFMXMEEK93ArFTdkUChqhJ
         TlwpxYTQYxzlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, rmody@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 11/12] bnx2: Fix an error message
Date:   Wed,  9 Mar 2022 11:26:16 -0500
Message-Id: <20220309162618.137226-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309162618.137226-1-sashal@kernel.org>
References: <20220309162618.137226-1-sashal@kernel.org>
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
index 299cefe6f94b..21e32d732c3f 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -8234,7 +8234,7 @@ bnx2_init_board(struct pci_dev *pdev, struct net_device *dev)
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

