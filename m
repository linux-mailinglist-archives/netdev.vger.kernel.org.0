Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7175F620AE4
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 09:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbiKHIGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 03:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233461AbiKHIGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 03:06:50 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A641CB1E;
        Tue,  8 Nov 2022 00:06:49 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2A886BAr088047;
        Tue, 8 Nov 2022 02:06:11 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1667894771;
        bh=wY9z7UvZj24VC3mNio1jVMalD20CbZ1aaOEVGgiwzY0=;
        h=From:To:CC:Subject:Date;
        b=NfOT7oZ/R3Z7Aa0WN6kUTO9/qMXu7qxRNh6n57QM5Po9WYvF8UiBk9fFlcq7CuUDK
         qtNywROZ/287/hK+q9V/+GcxJV6af0BBeQPnXHHRZgVBba3RvhFjeIlaKWF1lndTnb
         G62v1ND74qValWCTeK2kjxuxnbVvcjUZ6EYzYFLY=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2A886BBt018819
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 8 Nov 2022 02:06:11 -0600
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Tue, 8 Nov
 2022 02:06:11 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Tue, 8 Nov 2022 02:06:11 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2A8866mC033956;
        Tue, 8 Nov 2022 02:06:07 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH v4 0/3] Add support for QSGMII mode for J721e CPSW9G to am65-cpsw driver
Date:   Tue, 8 Nov 2022 13:36:03 +0530
Message-ID: <20221108080606.124596-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatible to am65-cpsw driver for J721e CPSW9G, which contains 8
external ports and 1 internal host port.

Add support to power on and power off the SERDES PHY which is used by the
CPSW MAC.

=========
Changelog
=========
v3 -> v4:
1. Fix subject of patch-1/3, updating it to:
   "dt-bindings: net: ti: k3-am654-cpsw-nuss: Add J721e CPSW9G support"
   and collect Reviewed-by tag.
2. Rebase series on linux-next tree tagged: next-20221107.

v2 -> v3:
1. Run 'make DT_CHECKER_FLAGS=-m dt_binding_check' and fix errors and
   warnings corresponding to the patch for:
   Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
   with the latest dt-schema and yamllint.

v1 -> v2:
1. Drop all patches corresponding to SGMII mode. This is done since I do
   not have a method to test SGMII in the standard mode which uses an
   SGMII PHY. The previous series used SGMII in a fixed-link mode,
   bypassing the SGMII PHY. I will post the SGMII patches in a future
   series after testing them.
2. Drop all patches corresponding to fixed-link in the am65-cpsw driver.
   This is done since PHYLINK takes care of fixed-link automatically and
   there is no need to deal with fixed-link in a custom fashion.
3. Fix indentation errors in k3-am65-cpsw-nuss.yaml.
4. Remove the stale code which tries to power on and power off the CPSW
   MAC's phy, since the CPSW MAC's phy driver does not support it.
5. Rename the function "am65_cpsw_init_phy()" to
   "am65_cpsw_init_serdes_phy()", to indicate that the phy corresponds to
   the SERDES.
6. Invoke "am65_cpsw_disable_serdes_phy()" as a part of the cleanup that
   is associated with the "am65_cpsw_nuss_remove()" function.

v3:
https://lore.kernel.org/r/20221026090957.180592-1-s-vadapalli@ti.com/
v2:
https://lore.kernel.org/r/20221018085810.151327-1-s-vadapalli@ti.com/
v1:
https://lore.kernel.org/r/20220914095053.189851-1-s-vadapalli@ti.com/

Siddharth Vadapalli (3):
  dt-bindings: net: ti: k3-am654-cpsw-nuss: Add J721e CPSW9G support
  net: ethernet: ti: am65-cpsw: Enable QSGMII mode for J721e CPSW9G
  net: ethernet: ti: am65-cpsw: Add support for SERDES configuration

 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 33 ++++++++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      | 73 +++++++++++++++++++
 2 files changed, 102 insertions(+), 4 deletions(-)

-- 
2.25.1

