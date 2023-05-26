Return-Path: <netdev+bounces-5684-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D68007126F8
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:53:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EC421C210B2
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:53:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E376118AE0;
	Fri, 26 May 2023 12:53:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0053101E8
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 12:53:24 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7155114;
	Fri, 26 May 2023 05:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685105603; x=1716641603;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LqzVE0lU/1GvWumVv/gU63LLKqWsOobFk8T/wLOvU50=;
  b=X+JuRVUsaPUVwdnye4CoygqaNjycBZDluA4rAxOybatdodCfR+icBsZF
   1BWH4LmPRCBYTux4FhzThF8gxYMFLSCGm044NmSN1hdV0r8cg0yriPm2c
   +DG+g89IH8WD9U8IRGRYRt47j+9uvwx0XRivOiwF5p971AvVoq9gq7mW/
   hQgoQy9H1YkL+ApXzAi5SffkHkDNIWncPMhDkD2VCnqoVIJJoYrSrwVY7
   zZXCbYNsNq4e3HIxvtu9vWmKEuw/dvmtO8jadrkN94cj9ZtIWxz09COui
   gJuE7v5I/kwnYw2vbX7jL0godP4E3WoloGJl6OsLldbwzBletOIP5dfdx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10722"; a="343688114"
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="343688114"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 05:53:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10722"; a="817524995"
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="817524995"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 26 May 2023 05:53:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 26 May 2023 05:53:21 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 26 May 2023 05:53:21 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 26 May 2023 05:53:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lKaWKBsQnlH/02RB8LslvDWI6wXKYfz+YY7vMXRgfYrSjas71+lHWVlCvfSGDTZy49nwckkoHG2YLRbsJUdbX8aVbs0unXq3yzKnpsuzigf5tepXztd/6tIuVaXjeQ4tZz7pkugsZ6V4pWkoexDLqdyGT0DWTZeais078jDXBHiqrfBw8J1mGKFiA7IU05d3St5meix1a1pSoLc+4FWU0N6m7vv9iVEHrk4INY/EuhHh7ZT970LkV5Ga1pRc/XTpMij0kDq+CxWY5EYwx/ODIgT6thHvLrQj3Fz4rjlqfsRrfYa1KyXyYFn7CtAOvZjJdExPvq8OGHk8km9MtyH3Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dpcDlnrcAKXSewE0GqxLqGkr6DC2cbevyGlF95XPUQA=;
 b=g6p1SktZKNT4/9E0e+bTp5ptNff7ytILnY7K229wCP1k1q5VOBFpScctrsvfxRIXjET5+dmxUH4ITzcb7aHyvgjkvtmyErbLwD+SOr1R0bRQisjBPfleNdxUENjmM/D7i5ejHOoSesc2QodF5cPk2Mprj6ZfRgEyF/FyhcDbVWZV9WDZP2DMeYceiiTnzhIU88Gd/D81yT/kz/OqLx7UG8z1xE9tAEy1gUUJ66G1Z1UY1kovtl+zbYmVW0dfHvpRwXiQ6dMIV3hWK2Wi1+gQN2N5rHItSbpctww6ajOJvnQhOV7qOcebV0hP/j2UPFhu4SFNdKw1uLsJdb1IF8Oe2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA0PR11MB4527.namprd11.prod.outlook.com (2603:10b6:806:72::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.19; Fri, 26 May
 2023 12:53:19 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590%2]) with mapi id 15.20.6433.016; Fri, 26 May 2023
 12:53:19 +0000
Message-ID: <88c4f8c4-085c-1934-536b-0fc8a38205c7@intel.com>
Date: Fri, 26 May 2023 14:52:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v2 05/12] iavf: always use a full order-0 page
Content-Language: en-US
To: David Laight <David.Laight@ACULAB.COM>
CC: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>, Michal Kubiak
	<michal.kubiak@intel.com>, Larysa Zaremba <larysa.zaremba@intel.com>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, Christoph Hellwig <hch@lst.de>, Paul Menzel
	<pmenzel@molgen.mpg.de>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230525125746.553874-1-aleksander.lobakin@intel.com>
 <20230525125746.553874-6-aleksander.lobakin@intel.com>
 <9acb1863f53542b6bd247ad641b8c0fa@AcuMS.aculab.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <9acb1863f53542b6bd247ad641b8c0fa@AcuMS.aculab.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0014.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::24) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA0PR11MB4527:EE_
X-MS-Office365-Filtering-Correlation-Id: 755b1578-a7b0-4858-79d3-08db5de82db7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lTOSvu5BwXHhZLBsyjyeGiYplqZ4FAzhb+KJSsS12Cibyj0pUQCNgbu+7ulXMOA0r13O0o52tj53dK2kjV1EY77kLvboCFhkvyuiq/to/STEzW3mAUO8COBFt6snq6Pm0yilz48hmj5YZo+6RwZZ7cP/526rLKo+3VfushwC7v3mBfyyUHOGSP64q62zxFycr8LaLMhLMZGgsnOVaCtN2ZQnFm7hIadq9prBcQOOj60MBNkqGPwlSOD3faeP5gBkejNZ/rKyO43p0P0HUhxPJk/dw9QVWyJws8UW4Hoh/UQqPShC/w59yWKPAUr+sVylhLqW/c0xmCWRyP+39iHxgW3+7ePphL3dIYofk5mUtTkx1wLzOtCwLO6pZEP5GtnQlDI6whuPHi4nT1908wfOb3Gs1au0Dmn/ANeSFTQfsx54UxLFEOWohHfbGCbGj0vb5ipJoLF7C9xXFsQjdfZqdJoBFwJOZg20PYsHZ0PctfM5PTxxRGDOXOYiYa7bcBu2foUd7cB47MGTVmUqDl3l8CXM7jhoKK+O/A9BU0wLoeQEJnv5463scU4wP9LfbOJ+DGy0tboIdLympkp0fJYEJEa5sac3WOx9QN6XmUwUQMxU9shW7ZKXeZsvEaGaVZCdfK4wgtrYFbKIckQP1jOqwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(39860400002)(366004)(396003)(451199021)(41300700001)(6666004)(38100700002)(316002)(6486002)(8936002)(8676002)(86362001)(186003)(2616005)(31696002)(2906002)(7416002)(5660300002)(83380400001)(36756003)(6512007)(6506007)(26005)(478600001)(66556008)(66476007)(66946007)(31686004)(54906003)(82960400001)(6916009)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekIwL2E2clJoclR4dklWWU1KNitkcXpMWHArSm1FREcvbVlSNjIxUU1sYSt0?=
 =?utf-8?B?SFdLd2dlYkNOR2FEVVBBQzd1M04wVDNIUUljN1R6WEhLWGJISnBpQno1NlRq?=
 =?utf-8?B?Z3luaEVBbjRkQ0J5YlRLU2YyZ2xkSXJpSkJvNm1wSEw3KzB5MUFtdGg5Z3Fm?=
 =?utf-8?B?UUlGSXcxOWNaSjRuVmkrSnJ0YURHbnVPNXhxSXBSaE5seWU2Ynlhait4TUxs?=
 =?utf-8?B?ZEZWTFNIZStVZ2M4OTZ4ckp2V1B1UTJ0Z0ZvS2lTSFZDVzJISjBJVlFNT08x?=
 =?utf-8?B?V3lBNEpSZittd2ZBb1phZ29INE1SNnNCQmxQTWpZNmtnWS9ocXFkem1DdmFy?=
 =?utf-8?B?d1FqZkV1U3Ayandtd0tXa3dNU2NEVWE0WDVXY3NOZVhCZ3ExZTU4TllGRm4v?=
 =?utf-8?B?dlczNHFNdjlLRDhkeXVYUWlESXl5M0M2MDFsU1J4VWNTQnFubE50TnRrejBw?=
 =?utf-8?B?blkyUUNqU3F4cVNTSm03a3NXTHVEUlNTWVcwUEFzWmdoQUVXUmpsdUwxdkZ1?=
 =?utf-8?B?b1FwM1pGempjSjFVdGo0R3VSMldpMDFKTE85MC8vd0lKdDAzaVAvMmtDRXVr?=
 =?utf-8?B?aFI1UVJZeFZIa0FXelRSSDlWUUw3b2xaeVN1cEVzbld1dWFlSWVGZXkxWVpU?=
 =?utf-8?B?bDYramJodlBYTnAxTTFiYjhwUmtiVExkZHJTTEx4cWc5US94aSs0SWZiQXl1?=
 =?utf-8?B?NUNSanhScUo0TGlzQWFpU0J6VE84M3Z4SldNRldqVS91Q3BRdlFSVGRCQUNG?=
 =?utf-8?B?Rkd6c0xHT0NjU0Vablc4bzZaN2ZqV0E5a3JFcG9aMy8vZGVKVDZESTU5MkpR?=
 =?utf-8?B?dlVjZ0twVzg0QldBNGM2aHMzNmg0bUdDOXdSbkpYWmtlaGI1ZFc5TVlKKzlr?=
 =?utf-8?B?Q1dpNDRiaUo0M3VOcWNmZTAyZzhzalpZcUpOeWpGSUpreE56UTIrVFUrSzdj?=
 =?utf-8?B?MUNxMDR0SmpZcEZmRmNYZDc4NXhaNmJjQlF5Y0Z3cDNYYnVXVXYzM0hLTlNj?=
 =?utf-8?B?OE5PTCtSeW5lWDZzOVpMTEtRTnRkM2tkazMvdTZrUEpQQ214ekh3eUVjNC9O?=
 =?utf-8?B?V1U2Z2szejA5YjhKUUwxRUllTHZ3NFJDbmNvcWsvN29WUXd0V1huampHNlFJ?=
 =?utf-8?B?aHA5aEdNRnp6STVDT2wzeUx2a2hlazdyY1B2Z0p3ZDRKUVMzcFZZWTM3U01Y?=
 =?utf-8?B?cG9NUS9TM0l5UzVWRWZKZjhXbVM0V2xzdGYzWFp3ZXprc3dPeTl2bG13Zk5l?=
 =?utf-8?B?RFBhbEd2dmJ1dkozRmZQTlJOdXE2UmhNUXkwSFdMOG94UjU1Q0pkaE81eFRE?=
 =?utf-8?B?YlVjRWtBRWgyRDFHUkJteDczUytIL2VzODZSYjFjNllmbktpL3ZseTY0WWZM?=
 =?utf-8?B?cE9zemc5a2xVaEpaUzdHSEdtZnRzUzRrai81YUxJWXpOUGEraFVNYk81eFBk?=
 =?utf-8?B?ekdpRkhyc3FnZXdEcnRvM0VId2pyNmpYaHUwYWh2alZRVExTVkFma1pCT0Nk?=
 =?utf-8?B?N0FSK3l2d09nVFBFR3JpSnYwNzE3Sm9maDh4OXIzMExtTnJjZ0VGVGpicDFP?=
 =?utf-8?B?RzFGMWVnNG9nRU9kc3VkUG80NHNZeGZnNWtjK2pWM2M4N1NaYXNlYUY3aktN?=
 =?utf-8?B?L3IzWFlqaEZvbnFqb3VJT3hFcldhSjJGVzFFWDZla2Q3NjRVRDdDWWs2S0pz?=
 =?utf-8?B?aDZ5dFdaWE5YK0ROeTIyQTZGUWNuTGhjenhWYXF2NWMxTUdVV2hERWJZdGU0?=
 =?utf-8?B?eURZOGdET3lCd3NSTkZMS0dOcG1oc1hlcURhd0pHWTZTY0d6RnMycXF6ZVBK?=
 =?utf-8?B?bnhDdGcxb2ErYXZFb1d0REt3aFhVR0JkQ1VESWxFRjZ4WktobFpNd0hvZkUy?=
 =?utf-8?B?Ulo5MWlvN2NCZmlHME5xWldBbUYzUUpDZERUV0hpclVVMEorSzg1Nno3S2pq?=
 =?utf-8?B?bk9RWE5LU1gwNEd1VEZ6RHlHYXVvTThJelVIYlZsTmhteUdlc1o3VUZDTUIv?=
 =?utf-8?B?a01mdjFKV1l1NnBvZWM1SFoyUDhzYkgvSE1TcVN0cm45VVNya29GaVJuRXVE?=
 =?utf-8?B?RXBzODlsQmZBMFV6dnFtQ0xiRW1GQWU1S3VuSHlFS0dZUm02VnpDQWVxWjBs?=
 =?utf-8?B?elZXVjBuREVyMUlRaU9XUzM5a2dKMkVMdm5NUW5rSTU3YzdhMjV5VVlFend5?=
 =?utf-8?B?SGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 755b1578-a7b0-4858-79d3-08db5de82db7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 12:53:18.7964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zTBma61u47m3f/zz65URxvhVNlsSeRbvUZ3p+J80Jo9fL+S4VKD/mnmFd9iFAWwcJblUgqHd62pKLePhvXJIQiB9yxZGgvd0SuwQy3c5ODo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4527
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 26 May 2023 08:57:31 +0000

> From: Alexander Lobakin
>> Sent: 25 May 2023 13:58

[...]

>> 4096 page
>> 64 head, 320 tail
>> 3712 HW buffer size
>> 3686 max MTU w/o frags
> 
> I'd have thought it was important to pack multiple buffers for
> MTU 1500 into a single page.
> 512 bytes split between head and tail room really ought to
> be enough for most cases.
> 
> Is much tailroom ever used for received packets?

You don't have any tailroom at all when you split 4k page into two
halves on x86_64. From those 512 bytes, 320+ are used for
skb_shared_info. And then you're left with 192 bytes or even less (with
increased MAX_SKB_FRAGS, which becomes a new trend thanks to Eric and
Big TCP). XDP requires 256 bytes of headroom -- and you already don't
have them even with the default number of frags.

> It is used to append data to packets being sent - but that isn't
> really relevant here.
> 
> While the unused memory is moderate for 4k pages, it is horrid
> for anything with large pages - think 64k and above.

But hey, there's always unused space and it's arbitrary whether to treat
it "horrid". For example, imagine a machine mostly handling 64-byte
traffic. From that point of view, even splitting pages into 2 halves
still is "horrid" -- 2048 bytes of truesize only to receive 64 bytes :>

> IIRC large pages are common on big PPC and maybe some arm cpus.

Even in that case, the percentage of 4k-page machines running those NICs
are much higher than > 4k. I thought we usually optimize things for the
most common usecases. Adding a couple hundred lines, branches on
hotpaths, limitations etc. only to serve a particular architecture... Dunno.
I have 16k pages on my private development machines and I have no issues
with using 1 page per frame in their NIC drivers :s

> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

Thanks,
Olek

