Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C5124D484
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 13:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgHULyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 07:54:53 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14286 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728626AbgHULv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 07:51:58 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LBp4wE023950;
        Fri, 21 Aug 2020 04:51:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=T4CX3VWfG2PeimQF46kq/C3KZZhAOY/QWzVqxBwIC2E=;
 b=bNnuraK5BD8OUwMd3CUqAWvfhP8+lTsk5MPGXluyLQaFdT42dv164sbRHZd39uWAyhCb
 0kGcoZy38RbtVAXoE1sOjXitMR3Hc7lMF+LzbyH5YRQpeDB9mpxDKcHCKL6U/hYZt3xr
 4g8yi0GrCLeYMvmjgZ+m42jQi4eQB0J15tssPIOgi+cYfMofUglEDK0FHKECx+19qRje
 nxj2HcIboEoKc1s+skWmCJFH2AAzi7WdNIq6NwvAMMR0XbA0YC4dZWDrnZyGar0HKWpx
 REm8ANxR/kJZLwFIG/Wp1XoQMNpQTrgRmAQZI+dFYrkkVnR6G3L73rUnLARZr21ajrMs 7w== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3304hj23p8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 04:51:49 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 21 Aug
 2020 04:51:47 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 21 Aug 2020 04:51:47 -0700
Received: from NN-LT0065.marvell.com (NN-LT0065.marvell.com [10.193.54.69])
        by maili.marvell.com (Postfix) with ESMTP id CA38F3F703F;
        Fri, 21 Aug 2020 04:51:45 -0700 (PDT)
From:   Dmitry Bogdanov <dbogdanov@marvell.com>
To:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>
CC:     Dmitry Bogdanov <dbogdanov@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v2, net 2/3] net: qede: Disable aRFS for NPAR and 100G
Date:   Fri, 21 Aug 2020 14:51:35 +0300
Message-ID: <3950bbb988b66c9c43c46d46c9632a272cea294c.1597833340.git.dbogdanov@marvell.com>
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

