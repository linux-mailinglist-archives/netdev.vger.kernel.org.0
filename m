Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9682F47828D
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 02:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhLQByB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 20:54:01 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62794 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232143AbhLQByA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 20:54:00 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 1BH1qPGS024780;
        Thu, 16 Dec 2021 17:53:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=oMTB0deKg4+xt+f9fdrozLMHfy2sKYXhN8LRzcBon2U=;
 b=YtU6PTjUmz1HLiuwNDHTg/CqjvXcg26d9O1wx+3QyfqEQIQtWhA8NNPt0jc+MTVZCOLc
 Na9CcrqmLj44eZbxliyGeILI7dWO5ZlNoXSoFhUPSTALZ3i2RzkKhodgamc520BANNAZ
 pmaX+nY3f2lZ/DASDbbRKjn5sV4LZG4KPFg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3d0h91r06j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 16 Dec 2021 17:53:59 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 16 Dec 2021 17:53:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cuQLAinuAOFFoZeKz7KXVWe7ioCWwRFUq4KVpbQDUg60CLFyu0LqZAHpEbCnd1/i60ooypqWg8UTpXtItXKBzQoiSGujZvJKKt4c4CmFCNk3+deQBP9N5vOz16x2ZxoaungISvRmPGuPuo13F0qThHL5Ch4hOA9ixeNFOkiwteqjRCf1uqhRLIgsQ1wzX23NuFOWOVrXeCxiytFYMtG3Jsjs4lBRyMSto13ucuh8CDaOnKXXGd/h1hKBXfj0OKwxHjHBOGarK8eaNDkrzmdkJ4+yytH5HWBep6CydZLWW2PGrgk6/VqiKCPd460r7xYAgYcbUHy0W2LxwUm1VcEuVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oMTB0deKg4+xt+f9fdrozLMHfy2sKYXhN8LRzcBon2U=;
 b=cRy0u2g4avTSJXRFrwZAqhBFCmF98iWbAagKQ6O02kDMG53PsHFLzHMFbXXF5LF3CDKQoEwbjhv5d/uQvNhlK2kqaYyp/cpUXQN568TLHad0mV7JuP6sp5xfp+iFc/LiOtbopctcKfk58TDeh/dek9D6Ruwyk60rbqlEIXIjhecMc7498EwN9gsFiIUw4Z+5sCpCGktAsonQdUf5l6znWaoE5+K2hJFPU2DYwk2TClxO+upI/S3o7NapIJuqDw851UH7PSoojoufd/Zco3c1uzIMnD4zRXK9ty1yQCw52iG86AA16iMeWa6jJx/w+sLMoZjB66/1DwtpS66Cs35M8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5283.namprd15.prod.outlook.com (2603:10b6:806:23b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Fri, 17 Dec
 2021 01:53:56 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33%6]) with mapi id 15.20.4801.015; Fri, 17 Dec 2021
 01:53:56 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "Peter Ziljstra" <peterz@infradead.org>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH v2 bpf-next 0/7] bpf_prog_pack allocator
Thread-Topic: [PATCH v2 bpf-next 0/7] bpf_prog_pack allocator
Thread-Index: AQHX8Xkz/fv1YJcIlkCbgavAsgZfuqw1jcSAgABhLIA=
Date:   Fri, 17 Dec 2021 01:53:56 +0000
Message-ID: <DC857926-ECDA-4DF0-8058-C53DD15226AE@fb.com>
References: <20211215060102.3793196-1-song@kernel.org>
 <CAEf4BzaFYPWCycTx+pHefhRHgD2n1WPyy9-L9TDJ8rHyGTaQSQ@mail.gmail.com>
In-Reply-To: <CAEf4BzaFYPWCycTx+pHefhRHgD2n1WPyy9-L9TDJ8rHyGTaQSQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efdf04ef-2e3a-465a-9516-08d9c100165a
x-ms-traffictypediagnostic: SA1PR15MB5283:EE_
x-microsoft-antispam-prvs: <SA1PR15MB5283393F154D3969B2CCFEA3B3789@SA1PR15MB5283.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D5/gpCT7nNGF9iq4Ol/jhhEklwcNu/w6We/KbzBuwP8l8vkL1mdNaLlrdm2w50l8DwJVv49lae162RudsNRuDVvFOnFY85m9MlZdwhKobtfe3R+HM14LwOl4Ra6A0AMd/7GgEvbFR3ois8tPl/R10W5+JFeUjRka4RHcNj+exsUDBcztfVypUfyGayWEKwWWxi8cRU70SU6APyRu9t+r+L7M1vQObWC/9lUbm8sb7DULf4g22FdllV3TiDUMM/+pNaDVwt4HBITJpuap22Kb72nYnFh7KjsDhD7iu20tr20k7rNL5OnEWiT11OVNOsQYH1B3Q/R6QB/iW90t4xZtmP3mDKdBQnrRQitoYer1c2aKVj1ilFP6qOJ8exveG0sVbwkOA9gRMGAvIw+Km9wvr9hukbfX4jdhBTNvay0lMppBjaLwA3bJrumo76hxyGhr5205o3qBjiYnyQ6dsdPJXnNIaA7KXq/QCIDwl28ltZKlRpxs3ZejyziB3kOkcCUI8AP9EAXKktNEFAwpayPCE3KkFiM0X7WGiv7EVnSRd1zOMJj4BHXkMVXkxzJtnMHvNHVG3MrE1BL1BtWwj/5zSEU/J79wzbJMvsfkIfcrL2dZ1kK60ky4HJir8PuPMI/Y15LkCjtITyYzOVCblwJYnExiDJ0pArTXaw8ToGLvE06GqPJ1vOKzWdxOZYhM1b7F6+9nmKI0CgmlK5UyjsiQARRvY+P1hJppoPET78spur9bX4w/CKAOS3uBbKz+/u4kruXLAdk9FbcVMlYT2ckM7cJOlHHamUX0hn05AE4zkKfctEuMJFEVYc1ZTLpiDSKTnhDxNF8r9jTA9xd5OOmNSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(66556008)(64756008)(91956017)(8676002)(38100700002)(6916009)(2906002)(76116006)(8936002)(316002)(83380400001)(86362001)(71200400001)(7416002)(33656002)(966005)(186003)(508600001)(53546011)(6506007)(66946007)(122000001)(6486002)(4326008)(38070700005)(5660300002)(36756003)(66476007)(54906003)(2616005)(66446008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?snt/xZkQX/r60Si9COxGVyyfkcqOD1Spg4NizQi0wSpRJiGJ2F80YFQkhF9z?=
 =?us-ascii?Q?+EUwYE9o9+31QEJ38xi7iP6pjyv53yd3vh9GcA6sB2p3rnP+YlE3EKzV+3LR?=
 =?us-ascii?Q?LAuTL0imUe6B46TOLifVU5zgodiODKovckssxbR34xKl/Sl53oTtA3ZinTC/?=
 =?us-ascii?Q?F2MxH2Pbx9G0c0gQvc/ZBZynV9gXYHDro0yjoL1QbXermtGxoRymDqi2rauj?=
 =?us-ascii?Q?ZFPMASdTHoHcY9QM2NT8ISLEhZayUiZtzdIw4wxPk8EDW6zwNnCuCcTvfRFk?=
 =?us-ascii?Q?0gnjsHY6U4DaGd9M1gTM0RJBLsEjzEJpnqSmEa/mIejtXKlwZrrr0Oy3m78k?=
 =?us-ascii?Q?RDpZrvwlbosubvZTYqG708cP7YOexTAqwux+0LrYH3ZhC7ZA85FNefzi6KS6?=
 =?us-ascii?Q?ooOyWx9sktkmtkidM0AnJChKBv1EY+R0mT5z+spQPm6/vyDjaJYdcKVOibNq?=
 =?us-ascii?Q?6dDIDPuGzn2LujiKsYQ0dq/hlPe/BdfZ9LG+bhQ62WjHeAWmLnozorBu7NDk?=
 =?us-ascii?Q?nDO2CJ7qLk1jABkruDyt6RGfH/E8VF3kqxVqw8p1SDqPmiuMT+1gb9jCOLTt?=
 =?us-ascii?Q?ZjyRbiRBQUqvSG4w6K9AeInhrmKoLoJ6XUSB+EZlhjpQzQdAWDlW417pscsD?=
 =?us-ascii?Q?Vb0guVpzIR7M1Wb9fyxiNW6t/HIGJ47ohhw4XarAwss9sav4RziKVISIJ8VM?=
 =?us-ascii?Q?TP8wg+hxGUAWri19Ho14jAh8NcXPIBu3tJ7vIPi1RCgOgSO/wlv4TRkBiD3y?=
 =?us-ascii?Q?MW/1sYBZWxFQFgHxfSain9AJEmpebdfzBshFumVgf6DF5Ob+lWdKIARZ5R7G?=
 =?us-ascii?Q?OllfFnEEpY8JEu8vw5OQ9qTcU/92LSoF2JYoEtPxf2wNhZD3ZqJJ2i/44RoV?=
 =?us-ascii?Q?ziAiRD4AuBc0gp5GylLrSi691qbC8AOk/44D6CBC+2mE+/DRZnrjht/Al97b?=
 =?us-ascii?Q?OWt/boWcrX+1wD914Bfpcbrq3+FsLO3Vy6Uu9gc2STgwHUgFbmlvKkggNx62?=
 =?us-ascii?Q?fKFpOm8wk/aw5MiDMX9mzUPnvBOZIDuNZm09ca66lO6u/b4YXUW5Q+FGsxwp?=
 =?us-ascii?Q?X/MU8BtCudruRxaMM1+wXTKJyMKBsaZuUTT1/z+ZoHtUwDCENGwVCT8dPDcy?=
 =?us-ascii?Q?09WtBIKr0jAFY1PACiZpbg4vrsBgjUx/SBpbEgGwKjmyfcPikb4pCysIcbRS?=
 =?us-ascii?Q?QoMxlQpJQhDUonpf59RZsA+MXjTx6jJcjRa8dxB2vgvhnqoT1Uj7DXqZJmVb?=
 =?us-ascii?Q?dVF//LGY86pos1+/bt6riVjBQjqWiM+9sj0p05NwpYyNTHM7rHSYsFmuw2Jb?=
 =?us-ascii?Q?3us/fvgJ0rnPM1zxcAkFDqG7FIyNgBtoZZw+d8em1lqClqem4zvQ4Bs6s2sR?=
 =?us-ascii?Q?c8Wfrr/5hYNsffFLcqZTs62WA62sZR1bLzylFma21YSHmAbTakcqbxILRC9G?=
 =?us-ascii?Q?S4ti0NosUCK7/J2ZQq7qDeVDxKZenoI9iJbeuKezxbyak1KL61g+XCFbbrXG?=
 =?us-ascii?Q?a/qsbktHzfwsXrNoSxtbqaaSRpjIhtqaXfW0fYY2oymIl/ErzunxC4Y6whxO?=
 =?us-ascii?Q?YdSccy1usYRPryg3SWVF/cR7P70cS11O1q/oeq8cpqMdY3odY5uTHufohE3O?=
 =?us-ascii?Q?8krtNO05PXY4BLEgRzaWsoGdRio/qKYWJUwotgxxDvPctC190V9bSoR+J67n?=
 =?us-ascii?Q?CDgowg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E4CBFAED1DE0F5479CCF3C9C7B97EE61@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efdf04ef-2e3a-465a-9516-08d9c100165a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2021 01:53:56.7875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KlzZizBh0v0NOCcSUihxFFIQPvTZjn+by+V1TfY9KYNVD6IFlfwvWT2JdeR6ta2Al/nALq+k77/Euw23Foeo8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5283
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: L95gel4FS8goozTbleMSLvxI-Cg0OvjF
X-Proofpoint-GUID: L95gel4FS8goozTbleMSLvxI-Cg0OvjF
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-16_09,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 spamscore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112170007
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 16, 2021, at 12:06 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> 
> On Tue, Dec 14, 2021 at 10:01 PM Song Liu <song@kernel.org> wrote:
>> 
>> Changes v1 => v2:
>> 1. Use text_poke instead of writing through linear mapping. (Peter)
>> 2. Avoid making changes to non-x86_64 code.
>> 
>> Most BPF programs are small, but they consume a page each. For systems
>> with busy traffic and many BPF programs, this could also add significant
>> pressure to instruction TLB.
>> 
>> This set tries to solve this problem with customized allocator that pack
>> multiple programs into a huge page.
>> 
>> Patches 1-5 prepare the work. Patch 6 contains key logic of the allocator.
>> Patch 7 uses this allocator in x86_64 jit compiler.
>> 
> 
> There are test failures, please see [0]. But I was also wondering if
> there could be an explicit selftest added to validate that all this
> huge page machinery is actually activated and working as expected?

We can enable some debug option that dumps the page table. Then from the
page table, we can confirm the programs are running on a huge page. This 
only works on x86_64 though. WDYT?

Thanks,
Song


> 
>  [0] https://github.com/kernel-patches/bpf/runs/4530372387?check_suite_focus=true
> 
>> Song Liu (7):
>>  x86/Kconfig: select HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
>>  bpf: use bytes instead of pages for bpf_jit_[charge|uncharge]_modmem
>>  bpf: use size instead of pages in bpf_binary_header
>>  bpf: add a pointer of bpf_binary_header to bpf_prog
>>  x86/alternative: introduce text_poke_jit
>>  bpf: introduce bpf_prog_pack allocator
>>  bpf, x86_64: use bpf_prog_pack allocator
>> 
>> arch/x86/Kconfig                     |   1 +
>> arch/x86/include/asm/text-patching.h |   1 +
>> arch/x86/kernel/alternative.c        |  28 ++++
>> arch/x86/net/bpf_jit_comp.c          |  93 ++++++++++--
>> include/linux/bpf.h                  |   4 +-
>> include/linux/filter.h               |  23 ++-
>> kernel/bpf/core.c                    | 213 ++++++++++++++++++++++++---
>> kernel/bpf/trampoline.c              |   6 +-
>> 8 files changed, 328 insertions(+), 41 deletions(-)
>> 
>> --
>> 2.30.2

