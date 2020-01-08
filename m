Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4818E13445D
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 14:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgAHN5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 08:57:17 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34179 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgAHN5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 08:57:16 -0500
Received: by mail-pf1-f196.google.com with SMTP id i6so1689429pfc.1;
        Wed, 08 Jan 2020 05:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qW90h0u7OkzvuxRNBAEqi37oJNoUhGwMxLdMwSq1ERo=;
        b=ZuGH2Wj7E14zCp5yindCZWoGHDv7ZOtdQkjnWFD/TfhMWtzS5Xjx+Ks05Fl2umCQxf
         EwAYwY4mV93SL+T2LKRB2AKRlzgneyqlPV9+PBcc+kYeq0wtMtXTqZzh+iMfAGZykg5t
         bsXvfP9i0+/OUWaiq8Yb/DbC56N6DhngQyjiL/KvhG0SBBWjGObMFVfuZpH/KoawWCEC
         kZ++1T2HP0Zo17uKVoZgu5w2akM4e0txuiFbtd0x2Mp5QarS++fKapcAfnehZ0Y6DmGT
         +jkspmJJdJmz24vJoFEOMTHp7MjLgC84FQk7mylrMVEbCBsKb73X2F0mFKvAE2/+TKAX
         9OWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qW90h0u7OkzvuxRNBAEqi37oJNoUhGwMxLdMwSq1ERo=;
        b=irkSqW3IJTr6h2/5AcK5yIbYJoTdJYoYLTvRRzDodhWkRhQEsacc/SUYuADmf17v/i
         IdS/DzETX5nlteR8oemdEHDfh69iSXZiqaWWg8jD1FHdgxtoXceVexOWLfsyKthk7/6S
         OzU3fq9fAlBrIHZNxDPBzfkO6RHoh1O7g6wqYm8iCel3VcJr/ZdFWd0azO55Jt1oIWYk
         KVjnkLn1k8naGHbMwZQEZAQ583hAbD0dP8piaJWp1GNx4HLCNDObpJtevvbeBDoUiTmU
         n97+fEa6lBJDsD8B122DsI2Qilgpa4jSRjkDKUpkvhzxwfcmadekL0m4X6WhEFEQYGkp
         4LSg==
X-Gm-Message-State: APjAAAXqZhLsSe8vvvLMK5PqyvDFlEgEJ5WE/Sbh8R2/tDxQvb1TZXGM
        eO1mDRI1E2kDHjOsDH7C2Jc=
X-Google-Smtp-Source: APXvYqzMlnEoYbJ22LLGcHWee0yQGtrOCZXdglioPZIVFM1/YGxuYCvFUALBewJvzxtmga1BAo495w==
X-Received: by 2002:a65:56c9:: with SMTP id w9mr5145925pgs.296.1578491835938;
        Wed, 08 Jan 2020 05:57:15 -0800 (PST)
Received: from localhost (199.168.140.36.16clouds.com. [199.168.140.36])
        by smtp.gmail.com with ESMTPSA id s185sm3984867pfc.35.2020.01.08.05.57.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Jan 2020 05:57:15 -0800 (PST)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH v3] net: stmmac: pci: remove the duplicate code of set phy_mask
Date:   Wed,  8 Jan 2020 21:56:49 +0800
Message-Id: <20200108135649.6091-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All members of mdio_bus_data are cleared to 0 when it was obtained
by devm_kzalloc(). so It doesn't need to set phy_mask as 0 again.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---

Changes since v2:
    Abandoned the other commits, now only this one commit is
    in the patch set.

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

