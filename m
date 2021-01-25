Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F98E30288F
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 18:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730613AbhAYROg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 12:14:36 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:12808 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730563AbhAYRNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 12:13:04 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10PGpnLK018054;
        Mon, 25 Jan 2021 09:10:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=1sbBDEteLU8URY1O1HNgrpOjmbQpvXwOvjFY5lVJWug=;
 b=FYIcaGnCO4OZGYQdxriu6V5u2lI80Yz/ugCtCap+ViEnl6VRtG1W10OUsWKr2XH2Zfcr
 oVwVK7yWB6UU9Ml5L5piAkWzjWZVJXBULeNjWC7yaut0eqwB/5Hz1p+BYdu9iHZqDHng
 ur6uP6n1Tb07iktR1M7gIZKJDX2VxgCOvVQOnXCBQyLNdhFNmhci/tndPGNkfZF33PDQ
 5xW6ihNeHydnjORYPB/ZPJCvzM8NyeaWVQ/3nxe8una/5mi8GyQU+TwMmK8nuYdwnipE
 vFMf0fJ/EgiiW1ZNjrRsq4lBWvUv2tAp0Wc8CAuE8ulWQtZr2oTSZFJu9qGtVKkNiSjY Dg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1u5ajf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 25 Jan 2021 09:10:16 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 25 Jan
 2021 09:10:15 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 25 Jan
 2021 09:10:15 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 25 Jan 2021 09:10:15 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 665463F7043;
        Mon, 25 Jan 2021 09:10:12 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v3 RFC net-next 17/19] net: mvpp2: set 802.3x GoP Flow Control mode
Date:   Mon, 25 Jan 2021 19:08:04 +0200
Message-ID: <1611594486-29431-18-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1611594486-29431-1-git-send-email-stefanc@marvell.com>
References: <1611594486-29431-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-25_07:2021-01-25,2021-01-25 signatures=0
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
index 15974a7..55138c7 100644
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

