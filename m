Return-Path: <netdev+bounces-3920-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAA547098D4
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:57:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B319E1C212A3
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD47DDDD;
	Fri, 19 May 2023 13:57:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7197DDB1
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:57:56 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE5210B;
	Fri, 19 May 2023 06:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684504673; x=1716040673;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mD0LhS2fOSt40w3QGOH6dxC6JqL7JnDPne4XwE4ll0Q=;
  b=DtPGRgERBCjZ6fc7mX57gzEKZ6/IA0w1ObFL3s+ayjGP6wNIlUFhkic6
   ZAPmVCiKLXyVhgagcJl6Z8L4D2+F8OWzwvvxKq4cVo7UEzijKGidDp3hi
   oZ7aNJWumDa5kxkJgvDYkN0TLMT/KJt5Dg0av0eWgnCZJ0rDQxcY9qIgd
   lDT/sdl2FjgfSoGwHB145nnzxRJ/OX5G3V64N3Tu1yaJCGQe96VmsK5KV
   88MChVtuQaeVoMMX5t8cGNHeaE6SdIl8QDyYr6Pe81UaWE/NVmID3tqbG
   3UdnEmIGUxFCfkjSi1coxTbQyRA3r0tKUDweYzJYQCdOgK0dBuEkgPf6X
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="349890679"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="349890679"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 06:57:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="792378882"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="792378882"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 19 May 2023 06:57:53 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 19 May 2023 06:57:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 19 May 2023 06:57:52 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 19 May 2023 06:57:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMzVBOi0bHrpQTj1v2jFoGFDQbisviV2zNnZJMV6ipjFzBN6oCEg8L08U3CIYgo2w94rvenSaCI4pMwJBY3ILWE7K7Z0P/JxrMexqF1F9puBwHqOMaMJgfCSYGzlSfE7le0AF/Jtb3DnzJAkajGJCmNbNoMMx6/h7bbKVNpwhLbZQ2ft1os2pyURG9cX8lj4UWN+gTGsQhQ7GuCRZT9fyB7YpDe982YLzNSbE3+GMCuHqbHlfeEmk8KXdYtdIMMN7ybmtp+R+tFYrUYD+yk8WzzlKZaK0Tbrc/uhK0tV9+Zsb+UFmtwgDnVOiah1F1+iha90QDpgxC+F+18LBSDCvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4McygUFteGV1sjPpVSp07IJiVApjQy58jIvxxc0M2bI=;
 b=FhlbXHHe4Pes5O+cPTSgXakH8y6AjwC0cQQObEHm8F1L71XWVi65Gnjt8/OrGBpyOkei1nmIxNSofSGDdkqLIclanhgEvmR9KRpqM9AOFBiBZa2QT+Y2MmKD/Ds1ObBDWx/ejJJKQ/z0kXvw0BFtg2Gw9DsGDWPEtXg3z5qhZffbDUvHKteKzU38Dkn/eOqMQ+nFup8PByLQfmlLeyX8b7fAtIui8qbJfHhTGoRhkDCFtc7VANAChexMWQqpxJ4rphYDdjhI/J1ZU3QAE9kfWGUZKB+edSnNMo+CXKMytpe09uIt6/beKpOpZVmOiI9Xcy+EwBaSXmWoNhQBrf/HOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CO1PR11MB5041.namprd11.prod.outlook.com (2603:10b6:303:90::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 13:57:50 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590%2]) with mapi id 15.20.6411.019; Fri, 19 May 2023
 13:57:49 +0000
Message-ID: <77d929b2-c124-d3db-1cd9-8301d1d269d3@intel.com>
Date: Fri, 19 May 2023 15:56:40 +0200
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
 <0dfa36f1-a847-739e-4557-fc43e2e8c6a7@intel.com>
 <20230518133627.72747418@kernel.org>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230518133627.72747418@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0126.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::20) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CO1PR11MB5041:EE_
X-MS-Office365-Filtering-Correlation-Id: ca6a3db3-b143-42cd-31c5-08db58710826
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9fw71560US43hI8/5mEOYyZ5DFM3AJAJX8ATjCDRokEP+1gGM44k9DfTDEftcyR5w1uRYzI7bdjBfdhbIxXtRJY/vd7YIWkRtQMYa3NqVawyYbnvrHv0VDAQECBPQiRqY5U1rnjJghJIw2F/aZcfu0vOu2VBlg2gv0lH7gZEyycCNqJKX6Z6OGsT+NFaDybWIsBobUMoJQpe/jeCvaOyE1hMuvzhv9R0J8BYkrRP4hMx5WweEziaeHk7Hc0GlXUvlwJtcgMTE8dnDy1Ev6KZiDFD96ey8wQVj+HlEkE456vhIw4kE0XuZmtH1L9JBsujBenjqkDNsPA4jNls+23MbNBhhhLGz3c3uEsvqKIMlUqSxD84HtDCOJCjGocLN0HYc4y6m6q4Nz1SoMZSAPLzcXoKjI+HBXNdJszlqvZY5VBsPR/ydpzr+n5H9eeZ6np2tBd/t/n6bO+h7sIMv+zfCJjVMyClnMKR9swtkP8eLkn+Iw9AtF7U0/sRYjPAjvr9VHG0ttNP372HPQy/isjg2not1Owrft8iLNsxygibFfop0Nn3/se0l7B9UbkTfmne6TORIEwO3JdIG/sosmuRe6StG44QjMZKxedwUR2aLOrsEQP039t/37hbi64Glf6F2FucOvAacRr3HTeH4+0g4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(136003)(396003)(366004)(346002)(451199021)(31686004)(6916009)(66556008)(66946007)(66476007)(478600001)(4326008)(54906003)(316002)(86362001)(31696002)(36756003)(107886003)(26005)(2616005)(6506007)(186003)(5660300002)(8936002)(6512007)(7416002)(8676002)(2906002)(6666004)(6486002)(38100700002)(41300700001)(82960400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVpmdkFic0xyOXMzMUZxYVM1YVpNdmI1eENGTHE4WkgzZnhJaVdpRGxRQ0My?=
 =?utf-8?B?bEIyeHo5dkRWbE84ZmJVcmxwVHI4bkpWUklNMjRoMFI2M1J6OHltRzBVUThN?=
 =?utf-8?B?TUpDaVJ2dHlva3pQWU5iZjl2QmZmQ3oyY25WaHJOMDBlTU5UTTlGM2ViamE2?=
 =?utf-8?B?dE9QVGlpTVRyL3QwZWlBMmUyaDdOWk85QUtYdkhEV09NdlVVTHA5ZTV1Zngr?=
 =?utf-8?B?anBCNjY1WWN1dk5KdHRKZTg5ZWtsdU5kR05lSCtUNjVFaXAxZmFPQUtZS3o2?=
 =?utf-8?B?OHdyb1hVcm1RU05BaSs0Z1pDa2dXVVF4UzRZNnp2RWhhYmpCbmxpUEo1SmxD?=
 =?utf-8?B?NjhvWFJsbUQ2TW5tbFVQMFN6NDYrUG0ydGtpeFlYNit2UHhwSzdWeEJJMnAz?=
 =?utf-8?B?bEhFOTRRT3FueXdEZDQ2WGpvZTArNk1ucWs2N2FUUnJhNDZNRHZDOUwrU0p6?=
 =?utf-8?B?WG5TbEVEYzg2WGlHYkpRdS8yU21kb3k0ZkE2djlMeXhqbEZZRjZqWUFLSEF2?=
 =?utf-8?B?cGlEdFBnTTcrYlh6c1h5RTcwbm9NSGE4dS9yK2hkaENrQ3FsZVQwMXcvUUdp?=
 =?utf-8?B?ZC91NTRZeFJVZVhTRUEvcFNiRzdmMFJnRWNaUVhFUTQ4eVRSNTBoeXlpZUtR?=
 =?utf-8?B?bXBabHdGVlIzQnc5M1Qwb0lBWFAyREZMdWJTOTZyY0JLWHdhSUxnUmRaNElV?=
 =?utf-8?B?cmkzQk9DQ3Vrb2pWaWJpQjBidVJhbkZKZzlHTC9PRlVMSVdPTWN2WjdBU01t?=
 =?utf-8?B?Q1EraloraWI3QlJmWlJVSS9EbGVPTlNJMFdFMzdnRjk4a2ZRQ2Z5RktmZ0Nq?=
 =?utf-8?B?di95VlAwQ2hjZURTZ2crcyszbHJ1TUpscUdydU9Xa1YrR1p3Uk40TVV1QjhB?=
 =?utf-8?B?ZkdYQ0tWK0l0aFNKTkhlbzJ0NmZQMlhHQnJpWWljazFxd1lBOTRuNk5hZnhQ?=
 =?utf-8?B?bDU0eXZ0ZWJVWHVRcVJlN0orby9OSnh5R3B1NnhGek03cVhMTlZyNTYrR2I3?=
 =?utf-8?B?UDFuNjRjQjdoU3UwR3JpWno3aURSSjhjVXlheTJDZHNVQlowNGZWNnd1QU1H?=
 =?utf-8?B?SkFqSzd0cEJuTGdsNjNpamxhWjA0WVcyZFFJTzZXNHNsZ1Y0bVhmRXpZVTV5?=
 =?utf-8?B?MXhkTHZlS1F1YXZJajc2OVZIaGRTdnU0RUQwOVpIT2V1NE4xVTdGUWNKaEtL?=
 =?utf-8?B?b2tsbWhOWGVTejZkdVNtdXk2eGY2QVVaMWx1WkVIYlR5aDlZOEVRcHBab081?=
 =?utf-8?B?QnltZ2NVSnJ6SERPM25JOWRvUWlEK1lWdldGYmFCWXlyOEVienQ0YjR3bk95?=
 =?utf-8?B?MG5GOThXMm1ScVZqYSt4VFhBNTlnQU9iR0ZBbjNjcEhJYWNTRjMyMXBWRit1?=
 =?utf-8?B?YXI1Z0hhbms2R3lOV25BeG1zb25KNHE4SzlZblUrTkNRQnFKS2tEM2RadVV3?=
 =?utf-8?B?REs4K3dFN0lNMVV1RmNJTkJDRXg4TzBMTVptd0ZIN0d0aitRdWhMYVhCRVRG?=
 =?utf-8?B?Zk9DMHhuZGhXSElhTXRvL3J2UEJ4OU5RVW1yVUVadVFvejFSTkNDQ09JZ09Z?=
 =?utf-8?B?UGdYd2dVL0RxUXp0WVU4VEJhYit1cEk3czlMUi9sLy8wMUk5TXBHU2FzeC9X?=
 =?utf-8?B?TUc3bFN1Z2FCeDBRMDdvQ0labzQ3U2pHVnZObmgzVytCTm5nVFBHanlFb0ow?=
 =?utf-8?B?c0hmQU8ya3M1TGVvYllEZWJLK0RST1JQaWc1T3NGRzM4cDRZWHFIRU4rell1?=
 =?utf-8?B?UXI5QkU3RHZXM2ZHMTU5SHl0cktpVG9vcXVXUjJBanRNeS83UGdFYnI3MXV1?=
 =?utf-8?B?cGRzWVlTbzdyTE9uODVyRGJ3U2VJUEplcW5ORjVMbHY5V3ZBdnQxUHlUSnh4?=
 =?utf-8?B?alFoUzAvZ0N5bFE0Wi9ncUdOVmlZQkRnWGpGS1JLQjVoY2gwRW51ME52R1Jv?=
 =?utf-8?B?L2hjZTJudlYxallha2dHc2h1NTJHS1VxV0wzSzdMdkNvM3RZR29wUXNMTXVq?=
 =?utf-8?B?WWd3RE1LaTNjaTlldWlqUjRRWUlWSlB5SENDUXF2UUx0RjZGRVk4UGNYdDVy?=
 =?utf-8?B?L0NtWm9TVDl0UCtrblovdHAxc2RKYi9COVpDMDQ0OHJVb3EyNk5qcjRRSFdx?=
 =?utf-8?B?ZFZ0K2RqY2Y3S09JcG1pL3E1M2QvMnJQKzVsWjJlbXNtL2F5S2c0LzJJYlRJ?=
 =?utf-8?B?UlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca6a3db3-b143-42cd-31c5-08db58710826
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 13:57:49.8326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pFL8i3C1K3fLVACuvCfvc9PCE3OOlt2XMzzRPbs8pbqqNhJy6DZikyTB9Q/9D9yVStwxFy/+/v/4QCz1pqWQyO7v9vnGlpfb7S5/pmAU8rs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5041
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jakub Kicinski <kuba@kernel.org>
Date: Thu, 18 May 2023 13:36:27 -0700

> On Thu, 18 May 2023 17:41:52 +0200 Alexander Lobakin wrote:
>>> Or maybe we can do both? I think that separating types, defines and
>>> simple wrappers from helpers should be considered good code hygiene.  
>>
>> I'll definitely take a look, I also like the idea of minimalistic and
>> lightweight headers.
>> page_pool.h and page_pool_drv.h? :D
> 
> What I've been doing lately is split like this:
> 
> include/net/something.h           (simply includes all other headers)
> include/net/something/types.h     (structs, defines, enums)
> include/net/something/functions.h (inlines and function declarations)
> 
> If that's reasonable -- we should put the helpers under
> 
> include/net/page_pool/functions.h ?

Hmm, all files that need something from page_pool.h usually need both
types and functions. Not sure we'll benefit anything here. OTOH leaving
those sync-for-cpu inlines alone allows to avoid including dma-mapping.h
and currently only IAVF needs them. So my idea is:

- you need smth from PP, but not sync-for-cpu -- more lightweight
  page_pool.h is for you;
- you need sync-for-cpu (or maybe something else with heavy deps in the
  future) -- just include page_pool_drv.h.

I tried moving something else, but couldn't find anything that would
give any win. <linux/mm.h> and <linux/ptr_ring.h> are needed to define
`struct page_pool`, i.e. even being structured like in your example they
would've gone into pp/types.h =\
`struct ptr_ring` itself doesn't require any MM-related definitions, so
would we split it into ptr_ring/{types,functions}.h, we could probably
avoid a couple includes :D

Thanks,
Olek

