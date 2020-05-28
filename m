Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F387F1E614D
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389967AbgE1MsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:48:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59638 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389852AbgE1MsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 08:48:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04SCbfKr144094;
        Thu, 28 May 2020 12:48:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=4MhLm3IwlAX0+PMwL8iXWxVwK1DxULSymdapXAO1u2U=;
 b=geURq/j8aOmtLLp/5ebYTnaPSflS7Q4ZZQP10agwdrg+sGBAFkmBidSZpVegN9bVDAnC
 e+binqmqMEDxkU0XZ0jsYgzfgIgFsb+F96JadoXONk8ma5oLw3lLUrQhihLH5Ko+sknD
 d0K73kLVHXyrUYsCInSaTgQnjBYxIwr4N2BVrCdRV3S7b+z90OEk0JVT63y9GrDVgWW0
 QnGLjhd/ffgPL3H3L+D8haetQ2JUU9bHnU84hpY3B0QuaeDVy93tCTSmimwRc9/cmjYq
 ITjH3ysWzIy0E0dhIKIa3M74BA3aZO5oDUcD6knFK3qQiIDvO2PpoLILxQZai6xyKwG9 bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 316u8r4s80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 28 May 2020 12:48:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04SCbcGG191796;
        Thu, 28 May 2020 12:48:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31a9kse0dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 May 2020 12:48:12 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04SCmBm9021233;
        Thu, 28 May 2020 12:48:11 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 May 2020 05:48:10 -0700
Date:   Thu, 28 May 2020 15:48:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>, Eli Cohen <eli@mellanox.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net/mlx5e: Uninitialized variable in
 mlx5e_attach_decap()
Message-ID: <20200528124803.GC1219412@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9634 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005280087
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9634 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 cotscore=-2147483648 suspectscore=0
 phishscore=0 clxscore=1011 mlxlogscore=999 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005280087
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "ret" variable isn't initialized on the success path.

There is an uninitentional behavior in current releases of GCC where
instead of warning about the uninitialized variable, it instead
initializes it to zero.  So that means that this bug likely doesn't
affect testing.

Fixes: 14e6b038afa0 ("net/mlx5e: Add support for hw decapsulation of MPLS over UDP")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 571da14809fec..ae53bf5994215 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3637,7 +3637,7 @@ static int mlx5e_attach_decap(struct mlx5e_priv *priv,
 	struct mlx5e_decap_entry *d;
 	struct mlx5e_decap_key key;
 	uintptr_t hash_key;
-	int err;
+	int err = 0;
 
 	parse_attr = attr->parse_attr;
 	if (sizeof(parse_attr->eth) > MLX5_CAP_ESW(priv->mdev, max_encap_header_size)) {
-- 
2.26.2

