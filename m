Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92EE969684A
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 16:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbjBNPkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 10:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjBNPkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 10:40:43 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C8A2916F;
        Tue, 14 Feb 2023 07:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676389241; x=1707925241;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jYy3Ab5wh4e/I292RbRqI7qmpR8Y74jEqxsWNAvNOrw=;
  b=cjNamBnyvWUuvgDSOrpe3zLchrFaQr01T7XXBCzDa8wXsQKU4+qy3m4w
   XkxN44z6f0HWVhcmPiIniAEvIiFqf0XAMfpF1H8ECMtCCZY5OhrSHL2Mu
   cwpKXz+Bj4CfIIjx+Bz4B0yBwrAhwEEJKSURgFd9afg4yDF9yHjqwEpov
   kPIX3L3eOu3GcVXkgku0J+Cp1f7lK1eXvFHVtUZ0B42AsUFpV2uo2Wfsp
   b2NQHOAI2/L2DK3GlvN9SqDZVAVLjWA0YmN6G5k4zFFsZrkB+MAWvul68
   o/1C/0QBthItYDO9AIkQtS9KXBpR54hpex44IoZy3tPUonitnMrM5WJwC
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="314835249"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="314835249"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 07:40:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="812076315"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="812076315"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 14 Feb 2023 07:40:41 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 07:40:40 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 07:40:40 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 07:40:40 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 07:40:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QITiOk4kPdkPV5rBAMo7kMM4rYZvD4yEDPCn5TgPFbEYAs6W4OQvWUJm5/vysUqfQWYyKL6NYXn5EiJHIf2v3TroxKGHku4rfds2Acb3cO6lzutG7d1ghfnUHL0xIdfcIKe4bhISgDwRs1vijXJjEZfHsTmyEPNAMgT1IIWv1+SiS9flF9QG2ujScSfli61wogZ6Q2UkHmyFdEnuOQ6zvg1r9hNl81fbhIME4F2yj3KJ/1V4UyBuDh5Cn2IkB/mGxIlewnjVJkLQklSKDNdHjAJGVHTp6hY2I+v/ba7HuVreihAoQswOVr/GyOmrLpHxk+VlAHsbBwY+5w4CfEbmag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mAl2At5s9GmvE2uubSb8kGee8cpYo3uuoEFadP1PmlY=;
 b=f7McxvGgE8A5cLkT5NtLsqCmoaDMKSR/NT5F4R64m49KLqHIZbw1MTDhmTcHuovsJWOR3Qjy0Dwadyv+o6ZairINStfGRcg0MCFxFeNBaPhVuD4i9XgBEqHGW3RavkCqQ5TyhoIx+Mi2mFL0mXx2f/hj8UyXYILZ3UenpsTopzsDmkHNWny+/318yE/HUJTWu/qBuD4vL/MX+7LFhDLl5BY+XWfConh0Uvl48sEqMCmbj+eM2u2EDErLkn1oZOm7yszQKbO49hhJl3BmdTtfDhhiPCmZSvRnsE5S6/+pX6Vautdgd6ZQ7I7zjXVd9RUs7zAebXcs+dAw80LrZv5lDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH7PR11MB6697.namprd11.prod.outlook.com (2603:10b6:510:1ab::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Tue, 14 Feb
 2023 15:40:38 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 15:40:37 +0000
Message-ID: <6823f918-7b6c-7349-abb7-7bfb5c7600c2@intel.com>
Date:   Tue, 14 Feb 2023 16:39:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 bpf] bpf, test_run: fix &xdp_frame misplacement for
 LIVE_FRAMES
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "Martin KaFai Lau" <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230213142747.3225479-1-alexandr.lobakin@intel.com>
 <8fffeae7-06a7-158e-e494-c17f4fdc689f@iogearbox.net>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <8fffeae7-06a7-158e-e494-c17f4fdc689f@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0150.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::19) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH7PR11MB6697:EE_
X-MS-Office365-Filtering-Correlation-Id: aff367d6-e4b6-4d8f-5701-08db0ea1d17b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +eOuAv4UZE2GbQ+Br7YCl86d8vw6i3hQsczXBAr37U2I7+ihQhZ+S7ZA9NNtNzpSZzdpGAl7ItCRtbcOIHNEU3O+jWC91knpEDiEN/ewNrNMq6YQ+rxLBC3xIKqXu3ozc9oKvUTSSEVFYpWVr2aPthlhS6vcafJnVyS6g9YZl3GNdHkf1h06TnOgme5ksl9BppU7okawCINqY98loZGBVBOAAxwpb0bjPpaqxgYnRN9fS3RvtlhTz9W1RSssYiHXLLg0U6Mgofgr9WPXmMda40RFrUOVeuLaO5qMo/b9meRXE2csqys5PFwNcOLQtpNSuhRI9qMnFWmTMyfmO2f7rUHox81334C+Kh1SaiaOsHIsQhcC//J0Hn8A2wU5/G04oRqoQuW7vambND+dUBOwfAyVOTUsP9KWmioeGDXKT+DrCoNoo+d7QhTOv4PMtfQQ1xcHUxV5WQZByuCFpzSosRtCl60aPOkqwdvMADQoX2Q0hn79q4cyY6ufPNtfmzVUKdjvd0XI4rchEtO+rxtqOLRp/8Oc85KdXKSgO37yjJ1oaq1eeyMEPsxdYki5U1LGAm8U44PVfCsFsjm9PT6CmOZFhhAmTjPidLovSDxZLgav04GvvRJb3XPVo7DbLkN5o7eTH88fb1DGTmmjLFv5hZ6ch+hqW+fKTN0ckxyqiQGVixJv+xiFT/EFtGN4/k5Fn8aSHMpjdUhYBq8RE+m/tA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(376002)(136003)(39860400002)(396003)(451199018)(8936002)(5660300002)(6916009)(7416002)(316002)(2906002)(54906003)(41300700001)(2616005)(4326008)(66556008)(8676002)(66946007)(66476007)(38100700002)(966005)(36756003)(82960400001)(6506007)(6512007)(86362001)(31686004)(53546011)(6666004)(186003)(31696002)(478600001)(6486002)(83380400001)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXJNbVNCa3lMNXUyVnFIOCtKSDd2Vng4d3lYZkk0U2g2SlNQbnorWm9EbFBw?=
 =?utf-8?B?eXhCZHljVVZpN29UUFVFZjZza1pXTElOZVhZaURwaTd2dkFUTTU4UEJyNXpa?=
 =?utf-8?B?eURjUk1uMXd0TXlCaFF1VnFmS20vcUtMUUk1d21JZlA3MjhrM2N2TDk2ZjVR?=
 =?utf-8?B?dm9wU3B0RE9CQ0NqVG1LeXVxUFVpRW5HTlEvMyt6U0NsZXdLeVhhemF2UlhH?=
 =?utf-8?B?TnpnaGppb0FPR0c1SkNzZ1laS2JScEFVUTJoK3dUaTZGMm5ac3M4WEZ2NVZF?=
 =?utf-8?B?Rk9ZcDhLbFA4RHZabUV3ZmF6L1pWRHU0ZUUwZ05KbVo4bjBvRGtidjNKcjJ1?=
 =?utf-8?B?NEJLakkvbWxOQ1grVlVhUUxIczZ2L1hoNUQxclJKQ2NKSHd3OG1EbWcvdEtC?=
 =?utf-8?B?WlFla3kzenhDQU5MRVpVSDVIMnorbDVxTlpZVVJRdjNoL2lqY2Z0VjZ3Z09D?=
 =?utf-8?B?ZXJJSzlaODBtZUlEMS82Q0RMV2xZQzd5Q09NanUwMnd0U2QwV2kycHcwWTBh?=
 =?utf-8?B?TEljWHhYYjJNNGt6bk5VM294UHlUaG05dnd3ZEpyUmFDYnd0MG5SSXI2V05K?=
 =?utf-8?B?TUl2QjA2eTcwemUzR29hUVVLWDQyT3NhMjNnWEpyY2xVY3pqNEt6bVp4TDB0?=
 =?utf-8?B?VitHMHkzSGl3WFNJZVVHZzMwbWpZakp1a2ZMeTBJWjE2Mk1NNXNBS25TWWRK?=
 =?utf-8?B?ZlgzcHZvUXpwVHE4RVVvaEdibnVqTTk0SzdoMTVLeVkwRnBQMjBucnMvekgr?=
 =?utf-8?B?VkgwM2ZwWEltaDhMUDhxVGxTQlhtWkdqdXNPZzFRSVVGYXZXZ28zMkR4THpY?=
 =?utf-8?B?dDBBVEZLS3RhRndhQUEvazc5YjdjeXZUb1h0THNwbG50VjNkcWJKV2xxbWN3?=
 =?utf-8?B?UGtUc3kvN3Ewa005NUErNjQ0UjloZkU4cVFhK2g5NHYyWXM1clgrY0QyQ3VF?=
 =?utf-8?B?REJMbllIZzFta0JZZzVJR1ZzVVBTUFBtaENMWjNYYXVFcVlzQnN6YnY1L1Vi?=
 =?utf-8?B?ZU9JdEJWZkNUSXFPbWtNbGxwZUNWWEdyK0RDS0dQazFEZVAyTTZ1Sy9RYm9F?=
 =?utf-8?B?S1hUYzhhcVdzUitMWGpzdnR4bzFqT3Vjd0lVa01yR3BsTE93K2kzUUlsMVh2?=
 =?utf-8?B?NU1kZGlDUndRY21DWFhQa3IxaGNMNmtWR1dJZktSQzRnWm9CV0VNemtZZStX?=
 =?utf-8?B?aGdrSG5Gd1ZKNnhlOGNCRk15OG5EbXRGLy9zTzc5eVl4UUNEQUdOWStiOEtZ?=
 =?utf-8?B?VFlzYmtMODFsM3NtOVNESHJJT2ZXYVdLaVVtZDA5WGFpRTZqcUF0L2FpbkJ3?=
 =?utf-8?B?a09vVngvR3JMMmwrVWJEb3lWai9YSjdLUDRRdG9Wc2w0K2FSSXZoN3VTb285?=
 =?utf-8?B?ekhMMkhidkwyd2YrdHlNRUdKejJaOTZPQXVxdWh2T2JhcXBESThOVzFvMWZL?=
 =?utf-8?B?YTNVUW5KaGpCWi9ySC9GdFlCaUdUSDVxVlpQSTNmOXluRHN2ZDl3NE9PbXY3?=
 =?utf-8?B?SEFERUtpMTFyWUtJRWIwamRHTExhRkx0WTRaUW1Yc291SXQ1SVdHZGlJUnhL?=
 =?utf-8?B?U2JOcjVuUW5wcGhxZG5YMTQvVXRXNXI3TDRQWTl1V3ZvMFRhWDgvZFg5cXFM?=
 =?utf-8?B?S1BBSmRQNm9zL2VwQzFjb1pTaTFEMldpZ1R3NHBtcnliTmRQWUpqMCtxNStS?=
 =?utf-8?B?Y2FJTkNFNENQWjYybGoyemNBM0lZaW00VlFlNnBsNDJTZVlMMWFaMjdZbU1x?=
 =?utf-8?B?cDRLNGlyUzRJN2gybjJISFVXeThrZ2FNMzd1WFNLNmFxenVtTVlvTTlIbXNw?=
 =?utf-8?B?WnhXMDJUUFlxOFFtTUUvMXRQRHB0a1JCV2V2VEpBODBiaFVlUTFRUFJBOFo5?=
 =?utf-8?B?TFFEVld0T1FPbjgyTjJPNW1IR20wQjdWUHdPU2xqYWV4L2RPL040T1BTT0Z0?=
 =?utf-8?B?bG5lcFllZkNZNVpnbForS0tNaDdXd004WE5lTTdvVXV3OUhXc2pOZzJsOVVK?=
 =?utf-8?B?MmgxUjlDNzR5U2haVE9IQWk3ZmJUVjNwZDV0eHNSR09YZ0lVQWlHOS8yZ1Nx?=
 =?utf-8?B?Y2JPN1EzNWZKLzBTMEFBMmJwdU1JRVRIQWZlb2dlYVh2WERoZGZqUklXWVJt?=
 =?utf-8?B?cUE1WmNRM3NzSlZJaVZHUHNqemJqNW13UG8yT0RXT2I3MFN4Um12cXAzZmww?=
 =?utf-8?B?dHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aff367d6-e4b6-4d8f-5701-08db0ea1d17b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 15:40:37.2758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0eKMh0e1mkq6L2bOt92LYmC84p/Y1HAHBYgWh0wurIWnXlSQ04SSrW6G03AcrgKLZ0RebAm0g1DY7kphZ+hUrA9fyl3TwHU00cLJuEkt0os=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6697
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Tue, 14 Feb 2023 16:24:10 +0100

> On 2/13/23 3:27 PM, Alexander Lobakin wrote:
>> &xdp_buff and &xdp_frame are bound in a way that
>>
>> xdp_buff->data_hard_start == xdp_frame
>>
>> It's always the case and e.g. xdp_convert_buff_to_frame() relies on
>> this.
>> IOW, the following:
>>
>>     for (u32 i = 0; i < 0xdead; i++) {
>>         xdpf = xdp_convert_buff_to_frame(&xdp);
>>         xdp_convert_frame_to_buff(xdpf, &xdp);
>>     }
>>
>> shouldn't ever modify @xdpf's contents or the pointer itself.
>> However, "live packet" code wrongly treats &xdp_frame as part of its
>> context placed *before* the data_hard_start. With such flow,
>> data_hard_start is sizeof(*xdpf) off to the right and no longer points
>> to the XDP frame.
>>
>> Instead of replacing `sizeof(ctx)` with `offsetof(ctx, xdpf)` in several
>> places and praying that there are no more miscalcs left somewhere in the
>> code, unionize ::frm with ::data in a flex array, so that both starts
>> pointing to the actual data_hard_start and the XDP frame actually starts
>> being a part of it, i.e. a part of the headroom, not the context.
>> A nice side effect is that the maximum frame size for this mode gets
>> increased by 40 bytes, as xdp_buff::frame_sz includes everything from
>> data_hard_start (-> includes xdpf already) to the end of XDP/skb shared
>> info.
>>
>> Minor: align `&head->data` with how `head->frm` is assigned for
>> consistency.
>> Minor #2: rename 'frm' to 'frame' in &xdp_page_head while at it for
>> clarity.
>>
>> (was found while testing XDP traffic generator on ice, which calls
>>   xdp_convert_frame_to_buff() for each XDP frame)
>>
>> Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in
>> BPF_PROG_RUN")
>> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> 
> Could you double check BPF CI? Looks like a number of XDP related tests
> are failing on your patch which I'm not seeing on other patches where runs
> are green, for example test_progs on several archs report the below:
> 
> https://github.com/kernel-patches/bpf/actions/runs/4164593416/jobs/7207290499
> 
>   [...]
>   test_xdp_do_redirect:PASS:prog_run 0 nsec
>   test_xdp_do_redirect:PASS:pkt_count_xdp 0 nsec
>   test_xdp_do_redirect:PASS:pkt_count_zero 0 nsec
>   test_xdp_do_redirect:PASS:pkt_count_tc 0 nsec
>   test_max_pkt_size:PASS:prog_run_max_size 0 nsec
>   test_max_pkt_size:FAIL:prog_run_too_big unexpected prog_run_too_big:
> actual -28 != expected -22
>   close_netns:PASS:setns 0 nsec
>   #275     xdp_do_redirect:FAIL
>   Summary: 273/1581 PASSED, 21 SKIPPED, 2 FAILED
Ah I see. xdp_do_redirect.c test defines:

/* The maximum permissible size is: PAGE_SIZE -
 * sizeof(struct xdp_page_head) - sizeof(struct skb_shared_info) -
 * XDP_PACKET_HEADROOM = 3368 bytes
 */
#define MAX_PKT_SIZE 3368

This needs to be updated as it now became bigger. The test checks that
this size passes and size + 1 fails, but now it doesn't.
Will send v3 in a couple minutes.

Thanks,
Olek
