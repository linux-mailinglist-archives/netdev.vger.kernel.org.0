Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7D0309D17
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 15:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhAaOmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 09:42:05 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15192 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231993AbhAaOk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 09:40:28 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10VEZqoH024782;
        Sun, 31 Jan 2021 06:39:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=migziCnZ7PdHSXho5apmvqn7UBrKN34JL1abM3fmZTk=;
 b=h3OsoZPrHJvUmjiyv3bdqOvseEuTMl/sPTWgS6it3Wh1jVOW5FVd6qJyeBUMB07EXg+P
 LmrX3hZ73X+Br5OoMKmFsHihFooyEPOTaPcLiq4WslE1bIGgCYBbC2Usa/6fhSrcdpr2
 VW3h2jXlhcR4ivAybzlplDtzMxSIHUG2mV+QsChEt+tHxmYWSev5WcC42wShsWz8Ysz+
 r59DklOjY33MA2HMryTQCpd/dqbqzW3JBwt7/SinemvAvjS4MA6v2V90PpC8r/sDRBig
 6Qhfc61Cowd4uIRWUlRaXyGAgKbB839mF0tP57eMEkn+6XCeXZaAxRoyZoiYqpnQKzVl Gw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36d7uq1q4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 06:39:20 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 06:39:18 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 06:39:18 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 31 Jan 2021 06:39:18 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 775813F704B;
        Sun, 31 Jan 2021 06:39:15 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v7 net-next 14/15] net: mvpp2: set 802.3x GoP Flow Control mode
Date:   Sun, 31 Jan 2021 16:33:57 +0200
Message-ID: <1612103638-16108-15-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612103638-16108-1-git-send-email-stefanc@marvell.com>
References: <1612103638-16108-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-31_04:2021-01-29,2021-01-31 signatures=0
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
index 06d3239..98849b0 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6284,7 +6284,7 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 	old_ctrl4 = ctrl4 = readl(port->base + MVPP22_GMAC_CTRL_4_REG);
 
 	ctrl0 &= ~MVPP2_GMAC_PORT_TYPE_MASK;
-	ctrl2 &= ~(MVPP2_GMAC_INBAND_AN_MASK | MVPP2_GMAC_PCS_ENABLE_MASK);
+	ctrl2 &= ~(MVPP2_GMAC_INBAND_AN_MASK | MVPP2_GMAC_PCS_ENABLE_MASK | MVPP2_GMAC_FLOW_CTRL_MASK);
 
 	/* Configure port type */
 	if (phy_interface_mode_is_8023z(state->interface)) {
-- 
1.9.1

