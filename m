Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1169439A140
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 14:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhFCMl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 08:41:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46102 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhFCMlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 08:41:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153CUmDR162320;
        Thu, 3 Jun 2021 12:39:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=M542x0boGODnUlJz41kxOBy1SWVp7Fwn/02HuLjbGdI=;
 b=XQWDb3RhNZedNIqo+FUfXm9pwg218R7OEoKqKzdptSri1R6jCjC6hDZhd+1HpVUc1VNd
 UM9iBE5QvsmW+I4D6UNJHIiDan2psaDZiHBcZJma50vfpJWvYnvBqVoIDYkj7fplxPF2
 qNu/ib1t/lRoaSeatVREZieGfmQbKu9TywtZ6/JJALO/kNOcVwMEaMM38m26n6bvRXtW
 hXLDa73iHlPULhefWZ7wKtiPi/7YcvKhDzKIJjMxA3PYvBQoLLuiNW2r0SFN5xeYSWVl
 2EvPzVBrZnwJ7fTu9QwlTnA/oYTvrL4kNvbZfIOiH3uroYqM92XrYhEcmYU4W+sj2ayv MA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38ue8pk7ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 12:39:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153CUpt3146452;
        Thu, 3 Jun 2021 12:39:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 38ubneu39x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 12:39:32 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 153CcTdE164461;
        Thu, 3 Jun 2021 12:39:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 38ubneu39q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 12:39:31 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 153CdVAO008677;
        Thu, 3 Jun 2021 12:39:31 GMT
Received: from mwanda (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Jun 2021 05:39:30 -0700
Date:   Thu, 3 Jun 2021 15:39:24 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saeed Mahameed <saeedm@nvidia.com>, Paul Blakey <paulb@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net/mlx5: check for allocation failure in
 mlx5_ft_pool_init()
Message-ID: <YLjNfHuTQ817oUtX@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: ka4XI3IZmZpJRXB6GUXXTJK9R06JZvZY
X-Proofpoint-ORIG-GUID: ka4XI3IZmZpJRXB6GUXXTJK9R06JZvZY
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10003 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106030085
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a check for if the kzalloc() fails.

Fixes: 4a98544d1827 ("net/mlx5: Move chains ft pool to be used by all firmware steering")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
index 526fbb669142..c14590acc772 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
@@ -27,6 +27,8 @@ int mlx5_ft_pool_init(struct mlx5_core_dev *dev)
 	int i;
 
 	ft_pool = kzalloc(sizeof(*ft_pool), GFP_KERNEL);
+	if (!ft_pool)
+		return -ENOMEM;
 
 	for (i = ARRAY_SIZE(FT_POOLS) - 1; i >= 0; i--)
 		ft_pool->ft_left[i] = FT_SIZE / FT_POOLS[i];
-- 
2.30.2

