Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C0931B092
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 14:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhBNNkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 08:40:32 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:57342 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229637AbhBNNk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 08:40:28 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11EDZ4am024576;
        Sun, 14 Feb 2021 05:39:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=qW9zL3rPdfmlwjMaLhkOuc1rmBoEJNezgQHiqqrUETc=;
 b=ZLhrMLwQ8jkOcvyuHDan18eQLpohKLGMoVwEcfYM03VCFVWwmxa2cdvoNPp5PpES0DWY
 DZy5TTWh4ogZH52C+FuLVdlXwmHDmAF2wuV1gPK32wSzGljbuiK4bt0cmOvRphSx2gaw
 O1/zsUd4c5v92bncy8hjtwHNd794vroI6lwLKf42+HJRS8xo/D9KVT1Ml0rQA1Pe11ww
 oKFxXQ3zT86sUPb4yz3rewkskAL28rUz+FEN7pBQMpnTrE5scsRyzcnMOzventux+yPy
 UfYzEuCJKfk/nAXVopEHgadfIE1TJd1g2RJJltoLqRSks86hg+uRJGu9yHNORnxEbxr1 Tg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36pd0vhyx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 14 Feb 2021 05:39:39 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 14 Feb
 2021 05:39:37 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 14 Feb 2021 05:39:37 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id EF78D3F7040;
        Sun, 14 Feb 2021 05:39:34 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [net-next 1/4] net: mvpp2: simplify PPv2 version ID read
Date:   Sun, 14 Feb 2021 15:38:34 +0200
Message-ID: <1613309917-17569-2-git-send-email-stefanc@marvell.com>
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

PPv2.1 contain 0 in Version ID register, priv->hw_version check
can be removed.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index e88272f..9127dc2 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -7469,10 +7469,8 @@ static int mvpp2_probe(struct platform_device *pdev)
 			priv->port_map |= BIT(i);
 	}
 
-	if (priv->hw_version != MVPP21) {
-		if (mvpp2_read(priv, MVPP2_VER_ID_REG) == MVPP2_VER_PP23)
-			priv->hw_version = MVPP23;
-	}
+	if (mvpp2_read(priv, MVPP2_VER_ID_REG) == MVPP2_VER_PP23)
+		priv->hw_version = MVPP23;
 
 	/* Init mss lock */
 	spin_lock_init(&priv->mss_spinlock);
-- 
1.9.1

