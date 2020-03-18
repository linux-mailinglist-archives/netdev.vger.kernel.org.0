Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23F7E18A6DC
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgCRVUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:20:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40080 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726596AbgCRVUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 17:20:40 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02IL5dWU024291;
        Wed, 18 Mar 2020 14:20:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=3QUeZMQwBVDjcTbr7yURPkLohR6ApWvfzmhVLkat2uo=;
 b=fciKq23m4MIMY256nWKBG/c/6EcJ7ajWecEW5ybEe7oucv92BlO8ENRl8WukWea10FdT
 L9PNf4kUJSnJhzryb2RBaj49xsh+PDN+VYJd7uA+5MxD7unDAkjsKRtk2nZIghOV1RUK
 1iBxwC5sZRTotsf/jRbfmiBYuWZo9T7hg44= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yu8x3mwqv-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 18 Mar 2020 14:20:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 18 Mar 2020 14:20:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bFUKMnQsSUXRe4B6RU7sQ/gHh2gVyNTtfMmxQ/DgkYDcETirjOjy30SBdbKOx2pijCJzUv5avhFfzbtoEZdlrtNj2S+hydxMm0k5iK4nOOfWenuS4PP3/XvIonKCM51TFg3++ms54+A+yGVXTB6HkKDL6t5npJ5TDzhwCNQMDaqLubGnAyl2Cp7vTElfhEjOUPDSET596taezPfhALcp5aFqQVlWUn0Nfmu+ljFNA8d2KDO4qy6R+hMFIurJNAozmgk4tqw5xo22pebnpo+kkwHNKH2NOMRneohOUXdhXh51954ocJtLutWWYlRLwwNoTEHoR+U/I3LcAPlCU9aB0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3QUeZMQwBVDjcTbr7yURPkLohR6ApWvfzmhVLkat2uo=;
 b=WlHIVvrIZv+8EOFzOPWOyLF+WAAfZMP7G+rTmNtve7Nsmaptks7VZjVA3OmMLN0bh+0tC2QOqJ5WkaDM5KH5cg4XSCHf9s5bP3oO0uXB5a1fD20l0pnWT82Mw00EixtnDOP3010w8tkIaxXyos7+WUfz75FMZ/pG/4PqjwRFElmoCoNprjT4GErr6sxf8Y+IsS/cuCPRTgVQhyuEcVJ0X1NfmWjgeKNzvsEDLnZfgS8dgHYR47Mm6+cMBkvhwNc3JFLUKnQPJdrKhqQq8TyHzKHLPGoqhpgavV0yKQApf6X6VPWugN8GbQ1fL80dnO8jV1wQKEH5as9VQxOUCAawBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3QUeZMQwBVDjcTbr7yURPkLohR6ApWvfzmhVLkat2uo=;
 b=IC2lH1riU3E253sgZfTWAQ0ty57G2qufU/C34HABHoIpW5TDi2WocWMSMY3etciLdytrl9m7K2u4OPUubyjkNpLfdL47nUN2IAgOQWjKeRqTseBMCM3Q+m0DQdSrhAlfMxXgqCVW67JxZjkiYWsnLfSKOVYLC4riji98QWmT+eQ=
Received: from MW3PR15MB3882.namprd15.prod.outlook.com (2603:10b6:303:49::11)
 by MW3PR15MB3867.namprd15.prod.outlook.com (2603:10b6:303:45::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15; Wed, 18 Mar
 2020 21:20:11 +0000
Received: from MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5]) by MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5%5]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 21:20:11 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "yzaikin@google.com" <yzaikin@google.com>
Subject: Re: [PATCH v2 bpf-next] bpf: sharing bpf runtime stats with
 /dev/bpf_stats
Thread-Topic: [PATCH v2 bpf-next] bpf: sharing bpf runtime stats with
 /dev/bpf_stats
Thread-Index: AQHV+9Iy3gdyr8P9PUGp5sv3FGMYHqhNLWaAgAAGw4CAAAJXAIAAAvkAgAAaDwCAABahAIAAfHOAgADxmICAAAYpAA==
Date:   Wed, 18 Mar 2020 21:20:11 +0000
Message-ID: <3E03D914-36FA-4956-AF14-CAFD784D013A@fb.com>
References: <20200316203329.2747779-1-songliubraving@fb.com>
 <eb31bed3-3be4-501e-4340-bd558b31ead2@iogearbox.net>
 <920839AF-AC7A-4CD3-975F-111C3C6F75B9@fb.com>
 <a69245f8-c70f-857c-b109-556d1bc267f7@iogearbox.net>
 <C126A009-516F-451A-9A83-31BC8F67AA11@fb.com>
 <53f8973f-4b3e-08fe-2363-2300027c8f9d@iogearbox.net>
 <C624907B-22DB-4505-9C9E-1F8A96013AC7@fb.com>
 <6D317BBF-093E-41DC-9838-D685C39F6DAB@fb.com>
 <ba62e0be-6de6-036c-a836-178c1a9c079a@iogearbox.net>
In-Reply-To: <ba62e0be-6de6-036c-a836-178c1a9c079a@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:424]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34cab117-44bd-4885-99b9-08d7cb822496
x-ms-traffictypediagnostic: MW3PR15MB3867:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR15MB3867546C2D1ADE59946DD659B3F70@MW3PR15MB3867.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 03468CBA43
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(136003)(376002)(366004)(39860400002)(199004)(5660300002)(81156014)(81166006)(86362001)(6506007)(54906003)(53546011)(8936002)(316002)(6486002)(8676002)(2616005)(6916009)(66476007)(33656002)(66556008)(76116006)(6512007)(66946007)(966005)(71200400001)(186003)(2906002)(64756008)(66446008)(478600001)(4326008)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3867;H:MW3PR15MB3882.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jTVqsxMHNscg19Xq3e4Hy/P1TkGj1kQB5RTADwZY3U9Rsh9iO0c6Q5Dx8TmNu3rVDwm+lt5hMU83GUjJa+xOKOlAAY6SE+gbzLySs2w5LqqZBA8VSsKTP6dmuwarvj1kv77dTu5tpxTtjZGdw7fb/8rrIvdZ7SgtA6iyGTGNDt1gRJTapOuuKR7Qa1dyA8lJOlY6vfAdw4JQLqVSMbZ22tUKKto7NpW+mS10EV+qfxFQj5mezK5CVQPpnl7Pq62jT+ebLLlsdwM1zg6D1j0hcPG1OzG7efa/8BqI6EIceQD13ISmlXlo2DnqnPHM/MBWUT6xtQE2ir7SeRTOqG+AB0hvlx1/jE9aJwMMNanG+5vTYPQDz1ysPMmKnGI7zGxYtb1TjH9eOd9Lq1WK9QX3ZoQaxzfaw0EszfrKUPiMoqf4NaOYV6WyYiiHB2ByA1VNGbT3txBtlkHs4tqWnFzPwbwttIz7vDxDXQ0LZad/4vJ1rrMJ+UqP+DCGQJ0JDoSE+PCWYjlsyR3D/zeiAlpMAA==
x-ms-exchange-antispam-messagedata: IZIBhRoVbsrecCWs6gN+b6SxStPgVh4mc8ODOGiZYTM1m+mDHDz8Hidrs4nt36vQdOtu2pyXP6feACOCxAykmTSjRmIrsdad3/t+pjykU4y6BC8GmsWzy0tOshRsMvJsBxEXWao3FdWAyDn+je4oVZTOkLY4oQFiR/GI4LpyODtz4fkNouSTPV4lCvCc+WlO
Content-Type: text/plain; charset="us-ascii"
Content-ID: <874C4D6F6CDB134A8124E59F599C5F1D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 34cab117-44bd-4885-99b9-08d7cb822496
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2020 21:20:11.4717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3DyHdcBmzG4Ut0kRAIhjWxeOr4Um1MXhXlzMSe6tSu+njml4tobIsnCvk0ffFFyaVDBgwJuDyeko4IoFe99B9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3867
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_07:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 spamscore=0 suspectscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003180090
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 18, 2020, at 1:58 PM, Daniel Borkmann <daniel@iogearbox.net> wrote=
:
>=20
> On 3/18/20 7:33 AM, Song Liu wrote:
>>> On Mar 17, 2020, at 4:08 PM, Song Liu <songliubraving@fb.com> wrote:
>>>> On Mar 17, 2020, at 2:47 PM, Daniel Borkmann <daniel@iogearbox.net> wr=
ote:
>>>>>>=20
>>>>>> Hm, true as well. Wouldn't long-term extending "bpftool prog profile=
" fentry/fexit
>>>>>> programs supersede this old bpf_stats infrastructure? Iow, can't we =
implement the
>>>>>> same (or even more elaborate stats aggregation) in BPF via fentry/fe=
xit and then
>>>>>> potentially deprecate bpf_stats counters?
>>>>> I think run_time_ns has its own value as a simple monitoring framewor=
k. We can
>>>>> use it in tools like top (and variations). It will be easier for thes=
e tools to
>>>>> adopt run_time_ns than using fentry/fexit.
>>>>=20
>>>> Agree that this is easier; I presume there is no such official integra=
tion today
>>>> in tools like top, right, or is there anything planned?
>>>=20
>>> Yes, we do want more supports in different tools to increase the visibi=
lity.
>>> Here is the effort for atop: https://github.com/Atoptool/atop/pull/88 .
>>>=20
>>> I wasn't pushing push hard on this one mostly because the sysctl interf=
ace requires
>>> a user space "owner".
>>>=20
>>>>> On the other hand, in long term, we may include a few fentry/fexit ba=
sed programs
>>>>> in the kernel binary (or the rpm), so that these tools can use them e=
asily. At
>>>>> that time, we can fully deprecate run_time_ns. Maybe this is not too =
far away?
>>>>=20
>>>> Did you check how feasible it is to have something like `bpftool prog =
profile top`
>>>> which then enables fentry/fexit for /all/ existing BPF programs in the=
 system? It
>>>> could then sort the sample interval by run_cnt, cycles, cache misses, =
aggregated
>>>> runtime, etc in a top-like output. Wdyt?
>>>=20
>>> I wonder whether we can achieve this with one bpf prog (or a trampoline=
) that covers
>>> all BPF programs, like a trampoline inside __BPF_PROG_RUN()?
>>>=20
>>> For long term direction, I think we could compare two different approac=
hes: add new
>>> tools (like bpftool prog profile top) vs. add BPF support to existing t=
ools. The
>>> first approach is easier. The latter approach would show BPF informatio=
n to users
>>> who are not expecting BPF programs in the systems. For many sysadmins, =
seeing BPF
>>> programs in top/ps, and controlling them via kill is more natural than =
learning
>>> bpftool. What's your thought on this?
>> More thoughts on this.
>> If we have a special trampoline that attach to all BPF programs at once,=
 we really
>> don't need the run_time_ns stats anymore. Eventually, tools that monitor=
 BPF
>> programs will depend on libbpf, so using fentry/fexit to monitor BPF pro=
grams doesn't
>> introduce extra dependency. I guess we also need a way to include BPF pr=
ogram in
>> libbpf.
>> To summarize this plan, we need:
>> 1) A global trampoline that attaches to all BPF programs at once;
>=20
> Overall sounds good, I think the `at once` part might be tricky, at least=
 it would
> need to patch one prog after another, each prog also needs to store its o=
wn metrics
> somewhere for later collection. The start-to-sample could be a shared glo=
bal var (aka
> shared map between all the programs) which would flip the switch though.

I was thinking about adding bpf_global_trampoline and use it in __BPF_PROG_=
RUN.=20
Something like:

diff --git i/include/linux/filter.h w/include/linux/filter.h
index 9b5aa5c483cc..ac9497d1fa7b 100644
--- i/include/linux/filter.h
+++ w/include/linux/filter.h
@@ -559,9 +559,14 @@ struct sk_filter {

 DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);

+extern struct bpf_trampoline *bpf_global_trampoline;
+DECLARE_STATIC_KEY_FALSE(bpf_global_tr_active);
+
 #define __BPF_PROG_RUN(prog, ctx, dfunc)       ({                      \
        u32 ret;                                                        \
        cant_migrate();                                                 \
+       if (static_branch_unlikely(&bpf_global_tr_active))              \
+               run_the_trampoline();                                   \
        if (static_branch_unlikely(&bpf_stats_enabled_key)) {           \
                struct bpf_prog_stats *stats;                           \
                u64 start =3D sched_clock();                              \


I am not 100% sure this is OK.=20

I am also not sure whether this is an overkill. Do we really want more comp=
lex
metric for all BPF programs? Or run_time_ns is enough?=20

Thanks,
Song=
