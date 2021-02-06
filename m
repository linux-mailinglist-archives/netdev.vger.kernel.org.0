Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E19B311EDA
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 17:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhBFQvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 11:51:40 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23560 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230487AbhBFQtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 11:49:12 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 116GjwMo024296;
        Sat, 6 Feb 2021 08:48:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=9lzUz2BCH7tu12Q5O+UlThumhN5ntvDQXiyz9b0qc7o=;
 b=afpdSRSuSEkBGiO4nlDPRWmya87zqH7CN0dXPyJEd7q9GhuNGLVjtmy3QkVA8PDlm2Aw
 EvNYR6s03mOklv0i0eRGC4uOC/fmLA7ixpUaoeqBun9mag0X0JvzVqS9BNi2IHa4INGP
 eFwltb7PQ4cFfwhyharUYO76u/2IzpQEj3oqbdCigM2ZiG9l0TXnMO8v9WG/JFvebvVA
 OO1rLKH2XVGnAxJvwjZnzwjvW/LsBMHKJWKxaDvE46TOh6UjXriTMS0DEkqNh8/e/3o3
 eFMvqC7zNfVRnrnfrYo6T+dq+p1MoFkx6Yo4e9PDlpSdJx1CuBENbS1GiyCgrPWtUfzI kA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugq09xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 06 Feb 2021 08:48:24 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 6 Feb
 2021 08:48:22 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 6 Feb 2021 08:48:21 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 2306C3F703F;
        Sat,  6 Feb 2021 08:48:18 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v8 net-next 14/15] net: mvpp2: set 802.3x GoP Flow Control mode
Date:   Sat, 6 Feb 2021 18:46:00 +0200
Message-ID: <1612629961-11583-15-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612629961-11583-1-git-send-email-stefanc@marvell.com>
References: <1612629961-11583-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-06_06:2021-02-05,2021-02-06 signatures=0
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
index 5a51697..5526214 100644
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

