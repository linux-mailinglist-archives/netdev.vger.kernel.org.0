Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEE4467457
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 10:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379677AbhLCJ7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 04:59:16 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:29334 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232991AbhLCJ7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 04:59:16 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B39kZGt004617;
        Fri, 3 Dec 2021 09:55:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=81Y6OrKDToUEL6vCoCb+MYWm/h9U70OTjVMAvQPM4p8=;
 b=FR8fOgbKFdjWQ+RQzB53Rm3DTn9U9HEZIDXfnAupF1lLhteFOEP2HVGViFIX8BqPlWnt
 CIOoOXuRRtpIqUIlTasiyge1hY6LXcZYde8cFs4pa7Q3pVQdwx9eFtgOd3t2dAYSWhpH
 Hrf/wXpw0KlzlEgVE+ZJ/T1k/ilB/mGsm8RnUqPl3CPgvMyPdFdmApa59nbLVG7A22do
 3hFIKNIl98vymP4yt1DlA42vI+6XrCJSxHcu3d0EGwy7vOp4Fz3zvdK6WTVJmYdz+qL5
 KL9zZo3d689/Czu7NYcSn5ZaaGnmGMAY1kJUj/AcHbv+LomDlDFLTvMSctmAYqn0+XeS rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cqgwdr1qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 09:55:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B39kwK7065416;
        Fri, 3 Dec 2021 09:55:46 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by userp3030.oracle.com with ESMTP id 3ck9t5wbr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 09:55:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+XVYIoWDqdN8FyfAIR2JXPlS9gGdxUfXg0Hpkd5I7PiS4OYvX/RLLPiJqJrBtiFur9jeXSF1699f0UJWETPivN1FzXfCy0ZouBSWprNQYU1sy88/ViC4pEVZWbwn2MEn/knAjbiDOK3dtGXTsYH0YUPbgpaViQN/ezThobrE5/DYtBXL9SYHHCGNPEzwwWu8HC19TcefLJbyt5p/LUgBMoBuQUDIuS6BZGeFVooUQf/CK9yjgVtj8brz0bb7IfMYvPi24M7pIhk9rTfGI2KGeZGA1AHThUlU7MsFT4wxYnC6c9j+NNy5gLfCtsHQuA1gMxbyuSmYT8GcUeyt4rsVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=81Y6OrKDToUEL6vCoCb+MYWm/h9U70OTjVMAvQPM4p8=;
 b=ESnBH50uXgRbYv7qtknxaKayK18TRWzAaSjPHeiIlLPqtAXTpQtHgRqRcujVAa7zv7Gp7qccTy/olmarl0h78JChejONPEbfvUBrYRb5cHw531H1t0Nx7wbkwr14jK2W38NGOP6PGz8kQtAAr98h86qk5uBkaIrmTJTOXE6kz8y1fLlpVGLLxPjQ4kZN0hDj3FddJT4rNqZM3DdUkYihOUtb82JUjWeuVvHqbNXqM6q+w+Bz/7dHk+4eVT/R4bb1yh8Oy1OX671JgAKFj43AurvJr2d4UBDCMI1zqqBT6Lpf/4fJ4mce32oLEpW8dpAAiKReKXQB5XKjbrypJotjBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=81Y6OrKDToUEL6vCoCb+MYWm/h9U70OTjVMAvQPM4p8=;
 b=QOAOfpWrHONbvDyqUi9R9r0agg+zdkrrw5o1gLD45x/8ITcrlysxjroiu4FlFS2BquhVoWWMxX5gX4CXOGpORqT3VchwnWv+CkjiZC5sYa5uiR2nOf9e+XbWQ3vTR7yyW8+KggnaUpp5EqUGBdWRxtT7Z+/Up894U6q+nGjkAzI=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW4PR10MB5677.namprd10.prod.outlook.com
 (2603:10b6:303:18b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Fri, 3 Dec
 2021 09:55:43 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4734.027; Fri, 3 Dec 2021
 09:55:43 +0000
Date:   Fri, 3 Dec 2021 12:55:31 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: lan966x: fix a IS_ERR() vs NULL check in
 lan966x_create_targets()
Message-ID: <20211203095531.GB2480@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0196.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::22) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0196.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:44::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Fri, 3 Dec 2021 09:55:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c0f4bef-269b-4353-fc1f-08d9b643120b
X-MS-TrafficTypeDiagnostic: MW4PR10MB5677:
X-Microsoft-Antispam-PRVS: <MW4PR10MB5677064CA6A6FD57ECEAEEAE8E6A9@MW4PR10MB5677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:913;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oH03KQprbQR7NGfYrFcnugVXUhQY5i1mivIDSFnUueLPuDtEUkO99WdPzEOJ2kdNDo6S+gm2W62Hq+QJLV7hUkVaurG+j8l4DZkd/vsDj3FGU6Aa01klKMVliCN1FZUwkGKPNcUi4idbNVpi6s8yTMTwzgq5Xk3i8SawPBDlLyIV66grPMkcuLONuMNrH6txx3K9w7xKvYYgCN/LeeUCD4z8mwYoQ5CoA1pNgDYtXbT4RkC5JlwmE6tCem1xWqCoNFyf9+IIgMZP4bI97pxLR3o+DZ/dz7c4ggC/+nuXnDyCI4fXBsj8edOvgPGfRYTsU/wECFRmkHOEp7Ctk55d6FUBPzy5eM54dHlcvaX+FwkUP/oVFzLX6Nr+XxeztmhpK4DerR9s0tmKVlVrnkvneefqa1Cgxege3Q+F5dY3mYMVGRJCJoOlFRcbwWhW+loBGmt8kvRSp4iTEfX2LJAwW5Amj1UkSVAh4fMez3NhDkZ1rx4hSgPnXYBjCEmlErThynMzBHtLSIj2owxI9k1Kl8fO2v7VZIrEyNuB+6Lf7gdrzUKyiNPFNYSLmUTMGD+bIspS6R1m+XzxCOhs6TF5BBDx7NNN2xKRcLNPbTTkjc6idoAwa1sPQVyppW/3p56oKQGDpUKJwJIaZTVK0nYWZcqnW+7yzqBtxrPpfE7uFEtJ44DQ+9tc2zaQQrasLoEx1vNaHauWC7o1uU11gLMeqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(33716001)(33656002)(38100700002)(186003)(38350700002)(2906002)(5660300002)(66476007)(83380400001)(1076003)(316002)(54906003)(6496006)(956004)(6916009)(8676002)(26005)(86362001)(9686003)(4744005)(508600001)(6666004)(52116002)(9576002)(66946007)(8936002)(4326008)(66556008)(55016003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I5NNLqMV0Ft3Iil3LfTXsxAlcBy/DK36Oh4XYhDdDg3kEzbvN2EkOA99GCUO?=
 =?us-ascii?Q?cn9r/JA8KiT5jruMgUe9Z03+A037S6G2l92uxpOV9+8BWBlFRoQQt7oh6gwI?=
 =?us-ascii?Q?0XcEa08cjHbRsP0qvShAKEa4t5k7S8++VDzbbapJiF8gFrsJ2ATGF17c+9eg?=
 =?us-ascii?Q?CKXPI4JbxVUpQixAriJjqvJuCKeKeplQExovzwFfb56Qw+f8II2wOMNG+0/R?=
 =?us-ascii?Q?LH5HVMNPo1uX3VUE41QFuuOS29Og7gfj+nJy3OSvOsmoS37rpjJpOkfYmG6b?=
 =?us-ascii?Q?9PN5trMp6feB/qzE3Xbo1ML3+lkBLbjoCd3mMqj/x7fbOzlC1gy26V2+eqQU?=
 =?us-ascii?Q?jHeDAU+7JcTjnTAUrcJstN27YIsJAOaRcMUe4qHhoSoEISKPEeQC5VDGP1Mp?=
 =?us-ascii?Q?f5idHxpqVOZJSCAVRi8YZSuX9aEcWZCcl4Q0u9w1DJQZkH+E0A2nqipoIUow?=
 =?us-ascii?Q?aJ73M4iQu2aU9/Oef/7pe+g2E/BlafgGJ/WM9wMLrVGquIHKyvYoKyP9apli?=
 =?us-ascii?Q?ZhZyALhthKeVAwocceLEFyl2DGXMvD12qMbjQ9WazEvjQ3HpdJWlJiyC/Xph?=
 =?us-ascii?Q?RN7Wm5lcUELFPIAwBPyw6w795eTPxiZ5jEOQzGCqwaSDYuuyQ3GAwjNXQxTm?=
 =?us-ascii?Q?48Q1FyrFEDYs9uioCQOe9KUJ2MbUMjTO5zfeEb95Yt2E1y0Mf8l5uByy3cNs?=
 =?us-ascii?Q?79bHOcLDHb2BQN7bgI4zM3FK2SICxwHVY3ryD/ryrG03qdgMesuMeJOUtnOp?=
 =?us-ascii?Q?ABoD6jbr2QbkLcCYzS89oDtr6DCGF8dyuekq5NeN3HJYAFAGGk9tTRb9dH4T?=
 =?us-ascii?Q?AudQ/8Eo2Mw0/sFJWTDRCgQPpD2VOm1BwmIUWwpUkJFSf81WaNb5/gkPsNat?=
 =?us-ascii?Q?5L0/nn0cpq5aMIV3knD5l/saZKXGaTXADum+jNuleFyfhBWcABUzI/0mZkf3?=
 =?us-ascii?Q?e3umvvm4s/uB/eoYvCEyyPQ0t6FbcPhoPk4y8HjVq/Rd92reCRDBu78Pzo+c?=
 =?us-ascii?Q?T173tnSpt1sXWoDz8NM2Vzc6o8mNaoIu45tR+yEhQDepa+0JGpLsNNudzSwj?=
 =?us-ascii?Q?ejshW8BjAn0Msm6ff/ny/thAQFYs1Kpg3Fug3IAp200vp4+N9yslNnwdYD+3?=
 =?us-ascii?Q?+CG4M1LdlakT6DGHihWMKNdsytveZh1PHjf45TDmIlDWRELJOx8PWHrcdwcq?=
 =?us-ascii?Q?zqgO8W7wRVvPaoZ7tIuVO5wO9lfO380ugfIj4PRGGKpnu25IGIMryayTh+YS?=
 =?us-ascii?Q?G/SkJTsRyr4xfRZFZQ3zoB+OlpkZz00+NaCRKGzEH4EmtUoSowpsWZOlYcJH?=
 =?us-ascii?Q?WBdJu1jRPOHrMCjK6I3I2/3Beik0eau4KzYEtG2+w2bu7tievPKZnYuujX8O?=
 =?us-ascii?Q?IUdfpNZVVc9ZKdQc8qNJem/13wgUpWtWKCtuRRbHUkGvzzVg2aSUi3geH6rq?=
 =?us-ascii?Q?oiHdZ2Ksigvcwd9/wBGtEM0vLfLt23FAo8PYWXDCCkcy9vjcmkrv8EwA+PCP?=
 =?us-ascii?Q?7jWXFsR9/Z6D20aTW1qzH0TcM765/1wQksTampHmGQHBLlovO/qCnstVjHIb?=
 =?us-ascii?Q?2eV+HfYI0s6NYK64FqgVusiDC85kEazLeGZzvzfezjkFrcqU4NDHRYNzURJA?=
 =?us-ascii?Q?3YdSOSkFkdxaICGPGndMZnRRFmejKwajuMeqr+JMe0AL6lmJ4OPmzDZCTxNX?=
 =?us-ascii?Q?CpEUQlFMrjiao6veTZe8UiSOlUE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c0f4bef-269b-4353-fc1f-08d9b643120b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 09:55:43.4633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KBdaPS59ALqcGFdObuLjDISQVZyxkifJZgf3OYu4U4KxHVDy8JsIPXKpaCpMWF9gKqjz0UJtLC2r9GGIBfLo9nL+CSKgPHaKso5T40xmojc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5677
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10186 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112030061
X-Proofpoint-GUID: JAQ9A0cdmfTLOM1NsB04XVlDhUnjrlmX
X-Proofpoint-ORIG-GUID: JAQ9A0cdmfTLOM1NsB04XVlDhUnjrlmX
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devm_ioremap() function does not return error pointers.  It returns
NULL.

Fixes: db8bcaad5393 ("net: lan966x: add the basic lan966x driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index e9e4dca6542d..00930d81521a 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -83,10 +83,10 @@ static int lan966x_create_targets(struct platform_device *pdev,
 		begin[idx] = devm_ioremap(&pdev->dev,
 					  iores[idx]->start,
 					  resource_size(iores[idx]));
-		if (IS_ERR(begin[idx])) {
+		if (!begin[idx]) {
 			dev_err(&pdev->dev, "Unable to get registers: %s\n",
 				iores[idx]->name);
-			return PTR_ERR(begin[idx]);
+			return -ENOMEM;
 		}
 	}
 
-- 
2.20.1

