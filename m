Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B183DA621
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 16:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbhG2ONu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 10:13:50 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40286 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238094AbhG2ONS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 10:13:18 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TECMiC028507;
        Thu, 29 Jul 2021 14:13:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=85lgUW7kCoFAfqkeYobFIjPUJhHJqToQ07SEX9A5qis=;
 b=LE5SfLuc+1hoYez9Klymry5H0SmeWaQSvsUJhRZhe6L7yo28PQ8a4Ou+4RAsKKsxCZPD
 kilxWWWVe4Hn6KZ/+TBJHwL0XBsiNsayPVkmauYBTiWMd6W1ua31mtSUp3xHRhPoVhte
 rXmuTQ0Vhfjkl6SQdG/o7lLnVdXD52glAtz3hkeI759qWCJhek8v2vpnxqWe/hqe1eus
 kDB6CU02eU4LJt1MKd1amToyOTh6jASh3IUG1HKB74znvUqw033svw/1ySFsfpp+yFWK
 KUEJpVGMnsoElJevLJlbr1G/iD50SSGWvaMXh8Z9D85e9VFdNj57Et//sXqTEFFvATE9 jQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=85lgUW7kCoFAfqkeYobFIjPUJhHJqToQ07SEX9A5qis=;
 b=aIn4zU/+ZhDaOnUOIG+2KZvMSGH9SSjH7hNyeaKipiO/T6PWBP3Pp/w/Zm0d0TEnGm6K
 zWZvoJB6YqXOX9M3/OGUoP4GmAYlMPRachOPPMp0g3e/GI9SmOjT3ZIQI1A0bmN6rsQp
 LynkeFLgak12cxT0J4LpuciGKjzlnycIe9yFNBQtgLet9wKOqFY+M8F9H+ypiJPpSB2V
 NWzWMynLeJTxsQ0+3peXypWaGqciSO9TjpmFXgsWJ6lPH1pBGeQZTmqO7+tdWy2UekLk
 gQDfUQ6HPqVBswTqa7KjrQQr9FgvaTK5IoZsLnZ8OFW58hmP/34kmVqsCIa0ckVkqThZ Gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a3qj4rxg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 14:13:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16TECGuY049096;
        Thu, 29 Jul 2021 14:13:01 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by aserp3030.oracle.com with ESMTP id 3a234ejt90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 14:13:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RHQUC+U7Rfb+nCG8YqTuZubNzU3dE5/EsrolbUV2ifWLMx1L3ohrExv0PjDNlw/m4m/4KMaHVq7gAxxiBMHgc5ZTmBYkU3V7eNHchVk5mU9pz+D4dgBVzT8aq3IfJV76GjDStZCTZkj8ooZq1KY9F88k8qdUIlXXZNkmdWtijnOTsX7n2kIdVbOqetU1GVilI9yDza7QB4Lxs75WAB7DbbcfSIEhZHJGisXXAvseoFYNLJFwKNE5LTRKMtJV9fdrSdIAqtYNVEbXu17RGmeeK8fu97+g0++sDtPPBv+b2V+LdnXmPsxrrSNwfXZIrD6X2lmMM6xh8FWjzr4Pt7Vyrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85lgUW7kCoFAfqkeYobFIjPUJhHJqToQ07SEX9A5qis=;
 b=Vtej89nhQq5ljtktnGfzaCHuU2H/RhM0ViCXwzuIuIvY2PhsYmhat/kHA+J85PZWLNCpxUwnRvfKgTCAizYu8MwcU1ft/tQzUJ0lXkaBnwKbuRDhgLdCNbF0Q44uNYQ7BsCLxk0fHsdre86MNU3tfF2qkOt8qv6KRQM55mrAkSaDtIkn5Aczdxkj1J+24benLMOzLG1bQ7zmcnYFs7BZiaIMHyTmQ4LHJ2R+n/hHzezhuPwi9LRg1GL+S54ib36NJK4mmALbzOjDFAh1rynxx01OSvT14njnLL8xpla/lq95Hxt25SV05ABI64Vz80hv0uaXaods7eV0U9V4krGexQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85lgUW7kCoFAfqkeYobFIjPUJhHJqToQ07SEX9A5qis=;
 b=MDK30LPkeGptMHTl1cmFSIJz21LLe66N5/QAHTJsv1GhUvJbj4T2lozR03yPqRofiZ8PUGFaXZMAFsD0W9w77BmPB59g6eKb8123vIxtXXAL5pN4Yz98l5Ge5N7HtJ66asC9EmSgaMSuupv0YxblYGIGtaOoTfR4HrdShZDXHpM=
Authentication-Results: grandegger.com; dkim=none (message not signed)
 header.d=none;grandegger.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2096.namprd10.prod.outlook.com
 (2603:10b6:301:2c::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Thu, 29 Jul
 2021 14:13:00 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4352.032; Thu, 29 Jul 2021
 14:12:59 +0000
Date:   Thu, 29 Jul 2021 17:12:46 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Wolfgang Grandegger <wg@grandegger.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Akshay Bhat <akshay.bhat@timesys.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] can: hi311x: fix a signedness bug in hi3110_cmd()
Message-ID: <20210729141246.GA1267@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZRAP278CA0018.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::28) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (102.222.70.252) by ZRAP278CA0018.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend Transport; Thu, 29 Jul 2021 14:12:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f95a8cb-db6f-4f70-a26b-08d9529af866
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2096:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB20965EBF7AC522EAF81447AD8EEB9@MWHPR1001MB2096.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KTSxoBaFCNW2g6nu+mb4nvbiztKl2K5y/JR8PTplZBd8Fp8wtxOflEID8Sl+RAdZP+YB+exbrNMgfyYIYR+ws7ZImZAdOUMsQpvkOQaovs5ka0sQuBLl47wKtqNGtpaVKpHCgC10WXJ3MI8v8D5ZyIYnWt8WLPeU9/7RVJv5D5rDNeb21jGiM4ZZ2Mq2tI2hFgbouMvZnT4je8JmzW/o3YYW5EEhCUbCRNaQiRbtfLy4KsY2jf9f33qpzOhkVtbkGchxgQhucm7OOcQzZQxx/SZuEgeTOGiXo/KM8kd5L1WNsvSMVadRNKSLazuIMKvvHyasxwxQdKXm4KCntUFHZu/CmOx7fqJHbpBavfgCASQgiTKdKku1vT2nBrS1t2iKd6rw7AoqdcUQbLpPDXGo2hlsQ4uoA7C6vthvIrk6sLsppZm4WggNEQ7NEjwQTJCWuTtsuKduZFZcc86acVGcoJw6CRkJBGsyg1MrZJGHJZwx7z+DV7dVYhYytD1agsA9YoML3rylNFz1E0NPLLBPAcODcFi3zz3KN3bflRuLohhfAmIGC9K7//grOnS6wKwmfY3A2bzE2Nmf7x4bouyiYBxRQxorEi+8tQY7diIcjAD+j9ceAYscQpPTQEymVLjEgD5he60+xMWtjubKcj4Z4XYnl2b5w8dp2MkPvwXk+G7kFA2Y89QepgET5R4Q63NiS5iKJ16JShAC/v4y/QY6fA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(39860400002)(396003)(136003)(9576002)(66946007)(6916009)(83380400001)(55016002)(4326008)(478600001)(54906003)(6496006)(66476007)(6666004)(186003)(8676002)(86362001)(7416002)(33656002)(956004)(1076003)(38100700002)(8936002)(44832011)(52116002)(38350700002)(316002)(9686003)(5660300002)(26005)(4744005)(2906002)(33716001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QSrsIeR09GmU9tSD1rpjeDjfMQCsMNUahe/kUj4i/Al9Ttflf9DWBfx/U66C?=
 =?us-ascii?Q?2zdAf1MbCVMQvbUW5rqmbvhDY1qp/v64SuFRguHtI1YMsWqxEnwDK15fr/JT?=
 =?us-ascii?Q?090uMivL5hqHI3Dey3kmndUbb4yFxvSZX/mPDEWe/rTo+VqO/eCzhZNvxr5+?=
 =?us-ascii?Q?asOqPm0PoxR49e5xytw19Z3g+rKbHFGWHL+cQKYzQpmok2n+qYeCHIQixnyU?=
 =?us-ascii?Q?MRLI+xk3b9gSFaY/MUCzcq8zRFDx9zywnz8zQEBxGCDQcUrXsokUapZmzTgv?=
 =?us-ascii?Q?7AZQzJloE2qlU/4hZjguxINLmTMAIUgmBGp0XVS+W746Hh4GZpNoAXVvwcAY?=
 =?us-ascii?Q?ybwadZvnejqgh1Yl/qfca2XfzwQafNtD70pMcBMW/8fhdxwRJ7FNwo4ngCjf?=
 =?us-ascii?Q?oPR4M1lTqVJ/WxZpkk/bIllyZ52jY+CFr3C/lWxp5kj6//6sAvSqoTK3rH0s?=
 =?us-ascii?Q?TDzmgfPS2HNCU37JYwFDGKrawfNQXRii54OmkGFOCtkx5H5w06pZNhojP5gi?=
 =?us-ascii?Q?VaM3syccwZ864oeJ29RinjVhnI7xFtN11E1QjW5c3VXvHbk5zUU5A+7k8Fp0?=
 =?us-ascii?Q?h5DdYjHK8pQO3oBiJT804Ya9ofuMbfJQCnIHWqq54MHzdVlLdn+rfTvW2f8S?=
 =?us-ascii?Q?3cmEBPGL1J1wmW/UYi1FTKBmbNVP2spARJ9EO80HDlcn2GscAdohUQskeOsk?=
 =?us-ascii?Q?5Ft5zBTKAXg5w5u8VuRIyhsEo7qXtU/OtTss7xGqHUWrGeVm5lmCMSdjtslU?=
 =?us-ascii?Q?dwFYbAIV7y8efsochqZmpA+Ww64wsd3ZAxPvJogyOMZxsT03aYNPZe0pQpzu?=
 =?us-ascii?Q?oj6wFeGxABTNl4a7GTQ14jTcfNG6UD/7f7piY5hYWADrFG7iCZ38XjWqhin4?=
 =?us-ascii?Q?S588zjqHnYATQMBZnTL+5U5b1QOC0lxPVxdk1JoyRuOuSMTUOueZ+7IPz0kv?=
 =?us-ascii?Q?/47eusHQrq3AU8rRP/xIsK7rYhI1vWnqAQSZXDjLaPUWJpaWOVvWUgFgyHJK?=
 =?us-ascii?Q?D6t91n4EoxRHNDMN45GRVkELme+6TUOOoX8yIrgFP+1zEyc+ct7OttB4L5dL?=
 =?us-ascii?Q?qwFVlq635U9FJgnsQ3JFxtVugrBk1l62rA1maPImwJLQat++LeW9w+2YrKys?=
 =?us-ascii?Q?/Nqi4qt2uG84aFRFk5zTUhudESWDI35XoE1Or1wM2lPp2gf//EVZQ6PIWHc+?=
 =?us-ascii?Q?m3SXuxFSC+MTo6mlJBEjYP2D5E6EXpvSQVGVXpPHdKikekLcRCJ9gK4jtsTC?=
 =?us-ascii?Q?9vLEbypEZh+g02rCuZgyvwAycp8xUkyC5HqVsJk17hvsSVHBGL60kfPjeFSm?=
 =?us-ascii?Q?RCykd6ls7yvv9jpK0xWOyFjs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f95a8cb-db6f-4f70-a26b-08d9529af866
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 14:12:59.8820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UDSZcRPamMBDzoZHuCibBtBnO1eQC3rvxba7CVnseAty7+xO3GcDKCvUrI8m4Cca7pZ8rp3Ye1h4u0OAMxCBHDtsEQYfNPyLwKUCWq3joN8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2096
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10060 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290089
X-Proofpoint-ORIG-GUID: GlTcFb2UCgsI-MNfUNT801ShOvVkBedY
X-Proofpoint-GUID: GlTcFb2UCgsI-MNfUNT801ShOvVkBedY
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hi3110_cmd() is supposed to return zero on success and negative
error codes on failure, but it was accidentally declared as a u8 when
it needs to be an int type.

Fixes: 57e83fb9b746 ("can: hi311x: Add Holt HI-311x CAN driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/can/spi/hi311x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index dd17b8c53e1c..89d9c986a229 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -218,7 +218,7 @@ static int hi3110_spi_trans(struct spi_device *spi, int len)
 	return ret;
 }
 
-static u8 hi3110_cmd(struct spi_device *spi, u8 command)
+static int hi3110_cmd(struct spi_device *spi, u8 command)
 {
 	struct hi3110_priv *priv = spi_get_drvdata(spi);
 
-- 
2.20.1

