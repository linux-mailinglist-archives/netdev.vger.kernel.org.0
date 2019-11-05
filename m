Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBB9EF52A
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 06:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387564AbfKEFwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 00:52:15 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27072 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387504AbfKEFwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 00:52:15 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA55oBjo027790;
        Mon, 4 Nov 2019 21:52:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Zzhxd60Xhgsy1rpwOE0x6nzoL/FxaIDXUtqWSXhX/s8=;
 b=xNKMbf33gvD+LZSNK31Fj2yq7e6M5tgVN1vuZtVPsqVodFCkDoYBqmMcrlbxM2n4dsdb
 oM471+6op8keBz0z0O6catReDDJ/MFNiIidQi3EOaHi+sNKm/AMTxorQlPHxHLS6R/wY
 kSW5AXSXOSQE8i2KicvRGyLaeUoM0maAwVdR4DJHU0hFdbf6P5rolg7vKKM2aUAh1S4o
 B0S2wFHwMknuhJDkGvVwXym+s/V54bbe8nGz2MFzrXN4kjfP9yVPfhYSuKc4ZcLJD9/S
 7RCe+yrJQdGcrZK3K1TMB2/VHJNjPdf41zqrv2pFWiq6+cTc1NxTujjP9kYnyrf/WSMY PQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2w19amruf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 04 Nov 2019 21:52:12 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 4 Nov
 2019 21:52:10 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Mon, 4 Nov 2019 21:52:10 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9BD273F703F;
        Mon,  4 Nov 2019 21:52:10 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xA55qAvl030058;
        Mon, 4 Nov 2019 21:52:10 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xA55qAc0030057;
        Mon, 4 Nov 2019 21:52:10 -0800
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <manishc@marvell.com>,
        <mrangankar@marvell.com>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 2/4] bnx2x: Enable Multi-Cos feature.
Date:   Mon, 4 Nov 2019 21:51:10 -0800
Message-ID: <20191105055112.30005-3-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191105055112.30005-1-skalluru@marvell.com>
References: <20191105055112.30005-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-05_01:2019-11-04,2019-11-05 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FW version 7.13.15 addresses the issue in Multi-cos implementation.
This patch re-enables the Multi-Cos support in the driver.

Fixes: d1f0b5dce8fd ("bnx2x: Disable multi-cos feature.")
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index d10b421..5e037a3 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -1934,7 +1934,8 @@ u16 bnx2x_select_queue(struct net_device *dev, struct sk_buff *skb,
 	}
 
 	/* select a non-FCoE queue */
-	return netdev_pick_tx(dev, skb, NULL) % (BNX2X_NUM_ETH_QUEUES(bp));
+	return netdev_pick_tx(dev, skb, NULL) %
+			(BNX2X_NUM_ETH_QUEUES(bp) * bp->max_cos);
 }
 
 void bnx2x_set_num_queues(struct bnx2x *bp)
-- 
1.8.3.1

