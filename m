Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B267D1B2A95
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 17:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbgDUPAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 11:00:31 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20050 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726628AbgDUPA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 11:00:29 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03LEtdPB022819;
        Tue, 21 Apr 2020 08:00:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=GbWJcZCgLloge32IsBieU3dpMyLYErAWJJlqtz6epB8=;
 b=aKeBG7Hss5ej+SdVnmANNLY3/9lBHGiPMkBxCN8ti4LwWqo5qqICVBg84DOkrCYCoz5J
 WxIvzp84pFIP3UMjAXmgIy2kGNi0WDzz7bPU9B93ZYL6QELLK+ezSPPRq8j1EwpzfpCf
 FCVzMVzRXASJBx8+40mKcrEwJYhUdYA2P06Me4nAwfhKgljOTIbpc1TY3aD+jTNxJq0K
 Lhm8RNljY1P47iAD8VRXBQyM3AOXzPOEmsFFqSD8ERzeT1fEJiFecfVzHdIXekQG5s57
 JWgAiksuKI+O5ujYuW9yHymdU1X+sDuvWgNJOvZFp09lJjICZjcV2wt8wSbLgs8kyC0w iQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 30fxwpcqua-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 21 Apr 2020 08:00:27 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Apr
 2020 07:53:30 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Apr
 2020 07:53:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 21 Apr 2020 07:53:30 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id CA18C3F7040;
        Tue, 21 Apr 2020 07:53:29 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 03LErTFO016331;
        Tue, 21 Apr 2020 07:53:29 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 03LErT8A016330;
        Tue, 21 Apr 2020 07:53:29 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <mkalderon@marvell.com>
Subject: [PATCH net-next 2/3] qede: Cache num configured VFs on a PF.
Date:   Tue, 21 Apr 2020 07:52:59 -0700
Message-ID: <20200421145300.16278-3-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200421145300.16278-1-skalluru@marvell.com>
References: <20200421145300.16278-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_05:2020-04-20,2020-04-21 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch add changes to cache the number of VFs configured on a PF.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h      |  1 +
 drivers/net/ethernet/qlogic/qede/qede_main.c | 15 +++++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 234c6f3..bf8b8ad 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -198,6 +198,7 @@ struct qede_dev {
 	struct net_device		*ndev;
 	struct pci_dev			*pdev;
 
+	int				num_vfs;
 	u32				dp_module;
 	u8				dp_level;
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 34fa391..9c4d9cd 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -190,12 +190,15 @@ static int qede_sriov_configure(struct pci_dev *pdev, int num_vfs_param)
 	rc = edev->ops->iov->configure(edev->cdev, num_vfs_param);
 
 	/* Enable/Disable Tx switching for PF */
-	if ((rc == num_vfs_param) && netif_running(edev->ndev) &&
-	    !qed_info->b_inter_pf_switch && qed_info->tx_switching) {
-		vport_params->vport_id = 0;
-		vport_params->update_tx_switching_flg = 1;
-		vport_params->tx_switching_flg = num_vfs_param ? 1 : 0;
-		edev->ops->vport_update(edev->cdev, vport_params);
+	if (rc == num_vfs_param) {
+		edev->num_vfs = rc;
+		if (netif_running(edev->ndev) &&
+		    !qed_info->b_inter_pf_switch && qed_info->tx_switching) {
+			vport_params->vport_id = 0;
+			vport_params->update_tx_switching_flg = 1;
+			vport_params->tx_switching_flg = num_vfs_param ? 1 : 0;
+			edev->ops->vport_update(edev->cdev, vport_params);
+		}
 	}
 
 	vfree(vport_params);
-- 
1.8.3.1

