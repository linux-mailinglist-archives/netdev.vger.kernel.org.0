Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6C454AE68
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 12:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238421AbiFNKei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 06:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbiFNKeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 06:34:37 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C090248389;
        Tue, 14 Jun 2022 03:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655202876; x=1686738876;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5gXWPPrcQK7lvWRIM1wvD8JU12/Fjqzd+ksC9uIc2L8=;
  b=SkzVOqwvr+FccTNVUwVE+8efe4nV7XLwpNjq6CvQRnxI/nYynxNMJ+3H
   q6jb7ic2bnST8kJtz2MlX/EIHgxco0erlIudtKNQU2BuoWnWhY1s0Ftud
   VQWbZxHhi2lSftcHBh4WoVt0RnEMGacp/yQQIOtSSwevbyCxUwg/Xix7O
   zdH29GNYGbWSTPolDLphrTV+41Phq5eW5CqwgmEyBuhEKenOygaQ0yx6h
   2KFSmMWo2AQ4w+SgPc4zfSDFcrSNLe4k2g+Jgnpsh3pB5LflMar6GZwuA
   tPe8Q8xR8wR6oqat0tp6ZckO7DwDkrqDzlDN8L72eUZKbCwreqvcqMfaF
   w==;
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="99929351"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jun 2022 03:34:36 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 14 Jun 2022 03:34:34 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 14 Jun 2022 03:34:31 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <lxu@maxlinear.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next 0/5] net: lan743x: PCI11010 / PCI11414 devices Enhancements 
Date:   Tue, 14 Jun 2022 16:04:19 +0530
Message-ID: <20220614103424.58971-1-Raju.Lakkaraju@microchip.com>
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

 .../net/ethernet/microchip/lan743x_ethtool.c  |  65 ++-
 .../net/ethernet/microchip/lan743x_ethtool.h  |  26 ++
 drivers/net/ethernet/microchip/lan743x_main.c | 378 +++++++++++++++++-
 drivers/net/ethernet/microchip/lan743x_main.h | 144 +++++++
 drivers/net/phy/mxl-gpy.c                     |  55 +++
 5 files changed, 659 insertions(+), 9 deletions(-)

-- 
2.25.1

