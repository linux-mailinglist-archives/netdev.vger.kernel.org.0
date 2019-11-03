Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA163ED2A5
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 10:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfKCJMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 04:12:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55934 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbfKCJMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 04:12:00 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA399oQN007383;
        Sun, 3 Nov 2019 09:11:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=P3PgjTx1xX0s1w7HFWuS+rPiOnekGULZdTFE8G1NGrU=;
 b=ILavzPD4gL14fiMwm+yZh+a7zeRUZmQZR/65Dw0xgY/LSHTYKgnJDAczR69ljDt0e1QT
 jDoXIbc32vv0K9vZ43i+K2xpK9TubZUmOaVVB5Ik9yybH39h4MFIe76kicUwlT/DuCq4
 3L6oHhJE5JWjZvLOA4zsAYX4oomtGoq9nXbVmutS5BLHH8vSTG9IThizeGwyNgexyB32
 ahG3Tg78lKUhSqwQemhnIIpKaoy46bZIaBmziXJhWp4McZvilecDp20EiV8RmGBNi3fW
 crmK0F1R0iSzzPVBZGWaxGXhBmEY0LT1dtfcno+6u0JjyW7H9slka4fdWb9iuamk/6Br Tg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w117tk0mh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 03 Nov 2019 09:11:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3990VW027783;
        Sun, 3 Nov 2019 09:11:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2w1kxjj8y8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 03 Nov 2019 09:11:45 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA39Bhm1020617;
        Sun, 3 Nov 2019 09:11:43 GMT
Received: from host5.lan (/77.138.183.59)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 03 Nov 2019 01:11:42 -0800
From:   Yuval Shaia <yuval.shaia@oracle.com>
To:     tariqt@mellanox.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, dotanb@dev.mellanox.co.il,
        eli@mellanox.co.il, vlad@mellanox.com
Cc:     Yuval Shaia <yuval.shaia@oracle.com>
Subject: [PATCH v1] mlx4_core: fix wrong comment about the reason of subtract one from the max_cqes
Date:   Sun,  3 Nov 2019 11:11:35 +0200
Message-Id: <20191103091135.1891-1-yuval.shaia@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9429 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911030098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9429 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911030098
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dotan Barak <dotanb@dev.mellanox.co.il>

The reason for the pre-allocation of one CQE is to enable resizing of
the CQ.
Fix comment accordingly.

Signed-off-by: Dotan Barak <dotanb@dev.mellanox.co.il>
Signed-off-by: Eli Cohen <eli@mellanox.co.il>
Signed-off-by: Vladimir Sokolovsky <vlad@mellanox.com>
Signed-off-by: Yuval Shaia <yuval.shaia@oracle.com>
---
v0 -> v1:
	* Add . at EOL
	* Add commit message
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index fce9b3a24347..69bb6bb06e76 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -514,8 +514,7 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	dev->caps.max_rq_desc_sz     = dev_cap->max_rq_desc_sz;
 	/*
 	 * Subtract 1 from the limit because we need to allocate a
-	 * spare CQE so the HCA HW can tell the difference between an
-	 * empty CQ and a full CQ.
+	 * spare CQE to enable resizing the CQ.
 	 */
 	dev->caps.max_cqes	     = dev_cap->max_cq_sz - 1;
 	dev->caps.reserved_cqs	     = dev_cap->reserved_cqs;
-- 
2.20.1

