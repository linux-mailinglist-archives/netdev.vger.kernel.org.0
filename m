Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB9642641B
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 07:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhJHFfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 01:35:38 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:45938 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229511AbhJHFfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 01:35:37 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 198576ed025384;
        Fri, 8 Oct 2021 05:33:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=80V1A0YvT3+gRkHErSqPFP50j2v1sLzJjdPXcF0jgW0=;
 b=AKoBK8iLuaK39S67AwJzdTrug0+IW4du1zgIjKM47NKsj8ciCmM8fngpYkjeiJ2lS8qh
 iRRQprRCun/TCnEpEOBRaMG2YqVbGiE+XiZcbp40ji9LA4o/kMIoTwhMpwdMTrMV1ZDN
 wtlXOjLRtwmV8haFdR8I3pFsyU65QOvh8ouyrgNb6T4MqQqy0/xjFIxByn/RFvh9QepV
 n8cXXIz0eyaYBTznV9AMFVSgnR0YTWSJf07Jbu8j0tLS0U53Ly3m1eHmufgTV1NSYxK/
 d3H+SV6+O4KVWb/2lo5PDk/rR6MF6iDX7x9YSjNCPrpbbfdAnRuidPK+SNoBt2GlNOYE Uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bhy2ddx4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Oct 2021 05:33:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1985U9Yu036733;
        Fri, 8 Oct 2021 05:33:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by aserp3030.oracle.com with ESMTP id 3bev7xhcc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Oct 2021 05:33:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bje0ynbhh2fz6zvdsdcCgRPsmh+2JVai9uHFYeJNDZJI1mAHKmCjgrBmcM/Zxv5qmk0l+iEX66cVWsFkKFa+Ae1pwW5Mzp+P94daBpkSW8shpmx+yHSH6okQmjkpdP9yU1zO5+kcmKl4tQzL8dG4g99gIgCSIE7SZkxhrPQ0/LlowRb+WDZ4kNk7bOOjvcaOiJDgnLeXYiA7w350AVIwo0tAMdNLaXeWFPmNKFcjlYaJrJQaQDO94I/H1UBxJjIEX/SQsc0U9Y0J6ei+fC/kHKbsnM/oXlz/ndLlad/+V4Uust2zqOPKJy/WsZTlMn9hjRwFlqMobqaa9+uJwRgk5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=80V1A0YvT3+gRkHErSqPFP50j2v1sLzJjdPXcF0jgW0=;
 b=EBKVRekwUuwKXXS9JCb89fuZZ8BFz5L674FMFTfixtBXDMB7pLojZSc5BxUo9AiPhlQQp4GwON/JFrxgFgVQysj5LoSsl7kE6n34s9sqiq/TYCEjmDNFhcj5Cm2q2DmbA5+NUH6urmdvaP1sn9l//wZ6MEuJ3U9Y3lax41DXpHOABgGq7Hfq0WeJBpruGr11nL6adnCKkui8dwMKOmYSyf2mt7Jc99Fj+YkwXGi/ZZa2cY2UYd903QCPcHLs2ESX+o6oktVX7FSuZ5y37dvUS4Bz+1d4G6+o9YJA0taeoGBHvf/FbM8h54EPo4HtkTXfGPxnRnc0MoFL6SyiyIvUGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=80V1A0YvT3+gRkHErSqPFP50j2v1sLzJjdPXcF0jgW0=;
 b=ndc8fowH0uz6a1YMa04Hn9LYh2fn6Q/0ZoG9haxNuFwipu0VdBawJnszdXZQDmAe45FWoAZTciovj66An0OGys+jiGNp54Eosd8m47NH0fYlp1xuK6tER//fQ2shQG223nkL9GiIk7PRW7P1vafObxYoTaPP3Dmg/q48MOkzJmo=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1248.namprd10.prod.outlook.com
 (2603:10b6:301:8::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Fri, 8 Oct
 2021 05:33:35 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4566.022; Fri, 8 Oct 2021
 05:33:35 +0000
Date:   Fri, 8 Oct 2021 08:33:15 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sfc: Remove redundant assignment of variable rc
Message-ID: <20211008053315.GD2048@kadam>
References: <20211007175036.22309-1-colin.king@canonical.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007175036.22309-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0049.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::12)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNAP275CA0049.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Fri, 8 Oct 2021 05:33:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcf625de-6bd9-4bbe-f212-08d98a1d2bdf
X-MS-TrafficTypeDiagnostic: MWHPR10MB1248:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB124849E48E8DEA5AEDBA91AC8EB29@MWHPR10MB1248.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0JphTwGUKqbZnI5qtsTciK65SAURvq4kU5wmwfme9RixUKN04Cr5QncMhnLhDlxPPMbrjaLkoyQuf/CpmiC5YdIRvwXhjeKMnLDpiFBf0meUlRvISdcxXWWivj/Vlyok/ta01X6Qgkdbky75TvTxyKc/Zs+ONEMS2vWM6kaQO0qoWFsxiua3u9hE9ylWYtsZpeU8be2TUUXbJQC+XsVMTHlKh1lcqFiAQqQ6YSFheqre9nikkW6HbnjE19PLdeQbP5eOxDjHHpHt+7ixjt5AdGFbxSf4esv8QuK46cGeWJh98iUOdhhUtBcYiC6+bjFnawRLFanPNRH8ixbciA33mtSB5xcsJ0oQaOWhL6p8gi5nxQd7MtuYKgK4VCRBCviBMp8uVGS+9lOHidl1BLTUCRUW90mzgoowiP05Yp51h8WvHKq4WDUcXD7y3TDJkAYY73LXhEOXKJpnXvJRVj1MEwoMEtBC/CMSvIUdSpHp7vp9bTz+ER3CidZNU9hgzGjuV2b7VH3sXmAdJctKX2gn6CoK6ELqucGN5o2Qs5UMSO1v1H0Z2vedC+KvxmvNAaVUg4jWf5CFBirOaF0K5ujUQ5DnUohP8/Y3Hk5+SejBxj1pv8Za8+6Wo7VGn5vFnOZQhiNqIHJ2B1+1kUqTOVkLuWe1k2jzp/p0rLGb9PXxqKNajqJZgmDYImzqwEe4Nax17fpuuvc/dfNARpac6WMEsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(6666004)(66556008)(54906003)(66476007)(8676002)(33656002)(33716001)(5660300002)(6916009)(186003)(6496006)(4326008)(26005)(9686003)(52116002)(9576002)(44832011)(8936002)(83380400001)(38350700002)(1076003)(4744005)(956004)(55016002)(508600001)(86362001)(66946007)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zE1HMHlowJWIOFHE4OFnPN8WtmfoQ8IrpVZ7gMR1jhK1KNv5KDxLx2dVWDCk?=
 =?us-ascii?Q?Bj1j/gJf6PMNCZT3Z9YXhZNCjJPi4mt+6Rf76gGMNDtHheCt14x3ObsjIqLn?=
 =?us-ascii?Q?yZzNDe6geDOu341+DjhU7Pe2VZ4+naXaCImf3xeR06RVw7pOMkIsHMbiRx4+?=
 =?us-ascii?Q?wgTDWDlcH2K+hjYLLN8qG4NTsVxq4xqCWVVnPE+hSbaOtdwUyBmJQuPracNW?=
 =?us-ascii?Q?xUo04/S8t1ajnLqpjYsLhxMcOgE+DMyz1+wVrI1SjIehv4mE7GH5mHfMWx8A?=
 =?us-ascii?Q?RGjaR3PsO183Wk9N8Hnihv+ZLhB4tR++Ms1c8nJPEj0Bf+hgRGdkHUAoz89l?=
 =?us-ascii?Q?uS5rI/9tTNJSq3onAVuayTllf1bXXRV/vWQu/VjLF2s4rEDu6lmFSe4rlXgP?=
 =?us-ascii?Q?+DuOaE25HU2j5omOQ4L+f+zr8rlXrYXngxbtHPGR/ZlYpszk1ZxMWgxTa/Fh?=
 =?us-ascii?Q?VU4fi5uPEi9gZWHLa+ysXEcgBjb++07r8zF3UrGd7jX8iiQXs/UIzGBrkC9Q?=
 =?us-ascii?Q?c98DqggxFNutLy85Dp5IseTQ5fK7nEEAmZyvaawObH3yFO59tOTo3mHbpY3v?=
 =?us-ascii?Q?BRPmY2Erh2ZVYX6KDc0Sf7++EneykqO4wvOutq7pLJ2WiZj78e/bKo92WiiH?=
 =?us-ascii?Q?iKJ0jh2RwDjoDbb2KvzAFFodP7Y3wiD1wVK0PkBFNRwIE5YdTWUSj0M8rgMB?=
 =?us-ascii?Q?CfMaXenkfVh737O6omA6u5jJl4G44HBEVZeqzZVIfM4130lZodfJdVkOe3mT?=
 =?us-ascii?Q?CLiLMjryl8cjpsGchsRcCeqtd6XBFoGjAtlcY3V+MbtV4hQS5QLTuEa2flNO?=
 =?us-ascii?Q?2QmbAgBfvEPP8lMJ3RcpN9ShNtawSql9B+rc7PP6UTwxvNlV10d9S8LoQ8Qk?=
 =?us-ascii?Q?/+qbPK57ocZNQAWOG04CQvKpA1qR3f8f1KyvDVcVf2QLoCKxvPq0ImFsvWBH?=
 =?us-ascii?Q?YBbSEoFY3ZlK+zM2tQ7smoaEsWBDcWsi6Ri/4Nrq9hZEPbGBeKD3J1pPegmA?=
 =?us-ascii?Q?cZ7nXH7o4/GykUrw+BnIsmr0fQDocF7wNyy3FA7ltgrHfkaNft8RDpmFowtg?=
 =?us-ascii?Q?4uudXZNagRlxpA72Y6agfsHXbTPx9955wgZx7ApWb0g42drS1MQPwVaAzB23?=
 =?us-ascii?Q?veK8W4KkuEZXAC4a37KQ4xirfaPtsUHi05Jgn7NVtlCevwEB07McZwjksV5j?=
 =?us-ascii?Q?s4VAgaQSF5w/GkrJhJtLJRipiD6qS89AF8yJukzwk9LTh99qZm7gBfvIA4CC?=
 =?us-ascii?Q?ERhnZvksjbExyNhH5IV8QcpZZXEl2x8Oqfv+sIHsuN0OnfwK0uY+FSY8QvFn?=
 =?us-ascii?Q?bMg1LXrRnHeGAddP3i3o9Nb8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcf625de-6bd9-4bbe-f212-08d98a1d2bdf
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 05:33:35.1832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SBNQTreLYE5rJMj1NblVVntGUgWDI5mtpfKbZLBHwrXrcsMINbJ8gC6BYCrQTJxclP5Ch8x3usYKk0CTS8qJyRAIecTn2HiH/ZG9JfWpcww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1248
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10130 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110080031
X-Proofpoint-ORIG-GUID: _cU9gVVWYRoqNToKzp0pg-2u_g9-0ISq
X-Proofpoint-GUID: _cU9gVVWYRoqNToKzp0pg-2u_g9-0ISq
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 06:50:36PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable rc is being assigned a value that is never read, it is
> never accessed after the assignment. The assignment is redundant and
> can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/sfc/ptp.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
> index a39c5143b386..f5198d6a3d43 100644
> --- a/drivers/net/ethernet/sfc/ptp.c
> +++ b/drivers/net/ethernet/sfc/ptp.c
> @@ -1141,8 +1141,6 @@ static void efx_ptp_xmit_skb_mc(struct efx_nic *efx, struct sk_buff *skb)
>  
>  	skb_tstamp_tx(skb, &timestamps);
>  
> -	rc = 0;
> -

You can remove the initializer at the start of the function as well.

regards,
dan carpenter

