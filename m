Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A77313A10A7
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238448AbhFIJ4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 05:56:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59520 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235293AbhFIJ4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 05:56:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1599oSwj119119;
        Wed, 9 Jun 2021 09:54:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=CfKaeaE6zvgPBzKelUntpU4py6smH8Ma/t9ckXEW+l4=;
 b=khUqxhhh7bGilUElyn7Ti7KtJ5Tx1EPON7tP9ftm6r7SBKcn+KHmRjbts+OxbHxZghmy
 Ozf1RfpiImnPfWezBPxzdzl0DQIIa2j6K3QieVG1w1WhQe19l+T1c+nXLzSUjt7R70YF
 6fkD3X1tcACJ6gQ3KmyNvs0o1v8ASE5rqSd3q4Gt3OEJ8ULcd5eRtloE6bDY1kBloFWo
 uIh2s8CWOLfip0JqI7DnBRQJbzZrLc9IXI/Jl/PB+PYrPxjdptxd7F82V13EZSNq/xdF
 nzkFolztln9l9xCOURb+mEWc/Ypp5r1Y3HKCg8Cb8YO85wgxpf46C0rDEnt4D1CP9CHy 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 39017ngmuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:54:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1599oOfk029386;
        Wed, 9 Jun 2021 09:54:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 38yxcvhc1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:54:40 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1599phfX031234;
        Wed, 9 Jun 2021 09:54:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 38yxcvhc1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:54:40 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1599sdx7011736;
        Wed, 9 Jun 2021 09:54:39 GMT
Received: from mwanda (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Jun 2021 02:54:38 -0700
Date:   Wed, 9 Jun 2021 12:54:31 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jiri Pirko <jiri@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] devlink: Fix error message in
 devlink_rate_set_ops_supported()
Message-ID: <YMCP1wJ6+e2E1n4m@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: fC7VRwo9cTzHz1LYDcfhdKIXmBwIjPd3
X-Proofpoint-ORIG-GUID: fC7VRwo9cTzHz1LYDcfhdKIXmBwIjPd3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1011
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090046
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The WARN_ON() macro takes a condition, it doesn't take a message.  Use
WARN() instead.

Fixes: 1897db2ec310 ("devlink: Allow setting tx rate for devlink rate leaf objects")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 1e953b77a77a..4a5b333c05a0 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1732,7 +1732,7 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
 			return false;
 		}
 	} else {
-		WARN_ON("Unknown type of rate object");
+		WARN(1, "Unknown type of rate object");
 		return false;
 	}
 
-- 
2.30.2

