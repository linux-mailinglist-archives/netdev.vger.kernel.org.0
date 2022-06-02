Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5FD53B801
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 13:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbiFBLqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 07:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234167AbiFBLql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 07:46:41 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEE82B07E0;
        Thu,  2 Jun 2022 04:46:39 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 252BkKmm102230;
        Thu, 2 Jun 2022 06:46:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1654170380;
        bh=ntPvbCmcohBfciLcjqfZzj02vyGWQbthMaYla29csnk=;
        h=From:To:CC:Subject:Date;
        b=i/ES2l7pW2NO9qomNBSkqIMube2yTKlruISkPnIVGhFNFCm84OkD7u8eH0nsA6KxK
         5GUgH3BPbc6di07efPCrZQoEgV7lydNYVfs9NWGK1sXtyHDO4+C0mSis7cX6vSeFr0
         Wf3JTozVH43d+sbnlSUFcLfCiA14QHVhDBMnYiE4=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 252BkKpj068873
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Jun 2022 06:46:20 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Thu, 2
 Jun 2022 06:46:20 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Thu, 2 Jun 2022 06:46:20 -0500
Received: from ula0492258.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 252BkDxf035959;
        Thu, 2 Jun 2022 06:46:14 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>
Subject: [PATCH v2 0/3] J7200: CPSW5G: Add support for QSGMII mode to am65-cpsw driver
Date:   Thu, 2 Jun 2022 17:15:55 +0530
Message-ID: <20220602114558.6204-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

v1: https://lore.kernel.org/r/20220531113058.23708-1-s-vadapalli@ti.com

Siddharth Vadapalli (3):
  dt-bindings: net: ti: k3-am654-cpsw-nuss: Update bindings for J7200
    CPSW5G
  net: ethernet: ti: am65-cpsw: Add support for J7200 CPSW5G
  net: ethernet: ti: am65-cpsw: Move phy_set_mode_ext() to correct
    location

 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 140 ++++++++++++------
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  41 ++++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h      |   2 +
 3 files changed, 134 insertions(+), 49 deletions(-)

-- 
2.36.1

