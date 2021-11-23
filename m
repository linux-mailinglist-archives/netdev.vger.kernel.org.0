Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17AC245A1CD
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 12:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbhKWLq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 06:46:28 -0500
Received: from mail-bn8nam11on2057.outbound.protection.outlook.com ([40.107.236.57]:7873
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232666AbhKWLq1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 06:46:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmyIhzvv02YFQbXMNy/8h/T3Alq5Xo+EUr6WrO1Oz4Z5yzuMcN7CSHw5/RDUZG0BOlU9o5ri+L0CCF1JAlR4uHuC7bjR0cxiLw+MPS31Vt+HlNmtHfs7eYHgUBrQvW4uIm4KxB9RKWikx/piJLOvpQv+9/SpIZrJaJkA4nvN7ngDdOYzLEyPnJAnfFqKTsyCXsRSe8yNQybgL4sIwZq4dXz/avpLoRiAeO+vb9HrZiT+ToEh01LIltdWtJHBAMEiSR2ZQaQfJwIlxJ2nK6iHF+nBg2IkQl1BUNqK2wDRHAltFHOxiO6KoxuVvg28SXdiy/iINjskA6J4sc6M1QCuEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C5NTWHUcscGG+UVBajRDyF1S91V0IdEjyi60pHtzc1Q=;
 b=WtKfXHd+uN/SBgSTqtOCgFW+Ceo5ynG04e539lSb3VtjhVP17UWMKmueyv593t4Cf3CocXX3NaQPntHDYVygSnxJbtmEqKHKkzs0LO7iT8vxSp+4oATdVSEK8zw7qKSOMFHqpMtFx0yVGlG2tkoFM+zUUUpAtYDwANAUhZJY11huLV2tjiKIoU5NM7RcKh9OF8MabULOBZ5FsvVUcdkTIALPX6cVPf55KMV7jfk9SLg1dlT9nYd/QykT2V1hwatfUSnYEk4nro8be4edcU8rNnhr3YP2vTQR5tOuDg2lgqNwubDaCpOvTPkCc54MV9jB20NtTXOOjEQUbrzdvH3sSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5NTWHUcscGG+UVBajRDyF1S91V0IdEjyi60pHtzc1Q=;
 b=nH3vvnVyDWajFlvt2UVP+0hBHs2tk7U7Jxh02/qLh5EUDq21gHY4Q9YRjpKxDyou8rVd4g/X/G2BBcEfPWm8hjXdQSG2mH2pAW+bdtO4O7JQ83VUnH983AXXWJFATMtvhRJAbx7yn+9YgyRHRLM12swzuu6E0liVHKRKrDkufBHt/flW+HjngZdOPgIriupQ60QCeABx/4mECLxIp7nm3rGdy6gSLMmiA7wNoB2IY7dvdQY9DT1WB2GFgUIrelE7b/ou795nZeRsFhODopqvp+rsjCR+pwEemFwc+HkPQQXFuM1YijCr3ceM3bsyitBEpQK+VW1CUS4RVWyGakOWOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5136.namprd12.prod.outlook.com (2603:10b6:5:393::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Tue, 23 Nov
 2021 11:43:18 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%9]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 11:43:18 +0000
Message-ID: <1255e120-cc25-ff45-7423-33c91d6900fd@nvidia.com>
Date:   Tue, 23 Nov 2021 13:43:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net] net: nexthop: fix null pointer dereference when IPv6
 is not enabled
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, stable@vger.kernel.org
References: <20211123102719.3085670-1-razor@blackwall.org>
 <YZzMAgIKFsCRjgc/@shredder> <f9ea69c2-495b-72c5-5327-22d6228d50d1@nvidia.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <f9ea69c2-495b-72c5-5327-22d6228d50d1@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0106.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::21) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.23] (213.179.129.39) by ZR0P278CA0106.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Tue, 23 Nov 2021 11:43:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0b01ee8-8178-4aa7-9ab5-08d9ae767176
X-MS-TrafficTypeDiagnostic: DM4PR12MB5136:
X-Microsoft-Antispam-PRVS: <DM4PR12MB513644B085FFD432DD73ADB2DF609@DM4PR12MB5136.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lFGvYdFjnYVK9OLMyCk7rYMtaLLZz+D9a99kk3IKyozo49unMVcT/NYliGfgEhEntfvuKBMiBsxp/gBIVYPkCztwJnCaE8TgxyxfDQpWPUChuqbd9WkWRE5Xc5FCPBLRFCCo+vrfA1gMF1D0eyJYL4ACYpiQQ60mU4WtZrBW7TC7kV+aFjG+PVZRMqOieFuw9wcVwSsQQasLeskrfX9XiagSUkEXT8Ogq20JPCGJFyKh5XkskxyhDOgN/fRtx09ZUuPpIcXenZqN63gY3eVMfK+b7TaX2B4YL1ZsWKyYYzBtyJjF4dZAWG+7PljovhVSpa4eCoVf3jtJ6+D+sGADm3zR6A+/SInw27nv83VSTOysg/HsaKojlKMzZe/JoBzg1vP0i+ITDALhCUl60Pyesr85zIVkLE45m9rKwN7S2rxSxLn2vIzjNkCEtzt5+NLJ0ZccdijEg/jZtcpZxSW+OuHjYXA9cw44gfGYbuaR8iAHKcbbh518hXFTIJscEB5n9/ov89/LfXkR/ckzXotrGMNgWwbpNYTVbfSnteMDhpPdxi0EvsSm18HwbjOpMF/vwUMY43T10+gdeZ24veZbvwK0TjItcAmQvolJPL+6o8XaYlP1j+WB+oPiCZx+kgOBctJUKvAzc/4qz+2DY8FZFK6j/oCbynwyPE9C6px0yohIeCkcy1M8l73sv1AOihosKJah5OkMZ5QVmWXseO+m+a1IRdoVlgNTJjflc8LOEsM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(31686004)(508600001)(16576012)(2616005)(2906002)(66556008)(36756003)(6486002)(5660300002)(66476007)(31696002)(956004)(4326008)(110136005)(66946007)(6666004)(26005)(53546011)(38100700002)(8936002)(8676002)(83380400001)(186003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGlqd012UEhsK29LUkZHQWJPc1liTllNbkdmcDBTVFVKWmZQWEhjVndkaXFi?=
 =?utf-8?B?bnZNU1Q3eVVKMUVydk1yVHZiS0Rtd1d2SkN0TDZDSTR2MjF4S296M3lPaWVv?=
 =?utf-8?B?MlVtZTYwK3FhOWM2QngwZFVMY3NTa3lSVHY3YVo5TjRyeDJJc0FkRXRHOTYx?=
 =?utf-8?B?WCtMWE5YSmtJTi9TK2JsNmZCM1pOUVdCcDNjdkE4N2JVRFdhRGNKZm5jdVJs?=
 =?utf-8?B?ZDg4U0xFZXk5elF5eVdJYVUzamY5RG9BMTdZdUZFQ2gwMXVTZTBxeDVoaGc1?=
 =?utf-8?B?NDR6a0l2Y3BtOW14QVlJS0RaWFBIK0hHY0ptVEttRGZLZU9mVUlpVjFwOGx1?=
 =?utf-8?B?RDNuckRwaTArTFAxaHhZNkNkZ0hlNFFTSTN0amxyWmNOY3NnalFQd2tYN2hk?=
 =?utf-8?B?RFRmMXpiWlVMSGZQRGdON2pYc3Vib2VyRk5IenAyQ1dCVzZvUGlUazVxWE5G?=
 =?utf-8?B?ZDUwRGlPNUQrb3p6bWZYa1MrK2FvTk5tN1I2K3ltSnFxME9JdUFGdFVYOWxD?=
 =?utf-8?B?dk9OaVVlLy9nTVVaSVJjOHZxdEM0L3IyOGtQaEJ2OU5hdGc4YTVhd1l0THV6?=
 =?utf-8?B?TTRkSnVTeURPVTh4YVpiaDljZlN2YkNJcUZlNXppNmFpM1BLNkkwUGtTUzBU?=
 =?utf-8?B?UzV2QUJTYTRTSzhoWlI0a3ByQTZYQVEzNjRPWW1kMTQxQzkrSXA5Y1dnZnpz?=
 =?utf-8?B?ekJ0U01wOURRV3Q0NDkxTnlDbTQza1dHczdZSkZzckROQTNBSThFWktFZzhJ?=
 =?utf-8?B?RVU0bGlpTDNnblRDYW1TTloxWmUwU2tsSDUwVlgrRkczUk9zblA0RzJ1aU9a?=
 =?utf-8?B?aU1WV3JPVWVaQ2xDWFFaK2FibzJEOTlFV3JSU2FKb24vc0FDaHMwendGSURH?=
 =?utf-8?B?OTNxMFFkM2pmQ1hCWEtwRjR0bEJndktOSkROTE5IbXlRTk9nVzhxdnNYcFNL?=
 =?utf-8?B?dHluVE91ZUFzNUxoN2RnZXRmMDJERStWVEdIYWkzblhKYndGWXlEbEJjb1Zj?=
 =?utf-8?B?TFY3WVNNUG90UmtjK2l1QmE2U3dadzJvOGhqdVczWm81ZTV0c244Zk54Z2Ro?=
 =?utf-8?B?c3BTZEhNMjdNYzBTajViNFI1aTdyMk5qSExGVVJpZGlXVTdMQ01QV2tZQVFN?=
 =?utf-8?B?NHB4OVA2cUNWR0k4Kzg1MHF1Ymp2RTN0YXFlNmVaY2JMTkU5SlFZbXhRYy91?=
 =?utf-8?B?Uy9OR1VzZnRjeGFLV1BQZnpwQlQxZUxlZGhCTVhUY0IzZzd0SEpkV3lYTjJs?=
 =?utf-8?B?N05WZTZZNnUyN3ExOEtqbGFNb01IVGdBRHgyWkpxZEdMQVZrYnNuN0pKclFX?=
 =?utf-8?B?amthd2wzNEQzb3Jrck01NmIrdnVVREdCeFVjbndsZXc2ZXZmNVNsUG5tVFFq?=
 =?utf-8?B?OVV4eDVlN3h5RGUybmNlWmluRXRwV2drWEJWeUFJa0F5MS9zUktNYWd5NVR2?=
 =?utf-8?B?aTlSMzV6YTBidEROTmh1NjJVYXlhaUNNY1RVSmdSWDJ6R0JsYjJkUEVwclU5?=
 =?utf-8?B?S09yUStFM2w4QWMxLzN4WlM4QmxaTlpwejJ4QmlzWi9qaHNPSkhsUjZnOFA5?=
 =?utf-8?B?R0gvZ3pVUDJ0bkdvLzJzTk1ZRlFEdXNwMEZyMko0WC9LakNmV3N6bVd0Y0FC?=
 =?utf-8?B?enF2ZmJoZUU2ZFYxdFJrZEI2OC9LbUJPYW9YbjZCMnpVUldybGZBRmZkUnpt?=
 =?utf-8?B?aUhGQVIwdWhtOHhoOVZ0TmwvSDkxU0cxSGZUNUVmYks5Q0R6Y3A5anA1dEty?=
 =?utf-8?B?VVdCb2dQRWJMQTJxMjBZY1RlMC9CbzQvRlUrOEpuYktBcm1mcEVlY1A0MVNr?=
 =?utf-8?B?d1NpbStnbnF0aTlFQ0hyMzFEU0ZaSWpRUDRENXZMWWFMU1M4T0JMc015RGN0?=
 =?utf-8?B?RFNENUZSSEQ2aFAwTEFoYmtCUU1PRTdYS1dQOGpMRHFaTlh1ZlZtL0JLb3NT?=
 =?utf-8?B?S3lRNjJkRTdKNnJQRzFpUlUxM0ZiZGN2bFNlNjhRYTQrajB3ZTVCNGtzTGdH?=
 =?utf-8?B?VWN3QzZsWUVqRWptSFdTS1lZdlBPWjkxdnRiNXp1TkRkVVRRRmJDOE1IOXpW?=
 =?utf-8?B?cUhjdUxoNkNwUmFCSVI1SjluemZsaVZTazNtSGhqRzRPZ0tiSXZZNnpYSjFm?=
 =?utf-8?B?UFhWL1hMenQzaDVPQWVTNXlpZ0lyd3d4MmpjNnc4OTVIdTkrcGI2bGNkRThm?=
 =?utf-8?Q?kahI1iDdxWc4ICaB3Ba8DhY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0b01ee8-8178-4aa7-9ab5-08d9ae767176
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 11:43:18.4808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xVU2Pjju8xo3QjVkOhUsVxy9cXuyZVy0BzDQJr7lgDoTpnxFC58pKF+HUfC3VC/8MRhGGt4KYCsOr0OuhtB5iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5136
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/11/2021 13:33, Nikolay Aleksandrov wrote:
> On 23/11/2021 13:09, Ido Schimmel wrote:
>> On Tue, Nov 23, 2021 at 12:27:19PM +0200, Nikolay Aleksandrov wrote:
>>> From: Nikolay Aleksandrov <nikolay@nvidia.com>
>>>
>>> When we try to add an IPv6 nexthop and IPv6 is not enabled
>>> (!CONFIG_IPV6) we'll hit a NULL pointer dereference[1] in the error path
>>> of nh_create_ipv6() due to calling ipv6_stub->fib6_nh_release. The bug
>>> has been present since the beginning of IPv6 nexthop gateway support.
>>> Commit 1aefd3de7bc6 ("ipv6: Add fib6_nh_init and release to stubs") tells
>>> us that only fib6_nh_init has a dummy stub because fib6_nh_release should
>>> not be called if fib6_nh_init returns an error, but the commit below added
>>> a call to ipv6_stub->fib6_nh_release in its error path. To fix it return
>>> the dummy stub's -EAFNOSUPPORT error directly without calling
>>> ipv6_stub->fib6_nh_release in nh_create_ipv6()'s error path.
>>
>> [...]
>>
>>> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
>>> index a69a9e76f99f..5dbd4b5505eb 100644
>>> --- a/net/ipv4/nexthop.c
>>> +++ b/net/ipv4/nexthop.c
>>> @@ -2565,11 +2565,15 @@ static int nh_create_ipv6(struct net *net,  struct nexthop *nh,
>>>  	/* sets nh_dev if successful */
>>>  	err = ipv6_stub->fib6_nh_init(net, fib6_nh, &fib6_cfg, GFP_KERNEL,
>>>  				      extack);
>>> -	if (err)
>>> +	if (err) {
>>> +		/* IPv6 is not enabled, don't call fib6_nh_release */
>>> +		if (err == -EAFNOSUPPORT)
>>> +			goto out;
>>>  		ipv6_stub->fib6_nh_release(fib6_nh);
>>
>> Is the call actually necessary? If fib6_nh_init() failed, then I believe
>> it should clean up after itself and not rely on fib6_nh_release().
>>
> 
> I think it doesn't do that, or at least not entirely. For example take the following
> sequence of events:
>  fib6_nh_init:
>  ...
>   err = fib_nh_common_init(net, &fib6_nh->nh_common, cfg->fc_encap,
>                                  cfg->fc_encap_type, cfg, gfp_flags, extack);
>   (passes)
> 
>   then after:
> 
>   fib6_nh->rt6i_pcpu = alloc_percpu_gfp(struct rt6_info *, gfp_flags);
>   if (!fib6_nh->rt6i_pcpu) {
>           err = -ENOMEM;
>           goto out;
>   }
>   (fails)
> 
> I don't see anything in the error path that would free the fib_nh_common_init() resources,
> i.e. nothing calls fib_nh_common_release(), which is called by fib6_nh_release().
> 
> By the way, I haven't checked but it looks like fib_check_nh_v6_gw() might leak memory if
> fib6_nh_init() fails like that unless I'm missing something.
> 
> That change might be doable, but much riskier because there is at least 1 call site which relies
> on fib6_info_release -> fib6_info_destroy_rcu() to call fib6_nh_release in its error path.
> 
> I'd prefer to fix these bugs in a straight-forward way and would go with the bigger
> change for fib6_nh_init() cleanup for net-next. WDYT ?
> 
> Cheers,
>  Nik
> 
> 

Just to let everyone know, me and Ido had a quick offline discussion about the issue, I'll
try to untangle the places which have different cleanup expectations of fib6_nh_init and
try to make it clean up after itself, as that would fix more bugs (e.g. the memory leak I
mentioned earlier) automatically. If the change is too risky or becomes bigger than expected
we can always continue with the simpler fixes for -net and clean it all up in net-next.

I'll update the thread soon.

Thanks,
 Nik


