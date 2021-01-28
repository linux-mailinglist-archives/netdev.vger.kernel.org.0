Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25C0307E1C
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 19:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhA1Sgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 13:36:43 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29966 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231127AbhA1Sev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 13:34:51 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10SI62bO020134;
        Thu, 28 Jan 2021 10:32:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=/g/es+Tg5FBzCKG2QIZyAEonCnsAEgNRvkP3FuHc02k=;
 b=gVlQ94Bb/ciJQqm/roNAsKBQAyoJ82/Ms79MjP/QYk0AJlP6LU7k+C7LOWuXpBkQzDgJ
 c+Ug+e/FTU7k2imI7J0ktigVexglP1DPtILrn+dKcWkG7RqodCCtBzje8Xl2f7M8ukeY
 4KwH1DSSYUTirPij+vM5bvzwp+P4F6/HtMGB9jhQzNLr+Tiu0xrsOp2V738+EzxKgcPr
 an4PmIWWATpD5io/2qvByySYQkWtRq1MG2t/6gVr4NeYUmky0SfQYM6nrEXmUXPbqIBO
 guG1NM5oeAPk9qqWESuxEDM1SXYy9bD2g1HbPDENOkEfkVI2cc+fIO+pZY3HO8c8H9UX 2w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1ufxf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 10:32:00 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 28 Jan
 2021 10:31:58 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 28 Jan 2021 10:31:58 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 913163F7041;
        Thu, 28 Jan 2021 10:31:55 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v5 net-next 08/18] net: mvpp2: increase RXQ size to 1024 descriptors
Date:   Thu, 28 Jan 2021 20:31:12 +0200
Message-ID: <1611858682-9845-9-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1611858682-9845-1-git-send-email-stefanc@marvell.com>
References: <1611858682-9845-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_12:2021-01-28,2021-01-28 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

RXQ size increased to support Firmware Flow Control.
Minimum depletion thresholds to support FC is 1024 buffers.
Default set to 1024 descriptors and maximum size to 2048.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 8dc669d..cac9885 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -715,8 +715,8 @@
 #define MVPP2_PORT_MAX_RXQ		32
 
 /* Max number of Rx descriptors */
-#define MVPP2_MAX_RXD_MAX		1024
-#define MVPP2_MAX_RXD_DFLT		128
+#define MVPP2_MAX_RXD_MAX		2048
+#define MVPP2_MAX_RXD_DFLT		1024
 
 /* Max number of Tx descriptors */
 #define MVPP2_MAX_TXD_MAX		2048
-- 
1.9.1

