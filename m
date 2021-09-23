Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9486E415878
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 08:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239436AbhIWGxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 02:53:10 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:7672 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239370AbhIWGxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 02:53:09 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18N6WFh9002737;
        Thu, 23 Sep 2021 06:51:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=GIAyCkpjoyOM2BiyMDmCth6ntpcxpkcJr5xjcGp8dC8=;
 b=gzXc29N0mzEsHWeQ/F9AHXa5J0Zt0BAbU0deHTmDeWamC47STWKx+xels6MhSPrmNtvg
 2sm5VXQ/bBcoURg1OpVE6HIT6pRzCZdiNmkAK0C/4m2LZ5C3xGY6lBmBp7IwyVAlHwLW
 qGLIWFdPNM3fI5tF9YVwvqj1oAbWyXPXy8O5PaU79IxXg4yshHats1V6DW9z3+LAz7+6
 cBefF5WeprlQ5GD1LaSkQi9Fl1qAbTQRf1A7MZCcimhHxWBIbYr33eLcbwsjISg03VRg
 hm1IhjsJs5EwBkgSM6bj417+BoOn4G83ZJbSRBoz2bvsiAS4OOthOnEghLh0mSnVnagK 2A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b8mdbg2ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Sep 2021 06:51:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18N6irxQ140879;
        Thu, 23 Sep 2021 06:51:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by aserp3020.oracle.com with ESMTP id 3b7q5bryy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Sep 2021 06:51:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWZqJgR4AoKJGMmGLvkZNXOrxKTOMzw2TvJ3GrUoE0sjo2ufjr6TVFs1MEF1XX2VHZxoO7hHas4Xgn/Pu/ek2FjPQxyF0oPsC65/kPxjaq70Oi39yST99u3HeK/bdH3R2X1kLJb8fohcDqzbaMYwhUykBMLQSGCpDWPYPNa6fKjsGrSKPYEYE/K4xCobdbST6nfvmLDZPq4WYmR40g3tOZxWnJR9Vx7+FChg4nAQdVRp3CnI7cpuO4KYsXEGHaw6qXTz6P18NID9yjflEYtnslmuKoc6tBouX5TGpIYQN9kLyXddsP/UqnYY2Q1W0CNhukl+znEsIB5Ixc3/sPuPew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=GIAyCkpjoyOM2BiyMDmCth6ntpcxpkcJr5xjcGp8dC8=;
 b=mAwp4OOuR+qSHibF6XP/Wlrxv1bwMx4HphU30k21DFOanh+s4RMcgavu62KoAzzHhur6IAZknzx9x3YZovGG3f/tW06AdZkxmrR2IefnRGskmVnfB13PV9P/gZNJYfsg4tvs7vYlAnn+oeRMUXWPkmKY+e/yWynZQkb04J8h2jozDQ+46/jFKE6EULKq1zv1J+UPf0btKHe1ZgVXCJwbxdhDtrzTB0Onx/jgPtPdYn+te9BpJs16xX/IknYj7yz0JyO+mpKMhBF0dvEKtXDnIZktoI4aMP7bW8iJixv5y+ysL81MZCgkPskqX1p+c3/oRRkIFRHvT1UtH8rTOUwEDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GIAyCkpjoyOM2BiyMDmCth6ntpcxpkcJr5xjcGp8dC8=;
 b=S6ugD/pi0mTTkBI9de+TyynliF+5mdy98Aoql1q7+wiy4q4lyxCWsONtenaejj5iKCdK6qpvuZpC1H9BAA6Qf5qmMiHfGK/qF3C3X/It0qpml3mgJAxC2BnwaucPoUzoAX2Qa7TtqY1L/HIhhQZZgg3fyM1u2vC8tl4PQQuIaRY=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4658.namprd10.prod.outlook.com
 (2603:10b6:303:91::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Thu, 23 Sep
 2021 06:51:07 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4523.018; Thu, 23 Sep 2021
 06:51:07 +0000
Date:   Thu, 23 Sep 2021 09:50:51 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] nfc: avoid potential race condition
Message-ID: <20210923065051.GA25122@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0089.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::22) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by ZR0P278CA0089.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Thu, 23 Sep 2021 06:51:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db716553-f6df-436d-9e2d-08d97e5e8463
X-MS-TrafficTypeDiagnostic: CO1PR10MB4658:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4658A3F0157C55CC85FADCB38EA39@CO1PR10MB4658.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V4I2B63OA/k+7U0quCx8HDkYT3Rzdfkj3ZTb3Mxx6dj0yCTRzbkpq4IGUZ3++vHb6/LUlcdEwIZxFbYUjCaw4KUwQwGsBnUXktlc0OxqfTbfg9x0SDU+1BNwttzuo+mCsomaCA6q0SIM5fMJtl1IWBk6Xu94NNHQSFayXVubZTYXOpguAITyB8EzhIckJacNS6MWc8WZd5C28RaRk/F7NFCQzSX5yV0QIG4VOybyDxZRukyO6Nh2fI2CmB6MD1Cufz0kp2S2qmdfd9PR93oK5fKiAsw2ydum5WmRZzjC0hLwiT0mqHTvzPS1t7AX/pdEDUvNaywsqhxus8Fh5a69NAmWOMMirx4knGGUTvGBY0/yxvkLwlQGxt7xhD0JIJgHP6ezFiALDEf9pqHKSjJ5juKIqBVB2bvduPnaUIuf7b9s8C7cG3meq713Gql3k+A4O20xI5bRzE+Rzy3bML5CalO3uyIWbCOJvSvBUfRhnknMF3gQjmqD5eUGNPR0OfIcYM5tQrzMNXRV2fnL29eLKkhiSVgVacyiQ6g/0hDxOw4XoxXQIkS3F4T9YYurLWilpirOqp+S54/53RM7PNkwRAQ9zVaZSXSUKl+x9w/lC+iweLFQV9oc0v6jc7tq5WV+ZrE7mhtkXFusF9UND6dkgv2IX8lB204eIK1oY9t6cS4hz3GluoFyO70wj0biySZ2yHXNSVYeTKHzEGVV3J9bxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(316002)(86362001)(33716001)(66946007)(66476007)(83380400001)(66556008)(508600001)(2906002)(38350700002)(8936002)(38100700002)(44832011)(54906003)(52116002)(8676002)(4326008)(55016002)(33656002)(6666004)(26005)(186003)(6496006)(956004)(9686003)(5660300002)(9576002)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M4dGv3hLMs/4DWGZvkKi0MgoWvwOL6vLC7aoBv69HpfvCqGdbxOKgQ5RdhLB?=
 =?us-ascii?Q?V1Uw+SCnGRdZ6kloqhjjLke1CuatSecH+ZlCVQI7qWC7fD/Ckc/REiHDtso/?=
 =?us-ascii?Q?GnB1PEuDwPWq28CkrzTa6EwIyBb63rzhBmoEqplJY0q2gzMoLJmDc7/I3iev?=
 =?us-ascii?Q?zNkdZTAjo5ZdIMDuUf4p21CI28GacUUC66LZBNp58XLrMJCLSsalAdwFoXHS?=
 =?us-ascii?Q?Zh0xLmXQ7RrcXZO0pf7Z6AReksPcZRV79seyP/jD8y4btUD5G/WYX4pCsmLx?=
 =?us-ascii?Q?jnaQ8bGZBzqW6zRDsAJ+YBFGIJmrbk8Y7cVNR50/vpYnKHBK6NZBXptQTeOV?=
 =?us-ascii?Q?IsrQeUy/vqks2fjKCBsmRTVWy4NpZvxjW48HHQHnvujcdAclJ/igxUJ9XqvA?=
 =?us-ascii?Q?BfiLcjH5+XBVlkoILFXlOBYHcupJ6M2xhJDORYFfHfkESwqmulS93Xz/Ye6L?=
 =?us-ascii?Q?M7VdLdwk9xFyy4oAM1Q8sfBgg9ehXQYHcAcive5lecwu2SU4pwH5kHP3jsHB?=
 =?us-ascii?Q?ARXihbyutzFY3W8Y0vkFryMrhi4lds6S4By02YzAZrIsW9wzzi23zH9X3n0V?=
 =?us-ascii?Q?zi+zm8ofkA1qILbcD6nwmn3vqlzcix1D3lrF/dSR+KmkC8cRFvDZx7fMLPVE?=
 =?us-ascii?Q?45NCuY0DEYa0WKowg3bKUK+TfDExQ15KYH7sTlUivDfNpZQkp15j/109Q8H+?=
 =?us-ascii?Q?GiNlruXFM1xzDJauns2tqK/F1pcS7zJGsznefuFqJnD7+VjVF8weS/qMruH+?=
 =?us-ascii?Q?0ptFiHsdKj28krJiyEccKhDCcWLTpDK1R7kIkJjS7CFmjQvZqo7J3gmjhpJv?=
 =?us-ascii?Q?862NKAtCqonoYyAaMeJaGd4FeAhIO834E+iDtvu6+1wkfBqng2LI0o541fJ4?=
 =?us-ascii?Q?Aw9VBq/evQsEUXp5TDuXhUI15URUSKpTtRZUCTz5WQ3kWyxu8U52/kwZKQOP?=
 =?us-ascii?Q?rZjfD7u8E+s59VkbhjJ/r2pFUFkpic3NwxEOEXCrozsUiiw/LKrEI+9/XR6Z?=
 =?us-ascii?Q?tqf/zrvMrgicsu2BJi2VoASUAzmV8fP9pKW6wEyF+Y0/vjUUG7HnetEAFzdf?=
 =?us-ascii?Q?V26oStPh4MbEhdtdQl0Yeg0Z3Vrqrjy0hClKQIkuQRYzPUfOCPEVO3v9E9xK?=
 =?us-ascii?Q?mvYRy5IdYJBh3er0M4SGO6/f7wyNBh2cUObhZXzyII6Vp8Ww9OlWzUBUCuPN?=
 =?us-ascii?Q?RU3dLI+QDIR9LBBKJICR2Ehxbx6vc04Vsr+3g3To4IUKBZAEwdm9Yrp/90hs?=
 =?us-ascii?Q?XfFNmI76Nx6W/CChuwXow/bLqjgyYWFCUxit9bXv/rHO1dS9M+LPKOsQSqaO?=
 =?us-ascii?Q?XYSMvWRSF0cAHuPirUBeByiz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db716553-f6df-436d-9e2d-08d97e5e8463
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 06:51:06.9858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mkJuvpmiDfDJ3MG7P47zSRnOL3IW7UNMe6Ls9MHzJDja7P2OYwayl9xb+vj+Z4lnMWLjOijxhCTTrsGKzPX0GdTUE4Gv08r69qiywiKuMJI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4658
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10115 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109230040
X-Proofpoint-ORIG-GUID: woEXPYl6R8mM30cc5BSQU2xOcMeFqD-k
X-Proofpoint-GUID: woEXPYl6R8mM30cc5BSQU2xOcMeFqD-k
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This from static analysis inspired by CVE-2021-26708 where there was a
race condition because it didn't lock_sock(sk) before saving
"vsk->transport".  Here it is saving "llcp_sock->local" but the concept
is the same that it needs to take the lock first.

Fixes: 00e856db49bb ("NFC: llcp: Fall back to local values when getting socket options")
Fixes: d646960f7986 ("NFC: Initial LLCP support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/nfc/llcp_sock.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 6cfd30fc0798..74f4209c7144 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -314,14 +314,16 @@ static int nfc_llcp_getsockopt(struct socket *sock, int level, int optname,
 	if (get_user(len, optlen))
 		return -EFAULT;
 
-	local = llcp_sock->local;
-	if (!local)
-		return -ENODEV;
-
 	len = min_t(u32, len, sizeof(u32));
 
 	lock_sock(sk);
 
+	local = llcp_sock->local;
+	if (!local) {
+		release_sock(sk);
+		return -ENODEV;
+	}
+
 	switch (optname) {
 	case NFC_LLCP_RW:
 		rw = llcp_sock->rw > LLCP_MAX_RW ? local->rw : llcp_sock->rw;
@@ -598,14 +600,15 @@ static int llcp_sock_release(struct socket *sock)
 
 	pr_debug("%p\n", sk);
 
+	lock_sock(sk);
+
 	local = llcp_sock->local;
 	if (local == NULL) {
+		release_sock(sk);
 		err = -ENODEV;
 		goto out;
 	}
 
-	lock_sock(sk);
-
 	/* Send a DISC */
 	if (sk->sk_state == LLCP_CONNECTED)
 		nfc_llcp_send_disconnect(llcp_sock);
-- 
2.20.1

