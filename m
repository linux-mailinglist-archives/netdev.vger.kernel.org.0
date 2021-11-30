Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5030146403F
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 22:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240739AbhK3VeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 16:34:23 -0500
Received: from mail-bn8nam12on2081.outbound.protection.outlook.com ([40.107.237.81]:51457
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230142AbhK3VeW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 16:34:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTP/Ek84yxv7SOPH8swIPXyiOcZSt8QPB9joSjCdQ4kCRm+Kehzgrzwdsis+3+7M9Tyg7tSnFvM819Xuwgv4oqbDoowKasla/86WeyKzEdVd2IsIzxmJQTsKDFIPJK5c4gmF1Cox6qq25c+98fTrZNkh2qlZ5Ed6ipAwpGLQFDbCww2gOgGEZ0ZYeygj+p18SlziFpeJ6CQVzuGT7dsfuoMNbV2H/skwbRYzPeM1AEjS+xbGIDYDhMzdtqCF8iA6HHeA2P/URi+zcsAWw+eyhPDF4+ETy6RplyfIEg4mYQPrTY2HFNMun8hiL6yInvhKsNzjEMvNQrLAjeFLtwNViA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Av527f0cg2DY4thegdDDbWxbG7xYO7oUMIzNak8tYEo=;
 b=CKKNfCn/CRofB1l8zHSY1W1fmfc9CzFATJN9qT9jHYCyzVvwDSVJ9wK7rFiVnePLh6h100yXGAzM0eNYtr7hvQKfbnhfEztcZrSjJhkpZlnsPZGi2MpWDXFgpO8CVYerDgEXDjG+CAad5aG9AxP3U39HOgIrw1yrjBuWrbHbLQyJX9c8r38AnHwUX/IA0AWOb4wH99YhZc9UVxW/pdsJV/5TTqTH//dq2JeI6Ck4/SZ4C39ivpcdZNqxOhlylITLAH10Yqbg0XFsTbro1+Te/G9Lk/3GZU87GJ7hUR+3lONjCvyGUM0HLymrEPHX/1rV3u7FV8t+qBWmLNNKA9c58A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Av527f0cg2DY4thegdDDbWxbG7xYO7oUMIzNak8tYEo=;
 b=dBcHpdAGVmPEnHMuDmsck6t6uRIosb35HxM4MV5ZANP+34UcLLLyD5wHMgBwoIL7PMfg8ae9g5ZE4okZCvQXMtpRGlm4Qjvt70ey/LpVHQVOMEPgh4rCphxdyghBLGbEhC0l8sbZCBhXdJ/tGrX12JPTKPk+MkgItg8yOVChUiVh9KoHNc44DkVawUPLrP5cCaIFj2TaV0+zuaw9O9sNa4KSKxmw7Z9x/apPQqZscn5fSFACSCJlBc9HvcWv2FMV27HHvq5jqhLFHVMWFDGCH/s9VWGK0D75YtkYpBO9AiE5idQGgkBoO8slrPFwR5xVZD9S7uPCf16ODtmzMTRcCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5264.namprd12.prod.outlook.com (2603:10b6:5:39c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Tue, 30 Nov
 2021 21:31:01 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::2c70:1b15:8a37:20df]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::2c70:1b15:8a37:20df%3]) with mapi id 15.20.4734.023; Tue, 30 Nov 2021
 21:31:01 +0000
Message-ID: <0a8c9c54-db43-8b72-61cf-8ebb60957f3b@nvidia.com>
Date:   Tue, 30 Nov 2021 23:30:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH net] net: ipv6: make fib6_nh_init properly clean after
 itself on error
Content-Language: en-US
To:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
References: <20211129141151.490533-1-razor@blackwall.org>
 <YaYbusXHbVQUXpmB@shredder> <0243bb47-4b5f-a1d7-ff63-adcb6504df8a@gmail.com>
 <3af9d2b1-4c18-1e11-aecd-9625be186bb1@nvidia.com>
 <55c48e77-439c-9f0c-f51e-7e944e9b5c1e@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <55c48e77-439c-9f0c-f51e-7e944e9b5c1e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0139.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::18) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.42] (213.179.129.39) by ZR0P278CA0139.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Tue, 30 Nov 2021 21:30:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a759abd5-ebc3-4a23-1311-08d9b448b46e
X-MS-TrafficTypeDiagnostic: DM4PR12MB5264:
X-Microsoft-Antispam-PRVS: <DM4PR12MB526475AE4FAA9A32942258FCDF679@DM4PR12MB5264.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rHEMu/uJCCvk0d9vGwGOsYTmfZL0JnG5XEcEbRAuQWDnNsQPAfDAWVn2eC/h5BqxXBy/qFqydlnxzmCAbESjyIesUXqbLsNV1DQwvboTYUNx3G9Avvzb4Jhc9/IlBTZoU4bD97dFDLikx9cGbUJyuykTIezOatOZJaITIW5c3nHIT5KQ47BN97pSITIMcMZyBZKL0wXUDPN5P8rS5asFGdVGMGLszvYHgti0x5bZdTSDpnEVcWZ7aW+79LzQHTj3e7F0Duy1/HDCKPEAulnqIiogOCgjGZufFizQX6fx0Rewb8wQK5Ek/raJfI4ejZ0/Yz591QVaMVpTqEMD2ecnyMr5iWZjXme5a56vhIGjPufjMc0wiMogy2wu+g2BUWyuxGBgQCod4ZPzc3HLN8vpkp4DyF9kXJw7I2a2I69AV4X5JxLgLsETK8WK+T+whggOqNVdFURkTMWHl2wNzax0LeicYdpQwgdVrsZp9F/qxxoC+BB51kY+E02UiFSk2LDgJhCTYrz62k5KTX6WeECv427xoXo5P/ny34yyaNQgIGT25v+TWlkvDxBh8NIYJwk0373R95hJXeVUR7dlK/VTA+ktsQhjnKFzXp0Rx1gqYpdiT1Qmb58X8MMENZzaZ4GuV4Gx9Z58z3OiPVSeoM8BtpZkDpZFQ6/4zAH99Ix2oBplDBnFXfb8aCJIX5NuTmex7qBhUVu97iRSO8/BjYv6j9fPohLkpPnlUdHBXMacM6v2pt3COZzIeyD8PPmlDm7q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(2616005)(2906002)(26005)(956004)(6666004)(66556008)(66946007)(66476007)(31696002)(186003)(53546011)(110136005)(316002)(8936002)(8676002)(36756003)(38100700002)(16576012)(31686004)(5660300002)(4326008)(86362001)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ancwajgzdTUzdzdoM0xsb0hESlI1dXVSdmdFRFd6R2xOQjBDL1BHMThhRnlq?=
 =?utf-8?B?RzRVQ2NCTkFCZXVlRUY5czVHV0RXN3JZdWUvS0tLVUpBT0drL2JNdC9STUY5?=
 =?utf-8?B?NUtoS0dBTzMveDVpU2dibDNLTGgrb0dBd1dmR05mM2hQVVVmV0wvRDNhREF2?=
 =?utf-8?B?cCtnRmRBbjBnWTV5Z0s3WWlrV3VRdEw2MG5nelVUTjNUVzRNY2lMLzl3SUlv?=
 =?utf-8?B?dnZ5MVAwREpEaHlrNkJSRFFCRmVKa01HS1lnczE5UE9xRUpqR3k2RElhMFU2?=
 =?utf-8?B?dlN1QzVKSHk2QzkwTG1KRS9mTjFDVzVHSEg1ZDZ3N0FnVVh1ZGsxa1o5dVA2?=
 =?utf-8?B?eFhLaVZ1Y1pGSVZwUXk3TU8xa2VQYTZZUkxtenRHZ2p0VlJVV213RGIyaU1K?=
 =?utf-8?B?K0xoR3ZMVzNaeVFLYk5mUTV1UENUeDR0TnlEbmRyVEloTFRHWUNTakQ5bUMv?=
 =?utf-8?B?amlJNGNLS2pGRFF0SDk5UzNUQTBWZUJQSUlLTnFwS1p2QnRaclRudkxtVkZM?=
 =?utf-8?B?U0c3MWJlcmwxQ2daZTVIQUhpSUZEc0NtNWI4R3diSmRObjd1YllsV2xEZjkx?=
 =?utf-8?B?Vk05RTQ3WHR2aUFncTlMZS9sbkwvM1dkS09xZEVuMThGUWkwQUpFYUx2MDBo?=
 =?utf-8?B?eUR6QlI3TzJSRGt4ZDN6NmxmR3FEMFpkWmhJSDhtODI0VFhiN1VDYTVzRysv?=
 =?utf-8?B?bnhWYXQxTm8xZmV1dzU5czJuOTBIRHROUmV1ODN6MnpDVXJwUTFtSGUvVDlC?=
 =?utf-8?B?Z0JzcEZFcExxSnFMY2RhMk9wdlo4RmlRRUdqbWoxNU5oQ0VaTC96dVhmRHh1?=
 =?utf-8?B?SmVwN2dQNWhydlp5WjViY0JhVmp2VTlzVXhvM3MzTFIyYXRYeGR2QnJ0Z1B1?=
 =?utf-8?B?b1RDZDI4S3Q1WTg4RyttOW1tTnhpY0gyaFhQQVVLR3p2MXZzT3NsOHdhYVJa?=
 =?utf-8?B?aWtFSzkwQ1B0dUhFTjVROXZVV21aZnFTL3ZNV2JScjhMTkJCcGlEa1ZqYkV4?=
 =?utf-8?B?eGNHRHNlMld5YnNaQlF0U1dZRzFTUHFnTHV5a1JCU0dIdHJxSlVCU211NWps?=
 =?utf-8?B?NEdoamlONkpaemZkZDFaRmoxVWhGcDUwY3pMNUF4cUkzTlY4WktWbnp2YkJq?=
 =?utf-8?B?WkdQWFI0UUlHTWkraXZpa2xmeUpqbnRFbmlvTHRiTGYzN1lQVGlXREh3cmZ5?=
 =?utf-8?B?TzNVTU5YQWtqd2g1VTNuUjlCTkpmNmFJRjNRRU1pN0ZsaksrNy8rSXpPV2hq?=
 =?utf-8?B?VmIra1VNankwekQwUTI1MWhYOFR1MkZqUkR6Q3VLY2JzdEFPclBDZ1ltVjQy?=
 =?utf-8?B?ZXg4M3djeERvWldUWHplTU16RUJ6azJDOHJnMHRwRGxOVFJiLzlVOGg5MWlR?=
 =?utf-8?B?OVdzbVVHMSs4Zk4vbWdMZkxPM2xuc3FXbVRjdTFTVHVuSDRZeGs4TjdrUzYy?=
 =?utf-8?B?V3JpSXBiT3Q5MkRpVzkvYXVmSFVFSXFucTNYL1Jvcmk3eHVaclBxSXBvYU5U?=
 =?utf-8?B?VnNTNk84RzlxNFpQSWEwYzVkQmhZWlpWdi94aisyUTFKM2dndEcyZm5lZCsv?=
 =?utf-8?B?OEpsTFdYcTBlbnhiR0xmWWVFdE9VQXVLR2dMNUxmOWk0RldCUmRwUFo5SVVK?=
 =?utf-8?B?YkhZUDdvaEtVc05ncXNPaFphcFZxcjM0WDYvZ2hXb0xoR2RYNENvbG1qeHAy?=
 =?utf-8?B?T3RLWFNGcGpVQ0p4emphcjFPYTh2ZDBZdGJpblNDVjEyQVk5NjlDdVJIQTlP?=
 =?utf-8?B?R29MeWxXM1QrZjIxeWJsVFNLcHZzWFpmR3Bodmlic0VtTVc3MmZqS0ZoaGlq?=
 =?utf-8?B?Mk5oeWs5MTZaMXIyS2YvcFN5YVg0Uzk2TVZhRHpXeGdWUzN0R3lsWW9sdlh2?=
 =?utf-8?B?RHZmVjY2KzBVQzNyOUo2eEJac1JKUGtyZnpsQ2xMSjdSV0tWZUlqdnRUYXVa?=
 =?utf-8?B?MzBndEJiOUhmejErUnJjVVF5MW5BYmFJa1BDR2M2WjFaYkhHTXhyMnZFOWtI?=
 =?utf-8?B?SmNCRVpNMjRHaERNUkNvbDlzVHVkUHYvZGdBMlUwdFl4b3BpOVNPL3RhR0hX?=
 =?utf-8?B?QlM3dDZXYlZudlJGTFltcG5CUjQxZWhJZitrc283bEZlZFJBUmhoUlEwd3F4?=
 =?utf-8?B?NHRCQWozRjdzd2k0U3o0RDJHM2I3MmVQM1k5ejR2NW9EM2ZQbTlCTkxrSHhM?=
 =?utf-8?Q?GHVSB0duUg86+JgTlds6viY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a759abd5-ebc3-4a23-1311-08d9b448b46e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 21:31:01.1405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qS0nLeaELHnWutgQsLsdtnrr1qguZ3UNNykgA/W+K86mEcWztccYB/MC/SJ5P2Q5cj9u7ZFMIGLKRlWnymOjeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5264
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/11/2021 19:18, David Ahern wrote:
> On 11/30/21 9:45 AM, Nikolay Aleksandrov wrote:
>> On 30/11/2021 18:01, David Ahern wrote:
>>> On 11/30/21 5:40 AM, Ido Schimmel wrote:
>>>> On Mon, Nov 29, 2021 at 04:11:51PM +0200, Nikolay Aleksandrov wrote:
>>>>> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
>>>>> index 5dbd4b5505eb..a7debafe8b90 100644
>>>>> --- a/net/ipv4/nexthop.c
>>>>> +++ b/net/ipv4/nexthop.c
>>>>> @@ -2565,14 +2565,8 @@ static int nh_create_ipv6(struct net *net,  struct nexthop *nh,
>>>>>  	/* sets nh_dev if successful */
>>>>>  	err = ipv6_stub->fib6_nh_init(net, fib6_nh, &fib6_cfg, GFP_KERNEL,
>>>>>  				      extack);
>>>>> -	if (err) {
>>>>> -		/* IPv6 is not enabled, don't call fib6_nh_release */
>>>>> -		if (err == -EAFNOSUPPORT)
>>>>> -			goto out;
>>>>> -		ipv6_stub->fib6_nh_release(fib6_nh);
>>>>> -	} else {
>>>>> +	if (!err)
>>>>>  		nh->nh_flags = fib6_nh->fib_nh_flags;
>>>>> -	}
>>>>>  out:
>>>>>  	return err;
>>>>>  }
>>>>
>>>> This hunk looks good
>>>
>>> agreed, but it should be a no-op now so this should be a net-next
>>> cleanup patch.
>>>
>>
>> Actually it is needed, it's not a cleanup or noop. If fib6_nh_init fails after fib_nh_common_init
>> in the per-cpu allocation then fib6_nh->nh_common's pointers will still be there but
>> freed, so it will lead to double free. We have to NULL them when freeing if we want to avoid that.
> 
> fib6_nh_init should do proper cleanup if it hits an error. Your bug fix
> to get nhc_pcpu_rth_output freed should complete that. It can also set
> the value to NULL to avoid double free on any code path.
> 

Indeed, that's another way of achieving the same goal.

> 
>>
>>>>
>>>>> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
>>>>> index 42d60c76d30a..2107b13cc9ab 100644
>>>>> --- a/net/ipv6/route.c
>>>>> +++ b/net/ipv6/route.c
>>>>> @@ -3635,7 +3635,9 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
>>>>>  		in6_dev_put(idev);
>>>>>  
>>>>>  	if (err) {
>>>>> -		lwtstate_put(fib6_nh->fib_nh_lws);
>>>>> +		/* check if we failed after fib_nh_common_init() was called */
>>>>> +		if (fib6_nh->nh_common.nhc_pcpu_rth_output)
>>>>> +			fib_nh_common_release(&fib6_nh->nh_common);
>>>>>  		fib6_nh->fib_nh_lws = NULL;
>>>>>  		dev_put(dev);
>>>>>  	}
>>>>
>>>> Likewise
>>>
>>> this is a leak in the current code and should go through -net as a
>>> separate patch.
>>>
>>
>> Yep, this is the point of this patch. :)
>>
>>>>
>>>>> @@ -3822,7 +3824,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
>>>>>  	} else {
>>>>>  		err = fib6_nh_init(net, rt->fib6_nh, cfg, gfp_flags, extack);
>>>>>  		if (err)
>>>>> -			goto out;
>>>>> +			goto out_free;
>>>>>  
>>>>>  		fib6_nh = rt->fib6_nh;
>>>>>  
>>>>> @@ -3841,7 +3843,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
>>>>>  		if (!ipv6_chk_addr(net, &cfg->fc_prefsrc, dev, 0)) {
>>>>>  			NL_SET_ERR_MSG(extack, "Invalid source address");
>>>>>  			err = -EINVAL;
>>>>> -			goto out;
>>>>> +			goto out_free;
>>>>>  		}
>>>>>  		rt->fib6_prefsrc.addr = cfg->fc_prefsrc;
>>>>>  		rt->fib6_prefsrc.plen = 128;
>>>>> @@ -3849,12 +3851,13 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
>>>>>  		rt->fib6_prefsrc.plen = 0;
>>>>>  
>>>>>  	return rt;
>>>>> -out:
>>>>> -	fib6_info_release(rt);
>>>>> -	return ERR_PTR(err);
>>>>> +
>>>>>  out_free:
>>>>>  	ip_fib_metrics_put(rt->fib6_metrics);
>>>>> +	if (rt->nh)
>>>>> +		nexthop_put(rt->nh);
>>>>
>>>> Shouldn't this be above ip_fib_metrics_put() given nexthop_get() is
>>>> called after ip_fib_metrics_init() ?
>>>>
>>>> Also, shouldn't we call fib6_nh_release() if fib6_nh_init() succeeded
>>>> and we failed later?
>>>
>>> similarly I think this cleanup is a separate patch.
>>>
>>
>> Same thing, fib6_info_destroy_rcu -> fib6_nh_release would double-free the nh_common parts
>> if fib6_nh_init fails in the per-cpu allocation after fib_nh_common_init.
>> It is not a cleanup, but a result of the fix. If we want to keep it, we'll have to NULL
>> the nh_common parts when freeing them in fib_nh_common_release().
> 
> exactly. set it to NULL and make the -net patch as simple as possible
> 

Sure, of course. I'd prefer to make the code consistent w.r.t expectations regardless of
the release cycle, but I don't have a strong preference. I'll post the fix with
NULLing the nh_common pointers.

Cheers,
 Nik
