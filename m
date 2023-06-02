Return-Path: <netdev+bounces-7433-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ABEE2720409
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:11:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC49A1C20E86
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:11:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6970319925;
	Fri,  2 Jun 2023 14:11:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CE219914
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 14:11:20 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D04E41;
	Fri,  2 Jun 2023 07:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685715077; x=1717251077;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WEuoE/22upTwizbkHAb7wUpNSG3W8irAh4ohOv/LZqg=;
  b=R0tS5/Ye557sJoOJsD4+dga5MjVDBaGqwEvksS9UVke29PvkpsnVKjRW
   3U133g0QsRc9m0bjkryuBZdPSNHsJJqWZW+vsHNN6lN5dUfqawe6+w5CJ
   7P0kTA35dQPLVLvacxaReBUDbpm9UdvVcK0V2K8iFeoVN/yyQG4st4bBI
   PK7c1l9UPFTBQDnBW3WYLXsLsqlkDIIlKI3HWeu/cP1VQYqTwagGVpL2u
   5AAiVu1HJlHvjoYbmg+bTzNpLSD9dmg52UoWpa6wNhyPJY4E5vzGmUwbT
   LBD0khKmPUlUIhbtQMhlx7LeiBmazKHAD7OB+h7JeMalDWvSFlLo7wqvJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="358304507"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="358304507"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 07:11:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="954519429"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="954519429"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 02 Jun 2023 07:11:15 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 2 Jun 2023 07:11:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 2 Jun 2023 07:11:14 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 2 Jun 2023 07:11:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CItDVID7pHz2ZdZPtxmYT+BSpdxIunITc5L15EUpPhPcnzDvlL7VaszQocp+vLOdmAHxMbmnze4WNauh1gyRLT/myB6HKEA5U3z2vyu5y4GS6/D06XIJLc4tWI87Z68xWes75kMZIz8gYlXuPMaEHVwMFf5rzxiJKq/d0hFfbowC31hDoFdWwJgtw2pe/KKHNd2fEn3dR5eK8dBH84ZnB006MLbt7WuW+BttkeVqmqsk5StKf54muG6uuikpRw7tXOUb1PUBLqao+yKZJTvldtYXkzrctC7UTd61N6Z7piPWrCI8hvKLK2JiMtSaoxBHQguIHApxByzWH6POEmyhgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3eMyqX2JRqTFXhLrpKxauvgAy2xb9DiseyaPy3Gntx0=;
 b=Ot6c0KnS+72ecJOl760Ayea+e9nRA66+J2lOeOU5eoZ6IjArfLdIuKhQ7h2wK5mo0Awias1Y/Mm6pvdGf9lQg94Juj7pAUQrjKMu5vhuH9WWmM5QnGNNl35fvjn7JcX7cci4u81e57tAPiR6IWFChtXgaDXCc81K1HrUbJ6zwmkJ505fuBI416+uk0coOjI13aGJTV2xfCyoSvkx5mkkyKLmwH5bw5v3AFDLNaYm41m29YLmBR0all30w84GeSiluCinOSUEOqYvIa6X8zFmFvaAH/agUEz/TeoSqp5FGJiVMf2yk4R5MWCtqqyKZ1mwu1ad6+sdFUG0bfUhdxhUig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM6PR11MB4563.namprd11.prod.outlook.com (2603:10b6:5:28e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.26; Fri, 2 Jun
 2023 14:11:12 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.024; Fri, 2 Jun 2023
 14:11:12 +0000
Message-ID: <97d2efe0-599b-70d3-16ca-1dbab13eb2b1@intel.com>
Date: Fri, 2 Jun 2023 16:09:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v3 03/12] iavf: optimize Rx buffer allocation a
 bunch
Content-Language: en-US
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Magnus Karlsson <magnus.karlsson@intel.com>, "Michal
 Kubiak" <michal.kubiak@intel.com>, Larysa Zaremba <larysa.zaremba@intel.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, Christoph Hellwig <hch@lst.de>, Paul Menzel
	<pmenzel@molgen.mpg.de>, <netdev@vger.kernel.org>,
	<intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>
References: <20230530150035.1943669-1-aleksander.lobakin@intel.com>
 <20230530150035.1943669-4-aleksander.lobakin@intel.com>
 <ZHd4UPXgNaJlmyv1@boxer>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <ZHd4UPXgNaJlmyv1@boxer>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0068.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::12) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM6PR11MB4563:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c8d5f3f-ff20-4e40-11a6-08db63733888
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KOFwKI8m8XEfndI7cL1iUaFXraEoYMr9M4q2Woc3V2/9OhQe7XmP1LU/B5MRaqSlFaSBh05iY2Qs87z01JZmvGrTFHnJjCSMad31BjVATMpXiBMd+2X7KNHLel4akf5FN6DP2CDDctQiqzVMcrnhbzBr/C79X/wkMhkaKS/G9lVxO7gf+ruQqeI+x7lXP+jJ23ePvssRowyTAc6oggIEJk/A7k0f+aZy4lQcYF/ZTp4UpRTOB6YBVdBtYLrnw48OAnwTt8ym3qUAx6pZWXPGmyCcCwlHdiZwdxZ9mTVBtyjcOETuPOl+UcNrdFj6z4H/KzPHR4QS6RcS3auxm6MIwjyBZOdN7MW6zAct23n3/dU469gLG4XSTrAPiY0QnX8N7klmtsElTI57cP9mS6x6rtRE11ToRpfhOIgm9RjFzYr+VT1VF1EpUPunTDOkc1UXSdFo2vUZl/pyxEF+Hmm4ifJjTMXjjvY2jd1VLKpwaywV6eTn17VeDWdj/+LTE9iSjsn6UJXYxjvWJCV61XzoyZ9n/N/PtTnXV6reWCoHgWhQN2DykZj8BCyFOq5qRi8iUI0ksJ7nIba4WaRfsXfGYQ0PqB+Wypvzt7GOxiJCe8q5/gRjVvSTEa5w86C4YVxkRkUKjFl69bJ2y/lK2kJU3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199021)(8936002)(8676002)(6862004)(66946007)(31686004)(5660300002)(7416002)(4326008)(6636002)(66556008)(316002)(66476007)(41300700001)(2906002)(54906003)(37006003)(6666004)(478600001)(6486002)(6512007)(6506007)(26005)(186003)(2616005)(36756003)(82960400001)(83380400001)(38100700002)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTBoUWNCeGRiZkVqcmVtUE1FS3Z0WGJOMTA1cFhWSlp2VW9UdVkwSlp6L0pZ?=
 =?utf-8?B?NGYzNG80bHl3QmRudVF6RXhsRE1HMFpmUEhQaHBQQkJKN000N2lYM3lqMmtI?=
 =?utf-8?B?ZmlGYThBRlhVMUNtZ0FLS2JmNjJJZ0Z1U1UvVUE2MU5kTVVlaVNWN0x3UnNs?=
 =?utf-8?B?ZHpuM3hWNXBiTzN5YUxwRElsRE9QL3AzdnNaWnZ5Qlc5d25uK1AwZEFtYnRI?=
 =?utf-8?B?R3l3ZklML3ppRkhwcjA0SHlJTStTODZXNWNJWmhZK3dnekhERnVKV3l2TzRP?=
 =?utf-8?B?aDVZY01kSDNHa1NIVDk4N0tuSTJDRkJBS1RhOFkzcC8xTHh5a0tldkJxZGRq?=
 =?utf-8?B?Y2VYNjZqMFJ6SmszMytuazVKcW02WXZYOTBqT1k4b3RqSUFpRDd2dFJsVURD?=
 =?utf-8?B?MEdua29jUk5JdHlCQzVoN00zdVFLSEFTd2lIdm5lVnhERkZaeEEwTVBrWnF5?=
 =?utf-8?B?aXlKdTN2MFJoVjQ0T251VDNuL3dQS0x6QkdzUllLVHlVUkV5Skduc2pjdmho?=
 =?utf-8?B?TWw2RFEyVWJHbnhoOEx4Nm5SOVExRGZRZldxcSttaThML2VqdXkxQW5jRU1R?=
 =?utf-8?B?WkVsWGwzdEVyb1hRZ0FHNFBzZjdvUVNSTS8wSDUrbXB3TXRxYVJRa3B5ejYz?=
 =?utf-8?B?SE5pMjhmWmlzZGNmUTdHV0pXY0Y1M1FabytpcHpjNU8vNzd2SS92bzJBQnM4?=
 =?utf-8?B?MG9VVHhaTkRBcmtFalBvcUFTbkEydnZtRHZzVEVMd2dEL251elFMenc2V3RQ?=
 =?utf-8?B?V3lRMUVWK202VUN4aDQyZVJpN2RWMGpLWmUvSVFlREN1ZjUzYW1IZ0M3Qit1?=
 =?utf-8?B?TjJ2RVZjRjBzVEcrREtGa2ErcWEwL1QxenZpdnNpaS84cGxESTFaSWFsTExN?=
 =?utf-8?B?QXJEcGU3WkNPZFo1YlZiVXNnc1R4d2RnTG1xRGJYWnZ0ZUpIRXJZeGJpNXQ1?=
 =?utf-8?B?R1pYeCsvZXZMMXZ3M2FybmFNRDNsVmpkV1dwemNRSFN5WjgzTkcyTXAwdjdJ?=
 =?utf-8?B?bkNrRmpLR0ZVazljbzloNitQQlZ4MkdiU2ZOdldiQUdVYzU4cWF5TGs2bjlN?=
 =?utf-8?B?bE12TWd3ZjRoVlpEMDJua0hGTVZ6aXoybVZwWDVFb1dOdzFxR1Boa2VkR0Fx?=
 =?utf-8?B?RVRxSVlZTHF2Nk12Z0daSFg1ai80RndtZk44SDNRWUFiUW9ySTE2WU5MK2NK?=
 =?utf-8?B?UTlBbXZjbFBadVJHY1h6V0JJdFdGZVBhY3I1dFdPVzdUREZwS090UVZTWjF4?=
 =?utf-8?B?Rnl5cjgyb3Jwai9JVFV3cDhBdmxMV29WMlBRMEowVjY1dWluTVdRUjMvcERr?=
 =?utf-8?B?Y3Y3RGN6U201SmpaYlR1K2RIdGxqbERMRjE2L09ZanJsbFVSWHFNT2JJU1hE?=
 =?utf-8?B?ZXQ0MmlOVHNOZmNQTkVzV3F4a2pvcTBjTWtuZldKU1U1dEhXangzdXRQSzJU?=
 =?utf-8?B?MmhlVGhkeXdIc0MxUzJuZGQ2cmRiMUZ0cnROUGNLZTVZNkI5czJxQ1JCbXVJ?=
 =?utf-8?B?NENTdzFJVC9VbzN0cHZYUXhsVzdLbkozTzcrQVJ3NDhYcmZKSEpVNDRpSGtW?=
 =?utf-8?B?SGFrZUFxMDNsUFJicitxNjF2Rkg5MG1HaVYwQWFaakszNXdPMGo5UWVkZFIz?=
 =?utf-8?B?ekhsNFpaSmdoc3pyVDZBT1JVNDFnb3FDVXBQZWJVRDd1WUovTXNSemJkVUt2?=
 =?utf-8?B?MFlpZWI4dkhYdWdZRDBiUm9FU2RMRU9vOWdtUElENmptRENWYUJMT0l6U0tI?=
 =?utf-8?B?TkMwUC8rNms1MGFodEVGOFB3bnczTExDUEVFVUpiYWltdWkrNndqSnJDamVa?=
 =?utf-8?B?YlAwbHZScm5haDJid015clArVXU4Y05JcFIvZk9nT3dYRHh5Zm9hSXpBcWZy?=
 =?utf-8?B?SlNnVE91YlVVbXVFaS83eUhaMVRpdHhsV1E5RWFHbzV6QWhTc3lzN3g5SG1P?=
 =?utf-8?B?bnFKcjlxdUlaRHVsQVJKNHdxbVppT3J0a2hBWkU4ZGJiUnBpdHJmNld0OFdn?=
 =?utf-8?B?TGgrZkVxdndXTzgzUXhYZmNpTE51dkxEOTA2SlVML01ReDhyMVNNRDczUDNm?=
 =?utf-8?B?UW1GTHBabWpLZnJwaTBqakpMVm9Kb3ptL052cVhiU3BvbVJadlYzdWI2ZUFN?=
 =?utf-8?B?Qmk0RW43eEtlSjlFV01VWm9KN3QrV2VqQUVhVmtBeGc5WlptbmRhbWVjMXBq?=
 =?utf-8?B?Tnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c8d5f3f-ff20-4e40-11a6-08db63733888
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 14:11:12.5849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VWHZDEnLHIzTdqBxg+hLa1YTzqiwb9OAcI3tGnxcu07Kf2bXv4LxDfyjC1MFdhhMgiDSHdjdg0xCEFDSge9ssIsTObA5t8QA7cOfLRi+Ad8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4563
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date: Wed, 31 May 2023 18:39:44 +0200

> On Tue, May 30, 2023 at 05:00:26PM +0200, Alexander Lobakin wrote:
>> The Rx hotpath code of IAVF is not well-optimized TBH. Before doing any
>> further buffer model changes, shake it up a bit. Notably:
>>
>> 1. Cache more variables on the stack.
>>    DMA device, Rx page size, NTC -- these are the most common things
>>    used all throughout the hotpath, often in loops on each iteration.
>>    Instead of fetching (or even calculating, as with the page size) them
>>    from the ring all the time, cache them on the stack at the beginning
>>    of the NAPI polling callback. NTC will be written back at the end,
>>    the rest are used read-only, so no sync needed.
> 
> I like calculating page size once per napi istance. Reduces a bunch of
> branches ;)
> 
> Yet another optimization I did on other drivers was to store rx_offset
> within ring struct. I skipped iavf for some reason. I can follow-up with
> that, but I'm bringing this up so we keep an eye on it.

rx_offset is stored as Page Pool param in its struct. So no follow-ups
here needed :)

[...]

>> 3. Don't allocate with %GPF_ATOMIC on ifup.
> 
> s/GPF/GFP

Breh :s

> 
>>    This involved introducing the @gfp parameter to a couple functions.
>>    Doesn't change anything for Rx -> softirq.
>> 4. 1 budget unit == 1 descriptor, not skb.
>>    There could be underflow when receiving a lot of fragmented frames.
>>    If each of them would consist of 2 frags, it means that we'd process
>>    64 descriptors at the point where we pass the 32th skb to the stack.
>>    But the driver would count that only as a half, which could make NAPI
>>    re-enable interrupts prematurely and create unnecessary CPU load.
> 
> How would this affect 9k MTU workloads?

Not measured =\ But I feel like I'll drop this bullet, so will see.

> 
>> 5. Shortcut !size case.
>>    It's super rare, but possible -- for example, if the last buffer of
>>    the fragmented frame contained only FCS, which was then stripped by
>>    the HW. Instead of checking for size several times when processing,
>>    quickly reuse the buffer and jump to the skb fields part.
> 
> would be good to say about pagecnt_bias handling.

?? Bias is changed only when the buffer contains data, in this case it's
not changed, so the buffer is ready to be reused.

[...]

>> Function: add/remove: 4/2 grow/shrink: 0/5 up/down: 473/-647 (-174)
>>
>> + up to 2% performance.
> 
> I am sort of not buying that. You are removing iavf_reuse_rx_page() here
> which is responsible for reusing the page, but on next patch that is
> supposed to avoid page split perf drops by 30%. A bit confusing?

Nope. reuse_rx_page() only adds overhead since it moves reusable buffers
around the ring, while without it they get reused in-place. That's why
it doesn't cause any regressions. The next patch removes page reuse
completely, hence the perf changes.

[...]

>> -static void iavf_reuse_rx_page(struct iavf_ring *rx_ring,
>> -			       struct iavf_rx_buffer *old_buff)
> 
> this is recycling logic so i feel this removal belongs to patch 04, right?

(above)

> 
>> -{
>> -	struct iavf_rx_buffer *new_buff;
>> -	u16 nta = rx_ring->next_to_alloc;


[...]

>> -static struct iavf_rx_buffer *iavf_get_rx_buffer(struct iavf_ring *rx_ring,
>> -						 const unsigned int size)
>> +static void iavf_sync_rx_buffer(struct device *dev, struct iavf_rx_buffer *buf,
>> +				u32 size)
> 
> you have peeled out all of the contents of this function, why not calling
> dma_sync_single_range_for_cpu() directly?

Pretty long line, so I decided to leave it here. It gets removed anyway
when Page Pool is here.

[...]

>>  	if (iavf_can_reuse_rx_page(rx_buffer)) {
>> -		/* hand second half of page back to the ring */
>> -		iavf_reuse_rx_page(rx_ring, rx_buffer);
>>  		rx_ring->rx_stats.page_reuse_count++;
> 
> what is the purpose of not reusing the page but bumping the meaningless
> stat? ;)

Also above. It's reused, just not moved around the ring :D

[...]

>> +		/* Very rare, but possible case. The most common reason:
>> +		 * the last fragment contained FCS only, which was then

                            ^^^^^^^^

>> +		 * stripped by the HW.
> 
> you could also mention this is happening for fragmented frames

Mmm?

> 
>> +		 */
>> +		if (unlikely(!size))
>> +			goto skip_data;
Thanks,
Olek

