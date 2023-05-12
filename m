Return-Path: <netdev+bounces-2164-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6E1E700962
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:44:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AA6A281681
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B78A1E527;
	Fri, 12 May 2023 13:44:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C10DBE4E;
	Fri, 12 May 2023 13:44:16 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B63132B4;
	Fri, 12 May 2023 06:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683899054; x=1715435054;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8W8eOhFhk4GqsAiwN5OQtWmPnxTrR2sFNi9k/DUY1Qo=;
  b=XbAwLnt4059FgzjXTlsTOJ4dSLOTtsoeH/DvkmgUU76BFmhtOLo4t8yj
   82pbpx/oH0o3ijXe+9aLqM3rXEWVnbzVJg+oBSmMq24e8YJctIULniGBr
   GO8P0U7UX0ljZEkKzO90OGcBy2KeQJnO9haP8KQOsWr9BeGr5ReHIDhjr
   d3vUewaTbPHE/1Wy4URV2qZmIUviA5U3uhbPjpF6S2/t/52nOdUhA9/qQ
   HnC85jXfVjJTX2mGtirFUUbSpOtriRemj86ljDuAcWA/OPHfLcZ9dD2o1
   JiG2udlGe7JRMVQm88tPutbM37fbpsRyJUNayVyZE3HinLODIMGWm8Rjf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="378926573"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="378926573"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 06:44:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="844421092"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="844421092"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 12 May 2023 06:44:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 06:44:14 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 12 May 2023 06:44:14 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 12 May 2023 06:44:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bB8bK+fgenEvm0//G09nmfijwvrQ0J+H2OLt/sjmfeMAXI1HUmpEYZJ3bg4Ow8y8AP2C7kXdc9LblsNdq2ZhA6zEZ7yGLE8tvejdbm/TDQDQXMCR85GpMMGWOD7CCxOKLFijmFoqPakYnaPPJQOKIkUxbvPcIWm4DlAqxM5yquTwtviG4SV3ZY9zzNJKe3TDCMQYk8R6ZAT8ZeW8jhcvEO2JghtXKSF80YNd6PdBRDvIBttOa4ltSJlTxFYbgjmX9zVFOAdqJStlXawVS3BVWAyrlA8Pd39euEhFWvWEGkUp279afd/DahPepf7wkK1pPFAmqocsNVj9g6C08ocPKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QkYFcEAgXCKMqiEGtPrW3TRH7AmFfPMQndiNF/Udli8=;
 b=D47X0cf8V+1i7KBy6VpSQm0R3pzgmEhdbzTonXS+tigvONSZ7C1wVq81Adc3CYX537MYK8G7TocA3zPcvlExynTz2in3YW+tPQYjDmu+kLRgoJwspur6d56EJS1LjCT1vDBz5mDhXRXrg2C9wOARGIj1FX76cBHfqwq78HcAyh5GxTXEtRfrDGwb7l+T1OAmnEgqbCsvQ8iVCVOOBinzxXP/5DijgSQPm0oy4U8xQ6NBpShrqsITojw+JxNnJNX03BKxqXrnSKf13J8giOa5tRQhBrxfIchT5CXbI2lyYnFFCr5jgmZHKKNEzJFBAyVskf5eq9L84XNAbM4WmhMvRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ0PR11MB4895.namprd11.prod.outlook.com (2603:10b6:a03:2de::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Fri, 12 May
 2023 13:44:10 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590%2]) with mapi id 15.20.6387.020; Fri, 12 May 2023
 13:44:10 +0000
Message-ID: <c65eb429-035e-04a7-51d1-c588ac5053be@intel.com>
Date: Fri, 12 May 2023 15:43:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC net-next] net: veth: reduce page_pool memory footprint using
 half page per-buffer
Content-Language: en-US
To: Lorenzo Bianconi <lorenzo@kernel.org>
CC: <netdev@vger.kernel.org>, <lorenzo.bianconi@redhat.com>,
	<bpf@vger.kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <ast@kernel.org>,
	<daniel@iogearbox.net>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
	<linyunsheng@huawei.com>
References: <d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0019.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::6) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ0PR11MB4895:EE_
X-MS-Office365-Filtering-Correlation-Id: c3002466-e902-4c24-69df-08db52eef6e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jQ45pLyZ/A4u0UiC3VJKsT6D3+mMTb4uwLfc1Bw9gYGtT6gQYGQAbl7WvxR5T+H2v4xsDdJHMBjJsZWtl3a68oSHaaiOuuqAMfm7oSUWLootxCoElx14U5U/yaF0N+2tn+YddPQTGX0NWmrU61nrqaOLmXN8Z2clGWBoz9b90e23OTY9g5wldH4rfO9vxCtO/ypayeVivcWuuCIxnofBb4H3NwNZpppj8FmjwmQyYRfnEK98/n6SQcXrd1o5cFRuY3WaiOiN5j2yvluqVyOj8P1Bofz/Jsx0/NhoWOBC3I6thMNNwgk/gYv0KAbJnB1Ya9ITHxD+hGVuEWuWNXsU5AqVLFSsvYpQhPAyXaVqdeNiienbrXez5GQMHGBXDCLZwZDny86SU7F53lEqspZf/1cPkrmf3gpWwvWLZS8k+i6A7kE+klR/8RKbxKMYOSBgaDVut4GnwFmgwMNiMUsueK/38D3GKuy2Wy9rjGTw6OZ2u4taF6HlbvwpxhqIpZtvyS56lIT4KSyzy/W+YqMx0RaYOrWTvaxxkfPh0931cIYV4RMkXDYGyWcRtHI0RxKF2U5nrKSy2T7a+NtIalE4/6iF1d7GpRNJjb3d19Efs7iA7AjoYEAbxyn6hZVKFAuhPgtCg9gHi6eZAPuFeFKbDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(346002)(39860400002)(376002)(451199021)(38100700002)(82960400001)(31696002)(36756003)(86362001)(31686004)(8676002)(7416002)(8936002)(26005)(6506007)(478600001)(5660300002)(6486002)(2616005)(66556008)(83380400001)(2906002)(316002)(6666004)(41300700001)(66946007)(186003)(4326008)(6916009)(66476007)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHNnRkphRGRmbDBwd0VrLzk0QWFhTlozUHNXbEZnemQ2bEw0dlI0SExSMlpl?=
 =?utf-8?B?N2VHSFlDSWl5cFNDTjZ0ZVpJSk5NR3NSelZ2SVZZRjhZQVZNZkVlR0FwMFJP?=
 =?utf-8?B?SFNHTW9DTnVJZHJhTHN0TXFlcjZnTERzT0QwY0lNSjdqQTdLV2VtQm9JTWlk?=
 =?utf-8?B?K2hucnJVekkzcHRTQ3ZieTZ5Wm10ZW05SUMwYmw4RHk4ZXMrR2pBTVFHSHp2?=
 =?utf-8?B?b1JwZUNpNmRrRGUvbTNFU2RMKzgybEx3R0g4TkdTb1RROS84aW1MRDF2cHlZ?=
 =?utf-8?B?ZVVjZ3dlM2dvb3RVcGFCT1JIdVFVYk5LTmtXcDJZeW1WbTM3SUhJZ3JxdHRP?=
 =?utf-8?B?RGhqL2lwVjVHNG13ZFd1Qmd4Yzg4eldIWDE2OWV4eGZLcGRFUGNveEE2a2ds?=
 =?utf-8?B?Q3gycUhrdXpCb3RUTnBPc3A4dE83MStLMENza2hxY2RhUGN0MERzaEJPbG1Q?=
 =?utf-8?B?b1FKUVA5VmVicHN1S21TdTB4VzcyMDN5b0tmNnA2eDd5bTFXMUZBcFRqZDkr?=
 =?utf-8?B?WU1KdVJoc1dzaGNoR2dDNnZKZURXYmZMUDNNZk80NVV4ZXpHVlMyb2xPZmxB?=
 =?utf-8?B?VHlJZytqV1ZpR3JDcU9qUnlJNHphVWx0cXMraFNuQVFDTSs3UURTWStrZFh3?=
 =?utf-8?B?NzNOWVZIK3pOdGRsZ2pMOVM3WkxXOUduc0d1TGY4ejJkdHQ3SHhUWlgvNmg3?=
 =?utf-8?B?UlYvcE5ocjFvODBYcVR6Qjg0N0c1Vm1pclZXbmYwdGczZUkvZVRYK1laa0hB?=
 =?utf-8?B?dis5Qlc3WnV5d2hjY2pGcE1ETU8rWmRuTGtvSGhvakhJWWw0dnZTcDNYTjR2?=
 =?utf-8?B?SjJCdVNtaGdoTFdEM3Q5UDZXODF6ZHRVKzhCM3piNi9wMnpDcWpaL1dCU3Rs?=
 =?utf-8?B?U2tYNmk1WnVjYU00ZDFneWJpQ1NEN05UZUFUY1ZxYmVwcnlpMXR4TUtjVkRB?=
 =?utf-8?B?OXltS0tFRG9SRjI1KzhFMVZSRHZqZW1oT1R3ZVFtWkFDNlR3UlVZVWZqbXpP?=
 =?utf-8?B?aWRZRm9laDgyUUgyT1FKWEtqVyt4VTc5ZXE3SGthRkNFd3VHVS8ycUR6c3E1?=
 =?utf-8?B?SFF2RC8rWXdreUcrTytvbFVzU2VDakQxanpUY1lJMzZpaktiNUg5bXBnYWJ4?=
 =?utf-8?B?TUw3SFdkRlFOSnlKMURPbHdMTHZBdkNoVktLK1c3WnN4WlozK2g2cHhwTzZv?=
 =?utf-8?B?L3JEclMyZ0ZRdXdzd0RDci93RFBSZmdUWUFXT3VralBHQUY1Q2FkVXRadWY2?=
 =?utf-8?B?YUFEajJGYWw0eDc5NWwxbEE4cWFjVENkYi85L04yWDd3T1QwQ1dPbnNXL2Q2?=
 =?utf-8?B?b3pPbXNyamtwOXZnYlJVblVSTVd2OVhlYWVsdGoycFNzMzNSK2RMZVl2ZlRH?=
 =?utf-8?B?VkNYWExEQXBQYTlQenhZbHVaNGNscWlvN3RodFY2b1hVK3k0bTlXK0wza1hi?=
 =?utf-8?B?cmp4MTVaN0ZXdk1JWUJ4b1B5OFVtRVNDZThBOXNjQjZBNVVuS1FqN3g3NHc0?=
 =?utf-8?B?a0FpTk1qdSt1REZIYUt4cmErSEo2SjRpVm0veGI3UXN2MDVwU09lYmlTRjRC?=
 =?utf-8?B?cFhBSjVvYWNaeWxYTFhUcVluV3JKV04yTWJxOWszRnRjYUFLdDJjNEsxQk5I?=
 =?utf-8?B?bXlCQXJ6bE9HdkFzd1hlYjRnZEMvSWsvUmhDbGp3QW5LejFXTm1CaTFXOVFT?=
 =?utf-8?B?RGhCWmg2d2lqcjRjR1hKZkJUNXhMS3RJTExleFNOUHJWMXhyUnhObUwwdVVB?=
 =?utf-8?B?Z3VaZ2VGRDhjMzRLbVI1b2VYb1B4NXhIOXFUaHh1dGxzQkhUaG8za0szNnRY?=
 =?utf-8?B?LzM4QTBtcVFQRUo1VzVFWnZiOWd2TVZZeGlJMUIvaDlrMHZoSUMzYU43ck5i?=
 =?utf-8?B?ZHc0R0JpNDE1ZnR5NDMwRUlzaG5IdU5sSURRYjhkRVVydjZQZldWN3ZLMXBJ?=
 =?utf-8?B?M0wrczFkMkZPTGU4ZzFtdmVQejBjakIvZzNSS1dIaFkvaFQ5alRNWG5qTjFJ?=
 =?utf-8?B?VFdFM3ZwcTRaLzBLL2xpamJhcUpmb1ZQNnhtZjB6TERIMUFUeWNkOGZLMU9U?=
 =?utf-8?B?cEhOdEY0NWw0TTROcmZ4Vm01NXZqQVlCSlJacW15YmIwelFBUm1qbXlrSkFN?=
 =?utf-8?B?TWFyS1FCSTJ0bUpEVEpkVkQwQnh6aHRqenV6UHdUOVdzUWpCTUJjTTE4d1BP?=
 =?utf-8?B?RXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c3002466-e902-4c24-69df-08db52eef6e6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 13:44:10.4590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 20yFqQSodzItOlxFyvX8B1HDTCTmjcKr8tTZoYVDWQDBaltbEAYrqCW0NXcNNUbcWuXX2R0kWaA0Ib0NB1tgtvaAOW7Rt8LNvBjDJoQj/YA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4895
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Fri, 12 May 2023 15:08:13 +0200

> In order to reduce page_pool memory footprint, rely on
> page_pool_dev_alloc_frag routine and reduce buffer size
> (VETH_PAGE_POOL_FRAG_SIZE) to PAGE_SIZE / 2 in order to consume one page
> for two 1500B frames. Reduce VETH_XDP_PACKET_HEADROOM to 192 from 256
> (XDP_PACKET_HEADROOM) to fit max_head_size in VETH_PAGE_POOL_FRAG_SIZE.
> Please note, using default values (CONFIG_MAX_SKB_FRAGS=17), maximum
> supported MTU is now reduced to 36350B.

I thought we're stepping away from page splitting bit by bit O_o
Primarily for the reasons you mentioned / worked around here: it creates
several significant limitations and at least on 64-bit systems it
doesn't scale anymore. 192 bytes of headroom is less than what XDP
expects (isn't it? Isn't 256 standard-standard, so that skb XDP path
reallocates heads only to have 256+ there?), 384 bytes of shinfo can
change anytime and even now page split simply blocks you from increasing
MAX_SKB_FRAGS even by one. Not speaking of MTU limitations etc.
BTW Intel drivers suffer from the very same things due solely to page
split (and I'm almost done with converting at least some of them to Page
Pool and 1 page per buffer model), I don't recommend deliberately
falling into that pit =\ :D

> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/veth.c | 39 +++++++++++++++++++++++++--------------
>  1 file changed, 25 insertions(+), 14 deletions(-)
[...]

Thanks,
Olek

