Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4CA24D485
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 13:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgHULy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 07:54:57 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45306 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728582AbgHULvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 07:51:52 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LBoPx4021433;
        Fri, 21 Aug 2020 04:51:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=xBc/b7MlULJeQkITKlogoIeCeUWYTBUbK6NFxu4fUFA=;
 b=PjVFVWC2zvA48yVMJ75644zYWFmLE6RYFcYju01hUtwqWbblOB0cYPzPe9KzDvr8WJme
 aKx5oi6drwCjAx27wkEsZMScLLmFMLYHv/DpyTQiurm1O1yyvGl4kQHh/PAhELqJHsgw
 Y2sTbdRxszRNDiHnFEyxqvdggZh7iq0VT1kfEncubOZ4Ut2o3hLJyPRpkDKzOK4kQxpA
 gOVStevJLA02r1WUpnOEl4L1J9x/4tQmSBFGf0iUBM9BYKZj0Pqgf5bqEJXYjJXSoyeT
 tTkhh+vvWYZT6DvxhQp63YSfAZbVuQR1FGYoTA+w/NwIQOgeWpjrjoIdcx0zWlZktxdp JA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 3304fj2e3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 04:51:50 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 21 Aug
 2020 04:51:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 21 Aug 2020 04:51:49 -0700
Received: from NN-LT0065.marvell.com (NN-LT0065.marvell.com [10.193.54.69])
        by maili.marvell.com (Postfix) with ESMTP id 25C553F703F;
        Fri, 21 Aug 2020 04:51:47 -0700 (PDT)
From:   Dmitry Bogdanov <dbogdanov@marvell.com>
To:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>
CC:     Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v2, net 3/3] net: qed: RDMA personality shouldn't fail VF load
Date:   Fri, 21 Aug 2020 14:51:36 +0300
Message-ID: <a356c374d4b5456947242d27d325831f339fd569.1597833340.git.dbogdanov@marvell.com>
X-Mailer: git-send-email 2.28.0.windows.1
In-Reply-To: <cover.1597833340.git.dbogdanov@marvell.com>
References: <cover.1597833340.git.dbogdanov@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_06:2020-08-21,2020-08-21 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the assert during VF driver installation when the personality is iWARP

Fixes: 1fe614d10f45 ("qed: Relax VF firmware requirements")
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_sriov.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index f1f75b6d0421..b8dc5c4591ef 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -71,6 +71,7 @@ static int qed_sp_vf_start(struct qed_hwfn *p_hwfn, struct qed_vf_info *p_vf)
 		p_ramrod->personality = PERSONALITY_ETH;
 		break;
 	case QED_PCI_ETH_ROCE:
+	case QED_PCI_ETH_IWARP:
 		p_ramrod->personality = PERSONALITY_RDMA_AND_ETH;
 		break;
 	default:
-- 
2.17.1

