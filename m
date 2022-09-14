Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117F95B8589
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbiINJvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiINJvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:51:41 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C14F65567;
        Wed, 14 Sep 2022 02:51:38 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 28E9p0IM101243;
        Wed, 14 Sep 2022 04:51:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1663149060;
        bh=G5JJSLPgnGzsnxIH7JQUb1JFnlgikFlcJPmPUeJjPUw=;
        h=From:To:CC:Subject:Date;
        b=s3Znpfhb4NmL5yzgyXSqQIR4gSlAVIN5T/1oiDJndb7JK0H8FZJ6e4gpBi26uBGgc
         Z0Tf89GbH2FFVlgk0tRdtGAK2WhPTYnMH7e9vQgMo2yXEKspatsZDcr/FxU/VHsV/O
         7XLzMYbUPmLCnNdyWtKUX+X+czsVGXOZ9DDLaonY=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 28E9p0X8010181
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Sep 2022 04:51:00 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Wed, 14
 Sep 2022 04:50:59 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Wed, 14 Sep 2022 04:50:59 -0500
Received: from uda0492258.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 28E9osD0046564;
        Wed, 14 Sep 2022 04:50:55 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kishon@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH 0/8] Add support for J721e CPSW9G and SGMII mode 
Date:   Wed, 14 Sep 2022 15:20:45 +0530
Message-ID: <20220914095053.189851-1-s-vadapalli@ti.com>
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

Add compatible for J721e CPSW9G.

Add support to power on and configure SERDES PHY.

Add support for SGMII mode for J7200 CPSW5G and J721e CPSW9G.

Siddharth Vadapalli (8):
  dt-bindings: net: ti: k3-am654-cpsw-nuss: Update bindings for J721e
    CPSW9G
  net: ethernet: ti: am65-cpsw: Add support for SERDES configuration
  net: ethernet: ti: am65-cpsw: Add mac control function
  net: ethernet: ti: am65-cpsw: Add mac enable link function
  net: ethernet: ti: am65-cpsw: Add support for fixed-link configuration
  net: ethernet: ti: am65-cpsw: Add support for SGMII mode for J7200
    CPSW5G
  net: ethernet: ti: am65-cpsw: Add support for J721e CPSW9G
  net: ethernet: ti: am65-cpsw: Enable SGMII mode for J721e CPSW9G

 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   |  23 ++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      | 186 +++++++++++++++---
 2 files changed, 178 insertions(+), 31 deletions(-)

-- 
2.25.1

