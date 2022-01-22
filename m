Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8BD496902
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 02:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiAVBBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 20:01:45 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24892 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231226AbiAVBBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 20:01:45 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20LGKBxX019789;
        Fri, 21 Jan 2022 17:01:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=tEfJ0jx4qzHmSMzeBm8Z1d9RmqreDWmQGzEIkb1RNr8=;
 b=YLAEDfOEMyhhXkS8wfw4f3AwTqwfJuhrNp5Z5SBhGaUIyJEjYoVfDtsCoCZIKFjyjuUe
 7nS0A9li6cGOGQYhWd01hBXjN5CY7OPyIB0oEJi/WP29PXPma1+MX3xLHfbWxqcZqyYO
 Dca+jAcxi5UaKuBhZ7Q3d4OPYAM2giFSFiU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dqhyvy2rg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 21 Jan 2022 17:01:44 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 21 Jan 2022 17:01:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrO2yZVJ3GYXLKHw+T85twRDBYccbR4/gs1dY7hr9LongxozeJbhRHSRBB4RxDmX5dZx3EkBV3TTP9dij7CjKNNXK5Gup42oBQTyKV84lmKZA4gVMZx2zxT5feO6mkFtjGrEUWuGwWQCEF7AhyaF9Jyz6/FsEhZ9n7mHFNgzckIbzNMOfI3Uu1u5S9q7kYvgUZjsThduZNoJhtQV9UzmohNy5YSwreBuD1DRP7PKOYvL3ed/uhEes+1bsFbqssZ5h8Jh4lKzGvRYRdbhvpA472dslZPX75N2+Fx5L+9BlxodnRS9fVtbnbQEW6rV7O1MMnSpmLrzyNwKNggVPION2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tEfJ0jx4qzHmSMzeBm8Z1d9RmqreDWmQGzEIkb1RNr8=;
 b=amQhi48YL1lC4tSveDx2rUKnsrfNR8xHSJoLHBAOZP0GvycPRbzS3xbIqKCZxCTYA+ucZAhiRABfxYYecz7wP75nM+zyc3frGHw0yIxWsR54zs4piJOkvkaNQjLm5xGl2WdbjUtktO6oEGMc/W/ewv2YDlR6LTVXQh4LrNgfzoCdnTTAwXinnCYklwCYqegV86BPX+jbitljvtWNBwBTPhurfNgTG6iX9Aewrod7sHGVX13kkXeLn9X++l5BwFHAH7W5P4rIx+Lt9NhE0GxsX7dlb57HptqO41ILKqO/W3r/JGBEHWsuyzxYyXpujNAWLzXvjprvvhWdGXNx/qgg8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BN6PR15MB1428.namprd15.prod.outlook.com (2603:10b6:404:c3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Sat, 22 Jan
 2022 01:01:41 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e%7]) with mapi id 15.20.4909.012; Sat, 22 Jan 2022
 01:01:41 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "Peter Zijlstra" <peterz@infradead.org>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH v6 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
Thread-Topic: [PATCH v6 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
Thread-Index: AQHYDwA7v2eTErzZP02KrqTA2Ue2qKxuJqkAgAAH3QCAAAUSgIAABaKA
Date:   Sat, 22 Jan 2022 01:01:41 +0000
Message-ID: <5407DA0E-C0F8-4DA9-B407-3DE657301BB2@fb.com>
References: <20220121194926.1970172-1-song@kernel.org>
 <20220121194926.1970172-7-song@kernel.org>
 <CAADnVQK6+gWTUDo2z1H6AE5_DtuBBetW+VTwwKz03tpVdfuoHA@mail.gmail.com>
 <7393B983-3295-4B14-9528-B7BD04A82709@fb.com>
 <CAADnVQJLHXaU7tUJN=EM-Nt28xtu4vw9+Ox_uQsjh-E-4VNKoA@mail.gmail.com>
In-Reply-To: <CAADnVQJLHXaU7tUJN=EM-Nt28xtu4vw9+Ox_uQsjh-E-4VNKoA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb82fa28-3b63-4218-c9c1-08d9dd42c060
x-ms-traffictypediagnostic: BN6PR15MB1428:EE_
x-microsoft-antispam-prvs: <BN6PR15MB1428D08785E3B8BF742892C2B35C9@BN6PR15MB1428.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qn01xxo0QCCfiD47lpEMQjxKDrB05C27JxsVofRXiSYPTvZlKWNDZ9PoTqw0cMlxogjWVyH0b8sZj68OwXlMwWLaQxL5Ki8MzhVCS1xwpwNatc0TdQNk3//10V6CMqSQ2NspRPE0vkoO2w1ffmhcxFhqrfNq8y55SFRDKlOn/R/hU3R0pCTMXtGr7X6hsnjys/uEP0eMJMcWNA4xDr54uUcrV7y70QFY8BNA3p1zQnq+n+fa54c+uwbdwCtdKiDigtQKputPzRRrG/2Ip30Ry6quAUojnjwT3Sh+M7y2zvE02wMgPbSmYBoOd6We208e8MTVSTAQy/iFqtp3sbS8u029+tvbZUKz4JSPbnl1mcSQYJZdvHLvGS3V38RXRKUPAzvTTKkyACNSgPcsn+fX8ckdJfj4idknl0BIwljts01Bxk3peoPqerQeHQwllRSzFXkQlGRv13ZhYqX1SGBAlh8cddS7Krmzp7sGup+9dgQtPhteVS5CHLVBQHpP+tX/onm4qtbQ7UMNGPQgE4M76Itwy/hZ5REA9Xfn3ET/SeFCatxAda02jqL7g9ihAqIEL6ZGkOpMTBQmfyIA5jdTD2x8tRl3F8mIEO2QUsPlCpWHAAOhkg+glahwMp0xWOC7kTeUlPIMI/z5hHJpPtlSw2vjKzynaFMYkvwm1amkhxYQykkNQgi1WBIIeSIxkrPaM7Rd8Sy+Ih2nZW7NccLCeQLlh5WjncdWmsfzUD/z736JDqMeKM6STGaPF7GL8Xkc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(8936002)(186003)(86362001)(6506007)(53546011)(6916009)(8676002)(2906002)(36756003)(71200400001)(64756008)(508600001)(5660300002)(316002)(6486002)(6512007)(54906003)(76116006)(66556008)(66946007)(66476007)(66446008)(91956017)(38070700005)(4326008)(122000001)(33656002)(7416002)(38100700002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hyBglSWzbLhRwinLMp4auGrTHnWb9p7LtvSDgqPZy9Fh86XT1aPB++DcDk32?=
 =?us-ascii?Q?l8qOitmMQDmWo5jONYmJiRFRQ6aMymLpMVNWPROtXzWHD+b0M6PoxxdVGy+h?=
 =?us-ascii?Q?7irPrrfPwivJPWHx3msPCSv44iOT6h/rEB94MiviBOsBWrxzN93tHJ+5Vpla?=
 =?us-ascii?Q?1uJom6kLE2l0D49Max3w6PqzVMm/djLTviDV2OC0u5xUxN8SgQb4sHEcLD8x?=
 =?us-ascii?Q?2c82UYXLEcCbPxslwaI3EwH4ZbRNSa2jHj47Csd8Bvy6bDryfVZCWVxmUCdH?=
 =?us-ascii?Q?qY/Bzlp4eR3M2NO/n95p/3DHK0tTrzpACVbi7CfzbWAXxYmivCMdFdcW0fBy?=
 =?us-ascii?Q?mhiKMvxk18LpHpGcdvzfYi5XTAtYeV0yCtmoFEGlQILoPkIOiRDROOTLjbDe?=
 =?us-ascii?Q?3GbxNMGpCirnxTAaAg4ZrxI9fFXEyTKKYyJar/9zzTweKSxrH8jlHwxa1LdL?=
 =?us-ascii?Q?lKT0SJeN/HfB8qgCIMww7Kw2GCXvlmT/uELSrAIOarMTxIqEoCnGpPZ4TxR5?=
 =?us-ascii?Q?AMPyVxIhbGUuK78pxA2fzw2vHoNmD7JcHprR4UDnCJnuePDElJDEvTCtSpW2?=
 =?us-ascii?Q?wtHc4EGaGnatDaOOnhlSEAknYoWFoiIzO6r/1UT4s2ED7Xg/1UyZYRfZXNE9?=
 =?us-ascii?Q?vzWC+QMfGWGDnQUyRlpLupuSmjuwLMemnkqYIfb4eK/XjZ+HZm4MaBXCEVCX?=
 =?us-ascii?Q?LdLTCOTfVUe+bzJbEG/L3jHDK8Ey1Hn7u5OtTD4FEIHD5iCNcnySfQkA39xP?=
 =?us-ascii?Q?cmL7nDqiwbpclSxOkXFPEVZiTzEXti6LoVyJUxWxCY8yRji9fRYkPZYn9z58?=
 =?us-ascii?Q?+Hxybl7o5yOjtkgqPzDYCr1nRFYx1Ysid7ranx4VhfDbWxbdwh1W+RA3DtHU?=
 =?us-ascii?Q?3MbdHTYfOr2qi3S1o7k+CLg1Vk9w87j3F2VJAAT9GbMHncD9Y6SeKrxsaTEu?=
 =?us-ascii?Q?i48Pqr8U6ExaIaLTAEmJFW2zdFCF4MElLfrEx9o50hwXn8Ul+AhhXdwD9EPD?=
 =?us-ascii?Q?ppH6BkMZEkGPeBjbu5r+0ew5uZ60prM0iB1WSGs95CyWiOxLozOcFZ43sTIk?=
 =?us-ascii?Q?tGFR9Q0uNNudFF4VW9wcl0scf0kAVcFvWwo0qiUEDBLrdvSymbNrvvgkl9L3?=
 =?us-ascii?Q?tSmPiQTXGZnvl3Junz41OgCIbhgi7l79zWxgq3EmN2aWqZpXfaWEgw22/4wf?=
 =?us-ascii?Q?+CAHSqmUP765ZY24Y3+R5d1/e6xhpup3OAFrXoa6wprAyFmAt3qhL0a/n2GK?=
 =?us-ascii?Q?ssj8hnHDfGnkdzxt1tlx77ctNDlCzPED9NVYFzAJJZSBann4/I6kMpzlq8UK?=
 =?us-ascii?Q?ko5d7AXaSgIxdfq3mvTQGef+LSlznPBmJlT7iP+b95CY0OomLSrPWbQXJXqA?=
 =?us-ascii?Q?eOaLRXzgdCPorjXuO9yxEYWq146c6/tYpA7EXvuJx1k+X3Ykwpqq5RJoVPM1?=
 =?us-ascii?Q?7gA1zB5waPS7RGf0A/9ay+5S6JnKnDqk7HPOhj11cnGpd+Q1YiD11hmNZKV8?=
 =?us-ascii?Q?Nnx76vcwY46pcVdwWG0/P3LjVshl3sFwOzX99Ejgw5kIvyZlRZDgww7AsC3I?=
 =?us-ascii?Q?MlbsEjR2+hKOdsHw3PXFctRKdVagqWOu6TkhdBjfwzzZJ4T0Htb5CBZ/PD3T?=
 =?us-ascii?Q?HpKj4/utRUTUMvebXFjNqZx6tyxEKjVJqAPp9QW1eulB5WSyYSkfErGipUxp?=
 =?us-ascii?Q?lcq8Gw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DBD29F2D2F1980479E7767D387A2BAE5@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb82fa28-3b63-4218-c9c1-08d9dd42c060
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2022 01:01:41.4003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2yqKy/kSZUbJdyamKQoL0fdy1sThOBKiXitqsZ6MBqKdGkViINjIOVwj506AY9+aBis/JvM+pgECkeGY11flLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1428
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: vNqcrAbw0PyaCFKgqKnzmYGyfapSYFVL
X-Proofpoint-GUID: vNqcrAbw0PyaCFKgqKnzmYGyfapSYFVL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_10,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 spamscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 mlxlogscore=730 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201220002
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 21, 2022, at 4:41 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> On Fri, Jan 21, 2022 at 4:23 PM Song Liu <songliubraving@fb.com> wrote:
>> 
>> 
>> 
>>> On Jan 21, 2022, at 3:55 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>>> 
>>> On Fri, Jan 21, 2022 at 11:49 AM Song Liu <song@kernel.org> wrote:
>>>> 
>>>> +static struct bpf_binary_header *
>>>> +__bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
>>>> +                      unsigned int alignment,
>>>> +                      bpf_jit_fill_hole_t bpf_fill_ill_insns,
>>>> +                      u32 round_up_to)
>>>> +{
>>>> +       struct bpf_binary_header *hdr;
>>>> +       u32 size, hole, start;
>>>> +
>>>> +       WARN_ON_ONCE(!is_power_of_2(alignment) ||
>>>> +                    alignment > BPF_IMAGE_ALIGNMENT);
>>>> +
>>>> +       /* Most of BPF filters are really small, but if some of them
>>>> +        * fill a page, allow at least 128 extra bytes to insert a
>>>> +        * random section of illegal instructions.
>>>> +        */
>>>> +       size = round_up(proglen + sizeof(*hdr) + 128, round_up_to);
>>>> +
>>>> +       if (bpf_jit_charge_modmem(size))
>>>> +               return NULL;
>>>> +       hdr = bpf_jit_alloc_exec(size);
>>>> +       if (!hdr) {
>>>> +               bpf_jit_uncharge_modmem(size);
>>>> +               return NULL;
>>>> +       }
>>>> +
>>>> +       /* Fill space with illegal/arch-dep instructions. */
>>>> +       bpf_fill_ill_insns(hdr, size);
>>>> +
>>>> +       hdr->size = size;
>>>> +       hole = min_t(unsigned int, size - (proglen + sizeof(*hdr)),
>>>> +                    PAGE_SIZE - sizeof(*hdr));
>>> 
>>> It probably should be 'round_up_to' instead of PAGE_SIZE ?
>> 
>> Actually, some of these change is not longer needed after the following
>> change in v6:
>> 
>>  4. Change fall back round_up_to in bpf_jit_binary_alloc_pack() from
>>     BPF_PROG_MAX_PACK_PROG_SIZE to PAGE_SIZE.
>> 
>> My initial thought (last year) was if we allocate more than 2MB (either
>> 2.1MB or 3.9MB), we round up to 4MB to save page table entries.
>> However, when I revisited this earlier today, I thought we should still
>> round up to PAGE_SIZE to save memory
>> 
>> Right now, I am not sure which way is better. What do you think? If we
>> round up to PAGE_SIZE, we don't need split out __bpf_jit_binary_alloc().
> 
> The less code duplication the better.

Got it. Will go with PAGE_SIZE. 

[...]

>>>> +
>>>>       if (bpf_jit_charge_modmem(size))
>>>>               return NULL;
>>>> -       hdr = bpf_jit_alloc_exec(size);
>>>> +       hdr = bpf_prog_pack_alloc(size);
>>>>       if (!hdr) {
>>>>               bpf_jit_uncharge_modmem(size);
>>>>               return NULL;
>>>> @@ -888,9 +1052,8 @@ bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
>>>>       /* Fill space with illegal/arch-dep instructions. */
>>>>       bpf_fill_ill_insns(hdr, size);
>>>> 
>>>> -       hdr->size = size;
>>> 
>>> I'm missing where it's assigned.
>>> Looks like hdr->size stays zero, so free is never performed?
>> 
>> This is read only memory, so we set it in bpf_fill_ill_insns(). There was a
>> comment in x86/bpf_jit_comp.c. I guess we also need a comment here.
> 
> Ahh. Found it. Pls don't do it in fill_insn.
> It's the wrong layering.
> It feels that callbacks need to be redesigned.
> I would operate on rw_header here and use
> existing arch specific callback fill_insn to write into rw_image.
> Both insns during JITing and 0xcc on both sides of the prog.
> Populate rw_header->size (either before or after JITing)
> and then do single text_poke_copy to write the whole thing
> into the correct spot.

In this way, we need to allocate rw_image here, and free it in 
bpf_jit_comp.c. This feels a little weird to me, but I guess that
is still the cleanest solution for now. 

Thanks,
Song

