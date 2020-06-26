Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9170420B7F3
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgFZSRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:17:46 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:59806 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgFZSRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:17:32 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05QIHI0L115330;
        Fri, 26 Jun 2020 13:17:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593195438;
        bh=phYtIIqn4y5a02HhamR20fkUSyepLjNfKvic75zwtOE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=fgF3SFL+v+V9x7x4iX2KJi0C2cz/f3nsgakc0bR9StRBKFmPir7nVkQgyf7KHT9yx
         AxJbbPQYNb8tF0bRfMPw+MJRFta3Vzgk50Zi/e8j6hMHE8cytHGByz6bPLLS5kWm2O
         4Ixqjsw2BoqHp8CeTdCy1GHgsx3KRHUQunay7aJ8=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05QIHI4t058732
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 26 Jun 2020 13:17:18 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 26
 Jun 2020 13:17:17 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 26 Jun 2020 13:17:17 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05QIHGBO107617;
        Fri, 26 Jun 2020 13:17:17 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 4/6] net: ethernet: ti: am65-cpsw-ethtool: skip hw cfg when change p0-rx-ptype-rrobin
Date:   Fri, 26 Jun 2020 21:17:07 +0300
Message-ID: <20200626181709.22635-5-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200626181709.22635-1-grygorii.strashko@ti.com>
References: <20200626181709.22635-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Skip HW configuration when p0-rx-ptype-rrobin is changed as it will be done
by .ndev_open(),

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
index 8c4690f3ebcb..f7b33875a385 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
@@ -741,7 +741,6 @@ static int am65_cpsw_set_ethtool_priv_flags(struct net_device *ndev, u32 flags)
 	}
 
 	common->pf_p0_rx_ptype_rrobin = rrobin;
-	am65_cpsw_nuss_set_p0_ptype(common);
 
 	return 0;
 }
-- 
2.17.1

