Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C2D59B9ED
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 09:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbiHVHCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 03:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiHVHCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 03:02:00 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E91628728;
        Mon, 22 Aug 2022 00:01:59 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 27M71W9N003996;
        Mon, 22 Aug 2022 02:01:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1661151692;
        bh=ItL3MpL6nlVsmOIaVNnatVx0td11x1P4PqAWB2ISmvI=;
        h=From:To:CC:Subject:Date;
        b=K0BDTwrerJYrzqRlAXkTy4A+/vpan9WotByjtDjiTUdQHn3+7q1GADYXinpmv47VH
         He8KygXA2/Q2HQA2aWvNIcuXvZ5c1Gtnv8E3OAtWXvFvaVr5hcCqZ+dg+11rzPJMIc
         jr2Qv1bn/uQnJT4tXjZIrlcxdzk6FDXhuj5ytU6I=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 27M71W31033997
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 22 Aug 2022 02:01:32 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Mon, 22
 Aug 2022 02:01:31 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Mon, 22 Aug 2022 02:01:31 -0500
Received: from uda0492258.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 27M71Qlr030502;
        Mon, 22 Aug 2022 02:01:27 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH v5 0/3] J7200: CPSW5G: Add support for QSGMII mode to am65-cpsw driver
Date:   Mon, 22 Aug 2022 12:31:22 +0530
Message-ID: <20220822070125.28236-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for QSGMII mode to am65-cpsw driver.

Change log:

v4-> v5:
1. Move ti,j7200-cpswxg-nuss compatible to the line above the
   ti,j721e-cpsw-nuss compatible.
2. Add allOf and move if-then statements within it to allow future if-then
   statements to be added easily.

v3 -> v4:
1. Update bindings to disallow ports based on compatible, instead of
   adding a new if/then statement for the new compatible.
2. Add Else-If condition for RMII mode in the set of supported interfaces.
   Support for RMII mode is already present in the driver and I had
   missed out adding a condition for RMII mode in the previous patches.

v2 -> v3:
1. In ti,k3-am654-cpsw-nuss.yaml, restrict if/then statement to port
   nodes.

v1 -> v2:
1. Add new compatible for CPSW5G in ti,k3-am654-cpsw-nuss.yaml and extend
   properties for new compatible.
2. Add extra_modes member to struct am65_cpsw_pdata to be used for QSGMII
   mode by new compatible.
3. Add check for phylink supported modes to ensure that only one phy mode
   is advertised as supported.
4. Check if extra_modes supports QSGMII mode in am65_cpsw_nuss_mac_config()
   for register write.
5. Add check for assigning port->sgmii_base only when extra_modes is valid.

v4: https://lore.kernel.org/r/20220816060139.111934-1-s-vadapalli@ti.com/
v3: https://lore.kernel.org/r/20220606110443.30362-1-s-vadapalli@ti.com/
v2: https://lore.kernel.org/r/20220602114558.6204-1-s-vadapalli@ti.com/
v1: https://lore.kernel.org/r/20220531113058.23708-1-s-vadapalli@ti.com/

Siddharth Vadapalli (3):
  dt-bindings: net: ti: k3-am654-cpsw-nuss: Update bindings for J7200
    CPSW5G
  net: ethernet: ti: am65-cpsw: Add support for J7200 CPSW5G
  net: ethernet: ti: am65-cpsw: Move phy_set_mode_ext() to correct
    location

 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 18 +++++++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      | 44 ++++++++++++++++---
 drivers/net/ethernet/ti/am65-cpsw-nuss.h      |  2 +
 3 files changed, 55 insertions(+), 9 deletions(-)

--
2.25.1

