Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA0464257F
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiLEJMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiLEJMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:12:10 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FB1E0;
        Mon,  5 Dec 2022 01:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670231508; x=1701767508;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jIpjkPXqHFP5AljxTPk3v1Sc8fFbfq9CBDoizAUK50I=;
  b=iVNiNluWWo6Ko2alCqYd76IJ8riJsJOA0rSJHcC6m6kskwqqICKReCpv
   XI5s6wMHtFFwr4dYLAz8wnp7KWefDgQMBIPfesJOS5BxMgh7ncA1Mqmj6
   pYrrar8vMP+d1uii+oTsxEvNRT90R6UVduhLd9vFOMlWsC2LZpnQY9Bbw
   HHPEFL0sOsgn5cyVRgVc8PXdfq0x77p/fj02J+BSeXDM9PizPsOOjD2Bm
   TSxNpjeYn2erWcANRk3x6aTPYA5tfSCdo7d+41tVAb4wQUWEqIFpE62CX
   sXCkiaahmnHsM5+SVd5PPV6/FwKaoPs+gr6bXuci9HcgHze/4SZfYDt8u
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10551"; a="299727568"
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="scan'208";a="299727568"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 01:11:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10551"; a="890889277"
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="scan'208";a="890889277"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 05 Dec 2022 01:11:46 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 5 Dec 2022 01:11:45 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 5 Dec 2022 01:11:45 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 5 Dec 2022 01:11:45 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 5 Dec 2022 01:11:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhUYdD03M7iS9+MeXrXASWlHK4jACN4fpypB1aMlWjV1rcQl+yKYqsieUD63EC6523lQtU4CI2BBjlJJY9NBkMsJ07FvvlPHMU4SZwyhn/DQxvn7ueQdh2VNLgJe/9mtMv7qqG5OefGnTEFEzmW7RsEnw3Hqge1zI0OePOfPPBNJrminc25pz2InsDNMgHemHWDdmXm43ZjumtI6Yt1LpcjQ8B7ogHPV6uRXTY3FJTa/IJAzktVHW3Sleh2mCLlMsCpZXNBmmeSPxkwD+aqB0Isu/B1x/G6qtTOrloM/2SFlU5ADI5PAz39sEfutpvKXB6McMQxPAX+7kakKD+ufVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bukNY57Bv86DC2/i2G8cmSXfRFHqoKgOALdlF1qztV8=;
 b=Tx6cYqhUDdBeS95ZKQ/q8dd+hGMek+NCtsKAdqdBGMj8M/csQRWvy6jbvMm3jzVnB2NXa6zfuOh+ISlirn2ROOgZkd5m6X+VGOvsGR53/BUjVwwah3epgesA6aOXw01sEMBYPTy1w61zr93AITENWOd/N9KfAKzNtFUDlymV8A4Bpf/MEHXviLFD273W+/nwLKS/tZp5PoTOHINzsFU8mnH1fHj1iZlmkOFZthrHx4DM9K6fGuKbcS4XHCm+LYtbKt8TEAm2OUdxEq4sChq5rwXXRge25jBEGxgp+mIwSNT31aVpk7d6MFfl02dN5SRF//Jb7iHgAT0VuGGHtXuIcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB4449.namprd11.prod.outlook.com (2603:10b6:a03:1cc::23)
 by MN0PR11MB6058.namprd11.prod.outlook.com (2603:10b6:208:376::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 09:11:39 +0000
Received: from BY5PR11MB4449.namprd11.prod.outlook.com
 ([fe80::b289:7d0f:1d94:cd52]) by BY5PR11MB4449.namprd11.prod.outlook.com
 ([fe80::b289:7d0f:1d94:cd52%5]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 09:11:39 +0000
Message-ID: <5147a603-363d-9773-70ee-277c8ff3fd82@intel.com>
Date:   Mon, 5 Dec 2022 17:11:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: [PATCH bpf v3] selftests/bpf: Fix "missing ENDBR" BUG for
 destructor kfunc
To:     Jiri Olsa <olsajiri@gmail.com>
CC:     Yonghong Song <yhs@meta.com>, <jpoimboe@kernel.org>,
        <memxor@gmail.com>, <bpf@vger.kernel.org>,
        Pengfei Xu <pengfei.xu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "KP Singh" <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20221130101135.26806-1-hu1.chen@intel.com>
 <a1745d9b-4bfc-50d2-8da6-7631ae2b24d0@meta.com>
 <aadf45b9-b6e1-256d-c618-31b65e9f7161@intel.com> <Y4iVCmBS1fbTw63o@krava>
Content-Language: en-US
From:   "Chen, Hu1" <hu1.chen@intel.com>
In-Reply-To: <Y4iVCmBS1fbTw63o@krava>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0036.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::22) To BY5PR11MB4449.namprd11.prod.outlook.com
 (2603:10b6:a03:1cc::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB4449:EE_|MN0PR11MB6058:EE_
X-MS-Office365-Filtering-Correlation-Id: 09be4329-1b68-45fd-8e5f-08dad6a0b77d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zzpMds5VGSXqA5H7x86ULzqeB9YYGM7ORlyiyqpQMeCkYV9yDcHYOeCSHXiNJX/o1CEXM5Fi8FUPkXlW45ZL7U4X6ihfc75O6ekrSTqJ9ROh5Ub8ufPYPtdmix3lqn4HtZayE9JyxBuXjJMtGPt8Qvg1TPg+6EZawY+MgfWIOAZ3tfPHbo56S82RWplHs4s7UIeQoErOqdpyI5VccvPiYXW7owS8Kkxpl7G0RCRekINUk+iOP//gyIzL3UXyje70mn3O7eDzzTaiusxv/HUwmE+Nr0pLq+MQtNxdgZhKbLybj2YLJzUmSJL624+RpqlIvMzwEbCuRZVTvzXrwWKNyUpDgMdl2JfcI5NpGM4J+HDFoRlMNyBi8sj6ovEB3tDaMPpEAjzFBAlbJiNsZfh/ZGNcnza+QQZvJ+rSYmOJucIth+iMOv8WtUTN5Bx+p6W1rBixQH960MlUav+nzdvFMGdojeM+ueTO6FHb6iGTZJJdYsZkn889LZVxiZZ8sJZhZXMGZfQH7yI3UiZOoLSIVbehmxZaZDa09nR1S+998I2eYaJNxrfHPYEl1GdAkiOZj2PHkmOHFVAGmMselz7IQPACJNsF39rnWijvTszyEtMbJwqGU2Ygbb6GO3ferrhvHp2dQHlqD08FOAy5HEfcdfkrLNZnJqBQQv+jpEjK1+9lWQHYRKhWqB1R2Ma9raG36MbeTw3X4ZMXHyk1nqSlL1wlGRrrMOFjwTwh6pSKz+orYNoUYP68kqutPnLG9Mk7aJhcQaEFgtZFxEXJ8hdt/GdmiM60Se63azwwIbueBCaXj0ibmgwmOv8msfEfCeAL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4449.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(396003)(136003)(366004)(39860400002)(451199015)(31696002)(86362001)(186003)(8936002)(7406005)(5660300002)(7416002)(36756003)(316002)(54906003)(6916009)(6512007)(26005)(2616005)(41300700001)(6506007)(66476007)(66946007)(66556008)(8676002)(4326008)(53546011)(31686004)(38100700002)(6666004)(966005)(478600001)(2906002)(6486002)(83380400001)(82960400001)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTlNSFVUckIxUjBUY292bGNqMzVtZVdQUTdCNklPSzgvb1NBOEtIRjh0NGNY?=
 =?utf-8?B?eDdNMnA2QzF1eWZnYUVmeTZ3OHdnaSt2Y005UmpveVpabHMyZ3JXaGUwOGhw?=
 =?utf-8?B?TVlVczFKbnA0ZnRncHFZQmJFT3N4TXNMTm93Nks4ZW5OTDlRVk5xS1VlZ1Zi?=
 =?utf-8?B?ZGtCY0UwWEZhMHhLOE4vOXFHWGJET3dobG8yNnRoVzBVeGdGVGNnR3dYcUFi?=
 =?utf-8?B?bTh3TFg1dHF1azFkM2V1MjhKWE83eGhENTgvdlQxSDFVK0tJSHpyQndMbHcy?=
 =?utf-8?B?cmFUZjV6R29GTTloY29uSCtZWU90bGRTT2piT1B6bTIxQkJhbkkrV0FLa3Y5?=
 =?utf-8?B?MmRjdE9NYXFLekcvaGhJcGgvUmFJNXh3bkViTEljVW9nS2dTZDJSQkhuYnhS?=
 =?utf-8?B?bEs1NEZVS0VBQmJhSHJ5aTllQUNnUEJFRTA2enpsS0MyOFdqdE0wWHFoV2J5?=
 =?utf-8?B?N1BGaEI2MkZzTlQ5MFFVbC8yQnZyVVJtaXZYSEtKZTZQaXhwZTBYRmIzSGV3?=
 =?utf-8?B?bytSYjErdkwxZlNDVC9oOXdpYW1PRk8yVjJSNUJCT0tzOUZ1VDVJS2pCM3dv?=
 =?utf-8?B?NHpxM0s5ak1CYlhHLzNzVWRjTkJnaWJtb2ZFUVR0MmNzRlBzb3U5NGZJeHJn?=
 =?utf-8?B?M05MQWtiYzR2RFJUZThjdjRybnpqdTZZbjNmeHNHVGZmMWM0RVJtRHlOd0ll?=
 =?utf-8?B?ZGxibmhya1VzdjE4VTkrcU9pZ2c2TXFzWmdCMDYvTTVvS1BKbFBkR2JvQ05F?=
 =?utf-8?B?bURzekNJcnJnazFyM2lES1QzaTViVDhGT3YvTDNUbkI2RUNWb0ZETGFoZjhw?=
 =?utf-8?B?WFZ3eityUFhiNTVPRFl6VHg4dTQwT1dqWEpjUTFSOFM0ellsSXpnaWMxeWs2?=
 =?utf-8?B?NEtvUjd5b0s4bXRvU29HcWpETDM5TGVLVjR3REUzNHkvZGs4SjNXVEVpdU52?=
 =?utf-8?B?dW9odDR4TXVMbDQ2Y2pyVURwalF3d2VpeW91T2hZbnRWMldTVUpRY2tFa1Mz?=
 =?utf-8?B?cG9sUWp1a05BUzFjR0pCdG9qalRUb1EwZ0VFMjBQeEN1K3dFRU8wZ0FUaG1Z?=
 =?utf-8?B?MmhSOHlXYi9ON2NPM21valdtUVBCMldGdEJyQkNuSjZJWmk1NFJCMldGbWpi?=
 =?utf-8?B?bXdKNEZ6dk1TdFA4SEZrdDdnUkE1YmxGU0ZKbjRKOWxuY0EwTTNLbDNPVlVm?=
 =?utf-8?B?ZER2M3NNbGJxT3ZQRlBTUkMvYjJrSkMwc0pGS3R6bWNlVjM2Y2xRWjhteTV4?=
 =?utf-8?B?TWROUE5ENmFrZkQ1b3R3bC9CWDRuajRwVUxnSGZPUTl4SFc1dnJHNXVmTmV6?=
 =?utf-8?B?OS9ya0xpbDFMb3g5d2hvT3BTeWVHaDlLbWI0ZmpFdDlTSlY4OEs5QUhqek1W?=
 =?utf-8?B?NWFyYW9yMDNHb3FGN1ZEakkvTGc4ZVEvN3FKamdUbkRlSkVHd2JBMFFpS0Zp?=
 =?utf-8?B?SVhjK0xWYmJGTHFqS3d2enEyZEt6cVB2eEtDV1FvbGJZWndybWdFaTd0KzVP?=
 =?utf-8?B?NHdLK0lxWklaL3lrZlA4b2wwN2svcnAzTFljNmQ2UElXTVpKMlMxTGNGWm4z?=
 =?utf-8?B?Y09WWFNxVXB1OGpyQjIydkJTSURWTFR0VTljY0t3SmhpZ3E4Wm9hOGRMWi9r?=
 =?utf-8?B?Q1Zhdm1PUisyVWxHb0tBbjNOZ2hTZkRuZ2hRVUJEbW9kUXZBQkM5b1hXaStu?=
 =?utf-8?B?OHNkcE5tRFkrL1pPZE9qRjMwS3E0T2Z4bWdrWUhBVFV3bytWakNaWk9BdWRs?=
 =?utf-8?B?Q21MRDQvN2p1b3FnVkZZK3JCMzNDRmxiNU4zNGgwalFTRVhWaHVDK0xEaXd6?=
 =?utf-8?B?UUIralVlQjdSc29yaGVJSlhmOXhsUlc4RVppNFdjZFZJbWRIYmRhWVlHT1lI?=
 =?utf-8?B?N0RaMmJpYXROM2l3U3Vub1pEczFrSVo3SVRmSkJyd0JBK0R6QklFRnM1SkRX?=
 =?utf-8?B?SG1tVElSbHVCblR1cU0vZGRSemdEUlVMQmY4cFA4YXZyMTBRNUhJOEtBRW92?=
 =?utf-8?B?ZlZYWFp2V1J5aXEwT0U0Z0h2K256SzA3bm9uVGkxQnBhbHNrY3ZkNW5JQXBJ?=
 =?utf-8?B?YXRJNWR3WFlwU0RHazd1Mkk1WTUxNHllWGgzVVMwSGpOM0tDOGNlb2xGeW0v?=
 =?utf-8?Q?75QOaSdGAlCRnYUlwillbTRBN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 09be4329-1b68-45fd-8e5f-08dad6a0b77d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4449.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 09:11:39.3229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +v0hMhqqN178hFph0BCROA+7UDLY0Unq3x7DXCwxdtYSerC9/z686GXBe5GvDJ41auwNe4AuGUt3jcACDcZ5xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6058
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/2022 7:50 PM, Jiri Olsa wrote:
>  On Thu, Dec 01, 2022 at 04:07:56PM +0800, Chen, Hu1 wrote:
> >  On 12/1/2022 12:52 AM, Yonghong Song wrote:
> > >   
> > >   
> > >   On 11/30/22 2:11 AM, Chen Hu wrote:
> > > > With CONFIG_X86_KERNEL_IBT enabled, the test_verifier triggers the
> > > > following BUG:
> > > >
> > > >    traps: Missing ENDBR: bpf_kfunc_call_test_release+0x0/0x30
> > > >    ------------[ cut here ]------------
> > > >    kernel BUG at arch/x86/kernel/traps.c:254!
> > > >    invalid opcode: 0000 [#1] PREEMPT SMP
> > > >    <TASK>
> > > >     asm_exc_control_protection+0x26/0x50
> > > >    RIP: 0010:bpf_kfunc_call_test_release+0x0/0x30
> > > >    Code: 00 48 c7 c7 18 f2 e1 b4 e8 0d ca 8c ff 48 c7 c0 00 f2 e1 b4 c3
> > > >     0f 1f 44 00 00 66 0f 1f 00 0f 1f 44 00 00 0f 0b 31 c0 c3 66 90
> > > >         <66> 0f 1f 00 0f 1f 44 00 00 48 85 ff 74 13 4c 8d 47 18 b8 ff ff ff
> > > >     bpf_map_free_kptrs+0x2e/0x70
> > > >     array_map_free+0x57/0x140
> > > >     process_one_work+0x194/0x3a0
> > > >     worker_thread+0x54/0x3a0
> > > >     ? rescuer_thread+0x390/0x390
> > > >     kthread+0xe9/0x110
> > > >     ? kthread_complete_and_exit+0x20/0x20
> > > >
> > > > It turns out that ENDBR in bpf_kfunc_call_test_release() is converted to
> > > > NOP by apply_ibt_endbr().
> > > >
> > > > The only text references to this function from kernel side are:
> > > >
> > > >    $ grep -r bpf_kfunc_call_test_release
> > > >    net/bpf/test_run.c:noinline void bpf_kfunc_call_test_release(...)
> > > >    net/bpf/test_run.c:BTF_ID_FLAGS(func, bpf_kfunc_call_test_release, ...)
> > > >    net/bpf/test_run.c:BTF_ID(func, bpf_kfunc_call_test_release)
>   
>   Alexei mentioned we could now move these ^^^ into kernel module:
>     https://lore.kernel.org/bpf/CAADnVQJ4xaAacOUpzMG+bm2WK5u=1YLo5kLUL+RP3JZGW3Sfww@mail.gmail.com/
>   
>   would it help? not sure objtool scans modules as well
>   
>   but we'd still need fix for bpf_obj_new_impl/bpf_obj_drop_impl below
>   
>   jirka
>
Kernel module may not help on this issue.

If the kernel thinks some of the ENDBR instrucitons in module are
unneeded, it may remove them when load module. Let's take
bpf_testmod_test_mod_kfunc in bpf_testmod.ko as example.

- Disassembly in bpf_testmod.ko:
$ objdump -D bpf_testmod.ko | grep bpf_testmod_test_mod_kfunc -A1
00000000000005e0 <bpf_testmod_test_mod_kfunc>:
 5e0:   f3 0f 1e fa             endbr64
...

- Diassembly after kernel load bpf_testmod.ko
(gdb) disas bpf_testmod_test_mod_kfunc
Dump of assembler code for function bpf_testmod_test_mod_kfunc:
   0xffffffffc02015e0 <+0>:     nopw   (%rax)

Below backtrace shows how ENDBR is converted to nopw when load_module:
(gdb) bt
#0  apply_ibt_endbr (start=0xffffffffc0202316, end=  ...
#1  0xffffffff81096f19 in module_finalize (hdr=0xff  ...
#2  0xffffffff8118375e in post_relocation (info=0xf  ...
#3  load_module (info=info@entry=0xffa0000007843e08, ...

Thanks
Chen Hu
> > >   
> > >   We have some other function like this. For example, some newly added
> > >   functions like bpf_obj_new_impl(), bpf_obj_drop_impl(), do they have
> > >   the same missing endbr problem? If this is the case, we need a
> > >   general solution.
> > > 
> > 
> >   bpf_obj_new_impl(), bpf_obj_drop_impl() also miss the ENDBR. Below is
> >   the disassembly on bpf-next kernel:
> > 
> >   (gdb) disas bpf_obj_drop_impl
> >   Dump of assembler code for function bpf_obj_drop_impl:
> >      0xffffffff81288e40 <+0>:     nopw   (%rax)
> >      0xffffffff81288e44 <+4>:     nopl   0x0(%rax,%rax,1)
> >      0xffffffff81288e49 <+9>:     push   %rbp
> >      ...
> > 
> >   (gdb) disas bpf_obj_new_impl
> >   Dump of assembler code for function bpf_obj_new_impl:
> >      0xffffffff81288cd0 <+0>:     nopw   (%rax)
> >      0xffffffff81288cd4 <+4>:     nopl   0x0(%rax,%rax,1)
> >      0xffffffff81288cd9 <+9>:     push   %rbp
> >      ...
> > 
> >   The first insn in the bpf_obj_new_impl has been converted from ENDBR to
> >   nopw by objtool. If the function is indirectly called on IBT enabled CPU
> >   (Tigerlake for example), #CP raise.
> > 
> >   Looks like the possible fix in this patch is general?
> >   If we don't want to seal a funciton, we use macro IBT_NOSEAL to claim.
> >   IBT_NOSEAL just creates throwaway dummy compile-time references to the
> >   functions. The section is already thrown away when kernel run. See
> >   commit e27e5bea956c by Josh Poimboeuf.
> > 
> > > >
> > > > but it may be called from bpf program as kfunc. (no other caller from
> > > > kernel)
> > > >
> > > > This fix creates dummy references to destructor kfuncs so ENDBR stay
> > > > there.
> > > >
> > > > Also modify macro XXX_NOSEAL slightly:
> > > > - ASM_IBT_NOSEAL now stands for pure asm
> > > > - IBT_NOSEAL can be used directly in C
> > > >
> > > > Signed-off-by: Chen Hu <hu1.chen@intel.com>
> > > > Tested-by: Pengfei Xu <pengfei.xu@intel.com>
> > > > ---
> > > > v3:
> > > > - Macro go to IBT related header as suggested by Jiri Olsa
> > > > - Describe reference to the func clearly in commit message as suggested
> > > >    by Peter Zijlstra and Jiri Olsa
> > > >   v2: https://lore.kernel.org/all/20221122073244.21279-1-hu1.chen@intel.com/
> > > >
> > > > v1: https://lore.kernel.org/all/20221121085113.611504-1-hu1.chen@intel.com/
> > > >
> > > >   arch/x86/include/asm/ibt.h | 6 +++++-
> > > >   arch/x86/kvm/emulate.c     | 2 +-
> > > >   net/bpf/test_run.c         | 5 +++++
> > > >   3 files changed, 11 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/arch/x86/include/asm/ibt.h b/arch/x86/include/asm/ibt.h
> > > > index 9b08082a5d9f..be86dc31661c 100644
> > > > --- a/arch/x86/include/asm/ibt.h
> > > > +++ b/arch/x86/include/asm/ibt.h
> > > > @@ -36,11 +36,14 @@
> > > >    * the function as needing to be "sealed" (i.e. ENDBR converted to NOP by
> > > >    * apply_ibt_endbr()).
> > > >    */
> > > > -#define IBT_NOSEAL(fname)                \
> > > > +#define ASM_IBT_NOSEAL(fname)                \
> > > >       ".pushsection .discard.ibt_endbr_noseal\n\t"    \
> > > >       _ASM_PTR fname "\n\t"                \
> > > >       ".popsection\n\t"
> > > >   +#define IBT_NOSEAL(name)                \
> > > > +    asm(ASM_IBT_NOSEAL(#name))
> > > > +
> > > >   static inline __attribute_const__ u32 gen_endbr(void)
> > > >   {
> > > >       u32 endbr;
> > > > @@ -94,6 +97,7 @@ extern __noendbr void ibt_restore(u64 save);
> > > >   #ifndef __ASSEMBLY__
> > > >     #define ASM_ENDBR
> > > > +#define ASM_IBT_NOSEAL(name)
> > > >   #define IBT_NOSEAL(name)
> > > >     #define __noendbr
> > > > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > > > index 4a43261d25a2..d870c8bb5831 100644
> > > > --- a/arch/x86/kvm/emulate.c
> > > > +++ b/arch/x86/kvm/emulate.c
> > > > @@ -327,7 +327,7 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
> > > >       ".type " name ", @function \n\t" \
> > > >       name ":\n\t" \
> > > >       ASM_ENDBR \
> > > > -    IBT_NOSEAL(name)
> > > > +    ASM_IBT_NOSEAL(name)
> > > >     #define FOP_FUNC(name) \
> > > >       __FOP_FUNC(#name)
> > > > diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> > > > index fcb3e6c5e03c..9e9c8e8d50d7 100644
> > > > --- a/net/bpf/test_run.c
> > > > +++ b/net/bpf/test_run.c
> > > > @@ -601,6 +601,11 @@ noinline void bpf_kfunc_call_memb_release(struct prog_test_member *p)
> > > >   {
> > > >   }
> > > >   +#ifdef CONFIG_X86_KERNEL_IBT
> > > > +IBT_NOSEAL(bpf_kfunc_call_test_release);
> > > > +IBT_NOSEAL(bpf_kfunc_call_memb_release);
> > > > +#endif
> > > > +
> > > >   noinline void bpf_kfunc_call_memb1_release(struct prog_test_member1 *p)
> > > >   {
> > > >       WARN_ON_ONCE(1);
