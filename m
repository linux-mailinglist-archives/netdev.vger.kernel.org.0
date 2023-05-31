Return-Path: <netdev+bounces-6844-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7283171865E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:30:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D2DC281510
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26AB171D5;
	Wed, 31 May 2023 15:30:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE22316438
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:30:47 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E869611D;
	Wed, 31 May 2023 08:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685547042; x=1717083042;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NyKkc1yf/WAjVdLXMvFBs2vmV9cJEgzsa9lPvU017fk=;
  b=kop5S3lg9wFVBFUqL137N3drAtRIzEpRpUNE8q6AZSLwLwSDLZaM69mZ
   IKSCVcUBDAF7Qs8j3KVQdcN9ZXEy0Jqey1o8yJfdZRcXBXbeODqN+Dfqu
   ujNOY4K5wMmqbMuJX80ILxw8V/n0TyNay650i3JIci3pvGDNCMfiBwxm2
   zh7AOzJuVENhe37JfMJVOMEkR6Sug1AnSyhsbJ7CK87ZKH3i/UGi6MSO6
   RopYAIKcpjLq7hUsqCWrUmw93+/R7XzWx1mOl2I0+3AzQJzbbin54aWHl
   jV3RRQjTDKbJtO8UC09rMCELb/PMVX51e+6A6D0ZzX6HnHNsDN6zZnW2H
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="421043331"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="421043331"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 08:30:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="819362796"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="819362796"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 31 May 2023 08:30:41 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 08:30:40 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 31 May 2023 08:30:40 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 31 May 2023 08:30:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RaOLXIXBMvSCO/IMxbmx4XEBSarjbOsqXlQVglXZtAzrR6z8vtNpumHuBhfxIbNsAcuj8KnAhHyfIjTmzt+X0GIjqzCS0GB+FCFx8otumHciAiDZPKuIZad1XRVvlIePq0FtyIlc8Rj9z3IRZ/bFhBAJuTbhtCEiJfMNzkElwb5QdqPYb5D3z3ZYPIGxu0AL2U7w2HEkJuv7fZbzWfGIckAGH+7AQeUEJCk6uOYG/gjgxxsp0pqjHwaJaU5k7bKayaf2qo5QFYcDzKlR2fz/02xmFxBFb5LWzHmgbVc4GmCCwXNmrwTqXgTNXGbD3GLkQ3F1T6u9fSL2gq94nn3WMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ueya3HYWuDg8pZ5t0rv4V8P3FlBl4DJZG8x6fIsXIsU=;
 b=YvNxMLrF1bmqoHD+Uy+Cy93thUaML88V7f6A2qH873psr178A4eeBj9NjSzbe7Cm6wZMtt0/ATaLlgKtY8nnpa9Ij/1GEES6/fubr4CH+TeVK53uHClDjLQ10YUMjQzFOeTZGm72iJYUvW69QE0EMdZFdHQi52cqHSbCgtLM12jkSFZQ1Z1iMxLriO0rcoz23YFAXBkjxWEdLRhbteHLXww79cOR3M2vteUCJbtgCHmMFvCRfsER//d9bZq76NThewi7WsSlYlNiiuukBnofgsX/PepZtU7IYSj41/Eci0B8jEnA6axIbbaR8/Hc9ag4aW6tFEQ4kxEyF30+ZG4L0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MW4PR11MB6691.namprd11.prod.outlook.com (2603:10b6:303:20f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 15:30:38 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590%2]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 15:30:37 +0000
Message-ID: <ca5098cc-6c02-d825-4365-4daca3b4f63f@intel.com>
Date: Wed, 31 May 2023 17:29:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v3 06/12] net: skbuff: don't include
 <net/page_pool.h> into <linux/skbuff.h>
Content-Language: en-US
From: Alexander Lobakin <aleksander.lobakin@intel.com>
To: Alexander H Duyck <alexander.duyck@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>, Michal Kubiak
	<michal.kubiak@intel.com>, Larysa Zaremba <larysa.zaremba@intel.com>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, Christoph Hellwig <hch@lst.de>, Paul Menzel
	<pmenzel@molgen.mpg.de>, <netdev@vger.kernel.org>,
	<intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>
References: <20230530150035.1943669-1-aleksander.lobakin@intel.com>
 <20230530150035.1943669-7-aleksander.lobakin@intel.com>
 <81d8da838601a2029e97937a952652039285cb4e.camel@gmail.com>
 <a6a29f13-68ae-c7f3-e4c2-30e23eabc888@intel.com>
In-Reply-To: <a6a29f13-68ae-c7f3-e4c2-30e23eabc888@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0169.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::11) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MW4PR11MB6691:EE_
X-MS-Office365-Filtering-Correlation-Id: 621da703-893b-49d3-3652-08db61ebfbdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CUOwFnVFWUihgfLyQ6Yk9fuq5cgDGisDBq1WAW4OjiO5QDGvWhJuTfIoF07bt9vf1RSfR8slZVhGdtX4UMijQ9t9yiA8hk65V93ScjHxtEFq88V3rKzNwF+AjuOJilex5/ywakSCAbQEQulVjs2jZcOtFqKLBi5H4+1LPK9Or4jBes2IzwnYhcpRrfwmjA7dVEhwq1Yy8XoRNDnAHGxKwSzpETVMsDM7Ns4IAnhOAVGadqZy29wX4ca3tliXnMT3ecownWfwByG0wG+YNFbr40jgqW6HBrY8wQ4kbDvGcoNkW/EqjzYyc91/7a/UCWgCj3yZa8WmOBiN47U5vIWHAoKnMILGUf6pvKxEeDGU78B/IvtO5lLiRZYcym+4/LwLsxM6F5K2qmSErxPCd0b09CcGTSRcmjpo6aKstJAGKbe6IMi6mQBMbFOqbF1JSN2hqNNZyFAVEWgk+/N0BYogrt8vREBcDJeYM6jIyPiNUtJdYQrgluwRfYbyBPNJSx+ltxFF8N79H5aK9iJE//yEhrGbukPx8AUPHBpOukN2+hJWJGtv81EPl8GIW37E0/d1nViZI9AfsXICo1ta+R3/2zf6pX2WpOX5b/vZF/ULPOepR+Y4yFKc7/izMxO6teOq65LmVr6nduXhNhubIiUJnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199021)(31686004)(6486002)(66946007)(6916009)(66476007)(66556008)(54906003)(4326008)(316002)(478600001)(86362001)(31696002)(36756003)(186003)(6506007)(6512007)(26005)(83380400001)(41300700001)(8936002)(8676002)(7416002)(2906002)(5660300002)(2616005)(82960400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzVlQ0xKWFJqb1hHcFBUUDl2VzM2M0lPRUp2dE9QTU54TTJ3U0JWc0lLZkVH?=
 =?utf-8?B?ejF5bUExVml3Mi8xUWZmRmpCUG9ZZWcvMlBTM3orL2wrSEJmejJGaFpTYnJ2?=
 =?utf-8?B?L3JNaWhsVkJLUmRNYmV5OVBWdk5DS1M3Mk1uLzl2bWRGeEVCa2NUNUFYSC8y?=
 =?utf-8?B?TVczbU81YzFRbnI4cE1RbXkyOGJuMkdCMTNGV2Y4VGEzbmV6T3FuZU4ydzJm?=
 =?utf-8?B?V3hOSGtjTXByMFV5K3ZQdGdKN2ZSRFI1bW9FSzFQaHBFNHU1enE0UTFEdnNi?=
 =?utf-8?B?RThTVWRLRWhZUVhxWTM4MG5aejNKbFFwT04yOFZlOWtUTFMrblZvVUhTUVZG?=
 =?utf-8?B?NGlhcG5jbExZU01YMzN3c1VHMDI5NjhHb3Q0T25BaEIzQm1XUFJYWVN6UEk0?=
 =?utf-8?B?ODFFRWd4VzNvQjlISVgxSTZkbjE4QmtTcWsvRmhxNkliaWlNMURyQ2xoSTZ6?=
 =?utf-8?B?c2d1Zzk2ZUVHdkV6Mnl0dGJvMFMxRzdFcjB4U2UwMFl0UFJGdmhlLzhXakRz?=
 =?utf-8?B?eFFnUStoVVY0MVJBazRZbFVqMm1mamVZOUFKZWpJMzEvbXQzMHBJTkpodUFX?=
 =?utf-8?B?VW1xVGRqLy8zQVJvdmlnM0YzVVFZekxqUHNTMStQTS8yT3VINExlb0dNMkp4?=
 =?utf-8?B?eXBIVzFHZUVFUWRsWXlaK0VHWlZWMUhVNDVURzQvanBqWXVIQmo4RGE4NzZi?=
 =?utf-8?B?bFBFS3dwUEwwWEpEVzc4eGx3bnkzdHhla1FURDZ4NFNIVFVEcmh2Vm0xUDJs?=
 =?utf-8?B?bjgvYjZ5K1pkTFNodVRqV3duU0M0K0RlU2RNamJyTnVYaGVHQTlJMjVDZUxr?=
 =?utf-8?B?UHlXRUFORnpMa05RMVFVdDV0QmR2R3dGRjdBbWhOOGRxb1FaS1pmZ0RuV1FH?=
 =?utf-8?B?SFZVYzV3SHM2cVMxZ3JheXJrSnBQTHJnOVRsT21lck1ReE0zZWh1UEJON1Zh?=
 =?utf-8?B?N2lyZ2FFa1Mzam1KNWdaTDkzQ0tRZzZwbEVCTTRLOWtFaWZLWkpSWWdUVXpu?=
 =?utf-8?B?d2ZtOXJuVFJKWTlZWHY1RkpBcWx0VzhEOTR0bmE3cE1OcUxHVjk0cjJrbWFr?=
 =?utf-8?B?TEpTWVVjUVd4cTJCVFNhYWJQWk9LR3BRenZFeERSQ2RGTHQrNHVGUjVGYkFj?=
 =?utf-8?B?eG43VHdqdXRHN2dkSlp3cEdXQkpGV2JzMWRvL1Y2UzhjQWFrRHNSYVdraUt6?=
 =?utf-8?B?T2hLcFBXbEdtZWNCbHFEMTdPZzVWK3FSOGdkQ1JaaU9GdWRjenRtQmVvY1o1?=
 =?utf-8?B?U1I1c2FnV3VYQjVORDBZSFpkUCttcVE1TEJIMml1VXExdUl0dDJYZURFRjha?=
 =?utf-8?B?QmhqWHl1bXRaSW9FczhYYnk0QktzU1l1M2ZRMDB0L0M0TUVFaFQ5bFJJdmU2?=
 =?utf-8?B?VHV1SmVCYUMxWGFHdW1lUnFjYkxQNWhZSkhXd2ZqSWg5MFlmQzFHVjVta0d2?=
 =?utf-8?B?VHpud3RYNVgxSnZEbGYvUy9ZSm9JNEowUnVycitzNWlNQllJeW5XR242U1pP?=
 =?utf-8?B?WU5ONnRGSDV4VkJBalhQdWIrT0M4cFM3UHZnRTduVThOUHR2b2l5dU1rRk9i?=
 =?utf-8?B?MGlyTlZxUGd5bVVHYkpOSFNRZXByblJEeE1VYzhWN0o1b05PSWtQc01HQytK?=
 =?utf-8?B?QjZFVTlCNWZuYjFFV1UwYlhzdkRSR21ibFoxMnU1cVdnM1Y5d0ltK1JTbXYz?=
 =?utf-8?B?ZXV2YXFuWEJGZzRHVG9UWmc3NkJNdVhvZEJWYnBIVGVpR1RYVm1lNHRZRk05?=
 =?utf-8?B?Zk9DcFVZcVdSNk5TdnJLNldEbGNtdkV2YmMvQ0xGSE1LSmc2TVhQbU5DRnV2?=
 =?utf-8?B?OWZObkN1Z3RvbEF5cUQwdTdHWEkxQjE0KzJ6Y0VoNnR3Qm1YY1VrRjVpUEJw?=
 =?utf-8?B?R2s2bm1Yc2d2RFNXejV3cVJteTNYYU55NEdjRmRKdGRmbVcwK2IyaSt1N3o1?=
 =?utf-8?B?MzV2Z3JjODRWV0VTVkh4cU9vZU5sWXJ0WDU4VjU5YkxaR3ZvT2pFNVJCZkpj?=
 =?utf-8?B?dGhoYTgvakFvbHFGcUFydGJpZzJvN3JNWUlCNjN6UXc1cTNaajhaYlJGQVNp?=
 =?utf-8?B?bjE3WE42M2k2QkRwWTBOSW9obklUcTUrTEZOSmVwZzNnaTViL2MvbWVWWXV6?=
 =?utf-8?B?a2piQm1CcEtvbEFWS3l2MEFKY3g1UlY2MWxITnFmeWpocXJRL0V6SnNPYUx0?=
 =?utf-8?B?M0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 621da703-893b-49d3-3652-08db61ebfbdf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 15:30:37.6598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWUBwnGayQLcCaj2DCDK8ZbgQybw4OgQZfnOR0bshqrJPoE8ug9Z9Db+obabsv6BNZJAht4tX2GPrkQedfm5Umq8ya88uYh/9xZpHUzbHB4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6691
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexander Lobakin <aleksander.lobakin@intel.com>
Date: Wed, 31 May 2023 17:28:30 +0200

> From: Alexander H Duyck <alexander.duyck@gmail.com>
> Date: Wed, 31 May 2023 08:21:03 -0700
> 
>> On Tue, 2023-05-30 at 17:00 +0200, Alexander Lobakin wrote:
>>> Currently, touching <net/page_pool.h> triggers a rebuild of more than
>>> a half of the kernel. That's because it's included in <linux/skbuff.h>.
>>>
>>> In 6a5bcd84e886 ("page_pool: Allow drivers to hint on SKB recycling"),
>>> Matteo included it to be able to call a couple functions defined there.
>>> Then, in 57f05bc2ab24 ("page_pool: keep pp info as long as page pool
>>> owns the page") one of the calls was removed, so only one left.
>>> It's call to page_pool_return_skb_page() in napi_frag_unref(). The
>>> function is external and doesn't have any dependencies. Having include
>>> of very niche page_pool.h only for that looks like an overkill.
>>> Instead, move the declaration of that function to skbuff.h itself, with
>>> a small comment that it's a special guest and should not be touched.
>>> Now, after a few include fixes in the drivers, touching page_pool.h
>>> only triggers rebuilding of the drivers using it and a couple core
>>> networking files.
>>>
>>> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
>>> ---
>>>  drivers/net/ethernet/engleder/tsnep_main.c               | 1 +
>>>  drivers/net/ethernet/freescale/fec_main.c                | 1 +
>>>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 1 +
>>>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c     | 1 +
>>>  drivers/net/ethernet/mellanox/mlx5/core/en/params.c      | 1 +
>>>  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c         | 1 +
>>>  drivers/net/wireless/mediatek/mt76/mt76.h                | 1 +
>>>  include/linux/skbuff.h                                   | 4 +++-
>>>  include/net/page_pool.h                                  | 2 --
>>>  9 files changed, 10 insertions(+), 3 deletions(-)
>>>
>>>
>>
>> <...>
>>
>>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>>> index 5951904413ab..6d5eee932b95 100644
>>> --- a/include/linux/skbuff.h
>>> +++ b/include/linux/skbuff.h
>>> @@ -32,7 +32,6 @@
>>>  #include <linux/if_packet.h>
>>>  #include <linux/llist.h>
>>>  #include <net/flow.h>
>>> -#include <net/page_pool.h>
>>>  #if IS_ENABLED(CONFIG_NF_CONNTRACK)
>>>  #include <linux/netfilter/nf_conntrack_common.h>
>>>  #endif
>>> @@ -3422,6 +3421,9 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
>>>  	__skb_frag_ref(&skb_shinfo(skb)->frags[f]);
>>>  }
>>>  
>>> +/* Internal from net/core/page_pool.c, do not use in drivers directly */
>>> +bool page_pool_return_skb_page(struct page *page, bool napi_safe);
>>> +
>>>  static inline void
>>>  napi_frag_unref(skb_frag_t *frag, bool recycle, bool napi_safe)
>>>  {
>>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>>> index 126f9e294389..2a9ce2aa6eb2 100644
>>> --- a/include/net/page_pool.h
>>> +++ b/include/net/page_pool.h
>>> @@ -240,8 +240,6 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
>>>  	return pool->p.dma_dir;
>>>  }
>>>  
>>> -bool page_pool_return_skb_page(struct page *page, bool napi_safe);
>>> -
>>>  struct page_pool *page_pool_create(const struct page_pool_params *params);
>>>  
>>>  struct xdp_mem_info;
>>
>> So the code as-is works, so I am providing my "Reviewed-by".
>> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
>>
>> Consider the rest of this a suggestion or a "nice to have".
>>
>> I wonder if we shouldn't also look at restructuring the function and
>> just moving it to net/core/skbuff.c somewhere next to skb_pp_recycle.
>>
>> I suspect we could look at pulling parts of it out as well. The
>> pp_magic check should always be succeeding unless we have pages getting
>> routed the wrong way somewhere. So maybe we should look at pulling it
>> out and moving it to another part of the path such as
>> __page_pool_put_page() and making it a bit more visible to catch those
>> cases.
> 
> I've just noticed that this function is exported with no modular users ._.

^^^ pls ignore this nonsense lol

> Anyway, I feel like it's a good way to go. The entire function, apart
> from the magic check, can be moved and made static. And the magic can be
> moved one level up, right...
> v4 will happen either way I guess, so maybe I'll replace this patch with
> that kinda change.
> 
> Thanks,
> Olek 

