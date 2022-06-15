Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F90254C63C
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 12:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343555AbiFOKcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 06:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239526AbiFOKcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 06:32:45 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04AF2AF8;
        Wed, 15 Jun 2022 03:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655289163; x=1686825163;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MCkQZe9vraO5nzoDcG/+4sMEE/qxLO7FtoUZnD1O7L8=;
  b=YaWRNr+meN54/0TJRRy2ory3ianO6rHqPEisARU0Qfe7nRMGP714mQqV
   KT811VtXYp86lu5U4vxif2l4IVEl+bxDV4xm4ZTzSTbPGLrfF2lSVG8oO
   64F1zvJvveSrqI741/gZIhtUPCkbMDkHDlqccfdiJUZ5GpRf+KQwEKUVU
   zS8g/rwv7YFUSkvmoGxIH/FVADvKEY0rEoDEUvb33VNu1eK5Ummt/NJ/P
   xe1fRe1i2/ztsNS0xesVyW1NA+U4+eMksyqtSdg/WDU3io3Eg/vE98Dpg
   o6Hsx20pBx71CbTiOnkg8mA/EwCC8ekwlBzgEe1hy9+5jf7j3UZ8bnaZk
   A==;
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="168502163"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2022 03:32:43 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 15 Jun 2022 03:32:42 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 15 Jun 2022 03:32:39 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <lxu@maxlinear.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V1 0/5] net: lan743x: PCI11010 / PCI11414 devices Enhancements 
Date:   Wed, 15 Jun 2022 16:02:32 +0530
Message-ID: <20220615103237.3331-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series continues with the addition of supported features             
for the Ethernet function of the PCI11010 / PCI11414 devices to                 
the LAN743x driver.                                                             

Raju Lakkaraju (5):
  net: lan743x: Add support to LAN743x register dump
  net: lan743x: Add support to Secure-ON WOL
  net: lan743x: Add support to SGMII block access functions
  net: lan743x: Add support to SGMII 1G and 2.5G
  net: phy: add support to get Master-Slave configuration

 .../net/ethernet/microchip/lan743x_ethtool.c  |  63 ++-
 .../net/ethernet/microchip/lan743x_ethtool.h  |  26 ++
 drivers/net/ethernet/microchip/lan743x_main.c | 378 +++++++++++++++++-
 drivers/net/ethernet/microchip/lan743x_main.h | 106 +++++
 drivers/net/phy/mxl-gpy.c                     |   3 +
 5 files changed, 567 insertions(+), 9 deletions(-)

-- 
2.25.1

