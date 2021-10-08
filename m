Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38170426464
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 07:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhJHGBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 02:01:41 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46452 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229511AbhJHGBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 02:01:40 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1984pHhD001318;
        Fri, 8 Oct 2021 05:59:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=R8psRGWZ4JBAr0YaLvNla6vwPAj8/G/v6x7XE2pioIQ=;
 b=lqMl9W56fUsjNS7sA17au2sjawDioDct8v18CLG5AD28xhUHKg3c2weag8HDG5MFsybo
 1Kyw7/9KvbCf8uVom1JXUjCSN/H+qF921lS3p0VeYqWxrxkthSBF5gvNYjm7RdOTfU8A
 YqsAlccexDxxuqyhNLLetqG4fNACxsN+wpPlrDbXgdIOJY47y6tM5CFWJjh9T3YocYwe
 uPy+AqR3aNBMsGgZyRSXoR9wZQJuwL5jXn56Jmx7fRWm8YM53lqclQXcco2zk941x1+t
 oBrWOORwiLQgxTtbk4C/Edeq03WWfLS2gOODcZX9vZwtH3K7NT3ZAo+sOsFrgCdWk6Pj +Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bj1ecnj1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Oct 2021 05:59:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1985uSWg050225;
        Fri, 8 Oct 2021 05:59:14 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by aserp3020.oracle.com with ESMTP id 3bev922b65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Oct 2021 05:59:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ncYP7SbASJOH80MBxzsmce5Uh0dJtkbvLIAmmOiWaPkepxauqcgzhxkbyzZt++VRSCZ156ESCrOq7HWQ6fkq/uMrAtLIorAcyts1MdWGLG5czuFXh9fjpIfeUUeADkGlgdudtWhSPfb1G93ogiu/rQVlmLGy5bKAiqMKBQHXjM9EN4fn4IEuq8DbDfM5RkgyCwf+dBhg+J3zizDFJaOLIT5Qk/ySw/qHHoVk1y4VEeRXp/tVHw+Br9L+dW84rerqBBWakIbrh6C+zCGKmknq8sJqRD7pCkij/wgDqceG1rW9ACT4LlOO0vNFTBe/0IbELYJ1Z0mGUKpbTXk38Bx2Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R8psRGWZ4JBAr0YaLvNla6vwPAj8/G/v6x7XE2pioIQ=;
 b=Kht+aZmf6FMJBTV0kUO9mBXeh042u5285I/+Yv6D1PHuZhTl2RSH1wopKT4yfX5mvC+ZSk1hyEVUikJ4ReUCkPvfcjPUahXpPFHLX31BNbaNcfQJLCT9VjpXo158f4CxsRkhjIhEDA+Cbz43X4AuhVVztbn9dRkqpA3RWLMPOAjZ4XI0dQ9b2l4fvtHZwZRfETikbKgrPXAUArgTBeE9wYeZ24D7LcsvjoAiuQer34w/QpFEVxbNjeUrapDjK5yyqOVcoNmhmtlwKkLfwxx/feDYMU9PdgELFn1kfJwB90vYVc0mpMtg9xWEdPCAhnzBiB1qYc4DG/xuHatXw6RLRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8psRGWZ4JBAr0YaLvNla6vwPAj8/G/v6x7XE2pioIQ=;
 b=BF3MgghIl8WR2ej6CerBP4DhAvV+VvQgwLL4K4KO0Nu8iN7J9HfnBn+R0Zl7v95dCDItG3WxbsH1CDz8WdgWBh2wgyIpprl7U/SnbNY1Y4E1w+E0Wnsw+ynV4f+41aCxFxoA86j+U8UtbxiZIa7jNmkFAG5g2vxNAWo7+tPA7Xw=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4466.namprd10.prod.outlook.com
 (2603:10b6:303:9b::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Fri, 8 Oct
 2021 05:59:13 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4566.022; Fri, 8 Oct 2021
 05:59:12 +0000
Date:   Fri, 8 Oct 2021 08:58:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W . Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] carl9170: Fix error return -EAGAIN if not started
Message-ID: <20211008055854.GE2048@kadam>
References: <20211008001558.32416-1-colin.king@canonical.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008001558.32416-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0004.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::9)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNAP275CA0004.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 05:59:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea0f576b-268d-4ed8-ead8-08d98a20c067
X-MS-TrafficTypeDiagnostic: CO1PR10MB4466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB44664CA673EFF4C56C5C982A8EB29@CO1PR10MB4466.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vO+VIgkHjg+JhLpNGFYf4E5Fn3CTfgGnjdJr2TRp03k04sjDuf6+pzAx139CJpM+LUAHaecbN1nAlEKjVvjewtqotQGAU4T6r50HddWPJM3zc5KGFxsP8JlqqJmI9OvOFGEwf4KF+cTn39QHd9nWnes/0ynYcPMFT+hDhgLA1n6Teeu2KTIrL5rzYuiW/0IExjzxmd48pFfApXR4RghxxUX2kOQauB+hY1KIOEb3m6+941MfHpCNI6rh87/EgPglGyTP4mC3XS76Llw3vlNiA0ZSogWZ6vcAMcMXcrfe4wQ7QWe6mjaYdVFA9/MjcIEk0QXv1rT8B+1yeg3TIpcu/DS9BB9iFAHh4bQLvUj3uBSNdK5j0Ohmxkd6lkg8DHOdXMSBpxYUbMGBlrPax7zOU/u/ErZM2ZWnL/9dCsRjnuf+awQ/ZgQh3m8GH8ViC+065GYkr7V3NhY8LMIEnGIM5YhQLOH7iOXD4PHMMf/9oJKb6H7oJ4qp9eWqKvWxrQQWayIKIdKwdAo9DbWZPqvBYnWsurhD+mvMXJt4KniyqFm4PmCKxeX6kPyVRclLI7ddd05RPwK6StRn9g6THfPfGvJq04G4Bw1sxaQ9iYCCYNRJMLPtYE2Du5fQT/0Ob5k2j0P1Mvg1BtHiOlpp2UaOI5Aq1zQfi3SqcIlATUvkwMvzJlfwLrDq68bnr/t4HCMcQ2CpOc14URdEfbNFlGWQdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(33656002)(2906002)(86362001)(44832011)(316002)(26005)(9686003)(9576002)(6666004)(4326008)(38350700002)(83380400001)(186003)(5660300002)(6916009)(66556008)(66476007)(956004)(66946007)(38100700002)(8936002)(33716001)(1076003)(52116002)(54906003)(55016002)(6496006)(7416002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sbFvRIiceum7B2EIBMK5rPqHIOEgMH0d/uVbTO83lNqZApReLzWq9hCJPmqH?=
 =?us-ascii?Q?aDvIUMu+CzrqhyZyBGLSsWUJOXLwypftsRN6T5eNrBSCOaYKgDwA4lsad2xq?=
 =?us-ascii?Q?c4QlhHO7qaAPWoaUGRV60/BMTNyd7u8BBvNjDJcj6VMYh4cVdHFlyduz1xm0?=
 =?us-ascii?Q?HC0DXuG5aZEUdaIzbghVJTN49gDTusWXCVO/QDYjBRYPxuZTy/vsyESRiaPM?=
 =?us-ascii?Q?DxXo4S1QvGpejZW3/4jKKtp1+CuzZhqdxzyVx2BfkYRmigUz0H/ivYFkWVew?=
 =?us-ascii?Q?0+zwmc1gslKZEjyZYK4GArn4i/RV10EcKXo2XbOnRBfgtUUTYMjwYDcEvhhK?=
 =?us-ascii?Q?Si28UJSrqvovctrIPd86n1oATaTIuTNxv1aDDpDnQPg/+92xLea2LR02Wy/M?=
 =?us-ascii?Q?lMSdofqiWtCz7uBIL/C84mGHW4dDjYYWKY8L+egudVcoRl1O5W6f6hNWIn7u?=
 =?us-ascii?Q?rWmgUPgaqBfkE5BTCArFlhdKO2W5ZkQuGrBrRV55vFndo822FUXR8gXWeVlN?=
 =?us-ascii?Q?sWmnAHGffGXbgMVxbDH+88KYwIiQGlLg4tKLOjqGas27FrMNojwyx/nh80Dd?=
 =?us-ascii?Q?24zQ+Fc2NcmsVlRQsmt808eEg3cOQrxjvIyuTSdvgS2VygqNQ0rdrNNPNpwv?=
 =?us-ascii?Q?yZEvTeDpb2m8a2PTYoL+MPk80vmuWCbFah7ZWrgQF2aSXn5WPrSSEbdzWYXR?=
 =?us-ascii?Q?hvn6GaaFI2Xl18Pewc/+rDOuJBszewY5RaCL+U2u5nFCdKb+snSn8i/dtBcw?=
 =?us-ascii?Q?Bl/RYiX5CxNA8wO8LIQFNvtN0AWDTVKnNn0q5w/0LjqvPqIu7eoDVShq/Ahk?=
 =?us-ascii?Q?HAi/Cczu8P5t0NlDiJEhOMnhj7VoGI/rhmlv84LPOU0AOAN1afdl5hOcspsM?=
 =?us-ascii?Q?KXpUpVIA+mdGxXEFiqSQlP3t4aLtUFSQTyc1+2WTPJ8AAbktkgVJtzpmd0aN?=
 =?us-ascii?Q?AicvXNJjxD3CNeVo719AezQBuVJqNtoSeG2SmHUde2NTpqXWHRQJBRDD3blh?=
 =?us-ascii?Q?6yYuLREItdfONWtAHaZ+fWCukXKcJ+aVfk0H7AVW/9wCZstrvdSW4tsVvcRh?=
 =?us-ascii?Q?OLjO7nJZHMeughYYpUPYhx9bvPiNnH4DaJtSRFfC6PDeeGj7qgX2zxFmAEqZ?=
 =?us-ascii?Q?sBksf86L13zR8zzDDwlgjnd8QQYYE9BgsJX2xq+dvg75SPh+0fsCvJUua6FZ?=
 =?us-ascii?Q?p2Dlu00+soht7/06DXXoNX4S0dMthZulecJWSLazyHpICK1y8Rt8Bz0Q7fHL?=
 =?us-ascii?Q?bvYut9Us56QJMK5J4Ma46cie+luu2v61hUQxYBJkVVKNbg+Etjgb5MtI/a6c?=
 =?us-ascii?Q?3OUaHCIL02ZA5O0S5yz9ptYZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea0f576b-268d-4ed8-ead8-08d98a20c067
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 05:59:12.7514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2fxsO3DpP4lbudAaeD+Dsdk4DqPC4tUqAsRKbFgfpV8yWIPgYxdP/Ey5yNc6V3Yg2NvT1eAifuKZaVgkWFHron8miO7j0ruQ/BHQ9MN1CAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4466
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10130 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110080034
X-Proofpoint-GUID: LfGhal-WKUVvzsRNKnuHQdg_MfRp0cPP
X-Proofpoint-ORIG-GUID: LfGhal-WKUVvzsRNKnuHQdg_MfRp0cPP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 01:15:58AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is an error return path where the error return is being
> assigned to err rather than count and the error exit path does
> not return -EAGAIN as expected. Fix this by setting the error
> return to variable count as this is the value that is returned
> at the end of the function.
> 
> Addresses-Coverity: ("Unused value")
> Fixes: 00c4da27a421 ("carl9170: firmware parser and debugfs code")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/ath/carl9170/debug.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
> index bb40889d7c72..f163c6bdac8f 100644
> --- a/drivers/net/wireless/ath/carl9170/debug.c
> +++ b/drivers/net/wireless/ath/carl9170/debug.c
> @@ -628,7 +628,7 @@ static ssize_t carl9170_debugfs_bug_write(struct ar9170 *ar, const char *buf,
>  
>  	case 'R':
>  		if (!IS_STARTED(ar)) {
> -			err = -EAGAIN;
> +			count = -EAGAIN;
>  			goto out;

This is ugly.  The bug wouldn't have happened with a direct return, it's
only the goto out which causes it.  Better to replace all the error
paths with direct returns.  There are two other direct returns so it's
not like a new thing...

Goto out on the success path is fine here, though.

regards,
dan carpenter

