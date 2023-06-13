Return-Path: <netdev+bounces-10386-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0739772E3CC
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:11:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B911E281092
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 13:11:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17E1128C06;
	Tue, 13 Jun 2023 13:11:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0990E522B
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 13:11:36 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A501AA;
	Tue, 13 Jun 2023 06:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686661895; x=1718197895;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OhWGaOwEK3EKrBBQn/uHRL2CZm6PeHPDS9a98qpvCbg=;
  b=LvBT+NOLDpJ+NIgWMVLlZTfraNAKg4PXFsIbhEf3nCMpx0J43m+X6U9R
   4pMcYaa+g0l80WAXxecm5P8sx3IAWvITDJDAzuhfNLM4/TXe5Pjd3gIxw
   aWNZAb5hrKNtIwkkT3hbswAZENKSXVtXJ9VabWJ/ExDxwKPY/bw14azLO
   m3atssBMYSy/wM+XG9qAaif3kvAZddTIQH3Kj/wDCqtu628dsPl2D20c/
   snQxMXMADt86WVWwI1VfqupLMCiDEColNQDW0pwfS5y/2mRk3kONBkn9h
   9LcXDpLRQem3KgV8FQKctxoJsn8RcyoJCyP8zF0owubbJ3uRDjwEm9QrD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="347978003"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="347978003"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 06:11:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="801476567"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="801476567"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jun 2023 06:11:34 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 06:11:33 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 06:11:33 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 06:11:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsCHyHfjJAptNMyR2gmklSCmQugZFLKUWoGVAU7LLkKrV9sXlmnTcW9wgFPr8vHLe1d7GgbPEv9do/sHM2eLM69jQoOejIvs/p0HB4FBQGxQFETrvfddRH9rFPx8efGaSAeDpAKtz9HSue1Y1UdZynSerHB+wy5zmO1Vfqj7PxGsxD4yBPkwodXOF4he/98Rg15xqfiS1Q6mhR+umF33/lvUf1FvTSBBPY8RSyT6GGU3jxhEW20SNOiF/hcCS9OSnbX42+1aVQQyktnm+TH7jgUjm5Lc+Yzb96l82XA8iQesHUwBA04xjPiA64N5qqBkSJ8tvHAzZGcViaJt8meVWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qsVXsPK5Ljfef47EhaYtAC/rDgcvfRAwMuuBZ6NWRsw=;
 b=EhBe2y6826p8DWX61dQXAcmeha+jeXnA/8/lEYtpgbRfcF0Iz65bdTEUKtEzq3hhkg0M+8kwZiFvP6Fkn3puynwsh4LtInj9mnkFEGI25V7zXQpdSkfa+QAEF89U9vE0PHpZSFdy8awtr4DvHc+VJ/EwwYxvdRI44p268YejMGmgYWrEnoB9tDefSGEoiSnE4Gd5l/xCEXg/um4zqHFEN23o0ZMaHJ494OrlH8yRFi8pyyAkZVEY+O8EXzffosnLYhCU86g+NycUSULPRJywn7Kj1J6j7Aff2CV137bRZbR1R/YiG7jj/+bHh/5TNBD9yz0/eGtpxj9iTAlpfPx9xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BN9PR11MB5515.namprd11.prod.outlook.com (2603:10b6:408:104::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 13:11:22 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 13:11:22 +0000
Message-ID: <9f861b07-78e4-c18c-d1a5-d61f3cf42e3f@intel.com>
Date: Tue, 13 Jun 2023 15:11:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.1
Subject: Re: [PATCH net-next v4 3/5] page_pool: introduce page_pool_alloc()
 API
Content-Language: en-US
From: Alexander Lobakin <aleksander.lobakin@intel.com>
To: Yunsheng Lin <linyunsheng@huawei.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Lorenzo Bianconi
	<lorenzo@kernel.org>, Alexander Duyck <alexander.duyck@gmail.com>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, Eric Dumazet <edumazet@google.com>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
 <20230612130256.4572-4-linyunsheng@huawei.com>
 <d4424b60-9a9c-a741-86e3-e712960cdf44@intel.com>
In-Reply-To: <d4424b60-9a9c-a741-86e3-e712960cdf44@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0053.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::6) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BN9PR11MB5515:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bf69dc7-3bf3-41ff-324e-08db6c0faf0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o72SYFQMwdAEsNDC9vaDlQik47y6BtzA0xv3OwoTSy9OU2SE9je7d0QVG1KwW8ESc4m5am6Srfo+4VmboPC2z+cbjgJyS1VsvEyLgBQAnn1Zi2KNEJYJLYk46dyHRB8uubpGIr7OmYJO1+LuBuO173liEsg2ksAdMfTmoDfBXsqtUeT3fgr3+QIzuQhQHtd9B2srzCQYnNystU29eSd0rPmzOlc7MGqVujFZ/lvkFjGlYJ3DbWsypBIYCA1QlNDdeb//dihJHM1NVsO4ePwDRnYaReVLeaqYl81BO8Zqb9lXUBjAjNkzr+kx/FWUns9FgQR74djCfKpZK7UGuDDa635Q/pB8jXJbt6MtrhpS1byXwrk5DRZgcXt9paoy7nZqnGyEqWgiPbp9YkToZF+4dUiVe/+/l1SXMIfkxpi+7b7XVVGGjFSQHuxW++t+1ev46j7psOg1RmvibEF1i2r/4NmxmTnOtRIkFfhrafZ/oTgWrABf8ExJ27tPS9/O4w5dZ2RT18VV0vRSt0IMhfxA/DnHrNIbaRWdbww8wUuzRXJWA/TFpS909kV7x2XMudCPvtvqmkz0lUsvUUPe32vMg19S0wP+WHZSLTiYPKynkro95qkGnmjicU4l7Nd93nEEKqObNNAnZDQVsXXK7qRB1F36JFUSwPpUtCZHqY9mZrWbyP/OoHndYb9UwRzrCtZu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(136003)(376002)(396003)(451199021)(66946007)(66476007)(66556008)(478600001)(54906003)(5660300002)(8676002)(8936002)(36756003)(6916009)(6666004)(31686004)(4326008)(316002)(41300700001)(966005)(6486002)(38100700002)(82960400001)(83380400001)(186003)(6506007)(7416002)(86362001)(2906002)(26005)(2616005)(31696002)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VjV3a09MRFIzVmJ1NmdCeTUwM2ZUWC81bkFWdi90QzN0Z2prQWxsR1lrSXE0?=
 =?utf-8?B?NGRaQVNQaG93Njlma3NmSnM3bmpjS3g2djJBSnlRd1BvQzJxVE8xaEQ2OEti?=
 =?utf-8?B?K0duK05FdzFMWXh1RGdmMW9Qb3pmZWUvZWx2UzhnalNsRlJOdWR5TklqZUFF?=
 =?utf-8?B?TWhBbSt0bklLaVYrbDcrcUd2YVVqcjRaamc5MTRXaDF3cThQSGh6bDBERTRW?=
 =?utf-8?B?bGxDcEg1SVZGZG9ReWprR09kMmZqbkluK0VuQVhaZEsrZ2luNVNLc0dXblZh?=
 =?utf-8?B?bDB2bENuWFBkMFJqR2dtTlBHSFphcERnZzFLeFZZRVVvcGdCNnFkb0xSakJt?=
 =?utf-8?B?MlZCaGVZdnJuY0hWRFNnYUxwWDA4ZTJXSDYxcUhjRWY3RUdQMDBRMFp3RjE2?=
 =?utf-8?B?V2YxZmtWcmxjZzM3dGZkTkxCUUxYU1duUWUxdzRNYmVJTjZmVDVSTE03MjhV?=
 =?utf-8?B?YVZJUGpobEhDeWVyc1liY1Z2WU9tcHFjR0hkMWhZd2QrVGF4QjlXaW8xTTVL?=
 =?utf-8?B?YlNFb0pBYmZDVE83SUZRb0Z0c2dXMDIwNjBzQ2FGTy8zM3lSTW5aVmZBYnFF?=
 =?utf-8?B?dG9US2Z2VjhHZ3VzM3FLQmFMOXVSTzhoUVljR29tNURSc3FlbHBPVENrMnpY?=
 =?utf-8?B?MngyWG13SEZvQU1ZaTVWQUFjQzg4dDNyYldKWkdHNExjOFVHNTNadDZOZ1l4?=
 =?utf-8?B?UitMMUtOTTFhS1oxNnZkbXFKQStUcnozWU1nRUNCVElHT3Y2dkxMdjZoQk04?=
 =?utf-8?B?eC9tSUpMK28waSs2ODdqRUgwK0VoUnAzazdaOG45YlM3cHpjMk1UTGZXZk1X?=
 =?utf-8?B?K0JHQWNKYkpFQnMrYkRoRS9DNCt1bHFpdDRSU05PbDFnL0xkRE9DSmZmVHhi?=
 =?utf-8?B?Vis2UHZjajRvR0ZiZ1VadjQrTUE5ZVFwcWQxekV6Z05YSng0VUxXZXVpNlQ3?=
 =?utf-8?B?dWR4UlFSdDM1M2Z2WGgvT2ttOTUycURXcGFoMjlNcHYrbWVBNFpJOUVBQXBH?=
 =?utf-8?B?KzZ4aEsxUWNMR2UzSW9LaUorRlk3TnBPbDRqclZFaEJOT1V4UnZoTTJuNmd6?=
 =?utf-8?B?ekVQQkdQNVB3UEtPYitmS2owWmNrZzV1ZEZzZFJhSjdJZm0rVk1SMmZXQ0gz?=
 =?utf-8?B?dUdxN25MZm9WVHdpa3hmVStjeUhyeUNzQ2lxbEdvWnFzeWs4WkxGOGJVM2Fj?=
 =?utf-8?B?ZmpRRFZCVFB0NzhZd2ZIUzZpa2lRZi9aNDc4QkZtR3hoT216YUIrMU1WbnFv?=
 =?utf-8?B?enAvSUJnTFZzaXVBRFRVeVdmcS9aT3J2MFF6TVdLMms4THB1RksycGdJWFA4?=
 =?utf-8?B?NENiM1U2aHpna2ZVV0thYXlCWWJBZUdsS1BOaXBlczdGNC95dnY3MnQ5WnNr?=
 =?utf-8?B?WVByL01laXZOZzBhQWZLWlNweTdyRVJsdVIzVHE1ME5McU1lWVhsUk55OTlV?=
 =?utf-8?B?bERaTUUzenBvRXJ5dW1UVU1uMmxLZVJmS0lDUEpwZ013UmhGaGJkUUY0aFlL?=
 =?utf-8?B?eldoRXJxVnZ1ZEVVN3M4SzNUeDcwZ1N1emNIS3d6eGxLQ1huWEZLZDRrMGp4?=
 =?utf-8?B?TW5NeHpSWWUvQkI5LzRFeE9TaUZiMU1reUxsSmNBWmVyc0hCbFBzTlEyeXJy?=
 =?utf-8?B?bjk5ZXgvNzkwd2JXTGNwL2plZDhpWTF4OXJqV05vcXdzTkdCZi9RL29xbXF5?=
 =?utf-8?B?TmtuQlRBK3J1ckh5UG1OaWd6d0srMm9tNTF6Zk1XNDBkaGxCWUtxS2tYZGpN?=
 =?utf-8?B?bjNvQjhqbGJ2ME1zRzVoTm15Y0lqZnZhbzZBV2tQWElNTnlzbkZiN0dUaEtR?=
 =?utf-8?B?NVMvOWJJUkxXWGlTN3FlSXhPRU5xbURIWmFMNzN6Q3FReXVyMG9mTWNUTmRv?=
 =?utf-8?B?SmtuazE4aHlENjRYcm13ckdWdlc2ckZIMVlFZTdaNktxVStKVnh0RWprTlVq?=
 =?utf-8?B?Vk9XWVRKQW5ETjNBa1ZTeHpxTEtOVlBCS2JtaFNJenptMWpTUWxaY25BMk8r?=
 =?utf-8?B?S2xvcU9zclNITlo0V3ZTeWNmWVhIQ0N4Y1J1MXZVeGt2czRST2Fyek9NVmZj?=
 =?utf-8?B?b0xDd2VKVFVJcThiOUNYUnVFbjk0VS9Bck5rZDlmTGplVDN2NTI5ZmpZVENR?=
 =?utf-8?B?dnh4N1RkTmEvalRzQU1XUFA3MVhzUjZxTWEwNU40Y3JpanVleTFrZVpHUkxV?=
 =?utf-8?B?MlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bf69dc7-3bf3-41ff-324e-08db6c0faf0b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 13:11:22.2286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uq6sgLGuDVgtYfC7HZhfAra/Iwyk30LlAj0gnaOZunbqqAHcqZsaY+aSqBquXyXesI3WmwLWvdfdmg2fJi9D3g4qjDsYyzt6/9YQAjkJ6vA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5515
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexander Lobakin <aleksander.lobakin@intel.com>
Date: Tue, 13 Jun 2023 15:08:41 +0200

> From: Yunsheng Lin <linyunsheng@huawei.com>
> Date: Mon, 12 Jun 2023 21:02:54 +0800
> 
>> Currently page pool supports the below use cases:
>> use case 1: allocate page without page splitting using
>>             page_pool_alloc_pages() API if the driver knows
>>             that the memory it need is always bigger than
>>             half of the page allocated from page pool.
>> use case 2: allocate page frag with page splitting using
>>             page_pool_alloc_frag() API if the driver knows
>>             that the memory it need is always smaller than
>>             or equal to the half of the page allocated from
>>             page pool.
>>
>> There is emerging use case [1] & [2] that is a mix of the
>> above two case: the driver doesn't know the size of memory it
>> need beforehand, so the driver may use something like below to
>> allocate memory with least memory utilization and performance
>> penalty:
>>
>> if (size << 1 > max_size)
>> 	page = page_pool_alloc_pages();
>> else
>> 	page = page_pool_alloc_frag();
>>
>> To avoid the driver doing something like above, add the
>> page_pool_alloc() API to support the above use case, and update
>> the true size of memory that is acctually allocated by updating
>> '*size' back to the driver in order to avoid the truesize
>> underestimate problem.
>>
>> 1. https://lore.kernel.org/all/d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org/
>> 2. https://lore.kernel.org/all/20230526054621.18371-3-liangchen.linux@gmail.com/
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> CC: Lorenzo Bianconi <lorenzo@kernel.org>
>> CC: Alexander Duyck <alexander.duyck@gmail.com>
>> ---
>>  include/net/page_pool.h | 43 +++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 43 insertions(+)
>>
>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>> index 0b8cd2acc1d7..c135cd157cea 100644
>> --- a/include/net/page_pool.h
>> +++ b/include/net/page_pool.h
>> @@ -260,6 +260,49 @@ static inline struct page *page_pool_dev_alloc_frag(struct page_pool *pool,
>>  	return page_pool_alloc_frag(pool, offset, size, gfp);
>>  }
>>  
>> +static inline struct page *page_pool_alloc(struct page_pool *pool,
>> +					   unsigned int *offset,
>> +					   unsigned int *size, gfp_t gfp)
> 
> Oh, really nice. Wouldn't you mind if I base my series on top of this? :)
> 
> Also, with %PAGE_SIZE of 32k+ and default MTU, there is truesize
> underestimation. I haven't looked at the latest conversations as I had a
> small vacation, sowwy :s What's the current opinion on this?

Please ignore this, seems like I didn't manage to read 2 lines below,
you explicitly mention in the comment that you already handle this >_<

Thanks,
Olek

