Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7E43F4106
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 20:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhHVS4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 14:56:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7348 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230245AbhHVS4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 14:56:05 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17MI21gR001662;
        Sun, 22 Aug 2021 11:55:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=PnZIWHy+JwswUHCXY0k59JrWGsPqhZ9ocCmm/zbrkIs=;
 b=daBCww7pheH5dfM/hRejBG8VZNChD9vxBK85aRSQVsSEJWVm1g3tei3trExA+4hkDWs0
 +YvmucjWaFLI7FtSscIigKJEtSnSwmF+nwVrUStgGBkhfe3IVsmzjBboGQ0bmOmkFpTu
 wt3I1ZCa9lHfz3Q6C+IGmir/PJtlNzC+RR0RXl6k6ge7NaSMAT+lJF/QLQM3VpgYZhWX
 ty/8Pi/HZHW9zaOKfgHGAd/Fv+Hb8iJ1YhELrsAgsgtUTMAbgZNrdE84myQ3OjmtEJpm
 lWRpfBbSWSHutEZPToIPhauBco8mdA0/vcUCnLCXbwOkS1bnaN17r2emoDqHOxQDEwEF 4Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ak10mudbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 22 Aug 2021 11:55:19 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.23; Sun, 22 Aug
 2021 11:55:17 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.23 via Frontend Transport; Sun, 22 Aug 2021 11:55:15 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <aelior@marvell.com>, <smalin@marvell.com>, <malin1024@gmail.com>
Subject: [PATCH] qed: Enable RDMA relaxed ordering
Date:   Sun, 22 Aug 2021 21:54:48 +0300
Message-ID: <20210822185448.12053-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: JUeXKodGkZH6S9ClbHNU_f2lWnGpaN66
X-Proofpoint-ORIG-GUID: JUeXKodGkZH6S9ClbHNU_f2lWnGpaN66
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-22_04,2021-08-20_03,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the RoCE and iWARP FW relaxed ordering.

Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 4f4b79250a2b..496092655f26 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -643,6 +643,8 @@ static int qed_rdma_start_fw(struct qed_hwfn *p_hwfn,
 				    cnq_id);
 	}
 
+	p_params_header->relaxed_ordering = 1;
+
 	return qed_spq_post(p_hwfn, p_ent, NULL);
 }
 
-- 
2.22.0

