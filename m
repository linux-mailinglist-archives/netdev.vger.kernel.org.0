Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFBE312C12
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 09:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhBHImP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 03:42:15 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29262 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230352AbhBHIgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 03:36:40 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1188WCRk003068;
        Mon, 8 Feb 2021 00:35:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=DvfD7O77b2ATuThWoUKzOIAnS3uUNeYNikGy/OGeLu8=;
 b=dS/HpoZg1VqjnSIuUWzUn0TRe6NMFU8xQ07Qn8766nQplFj20sLodW30I/Yhb02zmlyk
 xbItxxVK8NytIjuT87S2aqkpAPMfcJv6+qn88IjUtGNsfNhos6J8O2iDwdp0MIOtVnGa
 Jc+gaRiY+zRvkyxMe3MY3u2lXZfKjjCuDS7gNeL9dxMDIYDCCUqeTMGAzCXD36ux4F1Z
 xyoaVuGfuFBJvvQxtnWBme3sW7zAIcAAhkMjINkmh12LojIaDT0xQoK1fra+a5Hd7IY2
 kYxl6I1T96G7OEvdmIQqvPDVM+t4pOSOCqkjfvSaSaTz6RpkB5KzZ4AE7wiQwHOb0F6i zw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugq3ydb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 08 Feb 2021 00:35:44 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 8 Feb
 2021 00:35:42 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 8 Feb
 2021 00:35:41 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 8 Feb 2021 00:35:41 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id EE71F3F703F;
        Mon,  8 Feb 2021 00:35:37 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>, <devicetree@vger.kernel.org>,
        <robh+dt@kernel.org>, <sebastian.hesselbarth@gmail.com>,
        <gregory.clement@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v10 net-next 14/15] net: mvpp2: set 802.3x GoP Flow Control mode
Date:   Mon, 8 Feb 2021 10:32:46 +0200
Message-ID: <1612773167-22490-15-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612773167-22490-1-git-send-email-stefanc@marvell.com>
References: <1612773167-22490-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-08_02:2021-02-08,2021-02-08 signatures=0
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
index a472125..4d0a398 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6283,7 +6283,7 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 	old_ctrl4 = ctrl4 = readl(port->base + MVPP22_GMAC_CTRL_4_REG);
 
 	ctrl0 &= ~MVPP2_GMAC_PORT_TYPE_MASK;
-	ctrl2 &= ~(MVPP2_GMAC_INBAND_AN_MASK | MVPP2_GMAC_PCS_ENABLE_MASK);
+	ctrl2 &= ~(MVPP2_GMAC_INBAND_AN_MASK | MVPP2_GMAC_PCS_ENABLE_MASK | MVPP2_GMAC_FLOW_CTRL_MASK);
 
 	/* Configure port type */
 	if (phy_interface_mode_is_8023z(state->interface)) {
-- 
1.9.1

