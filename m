Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336FA486654
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 15:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiAFOws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 09:52:48 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:34342 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231940AbiAFOwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 09:52:46 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 206DfVv5006304;
        Thu, 6 Jan 2022 14:52:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=b3kEKXIS/rFv6cORIsdnrQlq4R6zO+kp91GmjZH6kkE=;
 b=dPol1dYsmaCmy0XuNfoGPcaRqFGN8Y4s6nFbwlfkOwLLHJr0LKobq+nCYsgy0Xlvl68x
 mRUczVE72gBJqvqy+SiVbR2jZGm6+F9Y/2mfDdgRz8VlFoWNY+6tD6y5ryVuhJo674J7
 WrrDmfzdhGcXM9TqKvC052vLDX2gLDUyex2ENdtmkp6193eXhz+Ap0nihmdb8FuuLuKI
 Hf27204tS487HqLK3NK5nT15DsNJN29PJctG2ecGFM+KI1fEasrpfYHrLuu234NKJ089
 UGhtBnLTliIx40a28VpRwxV8dhMKwUtFCXNtAvOwpDUuc22tFiEzEsF95zT/s5yXhfXE zQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpm1qhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 14:52:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 206Epq4T132210;
        Thu, 6 Jan 2022 14:52:37 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2177.outbound.protection.outlook.com [104.47.73.177])
        by userp3030.oracle.com with ESMTP id 3ddmqcycr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 14:52:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVx3jYexl5Ou5IsGSREmrJdk088qbS8dHmZKWq3m1t3HuXOe0rEXIHivCMGPrFwKjYqv1LBSSTPkXNfsPQGS+iIez2pXCNiTgrG4cxESXqOM+b5x9wQwDGjF/BFVuypKCnGRo8Na3c55x+cR1rriOEScL/en0/n4bYVPsEZkGt1dxwE3fAz1e3MMPGKLl5H5sH2SKoo2L+tymFgnZeHIS5mOY+9avpKAaRklrFvxNYc6c2WrinPGMFjqW8LfutZ3zcVJzChtXZQuusDnUqTzSKwJBihSiTq5rwRrQAhE+Y/1umB3GKh3qlfiM3NSUisVl2+XJ3W6r108QtAv1reubQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3kEKXIS/rFv6cORIsdnrQlq4R6zO+kp91GmjZH6kkE=;
 b=k3cUEaBP8YOP+WOZhnmyxIE01Z+Syu2MaH2f+B3THGKKhNaWLBzQjiVZXV8xeqLfMAtG/kzRhT3kfs4s3YbWAoTJaBL/8X2Qgep0Vq5uHFZH29ug9ie/V5KLAb7+JYTjwUaaQ5uz9ytb1SXBo7+cCIHrhADjLDYBHQdGZJcjvoU1jqNvFBr6oYVyOXrGnpytKauXW0xZIlGz2NitZY4M+MjirAGmtNtcmoSmi0PHxTLsC5vWjb9brN/2K27ZXc9tyvxBHHXJKqf93ZGBIuQ4ToDdXYDQCVx05UeUDrULnRPGnY9FWcl21km5KAo7cBJ3cQsgTpialGDylm4VmrPtdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3kEKXIS/rFv6cORIsdnrQlq4R6zO+kp91GmjZH6kkE=;
 b=LQgDK46e/s+3Ld4S0D7pm0vpbpxH5GfJeiY+qMIM4w7kpHb7QhCfF/HSYMhnoECze+71OM5Q0nGv5TdthHaoAWkCwML0OgJUAncNly8x8K39xcBwfd5pC4gBjb6DTY46ZEuqQQl6vonNUW1tQk2s7IN6eBZx7RwsNQTbLpKXqSc=
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32) by CY4PR1001MB2328.namprd10.prod.outlook.com
 (2603:10b6:910:4a::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 6 Jan
 2022 14:52:34 +0000
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::38cc:f6b:de96:1e0e]) by CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::38cc:f6b:de96:1e0e%4]) with mapi id 15.20.4844.016; Thu, 6 Jan 2022
 14:52:34 +0000
Date:   Thu, 6 Jan 2022 17:52:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christoph Hellwig <hch@lst.de>, ralf@linux-mips.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netrom: fix copying in user data in nr_setsockopt
Message-ID: <20220106145211.GN7674@kadam>
References: <20220104092126.172508-1-hch@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104092126.172508-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0027.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::17)
 To CY4PR1001MB2358.namprd10.prod.outlook.com (2603:10b6:910:4a::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22a2d3a8-a618-4bec-f721-08d9d1242c64
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2328:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1001MB23286F8F3D61BD240428A4788E4C9@CY4PR1001MB2328.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t9iIcj7WLiSiBK7Pu6JzeCFwjgZyJmTbHJ+QbuFDlnoB7Rrxw8nTeKQwrnd9QWnT71POLyvD6TBrgwVs85izB1kSNqF574aUWu28NlWC/7EolNVGsaAjQOBWovBf4OBrH+OC2tSVbRaRoCnbrSfpdr3gmquBi63Rgkk6WcDAIpHJb7SmeUqkSCtgAZlKoJZJ2J6+3pHN2VAi1AShTk8qYrQfn2/0ZtdHd6dNkGIvVoUFXCZStk7GyaKO61B4hFHxUc0U893SqtPspEFuYw+5yta1NXM7Ls0LEPPQUVTwHApL9AjXP8G2/71HgfxLgfEDdnYUBdND9f6vipmOLsZRFWnXHMhT8/Gh2BUMxi4dLgUTRwclOFeF3Ds6KiHrQ6wCwHIIpUriDzh3SzxQx+u65kVH5t+kCGBkR43E4C+6DKLhOTL8j3T09S3A0zfGdqLfP4dmHKr6mZmV65cybJ5xD8TUyeFVnoDcOC94CRwbRbgM92NHW+GqID/2OTIdnQa3KZYzn7qnmKkrnit8jBN66iQsKQLwGryb9WnWRJYojOi6v2zrw20MAcqiM3Ex3zQ0VR3flG+a1305cZ6Uyi4X4hf3hdaJcL6XvVGNMahXz0B/F03eVNk+dog+5pI5nM9hybagVMd2VtGf7PTS5dlviTmORRnYrQaZHMVXHpkOQqo4s0kscGeCAPnmiVcxZ+aBwxL3KCU6zc6PwIj7318SXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2358.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8936002)(38100700002)(38350700002)(8676002)(44832011)(4326008)(508600001)(33656002)(33716001)(66946007)(66556008)(66476007)(83380400001)(5660300002)(2906002)(6506007)(1076003)(86362001)(316002)(26005)(9686003)(186003)(6512007)(6486002)(6666004)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ehgPQ7K4nadJdgcbu6u8vSXUMHeRXZknVfiwy1wV1uJAEKUy2zetMbRmKUQj?=
 =?us-ascii?Q?h9+qcA+Kc5yIazwqyzubK/HoenngyQARpZD2petfK1qsFZsvHJUFdYfJ64dA?=
 =?us-ascii?Q?mkYIWh5vWQCRXsr/l/AEbv7uPa40I1sdluiBHcHvZziVJ/G7yTkjP7CxGrru?=
 =?us-ascii?Q?+/iBatX031U83yc1TZiy2CmvWsNkzVEcDYfNCx5YggBjgAIZwyAlLK5hUGwb?=
 =?us-ascii?Q?ZFgSwN1jQphz7aib3KFZBCGx7FFQmYJVF8A7JG1iDh6FcXsT6o6ur/r9K0wr?=
 =?us-ascii?Q?1K367+W1UQwbqi3ClOWe/4HR7bJ5YniwSu0zCjoLQTiJaF9q7DlKfH3a/BeZ?=
 =?us-ascii?Q?Pmz7mnL2kh6000Aif5SmPi9WdCjFe7Ap36B6g5J+ubNTAk7obMpmW9M+BoZi?=
 =?us-ascii?Q?F/MXWK88Nv4fbp2U0qUxPbugZDc4izt1At/BzDTz6TUP8BmhusjAZH7pQcMs?=
 =?us-ascii?Q?0QpCYpEcRqfmWr1obIJl07oZuUH6db1s3zALjGVbjooPPiIdl5uiJ/M1y7D/?=
 =?us-ascii?Q?D1HR79JTBGc4eqG90flBnFErYHaTecWxhNVvqJTBwZiSHVN4yZLCRK9nUdSs?=
 =?us-ascii?Q?EWrmr93EzLGqGVKZ4gY6G2Bg8OiuIHgFxnqJH2eTwBBBXDfP9gZQx2dlrFdN?=
 =?us-ascii?Q?/m90sDHbdhR9nQ2FRkdb7XkHEdtUwCIcrzDituD8ibP8wLjgLc2a7kVfVve8?=
 =?us-ascii?Q?CGVI09d0V9Ir8oIgxxEyqh/ZDGatpn1xClYdH80Gz9FrQnnf5rfJRj4Qy6uQ?=
 =?us-ascii?Q?Ny/d8JiY8PrGWFNqLI5GPU+09qgiIEIO0BSvgY0GX4asHz2ODh0W56u0gDxE?=
 =?us-ascii?Q?LLJo+MWPqc9bWRfkunC9g9Z9oPRwEpXEkNFQ2/X55q/UZgL5ZK/OCRyLpuh4?=
 =?us-ascii?Q?uo+EtIceH3z/qy1WJS+ZCQnGyVFUEpKJG+mkzSc9UOZCNpUK4ZcRt4IrnasM?=
 =?us-ascii?Q?FmCQX7JBEaFgxAdsJqDptdf+lf1nVC6tvdrxeIw7Sx+0yG/sPrab7zld44ti?=
 =?us-ascii?Q?UICBObZmtvMmg2imC4npE8Te3RWK5b+llghARzmhUF70IOWS0kReHlB3QCmB?=
 =?us-ascii?Q?fF0r7BK0V2daOOlaIsXPBm/aIXnQc5z1I6jjGALy9e9OF4cMaTTxQBW2e9+7?=
 =?us-ascii?Q?7s9JwrwWQ7PAirh6K7JnpekDaA4BYA45FXf/jWgVAlTovpbpVE9lmPXVWRoh?=
 =?us-ascii?Q?++n6KafJe/yxI7y1V+AX5wIAXGs5YCLtqbbBzmrsKT5/gafSgjWxZXVwnEe8?=
 =?us-ascii?Q?Mrj7zr9ekq6AYJJcjXoGzcZH0Aiut564od8hRDeA4tPFdo0aDk6Za9f2TlXM?=
 =?us-ascii?Q?Dolac3WeTqopJyNfkEv8G441BQyswHWJ4qUT2URKnp0KlROs4lAZeR1C1bab?=
 =?us-ascii?Q?y1I4Qld9ZmjXJFHpXp07S7CJItH9Vyyp44EOU0aG63AjhnaTHliATpypByZs?=
 =?us-ascii?Q?uTEB0ZunF4vGSqblasmvwfnsj5HtWfvJBIK/5tmC5bdEgXJh68PDY7nF474M?=
 =?us-ascii?Q?biXNbi66yBtp9geJGSWNEVMQBwJE1IjSCyG+ggsljq3jI6b3M2+ljTKFhALh?=
 =?us-ascii?Q?13H5wPj9mXFfEeuYstFSCLCKyA2vBJeB0EnUMm7K+64FzkDq7xj3krlGSR4s?=
 =?us-ascii?Q?mv1RwcV7aFd0tIFK+Q+QKt7MOUKLriucXtE64wlRDjvry0bmWaQTTtvXFpBF?=
 =?us-ascii?Q?LUjEpcwIYOfDtr1RonCfcOY8pOM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22a2d3a8-a618-4bec-f721-08d9d1242c64
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2358.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 14:52:34.5665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l0RkFA4R/NEdEeCZbHlOo1IL26fErSQDY7+91uyaHlgYzdreA21eoWw65CPeZf4QN/LM8e5pEhx+/r197ozAD9DE5sISbMrEXthW5O5Av3k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2328
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060104
X-Proofpoint-ORIG-GUID: lZtapFYP09QsdFXrNVeWIXLNTINWtegc
X-Proofpoint-GUID: lZtapFYP09QsdFXrNVeWIXLNTINWtegc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 10:21:26AM +0100, Christoph Hellwig wrote:
> This code used to copy in an unsigned long worth of data before
> the sockptr_t conversion, so restore that.
> 
> Fixes: a7b75c5a8c41 ("net: pass a sockptr_t into ->setsockopt")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  net/netrom/af_netrom.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
> index 775064cdd0ee4..f1ba7dd3d253d 100644
> --- a/net/netrom/af_netrom.c
> +++ b/net/netrom/af_netrom.c
> @@ -306,7 +306,7 @@ static int nr_setsockopt(struct socket *sock, int level, int optname,
>  	if (optlen < sizeof(unsigned int))
>  		return -EINVAL;
>  
> -	if (copy_from_sockptr(&opt, optval, sizeof(unsigned int)))
> +	if (copy_from_sockptr(&opt, optval, sizeof(unsigned long)))
>  		return -EFAULT;

No this isn't right.  In the original code, it copied an unsigned int.

	if (get_user(opt, (unsigned int __user *)optval))

The fix is to probably to change "opt" to an unsigned int.  I wonder if
I need to update all the integer overflow checks to from:

-	if (opt > ULONG_MAX / HZ)
+	if (opt > UINT_MAX / HZ)

...

Probably no one cares, right?  Ralf?

regards,
dan carpenter

