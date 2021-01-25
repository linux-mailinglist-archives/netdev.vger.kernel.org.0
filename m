Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FDF303408
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbhAZFMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:12:38 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18451 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729158AbhAYN56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 08:57:58 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600e7fee0001>; Mon, 25 Jan 2021 00:23:10 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 08:23:10 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 08:23:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRIzna5MxioXIkwoRjZeCXHtxtvihe9vmWuoapqC1DjAPXNYKZOBymBgcOdThgrzdzccnHnycJH863PUhPKTsK4jWHPiylcTbaJOeR/drlg86Ck8A8XbKFZP0DkzBVZzQsLCn/1spGbgBW7zXEPT90QZFucReyDsR8G1AAz0ankSWAMzsLOTbrHtK2amYT0PBI94/dYlXHRbNmo1gXHq0ezUWgm1uadtBaMl953mUoqPnzyjsiTyVjKXovugb+chmBaH19Ydf0d3N3DRy+tys2tLxx79SE2DwGnaYVJg4i1WNhEls2edZTbZFe2sZ6+F17o12q4ONzbUyLfMWABRsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PIRuWXZCFHS5EcypCfN7alZbx+dHw8KfVNzh7RiZl98=;
 b=HhqMaOjS1qz3i4Lij3FIU/Gp6ccB0Q8y4law7H3l3wQ9xuRvq7pblRGlJN89U8rXztJjs7uS4mwyDsP9GZMCOTxjUuIVjcE/UEUBzyI6vt9WzFIdq4Fn9s1b+ob+sldDqvTYj2UwjZNMtW2FjlDnBwotpy/N+pzWbvejkKwP1MT4PTwTcdLCK/XG+q9TdNkMDlh5aTDhqDibMACQQvcz2LU0+C2XE3jJXw6uRehRYw8d7xSUPAYIL/Ukllbahrrq0Y3aQ2L9baP8UbSwhF7TIcMK6ktBrrjKPsHNL9GqvcTemcEF+JbFMWWioJ7hJuIXpJBcxq9kgPVnfUKNDRsE7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM5PR12MB1609.namprd12.prod.outlook.com (2603:10b6:4:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.12; Mon, 25 Jan
 2021 08:23:09 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::edba:d7b5:bd18:5704]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::edba:d7b5:bd18:5704%4]) with mapi id 15.20.3784.019; Mon, 25 Jan 2021
 08:23:08 +0000
Subject: Re: [PATCH] bridge: Use PTR_ERR_OR_ZERO instead if(IS_ERR(...)) +
 PTR_ERR
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>, <roopa@nvidia.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <natechancellor@gmail.com>, <ndesaulniers@google.com>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>
References: <1611542381-91178-1-git-send-email-abaci-bugfix@linux.alibaba.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <4c68f49c-a537-3f8f-73ed-5f243cb142a9@nvidia.com>
Date:   Mon, 25 Jan 2021 10:23:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <1611542381-91178-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0074.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::7) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.166] (213.179.129.39) by ZR0P278CA0074.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14 via Frontend Transport; Mon, 25 Jan 2021 08:23:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 523204d0-895c-4a83-8b69-08d8c10a7272
X-MS-TrafficTypeDiagnostic: DM5PR12MB1609:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1609562AAC1D0A6C1305A388DFBD0@DM5PR12MB1609.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FPS6BWn/jHEgFzzy5Uric6CE3uuW3ZLoWuzrrNRhPGB+ozz0kwosqFDAvZePsUKkeWNOMyfqJ5zpilol3B/r8wuyC7nQ5KV82Pj7lDKBLtVNjiug+QO8XQx2lLQKggs4X7v70jjUbqGpO6WPexheogLhNVuOsptpKcZ5CTROdz3MCtLy1OWnAPZObCbYgVOCpoYDc5pD0qHpY4y6qYDazcwrLa7NO0kcR+Oa2J57gf3QSA9UfVXhPe/VDlAWnvrDVlq1tm9Iygel9UjnP42SncM2X0nOA1JFGI60G/JX2ZiWouzbfEvDT+iqwiA9y4YtDIavtN27dk3GNw0xeWP0ZzUrHQZBKnvjm7H8CIOizOdZKN7laapuSxP0cJsCFdWCtWI3UJ9UT+8PGKf5trWjbsBXyqOEYd3mMMr9Ggq6LJ7aNGjPsMlMCuHtWJkwm6JZxEuY8r9i6pVvx4Tm73q4olI8ObZx6sNtTbM+tg9rpXk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(36756003)(6486002)(5660300002)(53546011)(86362001)(316002)(16526019)(26005)(66946007)(186003)(6636002)(66476007)(8676002)(31686004)(66556008)(8936002)(478600001)(6666004)(956004)(31696002)(2616005)(83380400001)(2906002)(4326008)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?M2J4WGtzVDF2YjBOOHFzUVZpS2xsVVBWMTRtbDNoeFBYNEVEbWo3RmF0bUcx?=
 =?utf-8?B?N1FIZGdzSTd3czMzM0dIM3haNVU0VzBrZTJ3YUFJS3l3Mm9iMmFFVHVhalNs?=
 =?utf-8?B?eEZmZnlySlZzT3kvL3NOU05vWmJ3MXdDNUtBbzh2NUxqSDB2cnh0U3oyZkJq?=
 =?utf-8?B?WTNueE84RWgyczdBdWYrcTg5S3gvQWxXSEMwU2JaMERyRURwTThXN2M0T1Rp?=
 =?utf-8?B?clBqME9UQ3l6aVBaTWgycnRvRW5vLzBvTEhnK3ZXOWhNUmI2dVYxeWpSbzNM?=
 =?utf-8?B?ZEtuWlV3d002Q01FRE51aXd1UzVRVTRmR2o3UE9YVUpreHk3TWJMRHRyQ1NB?=
 =?utf-8?B?SlZFdGY4b2xETVg5bUVSTFJ5ajJXNWtsZU1CbGdUQlJQdW5XT1duZVI2MW53?=
 =?utf-8?B?bnFxOWtjelVIK0pNem1zMWF3UWQ3QlF1TlJFQWVXUHdYd284R3hmcWkyRVFZ?=
 =?utf-8?B?QmJRVmJIandVL3MvRWpRQXRMYzA2VlZob1cwKzBsQ1RTb2tvTWZDZVBzQ1Jj?=
 =?utf-8?B?dTZ4ZDRDUW9FMFdlS2VxOWtDVTJ2bE1xeUhiamJtd09ndzlGOVFqdkptOGJO?=
 =?utf-8?B?aGJLd3E0YVErZTNsRThZc0FaREtaQ3FGNXAvS25xQ0h1dmxoYWI5SEJQVUha?=
 =?utf-8?B?MlJJZk4xN2QrQ09CZS85Qjd4Y3BxN3NBbGs0WWd0dmxselk3eVZzNE5MZXpH?=
 =?utf-8?B?RDFTK2Vldkk1c0lnd3F4VElOZkV1cTF1OEJGZFY1U1pKRmtqLzlETmlXRDho?=
 =?utf-8?B?S1c3TzVhdlZ6WFFMeDFra1cxNFpYRHc2WU9zS0dPUGtETktubkZiM3dVbm4z?=
 =?utf-8?B?ajJSd1htZ3lEeGg4WG40NVY5L29kMHl4cGxjbHg1WllTekVkbCs0VkxldUU1?=
 =?utf-8?B?aWYxVXUvY0Rkd0NLUXpyeWtqTWphY1pXcjdEVk5INnFBa2lDUi81T3h1ZUVo?=
 =?utf-8?B?UkZLeG1WZys3eHhwWWNtRU9YakVzbUhYbFNOc1ZQM0FYNUc5czV4UmZaTUQ2?=
 =?utf-8?B?dmhQREw0ZXkzZEFRQnMwLzg1RGdmbG1leVJYUTZSOW1NbThIL2FXdlNFcWh3?=
 =?utf-8?B?bnhGNVIrcVVmbks5SENGQWd5SkYwallzQW1OS1NVUTY0NlJZbE1xQ0h2Y0Vh?=
 =?utf-8?B?ZU5IMTFoc3VvY1VTdTZRK2c1bDZmdzNGc3l3d242ZzF5cDJvMUlFbE8xRGZS?=
 =?utf-8?B?dXIvKzFVdzYrdldZN2djSis0bUhEc0RYb09PN0M4TlpiWVplZjgzNXU5Syth?=
 =?utf-8?B?dlJjc0JRdExQbi9KWEkwVENNRS9oSHhZS2J5MWpoM1JQWlVKYkV2T0liUWx3?=
 =?utf-8?B?c0wvY0U1Nnp0MWRPMG5pMlpBbVY2NWVTK3ZtY2hiLy9aV0d5SnlwRnliZVBD?=
 =?utf-8?B?N0RwSWpqYW9TWTJDdmNYdW1ZdENXZlhaSkhtaFF0WWpldWxVdEd1a1c1S2pV?=
 =?utf-8?Q?3PWBhL9A?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 523204d0-895c-4a83-8b69-08d8c10a7272
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2021 08:23:08.8700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sDcmcSE8zWQcVfEuOeHno4TEyztas5QKlIhAh26NC0YCWPcDMJchhR0MAhidKxXQoIHcTBJ9EKzRACGXKH67Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1609
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611562990; bh=PIRuWXZCFHS5EcypCfN7alZbx+dHw8KfVNzh7RiZl98=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=MmD/eIM6JGtlNoaOOoP0+gYYHKGdqmH2PsZDqw8VTfowbQpflMj1OcOCW58d5eMHS
         BzkKVHBZOW2MwLBqtftcuOcac3dVAvdyrSfIOG+eVSeRmpc62RcmNnwlgt+XocK8fK
         JtCC1JhGDeofkQFK4b0mw4rJmN+5L/I8zCNF/vR/j7U0QVFAydsXMLavcDOOG++u/7
         BHSDklBT3VTk8am0ONzJPHPdM/AJelooD5JpWknWdtTwaiNHgECsim91FRvMhHyHs1
         uu+4haYcG1ttLlzmjJA64QT32LSPLUAG4iG+0lsDfGVCDBgzLprNv2x2k9jHj5/YXi
         wR1zwP2AveBAw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/01/2021 04:39, Jiapeng Zhong wrote:
> coccicheck suggested using PTR_ERR_OR_ZERO() and looking at the code.
> 
> Fix the following coccicheck warnings:
> 
> ./net/bridge/br_multicast.c:1295:7-13: WARNING: PTR_ERR_OR_ZERO can be
> used.
> 
> Reported-by: Abaci <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
> ---
>  net/bridge/br_multicast.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 257ac4e..2229d10 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -1292,7 +1292,7 @@ static int br_multicast_add_group(struct net_bridge *br,
>  	pg = __br_multicast_add_group(br, port, group, src, filter_mode,
>  				      igmpv2_mldv1, false);
>  	/* NULL is considered valid for host joined groups */
> -	err = IS_ERR(pg) ? PTR_ERR(pg) : 0;
> +	err = PTR_ERR_OR_ZERO(pg);
>  	spin_unlock(&br->multicast_lock);
>  
>  	return err;
> 

This should be targeted at net-next.
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>



