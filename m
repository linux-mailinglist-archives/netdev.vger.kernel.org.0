Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F347430254
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 13:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244289AbhJPLOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 07:14:23 -0400
Received: from mail-mw2nam10on2063.outbound.protection.outlook.com ([40.107.94.63]:36321
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240148AbhJPLOW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Oct 2021 07:14:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGK2n1oU+ptgRM8kjqdKwRVOVco1YVNZqQXbPXuho3OXMSvQifzoiOf5xIKm9YH1KOBSRxKykLdcKq/F/JO9+lhucEpxJ+QftMdfaqQq6m3MtiyqcOjXQP6hFWTz1t1J2Z+jY9+TFzyGQFmSvAU5GdmWAoQF0VA4Wg0CcYpIbwYjXS/ISbP7BXkilbl4jKVCLhKsBdVrjyTThYEoYcjzXB9y/l6J6OTOTBqEvARtVczmstHI/FFTyuQMH/AdCS2TWHLwyH7FyYK7zHAdH+tgSgee5P5ADw7+t9x6dZIQ49wnMqqLjD6+ev1wS0rT7H+Tx3eTRzpp6x9YoV4FgqIC5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hOfqkCmEeDU7ngOA7+b2rXK2U/mDsU25DH39iAvs02g=;
 b=hwC8E+kyLgBn2/t6ydJTjhnQXHziUaE5cbDXskm8q5tvokrRaf2elfwnNtrCmukrrgBe2UWlTZpBLLn/IhSEHBlI3IJMIkWD7QB5rG59Fn8eYiFwZwiWHNSyTbEC7ZUA5K/s/MElf4S5FcrXlXN5oQGkF/Wcp8Cv6W//MYIe+gMyAPH8er8UUdYPRulWPwKz+xiuHNPn9Sbx5P5WNVmczOT9yEPD1alHWWc2+GurSgVjYbF6yloJK6XZWh12/3/sXX5VARJtwS6CZzzdTvUl+ePaYWg4Li3yTIfRDxGToZ36GWE67aGLFKOmc8yq5+jfrW7L/MEML2r1YfgzdkrjDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hOfqkCmEeDU7ngOA7+b2rXK2U/mDsU25DH39iAvs02g=;
 b=koIbtxqB9FBC780DxSDPs7D4wXIILEmskLEu/rq4iHJGvVVH/c6PMceIwFpLgzSjHSqOYcVKHiVhPxwJXHmJVIGb7+6vrc2+xI0J3QTLys3XQk0TQ86uMG8LRotkVDdznW2QOcJ0RSyMGj8YbSiaQy9i6i6rnItg6pzhyzL4PcxA6IicqCuHHfxgm0+OJpX9akyy4N4H9oYovHQpXCesfv6egqeIqfA2660bjk+w7urB5Iwz4kPqSHCB4oOip/j95ZFtm4hJ3UjvGK4Oo9fAjttz9wtGF7J9A/jWqzRzR5DPrR4C5vWuzwxCxsSD9Lf2E0LBdiXGGH4tbjn3VJaqGA==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5056.namprd12.prod.outlook.com (2603:10b6:5:38b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Sat, 16 Oct
 2021 11:12:13 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4608.018; Sat, 16 Oct 2021
 11:12:13 +0000
Message-ID: <fc84cc7e-142f-48cb-2638-6cbc5b625782@nvidia.com>
Date:   Sat, 16 Oct 2021 14:12:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3] net: neighbour: introduce EVICT_NOCARRIER table option
Content-Language: en-US
To:     James Prestwood <prestwoj@gmail.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Chinmay Agarwal <chinagar@codeaurora.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Tong Zhu <zhutong@amazon.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@codeaurora.org>
References: <20211015200648.297373-1-prestwoj@gmail.com>
 <20211015200648.297373-2-prestwoj@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211015200648.297373-2-prestwoj@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0144.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::23) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.240.28] (213.179.129.39) by ZR0P278CA0144.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Sat, 16 Oct 2021 11:12:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e68cd5d-6ad0-460a-338c-08d99095ce2c
X-MS-TrafficTypeDiagnostic: DM4PR12MB5056:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB505685D24D263A00E8B1DF3DDFBA9@DM4PR12MB5056.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q3OIPdo7X+It4Inur30x6Neh+tJN2eJzv4jhFzq5SzCKBfdCcm3D2aqb+m1r3lDtp4ImhgLJJsE5ZapS9SCfMkorU6XxAnXml1V9lrnf/HZOvaPfZ2cJuJBNtF3YFIxvc+oJm1XeLsGA6WbYZIfs9lfkI8aR4y8DC5jZTr7Lp24armZvUr2+G6V6f4QIlh0yT/uG8CHW9Z4JBrKpHBQkcyEfYILBn5s+UcTgRJWnPNh61KJQ5iQZbR3UPNVwbYCQVa+h0SYxdxYHdwosNBPrOjGMjqTkgC5BKeX3fCt8567FeYqyAq8kcycpimtajx/2ZNU5Hxte+SH+au2+pFDTC/cFIABS19TpEfAKymOPGJLT0j8KeG8hOI9GAufYuCjUjK3GrcNq5UmOtCUqGLg9REoR4w2DvzXr59LUggqa56M9EDaYu/wwSKPR+WKV9iBX8dhkz6lwmq92bmAeQTEfTrhxosQsVWU1o27eUBHXrIDTADDnzGh4h6lbpS+kmsoGLHI+lEot/AfdRhWn1ZnNMZ8PkQ6QSds/1apePde8xBinKkx0DfAEAMkA+69TK8oGpfo7iFX2UAo3n1PNhhXg6MJnmuln09u0jRUvFr1/LOz1dnZYEYWh8cBDNbiGzUWzYgHG5jachcpt9HlFAvCIKHMW24aR+ARe8RM6htOWs8EzVgmy2vsO/b/5XzpDoIRivIbYuh1ZrixEYOM4Mjr16iy+nWyIxunWbezJO6PTKXU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(8936002)(38100700002)(36756003)(31686004)(8676002)(5660300002)(26005)(6666004)(508600001)(2906002)(53546011)(6486002)(316002)(66476007)(54906003)(2616005)(956004)(16576012)(86362001)(66946007)(7416002)(186003)(31696002)(4326008)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVNySlFwQ2s4ZC8vVFVpc0FEcmIwQnk1ekswQ3dkbllCbGVNYmNNUEFJR3g0?=
 =?utf-8?B?NS96VjR1WnJFSU51KzZuK1hnamNCaVMrK3VCRlA1WWtpRWlZamVjUVRDZm9k?=
 =?utf-8?B?MndnL0dudmROWFhXMGkyc3hiZ25rbHJBczU2bElub2xrcjgwajV0ekQ5UlRQ?=
 =?utf-8?B?bXdDbnJyMDV3SDF2cW84OEN1Yjh4M3RxM2xXQ2ZqRHV6ZzVFbVl0RkxjanpF?=
 =?utf-8?B?cE1nSkZTaEZHMFBzSms3M1FiSjl3cktUN1hiTkJZaWZVendzMXFNcHJmSnhi?=
 =?utf-8?B?U3AwRTAzWnRBMldDNWcvdk5VVWk5YW04OHdYNVRpLzFWN3NDbTFaS3RmaDhC?=
 =?utf-8?B?ODJBWDhiOVBWa2xrejl5T2FFL0dNblJuWG5oYXNlNkpRcEtGdUs0eUViQmhi?=
 =?utf-8?B?SzRRUHROWUhrQ3dBZGQyRE5pR3dybkpzYjY2cHc3YklEcFl2Y2VKeHE3UlE4?=
 =?utf-8?B?MUdQMzIrV3ptWWpXeUhHSS8wV1k5cXR6QlNjOVE1TXRTQm9OM0N6aUUvTXVr?=
 =?utf-8?B?V3JMYnhlVUtZQTUvMmxSTzdiNWhzdXBpOHc0K1pMcERmK2c0bmZCenEzQkZO?=
 =?utf-8?B?STFKVVI5RDlUY3FEVjV1dE5MYWpaSGpuMUNQQU5EQ3JHaHlLNXdYYXVFRnFX?=
 =?utf-8?B?MzdyUGZwZk1FQjQxWWVCcHFJZ1dDTXNhQ3BWUmlxbUF6SmN1cGkvT20rU1V0?=
 =?utf-8?B?RlRIcXdLNG1ZOVIxY0ptRGxEUHN4dUlMVjFZVTUwcUpEUENZblo3ZnJPakox?=
 =?utf-8?B?RmI2QjNsR2ExWFVIcWNHa09hVlpUNEtKQkdDaFIybFNyeVk2Nit5ZXIrZXFn?=
 =?utf-8?B?UUVlWVdZeTlxTFZCUEpnNXhSNEk5M3dMZ2F6aCs5ZTJJTjhFTFdNZ040Zk1E?=
 =?utf-8?B?RTRaeWl6T09wcVJJek82bm9WMTRLbFk1U2hkS3Q2MG56STZDbDc5dDVkTmpF?=
 =?utf-8?B?ZFdLZDd5VWdNSTN3bmlOeFlmU0JPdzdkZDBYd1pmd1RlckhuZUxuSWt6My94?=
 =?utf-8?B?MVNucEFxVHNkclgxck9WR1IxKzJHajh3OXphcXlJZjVYdDh2UFpQT3NMVG5M?=
 =?utf-8?B?ZDFNTFg3YWNnMXVpMDlMRjI2V1Q2dVBMWUhXRXh2cm9ubWFwTGk5S1FZYzBP?=
 =?utf-8?B?VnBFT0c0Q1dkZHdjU1BqL3cwemVDd052OGJkdTdWR1hFN1ZhTStoSURzSG1O?=
 =?utf-8?B?WmZ2RUYvajZwdTNyR21lbkRBZ2ZOQXNjTWYzOHNJcElpTm85QUZoUVhvc3lF?=
 =?utf-8?B?WXNsVnNvdHRSQkFsTnlzdTFhS0h6KzI4dmJ4blJDT1BxdkhDQTNIdDArOE9j?=
 =?utf-8?B?dm42eHVXYmpISWxBREpWTHdwMzk0KzRMUkJDUjNNaTI3N3RPS1hxN2VESXhH?=
 =?utf-8?B?VE5kcThKUzRETUFnblU3U1hCY3dNcndMbm5yVWJNNFJzVFJGbkxRQktDa3Qr?=
 =?utf-8?B?eDVKb3BRR25ZVmVzMXRSZFlWT2lOVTU2eGFVTmhtRXE3OHhZQnYvOUdZS3Rk?=
 =?utf-8?B?endVcFBKTWtPUE5QYnJzd1JIdVc0c3RKbTBDNXdZL0w2YXNNa1RtcjlrUjNt?=
 =?utf-8?B?NDE1YWdKMGFWYTFHWGZKbHV4ZWd5cVRYVWRJMDFML3lCSWJEd0pNYWxsTDNh?=
 =?utf-8?B?ZmhXNGlvOU15MXZheVhZOGptQlcyU1U1dytpcHcwbnNMc251RHROTUliZUFP?=
 =?utf-8?B?RlM3TFZxNW5BdEt3QjZqUkVhVDJCaVdDVzBlZUt0dS9WQUQwVkNWMEZDdjFE?=
 =?utf-8?Q?/yiUiLYNgkaeeAXHobggfyaYisTVoP74tzpKDxi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e68cd5d-6ad0-460a-338c-08d99095ce2c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2021 11:12:13.5346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p7UpKpyxiH5/XwinEEZxxFjl3Y+ZrrLYhes1pOGIgtVzy0AYVhbwE6cTwJsCrj2gzDvqUkRmFSTr/1mi4veyUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5056
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/10/2021 23:06, James Prestwood wrote:
> This adds an option to ARP/NDISC tables that clears the table on
> NOCARRIER events. The default option (1) maintains existing
> behavior.
> 
> Clearing the ARP cache on NOCARRIER is relatively new, introduced by:
[snip]
> Signed-off-by: James Prestwood <prestwoj@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.rst |  9 +++++++++
>  include/net/neighbour.h                |  3 ++-
>  include/uapi/linux/neighbour.h         |  1 +
>  net/core/neighbour.c                   | 18 +++++++++++++-----
>  net/ipv4/arp.c                         |  1 +
>  net/ipv6/ndisc.c                       |  1 +
>  6 files changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 16b8bf72feaf..e2aced01905a 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -200,6 +200,15 @@ neigh/default/unres_qlen - INTEGER
>  
>  	Default: 101
>  
> +neigh/default/evict_nocarrier - BOOLEAN
> +	Clears the neighbor cache on NOCARRIER events. This option is important
> +	for wireless devices where the cache should not be cleared when roaming
> +	between access points on the same network. In most cases this should
> +	remain as the default (1).
> +
> +	- 1 - (default): Clear the neighbor cache on NOCARRIER events
> +	- 0 - Do not clear neighbor cache on NOCARRIER events
> +
>  mtu_expires - INTEGER
>  	Time, in seconds, that cached PMTU information is kept.
>  
> diff --git a/include/net/neighbour.h b/include/net/neighbour.h
> index e8e48be66755..71b28f83c3d3 100644
> --- a/include/net/neighbour.h
> +++ b/include/net/neighbour.h
> @@ -54,7 +54,8 @@ enum {
>  	NEIGH_VAR_ANYCAST_DELAY,
>  	NEIGH_VAR_PROXY_DELAY,
>  	NEIGH_VAR_LOCKTIME,
> -#define NEIGH_VAR_DATA_MAX (NEIGH_VAR_LOCKTIME + 1)
> +	NEIGH_VAR_EVICT_NOCARRIER,
> +#define NEIGH_VAR_DATA_MAX (NEIGH_VAR_EVICT_NOCARRIER + 1)
>  	/* Following are used as a second way to access one of the above */
>  	NEIGH_VAR_QUEUE_LEN, /* same data as NEIGH_VAR_QUEUE_LEN_BYTES */
>  	NEIGH_VAR_RETRANS_TIME_MS, /* same data as NEIGH_VAR_RETRANS_TIME */
> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> index db05fb55055e..4322e5f42646 100644
> --- a/include/uapi/linux/neighbour.h
> +++ b/include/uapi/linux/neighbour.h
> @@ -151,6 +151,7 @@ enum {
>  	NDTPA_LOCKTIME,			/* u64, msecs */
>  	NDTPA_QUEUE_LENBYTES,		/* u32 */
>  	NDTPA_MCAST_REPROBES,		/* u32 */
> +	NDTPA_EVICT_NOCARRIER,		/* u8 */
>  	NDTPA_PAD,
>  	__NDTPA_MAX
>  };

I think this should be the last attribute (after PAD).

Since this is a single patch you don't really need a cover letter, you can add the version
changes below ---. Also your cover letter says v2 and the patch says v3.

Cheers,
 Nik

