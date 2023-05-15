Return-Path: <netdev+bounces-2715-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F86A703377
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:37:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F4941C20CED
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2E02D512;
	Mon, 15 May 2023 16:37:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F10DF53;
	Mon, 15 May 2023 16:37:19 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2D6126;
	Mon, 15 May 2023 09:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684168638; x=1715704638;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=baRFyCWWnNUUTmWVPV+HRDf3+TatFclupusdL+K81EY=;
  b=YB9dr8gJPmw2pjdY3ctcEYDVweWkMeWizsYoWUfUd3uv9J2bvTaRF1GI
   yxSOGdWKUp3c62us16mKNUja0Jj3w0m/kF+lWNeKbvNXGyl7xXY/fGQN9
   kGEqk8hYK0JoM/ujGU5YQPnoLoBcJBOuBXJCMg6ab2EDrUrr1DmOJYqJ0
   MnsR4XMoakzSP7+7LpEQDSONYvnDPXiA2iZV5PcTpGpJ5634iCUAjtS9n
   OgNXCeAdUZOEzQzklNnJBanSAwSZyEcHqcp97xBK0nUQ6Ws3OdB10yqcd
   vX4I7VTrB1lHlKf7Vme7ZG4yOdP7T6NKzArNcPkHeBe/o19riNskhmOHF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="340602958"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="340602958"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 09:37:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="651483299"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="651483299"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 15 May 2023 09:37:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 09:37:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 09:37:16 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 09:37:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZ6UoGVG+9P3gvF61+asGuRYo2zVsaxZis0Q8YafIfNkJtniuCEOq4lpbN5hstoyeVmp95QB/nEmY8SKo+XUDOqDqptBn7/X2qNMprtJ9OjP9n8RMc5i83OWkRAbijd0fl2H6uGG5bwlPjfaW8LGEYJglnK6bGjlT4ops7oNHN+KmwAr5cL/Z0BuQWPtg/HHlT465AQY8FdrrGgLXXdEdVH83TRfUKObkQmQDQdBJfJAn5u/Vgb0TlZVyFHxuuwHPSaIkEv0khdYU3dhdRxm/8s3HdRg64MmiW1ZpHuQQpg805LENUd6qOUOpj9oEWvozHxcVlKesqs0Kb+4eqePLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=spkSOehx1uz/4k7nhWEr81LlONh7zm7NcMjOWN9X0Vc=;
 b=FIAilas5FuVHmb6Lbd5Lk5Cc7liIpf4FOBD94DWX0Y58sMp4uPnHHcPHO5zU/4KAGTaQRInGOmauEchmRTHjlLGOnH1knLZurkDGDbTe393uD4hRcT1TRgDMTDtRFf+aPzCVmIAJWusq0aar2ZEYaaQp4XcoZZETuWmuQ+NoOXdSDuEbWQIxBpg0dhAmPLC3e4LtJUGV/55nPMRDxCXQAinNnCx80dWrLWz1282g6imJsOnjN8lOcOzZdVDa86XnaJMRrILFcwHyowLgSHg9fyWDgl2yLoH02/QAJOIRunZKQKjM6WEHRGemwwMoPilcfddjHrOfqbyhefUM6ko+0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA3PR11MB7535.namprd11.prod.outlook.com (2603:10b6:806:307::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 16:37:13 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590%2]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 16:37:13 +0000
Message-ID: <5a55afe2-61f8-8599-6cf2-bd4292e0daae@intel.com>
Date: Mon, 15 May 2023 18:36:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC net-next] net: veth: reduce page_pool memory footprint using
 half page per-buffer
To: Lorenzo Bianconi <lorenzo@kernel.org>
CC: <netdev@vger.kernel.org>, <lorenzo.bianconi@redhat.com>,
	<bpf@vger.kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <ast@kernel.org>,
	<daniel@iogearbox.net>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
	<linyunsheng@huawei.com>
References: <d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org>
 <c65eb429-035e-04a7-51d1-c588ac5053be@intel.com> <ZF5J2B4gS4AE3PHS@lore-desk>
Content-Language: en-US
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <ZF5J2B4gS4AE3PHS@lore-desk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::14) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA3PR11MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 026985d1-50d3-4b86-c0ca-08db5562a2d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SfhVXs/rlHLLCfcmfMx7+Xm8eSUpakDmv62edTdd9aGPpOFVYbO8S18FmR0nROkku6FMwjJdTv0CFJAdXY/L93y8LaIPYviEV6um+vTD51u7reCi1vT3qnZ5EqMCWmY9EWTi78oIFOf2OYRJzT+lwHmAGno1deKLOVZ8AQbFCB1HEQ4Y5YQlBweozNhQvs1whMPyoedbwJnSpfJGnfLdfawHENy51aETg7xffldCUEMitXnuJPO8hmmhMCE4U8q4ilDV9AzBt5EZ9h1MiMrA0bALv8DSoISlg80yIJ1DW91P3Yh584ztb4XXZMQnPY/VKRBg8f4Dqzi3ZxIg5lRRBH/7skOQ4NbpOvhi66HNWT+KfRQffTjTHG/5Qdd66ZXdpnkYpvS8iOyEuX0JnSnR/FcA5nj/hGnTalXm9RpH5yhaKeIoQZDJfDGfrfvSK7+prvejitu946lG0YbmvNQx3RDzRfcj052iBK0VeTwe5c2rVJzooLEpG+LgEjiBZ07bNHXSX3awdr8jxaFk9sTqDtBjtNoMO8cUKPrSVxAV1bAczdCzzJidct2LRwNcnsLckK1kVPLJ2xKKJhAMTAAZ2S0tWGVA2oZDi9ICApy0oorGMjqPlM3LEJ+9BNVJtM024CkfOcNlfOUF2lrT9saL9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199021)(66574015)(2616005)(2906002)(6666004)(83380400001)(6486002)(66556008)(66946007)(966005)(66476007)(478600001)(8936002)(8676002)(7416002)(6512007)(26005)(186003)(6506007)(5660300002)(316002)(6916009)(41300700001)(4326008)(86362001)(82960400001)(31696002)(38100700002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2dETHNIRFpOR3lxZThuZzlwa1hwQlRhcTFJS2cyRnc0RlJwQ3I2RnBDRm41?=
 =?utf-8?B?czlyaTB3UjJHQW5UVEgxaWEyUHE5TmFjVHNPUlpwTTJZcTlUa1RNR0Yyd3dS?=
 =?utf-8?B?V3V1NFl6TTNjZFhuMWZjU0lmdXNOb3dDRnV4cEw5aU5wS3FmRXBUZ1QxcWFn?=
 =?utf-8?B?TitCUnpBd3VUMTBwL2JyTlRnRXlzZWVwQ0I5YnhOQnpUbmhSdlg5RHE1bTFk?=
 =?utf-8?B?QkJ1VXhzZldhMlhLdWg2NVJlcHVGVUw3aTJiaE10aEp5K2VndXlIemZGWEJu?=
 =?utf-8?B?cTVYSlFISk4yaENGK1ZJNGk0aFFGUFQ3RldtS244T2Z4bE1Fdll3amNEWUQr?=
 =?utf-8?B?Uy81cFpreFM2R1doN2ZLUUVneU5jOE5jamlzamd4a05FenhOMTRXQkpZbGZz?=
 =?utf-8?B?ZGUwd0I5QWovV0U3U0xoMUFjWGZtMHdFSzFsVWovNEVHV3QrRk0xaDF2dnBa?=
 =?utf-8?B?ZEk1SkJRblloUXpMaVB6QksvRWxYWUhIUHVyZlVodURla0lIUmRHelZRZjB3?=
 =?utf-8?B?cXBCZUh1MWY2cTFHd3ZHUG52NkJSVTlUQ0FTZmRBaVpsVW1lZUpqVk9oNFJo?=
 =?utf-8?B?aGsrUWo3cXp2M3ZqS3Z2dFhOZVc4M2p1eXQ4S1hRaTkxMEp6dG5WK3ZzTG9t?=
 =?utf-8?B?OCtRT0hsdXU0aEduZG5ZVGh3RFFvNEcyczRYMm9HT0pseldLR0dvVE1hTVRh?=
 =?utf-8?B?dDU5bkNPZjVsRXg3bHhoT2JpQmdmVTFEYkZYSm8yN1Z0S1hwMjlySm5oazdK?=
 =?utf-8?B?R0gvUWxES0k4bzRiNDdudEJuVDN3dlhhR2k1MDhra1dBTThtOHQ1Y1R0a0gz?=
 =?utf-8?B?c3VjZkMwcWFVRmpGVm1Xb3JLd2dMdTYvYi9MdWNqSDNFOG1pWHYvT1Y1SDF6?=
 =?utf-8?B?N0k4MTUzdDl5bFVybFl1S0VWYWhFQ1pJdnc5cmN5Z2R2TlpTb2FVaGdHN2dU?=
 =?utf-8?B?SUVId0dlc0pFK1BIejlPQnNodG9aOU5YdXJtWWdGSzJZN1BIZCtpdjZNK1o5?=
 =?utf-8?B?ZjhFNkFnL05TajBzbGo3bG9UTTJXaUhwb3J2WGVHbXA4TWxuZUs0MVRhampE?=
 =?utf-8?B?WXRRRW9oZWRwR2ZubFBsNGM5eGo0ZzE0RVRpVUdkYStycnFMY1BkZEprU29r?=
 =?utf-8?B?VEJ0OWh0SXdaZDlDVmxjaE1CYU1VY3RmWlo5WkI4aXIwelg1bmloblBpZVkv?=
 =?utf-8?B?RGZwODRuUDJaNmVVTmprQzc4WkdWWEo3cEplcytWWEZkSkoxalRodE92czVt?=
 =?utf-8?B?VUZhSVUwUXIxajZDU2pKSDJLNjNScVA0Z2krbEw4NG1rY1A4cng5RlNXa0VR?=
 =?utf-8?B?THJxVDBBWlRMOU9MM3pTZXUzY3ptUVVtTkEvTU5VOUFJY21vb21qU3RGcGVN?=
 =?utf-8?B?WVRmMVFWZyt3S0JsWFlwTUQzUVhycllnajdDMU93bEVwL1A4S3NxaWcrU29N?=
 =?utf-8?B?WFREOEJocEVHenJMNm1WT3dHWEZSSHljaU9Pd0FvZjlMY0ZQNjF6UGt1MUZi?=
 =?utf-8?B?ZkZYdml0RnFyNkJ6TzUzb08zaEFjNW5yNHpZSTN5b3BabVlldzM3eVlQem5q?=
 =?utf-8?B?REtLWThxQ3pwMWVtOWZOTnBJUUc5eUxVNzNTNWU1cldPRXRoQWQySGZuUjM1?=
 =?utf-8?B?ZXg5RjlLTzI2eFJwVTRTdDQ1cmc5UlJtYUxyakpCWUlJRFQybThLcGY5eEVs?=
 =?utf-8?B?V2VINktsOHlybkZOZm1vbUptNFB1MUdkQ29kTG1kbzlOYmdOSG9MVjdMeXI2?=
 =?utf-8?B?MDNuRVlNcjFGd3dMK0ZxN2NON2Z1U3FiWVl1UXVxOW1lbHZZSmlseS9XUThw?=
 =?utf-8?B?L0hVSU0wYnREaUtPcjl0T0oyNmZvZmwveDN4UFJsYy9PY08va09MQTRFZ2R3?=
 =?utf-8?B?ZFdkYjNHbXlPZW92SE9YNFBjS3V4OXpBU2gybGRVaXJ5dUk3bG5HWEkrN2Ux?=
 =?utf-8?B?aUY0a3k4MjJVYzJ3QTR6aGZsOVA3dWRTbzNUTDI5N1VtK0ROWXluN2JpUWxR?=
 =?utf-8?B?VUlaTDhkMjFtVy9Tb3I2b2pmMWJvRTlCdU9aR0VBL1JHL0hiQW1rVHd6WS95?=
 =?utf-8?B?enlIcEk0OE5RYnZoSGw3R1NhWFgxU2E5MjFKRWhxcExKNGQ3ZHUvc25Wengz?=
 =?utf-8?B?QnBEN2VoQkhvRzYzdUkwbG92dGREanFhK0FXZlkycDRPOGQ1Z2lMeHNzWG9D?=
 =?utf-8?B?RHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 026985d1-50d3-4b86-c0ca-08db5562a2d0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 16:37:13.3277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7AeIBLU6a/KTTE7GMwhSvvyA1+MrnKTqOKc8r/sBkZh96YGcyjRVptlCgS1jL/i85ZsWF2mcWrCvpis0akqqyw1pfMZnNbVq0jucVSIduFo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7535
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Fri, 12 May 2023 16:14:48 +0200

>> From: Lorenzo Bianconi <lorenzo@kernel.org>
>> Date: Fri, 12 May 2023 15:08:13 +0200
>>
>>> In order to reduce page_pool memory footprint, rely on
>>> page_pool_dev_alloc_frag routine and reduce buffer size
>>> (VETH_PAGE_POOL_FRAG_SIZE) to PAGE_SIZE / 2 in order to consume one page
>>> for two 1500B frames. Reduce VETH_XDP_PACKET_HEADROOM to 192 from 256
>>> (XDP_PACKET_HEADROOM) to fit max_head_size in VETH_PAGE_POOL_FRAG_SIZE.
>>> Please note, using default values (CONFIG_MAX_SKB_FRAGS=17), maximum
>>> supported MTU is now reduced to 36350B.
>>
>> I thought we're stepping away from page splitting bit by bit O_o
> 
> do you mean to driver private page_split implementation? AFAIK we are not
> stepping away from page_pool page split implementation (or maybe I missed it :))

Page split in general. Since early-mid 2021, Page Pool with 1 page per
frame shows results comparable to drivers doing page split, but it
doesn't have such MTU / headroom / ... limitations.

> 
>> Primarily for the reasons you mentioned / worked around here: it creates
>> several significant limitations and at least on 64-bit systems it
>> doesn't scale anymore. 192 bytes of headroom is less than what XDP
>> expects (isn't it? Isn't 256 standard-standard, so that skb XDP path
>> reallocates heads only to have 256+ there?), 384 bytes of shinfo can
>> change anytime and even now page split simply blocks you from increasing
>> MAX_SKB_FRAGS even by one. Not speaking of MTU limitations etc.
>> BTW Intel drivers suffer from the very same things due solely to page
>> split (and I'm almost done with converting at least some of them to Page
>> Pool and 1 page per buffer model), I don't recommend deliberately
>> falling into that pit =\ :D
> 
> I am not sure about the 192 vs 256 bytes of headroom (this is why I sent this
> patch as RFC, my main goal is to discuss about this requirement). In the
> previous discussion [0] we deferred this implementation since if we do not
> reduce requested xdp headroom, we will not be able to fit two 1500B frames
> into a single page (for skb_shared_info size [1]) and we introduce a performance
> penalty.

Yes, that's what I'm talking about. In order to fit two 1500-byte frames
onto one page on x86_64, you need to have at most 192 bytes of headroom
(192 + 320 of shinfo = 512 per frame / 1024 per page), but XDP requires
256. And then you have one more problem from the other side, I mean
shinfo size. It can change anytime because it's not UAPI or ABI or
whatever and nobody can say "hey, don't touch it, you break my page
split", at the same time with page splitting you're not able to increase
MAX_SKB_FRAGS.
And for MTU > 1536 this is all worthless, just a waste of cycles. With 1
page per frame you can have up to 3.5k per fragment.

You mentioned memory footprint. Do you have any exact numbers to show
this can help significantly?
Because I have PP on my home router with 16k-sized pages and 128 Mb of
RAM and there's no memory shortage there :D I realize it doesn't mean
anything and I'm mostly joking mentioning this, but still.

> 
> Regards,
> Lorenzo
> 
> [0] https://lore.kernel.org/netdev/6298f73f7cc7391c7c4a52a6a89b1ae21488bda1.1682188837.git.lorenzo@kernel.org/
> [1] $ pahole -C skb_shared_info vmlinux.o 
> struct skb_shared_info {
>         __u8                       flags;                /*     0     1 */
>         __u8                       meta_len;             /*     1     1 */
>         __u8                       nr_frags;             /*     2     1 */
>         __u8                       tx_flags;             /*     3     1 */
>         unsigned short             gso_size;             /*     4     2 */
>         unsigned short             gso_segs;             /*     6     2 */
>         struct sk_buff *           frag_list;            /*     8     8 */
>         struct skb_shared_hwtstamps hwtstamps;           /*    16     8 */
>         unsigned int               gso_type;             /*    24     4 */
>         u32                        tskey;                /*    28     4 */
>         atomic_t                   dataref;              /*    32     4 */
>         unsigned int               xdp_frags_size;       /*    36     4 */
>         void *                     destructor_arg;       /*    40     8 */
>         skb_frag_t                 frags[17];            /*    48   272 */
> 
>         /* size: 320, cachelines: 5, members: 14 */
> };
> 
>>
>>>
>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>> ---
>>>  drivers/net/veth.c | 39 +++++++++++++++++++++++++--------------
>>>  1 file changed, 25 insertions(+), 14 deletions(-)
>> [...]
>>
>> Thanks,
>> Olek

Thanks,
Olek

