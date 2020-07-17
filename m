Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5290F223B41
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 14:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgGQMTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 08:19:46 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:50790 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbgGQMTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 08:19:45 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06HCJfM3094214;
        Fri, 17 Jul 2020 07:19:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594988381;
        bh=zxUFAurYBZuCopybPJy1heOrkqjSKewqf4SLYr/5yD0=;
        h=From:To:CC:Subject:Date;
        b=MjrmpHf/wJxoWyDYF8L53tUsNvFQhztbQTI0TOeNNdd3WASCWpb+i+o2b5c7q79ZW
         il7awPzmpZ86+kKIfvrqOsofuR4UHrX/SsilOHCUtUFgU/yxM72dM8aYtXoKaRB2ez
         Qk44/y8fWI2/0bDhuGbrWM6VFu4+NUHK7jRLIVKg=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06HCJf5a009074
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 17 Jul 2020 07:19:41 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 17
 Jul 2020 07:19:40 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 17 Jul 2020 07:19:40 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06HCJd5q077284;
        Fri, 17 Jul 2020 07:19:40 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Murali Karicheri <m-karicheri2@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH] net: ethernet: ti: add NETIF_F_HW_TC hw feature flag for taprio offload
Date:   Fri, 17 Jul 2020 15:19:32 +0300
Message-ID: <20200717121932.26649-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>

Currently drive supports taprio offload which is a tc feature offloaded
to cpsw hardware. So driver has to set the hw feature flag, NETIF_F_HW_TC
in the net device to be compliant. This patch adds the flag.

Fixes: 8127224c2708 ("ethernet: ti: am65-cpsw-qos: add TAPRIO offload support")
Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 1492648247d9..6d778bc3d012 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1850,7 +1850,8 @@ static int am65_cpsw_nuss_init_ndev_2g(struct am65_cpsw_common *common)
 	port->ndev->max_mtu = AM65_CPSW_MAX_PACKET_SIZE;
 	port->ndev->hw_features = NETIF_F_SG |
 				  NETIF_F_RXCSUM |
-				  NETIF_F_HW_CSUM;
+				  NETIF_F_HW_CSUM |
+				  NETIF_F_HW_TC;
 	port->ndev->features = port->ndev->hw_features |
 			       NETIF_F_HW_VLAN_CTAG_FILTER;
 	port->ndev->vlan_features |=  NETIF_F_SG;
-- 
2.17.1

