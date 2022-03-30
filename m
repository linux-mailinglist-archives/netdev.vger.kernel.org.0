Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88104ECE97
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 23:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243190AbiC3VNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 17:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiC3VNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 17:13:04 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA4B6451;
        Wed, 30 Mar 2022 14:11:18 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22UHKgnc028145;
        Wed, 30 Mar 2022 14:11:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=E0YDTkEIK934XMhwDqUmra5dAhxVbytsQK9fBZyP26U=;
 b=cQbkM0mt35u0TfoRxrTnjugQS8wvuoOsGuqnxRkSiXsqnvCeKtbOpG5bqYNvJpLwYqDx
 CLZqlpCdA+vBkR/hVZfhhV2t5KYVGRySh/c1T/QHFzN6EvVat71/oG1SS7Ek5z6UQy75
 q6PeFFPHQNHgFT13OlHdv74CbNcbfzdT6/U= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f4kk9vywc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 14:11:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KYcrfgRguIwD/uPa75aFqtoqS1wPfIsGwe6aMwnp8qJPoMfmERK1r7ghMv7Gki1GX9KKlYCez0tFZ3F9W9Hj1q3lAsBNb5zU1ww5kWTbj1hBhOvOjHiMcG2UztQg0Ij5V2wT5tIsXdoNZ6+kfTCER+rSXwcLlhvNRR52Qe7bVmdbr0dyIkwQJ1Hm5EoYX2QnjAkbUtO2IB4+DZJjdYAofIhW/e8zaoAc1pfBZ4rU/8ZwzUzgimkb6mwbyGB4yyC9HRcge9tSvC9FiINLYUKJ632PifMCikLKenI5VC9CvsPmG3bIM/tWuHZsekgqaVAjl7x5gFHpVYzR4M4BbHv/jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E0YDTkEIK934XMhwDqUmra5dAhxVbytsQK9fBZyP26U=;
 b=h4CSb/dK/f5t9QgaadVtFwVVSNsq+Re67etHFhycOOGwKKtuCMtoqT4slC8TWc+7xSzBVWGAaGcjrIhzdNaMoUhax/i/2csRMMCiOE+J9AJ2N0AaOYLKAO+n/Lu10xgMDHy2WCwpc4zX6SnMHm5/0cAFYKMNBtnmEsfeki+Ai+66Z5SpOMm6SUkjyveOqEwkOVDXYrfVXt2jJszpt7bSKpJcHYQfooUlszcbVNdxjOEYhBLlpHC7KVU+f0qUu0oYkBK/2bU5KRjFFE57N3NwZxHoDjBewJ5xwJuTPx40mqKVLMpFq8vWxWcGUe7owVq8PhP8QAsoogfabB/PxNIFLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BN8PR15MB2514.namprd15.prod.outlook.com (2603:10b6:408:c8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Wed, 30 Mar
 2022 21:11:13 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::58c9:859d:dc03:3bb4]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::58c9:859d:dc03:3bb4%3]) with mapi id 15.20.5102.023; Wed, 30 Mar 2022
 21:11:13 +0000
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
Thread-Index: AQHYQ8NoYshikhsCNUuid70h4G7GUqzXCr4AgAAK54CAACPCAIAAQfAAgADygAA=
Date:   Wed, 30 Mar 2022 21:11:13 +0000
Message-ID: <0BCC6E9C-90E1-4B56-8829-12D180520D71@fb.com>
References: <20220329231854.3188647-1-song@kernel.org>
 <CAEf4BzZCLwzrZPTOBEg88i1Tki6uPL73ujSE-SCSSU16HENUHA@mail.gmail.com>
 <53E87B8F-6BB1-42AB-965B-096C86236926@fb.com>
 <CAEf4BzbVqM_akAGsHkf4QJdwcA2M-Lg6MF6xLu72rRS8gUjPKw@mail.gmail.com>
 <A68BDAD9-A4D9-48D0-ACAF-7AF6AD38F27B@fb.com>
In-Reply-To: <A68BDAD9-A4D9-48D0-ACAF-7AF6AD38F27B@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b963459-d1ae-4579-9a70-08da1291d23d
x-ms-traffictypediagnostic: BN8PR15MB2514:EE_
x-microsoft-antispam-prvs: <BN8PR15MB251454D19B94198A6CC5170AB31F9@BN8PR15MB2514.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kCWfi3jBHG/c69k58doKzWMNKXnUa8la7NJUsOIb5SaDfaj0U3s8Cd7/OOWEf9SW45Q4qCwkztzLfkZ/I0rNgZ3Yvxn/7Qi3GBqjuXALhKtQKvGgYlfkHlwnrwb+Da+5H4uHbHiNjy+PJ3dY6cLFLICBAkd+7hM7jJ93xRMaaPSiev3mr9BZNgt9WyVz4NwJaaazCcNSB6M4q5j25OskzB0ATmUPfiBqakXeVR2AP/2gBjgg5NGGDdpZne9jTYMOu+23/aSOfQ1VM+VnbXieElmheKSR8IucW7Tmd8XqZZ+SIUfB7e7xmqKmxEEfQ9S2KA2DtAh+jpoVVUpWEFOOTZeCFcidk1F89vSb+GN704iLjnhuslXHzQHUo/OYqViYaNjm5q0UiI28OH1OT5tKU6O00y3xc+FpFwFrfcZEjTZFxLxJ6pWxorDNDnk387SgH0WgHpPCjiI+1JAtfUs8wHaiwnLBb22e9zuihedNMBzb/k9gyNoz8bUYgkJQ5s9Ruq8Dig1bAh7VraSdhEQ2YYUKcPYNen60xiNhMLxyF03yz3bHtGn5+auU5eFASZA8EwT0JtVAzUFRf9CsctWbuQVUSqUbb53R9rZW2cR9ZkKiu+wolOWJd0U0B4b1BPhOmqZ0X3YT07TOnD5U6TFqv082i/FolqiHfKHtVRo9TIxAgUQxkf5x/1SV1jdINqtV5Zr4Jur+1XD3Wn/GIdjmF1mqZinuo7ZSSFy9L0Bvdzeh3Br91tD+khZT2zliFIHeD2N5RUEeIShezIwpahdslw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(64756008)(83380400001)(122000001)(2906002)(508600001)(6512007)(15650500001)(4326008)(6506007)(76116006)(66446008)(66476007)(66556008)(66946007)(8676002)(36756003)(71200400001)(53546011)(54906003)(6916009)(6486002)(91956017)(33656002)(8936002)(186003)(38100700002)(2616005)(86362001)(5660300002)(316002)(38070700005)(101420200003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ODgzFExhfsZ6mIJz98WypAzw88hL4LMDUI2Q0kwYi/JtelE3ElDO7LTveHvx?=
 =?us-ascii?Q?2K5IMdZsuK3KfOlPcJjx8uqz/hEz3K8WBlu3a/Mc/vQBSxY7McVKhDmzK2au?=
 =?us-ascii?Q?IdgctYDsYnKmPczyAiawF7r0VXxnvYzrJl7zY9EX9e2+PCmIUnxMXOraX1WN?=
 =?us-ascii?Q?8aKUMkQfafgoGehNLvBARhOK2Q5I8xaWt4LwronUAQaEFPU+NK/4ALXZNzBS?=
 =?us-ascii?Q?ClmFl5BNKy1wq1sixmbOcDFUlKRS3/uZjlFW8kWeCrL7VEToPH+Kt9qFshv2?=
 =?us-ascii?Q?LdjqKu/BuOI9zW2JeaQWAsGP4UtWiveQvB8pLrmpZAfXIhDIhNvGv+h9ZJwf?=
 =?us-ascii?Q?yyW3G1C5d0S+MWeNy+TFJmolTXdEvhBOhUT7tvHlYIJ4OTxS8+gFZ+4X+lYG?=
 =?us-ascii?Q?BhB2LhF/v1dv5wtiVjHD9MhSvV8plHTpQbsdFsRpxmG42imGilgW3barg16r?=
 =?us-ascii?Q?1efoKWhewaB+pAlRFyK36UuUVcsbAxgUpvNK04Whqeq/LPLLYTvlDsgyZscn?=
 =?us-ascii?Q?fLipVpNM1EAL+Z0yBrndYcQa9M4aZTaeXgb/SOiNDe11y1SDnfjCpR3pp6H8?=
 =?us-ascii?Q?buq0aRF5/gK9yc+D/Sblt8XfDZUpvV7io5FQNBxWA5F+FB7P241fbTQeNmiF?=
 =?us-ascii?Q?txmyiF3Omeb/Hl0k9fO5SeySCJIwhPh3s4Bn3Mz/FO8jptLKgZtE4BKGdksQ?=
 =?us-ascii?Q?509D882LDbSFk0PGOrODULY7NzIarZ+d36p6nWoTM/72IIn1Qe9DO8thKvjo?=
 =?us-ascii?Q?Q7xgewy682woVCtpYgCAg4P0uYa2I6cnyQPWKwe1QO+lYkU4yNwtzjSF3N+L?=
 =?us-ascii?Q?UJMsnnDK4qYQERVWjnXUN0Eh/M358IzgAkDGksessd2t3i/WR57EVQA3VYm0?=
 =?us-ascii?Q?BIx8SIebyZVzfMK3UWD00vbujuZG9DYyilousf72JmNq1cPS3sSvUB0bIJ4G?=
 =?us-ascii?Q?YZ3bxmW5bbzGLtG9ThGQNn2ICg6G8CpxgOBJSEwOrIw2fVaAhlND+u0AmOPv?=
 =?us-ascii?Q?2KXgVYQ12vhBUqeLqzP1uNWnw8kFTU4opStaqLID+Wu9xVMiMpbnVt0+YQZo?=
 =?us-ascii?Q?uEuAU5Jp8cHRfEIlW9eptmNB2AVDSZ1xdRBw5ltPRYNenjAOia51Vr3iTTaL?=
 =?us-ascii?Q?iSouKxdPCkgJSFZ6zGdir3PJI76Yt2zbZeWLc7LDcUzwVSZwqfri3YlEISmV?=
 =?us-ascii?Q?X2tc0cejLgFIbFLw6nfUPdKY0viVZi3Rxrtkm5sgp3dkhBP3LslAy1KrNQUz?=
 =?us-ascii?Q?SSShag8MyMhuABZSM4COuk+rYMOgPFwVA7AF79tzIPJTMCQ1oJ+1BObosP8G?=
 =?us-ascii?Q?q58WrMN8zGkSIgq1yqdJEBKFf5uaWbSMG7pMlHMbC9LEZe7s6Rm8HoR4EeRh?=
 =?us-ascii?Q?axZMUsG9IPYXpux6iqEDNcITUs7LwCRtgCTqnEu0XbwkjBx4S1bVXFHwNAWy?=
 =?us-ascii?Q?1S6Dc+7fJU7cFSqr3mZ+6H779qlTNRvGBkbsmiZlbZr95ndqR7Vlh1SGQngO?=
 =?us-ascii?Q?WNnzvKEcIuxUXM6x53fUJvagiltcJupDKDxVDvlEJdRYkMapI0kBA4B93Fpc?=
 =?us-ascii?Q?XNxtBdBad+5zkUm98/xtZmonLn5UBjGr7d1p5OFbte7xNQ9EYG5MnKf9AY4S?=
 =?us-ascii?Q?gKrCFs+x1QzptyYaeJ1euxtvJyK2sO31/Z0LcGfpPPrM9lPMBsgnHcGsPnnl?=
 =?us-ascii?Q?eXJk/mXSVCP56T7JBYyaqN/2SXXShe2CCnTyPjuwutg4kHs2UAGI0VqszCg9?=
 =?us-ascii?Q?8HriCS7qSqq8QFmLjPClt1XzFWSpMRzwsZQh2xh4TD/u/WLr8RuJ?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CDFE26EECB63154FAF1D3F07D6B44F5D@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b963459-d1ae-4579-9a70-08da1291d23d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2022 21:11:13.2375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QB0RsNbByaaHs8VcY6rrSKQmFWk65CRwACeF9FJALrnEYII1l/L83/3GY/S7fOQ0rX7cGVxLGcDJSaLIiNJFNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2514
X-Proofpoint-ORIG-GUID: I_9nEK9f4AQLJaggOfLVyPfMvgSz_wQ2
X-Proofpoint-GUID: I_9nEK9f4AQLJaggOfLVyPfMvgSz_wQ2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_06,2022-03-30_01,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 29, 2022, at 11:43 PM, Song Liu <songliubraving@fb.com> wrote:
> 
> 
> 
>> On Mar 29, 2022, at 7:47 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>> 
>> On Tue, Mar 29, 2022 at 5:39 PM Song Liu <songliubraving@fb.com> wrote:
>>> 
>>> 
>>> 
>>>> On Mar 29, 2022, at 5:00 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>>>> 
>>>> On Tue, Mar 29, 2022 at 4:19 PM Song Liu <song@kernel.org> wrote:
>>>>> 
>>>>> TP_PROTO of sched_switch is updated with a new arg prev_state, which
>>>>> causes runqslower load failure:
>>>>> 
>>>>> libbpf: prog 'handle__sched_switch': BPF program load failed: Permission denied
>>>>> libbpf: prog 'handle__sched_switch': -- BEGIN PROG LOAD LOG --
>>>>> R1 type=ctx expected=fp
>>>>> 0: R1=ctx(off=0,imm=0) R10=fp0
>>>>> ; int handle__sched_switch(u64 *ctx)
>>>>> 0: (bf) r7 = r1                       ; R1=ctx(off=0,imm=0) R7_w=ctx(off=0,imm=0)
>>>>> ; struct task_struct *next = (struct task_struct *)ctx[2];
>>>>> 1: (79) r6 = *(u64 *)(r7 +16)
>>>>> func 'sched_switch' arg2 has btf_id 186 type STRUCT 'task_struct'
>>>>> 2: R6_w=ptr_task_struct(off=0,imm=0) R7_w=ctx(off=0,imm=0)
>>>>> ; struct task_struct *prev = (struct task_struct *)ctx[1];
>>>>> 2: (79) r2 = *(u64 *)(r7 +8)          ; R2_w=scalar() R7_w=ctx(off=0,imm=0)
>>>>> 3: (b7) r1 = 0                        ; R1_w=0
>>>>> ; struct runq_event event = {};
>>>>> 4: (7b) *(u64 *)(r10 -8) = r1         ; R1_w=P0 R10=fp0 fp-8_w=00000000
>>>>> 5: (7b) *(u64 *)(r10 -16) = r1        ; R1_w=P0 R10=fp0 fp-16_w=00000000
>>>>> 6: (7b) *(u64 *)(r10 -24) = r1        ; R1_w=P0 R10=fp0 fp-24_w=00000000
>>>>> 7: (7b) *(u64 *)(r10 -32) = r1        ; R1_w=P0 R10=fp0 fp-32_w=00000000
>>>>> ; if (prev->__state == TASK_RUNNING)
>>>>> 8: (61) r1 = *(u32 *)(r2 +24)
>>>>> R2 invalid mem access 'scalar'
>>>>> processed 9 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
>>>>> -- END PROG LOAD LOG --
>>>>> libbpf: failed to load program 'handle__sched_switch'
>>>>> libbpf: failed to load object 'runqslower_bpf'
>>>>> libbpf: failed to load BPF skeleton 'runqslower_bpf': -13
>>>>> failed to load BPF object: -13
>>>>> 
>>>>> Update runqslower to fix this issue. Also, as we are on this, use BPF_PROG
>>>>> in runqslower for cleaner code.
>>>>> 
>>>>> Fixes: fa2c3254d7cf ("sched/tracing: Don't re-read p->state when emitting sched_switch event")
>>>>> Signed-off-by: Song Liu <song@kernel.org>
>>>>> ---
>>>>> tools/bpf/runqslower/runqslower.bpf.c | 19 +++++--------------
>>>>> 1 file changed, 5 insertions(+), 14 deletions(-)
>>>>> 
>>>> 
>>>> It would be much less disruptive if that prev_state was added after
>>>> "next", but oh well...
>>> 
>>> Maybe we should change that.
>>> 
>>> +Valentin and Steven, how about we change the order with the attached
>>> diff (not the original patch in this thread, but the one at the end of
>>> this email)?
>>> 
>>>> 
>>>> But anyways, let's handle this in a way that can handle both old
>>>> kernels and new ones and do the same change in libbpf-tool's
>>>> runqslower ([0]). Can you please follow up there as well?
>>> 
>>> Yeah, I will also fix that one.
>> 
>> Thanks!
>> 
>>> 
>>>> 
>>>> 
>>>> We can use BPF CO-RE to detect which order of arguments running kernel
>>>> has by checking prev_state field existence in struct
>>>> trace_event_raw_sched_switch. Can you please try that? Use
>>>> bpf_core_field_exists() for that.
>>> 
>>> Do you mean something like
>>> 
>>> if (bpf_core_field_exists(ctx->prev_state))
>>>   /* use ctx[2] and ctx[3] */
>>> else
>>>   /* use ctx[1] and ctx[2] */
>> 
>> yep, that's what I meant, except you don't have ctx->prev_state, you have to do:
>> 
>> if (bpf_core_field_exists(((struct trace_event_raw_sched_switch
>> *)0)->prev_state))

Actually, struct trace_event_raw_sched_switch is not the arguments we 
have for tp_btf. For both older and newer kernel, it is the same:

struct trace_event_raw_sched_switch {
        struct trace_entry ent;
        char prev_comm[16];
        pid_t prev_pid;
        int prev_prio;
        long int prev_state;
        char next_comm[16];
        pid_t next_pid;
        int next_prio;
        char __data[0];
};

So I guess this check won't work?

Thanks,
Song

