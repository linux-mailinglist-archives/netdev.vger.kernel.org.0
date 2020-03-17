Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72280187A52
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 08:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgCQH2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 03:28:02 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:43918 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgCQH2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 03:28:02 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02H7RtvY106033;
        Tue, 17 Mar 2020 02:27:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584430075;
        bh=8YHq2J68+0j2Fs0bfJ25HKCvq9MmsLj2RsTsoQk+IrI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=BfEpOBKEP6Cm9WcECOhS8bJcSBDlw8RVnHPVjO8lJ6OlGT6Sd8r81fxU4zLtQ8tmr
         E7it/7ckwwZQ2NfRG8rxwv/+B84z27zLG00NI9U1fBlXI7GdwtQGMrFhj1+z7l7CQJ
         3c50ibjZsCT8z/t7HLWh5CxtBmAa6pTbkUBr0d8Q=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02H7RtTL055892
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Mar 2020 02:27:55 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 17
 Mar 2020 02:27:54 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 17 Mar 2020 02:27:54 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02H7RrwT091572;
        Tue, 17 Mar 2020 02:27:54 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        <devicetree@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     Murali Karicheri <m-karicheri2@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v4 01/11] phy: ti: gmii-sel: simplify config dependencies between net drivers and gmii phy
Date:   Tue, 17 Mar 2020 09:27:29 +0200
Message-ID: <20200317072739.23950-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200317072739.23950-1-grygorii.strashko@ti.com>
References: <20200317072739.23950-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phy-gmii-sel can be only auto selected in Kconfig and now the pretty
complex Kconfig dependencies are defined for phy-gmii-sel driver, which
also need to be updated every time phy-gmii-sel is re-used for any new
networking driver.

Simplify Kconfig definition for phy-gmii-sel PHY driver - drop all
dependencies and from networking drivers and rely on using 'imply
PHY_TI_GMII_SEL' in Kconfig definitions for networking drivers instead.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/net/ethernet/ti/Kconfig | 1 +
 drivers/phy/ti/Kconfig          | 3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index bf98e0fa7d8b..8a6ca16eee3b 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -53,6 +53,7 @@ config TI_CPSW
 	select MFD_SYSCON
 	select PAGE_POOL
 	select REGMAP
+	imply PHY_TI_GMII_SEL
 	---help---
 	  This driver supports TI's CPSW Ethernet Switch.
 
diff --git a/drivers/phy/ti/Kconfig b/drivers/phy/ti/Kconfig
index 6dbe9d0b9ff3..15a3bcf32308 100644
--- a/drivers/phy/ti/Kconfig
+++ b/drivers/phy/ti/Kconfig
@@ -106,11 +106,8 @@ config TWL4030_USB
 
 config PHY_TI_GMII_SEL
 	tristate
-	default y if TI_CPSW=y || TI_CPSW_SWITCHDEV=y
-	depends on TI_CPSW || TI_CPSW_SWITCHDEV || COMPILE_TEST
 	select GENERIC_PHY
 	select REGMAP
-	default m
 	help
 	  This driver supports configuring of the TI CPSW Port mode depending on
 	  the Ethernet PHY connected to the CPSW Port.
-- 
2.17.1

