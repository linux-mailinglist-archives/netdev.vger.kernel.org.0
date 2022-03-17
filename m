Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E984DC424
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 11:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbiCQKoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 06:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiCQKog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 06:44:36 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572267C7B6;
        Thu, 17 Mar 2022 03:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647513798; x=1679049798;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=m5EnwoRRHmooy0FryyIjRhlX/cBcuiEAB12WBtxGbFM=;
  b=L41+Aw0/EaLlGP916SPVFa903zwitfBWVKmMhVmjvCbxHdLoSTRgDeJF
   sOq3UdL3Kk1sT/PGNKu2miFMhlnxAGb4z+UE+cYjuvEMYrdO6jxLJF4VH
   daRpjqktN5hDvXAKwO6N3FUR0b/xrT/tX8KG/DXnKo0Bx7RicUVNXHVc4
   ZrUGA5WwHug/WskF2fQlAtsNfezBzSYqf59hyS7M8ekohLGXX5JzofN2R
   boIRG0zj6K+TW67wrMip8jqozQ0zBGvhQzWYHwdEdHn+UJt9VpxuCMqSR
   DMF1jtsRRIVoDNsQ66+pm3iKUGJ1jpCK67RE5iEVynwrTNfeg/wr+kWiS
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,188,1643698800"; 
   d="scan'208";a="156782070"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2022 03:43:17 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 17 Mar 2022 03:43:15 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 17 Mar 2022 03:43:13 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V1 0/5]net: lan743x: PCI11010 / PCI11414 devices
Date:   Thu, 17 Mar 2022 16:13:05 +0530
Message-ID: <20220317104310.61091-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series continues with the addition of supported features             
for the Ethernet function of the PCI11010 / PCI11414 devices to                 
the LAN743x driver.

Raju Lakkaraju (5):
  net: lan743x: Add support to display Tx Queue statistics
  net: lan743x: Add support for EEPROM
  net: lan743x: Add support for OTP
  net: lan743x: Add support for PTP-IO Event Input External Timestamp
    (extts)
  net: lan743x: Add support for PTP-IO Event Output (Periodic Output)

 .../net/ethernet/microchip/lan743x_ethtool.c  | 378 +++++++++++-
 drivers/net/ethernet/microchip/lan743x_main.c |   2 +
 drivers/net/ethernet/microchip/lan743x_main.h | 159 +++++
 drivers/net/ethernet/microchip/lan743x_ptp.c  | 558 ++++++++++++++++--
 drivers/net/ethernet/microchip/lan743x_ptp.h  |  10 +
 5 files changed, 1061 insertions(+), 46 deletions(-)

-- 
2.25.1

