Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0062DAE13
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 14:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgLONgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 08:36:05 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:19118 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728054AbgLONfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 08:35:46 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BFDPTh8015379;
        Tue, 15 Dec 2020 05:32:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=kzVNG9l2wMsHpkgpX4GfYITXE8UzXLYNc9dS0IWK3gM=;
 b=eKwD4v0AWzy3tZfAiquPytgt1IBooqqm5YGE9LOtNjQh3DEaFvcM5ayZoWTjdva4AJcQ
 WFJl4GlQnub5TJHIF1E82erZu2gpxpbaQsTdQc1kH3t5JVJeVRiZdLXNWYfaCzRoBgnD
 V40h+CdS7yNwbn9Ce/dm6iGz3SO4SzjlyOhnm8ZmlUh5l9Rjdq+WTSuGotlvmU8/Jg/k
 4946hDjZd2D27HiOJNyIc9bHota7wE/ryyTOhJyHRC3bTT2nThK2Hciu2yYPGTnaUYNY
 2Gw1jjlgAwl7GaNdJE3LnN20rjlRRRQV6vFXjTHfOR2XhFYug6OwIyq1qWnQ7QDII0L6 VA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 35cv3syyyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 05:32:58 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 15 Dec
 2020 05:32:57 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 15 Dec
 2020 05:32:56 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Dec 2020 05:32:56 -0800
Received: from stefan-pc.marvell.com (unknown [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 6A0B23F703F;
        Tue, 15 Dec 2020 05:32:53 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net 2/2] net: mvpp2: disable force link UP during port init procedure
Date:   Tue, 15 Dec 2020 15:32:13 +0200
Message-ID: <1608039133-16345-2-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1608039133-16345-1-git-send-email-stefanc@marvell.com>
References: <1608039133-16345-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_10:2020-12-15,2020-12-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Force link UP can be enabled by bootloader during tftpboot
and breaks NFS support.
Force link UP disabled during port init procedure.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d2b0506..0ad3177 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5479,7 +5479,7 @@ static int mvpp2_port_init(struct mvpp2_port *port)
 	struct mvpp2 *priv = port->priv;
 	struct mvpp2_txq_pcpu *txq_pcpu;
 	unsigned int thread;
-	int queue, err;
+	int queue, err, val;
 
 	/* Checks for hardware constraints */
 	if (port->first_rxq + port->nrxqs >
@@ -5493,6 +5493,18 @@ static int mvpp2_port_init(struct mvpp2_port *port)
 	mvpp2_egress_disable(port);
 	mvpp2_port_disable(port);
 
+	if (mvpp2_is_xlg(port->phy_interface)) {
+		val = readl(port->base + MVPP22_XLG_CTRL0_REG);
+		val &= ~MVPP22_XLG_CTRL0_FORCE_LINK_PASS;
+		val |= MVPP22_XLG_CTRL0_FORCE_LINK_DOWN;
+		writel(val, port->base + MVPP22_XLG_CTRL0_REG);
+	} else {
+		val = readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
+		val &= ~MVPP2_GMAC_FORCE_LINK_PASS;
+		val |= MVPP2_GMAC_FORCE_LINK_DOWN;
+		writel(val, port->base + MVPP2_GMAC_AUTONEG_CONFIG);
+	}
+
 	port->tx_time_coal = MVPP2_TXDONE_COAL_USEC;
 
 	port->txqs = devm_kcalloc(dev, port->ntxqs, sizeof(*port->txqs),
-- 
1.9.1

