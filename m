Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4568069971D
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjBPOVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBPOVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:21:31 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2719B4AFD6;
        Thu, 16 Feb 2023 06:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676557290; x=1708093290;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=oGDwNP/TaCCY6UXqL//DjVhW6FOzMAg+BuvsTpnsctM=;
  b=lSKJJxT0c6tI377Hmw75t1Ipmm8qDGiCk4yzwc5cQESOmixLnWpOhfCJ
   NXoVNNYsCbXScm1kq4pFREiXRgj3hv+Neuz4A+q6vmXxJtdAltbk0Qnqa
   moQc4kg9T2x8MIIu0c1nXzbvWtqspX+mgNBxm8WoiWseQ/wX3dR56m2dK
   oI43btxwW1d53m5Ga5skue/LkWNMuQ5Mvrqkez7v8/pae4hz9oc7ccbIH
   59eNHXlZIHF/DC6DfmQKkZf20oBG7GlMuUeqj3ggnHPXsKoirQyVfe/7X
   OHnTEHWGt/1MaMbIVyFAjKUHEMlFkdnBEvLaVHUgrlVVWe5ErQDTC0+YH
   A==;
X-IronPort-AV: E=Sophos;i="5.97,302,1669100400"; 
   d="scan'208";a="200916573"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2023 07:21:30 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 07:21:26 -0700
Received: from chn-vm-ungapp01.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 07:21:26 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <enguerrand.de-ribaucourt@savoirfairelinux.com>,
        <woojung.huh@microchip.com>, <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <edumazet@google.com>, <linux-usb@vger.kernel.org>,
        <kuba@kernel.org>
Subject: [PATCH net 0/2] net:usb:lan78xx: move LAN7800 internal phy register accesses to the phy driver.
Date:   Thu, 16 Feb 2023 07:20:52 -0700
Message-ID: <cover.1676490952.git.yuiko.oshino@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the LAN7800 internal phy register accesses from lan78xx.c to the new lan88xx_link_change_notify() in the microchip.c, the phy driver.

Yuiko Oshino (2):
  net:usb:lan78xx: fix accessing the LAN7800's internal phy specific
    registers from the MAC driver
  net:phy:microchip: fix accessing the LAN7800's internal phy specific
    registers from the MAC driver

 drivers/net/phy/microchip.c | 32 ++++++++++++++++++++++++++++++++
 drivers/net/usb/lan78xx.c   | 27 +--------------------------
 2 files changed, 33 insertions(+), 26 deletions(-)

-- 
2.17.1

