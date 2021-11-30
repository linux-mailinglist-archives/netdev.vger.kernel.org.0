Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3028B4634C6
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbhK3MwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:52:16 -0500
Received: from mail-dm6nam12on2062.outbound.protection.outlook.com ([40.107.243.62]:2785
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230150AbhK3MwM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 07:52:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVv5wIHTqWCi0O06PdxwCkByHxgtgVGmdGacmYs6dhiZzvLgRAfuHi8fBNi2XrcksUnW+UqdRzkgwgZ398yT1o+RzDMjctfZ094eqD26M5774RZKqWZSbVPo0g63XbtmDiAXVsB25GQPs/XO6TeChw0itvJzv8InxCq6QzkHaR+4ZkR0vJoynHsqqjvhnM/FuszNBjmungvdMQTWpUwHY3nEZZ0bRP29AcdAj2myJp2XZH6ieis4qFg22gUKhPw4bpfoLJlXmE5vaUuK1rJp4byS/AG0EHbsO57+TsvkW9eIfzP+crX12sHgTVYcDPrsWH8QEYcQ2qbgkcgJQPCxew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1RWXMWdFMpdjLUribMiPcZKelEifbfWFpkqS4BzW39Q=;
 b=N1EBKKVdmL9m3OOpIt1TD0SZVU4wBnksViFgrjyu5XtoqPS++1ZEMk0V87+yStmnxcX5ofokhjYDg1bI/Zp57C0pSSuR/eQJKmkEwvDvjysLDCHarhQ5E0SpbP7BmdFlyVM3oT6vD1uB1kp6lAySpUSe5Zxp9OlKHjMJLaWeHJR+VoNca6wdodj6FqQUJ5pc8HO8CuZdBKywDc4zacfvUA/s/EtpbBvw8calP8r4776rBK/YN+AN6xje3wEG3Dg6pYtHVN5SJSJuWxKtKSqadTHST4dCimo7QGa8v0SrIKy75RMnE0kTe4PhVGOECQ1/hyvK0g7DIkK68rsXjUpx3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1RWXMWdFMpdjLUribMiPcZKelEifbfWFpkqS4BzW39Q=;
 b=d+d+jcTRLHxFkPvVnXVmi3egyFMtubgIDsWIFq1ivOsY6aFVGwUp0s1heAjNDyigjDdKpCAW/oolSCm7j8qmz0KkcXXbxrvW5dVD55O+x2Ifn39g6xh23MrYVakMR4H6HBI+zX7n17kVfxrgozVwo+Keg3KX1YuFC2MaM7IgigkyV+2ZBagfTU8zfMRZQzoTxlUuZU3gIPrv5qz4gq+XnzTJI6PfhLM7SJU42A/JigwvX7ibW1gZdzQvr5seBWh9tkL30sVeZEdMEiiE9aOetqdf+NiI3/YyFDYLBuJeX/D3TSl/Povl1vHZU6OUocN4EJjD1i+xpPFWUWXqHeN7Bg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5248.namprd12.prod.outlook.com (2603:10b6:5:39c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Tue, 30 Nov
 2021 12:48:51 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::2c70:1b15:8a37:20df]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::2c70:1b15:8a37:20df%3]) with mapi id 15.20.4734.023; Tue, 30 Nov 2021
 12:48:51 +0000
Message-ID: <e1de9120-a86b-581a-3e61-382306a265fd@nvidia.com>
Date:   Tue, 30 Nov 2021 14:48:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH net] net: ipv6: make fib6_nh_init properly clean after
 itself on error
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com
References: <20211129141151.490533-1-razor@blackwall.org>
 <YaYbusXHbVQUXpmB@shredder>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <YaYbusXHbVQUXpmB@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0022.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::9) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.42] (213.179.129.39) by ZR0P278CA0022.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Tue, 30 Nov 2021 12:48:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78d1ba96-59f1-40b1-89e9-08d9b3ffc2aa
X-MS-TrafficTypeDiagnostic: DM4PR12MB5248:
X-Microsoft-Antispam-PRVS: <DM4PR12MB524853A744DD457C0515226ADF679@DM4PR12MB5248.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J15xPtPflClPdB3oINOtKdVnJZmx5+gZjbbBNNJs8Dg6iRo785Dpnfun2xCQ1b06zQsiPb2ZOrPpvMf2MGxLv2pfOhuD6wdFOENbwpPHgpE/jxLFn7hG/olWp5edgtMkz7T81Sl9iWDtjXCB2CLI31PtaVZ1efdeWBqcCBNPbkwb3eG82BwOZ8guXRyNyUuOY6mf4MtIdKqq80hkJBU67hRsoWKv7BDr4mzwRKUdWjntsy5ItE6UZWfK+W5Z1tjm3RO5sZmaCyiYfkrdp66anKXv2aOqZaGauSB6XN6SmJo8mp+YqbOWzYGsP7aUY9n/V5ISmGC7U+XAHdM/o2RBnxL0X6gKqN4/RV3Cx0sAiGjPRHFzrXhwdx78oJvo49QG7BK1AK0Mi9+JKtAbhlhnpB0sZrS3S30/3qQr0xzOz5VVXnNAQtaGemIJ/mh9Zzps4oUGcjUHKs+m1VqtDkUrXAsUtiYZFOWeyWFxA7XA8FsHc8q71kkIxBXaBcgHAUXLwM7kEOUC6OiiW2Savt2IDmSdoxH2MRJJYWuDy+H4Xxf88Vpj3GwTmQ9xQ/zrE1z6vGHrx7XsATtrq3ojvAbmwFId5uvdKUKyRTitXzxbl1Y76LIwBm3QQZMfppIv5C2OpwNjiS8rvK6Xw1MlDvkXEJRKSb/MvCFuBAGhvl5uHygYA+O1ID/xQwGIla4h3ZWUncQ7zRReF2Bk79DFI/qtxGgFUiOCCBzDOrb2BFoMoS0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6486002)(26005)(53546011)(316002)(66556008)(110136005)(5660300002)(16576012)(66476007)(2906002)(8676002)(8936002)(31686004)(508600001)(4326008)(956004)(2616005)(6666004)(38100700002)(36756003)(31696002)(86362001)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZG5TOWxxbU5iVUsxSWxLSnRqYXZjL0RjZW00SmdiNDZEVCtXeTBnTy90NTAr?=
 =?utf-8?B?UlB4Z3Fid3pnd2ZxMVBwZjNvaGVYU2V2c2dxM21XbjhPa2EwUXNWYWpyUnIz?=
 =?utf-8?B?QWJNRFdTRW1zSzhFeFNOaE4zeEMrcEtienNpSnE1SmM1U1RwQU5mRU15MW9E?=
 =?utf-8?B?dGRsamVUVHloQzNGMkRibEd2ZCtFSTEySENLWXFIZVBCc2twUG0ybnV1dFF4?=
 =?utf-8?B?VEt5ZmZTbnVlSlhrOWRwYnlhNmZLcmgwUkxOY1I2UzVyWE1KTGlJblFpL01H?=
 =?utf-8?B?NHBORVZsU0o0SHNxOFd6UmNUZit5cGN3elkveUtEVjdTTmx2OCtJN3NXWW9r?=
 =?utf-8?B?Ymc2NWk4T3NnYnB3dDZKdW4vdk82bE50M2lJREhUODFVRU15cG9iWWwzVG9n?=
 =?utf-8?B?OE5ob2VnaXlmWmdJcnlibkFRanlldkdWdmVKVm12OVJ0N1lETHV3dXRIQXMw?=
 =?utf-8?B?Ym9QSkwzOXJUVDJnMFBDZnlqYmt4WFh3ZHFFUzQ0WFlsTzArNGFYYTRzQ2Nu?=
 =?utf-8?B?WlVSNlhEa2JvTWk1MVc2MmVVUEszSm9BWEZzRGczK21XNkc2akQvWUxNTmNZ?=
 =?utf-8?B?d1VvREt3U25WUVlTWTZqaS9mdlJMWHU3SjhNU0VNbjRIM2kvZW85WVlDTTlj?=
 =?utf-8?B?Ty9tZXY5UmV4WnRTRW9aU3hWRGpONy9yVXByNFVlUnhTR3NCVUdFSEYvMEhQ?=
 =?utf-8?B?cWd6a3F6UDJ5d09STWpqUGNJZmFQRTFjMVNHYmFITzRGdDNlQUpOejgxeGw0?=
 =?utf-8?B?REdDV2tQZGZXbko1SXR0a25xN3loWTFGUFE0dlY1MUhIOVlwZG1zRFJ1Q3o0?=
 =?utf-8?B?c1ByRXlKN2hPMnRnRlpVT1dyWXZGbTBOMDlPYmRSalhGMzgyQ29jdWZESmx6?=
 =?utf-8?B?aytSOVBzTXhiSXFxSUNNZXJ2L0hOSTdnUGREVnl5Q1hra1crMXZMM2ROTnQv?=
 =?utf-8?B?V0k3MFdBLzZaNEpBZlYxMk8vNjFBRGRLMnNoa2QvRjhrc0NOeTdZSFVmUjhP?=
 =?utf-8?B?UVVVWG8ycEhmWFloeU1zZ3Z6cytnZDhITXFtcEppcEt4NktndE5PdjFYVFRM?=
 =?utf-8?B?Ky9QWTFodlBTc1UycE9BOWttZ244R0w4YnhiMkFHajZNcVZWWndvaERCN3NC?=
 =?utf-8?B?cExuT0E5ZlIzUk5hMm9Ka3RRL0w1VlRYZUNJZ25tUk0vdUJHdzlYTXZLVXZY?=
 =?utf-8?B?eHhwQVZuVVN4TERWV0FlTFJqRzRVY2lkVzBCZTB4b3R1MytZRklhdytVenNI?=
 =?utf-8?B?MFpqOStpQmtkQ1RmNDBiL2RjRm95aENTSXcrRkFkMWJ4NzN0TDZLSWNSeWg2?=
 =?utf-8?B?Tmt0RDhoc05pWkdGUzRFODdXcVlFakdOYW43ZnFzeVJEdEtjS2I4dkZHcHNI?=
 =?utf-8?B?elNtTkpuaVFQOXdzU2ZVUnN0Z2xjcGNCaS9QQ0hLK3c1R2V5N2dIYWZLNDAy?=
 =?utf-8?B?SGk5YW5wc0RJdTdDa3ZsTEJyS0FhY1RHY1FjVGs3SEhBNmZ4TXEzNW5rd0Q3?=
 =?utf-8?B?R1FVakxlNnNCekVMNm9WRi9zYWxzOUp0a0lhQy84M1ZnTHRiaU9lT282UE1H?=
 =?utf-8?B?VE9OZlpUbGRMNzBDYSt0eXRNVGVYTzVXTTNvRzJvclV5bEhhYmkzaVl4ZWkx?=
 =?utf-8?B?UTh2Q1FjVEpQTUc5enBreDdpWmhHUFVqcE9heERMZXhBUUhjNmZOYXRxVUEr?=
 =?utf-8?B?WGdSRW9PMDlXWVZRU1hvK0VCKzJzTnZnZW03WUVJWldybEgwckdYTTdzUHI0?=
 =?utf-8?B?RWpPN243MUFwQ3ExemEyWTlqemYwR2Q4TnQ1SWd4OGRKQUZnb2tTKzl3TXd4?=
 =?utf-8?B?bTZ2ZTZoSFcxUGNNK0xtYVlGdmNHM2JyL0VqMHh5ekN1UVllYis3Rmx0U1NI?=
 =?utf-8?B?dXhVMENaR1FoNjNRNzNyZGYrL0FyNzlqN010RnQ4bDV3MWFQYUVtcmNSVWcy?=
 =?utf-8?B?ZTg0REh4bXgrdlR6Zm42ZGRIQ0t3UU15V1pLbTBaSEFIYmdNSmxJYjArSHlZ?=
 =?utf-8?B?UE5sWnJ3S2pYNFliOXBERnFrVjFQazUxMmRYRXA0TVR0a2xtTTRHU2RBYkxy?=
 =?utf-8?B?SlZ1eW1rdXBmS2pxSG1CZ3FWYkJuajlzZ1UxaU9tZHpPQittTE1UaHFkRTRK?=
 =?utf-8?B?TGo1Vno2OEpZbGNRcGU2UjR5ZERzT0lJUnl2NDhQUG1FWkxhd0U1RUUrWTRr?=
 =?utf-8?Q?R21ZXi57WsV7J6To3fAfmUk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78d1ba96-59f1-40b1-89e9-08d9b3ffc2aa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 12:48:51.5098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xyOuMsVw3jcvN0O73osal4bvumdKETy3yWE0ldUIZIe23laj7KiG0OBToOUDkkGIZwFqDiE6PazIadtHT6gupg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5248
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/11/2021 14:40, Ido Schimmel wrote:
> On Mon, Nov 29, 2021 at 04:11:51PM +0200, Nikolay Aleksandrov wrote:
>> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
>> index 5dbd4b5505eb..a7debafe8b90 100644
>> --- a/net/ipv4/nexthop.c
>> +++ b/net/ipv4/nexthop.c
>> @@ -2565,14 +2565,8 @@ static int nh_create_ipv6(struct net *net,  struct nexthop *nh,
>>  	/* sets nh_dev if successful */
>>  	err = ipv6_stub->fib6_nh_init(net, fib6_nh, &fib6_cfg, GFP_KERNEL,
>>  				      extack);
>> -	if (err) {
>> -		/* IPv6 is not enabled, don't call fib6_nh_release */
>> -		if (err == -EAFNOSUPPORT)
>> -			goto out;
>> -		ipv6_stub->fib6_nh_release(fib6_nh);
>> -	} else {
>> +	if (!err)
>>  		nh->nh_flags = fib6_nh->fib_nh_flags;
>> -	}
>>  out:
>>  	return err;
>>  }
> 
> This hunk looks good
> 
>> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
>> index 42d60c76d30a..2107b13cc9ab 100644
>> --- a/net/ipv6/route.c
>> +++ b/net/ipv6/route.c
>> @@ -3635,7 +3635,9 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
>>  		in6_dev_put(idev);
>>  
>>  	if (err) {
>> -		lwtstate_put(fib6_nh->fib_nh_lws);
>> +		/* check if we failed after fib_nh_common_init() was called */
>> +		if (fib6_nh->nh_common.nhc_pcpu_rth_output)
>> +			fib_nh_common_release(&fib6_nh->nh_common);
>>  		fib6_nh->fib_nh_lws = NULL;
>>  		dev_put(dev);
>>  	}
> 
> Likewise
> 
>> @@ -3822,7 +3824,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
>>  	} else {
>>  		err = fib6_nh_init(net, rt->fib6_nh, cfg, gfp_flags, extack);
>>  		if (err)
>> -			goto out;
>> +			goto out_free;
>>  
>>  		fib6_nh = rt->fib6_nh;
>>  
>> @@ -3841,7 +3843,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
>>  		if (!ipv6_chk_addr(net, &cfg->fc_prefsrc, dev, 0)) {
>>  			NL_SET_ERR_MSG(extack, "Invalid source address");
>>  			err = -EINVAL;
>> -			goto out;
>> +			goto out_free;
>>  		}
>>  		rt->fib6_prefsrc.addr = cfg->fc_prefsrc;
>>  		rt->fib6_prefsrc.plen = 128;
>> @@ -3849,12 +3851,13 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
>>  		rt->fib6_prefsrc.plen = 0;
>>  
>>  	return rt;
>> -out:
>> -	fib6_info_release(rt);
>> -	return ERR_PTR(err);
>> +
>>  out_free:
>>  	ip_fib_metrics_put(rt->fib6_metrics);
>> +	if (rt->nh)
>> +		nexthop_put(rt->nh);
> 
> Shouldn't this be above ip_fib_metrics_put() given nexthop_get() is
> called after ip_fib_metrics_init() ?
> 

yeah, that's ok for symmetry

> Also, shouldn't we call fib6_nh_release() if fib6_nh_init() succeeded
> and we failed later?
> 

Hmm, that's a clear bug. I was only looking at nexthop objects and completely
missed that there's an error possibility after the non-nexthop path.
You're correct, and in fact we have to add another error label specifically for
the non-nexthop case because we shouldn't do it in the nexthop case.

>>  	kfree(rt);
>> +out:
>>  	return ERR_PTR(err);
>>  }
>>  
>> -- 
>> 2.31.1
>>

