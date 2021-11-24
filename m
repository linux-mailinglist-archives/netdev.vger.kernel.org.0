Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304FF45B835
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 11:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241203AbhKXKVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 05:21:02 -0500
Received: from mail-bn1nam07on2067.outbound.protection.outlook.com ([40.107.212.67]:36351
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240105AbhKXKVB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 05:21:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pzv9WMA/k9P3KjXJRP8AVo69fvrGJnNi633xRvJzaSrGRSY2ZTT3K4XnRIvY4D30WBJ5VEHbdxc6mksCy0NPsVjfbYRkmWAZPMDylUBQhXxEb2OzO+s6XVjP4B9c/XHB9LwgWymNaADk5orT7Sq7ay5moY3cLvWfwzBTmC6pHDShiLcxZZ0L+nMVv2KNOfH+KIlXTvW5bTtHuuFUkFh4sDlk9T83a5+vu8gEgwrTXM59YILkDa/LZGg/nv4R0cyCFpXGczVb9qpb5o7iNZIs9b9SbzJCt2NB7SbaJinjNE2Iu75EtURTpMvziYrnCCkp1GVakmwsrXdw/5qYOoHg2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cfd+gc05nVYoH+2Sa9jrb1PmxNSwlvbR093ZAvwUYGw=;
 b=SGhuEK+XtoRKDE2X4YkQ+iksJXVDd/e+TUAGL0rCCJDYHjmyhiLa9qvj/hNMUD+PC2WUcMCuKInfpaYvq54KtukBZjvHby5j0ZNiiVWYDpuRG9eYx0KNCK0flhtBoBcQ6EIuFg4Msylx0izgh6qAYAlhzRYCXDFrvafXeLnjZdDyprhG2wJPI5QrAhelAEnPToo1lp/vSab1apjQUg/CLxdnuTTV5TTdfp7Gpuz5mZAGn5jhuGdDj/eU9C8FCRiUNTult1FIJh3ZWqOXGCcsqLIVmZsPn4T8MxRhF1aS8tU6WMVjWzg+fGApoNLXso45srxN7otmVzQbf/soWfLd6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cfd+gc05nVYoH+2Sa9jrb1PmxNSwlvbR093ZAvwUYGw=;
 b=Q0zN9Bvl2Cg2992XBVnQ+QRHL1dLYHqPR0UCr0mMQ9umjnVY13Cn/vSweE0QuFH89dnuixlWdtBNxjroIk4vAR7vzgAvQm72lJMTKCyRZX6/IiCOis/bpxIVAeex1Gh0uZRb4jTO5XkbJ1fI2DSGd8ePK2Vbocw5ypsuRXpqhbC0Tc6Oct+OSR82zYvm+Dd+p5dwUQhRv450xGdr9IpQK/N7JWlHFDCaztNOPsDbd1XvUuNyieOG8AoY1kVKUA07Huv7Ttx03Ivg4I8zBx+tJVizwJnwFUnRK/TzCGf3iLgucDFMdXfxW+vdhTozSLQJ5PzLCwBHr3jU73L4Djwixw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5414.namprd12.prod.outlook.com (2603:10b6:8:3e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21; Wed, 24 Nov
 2021 10:17:51 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%9]) with mapi id 15.20.4713.025; Wed, 24 Nov 2021
 10:17:51 +0000
Message-ID: <5701e4f9-8a0b-56f6-3741-48d8bb9e1b7c@nvidia.com>
Date:   Wed, 24 Nov 2021 12:17:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net-next] net: bridge: Allow base 16 inputs in sysfs
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        bernard@vivo.com, David.Laight@ACULAB.COM, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20211124101122.3321496-1-idosch@idosch.org>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211124101122.3321496-1-idosch@idosch.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0058.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::9) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.23] (213.179.129.39) by ZR0P278CA0058.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Wed, 24 Nov 2021 10:17:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ee12ea8-e02a-4c41-9d73-08d9af33ab9c
X-MS-TrafficTypeDiagnostic: DM8PR12MB5414:
X-Microsoft-Antispam-PRVS: <DM8PR12MB54147B45E14E12886FDE01EBDF619@DM8PR12MB5414.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v0UBP2wXY7ETqWxY9v/Oso8ZpDqCIl+qXKRXPkzlPopAzHCFvgZsV0AgplwB2qsXvUYVvWWdnRQCAJSGp6jtdxWXk3PZhHNTfaRZAL5JQ6q6n72rzgLzFonNnuDAGY3pIxf9PcAnLti1EyThEiqJxKORuAdI2xv1PrC2UdVpn/tZxuwtCNxcHRtJNrq7IbNRCy6a72dwJTl1DylwTgnJhnpriPh4g12AgqtEd3s5/+RjjaxXBNXQ0muQhtuNhTddSbc9Fy40clp4k/GuMH+Hv5afWscqqqtw7cGsX8KWFQ66C3J/ky1ycG9PIMnxCeg1L/W3ec7RFVZ6L1GL89EJOLocKkMsOgD799F21/KWhLvzTU1aLy7u4+3eB4RGy4/vkUS82pz08T0gZYXV0AyNGDWK3zCU3JfHI2DDLx2I/9Bel/kNnbwv854kKA4S8oDrYXsZzGIffT9JTyfYxmxOlOgNLrXKX25v49NIL/+m5tWo/s/fKkdG/b6xW8vUgKLhr3zg/S2miNbArMP0mFO9b+zWpE15dTk/Ajtd2529+rRS2YjNEgoBlVCw8JxEDxWiN3avXmpIui1p9UrisdJUBtwvWiV29Tab62nLrRqLWekzHgWY8ALUbY9bEKRU5sPeq2I10GfKqBZEO4BfcYWU5KwE0+kNZFpByJdAkS849ajMy26zTQF/Li89LpxeM/1Hq3F7OZoLyZ7XfqeTO1iZ60/uN49UC5PJe4BdIUe2mRECoTxXYTXYGb71pwmqOeTw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(53546011)(83380400001)(31686004)(107886003)(8676002)(5660300002)(6666004)(31696002)(36756003)(508600001)(86362001)(66476007)(6486002)(66556008)(8936002)(316002)(16576012)(26005)(186003)(2906002)(4326008)(956004)(2616005)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3ZaSkROZ3MxWjVIZmlHblhpVFZxSFA2YmdWMjNMQzdsSkxUWTN4aVpBY3Fu?=
 =?utf-8?B?ZUxmVWtONHhyYUtIbGpiNXZiTTJSZ0wyaDlZZHJoWWZjQUNXZytMZDhvS092?=
 =?utf-8?B?alJHMkwwU2lCN00wUG11T3dCczhZZ1NzamsxZURFZ09WN3l0NTYxTzM3bS9v?=
 =?utf-8?B?Q1R1U1gyUWJlNUpOT0RoM1djaWh2NFBpdG5TMTVabUlYNjFkd1NLbTU2OURB?=
 =?utf-8?B?djVZc09KMFRMR1plYUIycmFiN2IvSktKSjlzRlFyMTYrckVmbjArOVZSRTY4?=
 =?utf-8?B?OEZlUGp2Q2prcXhrdmVBVGlpT1EyYy95c3BTZlJ6bDc1Q3ZxeEl2ZjJXVjNy?=
 =?utf-8?B?aE5tN29aV2pienJpaDRYSDlsQUdtV1AwUnlKYWMrUVRvMVNYalJRK3JsU1hi?=
 =?utf-8?B?WkpuOVhoWk9ob1FvSVJSTEVBZHIwdmlOWDhjT2FiSTErN0RSVllndUs0UjEx?=
 =?utf-8?B?ZGt0T0RJSUMzR29SdXRHK3pOcXpjdnhmL0haU1g3UWpzeUpWMnJSNHhndmZr?=
 =?utf-8?B?Vzh3LzJoVnZuVnI4ZlAra3laVEtDWkMwbGUwVmRVbkVtWGE4Q1JsVzZ4bDli?=
 =?utf-8?B?S0RJSis3L2NKY1ZZTmlBZzNQRjNBUFZqTXpKaDJMd05WWmVLaHM2YXZtSkZW?=
 =?utf-8?B?MHJoNFVxcjFzUkFrdUVha1I5ajlVOVZVTXFlbVV3KzBjSlB1RnBLYXdEajY2?=
 =?utf-8?B?WlFlYkNBNnNxTmxMenNIaHgwSGhkNWJLL3QrM3NUR2tsaS9qakR1YUdBdnhM?=
 =?utf-8?B?a09oWTdBbTVSbW51enhzUmExcmRWRjVDL0lkU0RkUFNHZ1oxOEZQQ3dsek5o?=
 =?utf-8?B?cUdWODAwRGhlM2VUWjVaY2xIa3Q0b3FQTXFQazdHOVRjTjV5dW1pZHFKTTN0?=
 =?utf-8?B?MzVxVEFGNWRxeDZwaHZTWGkzSVlydFlSaE1NWDhWTlNGOTdBOFowMVQ2M1hZ?=
 =?utf-8?B?NDJrM243aUxjb1FGM0xhV1J5amE1QmQyNWtQSTQ0WkwyVUdhajZ6R0hYN1JR?=
 =?utf-8?B?a0lHMXNtQ1JkOW5WbU53OVJDcTlpQzdJQ1hkRXlrLzNJdHZxRE9VblZoZDVo?=
 =?utf-8?B?eG9DYm1Fd0orcnB1UW15NVdXVlR3VkF1UXNyOVdIRTg1TEJoaHVqcWEvUkRD?=
 =?utf-8?B?OEFEOXRoVnZ3NUVaclRsWGJTSDY4cTFQUkpFMXdRQ015dTdtSjJiMndnVDJq?=
 =?utf-8?B?cEdzOHFXMVFkRUVXYXFrUGd5MFN5aWlmZ3FhY0VFQytqT0hEZ0UzaktrRFlk?=
 =?utf-8?B?cTJJb2JFK1N3b2RaRW9qOXA1QXRpS3lxZ0NDRDFpYTBSNWNGc0tzcjNNdTZR?=
 =?utf-8?B?REdyU3g2M2FPVG5Wd0RHNW1QalpFTk1wc0p5b0JDNi9IVmRWK1ZyYk4wdy9L?=
 =?utf-8?B?ZVZDaHF2VmJZMFRlcE5GWU5EengvQkFmd0VTbWJlYm9WZTY1MHFWRjZyWUMr?=
 =?utf-8?B?TnNoYjJYQUdFMW5CVzFjL0FEc2JZM2h2WnI0eU1xWGxVbXlqTkF4RW92K29y?=
 =?utf-8?B?SXpDQkZjWGpCY2JXU0h6VVE4VkVVblJpSzVQODNXcmdTVzV2bGdrVVBkUlIv?=
 =?utf-8?B?SWgwVXAxY1c4SXhrYWdiV3pPRGNoeDZicEFWYkx0R3NJYmNhc0FJSXJaeW5P?=
 =?utf-8?B?RW8xUFlnUFZ5bTY4cnpZTVpxMis1N1ZoZXJwUzZXSWFRdGhuNEZDS0x4Nklz?=
 =?utf-8?B?Qzc0cExkbEhIeUcyL0NwTVdvRmgyZjgwcWpWU25QVUpvb1VQeGFoOEMxSGpy?=
 =?utf-8?B?bFdvRTJQd3lKNXhlNG14UkdKVzFBMWd5QTJ6SFpaajAxbUZlL1J1RTdmbC96?=
 =?utf-8?B?Q0U3NVAvcEZMei9DRjhScCtDalpKbEZvNmNxSjNuTC9KNmprdlgvUWcxWWVK?=
 =?utf-8?B?K0pWbFQrME1sT0JINnFYcVI1cVFJNFpOOXVDVXI1cmNCOEVsL1BZVVhYcXFO?=
 =?utf-8?B?QTR0SDlUSTc0UW85YlhZeHh2SGpRR28wSVlwSkl4K3BvUzl0RXhjMDMyL2JL?=
 =?utf-8?B?ejlLRjdhc2lBQlpJUWdhcG5VWXBVZm9IUEN1bk5ZN2FJR1ArSGFjTlhFcm1h?=
 =?utf-8?B?L0pHZWdpVHB6SXhHeVo0VStvYThzVkRzbmZVWFNNSVY1SDYvUWtFSzZKL0NO?=
 =?utf-8?B?a01JSVgwTlExQWJtN2hUMkJYdDhMektvcjVUWk9lbTFTdm12WGViYTJqU3Zr?=
 =?utf-8?Q?tAAYl9/vwNtwciKQjblb9Yc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ee12ea8-e02a-4c41-9d73-08d9af33ab9c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 10:17:50.9196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N+S33iloagoqQ8t47GEG4AI2DBwJke9qDl3JbVM1oNfmGvyEEZXF3Uc3ehQ2MJ71YC0bEAXPXOoNyVsrJyiJlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5414
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/11/2021 12:11, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Cited commit converted simple_strtoul() to kstrtoul() as suggested by
> the former's documentation. However, it also forced all the inputs to be
> decimal resulting in user space breakage.
> 
> Fix by setting the base to '0' so that the base is automatically
> detected.
> 
> Before:
> 
>  # ip link add name br0 type bridge vlan_filtering 1
>  # echo "0x88a8" > /sys/class/net/br0/bridge/vlan_protocol
>  bash: echo: write error: Invalid argument
> 
> After:
> 
>  # ip link add name br0 type bridge vlan_filtering 1
>  # echo "0x88a8" > /sys/class/net/br0/bridge/vlan_protocol
>  # echo $?
>  0
> 
> Fixes: 520fbdf7fb19 ("net/bridge: replace simple_strtoul to kstrtol")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---

Thank you for taking care of this.
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

>  net/bridge/br_sysfs_br.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
> index 11c490694296..159590d5c2af 100644
> --- a/net/bridge/br_sysfs_br.c
> +++ b/net/bridge/br_sysfs_br.c
> @@ -41,7 +41,7 @@ static ssize_t store_bridge_parm(struct device *d,
>  	if (!ns_capable(dev_net(br->dev)->user_ns, CAP_NET_ADMIN))
>  		return -EPERM;
>  
> -	err = kstrtoul(buf, 10, &val);
> +	err = kstrtoul(buf, 0, &val);
>  	if (err != 0)
>  		return err;
>  
> 

