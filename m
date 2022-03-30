Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1237A4EBAF6
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 08:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242621AbiC3GpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 02:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiC3GpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 02:45:12 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7672A6A009;
        Tue, 29 Mar 2022 23:43:23 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22U0cIkU015166;
        Tue, 29 Mar 2022 23:43:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=8Az0vZutWay8xGqbvaPpIFAEsGdmz8EOq/eognmxgus=;
 b=L2/ILXs5/3dzvMgcIVqR+8SRBDxQSX9k8seh9RyTxYe4jlj6yKHo7rSc7e2BFufBC2nA
 /nG+qChc9u6sc7Ufh1diKowOWCZ24hOH9b12xI8SQn+ZPJcEmTzNh8ybiIr9X2V0yvky
 A7DO/TtbtRMKr8jCxSq3Q4f3jYjij1mCs0s= 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f3ta68cvt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Mar 2022 23:43:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Da2ZFaDN+ZABfPMKVQ7kdT6X3YFyNDFL+sz77nxCMSwYC8Y81FW1+1s6BrZvPDxQX9RmaKT/U73BwiGZ87VO+irrDhq/EUhXaH+phzEc/va/4LYdgsTwil9Q7s18P0Towov2blkQolSCj0wa0SE1NoB3um6HTSCGVxAM43Rz2KTge+tFDJYUAkVMB6jyxB6i70HKSMJeYXeKoH8PqFng1a2Al90vpJhs4euTRuRYtMgPgE1zqMgYsEe9QlvYJJPNzXxEXM/tpgMJaJGQyb9oaE0z9izkS2QVQJHhs7R1Dezpo7dtx6uGuqkNKkRgfDDo6BKMMg1EmwWAvpXFQzsb9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Az0vZutWay8xGqbvaPpIFAEsGdmz8EOq/eognmxgus=;
 b=lIZ/NBU+8rzgAQ7ddMDi8NStkrZLB9vODFkqcDWghTHCmRxZgqTpjEGlwUQ4FqA0vbNpTWA4AeOcnzkJwbfVHc/wJYkUuUecgf4OyEhNt2CQRGAB+m+xFb60TS7CbUNPu2ZhNsKXVKf4TXAFgn75XCSOv6vdNFU8I8qjQV62dBI2hPbAFeLlhVEgArAwPnUB0p5U9GLt9JFndF1zqyvnte3kDgQVoFO3W93IGIEECdexTCPVI8XS1f5Eewq/JxjdMKunOlOe1Ck+Z/2caRMHwsehjGsnlOyBO7VHAbKFBY06kEWl2bLyQRj27otDBk6ZERF3oKuhHtg68tWiLo4h3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BYAPR15MB2934.namprd15.prod.outlook.com (2603:10b6:a03:f7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.23; Wed, 30 Mar
 2022 06:43:19 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::58c9:859d:dc03:3bb4]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::58c9:859d:dc03:3bb4%3]) with mapi id 15.20.5102.023; Wed, 30 Mar 2022
 06:43:18 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Valentin Schneider <valentin.schneider@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf] tools/runqslower: fix handle__sched_switch for
 updated tp sched_switch
Thread-Topic: [PATCH bpf] tools/runqslower: fix handle__sched_switch for
 updated tp sched_switch
Thread-Index: AQHYQ8NoYshikhsCNUuid70h4G7GUqzXCr4AgAAK54CAACPCAIAAQfAA
Date:   Wed, 30 Mar 2022 06:43:18 +0000
Message-ID: <A68BDAD9-A4D9-48D0-ACAF-7AF6AD38F27B@fb.com>
References: <20220329231854.3188647-1-song@kernel.org>
 <CAEf4BzZCLwzrZPTOBEg88i1Tki6uPL73ujSE-SCSSU16HENUHA@mail.gmail.com>
 <53E87B8F-6BB1-42AB-965B-096C86236926@fb.com>
 <CAEf4BzbVqM_akAGsHkf4QJdwcA2M-Lg6MF6xLu72rRS8gUjPKw@mail.gmail.com>
In-Reply-To: <CAEf4BzbVqM_akAGsHkf4QJdwcA2M-Lg6MF6xLu72rRS8gUjPKw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28fd0b06-60d4-47ac-bde9-08da12189379
x-ms-traffictypediagnostic: BYAPR15MB2934:EE_
x-microsoft-antispam-prvs: <BYAPR15MB293464B81DC8FD65BDFF7F11B31F9@BYAPR15MB2934.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YpKrUWe1An4azobGM4gsqq+nT/yPBp5JRqkfFFkGbXl5wDtehPo23BIyswArUTLVxM/y277M+0y2jl7dpmBzMV55PYKEXrFDKslvAcXjeN1LxjbSIJeEEwcknIfVwPJ38AmBLeAHAWdVwoCOTb4kbGQctqFHuhjPbjQYmAZfvv6lcTRsS6qHZ4R65/AVoPqYmy7+d7OeJOyIvqkc4eW6e/oeuQCJuV/AQ6sJCGWWGEH2HLoMcFBOU3KPbAEaB7MMOAVV36zLqYTZqIvJI4Bsj8De4PE6Wyq0aBdcvwlNYfFWv5CFzw2LbaTugzj5DCSZvPC4tOg1/vAEjtAufe5Npdq1TTmdpOrOhDoup9wE1DpcTQDHl4hBFCE8gSc9HHfDBhBhyTGGPFmXSdnSFdbJ9AzRvBYAEqTM27byATM1pYP1NYEWzc5d4XkEpa904SYvaGszse0SHAntGdHTcY7DD3TFEQ8vxIa5HmrQkOsa0OWJi6slsqeq0cD4rH9L2LETWV0FlWJuQglvUNKe1DlhYulaKA9+ebGM6rR7igb+XMP59/eoSLXeVBgmbzHasuYle/Zdkf3SVkwFFrVIT6W0rMBdzO7E2vgTMi2aHS6p/JeoTLhTVOip2X6MiwIzPt1QKVwJF5K0b4XJ+hVC+J+H2nKM6ToeafpX+3LTZCnfvCTNrvOyCZ+UffkE88psqMXOe5xEQe7WznsG/+5/ux3i5CPQVA+D6ykowqPQmzMf89QNkUqrwwejICGw8IYdYmFlK8xYzEUaVb6KmYc7L8vUpA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(66446008)(2616005)(91956017)(66946007)(8676002)(6916009)(66476007)(4326008)(54906003)(66556008)(316002)(83380400001)(71200400001)(6512007)(64756008)(76116006)(36756003)(186003)(38100700002)(33656002)(53546011)(38070700005)(122000001)(6506007)(508600001)(86362001)(2906002)(15650500001)(5660300002)(8936002)(101420200003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?H/BG+RfM0L7tgJpxjNTYRR255atvQU5TdmPsbI/TgYbEKkq2c/vYaejaVa+3?=
 =?us-ascii?Q?t1zypV5Lvue7Ec/YrpaRGwoaxhX+tkr1GhzmEeYAeOoxNiFzj3TROviqtRSp?=
 =?us-ascii?Q?kYDi28MUuuHgdH4XjK/Qhnu8eMii2N01sZ7kUA4Nkfz4QSd318+JD5560uQ6?=
 =?us-ascii?Q?Chbp+Ddvv0dALR/dMIsfC6PA6KuGTbfqfknRAZvR9hLECQYNVNGUsly6WOVX?=
 =?us-ascii?Q?J1wzlySGS8dyUpmxkKBcHfNP1uKPR7TWyvEcExRl28crSh563SawyUCIM7if?=
 =?us-ascii?Q?Oc28dIOZv5QxYO7EvIDt2B2GhM3/IAFmOVc+XjkhkpomDdu4LffX08DuEACi?=
 =?us-ascii?Q?jtyMcnvF+C93OibGbzDRCjO4fUc2xNHCZ1RvEC/pm6fezcO5+S0zlaitFDWN?=
 =?us-ascii?Q?/jkedgqXQt9nUgpdTrVPpisrC7Jys/Q+w86PKaFlQUWYFA/n4GDn32bLFu38?=
 =?us-ascii?Q?YwWSZDXhRQUWWbxlZInQXKvTi9S0dY0Bu4gD7Ljz8J9UAM+nUgAZPrV5eg6l?=
 =?us-ascii?Q?xnVBvdP2U+eOQpE5i5zvBrzzl/gZtsXT8sCqADlcIYUGtaqsF2gE3la1ssRG?=
 =?us-ascii?Q?tLvHDa6852Vo6UP/Mf/IP574K2UwzKDJW1wzw0oVFHeNxx3cSappoTsXlBjv?=
 =?us-ascii?Q?7UUYkx+3gg8DrenJqcYIi0xFRXChCpf1vHLFFK6uUFvhENJFiFrZx/5hT4OK?=
 =?us-ascii?Q?xXyYqZDUmkaQYwIEuJm4oemPA1qkgmgYWXFSB5BhJ8EaF6c2cEADBSZunLq6?=
 =?us-ascii?Q?d2n9/ZV5rUy4qossSb5MN+7Xul0ClemHkW08xsmTopHOfATy28kNNG1HOZev?=
 =?us-ascii?Q?nNJ4SAraGGJB39i5c8QlFP6e/xFtLxcL5gFwnlPEiapN6U/TETbjmlyRrm7R?=
 =?us-ascii?Q?Cxwna8T0wsdm/V464eL2c/L0bwZDfFsOB5/PFoZ0qVin/uiOrU70/+JSMu1r?=
 =?us-ascii?Q?YWRFj0g97ekEg1jO105abXU1zuful5RuPoumAysc6WcgTVOjV3NOc/AiNFdM?=
 =?us-ascii?Q?+M79qaJWCK50L+kyTg9TgbqWOc10cGeAQ26L3bbSyv5JnbfqXjUGmhBBUWFo?=
 =?us-ascii?Q?QA4llreErlRQ4mV0fkzadc3ofGKCEtAQMAI44urrom+vURDj7pfR4omEM/RY?=
 =?us-ascii?Q?HCjmnKc9nFKyq+/MYWcxc1WyBhXGebbVCKkJt44avW37fpbzn4j/SrPy+Igr?=
 =?us-ascii?Q?6ZdIhGc1RIgnhISX1t1eYqcu+ldHGLL05kNArMiS9ztfCJgOhfQqnVg0c5/s?=
 =?us-ascii?Q?JhJSDaOZNm00GywmWxCRrRXoancfNV/anplEVDscZ99t+J/I+pSmI79idVjZ?=
 =?us-ascii?Q?U9ZfoF6pcQ8DZDN9CL5hqI2+N00qVHkbQrZpM9/IUu8Upgh3aE9b4kp+hNeI?=
 =?us-ascii?Q?jMEnSP4h9vCbKL+OTMI5xOpNvOFtEbT4tB4agXb7pmIYwJgx6HOmdsm2gJQc?=
 =?us-ascii?Q?noqdRrnNpVjBlBZmGvxvF2AKMhgIVMlr+w9HOCsJuYs5I5L5AXrKPprqvNLf?=
 =?us-ascii?Q?dczSx66bybR0G3f8XLpCelW+emV7JBFYDbTGLrkuFuwWIxc2HyI51xj5Rai5?=
 =?us-ascii?Q?SyantnlgERBp6zhtxyznuaRuoFSLqGCtSwyw0mZHO60JMUmsvRckzF5dw92Y?=
 =?us-ascii?Q?MORMn88y22Xmj0S293QrMHG6mkVHotMtoxvWtj3Y2lAV4xGtnQg/0UOBkjZq?=
 =?us-ascii?Q?gPhuNJwBsU4VLE1MMWdL6VeDbfpmzrfES8STd7k7EolfB5GpHF3D22qc0AAE?=
 =?us-ascii?Q?Hui6v44KFy4VrFQMS/8KJXiyGyftb1Wr7KOTWUrRGxZ7oKa3NKRh?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2FFDC823E76F244485E4E10E922A399C@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28fd0b06-60d4-47ac-bde9-08da12189379
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2022 06:43:18.8153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1GnSgeUwwLDC966NYGxfEgn9XeTI9pBSpA/XuXK4j63TttMD7fTWsi7ycjv7FfGE0wXhua5LQPzIA1OlmpHOhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2934
X-Proofpoint-ORIG-GUID: p87vsIfsZNW9M1Fs6C27UydCI4ZaOeMg
X-Proofpoint-GUID: p87vsIfsZNW9M1Fs6C27UydCI4ZaOeMg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_02,2022-03-29_01,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 29, 2022, at 7:47 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> 
> On Tue, Mar 29, 2022 at 5:39 PM Song Liu <songliubraving@fb.com> wrote:
>> 
>> 
>> 
>>> On Mar 29, 2022, at 5:00 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>>> 
>>> On Tue, Mar 29, 2022 at 4:19 PM Song Liu <song@kernel.org> wrote:
>>>> 
>>>> TP_PROTO of sched_switch is updated with a new arg prev_state, which
>>>> causes runqslower load failure:
>>>> 
>>>> libbpf: prog 'handle__sched_switch': BPF program load failed: Permission denied
>>>> libbpf: prog 'handle__sched_switch': -- BEGIN PROG LOAD LOG --
>>>> R1 type=ctx expected=fp
>>>> 0: R1=ctx(off=0,imm=0) R10=fp0
>>>> ; int handle__sched_switch(u64 *ctx)
>>>> 0: (bf) r7 = r1                       ; R1=ctx(off=0,imm=0) R7_w=ctx(off=0,imm=0)
>>>> ; struct task_struct *next = (struct task_struct *)ctx[2];
>>>> 1: (79) r6 = *(u64 *)(r7 +16)
>>>> func 'sched_switch' arg2 has btf_id 186 type STRUCT 'task_struct'
>>>> 2: R6_w=ptr_task_struct(off=0,imm=0) R7_w=ctx(off=0,imm=0)
>>>> ; struct task_struct *prev = (struct task_struct *)ctx[1];
>>>> 2: (79) r2 = *(u64 *)(r7 +8)          ; R2_w=scalar() R7_w=ctx(off=0,imm=0)
>>>> 3: (b7) r1 = 0                        ; R1_w=0
>>>> ; struct runq_event event = {};
>>>> 4: (7b) *(u64 *)(r10 -8) = r1         ; R1_w=P0 R10=fp0 fp-8_w=00000000
>>>> 5: (7b) *(u64 *)(r10 -16) = r1        ; R1_w=P0 R10=fp0 fp-16_w=00000000
>>>> 6: (7b) *(u64 *)(r10 -24) = r1        ; R1_w=P0 R10=fp0 fp-24_w=00000000
>>>> 7: (7b) *(u64 *)(r10 -32) = r1        ; R1_w=P0 R10=fp0 fp-32_w=00000000
>>>> ; if (prev->__state == TASK_RUNNING)
>>>> 8: (61) r1 = *(u32 *)(r2 +24)
>>>> R2 invalid mem access 'scalar'
>>>> processed 9 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
>>>> -- END PROG LOAD LOG --
>>>> libbpf: failed to load program 'handle__sched_switch'
>>>> libbpf: failed to load object 'runqslower_bpf'
>>>> libbpf: failed to load BPF skeleton 'runqslower_bpf': -13
>>>> failed to load BPF object: -13
>>>> 
>>>> Update runqslower to fix this issue. Also, as we are on this, use BPF_PROG
>>>> in runqslower for cleaner code.
>>>> 
>>>> Fixes: fa2c3254d7cf ("sched/tracing: Don't re-read p->state when emitting sched_switch event")
>>>> Signed-off-by: Song Liu <song@kernel.org>
>>>> ---
>>>> tools/bpf/runqslower/runqslower.bpf.c | 19 +++++--------------
>>>> 1 file changed, 5 insertions(+), 14 deletions(-)
>>>> 
>>> 
>>> It would be much less disruptive if that prev_state was added after
>>> "next", but oh well...
>> 
>> Maybe we should change that.
>> 
>> +Valentin and Steven, how about we change the order with the attached
>> diff (not the original patch in this thread, but the one at the end of
>> this email)?
>> 
>>> 
>>> But anyways, let's handle this in a way that can handle both old
>>> kernels and new ones and do the same change in libbpf-tool's
>>> runqslower ([0]). Can you please follow up there as well?
>> 
>> Yeah, I will also fix that one.
> 
> Thanks!
> 
>> 
>>> 
>>> 
>>> We can use BPF CO-RE to detect which order of arguments running kernel
>>> has by checking prev_state field existence in struct
>>> trace_event_raw_sched_switch. Can you please try that? Use
>>> bpf_core_field_exists() for that.
>> 
>> Do you mean something like
>> 
>> if (bpf_core_field_exists(ctx->prev_state))
>>    /* use ctx[2] and ctx[3] */
>> else
>>    /* use ctx[1] and ctx[2] */
> 
> yep, that's what I meant, except you don't have ctx->prev_state, you have to do:
> 
> if (bpf_core_field_exists(((struct trace_event_raw_sched_switch
> *)0)->prev_state))
> 
>> 
>> ? I think we will need BTF for the arguments, which doesn't exist yet.
>> Did I miss something?
> 
> Probably :) struct trace_event_raw_sched_switch is in vmlinux.h
> already for non-raw sched:sched_switch tracepoint. We just use that
> type information for feature probing. From BPF verifier's perspective,
> ctx[1] or ctx[2] will have proper BTF information (task_struct) during
> program validation.

Sigh. I run pahole and saw trace_event_raw_sched_switch. Somehow I 
thought it was not the one. 

Will send v2 tomorrow. 

Thanks,
Song

