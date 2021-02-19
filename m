Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756F131F6E7
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 10:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhBSJ57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 04:57:59 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54160 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbhBSJ5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 04:57:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11J9t2fv165973;
        Fri, 19 Feb 2021 09:56:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=W+HbKmZFEWtTD6FhTxXlEQ6JRN3CzO2jVHYydtVppho=;
 b=D98l6qSpLT9wIE3jg/LIm7DVuTJI9gG9zBXNT9LuCe5UUJeE+cKyYA5VWhfTbGl16ej+
 qYvtj6w9HDVpGzJzZ5SkkdXSNs2nPpCR3IOloN6rOBjNRZtATyQdhbpTltK71nom5uqa
 TTvyEcTcjd27/289LLfA4jnlzpxm1OT1UhNvldf/UbqN6Yv9urEeQ44ZTFDpEFO14bV3
 hQN831xyh7DMqsZJWvPGCRo50D2VHRpC56degwx4nZIhG0W4SuZNBMrkFAIS0lKNH54r
 oG/JbjVj8jSSNSjFPv+zb3XGY7TyiPXawNUMeDDBH5vYvUy9YXQ97bjfS1+vm9qPVuwt oQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36p66r8xd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 09:56:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11J9oUCH034326;
        Fri, 19 Feb 2021 09:56:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 36prbry6br-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 09:56:51 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 11J9unEQ004742;
        Fri, 19 Feb 2021 09:56:49 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Feb 2021 09:56:49 +0000
Date:   Fri, 19 Feb 2021 12:56:32 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Christina Jacob <cjacob@marvell.com>
Cc:     Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Prakash Brahmajyosyula <bprakash@marvell.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] octeontx2-af: Fix an off by one in rvu_dbg_qsize_write()
Message-ID: <YC+LUJ0YhF1Yutaw@mwanda>
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

This code does not allocate enough memory for the NUL terminator so it
ends up putting it one character beyond the end of the buffer.

Fixes: 8756828a8148 ("octeontx2-af: Add NPA aura and pool contexts to debugfs")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 48a84c65804c..d5f3ad660588 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -385,7 +385,7 @@ static ssize_t rvu_dbg_qsize_write(struct file *filp,
 	u16 pcifunc;
 	int ret, lf;
 
-	cmd_buf = memdup_user(buffer, count);
+	cmd_buf = memdup_user(buffer, count + 1);
 	if (IS_ERR(cmd_buf))
 		return -ENOMEM;
 
-- 
2.30.0

