Return-Path: <netdev+bounces-7421-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD017720335
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B02C281826
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 13:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7832718C36;
	Fri,  2 Jun 2023 13:26:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C035111B8
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 13:26:28 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A5CC0;
	Fri,  2 Jun 2023 06:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685712386; x=1717248386;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F+jFBPjA2PM/zdWr/IN8gpY1bay6RM6w6vmRW4jfL3Y=;
  b=YPhf69GZdDaG89GLqAgrqST1qSFIzqr/j/VKgpmGTyR7DX2fpFzplTBv
   7aHlozJk7ya3vesW0JqmIS75S/vooiQxQrmy9+1oBBihA4xDnIaoZxDfx
   BVuyyMwp91B1IL+qLgn6BqSGLKFcIQdMO1fLWvwKGBXTNraUWwBAXSdKo
   6Ry91lVHgxxdoCfvnHtvr65pxLC6hUbcCbxz9dMhqW8twMYW5NjRCkksv
   gxmIxyTGG4sdwZs0SF+yW5HDDTaIRZuY8+harbApD8EIFKKbAG8b+0hgR
   rF0ODdrUhLI+tbePjIHng32OMMbCevzbT9SOuL1b2PhzlkJlfHyGIfqTO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="353361341"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="353361341"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 06:26:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="658274186"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="658274186"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 02 Jun 2023 06:26:23 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 2 Jun 2023 06:26:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 2 Jun 2023 06:26:23 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 2 Jun 2023 06:26:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JP1MJohTvHZ62+DtnIc5EQKxcGGT1wKeNeCRscgxDn3ZumEjLkYODy2rPC3X2usUF4D9kqh8fxYEnlluYxcKESLvJF5kIVCy/m5+PCT8LliC799axaJzKzTYnGiJz2HUdPMRQ6pI0Tk+/x/C6gPfuIIH6VSuBl8vrxp7IpHSa6TqXqJ/DQ8P1sJF/1bpzhThneLxyXE77iuHf/4TAokPJOY1dsZkBRG0Rkcz9pPRGCNH3K5kyFE6ob2ab+ifYT6hAgidnFA9q7YSOGd9I/CK4nd0rwy5++Lr7df7/VK0mEhIH+BGCG9dqSYwRsdv+7QG5wVqCykihN/V5QF6A2EOOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=okOuT5Oezjntbf8muW8Ukvmp+r+/bMXhJdwL1kwKXrE=;
 b=dYNkaZ7o2DIg9eJ3zIeq7VqUeHyTtRLnHHcfe4ybKoHVooTuPzVCq6R28qDv5TGeAMJalSQFTz9TSQ8HLtxuU452JPLkTuBLYTyF0osznQSXbKYnw/Dgb0hu8HmT/gZcEmwoBoOSBB7fG6yx6L/3CSesjC/yIwxyW3YMDTovDs3UHiYkbp2no9t3qAvS3t5wsn0Na4GoKwMIc7crY2KsGWzTlqiX8fdLtcC0TXTuST6zIfoxFu2GaebazJXGSakJSnvOKcFZPsxCQJlEoVdMJMUaMQk2FsuVnD/OwnYtNL4+06acxowuQ0Fv0ZGxF8iiPj/ufCdAe3b8liUjhPDvtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BL1PR11MB5541.namprd11.prod.outlook.com (2603:10b6:208:31f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.26; Fri, 2 Jun
 2023 13:26:20 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.024; Fri, 2 Jun 2023
 13:26:20 +0000
Message-ID: <069f9d40-d72f-0357-f2d1-69defd16d327@intel.com>
Date: Fri, 2 Jun 2023 15:25:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next 08/11] iavf: switch to Page Pool
Content-Language: en-US
To: David Christensen <drc@linux.vnet.ibm.com>
CC: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>, Michal Kubiak
	<michal.kubiak@intel.com>, Larysa Zaremba <larysa.zaremba@intel.com>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, Christoph Hellwig <hch@lst.de>,
	<netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
	<linux-kernel@vger.kernel.org>
References: <20230516161841.37138-1-aleksander.lobakin@intel.com>
 <20230516161841.37138-9-aleksander.lobakin@intel.com>
 <4c6723df-5d40-2504-fcdc-dfdc2047f92c@linux.vnet.ibm.com>
 <8302be1b-416a-de32-c43b-73bd378f8122@intel.com>
 <002e833e-33b0-54d4-8584-9366850a7956@linux.vnet.ibm.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <002e833e-33b0-54d4-8584-9366850a7956@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0139.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BL1PR11MB5541:EE_
X-MS-Office365-Filtering-Correlation-Id: 12d48a30-37ca-4ebb-5df3-08db636cf339
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lmd/00Y0baYiMit5+I3Z7OF9lwAvURTNgRP1Gjk3+iSGD3yyri/nxiCvJwelv9bsOom1TThWn/QHHGVjk/mCkw0wmOSgiGxWfa9UAITvLUX6XsygNts/2jMwyBOkhfZ7sB9omf8fL0jYQtjoVoFcQTAPSLM7QhVPYgs5lvKmJXYTP9HHiVNdQGCidYR7HDvSX/HKcMgxQk80lwme2FFjgPq05scmvtQB9yyz8bP0Ve5ngQtLaLK+3qUoVLKOOMqaRHGRYF4q3aToGMRGEbqIvc43RE9IhQw52S+vr1UBKiSup5ODo39NIn/bQgZfhM3jS2detqLP1VpHBO+8MASq3YEQzvZR+xAjxVR9dTuo47PeyL7o0EH2RmR8N5BaCLbLEhL04Ih3bC7G6s+feaF8reR2mz0LHENj3pCk+eFwToFPrEr2VxrtycDs0IFWfF0AJqocmRTklolGPPhIBtQgQqxWnBoSTTRyQ4aSCw0WksOHG/mv4JamMTE+HWXTIBDbfOIdQ1iY1oe6q5kpJvr2Zx+i33uPoAqPxLXDhUhNdZaXpkiG4HO4ToMgqPi6jDL9khE5wNHGw9hr4AlJ0dYjVIo+/dPqm5qrKK5OEkOenBXjxn7n0Dfv4ofcJewUHlwBUN/DvyYiaD5A86eDfGT0lA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199021)(8936002)(8676002)(66946007)(31686004)(5660300002)(7416002)(4326008)(6916009)(66556008)(316002)(66476007)(41300700001)(2906002)(54906003)(6666004)(478600001)(6486002)(6512007)(6506007)(26005)(53546011)(186003)(2616005)(36756003)(82960400001)(83380400001)(38100700002)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3V5OVJZTjFyQktvam9lYTQ0dU8vQTk0aTAzSW1oSXVTN1czY3NzM2hTNkxs?=
 =?utf-8?B?TTZMUkdienRXMWlaUE5yMElJeDczc1dMcVQrYzR3VTI3MVlXdkNoclB5YTJr?=
 =?utf-8?B?QUxWa0JXaUZwVUR0UWdVb25rSTNBYWZRbkltdk1kRmtoY05wVHN5REUwMklS?=
 =?utf-8?B?Qmo5bnZabHJ5WWVzbm91QUx5MEQ2Sm5JQWs1QWxvVUluOFB6WGRHdnFGUDVx?=
 =?utf-8?B?TlEzZzhDSkpRNmRvdE54SmdxYVBhRnVRUGprODhNb056dTB1UEJBNWxlMmFV?=
 =?utf-8?B?NjBvbElUMjlhVllSNmQ0ckVrbFM4WGlaYldkNGFMMVRwT0dUV21oM2E5OVB4?=
 =?utf-8?B?ZFV3VWpSelhPc1V3VElvS00xOXo0QkJKdlQzNEZ0Zk15RzF1TnRKSzk0ZDdC?=
 =?utf-8?B?bTFDVWM2dDJ0bENQb1EyUUJKVkF4ZXNZbGhWSHpRL3AwcXo1c04vZUZKYlcv?=
 =?utf-8?B?bEsrVzlOMmFnazFQR25yTHBKTURWcWNqTTh5b1VneGpzNnBBTndSa0J0TGlJ?=
 =?utf-8?B?RnVvazZIYmxUVlp2Ni96TVo4WVI3bHYwU0t4eWc0MHhHTW9McjN6emZzZGJ3?=
 =?utf-8?B?UWcramp0djVoU0MzL0szUGloaFZSelBsTXRRN21LL2E5cm1uZTB2NFlCNmFW?=
 =?utf-8?B?c2NoS3poOFRhejVzUlFYSUg2NzJXU09KSmVwejFJM2FKcjlkKzlua09KbHZo?=
 =?utf-8?B?T1c1Z29CVGNwcjN3L0Z4bU42MGo2VG1EaUhaOTZWYTYwUldNQllabk9QN2tF?=
 =?utf-8?B?aVUvdHNuZU83SGxtd0NTUlp6L1lqVUdPa1RYSjBkQ21yamorYnhsVUZzOEph?=
 =?utf-8?B?bjc0RTFwRDhaeUpzTERBMmNyR01sL0wxSGpUZXE0WjF4Rm5PL2hnNmFEclRo?=
 =?utf-8?B?MXI2d0Y0R3FBL3BUTmNBbFQxSm9SU2FlSDByeHAvNnBGWWNZZEhCa216OHJ4?=
 =?utf-8?B?QTNJNWVWNkFmaW5wdXVad3NleTRoa2xNV09PSEF6aVk0eTdPY003V3Z3SDF4?=
 =?utf-8?B?Y2t4Sldza1VRUHNjYmt1b2tucUFucG1OUnpsKzhWaDdsbWxnRXloMmxKdCtw?=
 =?utf-8?B?N3lPQTRpUEhoZktTVG9QTXk5M0IyckdseTUzT0w2TytzMlMvK0NVOEJ1NlY3?=
 =?utf-8?B?bU9MRy80ZjVhZWNubzlyK056UkZhb2VVRTlWUjZFTjhDOWpsek5IaFhvdmNM?=
 =?utf-8?B?T3BYc0JrV3o1bWxub2JMR3hKL3dFQlM5M1prM29zaWJyOHdyQnlyNXpETFlU?=
 =?utf-8?B?RzhQRThYeENRWmowV2twdDZndFU0VFlyUUwwcTh1M1J2NTRrd3FmTi8wNEdz?=
 =?utf-8?B?Ty9tTHZaaUQ5V1ZlUE5JTC9qREltRE4xSXVSS1F4RjZFZnB2UXlvc3hDUmFj?=
 =?utf-8?B?WFAwZlZvR3FRcVVWekVHRURyRzY1eks2WllYNWFQWXN6ZkRRemNjWXBQMU81?=
 =?utf-8?B?YlppRWhlOWo2UDdORWYrY0ZhSkd3NmVpQTZ4aXZTeGpYWk1mNElLZjFXbW1v?=
 =?utf-8?B?ZkZaOFFUcFlmWWxaNTF1cWVwNFVDZnZvdWxmR3dTRkxYbFg3Vnd6MC92NzBW?=
 =?utf-8?B?Zjc1N2hsZWhOclcyYVJPZThISitkaVRFS1V0aXNXNmVnNG1tWWtMSFgxckxG?=
 =?utf-8?B?MzA4MEJuVW42bzAyMDFseGFxMnVhTHU0UkZ6NUZtQnltYTRyYmRaMXNTT1k4?=
 =?utf-8?B?NkhQQWxMdEE3OXhTMUM0cUJQTkVCZnhTYnp2KzBHRHpLTUM2ejU0dURDZkV0?=
 =?utf-8?B?bWUwbWI0YU5QWXBZcjJkM0NiSlpvMUU2Rmo4VGFhVmd6K3FCcVBqQ2NCbUZr?=
 =?utf-8?B?U25JZVdjb0dFVDNyODI4Y2VnMGpjQXBrR3FTV2x4VDJEWTZZYmpNTHlLL3lU?=
 =?utf-8?B?ZGNWeG9iam03R2Z0cmFtTm82TW9qelVWK3ZDWE1SVDk5WXpwTlFJdmpGUUdE?=
 =?utf-8?B?d3lhZjVuNU1WaVpKMTRDcHVSRUhjejhNeC93OFlPQnBsNlJzOW9uS1lmcUtq?=
 =?utf-8?B?Mlc0anpQeHFpR0p1ZG1WQUEvbmZlaUdOZGpyV0ZmbGZiMWJyYXdmNzFsbVVm?=
 =?utf-8?B?V0g0Z2UwUjRZdjlqcDRyZWRvb09aR0IycjhRRTVRdlFQR2l1cVkybkJyT3dT?=
 =?utf-8?B?TTU2M25Ddk9iN0doWmVFcm1RQUlEbWErR0QyUnJPM09Md1lROVNQdkVwQUMv?=
 =?utf-8?B?S0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 12d48a30-37ca-4ebb-5df3-08db636cf339
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 13:26:19.6860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wCxyTFhcvHKffoUjIWeyGZ/TL4FIyC0ZBRD4p4XCZYUXw/KNFwcWPW9iM4KZLfJBkI41urht27YaggmsjXvFFK5lXTualAKTjoJIs3pJ3kM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5541
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: David Christensen <drc@linux.vnet.ibm.com>
Date: Wed, 31 May 2023 13:18:59 -0700

> 
> 
> On 5/25/23 4:08 AM, Alexander Lobakin wrote:
>>> Any plans to add page pool fragmentation support (i.e.
>>> PP_FLAG_PAGE_FRAG) in the future to better support architectures with
>>> larger page sizes such as 64KB on ppc64le?
>>
>> Currently no, we resigned from page fragmentation due to the complexity
>> and restrictions it provides for no benefits on x86_64. But I remember
>> that pages > 4 Kb exist (I have a couple MIPS boards where I have fun
>> sometimes and page size is set to 16 Kb there. But still always use 1
>> page per frame).
>> By "better support" you mean reducing memory usage or something else?
> 
> Yes, reducing memory waste.  Current generation P10 systems default to
> quad-port, 10Gb copper i40e NICs.  When you combine a large number of
> CPUs, and therefore a large number of RX queues, with a 64KB page
> allocation per packet, memory usage can balloon very quickly as you add
> additional ports.

Yeah, I got it. Unfortunately, page split adds a bunch of overhead for
no benefit on 4k systems. There's a small series here on netdev which
tries to combine frag and non-frag allocations in Page Pool, so that
there will be no overhead on 4k systems and no memory waste on 8k+ ones.

> 
> Would you be open to patches to address this further down the road as
> your refactoring effort gets closer to completion?

Let's see how the abovementioned effort goes. I feel like a generic
solution would be better than trying to handle that per-driver.

> 
> Dave

Thanks,
Olek

