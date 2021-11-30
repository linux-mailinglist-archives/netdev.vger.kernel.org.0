Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38159463C21
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 17:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238459AbhK3Qsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 11:48:39 -0500
Received: from mail-bn7nam10on2057.outbound.protection.outlook.com ([40.107.92.57]:23552
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233320AbhK3Qsh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 11:48:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNG/vW7GcKFSXpeLRGPlEHZNaKwVVXgs7ZqpI241cLkBtijfSlg1cwPv/TykA4FdXUZI/xQ2Zf/zWepGwZhPxZVrBzbmHa9rmJtTwdBVty8IG919smn5rjjiwOZ0kbgnkc15AlpxABfu7K8MDat/8RWJesETzGHIFVelTvnyZec8y0lOq4POei4sSXcBVvy0WS51wV9R0KNev+7BzXHc0PpqtNbT63HSfTkd9UzxGWfw3I756kXOfT1dTjREeMJfoqBMrZkgAijM1XTWFXcwph6e4as1Q8Ce18x6BHG4yNuZHBSWK2Q+X1f6vLfecxmUwdfB6xffj7dMTys8ddm00Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HNAR+Oynb+qC59j9WL6cYoLuLqX29XkMujbb743sNAc=;
 b=Yoel3yx+4QDURZWOnoPxUcyjAL/WBpSwVfe4t0l4TqZzQh2sD6v9x3MCvGP8D28sUERj+esMuQxIxXB0LhJm/zGyNJVgbfQXIX/qrj/3x6zvjAgyYqU2xQ7RVIXny6HIpjbf9nj36mWysE1Sj+SeNP98l1AzDbSQczC6VL/6vEY6XyB3011ms9T9euzywO49eZJT/7iJwqxOu0WmYAaRLZhx7C5sSD3LUR3mJXh8+0UAaIS7pmgqt0zqpp6gJ2dBFAxpHWWlrCKqhfpIrJR++bn8pJFA6Ea3OHoKPd2OekGZCGtItZPfOl9jU6+l89dU5DPWeUzfy9K9cJkrHrrKzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNAR+Oynb+qC59j9WL6cYoLuLqX29XkMujbb743sNAc=;
 b=dzb7UagKVk2Sh6kYco39s4z6+cRiaWz181cVQrAvNVZGBujlyNFGToTqNcIQ+Kl4nUVYfda2jIiSKJwq3ixg94HsCLzOVPivWtgz+WjoAVz36idWVKEClfGyf9Gp2sXW7kmQo90rqmLFQnuy0F0W/7SFZzm0gSI1+58SlUuN1hmJWUSQD2zUQjbWCsLOE6/mtl6X146k/IBPJTWRLbP3YIwkBTfL6NxXTMMEMFCBjhjrZ7HLnsDlFcMV89Q3is17TUGHicreXxG8/GNNZ13utxq5CrLyIj4MfzApMNnMUYxtKHob9fVEYBKmYNZ+GjW9qJPoAy1MSH9XEuCTXuBV9g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5374.namprd12.prod.outlook.com (2603:10b6:5:39a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 30 Nov
 2021 16:45:17 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::2c70:1b15:8a37:20df]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::2c70:1b15:8a37:20df%3]) with mapi id 15.20.4734.023; Tue, 30 Nov 2021
 16:45:17 +0000
Message-ID: <3af9d2b1-4c18-1e11-aecd-9625be186bb1@nvidia.com>
Date:   Tue, 30 Nov 2021 18:45:09 +0200
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
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <0243bb47-4b5f-a1d7-ff63-adcb6504df8a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0034.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::21) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.42] (213.179.129.39) by ZR0P278CA0034.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Tue, 30 Nov 2021 16:45:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fdea743b-4d47-4ef2-3d4e-08d9b420c9c1
X-MS-TrafficTypeDiagnostic: DM4PR12MB5374:
X-Microsoft-Antispam-PRVS: <DM4PR12MB53740974966373338C91E67ADF679@DM4PR12MB5374.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VqmXA3TVuIj4b7234VYzxEC5pZMdo32LBj9iXkNOs6CbP6xanucxwcZL57y9i4kj0iId5UldhuZln1b/5JRVpswkcYOcb+NgH1agFDQM66oRlO0hJqmh08tvvMLYjZ8UglFNEb8hSdqJRKvq3fQ0bQ9lQfp5yRuujjbR5HTHpkiGPdASxQU7Ym0x3ubQ4nlmm3hWtwABEUjb570GOE4/lX9UaJl2VFjBe+BdOSQRK8n4F/ubaX4p06Fhg1qbpy1/kxBonuzfhSeXu0oNzi/flv2ICgsNjKG5hTZsx8yg9qEblowWmLXaBQQx1i6bw27JGVVK2hG694zrapPxwyfxrQqmQiHAhlg1wxJ8undcfdjh/1DPgx99QbhIneT301uVrHoHdSbCS1OB4gB0tlYcMWOfzd7skvtYdYmafckzpzyoIsutkwLJpMOnxJZKJoMDnfZ3nl3ilV57GInvwMlj9DcBJik12FDVTSNdq4vvL/WNlPVjDTM5nKuCO8NKp/6g8rWKyyF737Y+5UF7rP4PtEh945MTXrK6cQZKKXxx43AJVQanMYAKmuiGaYdkWJ9qmox7jK4WCb1h9CJga4doL32zz13osSM6auNRuujdFZCePC8jTOaVQFDmApP6eu7R3+BL33Lccp1ChBcfdAFo8rhr/b1AtETkH2blAFgqHLGuJdK+PpDzHe528UNd10VrG6gIpQZx7iPuShQKXGXBwT8SvT4e5tATRbCmrSq1UvHds+qI56Qt+xV9pHGPrTrz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(5660300002)(956004)(6486002)(66476007)(110136005)(66946007)(8936002)(2906002)(26005)(66556008)(36756003)(31696002)(53546011)(8676002)(31686004)(186003)(4326008)(38100700002)(508600001)(316002)(16576012)(86362001)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVd3VzdHWU5qS2tDRUg2NjlGdVlWUTluM2Z5ZFgzbEVVelVmT2pKMWZtMTJ3?=
 =?utf-8?B?N042U2xPOEIzTUU5ZmhHaHlKakZFeFZVSUhINWppc0hFdENTZTdhT1RVZGNL?=
 =?utf-8?B?U2tuUGZBUFhFbHNYZFNyUTkwOGNnTC9oSk5yd0pEVGs4TzcvMEdlSXFGclRZ?=
 =?utf-8?B?ZkFIUzJDTW9VSlI1cDcxb2RyYW5jejIrSW5kQ2xKdHFVeFdWQ2FlekI0eFhX?=
 =?utf-8?B?d09HTVJabU5mNE5NUmZYOEw2L09MdFphb2I5VEc0b1VTZDZicUJuSG9UVWFO?=
 =?utf-8?B?bHQ0b2tXSit1ZlpYamN6RUFxc05EUkpTbU1rSUNDRklQMDhBK2pwV091VTJk?=
 =?utf-8?B?TTNWNHBBTmNTdFVyM0k3NWFVeXg1UGRyZmxBb3gydFZ4RWRiSllQMGZIYWdn?=
 =?utf-8?B?MnhjeXBSM2VLZ2pLNkxmbDIyYVh0RmtOcmkzQ0NBL1ZzeFIrdU8xSEFkQlI4?=
 =?utf-8?B?VU9jbitmVDRkTXltTzdRa0FvT2dhUFhPMzVMT3dlQURXZGhBYXRna011MFFr?=
 =?utf-8?B?cGFnay9sSUFlL3FhNGw2UHRHbTJsS0IxdDhBS0xwL3RQbUZsejVCYnJNUUpM?=
 =?utf-8?B?YVhlbVlWa1J0TncvMVlIL1JwdHJVNE5EQjB3U3M4UWcycjcyZDRFYjFOMVFC?=
 =?utf-8?B?UWpUZ05SZjRQeWhIdGdiNGk4amVJTFBIRVhoTVFaaC9lZnA5VGNNRUN0TE1n?=
 =?utf-8?B?WDNuZ2UyeWd6MC9RcWNoYndCMTM2ajhReG8vUDBlWFJsR0J4WkQxdFNOUDVi?=
 =?utf-8?B?UUFlb0V0SWFNUURrb3JDTDN5S1REVCtDUEx4bFQ4TDY5L252dXVtMU5ONWpt?=
 =?utf-8?B?T1N1UjRGVkxXUnZtTmZsVjJQQzZBTHArM1JKVFY3M0lZNTRUTURQUnV6ZG96?=
 =?utf-8?B?b2NtUklLTFJJc0hTOXdWcjd1SUwwNE9Lby8xd0NadDRpeWFnMmJNaFN4MWMx?=
 =?utf-8?B?dElxd3Q4bkdqVTdqaUhZeW5HZGh3ZHUzZ2NESStOMFA5YS9Tc2xaYjFIU3Nt?=
 =?utf-8?B?T2JZNWVIN2htSzh3N3h1d2RWeTdNZElZOHdMMlVuQVpkS2pXcnVSVDF0ZDlZ?=
 =?utf-8?B?bGpXL2RvbTdLeUk3dEhuUlRLWXRoRmhYV1U5NFA2NkJEZ1lyendsNzJRWWxl?=
 =?utf-8?B?V2RGSitLZlZMTmNFcU9tTkdSY1pOWjcybHBWaElldlFYQmlzTlluU3BPRE90?=
 =?utf-8?B?ZzduZFNoaWFjaUhkbDBXbmNneGhMR0hnV0xURUZ5ZG5aaUlkcS90aWxMcEpt?=
 =?utf-8?B?dmhuT1p1Nm11NG5UZEtXUG9wdlhRK2ZiOXcvVlNGdXRLSS9IWlBXcTdYZVlm?=
 =?utf-8?B?S3c0bVhNREFZZngzMzZmSkg0VXUwemtiK2ladHZqVlJxV2diVVRYUUljZ1E3?=
 =?utf-8?B?d0padklRaHhXMUlQc1pGSFhhVVRjN1lhTzE5Z3lqNUhWekJzNjNyRHJrdXFH?=
 =?utf-8?B?TnV5Z3FZREpDWUN3aVNMSVRJVmp3VzJ2K1JYbG1XUjluZFN0bWNMb3N0K1Jj?=
 =?utf-8?B?akJkUVFpMjNtK1J2MDRmbTRGdjhFUDNialV5ek1oNmZwdTQ3Y0pyc2VJcXN6?=
 =?utf-8?B?T0RQbUZyYkxLa0Fac1BYYkFTS1NtdHpOU1k3dEtOV2pOd2owcVVocU5Jdi9R?=
 =?utf-8?B?RG9JYUVsTHYzeXZTQU5qazNZNGEyZ3d4dkVRWXRTQjFEYVlZQXo2SVR3dVB5?=
 =?utf-8?B?bUFBZW9EUHJ4MFY0KzdxclYvRy8rRWxiOHdIYUt3cVp2NXdReHY3aTVpM1lN?=
 =?utf-8?B?R0N2Uk5acjZCRzltR0lMTlpxOVQzRDFKVnE0NTBGQ3VEUW91VGRjZ0xOblNa?=
 =?utf-8?B?eEk1eUVmQU4vSFFmT3FONGVveUNyWUQ4Y0NuK0N1dm8xMjNJLytoWldub3NT?=
 =?utf-8?B?VFBpaDBpNTFqK1FPN0FqUmJ6STFSNllkZGJYSTdIOEZ5QUQyMXloaHdLY2Fp?=
 =?utf-8?B?TzdNU0ZXaXUvTTZjRmo1STRxZTJDWERBWlZqT1A3WTR3SUpFRnRHTTlIRWZZ?=
 =?utf-8?B?OS9NNGNXVGZyZVRGMGpHalJnb25QbzZHd1FjWFNvWHg2OGtsTXJONkVPQlFY?=
 =?utf-8?B?ZjJjTHRWTDdwMzUyL3ZMOGVPQ1kveFV3L21kQm94cDYyeDZaYXgzZVB6b0pB?=
 =?utf-8?B?SS9wVlhRVUU0VldNc3ljVk9kb04vM1kxRmluRkJJV0pXT0JVYUZqTDBHUS9U?=
 =?utf-8?Q?AHzbFUPTcNnrzlOKNY8oKB8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdea743b-4d47-4ef2-3d4e-08d9b420c9c1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 16:45:17.0635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lwe3oeOnodYXVQJfQgUcYG7KTd8zUbPQvj3jw6j9vOnc96E5TnRQQgb+P6Z27/h5Mgk2Ka1mB8T4aceXh4EPbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5374
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/11/2021 18:01, David Ahern wrote:
> On 11/30/21 5:40 AM, Ido Schimmel wrote:
>> On Mon, Nov 29, 2021 at 04:11:51PM +0200, Nikolay Aleksandrov wrote:
>>> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
>>> index 5dbd4b5505eb..a7debafe8b90 100644
>>> --- a/net/ipv4/nexthop.c
>>> +++ b/net/ipv4/nexthop.c
>>> @@ -2565,14 +2565,8 @@ static int nh_create_ipv6(struct net *net,  struct nexthop *nh,
>>>  	/* sets nh_dev if successful */
>>>  	err = ipv6_stub->fib6_nh_init(net, fib6_nh, &fib6_cfg, GFP_KERNEL,
>>>  				      extack);
>>> -	if (err) {
>>> -		/* IPv6 is not enabled, don't call fib6_nh_release */
>>> -		if (err == -EAFNOSUPPORT)
>>> -			goto out;
>>> -		ipv6_stub->fib6_nh_release(fib6_nh);
>>> -	} else {
>>> +	if (!err)
>>>  		nh->nh_flags = fib6_nh->fib_nh_flags;
>>> -	}
>>>  out:
>>>  	return err;
>>>  }
>>
>> This hunk looks good
> 
> agreed, but it should be a no-op now so this should be a net-next
> cleanup patch.
> 

Actually it is needed, it's not a cleanup or noop. If fib6_nh_init fails after fib_nh_common_init
in the per-cpu allocation then fib6_nh->nh_common's pointers will still be there but
freed, so it will lead to double free. We have to NULL them when freeing if we want to avoid that.

>>
>>> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
>>> index 42d60c76d30a..2107b13cc9ab 100644
>>> --- a/net/ipv6/route.c
>>> +++ b/net/ipv6/route.c
>>> @@ -3635,7 +3635,9 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
>>>  		in6_dev_put(idev);
>>>  
>>>  	if (err) {
>>> -		lwtstate_put(fib6_nh->fib_nh_lws);
>>> +		/* check if we failed after fib_nh_common_init() was called */
>>> +		if (fib6_nh->nh_common.nhc_pcpu_rth_output)
>>> +			fib_nh_common_release(&fib6_nh->nh_common);
>>>  		fib6_nh->fib_nh_lws = NULL;
>>>  		dev_put(dev);
>>>  	}
>>
>> Likewise
> 
> this is a leak in the current code and should go through -net as a
> separate patch.
> 

Yep, this is the point of this patch. :)

>>
>>> @@ -3822,7 +3824,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
>>>  	} else {
>>>  		err = fib6_nh_init(net, rt->fib6_nh, cfg, gfp_flags, extack);
>>>  		if (err)
>>> -			goto out;
>>> +			goto out_free;
>>>  
>>>  		fib6_nh = rt->fib6_nh;
>>>  
>>> @@ -3841,7 +3843,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
>>>  		if (!ipv6_chk_addr(net, &cfg->fc_prefsrc, dev, 0)) {
>>>  			NL_SET_ERR_MSG(extack, "Invalid source address");
>>>  			err = -EINVAL;
>>> -			goto out;
>>> +			goto out_free;
>>>  		}
>>>  		rt->fib6_prefsrc.addr = cfg->fc_prefsrc;
>>>  		rt->fib6_prefsrc.plen = 128;
>>> @@ -3849,12 +3851,13 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
>>>  		rt->fib6_prefsrc.plen = 0;
>>>  
>>>  	return rt;
>>> -out:
>>> -	fib6_info_release(rt);
>>> -	return ERR_PTR(err);
>>> +
>>>  out_free:
>>>  	ip_fib_metrics_put(rt->fib6_metrics);
>>> +	if (rt->nh)
>>> +		nexthop_put(rt->nh);
>>
>> Shouldn't this be above ip_fib_metrics_put() given nexthop_get() is
>> called after ip_fib_metrics_init() ?
>>
>> Also, shouldn't we call fib6_nh_release() if fib6_nh_init() succeeded
>> and we failed later?
> 
> similarly I think this cleanup is a separate patch.
> 

Same thing, fib6_info_destroy_rcu -> fib6_nh_release would double-free the nh_common parts
if fib6_nh_init fails in the per-cpu allocation after fib_nh_common_init.
It is not a cleanup, but a result of the fix. If we want to keep it, we'll have to NULL
the nh_common parts when freeing them in fib_nh_common_release().

> 
>>
>>>  	kfree(rt);
>>> +out:
>>>  	return ERR_PTR(err);
>>>  }
>>>  
>>> -- 
>>> 2.31.1
>>>
> 

