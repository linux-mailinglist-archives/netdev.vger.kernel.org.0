Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E1424B81E
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 13:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbgHTLJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 07:09:34 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60442 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730664AbgHTLJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 07:09:13 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KB6vV8005004;
        Thu, 20 Aug 2020 04:09:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=T4CX3VWfG2PeimQF46kq/C3KZZhAOY/QWzVqxBwIC2E=;
 b=a8kf0VUYDH/uOdCwn0vJAihk4OAcNRmI+SY9I5I/4XB+BPlWNzruvTWgS32hb9nktblp
 53s7FgZar2Vp4qIXxOucox0/XVdyO0ukBtxXPYqkd7Old6aGLpITTUQk0Xqs08Fy491Z
 A7lBSoe98icnJU2opBIMsim92h2e2zTk8wd1ceI41H6id2sKfmuGpcnrjJ1PeoMxYyfo
 TLMuqXh1/eGk3ZvzCC7zWMGVZ40Pzjm1X9p4njza5OL3NsnpAnwRyDspFR0zh2KOuVE/
 T97z7s4Rn0kdwsAmv/3oWCrZ0BFkcmczr2byoB8mF5ofL+nEIjiMHmF7lalBkMl7yW5A 0g== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 3304hhvsun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Aug 2020 04:09:10 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 Aug
 2020 04:09:09 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 Aug
 2020 04:09:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 20 Aug 2020 04:09:08 -0700
Received: from NN-LT0065.marvell.com (NN-LT0065.marvell.com [10.193.54.69])
        by maili.marvell.com (Postfix) with ESMTP id 7536A3F703F;
        Thu, 20 Aug 2020 04:09:06 -0700 (PDT)
From:   Dmitry Bogdanov <dbogdanov@marvell.com>
To:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>
CC:     Dmitry Bogdanov <dbogdanov@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net 2/3] net: qede: Disable aRFS for NPAR and 100G
Date:   Thu, 20 Aug 2020 14:08:31 +0300
Message-ID: <3950bbb988b66c9c43c46d46c9632a272cea294c.1597833340.git.dbogdanov@marvell.com>
X-Mailer: git-send-email 2.28.0.windows.1
In-Reply-To: <cover.1597833340.git.dbogdanov@marvell.com>
References: <cover.1597833340.git.dbogdanov@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_02:2020-08-19,2020-08-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some configurations ARFS cannot be used, so disable it if device
is not capable.

Fixes: e4917d46a653 ("qede: Add aRFS support")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_filter.c |  3 +++
 drivers/net/ethernet/qlogic/qede/qede_main.c   | 11 +++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index f961f65d9372..c59b72c90293 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -311,6 +311,9 @@ int qede_alloc_arfs(struct qede_dev *edev)
 {
 	int i;
 
+	if (!edev->dev_info.common.b_arfs_capable)
+		return -EINVAL;
+
 	edev->arfs = vzalloc(sizeof(*edev->arfs));
 	if (!edev->arfs)
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 140a392a81bb..9e1f41ba766c 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -804,7 +804,7 @@ static void qede_init_ndev(struct qede_dev *edev)
 		      NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 		      NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_HW_TC;
 
-	if (!IS_VF(edev) && edev->dev_info.common.num_hwfns == 1)
+	if (edev->dev_info.common.b_arfs_capable)
 		hw_features |= NETIF_F_NTUPLE;
 
 	if (edev->dev_info.common.vxlan_enable ||
@@ -2274,7 +2274,7 @@ static void qede_unload(struct qede_dev *edev, enum qede_unload_mode mode,
 	qede_vlan_mark_nonconfigured(edev);
 	edev->ops->fastpath_stop(edev->cdev);
 
-	if (!IS_VF(edev) && edev->dev_info.common.num_hwfns == 1) {
+	if (edev->dev_info.common.b_arfs_capable) {
 		qede_poll_for_freeing_arfs_filters(edev);
 		qede_free_arfs(edev);
 	}
@@ -2341,10 +2341,9 @@ static int qede_load(struct qede_dev *edev, enum qede_load_mode mode,
 	if (rc)
 		goto err2;
 
-	if (!IS_VF(edev) && edev->dev_info.common.num_hwfns == 1) {
-		rc = qede_alloc_arfs(edev);
-		if (rc)
-			DP_NOTICE(edev, "aRFS memory allocation failed\n");
+	if (qede_alloc_arfs(edev)) {
+		edev->ndev->features &= ~NETIF_F_NTUPLE;
+		edev->dev_info.common.b_arfs_capable = false;
 	}
 
 	qede_napi_add_enable(edev);
-- 
2.17.1

