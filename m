Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D6669E68F
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 18:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbjBUR5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 12:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbjBUR5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 12:57:07 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46D62FCFB;
        Tue, 21 Feb 2023 09:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677002198; x=1708538198;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f33v+xPcFLY6YsrQbzxatjXyZtnPXkkaQD6hNl2JzuQ=;
  b=lXknKHxwltaLNOLwLWP1O/6uk9Dae2xCAyE74kDw5ht6la/aldK+I7po
   s7xgsm+SK8SeNLC9KAZh/acy6V098PhALlaQGtvZfHJwIHjZi6vvYBurr
   sH/0opxnXMbk4u6mDk7Y7qqThwMO6tl+8E1MmCYlsK/20q3PYlaWIJSS9
   fUzJXcxgqEAHGX6r4fLdiUMRtE+enPDop+L71MZRqsmMtpgTuHcNg/V+M
   VqI7ZbCd5obLhtXWJ0iMTmarNhPBveUlrF1K2yPYvhbVwz9DOftEp/t1h
   WDOZ2YVF0TyCsu0H2/PJhKsO5+ZXD4WilgZQVqAJMDokLdbw9coHvsA1c
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="395190808"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="395190808"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 09:56:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="649262202"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="649262202"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 21 Feb 2023 09:56:29 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 09:56:28 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 09:56:28 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 09:56:28 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 09:56:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKkAPd17KO7XZC4WTo0QERNIqBmuCWVndsfh4kgSl9OyMB5D3nvUeFJHnXGohBWmJrX0Nsrnx9+miGV8ZCtLniybZAhdTosSwbeMjfmNaN5Ffu1fWm2lsF5LcmHwULQOM0+wT3VOP9aCj7qrZixYCiGL3jyaIIBzEteVlcXRWL5xrSMNaLG3ACWQHZUddkxseje4LCxvKAvDFkjzekn1hdkk+DUYVln4p4hSi0xBSYzeb7gxCMnbem4IL3768x3mzLuCFUKQ1BZOGQ1As3pLY2eEocZsxdMceY2fgX0iOIYFNmK38DMQEazR6MfKW/ZSKGr5wIBdrUdI+vxJPXxYyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FUndoLL8xcRUVlmJqezP+5AWVSf1cZXmd1JmhO5ne1k=;
 b=itfe1sAm4dg+kDsMYSqcwulR8gfZq8NV/WictDZKJ8h16arhk05X+u4bmTWl2Jtx9yOUorfPxAPDtN77x3f9OZIjlO8SfaF51maoG+KAmRaTQm+w6W+5edZtW7Qa5mb4PmdTuHuh/xBiCTh6KfnLJVnh3iqVU3hmCOLj5u9wDg0Tzc9MAHfVYDN9zXwj338M3E78q3ny7uMYERJwbGUGi8UMcAxKLLDtUSx6MUjA5fMgvqNRQ5V7KFIjSzRQxENdjKan3jw6Rw2cZMFSGxDZqmFjGRfxLrIjkkFUXvi08aMl9lO4YCCJy008XfZhkety0od2KCUwT92LMN/yUTGGDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BN9PR11MB5225.namprd11.prod.outlook.com (2603:10b6:408:132::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 17:56:26 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 17:56:25 +0000
Message-ID: <d32298d3-5754-d07c-260b-dfb46ff0a0cc@intel.com>
Date:   Tue, 21 Feb 2023 18:55:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH bpf-next v5] bpf, test_run: fix &xdp_frame misplacement
 for LIVE_FRAMES
Content-Language: en-US
To:     Martin KaFai Lau <martin.lau@linux.dev>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <20230220154627.72267-1-aleksander.lobakin@intel.com>
 <36538615-7768-bdea-7829-6349729ab7cc@intel.com>
 <d6388f1d-13d3-d844-eca2-a4874e5c70cb@linux.dev>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <d6388f1d-13d3-d844-eca2-a4874e5c70cb@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DB8PR06CA0047.eurprd06.prod.outlook.com
 (2603:10a6:10:120::21) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BN9PR11MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: fffc6ec3-7a21-46d5-8ee6-08db1434f323
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fo/YTytaHWDdbCBzoJU+JgKwiEKLRc7a/SbAkubN2SfKYloEi5sdd+cHn7NzXe9TPxCPN6W9qLiFAOm16tDBGbpiAdudmfcbQvxhbICTWpndC+V4Wo//isALWC/p0Y8QfwH4aP86jz+vpxprg5EvRjskqRVKUZr71t9IhAgiGuUP26/wPz4H9Hoi41UtBT+HbAnh4fJIIuvAyWLB/xEauzGed+zZBPdkf1ZdXqkJhvW1ZVfzTXPr07Zv5fYqdTLGy3UKcKzu1f+xJvjjTMWknUVJPxB7o5h8tu1nVjrBYgJpu2o8+F1AdALsvEAEbB1XZg5pkN7mE0ycNeO3kHp+4v8iL/k+aJD3+PKbf/Ca9gCKGM4MF4mrxEG5u2V47CjgSBpvVebhIGWtb2NYgsDP4A5L5ck/t39zvy/mSUv2Ddvssgvvw1dYU2t2Rmma3H8Li4zM+Tmtro9alE0UT1d/ayby5UNrt1WBx0qrQlTvzJ4ENfNkP97r9k5OLPxKSJUHsnVFJ9xbRi/zEMyH1eFIs7aiJBXDG+bnbcUIjtz12QS64gbXVEcorIp5ltxcej0qcmJFLy9tRG5/9aJE/u9NAqBmlbFtWqnyBVLtjVZyEkOuT9G1GDxYVkmqcft7qZjCKcPHGVDJeVEBRH/IxB+YKajpYmE5wtaJAyvyy9pxmyXlmxmetu4KmsINF6Z2LM4kX6q0W9CmHpykI3Aw0aC7FQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(376002)(39860400002)(396003)(366004)(451199018)(38100700002)(31686004)(2906002)(82960400001)(8936002)(5660300002)(7416002)(54906003)(6512007)(26005)(186003)(41300700001)(83380400001)(2616005)(36756003)(6916009)(66556008)(66946007)(66574015)(8676002)(66476007)(4326008)(53546011)(478600001)(31696002)(6486002)(6666004)(966005)(6506007)(86362001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZTgxc3pvU0YwVVhpcmxRaFR2TUZNdVF3aHNlRXFuQnBDR3VuakgvQkZ3bTd6?=
 =?utf-8?B?TSt3M09jUU9FaS9tSEFtNkM0ZXBiMFlXbHZ5dXlkRnA2YW9DTk91bU93OXpV?=
 =?utf-8?B?c1JBY1lmd0xPM2h4enhXTnkvMi9pRlBOYWI4a0FwTnd2bUN6bEVaM2I1K1Vi?=
 =?utf-8?B?YU9SK3ZSNmV6eU81REQ4eGZ5c2dlTGF3RW92UFI4Sk1VL0IrL3RYWUl3NUtL?=
 =?utf-8?B?SmpPZjlUbm1SSnlCQWhvbXg0UFYvemNEd0k3bndueklEMnVLK1BlWnBoTDBM?=
 =?utf-8?B?dUo1V3NzUUljaFNuMXNKK1JMbjk1UjRmR2VTMnZ3UVNqM21rdlpBdTZOMUYw?=
 =?utf-8?B?aEhTS3JweDdDL3FGWndvQlhUVHFnVHRJejhSclRXdktPeTlYYTZqZTN5QmZj?=
 =?utf-8?B?dGpWVEdVZ0JpbmR0bXdGcEZHdGVQejl0b2toaGcyaVZoaFBuWDhtdnpldFRn?=
 =?utf-8?B?L1hvSXdqbVo1bHdVNEZwdkJoVisvdnpKSm1DTTlqL1lqNDg5UEExV2VIbEc2?=
 =?utf-8?B?YTM1UXZRNHpJVTRVQ2IyM3VDSEIzVDNKTC9JWTlNclY3VHFWTDBGK21xSzVT?=
 =?utf-8?B?RFlVc1J2VXZoNG8zQUhvdXl1WENlVXBlMkNBQUJBZmEzdVBwMXNNME8yWGF2?=
 =?utf-8?B?MTYvdDAvSzlqQVpxaEZ0MlRhREhWOFpkbkVPc282b1pUS0szRDFoSlY2SWVU?=
 =?utf-8?B?TnZXQUp1UkhpNTNySkNuQktlSDdlWW5mVkIrYzZ6bUI5SmZpM0djYnQ2ODh0?=
 =?utf-8?B?OXNiRHdqL3lJbXd3ejJ0ZjEya0o3N21QWGc0eXM2b2VmUHIyQXA5cDlwWU5P?=
 =?utf-8?B?T3hLMHNFM3ZZamRmSHl5TGI5R2krbVRrbHdSY1lKZ1ZPaTdPUHl5bXRKU1Rr?=
 =?utf-8?B?LzJjMUwvSjBFTjhyTDBCSER6YXlpOVlKRWlqeENBcVpJTHc4dW5nMkczdXk2?=
 =?utf-8?B?YnNXUVhaUHBrOVRZRUQ0RHRGOXdWTTZDbldwVUNrazgyd09VNHFVSFBsMmVX?=
 =?utf-8?B?RWppVFhjQ3RCNHA0WHFqUjBoQ293eEhYSUtSSStCZ1hvS0FDRWg1NVJkblBr?=
 =?utf-8?B?VXZNUWpzTlkvQnJVM2kyb2NMd1dFRlVqakJxQmczL3BrbkNvOGdhQm5IaGZz?=
 =?utf-8?B?b0tIU3oxSXdWV0Z1VVJndHhZUGRQTkNDQVQyeGNOdUx3cjg1QTFNaVc1VkY4?=
 =?utf-8?B?WmthTnVRV2lqS2Z0N3BDME1VVXkxUFp3aU1hbHlJaDZnSDY3TFczeS9SQzRZ?=
 =?utf-8?B?WFRlMGlVdWpEL1ZpRXp5cERyVDQyQ1Q5WFMxMEF0eTBWRG1JeE44VncvdFFV?=
 =?utf-8?B?TzlCZjdoUmJ3UGZkaXhzSUpOZ1ByVThTUmVhUVovTmVYZ0g4S0YrN0RYb0VZ?=
 =?utf-8?B?MkQ0cHRNalRMQ0RwMlEzc2pRREhTRmVLbEFGSklxTTVkN21wSkNQSE1BR2NB?=
 =?utf-8?B?N29pUU9ZeU9TeFExcTVhWFdKOUdVeEJEbnVReCsvS2huTS8wbjRCVXRCQkEv?=
 =?utf-8?B?Z2NBaHhjR0JHLzdhS1BLajdpdHVSWXU4b0ozL2Rqb2g4RXdQTlozUHRGOHRU?=
 =?utf-8?B?dU1pUkhLYXU4alFhU2tkSUE1MDVQam5tS0VWdjRqTUJyU0R4L05QTXlZQzRQ?=
 =?utf-8?B?VHJPRTVCNjQ5THdpTmRVckV4MWdhNVlKTEZnV3FRT0cwbGRkVWsyK0gxUnVm?=
 =?utf-8?B?b25Zc3VQbnlKcFdHN04yNnlOYkR3cWlKVVZ5MEE2NXdOOGdlbklGVHNrVXgz?=
 =?utf-8?B?eDBxVkhzN2x6OFlxWGNaNWxtaVFmWmVNRktZSTR3R2ZMM2ZjTU9HVVUrcUM4?=
 =?utf-8?B?eCszSXBMMjFscWdpU2NzKzBzMkJ1aWZ5N29IN1duY0VRVXAyWnJPNDRRT1dU?=
 =?utf-8?B?Y3c3R3B4Qm0wRW1kYXg4TUxCRlRkTWxleGlNUmcyeEhUZDh0M29Dak81SE4z?=
 =?utf-8?B?ZWNPN2lrWGtLamNHcmROamlnZlY4VFpuaHAwcXF4ZzF1ekdUcmlyd0ZIdTFj?=
 =?utf-8?B?Tm54eWFOeWdyMUlrRGtLQ1E1OWs4SWlGKzAvbkdCWk9kV2lNNm1jK2NxRXhH?=
 =?utf-8?B?Y0NWQkpLOFdleEhFRzVWS3RJdzczTVV1VzJyMkJvMUxDNGlNak1CeWhsR05i?=
 =?utf-8?B?UUFkSzFHUDF1cTFxRnRldzNkMVcwbWN0WnVhSWxjQmhPZHlKYzJGREVzK0lK?=
 =?utf-8?Q?JYGJHreE7DQVzAD8PXdbLjo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fffc6ec3-7a21-46d5-8ee6-08db1434f323
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 17:56:25.5449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KZFB3FoZ3QCFvRoEeZSAjSAR45vekMu/r4sCfAbLGqjl5EYomsbVemzk46MK89axRT8+sw+h6scTsuqyu63YUqDvrsGfnw08B+I97C7SAPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5225
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

From: Martin Kafai Lau <martin.lau@linux.dev>
Date: Tue, 21 Feb 2023 09:52:52 -0800

> On 2/21/23 4:35 AM, Alexander Lobakin wrote:
>> From: Alexander Lobakin <aleksander.lobakin@intel.com>
>> Date: Mon, 20 Feb 2023 16:46:27 +0100
>>
>>> &xdp_buff and &xdp_frame are bound in a way that
>>>
>>> xdp_buff->data_hard_start == xdp_frame
>>>
>>> It's always the case and e.g. xdp_convert_buff_to_frame() relies on
>>> this.
>>> IOW, the following:
>>>
>>>     for (u32 i = 0; i < 0xdead; i++) {
>>>         xdpf = xdp_convert_buff_to_frame(&xdp);
>>>         xdp_convert_frame_to_buff(xdpf, &xdp);
>>>     }
>>>
>>> shouldn't ever modify @xdpf's contents or the pointer itself.
>>> However, "live packet" code wrongly treats &xdp_frame as part of its
>>> context placed *before* the data_hard_start. With such flow,
>>> data_hard_start is sizeof(*xdpf) off to the right and no longer points
>>> to the XDP frame.
>>>
>>> Instead of replacing `sizeof(ctx)` with `offsetof(ctx, xdpf)` in several
>>> places and praying that there are no more miscalcs left somewhere in the
>>> code, unionize ::frm with ::data in a flex array, so that both starts
>>> pointing to the actual data_hard_start and the XDP frame actually starts
>>> being a part of it, i.e. a part of the headroom, not the context.
>>> A nice side effect is that the maximum frame size for this mode gets
>>> increased by 40 bytes, as xdp_buff::frame_sz includes everything from
>>> data_hard_start (-> includes xdpf already) to the end of XDP/skb shared
>>> info.
>>> Also update %MAX_PKT_SIZE accordingly in the selftests code. Leave it
>>> hardcoded for 64 bit && 4k pages, it can be made more flexible later on.
>>>
>>> Minor: align `&head->data` with how `head->frm` is assigned for
>>> consistency.
>>> Minor #2: rename 'frm' to 'frame' in &xdp_page_head while at it for
>>> clarity.
>>>
>>> (was found while testing XDP traffic generator on ice, which calls
>>>   xdp_convert_frame_to_buff() for each XDP frame)
>>
>> Sorry, maybe this could be taken directly to net-next while it's still
>> open? It was tested and then reverted from bpf-next only due to not 100%
>> compile-time assertion, which I removed in this version. No more
>> changes. I doubt there'll be a second PR from bpf and would like this to
>> hit mainline before RC1 :s
> 
> I think this could go to bpf soon instead of bpf-next. The change is
> specific to the bpf selftest. It is better to go through bpf to get bpf
> CI coverage.

Ah okay, I'll resend when bpf pulls merged net-next from Linus' tree.

> 
>>
>>>
>>> Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in
>>> BPF_PROG_RUN")
>>> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
>>> Link:
>>> https://lore.kernel.org/r/20230215185440.4126672-1-aleksander.lobakin@intel.com
>>> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
>> (>_< those two last tags are incorrect, lemme know if I should resubmit
>>   it without them or you could do it if ok with taking it now)
> 
> Please respin when it can be landed to the bpf tree on top of the s390
> changes.

Thanks,
Olek
