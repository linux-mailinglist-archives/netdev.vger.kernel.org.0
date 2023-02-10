Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71822691F2B
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 13:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbjBJMcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 07:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbjBJMcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 07:32:13 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF84663587;
        Fri, 10 Feb 2023 04:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676032331; x=1707568331;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SXs95Ktpi0VrBD6Jhz0VcC1ZkiXtfYQiA0fpCIG/MKg=;
  b=jOgQoJs+RkdfA3VUjcLaLkvlA1tKiIPMQMHyaI8gaXy3yMDeLxyEtlW6
   bBH6K9OZCxDAzy/U7WB/0jhraPM3W9Rqhm8Am5kQUlYGeY7BsTFLtNSHs
   NFCckt3SlGYf+cKdlUzIa//2Yu2TwWpQHR2quQEOnensX2xSjWjoqybt+
   vMPdT/OYavbx8IwFrdsFESOQzOvK2snVRj02caMenFVluWnhTWJL+aIPr
   4GviBsc/gmNFsSuVDkSpvNaR8MzEz57Nab43bCz9ErwYV+FVBXoXbc8sv
   WqTUXoIsRT9jK1LfwFRuZkeuegHtot4sMeiNihz020oHyC3smYf/C+rxf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="314054533"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="314054533"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 04:32:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="736724126"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="736724126"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 10 Feb 2023 04:32:10 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 04:32:10 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 10 Feb 2023 04:32:10 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 10 Feb 2023 04:32:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nG1Xl9oaj/KHCS1ZKXX/YFMdeSjV2kYUgnKsxUjoROrlqrTbsJwDAJXBXwQMfLhfozR7Ca7eA8t725Gdddufi4iojQr7n5B9kKzcXm2X2pwU/h/zGhKw18ucdGq8JAEmfCRUUyPZcoODRvrBAJsHC+LPPp9o7FFjJLCeR1F772g7PTie7qimH3a/r4V8BfniC4YjuessROuveyMfYyqaw3Dcllr9MG4e4Hm+i2/31ryBUZz4F7cGxIEdOKeHic0qUzok7gN1BarjYafZiPCifHSX0ZvpRovaraNOQB180e5OuNQAK5ByrHIQ1J789jdhDtqdSuPGS/dOsIcMfP1xyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gHtTHEs/dvbjVwZfh0JXRO4/W1NEa7hH7w5LVb1SsXM=;
 b=hy/z+1HFsr2Nu6J7txiXjEM91SEEGN18LNLE6hiuslNoBA6MPuUiLQcfdgS0cNiIvyDRfmeWHr1SQ33hdroDIxEc/4lbE36HjkNQifDMchAQZhUMzZeN1mYgtwynpYfNuzIYtZcnnVaDFwY+pucvRlSMhzmEeaADOkRxEdxKL9sYMfPFi/yv24c3Q2PsxEeUo2Nup7Dt/8qkNF4DqCiCkdn8isVeFrA26ZjJVYxh1cOWkCfjuhjpkEaJtdKDBE4hBp2PAWeqXKwjze5WB0XdYBc4DMqwomw6/ZcjbEdUHX/wyvM49cypsuLXEaPbUbhuVQDKCRTF1LNpb0g8+Gx1JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3624.namprd11.prod.outlook.com (2603:10b6:a03:b1::33)
 by PH8PR11MB6803.namprd11.prod.outlook.com (2603:10b6:510:1cb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Fri, 10 Feb
 2023 12:32:08 +0000
Received: from BYAPR11MB3624.namprd11.prod.outlook.com
 ([fe80::e816:b8cb:7857:4ed9]) by BYAPR11MB3624.namprd11.prod.outlook.com
 ([fe80::e816:b8cb:7857:4ed9%4]) with mapi id 15.20.6064.036; Fri, 10 Feb 2023
 12:32:08 +0000
Message-ID: <701f6030-72d7-0f11-173b-a2365774b6f2@intel.com>
Date:   Fri, 10 Feb 2023 13:31:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH bpf] bpf, test_run: fix &xdp_frame misplacement for
 LIVE_FRAMES
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230209172827.874728-1-alexandr.lobakin@intel.com>
 <6db57eb4-02c2-9443-b9eb-21c499142c98@intel.com> <87sffe7e00.fsf@toke.dk>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <87sffe7e00.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::8) To BYAPR11MB3624.namprd11.prod.outlook.com
 (2603:10b6:a03:b1::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3624:EE_|PH8PR11MB6803:EE_
X-MS-Office365-Filtering-Correlation-Id: 66d37289-e4f4-4946-ac5d-08db0b62d2d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tviRmaJBU3f2JeZCFs86IHJJmyEIPOZx6S24748J8adeFPFDoMYOA2TYghbqaykxb5hv6bTW6Tkt2qOTwflrh313MHKtAFA7o83JtnlNxij/B4168uOUiVw/+EMmAIm7BlZQDyHtAJwasfEor+KyrmpGNUD5N5LCSp/M95gUGkOIiLUrw54DCshHbB6ppzziBcuLTHK66+0YmlHtPkF+K4TDmEHkwK8BY/beJZ4qSdcyZiobqF3zL9s303qMPHmMATICIO2t8sVakr0ZFX5NZiPU1cUukLKrzpaHVob3CWRB1HpFTGHGbmYX2ZHSCOF8QHO8+nicljpbJiETEfPglZem1t/KpjW9iFqePL63D1nTILQ6l2irw3iRXOJ570LnU+mEej82wwHwebPBdqt4MpWB7b7m/6gssMY9ScVhj6O+VlCnDNm3tDmrFJa9WG+BN2B0GO7q79FU6EtsJNtPZhOCiR6V6e7EUGrDBPPbBjLhKCmMJjcbwrLWnkgx8O6DzThU8sUwupm1KYHELnhLrZqiXxKSkjUjmetiGAT3lTEduozAwCL/bAk3cTkX8+TpwBu5f9kNoN57rROf5TrF84UAzyrjrL0MrBsX+d9t8NJVAXTdRsxAXWDiLhT9kEueBJ05YR4ayT9OJFP9CAv40oQZtxdr1zB8nSBhExjKTGUGCsFIyMj4d5prEz+VYPk+9NdnOXKZYXyzKk9n9oo1x6Qagr1XAEKYEPA1oEyBy8M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3624.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(346002)(39860400002)(376002)(396003)(451199018)(6486002)(478600001)(31686004)(26005)(186003)(6512007)(2616005)(6506007)(6666004)(316002)(54906003)(66476007)(66946007)(66556008)(82960400001)(8676002)(38100700002)(4326008)(6916009)(2906002)(7416002)(36756003)(5660300002)(86362001)(31696002)(41300700001)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0F5dzJPeGpack9pdFhXS2NieFpjMUdZK3pRZ0FNTVJGSk5MclVWMkJaNmxl?=
 =?utf-8?B?ZVdnTStNeENVVGpObU5scmEyZDJxQldBN0FIY2hkay9SUHd3R1ZyR09hRElY?=
 =?utf-8?B?NzUwQnJvUWFMdkhNVDlqbVlkQSt1MVJRTUxsUkFOWEF6bWpmK0FJQ04yRnpI?=
 =?utf-8?B?ZjV4UytvTlZsQTlpT3p6U3RYbFNNQ0RCZHIzdmJ3RTVJcGdKZUhHRUlEVXA1?=
 =?utf-8?B?R1owbGhxTHBwMm1MMjZPdkdIS3dxNk1rQ25LTWdrd1RGYmVxVllTb2JyK3lr?=
 =?utf-8?B?Qy9vMHVPSkZ2TlI0TjNoSlJlTzZvOWVDcE4zTFVnUWlsQXY0S2JNbHVRNWhp?=
 =?utf-8?B?eksvbnkvL0t4M1hNVUUyenV4VFpDeE9CZVp6MExxbnZvcGxJYkZjY3h6YUJa?=
 =?utf-8?B?QkxNWUo3ZjN6Ujkyc1N3M3JZOGpnczF4WGFNNnkyeWszYW53TjZRVFEzdEhO?=
 =?utf-8?B?YmYyQW5od09rWXZNWWFyeW9EUGlKV2dMdjI4NHN2TkdiQUZqNmRKaUtOTWkr?=
 =?utf-8?B?NFNDTWlId2dHMWVidWp5Z0JHL1p1NkRiRDEvM2RpL2ZRN0lBRXBBamNZb0Qv?=
 =?utf-8?B?eklmQ1B5dkZkWWcxaldDeDFVK3JxUENUb05yM2RWMXRHamJ3ZXpkeW9nVjd3?=
 =?utf-8?B?NEdsdUJ1SEV1WnNhNXlFQUVVRy9tdUtrUzU5ZllFQWQwVlpDMVcrelhDdjRK?=
 =?utf-8?B?cCtrTlBIU2htQTVqVkM1aUcrN3lGbms4bUw5d2YvcmdEcWFBM3U4U3hNcWRi?=
 =?utf-8?B?cFRsSXM3Tm1tVng1TGswbWZVUWd5MHBza0xsYjdxWi9GTmFKbVlEUksvclhw?=
 =?utf-8?B?NDREaXBHTGtBUzU5YkNlM05pWG1Rd1cyajA4YnVSVW5XQUZSUHpGT2lzNVMz?=
 =?utf-8?B?K0liZVN4eDlDSndMQXJXbkhKSWY1RVNNMGJPMnFnMDF3VHN6WkpmWUNTeGZ2?=
 =?utf-8?B?dXRsaVJXdGJhNUczNkxscng2aFhDZWRWbkRHY291VVJlMHVCRldoanYwVCtX?=
 =?utf-8?B?MDRhQi8xandrcG50emFqNDdjVlN0NkFOK1VBMlhndm5URUNDTFNBSDZiSlUw?=
 =?utf-8?B?U2pCVTVrbVIwcm52MkxOTlRIUFRlck9XT3RGeEZBdm1CUFlvbFhjSEdjVTR6?=
 =?utf-8?B?N0lmeHdWUGJEN0M4MFhhKzlDSjVVYmw5RGY3YUxRNlY1dkxoTnEwY3pYOXJ0?=
 =?utf-8?B?WmJWS2VwWGVnaG9KbEpSdnR4UUdXbmhKSUNmODF0RlFTcDFlUllyZ1QvSXkv?=
 =?utf-8?B?QTlsMzRHa0QzemhuSVQvZ1pCcjY4d1VOS2p5SnM4YkJyNlBuZ1orcFU1aG44?=
 =?utf-8?B?Z2ZSMGtFblN2QTZ4WlBzWnVtSlhOclRtVzIyY0NvUWxZbzZYVmszRS9DSmd0?=
 =?utf-8?B?T0FxWlJUVEZLT29UZ1JhVFd0UGVRUDN6K2YzL1Njak1oUitmcXdUbjQwell3?=
 =?utf-8?B?SEpiMzE0VklxR3E3eUJDditMQmYyRFVlL0JHTDBVTDVxZHVyVDRYODhyVSsy?=
 =?utf-8?B?RDROMUM3SFo5akdxL2ljcW5DZ3ZWb0JEWTVpV2s5ZUZ0SVkxTm4zZmtjSmhW?=
 =?utf-8?B?dGMwbTBVUllmVzVtTTVWdy9RS0d2YjNkczVxQ1A1SnBvWEZvRTdxYUpyRHFC?=
 =?utf-8?B?dWRsVFZOY2Y4VVgzQWZCU0ZNcXEzM210QkZqV3FlZE15ODdaSCsrRTJxSjA0?=
 =?utf-8?B?N1pIc0NzOVBaQkVHT1JtUjlPNWV0c0tvQk1CZVNPbEFYb2lFemIvZ1ZBKzVC?=
 =?utf-8?B?alBKR25FSXdGa0t4MUpTMk44bHB5N2U3VVFWOXBIUUZ6OEx2ZWI1dEtxYVMx?=
 =?utf-8?B?VHFwcVNaaXpGMHFKSEhGS2tQeDRrNzJDL3NVK29rOGlEeGR0R25COFozRDhP?=
 =?utf-8?B?eU45bVNsQ1BSZ1lYUHBvTUlrYnhMWCs5RlE3d29iTDA2UEF1OVRtZ1VSQzBD?=
 =?utf-8?B?dXQwSW1DRlY4SldqZTIzOVJpU1IzMEVBeXJEay8xaUsyV3dkUzlpRG9ER1Iz?=
 =?utf-8?B?emhWdFdvL0p5dEJDYmNJYmFLNkRrVDREeWJXbEM3KzFSL3djNGNrczdMbWR3?=
 =?utf-8?B?RUw1SlMvanZFQnVjUVNuWFlTOHJ4Um5nZnBEUit1a1JKOFkzUks5VUt2aDho?=
 =?utf-8?B?Wk9Kc2V1cUpNNXMyanJ4TzVKOXRrbEFQd3MydU5DRWN1MVdsSWt0ZHUxM3Bm?=
 =?utf-8?B?L3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 66d37289-e4f4-4946-ac5d-08db0b62d2d3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3624.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 12:32:07.8126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xnh6A06PwYnxZdczSzD3HSM1CN8djCSJPHcKXMKIq8AiIrtLhLCcy0EtnnvSoy6n4ClZZ6dzOFDxJZ+EUtaLFm4myWP8/w/pVFJ7Go0SPqc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6803
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Thu, 09 Feb 2023 21:58:07 +0100

> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
> 
>> From: Alexander Lobakin <alexandr.lobakin@intel.com>
>> Date: Thu, 9 Feb 2023 18:28:27 +0100
>>
>>> &xdp_buff and &xdp_frame are bound in a way that
>>>
>>> xdp_buff->data_hard_start == xdp_frame
>>
>> [...]
>>
>>> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
>>> index 2723623429ac..c3cce7a8d47d 100644
>>> --- a/net/bpf/test_run.c
>>> +++ b/net/bpf/test_run.c
>>> @@ -97,8 +97,11 @@ static bool bpf_test_timer_continue(struct bpf_test_timer *t, int iterations,
>>>  struct xdp_page_head {
>>>  	struct xdp_buff orig_ctx;
>>>  	struct xdp_buff ctx;
>>> -	struct xdp_frame frm;
>>> -	u8 data[];
>>> +	union {
>>> +		/* ::data_hard_start starts here */
>>> +		DECLARE_FLEX_ARRAY(struct xdp_frame, frm);
>>> +		DECLARE_FLEX_ARRAY(u8, data);
>>> +	};
>>
>> BTW, xdp_frame here starts at 112 byte offset, i.e. in 16 bytes a
>> cacheline boundary is hit, so xdp_frame gets sliced into halves: 16
>> bytes in CL1 + 24 bytes in CL2. Maybe we'd better align this union to
>> %NET_SKB_PAD / %SMP_CACHE_BYTES / ... to avoid this?
> 
> Hmm, IIRC my reasoning was that both those cache lines will be touched
> by the code in xdp_test_run_batch(), so it wouldn't matter? But if
> there's a performance benefit I don't mind adding an explicit alignment
> annotation, certainly!

Let me retest both ways and will see. I saw some huge CPU loads on
reading xdpf in ice_xdp_xmit(), so that was my first thought.

> 
>> (but in bpf-next probably)
> 
> Yeah...
> 
> -Toke
>

Thanks,
Olek

