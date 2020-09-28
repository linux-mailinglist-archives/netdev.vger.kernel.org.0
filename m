Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C3F27B37D
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgI1Rmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:42:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41616 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgI1Rmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 13:42:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SHTeRL078540;
        Mon, 28 Sep 2020 17:42:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=p3DUDq7uf6JXIsqyfaYjxNfcx4XR8QeKONrgNyamwRo=;
 b=cetMbtdKYZ80SMCJq4QzvP5Lw1VssgLSbUc6GfjaE86DinIo/qeMyIklylYL6WuJepZz
 vnse58lElaejYVMiJseDF3wjT6qYv4KKNOXpJEpHxqcMWh2273X5mchnjU8yktkNOIaX
 AHq4FhUhEVf7Xz58Kbvos5Bdyzsni/AoQyz0fVT7FmWQZmjgnrs54p1BF68hxk53oalS
 PSLSBid81eEpNuY+5IMbqOYXALa1bGxaGT9bEujKYHcjtvF49JBKQEUO6prqiLimIfXz
 3rtarKFZ8nlYQeQvag7dIne5geboZuvXpRCadSN3KuQZV3+ucHtcFUDW4YL5tspLGBQh rg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33swkkpe4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 17:42:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SHUhSQ188098;
        Mon, 28 Sep 2020 17:42:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33tfdqh103-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 17:42:46 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08SHgjCP027408;
        Mon, 28 Sep 2020 17:42:45 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 10:42:44 -0700
Date:   Mon, 28 Sep 2020 20:42:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2 net-next] net/mlx5e: TC: Fix potential Oops in
 mlx5e_tc_unoffload_from_slow_path()
Message-ID: <20200928174237.GA446603@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928174153.GA446008@mwanda>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1011 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280137
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If "slow_attr" is NULL then this function will Oops.

Fixes: c620b772152b ("net/mlx5: Refactor tc flow attributes structure")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 438fbcf478d1..854153d02778 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1238,8 +1238,10 @@ mlx5e_tc_unoffload_from_slow_path(struct mlx5_eswitch *esw,
 	struct mlx5_flow_attr *slow_attr;
 
 	slow_attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
-	if (!slow_attr)
+	if (!slow_attr) {
 		mlx5_core_warn(flow->priv->mdev, "Unable to unoffload slow path rule\n");
+		return;
+	}
 
 	memcpy(slow_attr, flow->attr, ESW_FLOW_ATTR_SZ);
 	slow_attr->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-- 
2.28.0

