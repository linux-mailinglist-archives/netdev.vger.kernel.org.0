Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50EA546ADB
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 18:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349840AbiFJQsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349781AbiFJQrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:47:52 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5FAB5272;
        Fri, 10 Jun 2022 09:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654879671; x=1686415671;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tfHmXri7R6Bw+I2ET1tz+X8i7YZFY1rCt76KxR+OC/A=;
  b=jtzR6WxHUZTMpwAwxfIvyKlIhcON+q4hC+TSObOl3F5nPuyFxxe6Z/Br
   jGE9L/Dy1C+bzE5DjRIOiybEcVW8h3EwAXu9vJ6lQbv/XO98gGwG/ka6J
   mQQFF8+Y8DIIv/U5qsSJoAdIoaG92rs4MTb8liUznUMTeMlX/px13r9vS
   /eu1gxv53MI7V1JfQLZ0Z/J574L0rRsuUIjM0UNIlcmaNoqwAqwPWSZW4
   y0us2a98RLOYPAa1M3QQgIefPji5VNZi/ItsCdkjjnAppk/bFouwcJUeL
   ZyB7ZalHoGE3Idw50trWO9dv8fL4Lkqm8X/pJrgJzizcS3m/i7YSQYBKd
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="275209626"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="275209626"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:47:51 -0700
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="638211051"
Received: from unknown (HELO jiaqingz-server.sh.intel.com) ([10.239.48.171])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:47:49 -0700
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Subject: [PATCH 4/6] ftgmac100: Remove enable NCSI VLAN filtering
Date:   Sat, 11 Jun 2022 00:45:53 +0800
Message-Id: <20220610164555.2322930-5-jiaqing.zhao@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610164555.2322930-1-jiaqing.zhao@linux.intel.com>
References: <20220610164555.2322930-1-jiaqing.zhao@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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

