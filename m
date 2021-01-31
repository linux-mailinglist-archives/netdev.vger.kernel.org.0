Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C83309B65
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 11:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhAaKn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 05:43:27 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39140 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230346AbhAaJzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 04:55:43 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10V9cNJe023389;
        Sun, 31 Jan 2021 01:52:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=aSXi+ShybKDRXVs2uOeY/wKykSo1tWgMER6OrWimJFs=;
 b=PNY/r4d1ubN2v9uUSNdJcsf6FmD3AvJawgtQ94hKkfqtDgOPNveXtQPI7kQmoW32I4Zb
 vbYGNDiCYc08Q8a+ht1LLoFE10iutzx1zbBq9uxaCx3ljAYnGMQcdsHOL54xnpXTE91m
 POZP6T2f3Vs70ZBnapLf6FJ3C0NSC9eg+2CTVdhvqhxsagBVu/aXXjD/0mop84sS59IC
 +hnITxpoIKCkWUJ42miFd4Wm8rSsxS3WK8lO6QAtUFyb07orQ1/Zr/RJhEUixD84ORvU
 65q2tNSKHzG1p/k5AL5JF5PDG31MijhF7xbGinw76g9xvAdx6o99fboDdocX2L1Ib7qP dg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36d5psshk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 01:52:10 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 01:52:09 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 01:52:08 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 31 Jan 2021 01:52:08 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id BCE563F703F;
        Sun, 31 Jan 2021 01:52:05 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v6 net-next 16/18] net: mvpp2: set 802.3x GoP Flow Control mode
Date:   Sun, 31 Jan 2021 11:51:02 +0200
Message-ID: <1612086664-23972-17-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612086664-23972-1-git-send-email-stefanc@marvell.com>
References: <1612086664-23972-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-31_03:2021-01-29,2021-01-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

This patch fix GMAC TX flow control autoneg.
Flow control autoneg wrongly were disabled with enabled TX
flow control.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index afa61cc..7632810 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6282,7 +6282,7 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 	old_ctrl4 = ctrl4 = readl(port->base + MVPP22_GMAC_CTRL_4_REG);
 
 	ctrl0 &= ~MVPP2_GMAC_PORT_TYPE_MASK;
-	ctrl2 &= ~(MVPP2_GMAC_INBAND_AN_MASK | MVPP2_GMAC_PCS_ENABLE_MASK);
+	ctrl2 &= ~(MVPP2_GMAC_INBAND_AN_MASK | MVPP2_GMAC_PCS_ENABLE_MASK | MVPP2_GMAC_FLOW_CTRL_MASK);
 
 	/* Configure port type */
 	if (phy_interface_mode_is_8023z(state->interface)) {
-- 
1.9.1

