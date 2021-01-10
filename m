Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034CE2F0809
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 16:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbhAJPeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 10:34:05 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47382 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726929AbhAJPeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 10:34:04 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AFQBaX023651;
        Sun, 10 Jan 2021 07:31:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=uEBjAkcE63NqrDAC9NMl1o4Bp5PVR52PTWfJEYLvcJc=;
 b=JOW790hBEiErysCLu/KzMc+F+z8Bi6Ja0XVtydmd6FB7xbfPIoKcTcWpAse0daE5ToLc
 O2uCcJ2UVzAb5YcVsotT713QKRYKeAmHFie55QwK9V2Q6VlQN7Zf0WGiYf2BeL4Do1hC
 0ptrBAhr3+olLyAovBooEXXm655/nktAY+QBBh36IEMmYYNHxGpbVuTJz3p7wMDvVBTo
 0PzCY6ubBSGLX50mj+lHfZr3PHo66JhYQvsxK5oGE2Fiz5YFgwZrCN0D4GLNGr+C2CZ7
 HroZJuEuqHZ6NAsS4ApAJXmI/25gm0zJBZe4Yh1igdQkHxwycr26gY1D7/szE5v+9BsX XA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvphvdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 07:31:17 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 07:31:14 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 10 Jan 2021 07:31:14 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id ECE823F703F;
        Sun, 10 Jan 2021 07:31:11 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH RFC net-next  06/19] net: mvpp2: increase BM pool size to 2048 buffers
Date:   Sun, 10 Jan 2021 17:30:10 +0200
Message-ID: <1610292623-15564-7-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

BM pool size increased to support Firmware Flow Control.
Minimum depletion thresholds to support FC is 1024 buffers.
BM pool size increased to 2048 to have some 1024 buffers
space between depletion thresholds and BM pool size.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 89b3ede..8dc669d 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -851,8 +851,8 @@ enum mvpp22_ptp_packet_format {
 #define MVPP22_PTP_TIMESTAMPQUEUESELECT	BIT(18)
 
 /* BM constants */
-#define MVPP2_BM_JUMBO_BUF_NUM		512
-#define MVPP2_BM_LONG_BUF_NUM		1024
+#define MVPP2_BM_JUMBO_BUF_NUM		2048
+#define MVPP2_BM_LONG_BUF_NUM		2048
 #define MVPP2_BM_SHORT_BUF_NUM		2048
 #define MVPP2_BM_POOL_SIZE_MAX		(16*1024 - MVPP2_BM_POOL_PTR_ALIGN/4)
 #define MVPP2_BM_POOL_PTR_ALIGN		128
-- 
1.9.1

