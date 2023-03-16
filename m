Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59A76BCED7
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 12:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjCPL7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 07:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbjCPL7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 07:59:39 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20291CAC5;
        Thu, 16 Mar 2023 04:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678967976; x=1710503976;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aQJgc40bxhA0m6Gtt/TdHlxrdPmhvIPNPMXc1ig44Qc=;
  b=OQqwTeGEzEc62swA+7/5/jlnKi+yL6JouzGsyAuR1j/pY0DtDYanxhAn
   Itg3a67/tStfY7Cy7a0Is63z3bIyYNFKleTnZ0lCask+p0ZHmlsNq4fw5
   lRdSoO8LJxTBHqgcYwXV3WjsYFv/hDALtjJbp5MoCMMFUROefNYqmg1bh
   /CggDO29wJpRxhXhthL0sdw0/HrS2/MkF767CDU9wgQw7oW1WNL+p5PPr
   V3giG74SNKGMiVM1nb2Ls76KS4NcmNdHq8BnY7x6dHMQ9o7cwEHHbLEIp
   2LEbuC6s+pIR9pCUaqeMESaGwfU5IkdWVj+gHNyhECvcoqVSD35fQAvwC
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="337984020"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="337984020"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 04:59:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="925749555"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="925749555"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 16 Mar 2023 04:59:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 04:59:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 04:59:34 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 04:59:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BoD2tSCjeyEDqDYL19cxYRZwf/QTcnpyYJEYv7c2cf6H8bJy691rR708HCRIaHgkBssuJRDP+s2raem/hRjSEsBOwkbpgB1U4XDL+V5v88QpccGWTiVH5NOfIe0ThzufoYclubrG8Hl+YO6hLazr7mjPOtcXKnOstFAspSpbotaSmxMNPChMnlSlncZ2EissRvPpplEhvvR5L+q6WMYx5aFboz7Ml17Ev3SHmfq2q0ixmStGN+Q4rg2q078MdU7SBLytaGr5BQjW1IbqUHC4qb6b95DYbDeViyQET000b5vsHXBAHQchjRM1WksHJXA0nLOQqwBDbTLgJ+IBO4QxEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjCBAste7XJn9XeC7QpG+sZpvxukLw8XvjAF+b/7qWs=;
 b=DZ7uq4pqmdBh02sP5gnDbtwTpE30ZaBjLvqHId3k3vm5NqaTbFSKWY8PqLDF0/H9qX3EkAvkQs9U6x9mFwfj1vR/uqHaqAAvM2n6lisXJBIatgl1tNpcVpbozDJm5tlyOI4H3OGszagKy/0ExzTV4ctE4/QNnhHPdvFRBYck/2h8X3qKia9TrpO0wENf5sygxZ3dScwpIya2NqvDiaECF6t299n472+ZXrqZ6HYp6B4+AOn3c/c0MunoNgsDG0hyIhNZ6C62+GJWoI1Ck2XeuwOybHxmkpHAOeLumlbrFT8tKnywtTAPnjLX754NsOrzdm0NlJevlateBFCpOSbS5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA3PR11MB7533.namprd11.prod.outlook.com (2603:10b6:806:306::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 11:59:05 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.029; Thu, 16 Mar 2023
 11:59:05 +0000
Message-ID: <55a752e9-faf4-2b37-5492-c58dee3c170c@intel.com>
Date:   Thu, 16 Mar 2023 12:57:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v3 0/4] xdp: recycle Page Pool backed skbs built
 from XDP frames
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
CC:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mykola Lysenko <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230313214300.1043280-1-aleksander.lobakin@intel.com>
Content-Language: en-US
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230313214300.1043280-1-aleksander.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0107.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::17) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA3PR11MB7533:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a57f906-9000-4139-0434-08db2615d703
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d4Q8aVl2nB+BQDNtpbF168QCDnrPzjp/0oMVqFmTjhHLaf9xpk9O0pJ1qn/LPH8APQosqW7o7XUoPGV6EvjiWCQSuRvi+6R3bqAxe8rlgLGpNrTkOKllibpMV1NLVhkxEPExFyiZ7+L6qwTbvytR38IIXiDNKyd/FCXBwUiy1MK1wlgdgQ1ls61tNvbw7YHqZpyyt/1acvtU6lg8bPF4N+qvVMWys5CEgkdepnjdXzhSdKnfVseZOY55V4Ntl6lEoEMOLEMQmBzNYggLQqXgjMnFEcE8vLUMRvb8HxtGp0Zpd79FzdBqSXBRo89Q1aQuJSKFyACA4xA3Mcwxa/0EL9pwTpVBmI1/o22ab479GYcxujVPrpfl7hoHPvJdGhmP7vpaA8znPPKNIHc3qcIgUo9yXJVNiT612S+RETIGgz9AfNwFEFgZaw4cj/na00vBGQLshCpBCMywcEYRTGHd8FI26ie13gquQPfEY1E/ijFeo8RRXG1RlaTAEDeIbtcIqdz6qNTL+SomWxInx1rjd+YcJHjfJrOU71ynHgGiXfV7s/I/9bJlf3hg6f45O3zfPD/AxCoCufrNMOiChN63YufZo6QFuEaHp2e/ZubPZ2UaQv0H4rhHD4944NBotVWoYvQpBrjX8hoG+3JP33Is9AJPE3zCHJ9/puUcp7t2rmncZEpPhZjBWtgxAKaF4WCxWPpI7ZPZXErm8C7y8EHpyY0ZAwgOORbehTDbkWlvAiVT3iTyTwiqwd84Fw1in6kw2AUruC9mFytbZLa6YczXXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(376002)(39860400002)(366004)(136003)(451199018)(38100700002)(86362001)(31696002)(82960400001)(36756003)(2906002)(41300700001)(5660300002)(8936002)(7416002)(4326008)(6506007)(6512007)(26005)(186003)(2616005)(6666004)(110136005)(83380400001)(54906003)(316002)(66476007)(66556008)(6486002)(966005)(478600001)(66946007)(8676002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUdvdXBRRkVVM1RUSHEwOThaaWszK3FnVkMwcUliM04zNlB6MnRKTXdHeXBG?=
 =?utf-8?B?c29nUnY4bkdGaXdFQjdIcUF5Wk9tT3UxWC93b2xoSnpVQTRIVCtJLytDRHho?=
 =?utf-8?B?L3VWNHFaTnZLNTdJMk50b3g2MVFweVg0Z1lCeFZ1WkRBMnRBYWxEZ2pzbmJv?=
 =?utf-8?B?S215ZDV1YnBCdkZ2T3htNE5KNEZwMDhKT2tEYVRDbFdwekFGdVBwU2NSMWY1?=
 =?utf-8?B?ZGNzNjV5QnM1YnJaSVhBMHRkSnA2SjAxdGZSNDZBQjJWZWF1UUorWkRkQ1lR?=
 =?utf-8?B?akNPUHIzNmlPNGI3REY3NllXdllhZE1Oc08zKzdPTHFXdkhpY0tMUHdGYS9I?=
 =?utf-8?B?SSthNUo2SkQ5ZFU5ZnlVaGtmUm8vOVo1bjRiektqTWJla2Rpb21oamRWYVNp?=
 =?utf-8?B?cDFLMVNyd05pNjFGZGw2cEQwRXloNHlodGkweXpwRjByTGJYOW1UTW90R1FT?=
 =?utf-8?B?eEFaVDAvNE9nVzh6cTZEMUl0Qk9GMXFNQ2JBL21WK081QXNDdzFWcXdGK2d0?=
 =?utf-8?B?SVhYSi9xSERBRTlWVEJGYitvbDI4eGlaaGZGTklxaWxjY1hFamdtVmtKdTVr?=
 =?utf-8?B?bXFwOXV3aEpWZURmR1pjUFdTRER2V2pMK3h6cUljOWVROGtTeWRRVnNBV3hs?=
 =?utf-8?B?ckFFQkR4bmJrMWpIN1Zmanc3bXNTVmRaWmU3anM0RURGbXROeURsak5nSjgw?=
 =?utf-8?B?YXBZMkJwN3RyUGZicEVHSTE2K1BBKzJZQXVHeUZpTTA2eVI0dFVoNXV5S2xM?=
 =?utf-8?B?OUZCdDhadDg0TFhrS05TN1RvZCtyMDJWbVE1MG9Rdml2SnpvNkQ2T3NRcmhO?=
 =?utf-8?B?THJ1N2FvWGF1azFMUmlXeHZrLzlFUlVZTC8wY3I5QWVxVm9XMDFtamcyK3hP?=
 =?utf-8?B?TVRWWGx3NmFwZ2Y2NmI0WklBVGFqampGTm1UaGJjQ3VRK2Z0VXJtQkJCaFVQ?=
 =?utf-8?B?Sis3RHp6dVR1VndXeE1ZR3EwRWh6OXJoNU1sUndZakVKWHhkc20xT1Z2S093?=
 =?utf-8?B?ZmNlVGNZVnh1NGFqaXFoZDVOY2VSbDZnWXU3TDhzSis4cGN3QTZJV2V6Wk5B?=
 =?utf-8?B?Wk9zQWtId04yL0RuZUFUWXUzMzVLNTMwWWx2bERLbTZyait2aWJQcit4SWho?=
 =?utf-8?B?LzZVTkRNbi9MbzZjQmpUbnNZcTd2c0syTysyZUNvNlVpVHlxaWwyb2t3d3hx?=
 =?utf-8?B?QndzOFk2UEhLNWFSNk5qK2pQWVlOUm1HajR1dEZHbEduN1k0VGRsNCtQK0VY?=
 =?utf-8?B?Q0NURFRRaUNDQzZDWXBsd3AyRk9pNjBSZXd1d2prWUNBOFIvYmhWc05IQWIy?=
 =?utf-8?B?YWhCbE1WdTg1NzZabVBDcTg5TUdUL29XY0loVEMyZHczdEpuVEtBaWtVSDAx?=
 =?utf-8?B?VW1TQzl0T1crNll1Wm05bjJ5NDQzdC8vMmtKUlU4VGFsVUtNbU5kTzdPR1Q1?=
 =?utf-8?B?czlJcXhUeWMzRmQvUW1xUjNNcWwrVTRCMHVxaTFmekZjeEJsUlljaXRFclIw?=
 =?utf-8?B?V1I2RXkyYWl0b1p5ZnRleTZ0NXhsb2g4VzE3K0xuZmFwRFdxV3h4c2dVVlZa?=
 =?utf-8?B?a1lQOTZNdFZSRWVXWkpTT2tQK1JZLzI4aGM5blprMW1EZnlIejc3MnBXVU1G?=
 =?utf-8?B?TTEzYWVFYTd2OTBuOE9GNllwM0lCZ212eXpaRXJQSG9BYVl0R1diTUNKQTU5?=
 =?utf-8?B?TXpiK2FYd0xTV1J5TU9WNldIL2p2bEc5c0RsYUl2QTRFam12UEFoOE5OTUhS?=
 =?utf-8?B?elJQczR2YTh6dXhHbHhzMVk2aDNQMVBYS080V1E2UGxpQ3hzeERDYjZYdUZJ?=
 =?utf-8?B?c2RtVzl3QjZIbTM3ZWZvZmI2L3cxTHAxOEhmay9za3B6SFVxdGxBK0VONEM3?=
 =?utf-8?B?ZTVNQ3UwTWxtTlI1SFkwaU5kRTJ2Zys0OUhISjFPaUMwOGZBLzFlSnkyNlZG?=
 =?utf-8?B?aDlSa2VRZ2NOeFhnRjZOejIrZndoeXh3WVpGMjArRDIvczEycHRoYno3N091?=
 =?utf-8?B?RlM0RFdHWDdWczZYaFB1RUtzRHd3NTRIWDdTYi9kbTVFcWlOejdXMkMrL2ZJ?=
 =?utf-8?B?blMyeU51blA3UkNNSGU0eVJ6MGtZYkc2YVpkazdIRFppbjJVU2thblY2S1Vy?=
 =?utf-8?B?TTgxRGlzOTAva3crdXg3b3FLSXhYTk1XeG5INnl3RTdnUDNmelpDSk9KUWIw?=
 =?utf-8?Q?Jo6+b+QDafbl5s2flStFDA8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a57f906-9000-4139-0434-08db2615d703
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 11:59:04.9493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KZyDsCl1NaOy+FTmZDnpX+xf2UIfubQD8fpvIvophvaVaZe9mh8V89/UP5flzciE/Cv4g+SA2A98dixIW6I9Ionm9Scic3PF3KxKFX+mPlc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7533
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <aleksander.lobakin@intel.com>
Date: Mon, 13 Mar 2023 22:42:56 +0100

> Yeah, I still remember that "Who needs cpumap nowadays" (c), but anyway.
> 
> __xdp_build_skb_from_frame() missed the moment when the networking stack
> became able to recycle skb pages backed by a page_pool. This was making
> e.g. cpumap redirect even less effective than simple %XDP_PASS. veth was
> also affected in some scenarios.
> A lot of drivers use skb_mark_for_recycle() already, it's been almost
> two years and seems like there are no issues in using it in the generic
> code too. {__,}xdp_release_frame() can be then removed as it losts its
> last user.
> Page Pool becomes then zero-alloc (or almost) in the abovementioned
> cases, too. Other memory type models (who needs them at this point)
> have no changes.

Sorry, our SMTP proxy went crazy and resent several times all my
messages sent via git-send-email during the last couple days. Please
ignore this.

> 
> Some numbers on 1 Xeon Platinum core bombed with 27 Mpps of 64-byte
> IPv6 UDP, iavf w/XDP[0] (CONFIG_PAGE_POOL_STATS is enabled):
> 
> Plain %XDP_PASS on baseline, Page Pool driver:
> 
> src cpu Rx     drops  dst cpu Rx
>   2.1 Mpps       N/A    2.1 Mpps
> 
> cpumap redirect (cross-core, w/o leaving its NUMA node) on baseline:
> 
>   6.8 Mpps  5.0 Mpps    1.8 Mpps
> 
> cpumap redirect with skb PP recycling:
> 
>   7.9 Mpps  5.7 Mpps    2.2 Mpps
>                        +22% (from cpumap redir on baseline)
> 
> [0] https://github.com/alobakin/linux/commits/iavf-xdp
> 
> Alexander Lobakin (4):
>   selftests/bpf: robustify test_xdp_do_redirect with more payload magics
>   net: page_pool, skbuff: make skb_mark_for_recycle() always available
>   xdp: recycle Page Pool backed skbs built from XDP frames
>   xdp: remove unused {__,}xdp_release_frame()
> 
>  include/linux/skbuff.h                        |  4 +--
>  include/net/xdp.h                             | 29 ---------------
>  net/core/xdp.c                                | 19 ++--------
>  .../bpf/progs/test_xdp_do_redirect.c          | 36 +++++++++++++------
>  4 files changed, 30 insertions(+), 58 deletions(-)
> 
> ---
> From v2[1]:
> * fix the test_xdp_do_redirect selftest failing after the series: it was
>   relying on that %XDP_PASS frames can't be recycled on veth
>   (BPF CI, Alexei);
> * explain "w/o leaving its node" in the cover letter (Jesper).
> 
> From v1[2]:
> * make skb_mark_for_recycle() always available, otherwise there are build
>   failures on non-PP systems (kbuild bot);
> * 'Page Pool' -> 'page_pool' when it's about a page_pool instance, not
>   API (Jesper);
> * expanded test system info a bit in the cover letter (Jesper).
> 
> [1] https://lore.kernel.org/bpf/20230303133232.2546004-1-aleksander.lobakin@intel.com
> [2] https://lore.kernel.org/bpf/20230301160315.1022488-1-aleksander.lobakin@intel.com

Thanks,
Olek
