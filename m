Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF35A40C3B1
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 12:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhIOKhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 06:37:45 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:23030 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232054AbhIOKho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 06:37:44 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18FATFaS007085;
        Wed, 15 Sep 2021 10:36:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=GmlBhdejr5tYgSurl/TIkcaCKZnt0muVolAL2eOuDng=;
 b=a2K2r+DJ/0tesfd9wVudJtnpKUlgQsR33fzI2hr/QXgG7H2f60bpipGfR4Eva0xTqCq2
 q14aaBxeAw4p+FA6cpQF3yVfBPfn+ZVc36ccvXZ+nrs1yzFaNV7L0eBQlBrvfqqTkrUv
 MpdW68LBReHjjcn20OCx4Bf8CLxXGjiFMtsn0pqAja4XPi0ly5pgTSSlrJrjF66fJfuJ
 Zz1DzlaL15VFIvrSE9fi/AXRHLLbVDjUMUscCfAxqNQiB+Se7rRIH3CAhbmZXXYiSBQw
 HsoRw9lSivZuGuFu+jKK5QHVNDxSygyh4/XAcybcSaF7y8HJgR9AmdhI7gFJj3tRUhwU xQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=GmlBhdejr5tYgSurl/TIkcaCKZnt0muVolAL2eOuDng=;
 b=tAi9uCuGVCzbpGfIcR2hYeO7+F48PA33sJgAWz1HYkYGwdR+3TNr/TKYVfYJhGmsRp7w
 P2yg1l5J2WNlKqJDTd+MoOv6v25cgko5ylBbsxxXwYGk1lqSi4hVjCD7uKpTR+u0PDjW
 jNoBvOj/MPlPFNxLBovLyCocPVFgSN00FUjPrJNQti0KDETVWcxQzqVXnl4zLN3UY86T
 qHOdjdYLB0TmQIEzlO6AX0MjEaB88ajMGj1nhlSE+XyxsHWMMiEQhEpLBwK0dxzCLu/4
 HzlqbOfos3trNJPW17ZWY14CvIC7ukNOf/TA6ruRgPcQWBQNEn3wIWRXJ6l4ODMuj22Z Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2p4f4bmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 10:36:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18FAZa1R150651;
        Wed, 15 Sep 2021 10:36:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by userp3020.oracle.com with ESMTP id 3b167ten96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 10:36:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYc9fe9WYjJ2gsJxNrkZNco96ff7PZ/vknePhF9vfZUGtsXITR0fE4FzNQrcMJw5CSUkNh6j+aWqe8syOqthtxR1mHpbpi0C/Rm0Mqr0+vDmVj4vF7sMfFjwfY311pHvxq6h2czve4kjOMiJrg5EbmvbghBOuzWXsw7TgB6kjtLCOPSP9RTZxl0kfe0LKDSHko3Q9Q/qktOanLs6hJf99Z3t4ES9JTyVP/m8oeuySGzFHfDpwpTx+7GVQv8zX7av/zT7IskCdBh1WZhWclkVm4vUCt1XpfUovx6odUroGqbsTre0sxPB6p2KcbJEM4kKlmvQpbAZZsIfb/iKP1Tacw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=GmlBhdejr5tYgSurl/TIkcaCKZnt0muVolAL2eOuDng=;
 b=EmK+yyaq9DhXZEBA5sDNLuOiAFxVPPh1MmPLeiA8o0K0aCaAKaFbU2PF8jeLnICiMp1m/An8Z3FMhAeM+4KDRM1anfIoMjznxTRUoc0KBqNMdP1SfCx96jKSpoJ9BhKnvCnH2hwsWqSLn0ncY5MaKMccZDb6wCgJWyfLQCrbWCs8ZeGjg3P1EDlGqWKqBXHNFWw09QHD40W7OdrxPhHRrkOdQSVYO0P19XYqE1Mml2ZLyvK1kBRX7yhLWhhKRQvw0gMLuVW4WtKemz2gRuVzr7TqT0L6zqO8I3UW9FLJ2og+sP0AbqPfvRcrDfvPV4YzSlEHyM1SwcnpG2L8ecI/Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GmlBhdejr5tYgSurl/TIkcaCKZnt0muVolAL2eOuDng=;
 b=TmiiTCC6O2dVD2mged1bVhoiFcgL41QdYzEkA5NprCdpro7fToghGQpVTTaJETfzUNa4DnWP5c7JkMEZ1LjMGaonX/U15MaKLMQskzphEDUrTOhUyVXUgmZU1lCL4cu87ff7Y4sda0Y4rs7bcDC6pP0IYYMtHa24xa7qJAhiUC0=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1488.namprd10.prod.outlook.com
 (2603:10b6:300:23::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Wed, 15 Sep
 2021 10:36:15 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4500.019; Wed, 15 Sep 2021
 10:36:15 +0000
Date:   Wed, 15 Sep 2021 13:35:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: wwan: iosm: fix memory leak in
 ipc_devlink_create_region()
Message-ID: <20210915103559.GA7060@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0122.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::19) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by ZR0P278CA0122.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 15 Sep 2021 10:36:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c858608-b8b3-4c56-a877-08d97834a532
X-MS-TrafficTypeDiagnostic: MWHPR10MB1488:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB14881F25069C58414C7255FC8EDB9@MWHPR10MB1488.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:93;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zD5JSJVfeVPqWyW4hTud5laZuyELrMeVVzEu5DDgAFLPWtybqJfMJiC8/H137oe7cFnkt3sNFTEXGjHoItM+8FfUr6ho5Ul0JkzNiBTIM5VyVdmxFx0lAZcF5MdBuWjYdu6AZQhtqlPsDu7iE/UM02cqPY5UNDf2pcBLdvNqeWmU46/s1L+3QnjoLpJAYyfpanMXSIMEQX6UN/ezBfXBkvThac9cfmFkA4fy8hs8RPMVj746LuOs19+4jypU72anP7YNXBUeSYdvSy0vta02dCvo3RCOCEWnPyMOEUz8J/Ft+iyu40pVcakNmPzp651pEVf2PParBmJRRIG1OfHUImaSQKyDUezEI7H6rNFig2rxcEXRQQs9euhdghjIWxyzLiyyvY8W6YzNliq50VGSqJ5MQS4WS3d78TBQ4Ds2xmpjyH4LBjiQi0kiiofOZUbtMCdHyrKw91IMkU+1LHNA3i00h2rE/eQZ4E+bDntVStWzCAocAHUILK/FRRSqJuTQQ8m0RaiCz7JGIHeYd1ZnryhNee0/7tPYKtY10rOfbzM6tUsqIlGsQwZ6G+DF3FdvK9xFA1TDqO50QaGAJv9myjXW+oMayiueFAi3f71lnODkvK+KaBcKxSLgT1GOTgPLR4WZE9FcNcx2XbNYT/9DGPJ0cz6g/NBtTK3syRQEcKqGFhlNUhSlhlfa+vgCIBoUA2yP3aAdsnSZrQ6TngWriw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(396003)(39860400002)(136003)(26005)(8936002)(83380400001)(956004)(9686003)(5660300002)(33656002)(8676002)(66946007)(2906002)(4326008)(38100700002)(38350700002)(66556008)(55016002)(54906003)(316002)(6916009)(66476007)(9576002)(6496006)(1076003)(6666004)(186003)(478600001)(52116002)(44832011)(86362001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UAAWka1F0aJdEYAMeXVvJ9qljMDzO7pbuUg3QzRREUifHNpUbCwAuxRcE7mz?=
 =?us-ascii?Q?xgWuOqHos0adGPw/ds0mFOoGgxzhCMbd26CibCPSgfgy5MRHxpqXyt70pgVr?=
 =?us-ascii?Q?vXJP6hft7cZye5ZggTBc5zbn19Pr7i2hhSRxrALdoaSuI7ZzsAMNX54vpYdx?=
 =?us-ascii?Q?GRqCWGHKB7JD/Pv63dMN6gkbsdhuBmShPSnYncaOXW+cb1ZUlJw6xrg+X8mR?=
 =?us-ascii?Q?QE34dr8x2k9ZUVCwW6SUneooGxGlP5ExpxYri73ED4RY/c2WuSTHSudA7uWR?=
 =?us-ascii?Q?/L2YyTbzmIAwmenJfkUU4XHThUpXgS7P1sccCp5szkfHieJ8lVAzyze623Md?=
 =?us-ascii?Q?teLpPU+N9WiDuRWvCn/4ermflWrdpyR+y30c+5ABC+YCTwUhD6d2IMfoOlij?=
 =?us-ascii?Q?MsEnRTgJYJ5x6Lud7eUicupIeJp0UhiEYY91CwK4YTw65/foAkHmqqeLPikl?=
 =?us-ascii?Q?6Yv6DRK3eBZTEl/Srn6CpXw4Y3qW16he+H083pDRbGHCcPe/rN5ATUbTEhqw?=
 =?us-ascii?Q?/bIk1pI+NZ4r4cuzV/QuJEs1IS5IYrTYXt4KMETy69BygI7KjUSkTBf2+rNF?=
 =?us-ascii?Q?2FzMV6l3zvAXN92gQl/qa+52m3WFCvfkhzv6leLSf8gXD7wPPXymciHyW6fA?=
 =?us-ascii?Q?ctxPd1qoM/6hcWo4yEi6uNLOprHH9AzWKbxiYr0xpzKkum+oNnhtdJXRbTUX?=
 =?us-ascii?Q?MUMWEuRxg2dSw1MpFiLZ125x9P5hitk/u2GQGCKHuBRZ9X0feODFluNJlM4f?=
 =?us-ascii?Q?Q7lJLshuxavlPkjzYJufKN/QaqiVLDODd7ed3RwJftz/QRGdNFFkgQUV5pm1?=
 =?us-ascii?Q?+FRAv25p4WRtezHSAfuDeADpHY9C1Qp4mfNDk6+n39h8bQCZ5eGH8y4HE/Sj?=
 =?us-ascii?Q?C2hYnG7EgH+7XZNT42T54u1nb60ZHbxQLVF42ppbEvFh6D2DttSjRXhWX7ub?=
 =?us-ascii?Q?4c7ycnCgwqE8SPuQYiNP7trmtr8BY+ynEeqIBGXzY1QtnEu5tP5VpPhPHqCC?=
 =?us-ascii?Q?W9Vp46kEQbcDjbRyCsv/Tjqld52M3RDrUmQmufbl3KVBEvFaN0uv43Phtkal?=
 =?us-ascii?Q?Vw/Jp58A4hrjHVtpZeRi8YA60p8UTJ/SjAviBdkgqyTy0ZlSmzp6VrrpJyNS?=
 =?us-ascii?Q?uLmQyUqHh2hmhLLi7fWnHgLjNze2d/eNihdqbszg3jFqacNLUPVRqf6Si5Q4?=
 =?us-ascii?Q?JT/AHdmz67W1iSNK/OA6jt54JVjpgIQFQs0mIMHdz3DsmWN128/AF891MteA?=
 =?us-ascii?Q?SWvyLjXribNW4kc1KVIfAy4Z//50G8ZYG1usZraj6zHCZr7bOwpVqTs8jNXf?=
 =?us-ascii?Q?PCMRbMrfebyCzqNwufLz6Efs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c858608-b8b3-4c56-a877-08d97834a532
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 10:36:15.6278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /BtQxMRp5Ls/C9cq/1a0HTSasL5q/25piD7oIpqbWQ8RopY3l/mV/6FUUtHJiv/UHlw2i3ZPeKx23aE+GRfDC9CadHCoSO2u8fXYTbvVdA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1488
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10107 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109150068
X-Proofpoint-GUID: W14tPXcVN3G5AyqfU42RKsP8jNpB-UHJ
X-Proofpoint-ORIG-GUID: W14tPXcVN3G5AyqfU42RKsP8jNpB-UHJ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This doesn't free the first region in devlink->cd_regions[0] so it's a
memory leak.

Fixes: 13bb8429ca98 ("net: wwan: iosm: firmware flashing and coredump collection")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/wwan/iosm/iosm_ipc_devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_devlink.c b/drivers/net/wwan/iosm/iosm_ipc_devlink.c
index 592792c277fe..6d4f592ba0b6 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_devlink.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_devlink.c
@@ -231,7 +231,7 @@ static int ipc_devlink_create_region(struct iosm_devlink *devlink)
 {
 	struct devlink_region_ops *mdm_coredump;
 	int rc = 0;
-	u8 i;
+	int i;
 
 	mdm_coredump = devlink->iosm_devlink_mdm_coredump;
 	for (i = 0; i < IOSM_NOF_CD_REGION; i++) {
@@ -247,7 +247,7 @@ static int ipc_devlink_create_region(struct iosm_devlink *devlink)
 			rc = PTR_ERR(devlink->cd_regions[i]);
 			dev_err(devlink->dev, "Devlink region fail,err %d", rc);
 			/* Delete previously created regions */
-			for ( ; i > 0; i--)
+			for ( ; i >= 0; i--)
 				devlink_region_destroy(devlink->cd_regions[i]);
 			goto region_create_fail;
 		}
-- 
2.20.1

