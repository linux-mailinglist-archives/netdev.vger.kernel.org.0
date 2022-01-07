Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16741487313
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 07:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbiAGGau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 01:30:50 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37276 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231627AbiAGGat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 01:30:49 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2072gcB5007681;
        Thu, 6 Jan 2022 22:30:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=BzD+JOeE5SEyDsNPJEUsYX9QBWZrnmw3rAS99OixYlQ=;
 b=CAHKdy387IHrG08WBQELmXpLcTQg+mCqY77Cy7+elisFWe65jB5XM6tkKqQtpjZ1YoKu
 GOu54S+2YZrJQb95BlUh6dlqSPnw8vV00nIRFV3aPoVxTGGeXd0qTlYdSVVnsPdAkoBR
 +vzV+T72Y+ywVqis/9usj4xlB0MSsTdYOp1LIni/BYHhGTusRV3hCwKKCpc0uXokM9Xl
 ilSQmuw4mVghYYYhMn3iPMOMVmbJb+JA4x7eC7B/jRxCJC0bgVG6UZstJNM2hlmljRrW
 fZZdjyivlIBo7NnSP6N/XfHqBO5iosR0BsAoH3LJYbA6xduKapU3dAWDYmRTp78JAiLx DQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3de4w5j28t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 22:30:40 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 6 Jan
 2022 22:30:38 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 6 Jan 2022 22:30:38 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 2B5443F7057;
        Thu,  6 Jan 2022 22:30:35 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        <rsaladi2@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH 1/2] octeontx2-af: Increment ptp refcount before use
Date:   Fri, 7 Jan 2022 12:00:29 +0530
Message-ID: <1641537030-27911-2-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1641537030-27911-1-git-send-email-sbhatta@marvell.com>
References: <1641537030-27911-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: bWIkN15rUzLY2uAd8HlYRejyOZN_YymL
X-Proofpoint-GUID: bWIkN15rUzLY2uAd8HlYRejyOZN_YymL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-07_01,2022-01-06_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before using the ptp pci device by AF driver increment
the reference count of it.

Fixes: a8b90c9d26d6 ("octeontx2-af: Add PTP device id for CN10K and 95O silcons")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
index d6321de..e682b7b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
@@ -60,6 +60,8 @@ struct ptp *ptp_get(void)
 	/* Check driver is bound to PTP block */
 	if (!ptp)
 		ptp = ERR_PTR(-EPROBE_DEFER);
+	else
+		pci_dev_get(ptp->pdev);
 
 	return ptp;
 }
-- 
2.7.4

