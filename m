Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8F562230E
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 05:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiKIEW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 23:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKIEW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 23:22:28 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BBF13DDB;
        Tue,  8 Nov 2022 20:22:28 -0800 (PST)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2A94M91x064361;
        Tue, 8 Nov 2022 22:22:09 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1667967729;
        bh=RwAET4xnYfql+iPYftgqIgFKkb1Ikt+J8M4nWlkf1+M=;
        h=From:To:CC:Subject:Date;
        b=xC/KnrdwktIISQgkfqp2KbT51cb01rVB32Q+XKJdiKZGcASND+9GgEcl6K4uC4dde
         WE3hFz6j+4R1T+s3jnWT7Ae/4mvX4BvpTpFa9UIdfGbF+I1S1vvU8i4Qe5zNIrxyp9
         /+Rb/bzOQusO17ujacYC4fnVqAB+uw3wxrNFW2n8=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2A94M9Pq008289
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 8 Nov 2022 22:22:09 -0600
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Tue, 8 Nov
 2022 22:22:09 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Tue, 8 Nov 2022 22:22:09 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2A94M4R7111905;
        Tue, 8 Nov 2022 22:22:04 -0600
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
Subject: [PATCH net-next v5 0/3] Add support for QSGMII mode for J721e CPSW9G to am65-cpsw driver
Date:   Wed, 9 Nov 2022 09:52:00 +0530
Message-ID: <20221109042203.375042-1-s-vadapalli@ti.com>
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
v4 -> v5:
1. Update subject of all patches in the series to "PATCH net-next".
2. Rebase series on net-next tree.

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

v4:
https://lore.kernel.org/r/20221108080606.124596-1-s-vadapalli@ti.com/
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

