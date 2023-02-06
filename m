Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F6568B735
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 09:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjBFIXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 03:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjBFIXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 03:23:32 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758C11630E;
        Mon,  6 Feb 2023 00:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675671808; x=1707207808;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bbIwEGzziSPlF1Ehw+6b/lNou6p5/k6p3DgJosqYfK4=;
  b=Ta55jFjxSqtiSo8h9E3suEvukO04gBOenE7rvUPYSQ/Vipr2a5VajSNh
   bTY0HP706DFPLqL/SBUNlBX40k7YBBlVnKCjn2H6yS2EvkSjA5PwPnoET
   6gZTBpZxzfi527PprFSi22XCa84IE90nDdtFs7A5otaaid2Q6XDV49EF4
   eEKyCjGx8NPmL2rQbugNOSYTMoB9M9b1IhVxVgIVeDxHY1zmR1EL3ZLEL
   5/n4jFTD7VHk9Jc/94rm8mFWZYMvrWIjkppqsm5DYuAXUXZ53nsBIlNBV
   4DuUih9AYCFz63zxjjhPEEghsansHulINFN0ZJscFkT4+ylOaaDp4xO3Y
   g==;
X-IronPort-AV: E=Sophos;i="5.97,276,1669100400"; 
   d="scan'208";a="210718357"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Feb 2023 01:23:27 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 01:23:27 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 01:23:24 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <michael@walle.cc>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 0/2] net: micrel: Add support for lan8841 PHY
Date:   Mon, 6 Feb 2023 09:23:00 +0100
Message-ID: <20230206082302.958826-1-horatiu.vultur@microchip.com>
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
 drivers/net/phy/micrel.c                      | 187 +++++++++++++++++-
 include/linux/micrel_phy.h                    |   1 +
 3 files changed, 180 insertions(+), 9 deletions(-)

-- 
2.38.0

