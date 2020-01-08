Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8653213394F
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 03:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgAHC4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 21:56:31 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40870 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgAHC4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 21:56:30 -0500
Received: by mail-pg1-f194.google.com with SMTP id k25so814503pgt.7;
        Tue, 07 Jan 2020 18:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QyroB5LXjxb8iNcU2ElAPCjALtlsDRJIi4SawaB0E7c=;
        b=E3n6Gk5MirvuWn2qz2nIHVm+5Hxjz4Nq4wAdMyekVm9lA2tuXwuqxrIjy+bHKC6aRy
         29YP9weDLGP7P9gpfg+rJTz8bKsZdziuhhe78aqk5P0FQYw1x1Cxt19eIwU3FiJ6Y/k7
         NwXUcOVepPCx6qcmZeR+tgGPaRqDgKb8TnZr5eOO6Qw/aIROygskXs0fAuif0zs0puaX
         h/4PakQlPNNXEue27pSySzbAqBiXhfLYjmtKEBgQj+uimEl4Q+aHoJ78jWSQW04VJ+Z7
         glvcWowQ6cbxVX7rUq4/7W7IeFANAJQqoleuAoftLI05xvciZ6epm3pCB+V5Xm/OFS0B
         6TWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QyroB5LXjxb8iNcU2ElAPCjALtlsDRJIi4SawaB0E7c=;
        b=Tsys2dIjoPGjgqC9hm8y7YPb1jfid5PTLacHU/Oifn0puzzfXN4PLKIF5oMh1xYMlO
         Lhi2qt31xkQ7Br3iGsoXhO6pYLwdNxy251rs+sv1o4gvvwWqOXse7nt4cco/VOddEF1O
         0Ct8TYbyI10HlbOVQoofw3oQgtYq4KGzBrhw4Ayh6pO6+VGj3Ns56F6lPOfEKOrGV+Ys
         aS2Gp95ihj0WrIE1zCWMi1hFgZCTrYe9SqTBPP60dpWUcbEzn2eqXNvlI0jL9QvTSF+i
         Ol2kSZZPJgx3GOt8LoQrGrzFgzKH8pPNDrAAyQuw1gSXKen/KFtG0LVb3rXlmWm9OcpU
         VrvA==
X-Gm-Message-State: APjAAAV0R3f2WNqg/FHCJp0mirMiCRKtqhikw7lHwLaagWa11yXWliID
        n01K80aEqatADyWVtRfU+OA=
X-Google-Smtp-Source: APXvYqx2B0gxIFJca1dgjrpJf7auzNgufbWz8vdqEcAFaSebP15mW1okQWAH7ySFcWH1sK9e1o+WwA==
X-Received: by 2002:a65:538b:: with SMTP id x11mr2823226pgq.395.1578452189886;
        Tue, 07 Jan 2020 18:56:29 -0800 (PST)
Received: from localhost (199.168.140.36.16clouds.com. [199.168.140.36])
        by smtp.gmail.com with ESMTPSA id 144sm1021480pfc.124.2020.01.07.18.56.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 Jan 2020 18:56:29 -0800 (PST)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH] net: stmmac: pci: remove the duplicate code of phy_mask
Date:   Wed,  8 Jan 2020 10:56:24 +0800
Message-Id: <20200108025624.13968-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value of phy_mask will be passed to phy_mask of struct mii_bus
before register mdiobus, the mii_bus was obtained by mdiobus_alloc()
and set mii_bus->phy_mask as zero by default. so It doesn't need to
set phy_mask as zero again in this driver.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 8237dbc3e991..40f171d310d7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -65,7 +65,6 @@ static void common_default_data(struct plat_stmmacenet_data *plat)
 	plat->force_sf_dma_mode = 1;
 
 	plat->mdio_bus_data->needs_reset = true;
-	plat->mdio_bus_data->phy_mask = 0;
 
 	/* Set default value for multicast hash bins */
 	plat->multicast_filter_bins = HASH_TABLE_SIZE;
@@ -154,8 +153,6 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	plat->tx_queues_cfg[6].weight = 0x0F;
 	plat->tx_queues_cfg[7].weight = 0x10;
 
-	plat->mdio_bus_data->phy_mask = 0;
-
 	plat->dma_cfg->pbl = 32;
 	plat->dma_cfg->pblx8 = true;
 	plat->dma_cfg->fixed_burst = 0;
@@ -386,8 +383,6 @@ static int snps_gmac5_default_data(struct pci_dev *pdev,
 	plat->tso_en = 1;
 	plat->pmt = 1;
 
-	plat->mdio_bus_data->phy_mask = 0;
-
 	/* Set default value for multicast hash bins */
 	plat->multicast_filter_bins = HASH_TABLE_SIZE;
 
-- 
2.17.1

