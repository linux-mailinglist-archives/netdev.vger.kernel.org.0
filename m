Return-Path: <netdev+bounces-10384-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 626ED72E3C0
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:08:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89F4C1C20C6D
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 13:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3931D1D2C0;
	Tue, 13 Jun 2023 13:08:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20665522B
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 13:08:52 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45FE127;
	Tue, 13 Jun 2023 06:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686661731; x=1718197731;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bJ6tlP4k6eR5mpUS5qgOVIQ3zChNbM9G/oxzpPg4E5c=;
  b=HY2qwnDITe5vTYsqLr0zbaMmJX4E3hb9jLID9I/pADzvOc49eEL5gKl4
   MzJVP1zp++JDMGlxfStCOyyBFWJkcuWOz0nzKPgl+sbznWgBKu4GCSo7n
   MjS7KW0AgHPhtPxDOXwXntOHal/AurMaJPlzjB1csK0tdn/un+7Hr87A2
   CJ8hAfndbAV7NtCM6rOF8q6PU2Mv8BUcc0Smc9X3w6wG6iYqO0UBRIG0Z
   UOb3xTh4mQqV4TY4j2sObyrIlLRe5u0JKwAH0B5yLYj6Bq3XPnvFqm8ff
   UPyEbAbYQ8JtasuYh0HLpXga9/g8AQBzCVKQfB0tokDsXrqL4oAbTGy+W
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="343011639"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="343011639"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 06:08:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="714791848"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="714791848"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jun 2023 06:08:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 06:08:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 06:08:49 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 06:08:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OiqqbUOXi09C3MVhgVYGwtCuNE7u7Rzu7pZ3/bmSGBfzzASVLYfg52iQ+hLonSGKDz6oNJoZrzK3Mu/yjljeEcUvwWrYq8Gowkr/oO7KIebPym5Dj9sCI93wkgrs2XvhSftgChZeViRZchcS/AtjUcwqZiEDRgYRf42ndeSwDhL92ktCeHUdUTAXGROUKSADM/GJ9RXQoDKjvnVHBjurXUq66/ZO1NuSCYmaxnt70SLY85maqyx7rTX8pPADMYusz6Lc8zBdgGJ79pYv5biRF+gj3stox03WR6yky4eSA/oHBCPlz9OQGvMYc6oG3cyWCMmNWcgQj01aNJG4BMQWyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CV6KZBEWjqzqY9Kl/MjvS6/N8tTHhBWIRGkqhfCLyi4=;
 b=NfzrgI5NWkPBHHToQXWc1OtjkTIYerP7m2ylpXP6ZtFXjcz/nTBaxJKvIVA5DzPJD+QG2k2vQjJrlEald7w6Ja9EJljPUdMu1wz1xagTgqTIHaBo2zTahYIPsH/fpbUBXSMwagd+OD8u39HHJbVROP1yqf7/Y41qYNFPUr/TfMblj83dulIn5Hj1N92YgyntLuYGG9H0JrQ2SSFVMwkiLopXAgmi3w8CBmCOvn2Hajm6Cv5WvDTt4pvaQYRSAAIRfdLoMET8ZPoabC9h+Gx8im06wtHMpJXPyWC7M4sURZ2gxmeKpvjQdu8nnSnWzW+4MGKYepBk6G4Q4ykcU1GqyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BN9PR11MB5515.namprd11.prod.outlook.com (2603:10b6:408:104::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 13:08:47 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 13:08:47 +0000
Message-ID: <d4424b60-9a9c-a741-86e3-e712960cdf44@intel.com>
Date: Tue, 13 Jun 2023 15:08:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.1
Subject: Re: [PATCH net-next v4 3/5] page_pool: introduce page_pool_alloc()
 API
Content-Language: en-US
To: Yunsheng Lin <linyunsheng@huawei.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Lorenzo Bianconi
	<lorenzo@kernel.org>, Alexander Duyck <alexander.duyck@gmail.com>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, Eric Dumazet <edumazet@google.com>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
 <20230612130256.4572-4-linyunsheng@huawei.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230612130256.4572-4-linyunsheng@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0268.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b5::12) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BN9PR11MB5515:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c565d08-7340-4861-cea1-08db6c0f52c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HCzSHAlTpA7FmZgRgB4aeS9Ay80RCAExi7qHihHxxc3GUXkk15HYsIm8JSrZQwySU0QPe9Bj0AV7Jrf6trhltPNYawwlYP2Xj859ahCorZ5LPKe54zT5ew9oZUqI1tA6rPDto9PHDGW0IlLjXahb1RqkBcXESg2L6J7D5bpBw2ZXpJ0uTpht1d3grFg4RSBj8NsTc64c9x/Ipbcl+nNoq1ZKf4Feg/stVfCBZJigZZsNdub1evHHNzcgp7Mlipc3N5DF1ZA75xu6BS3w/eckUARPlVK7mYL+EMEiacsukYZqKTrxaPpRuqIqc3uO3fWKquEdzkg6ipP3NOl90PdfENzUAMHrw6aO6MNSgAM6OnZFf3T1W/DIQvqb3di5IaHaXNl41xNSAehofSj7PYexOeAKlsU4YLJtdEqjorn12u+tJls4wek4qMQcw0QqE4LaZp4baEW36hhlZySbUaMBw4btkMxoUzZ70sGe7B91jKjwYBqTLMcQlXeWr3IgxPTe4SgBC4xqv+1N5aXF0VY7KBuV0zXBI/XlcpjuleM2SQhcfVCo+zK2mWWOH2OmVu02sRg88wYcLYPcPd6QEaU3lwDbIGpti8yn4QcSc4dDP5vuu5rFGjr3viyeSELwKJF1g9nPhCJqL8byY6daDtK0TZzPrSv6SY4M5KHd+fhV8jISxplKIjAT005RfTkmvKRj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(136003)(376002)(396003)(451199021)(66946007)(66476007)(66556008)(478600001)(54906003)(5660300002)(8676002)(8936002)(36756003)(6916009)(6666004)(31686004)(4326008)(316002)(41300700001)(966005)(6486002)(38100700002)(82960400001)(83380400001)(186003)(6506007)(7416002)(86362001)(2906002)(26005)(2616005)(31696002)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGowQng3bzhkTEthMnRiZnFlcEJBZnlrTmZyLzNKanVRNmVSZzcwZXF3VkNu?=
 =?utf-8?B?aGRFMUx4TjBFNFE2S293Y1k4aExXemMyWjRHcEVsS1VsanU2dEJQV2ZXS21a?=
 =?utf-8?B?dTg3anVXWWc3TFlCa2FEenI5MEFYdUx4ekh5a1VIZ0Z1a09xQ0FNbjZIbG10?=
 =?utf-8?B?QnBmNk1lZ2Zuc2NPbEk3K2c3dFU2c2RXa0VBeHFUOG9jZzRTRGJDeGwrSTBH?=
 =?utf-8?B?elpVWVYxajJnNkpzcVBVQnpsMW5LZ3hoUmdCVlB4T210ald3WUhBeU5iME5s?=
 =?utf-8?B?Z21WeVdZZFM2dzBsOXNZR2dGWUN0cEFtY0tBUGw1SDR2czJCU1hMOWlyc241?=
 =?utf-8?B?QWtzbXlFdGo5U0dCcTBZbzdMdURzaThPczU0OGlNbDZYak45Sk11bDlIV2dW?=
 =?utf-8?B?N2w2MTYycGhVNnJxQnVOZm5nWDVsVTNoMmZGNTRMM0swSWozYVNPc3ltSEdQ?=
 =?utf-8?B?TDFiaFY5MEtGU1h5UUxJYjRPOFlJbHlPVHdRQWw4ZThLdmkyU3ZUTVRYV0R5?=
 =?utf-8?B?NEVIanNqUE8yOEJrRmZpRVlyQURkOG5mVkhkVkxzVVlXYzhRVUo2cytqbWhV?=
 =?utf-8?B?QUJIVzlBZkduVnBMbU4rSFlTbFU3YmRlZXBKWXFXQm9Wd3owZ3ZSUWkyWEk1?=
 =?utf-8?B?dHYzejc5VTlieW9Vejg3WWJ4OUVqQmRheE5hRmZDSkx3QXZxaEhsV0xQNUpI?=
 =?utf-8?B?dzNGenpLb0JiOHpDT1pnczBkRCtMbGRQUzBSeGRuNkI3bStzaDNaVDJZeGJ6?=
 =?utf-8?B?OStac2N5RGJTUG80Yk4zcDBRWTNmbXA5dzdtZlZYbnFKSVlZZStjTXNZYng4?=
 =?utf-8?B?RW8zam9PMC9WYk5UZVFqdlhxeWt2Y0lqSll3MEovZURqLzd1bnFuUXJCZmlT?=
 =?utf-8?B?V0xleWFMZUtrQUxHbGpMakF0NkxPOUhXUXpCdWs5LzE2U1QwSGd5NHZJYWtN?=
 =?utf-8?B?ZURHbTRhYXpkd0RTMThkcFdDRmYrTHJNeHRvRUJ1TkZrOWtsZDlVaXY5MjJw?=
 =?utf-8?B?S0NnL3F1RDE1eUNLMW94TGtGeDdVK25PNDEvQUhRN0lKNEZITjhpRlFKcXRZ?=
 =?utf-8?B?S1ZycGQ1MmlBNWdDeTFzaENVTjZUeG04Y2pRcTJNWjg3cUhUemdHV29EdDhi?=
 =?utf-8?B?aVBqeVNmNXRrWi9KNVZZdE9WcTF3UDExT2llYUhONVV1VGw2RERNamJXWWVr?=
 =?utf-8?B?emg1QlFrYWtqMlVLajhKK1JhQThWYmI3U2tHa0UzbkVhb1VBQ01ScU5ZdnJq?=
 =?utf-8?B?SDZJd3ZZT1F3cUZzWktNcGQzc0tFWFhDZnlONkppT2QzTENOL1VWMWhPZitU?=
 =?utf-8?B?SU5VNlBsS0JTUGhOc0dkK2ZWOXUwOEZMTkZrMHczMjR0bStaMjNvUUlzTmkz?=
 =?utf-8?B?d0tzcWVwdGJ2R0RFN1REWm82bkdNNEMzUzd1YnEzTEdCa3lSUUNYZDlocEdY?=
 =?utf-8?B?a2h0MXFwb1V3OXBqY0huY2pZREx5Mmd1c1VLdEtGV05mdkFZUi9OVTJ4cXRo?=
 =?utf-8?B?Z0l6NmNOaXpjSks5K3BoanVxMzYrV2NaQnRLNForL1BiM3hIZ3hTUlZxelRE?=
 =?utf-8?B?V2hSZXJLNnhTbzhyMjVwcWV3azhhV3MzRFlwazNoaVl4YlM3dzN0SWllakd0?=
 =?utf-8?B?a09DU0ZsSktNMG1GTjVhS1VJVHZEV2IyRUJHUzdPelZQTkZnTkpmc0lXNjJN?=
 =?utf-8?B?TExndXdablFmNzk3a21idnlaY3RrTExhdHNObVRaL2pxNGVlV0QyR0lIVWF6?=
 =?utf-8?B?OFZ3NmpIa2QzYnNTZk1rOW9EdVcvVkdiOXY0WTlpTWdYb0k4MitvQi95MkJC?=
 =?utf-8?B?SWQwV2xvSTBKcFlVbUwxOTFlaFlBLzA3ZHNkZDh0aVpRSE53dmJyeFN5OXRZ?=
 =?utf-8?B?V3ZLQnB2dDhMZXhRMzNHWTg2TmNpRHhhb3R4OG5KVUNyakNYc3FTakI3RXNp?=
 =?utf-8?B?dndXcGk4VjBIa3NOdGZHeDR2d2dKSnpTT0xzV0VPRy9vZy9NRW1SNUN4dGJS?=
 =?utf-8?B?b1RvcEZwelg3MHNZTXQ1T2JtNzFWb3dmN3czQlJvWXZhWmtGNUwrTk1HQ1Ry?=
 =?utf-8?B?UEJ6dU5FQkU5QWN5UGNvaml1bEhiai9oais3bnhZTHRvT0J6SmZBd0thbXNV?=
 =?utf-8?B?TG5NTitMQnV5VnBMNVljeC9hdkdGdE94MHJrZ0duOUliZ2h3YU1rVlRjaWw0?=
 =?utf-8?B?MEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c565d08-7340-4861-cea1-08db6c0f52c8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 13:08:47.4546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B1AwyzPxEkvOYgdqRQ18XhH1y0Mr8sZFbIEJNHLRkWmEaJmrtMQP1fVadb5muupjJTfeT4Q+/aD91cWn+ZQK/1yEwn3kX23f0x2uzlsoqc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5515
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Yunsheng Lin <linyunsheng@huawei.com>
Date: Mon, 12 Jun 2023 21:02:54 +0800

> Currently page pool supports the below use cases:
> use case 1: allocate page without page splitting using
>             page_pool_alloc_pages() API if the driver knows
>             that the memory it need is always bigger than
>             half of the page allocated from page pool.
> use case 2: allocate page frag with page splitting using
>             page_pool_alloc_frag() API if the driver knows
>             that the memory it need is always smaller than
>             or equal to the half of the page allocated from
>             page pool.
> 
> There is emerging use case [1] & [2] that is a mix of the
> above two case: the driver doesn't know the size of memory it
> need beforehand, so the driver may use something like below to
> allocate memory with least memory utilization and performance
> penalty:
> 
> if (size << 1 > max_size)
> 	page = page_pool_alloc_pages();
> else
> 	page = page_pool_alloc_frag();
> 
> To avoid the driver doing something like above, add the
> page_pool_alloc() API to support the above use case, and update
> the true size of memory that is acctually allocated by updating
> '*size' back to the driver in order to avoid the truesize
> underestimate problem.
> 
> 1. https://lore.kernel.org/all/d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org/
> 2. https://lore.kernel.org/all/20230526054621.18371-3-liangchen.linux@gmail.com/
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> CC: Lorenzo Bianconi <lorenzo@kernel.org>
> CC: Alexander Duyck <alexander.duyck@gmail.com>
> ---
>  include/net/page_pool.h | 43 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 0b8cd2acc1d7..c135cd157cea 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -260,6 +260,49 @@ static inline struct page *page_pool_dev_alloc_frag(struct page_pool *pool,
>  	return page_pool_alloc_frag(pool, offset, size, gfp);
>  }
>  
> +static inline struct page *page_pool_alloc(struct page_pool *pool,
> +					   unsigned int *offset,
> +					   unsigned int *size, gfp_t gfp)

Oh, really nice. Wouldn't you mind if I base my series on top of this? :)

Also, with %PAGE_SIZE of 32k+ and default MTU, there is truesize
underestimation. I haven't looked at the latest conversations as I had a
small vacation, sowwy :s What's the current opinion on this?

[...]

Thanks,
Olek

