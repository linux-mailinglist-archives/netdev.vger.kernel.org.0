Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9721691F24
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 13:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbjBJMaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 07:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbjBJMaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 07:30:06 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB5E14226;
        Fri, 10 Feb 2023 04:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676032205; x=1707568205;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cuO/ASnJ8peHB5fSRwkxe5bwzXli7pBk0Eq8LS1cKWM=;
  b=bwwXfo6jdZYPThSQNmwuorO0EqV+sDKjp+2+0FDp6iOLYJyxE+Hc3EnB
   Dib/f3kdE9nUld8sFqLqCobrtu9y9+XEyGhBEbToIoSPM0ngUzifZhI4O
   nvKyMzI8H/TdL74316lpvv8lgG2REnIOHmtOcTQKS75MZcV15wnWVmQv8
   cOLbrsvTIRE/8S2V4ZgZ3Mbd5CqDKVMVvQDcBvdLTpKzdys2Cg8+esPKb
   oO6Ovf7DoK0cFaSWwS6SkKBTABcmvGcf/nr2GlXgUXBzb89fwjwr0hWBx
   2qkxqJ3Mv/uPhRxWCWG+AGcjPrMUlnv3hlb//YjlymL+9cjXK+Ubi9XXR
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="318423613"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="318423613"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 04:30:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="776901003"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="776901003"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 10 Feb 2023 04:30:04 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 04:30:03 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 10 Feb 2023 04:30:03 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 10 Feb 2023 04:30:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KjX9RArxre0H/cU6JG1pEt8gStCRBaMgSh9NDKbH251EuG1tMxbcaVKRsOJp1HxxaiiaWva4vFMurwfRFf6t2ghOY+ZEg31Om9I/8zjh4ckssEDkG92A8T0yBejr/Ik9F6Y5fs+yKTeUMH/xQKNzgOleH+QBhBqYfYR4f7wwKtQmlrt/MoG1qEK9lB3LWMvQ+tbym6XAoO1bezKJYdh30kI5CX3A368KbG8iEl3aYUmZix+unY79sSldSTngxA/7izs38eM/P5AlDXXnBMrzXLEdMlyv3fjDvAMniLYKiiSfsWkh7UXSFYZXujGtb2NYEfBLsGxTx0r0wRbETcbvtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zjFfaWwSlajmQYj2OzYGln5WYpiynONnXGI4rbreuIw=;
 b=F3ZwZ6YYTH0O5sPkHp2ye4h5lKgJwOaDISECIjXh8eh7Cc89uQDfXjsqcSsvjuz/DyiKOIyAwvRsNgZ8toXmrhkTAHEFr0tv37X9BmgrJNi+4KiDQxFCTkIn4GTnDr7flsET+/qVcHbwTmVPnnGdnalrhi9KAVScGU/+ABi5IkX+5wxY7nCEBax45byi9lY+Xq3eZv97OGvs8M1zXlf22U9fz9U8c7MBajKni3XgWiN35WzG3y/eSIgZFIcbmqCH14hpQLHPvu72unJbU3GOVyUYfnctOGuHEdPkaJJ+W9in+I/DEZkONCyqCuv39K5SNR4nZiIY4i9L5LizX7ElMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3624.namprd11.prod.outlook.com (2603:10b6:a03:b1::33)
 by IA1PR11MB7920.namprd11.prod.outlook.com (2603:10b6:208:3fc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 12:30:00 +0000
Received: from BYAPR11MB3624.namprd11.prod.outlook.com
 ([fe80::e816:b8cb:7857:4ed9]) by BYAPR11MB3624.namprd11.prod.outlook.com
 ([fe80::e816:b8cb:7857:4ed9%4]) with mapi id 15.20.6064.036; Fri, 10 Feb 2023
 12:30:00 +0000
Message-ID: <8d3a9feb-9ee5-4a49-330a-9a475e459228@intel.com>
Date:   Fri, 10 Feb 2023 13:29:21 +0100
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
 <87v8ka7gh5.fsf@toke.dk>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <87v8ka7gh5.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0076.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::14) To BYAPR11MB3624.namprd11.prod.outlook.com
 (2603:10b6:a03:b1::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3624:EE_|IA1PR11MB7920:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c80ba93-d604-44c8-b08e-08db0b628682
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3SLD7MMKbLfdgwcOpOQha1PlIAh87k0iGBAtEAl2IpJ6U5LeM9EJnsRYJygs0tQy8QTPlUIAoH/GqntrQob995amd9+wGdXhzA4D90VtQk20/+8CAzPUrSq4Y2zSpL8Z2Z9fbbsym6yVKR3ybQQ1XyxNlbBjefhJkaxc4O9hBmSAz9Bo32sPboatn9/Iy1TEZkEn+5UaIjcgnvzscJ5sFH5rFlGHZ3/Bpqy60nEJVpeBrUs/zKrKQ0xZIUNf84tRrqUWQq54UPdlNEJzpUp9ckr3GFBYvNr2H47612mHELfVx640oMC1LNWNlT/+DaoS3vVo1gL0WAOmZaMNpwMAd8sriqiqud/CV+TPJoO7MpBV+aOeKhYEOKCmxqzDP5XTGtRRETX5ta+fH4smavN7QzA6FO8ps8ZN7nHLS0Nw/g0cv6+cPnbqtX6ROd1NIJESpOliTvfsSOkrAruQSft3NO9cylwBcjt72sS2GovndVFGQoHORoQhUoGggxOxmNRM1tuNGtV69TdB6tUS4vciBT+55TeL4lqdv+afM0I3m1uRfh5+5UoVz3DiDQd9mN94unlQGq6ShmNBIf7g7zdjjnx/Gca5PlyCqfNV++57u0rdhtzzT1yxopED6m3/k8M4L9EDSyZDoqC2BcAwEPOL7Rw0yClaunAzEULuawAV8mix0Dzdho898s/8z16L80pnjHRHnO5plbhsx3P3jaHSvZyWq4IyeyuOdG1F6Pm7HcI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3624.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199018)(38100700002)(82960400001)(5660300002)(41300700001)(8936002)(7416002)(54906003)(4326008)(6916009)(86362001)(66946007)(8676002)(66556008)(66476007)(2616005)(31696002)(6506007)(478600001)(26005)(186003)(6512007)(6666004)(6486002)(316002)(2906002)(36756003)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TlZUaktZM3NEQS9PdkNuUDNYY2NvSSszdjZod21tdHhPdmhiSFphQWdZc1J4?=
 =?utf-8?B?OTY0QjM1cWZHeWtUYmhKbDdNVU9hK20zQk5WbGhlT0I3TkJ0REF0RUtSSDR2?=
 =?utf-8?B?ZkkxTnNTQWRoZS9tRjdVNVJ0VXgxdzkzSk5IbkRSeS9mQTRrR3k3Vms2ZkZ6?=
 =?utf-8?B?TzZQWVQwVEtPYmowTlBqOEhxcVYrU1pQMGczSXdhbEJmNFJkMW1ZaC8yNlh6?=
 =?utf-8?B?ZFJlQkp1TWlxUEZYbjhmWnEwVXZJWnFBeDZaWWh5UDJSRGFrU2srMy9vT3JJ?=
 =?utf-8?B?TDdDNG5TdEVBVXVFTThwVGkzYUpmYzVRckI1VHl4N1NaNEx3N3ZjSGdINkhr?=
 =?utf-8?B?TVhucmE3VTR3ZzJ2V1M0SHNQVHQ1VkFEaU9LcTRnaHBUcjdoYU1uUC9qblFX?=
 =?utf-8?B?TDdJY28zWUZ5L01lM1cvSHVkNlB0TnhuK0pTa3h1ellUM3JZNHY0aG1TY2xJ?=
 =?utf-8?B?a3hScWZRWDZ0VHVXRTIySUpGdW9wd21wM1VDZlNucWxnU0htck1RQld0UUl4?=
 =?utf-8?B?LzV4eldDelVjS0FocmNWeWZMREFvd0Y1TUt1VFpoVGdIRTFnYkVsSkowWmw2?=
 =?utf-8?B?MUNPTW9aTGRVcDRlZnAyVkdyNnBaQkNOQTRaR0Z4SUs5UmxsZjdOV2dBOGF1?=
 =?utf-8?B?OG5tVHAxc0lmOERqQS9vbHhjdXk1NG5KUVhrZlFvWEVVZDk2WDZJMVRZY3E2?=
 =?utf-8?B?elNJZkMwQUZZb1d4MGJrQ0hVdS9xQmFxZ2RWQ0xOd2NUbk9STytCNGxtZEZB?=
 =?utf-8?B?SytDcWtIT3ZOT3ZCRlFOdlg4UHJrRnRFSGNMbGpCY3NZSlpIK1VGRllVa1c1?=
 =?utf-8?B?S2VjSkpDd3BHNzJSamhGOWJEeVZKVDM1M2RnV250endnNGFqbFpSU3RNam02?=
 =?utf-8?B?M1pkWURSclZDd25LRy9FNFlJcEJZcTF1WDkwNDFSbisvRUdHRWlDOWEySkFR?=
 =?utf-8?B?cC9VL1hHby9IZW55clpmV2pWbDUzZW96UndwaGRNUTR3V2FxY3lGbWtydUdX?=
 =?utf-8?B?RmpxaHFUdzhEa0hnVHdsYjNpM3R4d3gvNmh0ZTljaEI2MkcyRExaVjVENEhi?=
 =?utf-8?B?Nnpha3ZUZi9NRGgzemtmMVJFSUtDd2RnOWY4QXRRY0hDME9qb3RGTjYrU0s4?=
 =?utf-8?B?bEpHSHY0Q1ZzeEZSQmpHaHRSSENzcEhWYTNFSW1vNzFBbEpsYzV6WWNBOVM4?=
 =?utf-8?B?UFFiUlZBdFE2RTkrdkdIM1p6amg1NHFmVUNQTUNXdDhYeHFYNE5FUFA2OW5o?=
 =?utf-8?B?Y0pjVDFSdk16cTZFTlhtMHZoWTRPNWU1aC9QbTdhbkhBbnNmenhHSEM4TFNh?=
 =?utf-8?B?aTdkL3pFc0V6eVJTZGtkOTdlczVOQWR2UnZQN21JeXpQYlZJYzBiRXRaYlJy?=
 =?utf-8?B?bDVWRkxEd1lna1BrMDB5NU44US9GRXdNMWtLdWMzUXNkZUNUNDR2WnJSWDdi?=
 =?utf-8?B?cTRPdVN1MzJYUHdkQmlUY1ZaWTkyQTdJSlRpR2thSmRqbnJyTTd0dElnSi9D?=
 =?utf-8?B?OGt0TDlYVmFqOG9lSGlJUFJuRkhwOFh2VUtIZXNYS0ZJTUUxT2w1YnFDUHpG?=
 =?utf-8?B?YUtieHFyZ1hqLzVHODF3MG1XNFp3WW9ac1VCeG9BcWRyT0tpS0dQMno5Uk1p?=
 =?utf-8?B?WXA2VUFJZ29tV29KSU55TnFOcmx0SFR1Qk42eGRtbkI4dk5RbUp4N2FTNVpi?=
 =?utf-8?B?cExCdFJ3RGYrc0tkakZ6MnhJa25Cb2xjSW1VMDZKbmFqK1I3RnRhQXFrVlAv?=
 =?utf-8?B?VUltcFZyblF6RU1CQnJ1V0owVGIvQjR6UGpqZDhnanBoN1RYc0ZvV1Nxcmlz?=
 =?utf-8?B?dEx0dnR5MVl5Y0IyRjVnbmI2QVE3R1VqOXdJeTF1K2ExR3dZV3Y5cGFIVU44?=
 =?utf-8?B?dHVYM09Bei9PRlk0QzFhZ0ppZW5jZWg0RDhJaDBkODZEdTJOeGNNbzJhMmhj?=
 =?utf-8?B?MGxCdGg0MnlqVHFXQkxxakxGZmN5MWZQYnBrbnhKZEkxNjF6MGFMMUVqeTZX?=
 =?utf-8?B?WXRYV21rU0ErS3J0aFphNVZBMGozcno3T29zdzZ3SVRXb3dYYXU5eXRxVEhG?=
 =?utf-8?B?SXlGcDBTVXFOSm1SR2NoR01RRngzSHZpY3QvbTZTSzRrc3hIcnA3Qm5nM0hn?=
 =?utf-8?B?M3VrU1l6MFArMkxKSVFveUR5NG5JRHVKZVVXLzM5WHB0UTRZU0tNNkxvUXpp?=
 =?utf-8?B?Nmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c80ba93-d604-44c8-b08e-08db0b628682
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3624.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 12:30:00.0406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ljf1335uN0nXKbuVsRl/oDCKaY9dEhxWqbRqpReOsJ5V/k+rxDWauQ/qVlozagbDiZhlOaBP+CxQ7Oue5sYaC52SfgDS5Zci4jIasKVA1eg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7920
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Thu, 09 Feb 2023 21:04:38 +0100

> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
> 
>> &xdp_buff and &xdp_frame are bound in a way that
>>
>> xdp_buff->data_hard_start == xdp_frame
>>
>> It's always the case and e.g. xdp_convert_buff_to_frame() relies on
>> this.
>> IOW, the following:
>>
>> 	for (u32 i = 0; i < 0xdead; i++) {
>> 		xdpf = xdp_convert_buff_to_frame(&xdp);
>> 		xdp_convert_frame_to_buff(xdpf, &xdp);
>> 	}
>>
>> shouldn't ever modify @xdpf's contents or the pointer itself.
>> However, "live packet" code wrongly treats &xdp_frame as part of its
>> context placed *before* the data_hard_start. With such flow,
>> data_hard_start is sizeof(*xdpf) off to the right and no longer points
>> to the XDP frame.
> 
> Oh, nice find!
> 
>> Instead of replacing `sizeof(ctx)` with `offsetof(ctx, xdpf)` in several
>> places and praying that there are no more miscalcs left somewhere in the
>> code, unionize ::frm with ::data in a flex array, so that both starts
>> pointing to the actual data_hard_start and the XDP frame actually starts
>> being a part of it, i.e. a part of the headroom, not the context.
>> A nice side effect is that the maximum frame size for this mode gets
>> increased by 40 bytes, as xdp_buff::frame_sz includes everything from
>> data_hard_start (-> includes xdpf already) to the end of XDP/skb shared
>> info.
> 
> I like the union approach, however...
> 
>> (was found while testing XDP traffic generator on ice, which calls
>>  xdp_convert_frame_to_buff() for each XDP frame)
>>
>> Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in BPF_PROG_RUN")
>> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
>> ---
>>  net/bpf/test_run.c | 13 ++++++++-----
>>  1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
>> index 2723623429ac..c3cce7a8d47d 100644
>> --- a/net/bpf/test_run.c
>> +++ b/net/bpf/test_run.c
>> @@ -97,8 +97,11 @@ static bool bpf_test_timer_continue(struct bpf_test_timer *t, int iterations,
>>  struct xdp_page_head {
>>  	struct xdp_buff orig_ctx;
>>  	struct xdp_buff ctx;
>> -	struct xdp_frame frm;
>> -	u8 data[];
>> +	union {
>> +		/* ::data_hard_start starts here */
>> +		DECLARE_FLEX_ARRAY(struct xdp_frame, frm);
>> +		DECLARE_FLEX_ARRAY(u8, data);
>> +	};
> 
> ...why does the xdp_frame need to be a flex array? Shouldn't this just be:
> 
>  +	union {
>  +		/* ::data_hard_start starts here */
>  +		struct xdp_frame frm;
>  +		DECLARE_FLEX_ARRAY(u8, data);
>  +	};
> 
> which would also get rid of the other three hunks of the patch?

That was my first thought. However, as I mentioned in between the lines
in the commitmsg, this doesn't decrease the sizeof(ctx), so we'd have to
replace those sizeofs with offsetof() in a couple places (-> the patch
length would be the same). So I went this way to declare that frm
doesn't belong to ctx but to the headroom.
I'm fine either way tho, so up to you guys.

> 
> -Toke
> 
Thanks,
Olek
