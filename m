Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0937B673500
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjASKCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 05:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbjASKC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:02:27 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99C36779C;
        Thu, 19 Jan 2023 02:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674122537; x=1705658537;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JtbqRyUllaz66zQtIGl1oYLLBLWASU9EgxTDoiymdUI=;
  b=BuFKfGC5Jpbtf4oHHCNE2BMopQ3R4fiqMF3zzqpBzlfZSK5yUDslU2/a
   0DcIjB1CxXgup2QoYF0mxwsS3kHxhATBrbiW/vWjC7NujLFdCNPbYAKt8
   hW4gUMJ1jLeRLVBBWR/mPoy+7xx1a/7fpbaFXN+RGkcgFOZJUPzl+RV7Y
   tddPdTTy9DtFo0cEF9hV29f7NJzxUkes0lQU0lMmahfxeFAzePIaW7RSm
   kDG4fn/5fPHACejh5V1T68jKOC1wxTwmednCM2XBTnUVvlE47lt4Fx/Zs
   MjVUpf4AzO37xcMz16CphWtZ6b5lGsh0sxbbv2h48iMIg2fP/BaVFWsqP
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,228,1669100400"; 
   d="scan'208";a="208436084"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jan 2023 03:02:16 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 03:02:15 -0700
Received: from che-dk-unglab44lx.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 03:02:13 -0700
From:   Pavithra Sathyanarayanan <Pavithra.Sathyanarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <bryan.whitehead@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH net-next 0/3]  generic implementation of phy interface and fixed_phy support for the LAN743x device
Date:   Tue, 17 Jan 2023 19:46:11 +0530
Message-ID: <20230117141614.4411-1-Pavithra.Sathyanarayanan@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series includes the following changes:

- Remove the unwanted interface settings in the LAN743x driver as
  it is preset in EEPROM configurations.

- Handle generic implementation for the phy interfaces for different
  devices LAN7430/31 and pci11x1x.

- Add new feature for fixed_phy support at 1Gbps full duplex for the
  LAN7431 device if a phy not found over MDIO. Includes support for
  communication between a MAC in a LAN7431 device and custom phys
  without an MDIO interface. 


Pavithra Sathyanarayanan (3):
  net: lan743x: remove unwanted interface select settings
  net: lan743x: add generic implementation for phy interface selection
  net: lan743x: add fixed phy support for LAN7431 device

 drivers/net/ethernet/microchip/lan743x_main.c | 59 +++++++++++++------
 drivers/net/ethernet/microchip/lan743x_main.h |  1 +
 2 files changed, 42 insertions(+), 18 deletions(-)

-- 
2.25.1

