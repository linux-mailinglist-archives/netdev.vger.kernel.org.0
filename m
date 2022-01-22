Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694464968A6
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 01:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiAVAX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 19:23:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36178 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230077AbiAVAX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 19:23:28 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20LFnHdN016346;
        Fri, 21 Jan 2022 16:23:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=BQBv8Adx6AdODV7JAq5BNMzcVF6LkYlRMoY/L7EDorw=;
 b=NcznKvELA30fIc8AVQpqIEYgElqh3ejeSIUvgPIFxz7u5j6ZiG5W6uKD35SPhomDZCav
 H+jhCnVjREqJZwCrR/FUbw0+X1LY1o+0Zt8XT15d2tT1uebDAP6ZkcHYhQoKCQfq3DH2
 PRkp1gvm7t6FRFwh/cyMzDvXu1GOYlSOHc4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dqj0gq00g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 21 Jan 2022 16:23:28 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 21 Jan 2022 16:23:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ni79JgELR5mckKcIZZrMRWLBtaf1xcQywhsRw52+bZaC3/CVcS5P9xCE7kZ0B7BQOnjLwMVyXH/+baJfWag50nC/zOH0Dx7F5OpdkTadYTQGhTEFWH+ju2lu/MVfOZWV8QtCZL/5lqJuG+/EiPeCw8H0MyJVbMioiDOp9DsvdeE0EzWTPRNwMQ4igxeiznOzk4nLxAdCmMeZhQHEJZ/+YHuyi2I4ckiMUwo2uorVRKlviFPbrMiVWGHEepdkBpHl8j2QhRvHDgsc2qfqFNXo4Leg6dxLPhgerlcsR8kuAYfggc58+81QELDl+PG9LqbjDhB1ZpqJDvTaS5k/I7SmkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQBv8Adx6AdODV7JAq5BNMzcVF6LkYlRMoY/L7EDorw=;
 b=J5OOy2bHimssr9LvjOpThYuj0mAWBBgtNKz60LoCbXIwQM1Qb4L7A8fcCiOF8sy1bE9WzFsqZ3XeDIvJzehKqnMbsuOGr3/Qg70Q7+h0UkOn66HVwsU6M1aC7AY4no9hD5NLVdRl8QURjw5yNdxw5J8g/qKU8hUqZRfsxbl1nWwuvvX0dAbNS5EQ4BJB6lMZuHWs9gDxHk4AvjbQw4GpaPVxDgShz1DQtQqxt+UuAzJnNV8DdfekqikqCZmnd7xzZ9Ugg+vCc7lzVQASY7bln4UW53yIO+OjtuECELdDeFOsYObnQAo+1lJKvapmcN1s53KbxhAxvWyhEJIo57xmRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5139.namprd15.prod.outlook.com (2603:10b6:806:233::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Sat, 22 Jan
 2022 00:23:24 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e%7]) with mapi id 15.20.4909.012; Sat, 22 Jan 2022
 00:23:24 +0000
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
Thread-Index: AQHYDwA7v2eTErzZP02KrqTA2Ue2qKxuJqkAgAAH3QA=
Date:   Sat, 22 Jan 2022 00:23:24 +0000
Message-ID: <7393B983-3295-4B14-9528-B7BD04A82709@fb.com>
References: <20220121194926.1970172-1-song@kernel.org>
 <20220121194926.1970172-7-song@kernel.org>
 <CAADnVQK6+gWTUDo2z1H6AE5_DtuBBetW+VTwwKz03tpVdfuoHA@mail.gmail.com>
In-Reply-To: <CAADnVQK6+gWTUDo2z1H6AE5_DtuBBetW+VTwwKz03tpVdfuoHA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e8a0135-1cb1-4200-0abf-08d9dd3d6773
x-ms-traffictypediagnostic: SA1PR15MB5139:EE_
x-microsoft-antispam-prvs: <SA1PR15MB51391FFAC5462FCDA25BA5DAB35C9@SA1PR15MB5139.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 52+QRrqSE4t04ylddxvj/lsxJvkdrTRDMthHc5ezUMPxKvnP4lLZnl7j9un3ncx5l5/wV5gWNVvrHVGlT4lSHwXWN7FqBXDTBOKurkyVRrAol9YAz+F2fORAIHue5lorg5XDOs78RM/4l6+xPvjMoDgCrHdC1Oj0+IPw/T38vDlwaPWgzR0iPnlBC2nrl2O4EmkcdXZne7v1//Ncpv6Q+yZSZa8PcYEBaPAMgfqMBpbFETt5Rtht/qbInL698TagZMW7aZLJYSfijUYOHtGDYgsgFxwzJX/YikB9xZv8VlFUCj5srlEQj9j7i2rthYb9NDKXg/NV9DcpFxePSPm6Fasypl1TC/Ne33rbE1d5rfurI4PQouxVGUW2Mh6scuocEP1EsnG5mTzfikcH96b8ETBqVI3ImLbf+PkQTCEKZirx5Ca01yj0W7HIykBVzYyDeS3hcbhdLAMH6iOC7MgdTnXTWjEcqCHgMa6IXg1nn8XfzCmV49x5DcPX9b6OS40Bycviy2WE+VNeYelDi18YGkC9bVqOVRYtMyF7ofQN7j/zg7ThEj52jVgk97CsxOc0ys6hNzN9nr1BMU25QY+O+8DoXsHUmXhlIF8DsuChVQw2I62gpwvHv/Hctqe1q1WftcZNo/pZqdUA8lMQbW8KKLvO5ivRz+d+Jgbt/gpoTca0wfacnm36/MLuZ3U6oiNGueybKw1X8RtO7iVRzKqjt2qacCeUK9dDeD90QP9CxPC0wbY83EwRuXS35ZDUmiqD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(8936002)(8676002)(6512007)(64756008)(4326008)(86362001)(38070700005)(2906002)(508600001)(7416002)(53546011)(2616005)(6486002)(54906003)(91956017)(33656002)(186003)(66446008)(6506007)(66476007)(66556008)(76116006)(5660300002)(66946007)(6916009)(71200400001)(38100700002)(316002)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Hv9ciaurmXQiJLRFTRIcTI2AFc9Q9WMV5airu3TGUGdJ8ytxPFDEduaoQzM0?=
 =?us-ascii?Q?CH1Gf2qmabK8PKag8gBegN24qVBO6QIhsR79Eax6TLqGykMRdhRisDVMglmw?=
 =?us-ascii?Q?jK/iFMEUIDQ2wn0/bgq+yAr8Y+vJJx2KnXHzBy3tusCu5cIqLoFwPmgnfwcD?=
 =?us-ascii?Q?haoxxgLgNfmNajw3SBu19RHXEtfi4EGda88XjhUQN/2GFgjcZX5/cdj28Yp9?=
 =?us-ascii?Q?x8Dm5yBROrI10nyQ68emywRUJNJqf+QkE/kFPZ3kUTKigX5clL33Uq2pzF4j?=
 =?us-ascii?Q?SjoJQHtUlY6RYiIBUazd9H7goX23FUVgQEBxsBKhfxa/OWhZLRBt+hwHIYD6?=
 =?us-ascii?Q?LUXjShDCU8PD5XXHlD9fTBjlR87QXnI0zZd1uZCpo3xFB6eMVMDMpinliMV6?=
 =?us-ascii?Q?8PofqRTZEur4Z2UL/DTR4/SWbmzybDTOF3T/TJXzx0fgHrkT8KivTPcpYXou?=
 =?us-ascii?Q?rHuYX81zFSEn0H78lgcOcXn0j0KuhV8dOleVxtHlTytg+VpaAD4ANwjosST3?=
 =?us-ascii?Q?PRaAvydim708zVdIQDRVJ2O9daKFTUQNNtH/iQADSIvtapw30OJXdNlBFTSB?=
 =?us-ascii?Q?tT/KdMPceK07rU/iHz1fVF5A85Cyn5T3urkl8y0emuPyuAo91BKIj+lBE3K1?=
 =?us-ascii?Q?U0RK/SyYRkrZ83R7nPUgI0IbSZncvTYpBjINT5IUesschrAayv66u5a52lyR?=
 =?us-ascii?Q?MZR3LAnScRNGgUfS4CC/QhmRvtTfj4kjqCMvUFam5lHNHydcTf6Z/Z7WE054?=
 =?us-ascii?Q?2KApP22TArkUVPrWkaW1SHQV/na6NIsQRuHmERLi3N5JHpIeye24RcvTLei5?=
 =?us-ascii?Q?ivt1b7aQprdztO0JtSHwVm+rcoxY7VryYG2n1xPDqQ63pUHV03rZIs45zb/9?=
 =?us-ascii?Q?9ZIzrht3UpW8nJNdAwSXQpbKb6CPamNQA5u1JqYaaEnTp8vuEfokXUo/UX/8?=
 =?us-ascii?Q?Qrey2MMXF19YD/ooUhSIXqvL36QwoVMUZCgcbi0/Rho1iZXKUwydb0lF693F?=
 =?us-ascii?Q?mb8L3ZpJAtetdB/S5Kp0Ce5omnCLwXIxoj5Dhoc7msVRWCNi/9yQ7ygg9k7+?=
 =?us-ascii?Q?JaLBS2SXLuxKMIcJySPleiSItbHfOXJhYeTD4zsw6WZkIkz13nPea67ksr7M?=
 =?us-ascii?Q?lLuszrUHuM+8ZZkbI6odCepLv4HZ+0FcWk7WZT759qL7i5TIqd5sG9C5PBZt?=
 =?us-ascii?Q?9cD5DQt+HOEA7EnkLBI/0ArjQ73HKfuwB1m+QtEWFovv3odnSQhGRd/f4BB3?=
 =?us-ascii?Q?/C+T2Q6EaBK3VXFx001k2hfzf3g30yfUBt6hn03i+eWC3xdXtaVurOecLRIB?=
 =?us-ascii?Q?hTwkmZl6cPrzJwPuMza14eRGGZQF0PoS+H2ydifdS+dsqGUQzn6762STEZiz?=
 =?us-ascii?Q?AVLw7gjnHU9qe23E3NESVA7QvnDeyKuFo05VSszhPkA1BSZhXfF5ubpOBsDA?=
 =?us-ascii?Q?kzLUpY3CQgOZdBvINvCrAsQcn6TZxamnjOFQteCyfyPbmABXvWKprKK2YNYF?=
 =?us-ascii?Q?SpFbfBGX0fAAjKjKwo4p/NcYHWJWsOSo5kcvN1K4PsxUTZ1PhUzzR2tXt7lH?=
 =?us-ascii?Q?RkhZEpCfivyw0J6DiOhkKgzWsH9u54gNHoecoU7Z2T0HgsrdvUCUV/FjLzdh?=
 =?us-ascii?Q?1oX1Op4rCO9Aj5kpWrT5RzBxTahk7QibQc07HMBTu1lzZ7tqdzYLTuHPO71a?=
 =?us-ascii?Q?yQVQ1w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5EBEEC1949F64F4E9681AB26F1875A06@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e8a0135-1cb1-4200-0abf-08d9dd3d6773
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2022 00:23:24.7347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XUTtrYg4w+dpuw0V+jQ6tt4mqtC4jl0nELMLAomG0mV5bmc1oWRTiaRGOEUcswOjAyxOLYry4oXUJrkTLvtpcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5139
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 3pU-bjwfzLOwQRgO2FTaBvvcENID6FX8
X-Proofpoint-ORIG-GUID: 3pU-bjwfzLOwQRgO2FTaBvvcENID6FX8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_10,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxlogscore=999
 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201220000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 21, 2022, at 3:55 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> On Fri, Jan 21, 2022 at 11:49 AM Song Liu <song@kernel.org> wrote:
>> 
>> +static struct bpf_binary_header *
>> +__bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
>> +                      unsigned int alignment,
>> +                      bpf_jit_fill_hole_t bpf_fill_ill_insns,
>> +                      u32 round_up_to)
>> +{
>> +       struct bpf_binary_header *hdr;
>> +       u32 size, hole, start;
>> +
>> +       WARN_ON_ONCE(!is_power_of_2(alignment) ||
>> +                    alignment > BPF_IMAGE_ALIGNMENT);
>> +
>> +       /* Most of BPF filters are really small, but if some of them
>> +        * fill a page, allow at least 128 extra bytes to insert a
>> +        * random section of illegal instructions.
>> +        */
>> +       size = round_up(proglen + sizeof(*hdr) + 128, round_up_to);
>> +
>> +       if (bpf_jit_charge_modmem(size))
>> +               return NULL;
>> +       hdr = bpf_jit_alloc_exec(size);
>> +       if (!hdr) {
>> +               bpf_jit_uncharge_modmem(size);
>> +               return NULL;
>> +       }
>> +
>> +       /* Fill space with illegal/arch-dep instructions. */
>> +       bpf_fill_ill_insns(hdr, size);
>> +
>> +       hdr->size = size;
>> +       hole = min_t(unsigned int, size - (proglen + sizeof(*hdr)),
>> +                    PAGE_SIZE - sizeof(*hdr));
> 
> It probably should be 'round_up_to' instead of PAGE_SIZE ?

Actually, some of these change is not longer needed after the following
change in v6:

  4. Change fall back round_up_to in bpf_jit_binary_alloc_pack() from
     BPF_PROG_MAX_PACK_PROG_SIZE to PAGE_SIZE.

My initial thought (last year) was if we allocate more than 2MB (either 
2.1MB or 3.9MB), we round up to 4MB to save page table entries. 
However, when I revisited this earlier today, I thought we should still
round up to PAGE_SIZE to save memory

Right now, I am not sure which way is better. What do you think? If we
round up to PAGE_SIZE, we don't need split out __bpf_jit_binary_alloc().

> 
>> +       start = (get_random_int() % hole) & ~(alignment - 1);
>> +
>> +       /* Leave a random number of instructions before BPF code. */
>> +       *image_ptr = &hdr->image[start];
>> +
>> +       return hdr;
>> +}
>> +
>> struct bpf_binary_header *
>> bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
>>                     unsigned int alignment,
>>                     bpf_jit_fill_hole_t bpf_fill_ill_insns)
>> +{
>> +       return __bpf_jit_binary_alloc(proglen, image_ptr, alignment,
>> +                                     bpf_fill_ill_insns, PAGE_SIZE);
>> +}
>> +
>> +struct bpf_binary_header *
>> +bpf_jit_binary_alloc_pack(unsigned int proglen, u8 **image_ptr,
>> +                         unsigned int alignment,
>> +                         bpf_jit_fill_hole_t bpf_fill_ill_insns)
>> {
>>        struct bpf_binary_header *hdr;
>>        u32 size, hole, start;
>> @@ -875,11 +1034,16 @@ bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
>>         * fill a page, allow at least 128 extra bytes to insert a
>>         * random section of illegal instructions.
>>         */
>> -       size = round_up(proglen + sizeof(*hdr) + 128, PAGE_SIZE);
>> +       size = round_up(proglen + sizeof(*hdr) + 128, BPF_PROG_CHUNK_SIZE);
>> +
>> +       /* for too big program, use __bpf_jit_binary_alloc. */
>> +       if (size > BPF_PROG_MAX_PACK_PROG_SIZE)
>> +               return __bpf_jit_binary_alloc(proglen, image_ptr, alignment,
>> +                                             bpf_fill_ill_insns, PAGE_SIZE);
>> 
>>        if (bpf_jit_charge_modmem(size))
>>                return NULL;
>> -       hdr = bpf_jit_alloc_exec(size);
>> +       hdr = bpf_prog_pack_alloc(size);
>>        if (!hdr) {
>>                bpf_jit_uncharge_modmem(size);
>>                return NULL;
>> @@ -888,9 +1052,8 @@ bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
>>        /* Fill space with illegal/arch-dep instructions. */
>>        bpf_fill_ill_insns(hdr, size);
>> 
>> -       hdr->size = size;
> 
> I'm missing where it's assigned.
> Looks like hdr->size stays zero, so free is never performed?

This is read only memory, so we set it in bpf_fill_ill_insns(). There was a 
comment in x86/bpf_jit_comp.c. I guess we also need a comment here. 

> 
>>        hole = min_t(unsigned int, size - (proglen + sizeof(*hdr)),
>> -                    PAGE_SIZE - sizeof(*hdr));
>> +                    BPF_PROG_CHUNK_SIZE - sizeof(*hdr));
> 
> Before this change size - (proglen + sizeof(*hdr)) would
> be at least 128 and potentially bigger than PAGE_SIZE
> when extra 128 crossed page boundary.
> Hence min() was necessary with the 2nd arg being PAGE_SIZE - sizeof(*hdr).
> 
> With new code size - (proglen + sizeof(*hdr)) would
> be between 128 and 128+64
> while BPF_PROG_CHUNK_SIZE - sizeof(*hdr) is a constant less than 64.
> What is the point of min() ?

Yeah, I guess I didn't finish my math homework here. Will fix it in the
next version. 

