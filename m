Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A691168EB4
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 13:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgBVMEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 07:04:09 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:60724 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgBVMEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 07:04:09 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01MC46iT102100;
        Sat, 22 Feb 2020 06:04:06 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582373046;
        bh=90rqKQX22TWwXBOG89ZWUJQsPdv0lNIbOTJq3JG+a4U=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Ss7aDoEAHT4xyG1x10EPfUYH3bGFmfUY9p3XWeVB7+lGOJ/tzkRIvp106f6RxFFUF
         GplLqF5A5iMGU7tNpT4Sn8dHoUkMogq8SllYqr6sSRsRg/NjcHVfj6uL+QEB9GuxMv
         pagQSN2Z7IPsZt55vP5chPhfSGNwAqFVvaHN5mFM=
Received: from DLEE106.ent.ti.com (dlee106.ent.ti.com [157.170.170.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01MC464e000687
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 22 Feb 2020 06:04:06 -0600
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Sat, 22
 Feb 2020 06:04:06 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Sat, 22 Feb 2020 06:04:06 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01MC45mF107172;
        Sat, 22 Feb 2020 06:04:05 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [for-next PATCH 1/5] phy: ti: gmii-sel: simplify config dependencies between net drivers and gmii phy
Date:   Sat, 22 Feb 2020 14:03:54 +0200
Message-ID: <20200222120358.10003-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200222120358.10003-1-grygorii.strashko@ti.com>
References: <20200222120358.10003-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phy-gmii-sel can be only autoselacted in Kconfig and now the pretty
complex Kconfig dependencies are defined for phy-gmii-sel driver, which
also need to be updated every time phy-gmii-sel is re-used for any new
networking driver.

Simplify Kconfig definotion for phy-gmii-sel PHY driver - drop all
depndencies and from networking drivers and rely on using 'imply imply
PHY_TI_GMII_SEL' in Kconfig definotions for networking drivers instead.

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

