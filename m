Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6F52F0955
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 20:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbhAJT0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 14:26:00 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31652 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726394AbhAJT0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 14:26:00 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AJMZpw014599;
        Sun, 10 Jan 2021 11:23:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=i1UeS92+QN0MF3RiPXB1b5sYUz8GZG1QSid9119WUG8=;
 b=CIE9j0g6KYqUBUGmbGdlCHdJxMrQm4xlp/Je8C7oJZIRVcHCAN6gRnc28eumknrO3tcS
 FzxdtWRCfkw7HzsRCtK/4eUBPZO2m2v1mBfX8P+wStXVqvvTveio5Zs7OHE8B4k7cYhd
 l2hQhhKIAzEgzCy3vnVVM8jpQj0HdiR04k84wQRBUXTHVOb2isZIsZJNcHh0j7NBE6Tn
 URKVnZ5FlbLHWTWsY8byUJQmpsdthfLLPpxa4eX3tm3R4yM8jqJshRdeq5edL8A05+iO
 fk+w2jjenxzD7Dcw5pPnGSfYicGaCfYuQzk/FrRq5KDN+OAjdN8FO2GF+UJ/D9iuzIV+ xw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 35yaqsjds8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 11:23:10 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 11:23:09 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 11:23:08 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 10 Jan 2021 11:23:08 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 89C8B3F703F;
        Sun, 10 Jan 2021 11:23:05 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH net ] net: mvpp2: Remove Pause and Asym_Pause support
Date:   Sun, 10 Jan 2021 21:23:02 +0200
Message-ID: <1610306582-16641-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Packet Processor hardware not connected to MAC flow control unit and
cannot support TX flow control.
This patch disable flow control support.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 82c6bef..d04171d 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5861,8 +5861,6 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 
 	phylink_set(mask, Autoneg);
 	phylink_set_port_modes(mask);
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
 
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_10GBASER:
-- 
1.9.1

