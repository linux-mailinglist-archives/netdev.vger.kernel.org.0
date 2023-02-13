Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61006948EA
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 15:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjBMOyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 09:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjBMOyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 09:54:17 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D00559E7;
        Mon, 13 Feb 2023 06:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676300056; x=1707836056;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AFmYPRpZ1KlAkmuoPtwVL6FMQNRUw/2swhmbEWJhW6w=;
  b=iKb9uEv6IKVU/3TZXjRBIB9IVYAwJmjBP+zTj182GhXD6XzehzRTLbzZ
   KdFzQUVyVvsRY7IjozdY6KMVzpmi7HwS6rf8S8P04XsuEbSi2UXhnYYtK
   X05lvhDredRNDopO020uECsgepM9Q4xLSUSiV96Dt7ZuPsmjQtBd39PHG
   1U4StW4ckGUxgc8lwC1QiRRv+v+deeJC2VuGCbc8xgs+tpKlZM7vH5gZ2
   4D7eXd74Ti+J80C0X49tGombTiA8ktwbGbo97mYI412q7pCWrjBNGPqGE
   GeVAeRuMCtwXZoEQCRPe56EasiEHvWGXcFpHGdaLVhlxkZcqdZK4ppQ3c
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="393303688"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="393303688"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 06:54:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="792751966"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="792751966"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 13 Feb 2023 06:54:11 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 06:54:11 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 06:54:10 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 06:54:10 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 06:54:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MsWcWiBkOtqUs+F1+pmyBJsc8N8qtR+Bi4qiK/yzLN4JgvN9/s+VAspkA+AGNsYuUcTruNa4o/AFk8Qn/vR+SvHdRcbROZKfjrskwEsN3TxRmKuCkcHbtgndOCyuislBojCZJPUyeIOlYx9rgVCndk08HvV5cp+VDYNnv/YlpZqenPSxTN4x355aw5/Zs2BXD1M4EcSKc+bttIWDjy/w+MUYQXLe2i72VF48/cHUmGqkdiZBglhyYyxUKTGaFf4uXD5qqf1lMtrnuEhQwA1vzMtJfAHnueplRumxBZwGAvcy/6crCPWydwuaHqwmwEnHiqXwzoC4bn8+ZGgKPW5dVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XJUu6bynHiwZZIh1jzC36o9WJpH3t0caZb7oNryEXQ4=;
 b=iblmTxXhC7nHZgUEh5rwkefYksE8cd2xvQKCy6mGG57Kt2enbCgCYR/MQ92DTZSQ8RIEb6T4G69Pst5WVVz+CNMEu7gjf1vpQ3ggazg6/C5RZNNe/9D4Ojy58KaG7xIAwNvElgO/GDvSbLgHG3JAr9lGFxpEvxlG2O6OCSsYRW1e8guKKNCOQOQLwyCBlYMkukqJb1yr0Yybf/xhLgmwR4NfxAJoVxFDxOUzUSWmKTTDTfx2K3fR7Kqr5cN0qHMIEm2U2CB7PEQArZ4pzkp/vHGqygTXLZ60UZYU5LhVq8wxY3fLqTxioGkvx2N9sVIukBWMt4LXlTLXBRScQoWBRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA1PR11MB6782.namprd11.prod.outlook.com (2603:10b6:806:25e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 14:54:08 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.017; Mon, 13 Feb 2023
 14:54:08 +0000
Message-ID: <6c97dcd6-89fe-89b6-ed58-674810ae5fa1@intel.com>
Date:   Mon, 13 Feb 2023 15:53:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH bpf-next 0/6] ice: post-mbuf fixes
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Maciej Fijalkowski" <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "Song Liu" <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230210170618.1973430-1-alexandr.lobakin@intel.com>
 <87fsbd75pz.fsf@toke.dk>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <87fsbd75pz.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0285.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::33) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA1PR11MB6782:EE_
X-MS-Office365-Filtering-Correlation-Id: 1656adae-cc4e-424a-fa20-08db0dd228c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BeDbV0JKRPH7F+CEaomW70Yn9pNxwEN5NDYEdk0oRyBjaBIdCLlGbRMDLNY9qIOL7Dfv1w3UQSOfgVfwUGyQ77VOVy1V0CYwLnNg7gnVY2W4zMSvKi0meO8nm+fVVefHRT+FtImXxPOPB7/GoqW4y7J5Nsmuvxh3DEF47e+4eqg58xC8Yst9+EVKrMXWUKoIfVEfPo4QPCVtEvGcM2JqWkZddPsdfEyABBsSZJVZBjhTkLD7DJGG3h//TTObmw2LakYQGMyDn/N27/u2cuWWYcYxIlwdm9aE2mjtaV6inIMhAM75jENEs7AGUQ3WMheuS5a1/5AQ26NAT9MlJSby709ejN4pmZtT8aMXP2tChK1c+D7fgZvri4zUFqErLaZZsci16oNvug2PDokD3q1j55laX5evp0yJDtv2NmGgpE7mr7LjV9hkSSxxafz1D4MB8kZQVSrF7zYXuwI3KY3Q69o1uvhtdPCp+Op8EPj98NisB7DVPmMcDjKuK+gsxwR2DBjrjjYFQAqFYqPScgOLCX3NUmMJOB1+kqbrSGpWjg1cjNrzdwN+QjS81XwTxCN9Z4sJLYRsosSRpd5I5NfJm52Dpbk3Vb94zCXwkN/F3wIgQgF/DrM7a3hb3Rc3UufnPcT5cDnqo6qSfAZ8HMf3RM5O+U3D1tMwIMqs1jvgKumiv9obGrl0KzKr4u/13HjEdG2oFCoCDkETZdZ64rm/ERXHpj0nkNMgbdozcOhjh1s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(376002)(346002)(396003)(39860400002)(451199018)(36756003)(66574015)(2616005)(54906003)(83380400001)(82960400001)(38100700002)(8936002)(41300700001)(5660300002)(7416002)(2906002)(6666004)(6512007)(31696002)(186003)(6506007)(26005)(316002)(6486002)(31686004)(86362001)(66946007)(66476007)(66556008)(8676002)(6916009)(4326008)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RVNzYjFWZ0Zjd0ptVXZxL1FmakxEclZXQzlxQUsrMmgrM3RhOEdpOTk0OUZp?=
 =?utf-8?B?R2E4R0tZMlFLR045UFRSNG8wSXpqNGlsQUVnZkxjOVV5WHNvdkNuTmkyeEZN?=
 =?utf-8?B?b1p4TGJ1Nk40SlN1K216aE9NbFNqOFZaTkcwZ0FDTDJUclNMbGNSN3NJZjVM?=
 =?utf-8?B?Y0JCUkNLeXlZRTdxT0ZPK3lob2ZZQ0JYU3dDa3ZiTDY2SnFJQTU5RTZkRllp?=
 =?utf-8?B?M3Q3SUJnR0x4Vk1pbWxOaGpYOEtYUTh0REdWQXVvOUZRaE9lVHdRQ09kaDF6?=
 =?utf-8?B?bXVyc2tRSnNZRGlyTXFITW84ZWVrRmlXVjEwZ1NHRlNzdWY2eUl0dzNoUUM1?=
 =?utf-8?B?SnpDNGhEMVJNb1FBYUJmTFZ3YU1VRWxWY3FiTm9EV2x2TEVqZ2Vydy9vbUM3?=
 =?utf-8?B?NTIxR2tBcjRBcllrUm5XNXNUWFhMZEQ4L3pNcTZpQXFFdHpZR3o0eGJ3WFc3?=
 =?utf-8?B?YTd4MHRFazdDaDlaR1ZEdkdJWnRvZ2xjMy9odkNSUEt6ZVdWWmphUG1xd1dY?=
 =?utf-8?B?VXJkMHZRQmgrWUl2b1R2MFJTc214U24vaHN3VkgvYUZad3ZZUmt4S05neC9o?=
 =?utf-8?B?aFVwRGhrNExveEp6TkVUUWVvOHRUOWVjN0V6T29LSXBSVHhpZEpWalA2VVVx?=
 =?utf-8?B?MlJ3eTNUWVF6SlFkV0YyV0plRi9SbjlCOTBhQ2ZqbGVCaGR2MDZjNVZNZ1RX?=
 =?utf-8?B?ZTY1dHVpQlU1YjVIZ3pJUnFWb0pNL0k2WlZsVUtjN21QNTJGb1RmT2ZzNFM2?=
 =?utf-8?B?WENTU2JCRkZJR254K2V3TGdad01MNWUzaVc3eFRCTmJER0d3R1B5U005STNF?=
 =?utf-8?B?MmdCVGhaM2Mzek4zZnRKWjNoOGo4UWJkMlpleWtoY21NZHVFc014UUZsSytj?=
 =?utf-8?B?cWprRGcwQlFNSXQ0cUhrMDgxN1Vmem51akhtQlBKb2xwNXBiVjNtRVZES25N?=
 =?utf-8?B?K29sV2pTb2ZSa09BRHBtYjVsOXhEVUhSUlkweXh2R1RndDFtWlA1YnNXbDhO?=
 =?utf-8?B?dVZWUXhCdVUyTkVZRGJiODlPbnluaDV1Q0NoRmtUN1hQNFUzNDF6ZnNMbG5T?=
 =?utf-8?B?NnUwYWpnSzlCS0hIOVlQR0tiMUl5TWtXeXdsOElPTVhCckhxYlZKa01MYWxE?=
 =?utf-8?B?Q3djWVlOVjdLaTZ4UzFTQmtZa0RPN254NmhIYXZnK3hLaWpycUVxdkppRldN?=
 =?utf-8?B?aVIvOWNUVy9KdmNPWTBDbEJEZWNYc3dod0hKU2k1Qk5IRU1yN1dDY3ZMOElK?=
 =?utf-8?B?dHY4Wkg2U1Y2eU9aVVU4RVRyZC93TWF1K1lFY2ZXZkt2czVIYkkxS1EvZWhx?=
 =?utf-8?B?bWNHNEN5RHpsazB3OStLRWRmdDZJbG9ac0JyT2MyU1k1bTd4ZnloOUlQVDZo?=
 =?utf-8?B?UW9idGZFWDF6SjZaelIvSXVkazc4d2ZhQXNaRGlUR2MxNFVFMzMrNG56Wk9G?=
 =?utf-8?B?dlpGaXdDL2IwY2k4UG00ZzBYV1NVUVdpZXZIQXRaanhtVkMyMXd1YkN3SU9O?=
 =?utf-8?B?U01lUytuWVlHOThmL2VYbW9vbWIyNStEYU9uYUc0dXBaN1pHazZleG56L1Vu?=
 =?utf-8?B?cml0WkRYVGh6eTNlNE0vNDhlcmVEZmp6bzFzd3QxSWVFQ2pCUGR6am9SSkY1?=
 =?utf-8?B?M2JDcitRTllpV3NNSCtDTEFULzJjMmNGVHdLZCt3NmpSU1dJOFc0NE5ObzJm?=
 =?utf-8?B?RnhJV2NtZmtGZ3BRTUJtbiszOHhFcDN2Ky9UamFaNVluZHA3V1RIc1NmQkxH?=
 =?utf-8?B?ZmowS1B1aFVDMDI2ZHAvYTIwNndWMkgwdkxRS09JVU5GZkh5eFZzbTV6NVpr?=
 =?utf-8?B?LzBwYllBYWoxRTk1ME9JMXdlSHJuZnFwY0F6NDZxL0RlUyt2QjdmYjh6QUpp?=
 =?utf-8?B?T2E1K0N3bXBuNEh4Q0ozcFcxeFZiSnJ3Rjc3ZXdXcGQzYTR4aTAzbldhdmdD?=
 =?utf-8?B?QzJoMG53TTdvZ0ZMN1NHY2dCUnFyY2VrS2I0bGxobFBhV0ZuL2NSaEs5R3JO?=
 =?utf-8?B?MjJiT1MyT0duaHZCdVhhQWJja1E1ZU1uQW1OKzFweDRpWUxSZzVzZEE4Ylpv?=
 =?utf-8?B?NlZ2dGQrdGJPNnpXanBpdndHS1JTY1pnN0o3eklKQVF4S2VNczNRSDFObmJL?=
 =?utf-8?B?Sm5vTnZVbUM2MnF2NEE2eCtvZGpNYkFJTnZ3M0xqMXpheVhuUEhPODk1MkNh?=
 =?utf-8?B?REE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1656adae-cc4e-424a-fa20-08db0dd228c4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 14:54:08.4004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3WF42oa0Guy91frSGL+ITPBnBoUOEl2k542ID+uP+ASZ9jCSHLHX0EAQXl3q9WQtPhhE8TahBB+TaBmn6iIyx1ig3JzV3SP9OXdL8UO1aXw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6782
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Fri, 10 Feb 2023 19:09:12 +0100

> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
> 
>> The set grew from the poor performance of %BPF_F_TEST_XDP_LIVE_FRAMES
>> when the ice-backed device is a sender. Initially there were around
>> 3.3 Mpps / thread, while I have 5.5 on skb-based pktgen...
>>
>> After fixing 0005 (0004 is a prereq for it) first (strange thing nobody
>> noticed that earlier), I started catching random OOMs. This is how 0002
>> (and partially 0001) appeared.
>> 0003 is a suggestion from Maciej to not waste time on refactoring dead
>> lines. 0006 is a "cherry on top" to get away with the final 6.7 Mpps.
>> 4.5 of 6 are fixes, but only the first three are tagged, since it then
>> starts being tricky. I may backport them manually later on.
>>
>> TL;DR for the series is that shortcuts are good, but only as long as
>> they don't make the driver miss important things. %XDP_TX is purely
>> driver-local, however .ndo_xdp_xmit() is not, and sometimes assumptions
>> can be unsafe there.
>>
>> With that series and also one core code patch[0], "live frames" and
>> xdp-trafficgen are now safe'n'fast on ice (probably more to come).
> 
> Nice speedup! And cool to see that you're playing around with
> xdp-trafficgen :)

It's not only good for bombing receivers without any special HW, but
also for uncovering problems with XDP in drivers and/or kernel core,
as I can see :D

> 
> -Toke
>

Thanks,
Olek
