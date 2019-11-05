Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9B3EF52C
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 06:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387590AbfKEFwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 00:52:19 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27808 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387555AbfKEFwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 00:52:19 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA55ntw7019368;
        Mon, 4 Nov 2019 21:52:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=B+YBJKRobkP64FQ3wLgYyLHx6PCD6lwAQwijF76xh1o=;
 b=aOsr0ehgDrmavqxlbGvmfKuzyIlJyhdI64FN8v7ftlTMP+d3osrVOYj8EHSL9QCkAzu6
 6AlMu/vvRFJ3FFdlfo0Z93xME4JsJJR/d9WkWm7xqKaelgeVP1N3VNAdLLZ6qE0TUlnB
 16M/pFoHccUt6b7rTQbFCedjEP+AKWr4aWWJd1+vKaPD4/RsV6rulozm6IRBFUHS9EYs
 BMffmYt3LwEJuciqlxnANQuiNXAZ1v9SDotbCoofWwYkbkmWnq0TcmBcB+svQjpSh4eE
 /wNsMPDDTRQumum6uelJ4un3f62EF5M4ckTTntZgMdZ8PpnWVm5lwyzXfQ6/KvT1AsZV Xg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w17n91er1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 04 Nov 2019 21:52:18 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 4 Nov
 2019 21:52:17 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Mon, 4 Nov 2019 21:52:17 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0161A3F703F;
        Mon,  4 Nov 2019 21:52:16 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xA55qGEm030066;
        Mon, 4 Nov 2019 21:52:16 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xA55qGZU030065;
        Mon, 4 Nov 2019 21:52:16 -0800
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <manishc@marvell.com>,
        <mrangankar@marvell.com>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 4/4] cnic: Set fp_hsi_ver as part of CLIENT_SETUP ramrod
Date:   Mon, 4 Nov 2019 21:51:12 -0800
Message-ID: <20191105055112.30005-5-skalluru@marvell.com>
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

From: Manish Rangankar <mrangankar@marvell.com>

The new FW has added extra validation for HSI version to
make FW backward compatible with older VF drivers. Hence
set fp_hsi_ver to Fast Path HSI version of the FW in use.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Manish Chopra <manishc@marvell.com>
---
 drivers/net/ethernet/broadcom/cnic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
index 155599d..61ab7d2 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -5208,6 +5208,8 @@ static void cnic_init_rings(struct cnic_dev *dev)
 		cnic_init_bnx2x_tx_ring(dev, data);
 		cnic_init_bnx2x_rx_ring(dev, data);
 
+		data->general.fp_hsi_ver =  ETH_FP_HSI_VERSION;
+
 		l5_data.phy_address.lo = udev->l2_buf_map & 0xffffffff;
 		l5_data.phy_address.hi = (u64) udev->l2_buf_map >> 32;
 
-- 
1.8.3.1

