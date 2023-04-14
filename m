Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA5C6E28DE
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 19:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjDNRAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 13:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbjDNRAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 13:00:52 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA6F5B93;
        Fri, 14 Apr 2023 10:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681491649; x=1713027649;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hC4SLAy52Cw/qO1/zp1ZmJyg7mcsjVpOit0Vr9crmx4=;
  b=KLaCcO3hxeVRm3ETPrz2ZQKkpSfvq6TutX3Xk6T8fr4Hnt5H+03GpR++
   aolPn9uSGZmu+osFeZSbqHDQiwUxplub7Ax4SOCQgcCS0FzLF8QB3ieOt
   /t44vPynUnyVThzZOnLjD8ZiEanR4wug/h9CpM8wkyhKlKn+qLpgQInZl
   CnHCkddaS4d2XKDrAfx4K/FkzL94CJSQw4IZbrKLy3KiwMeU/im3EF8+8
   k8FVbNnlsnS6/9FTgJRIbiM+vXAyb/zqsjgThDfJJEMFrLDome8EQEI4z
   QzmtL88g6JAD5bkqGjnrQSyo0BRjJOxk0LnveWteXnuDqHAxkV5JdVihj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="372378822"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="372378822"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 10:00:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="759161314"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="759161314"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 14 Apr 2023 10:00:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 10:00:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 14 Apr 2023 10:00:45 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 14 Apr 2023 10:00:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9+BSw6IGrhmgtron5AdnneF4Mf6fVjTWCHtiKzv0TQ76TPDfNa+lVjy88FTmCmIhi1jN8W/7LcHq5czaCst/onjA8F1e5I1lSz8Bqu4AfPsmqhO6E8GA6geud5RcmAES1kvZMNsBvjHs8MKolKviln85iuh0aOgwvhJFKuvI+iZqlFabhn/szYou+7z2zg4/ZEH+vJT9aqiP1DsCR6bVyV0d3pEY0zuyEWCLsCyVhzStm3WhvnEWsQE4bKSB2JUs9EL3/yf63SmdLKf2fo4NRTMR6rkEQcJBR1p+r0GJ9TNhg84H9IC0QVMrYMDJZFtC61JITDkTtGoZradLvpC4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GLlLMGhMKyra+YCkZEeAEGAGDQI/sDjGOdRkaR2vA8o=;
 b=nhvEOLbj55mnyRaJJl19BiQnKQWxQm3OAjWUP5P0W3UWRPQPaa6zeGO7VQgCS2i0sBL2MAdv9F1K8JCvm8nWi93JR9m0GEjVMnunr5gimvnCUdS2DpBpixkyHnZMT+NoIqEuu0t2bCuSL7Fg7SFY5gTtStduv8HEJvIaNRbcaZfdZU00kNrYJFbraaAk1ScYBNAnzfysHAyca+PlgW9wQMCi9nLfa6kSxYb74uzTNs36u5VqlxkiLy2pm0Rbnhada6boPbsx+kEh9sMV9nJq7KKIoVW64vlCHf0UfyxwMUjW9bRUU/pO4aiqwFOhiVWabzga9mcv/b+ffCnqEzF5oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA1PR11MB6894.namprd11.prod.outlook.com (2603:10b6:806:2b1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Fri, 14 Apr
 2023 17:00:43 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 17:00:43 +0000
Message-ID: <06722642-f934-db3a-f88e-94263592b216@intel.com>
Date:   Fri, 14 Apr 2023 19:00:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next] net: lan966x: Fix lan966x_ifh_get
Content-Language: en-US
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>
References: <20230414082047.1320947-1-horatiu.vultur@microchip.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230414082047.1320947-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0122.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::12) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA1PR11MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: 482898d1-6141-443b-31ba-08db3d09c826
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zseiyBcGhjGIVECzxqev0MaVGIuPyeGeSWyX08DfspdOK9x2uy+9vaL+/cNpaWELAvhglfCXcpjIcfx2/32Fw2H8gO5j7nVsLcx5nP/y85AlE+WVsGiboXOr42rmrE/Ej8bh+DAAEn8U4/rc679/u+zD0dsqNvmy/VdFZ72Bjdfvqib8kExwre5vosYSBAVWLo3zTDZElEwnxFozsCuIk5iUoa3IND+a2Ctr3immQs0RqSCEpc5inHKdse9Fx2QWmZJACwgCOoPEpUm7pFkR8Ni09Q98dZr04yiZpRgoz4vo5CDM3F27FOFpHHtvF5iiS/2clHRvhbLgv3ANupYIsXVjaCE6PHS505o0d6s1PvTLTqB/sXfmgE6AuugV+L9LbPultqlhR/2RNKeICiVlYd3dbpHXTUTXBqNgM2zH/RCYjn52zFKrrOJpm1EzRA0S/O4rnuPyUXO1A/Qv+y6FD5o1GX+N/IYgaxb21RHEf4F7mDCFiGMIICKWblzOM/uIILS68KR+WJG7TCGilJOs15SgJKHJs3KmKWeAtjy6Z+w10n1mpUEtVHM1uVc/l05rPOtc9CBUm6eym6XY2rZgOkozIkDCFLg5fxfqwD/rZZxgGjE28B5lEQS38/bdHU/jn2jjoTjVBGyOGXP6NVvdUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(136003)(366004)(39860400002)(451199021)(6506007)(186003)(26005)(2616005)(316002)(2906002)(6512007)(41300700001)(83380400001)(4326008)(8676002)(66946007)(478600001)(8936002)(6666004)(5660300002)(82960400001)(38100700002)(31686004)(6486002)(66556008)(66476007)(31696002)(86362001)(36756003)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWY3K3Uyemx5TDgvWDFiem9wcGpxVVVsU3l3YTd5RWQwcDdYUmhLeGhrWElw?=
 =?utf-8?B?MmloREhOUXUxYkV4RHVHdFMvbjMrUDlPWkdSWENqemlHRkZrSXdyZ3VJeTB2?=
 =?utf-8?B?aWlrazBZMmhwOXc3MjFjZUdpd2M2MzNIZWtzZlVyV1hUdnFtVG1rVGZaOUZP?=
 =?utf-8?B?RWM2bFZFZFp4NDhaWitpU2ZnNEQ5aUlRVENES255a0VtM2xoY3pJTXcrNWFQ?=
 =?utf-8?B?d1JNUlJOQ2dQbXZpbk1WWHFhVzZ3WEE5dldkVWVXZzFiT3lQa0NyNm9IbFZY?=
 =?utf-8?B?a1JqajRJbFpyVWthUTdvNUwrcU5XUW1JL0ZBL3NyODljcWJ0OWthYzhXbjBC?=
 =?utf-8?B?NmxkOWEvVXhRK3hnS3o3NTlobGdpSlllUWcvWW91aFZ0NmVsMWh2Y2RLcWNQ?=
 =?utf-8?B?R09MQlhHVU9rd1ljcDEyUzkvTml4dU5TSUVRTVIrQU9nNURhK29QWXFMVm82?=
 =?utf-8?B?cU5xa2ZkdmZDbHc3c0ZhTDROc09qU2xtY3ZRODA4OTJlY0V6SFNBek5ZYVdn?=
 =?utf-8?B?TDBwck1odStQQTI5MHhtWFZmU0VWQVcwdkpTZlJHRHppaEJ6alFtVEFwNkF4?=
 =?utf-8?B?R0tXNlhiT0xOUXBPMmxCWU9Ib0hqK2VnV1kzcVZVMFhKc0t3MGVjQ2VTRnkv?=
 =?utf-8?B?ZWI2LzFYR3dOODJ1ZHQyUjRzbWJEVzhQZGZvclNXaUZnOGtpM0Y4S2Y4ZFVR?=
 =?utf-8?B?RTRIK2haQklCa3QwTi9lSERnSHdMQU5CTmRLQkt6ZXpwcUhVQ2g0Q0ZERUJF?=
 =?utf-8?B?NStSUXlvb1NndS9zM0orWkc4Q1N2MENMeGpUVDRNc1RMUnloMzFXbkxUeU92?=
 =?utf-8?B?WHZ4RGtHL3QyU1dkbWk2UnMzU1lMZ0lyNkZhTldiOEZSRWcyei9NeGFJYzBj?=
 =?utf-8?B?YTVONUhYcHpDZWU3djJhT3VxOXNBbldSTy9lTG9rWUZRaDJkNFVnSEVDQS9v?=
 =?utf-8?B?NFhUWENlM1l6VmNaY25jTFNxUFVZNkNMbDZKTWdEVHFrWElQdEViRVNEelVO?=
 =?utf-8?B?UlNtVFFJZGhmVVlZTGY5TldiT2dzeUkvOWt0OXNwZFpiWkZsL25lbkpReXla?=
 =?utf-8?B?bGR5OFMraEVxQXd5ZTh1aEdIeDVqWlRnUmVUR1RPMGl6enJ0V0dUOHpoaVEw?=
 =?utf-8?B?cDVvVXI3bzR5bUlUVCs2NG9HamxKWUNoMUlLYXVxWWZIc0JMSjVSMkdxRGo2?=
 =?utf-8?B?MHhGMG0vSGNHRWhWd25MbkY4bVNxTzFzY3hXSlBRdmxmZ21PWDdZZWRNdGNN?=
 =?utf-8?B?TksrMjVMbEM2RFRWV3lmYnV1WUpDWFUzSTd3cmxQRWtHNGx2WTJiWHdYVHh6?=
 =?utf-8?B?YytITWxVOVloK2ZXcnp1aUdmQkh0NEZkQnkwM1ZaM2hOcWkwY0xIUkQxOWEr?=
 =?utf-8?B?Zi82UVljdTJrOGhHUnN6V2Y5YkNrd1BFYmx6eEEvV3l6YkREWFFCQXhmZnc5?=
 =?utf-8?B?cFFoaVZaZ21pRjBScE1taHJSM2FaN2hGVFM0NmdweTFJcGhCZkRLOGNweHNZ?=
 =?utf-8?B?anF6TTEzaUpyR1U2d1hoTkx1VjVQYTNpU2VNYUpTVjlhZ2pKandUWG54VGUr?=
 =?utf-8?B?OGRTcHNNbzl3NmV5MTgvMkgreUJ6cVYyakxNa29YZHFWWUswQ3hzcTFSZVdP?=
 =?utf-8?B?M3gxRkJnVWExc2lmQlNPS1VaNEtjOGMyclh1d2FvaTlId1VIeWdSRnBsUHdo?=
 =?utf-8?B?NHlQMWxZYllwQjJ5VVNCYWtwRStqYUorR3NEK2IyL2tvRTRsM1F0REc4dzMz?=
 =?utf-8?B?QS9sRk1sZElVWGZqVUh0QWtlZzdRbnR3WmVzQUI5NkVaY01sV0R1TDQ4clc1?=
 =?utf-8?B?ekZqOEh1RWxvMnZzNjF6b2pyOWQ2RjZSclBKdXlCRzdUT29ZZzdoOW0rZSs5?=
 =?utf-8?B?QllHSjdhVnREdk5YaWZxNXdUTnd2OWxtY3k5MitPSzFYQmJBTWltMENkMGQy?=
 =?utf-8?B?SkltL2pTeG1wdXFCdGUxYlEvUlVvWi9CbWl5L2NMUjVVR24xbGk0c1hOcVd6?=
 =?utf-8?B?TjZUQmdpVHIxdkVzZGc4WTBTR0Z2b3UrQ1czbWFGdnFWQVhVZ1pVaUd1TTcy?=
 =?utf-8?B?bUlPVVdyV2lacmFDNUtGMFNvUXo3a3IwN0xRdmxTZFRkM2dNRit0SnVYUmN6?=
 =?utf-8?B?RG1FdUpWOThZM3BoTFpleFl2VDBQWDFhWld0OGZDMlllbnVMYjdEZEVVRUY2?=
 =?utf-8?B?K0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 482898d1-6141-443b-31ba-08db3d09c826
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 17:00:42.7471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zmxJftv6LoniUBOfoKhczEYdFZDbLnnr2+hYJShGEFSCr9GUkhGFfqjYVYh/YMPtKJR88A+6G26CIOpaVfiJBeHs/Xr7J1ZLDSyaFbpJmwM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6894
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Fri, 14 Apr 2023 10:20:47 +0200

>>From time to time, it was observed that the nanosecond part of the
> received timestamp, which is extracted from the IFH, it was actually
> bigger than 1 second. So then when actually calculating the full
> received timestamp, based on the nanosecond part from IFH and the second
> part which is read from HW, it was actually wrong.
> 
> The issue seems to be inside the function lan966x_ifh_get, which
> extracts information from an IFH(which is an byte array) and returns the
> value in a u64. When extracting the timestamp value from the IFH, which
> starts at bit 192 and have the size of 32 bits, then if the most
> significant bit was set in the timestamp, then this bit was extended
> then the return value became 0xffffffff... . To fix this, make sure to
> clear all the other bits before returning the value.

Ooooh, I remember I was having the same issue with sign extension :s
Pls see below.

> 
> Fixes: fd7627833ddf ("net: lan966x: Stop using packing library")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> index 80e2ea7e6ce8a..508e494dcc342 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> @@ -608,6 +608,7 @@ static u64 lan966x_ifh_get(u8 *ifh, size_t pos, size_t length)
>  			val |= (1 << i);

Alternatively, you can change that to (pick one that you like the most):

			val |= 1ULL << i;
			// or
			val |= BIT_ULL(i);

The thing is that constants without any postfix (U, UL etc.) are treated
as signed longs, that's why `1 << 31` becomes 0xffffffff80000000. 1U /
1UL / 1ULL don't.

Adding unsigned postfix may also make it better for 32-bit systems, as
`1 << i` there is 32-bit value, so `1 << 48` may go wrong and/or even
trigger compilers.

>  	}
>  
> +	val &= GENMASK(length, 0);
>  	return val;
>  }
>  

(now blah not directly related to the fix)

I'm wondering a bit if lan966x_ifh_get() can be improved in general to
work with words rather than bits. You read one byte per each bit each
iteration there.
For example, byte arrays could be casted to __be{32,64} and you'd get
native byteorder for 32/64 bits via one __be*_to_cpu*() call.

Thanks,
Olek
