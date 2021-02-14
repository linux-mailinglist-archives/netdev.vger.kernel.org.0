Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED6F31B095
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 14:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhBNNkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 08:40:40 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3164 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229837AbhBNNke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 08:40:34 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11EDZGf2024627;
        Sun, 14 Feb 2021 05:39:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Esi1Y2JrexnpQQeZJjiuyDCBKhV6+jEY1GLf3GLDt/k=;
 b=EYFIG8GKnQVPZ4EaaeFGuk8Zfn+JYzW+R/YNh4BxdXAft7H9qP+ut2WwomecMjq0pc1g
 WOX3TW0piMRwHfd3Ed7fsP6CHrXb5fK2oDb6U2JoXlrqJHdU/PaZpPghi0P1H6c0FhfS
 unoyisAb8NqdKeitP3iDwmCbnyEdpfSUMdQS3xSXsMziJw019gQnqxDw8Y9Tks8x96U3
 CxoS3tCvcYOE1CDojNhExV6NmpRfvcAuYOCa91JBKayMIJiPnnYVeUeLKhpiKW6S+hVj
 7pn0VKy+qGQYD3WWliMxC65a0l8icIVbSP1UQlR6EiNyKfFR3tFLotPYMfvvCiLccpp3 KA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36pd0vhyxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 14 Feb 2021 05:39:46 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 14 Feb
 2021 05:39:45 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 14 Feb
 2021 05:39:44 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 14 Feb 2021 05:39:44 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id B108B3F7040;
        Sun, 14 Feb 2021 05:39:41 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [net-next 3/4] net: mvpp2: improve mvpp2_get_sram return
Date:   Sun, 14 Feb 2021 15:38:36 +0200
Message-ID: <1613309917-17569-4-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1613309917-17569-1-git-send-email-stefanc@marvell.com>
References: <1613309917-17569-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-14_03:2021-02-12,2021-02-14 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Use PTR_ERR_OR_ZERO instead of IS_ERR and PTR_ERR.
Non functional change.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 4e1a24c..bc98f52 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -7277,10 +7277,8 @@ static int mvpp2_get_sram(struct platform_device *pdev,
 	}
 
 	priv->cm3_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(priv->cm3_base))
-		return PTR_ERR(priv->cm3_base);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(priv->cm3_base);
 }
 
 static int mvpp2_probe(struct platform_device *pdev)
-- 
1.9.1

