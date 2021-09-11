Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FC6407702
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 15:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbhIKNOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 09:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236348AbhIKNNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Sep 2021 09:13:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08210611BF;
        Sat, 11 Sep 2021 13:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365950;
        bh=EFMNFVAc5CcSijdhhhVHCaxpm6yJnxx8kYaKNOizbCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBMp8Gx8eUongj6OpSwfLMKLKZ/Vlf/9JE+rtHXUhqURe7gBUY8smYocC3K9pSKca
         4IdmfBinbUdwfNfr+IK6q3j1SowQlJZfQco2gjA8J8W9NrbcVqLlRqfM0IRvRyXQnC
         r81xMxtQ6TSslmDv+VbLhEnTqypbSD5E2o/ZO6wn8715crkbChGKu2DEkgWbZzh+Um
         xo/AwESeWa9kZVO8qIr7o1j5uGrgI75Hu8eb2b3Gt5BB4Zar46L7dMiyw8MFSQ2dOz
         rb3h6SuJD0Nw6keYLdpURDQZa2uS/ZClQGHbfFk44GF6clPlGhQ04FE5kG9Ul3p4xS
         9LM8DqE5vETuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhaoxiao <long870912@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 31/32] stmmac: dwmac-loongson:Fix missing return value
Date:   Sat, 11 Sep 2021 09:11:48 -0400
Message-Id: <20210911131149.284397-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131149.284397-1-sashal@kernel.org>
References: <20210911131149.284397-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhaoxiao <long870912@gmail.com>

[ Upstream commit 5289de5929d1758a95477a4d160195397ccffa7b ]

Add the return value when phy_mode < 0.

Signed-off-by: zhaoxiao <long870912@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index 4c9a37dd0d3f..ecf759ee1c9f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -109,8 +109,10 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 		plat->bus_id = pci_dev_id(pdev);
 
 	phy_mode = device_get_phy_mode(&pdev->dev);
-	if (phy_mode < 0)
+	if (phy_mode < 0) {
 		dev_err(&pdev->dev, "phy_mode not found\n");
+		return phy_mode;
+	}
 
 	plat->phy_interface = phy_mode;
 	plat->interface = PHY_INTERFACE_MODE_GMII;
-- 
2.30.2

