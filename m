Return-Path: <netdev+bounces-3647-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FF647082A1
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:27:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C26D1C210A2
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5368223C95;
	Thu, 18 May 2023 13:27:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEE123C85
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 13:27:21 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26867135;
	Thu, 18 May 2023 06:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684416440; x=1715952440;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0MbzgNGEDFHZv80yx2X4syApoBhyXvFFcyC9ihnfOrg=;
  b=VPNxQjWxIj8TRB03ojy9M6KRYO+eL94OS8+rfdPe/RoKpzWHpVBpH0Wc
   7G+TSXlByoxFDZt4+LvXltbnFekMiHY8A7a7vUPhWepJH8wdS/i0KZxsE
   +ieCtpCve6N/sWCv0eqxJ1DTVZOsyjn10Iw/cums7S9oQZhbdxZHUubzE
   NKzWP7ST2lTmcvZjjfk27UUHb08KjQkJ0b0V0sUInU70zMsFCMklUqb4i
   w+T5QcIA7n7Uyt+WfOfGWbUQun19qsVFlA45WmUvcjbuld4gHxqaCfVJf
   t7FwgWsLv0Klu+/+DucqAHsrHo4uhAGc6hUv4hcb8h+L8Gkx4g7x5FGh+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="438405729"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="438405729"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 06:27:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="791973807"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="791973807"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 18 May 2023 06:27:19 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 06:27:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 06:27:18 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 18 May 2023 06:27:18 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 18 May 2023 06:27:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTjrhMbJ+7EckVcwqWeBJqJEp0NLWY5OjTsme37z1St4LrXqejytYSarR2L/BLyVgnz3tMB9xDq7a0TrA0BkIlG+fgpO+VKftwh3rno4br74F7U0ckKQ5xuuuK2v/4VfMI/WqYWgR0HeggzQCF+2PrqrHQQmhmfVW1bCZpg1lsVsDiyQbw3xLMF3ScoT4qecskPo9kPM5AvYc8EzexIaISInaAoc9l59G8Fvv93ixRwWwVBEO2oCp6w23L7xa7/GC+N2rHw9I6aaITMam+6AWIvRHYR1GcwY0Rbi4/7YGInOHrFw1UQmqMVw+QClYHzOqfBpNNsc8umtmgTpn3BqYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CgAjGcAB2U6SIkmId8wbtmMF66TELO7fU3IVO6AoLgo=;
 b=iy2Yt6e9ZQ67PpN85bdWow0MVXimz/cIH6f8SOidNsQ8ejXVkhWRn1Nu8gs1ig2R4HJ294zv2d93QSmzm8Q/dzkAF727QuaUmfdGaEtvVK09EQ5J6WHK2yfO7AJrVF0YkAl6KusYZOKe0aJ5s3+8BWBorstPWMevzk8UjF6sHMXgIbeyyBohpefqizPGMyVNFZwjfz0LTXrkcZPr35mNXuxnePAlVq8nvU+VctTvPhUrlxDipufKzR8BPV4xagchGSnwyM9wD5cVFaDZW5rCd7+fuTnxi3hee3xZTYBu31M4HhmoRDX3UtMmCYTFxLTcH9a2SICgZGJcGZOU1OjJng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ0PR11MB5037.namprd11.prod.outlook.com (2603:10b6:a03:2ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Thu, 18 May
 2023 13:27:15 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590%2]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 13:27:15 +0000
Message-ID: <313c4834-bcee-1182-7094-4feef800c312@intel.com>
Date: Thu, 18 May 2023 15:26:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next 06/11] net: page_pool: avoid calling no-op
 externals when possible
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
CC: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>, Michal Kubiak
	<michal.kubiak@intel.com>, Larysa Zaremba <larysa.zaremba@intel.com>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, <netdev@vger.kernel.org>,
	<intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>
References: <20230516161841.37138-1-aleksander.lobakin@intel.com>
 <20230516161841.37138-7-aleksander.lobakin@intel.com>
 <20230517081458.GA32192@lst.de>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230517081458.GA32192@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0045.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::16) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ0PR11MB5037:EE_
X-MS-Office365-Filtering-Correlation-Id: 4151938b-3a70-4a08-d225-08db57a397e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9yKft80fP7VDA/1Pu0Wq908A0QctyHxbr1CYcIRt4clPfeLjEE7vezBfmvLoovrIubFUOxIQfmUQ0ZTPmFoZgxQ3iybTGU6N0OC7py6ec1nlRAVyYDFCAUb+wK51H3gS2UG6WYRiuvYpvfbmUZhCPVGT8lJHFvJsjn7IyO5AaUd0UMa6gtqlkmUApMlGJwPuXFiVQnGFY+v65OkrScLiEJ9S8y42WKKJF0AFr+Ojivrdj+9/jHd12nFKI9k7q3UBcQ+2GEcjIsBU3nOULq4IOfp+MI6+6dBTbmk7bkF/MnUUsP2/ayztEJOpSMZ0TxnawqD2YzjCgrShGXY5ce36rITKBi/neNt9EZ6vi1EpAauZXJSohSAMdj05nz9HjZ3KUjubHgTGWJckjCk1qmdNhRf/D2V6MLvF+AuoVVB85/1+fnAaQsAmuYpQ3ZcM2t5iZ/LPYYam3gwZlZFspzzEhHmSxaYqSveZyfAfuhEXIwfBsYB9b8jqLWg5ec8bSTPfOOIJJvC9N66lLVP1jPCNLQLupRJHZTaq9r7icL2z72QBX0uSqzo8dZ1UCnIYHoPjR2EmS3qtvEeWwvTSIMvM2zkwnZyatbZbrkr2Mu9z2AsG4U1BJaT3JSKPHU3DohP3D6DK/lKCP4kOAgL/QA4cwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199021)(38100700002)(186003)(2616005)(54906003)(478600001)(6486002)(6512007)(6506007)(26005)(2906002)(8676002)(36756003)(5660300002)(4744005)(6916009)(8936002)(82960400001)(7416002)(41300700001)(66556008)(66476007)(66946007)(31696002)(86362001)(4326008)(316002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q1FLYU1RZzltdnNTbDhFcmFNdVJpb0t4QTIzcjNXaXV2MlhmTlFFRGVJTWQ1?=
 =?utf-8?B?aFA4ZWZVUXBDUTBaMmJnOUc1SWtZM0szY0FhbDUrQmlCckp3YnQrejc2Ky85?=
 =?utf-8?B?QnQ3MUh3RVRIN2dIaG90RW55OWR3d2NxcDRmRzlCVkVscEpGT00vd2RONVA0?=
 =?utf-8?B?STl5bXUySnQwL0xxV01MYytFOHdLSUZPQkpRTVhERG9xRUJVUldzUzlWZjF2?=
 =?utf-8?B?S0VRUnk5RHVUdkJITENOUFBFNDJmbHFITmQrekwvSDJUWVh1UnV4N1A0d1Bw?=
 =?utf-8?B?TlhmblZSUXd2QmlRS2FQaG1ZN2JCTld1VmVYN04yVkxUQlNzOXQ0VTdHdVFx?=
 =?utf-8?B?T1Q1Lzl0R2QxMVJkZjJPRmo4WGRtSEpsSzI5N2dGYUI3d3lRVk13UW5ycGl1?=
 =?utf-8?B?eUFFRXNqb0V0eExLclgwUVRWWE1hMWtOTHRBb0N4T3VydC8wTDgvRXJkenA4?=
 =?utf-8?B?RXl5TTliVlJnR2p4RWZMRUdhbG4wQkN6ZEQyWk9WdENmZmVMY0NEN29Nc2RB?=
 =?utf-8?B?WFFzdUZqdmpqYU56cEZJdi9kT2ZrRXowWFQxYWxXUC9aMXMxTGdhc3pTaHdi?=
 =?utf-8?B?RFc2cERYQzFCSFJIU3M3TWhhMDlpdzJZcElvQytWV1d1bmtndGg0YzE2ZTN2?=
 =?utf-8?B?aVhGcktPeXA3dW9HVWViTjI4UVpmRXBCRzA0UDBLWG1aUDlHMmszaTVsSEF3?=
 =?utf-8?B?amF3YTNzeVROVjl0M2Rla2p1WGZDTTRXUGJ2d1pycGVtTnJjMkdFSFdYNXZB?=
 =?utf-8?B?QXJQK1FGU2ZadXNHMS9aZld3ZCtXVXFCV2ZuUTlXQUwwUkpIWk80YTloMlpL?=
 =?utf-8?B?aTd1TVREclYyZWdaQjQvRnhLSy9mTUFVOWFrbGFoekRzYVQ1ZnRTcVFkV2xj?=
 =?utf-8?B?RXI4Uk9MUVRjdkFNWDFzc2FOS1Q1cnlQYU10VmxNWlNqdS94dERqMDNDTlZQ?=
 =?utf-8?B?U1Bxa24za3BNNWlCdW9mQ09QaUdiSUdHQ3I3UUE4MVZadmgyMjJ2WWtiOXVC?=
 =?utf-8?B?K21lTFZTM0p4VkhTNXBLVjNrVndDU1I2cXJqNysyVW1EM1h4ZTJLaFNPZzBG?=
 =?utf-8?B?ODcwbmJVeFJxSGVhZUw1TkNwMmM3ZTNEVU02YUNSSkdiWlR2aGNlZ2FzTkY3?=
 =?utf-8?B?VWlnaU9FNGVXZG1VeHVoT0daa3V0NW91d05ZME0yZTdMb3FSU2lBUGZoZHpW?=
 =?utf-8?B?bFBCR3M0OCsxckVBbktqYTZjUnNVMjdhc2JhaG1xR3lyb0h4aUxTbEVpblZa?=
 =?utf-8?B?UWp0WEFkcGhzWXlSOTVaMms4cHgvQU9IdUtxa0hCSW5QWGF2ajdCTHBKMWNQ?=
 =?utf-8?B?MU56WFVFMHp4YUVqN3JuRm43aTBmZnVNcjZTR0pqUkNWaFZRclZHWFI1WWxm?=
 =?utf-8?B?N05HaU40YW5kK25IK2tKM1BTemhmaEYwaklvdGNRYWJQZ3FYL1NNYVU5NmJP?=
 =?utf-8?B?bkV0UVpwYWVrZU1vdG5vQ2NGVkExU1M1eFg1dUdGcHhWWXl2aDhXQ0huTnNo?=
 =?utf-8?B?SlJLS1E5SExkN3RFMUxjdkdmQ0c4QkdaQVRycEg3Yno5RHYzVGJZQU41OTFq?=
 =?utf-8?B?S1RURWZIUy95MXhZbnJoWUNkc1FFekRxZW9ERkMvOTJqUis0ZXNFaTd1SXR2?=
 =?utf-8?B?TnIvUU43RDVxd0lTYWl3SWdTTzE1N0MxbVZaTzRaSUQ5M1B4bUpIMGdwb1V1?=
 =?utf-8?B?Ri9zVGltUnhYTEkya1JpMlpJTmRNcnMxVTl3eFJ5S3JUYXovckc5NGxTeVY2?=
 =?utf-8?B?dzM3VWQ5bnA2Q2NDNmpDUDFOSTUyKzNhV1p5UmhSUU1abFJ5TGNYTldHSDYw?=
 =?utf-8?B?czVuaFRvY1c4TjFmN0VabHNWa3c4OE0rOU9SZTJ0b1hyTEpKRkwrVzBoUlJH?=
 =?utf-8?B?SzJlWWdIeHJzQmtrb1Z2VHFJVHppR0IyQTVvRjN6M09hbFZwcVRHMXBEYWI5?=
 =?utf-8?B?Zld1UGZxL0tETURUQVhiUUZPSHhLQUtJck43bWU4dGRqRmNwWWMySVFZTjF3?=
 =?utf-8?B?VjJWeHpyQzYyd2hnRWlHUVZVL1RxWVpUVFJteUVZZjNtUWdjOFJFQmRVTWJs?=
 =?utf-8?B?QjU3RzVMN1cyU2ZnN0dUZVVIQkVGYUR0bk5FbkgvWStsR09IVkdpUHY0VkJM?=
 =?utf-8?B?REVRUUU5VmYvbUozWlh5S1FlUHdUOGpSV2pmVXBKeXZuS3pDU3ZZOTNYZ1NQ?=
 =?utf-8?B?eHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4151938b-3a70-4a08-d225-08db57a397e8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 13:27:14.8324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WP+OcRxDwuZSlFmtdzoozS3Lp5Dc56uXKuLxH9aKsxWzIBmTDT/3aiENJ8r3ODg+2ryiHQtNnXaOoa5KMrH6Ryk3aIj3XNjgkz+JO+ahv3g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5037
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Christoph Hellwig <hch@lst.de>
Date: Wed, 17 May 2023 10:14:58 +0200

> So while this looks ok, Eric Dumazet had looked into some optimization
> for this touching the core code, and promised me to come up with an
> even better version a while ago.  Eric, what's the state of your
> optimizations for no-op DMA syncs?
> 

Hmm, his last proposals were for avoiding indirect calls when IOMMU is
on, but in fact we don't need to synchronize stuff -- DMA IOMMU on
x86_64 also usually doesn't synchronize anything, but you don't know
that prior to doing an indirect call and dma_need_sync() won't help.
I was thinking of adding .dma_need_sync() callback to DMA ops, which
could also be called once only on page allocation, like in this patch.

Also want to hear how it goes for Eric :)

Thanks,
Olek

