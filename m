Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760E549648C
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 18:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350142AbiAURxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 12:53:44 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16660 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1381969AbiAURxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 12:53:24 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20LGDAkw010722;
        Fri, 21 Jan 2022 09:53:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=UuVVNzqIMRxtrASQ2UEeOfndZ7lJZpHJK9/Lg9Jp34Y=;
 b=GZaDDjYqcCExvQ9AON3erCgdpOe4AeIpKxXvzMlfh89mUaEmMYkW4p0CnKRJw1rSj1Lx
 TB9fNi7IQ7cdSUPB8LpxOZaEHO+PPF8cQPlgPobMCQG0L6shAzvD8yXlRk/Yn+b02JvS
 ubjyWhOaHJWg7nLL2+tv8CiinCCcptvQgK4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dqj0gmpye-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 21 Jan 2022 09:53:23 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 21 Jan 2022 09:53:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSma6bBnXqNG2woo0yOH4Q86THfGb6c6z2XYv6ezVV5ctMpIeRPlOgl1OEgpq2T4AfVihN4rTBJqeZsU5/gst+nl+lzkL/ds7wL9VSGSKQGST8lUSSblZH0815jTPdnozuM4/3qSdnlOETHIf015U1xctQ+bU49FayIbDErzulF6iYY3M2EuhApkhOdclppzODRYooQXwDtzGOFUxaDFFk8sgvlGaIZf9UNbagh3VE87cIaajjFuEG1Q7OQBiUHOrkFREIhLhENwKhAOoVnIKAuU45cqub0TEkn7msMQcplpN2LTvk8riLqN2DJJLypUWn1TZNZNRvA9WfBEyNqF5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UuVVNzqIMRxtrASQ2UEeOfndZ7lJZpHJK9/Lg9Jp34Y=;
 b=nATqX5mWsLOY2D8+k6IEwhokOt8v+TUg/jrU7ORbpQtLA1Z/XkwNAua+m+62C7d5fTwc6Y5e6OVJhyN8Y9Ex5CXLeMKqDu01EBpWv4K/i2CnVmoQq5k/2KLa+S6DsextX8PHBW9Uui8h7ZftfGu0Ab2l9660N3oXAqefdT+C0/xidh8M02sVs8WdVSo6KsWrG/3gCM9Vqk11FmuxDMDDRDZAowNsUUaswd34yr9qrOo+aMx1U5V7jXA4E/S5Y2vO+RYeOZTEfvrr+YtHoxuHoDQ3KNrewMFwHy8wD55dI6Y+JxRZk/HVkNBiIOlkvFZtgCx5vN1XAcsadExGLsmP2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB4740.namprd15.prod.outlook.com (2603:10b6:806:19f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Fri, 21 Jan
 2022 17:53:21 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e%7]) with mapi id 15.20.4909.012; Fri, 21 Jan 2022
 17:53:21 +0000
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
Subject: Re: [PATCH v5 bpf-next 7/7] bpf, x86_64: use bpf_prog_pack allocator
Thread-Topic: [PATCH v5 bpf-next 7/7] bpf, x86_64: use bpf_prog_pack allocator
Thread-Index: AQHYDjH7IlFLQbwkPUWXKcNPE2HSyKxs6t2AgADYTAA=
Date:   Fri, 21 Jan 2022 17:53:21 +0000
Message-ID: <F72EEF0D-4F61-4AE1-B2A1-D16A5DBCCC37@fb.com>
References: <20220120191306.1801459-1-song@kernel.org>
 <20220120191306.1801459-8-song@kernel.org>
 <CAADnVQL-TAZD6BbN-sXDpAs0OHFWGg3e=RafBQ10=ExXESNQgg@mail.gmail.com>
In-Reply-To: <CAADnVQL-TAZD6BbN-sXDpAs0OHFWGg3e=RafBQ10=ExXESNQgg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94851b56-99eb-42d1-1b8b-08d9dd06e9f0
x-ms-traffictypediagnostic: SA1PR15MB4740:EE_
x-microsoft-antispam-prvs: <SA1PR15MB47407DDD49166ED4D125D2B0B35B9@SA1PR15MB4740.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mb65T9lH0B3GpNe9AbKJZ42cQgzJwcHhOcxULPQibQQvbVyBtU7qq7cJo5gk12taL0Blkeia6ToGcBM0UaFcb5Cg14nS2j9QDjRMbsVE/00MVEtmSH0hy4CpbGAzIGgYPXZAYVuCZTYivEq/0V1pbZLPPcAa2ZTU2wplMh+qi1Qfe8n/HJnIPi/ONDEhPh0Ur7RzFEL2mHfvDz4ieG6YCH4s0hL2wpKEnUEX2e+1zZWx33n/jCG3iDsPHabAuhbano+EZtZ33zfRjpZubI7vlKIZF9psJXStcxxAXGdeIphVvaIgDSXY8/0jUxvQfeqPba6gk1b3/7HOrSZUIo7APUU1PyjY9A2jFFQx9LtJh+1ieuP/nWmvkuV5vjs5fTlXbMk5zcOhO03ec/9ClAxzAE94h2HzmQkwhCxtbLFUjvW2DVKfaJlN92wjICXMExfqnyKBRif8CIhb7Gd98w6g1Jgaboy/CbMXLh09h7KTDBKHcgfwua1ST8ucIaNwFMYRRMn49764cEnC4hSqGP9ByOIyaA3m0qZld68dxy2st7s+H8trzHVfxkgx7kK/PR+LAf72Jflp/ro7/GNS50RqcYDGSBgCn7zdn90LBhUpAtYnN6d6jCB22LzxVixGP1OjUh327XVfyr8fSO+Z0lPM6jYsgeVFBUqlG55ayQbN7klLVUlWFoENBJ+Hr2t+kVPDNPju8wmUhUeBQ+KDiTke25izTzJ+w3cm/ULlV5v2ey51KEwqlFf70qaKXWalJGvG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(86362001)(8936002)(5660300002)(71200400001)(83380400001)(33656002)(8676002)(2616005)(66946007)(6916009)(6506007)(38070700005)(316002)(122000001)(54906003)(38100700002)(7416002)(36756003)(2906002)(4326008)(508600001)(76116006)(91956017)(6512007)(66446008)(66476007)(53546011)(64756008)(6486002)(66556008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Bz4Ui0ohdz/VxTpSLvDRTbQQUamg9PFvcgdDrH78gxEiWBvoNPci3Kndaj/Q?=
 =?us-ascii?Q?gm675EFcFtM9luRJsyG0/jWs1YzsftBNQWPd0aMhAfOyeHpvYISJpOzPN4oE?=
 =?us-ascii?Q?hE39K3m+2m2MrdFvU5krsJu+cQUPddwhUQZV65ZIqjH6pJ+NMdh8XUCl5rcQ?=
 =?us-ascii?Q?4w0XkQi6RcOudoFo3NRcuyvD08E0IH9oZmTY7Ut7mssyuFiZgCismJRMSf3A?=
 =?us-ascii?Q?3X5eBH9E69CJtlTM3I6kbKEPKk32oEInjUfeuaLJm9A/AWhyYilnLcK8qLyh?=
 =?us-ascii?Q?yPuW2DkF9CQcMD099hN30MvAYIAnSSUKUwrHGhiMBvVDngu6l2aHOpS5Nf2Z?=
 =?us-ascii?Q?PhULhjvA1JFE3GZJewbmw6zQeUQkfyCuhMbPhzxwF36zEHm2ABSmvs7FD3dn?=
 =?us-ascii?Q?qIOuXRjDAtdEoLu0SzMFYHQwQf4uK2lP4b8XFUvnGkt3GlnkDLJ0t05ZGdSA?=
 =?us-ascii?Q?TbUFr2ihPSdon6tgiSvyRrPK/J7bbGpQPy/chXUUBtI5GY3BaJ82TKEbGk+5?=
 =?us-ascii?Q?sa7sELhhu5rBKZFL1u9u+UntYxh88j0xvmh4Z2MDefCptzDAfAmJ/iJOrXAV?=
 =?us-ascii?Q?H6KFNwR+RbRvD3ijxw2pzeEHb2F/nkGnEp10sbmmOS3gZOqKxv+lVExZ3+4X?=
 =?us-ascii?Q?ENdC7DVyBd22lFCfpBvCQw7L3pnvwjmlUzP78qh7eZni/2T5y+gwzyHT/mDv?=
 =?us-ascii?Q?KwU/uPvXsjkNg1sdZsH9zDCrZ2fONOOrOz0U36gavlKB62D/FJw7gf7iu+n4?=
 =?us-ascii?Q?kl94p935OPEfPePKG251dFxBUX62TQi0b0XSjrRatI5vrfDa6nvKN1HhCZUs?=
 =?us-ascii?Q?05xukNqOrmpweL2V4maWbZEU98jTlzA5ZBbgWTS7pVpNtiLvCt6vJmy0vVzv?=
 =?us-ascii?Q?1Q2lItK4+/LYgxgBRWNprZRVCRMtr0MJj6xZlAvsq4VTPw0X/EIgzAEwQa0G?=
 =?us-ascii?Q?qtVUfzFa83PKfWm4t1yWH4GBgtyC0vMAEMnM0YebriG6QIWS4RqzDfP+NXYG?=
 =?us-ascii?Q?iiGJ+wV1WpCkXe2bFcZTVA+m7G3jtCiWQ0FtXn0fKXPf95pnszO2coD89Vhi?=
 =?us-ascii?Q?QIhPFGlpOCfhzsvh1zj9pD5IQNlns/zZIiUOGC/9DS1RD3+8HyJM/y1yi9q3?=
 =?us-ascii?Q?Dj0vs+ucK9RaG6F0xbFmYZhjDhq/weSqR6mBI6O2l77C4vbrqp/ijWjz2+CK?=
 =?us-ascii?Q?sKHmewVipF9PWsbi/jDpIS8W8h5uTzCK9JGwN62nUwNjkbRq2ip+yPXRx+eu?=
 =?us-ascii?Q?hvuDxL1XG8u7ihAHPkGUJZ+sVHP9TVPGMNAWPSfKiZXxBfyHirQYbFBbntMc?=
 =?us-ascii?Q?YPzWd0YR4rHMgp+JapGaIOHuhNkTkk058fJtL/omqinJoGoXRDJYjRFhDlLi?=
 =?us-ascii?Q?JjLT2q4cf3ms5Ch773PFTUylanzZdsfuiWKywwpfngTS0NeGqaNcnuNlKOe4?=
 =?us-ascii?Q?a0LlZhZjq7YRyDy6ELx02arNSdnBnluUNVKHR27b5W39wYYBfCsq3GcU2NVc?=
 =?us-ascii?Q?wr0Yv/VL5lSZSDWIFerT8fBcXh+7Ff0VBxxxIjbYkTKrCtnyueN5s7Th2vNp?=
 =?us-ascii?Q?/sz8VLkLsRYbUH9apKHMBMuJlXpp/sgHTb1WpGdSl0SWooInJMyA3blPt05b?=
 =?us-ascii?Q?4uRRbGACndydsYXNsfV83WPzxzQ2VLSyGH7vh0ZZpPNhn7x9PAG0zuFPh8SR?=
 =?us-ascii?Q?bMFfLQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <33800860C375C545A09B21AF38EDC378@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94851b56-99eb-42d1-1b8b-08d9dd06e9f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2022 17:53:21.2755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ro3UN043iN9+3qNbIL19tKVWpKSHyfv6YRheJschEe4ATD0fM0EeGuk2NIropHZT8Mmo6QHqdPvb3QWHwGGXbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4740
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: xjwgoksfQ6pNMt_2lqVcAjax0yvOM4aK
X-Proofpoint-GUID: xjwgoksfQ6pNMt_2lqVcAjax0yvOM4aK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_09,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0 adultscore=0
 clxscore=1015 bulkscore=0 impostorscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 20, 2022, at 8:59 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> On Thu, Jan 20, 2022 at 11:13 AM Song Liu <song@kernel.org> wrote:
>> 
>> From: Song Liu <songliubraving@fb.com>
>> 
>> Use bpf_prog_pack allocator in x86_64 jit.
>> 
>> The program header from bpf_prog_pack is read only during the jit process.
>> Therefore, the binary is first written to a temporary buffer, and later
>> copied to final location with text_poke_copy().
>> 
>> Similarly, jit_fill_hole() is updated to fill the hole with 0xcc using
>> text_poke_copy().
>> 
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> arch/x86/net/bpf_jit_comp.c | 134 +++++++++++++++++++++++++++---------
>> 1 file changed, 103 insertions(+), 31 deletions(-)
>> 
>> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
>> index fe4f08e25a1d..6d97f7c24df2 100644
>> --- a/arch/x86/net/bpf_jit_comp.c
>> +++ b/arch/x86/net/bpf_jit_comp.c
>> @@ -216,11 +216,34 @@ static u8 simple_alu_opcodes[] = {
>>        [BPF_ARSH] = 0xF8,
>> };
>> 
>> +static char jit_hole_buffer[PAGE_SIZE] = {};
> 
> Let's not waste a page filled with 0xcc.
> The pack allocator will reserve 128 bytes at the front
> and will round up the tail to 64 bytes.
> So this can be a 128 byte array?
> 
>> +
>> static void jit_fill_hole(void *area, unsigned int size)
>> +{
>> +       struct bpf_binary_header *hdr = area;
>> +       int i;
>> +
>> +       for (i = 0; i < roundup(size, PAGE_SIZE); i += PAGE_SIZE) {
> 
> multi page 0xcc-ing?
> Is it because bpf_jit_binary_alloc_pack() allocates 2MB
> and then populates the whole thing with this?
> Seems overkill.
> 0xcc in the front of the prog and in the back is there
> to catch JIT bugs.
> No need to fill 2MB with it.

I got this logic because current code memset(0xcc) for the whole 
buffer. We can change the logic to only 0xcc the first 128 bytes 
and the last 64 bytes. 

> 
> 
>> +               int s;
>> +
>> +               s = min_t(int, PAGE_SIZE, size - i);
>> +               text_poke_copy(area + i, jit_hole_buffer, s);
>> +       }
>> +
>> +       /*
>> +        * bpf_jit_binary_alloc_pack cannot write size directly to the ro
>> +        * mapping. Write it here with text_poke_copy().
>> +        */
>> +       text_poke_copy(&hdr->size, &size, sizeof(size));
>> +}

[...]

>> @@ -2248,8 +2261,10 @@ int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs)
>> 
>> struct x64_jit_data {
>>        struct bpf_binary_header *header;
>> +       struct bpf_binary_header *tmp_header;
>>        int *addrs;
>>        u8 *image;
>> +       u8 *tmp_image;
> 
> Why add these two fields here?
> With new logic header and image will be zero always?

header and image point to a section of the 2MB page; while tmp_header 
and tmp_image point to a temporary buffer from kzalloc. We need them
in x86_jit_data, so that we can reuse the temporary buffer between 
multiple calls of bpf_int_jit_compile(). It is used as:

bpf_int_jit_compile(...)
{
	/* ... */

        jit_data = prog->aux->jit_data;
        if (!jit_data) {
		/* kzalloc jit_data */	
        }
        addrs = jit_data->addrs;
        if (addrs) {
                /* reuse previous jit_data */
	}

> Maybe rename them instead?
> Or both used during JIT-ing?
> 
>>        int proglen;
>>        struct jit_context ctx;
>> };
>> @@ -2259,6 +2274,7 @@ struct x64_jit_data {
>> 

[...]

>>                        }
>> -                       prog->aux->extable = (void *) image + roundup(proglen, align);
>> +                       if (header->size > bpf_prog_pack_max_size()) {
>> +                               tmp_header = header;
>> +                               tmp_image = image;
>> +                       } else {
>> +                               tmp_header = kzalloc(header->size, GFP_KERNEL);
> 
> the header->size could be just below 2MB.
> I don't think kzalloc() can handle that.

Technically, kzalloc can handle 2MB allocation via:
  kzalloc() => kmalloc() => kmalloc_large() => kmalloc_order()

But this would fail when the memory is fragmented. I guess we should use
kvmalloc() instead?

> 
>> +                               if (!tmp_header) {
>> +                                       bpf_jit_binary_free_pack(header);
>> +                                       header = NULL;
>> +                                       prog = orig_prog;
>> +                                       goto out_addrs;
>> +                               }
>> +                               tmp_header->size = header->size;
>> +                               tmp_image = (void *)tmp_header + ((void *)image - (void *)header);
> 
> Why is 'tmp_image' needed at all?
> The above math can be done where necessary.

We pass both image and tmp_image to do_jit(), as it needs both of them. 
I think maintaining a tmp_image variable makes the logic cleaner. We can 
remove it from x64_jit_data, I guess. 

> 
>> +                       }
>> +                       prog->aux->extable = (void *)image + roundup(proglen, align);
> 
> I suspect if you didn't remove the space between (void *) and image
> the diff would be less confusing.
> This line didn't change, right?

Yeah, I forgot why I changed it in the first place. Let me undo it. 

Thanks,
Song

[...]
