Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1074A6B23
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiBBFDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:03:07 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:45898 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229458AbiBBFDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:03:06 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2120DNHx008544;
        Wed, 2 Feb 2022 05:02:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=yEJz5i4wgrqG1yaFRSy2oJPnZOWTi/+4rRC1Y5a8P/8=;
 b=P5sh6z6me6aaIRHa5nrjboTAJhhPCrCC3r+161q2SqX2HO+idvDR2ckqg0b5VMTdssHn
 /y4ehw+Jzp5zbj5mJHSyl4dk8iYqQWZMt6F6nt0QLY/V1uVaBjDv2xrjQsVRRnG0mACN
 Y/hp1ubwGzM4f2drEMmqAYcPEHtkf/bdGDb3hIqNDBPYz8YXka6KHFpGpiBqEfWUaYsh
 UxeLxXR/tYdiMFJwcZD6MHWpuR19p0rtN2NIiGdEE0iS2hQb/0HF/a4IRRrjSASlyiYU
 2TikGd2pDYdIFXtzDHVCN0p9dN0OimszSO1KspnBgxTkVmTF/aHXD7/8fRsolxaRnFZ/ Qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxjatw0j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Feb 2022 05:02:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2124thPY173546;
        Wed, 2 Feb 2022 05:02:54 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by aserp3030.oracle.com with ESMTP id 3dvumgmu8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Feb 2022 05:02:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXTaLBnbVMx/5FeOdF3kmx3CW4ihF02PjS00pmmEUaaJmYI5EtvarGOVRHitsre6FdsStlxpQ+Wt+1m6EXexiEus16yNrtLXhPEGjMy83sfS3hIsHPDav1FZG8uPdUFyRK0gDRDXHFQ0B1lAtHJFtJphv1IBJjDLfqDqUhp1g3ymU+FV7YdscHeOmzC84G9vBoTfb6xqVE0ohq4V5pTNoUHK+YioGg80xDzekDBxCPEGyARWBkG4zceuKzeHJz1d3ySBmr1jD0IIt2SeGEPFlf2DD1O/R6OEmbGw54cRWFHCC/Hv6Y0SySb9q7X/U5buiY/Yy1ZYieeXzmDCTo3tuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yEJz5i4wgrqG1yaFRSy2oJPnZOWTi/+4rRC1Y5a8P/8=;
 b=lGNHiwhRExoiyf9pTUTmBbHtnXxcyEZ+RlT70tRe8eUU5thojxDNb2aVIqLw2w/WkLwseY6oUekwO7043uWmZL91F4qhBKLAM/j7rpfrh1Fm8g8DuMkECZhDuwJVNHeauFGyNuHnQKv2R+ptzd8dXNlFg1Bi7W2ZOYgK3mW/VNHugtnMQougC8EYC49SYCwIKAfjiIjeR7V/VuQnU1toN6uLRF5ddwncVHtHZKSMHfwbR6KNhzpzKPcDP6yv+5cVKnha9YIfEIFf64t1Lti8EKKQGfdUcxqnpSTGpqSgH+KqBTwRC5OJjVdCQHMocQBtJmOSsI4wddttdF2eZPyo6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yEJz5i4wgrqG1yaFRSy2oJPnZOWTi/+4rRC1Y5a8P/8=;
 b=VYLYLhviqsks3PIWIbr3QIC5u1hTZPHH1BDCPDpFrVq4GfGWqo6ePtrDkKyGdvA2LDR0BlKA3yv/rwKuX5WZGR+puETaouHxCfCcMOM+hFTM5PVxLjq+XdhBLUW1TmTprZ8AH4jBBkVh4K8ypPqZB/EW1Gl5myOaqb/4I/zDz5c=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH2PR10MB4056.namprd10.prod.outlook.com
 (2603:10b6:610:10::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Wed, 2 Feb
 2022 05:02:52 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8%5]) with mapi id 15.20.4930.021; Wed, 2 Feb 2022
 05:02:51 +0000
Date:   Wed, 2 Feb 2022 08:02:30 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pkshih <pkshih@realtek.com>
Cc:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "colin.i.king@gmail.com" <colin.i.king@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: remove redundant initialization of variable
 ul_encalgo
Message-ID: <20220202050229.GS1951@kadam>
References: <20220130223714.6999-1-colin.i.king@gmail.com>
 <55f8c7f2c75b18cd628d02a25ed96fae676eace2.camel@realtek.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55f8c7f2c75b18cd628d02a25ed96fae676eace2.camel@realtek.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0012.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::24)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b98b9954-5c44-4444-08b4-08d9e609437f
X-MS-TrafficTypeDiagnostic: CH2PR10MB4056:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB40568E5F1D0D5C790A81C9138E279@CH2PR10MB4056.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i2STso6A04Ue49iYlMrtZYSpT8WA7BJ47bJNwdIzqb3TTK3uZLEBCehWMxAgDwvGc/rNI0GrWSBySqm8JtGdbHsccZ6bBOJkkcHB8ll+vCULGMC2C1vk/VUthlVU0mJb3i/pVN7jXUwbUphk1QjWSMcNAcsM9uLj+I6GDcqBGdwoDlfWA2Mym/yVDigcokDCtA6UGQreUvhWCmj7GPZMA1gpoHxZlfeyjeRs0u/Qjmswvn8rv34KZXJ1X49rCD9VjVj07i69dYMNW0hlUnRCFCmnzmk1S9NJw3VtLzbHwxYf8uxhPxdkfwfNcqdoBgiCy9ceJS9k/get3RpKJmiInoO6Yl24mZv0h+aCFdA393cll06g2DTkwUAQm2+PQhBkMqshffLkglnbfvqeRjVqepyh11qMZ7B76PskLeyKk5uKng5Fu/DgaA+1rt5777xJOWLATQwImoJsxvvl/MbSIaBYVm1OJ3zJjyp5sY1q+6mhEzIgPEkUi05T+GI40tNz3+rjmynvhZ+TI85V/WjyZhfcSyOOHN2mBR8/aFwJ4GTLraIUPzkZDMhalpa99T+gVwDu7XwqS97CgnQaRRfIfQ6sdrNd1EV53ceWo0H8WO2jgiKXcNbfs+IZLU8mdk/lS6jQjcjmHtEPy+OVh/1ksd11FU8do0a/4/+Oytj5h7MZ43qTjL9L+sKqO59j5qhKkkbKq/nsBSpQg3yloYOGow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33656002)(52116002)(38100700002)(8936002)(38350700002)(9686003)(66476007)(66556008)(33716001)(2906002)(26005)(1076003)(54906003)(6916009)(316002)(44832011)(508600001)(4744005)(86362001)(4326008)(8676002)(6506007)(6512007)(5660300002)(66946007)(6666004)(186003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FYG0e/8v9ZNgD8jcGYZTD/uHhREQNeFct1Ur3CLYTuHYr4CqIeppL2XBhwUK?=
 =?us-ascii?Q?DDwchYiCTUBlzBr2NOiH68VCZ3KUwzp53dTvdLHf6tgmYE+zPdSI6mS2MvP7?=
 =?us-ascii?Q?hXch4Iuk7WI5RHT9q3i1Fw1g05WFo4PzmuRgBUlFU6RkL9h8Lm7kzwkQiawa?=
 =?us-ascii?Q?Uad9pBvpbeTzSvmUDV0tHTgQdS8AdAaTb3uAwxql+w7JZbiUMvmKOV/hdaTX?=
 =?us-ascii?Q?MAM2eVqx6NGADT00F5BY/JQ3xLefA7sYHbmCS+f/Ter99h+Y6okMwsYP4eaw?=
 =?us-ascii?Q?cWP5Zykvlfz9mHKzBBTWBkaAihQQS8rFM6bzD93LRgpgqe0gtokU1c8UpvCT?=
 =?us-ascii?Q?EQF4TX4pVS2LYBaqwP2DmzneMNOUXBKwjvtaQVJ0gtnpxFpGINTFlkxDhjHe?=
 =?us-ascii?Q?zJ/AOai42hWFk9tIQw6Q/A95HjtMZ2z96ECUGo3uIK5tWWvyTqZopXW+fxq9?=
 =?us-ascii?Q?HV4NwNO9M8LkqQCKdG42w1xvaHqPL0YaeAHGhFZ/lN8aqffZkRPgpshZaiMf?=
 =?us-ascii?Q?bEID/ZNWPORxvCzXS2PRuOVgvEa+aFJkGjQliSenvpt7zg1sntIUPtF/lmq0?=
 =?us-ascii?Q?0h4NsmvI7jtE+oqE3Pr2ua8RMfO1qfZbBLp1gaHZIe+ps3z2jzlupzofc+Db?=
 =?us-ascii?Q?ekLvxXgrKCsLqps6+jjt1Tnu7bwqGXwcy/w214rFLC+SX5+98io2J2RtCreU?=
 =?us-ascii?Q?pFbS1Q2cl/Gx6FeA6+oPH00s1p/5MR4y3hF7hUFqqi416Ha7OgG47npW30SN?=
 =?us-ascii?Q?IoKpxiQhjzqoy/yI8PUYD5JfXRM7IkbMT3K3DoNJ+olNNgSXJfRfQznRW00k?=
 =?us-ascii?Q?JBUmJU7tbtQ9UPBZAvGBmfkLS5YWGXX6JEXqOHiFdvbohnj3NUIshOmvoVFl?=
 =?us-ascii?Q?HqaBaQVwaJsxVnsJrjNhBclUrn5lpFWTBWaquSExt4Fr70jASuzfeaI7fuRb?=
 =?us-ascii?Q?y0u0Qb1LT74KkmNhGXCpkHit9ubWCUGh5Co0EWTr+nohUhkYL2VMV0dtODvI?=
 =?us-ascii?Q?zITleZqcHA7WBcQ0xtaWM3LXSJSUXc4GKM5pDS2aWjQb8gJ00LpRM5HYusZR?=
 =?us-ascii?Q?CwpNFkzN8W7Ob7OmBz/wSRUYU3hnknjvCwEzB2kISddMhoPf1Iv1GxlaPIji?=
 =?us-ascii?Q?HUr2kgmubH+YLLoCy0IFyMpxKc0xh7yITplY2wbKBT2JLlNEYMhsBJ87729D?=
 =?us-ascii?Q?0VhxWZmG9e2MhdGqBbMbBV9i3kDYVho3vWpQ7xD9g2iyUw9JBVBTGtYA+PcJ?=
 =?us-ascii?Q?TkiL22RimngYkn+2zZQv4BkirDKYX44bd26cp2Izi5tOc3pCyPd7LTIQdCrI?=
 =?us-ascii?Q?osA25IjX7xrLORlPPBxbURh3oFi3C7l0u7IkqIGIVPf9iaLnZNNFpi0Uj2F2?=
 =?us-ascii?Q?z+vqq0DwdASyBwJfmQOR2OgodRPndA9Qc8eAO2NfWhtewDxe4OgNO4DvwCc+?=
 =?us-ascii?Q?3aGe1huija1g8grnIS3oALkzviJBfVNAtzIU2B0yq127H5F/hhRW8qSz65or?=
 =?us-ascii?Q?YF7SpFWBcCHF+klsHgJrNSuQGDwiPLkukqfUzCD6RNAxuQlU3uieQSs9aPhh?=
 =?us-ascii?Q?ZJjWgttGABOAWs4xckWikoZNsDgBztSwDqhjTKgXB9wAMfkUqbNDu4vIMpN5?=
 =?us-ascii?Q?VRmeoOnyax2pKaCQfQ+sltTeVzhdeV4StdoHj8RxwRF9ndZqDRu9qDMGcJoW?=
 =?us-ascii?Q?+rzzMfsHnglklfkV7kduTp2C8yQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b98b9954-5c44-4444-08b4-08d9e609437f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 05:02:51.3628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DMkFyesoFal9IL133M/qa8BIAZFpH3JQQ5Lfmwynbt/LuFXnEZP1NCnGGQHZr4eH3Ues/kc3pMtMbD5buvo2yARga5DPNiuexV6MbozmpyE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4056
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10245 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202020023
X-Proofpoint-GUID: vBOastZIo5SwHjSD9hhytGqhH_a_GWtQ
X-Proofpoint-ORIG-GUID: vBOastZIo5SwHjSD9hhytGqhH_a_GWtQ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 02:53:40AM +0000, Pkshih wrote:
> On Sun, 2022-01-30 at 22:37 +0000, Colin Ian King wrote:
> 
> When I check this patch, I find there is no 'break' for default case.
> Do we need one? like
> 
> @@ -226,6 +226,7 @@ void rtl_cam_empty_entry(struct ieee80211_hw *hw, u8 uc_index)
>                 break;
>         default:
>                 ul_encalgo = rtlpriv->cfg->maps[SEC_CAM_AES];
> +               break;

No, it's not necessary.  The choice of style is up to the original
developer.

regards,
dan carpenter

