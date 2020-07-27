Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AD822F7F3
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731050AbgG0Sna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:43:30 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:62172 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728843AbgG0Sn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:43:27 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RIfVGX025660;
        Mon, 27 Jul 2020 11:43:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=iL2lR/5h5Sb2vm+VFJc2yXO5EemP6NeDcSkrTe+WCF0=;
 b=dniKLgHoAAzli3ZLF1O85L6NEtsimu/TMQWhEnkZUEAdU5VyYpO7+RhoddrTiaTTtKBU
 ZRF6E4Qc3aO1togml+selrmtXPf4VppEQ2K+ZpfagffrLyuQyjrsyRn3u9iB1KyFjlgu
 Jq3A8Sj+IFcldsBfisC/oUA6bRGwjSstZqW000Ez78LqB1t3QhbE6CLwugkzDzFj66qw
 BO3TX8eZZ6kALVxNncDlt4irg9oFdZB0LtjvEI3pGEp4lAHjZZPJF3w39hcREjXhsPx/
 PgW49nA+s90WYAEYqiXae74LGCGelmGGuWdJ/Z6oz0ewS++ePzD6mEE/buz+AXqEk7Ne 1Q== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 32gj3qrm3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 11:43:26 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jul
 2020 11:43:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 27 Jul 2020 11:43:25 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id C577A3F7040;
        Mon, 27 Jul 2020 11:43:22 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net-next 03/11] qed: swap param init and publish
Date:   Mon, 27 Jul 2020 21:43:02 +0300
Message-ID: <20200727184310.462-4-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200727184310.462-1-irusskikh@marvell.com>
References: <20200727184310.462-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_13:2020-07-27,2020-07-27 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In theory that could lead to race condition

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
index a62c47c61edf..4e3316c6beb6 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
@@ -75,8 +75,8 @@ struct devlink *qed_devlink_register(struct qed_dev *cdev)
 					   QED_DEVLINK_PARAM_ID_IWARP_CMT,
 					   value);
 
-	devlink_params_publish(dl);
 	cdev->iwarp_cmt = false;
+	devlink_params_publish(dl);
 
 	return dl;
 
-- 
2.17.1

