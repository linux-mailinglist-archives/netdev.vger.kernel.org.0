Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AB131F6F1
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 11:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhBSJ7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 04:59:07 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56082 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhBSJ7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 04:59:04 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11J9tbCb166173;
        Fri, 19 Feb 2021 09:58:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=5++COl6nJt2YEvWjOmUxUrRFnGxsjCC/bSCzREpjT6A=;
 b=byHF5qr9i4c//3CdsRIKUBrKdO/NTSKmUtNrqe6gvlFYJAqT7hZWx9nKBXka4TotVqxX
 MoBB5G1PD4w20yjmvqdAB9EP99PA14L4t38NTJvW+DcRdeZWJOQDblxwtoNTSGjdHk1s
 15ms+/zJTORz80LdooArQ05USbpChQXe+1YLgnWjaFh3+sXZd0xRL68+H/6/AcXzMf5h
 t2x2FT02+pNEoaf1on4BF5EoVDzSPgb4NTp7VTa0qMtrhUwognifrewLumURf7qZYZQp
 g0vkN389fNFscDyyNBCufyDUnWdUeIGILgVxPEOmPbRpVFHS7sKhN0sk7dDHZxSkd33P IQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36p66r8xtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 09:58:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11J9oVJa034436;
        Fri, 19 Feb 2021 09:58:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 36prbry7td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 09:58:10 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 11J9w3Zm005609;
        Fri, 19 Feb 2021 09:58:03 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Feb 2021 09:58:02 +0000
Date:   Fri, 19 Feb 2021 12:57:52 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saeed Mahameed <saeedm@nvidia.com>, Aya Levin <ayal@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        "Pavel Machek (CIP)" <pavel@denx.de>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH mellanox-tree] net/mlx5: prevent an integer underflow in
 mlx5_perout_configure()
Message-ID: <YC+LoAcvcQSWLLKX@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102190076
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1011 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102190076
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value of "sec" comes from the user.  Negative values will lead to
shift wrapping inside the perout_conf_real_time() function and triggger
a UBSan warning.

Add a check and return -EINVAL to prevent that from happening.

Fixes: 432119de33d9 ("net/mlx5: Add cyc2time HW translation mode support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Saeed, I think this goes through your git tree and you will send a pull
request to the networking?

From static analysis.  Not tested.

 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index b0e129d0f6d8..286824ca62b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -516,7 +516,7 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 		nsec = rq->perout.start.nsec;
 		sec = rq->perout.start.sec;
 
-		if (rt_mode && sec > U32_MAX)
+		if (rt_mode && (sec < 0 || sec > U32_MAX))
 			return -EINVAL;
 
 		time_stamp = rt_mode ? perout_conf_real_time(sec, nsec) :
-- 
2.30.0

