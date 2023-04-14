Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF35A6E26B8
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 17:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjDNPTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 11:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjDNPTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 11:19:11 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE20CC657;
        Fri, 14 Apr 2023 08:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681485534; x=1713021534;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=c1wYvE7WJJbfkdhbtLKh0OuQLw00ZEhmHL80iT5z8LE=;
  b=BX52d6P0jcphWBHNK7FUzsFxshQ+ZfHzqhGA27j3fz16Dh6PMh4dKdoc
   CRP4svPE6vCpHEXx2oiFZUD5hNC5h3BvtDtZ6Vz/q6lNKpbMS1Jy+NicJ
   97I0q7WK1Wy7kjnruw0+F0YwAFKS2b2FEEvkdYRl95WdaBKoP7u0nQfq/
   fUT/puUNnVnPw+GYrftTocFQNlyjllIPhG4pKYly+o96+sMOePl6GZYOQ
   6wJECcRMbJhySA4lfbut4KT0uMP3uEtbg5E00Rs6P5tXLa/238kGZrQ7o
   nxX/obqNJVEeUJimjBBgGZSIQwD70tllUJJJx8ZP5GtApie+dmNeFl1Nj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="333261932"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="333261932"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 08:18:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="864238330"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="864238330"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 14 Apr 2023 08:18:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 08:18:53 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 14 Apr 2023 08:18:53 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 14 Apr 2023 08:18:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gnf7wg1kolaoybRqwIQ4NLYoFxwSgvbHYGGoOoPzUW6/m19TogDqmM7SJGJW2lfpTxdpKpoUk/WspsECOMNf7dZkJqQRvx673M7hZFXgnUFi+dkBb9SnKNjwyqASMGGm48mtAho4+fs2VBnVDiO6j3EaxJ5ljUlcToGHgjITo3OsBE+9ndZAKdBhWHS6AtTqfOkqrGtMdb4vYCIo3mD1oYGl4zvckcuXzwvYJ1NuD5/m9Md7OH2cRERtTjF+3KdRMJ7EgKGeDoT1oyHc2AL7MHOa5WWUCl2rIhC08WpGUS4m3otgu7pDfd0HbV1wrwCi9WS3TRzQYsALJg23n1BHag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QrhGm+o6PhUViIDzX7QO1aoBxUyuVGFDIymMQ41+kzw=;
 b=IewSUjgDD2eSp9OiZn2xZ1KuNDlwn74ARt7b8kNyei3k4+GDzrSuyw1cMDwCbgiT0CflMBTB+ACDKNZ1tO7SbwWDT5GwSfD1MEGy4LMqYE/9uPTsevz70tffzy+ehmKy94MeIdEmiSMe7yQi5v9bfuV837sh+qozdzvsZGLZ48PabUROP9Pf+xv6Wbojjk9kONnTt9OSwPrBS1byRYP5LiZbbFeAB4pgkeSUrKp5CeoGMaKLLvB29XSQ3TmSj3EbBtc2ChgZe+K5wt9dKo/GhWJGntsnMBG8+Plxk8jTe+6Br89VqbGnqaFD/raAvhoEkPl8CJsiiGJdr+tLsxQo+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BL1PR11MB5288.namprd11.prod.outlook.com (2603:10b6:208:316::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 15:18:50 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 15:18:50 +0000
Message-ID: <9952dc32-f464-c85a-d812-946d6b0ac734@intel.com>
Date:   Fri, 14 Apr 2023 17:18:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2 bpf 02/11] bpftool: define a local bpf_perf_link to fix
 accessing its fields
Content-Language: en-US
To:     =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>
CC:     Alexander Lobakin <alobakin@mailbox.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Maciej Fijalkowski" <maciej.fijalkowski@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220421003152.339542-1-alobakin@pm.me>
 <20220421003152.339542-3-alobakin@pm.me>
 <20230414095457.GG63923@kunlun.suse.cz>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230414095457.GG63923@kunlun.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::22) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BL1PR11MB5288:EE_
X-MS-Office365-Filtering-Correlation-Id: 4913d34b-8749-47a9-6788-08db3cfb8cb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H15MwBHiRy59/jHVf0taIR3vgIr9P6h48+W0BdMdc8kHMJnIlgiMjoP5yvf2Bw8rMos/vIbkoIFXccWJlbslOB6yA/rLoUilOdrH1xm0CH/jyDazta/AkAlxr+T+cfxDH5m/+hysTZedQaDNmQTML2IyVZJLSDwQwAg4y2U6lfmDXQ9GxH+1pN4W5hYDxEUGTml4SEJnEros/lNTfjx8St/wVmb3NQYyJP8zQWnRXnOgpZ6VfIife//f6qNlqVB+wohTqbaC4kwesaxtYZubIMKHYstomhzlEM8EzFvz+nmqgLi833AX/b89fYs+YQgJc+7Lijr0kLu77fW3Dq2qhlOj0Mhb9vsT3EZhtdAPQz+mAPo/0EW0UAgFUx+PeoUEwViVySYf4WqMA1xWPGDmpmYLPRpLkhX9xATceHEtu+UHQffqcs1yKwwt+PLbO/S7e9Bs4RVPNu0nZfSX8Gx6TYGFFhm0hVI3fX70S+VbarpyNPystrLJ88WMxPi5MjENa595PV6eW/hIjIqjdS2sOSW8FRjBRhs1hpFK+mLi7UgCnNUNVjezAN96w7TTdH4Wya4Yhrujm5lBzELmeDg/tl+SFt0jaid3nnCNCbochR/L3P+XcWGJ0oa+6D8f7OkXLckxuP7Q6vik8DZ7tNMfYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199021)(316002)(4326008)(38100700002)(6916009)(82960400001)(66556008)(66946007)(66476007)(66574015)(5660300002)(41300700001)(2616005)(6666004)(31686004)(36756003)(86362001)(31696002)(6486002)(54906003)(26005)(186003)(6512007)(6506007)(2906002)(83380400001)(7416002)(8676002)(8936002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHRTa0J4NktDV0VaRlh6bHFKSU9HKzVYdjhWWldZbTJ1a21XaDlNQ2NHNC9o?=
 =?utf-8?B?TE15WW05dGtBZmxVMTVxekZkSW9uVWNrMUdXRVRSRVB1Mjg5aU1pN21ocUtO?=
 =?utf-8?B?SThKRUVUYVk0SzBsZ3pURjJnamY0cWd2eU1wZDRsZjVjUUdVRUc1bS84REZP?=
 =?utf-8?B?NkVyY2JtVW9rbDRLYmUzbkFBUnE2aTNaQzJ6NmorT1k5N2trTS9MNWFNVjEy?=
 =?utf-8?B?cGEybk13Vkk5TG54QTg0dUhDYVo3Z1o2QTE1OHc0bGJSUXFING5pL0pQdzB6?=
 =?utf-8?B?TVRpUE00Q0twbHNNRUF6NTJVZHUyOEpsOStpOUtWK0ZiRFhDNkZZS0duc1JD?=
 =?utf-8?B?cWV6WEExZWFId2dGdjNiK3IzdUV1QXVyKzlaVSt6aGI0cldIQmJjU1piazha?=
 =?utf-8?B?UmgvcTJZSUVqSkVVTjdBRXAzQjI3c25xUzBpUmt4WHJlSmNiODVjamR2VDZm?=
 =?utf-8?B?VXhZdTJ0aVBYUXBqOStJeXg5TEo3RjhMSVhFWmp5YmRVYTR2Ui82aXNtQm1Z?=
 =?utf-8?B?dEZpaElWVVNiQkxSeVZGUCt3TFpUQ1NQQk15YXFaZDNZdklzS0dRS2tRT0to?=
 =?utf-8?B?RkRhamx2bnlvMk5uS2kyMFQxOWFiSkdWTExrcEF6c2hjVjFBVGVIRWphbE1V?=
 =?utf-8?B?MGFsdUVxcGpDWlU5c2ZjNUpFbVlKdUU0dEhiZ3FlbEhGdlRMQUx6dUowMDk4?=
 =?utf-8?B?K3ltVitHL1Iwd1c0STZ1dHF4QkVUeitFMDkvb1JoVlBTSWtvd0tHTFBObXFV?=
 =?utf-8?B?SVppcDFWWG9xUEZVcW45SzNCS2xieWo2Mkc3ejEvUUZrNEIrbVZ3NkpGRmx2?=
 =?utf-8?B?a3J1M1NDY01lRnhpK2VVVU55cFFrdXRnek10T3hRNWp1MGRqOGl4SlZwdmgw?=
 =?utf-8?B?L2Y3ZmNXTWZEYXl0WTBJa3h0NC9TZ3ZLdXFWSnFrcFZLaVNDZ0IzU3hLWHEr?=
 =?utf-8?B?R016enorUndNdVRBb1BhTzhiUDlQSVNmdWZKMzhNbFJNN2QxZnZoazh1Z0I3?=
 =?utf-8?B?YTFnOFdldlg4U1I3bU0xZitGdCszaElZWnFab3ZWUlZkWHEvRE9UTHJDSkV2?=
 =?utf-8?B?alZvWDlrVmE1TVRDNXJSUEFKbVVkMkF6U2g4dU9KM3ZjaWtkK1p2TFBBOHh5?=
 =?utf-8?B?Y0VpbE9BaVVRc1RRaEcyalJlS0c1NVNzUG9wZERhcEVrNkVTWkFvNEk0b1Zk?=
 =?utf-8?B?OUNEejlVSkRJYmxoTnQxSW5CeW8vZm9oS0lyWkZCajdRZ00zb1hVTnB6SUht?=
 =?utf-8?B?b1o4bWh2Y0Vlb0ZiWXA0TWZUL1dHT3RzV0dDSzllUHc3NEV4RGR0NGtjMllB?=
 =?utf-8?B?WjVzempqRDE5a21PVHU4Zk1ZcUJqaE1TZnFQRkUwb0lBKys3MWRjSWo2TEsy?=
 =?utf-8?B?SXNKdG5DakVwYTVYdzdnLzIzOXZHUFdzV3VYV1hNOCtqMDRGanJWMFIyY0g1?=
 =?utf-8?B?RlZTeTQxUHJ3aWZWZVloa2F4YU9wOXcvdG9qaDd1NUdsdXVDMThjWjR5ZUNm?=
 =?utf-8?B?cnhZRUIrSkV3SlozeHFhYnNVdTVLbk9NVEJVa2FQeGRQNmp2b1R4UXAxblUv?=
 =?utf-8?B?bkNyTHZzTnZSNHU0cTJxWldwUjJRTFNuZEtRTWxFZ2NZZFVrNit6dTNUUUY0?=
 =?utf-8?B?U2NDa0k3WmVvVndrRWJYSm1oSVJhS2twQTg1b2IxclpkZzdyTTd3VUIyMlQz?=
 =?utf-8?B?MU5heGxmMm0zSHFtWGovNDhSTGJxTjgzdWhRNGswTHpHb0VKMG92eUo2RUwx?=
 =?utf-8?B?VzJ3TU0rMU9UNGV5dWFLZlowRUJadDRBUkthbVlobFBicGcyVzVsenphQlN1?=
 =?utf-8?B?L2JUdURUYnh6TDRoTVpINmIycUhUU2RDYWRsUHM4RlJHbHAxRDRxalNHdmx1?=
 =?utf-8?B?T1ZCelBKaVByNEFldkh1TFdIUElTa2JtMS92cExqcVNzekd5L3ZEVm1ZSUZr?=
 =?utf-8?B?a0NkeGhEWUw5dTBVZDRObnpORys0alhzaEUwSWlXSmQ5bCtsdDBTblRIZ1Iz?=
 =?utf-8?B?Q2oybUhXMENTNFJLTTQ2N2lnS2c0dDAzV0EyQUVnSzkySTM1Uk5ReUpybGd0?=
 =?utf-8?B?bklvVnFGenp1QnozNWs1a3ZqMVV0dThKcnRhYlMzOUxsOHRsU2VCUFBrRVk0?=
 =?utf-8?B?aEMrNFM4T2Mxd3FxcEV5dGdZNnBlU3NQWkpOVUpvbWlIancrNDNodjMxUkJF?=
 =?utf-8?B?TGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4913d34b-8749-47a9-6788-08db3cfb8cb8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 15:18:50.1086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yXlHJ7yRbFnrxZ/ALYETRyrMluwWPyZun0zlxPmrlwshSwSWcXyCUAd+/d9+dCFfl4L7+pjsCPw6XaawJjfTz5u/VJBsl7y6GYGrhN2ZmBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5288
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Suchánek <msuchanek@suse.de>
Date: Fri, 14 Apr 2023 11:54:57 +0200

> Hello,

Hey-hey,

> 
> On Thu, Apr 21, 2022 at 12:38:58AM +0000, Alexander Lobakin wrote:
>> When building bpftool with !CONFIG_PERF_EVENTS:
>>
>> skeleton/pid_iter.bpf.c:47:14: error: incomplete definition of type 'struct bpf_perf_link'
>>         perf_link = container_of(link, struct bpf_perf_link, link);
>>                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:74:22: note: expanded from macro 'container_of'
>>                 ((type *)(__mptr - offsetof(type, member)));    \
>>                                    ^~~~~~~~~~~~~~~~~~~~~~
>> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:68:60: note: expanded from macro 'offsetof'
>>  #define offsetof(TYPE, MEMBER)  ((unsigned long)&((TYPE *)0)->MEMBER)
>>                                                   ~~~~~~~~~~~^
>> skeleton/pid_iter.bpf.c:44:9: note: forward declaration of 'struct bpf_perf_link'
>>         struct bpf_perf_link *perf_link;
>>                ^
>>
>> &bpf_perf_link is being defined and used only under the ifdef.
>> Define struct bpf_perf_link___local with the `preserve_access_index`
>> attribute inside the pid_iter BPF prog to allow compiling on any
>> configs. CO-RE will substitute it with the real struct bpf_perf_link
>> accesses later on.
>> container_of() is not CO-REd, but it is a noop for
>> bpf_perf_link <-> bpf_link and the local copy is a full mirror of
>> the original structure.
>>
>> Fixes: cbdaf71f7e65 ("bpftool: Add bpf_cookie to link output")
> 
> This does not solve the problem completely. Kernels that don't have
> CONFIG_PERF_EVENTS in the first place are also missing the enum value
> BPF_LINK_TYPE_PERF_EVENT which is used as the condition for handling the
> cookie.

Sorry, I haven't been working with my home/private stuff for more than a
year already. I may get back to it some day when I'm tired of Lua (curse
words, sorry :D), but for now the series is "a bit" abandoned.
I think there was alternative solution proposed there, which promised to
be more flexible. But IIRC it also doesn't touch the enum (was it added
recently? Because it was building just fine a year ago on config without
perf events).

> 
> Thanks
> 
> Michal
> 
Thanks,
Olek
