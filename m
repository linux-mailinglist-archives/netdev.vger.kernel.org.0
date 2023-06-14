Return-Path: <netdev+bounces-10716-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E42772FEE5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:42:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39FA628145E
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:42:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FD2E6FBB;
	Wed, 14 Jun 2023 12:42:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C29A3D99
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:42:23 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904E6198;
	Wed, 14 Jun 2023 05:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686746541; x=1718282541;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Oe4syyaRJMFWt//mJ/tNt8rB3SjG/qVLcsEsMEBdymQ=;
  b=lATB6/DTqVSYWG97b35z0BksfAZHlYssK8DEPTgaRrFzht6E7I7J8rdF
   KSVFfMMYlkteA1Cc5BOR0zJy2z+k2EblPR/ALG79rH4gObr5m1shgK4Th
   PogPW4Xi9/4fz81TLcTTaaYJdU45lj9hYOdy5/C0FYIMATdK7C83fwdQS
   8OjMo2HT4LU0H+29CbZTEHfZbsbRXAA3dVIVJZb4WAzxkDonl/Npr+rPS
   DrsI1aFGTv47eUo0dG4x5IqHxSvY7ib1d1/Dz5hLHHdH4bC3xPpLMo9s5
   KB/24JKzQ5sSnjONjYAsCAW5VtsPgOOGZoIoFOTQD3cIgVclvSwoSakpf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="361079749"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="361079749"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 05:42:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="741827088"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="741827088"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 14 Jun 2023 05:42:20 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 05:42:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 05:42:20 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 05:42:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EunRRvDNreW5KZAseKptTwsxkCX1R7nmWAd3T3O5+DENwyWdgBq0WZ4AGzPmL3JylnYdQE0CDbheXtTkuAPLl+qrT1w0/YATOTR4JZ9IUXDQz8j1l+OSfSSuWw4x1esiSMoK17ffdtp1hmNX7iSThJx3B3XhsLnMmH0S2wyM+WrFnL0d9ywphfDiN8UrsvLh2x4/CZiyQo+FtQiOjA1xUpyeHyl8xgrXp6OFmh9Pcl3J1aCYnXlEjpAshIeb3tIVVs1I5IG8wdAaANdCDaxyqMm+m6RzqXTwqRT1r6WtHDAS6EA7g4eS4wMec2aClplk3yzfnNaoF7bVoZj8ZFy8cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jMTEERwjji6qbVnbEGnX2ok9FWoHExYm1IETcLe/Hfc=;
 b=WEh/x3I9Kh+3snSnZ0eQrZ5OUEY/CmRBmxGRCdGLLB7YWC2B48DjXp3Pu/B3XC/f93VU0T1TkF9eD/4STfgvR8+YapAN8yY23zCkw07CbRrsvli0Z5uXB3FooUteuCjHOYPfc6vNzGN0whLLvm1ZohaEgjmml68ht/GOQ6MlVhHWW5JVBmFvXYlJzeLqKt3EWZoIXMHe0eiAXMNmtr468NetRXuR9lbvvY8kKY1SkTTBnnXU3uuYc5sx/xwazOquhsrRs1fEu5zSx8EjBUC7V7BmGt/bVe9KtPkxit3NmesZS5R5knMtIWoZd+Gy+q4Qn7jnBaVYUlqot5keR3ccnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA0PR11MB7884.namprd11.prod.outlook.com (2603:10b6:208:3dc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Wed, 14 Jun
 2023 12:42:10 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Wed, 14 Jun 2023
 12:42:10 +0000
Message-ID: <09842498-b3ba-320d-be8d-348b85e8d525@intel.com>
Date: Wed, 14 Jun 2023 14:42:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.1
Subject: Re: [PATCH net-next v4 1/5] page_pool: frag API support for 32-bit
 arch with 64-bit DMA
Content-Language: en-US
To: Yunsheng Lin <linyunsheng@huawei.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Lorenzo Bianconi
	<lorenzo@kernel.org>, Alexander Duyck <alexander.duyck@gmail.com>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Eric
 Dumazet <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>,
	"Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
	<linux-rdma@vger.kernel.org>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
 <20230612130256.4572-2-linyunsheng@huawei.com>
 <483d7a70-3377-a241-4554-212662ee3930@intel.com>
 <6db097ba-c3fe-6e45-3c39-c21b4d9e16ef@huawei.com>
 <16cc3a9d-bd05-5a9f-cb2e-7c6790ebd9fe@intel.com>
 <2eb57144-1e51-239b-07b2-b6b3737e7497@huawei.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <2eb57144-1e51-239b-07b2-b6b3737e7497@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0213.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::11) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA0PR11MB7884:EE_
X-MS-Office365-Filtering-Correlation-Id: e4311a99-3f6a-4ccc-f79e-08db6cd4c555
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: akeqyk3fB/zaCpAtJxFHjNGvaanRiXRZ1Vki4KCLVQICoXdcGitXyW/YUnwyRPIukdQrahfKhNzpnyGmwTTxDHPxIMjj4ys3uFJ+Z328hw2xRRgAy49fzZfcmHWGjAHGVvE759P7qvJE4qT/oowE+MuozBoMnipno6HyghQVFKMSy24RnYNQ1jjZ5LGT1lzhdAm0X2emE+f62/JVtmfEJvxVFwDIurync//HFBsHrNI9GEv8pHHlh6LU3uLLzuyTJwegh4VRfENw5QuSiJnQ+E54INMMXQ8HQz8lh7dxZFvxzM7ouHd+4cDH1I3r+Wy18jAmyDO3e6nEvcRow4S2OQY01/x4rQfT5G8nB2j6gkaltcOFBkzKx8jeqSQntDpkaaiagguuViiEK2Y03ARQTnEhmKzBEPvvx2ByZexjnKSWyFrfUUNBZeBomBnTc41/AT2JXJWmD0ZoJpQomJVsiWVy7eUoniTmFEk7oVE/4HBeLsR7OO6uHQKUdZbWHYMWUYUPLWHW6DVXT9x7D+oE/GTMuknbyTkKAZQW6DDfJEgOPNf505BNZ2MtAMQtvLfMJaLKwa2/JzO4EkYquG50970nkowG3566etiXSKs4QFSpBQ3bFjgAbP8HpNyOdGCcNSzmKdFZopdPa3blEVGh/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(346002)(366004)(376002)(136003)(451199021)(66946007)(31686004)(5660300002)(8676002)(36756003)(8936002)(4326008)(6916009)(66476007)(66556008)(6666004)(54906003)(478600001)(41300700001)(316002)(38100700002)(82960400001)(4744005)(186003)(26005)(2616005)(86362001)(6506007)(7416002)(6512007)(31696002)(6486002)(2906002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0tzZ0RRWTdZelVqV1RzTjdhd2gvejhuMGpjbEpEUHFZSGlNOGhIYlBEN2V0?=
 =?utf-8?B?UElCUE1wUW9zK3ExcG1xYmVuSDhqQTUzQXZOQTg3U2ZaTWpVbytlNFRxRnNq?=
 =?utf-8?B?VHdIa2IxYXVYWERaREZGM1BBd3pmTGV5WU9YMlRkVEdZM2w4MlowbEw3U1NY?=
 =?utf-8?B?U2EweDkzbEdwTVF0ZHdZS2JHY2VBL2ttRmppTGpCQmpLeXJOQXc2RGtDb2RJ?=
 =?utf-8?B?djNJTmJnV2NWVnl3TWw2MXFpQ1RyUG9kRlJSZnJ0SnU2L2k0TzRUNVYyZXpF?=
 =?utf-8?B?U1llQkoyOUdRNFZKUUEvL3RBY3MweGg3bkVkVUFoeGhMaVlieUk4ZWFwZlho?=
 =?utf-8?B?cmRTZkF2dWM0MzkreVN6R0NZcUt4bnRpRmhxTkluYi9ZNzROTVpRZXkzdmNG?=
 =?utf-8?B?S0VES3hrT1Mwc0U5cmpOR3l1OGY4Z05HZzNnVG9GMFRZVWRab1V2dStSZHBK?=
 =?utf-8?B?dy9WRmlQNjVSVkc2dDR5SlFvMXIvaW5jYVBJcnlkVzRJSTdVWTk1d0phZ2pj?=
 =?utf-8?B?d2p0VFJrMFlRQzBibjZzQVlKQkNTYUhRVHVhWk1jNHVkTGYvaWxYWUdMazUx?=
 =?utf-8?B?TXp3WUZQYmJXbUdGOGF5cHU5STBpL2ZrVEhieGNlRkJnOThKbThHY1dITEh2?=
 =?utf-8?B?Z2FHV2dGVUNtWUlEQnlNUWZOS012NjZPRDZJSWdRS0JYaFpBbk8vc2UrZzh5?=
 =?utf-8?B?d1diL3V3QlhVa0hUelJDSlZhRzhYQlhqWUlmeXZVSzkvYzlRNDJtYTRpbUFR?=
 =?utf-8?B?RmtuR0U4aG9pU29sS1JRTTlNYzIxdkpyUjlsUDhvWFAwSDJnVmFtUGM2K1lY?=
 =?utf-8?B?TGlaeTlwT2huNlJybDZlcnhYY1RRVElmTHptQVdlU1hWeW5hSDFnS0hkSWlR?=
 =?utf-8?B?T3kyRHVSSjdHM3RhY0dVZHBmTHFySjNyTmIyWFhDdlFCaVl2S1MrUG4zNlE1?=
 =?utf-8?B?L1VmTFVzc0tBYWxBWncwR2Y2YmUwb2g2dGpsRGw4OVluU2R0SmpSNVlDOWFn?=
 =?utf-8?B?bGxud0RBNFd0c2d3S2RDUHFzMTlKY28zMVh4Wjd3cmhQb1JYU3JLMnl5bkpY?=
 =?utf-8?B?elQ1dWk3Y2JPeHVYTGlWdHFFUnpGSnR4MXAyREt0V2dNZ2hiMTBlaFpSc2xT?=
 =?utf-8?B?L2dBWHQvNkN1bmFpTkN3ak4wOVVoUEZIbnM0SmRmRXB5aDFUWHBlb2NEUnFT?=
 =?utf-8?B?UWY5RFYveCtudEd2bGlaVzM1bmY3Mjh2dENMSm9MdkQ0U0lIN3VlMFpVVkNs?=
 =?utf-8?B?cHh1TjNxL0FCSW5KdFNvU2VnOGhkems5TnhIK0g1VXMvQ0tOdVJmMWN5YnVB?=
 =?utf-8?B?T0U4U0NZRnFKd2FySkF6UlZNakZESlZFV2VueS9RSmRCNEc2cXI2L3pxeFR4?=
 =?utf-8?B?U0JvNExQM3lGT0N5d294U051WEZKU0xDY2U2bzVicUFrbHBPeHR6a2tQZG42?=
 =?utf-8?B?SmNYUzMrL0tYc1YwSlU1dy9pdlhMellObVhWSjlsLzQrOTgzOWxGSEpReVJm?=
 =?utf-8?B?QUdFUDF4d05IaUhoMnVlRVovb2lUZDR5cnI0SCtiNEFpUzdWUTFWNGJQYXlC?=
 =?utf-8?B?ZmVIaXZlNThwYVlmMW9RS3RBRDJiSlA0UnVyUVlNWGFtTWtsaWVBcjM5WnhV?=
 =?utf-8?B?cUNaVE5xNUllZ0lnMlE2QVA3SWdTZEs5Nm5DQkhCODRXZ0lNRVJhVnNwSVlY?=
 =?utf-8?B?em1OL2pCblhMKy9YaEZPZ0VNcW5IcEI5amN4blFndEx4S2VVV3M2WVZCdkl3?=
 =?utf-8?B?M3cyclFoUk01YW42WHRLRm9qZm54VHBkMjZ6ZzJFVTFLc3JuNWlRS0IwSm10?=
 =?utf-8?B?UDRHNWNrcmo0eHdXVW1FMWttbjAvSCtQVXF3b0ZMUWNva3NWb2xQNnh4WHlZ?=
 =?utf-8?B?Si9nOUh5dStROGZ6OG40SkVDRm5IZEJ4dEFhSlRpUXI3TE1mMU9NUEdHV0xX?=
 =?utf-8?B?bURYM2RmeDcvQWVGK3Uyd0NQNXhkelBVUitNRTNBeXJ4MFBUd1pValhZTmF4?=
 =?utf-8?B?eldxU3dSWFpBVWdTUHBaUk5HeGlmM094UEVNY0Z3SmpzdjM0bFBHK1JPM1JK?=
 =?utf-8?B?Y1pDajh0UVYycDRBYUhheXpIWnhtb1VRdVgxV2t0anNvZkVpZVNlanB0QzNP?=
 =?utf-8?B?N3VwZkkreXdLMDRoK3p5UkJkUXJpcllJNlZ5VE9wRzVHQ0FBT1g1OGxrWGhY?=
 =?utf-8?B?dEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e4311a99-3f6a-4ccc-f79e-08db6cd4c555
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 12:42:10.4897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G3TzpRq1DeIYHyXs36Onljfv659e/nzxz/OQ+voYhSdR5/tD5ANKL2LnF6cRK2/v90NpnrQM09PlrxJBym0uLJBKA4RCemAhCMSZVj84zTw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7884
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Yunsheng Lin <linyunsheng@huawei.com>
Date: Wed, 14 Jun 2023 20:15:48 +0800

> On 2023/6/14 18:52, Alexander Lobakin wrote:
>> From: Yunsheng Lin <linyunsheng@huawei.com>
>> Date: Wed, 14 Jun 2023 11:36:28 +0800

[...]

>> By "I addressed" I meant that I dropped including page_pool.h from
>> skbuff.h, as I also had to include dma-mapping.h to page_pool.h and this
>> implied that half of the kernel started including dma-mapping.h as well
>> for no profit.
> 
> I see, thank for the explanation.
> I perfer that you can continue with that effort if that is ok.

Sure. Especially since I based my series on top of yours :)

Thanks,
Olek

