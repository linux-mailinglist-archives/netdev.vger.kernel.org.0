Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8C846D68D
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 16:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbhLHPQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 10:16:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:9094 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231429AbhLHPQI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 10:16:08 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="261930570"
X-IronPort-AV: E=Sophos;i="5.88,189,1635231600"; 
   d="scan'208";a="261930570"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 07:11:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,189,1635231600"; 
   d="scan'208";a="600651327"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Dec 2021 07:11:12 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 07:11:12 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 07:11:11 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 8 Dec 2021 07:11:11 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 8 Dec 2021 07:11:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S2Y1xKYnAaAnAu+6kTc/fea53D+m7sm9MWQdbdWVcK10xiWaDjJkvdLZjJIXob8FIP4ft6GJ1BBYgnIcCHI0K95qzldW/AVpD6GPrjwcgh/sBpAkPiYUw9Ytd/I37QmV3JK5chEqsa9z4mrW435XzrgkEm4BijKq5LYA5DH3jTvKK/JhTw1+UMtMjT/Bmb+o3IIXpaS0+mqHUPGfC5hrBZvnYZFSu7Kvmd4utHHRts9ElxAf3FMAbAoOQqAvGQoEfSir8ctsEAxb7+c8nbmkOv/rDTtet9tiLVYkBj0qAndW08CxsyaB1eoRTo+3oXFr5lH2vOnEzCK2F/y1tcuCEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a7slmzAAUodrYtZs3XQ26L7z4LiflkVhobpHVgcK7nM=;
 b=Xg5XpcfwZx1WAezH4sM3VfCgLi82uDABTTQJiNNLWOKWKBP8GZXCYkcy8X0UVUjxhNXYo7IW+sXkyclgMPB61f9i/Nb1iS54igoHsmfthhT9NcB4fl69a/fvWHTGoRmIZDd75Ylg+QMVe6t5k6oLQ4YBjCKGI96ikTWmurlOhxoklqUSjkCZg2cfOvfDNdKD24FHE+l+nCzDLgQ1LwkQ2GTxfARQKNapBrEbSdFdkjjexXW66zifDjXFeWqpiEZZhUKzKca0TV0M4AFCK12q87ekp3HADkFjhSxnZwHBdBXI5VRc3XJhGvlp5JLRXpQXPDQQaxA0s7xCptJmytoR8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7slmzAAUodrYtZs3XQ26L7z4LiflkVhobpHVgcK7nM=;
 b=J2yVABrOeD5ezquRu3ko2WWnnb22ncd5sZJynawSSR/R8kusXa6Z6t37gh57QqbitW6j6/uBRGt2CAvxzlr9mLI6xzQH5VcaF94T5GKdYJj1JpH3xdU1n2uy4MQ5+qLmMHvdwG4igAX9drjpM2oVJ5G9LYvZglP8O4RXWbGH0AY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3180.namprd11.prod.outlook.com (2603:10b6:5:9::13) by
 DM6PR11MB3818.namprd11.prod.outlook.com (2603:10b6:5:145::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Wed, 8 Dec 2021 15:11:09 +0000
Received: from DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::a94a:21d4:f847:fda8]) by DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::a94a:21d4:f847:fda8%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 15:11:09 +0000
Message-ID: <1c7a4f98-b02c-ac68-9873-ab6449f7301f@intel.com>
Date:   Wed, 8 Dec 2021 16:11:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.2
Subject: Re: [PATCH v3 net-next 01/23] lib: add reference counting tracking
 infrastructure
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>,
        Ingo Molnar <mingo@redhat.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
 <20211205042217.982127-2-eric.dumazet@gmail.com>
 <3d80c863-8f1d-5e94-44c8-cc1193cca06a@intel.com>
 <20211208065943.61b6220b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <20211208065943.61b6220b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P191CA0069.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:7f::46) To DM6PR11MB3180.namprd11.prod.outlook.com
 (2603:10b6:5:9::13)
MIME-Version: 1.0
Received: from [192.168.0.29] (88.156.143.198) by AM6P191CA0069.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:7f::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 15:11:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a12c885-99cd-4d8b-1e36-08d9ba5cf6b2
X-MS-TrafficTypeDiagnostic: DM6PR11MB3818:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB3818FD38DB85DC5DD05DA1DAEB6F9@DM6PR11MB3818.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3fQXFnjFU1yqh6FVkgUIc8wi/DinfzzBPN/WgMU4n2IOrLfSbofTjLtzmmA2iDZ0rLl8W+8Gr7RPFpycbBe6NYsSJoBFM8SALADm7dPpcsNTSHEOmkBYXYzgZSAL6Egi7cjfJXpW5h6hGsIDQVWF+ApfylveIW8/xPXERzIFnPzrvHCMUtFFk1XZ4L4S/dAty5EraNIhPE7AP6QEh/Bp8H+m/BhFKwRN/bcuHQ4LISWZ2HGV2YxLJgJJAGpw/X4IjIs6RzNPF9R9I558FohCif/9m5fYBNxYWeQu0bv6sVi6bGKzWmOIp43yDcS0AjXfn90cPiJ9pos12cT4YaicAQijc+QM0/fFwKBzXNty3AyPhXlqYvlYPSbSCNYgbQk8GyDCYuhRU/4wlayeY0f07uRJ+Iv3ormQsKNJ8vpUYe/8s4aV0/uGexjuC7XIf2oJL90gtsmZsI4ttyw/eumV/NHKiZ5OskPGD45L5UGYyyMqooNuDPjiwxKspiYSf70nVI8dII+BGCBP45FUeEo20hwo/HlxJoIWZils6IljHCA+GDH7lcU78AahCO7WZ443bbfCW3XC2pWo8zwzagMMDBFG1s51uHw/91ZyXmSxe+XbsfX04LqycC3MjlPQEzAUJtXnJwyAKbK+j8YM1B7MifSfphpbeeULbMqn51/9yRBPvwbPmVjJC40HpWM8rH4Q44H9Lc7J6jJXZ7Vlnht6HikCdJC0DzT24t1q7IV1qCNavqwKwLFDg2uIWSHTy3jGzyqolSPZ8VUsFzEFRrLBym0A/NcwQJPSMuMRoh6j5iDNMhNgeZZq3PwdnOFSGprX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31696002)(5660300002)(2616005)(54906003)(36916002)(2906002)(31686004)(6486002)(956004)(66946007)(66556008)(16576012)(66476007)(36756003)(38100700002)(316002)(82960400001)(44832011)(966005)(186003)(6666004)(53546011)(26005)(8936002)(86362001)(508600001)(8676002)(6916009)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWFheGVlSEsvSkRuZ1l1RWlTaWw1Z1o0Ny8zdW8vWThnYlQxSk1ka1ZodU8z?=
 =?utf-8?B?MzhWa3c0eW9KK3VOTWlLcHd6Nk4wT1VoRXFxTXZKK3kxYnNzOE5WZVk3ZFZz?=
 =?utf-8?B?bW1IaVc2Q2dDZXB4VUp3OThETldheXZ3NHBDWlZDeGE1QVNyb0pSOENGdzhp?=
 =?utf-8?B?aEdYRWdaN1Q1aDhrMk9zUlVUU0FEeTBzMTJVZm0zanhlaTU3SXVxSDl5amgx?=
 =?utf-8?B?My9HNk1URUNnVEdVUkZsWWh3WU0yMmY3S1Y0NGdSdEQ2TzdUZk5BcVc2QWp6?=
 =?utf-8?B?YmtkYXRDVjU0eTBtQTViM01VR3dtdEIwa3VIK3Y4bThhYjRDVTZFekhGdkxv?=
 =?utf-8?B?SDhLdTRZd1BRUmxkbVY5dFZmb0xNUGJXbVg5M1RjREN0TklmUHRMamxhUy9y?=
 =?utf-8?B?czAyaXhmVkhVNHgxNlI4a3FuNjN1a2tsVHJPY1BTYlI2dnBhUm1Da3RjdVZT?=
 =?utf-8?B?dms2c2pndGNIcVJ6WEsvMUIyZ2lkVzVBUWxNQ0xxakVLbWlIT21CeThKOFBx?=
 =?utf-8?B?NFVzNG1sTWhhRXMrMzhnb2MyQUlTd1B6cGNDdHNvcWpkdUlaeEFPd0RBVmtz?=
 =?utf-8?B?WFNKSTdhMXc4VHUrWUlFYkg0QzhqbDhoRTZSQzRsa0tsazROVFBlWncwc244?=
 =?utf-8?B?WmxJblVNcUFRaVdOL3VvTkxnajVzZHU1YVlYWFZrbUxYeXFHWTgrc2NtSm5I?=
 =?utf-8?B?N0p5N3ZQYS9iaHNuSDVzZG9Vdk83WTlzblF4Qm03TjFzWWRSN29BYVozQmZI?=
 =?utf-8?B?UTlWRkd2b2F5RmhSdnFYOGZMKzZrV3M0cytwN0RiWEhuR2hEK3pKUVhsY3BV?=
 =?utf-8?B?R0RHdklDU05lUXZvYytma2x1dERvWEtPajNTeUlEYTdBQ240ZmJ4QmhTbnR5?=
 =?utf-8?B?aGRnWUdrTjUrYXNCdCtxSzZBU2JSUGt6anU4TzJ2Z0JsVTZhVWNPcHR2UDRI?=
 =?utf-8?B?NEhrRmVaVWY0aFhSOU5qakFoc3JPRm1PTEMxdUpPVFgvejE5ZXpNWWUrSkQ5?=
 =?utf-8?B?a2RwdUVLZGlDd29rMnhNZDUyMHVNNEZjd0pody9EQ2FmbGszcWRZMHR5RUVP?=
 =?utf-8?B?Zytjb0tRZmdWczI5d2JwZUtVdmZ4VFgrM0s1eWt2RmplQmdPZ3JDRkVEYlhy?=
 =?utf-8?B?c3REdnpBalRqZDVSWnY1SnBUc0tIdUVhUldaSWwxaXhJNWJXMDJ3cUhsdWl3?=
 =?utf-8?B?eFVTc0tFLzdaTXB4YUsrZThLOHZFTGFYZjFiS0U1aEtUMFRkemFnYkxYalhJ?=
 =?utf-8?B?dVUzSEt3dEJ2dFkyZUVITFcvbzN1alVRd3NHV3FJc2svRlcxUklrYTIzVlhI?=
 =?utf-8?B?cFBxRlIxU1BWR25iU25PM0U2QkVuKzNGOGkrUWw3UzVYMExiQ2ZTVXNvSFg0?=
 =?utf-8?B?ais5QU5aZmdXTnJJdUJWR3NhSXI0UFJYa2ZDakxzK2F2bFNFTG1Ib1VQTStv?=
 =?utf-8?B?ZGxnZm5DR2lsVFVMSVpmd084c0w1VVIrbDFjWmhrc1Vzb2tXMHBoRUlMVTFy?=
 =?utf-8?B?SC91MkJ3aXdsbUxaZGVnYkdldjMveno1MDVHQXNkTUpBcUVEUWFMM2RvRlNz?=
 =?utf-8?B?VTQ5OXpXZXRaM0dyS05QNHZ1U3NjeDVBQnUwSEp1c0ZsS2xyU21XZEFPQm1q?=
 =?utf-8?B?TWRCZ0Qwa0VYK2FSMytYclBGSjNCZzNYSmhEdklrY05WR1JFVVU3WFRqdDFw?=
 =?utf-8?B?SmJsS1V2TlQ0OVo3T3U4dXZBQ2JpMitvajlNYWlVNjNDZ3RGbXdXZ2kyNTFx?=
 =?utf-8?B?bys3Ym9TL0xpQVp6OVB5TjdNOGNQV0xVVHF1VkV1QXdMUzJtaFRJNEx2bW5u?=
 =?utf-8?B?aVBhTlpqcENzd2owQUFzNHpGN3puT2lqTFlxejhpOEpBb09IcVY3R0VNaDBj?=
 =?utf-8?B?aksyVVJuNS9UQ0FJQ0ZmMHZsMmFDckpVb0hwNCtoWkhWRWxVK3dQTnR2Z3JY?=
 =?utf-8?B?aTJWaWtkc3N0SDNKTEczWWFTekVndXljZ0FUR0g3VGpRZ2lsMUgyRko0Wkdw?=
 =?utf-8?B?VGV2WU1JRkJPZ01xZkU5VHVEOURUNDJjbko4dGZleCtqU0ZpaEpMOE5yLzhY?=
 =?utf-8?B?dStPN0FyVmxVY05nYVVtVDA3NXdLU3I0Z3pUK2NISUlocEx4b1BzOU5YQUZX?=
 =?utf-8?B?U3BjLzkwTGRPcEp2eElnRTQ4Z0xCVWtGTjI5bE1KYXZCcDJnendwV1JxZ2JT?=
 =?utf-8?Q?ZNWljS4p8T3cRUn5I2MBalw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a12c885-99cd-4d8b-1e36-08d9ba5cf6b2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 15:11:09.0310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u6IeYcWAQcxTch1eQqXHznCViBBlfLJRolCOEdKXlh3XGup4x1tSxkJ620LGGn5RGi9UeqMkEHyvURDo/mkSJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3818
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 08.12.2021 15:59, Jakub Kicinski wrote:
> On Wed, 8 Dec 2021 15:09:17 +0100 Andrzej Hajda wrote:
>> On 05.12.2021 05:21, Eric Dumazet wrote:
>>> From: Eric Dumazet <edumazet@google.com>
>>>
>>> It can be hard to track where references are taken and released.
>>>
>>> In networking, we have annoying issues at device or netns dismantles,
>>> and we had various proposals to ease root causing them.
>>>
>>> This patch adds new infrastructure pairing refcount increases
>>> and decreases. This will self document code, because programmers
>>> will have to associate increments/decrements.
>>>
>>> This is controled by CONFIG_REF_TRACKER which can be selected
>>> by users of this feature.
>>>
>>> This adds both cpu and memory costs, and thus should probably be
>>> used with care.
>>>
>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>> Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
>> Life is surprising, I was working on my own framework, solving the same
>> issue, with intention to publish it in few days :)
>>
>> My approach was little different:
>>
>> 1. Instead of creating separate framework I have extended debug_objects.
>>
>> 2. There were no additional fields in refcounted object and trackers -
>> infrastructure of debug_objects was reused - debug_objects tracked both
>> pointers of refcounted object and its users.
>>
>>
>> Have you considered using debug_object? it seems to be good place to put
>> it there, I am not sure about performance differences.
> Something along these lines?
>
> https://lore.kernel.org/all/20211117174723.2305681-1-kuba@kernel.org/
>
> ;)


Ups, I was not clear in my last sentence, I meant "extend debug_objects 
with tracking users of the object" :)


Regards

Andrzej


>
>> One more thing about design - as I understand CONFIG_REF_TRACKER turns
>> on all trackers in whole kernel, have you considered possibility/helpers
>> to enable/disable tracking per class of objects?
