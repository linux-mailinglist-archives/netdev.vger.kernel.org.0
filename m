Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B34C636932
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 19:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239523AbiKWSqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 13:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236582AbiKWSqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 13:46:17 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AA28C0B9;
        Wed, 23 Nov 2022 10:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669229176; x=1700765176;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1j+pBk1t7ZWmS5n/rgZtgwr25O1Xm18DoxstHYRfiI0=;
  b=iJZRHiPhZ7eb5IbGE7tFPFbTt24eeSDwkoy6uZsc0kbE8GctRXu+jkm3
   8RU02zr/cZ429zo60SIMuEj4Kd9+jmDta5lRs2z6GXnhwzZV6SsQdn3TB
   fZdf24VKLUvBdwVfDXiLNMMJS1YdjK0M8h2KvOFtQEyHFjtAC/B12DPO4
   XVdifOn2ZmEHHZlKbszXLvIZk/hI3TON2ckX4oIfeGCWmvoh6EChrKEhN
   ZVX3EM70q4Owc5G2ZOT5fSsbFdtvoake38xgJrhP/RHlen8Ym6EVhC126
   8ssb41g9zNZpPYgh6FwFc/gtB5ElDFhmTtAoda5w37+dOTrtJiCaq/m79
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="378395222"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="378395222"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 10:46:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="674820433"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="674820433"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 23 Nov 2022 10:46:16 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 10:46:15 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 10:46:15 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 10:45:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOYiAA20XSazgtDAkmvqjMNcfTDVYJGpcWy/I7Z1pcDQTfDG5X9hHkvs8HiatPyg2JmvPXq/qv7eAHD0BRBMeeqW1va5wDlwRAjDGr15j2VIw8yS9LKMCAJ0bFhBDmFKTBYhv70VwJxEH2YrLBQaSyCciGCg0InA6t0mlapDR3C/dfJHCfNwyyB4VPRZubIuEY+y2Q6KlErpeAeFJBwDneLxMGtGD+x8hEdVF0MyIvOxkfNctTKriM0TB/5ZE1Eikwes5yKU7vIvaottSLs/ikFavMumXg4xYxGIZ6SseS0n/ulIo0DDuHi5HffbwxgxN/vnLIT6yPs1/3MXJjKMLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ph5kt6mmNcj/i5bBPWBG4v0nc7gjZFAgWIoAWQRfkg=;
 b=Up+O+2XOhrv/6onU54nS1diDNMT/KNyjAYVJ6LEKYTQBvywOvscbpwXFpTy0GRu6Fj3v9/KB1vaM4EqqzTC6D+sRoGY55ltYpceKWlFGxNZWWMD3ZAw9bJJNfNvFyJxi+wnt0KjGrOf78w5b64FxcwAkElGcEkAV/BDKxz9KK/AR4s3OyVHqZEgK6q+AcYD31/hHytbBwlU0Z/pLF4OOrEl/DDhFbxEE93Cs+eonNxgHAo+nDHpW1kldggR8+ATZ7rpAFAjbR8dWp0i4Gi2jjSZ1NtPk+AdhCzoXlmvfCib/u8Hftp/Z2kEWz7phu2dOcDwTnjZNEXpXoN7J3O1j4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MN2PR11MB4726.namprd11.prod.outlook.com (2603:10b6:208:269::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 18:45:43 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 18:45:43 +0000
Message-ID: <fc6c11e4-d038-1277-289a-ee51a839fc88@intel.com>
Date:   Wed, 23 Nov 2022 10:45:41 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [patch V2 13/17] timers: Split [try_to_]del_timer[_sync]() to
 prepare for shutdown mode
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
CC:     Linus Torvalds <torvalds@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Stephen Boyd <sboyd@kernel.org>,
        "Guenter Roeck" <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Julia Lawall" <Julia.Lawall@inria.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20221122171312.191765396@linutronix.de>
 <20221122173648.849454220@linutronix.de>
 <74922e6d-73d5-62cc-3679-96ea447a1cb4@intel.com> <87k03leh47.ffs@tglx>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <87k03leh47.ffs@tglx>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0224.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::19) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MN2PR11MB4726:EE_
X-MS-Office365-Filtering-Correlation-Id: b9fb955e-2f63-4abb-40d8-08dacd82ed30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SmJ7Cyc7T0WxWClVwRQeyamANOE4IwqNLW/hob7LTgvDXs84LvEPkbrnTFZONABahB1ZrkIiMbsKc+C5UxCu2pyyzBiQjCOGuzr38/XPvUVB49/ROGRyTMlIY8RnJHIEd6uhWcML/eiGOH34ytVpY3zUhUonozhPpHuVV8ShZ5nB1dsa+y6Mr3qDwLBBpQ1CFYee2B6MFSDMGgivKFilo2NunQE/fOUoMloG4rMfv6/iIyh+zK8A9JawKijtL2XYaamecyrIsFUKA9ELylFx9NpkrEWFWBikqkmH5xYzlEjFdDqtEJ9Cz1M4P4VUjsroLbxNLCv++tFYVa25XVAM5djbCbHW5vt+b0jSuFc1T7z8La+udiDHHCTVMDhJMlqCHOlq/q03vgxva/aVqI0cgcEWJi6bqorbatupU0SsCVZ5MY04IWP8c4UJEPO67P71nLCBibK/p/gV1CHls9oEwZIj4VgI7phvn09iI1MNgpf/Va6rfEz0/Pl4xiNfitByI2I+CIEMjmC24aNsg1lGdwuG+O6AqmT9uz2zzDNuL9Z+pINiW9Jt415cF9Mq/4Zk5bYj4RtkH0cY9EYZriLBoA+oFeHA7cV243OqOLoaYr/h9hKviraROVmNdaDfjGDMapqUn7V3+u8eCKo5HdZNDgngBjmf9+vBWJaJ+VlG9FanLbpWNeDZV/aP+2esmywUH+6yncuuWb8GlXo6zzFIHLz8DCJyyPT6G+7ROTnlIoQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(39860400002)(396003)(346002)(451199015)(36756003)(31686004)(41300700001)(38100700002)(4744005)(82960400001)(31696002)(2906002)(86362001)(66476007)(66556008)(8676002)(316002)(66946007)(4326008)(186003)(110136005)(26005)(54906003)(6486002)(478600001)(8936002)(7416002)(5660300002)(6512007)(6506007)(2616005)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TE1IWEQwWGViU2dvaktFRlBsT2NJSTdQVEVFTldsNnhHaVlubk9ZZU5QTEdx?=
 =?utf-8?B?a0p2UFkxMjl2NktoNkMwaVExR09JejExRDBmNFdudktsOFIvTlI1TnlaMnJs?=
 =?utf-8?B?WmRKWDVtN2RzSEhwQ3BJcHZNZHMxMnpKR1V2azFQN05SekVzUCtiM0grNjlZ?=
 =?utf-8?B?eWtwZHViTnFoQU52RmY4M003RUo5bmF3eGcyU3FNeFlHUGozUDhYKzdyT3My?=
 =?utf-8?B?eE80ZHpGRlUvSnByOG05anIxL2Z0Yk5LVTR4RGYzcVZKTVNtUk5aRWdoRGFv?=
 =?utf-8?B?VUN6UEhESWVaTm9uQ0IyeTFzcHN4Q1lRaCs2dEZobTVEZmlnTUhmWnBkaXhk?=
 =?utf-8?B?VzlLeWlndDBUV2w1QWkvcXNNK3p5NEVackxHZE1Wd3piZW5uNzZEWWh2aloy?=
 =?utf-8?B?OHpVWlNwNGRySzg5a2F3M2dTS3pOQkcwbWV1MUUyZGFTY3N2ZENRbjhUREYx?=
 =?utf-8?B?WVg3SjJreDNGa05SRndOOGR0dmVZekp0VHFqU25ZdFVDczJFejArUjZyYWFn?=
 =?utf-8?B?YWgrU3FJN1ZpY1haZDNlWXFGSlBzN0RPcnpjb1BvRHg3RFUyK0srbXpYenRh?=
 =?utf-8?B?TGpoMHpKeHprRmRITXVpS0ZEYVhQeEJRcUdTVXdrQlhwSStTQUtQNkFNcGRp?=
 =?utf-8?B?Z3AvM3Y1WXNUKzdOVUVia0s0YUxiK095RWNvUVJtaGlmdUp0MWVSUlZTN21r?=
 =?utf-8?B?RUREMnY2cEdibC80Um9OZDZsNXAwUE1HNVhXK0dvTEVOM01VVVpCeG1BNk9h?=
 =?utf-8?B?Ym1Da1NCd05jN0RFYmxvS2pZVEFwTWhUaERjUWtLeWhtQnBrUXZMOWFzMXNY?=
 =?utf-8?B?RlBvVVN6R1hIZFBNS0FzVDdKWFFQUlFBUllrSS9nTEN4SlFQQ0V6N2R2UnhL?=
 =?utf-8?B?aTlQNFJNM1VHYjJ3Y2tMOTlHNFhNaFNhVXEwQ3JsV0puaFVWbG1DTFJzZ1VT?=
 =?utf-8?B?QjNDYVBpRlg1bUQrVHFENmNMbDJJMW5zcXQwWXVqYVVpd1I3L2tSb1Y4bzNq?=
 =?utf-8?B?akI5VWdoWkdRNzR3TFBrTHczOW1uSWE1WVNkczdYUkFZOEtjcTJmR0llK1U4?=
 =?utf-8?B?dXdaMEwrakpTN25zNkxsMkRKbkdjcTFIa25VeVhaVEJCQW5rc1lTVERWU0pK?=
 =?utf-8?B?ODBUMnIyanh3NWNTM3d5UTN4VWlCUGpXRjdqTTBrYmJXVzZ5TUcycmdJZGtD?=
 =?utf-8?B?b21CaWpaQlZSTmpsSVVZUzZNZmZQYlRJaElDMkxPMDZLTUtnS3U2SFpCUEl1?=
 =?utf-8?B?SVg3NUJHRWJkdzZXTXI5bHVMaE9Zekw3TmdYYUhuQWVOMDZhNmxoZG4vZmFp?=
 =?utf-8?B?UTJGWkN5cXFoaDRjaEhaeC9ORkhMbzl3Qm54dHlHWnhkRkhDdkI0Ky8yck9B?=
 =?utf-8?B?eE9odnc5YlFaeTl3ZTd3ZFJ5ZEoxZmV1TTV6ZlBvZ0R3Rlk5a0Q0NnJ6Mlgw?=
 =?utf-8?B?clFUK2tLekFGYW5yQXFvRGljQ1F5VHlZNmFvTkNPUlJpdEgrbzhtbTA0UXpM?=
 =?utf-8?B?Zm1kQWM0SVpXSUE5a1ZtMXNGMUNwOUlzTFllNDhrWWhQWmJ4ZzF6Y3BWcXpp?=
 =?utf-8?B?bkFYVHNlb0c5WWxvc0VCMXlIZk5Id0lsbHl3OHljYTZGUUVoQmxKRW00TWtM?=
 =?utf-8?B?RWg2SnVOanM2bjBPVkpmbC9qamRKaVFaVWZnaXBiRE05V0JSUFpNMEltakMx?=
 =?utf-8?B?QTlNcG13QXg3ZG8zNEE0YTJVTGFMWW56bkJMWmUwU2NXZFJ1SzV5cDA2RXJC?=
 =?utf-8?B?N2RyWXJjQzR6OXZYa1ZPdTU3TkZlZ3VNZUNyNkZsclo3K1ZUT1hXbzRPZFUv?=
 =?utf-8?B?bHVFd3p3MnJFaGZPMjdEQ2FHQmVkaFhtakcrSHFwY2toZUVjL21GY0drcHNh?=
 =?utf-8?B?Ym1GOExCYmYyMWtoZVllUjYyUHFSYXhLRk1mOVlQQ0YyU2R6eUZWTlRnQWJJ?=
 =?utf-8?B?SC9RdUNQdzh2RFNOWW5mYWxGdzNSMUZlUWlDV21LK2ZmYkNYdEg1OWUySlpN?=
 =?utf-8?B?T2dHQithUllTOEpUOHF6ZXFLNVNndTE3dUlMd0taaUlIZmxFMitYLzFLWWdQ?=
 =?utf-8?B?MGlNUGRSNG12MXpmeFhxUVRKTWl5S213ZlVqdmY0Qk5iMnVrei96RkJqY3hi?=
 =?utf-8?B?alFGNDcxdnBXUFhxdDJDNXBoWmtSTzZQVVpoUmNDbUZ3ZkR4UFpvQUNUd3Zi?=
 =?utf-8?B?c1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b9fb955e-2f63-4abb-40d8-08dacd82ed30
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 18:45:43.6557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4diqhoWfCAq44whnkTcbMD5SoKWPy55KXS4JYfzpgNURhMtupbYis65dadgnpiBJGSuXmYTCnh9hy/WHnZIVSiE3nQLIEd+brGe2cNAzu+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4726
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



On 11/23/2022 9:05 AM, Thomas Gleixner wrote:
> On Tue, Nov 22 2022 at 15:04, Jacob Keller wrote:
>> On 11/22/2022 9:45 AM, Thomas Gleixner wrote:
>>> +int try_to_del_timer_sync(struct timer_list *timer)
>>> +{
>>> +	return __try_to_del_timer_sync(timer);
>>> +}
>>>    EXPORT_SYMBOL(try_to_del_timer_sync);
>>>    
>>
>>
>> Its a bit odd to me that some patches refactor and replace functions
>> with new variants all under timer_* namespace, but then we've left some
>> of them available without that.
>>
>> Any reasoning behind this? I guess "try_*" is pretty clear and unlikely
>> to get stolen by other code..?
> 
> Kinda. I renamed del_timer*() because that's the ones which we want to
> substitute with timer_shutdown*() where possible and reasonable.
> 
> A larger timer namespace cleanup is subject to a follow up series.
> 
> Thanks,
> 
>          tglx

Yep thats what I figured once I got to the end of the series. Thanks!

Regards,
Jake
