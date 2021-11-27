Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C2D45FF33
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 15:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355380AbhK0OZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 09:25:39 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:32896 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236645AbhK0OXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 09:23:36 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ARCx8SY021687;
        Sat, 27 Nov 2021 14:20:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=IptLXqVwJSTH6te4lEVH2OgDHPe3OKaTwrf7Sx0DHQw=;
 b=YlUjC29K0kcoIBsSDs9L7YrQrTX4IijUPo2tVqIyoHTX+b9LaTg1ygvCVEsV7JTQPrL+
 5GA7E+RYmBKJ/EkL3801skl3teZhuuSK+DmFhFnW2boQNLrQfTij/3KPuly9E5NFkX2z
 zz8CL4Ie3HS0c4TTqUZ04Z5ltSTvez0Yam0U/3g+Kz/WAapl3RHEnt4UK8GpTgnICrTm
 xIc0szxlJe5igW/NsrCaMyi7h61J9wVfGWCR6GGbHan8w93p0hjZ+emRJc10ldZDuwUQ
 wBTUiRxVMGRfc1jIkI9IeWiT5zbg+6FKoFOdOQVvKPR6xsoMjeuXo5Mm/+sZBM/o+Wf9 PA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ckb3d12ar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Nov 2021 14:20:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AREBibA115993;
        Sat, 27 Nov 2021 14:20:13 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3020.oracle.com with ESMTP id 3ckcg171wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Nov 2021 14:20:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cWx2njKIoyhkm3o41/xWk+Hw7x8XqHxiyh2KUdh3sBOSe37igEOM/Wy5zBiysAG1XEBWjZSqBQs2kb+oR7gt63NYC7z9qQVg/jQW2+REJQmGys+Oev0nSiSlWQgSMe8t0CcfXLoTvhDli8B9TwUjWaBm5Opwn8cUdg6PpTEy2LAhES3JwMdJyouIzoSbuu8mf2GU2Is1D9neC0dmJf1Ry4mJT66CJmOQZNcikXOu2jTcTndanJ99j5Q16ssSgSYOjvc/X8Ty4GOoKT11eGvzKfQJ8HWC014N3hsNovG5tampoqnTUSXdrjVHuL5xK+oqkSkfLQS4V/0MdE8QnHOWuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IptLXqVwJSTH6te4lEVH2OgDHPe3OKaTwrf7Sx0DHQw=;
 b=YEFdhr71zsolGZ8RHdZNayhdzTt2mZRGwOZwa3nXIMQrH0RplGCZ+lt7iqUf+3g34ZQlWk1P46+pQgD9zzI4xYNp99STrbw/NpuxA5j/GbWeIZZc2qKMJS0dk6uJXMnOBK3sZ+Lry4BnkANiet0qhJqBCBqgqFOQ7s3hWe0X07P7ibbTAOL9GGsZ1qAcM1RIXDLajf1IjouCIk0FC2qTSFx4Ot9ZJ3IivnT+ddoGP2ZbO3lMafHrguv7w3BA3EC9zY3tPRq7sGwO11HUd4a3+eToBojabehsa12xz/dhNXxBynq7Vog9PkCuogd2NDf4qLSfbX1epEiFzAHrBT6TLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IptLXqVwJSTH6te4lEVH2OgDHPe3OKaTwrf7Sx0DHQw=;
 b=Y8t5AoahAZPGWhNfzPye38eZRHndvawQOk48O3b17PQARcud8b0f4+rCXyMP6XRjLn8X1Og0NGndBGQIVjeXu14/5PqjEQRPatYjuIxCU0tkbwwqmzu3VMjc0whIyWJqkn2T7JHHl6g9VG/KM0o1PHNwDJAEQEJHs0k6SDlNepU=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4705.namprd10.prod.outlook.com
 (2603:10b6:303:96::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21; Sat, 27 Nov
 2021 14:20:11 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4734.023; Sat, 27 Nov 2021
 14:20:11 +0000
Date:   Sat, 27 Nov 2021 17:19:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Parav Pandit <parav@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Wan Jiabing <wanjiabing@vivo.com>, Eli Cohen <elic@nvidia.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net/mlx5: SF, silence an uninitialized variable
 warning
Message-ID: <20211127141953.GD24002@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0080.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::13) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0080.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.19 via Frontend Transport; Sat, 27 Nov 2021 14:20:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1fe311e-324e-494f-3d10-08d9b1b1057a
X-MS-TrafficTypeDiagnostic: CO1PR10MB4705:
X-Microsoft-Antispam-PRVS: <CO1PR10MB47058D547E0C1B31CCA454FD8E649@CO1PR10MB4705.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: De3peeRzwu3+JtQnvyVNyWyJM1GX4OVEu3A0N4ZRYzdM/bZWP4KNbwAR7ZV6Xq4Vie9z7cU56WhyBdVKrF5eKzAMBZX+ScyZztZnnfd8OUrRoVbuLNNaWeEhZPDqJD4tvPAg6my7E5ex2ue4fDmjyPEKqnX3WOFvYEXsgU03GjEfETPlFRpYjzPj/vJa2pdeA4y06qGAvqFWGegePp898iAR32RR2NOcZOiGq3vmi6z1QbbXiQw0BAtiQRoWncJqdYhZQsVRS9Iwv5PxaRwqQsogNgR2zpQsAJL/PQrqIfLXvYj27LHcBkCqsKVAwr3Sm0HyZQsgo00fuXH+68NUkW4WTAPvwaCP4HDCtGt4gTGQ+RlNSNHFwMwT79SrXJnfnzxOB9p1G+Ql8AQXNpRxT8EBtj2TpfSV0i3OUearKjunCDvo6OMj9QvLASXo7tH/uoUGQyxKeVgfJ7o2Xwg+C7PCrvQT+Yn32NNojtviJDjJdMczfQoFHueCqAJJd6boAW1kzTNyPXf7PKaUggmfUTF9wKYH6lypzFwSlKAFkJRkDt1AK2lPmq/KdN7LHoHRTe4JtcvbhKLtpKZElmsVFA9u6QQK0VbSTOPWXxtKpFKqw/qZf9C2A5cxD0PTvs8W+AiL39sQLhKhBICOE5XUnbF2ao2flFpEImE5aqeS6/IaKLTT7cP5zSZ46elivZFaPufuie4AXqmtaq4KqFRrig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(6916009)(4744005)(956004)(1076003)(9576002)(86362001)(26005)(8676002)(33656002)(7416002)(66946007)(55016003)(6666004)(316002)(66476007)(66556008)(186003)(54906003)(8936002)(33716001)(2906002)(52116002)(6496006)(44832011)(83380400001)(508600001)(4326008)(9686003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4IMxCguSuKoWTi3ty0cOOUMLJrQfkj+K6PECXnkfQ0iE1v2p3Q7pjA7YPYWO?=
 =?us-ascii?Q?pLD6hlY94nYWOeJII3oVeOvtBom9kdzKtnms1H9oSYMqxImwdVIpUYSaD4rs?=
 =?us-ascii?Q?6lkSMcQ3RhlZgxmBMjboYr7YO9zmeRrxQTqIxtbXwzoE4Zd+px1/iCjrtUST?=
 =?us-ascii?Q?4RQ0rxQexSvArPPrmmKhNdPZQ3RIDXpn7HeE8YovwFSZl5bwVBRLXLqnBP50?=
 =?us-ascii?Q?mkpEh07cd+i0kEMczSL0KigLcM+1vka8dfIQFPqD8/oRIB3UyjyuXSC2r1vV?=
 =?us-ascii?Q?+6dRUZUoNThjolKPg/LL8lkszRQ259IJ62QPl8MzgAKS/ufeChf7a8k9xc0Z?=
 =?us-ascii?Q?WOcjg9ITKC1zz16Nbo+tyJ81GtrvImmciU4zKrpDuD2U1UUO4veP23qHF2I0?=
 =?us-ascii?Q?V/0C0bAP3fGkW5mwkQ7hooN2qzDmAj32691GYMZc+rmfEO2XZEPwqD0cBoNA?=
 =?us-ascii?Q?yS8foBrifmFD6ZL9296hxFuEpARAE5vYH4h7xW6UA3IYSVxXSCo008M/3HjY?=
 =?us-ascii?Q?2DcfODLaQc3LcValwPs3M3/NXZxEiOlPR+JJssgh2i7W8Nb5BOxYDETQ+8qE?=
 =?us-ascii?Q?j9X2eWfRHbkdT82W5j96eGvepczU9LiNSPNllee58yHtAcLgbSQsGMLc8ots?=
 =?us-ascii?Q?WGdtXfZTE3NiyKYfHIyQihrSWuBDrrjPKO10vh6O/AZVnl0sPYasJt5jZX7S?=
 =?us-ascii?Q?oIC7g9bBGkEm3kmCAAy4uJAxrbZIpxC0p9eTmFKQIMrel/rIYJIsQhqkz3wf?=
 =?us-ascii?Q?zzaLRdbIQgcNX5Xg82P5Va9Kx9r41Mz+w1vmIzSMxKMIqCkDY6y14MEgFDS5?=
 =?us-ascii?Q?iJKx4jaNF7YoGCdkBfYM9CtTwQnBGUBbi+zvt+7H6MiRlpXS5GuCQxghsPYH?=
 =?us-ascii?Q?19txtd9fX2N/unO/7o7MyibpYY8K9iosJ+Pr0emKSQDf56li/JvlnLQk+keZ?=
 =?us-ascii?Q?Z3G8FNYg2dPEVJ9E0BmI4KTI+0dVDrq53F5HgrghPlP1QIIpEYmHIPn6Fmmq?=
 =?us-ascii?Q?eHnspPHSY5UcbaAAtyOBA5KXKi5j38ExrNDBjXOfF0wsU1RNmUUCJ1C0BUbg?=
 =?us-ascii?Q?KXVJY7jmadSvDZddNQf0Gl3Bln5rlEPXP8/tCm2UHtSBTRg5Kht4qeU50cTr?=
 =?us-ascii?Q?ZWaMTwRzRlxzHqqBxFwBYr9JyFgrRsefQDLKPsWPJf5WMQczN4DT7GNmCg5B?=
 =?us-ascii?Q?e1hZQyQWoqd2IC4G17MQLfmcMarQifYkgoRtd1JzR7gxn/qLlXgl3Rh8MMnj?=
 =?us-ascii?Q?n1tzJro2JUvTwAkhSZnKs4LDs/ufnFa2pSTTWJtbxWLvxD7WVzP6v8qQoy14?=
 =?us-ascii?Q?fHsqGrLco/o0TwlATkZLTGASKY3rz0q4BO5tPU1o/0SliS+n5/UR3new/9VI?=
 =?us-ascii?Q?raDb+bUq5wTatZ0amCMQJDKa05yjTC6k/iWvWYRk7DBwRKUxe6eCgoPGaT+m?=
 =?us-ascii?Q?ghU9a28a2HP4dkeCDBfPm1wfi3F2jpr3HLU2zNHr5oGvAlQG9H0NxbBt+MsI?=
 =?us-ascii?Q?lmCvXN7Uijx6HY9tsNufdlZiCgeMEwql9CvkBOf3UjKmZH5YnD82qF4lzL9w?=
 =?us-ascii?Q?Ava3qHbiOPG+SOi9IE75GsupC6VXl9x9GLRohegzfoiTcNsn7UZSDSgUXs8z?=
 =?us-ascii?Q?cVa36ykT5tIgKmUgstZ0obZXYV0qXglHpIg5atdJYZiADmCM4/HmI5zO7GaL?=
 =?us-ascii?Q?IL0Cz7BhchFFAO77Yngfx70rDqE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1fe311e-324e-494f-3d10-08d9b1b1057a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2021 14:20:11.2858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6n+5Sb+mQU7BBNDnNhEIJ99i0S/ziK8dFzqU6K5nGt1PQB5TIipwnTJOS2zblEsoVtznnpMOj4A+EP2GhWv5L8enJcPrmuayviyKP0devD4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4705
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10180 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111270085
X-Proofpoint-GUID: q_xXRbsVW3NcWPNVGlylttoBBzZb6pec
X-Proofpoint-ORIG-GUID: q_xXRbsVW3NcWPNVGlylttoBBzZb6pec
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code sometimes calls mlx5_sf_hw_table_hwc_init() when "ext_base_id"
is uninitialized.  It's not used on that path, but it generates a static
checker warning to pass uninitialized variables to another function.
It may also generate runtime UBSan  warnings depending on if the
mlx5_sf_hw_table_hwc_init() function is inlined or not.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index 252d6017387d..17aa348989cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -247,7 +247,7 @@ int mlx5_sf_hw_table_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_sf_hw_table *table;
 	u16 max_ext_fn = 0;
-	u16 ext_base_id;
+	u16 ext_base_id = 0;
 	u16 max_fn = 0;
 	u16 base_id;
 	int err;
-- 
2.20.1

