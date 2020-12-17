Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FCB2DCE9A
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 10:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgLQJnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 04:43:06 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52446 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726580AbgLQJnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 04:43:05 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BH9aJp9020795;
        Thu, 17 Dec 2020 01:40:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=AlAncbUjN9C61RgCMXrSYHMGQ9BKjAOvLpnBioJ+lGA=;
 b=PhO/nxAxqgWzGjGBIv0BKLTdKIO4Yjpl8I09oClvBO8HATeT6Zv3d/cM0olBKCSQQ64C
 EnY20aY/y42+ojoEWwvxEnkFk7a6RjU1SvZP9jzCJhGWM7sTUz4F+gbfVCPtDDwQhFrs
 mwwIT5NKlpct2zp8IyJyyQUqPRg5T0lcf4V0dhq0EddewLf8t+emWZXDeM/3BdQF2i7S
 eUW3N9paQnVELRV7a/UFt32piO4OKEURaW/ebZufkT4kqZIPwp9Glpba6RMcqOYQ4DUU
 rsh+mNXWP5IVLW8Op8SK7KfIdeg7kBEWvr6CLeGDntDvF18qpjL5GRqLUdW+Swt+vqLB Wg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 35cx8tf48u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 01:40:15 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 01:40:14 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 01:40:14 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Dec 2020 01:40:14 -0800
Received: from stefan-pc.marvell.com (unknown [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 389953F703F;
        Thu, 17 Dec 2020 01:40:11 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net v2 1/2] net: mvpp2: Fix GoP port 3 Networking Complex Control configurations
Date:   Thu, 17 Dec 2020 11:40:06 +0200
Message-ID: <1608198007-10143-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_07:2020-12-15,2020-12-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

During GoP port 2 Networking Complex Control mode of operation configurations,
also GoP port 3 mode of operation was wrongly set.
Patch removes these configurations.
GENCONF_CTRL0_PORTX naming also fixed.

Fixes: f84bf386f395 ("net: mvpp2: initialize the GoP")
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 6 +++---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 6bd7e40..39c4e5c 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -651,9 +651,9 @@
 #define     GENCONF_PORT_CTRL1_EN(p)			BIT(p)
 #define     GENCONF_PORT_CTRL1_RESET(p)			(BIT(p) << 28)
 #define GENCONF_CTRL0					0x1120
-#define     GENCONF_CTRL0_PORT0_RGMII			BIT(0)
-#define     GENCONF_CTRL0_PORT1_RGMII_MII		BIT(1)
-#define     GENCONF_CTRL0_PORT1_RGMII			BIT(2)
+#define     GENCONF_CTRL0_PORT2_RGMII			BIT(0)
+#define     GENCONF_CTRL0_PORT3_RGMII_MII		BIT(1)
+#define     GENCONF_CTRL0_PORT3_RGMII			BIT(2)
 
 /* Various constants */
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d64dc12..d2b0506 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1231,9 +1231,9 @@ static void mvpp22_gop_init_rgmii(struct mvpp2_port *port)
 
 	regmap_read(priv->sysctrl_base, GENCONF_CTRL0, &val);
 	if (port->gop_id == 2)
-		val |= GENCONF_CTRL0_PORT0_RGMII | GENCONF_CTRL0_PORT1_RGMII;
+		val |= GENCONF_CTRL0_PORT2_RGMII;
 	else if (port->gop_id == 3)
-		val |= GENCONF_CTRL0_PORT1_RGMII_MII;
+		val |= GENCONF_CTRL0_PORT3_RGMII_MII;
 	regmap_write(priv->sysctrl_base, GENCONF_CTRL0, val);
 }
 
@@ -1250,9 +1250,9 @@ static void mvpp22_gop_init_sgmii(struct mvpp2_port *port)
 	if (port->gop_id > 1) {
 		regmap_read(priv->sysctrl_base, GENCONF_CTRL0, &val);
 		if (port->gop_id == 2)
-			val &= ~GENCONF_CTRL0_PORT0_RGMII;
+			val &= ~GENCONF_CTRL0_PORT2_RGMII;
 		else if (port->gop_id == 3)
-			val &= ~GENCONF_CTRL0_PORT1_RGMII_MII;
+			val &= ~GENCONF_CTRL0_PORT3_RGMII_MII;
 		regmap_write(priv->sysctrl_base, GENCONF_CTRL0, val);
 	}
 }
-- 
1.9.1

