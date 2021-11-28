Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E656546099D
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 21:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235310AbhK1UTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 15:19:47 -0500
Received: from mail-mw2nam10on2078.outbound.protection.outlook.com ([40.107.94.78]:52170
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231693AbhK1URi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Nov 2021 15:17:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQ5r9zzG63OsM1iOhjL1K7mIzGce72+6rRrZIHsF1gC87HJyEL3BWPmvO1hRHihCUWEgN45N19RrCS8eTSjfjjbW9gPvwLBz+Ck3GNQr4iUUNz2adzahVDtHOuureCc+0/6GZTGBOP9AR8P67ioPJr2Az5RloGxhT/l3MRfvrafMTemOeUnAEGMElh/p4mlvsMe5CVpyucvOwscYrO34Ctb6ErQLIuM9geY+bSLmETbI0Qxwsc8YVsCutmTFXs3beAJSRlCJ+qeZ5P2KWee2+BgcPRovZcjiH3akD8ogpUMj9lX6IFujLKvk1jnwlAv8HMVp0TRK90voyd2V0aG/cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jE2dQcUHom7tRRsRyoWtPj0PY+hXOC60dQh5tsHD3q0=;
 b=KZ2JPOhEiIrny87yuwLOo+lzK3EhbkgrmGhJoz/+ImLmGcmWID6SQaCwlNS0pz+kuWHCQXgir+EFRm6MGIbLf12vHMIwjz79VXFFYDGmIc5/Z1tB2+uqEHF+3rqxUm2rT/ejnnxLfWzH1RvD9G7xl9pm8kVo6EZmeW5fKedxWyEK7fT3wnjwMoHk3LZy2NII2ZkWWhfdJhsbQv7STz3+ujVOu0740tjDyKRAstlATOk+gsvphRbCmJbx7JcYeD3NrWeDMuCJVgj7lUDd/cwnA2S5t022c2OUP1SHCDV57XN7JgD5trs7z74gsH7ScG5vWYICSFIizXUx0T5grwW5ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jE2dQcUHom7tRRsRyoWtPj0PY+hXOC60dQh5tsHD3q0=;
 b=UY5/XP7Mq+dygopACvlJybrKw6VVOI2I2sYB4h/REzFR4Ry1yjsdDn2tdKRi3rw0v3NNi0yD5y1yU5paMmzRLIJCsBvmDmwNqEiCLP04i+PKhuklH8Yp7SyOWD9zG7V1Qfbyp33GRrCg93lmexAcKv8warjJhH0QPucH+baTVTj45qcQTJKl+QfQMn0U1vewrDDUajAK+fRxA6hpMUjNoDUhfNbFgBU0UQq4w/Pu5yUHpirKTWV4hhYlCQO8jeE3A6DBjdi9zgmIU1dqC1dXIKF3VwMO/+HD59HFtAIbvPtFb3MaYvFVmxaYjWPa3vm5M0WHskOquLi4uS2NbbNmHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5216.namprd12.prod.outlook.com (2603:10b6:5:398::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.26; Sun, 28 Nov
 2021 20:14:20 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::2c70:1b15:8a37:20df]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::2c70:1b15:8a37:20df%3]) with mapi id 15.20.4734.023; Sun, 28 Nov 2021
 20:14:20 +0000
Message-ID: <b75dd859-266e-16d7-f37a-1c349fccacd4@nvidia.com>
Date:   Sun, 28 Nov 2021 22:14:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net v2 1/3] net: ipv6: add fib6_nh_release_dsts stub
Content-Language: en-US
To:     David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org
Cc:     idosch@idosch.org, davem@davemloft.net, kuba@kernel.org
References: <20211122151514.2813935-1-razor@blackwall.org>
 <20211122151514.2813935-2-razor@blackwall.org>
 <28dd7421-15f3-db72-4e1e-3d86fa2129d7@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <28dd7421-15f3-db72-4e1e-3d86fa2129d7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0168.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::23) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.42] (213.179.129.39) by ZR0P278CA0168.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:45::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Sun, 28 Nov 2021 20:14:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52f0af2f-055b-4919-66ce-08d9b2aba982
X-MS-TrafficTypeDiagnostic: DM4PR12MB5216:
X-Microsoft-Antispam-PRVS: <DM4PR12MB52164C3F4FCDCED0BD4E1413DF659@DM4PR12MB5216.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mKq0Uu8iA7t7kdrzlEMZRBkkt7GnDs1v2YOzicUx/acdcqzZpoIGqcloXhe9sAFmLLw9ojNzb/CHeL6bOFhANbgYLWA0IQH9NcB+Fbp11mXyxV43gHvRVVH4p3VJMA6bMSPSNsk8att3mdWLE1wF0ZFohyFwOtUyk6iW5Q3dbG/gKKIkyobPOA2+XqzYcP2x9i8hf77IAJSqyAP+YHyZdcHETW3Xb+ckJqbP2tITGxJcAO0XS3o0+ImgM/4u4/qu5fj7dDGHL26DVepMwyJZDIu8wt57ARF2SIV0HGtOPYEGQAEJdpSg1mLYXsuqt4j3OisYtto93XBDrqajxgoSOHWIC6dmkYpBs/O3OsK6+pYCxoGEvkcWOKWreaEzOnVhmut24wvwSfYdaLNBeOHaybEMiqTZkb5p5oTKCFcfJ+Bt5ep5pN66b5JxqFLebQw6p3Mo2b/3JqWSwx70kXvYvDqmOGxlnpaG+PCGC9w665CW/6q9WzTxG7eRxypXUl54+f4Jotj7xT2bs6NdJSjufIIuLv07vIoptoFOBdu/BXKz9WCMiiWBtcN7btFMewQwhiz7PrqLD/Ac5CYCl2OTtFglftFoqtLF5GMTg3nEJBFBECpLdBg4jsIMiKJcn9bOPVOq1TAdNxXJjH7LLjhLk4/mF/b1bKKtk2/8InYemXf96B3nUnrT1LPHBklvCY3t6qny8gTl6JiExP0p1LxgPZ3lqiBxhUj1drMr8cNN8aI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(316002)(2906002)(16576012)(5660300002)(4326008)(38100700002)(508600001)(66556008)(66476007)(8936002)(66946007)(6486002)(8676002)(86362001)(31696002)(110136005)(956004)(186003)(31686004)(26005)(53546011)(6666004)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0wwblRmc0swYzY1YzlEREF5c0VFSmdZREpKQk5JY1JGQk9UWHpCUm10L1NQ?=
 =?utf-8?B?bVdBd2JWMnA3Wm1oajdhUHBWbis2aGtuSWVRdUFMS083NTkyQnkzRlZGQmpz?=
 =?utf-8?B?UWtxZnJ0V0VYeDgzTDJTeXRPM25rMW9EQXQ5UlZocXpPUjl3U01qVFRlenNY?=
 =?utf-8?B?SExyelM5L1ZxaHdobVJzU0VscnplZkRvMnVMcEJIVFd4WXhmUmU2L1VKbHgx?=
 =?utf-8?B?cUFwVG9wSUJlZ3hoKzZuL0lNMFZZemRCUUlxWVdOendHaGsrY2VuVVZabVpV?=
 =?utf-8?B?VThqdTVPSHNGOW80eEF1ZFA5NzNCMmMvNENPeWJybFFleWduYXBDcGN3N3ZX?=
 =?utf-8?B?L0dCeWEyQk9SaG5VbGhiSThzYW5WWCt3QnlSUUUrRVFHazFqV09Ud3JJMG5Z?=
 =?utf-8?B?OWZRLyt3R0prWjNENStsSi9kbFVpOUpTRTcwa0xuU1F1aGlRdGdEMUhEd1hE?=
 =?utf-8?B?eVN6cXdpV3Z2dUhLZXBFeWJ0S2p6MU5aVlJUeWZYaXFuYWYvWU55R2x3U3Yr?=
 =?utf-8?B?QWo4RFJ4SDFadzhrdThiYzBYWUhhWjl2N2lvekx2aDFhWEtOUEFSdHBrcGNU?=
 =?utf-8?B?L2puZExTeWgyamo2UTNUUmc0dWsrK3FBSWVZQTVvVmR1ZFRGeGVIVnVRV1pk?=
 =?utf-8?B?bTFLd1NXbVFSSWdHQ2hBRnVmRlNsczVJTFYyWEN6L0wxWmpYTUZWanZyS2N5?=
 =?utf-8?B?SzRRWVF0djJmUXYzV2tLMkM1b3dJWDJzV2poeWRmTVFjQ1YrOWJJc2ZOdHpI?=
 =?utf-8?B?VzBlNVlOcUVTbXZMNWZYT0NibFEyRGtsV3p3dDB2MVNRcjhPUHRSS1Z2OUR4?=
 =?utf-8?B?eVNrWHQ2MCtSVkdPNTI0U0p6MC8va3JFNXJ0RlBYM2hnRzZiVURrVGFhZS9B?=
 =?utf-8?B?ZTA4OFVJYmcrN0loWVVvMldOa1NMcDlHT1VCc2Vob1NLMXcybXlQQit6Rkha?=
 =?utf-8?B?VlFjQkM4V2F6L1E0bTJwT0hJTGR4dWxmNXpvcVFvTDI5K0FOaVZ5WDkrYWRw?=
 =?utf-8?B?T0NCQm5HQzlxM20yTE9tQW1zQzdVTTJDUlZ2VCtsNWIrQmFGM2RkN21XTDNY?=
 =?utf-8?B?OE1EYkxsNFJlNlN2R3RjR0srWjlnb0pCa0x4NlZRMFc5NkFpc1EvVEh6eUhY?=
 =?utf-8?B?eE01Qlg5VXkzOUUyb3BpdkRtak80Mk1OcDROQ0t0bzRVd09UQVc0TFRmU1dQ?=
 =?utf-8?B?ZGRPV1gxQUdCbU9xaFFaYXVXYnJCWlZud1ptTlNveWlCWmJGTTl4TXV5SnhY?=
 =?utf-8?B?WTR5RERnZGRxTU05bmJDTWNneDdGV2JQRjhsWFNTS0E1Rm5JVHQzeDBuUjZl?=
 =?utf-8?B?Mi9RR0kyMm5XM2VYNStkZGhIeE9oZkVSWU5kM3U4OWRmbG1rZVVJTGRhSXda?=
 =?utf-8?B?dk5ScjV6YlNsakttRzVjZUdMTEpWNGtDcU9SQ0VrSTRwUGdKRnUxemdHd3Fq?=
 =?utf-8?B?Yi9ibFZUNUViMy9NUHd5dWMvZ0tGWlgzMjhzZHY0ZVZYUFFnM2QrTXZmN0d1?=
 =?utf-8?B?VDA5UUx3aGlEMjMwOG9XdS9wRnhlYUl2UlhLNGZ3WHdVNnNzRy9PSk8xRVBY?=
 =?utf-8?B?ZXBFaGJKTUVGNjdYejNrRW92bDF4MVFnVjN4VjZ1Z0lLSGQycmEzQStScUkx?=
 =?utf-8?B?eDRGbVRPVFhieXpWNGd3aU5sN2oyMGowdUdlaUY4Sm5DOWE1Tm1ZWW5uYUlD?=
 =?utf-8?B?d3dSWHZMY214bmRZTEN5eUkvNjRmaGFiSlhzNG1iN1RSTmlNYXNpS3VpU2NJ?=
 =?utf-8?B?T3NYQkJNRExBa1RzaVlVS2plbkVMZTZldUxEdWhnMXNEYWJuamJoNkVrdm1h?=
 =?utf-8?B?YVJzcXNmajBTVXpCWTY2V0RiVEtXN1RQNU9peTlXNU81Y3I5dlVUdjNlTHZi?=
 =?utf-8?B?SkdncmhvUWU3NzlocjY3Y2FlK1lXcExtVXVPTWJWbTJoc3dnUFJSMG9KUjlF?=
 =?utf-8?B?WGUvUktrL2RSb3lhNEVpbDlRTlFxMHFadThhcTZneXBoSVRtQWJ3NmNoWE45?=
 =?utf-8?B?MzU3cUh6dXhDTkxBM1VOODZxWE1XT1NjR1JHOFBqNGdvSHVSbmJzSFdyVHNr?=
 =?utf-8?B?MWZVcnFQTHJpRlVyZFI0bmFIS3lSdk5VcXJHdXpqVHRWVWw2THY0Y0RYMGY4?=
 =?utf-8?B?OXFTWUlmRE0vckJiY1Y3WUFQU0pRY2NSb3FSUnlYbm9UcFFFb0ZMc3hIVldE?=
 =?utf-8?Q?44TNjzfMUbs/pC6fBoZ/sD8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52f0af2f-055b-4919-66ce-08d9b2aba982
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2021 20:14:20.5580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6OKtdEeFekFB28uwNLb4bk9sQP9g2qeh+/vSdCGmfXvMPajGfvv+UNAOGOrBMGJfXnb3gevgzoA1YQ7bq5tikw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5216
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/11/2021 21:21, David Ahern wrote:
> On 11/22/21 8:15 AM, Nikolay Aleksandrov wrote:
>> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
>> index 3ae25b8ffbd6..42d60c76d30a 100644
>> --- a/net/ipv6/route.c
>> +++ b/net/ipv6/route.c
>> @@ -3680,6 +3680,25 @@ void fib6_nh_release(struct fib6_nh *fib6_nh)
>>  	fib_nh_common_release(&fib6_nh->nh_common);
>>  }
>>  
>> +void fib6_nh_release_dsts(struct fib6_nh *fib6_nh)
>> +{
>> +	int cpu;
>> +
>> +	if (!fib6_nh->rt6i_pcpu)
>> +		return;
>> +
>> +	for_each_possible_cpu(cpu) {
>> +		struct rt6_info *pcpu_rt, **ppcpu_rt;
>> +
>> +		ppcpu_rt = per_cpu_ptr(fib6_nh->rt6i_pcpu, cpu);
>> +		pcpu_rt = xchg(ppcpu_rt, NULL);
>> +		if (pcpu_rt) {
>> +			dst_dev_put(&pcpu_rt->dst);
>> +			dst_release(&pcpu_rt->dst);
>> +		}
>> +	}
>> +}
>> +
> 
> this duplicates fib6_nh_release. Can you send a follow on to have it use
> this new function?
> 

It duplicates a part of it but in a safe way because the fib6_nh could still be visible,
while fib6_nh_release does it in a way that assumes it's not. I could re-use
this helper in fib6_nh_release though, since it doesn't matter how the entries are
freed there. I'm guessing that is what you meant?
I'll take care of that and of the few possible optimizations for nexthop in net-next.

Thanks,
 Nik
 
