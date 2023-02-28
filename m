Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27D76A5C61
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 16:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjB1Pva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 10:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjB1Pv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 10:51:29 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7F430EAF
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 07:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677599488; x=1709135488;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GXgj6KmXfApsxAJVGqFFPvtDruU6HWdoOhpskDhY1lc=;
  b=C53RQylhbuJF/4+R5L7fsLWJ1aYENGPY8q5XKtbHrCI1pDP49vRqYY1b
   ditFgNyaa/f1slNJQZEMxD1EFWlCp9UplS768tup1wg7TNbaZxwH8Ji3m
   LwQgvKDZmmS8IfaHdwhF3lQdcRuoJVDBbSbfv8lRdQQ/dd6j39MBI6hv6
   zUpR1r1w2AykcZAV4VnLnCMu3AHsYzYgKuVWJl3bW909FO2PDBk69Naag
   J0dWoheoG67qvktIopeiTrCWvnfsmwcvtYpe48Vs55fc1O9TheO8/99mf
   j89TpeOpc7V0ke6eNy42Ys3UvTIB3TCVT46XIKsSesEP1XtObnYlnEsOh
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="334208168"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="334208168"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 07:48:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="667508038"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="667508038"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 28 Feb 2023 07:48:33 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 07:48:33 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Feb 2023 07:48:32 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 28 Feb 2023 07:48:32 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 07:48:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJ8eERkDxeYStoFodP1dDROj5rQXZyIWtLyO3FbZrvqjPcLY8zJG16R4vBRMys8J/VWzSfiX191yHeHO3BQU+TNEHBLL5SIiNIDnWOeyfVr3HxoXseP6UR5RKBD+Im7Fvld3m5P6GJlfmAC90vuNEx1NQPwqpC+eI2290/RNx7lhnpA82QRHEkzNghMKCdzg5nFLNdfAggFlun4r2pi6j0wRT+o3IdWa5HXHVtJrgi6acC8MAdvCMT+UdSsGhFR6CaksCmriygh7COQrpdWIQGg2KySVc0vdsfVoQ3m0oC/E7suzQhe1BwqDErQprxrfmKzSyvWnqvOolhukVcCklg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ffNsOucg3AycoVc+gloDQFGvbXDXFAhQ3+jdLu6MqrI=;
 b=M3GdGg5WZZI76YqTmfLHD/P2+006KcoWMJ2T7TyFCjLunWcfVy/u9g4dpjVyo7UnURDJroznh2mHWr2UrfPGEzusH/8h9mdJnoAombjHkeyT+7ES3Y3sS8qWz1NGPDjpGPz9PwBXuVzq/KuGMn72UqyuHZa6DduKZEYU224ijT+Ut/CkWiGCRGvjvkfxdY3+JczZ0LGxSNFvA2HZGsc8UF8nEv9YOcjOJuhBFBtRrFftxfa3LokGSdO784XCsOx1k1PEjYCBOLH6BFCOf906mQMeumW2VJAFGnFCsaam3qN+7LRynXP6quxaRjuw6+uho60VJbsxvwJOzkARiIjBDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ0PR11MB4848.namprd11.prod.outlook.com (2603:10b6:a03:2af::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 15:48:30 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 15:48:30 +0000
Message-ID: <03f987ab-2cc1-21f6-a4cb-2df1273a8560@intel.com>
Date:   Tue, 28 Feb 2023 16:47:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net v6 1/2] net/ps3_gelic_net: Fix RX sk_buff length
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Geoff Levand <geoff@infradead.org>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <cover.1677377639.git.geoff@infradead.org>
 <1bf36b8e08deb3d16fafde3e88ae7cd761e4e7b3.1677377639.git.geoff@infradead.org>
 <20230227182040.75740bb6@kernel.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230227182040.75740bb6@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2PR04CA0274.eurprd04.prod.outlook.com
 (2603:10a6:10:28c::9) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ0PR11MB4848:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ffb33b9-c00c-4490-3eca-08db19a33d54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4c3BX6RD4ZsxlLYQjWf+LtetIVreaP6m2Mlp8hrpis/b5gorQ2TqZKSYE0KheyfmQOEKBVsadsDFOdESkRu1pegfnsYaBUpW6gfcCiiqxt6uiVGFqZS4SpHLlUb6DMDcw32I9+A3VEqx74Er5U4nl1t6Uzqy43JuxZ6AONkTYqZGvbRUoyEqYE702Vj1mRWav1gcIc0hGeUW5PisMihXJVbDo8eqQBsOtMbcREMGYHc4yeBFB6Yn6o0NCF1Ilk20e1uzN3MC5QmXvHAO7NFg6d/h6vuFg7RU2AdEoxVq2sKZf6VlsgjyhNATxByeMBXT7pEDeTVYZ4DIt2s+lydT42mFR0Te2TXfQESP3QgP0VhNuYPo0snSPyFaaKO/uQvlgAtx+AkwiGaj9pOM6IPOMgIfQBf5gVZfCPI1LSRY4WfUy1paZxXht/cmUCsdG+HtuEFGGLNAna6jy4Jx6B4zfvGQ826uXmRXxpo6jE9Nl7zX0TjFd17JpN+VlSzLxNLBG8dlMrMQvZCnCfNUC/1TQ8XQdenwZEDqhRNZMssun4E8aaNPDYqLct9Lrfe1lRHLwoQklvPBAsgEt9znk/n4EynRatUwHddM9Wqc8ISFbfso7G8E72a7IzY7Zb6nSju+Qhnbkdgwcr1gdlikQ35emzJLAK6FYsm6vYfK+kr8dZJrHcB4yjAp8WF7omObNyfNnC/+JdWbSJdMm8MbJmk8dI8YFmdUNldqUG/W9KkKfhE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(346002)(39860400002)(366004)(376002)(451199018)(31686004)(36756003)(31696002)(86362001)(66556008)(4326008)(41300700001)(6916009)(8936002)(66946007)(8676002)(5660300002)(2906002)(66476007)(38100700002)(82960400001)(6486002)(316002)(478600001)(6666004)(6512007)(54906003)(2616005)(6506007)(186003)(83380400001)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEhRRGZMR0w5cUlsUm1FN2RKb1pHTEhwVzNtQmNYaTArMTR1RkJBSjlOT0wz?=
 =?utf-8?B?VFptN3BLZWVlMUpCeXJKekNqUFpuaWFuMyt4ZmVpeXU5b1IwUEJHTWJnWmw1?=
 =?utf-8?B?Q2ROWUZnUFhTNTlZR3EycFBEQXo0TnFBUFBxMll3Y2hZc2dZbWtWUHU4ME9O?=
 =?utf-8?B?b1RMSW5tYjRTaEorclRGWnV4WmgvSlZOc1diY3o1WWpGWEVsZnV4WnVDZE5K?=
 =?utf-8?B?cURKa1I5c1IydUJxaGdvNHBBZ0xoeUJubHg0c0lOa2JHM004NWhEK3ZxQXdr?=
 =?utf-8?B?VE1EVTltam50WEp0bkpkZDFpeTZqQ1RmdjdIZldBUmljTy9BaHhyVW9peXBk?=
 =?utf-8?B?UFQvNjI1UUJDdjlidWR5K3orZjdaK09kWGdBU3ljR0tVRis1bHZ5amtTZ29n?=
 =?utf-8?B?NmJYY29wbnJPTXYzVFFpVkNDWkRobS9rUmdBV3NDRW03NnRSSkNvWDNuQTI3?=
 =?utf-8?B?WXdXbmFibVJwYjJ4OXBhUURvaWhWYm1tb0ZwT242bWVQK2owd0RUSTJNUDRm?=
 =?utf-8?B?Tndtc01WYTVxdjF1UHdjc2NtWk5ocW10SEhabUIrZUF2elNGVEQzWkkzNHZa?=
 =?utf-8?B?ckoyLzdBeklWQThrbWppM1g5cE9vR0xTZHpjSis1U2tvM0RNSlJ2T2F4c1VY?=
 =?utf-8?B?VWhEdEJYQmljTHZnejVxR3YvVDFrb0ZHM21OZzVmNFBKcjV4ckZVK3BYbXYy?=
 =?utf-8?B?eENvRVBpRjF2Y25Ha0ZXZDBDa0pzVndjRmFPWmd4U2t0RS8vemJOS3hEUkJN?=
 =?utf-8?B?Z0wxWFhkNld1bGhQL3AxbXc1K3Z1YzFZN0hoMS8vOUp0eStGVk44OVg1Qndm?=
 =?utf-8?B?N3BPYTdxa3lRMHVRVkNsbWtsN0VTU0pScnY2SEZWcjRLVXNmRTcvNUYzS0NM?=
 =?utf-8?B?c3hJaFlYVVlIM1EwcUEzUDB3d1F2VkJYZGZXcExYSGtiRkFzeUFybnlOL0tI?=
 =?utf-8?B?N2VTNmcvdHVHZ0lzYnBqL2t2cmdHaG9PVTF1VHdqbEk4MG5pYlpKTVZnNVND?=
 =?utf-8?B?bGt3SVdCb3dwL3A5YkNid3JmeUtSeDc2NWk1dW5YYkgrZTdNL2pJR1FCSG9v?=
 =?utf-8?B?bUlTbFZLOWcvRHRBd0tkZi9wbk9aay9CUXVEMEhiN1kwK1J1eExRL1VmNURn?=
 =?utf-8?B?SFA5c0QrcUs4YTdaS0JmcHF1Rmd4LzI5Uy9mdXRmZFpGTzlrbkRNMU9RemF5?=
 =?utf-8?B?SndqbHlTbzRyWWtkYlhoSGhGUENIbDBsUmhoRXJjZGw3UHFWdURsMS9hSmtz?=
 =?utf-8?B?T0RoTnFWNmFadDRsS1pWVExLTVI3MXNyMjdZUmVCSFdHMEdKWXY0Um1TSVdo?=
 =?utf-8?B?Uy83bE1zT2srMzQ1UndZbG9PL1ZPTk94RkFIUkcraW1uUGdQaCs5QnIyNlZM?=
 =?utf-8?B?SmxHVVh1T0F2aitkTmZ5cERrb1RLMjRxNnliUXlPY09pLzQ4SUhYK09EaXgr?=
 =?utf-8?B?eml6Yk04Zkp5ZVgyUlA3QTVLZWUzWnJVMFpENFNDWlFEa2tNOHlVazkwU0N3?=
 =?utf-8?B?WXNhNnlsd3FSOGxaRnVrdUd1Z01teW1ublBIeDlmc2xJbENkMmJQUVFXZlhX?=
 =?utf-8?B?SVIyM2RVUVNFQVprQWVKVms1TUU5OVVWUVJ2R24zSXRJMW1DZXlvNWUxWTZN?=
 =?utf-8?B?aGVPcXQzRlgyMkp4NnZSZjZsTGdtYTlESzY4OENkd3prSmtUbUdMTVZhbW1y?=
 =?utf-8?B?TTVIaVZkWjZxTVFNNUxWbzduSTl6RlNyK3d4ZzJIRDRIYzNyUnhMcENNQ2Ry?=
 =?utf-8?B?N1pzZlVYZEJodFJ3dVZhdk1VSmRtWGx3aTYxL29QdmtNdE9sR1ZZSXJvYWZY?=
 =?utf-8?B?MHdIWDVrMEduZ0pHdFQ3a1ZVNDNkZEE5RjJIUTlUVFUvRUVMdkFleWo3Rkx6?=
 =?utf-8?B?OXMvZmZPSlp1QVJGTm5CK01mcHkzc1JXajNkUTlES2VEamVDYVAxM2krSVZP?=
 =?utf-8?B?T0RRL2tLMnNrbzdHdTFlU2ljdE84dHpSRksycCs2SFV6M0diczNMWFgvTlRk?=
 =?utf-8?B?QlUrbGw1VXhnZU45a3JZcFdpdktjbnRNclBqeG9WOGVTc3RyRXlpeWo1VjNW?=
 =?utf-8?B?N0wwRnFXVFc5YjBLREJCTzRTN096SEFTcEN5T2JXWEV1OFRBRmRFQ2g1V3gv?=
 =?utf-8?B?Ri9wM0RTQ0hEbjlqd3dMY29IQmtRMVFzRmV3Y3lZZG95L1g5Z0tXWlN0MTRF?=
 =?utf-8?Q?x/EbnL7oPRutcQ/B9sMLSiQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ffb33b9-c00c-4490-3eca-08db19a33d54
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 15:48:30.4695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MMFDfeSZdvJY5owIy5fkEBNM6Nqf4mH/gNLJ9uL35sfULGB39bkScSAA63dzAc0jOppDTiZ84OUdvPUKbiMaKS1OB0i5ioHUZJ4oYWFIS8o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4848
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 27 Feb 2023 18:20:40 -0800

> On Sun, 26 Feb 2023 02:25:42 +0000 Geoff Levand wrote:
>> +	napi_buff = napi_alloc_frag_align(GELIC_NET_MAX_MTU,
>> +		GELIC_NET_RXBUF_ALIGN);
> 
> You're changing how the buffers are allocated.
> 
>> +	if (unlikely(!napi_buff)) {
>> +		descr->skb = NULL;
>> +		descr->buf_addr = 0;
>> +		descr->buf_size = 0;
> 
> Wiping the descriptors on failure.
> 
>> +		return -ENOMEM;
>> +	}
> 
> And generally reshuffling the code.
> 
> Once again - please don't do any of that in a bug fix.
> Describe precisely what the problem is and fix that problem,

IIRC the original problem is that the skb linear parts are not always
aligned to a boundary which this particular HW requires. So initially
there was something like "allocate len + alignment - 1, then
PTR_ALIGN()", but I said that it's a waste of memory and we shouldn't do
that, using napi_alloc_frag_align() instead.
I guess if that would've been described, this could go as a fix? I don't
think wasting memory is a good fix, even if we need to change the
allocation scheme...

> Once the fix is accepted you can send separate patches with 
> other improvements.

Thanks,
Olek
