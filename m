Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30F64EEAAB
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 11:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344719AbiDAJrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 05:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbiDAJri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 05:47:38 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD5326B5A4;
        Fri,  1 Apr 2022 02:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648806349; x=1680342349;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UxLvpskW4rLuGgmQq0gOVH4HGX3wrTDJMXJXEcBsELM=;
  b=HPoeD5dVQA4CWAZHA2wysUtcLi/zcEfEJWbEwsPUIb7NhNkDtjU09C9O
   qMZ0OKc4wF+Re3iQIrRoAI/RVLpqzJZtkXev7JZkOKtmvYKExg2cg0Vjg
   vecIH3AHA9gzQjg7ZUuIfLNTx84IT4Mh+op56Yp04VDyZzFdBNZMFl40/
   fCXM0k7NNep5pMAqbWf2XcEPyCPv4iyoFKN7ARHQuFqFApSUEQVBFiHDk
   o6wSWLYmcDzGdJCFFsRzXayfYqazGS/kNfyLatAtNypstMiU7xnjSr/sz
   4TJmdeUImBYiKJa0LCHroDZ2dqrhLZj/CnSAsA0eDCe967w/gQqckjaPA
   w==;
X-IronPort-AV: E=Sophos;i="5.90,226,1643698800"; 
   d="scan'208";a="158947703"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Apr 2022 02:45:48 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Apr 2022 02:45:48 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Apr 2022 02:45:45 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <Divya.Koppera@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 1/3] dt-bindings: net: micrel: Revert latency support and timestamping check
Date:   Fri, 1 Apr 2022 11:48:03 +0200
Message-ID: <20220401094805.3343464-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220401094805.3343464-1-horatiu.vultur@microchip.com>
References: <20220401094805.3343464-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Revert latency support from binding.
Based on the discussion[1], the DT is the wrong place to have the
lantecies for the PHY.

[1] https://lkml.org/lkml/2022/3/4/325

Fixes: 2358dd3fd325fc ("dt-bindings: net: micrel: Configure latency values and timestamping check for LAN8814 phy")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../devicetree/bindings/net/micrel.txt          | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/micrel.txt b/Documentation/devicetree/bindings/net/micrel.txt
index c5ab62c39133..8d157f0295a5 100644
--- a/Documentation/devicetree/bindings/net/micrel.txt
+++ b/Documentation/devicetree/bindings/net/micrel.txt
@@ -45,20 +45,3 @@ Optional properties:
 
 	In fiber mode, auto-negotiation is disabled and the PHY can only work in
 	100base-fx (full and half duplex) modes.
-
- - lan8814,ignore-ts: If present the PHY will not support timestamping.
-
-	This option acts as check whether Timestamping is supported by
-	hardware or not. LAN8814 phy support hardware tmestamping.
-
- - lan8814,latency_rx_10: Configures Latency value of phy in ingress at 10 Mbps.
-
- - lan8814,latency_tx_10: Configures Latency value of phy in egress at 10 Mbps.
-
- - lan8814,latency_rx_100: Configures Latency value of phy in ingress at 100 Mbps.
-
- - lan8814,latency_tx_100: Configures Latency value of phy in egress at 100 Mbps.
-
- - lan8814,latency_rx_1000: Configures Latency value of phy in ingress at 1000 Mbps.
-
- - lan8814,latency_tx_1000: Configures Latency value of phy in egress at 1000 Mbps.
-- 
2.33.0

