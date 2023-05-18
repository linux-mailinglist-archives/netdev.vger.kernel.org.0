Return-Path: <netdev+bounces-3680-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 660F2708536
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:43:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96FCB2818C3
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:43:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B19A621083;
	Thu, 18 May 2023 15:43:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB3953A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 15:43:19 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F13993;
	Thu, 18 May 2023 08:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684424598; x=1715960598;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DzTQnzQdOHvg5TlkenucU8jL6Zz6eyYVQebs8vPJE30=;
  b=FxGDyRgUKvbXb6TtVHTAcJkU412d2TF2PPzQVEOG1URLj9yLsQmLS2Mp
   MaUsWdVn8nIExqPRkET469ORgK3Ve9NiGCCf4G9Rf5hR9pgVNBuZSHuKY
   DWKVD0Rpd/4B5k7GBuLslJzyMtCXLDXFiJwtRScAHEh+CEOF1FD/F+orr
   TzmuKDIb5oJ+gb5VKzWEWzHvEfFcvaWLoBJDmuFfxoNONdCxaB11eXMFL
   jHpuo814R22SCM9fmVphIWfFapxa1ziwF3d3OlQtZlihapIOcrWDHUBOh
   nWTEZeq3u8TVH0rl+6KtJ0Sk/wwSB20FYLv/4hlMOWBcFbXhmW4wR27I+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="415548732"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="415548732"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 08:42:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="771917333"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="771917333"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 18 May 2023 08:42:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 08:42:54 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 18 May 2023 08:42:54 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 18 May 2023 08:42:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ps3gelPgaV19xQnDkFO5lHYTSt7aLrJp8EJwu7KVkNlntHFJbNzSk9RmkikYQ23jL6YD+cNPfc3v7e0jn4YRzsbB+QAXyfVN/afVvQQA/M+MAD/lpnzZWOQ0BTP/f/beDg6ZDNAMjRzJaoNEXh2icz18O+W3EFEk288SXBo+1LkmcZSj9Ca4+Cu9z3FiEfWw6xDC2Hjz55F4HHjEA/k1YzOg4D90IMJQCFMs95smbzU4kYZwoM37HWBXkFU8OKaPPXfASnHOqF999Tmi8p1PxvlkNCfExH3Jiw0M5tMrApDCqETFwuEike7qXStAlocbI8BUJkMlRlDKuQcMvqDb9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JEYcHf4gY9M6vKdytiIxowJbO1B+B0CFCuFdbZPeMiE=;
 b=fGOUS/GsAH5IwLs87Vgf0YL3/aB1kU8mWVm+nvxFoF8f+M1ThjHcBHsV8CpIwg94idYxDf750tRKX7W8VZ5/KEmgo9koSUKCuA8GDn+N4fNayrgILDBtw6sxC5s3d2sTvYn+VKDRSIwWKBZV0xo+1Jl3biLJVkrncuui/c8Fhu7/Y5cy16i/jmA9EfRUc4vphjWSFYwepBmZFJvK8QYpcR9UVvIN3AfFasDWgZqqLRbtrSoWnDFaE5g8+rUW2Z8f7jLBTviQpJXZwMxHkFrYh9c1Rl4ZNex7cVXZn2s5LD9lfOYtMr76dC1NPCwxsvdPl4bBDFNeZTTgudf/uA1wqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CYYPR11MB8359.namprd11.prod.outlook.com (2603:10b6:930:ca::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Thu, 18 May
 2023 15:42:52 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590%2]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 15:42:52 +0000
Message-ID: <0dfa36f1-a847-739e-4557-fc43e2e8c6a7@intel.com>
Date: Thu, 18 May 2023 17:41:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [Intel-wired-lan] [PATCH net-next 07/11] net: page_pool: add
 DMA-sync-for-CPU inline helpers
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>
CC: Jesper Dangaard Brouer <hawk@kernel.org>, Larysa Zaremba
	<larysa.zaremba@intel.com>, <netdev@vger.kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, <linux-kernel@vger.kernel.org>, "Christoph
 Hellwig" <hch@lst.de>, Eric Dumazet <edumazet@google.com>, Michal Kubiak
	<michal.kubiak@intel.com>, <intel-wired-lan@lists.osuosl.org>, Paolo Abeni
	<pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Magnus Karlsson
	<magnus.karlsson@intel.com>
References: <20230516161841.37138-1-aleksander.lobakin@intel.com>
 <20230516161841.37138-8-aleksander.lobakin@intel.com>
 <20230517211211.1d1bbd0b@kernel.org>
 <9feef136-7ff3-91a4-4198-237b07a91c0c@intel.com>
 <20230518075643.3a242837@kernel.org>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230518075643.3a242837@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0175.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::12) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CYYPR11MB8359:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d91b120-7ddc-41b4-db0c-08db57b68a21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AhOHCJk5lkdOLDeSEKd35VBTKaTh1l8s1prTuinwP4MAe6We+rqwemNkQzLju/yC2WNE65C0OOR595hWKyP1ZzFsPBfWX4I4RC5DjaZNfmKSg82lkekunG8a61uQrjNTEvTZfwqCbRNNrCc/xUe8aeJZEmTAX9JO+zgms0iI7ohVe1f3yCI3THYxyoXgwPuNLHQfhX6BiDwfzcxwWiZpCSKbdFWJ0bzdFZQyIHqugXUV8Y8NXD9MS4rkbenVwaXGLNIC3XIYoeoRjrqvtKoXpK8JGaW7Ivc4jTT0k39I0zzOlRkXEgrNoNFICjWCvkOKS6Rw8Sz1tdqEk9+V5lFzrLHUGxomWV8ZEgncElqDdMn7s6uWHRi/2xihQSKgcWRGnp+pN1/+dGQllMzygVEDkD4Iw4cv5D1vkAaxV8E/9LmUZrNSwtl3f7IcSZDPXzGsXvaD73QVWbsoNix2ADqRK9fVOkVZ7jdXQFCvFcszIA/EXkrib1a6yBh8/O3hEIMjY6KtZUNkFlXcJvU+T12/WDGSZggv8UCoa2+H123l8apX6QHYVzM92nsBId/imdsciFc2TjBLA4tGYTkHLKgAi87YhJv4KKpGou94ol7CYVvBrgwI+z3yMMnxvOvogEH/mCeePpj/uM+cQgKHqUHOTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(376002)(346002)(366004)(451199021)(6486002)(2616005)(36756003)(26005)(6506007)(107886003)(83380400001)(186003)(6512007)(7416002)(38100700002)(54906003)(31696002)(86362001)(8676002)(8936002)(316002)(41300700001)(5660300002)(82960400001)(31686004)(4326008)(6916009)(66946007)(66556008)(66476007)(478600001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFdoNDBCVlZMREM2VDJVWmNUb0NqMHIrcGdESVNuQ3luT3BFU3RIQ1VuNEdr?=
 =?utf-8?B?eE16Yy9Fa1Nvb05tNXJ5YVJBVVVkOWh1TmE5ekc1NTJMUE9sL3BSdFdiV3Z5?=
 =?utf-8?B?YW95NlZlU21ZWUp5MnI2QWsxbzZjWE9sTmsyWG1tS25ORUJ4bndMUkdTY04r?=
 =?utf-8?B?Zk16Q0pvd3hCYUZEYS9GKy9paWttVWFjbzlyM1dvTEtWYVBFdSsyVVkwRE9W?=
 =?utf-8?B?THdJREl2ejlxZG5XVkJidG5kcmlNTDlGS01rSWE1OXlRZ1dOZ1dJMFM2aG54?=
 =?utf-8?B?Nk9RTmh3MkxjaUFSeTZPTXRISXRrMEFpNTZhRTNGWFEwL2I2aEdvSHpYZmJU?=
 =?utf-8?B?WEpuYnVtRkRLSXU4UDJXSUF6bUdNVUU2QkpQSVhEZkl4Zzk5VjRHYURGbTZJ?=
 =?utf-8?B?NSs5TWcxYnhZRjRUUS95ZGx3ZVBuNlNOS3loOTNWWm00a3lIalUrWVlRK3NN?=
 =?utf-8?B?MHh0THZvWDl3Y3Z4Tlh0emN0NGcyWEFJNlRrSzR4NWtEK21RUnllZHZNZ1JE?=
 =?utf-8?B?SHdNOEowVzc5SzA0bW40dHJrTVljazF4Y0ZlazZ0U3RNWGJuUHE5WHRPc1hn?=
 =?utf-8?B?Q1l0QlBhdDUvQlpFNjJzWEw2dTVKdEN0MDdhRkNNUjJpdXNWemRjWVdMQjRG?=
 =?utf-8?B?d2djbmcvWUhteGhUZjZDUVJlUjZjRWxHcHYzNVJNaktlVHhaL05Pdm5WRTBV?=
 =?utf-8?B?aUV5VWp0SWxCZk5NaU1zQTcvSjBpZHNGQ3B2bUJFSWZoOFZ5QnBtQ0hnM0hV?=
 =?utf-8?B?T0pGSmpaU29NeUlLSFZpKzFIQlp1aVZYYWpNdVh2WlExbWx0ZUM5NysycWpa?=
 =?utf-8?B?THQwcHhtSG9SZTdBbm4reXg4K1FMa09PRE9YR0dIeWwySGkwNmxVVkxBYTlw?=
 =?utf-8?B?T3BpSWZlVDUyS2dTSGFFNmo0dHRReG50YWtzb2oyLzZ4cVFrdGdLdWJTY1Fa?=
 =?utf-8?B?ZmVzU25yRkNEOVlZVVpPQmdteTRaQW9EcHZudUZwU1BWSlV6MHRtKzhVdjQ1?=
 =?utf-8?B?RlFHYnZzWm5WdVhlT1hXQVVoMDdPcXNXVzcyaEVXdVBFd2laQXI0UXdzeGZB?=
 =?utf-8?B?Z1RaS3E3MzhMaFFqR0VFVytMQkU5dWlBcDZubWMzb2RIOXhHWWNHRnIwNFJr?=
 =?utf-8?B?a0NuK2FjNEMrc2FkbEZESkovclV6cmNUcy9qd3lmWWlEQWxQcFE3NGNtUUNw?=
 =?utf-8?B?RHRiNDBGYzJvMUUyNmw1eWg2TUpyalBNVHJlcGRFRHhiMUJVMjlVYnE1RzdH?=
 =?utf-8?B?eWFSQVRwN3NlWnh4Ukt4ajhiY2M5TnNqdmVDc1Z3c0VtRkdqTkVJZTlGb0R1?=
 =?utf-8?B?MGYwbm1xUFN2dVZ4eWZzdXZGaXQ1WHJlNDhvK1lwYk9oSzZkMEVQY3lINnc2?=
 =?utf-8?B?Y3FLdnJJbnc4aDdldlhUNlQxR2hyUFpiOW15d3hHT0pEUVM5Y2htcUVkWGlE?=
 =?utf-8?B?Y1pxSlV1bzA5WmtUaTJFNTBpRlV1a1VqRXN1U2VuTytFcjNZNnJtVXNCNWdo?=
 =?utf-8?B?bU9HTC9qTlJRaFNYaTFrUXEwQ0h5a1dhZFZjbkxBYjZKQ3ZzR1BHUTNBWUkr?=
 =?utf-8?B?ZXNyY1RGM0RObEM2V3JOUUF6dHBydHhlKzhacVpKL29IUysvV25MSjV3TW4v?=
 =?utf-8?B?OFh5VmQxbTNnQkJYcXlvYk9Fcjk2TWxOZW1iM2hNanNtVmEweDBZWnRBamJJ?=
 =?utf-8?B?cEsvanBYdXRRY0dmeDNLMXRoVVM2cTczRDFJQkRqdmJJT3hoejFGTmUydG91?=
 =?utf-8?B?Y0N1NU9lNzYzODRldHVTL1o5S0VQNzJMOFh5R2hQTGFOS1QyT3lkcjR1aDZk?=
 =?utf-8?B?eEl5SlZtZTZtN25hdnhMV09yWEE0SExxL1Ztd2lpTDlFd0U0T3l0R01aMWFD?=
 =?utf-8?B?S04vTFZKQzY0QTJJaUtzQU1ERXRacmlFVnp0WGh3ZWZNbHdaZFZKUGw0ZXhy?=
 =?utf-8?B?a2drUUgyWjlXRG5SMkd2RXY0dkZvVFViK2pRRzA4MnZaR0RzTFY2ZzJjSFMz?=
 =?utf-8?B?WCtyemhhT3lQRWo4NU1BSE1oMzE1MkpPZXZzSnY4VzJoTW5ya1FPZ29PZU4y?=
 =?utf-8?B?S1ZsUnpqYW9lVTBMN21XRXVuTWlKQ2FYNWZuRmRaVEIrdlUxYVFqUXBiNkFZ?=
 =?utf-8?B?VTA2UzZvdlB6b2hlNUZYTkczeGQ5ZzVrZm9yaG9mS0RPWTByOGtaaEpuOUtT?=
 =?utf-8?B?TGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d91b120-7ddc-41b4-db0c-08db57b68a21
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 15:42:52.0416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: woM+mz5mPOJgz0ew00WvsqF3LIpIF8eenEpDKs35mxTMpVSKbiNvBXqGcHCbq99oHDWzhi0MJUSFDWDw6Kl7RLmgM72J0LvLHzhzMSAvKOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8359
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jakub Kicinski <kuba@kernel.org>
Date: Thu, 18 May 2023 07:56:43 -0700

> On Thu, 18 May 2023 15:45:33 +0200 Alexander Lobakin wrote:
>>>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>>>> index 8435013de06e..f740c50b661f 100644
>>>> --- a/include/net/page_pool.h
>>>> +++ b/include/net/page_pool.h
>>>> @@ -32,7 +32,7 @@
>>>>  
>>>>  #include <linux/mm.h> /* Needed by ptr_ring */
>>>>  #include <linux/ptr_ring.h>
>>>> -#include <linux/dma-direction.h>
>>>> +#include <linux/dma-mapping.h>  
>>>
>>> highly nit picky - but isn't dma-mapping.h pretty heavy?
>>> And we include page_pool.h in skbuff.h. Not that it matters
>>> today, but maybe one day we'll succeed putting skbuff.h
>>> on a diet -- so perhaps it's better to put "inline helpers
>>> with non-trivial dependencies" into a new header?  
>>
>> Maybe we could rather stop including page_pool.h into skbuff.h? It's
>> used there only for  1 external, which could be declared directly in
>> skbuff.h. When Matteo was developing PP recycling, he was storing
>> mem_info in skb as well, but then it was optimized and we don't do that
>> anymore.
>> It annoys sometimes to see the whole kernel rebuilt each time I edit
>> pag_pool.h :D In fact, only PP-enabled drivers and core code need it.
> 
> Or maybe we can do both? I think that separating types, defines and
> simple wrappers from helpers should be considered good code hygiene.

I'll definitely take a look, I also like the idea of minimalistic and
lightweight headers.
page_pool.h and page_pool_drv.h? :D

> 
>>>>  #define PP_FLAG_DMA_MAP		BIT(0) /* Should page_pool do the DMA
>>>>  					* map/unmap  
>>>   
>>>> +/**
>>>> + * page_pool_dma_sync_for_cpu - sync Rx page for CPU after it's written by HW
>>>> + * @pool: page_pool which this page belongs to
>>>> + * @page: page to sync
>>>> + * @dma_sync_size: size of the data written to the page
>>>> + *
>>>> + * Can be used as a shorthand to sync Rx pages before accessing them in the
>>>> + * driver. Caller must ensure the pool was created with %PP_FLAG_DMA_MAP.
>>>> + */
>>>> +static inline void page_pool_dma_sync_for_cpu(const struct page_pool *pool,
>>>> +					      const struct page *page,
>>>> +					      u32 dma_sync_size)
>>>> +{
>>>> +	dma_sync_single_range_for_cpu(pool->p.dev,
>>>> +				      page_pool_get_dma_addr(page),
>>>> +				      pool->p.offset, dma_sync_size,
>>>> +				      page_pool_get_dma_dir(pool));  
>>>
>>> Likely a dumb question but why does this exist?
>>> Is there a case where the "maybe" version is not safe?  
>>
>> If the driver doesn't set DMA_SYNC_DEV flag, then the "maybe" version
>> will never do anything. But we may want to use these helpers in such
>> drivers too?
> 
> Oh, I see, the polarity of the flag is awkward. Hm.
> Maybe just rename things, drop the "maybe_" and prefix the non-checking
> version with __ ? We expect drivers to call the version which check the
> flag mostly (AFAIU), so it should have the most obvious name.
> Plus perhaps a sentence in the kdoc explaining why __ exists would be
> good, if it wasn't obvious to me it may not be obvious to others..

Ah, +, good point.

Thanks,
Olek

