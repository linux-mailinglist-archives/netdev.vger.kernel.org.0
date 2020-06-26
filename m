Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4561720B876
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgFZSkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:40:53 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:57582 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725855AbgFZSku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:40:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QIFwE6003673;
        Fri, 26 Jun 2020 11:40:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=efCUwvvRXnomp8oKrJSmo7E9nSUwkjMUXONTteGt8Jk=;
 b=M867dvQEXB6tvu6s/kp0OGF17wb8IOEPP0MsxMe7s7o/nQSi27yxRSvThWOi8VkcDS0n
 e5zBSK19y5URF5jZKwTqPW3yYMggq1Feq6cSq6ICpgaWTGmrQ7q+JOpJWXR1nvIywvuy
 LORTb7WkhoQIfdRU1iBR2rb4L3SJU0xAnEqOhgGWo/2Qz5mnrU3EZW3T9mfI0LR6nxTX
 lGh2nnvUlwRAh06inLahCI3rdaZmF23k3xhjob2C1PujbinNPz1X56TvpqyQD9c+NKcS
 ZIUV8Rp+HnWHVQXAxElln1T3vfdHAktCoqVlOt44JFMjJL1wrICphtHv65XtqPNxg/qg Wg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 31uuqh5u84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 26 Jun 2020 11:40:49 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 11:40:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 26 Jun 2020 11:40:49 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 6D8CD3F703F;
        Fri, 26 Jun 2020 11:40:47 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 3/8] net: atlantic: Replace ENOTSUPP usage to EOPNOTSUPP
Date:   Fri, 26 Jun 2020 21:40:33 +0300
Message-ID: <20200626184038.857-4-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200626184038.857-1-irusskikh@marvell.com>
References: <20200626184038.857-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_10:2020-06-26,2020-06-26 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch replaces ENOTSUPP (where it was used by mistake) with
EOPNOTSUPP.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c              | 2 +-
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 647b22d89b1a..43b8914c3ef5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -1188,7 +1188,7 @@ int aq_nic_set_loopback(struct aq_nic_s *self)
 
 	if (!self->aq_hw_ops->hw_set_loopback ||
 	    !self->aq_fw_ops->set_phyloopback)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	mutex_lock(&self->fwreq_mutex);
 	self->aq_hw_ops->hw_set_loopback(self->aq_hw,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index 1d9dee4951f9..bf4c41cc312b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -217,7 +217,7 @@ static int hw_atl_utils_soft_reset_rbl(struct aq_hw_s *self)
 
 	if (rbl_status == 0xF1A7) {
 		aq_pr_err("No FW detected. Dynamic FW load not implemented\n");
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
 	for (k = 0; k < 1000; k++) {
-- 
2.25.1

