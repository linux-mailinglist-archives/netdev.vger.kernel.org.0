Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED14C546AF2
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 18:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349927AbiFJQu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349891AbiFJQuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:50:00 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D99629348;
        Fri, 10 Jun 2022 09:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654879799; x=1686415799;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tfHmXri7R6Bw+I2ET1tz+X8i7YZFY1rCt76KxR+OC/A=;
  b=g2uH6vvQBFoq/+KB/mGvqX+5neZxSeTcl8jeRZCtLNlE551kRdXbOQXg
   h/x6pcuJKJmTxfWoaFXfdJ+hliFOuIqjZbxvSdE2Za0x/nYv6f1qEoYH4
   bMbUiZy/7UAFxsrwvD5Q3qw8uad33nu2IJApYpdxs78mFFf33/v4pl8eW
   KLBceLEwwEqha4vu6w53lq7UY8gpQ+xWH3vCnYcrIln2HDFTLpy3Z4VHu
   Z4fPsHUY5okQ3NgSwCzOspa9C99A/0SE/ycRLuzyrpnIwCYkfF2ny5AyM
   spGcT6HXX+bXSvs5sqMgoGS0gzv1XLH3MIeaDH+Wk8e0TTik41XTCSNcj
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="339432559"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="339432559"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:49:59 -0700
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="760587730"
Received: from unknown (HELO jiaqingz-server.sh.intel.com) ([10.239.48.171])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:49:57 -0700
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Subject: [PATCH 4/6] ftgmac100: Remove enable NCSI VLAN filtering
Date:   Sat, 11 Jun 2022 00:48:06 +0800
Message-Id: <20220610164808.2323340-5-jiaqing.zhao@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610164808.2323340-1-jiaqing.zhao@linux.intel.com>
References: <20220610164808.2323340-1-jiaqing.zhao@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting NETIF_F_HW_VLAN_CTAG_FILTER flag to enable NCSI VLAN filtering
has been moved to the NCSI driver, the logic in ftgmac100 driver is no
longer needed.

Signed-off-by: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 5231818943c6..18821ca38795 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1922,9 +1922,6 @@ static int ftgmac100_probe(struct platform_device *pdev)
 		NETIF_F_GRO | NETIF_F_SG | NETIF_F_HW_VLAN_CTAG_RX |
 		NETIF_F_HW_VLAN_CTAG_TX;
 
-	if (priv->use_ncsi)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
-
 	/* AST2400  doesn't have working HW checksum generation */
 	if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac")))
 		netdev->hw_features &= ~NETIF_F_HW_CSUM;
-- 
2.34.1

