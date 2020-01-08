Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51293133C44
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 08:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgAHH0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 02:26:39 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:56285 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbgAHH0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 02:26:38 -0500
Received: by mail-pj1-f65.google.com with SMTP id d5so673750pjz.5;
        Tue, 07 Jan 2020 23:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YgvywnLyYzODjdUN5pjBnIAoT8QXrKrof9jZ9KWS50M=;
        b=uJidx6V2kVrDoRpmQOqy4JLM9x5893Q3qDlXO6/DMPh9J1EyCqLWtKvbpB3Z6msKqg
         5DL89PlYEk6z3WSMFSLvW5H3UEoFOSYT94WkBEBxqGu1uuP+/Ty+LUD+3cMHtg0TockK
         CFznXxPOuKWpd4a+0bT3DaI68Apws19E/q7N8NT5fnXok79vlaZk/ABWhqY1sn5X/g+t
         vePRaCC9Nm0H89xhY1jlQujIMlrjsq1CMC/YnAYV10m4KlIuyZORz7ltiPih5NUngisk
         E4JU2H0JUuCoutaTj1grPfT2ebbLC0e6pltRWdoKwOPOBtiUWlai7vt63S6Ut5QJYS1v
         BHIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YgvywnLyYzODjdUN5pjBnIAoT8QXrKrof9jZ9KWS50M=;
        b=N1BlY7EgUXb0C/NAVZ41HuUeKldmZQ2/BYf5N6UgTDnY36UGZKQKWu/6BAj/sFDWlc
         oJlcz5tn8oxVeV/6sra4GStXCdaZWipVLlc8eKa8m++rA40hM+yj1rc01mca2g3U4K8t
         pnG1dfiV7Uz7PySvUrMFbx5XT8QZ8YpONkFns79FtGKYI5u35APQ0hJ4CcH9E9XMLCbW
         puhkgfsZboKDfrUYI43aqMLkBxmJ1VLi4YSElR3DQkB6b8fU7Owu4GXmuRut2h42+6+v
         m7bSzU6JY5LCLvuUfqDvtSle92eUg4ZPXqdpoD6Cr/3Zz1+o95ECThG5/4VXU21MYs9r
         /zbg==
X-Gm-Message-State: APjAAAVuksNEDGjHcJPBv/JZ9g3SxT5NuR/ZiVr3NcQ560uGNNEkzaDr
        jXTbgEtiCpacnXKgMcbj/Hg=
X-Google-Smtp-Source: APXvYqwH9CfosT7s9ifO/AANNX8jvBDu0cCJazDa/8NyLgjjws4FKAWfUxN4dlltGJliD+L0TTNA6Q==
X-Received: by 2002:a17:902:8c90:: with SMTP id t16mr3926013plo.186.1578468397944;
        Tue, 07 Jan 2020 23:26:37 -0800 (PST)
Received: from localhost (199.168.140.36.16clouds.com. [199.168.140.36])
        by smtp.gmail.com with ESMTPSA id o98sm1865266pjb.15.2020.01.07.23.26.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 Jan 2020 23:26:37 -0800 (PST)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, martin.blumenstingl@googlemail.com,
        treding@nvidia.com, andrew@lunn.ch, weifeng.voon@intel.com,
        tglx@linutronix.de
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH v2 1/2] net: stmmac: pci: remove the duplicate code of set phy_mask
Date:   Wed,  8 Jan 2020 15:25:49 +0800
Message-Id: <20200108072550.28613-2-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200108072550.28613-1-zhengdejin5@gmail.com>
References: <20200108072550.28613-1-zhengdejin5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All members of mdio_bus_data are cleared to 0 when it was obtained
by devm_kzalloc(). so It doesn't need to set phy_mask as 0 again.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---

Changes since v1:
    adjust some commit comments.

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

