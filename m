Return-Path: <netdev+bounces-11135-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D986731AA9
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:59:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54CA628172C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1952168DE;
	Thu, 15 Jun 2023 13:59:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E635168C6
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 13:59:56 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB642D59;
	Thu, 15 Jun 2023 06:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686837595; x=1718373595;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WAturMWj/JV4WTKfVibx5E668Eo8V2ENKnzfH1IhlBM=;
  b=N3iXQELzfwG/RfFecrRgE97oKu1XWltnrBCr+yW7WyjuLD8YcWFSp0f6
   +taRfvENPQGnIUuxz8AJa05ZD9lizb64e1zKydswcqEVyWLDzAb/ePYtj
   eVX6rz/74XopChl7b1KRn5oripvOAnYknqeAEK1kaGGuLszPaHmbjDhXj
   KS7uqM7/B8kejWl23G88eY0RXXUcX0tCUA0IbnPBrF26y3VKxaPSELP8V
   NkmncGvoezjKZiw1AphPElqrtI9Tex1L1kjuSCtuIfyONag/OI4h42Bjp
   yrfQYYOlq2MhYpdG4numuO91Kr0oJaZOeAVuuLtSQEyXGBJ2puoHCYunJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="338544797"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="338544797"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 06:59:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="742236863"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="742236863"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 15 Jun 2023 06:59:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 06:59:53 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 06:59:53 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 06:59:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWEBDNT5q41SzVu83CRP5lqdKWPoQG4bdWOUqlIk/VBcYzbcAjiGYjAmvi8BIzznTn++0AhtYMs8sShUOmDb9dHEmllaZyadFvlkF3gERo73oxLcLfwgr+t4Gr08Jj8OtFRy3Hp7aKewZHdv0CpKIqS6YHFqlcQnrvKT+Rl41DfyFa7yE7jn4ED/sNWWF/9oftoF9SZXc5RalF6kAjkGZUIQfn0A5huTMdRjvexdCTeg/43NDnpM+o4aFK5e4Sl5rRmSJRpUj0eSxwRzMgiVaoP0D4BgVLTwhGDYfJ5Qsxw01O0AlN4hIrGdjqDBIO/5HGV9NA6Nl2f16+Pi2ZOgzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+K2B5Hf0vub4O/YP2IsN9/yGj+0YYrSXxua9dvtjb7I=;
 b=DjXGUZyoCtTLLuLTe4pw0J8yzG2pAsvD7+w/H6liJaLYVz4VIos5oL8JEeFnDYnju7elbXx0jn8k9MRzpv8c5NWKwfI2DonpVnWR4jAuccoT6Bu9P1gHJQUhBosqxo8pMeFeBcAEGpWkI+Q2/u7EKiMjSMPXw1YCqXg4gjYvkP/fAZCHgmEsUaT/l55x69aW+v0vtdz9Mw+rE+wh6DDymkfNinhRtKTXs82XMyo9n04lsdD7xcDnpxvLDl7zDU0kpWcDFykcV/lngmT279CQqHklW4oSOVrZwxZ8pbg9SoZpM1C0WlLbjdexV4NVot5Tg0zqeqiFAEt5073Tl/bRBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MN6PR11MB8172.namprd11.prod.outlook.com (2603:10b6:208:478::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.42; Thu, 15 Jun
 2023 13:59:49 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Thu, 15 Jun 2023
 13:59:49 +0000
Message-ID: <b7253d36-26cc-e5a3-e34a-d28d6fd8fde0@intel.com>
Date: Thu, 15 Jun 2023 15:59:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.1
Subject: Re: [PATCH net-next v4 4/5] page_pool: remove PP_FLAG_PAGE_FRAG flag
To: Jakub Kicinski <kuba@kernel.org>, Yunsheng Lin <linyunsheng@huawei.com>
CC: <davem@davemloft.net>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Alexander Duyck <alexander.duyck@gmail.com>, Yisen Zhuang
	<yisen.zhuang@huawei.com>, Salil Mehta <salil.mehta@huawei.com>, Eric Dumazet
	<edumazet@google.com>, Sunil Goutham <sgoutham@marvell.com>, Geetha sowjanya
	<gakula@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>, hariprasad
	<hkelam@marvell.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, Felix Fietkau <nbd@nbd.name>, Ryder Lee
	<ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean Wang
	<sean.wang@mediatek.com>, Kalle Valo <kvalo@kernel.org>, Matthias Brugger
	<matthias.bgg@gmail.com>, David Christensen <drc@linux.vnet.ibm.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, <linux-rdma@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
 <20230612130256.4572-5-linyunsheng@huawei.com>
 <20230614101954.30112d6e@kernel.org>
Content-Language: en-US
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230614101954.30112d6e@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0076.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::18) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MN6PR11MB8172:EE_
X-MS-Office365-Filtering-Correlation-Id: 2427c4bd-1ead-4a08-a366-08db6da8c8bb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: emRHLxOdarMHYQyD9p6pHDpyZJNHFLX9FaQ2SSvlj5xhpOkxOQafMxR/DaWmRfETTJkMH0SwSoQDj189vbukjpTcySwFyAj5aDvO9+GzS+3zNU9o9IfoCOMGAsVdVs+9vuBRZc7fhNkUkvvo66AInxujvU3XM87pm3KZkvCNIFZwjlEjB8y1U8dQ2aRlgwPKE2VB9eLktSdHGmvBzB7igiC1oyS4CSB7pw5831NGGznApoc+MEskODIE0qznjtoaH2FbRNZmG9yQC1FS+OFMpYWSUGdiNBov0icUs8su7U2Yeels5I/Sj9ByyMrdHS03hJjhn2g1PM3GDQ/Y3KuXqNrMlmTN7CVj5XjTQwvRGAUOmdpiaPL2LGfbFKkZ0CifxaZ0SmxclISbVwC/c4BtVke8yEXmYMIBZN6XHuN6EktZhDb5Ei99hb+50AdVpMD4Cc+X1gHFnlhquKeyqOrwwHN9nVb7vjJFn5o/JgFRidh3K6+TxUc4nLCjfiJetq5/GLlLumKUqgn9N6F60x6IydLLbg9E/ItS5k5aliT58hTVD3h2WOwJMT9DUREiUCPZQWaGqbBF9DecaZyq4Vjp9DY48Hq2NRP1iw2z7sOOs3PABLtPok7g428oo1Oc4LXBr9/s2Zu49NUlVpExNyYUTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(82960400001)(2616005)(83380400001)(38100700002)(31696002)(86362001)(36756003)(478600001)(110136005)(54906003)(4326008)(6486002)(6666004)(8936002)(8676002)(2906002)(7416002)(5660300002)(66556008)(66476007)(7406005)(66946007)(31686004)(41300700001)(186003)(316002)(6512007)(6506007)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZG1EaEJ5Y1RQMHdWc0gvd3Jua2tXQWhLcFN4QUd5RkpaKzhaL0M1bGZweXFI?=
 =?utf-8?B?OXpTT09kSUFHWmdlZ0Z3N1l4c2tXL0o3dnRzVmk3K3o5bDIzaG45c2hpakRR?=
 =?utf-8?B?ejB0OWJvZUdRVElFQVJReTE5NmNmUjlaQksvQTJFVm1qZ3FURXRZZUlobHRs?=
 =?utf-8?B?R205QXFaVFNOeHRRYzFwVlR0Zmo4MERGT3Z4SHoyM0RmeUZTTGN0ZDh3Nmxl?=
 =?utf-8?B?bFFOY0VPL25sSUhVcTcrUkY1L2xKTlFHV0NGMzR2TEZmSTAva2puK0pKODU4?=
 =?utf-8?B?VWUxb3lZbGNmb3NXMkpDbzB2LzFxckpCdUg4WTRURzdEN3I0SFdwbUVNT016?=
 =?utf-8?B?WXRNVFNnaHhzb3lnYnozV0xkcU1VV3F2ZlA1TDZiTTRCcXNwUlREVjU4enZl?=
 =?utf-8?B?aDhTUlp4enZrQUpvMEZjYVlheUVOTkFSZWtOcnJLeWJnTmE4UU1BT1FJVGFl?=
 =?utf-8?B?NjF3TWM4NVFISHVheFFnM1lZQ2grNHdqRWRXQXdSUlZlaUpkZVFzejJFZWZT?=
 =?utf-8?B?NVN6RGk0OEpRUWZMenIwRktrSS9OMXJjdG5wL01Jb3ZEaUttOXBGN2FPL2FT?=
 =?utf-8?B?S1pqeG4vREIvd2t0NHI2ZEJnZ3dXak5PeGhkNHR4cnhrV1dlZVZJUDU4Y0ZN?=
 =?utf-8?B?VGkzSEFBQXc0SFk2Ym5wV3oraEhPbnk0SjZ0WHlHTnVkWVZFWXJhYjNzRUh4?=
 =?utf-8?B?aXZuWjBwMjdHbE1pQllSYWJvd3RIWmV1TjgraDhuT0ZuQTFHNzJ4UnY3Wms5?=
 =?utf-8?B?SVY5anF2dUloK2MxTS9CRUowY1d4WUlYemF5ZnlibmhYUXc5UXErNlNMNWQ4?=
 =?utf-8?B?b2kzSWFNV2VUd3pRMThENEhSU1MvRGVIZjhoT2xtWEoySCttR0RPUmYrTC91?=
 =?utf-8?B?SFlkN2M3UXV2NmF3MXhjU3p1NGkxN2wxT0Y1Q1VuOHhDNi9VMHh5TEhCTVk0?=
 =?utf-8?B?L2RwR2J6SlhzTlBqdzFHb1JzTzZUTzhMczFNb2JhZTBxcmdjZ05iV1U4NlFW?=
 =?utf-8?B?RUV0Zk5taGpNUncxNml0RUNCUnhtblNFbTJHZ2pvV2dkYlZpSnVSUzBvRFJG?=
 =?utf-8?B?cVRlSHRPWEVOU09XZFFPQ2RzMjdobHI2VnI4SlNNNUxtWk9jK0VJT25hcVZC?=
 =?utf-8?B?azZUaSsvWUZxeDdTWUdDSWNVK1N5WW9mNnU3VHpxQlFLKzIrY2s0ZllVQXY1?=
 =?utf-8?B?TlU5eFd0a1YyamRQRFFxOCtlcTZBUnlEdFRYWUhMQ0VSdTBmTHhtODZIRFR3?=
 =?utf-8?B?UXBaYk5jcVBYUkpKWkxNREVtaG83Mm5uejk3aS9PdndnZzdjWkdzaCs4Mlpm?=
 =?utf-8?B?a0F0QW01ellscXN4dFRrZURWYkRyL0hCUU1qNXpuSFNQNlZueWlRTGhqbGNm?=
 =?utf-8?B?Mm1YdmV5ZlRmbm5oczFETU5QOXAxN3RZeGNHQ2ZEYmlKVW94dnMxUkdhTWJ1?=
 =?utf-8?B?eHJuSkk1ekhJNXVsdWlINURvMVpvbUZkNFo3enBjcmRVU0hNcnVCNjZhSDh6?=
 =?utf-8?B?VExLTEQ4VTVZVTFyVlNPQTNyVk82NXZOcE1jalg1UGN0R1Q1eXRJRmR5cGZZ?=
 =?utf-8?B?dkViRlN5eEQxSVNMOHlQRDdqOTgybEwrWjVtaTlPb2lxbXE2ZXZjUkFpZHF1?=
 =?utf-8?B?eXU1NkhjQlBUUU43RFlFOE5YVEwwd1VKMy9md2x2WXVTUkFJa0dYdTVndER0?=
 =?utf-8?B?ZTVXekU0R3VBQktrUTkvSm95d1dQQ2h4dzJiVEtHbk5qSEdoMmN2T0dJbW5L?=
 =?utf-8?B?MUNXVWNwZW03ZTBZb0dZdk5QMVp1aS9uMzErMTJCU3FTQW1VZThwZkg0dFJm?=
 =?utf-8?B?eUtTQ3d0WUFvVGtGMFduWDJFNC9OdGMvb1A0cTBsaWlkS3BvUTF2Z3FyS1RX?=
 =?utf-8?B?Z1FObW9MR2JndFpyM3liRExWYWNVTzIxTkdPZm9iWUcrQ3FCZTF1Q1gwZjBW?=
 =?utf-8?B?Tk9KQzFwZERNdUczRUxMYU5lOXJVTXZLQ25OUnVORy9BTnNUMVBsMEFuTjBH?=
 =?utf-8?B?MWF5a2JzQ2paNy9TekdiNlI3a0RWRG1aM1ZDaWdET3p5YVhrMWJGYzcvdVdW?=
 =?utf-8?B?U2phNHlPK1FBd2I0L2dEcmpXRzdxeGxaMzVoS0VmU0xqdmtScDQ4ZjlHSmVI?=
 =?utf-8?B?YXNKM3FGNTVDN0N4R3EwcjdWZW5mTHR1OE5FTWdTdXFuOXpoeFk5dWd6M1J2?=
 =?utf-8?B?Y0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2427c4bd-1ead-4a08-a366-08db6da8c8bb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 13:59:49.5277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zf3/FqU1/RcGgweR0e7M6UbRN5uJhfexIYo064dpExFoFEVubR2Up3jhQ76q9FDWZHqCcRnPUz0e8fBhI7o6kxaFqVNsDYZK9/y69j2gHAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8172
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 14 Jun 2023 10:19:54 -0700

> On Mon, 12 Jun 2023 21:02:55 +0800 Yunsheng Lin wrote:
>>  	struct page_pool_params pp_params = {
>> -		.flags = PP_FLAG_DMA_MAP | PP_FLAG_PAGE_FRAG |
>> -				PP_FLAG_DMA_SYNC_DEV,
>> +		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
>>  		.order = hns3_page_order(ring),
> 
> Does hns3_page_order() set a good example for the users?
> 
> static inline unsigned int hns3_page_order(struct hns3_enet_ring *ring)
> {
> #if (PAGE_SIZE < 8192)
> 	if (ring->buf_size > (PAGE_SIZE / 2))
> 		return 1;
> #endif
> 	return 0;
> }

Oh lol, just what Intel drivers do. They don't have a pool to keep some
bunch of pages (they can recycle a page only within its buffer), so in
order to still recycle them, they allocate order-1 pages to be able to
flip the halves >_<

> 
> Why allocate order 1 pages for buffers which would fit in a single page?
> I feel like this soft of heuristic should be built into the API itself.

Offtop:

I tested this series with IAVF: very little perf regression* (almost
stddev) comparing to just 1-page-per-frame Page Pool series, but 21 Mb
less RAM taken comparing to both "old" PP series and baseline, nice :D

(+Cc David Christensen, he'll be glad to hear we're stopping eating 64Kb
 pages)

* this might be caused by that in the previous version I was hardcoding
truesize, but now it depends on what page_pool_alloc() returns. Same for
Rx offset: it was always 0 previously, as every frame was placed at the
start of page, now depends on how PP places** it.
With MTU of 1500 and no XDP, two frames fit into one 4k page. With XDP
on (increased headroom) or increased MTU, PP starts effectively do
1-frame-per-page with literally no changes in performance (increased RAM
usage obviously -- I mean, it gets restored to the baseline numbers).

** BTW, instead of 2048 + 2048, I'm getting 1920 + 2176. Maybe the stack
would be happier to see more consistent truesize for cache purposes.
I'll try to play with it.

Thanks,
Olek

