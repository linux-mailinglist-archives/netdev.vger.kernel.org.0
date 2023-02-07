Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063D268D4DC
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbjBGKwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjBGKwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:52:41 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384C410C8;
        Tue,  7 Feb 2023 02:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675767160; x=1707303160;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sOUztMt//nWE+XKIz2ePb4hJ5WIVQx9GXgsItfzAIAA=;
  b=HQynwof7pHPLyh2dQEuM5OfaqrJ2G3FO53Lcq2yTSqZkzZ8gW75X2c9c
   MOIZifbWkSotStElBuV+FdUypykewvq27DMOpmKWe1q11RQOgVPSWwOc6
   FVS4d+6oETiEjOmLeFRcMdXy1lHhoqnk7Sr5FoQ8Mahbe4tykHsw24RYB
   NSt/jVRVslaGyAcx6+t7LSHENRVLS4XTw8DEQ3WxRFZ/wSUZL7EY4KkAk
   kgz0I3I/IneRnxNSMA+qBpp2t8Nx1HCZm4exbRt2zKrrm5wX5Z+rGUvjP
   KcwNRR+ycwbeps22GnYo0C1RUxOoOrP5Sk3CFT6CVw2Ffd3dCqBiu9/oL
   g==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669100400"; 
   d="scan'208";a="199639742"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Feb 2023 03:52:39 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 03:52:38 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 03:52:36 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <michael@walle.cc>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 0/2] net: micrel: Add support for lan8841 PHY
Date:   Tue, 7 Feb 2023 11:52:10 +0100
Message-ID: <20230207105212.1275396-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

Add support for lan8841 PHY.

The first patch add the support for lan8841 PHY which can run at
10/100/1000Mbit. It also has support for other features, but they are not
added in this series.

The second patch updates the documentation for the dt-bindings which is
similar to the ksz9131.

v3->v4:
- add space between defines and function names
- inside lan8841_config_init use only ret variable

v2->v3:
- reuse ksz9131_config_init
- allow only open-drain configuration
- change from single patch to a patch series

v1->v2:
- Remove hardcoded values
- Fix typo in commit message

Horatiu Vultur (2):
  net: micrel: Add support for lan8841 PHY
  dt-bindings: net: micrel-ksz90x1.txt: Update for lan8841

 .../bindings/net/micrel-ksz90x1.txt           |   1 +
 drivers/net/phy/micrel.c                      | 189 +++++++++++++++++-
 include/linux/micrel_phy.h                    |   1 +
 3 files changed, 182 insertions(+), 9 deletions(-)

-- 
2.38.0

