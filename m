Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2741A3BE617
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 12:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbhGGKEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 06:04:24 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:61338 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229949AbhGGKEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 06:04:23 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1679ppW6028944;
        Wed, 7 Jul 2021 10:01:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=eXaccNUPRIPewEw+2Dtx9uGB3jNU2DREgawh5NJZbh4=;
 b=BpRyBArusVqrO+8Y+6AB0QsUaHrCPX3b2yOv0WtkJUaN3PFvAJ/QFtyA8i9R1i1bNByX
 ZFsGrP74STC5XRFngO4LAupPUgZoIww3lZ2Yz3s1yuT35lova8sThWDuc0TcYwOBI986
 UuBsnWV4w5v3eG7mv9T5J+abAqqTDI42xGBPMdPrgmUJyYJPfJz/fxY78VuBbvg4+8Ls
 Hcc/9BVBJ6JPCZ+Hhh4+G9DcboYkROS0xQGrMT70maAyZfD8L+yaM5aFk6i5bdq8igvo
 wJsH7l6ZcZYkZuu2d7vc+//Rdl8RQOiejStOdRqQ53iBOAeZlxDo9J+sHpHEqBUnQJ97 DA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39n7wrra5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Jul 2021 10:01:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 167A0WWR007179;
        Wed, 7 Jul 2021 10:01:24 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by aserp3030.oracle.com with ESMTP id 39jdxjvvjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Jul 2021 10:01:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXItFyEQ1IwrbnJHgwKI35erbj8i9MJDfatlUpE4PH5wprszEV3bYykE2ZnETyQeuxkikMKanGc0ecvcshkcNsjzvYraj5zQM9bAXmmnizsRmLBYLBSh0lodXjTX7Cw9L62DrApMyu0mipbt/MPe6N/oIJ2FCDHYZIgJjwIyg/clCR2ZI/AKRQ07U+CshymuJqRYhud/ryqh32DhGVFp9RDCrtcdIv7u1LPpyuPSLSO3uyvQE1FAEbWosmi0jo/IMORJvHLUUiPZhGmRRrVnLy2chWiJuCnPL8EAikM+1BX//sj9Ah5RUcZQTo9yu/87kJSrzWHR4iKJSQIiRz3KPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eXaccNUPRIPewEw+2Dtx9uGB3jNU2DREgawh5NJZbh4=;
 b=jS5nCt4UqualJ2DUx3SjK9ukRL+Cn5d6GQ/5XYTjaUukxRWSiLuCT5DAndW3bGXNkLHRFQYePq66E9wUPh3jqu49/UQb7oF2Dbd/w5j8XsEfrwiUuR2UyxkNR/KjSpZn2f7sLNN6Io6msbaj3mhUVhElKgLa7y448ljE4BzACXcRuWtCWX7cv5vetUXwSjLl0Tdwst730rQric4atzrBNi+MlXALUXY44AQQOTKT920NY9Dky7O7CFhGq7+ghdkjfnNzlBMBVKjis88rK8WGVZrB5+i2b/tX8dQ4/cTDH4nFSNWKntwmKsUDYcJ3Ydc+UFou8cIpp3VTShbCGGf36A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eXaccNUPRIPewEw+2Dtx9uGB3jNU2DREgawh5NJZbh4=;
 b=InI/Yb4WDPeLdM3bCl+rb8IFEuU61Jepb0J6SLSA1usIbb4AHccbOX1yUBQclBSgei7evaj24Yq4r+O7iFlXozSaEM+VnfV17j80g3j+0TT41+mCBCXupSdlG926cp4vNcnidC67QPsFHb9GFQhtnoIeENIE9fqSVDqoGx6+jII=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2317.namprd10.prod.outlook.com
 (2603:10b6:301:35::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Wed, 7 Jul
 2021 10:01:23 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73%5]) with mapi id 15.20.4287.033; Wed, 7 Jul 2021
 10:01:23 +0000
Date:   Wed, 7 Jul 2021 13:01:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Yangbo Lu <yangbo.lu@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Alexander Aring <aahringo@redhat.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Florian Westphal <fw@strlen.de>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] sock: unlock on error in sock_setsockopt()
Message-ID: <YOV7XH5Sqx+ZHghC@mwanda>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: JNAP275CA0046.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::23)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mwanda (102.222.70.252) by JNAP275CA0046.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Wed, 7 Jul 2021 10:01:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d31deabf-e635-4e8e-0f99-08d9412e2ce7
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2317230B65FDB846085DA9BE8E1A9@MWHPR1001MB2317.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GxpxIAuWmb5Frr4xCRNCZkLCCdJne7ftGS35/vHOdXn9ruQqDAnvu5Yr2/CMitAoqbyjnnJQweCIGr2Gtd32GBsoYSvREkK4+wLLZQrDnWCW9wrkhCvgRiFHNSB8LAtJDLms3cqzangTRW39C+lNhUZ6R2qqx8QlJEPMOCE64aVKfcm9AI/e+wuXiGVfKt2SLp8gyy0LwPXGL6owIRdiwPKVfFb/XSai661TRMix0mIs8zDUxrXjLaQ2yiymhxIFaFncSnZJWlmqN8YieMvEZrKmNpdgEuUXbvFf2pPviyPpic46jgUrxkCjy2HJ4krcdHacqBQSunWNBE8HOIQLmKm7IAoLPi1qnjp4Fgg5JVplICMruS/4HAROR+217YSufERpyTHYPMY/G6Tw3ZxQFK77LwAHApInC+7TG9ki9KJivmh04wlyzMkHRHf+/R0foQMW8Ye6muvyK45gGOwfxj+jgybJbfDEC3kjW3x1LKDoy2EhKopBLKjy9har3WmUWBpxnsG2ZZpUOLb8jpy5JQbSFtZ56QA6bxrWJwfxqufd5zDLJCxYlPX5aTOYcjs134GF83SSx+BvJHCqgzjMvQ8GjnYZenwHEhYBRkZ6vNh4VcBDxgl35NmqB2iB8IW0waCtJF+//qvTnwaLKtfzUT3mmj3BJY28fqjoQyZIjDMIo0306s/01z1LZbl1i0YcvQNTt62WiKdIBS3Jma1AxR54MmqxBCOTOpo5Pt8wxgQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(396003)(366004)(376002)(136003)(52116002)(110136005)(6496006)(44832011)(8676002)(5660300002)(478600001)(54906003)(8936002)(55016002)(7416002)(9686003)(956004)(186003)(316002)(4326008)(26005)(9576002)(2906002)(38100700002)(66556008)(33716001)(38350700002)(66476007)(83380400001)(4744005)(66946007)(6666004)(86362001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Td1y0mlslfFne8S00Y1w0C/WPY4s4HcNWfmhLmEbsksi8f5YsombxhudyQ/W?=
 =?us-ascii?Q?A2os93JWT7SzDLkx/CDtddfRhO1vTqAsCsmFo/9W9jb3bjB4XD7Ui6Qqlmrh?=
 =?us-ascii?Q?4nU3oY2TwyjFl62wRPSblPw70Y6Ge+jL7S4eLmmlsQu0pNHzzI4qtqMe4za2?=
 =?us-ascii?Q?qzbaD2Tt3xHV2iIGjcsFifjZFX9aHZF7fMnbNKahh7WLbtjuBECOXqI2b3uQ?=
 =?us-ascii?Q?rlKNO+Vb73PBNEcxVWTj9ZLHkPU6AG1MWMGYkFPOkXFpwJqLsBcOt13+MkT8?=
 =?us-ascii?Q?JG2KEkiHwNbmW+HgDFcKH5CU6B/Ot+YqNYZhGH1nmRxzQ/K6GeuvHCOr3NvD?=
 =?us-ascii?Q?an6hFEdI/d/1cjtKrHB4Nk8kQxy+BKSuP6SqhnbUqGkV1O3vqQBpk70/OXba?=
 =?us-ascii?Q?/JJu9sxZzuNkqsTjpuE2g1SJbMYzr9MGVncNrLHDQAbWrmyMPJIO7t0gfSnV?=
 =?us-ascii?Q?pTtFJYCyRJOlz3cCc51Z6GFEQkkxahFE8v/JEs5LSGH0BJS8TdvDRyPTk7ca?=
 =?us-ascii?Q?It+wfK3pIcOUWZiG1uDzMRJ4PP/j/m9qsVjo6yWF48bgD/ftcnWIu9MQVWAM?=
 =?us-ascii?Q?XYoi0Ub9s0OxySKG9fduTuXAAisD2kT4wa3QOipP3IqNw+/VyiHR3aFazUH+?=
 =?us-ascii?Q?ALrCk/EV++JUrp0iIzLvlG22ByRTWCsijX6R207acKAI0vAkFdj/1BvmA8Rn?=
 =?us-ascii?Q?rAAZpX4VmnwAJWA1i/XKtVLfvVs0ulexamx4kmijbAeW7m8RamVPO3o9GehC?=
 =?us-ascii?Q?Gj9ybYPJ+35ijNLyZLSiUQkLvs8WC/Ke7cfeguYKRueVCpuhhvle3liBOZE6?=
 =?us-ascii?Q?/qNpyreZ+cojueW27M/XBdbyiWA8z9yQC2Jr/9wToLIwI/T/44rEVIQ30Wko?=
 =?us-ascii?Q?y6K+huTaV66tTHrSjiuzmxFW2Sgf5NmH6kkL8d4HZd1vFiSth/NwlCuZq0+l?=
 =?us-ascii?Q?wpgDpYFU7642vfWLCcf9NbRxfQ5rP7FQhodcj3rfWK6/QGbQUAs/d2T6hCxz?=
 =?us-ascii?Q?AP54p9kKUFpfxc7QZRPOObliBtVGsrKAod/+qgNGC4QvymaPcvA8pm94XBqf?=
 =?us-ascii?Q?1zItjviO4cAp5GIvM0cK2GHwJZnPpGMiQBSVzitWGxUGvSBw+B8vGPkE6qdd?=
 =?us-ascii?Q?X+g10Y/En2CvRC2WjhNJ3LNwb3jGHFohLegQc9RqXX1Ht+fQd/9x7OQ0DgMj?=
 =?us-ascii?Q?YU/WPCVyrg0QCCOg7orR2Lx8rnWoRrCeH5ly8r9+Yw5sWp4k+ToBtueCIfWJ?=
 =?us-ascii?Q?Sh90HkyIXZqcbXsk9J6MfG1tO7chplDxWq2VllBq5RIcHybTy5EPw8fyzS/n?=
 =?us-ascii?Q?Od62SfvReru/9wMOIi+wEjor?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d31deabf-e635-4e8e-0f99-08d9412e2ce7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 10:01:22.9246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WFJk2Xc3z49QkMVQmBOQS/76cXJRUKPIq1NUzbIfvztr0dWsee95zBTS5Q6Ka8pzz2Ptuy4MziixhnOD/W0hj0+E5gCe8i33p7szQpIipP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2317
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070059
X-Proofpoint-ORIG-GUID: jIGsa4QGmk2ngsrZDFbizHfKSL4ZLGMk
X-Proofpoint-GUID: jIGsa4QGmk2ngsrZDFbizHfKSL4ZLGMk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If copy_from_sockptr() then we need to unlock before returning.

Fixes: d463126e23f1 ("net: sock: extend SO_TIMESTAMPING for PHC binding")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/core/sock.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 1c4b0468bc2c..a3eea6e0b30a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1123,8 +1123,10 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 	case SO_TIMESTAMPING_OLD:
 		if (optlen == sizeof(timestamping)) {
 			if (copy_from_sockptr(&timestamping, optval,
-					      sizeof(timestamping)))
-				return -EFAULT;
+					      sizeof(timestamping))) {
+				ret = -EFAULT;
+				break;
+			}
 		} else {
 			memset(&timestamping, 0, sizeof(timestamping));
 			timestamping.flags = val;
-- 
2.30.2

