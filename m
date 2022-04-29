Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D78E514890
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 13:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358713AbiD2Lyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 07:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358676AbiD2Lyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 07:54:46 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6693AC6EC8;
        Fri, 29 Apr 2022 04:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651233088; x=1682769088;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vUGUX7Nvc/8LjzsG1/1jXvrhtbo00tkto7h2bu3JZ70=;
  b=H4DSI1d+94Djdk3XQD/VbKAY2wwOazJtVUnjc6AqU7ayVl8Ihh5xw/hQ
   djKsrR45uV5NYLqM33Lqa0aIQo6SNYPeAgAI9ZjrQvoXYpYuVCiBHSQve
   7aN4RqDOzFQpzlfg15Y80nJD5RAirT2kb7D7tgzde/AJzy12LsfpUmi8B
   GXXb8gy5+ZgLpdim8rHfj9a4tl7+NXpPfNVR2gcWB2ueSUu5ZRchO6SGp
   fbg0vhNDGrnVtdfk98i5XzgdRafq8xdg5ZxlJ2k/BQkw9DdTtVqACvWOg
   /NpcPba+nQREkDMy9QbXbcBR1iLaUb2nHhzl0z8gP/5o607bvMxAESrOG
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="329565488"
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="329565488"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 04:51:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="582085655"
Received: from p12hl01tmin.png.intel.com ([10.158.65.175])
  by orsmga008.jf.intel.com with ESMTP; 29 Apr 2022 04:51:21 -0700
From:   Tan Tee Min <tee.min.tan@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Ling Pei Lee <pei.lee.ling@intel.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Matthew Hagan <mnhagan88@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Wei Feng <weifeng.voon@intel.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>,
        Ong@vger.kernel.org, Boon Leong <boon.leong.ong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>
Subject: [PATCH net v2 1/1] net: stmmac: disable Split Header (SPH) for Intel platforms
Date:   Fri, 29 Apr 2022 19:58:07 +0800
Message-Id: <20220429115807.2198448-1-tee.min.tan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on DesignWare Ethernet QoS datasheet, we are seeing the limitation
of Split Header (SPH) feature is not supported for Ipv4 fragmented packet.
This SPH limitation will cause ping failure when the packets size exceed
the MTU size. For example, the issue happens once the basic ping packet
size is larger than the configured MTU size and the data is lost inside
the fragmented packet, replaced by zeros/corrupted values, and leads to
ping fail.

So, disable the Split Header for Intel platforms.

v2: Add fixes tag in commit message.

Fixes: 67afd6d1cfdf("net: stmmac: Add Split Header support and enable it
in XGMAC cores")
Cc: <stable@vger.kernel.org> # 5.10.x
Suggested-by: Ong, Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 include/linux/stmmac.h                            | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 63754a9c4ba7..0b0be0898ac5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -454,6 +454,7 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	plat->has_gmac4 = 1;
 	plat->force_sf_dma_mode = 0;
 	plat->tso_en = 1;
+	plat->sph_disable = 1;
 
 	/* Multiplying factor to the clk_eee_i clock time
 	 * period to make it closer to 100 ns. This value
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4a4b3651ab3e..2525a80353b7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7021,7 +7021,7 @@ int stmmac_dvr_probe(struct device *device,
 		dev_info(priv->device, "TSO feature enabled\n");
 	}
 
-	if (priv->dma_cap.sphen) {
+	if (priv->dma_cap.sphen && !priv->plat->sph_disable) {
 		ndev->hw_features |= NETIF_F_GRO;
 		priv->sph_cap = true;
 		priv->sph = priv->sph_cap;
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 24eea1b05ca2..29917850f079 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -270,5 +270,6 @@ struct plat_stmmacenet_data {
 	int msi_rx_base_vec;
 	int msi_tx_base_vec;
 	bool use_phy_wol;
+	bool sph_disable;
 };
 #endif
-- 
2.25.1

