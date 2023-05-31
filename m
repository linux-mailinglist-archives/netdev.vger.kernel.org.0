Return-Path: <netdev+bounces-6840-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B74718635
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:23:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2F6D28151E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0F0B171C5;
	Wed, 31 May 2023 15:23:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD5F2583
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:23:56 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A00184;
	Wed, 31 May 2023 08:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685546633; x=1717082633;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pYHXvlG8HHyQGBkaUzEtLZRDPIOeb8zQqR9vYo+ndyA=;
  b=nK10PozJ74KGj7Kx7fWU5ymVQF9ZCp3XaSXzTTttG3FHaf2Ms8XaM0wK
   ZL71BkMerj46xIabYw+uwzvqMVxbWP4XAOPSDMCUTd+dO1A6HoXy0yYrO
   y+eYVkYqUsBy9sbnK1apnYeNQQZxXqgb0IcN3qNM5RJOaEsOF9qiCV1ZR
   SFZeyJjr1sscWBm30N+0O9fxOS1CbvLCMhdZtnYWb5tAMZ4+hTUBPij8y
   ogmKhxwFsuCQjeJ0zYQXkThY735L0MqDhN3kDOfVP7jUapurUW2QHxVQ1
   BT5tcGTpZRqfCr9ndvZ2hPyMLLMpvvBJyIShFfE8tqYouo+y1MgO43FiI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="344785391"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="344785391"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 08:23:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="831259956"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="831259956"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 31 May 2023 08:23:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 08:23:43 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 08:23:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 31 May 2023 08:23:42 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 31 May 2023 08:23:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKqfYlzFpQPZU+pQsw66/zTlvmyVZk65XfDBdx+0nmWxo+EvF1Y86oTPOwTS4cjeM+UVVYTUoFAYMxh3mWXTgadZ2F9wjnlKswpPy2zKabJot2+sUQU5SZQtjCtgcb7Aisb9sr9O5ZWJVKax6HSMbfz3SpGwiy24JqvOzELct/JZ3SMxJKkUmh5IEEdXoT0u3q5BJfJ4nU9AwubbPwZhymF2HMlKHpmKNqWehKTTmcAJvJvCl4OLfHl1yBLe18ryJdxO4xhfSGf//G5jaZs8ovPby3scwoaddodJR8fSfdi7t67EsQMDbNxVfWbocBva4b+EpU30OEAXytlO5hoagA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+6zypXEvRFtXlznSfMUYCIr7G6/Wr1nUu47WIwgktUM=;
 b=WdO604IHpxLt9qVdduGJv9Iu30RIN+Bk3pr51JzUBtNVWEvfAJAnXJTDFuvYKNL/cRYSkBEWKIxFtJj3AyPxhwyQGQojs/nZjzUd0FGzEmOw8ht+pJRLl5eo3ZRpFcnCRcR4gYF0wvztbnbGc2Bpa6Fgkof/4LOAGw8jXhqZipmXVS93arbcHoHhGW40smv8UXjDY4o6Ye9BlNVucPiMBueO3dY0NlNBttBnfI446kdd9/Qx/hRjz8U9psAVvI4Pbvkc0L8SnjnOb5zMPFPw6Iex1avr4tsW9MBVIca7cdXXiFc922ku3ao+SCCbFZ6jeP4pTwXIABs382pDJMA2Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MN2PR11MB4677.namprd11.prod.outlook.com (2603:10b6:208:24e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 15:23:40 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590%2]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 15:23:40 +0000
Message-ID: <7ddd93fd-437d-8d67-c693-1bbcf36b552a@intel.com>
Date: Wed, 31 May 2023 17:22:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v2 03/12] iavf: optimize Rx buffer allocation a
 bunch
Content-Language: en-US
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC: Alexander H Duyck <alexander.duyck@gmail.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Magnus Karlsson
	<magnus.karlsson@intel.com>, Michal Kubiak <michal.kubiak@intel.com>, "Larysa
 Zaremba" <larysa.zaremba@intel.com>, Jesper Dangaard Brouer
	<hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, "Christoph
 Hellwig" <hch@lst.de>, Paul Menzel <pmenzel@molgen.mpg.de>,
	<netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
	<linux-kernel@vger.kernel.org>
References: <20230525125746.553874-1-aleksander.lobakin@intel.com>
 <20230525125746.553874-4-aleksander.lobakin@intel.com>
 <8828262f1c238ab28be9ec87a7701acd791af926.camel@gmail.com>
 <ZHcsBPr0EXx6hkkd@boxer>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <ZHcsBPr0EXx6hkkd@boxer>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0071.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::6) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MN2PR11MB4677:EE_
X-MS-Office365-Filtering-Correlation-Id: ad4be76c-b0d9-4612-5422-08db61eb02f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PZ/ADPmrHmmWddUdNJ49KXTuq8MeUxbPFMFZRg7jUJfKpBNaf25y+FkTvDBJvxKGRwsYkSwNdkjhlTxx8vO3vV5cc7QuVWJtZ27aDhmY6/nNTjpFHfGtEkLtczoUbV6qNG7nOlkwzR7T0x11O6uSd0ubGiYHFT5dPMVvpYYumjz7DQHsf9/QGflCHIfhUEFd3MOONEU4gEfXGoHPRbv50JBLkv0XdyRr4QNngjoYh18qnc+bXVraUjJ4Zis39uoptSN1+lc1X3uWSuSv2noHW1Iq/1xvMSImiRyTmLTdnJoDquWQHAjoV4Aqh20CglpjxKPd/Lz6mkXX7b4fB+6JPnmjb9Ja9fmvJIbJ+J6LQa7/S53c3Memelk7KkzJUeJCrr0F/LIhp5itvq+tp8ph3wrKrP1AlPgDR8f3B+HKcI8dALmTzhbHHfoFVzEkHqNLlVStChJDJmh5iHMWhzZ9T3ChBpgSW9lmH2FDn/R/FC7RHwDSmzBskUaTdwwy4Yj64ayGj93hosZH1juDFKtBXAFUvrXVnRDEmXlv5sXXaGgdJQlml2r9y5PPoePURHsoDkI5Ku95QkOpJ3iZUmyfjmxVAOBdXrhFUIc9l9xuT8SJNQlgmi4iBkIuYMUCnMK5WPvCXHa+my8x2+NTMkY4T4IqhS4xOZKEkULj2ka83B+hVnl0B5iE4aEtLw+8gcUk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(136003)(396003)(346002)(366004)(451199021)(6486002)(6666004)(478600001)(186003)(36756003)(26005)(6506007)(6512007)(83380400001)(2616005)(38100700002)(86362001)(31696002)(82960400001)(316002)(41300700001)(66476007)(66556008)(66946007)(4326008)(6636002)(7416002)(31686004)(8676002)(8936002)(5660300002)(2906002)(6862004)(37006003)(66899021)(54906003)(34814002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wit2dm1wbkpzVDk4Nk52REk2M2NNQnFGbW9IZlFrN1RTdjArM3NNVC81V1pP?=
 =?utf-8?B?NGcrTEZ2MmRxdWF6dDFVOTN3VHFSSzQrU0hQMHNESENweVdqcFRNdTFtdnRU?=
 =?utf-8?B?TVpydHZyVll5T2gwUC9kdTluSWREZWdIVkplckhlY0J2cm9kSXV5NTFmd3ZT?=
 =?utf-8?B?WmE0RXZOaFdva3BPQ0lWR2xHdkJ6NnMxdSsvU21jcEM1YjQ1Q3hvbEx5cmhM?=
 =?utf-8?B?UVRHc0p2djB2ZjdBYUliNEZlUUZxb0dXcFh4TFFqdFpxNUJjbzhZOE9JNzc0?=
 =?utf-8?B?cXJ3aFJ2azdEYWVlN2kzcDNqYlFaOVdYT01lT3NaV0JhTGZrbmhXZ1VLQkFG?=
 =?utf-8?B?SWRQdXFTSVFNaFdRTXNBWHMxeGJlOUNEajJ4c2pWMzdxYzU1YmhDRTB2YlF5?=
 =?utf-8?B?OENEWHhUUFlqc2VTcnRTNU5WbnNGb2N1ajFUQ3RIckk4eTYrVEc3MEF1SlV2?=
 =?utf-8?B?R0RKemNQaWYwOGNjQmtlZEtsTmIwNEN3NGdwRXZKYml2Y1Nuems1WGRMZitN?=
 =?utf-8?B?TFk1Y1pWQjBDSlNjWmhyQ3RvUlp1WElwaHNzL2JreEJpcC9EUW9pb3gwaHFV?=
 =?utf-8?B?MTFoaXl1M0lJWUlCdHpVSDFSYndyTFN2OHc2aGs3QnFlUVMwQlpXWTBNNlo4?=
 =?utf-8?B?OFdBYXNqWDV2WU5ueUJ0WEttZHRlSHNoVHc0d3oxMnhiZzlIYytpNmxQM2E2?=
 =?utf-8?B?ckZIQ0lZc0lzMkZVOXBaQW5IWUlzZFA3TkZ6bEdrSTI1OUZocjNQb0RXTThl?=
 =?utf-8?B?WDVqK212R3JUNVBMRDlsZzU2N0lCOUlHMFRVdWJZTW10dEdOaURVRk5STUJK?=
 =?utf-8?B?TDJXNGVIS1l4MXNMN0Z4enB5VkZnREZkek8zTWpzRkF1WHVnQ04vVW5OT3pi?=
 =?utf-8?B?d3E0TktPQ3dGQ3dRbWZHeEpEUGpQRFdRSGV5cUJUbEFSNlZSMm1EZXpDcTlw?=
 =?utf-8?B?UG9KbHlMYUUxS005M0NVQUVmRE9zNEhYcENsRi9ZeTNMQWlYNkFpRDBWVkl1?=
 =?utf-8?B?akYxNjR4NnhlU1BYd1c0MHpBb3FyZnp0MytncEp0SldySUd4Vk1IRWpRbWtk?=
 =?utf-8?B?NjBUL1FtOW5mV0VQSjNJUFVPMWpFaFlEZGRsVmhkN0V2eFFTTHJWNG5hS0Rk?=
 =?utf-8?B?TDVac3NvU0NzaGhkVlhzcUF1endpbjRMQjBPYkdLbGd0U0ZoUHNWbk5GSXMz?=
 =?utf-8?B?L0lma0JKM3g1WjdOTjZOd2gwUXZxaFgyU2RkZlk4Wit3ZnFYMWY4eFhCMkZB?=
 =?utf-8?B?cE01blNDYkUwNitZaU1ZY25oSmJnM21YaWl3LzFnemxGb3FuRU1GTENTU24y?=
 =?utf-8?B?cTRwV1RaY3o3ZUgvOFVKKzlIZEVIcmEya25qVGlLbTQvWHJmdUg4cElKNEtR?=
 =?utf-8?B?bGRtQ09heEdCOFhxTVlVRE8zSXcxU2tmQ2tSTDhseUhYM05qQkE1eDdJWE04?=
 =?utf-8?B?ZXRiU3NBSjZZd2I1VGVwemxXRCtyUnBuNW1uSEpyS3FPRDI0VjlHRG4vUjZx?=
 =?utf-8?B?Nkx5Mk9sRm1sRkZKaUw5YmpMcW1lSHJJdTNxNDZBZ2ZSVWQxM2FLU0x3a2tK?=
 =?utf-8?B?K21Na0tMdEgweVBqcWdyay9VOFAzNjVPT2tTRVBKNkdINW84b1B5OE9pc3Na?=
 =?utf-8?B?THBuU201MmxpT2kxYkdDT3lpY1Y5MGhxSlBFejZvSW1jbTFvQzRnd0pQVldr?=
 =?utf-8?B?ZnNpdnJma1psd0RyN3BaeEljdGNCUU9uS25mWnlQOEFtWlpsNTAxcW9ETVhh?=
 =?utf-8?B?MjZUcDhHRXhPNlFMZW95cTQrQ0xNSCtOTnBmWjZSbDFKQisxZ1BudjVLdkdx?=
 =?utf-8?B?OGFhdDNYRHZkZjB3bTBxeFl4dldwbVdsSCtPdzZWU09GelR5UGdFTTZib2Rl?=
 =?utf-8?B?SnA5TUIvSGpyVVg3QWtvY0FXeW42Y0c5SHRTMTU1MzNxT1Z5YlBKeXVIY2pa?=
 =?utf-8?B?V2QwSzc5VHJqdm5tMWdWck53bW9qRUE4WUpLQ2tJOXRweTBEL0VLVFo3L3dn?=
 =?utf-8?B?d0hzM0JZa1dIL3hJdFBzRGFzT1JBbGJ3dTQwSjExM0RzaXlEa1ZzUm1UMGht?=
 =?utf-8?B?dHE4ZDRKNVVQNmxBWFNHREFtMmpDeU9sSDk4bE1lbkphMUM1VnVxRi8xeElz?=
 =?utf-8?B?Y1lXMGRiMDE1aktGSy9tNXB0ajVSTWVGWXN2VTVST3Qwd3hoaFlzT3RlMmw0?=
 =?utf-8?B?Znc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ad4be76c-b0d9-4612-5422-08db61eb02f7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 15:23:40.1331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GJQpfhsNGniQqRWQipfJncluAKuZkayvel0V8KqrjLREu1KPzGaReOz25Z3obV/Ywaqq2kwRECabHzcRHwE36mbYlFJO06HvLuk9FiMdwFM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4677
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date: Wed, 31 May 2023 13:14:12 +0200

> On Tue, May 30, 2023 at 09:18:40AM -0700, Alexander H Duyck wrote:
> 
> FWIW I agree with what Alex is saying over here.

There are 2 Alexes, "choose wisely" :P

> 
>> On Thu, 2023-05-25 at 14:57 +0200, Alexander Lobakin wrote:
>>> The Rx hotpath code of IAVF is not well-optimized TBH. Before doing any
>>> further buffer model changes, shake it up a bit. Notably:
>>>
>>> 1. Cache more variables on the stack.
>>>    DMA device, Rx page size, NTC -- these are the most common things
>>>    used all throughout the hotpath, often in loops on each iteration.
>>>    Instead of fetching (or even calculating, as with the page size) them
>>>    from the ring all the time, cache them on the stack at the beginning
>>>    of the NAPI polling callback. NTC will be written back at the end,
>>>    the rest are used read-only, so no sync needed.
>>
>> The advantage of this is going to vary based on the attribute. One of
>> the reasons why I left most of this on the ring is because the section
>> of the ring most of these variables were meant to be read-mostly and
>> shouldn't have resulted in any additional overhead versus accessing
>> them from the stack.
> 
> I believe it depends on ring struct layout which vary across our drivers,
> no? On ice using making more usage of stack as described above improved
> perf.

It's +/- the same, most layout changes usually come with us moving stuff
around to optimize paddings and cachelines lol. Here's the same as with
ice, I don't think it's driver specific to get some positive results
from shortcutting more hotties. The sole time I was surprised is when
you were getting worse results storing xdp_buff on the stack vs on the
ring :D

> 
>>
>>> 2. Don't move the recycled buffers around the ring.
>>>    The idea of passing the page of the right-now-recycled-buffer to a
>>>    different buffer, in this case, the first one that needs to be
>>>    allocated, moreover, on each new frame, is fundamentally wrong. It
>>>    involves a few o' fetches, branches and then writes (and one Rx
>>>    buffer struct is at least 32 bytes) where they're completely unneeded,
>>>    but gives no good -- the result is the same as if we'd recycle it
>>>    inplace, at the same position where it was used. So drop this and let
>>>    the main refilling function take care of all the buffers, which were
>>>    processed and now need to be recycled/refilled.
>>
>> The next_to_alloc logic was put in place to deal with systems that are
>> experiencing memory issues. Specifically what can end up happening is
>> that the ring can stall due to failing memory allocations and the
>> memory can get stuck on the ring. For that reason we were essentially
>> defragmenting the buffers when we started suffering memory pressure so
>> that they could be reusued and/or freed following immediate use.
>>
>> Basically what you are trading off is some exception handling for
>> performance by removing it.
> 
> With all of the mix of the changes this patch carries, I find it hard to
> follow from description which parts of diff I should be looking at.

Huge piece removed before add_rx_frag_blah.

> 
>>
>>> 3. Don't allocate with %GPF_ATOMIC on ifup.
>>>    This involved introducing the @gfp parameter to a couple functions.
>>>    Doesn't change anything for Rx -> softirq.

[...]

>>> + up to 2% performance.
>>>
>>
>> What is the test you saw the 2% performance improvement in? Is it
>> something XDP related or a full stack test?
> 
> +1, can you say more about that measurement?

My prev reply to Alex.

> 
>>
>>> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
>>
>> Also one thing I am not a huge fan of is a patch that is really a
>> patchset onto itself. With all 6 items called out here I would have
>> preferred to see this as 6 patches as it would have been easier to
>> review.
> 
> +1

+1 :D

[...]

>>>  	/* if we are the last buffer then there is nothing else to do */
>>>  #define IAVF_RXD_EOF BIT(IAVF_RX_DESC_STATUS_EOF_SHIFT)
>>>  	if (likely(iavf_test_staterr(rx_desc, IAVF_RXD_EOF)))
>>
>> You may want to see if you can get rid of this function entirely,
>> perhaps you do in a later patch. This function was added for ixgbe back
>> in the day to allow us to place the skb back in the ring for the RSC
>> based workloads where we had to deal with interleaved frames in the Rx
>> path.
>>
>> For example, one question here would be why are we passing skb? It
>> isn't used as far as I can tell.
>>
> this was used back when skb was stored within the Rx buffer and now we
> just store skb on Rx ring struct, so good catch, this arg is redundant.

Also prev reply. I'm removing it later in the series hehe.

> 
> I'll go and take a look at code on v3.

No changes apart fixing OcteonTX2 compilation =\

Thanks,
Olek

