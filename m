Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8F8177B60
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 17:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbgCCQAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 11:00:49 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:56256 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729449AbgCCQAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 11:00:48 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 023G0ijo021709;
        Tue, 3 Mar 2020 10:00:44 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1583251244;
        bh=zFr5F9I7jfe0+E2ZyaA/hVidefazQ482jhqXNOfG3xs=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=rovcN5zt5ecBCH+T0uQeP4lQ7Ne3X7H/Hy7LUb3MV3kKqCISUj4WGdvqWETpLoGdK
         AOxZVVl4As2zguTFccd7gpWjLB023mHv2d2cynLBYa7Yo1vRoM121J9Re91EsVMuMS
         RkffBSZs4A6LD/ZS9yyvY/yRjIo4CPJoDLpaeU3g=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 023G0i6E085803
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 3 Mar 2020 10:00:44 -0600
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 3 Mar
 2020 10:00:44 -0600
Received: from localhost.localdomain (10.64.41.19) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 3 Mar 2020 10:00:44 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by localhost.localdomain (8.15.2/8.15.2) with ESMTP id 023G0hwq030116;
        Tue, 3 Mar 2020 10:00:44 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Murali Karicheri <m-karicheri2@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     Sekhar Nori <nsekhar@ti.com>, Rob Herring <robh+dt@kernel.org>,
        netdev <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [for-next PATCH v2 1/5] phy: ti: gmii-sel: simplify config dependencies between net drivers and gmii phy
Date:   Tue, 3 Mar 2020 18:00:25 +0200
Message-ID: <20200303160029.345-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200303160029.345-1-grygorii.strashko@ti.com>
References: <20200303160029.345-1-grygorii.strashko@ti.com>
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

