Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F55652BA6E
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbiERMdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236636AbiERMcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:32:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073E119CB41;
        Wed, 18 May 2022 05:29:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 800FDB81F40;
        Wed, 18 May 2022 12:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B634CC36AE3;
        Wed, 18 May 2022 12:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876903;
        bh=CjDagl7s1yUewHYXWMFrzcpaB6LIIM2ZSZMxbuBP6VU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Djmi/PE3M69y5It1rSsxtcLhTyCgknEQcdz1bndE+4b0P3iHLP3pgYqQryWShA/9Z
         1db9m+9nCGfYojnwgc86Eblhc31zJp7mUgwTdUU7MPQMbumdi7VC7y3Y5MMkp+BITm
         zAvjXAu3BM3ty2W+vSi+F59do2XG4mQsjzHl2JV80Jg8c00Htj/XVrJT9OeQ8pMtk1
         bUoW9nZz+rSoXxFCBVaIe6+m4l8/GjrKbIAEjF4QRWn7etA6Q2rguOpHT1m1Q+Hwa/
         gjPbQGClxcGR/8oFcrc9LuqC4u5PSg3haAFh0iQyQFWYHn3A4ggQzbtrFrzEA7XNpl
         wDaIiy9/TgJFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 11/17] net: stmmac: fix missing pci_disable_device() on error in stmmac_pci_probe()
Date:   Wed, 18 May 2022 08:27:45 -0400
Message-Id: <20220518122753.342758-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122753.342758-1-sashal@kernel.org>
References: <20220518122753.342758-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 0807ce0b010418a191e0e4009803b2d74c3245d5 ]

Switch to using pcim_enable_device() to avoid missing pci_disable_device().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20220510031316.1780409-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index fcf17d8a0494..644bb54f5f02 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -181,7 +181,7 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
 		return -ENOMEM;
 
 	/* Enable pci device */
-	ret = pci_enable_device(pdev);
+	ret = pcim_enable_device(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "%s: ERROR: failed to enable device\n",
 			__func__);
@@ -241,8 +241,6 @@ static void stmmac_pci_remove(struct pci_dev *pdev)
 		pcim_iounmap_regions(pdev, BIT(i));
 		break;
 	}
-
-	pci_disable_device(pdev);
 }
 
 static int __maybe_unused stmmac_pci_suspend(struct device *dev)
-- 
2.35.1

