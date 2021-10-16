Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F3E430245
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 12:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237029AbhJPK6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 06:58:47 -0400
Received: from mail-bn8nam11on2043.outbound.protection.outlook.com ([40.107.236.43]:7777
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229832AbhJPK6q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Oct 2021 06:58:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LEGvVNFQC5B0sfCTDOAtp6pVBrAbtmV+hrFGfzHiTyQwYidYpoaCZN2QeIHjPq3kGSORaS/RlvaP9nss/vtpTuXNbd59kYKISFsT1g2N3sQyHSiYhMVwhsHb2DD0cy+BuQF+8tP/tX9Qyhv9s0mrpc/ZqHxofVsNfK1LxTutAVwXStt+jKb9yMPevZHQXccGMjllsF+x9lPkyiNRjjKXXfJUlSUVvg8Put56cF1bR/zBmIkGJIkQZcGISjN+1gtcKxc2cQ4M0cC9vPOlvbaKJSpyiGJ71sh6rA+o+86goSovaHQPLRKfSXaazY0tbGkcYvIS0FjdZeK4JjgR2LUwoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AUniiJ6OeGLbG1wAJSEpLFfBJJ74i9fSehgCxYgN2+c=;
 b=lj4npjBkxpcCsnc76EFC0RErF21uaZbb7hH9nbQ8lK9v5C3I41OKYapyL20TSgSNyQrwZ4jzbxaBmYWjKzJ9swymt99fo5DAJWcJG7ArVWr5S3YhxE5UYOSduV4lmOWN/BAJXcWtmuOCOp+ywlCOijXvzVPOj4r28UzFFHetEJIJDfLRmQqipfmIMbPFlCw5y28JLnyNW/rgss0OKAI/SkQKWp+B60cEGL4Fro97u+Q+4b1BzeNV+tZOSTJVYPDC+dfoT7jGEO9Wz0DiABojjh5TvugWWVPM/j+bnAN5jDDirYWAPVEf5htCKiaair7iU8ibQqzd13bOUD1cUkz+lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUniiJ6OeGLbG1wAJSEpLFfBJJ74i9fSehgCxYgN2+c=;
 b=PIz5G9by3kgNh9tIF0M/s2JcFADqltX4LJG0oWIGr8/5GDWdHrNFIUCrU5+zXW5Us/tm1HLryTOCwWC/CTYy4e4xm/hEHNy9R8nx7PgF4JzTvvH3S5oTeOXJoO7VWGpNzWbHaNv0qjA3yNVj6AigQ4OLp8y0Ar4NcrOa6ANWhEd+PoEmupckkQD+i9QLy0ngXgwOTWMIX10P+GhXRHCeR7UT2EB+FyZFGqdHnkqaP8r5dh/KnsG/NKYEpVI3rBSjOONogJlcoIZlpS8lXHuwJzKlB5B0M7eCqXCguMcLoeKEeFIBBY387j+puUvQvY6W7UEjYOihk0DITXqkmnVTRA==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5167.namprd12.prod.outlook.com (2603:10b6:5:396::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Sat, 16 Oct
 2021 10:56:36 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4608.018; Sat, 16 Oct 2021
 10:56:36 +0000
Message-ID: <badf4e55-ddeb-cfdd-4162-b8b9ae3fed04@nvidia.com>
Date:   Sat, 16 Oct 2021 13:56:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 net-next] net: make use of helper
 netif_is_bridge_master()
Content-Language: en-US
To:     Kyungrok Chung <acadx0@gmail.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20211016050439.2592877-1-acadx0@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211016050439.2592877-1-acadx0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0054.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::23) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.240.28] (213.179.129.39) by ZR0P278CA0054.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Sat, 16 Oct 2021 10:56:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69fc3f0d-b4a0-4459-7940-08d990939f76
X-MS-TrafficTypeDiagnostic: DM4PR12MB5167:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5167072F4BCE23C06DBEB117DFBA9@DM4PR12MB5167.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J3kT00u8s714I0t/388AlVjTwv+54M1VfbiCB9t7UnRXcO9QnoltfgMTtJWt93jSqYWr+lwwOzidNJsqHp7AULVRJjIFDf6vYfuzX+ddXIak2+nkHfp+8qzOLt8eOU/doH3DjEBdVhEsSS4yNRL4XTQgtigZCGyTrASBxfjcbBYY2egZDn0G5XQ5NaDUp73gNnL6mEJOSL6QbL5kvf4NR8dUfKuu3yiC9gjPJ5abVJUGDKfL/2B+AsMG4ApqLh5LRQhVFqGB+f1h2qfV43H5bcn2EJq5q1ldtdiKE6HSRi0BKgll86hN2bvuDylw3TS7UW5Eo/laiQd1NPrBRP5EMVG/vdwzkfE61Fg434FhRVYXBK1HBlzEla2Qze38V3iJT1ZeR7Z5g6fXrL760UIRBCnBK94J2u6qM67PA5qFYuMOuYtMnNoXeetyVRzIRi1EwYyhyAXPyO6xoMZZDuH4IVjzWwggsdgBxQebkV8KLPjOADZaNKtuLNIVmXI5fPsU1l2bepHiMVbh38dILKMtoJ9m/kQ8BLDNpCI/1/rpTnhMz/wo9RZhSE1QXTogGiLtntQtKMR6wYA1Ebl8Sw7zComVpLhk+afjk+yt207NN7fWKUn1cvsR+tVNANEQ4wuvlvDCLFbFoO+EWwj2cDWTX3bG2w97XZQR2p+MUXlfFf8aq38kYziTRZeeS6V34O9Uj4y5lMIbB75sWKfCT0kUg1OQfL+YxGXm95J559o9P9IIwiCuezPP6dDro18FRvcwwRMNAu8y7K6dK8TNFBrWzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(31696002)(16576012)(956004)(38100700002)(921005)(5660300002)(83380400001)(186003)(31686004)(2616005)(53546011)(8676002)(6486002)(508600001)(2906002)(7416002)(66946007)(66556008)(66476007)(86362001)(36756003)(110136005)(4326008)(8936002)(26005)(6666004)(781001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTMxY1BEVmV2dEU1Z1dpOHRFSXU5RTU4Qyt2dXdDVVVJUXkwVHo3eXdvUm5R?=
 =?utf-8?B?UkIrYjhoUG10c3JUbFh2bTVWTm5PMjAwOFFmMjZib05OQnVFSkxPRFA1bCtE?=
 =?utf-8?B?YXY1akVrcTVVYnBrc045WW5MWlM3R2lKWXpVT29Ha1ZGZ1YzWDVLUy9VQTgx?=
 =?utf-8?B?TnV5bFRQbGdJQkR5TTlXNzlISEpnVVBvYjRFdzdXNGVSNFNaRHdsT2hqZ0hq?=
 =?utf-8?B?TXVtbmRSTGhOTHI0U1BhYlkvTitUdWFxbFpBZStoUGJiNzl3aUxMbTVubTNp?=
 =?utf-8?B?TzN4S3BWLzcydWtSOGhCNi96elp1dlFQVlhPRENNK0JyMHg2NFJkTVM5OXdh?=
 =?utf-8?B?WWNUck1XeVZwVDdobGZ5bmxvdStBdW94MEVzbTRtSDZlTG1oTDduMkRiMnpt?=
 =?utf-8?B?RHBjTmtWNlhleVpQRU5EUkF1bW9OTU5GbUFObXVMdEtHbVU5Rmw1WExIWHAz?=
 =?utf-8?B?WldjT1RDV0R2ajB0c2VHZnk4dGdja0ozcmx5UXJaQ1JlMDdVTW5JQ0ZVanhH?=
 =?utf-8?B?VVVNSDZiTHRCQXpRSWNlSGJxcERmNUdhdGNpeWpPMjNwd0pFSm9xUzZLWUsv?=
 =?utf-8?B?ZUwycjNnMkRDejNnS2g0RmNobk9ieHZZQ0dwRlgwVnN4WlhKQnFzZllqTkJ1?=
 =?utf-8?B?RlpIVXZDeVZEakpSNHFUazlTOFhtSzZiOVFmRjl0d3BsZFVXb0wyTEJ0L2hW?=
 =?utf-8?B?b01DYXhjY2FtNm1nZjNGZ1FRWENmK28xejhWMVJwSnFvdk5IVUsxRU9TYXFy?=
 =?utf-8?B?S0loL29UVFVEcFJzazMxRzA5eWZQYVZKSU16U3pkV08veGo2VnB5eFptTCtP?=
 =?utf-8?B?dWEzeisxQjNxT2dwdmZFZElXbEhkOVNHZEpaN1ZndjhvSTIxRDcvbXBDVjdD?=
 =?utf-8?B?eUdDSVc2MzlqSWZWL3F2R2FCT2ptZmt4VXc1ZGpwMEc0U0w2TGdLelZ0azNs?=
 =?utf-8?B?eTlTbWExdXAzK0N5NkVwRHBRTk5ZR3ArQ2JzK01YRWhPLzZqdzhMMUNIUGdn?=
 =?utf-8?B?UllGRjhRMEI1dlVZNzh1T2RWUU11L2dlSmlFTWFtNHZWLzhsOStTZERTQ0l0?=
 =?utf-8?B?S1RZTHE4K1FVaWVTQldrMXlkb0tlMFpMMVdpckxjZHFrWnp3bkdGM0VJRVpl?=
 =?utf-8?B?Q3Y1blJxeWZWVTcvM1JsVm5WVFZ1V2xaM21OZzlNejVsMmg1MUZGay94ZGtn?=
 =?utf-8?B?VjdQbWZuRFNiU0xsMDU5Rmw4MGpRTmhHQnNDZVNPTmp0MGEySUM4OUdaQkp6?=
 =?utf-8?B?bVA4MTEreFg1a0tQUVpqdjFHWVh5aDhTSnN6UTNlQVkxMTY4UmVnY1ovbTBD?=
 =?utf-8?B?aG1Da3hxdHBCdkxLNmZOR3dpaC80ZmF6WVVVZGJmcDRKcXdvK1RWSDB3K3p3?=
 =?utf-8?B?VG1GL1pDUUZ1TVI5VGozWmJ4dFZHODZnMEl4ZW5LVjZDZy9lNEpsVG9ZcmhF?=
 =?utf-8?B?a2xEWnJXUnFyaElaUHh3cjhXQWluL2dOTk83SHF5VWFiK2hLY29uVVloeWpw?=
 =?utf-8?B?WkhlOFpTYWEzSkRlYUN3dXVFUmhleWdnRXlHS1JYWFgzSVE5bkZOZG1ZQTZ5?=
 =?utf-8?B?SFFFMDVXbzRyL1FNeG1FeXo1NWJHekFBV3BYRDBDTjRhTS9RWHdUUW9ZWS9z?=
 =?utf-8?B?dUJlZ2cwalZtblMzbW92YjZhcWU1RHJZZFQxbFc1ZVJDb1krRGx4MVBORVpX?=
 =?utf-8?B?V09QTFJVT2dsbE5lVmVYbk1qaTJwaUdaTEJUdThvREtMRVhGcGU3V3VMUWt1?=
 =?utf-8?Q?IAsrNbg4vJFJddryuxK3+JhB9uwoOD6IYR9PdZx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69fc3f0d-b4a0-4459-7940-08d990939f76
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2021 10:56:36.2705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e68Lp+naZFLSw7fdEhH/nVAqoQNSPbW0pfX7nyklLqOsZB+Ez47AiWvE5QVjf1jzSdOKme8HJHw4tDLSt3uz7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5167
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/10/2021 08:04, Kyungrok Chung wrote:
> Make use of netdev helper functions to improve code readability.
> Replace 'dev->priv_flags & IFF_EBRIDGE' with netif_is_bridge_master(dev).
> 
> Signed-off-by: Kyungrok Chung <acadx0@gmail.com>
> ---
> 
> v1->v2:
>   - Apply fixes to batman-adv, core too.
> 
>  net/batman-adv/multicast.c      | 2 +-
>  net/bridge/br.c                 | 4 ++--
>  net/bridge/br_fdb.c             | 6 +++---
>  net/bridge/br_if.c              | 2 +-
>  net/bridge/br_ioctl.c           | 2 +-
>  net/bridge/br_mdb.c             | 4 ++--
>  net/bridge/br_netfilter_hooks.c | 2 +-
>  net/bridge/br_netlink.c         | 4 ++--
>  net/core/rtnetlink.c            | 2 +-
>  9 files changed, 14 insertions(+), 14 deletions(-)
> 
[snip]
>  	err = br_afspec(br, p, afspec, RTM_DELLINK, &changed, NULL);
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 2dc1b209ba91..d3676666a529 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -4384,7 +4384,7 @@ static int rtnl_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
>  					continue;
>  
>  				if (br_dev != netdev_master_upper_dev_get(dev) &&
> -				    !(dev->priv_flags & IFF_EBRIDGE))
> +				    netif_is_bridge_master(dev))
>  					continue;
>  				cops = ops;
>  			}
> 

This looks wrong, the original check is if it's _not_ a bridge master.
