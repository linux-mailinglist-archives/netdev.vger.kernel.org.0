Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC5218A96A
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 00:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgCRXqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 19:46:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22146 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726647AbgCRXp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 19:45:59 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 02INiN3H001075;
        Wed, 18 Mar 2020 16:45:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=F3ZFLYcE40h9NrGKZNI3rM5RA2iidmNFXNMRhhg3VTE=;
 b=PABaCGybyMYPxAhabD3djBeBZg94D5dCdLTHIRjYg1go/OB0Z7+B3W/JRkDn+w3v3BzV
 o8F+C+PewBJ5yjrG7iPR38JIdKW1BKP2kHGDKxzGeD8vU4kHgnV9hq0xkAoGy02RJUSi
 CQhTx1I4xNC9Dt1fCooRCiEGpcNAVuqdBbA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2yu7ynnr8h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 18 Mar 2020 16:45:43 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 18 Mar 2020 16:45:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+Ma7Jpw/uqNZY1CCYIxdMq34lPI1wJ2sJGB3NMbglpnZaDVxyVkK2vZAQFTKIYXMG9kCei9uSPeDQDQkLyWxgpb0M/9ya2pmTtRpRgOB3me9oEf0ZZJWLQFoYkhbxZsT8vEvK+NBtwQXtbdsXlcTVjtd8X8xWcJPb+kT2tl6GHaHANhpDofi9KTdN2k38wSd/L3X9OxOkS9hlBREfUXkS4vVvkJijLw7GoPg/tRw//uXlcWEZWyrujOgBOj/pxERBmUCb8+6qsm6UIhjFUOpvLHIRI8Z+NNr6MRFzBqC9wlMvlxhLAk2aD/jOaZ+jL8LCXaa0lzGZ6K4bnexGR+vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3ZFLYcE40h9NrGKZNI3rM5RA2iidmNFXNMRhhg3VTE=;
 b=Hcmip1Zf3EotvGPZDQbdgC/S9oWdy5s0zebO7sZ11AulZKxuig/HHSAdgUFJtn/NV5/PstR779RbIMcDo2JW/getyOc5ZR3XjMul6zsXtbDRuOcT2kgXoXJhvDgI3jnmDKhFzOQjFjJHSJ49BSidsYNVJHoMJjVoTJF4c6U6R/k5ol67ztThy+c2BZKp67vnLqvrngYOeg9GYgppeo7yk8VQa1o3czq55cCFcxskjbeMnqO3En2Kvj3grduVBsOMsMbY16JRyZCZ/07kFvw2Q09Ztgx0HfEBDRWN9x9j2LbD5zwXpAOtrm+oi8NG/eiCk73Tdt+tfTPIJnQ82dM6IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3ZFLYcE40h9NrGKZNI3rM5RA2iidmNFXNMRhhg3VTE=;
 b=BNRR+ATgSMbbnpn5W90RJpU76RAlRG1RLiFYzVHkgfvMuxnC5P/PP2i+P0lLiR+ZTPirIE8e6U2Y4BrKy9SB8LicDqGLxAPdUWOENKOKMKD826ycH0nWR+M/8T6pOacMUFW/IjtHXuZTQ3z9F95xmChHD1X0jBENFxmNTXrOvpg=
Received: from SA0PR15MB3888.namprd15.prod.outlook.com (2603:10b6:806:86::21)
 by SA0PR15MB3902.namprd15.prod.outlook.com (2603:10b6:806:8e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19; Wed, 18 Mar
 2020 23:45:32 +0000
Received: from SA0PR15MB3888.namprd15.prod.outlook.com
 ([fe80::a893:6fea:4e30:e5bf]) by SA0PR15MB3888.namprd15.prod.outlook.com
 ([fe80::a893:6fea:4e30:e5bf%7]) with mapi id 15.20.2814.025; Wed, 18 Mar 2020
 23:45:32 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
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
Thread-Index: AQHV+9Iy3gdyr8P9PUGp5sv3FGMYHqhNLWaAgAAGw4CAAAJXAIAAAvkAgAAaDwCAABahAIAAfHOAgADxmICAAAYpAIAAE3uAgAAVIwA=
Date:   Wed, 18 Mar 2020 23:45:32 +0000
Message-ID: <B98810F3-EA8F-432B-A66D-7111B779AC1C@fb.com>
References: <20200316203329.2747779-1-songliubraving@fb.com>
 <eb31bed3-3be4-501e-4340-bd558b31ead2@iogearbox.net>
 <920839AF-AC7A-4CD3-975F-111C3C6F75B9@fb.com>
 <a69245f8-c70f-857c-b109-556d1bc267f7@iogearbox.net>
 <C126A009-516F-451A-9A83-31BC8F67AA11@fb.com>
 <53f8973f-4b3e-08fe-2363-2300027c8f9d@iogearbox.net>
 <C624907B-22DB-4505-9C9E-1F8A96013AC7@fb.com>
 <6D317BBF-093E-41DC-9838-D685C39F6DAB@fb.com>
 <ba62e0be-6de6-036c-a836-178c1a9c079a@iogearbox.net>
 <3E03D914-36FA-4956-AF14-CAFD784D013A@fb.com>
 <20200318222953.GA2507308@mini-arch.hsd1.ca.comcast.net>
In-Reply-To: <20200318222953.GA2507308@mini-arch.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:424]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db8cc1f9-3141-4a67-902f-08d7cb9672bc
x-ms-traffictypediagnostic: SA0PR15MB3902:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR15MB3902B8DAC8C1299B24DC9390B3F70@SA0PR15MB3902.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03468CBA43
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(199004)(81156014)(186003)(81166006)(6506007)(8936002)(2616005)(2906002)(36756003)(8676002)(71200400001)(4326008)(54906003)(53546011)(86362001)(498600001)(6916009)(33656002)(76116006)(91956017)(5660300002)(966005)(66556008)(66946007)(64756008)(6512007)(6486002)(66446008)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:SA0PR15MB3902;H:SA0PR15MB3888.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dJSSaKVf6/2upPHT44Arp9eGCHE7JgbV9hGktwGsl7N4o8w3dTUZU5lMwKQe3+obDDgE6Nuxe1k2Sgng6Vgapa4yicEecRQIiw5aQEm0CYgltSU4uM5kMKK3lhuALa25L6Y0YcUIr5vGTKmTbVpjUethp1cFUjL+ugeLzmptmxEVY1Gp/JpTeMfnvn6CmvWcidREcNPcO3XZ4twzTUHDwJIu5Ie202PHk2SJT0cm70Jx5BYA10EO31CbSgvFegYuv9EBn6UVM8SYofqbLzVYcqZfzt/gh0in1LgK/dvBEGo3XjSjB97zKPLPPVbxDkA0rwV24twOojJIdUO9uFdya1tfryxpRatE7i0YdPh4nEzEti7J45+U5sC+12z7pF/6uDBLodL1g2pI0WgLWjBCdsvAZzyNdFb4aoBZKAlUBHEf1ikXEOMg18ql6suCV8eY3UbCHTtQCKwQlPw6T7AONVaorDvLLwKqG1WvucRH/hp9INer5qOeZRcu7ep7t54AAuRS7gYC858TaSfkbzeBrg==
x-ms-exchange-antispam-messagedata: XdqjS2TtXir2ifBfgAlH7lZbN2eGJ4KQ8wb4Fuzr1/x9XI2E4Ty3KQGgboonYOTBRjx2kx366iJBe+egJWd1hmObsiLlLfcxJ6Q7VwNr2o1dqNwAekDvI+zSW4FNZvrU50QF2H5Cndg6SOIdU6Rrbrx2IS3++FEhylt506rwpDqrLpEEj1qsCDyRbcbvAa7J
Content-Type: text/plain; charset="us-ascii"
Content-ID: <57A376CD96622D4AB3ABDE4D8B0EEF6B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: db8cc1f9-3141-4a67-902f-08d7cb9672bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2020 23:45:32.5652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aUuI9y6H/6pm78JOgEIx8/BAMwDuHx3g0NKH4RqcAZv0zZzw8zotgDLWhmpheQHR+umzYomjpUIauUtpsx4W3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3902
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_07:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 adultscore=0 mlxlogscore=999
 clxscore=1011 mlxscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180103
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 18, 2020, at 3:29 PM, Stanislav Fomichev <sdf@fomichev.me> wrote:
>=20
> On 03/18, Song Liu wrote:
>>=20
>>=20
>>> On Mar 18, 2020, at 1:58 PM, Daniel Borkmann <daniel@iogearbox.net> wro=
te:
>>>=20
>>> On 3/18/20 7:33 AM, Song Liu wrote:
>>>>> On Mar 17, 2020, at 4:08 PM, Song Liu <songliubraving@fb.com> wrote:
>>>>>> On Mar 17, 2020, at 2:47 PM, Daniel Borkmann <daniel@iogearbox.net> =
wrote:
>>>>>>>>=20
>>>>>>>> Hm, true as well. Wouldn't long-term extending "bpftool prog profi=
le" fentry/fexit
>>>>>>>> programs supersede this old bpf_stats infrastructure? Iow, can't w=
e implement the
>>>>>>>> same (or even more elaborate stats aggregation) in BPF via fentry/=
fexit and then
>>>>>>>> potentially deprecate bpf_stats counters?
>>>>>>> I think run_time_ns has its own value as a simple monitoring framew=
ork. We can
>>>>>>> use it in tools like top (and variations). It will be easier for th=
ese tools to
>>>>>>> adopt run_time_ns than using fentry/fexit.
>>>>>>=20
>>>>>> Agree that this is easier; I presume there is no such official integ=
ration today
>>>>>> in tools like top, right, or is there anything planned?
>>>>>=20
>>>>> Yes, we do want more supports in different tools to increase the visi=
bility.
>>>>> Here is the effort for atop: https://github.com/Atoptool/atop/pull/88=
 .
>>>>>=20
>>>>> I wasn't pushing push hard on this one mostly because the sysctl inte=
rface requires
>>>>> a user space "owner".
>>>>>=20
>>>>>>> On the other hand, in long term, we may include a few fentry/fexit =
based programs
>>>>>>> in the kernel binary (or the rpm), so that these tools can use them=
 easily. At
>>>>>>> that time, we can fully deprecate run_time_ns. Maybe this is not to=
o far away?
>>>>>>=20
>>>>>> Did you check how feasible it is to have something like `bpftool pro=
g profile top`
>>>>>> which then enables fentry/fexit for /all/ existing BPF programs in t=
he system? It
>>>>>> could then sort the sample interval by run_cnt, cycles, cache misses=
, aggregated
>>>>>> runtime, etc in a top-like output. Wdyt?
>>>>>=20
>>>>> I wonder whether we can achieve this with one bpf prog (or a trampoli=
ne) that covers
>>>>> all BPF programs, like a trampoline inside __BPF_PROG_RUN()?
>>>>>=20
>>>>> For long term direction, I think we could compare two different appro=
aches: add new
>>>>> tools (like bpftool prog profile top) vs. add BPF support to existing=
 tools. The
>>>>> first approach is easier. The latter approach would show BPF informat=
ion to users
>>>>> who are not expecting BPF programs in the systems. For many sysadmins=
, seeing BPF
>>>>> programs in top/ps, and controlling them via kill is more natural tha=
n learning
>>>>> bpftool. What's your thought on this?
>>>> More thoughts on this.
>>>> If we have a special trampoline that attach to all BPF programs at onc=
e, we really
>>>> don't need the run_time_ns stats anymore. Eventually, tools that monit=
or BPF
>>>> programs will depend on libbpf, so using fentry/fexit to monitor BPF p=
rograms doesn't
>>>> introduce extra dependency. I guess we also need a way to include BPF =
program in
>>>> libbpf.
>>>> To summarize this plan, we need:
>>>> 1) A global trampoline that attaches to all BPF programs at once;
>>>=20
>>> Overall sounds good, I think the `at once` part might be tricky, at lea=
st it would
>>> need to patch one prog after another, each prog also needs to store its=
 own metrics
>>> somewhere for later collection. The start-to-sample could be a shared g=
lobal var (aka
>>> shared map between all the programs) which would flip the switch though=
.
>>=20
>> I was thinking about adding bpf_global_trampoline and use it in __BPF_PR=
OG_RUN.=20
>> Something like:
>>=20
>> diff --git i/include/linux/filter.h w/include/linux/filter.h
>> index 9b5aa5c483cc..ac9497d1fa7b 100644
>> --- i/include/linux/filter.h
>> +++ w/include/linux/filter.h
>> @@ -559,9 +559,14 @@ struct sk_filter {
>>=20
>> DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
>>=20
>> +extern struct bpf_trampoline *bpf_global_trampoline;
>> +DECLARE_STATIC_KEY_FALSE(bpf_global_tr_active);
>> +
>> #define __BPF_PROG_RUN(prog, ctx, dfunc)       ({                      \
>>        u32 ret;                                                        \
>>        cant_migrate();                                                 \
>> +       if (static_branch_unlikely(&bpf_global_tr_active))              =
\
>> +               run_the_trampoline();                                   =
\
>>        if (static_branch_unlikely(&bpf_stats_enabled_key)) {           \
>>                struct bpf_prog_stats *stats;                           \
>>                u64 start =3D sched_clock();                             =
 \
>>=20
>>=20
>> I am not 100% sure this is OK.=20
>>=20
>> I am also not sure whether this is an overkill. Do we really want more c=
omplex
>> metric for all BPF programs? Or run_time_ns is enough?=20
> I was thinking about exporting a real distribution of the prog runtimes
> instead of doing an average. It would be interesting to see
> 50%/95%/99%/max stats.

Good point. Distribution logic fits well in fentry/fexit programs.=20

Let me think more about=10 this.=20

Thanks,
Song

