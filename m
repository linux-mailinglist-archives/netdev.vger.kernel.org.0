Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B5751E983
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 21:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446886AbiEGTkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 15:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiEGTka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 15:40:30 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0C51FA55;
        Sat,  7 May 2022 12:36:42 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 247AsbSE011728;
        Sat, 7 May 2022 12:36:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=FrqbV3KVdQ2TKtI14PLmfrVNqloLDbuw5B1N3TegboE=;
 b=SwNHGuEkuj3Cvj4C6K7hlDtGQz90mjmHygM1V9MNdmQqETNtSuvbd1hqI6NV+dnjVfxm
 7htw1KsWsG2aSwHjzIHfjqbUi53YeScYfGOy2sqgj299eYRlkTy4V2hdt/Y9USuZcsAC
 fnDh+GpYDgNgzLj7AjnbYr0DlCBrR5+dXSg= 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fwpfmhfar-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 May 2022 12:36:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PfRvVpnQzaJbJv3S8ruqjBz+llswegI8GXndTA0pZRIHZ9MBmiuxRYPwBkqDeoL3h3D0jx5JqAvGYvUWkLE16WSFpgwqIQLBHnOCdOEFVTk4Gwpp8IUAIh6tUIziASPfhLplhIeKQ8ukwWYK4LF/wNnAkkc41E5BuJ9LrV7oJDbzytmvO7y5cM6GHQG6qnD9DyZBPmgZ0KOztFzioxjzVdG/0OJfKI6MPe6Y+EUX7V8Go8gxQpwN9oEWNaDSsvXCO8FmV3JqBeC00rRZEAhVyN4GPTUpy0lbraK6P+xVzAjiRmjJn7xhCzyYnjhfihdMpBRRxbyKSihVVcD9kMrBdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FrqbV3KVdQ2TKtI14PLmfrVNqloLDbuw5B1N3TegboE=;
 b=makCCo3nwzYRYivlySlpGJTDnZ6+td7coRk7FTIFMF/X7lgqrV2PIjqE2ft4RYNRuNmkVaeloKB01ZJG4VEHcJkVywe8bwZeV47tBCrUJFqAqgj8AZ93g18GTEYqu4xee7JRI/gBRuxnmGwKmizUsNE299QaL8NH6pM1J9ff2LW/i3WoGcKwQS8e1MaSz1J00NqG7+A9fm39bSrI80z6hAJu8yDh6QpP8+tho62CtzQihZqmjnotn36fsldaNFJ03xreNPO5mgL6ePWDL9YGMzQNx3NvfJJezevOMCIxUY/WcHCN0x6KXlFvjL+6rE4i6dqQNZrT62nfkr/Y9EHNng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BN6PR15MB1826.namprd15.prod.outlook.com (2603:10b6:405:57::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sat, 7 May
 2022 19:36:39 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::4133:c564:79a7:74d5]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::4133:c564:79a7:74d5%6]) with mapi id 15.20.5206.025; Sat, 7 May 2022
 19:36:39 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH bpf v2 0/3] bpf: invalidate unused part of bpf_prog_pack
Thread-Topic: [PATCH bpf v2 0/3] bpf: invalidate unused part of bpf_prog_pack
Thread-Index: AQHYWOUphDgBQzjiX0ac6c+Sg/0OBq0EVWkAgAA8D4CAAFTGAIAOJWIAgADWHYA=
Date:   Sat, 7 May 2022 19:36:39 +0000
Message-ID: <110CB061-8DA5-400B-AAE3-13FAFE0ADE90@fb.com>
References: <20220425203947.3311308-1-song@kernel.org>
 <FF2E0EC1-F9D6-4196-8887-919207BDC599@fb.com>
 <CAHk-=wgA1Uku=ejwknv11ssNhz2pswhD=mJFBPEMQtCspz0YEQ@mail.gmail.com>
 <57DBEBDB-71AF-4A85-AB8D-8274541E0F3C@fb.com>
 <719D99A4-3100-49EC-A7D6-6F9CDBA053C4@fb.com>
In-Reply-To: <719D99A4-3100-49EC-A7D6-6F9CDBA053C4@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a11a6471-b2ec-4717-2549-08da3060e7f8
x-ms-traffictypediagnostic: BN6PR15MB1826:EE_
x-microsoft-antispam-prvs: <BN6PR15MB182613BCE019A60A3C7E78C8B3C49@BN6PR15MB1826.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TqYokyhpBk9iC351UBMOLDUcePgT+fGAA1nky/M7oVqX5OE351WC3z0ZX5Yd5VIwQ/jAmuaJfBiTsyjJFL+NhTTYEWbP5CY7mLVzqUiRqMEuYjWoEFtn1Za4oOn0aBK0piWHOfZyVJFfm5z2LF9wLPlaUxIU89+/dH/koIlJoR8/YHpTCGeFqRLNcvC7uFnBR4b/nC13jz9OU2VusDRI5yyGhE7KICLDhIXmXO8U+dWqTJOfiNZ8EBijaQdn+FN+hRJuhH2X5y2PDGEYq80HPTItsh916Sj6UoES/EK8ZfXRuUupILR8YcMq+mcr4FnyHXWQXX0c2YeFGPxiSa9j+IzKfUMc39HQGYrwufl61g65HjZjQE3ikCWORugSZHMkLRCsHTE4GddhZELaXQxt0WWcq9CcDZd5WteXMEqFrbjKSOIUnnqN701dx6wOmyxaeSOD0AnDPJUhnRhY6MXEmbZb60GRCWeR+54Eve1TJ6KpuG4nxmW4cDFQqfw/6qlD7AFLOu+RTwff19PooZJO3+Sue++d0UOagxBktNhT9pfA7SGCeAeUKGeZQJtXMCUJiAkKMxDQTmp29odGSzqvwZEUPnLEBAfwUyd75nK0YDyEcgjAnR8bIqJpF2GG66k+8APnzDrv9AAAxgDUmP3zQQw4Y4SVe61ZDAah9BaggM+FWAHd9FIX1Z0G5s23j/sGJzzgMfB51fjHPgC1xxBPo8H6lvIklo5g9sW42/eRE40Uj/u6qrgitTTzIqjvMJAD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(38100700002)(91956017)(76116006)(186003)(66946007)(66476007)(66556008)(64756008)(33656002)(66446008)(8936002)(83380400001)(5660300002)(2616005)(6512007)(4326008)(7416002)(8676002)(71200400001)(54906003)(53546011)(86362001)(508600001)(6916009)(6506007)(6486002)(2906002)(38070700005)(316002)(122000001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ThVQi3iwEQjVYUYqXu45AMSJVKcxb4X4lyZ8mELMi/aW9V8Ouc2zq7KXBKi2?=
 =?us-ascii?Q?nCUfj8GndEmshGhg9PTnNm80EpxxlBTRHA7Qz7furpCWB0SuhjyfLjlXgvnE?=
 =?us-ascii?Q?ijUtGIHVxQP8U5/5ltMtbN5pd5wEt89YaHXdxbg1yyb5xzuag2p8BUeTppTh?=
 =?us-ascii?Q?CghuoOtnjdPUwdSkYzdvXNR+5HJims91URAoKPD5DfyCnnU2Ljcs3B0KXfn8?=
 =?us-ascii?Q?iZaG1MQwV+ML5XIpOEpas+NBbgaF4BPsswI0AXjaniq/p67pLot6EQVfVJ+D?=
 =?us-ascii?Q?/Wkmddwk+PMVG1xlLwFSP+g8YfGRLc2trrtmsWKNMNDTJwDObFgnP/hH3zLw?=
 =?us-ascii?Q?JAENt91zVkFCsT8gNoEq7VD6Ao1nWaFvLxZGjwQS2wWkc2GtxHASbP34aKMw?=
 =?us-ascii?Q?VUey89Xe0z/YNZH1KdklsJk1p3ggN5L1LwWDH/iT8mDZxGSrCt14mSc2Vppn?=
 =?us-ascii?Q?vfzFZ3RI01vA7BrHEN0D50wEFuGGPQAzQUybknZOktWKxiHz2dL+VrFJdM/w?=
 =?us-ascii?Q?j2JOsA3yW8XRXxYhGYshp00qkgk2gZB6Qan1Q8/0WoecZ+z6oSyiALDVQDRH?=
 =?us-ascii?Q?WPWkSl+PKMB5Rkx6Zn1G+xjXOVGYsuqBnopgqXqmUEUrwXBSCPAgumdm/AHJ?=
 =?us-ascii?Q?cxniNu1oQemJaYcACoKSitLV2KKCOXmRQ128ga4FZ8rFHcrhhvQDtiPtHRdV?=
 =?us-ascii?Q?sXVqJbiNNZnpYjWslUGGOtZuiQ7r0gFWRFpvdy/PMrf7Wztr11uuciYWKGYz?=
 =?us-ascii?Q?uqrXvd2HRWfqnnSRvWHluiQcSX6Z3g01MYkA/u5gVxUatfCoTTrgcgo5ljWx?=
 =?us-ascii?Q?AgaETKyYJj6+IZYjJXpu4Y+lHOaRQXsGQ4M6gtcARdr7BNferkKcQSd646Qa?=
 =?us-ascii?Q?xLU0rLpKw3cPGcvyTgh8DfF8iKWiNXKRlVD1B+z4TEMC3ipVBSzZ/m86zkCl?=
 =?us-ascii?Q?Zwv2rxvePPg10XX7sReLKfj0RKQZ2yf2Ak3Z9zjFm/iOyz96yhWW3rqsbVvJ?=
 =?us-ascii?Q?ZYj4QVrNYjmn6XgDZxlBAMJA1YVafWGdafpr/BGGQ8yY4GPVuqUvhXzWkD7e?=
 =?us-ascii?Q?PMVk+zmVBu1Bvji0+l89maP9WLEvYfMlM/aTF8UylMacfg9xby9fllzN9iF0?=
 =?us-ascii?Q?7PGQBXQwkTvxTc0Vc+5Z7+TRkl1BzPs8n9xRBwSZUuquiJewf3cy6T03NqTq?=
 =?us-ascii?Q?HUwSYujk9CHXFw+w8AKaFblZEwhdRAaIFCKRM0eQH2eW7fyA7putWTWu5GzP?=
 =?us-ascii?Q?1uybEK39+IfOpgxfGsAS6rivKhKZ/A39u3dhvFZsiLtd3KqZs6HDyHCxS1Jj?=
 =?us-ascii?Q?odhPy302ZsGZe9kagI5jqxwlp8JCmdBqo8bDbzyXW7sPd/rYhibsuDyXgQ/6?=
 =?us-ascii?Q?WuU4Pf4jqk4vix4dIke/4h0Roxpx6GNoV9JnRvLVUeImMiFoF/zlemFWLP7w?=
 =?us-ascii?Q?8lUIiPSYyjvwsHdyQ6jlcURykBRhVZEUbAHbQNLY70r44i/BtSE7xX2EeK1q?=
 =?us-ascii?Q?dNqqFRUB03eJEiAyu/rD6SJykyp3TUm5aHJ3Nmxy2r8nTW21wfOq2GcHAK17?=
 =?us-ascii?Q?+7Rf9YddTsnOw8081UwamBX+ozg8QYrmzEsoPp+WENYbOoluu3IsZmDvDLDu?=
 =?us-ascii?Q?9lVN6s800WEaP/KEH+xb7bVSd3jbcpW/7Hw8u/pzUkXGE/fJCfH4mR8xop89?=
 =?us-ascii?Q?FRUnYOSrnXOcBOisdoQXqoPfMZs4QQw7bt0b5TYn0+UOGSQJZUQJZUG4Lxgr?=
 =?us-ascii?Q?qI8Y5Qq8XQsKG0LzQ0p0HCmVWBAM5q0JnUEAh+P/MrTYkHhGl8He?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <55DC5A598AF2AC40A9DA68423F34C8C5@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a11a6471-b2ec-4717-2549-08da3060e7f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2022 19:36:39.2514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: STWqoJcGlQRcZnSDV9Dm+l+H372o4VI6pDLkNCAt03JWiOWy1oC2QAgAPWKIylv3CDhDKpRKbvVeAQbI2zMLQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1826
X-Proofpoint-ORIG-GUID: s_EA2ads4Aw383lMS2DcErNPrHDdlmwH
X-Proofpoint-GUID: s_EA2ads4Aw383lMS2DcErNPrHDdlmwH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-07_06,2022-05-06_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 6, 2022, at 11:50 PM, Song Liu <songliubraving@fb.com> wrote:
> 
> 
> 
>> On Apr 27, 2022, at 11:48 PM, Song Liu <songliubraving@fb.com> wrote:
>> 
>> Hi Linus, 
>> 
>> Thanks for your thorough analysis of the situation, which make a lot of
>> sense. 
>> 
>>> On Apr 27, 2022, at 6:45 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>> 
>>> On Wed, Apr 27, 2022 at 3:24 PM Song Liu <songliubraving@fb.com> wrote:
>>>> 
>>>> Could you please share your suggestions on this set? Shall we ship it
>>>> with 5.18?
>>> 
>>> I'd personally prefer to just not do the prog_pack thing at all, since
>>> I don't think it was actually in a "ready to ship" state for this
>>> merge window, and the hugepage mapping protection games I'm still
>>> leery of.
>>> 
>>> Yes, the hugepage protection things probably do work from what I saw
>>> when I looked through them, but that x86 vmalloc hugepage code was
>>> really designed for another use (non-refcounted device pages), so the
>>> fact that it all actually seems surprisingly ok certainly wasn't
>>> because the code was designed to do that new case.
>>> 
>>> Does the prog_pack thing work with small pages?
>>> 
>>> Yes. But that wasn't what it was designed for or its selling point, so
>>> it all is a bit suspect to me.
>> 
>> prog_pack on small pages can also reduce the direct map fragmentation.
>> This is because libbpf uses tiny BPF programs to probe kernel features. 
>> Before prog_pack, all these BPF programs can fragment the direct map.
>> For example, runqslower (tools/bpf/runqslower/) loads total 7 BPF programs 
>> (3 actual programs and 4 tiny probe programs). All these programs may 
>> cause direct map fragmentation. With prog_pack, OTOH, these BPF programs 
>> would fit in a single page (or even share pages with other tools). 
> 
> Here are some performance data from our web service production benchmark, 
> which is the biggest service in our fleet. We compare 3 kernels:    
> 
>  nopack: no bpf_prog_pack; IOW, the same behavior as 5.17
>  4kpack: use bpf_prog_pack on 4kB pages (same as 5.18-rc5)
>  2mpack: use bpf_prog_pack on 2MB pages
> 
> The benchmark measures system throughput under latency constraints. 
> 4kpack provides 0.5% to 0.7% more throughput than nopack. 
> 2mpack provides 0.6% to 0.9% more throughput than nopack. 
> 
> So the data has confirmed:
> 1. Direct map fragmentation has non-trivial impact on system performance;
> 2. While 2MB pages are preferred, bpf_prog_pack on 4kB pages also gives 
>   Significant performance improvements.  

Please note that 0.5% is a huge improvement for our fleet. I believe this
is also significant for other companies with many thousand servers. 

Thanks,
Song
