Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBED0E1E86
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 16:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392334AbfJWOrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 10:47:55 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:48064 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389782AbfJWOrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 10:47:55 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9NEls6M089549;
        Wed, 23 Oct 2019 09:47:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1571842074;
        bh=cT6QVOINN17/Kt4DPXJNTtp2HuxVPeCSQkCxCBXAgWk=;
        h=From:To:CC:Subject:Date;
        b=CqqgzGyy+umx0BPLGKlIvxOL4k9bJAVHrDegXN1ncJCbHFzP6Q/f3vvjdtLOo2rGi
         eiDVV7bal25L+H+kThMz+qgA+RC+cgqx3DqViTsjtXxlVJJ+NWzpiYldJaBV7/ShAK
         DKBQkADwVOIpI813tYqB5WFFhteSWS9cZB6V6dW0=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x9NElsKE100452
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Oct 2019 09:47:54 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Wed, 23
 Oct 2019 09:47:44 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Wed, 23 Oct 2019 09:47:44 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9NElrBd059434;
        Wed, 23 Oct 2019 09:47:53 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>
CC:     <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH] phy: ti: gmii-sel: fix mac tx internal delay for rgmii-rxid
Date:   Wed, 23 Oct 2019 17:47:44 +0300
Message-ID: <20191023144744.1246-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now phy-gmii-sel will disable MAC TX internal delay for PHY interface mode
"rgmii-rxid" which is incorrect.
Hence, fix it by enabling MAC TX internal delay in the case of "rgmii-rxid"
mode.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/phy/ti/phy-gmii-sel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/ti/phy-gmii-sel.c b/drivers/phy/ti/phy-gmii-sel.c
index a52c5bb35033..a28bd15297f5 100644
--- a/drivers/phy/ti/phy-gmii-sel.c
+++ b/drivers/phy/ti/phy-gmii-sel.c
@@ -69,11 +69,11 @@ static int phy_gmii_sel_mode(struct phy *phy, enum phy_mode mode, int submode)
 		break;
 
 	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
 		gmii_sel_mode = AM33XX_GMII_SEL_MODE_RGMII;
 		break;
 
 	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 		gmii_sel_mode = AM33XX_GMII_SEL_MODE_RGMII;
 		rgmii_id = 1;
-- 
2.17.1

