Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D6315DB56
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbgBNPp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:45:29 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34898 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729591AbgBNPp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:45:28 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EFhpBp016852;
        Fri, 14 Feb 2020 07:45:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=ERSJF8t582kvzE/+SsYXZTNZaMgOIa/vW3VJ8PS4K1I=;
 b=m/xsKEzkpF4uLjObsBUO/r90YHYNQnjFZx/Q08h13KS1QWHQ3a9BfjU10jLRMQtGEbef
 +qtwIQbLyFXXMjKwmFpnMpJ8d89I11NUQ8fVXIHl8cUMCWNGXTuJUa5mvlSp5CsuVs8a
 2LHW9bU4YcG19PA0BKJcSwpgbEAN6ghTmwSOt/ZTxTkLFELkZcXTY1+ODzWwdnUyacqL
 R6L5kcE+ohEsqXtTIezD8MsngTAiKAgrVc6a04wiK+ACyTZx+kiXutcjvE18E3Jmr+CQ
 CK4hNvh+jjMieLqDa9ZFmxNsjy75zPksh0iZxK1LkXJ60qiMYf+2G8cMdgnzUp8VQzZx dA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2y4be2nar6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:45:26 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:45:25 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:45:25 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id 37C143F703F;
        Fri, 14 Feb 2020 07:45:23 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <dbogdanov@marvell.com>, <pbelous@marvell.com>,
        <ndanilov@marvell.com>, <davem@davemloft.net>
Subject: [PATCH net 8/8] net: atlantic: fix out of range usage of active_vlans array
Date:   Fri, 14 Feb 2020 18:44:58 +0300
Message-ID: <8617c88b29d233885dcb1941fc83b0cef78c87d8.1581513120.git.dbogdanov@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1581513120.git.dbogdanov@marvell.com>
References: <cover.1581513120.git.dbogdanov@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_04:2020-02-12,2020-02-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

fix static checker warning:
 drivers/net/ethernet/aquantia/atlantic/aq_filters.c:166 aq_check_approve_fvlan()
 error: passing untrusted data to 'test_bit()'

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 7975d2aff5af: ("net: aquantia: add support of rx-vlan-filter offload")
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_filters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
index 6102251bb909..03ff92bc4a7f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
@@ -163,7 +163,7 @@ aq_check_approve_fvlan(struct aq_nic_s *aq_nic,
 	}
 
 	if ((aq_nic->ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
-	    (!test_bit(be16_to_cpu(fsp->h_ext.vlan_tci),
+	    (!test_bit(be16_to_cpu(fsp->h_ext.vlan_tci) & VLAN_VID_MASK,
 		       aq_nic->active_vlans))) {
 		netdev_err(aq_nic->ndev,
 			   "ethtool: unknown vlan-id specified");
-- 
2.17.1

