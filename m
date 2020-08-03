Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503F723A895
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 16:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgHCOfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 10:35:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55016 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbgHCOfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 10:35:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 073ER8pd179137;
        Mon, 3 Aug 2020 14:34:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=QxBVs2uAQljrJun7eKn6DO1kz/SnWeQHWgAPkbHPo2o=;
 b=kmreGByM8FHXx2L7JPVqan4er7rqL8bGRhiDYRbJl/U2i+ko6GidBCb3ItbjegERvrQh
 9Xg0V+Kqt1rZPQZoEPFDZPHUvIdBOt/AkCaC7oJyIt9pmF8kr9Fa3oTLgzjML8UJFHfZ
 NqMuV5CDfVKFUarv7KPFlNWV6I0lqowqRjPRzn01pNSD/5JsA2/JiZhrMBKSEbIdJY3M
 RfvP/U96uUYdElYpQKQh3vKcIDPZ3T11OQzrmWrRhBzOSUcaMgi07xXXGYbFdG0L52HS
 NRFYtxkfwPcMhVlN+WbqYg9x3AYRynY+vxxN0KHj706Ajkbqt+HXJofoNuK7dL8pxh6C aA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32pdnq234v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 03 Aug 2020 14:34:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 073EXfca084641;
        Mon, 3 Aug 2020 14:34:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32njav1dk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Aug 2020 14:34:57 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 073EYuj7003994;
        Mon, 3 Aug 2020 14:34:56 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 03 Aug 2020 07:34:56 -0700
Date:   Mon, 3 Aug 2020 17:34:48 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net/mlx5: remove erroneous fallthrough
Message-ID: <20200803143448.GA346925@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9702 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9702 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 clxscore=1011 priorityscore=1501 bulkscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008030109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This isn't a fall through because it was after a return statement.  The
fall through annotation leads to a Smatch warning:

    drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c:246
    mlx5e_ethtool_get_sset_count() warn: ignoring unreachable code.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 08270987c506..48397a577fcd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -243,7 +243,6 @@ int mlx5e_ethtool_get_sset_count(struct mlx5e_priv *priv, int sset)
 		return MLX5E_NUM_PFLAGS;
 	case ETH_SS_TEST:
 		return mlx5e_self_test_num(priv);
-		fallthrough;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.27.0

