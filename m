Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DBF23C6E7
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 09:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgHEHX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 03:23:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16516 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725904AbgHEHX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 03:23:58 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0757Nd9L008540;
        Wed, 5 Aug 2020 00:23:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=IWAjldRq+VGWHug82JKmiW9uD9FZn/Tlfbn3aftZ7FE=;
 b=Gyxu6aVeBjI0vtHDhwZFEE3x/wfqXr4fyEk0tpEAK2t1eNIlWOXKHy0hydnNJ4pz2Uzg
 pJRGnis5SlH24yVDrFYM3+VUIvU4AbtjMRIH7fdzx5s6Gt3A553DYfCej5WFcmrxd+et
 JIKXRiEXEuwMCOtIsHuLYeMu/JJlrd7I4z0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32nrcsegb6-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 05 Aug 2020 00:23:41 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 5 Aug 2020 00:23:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MaEn65HbhpYhRoKMmliAb/yFzMq5ktP5xYY0kQQ9vnVI9f9P3yhI9NOYOm67OQi8o7wJY3SDhLwspPiWaFJJKdKC7VwR162nlgIYgcnVTGmWrBKekMREMxss5zGJeENEWKPVQvhr2lbdxIMjzZvIJ+Gb1OPbgzHm1SFA5cbDvPRVlYm4jlVlgaIEc2DLaOvpJz8WmCei9lL2IHwKqtdUKd7/riwyh9W+ZhDVO1Dj5b5oo8my9pAIAspvWogV3ZWCo1qUURVx3EAZBty24ngj/2nNbuTY4Y62S6HIMEZDs0Lu53/D1PeBXwxZRj/MO9B2X0/3WHuQulmfG7eej/VWrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWAjldRq+VGWHug82JKmiW9uD9FZn/Tlfbn3aftZ7FE=;
 b=Z9WJBpdtjwUauM08yqNiyKox5ksTuXFjaQJzJYd5VrXxU5OQk27JjA+JwOij9JtIH6U5hQ7URavM5hl9XZtoXN92sa1CXlXAFioTCmRoVmIMUJu+WjQtqLIx3TtgqZiMfnJtbuX0D8p/gMU1I40HWppiBXtIADBRhimkt8C1qjHpi1FqQGQBVfNeZC6TldUgTF34a3oTn0R1OoYia4BNSPRLm4uPwyHPlxEF2r1RsTMjk7FETxowCLtF4fpG5FbB20evoiwBCFGTQjfGnpctBRxenXZ8zYu/Ecqn3zvagfuji+rBY+ch4ua6cLaNZ1RFefBy5YSd5PHwVyCgcpol0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWAjldRq+VGWHug82JKmiW9uD9FZn/Tlfbn3aftZ7FE=;
 b=S64FNgVEoRz2ON42IDrOnNnokKWefNBdPZmZ+mGRWCDNezRxgxCi3k7FSV9G2agxTKw98A9S+2qPRyB+LU8LnAadf7evsHqGNz/+TNAUTTXZUDDCeX9lf8XlpgwPxF4JywCaDsG+0x0mYdV+vTFxqAyctbMQFH52JhPQJYGXq6c=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2728.namprd15.prod.outlook.com (2603:10b6:a03:14c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Wed, 5 Aug
 2020 07:23:32 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3239.022; Wed, 5 Aug 2020
 07:23:32 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Xu <dlxu@fb.com>
Subject: Re: [PATCH bpf-next 2/5] libbpf: support BPF_PROG_TYPE_USER programs
Thread-Topic: [PATCH bpf-next 2/5] libbpf: support BPF_PROG_TYPE_USER programs
Thread-Index: AQHWZ+C4tQwFkmvi20aNhPcONSrEz6klnl6AgAGMFwCAAZgFAIAAJ1IAgAAaAQCAAA8tgIAAB7wAgAAIKwA=
Date:   Wed, 5 Aug 2020 07:23:31 +0000
Message-ID: <88081DFA-39FF-42BB-98F4-CCDE634A1775@fb.com>
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-3-songliubraving@fb.com>
 <CAEf4BzYp4gO1P+OrY7hGyQjdia3BuSu4DX2_z=UF6RfGNa+gkQ@mail.gmail.com>
 <9C1285C1-ECD6-46BD-BA95-3E9E81C00EF0@fb.com>
 <CAEf4BzYojfFiMn6VeUkxUsdSTdFK0A4MzKQxhCCp_OowkseznQ@mail.gmail.com>
 <5BC1D7AD-32C1-4CDC-BA99-F4DABE61EEA3@fb.com>
 <CAEf4BzbbCZmijrU4vfkmq2PFsMMFG+xz9qR1e4wfrdm6tF4_hA@mail.gmail.com>
 <4DB698F2-BC51-4E96-BC3B-F478BE9AE106@fb.com>
 <CAEf4Bza4KXkVov=UwouryG5JcqYQ=9mDG8nBoWmb97rv+_yqTw@mail.gmail.com>
In-Reply-To: <CAEf4Bza4KXkVov=UwouryG5JcqYQ=9mDG8nBoWmb97rv+_yqTw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:8f7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 843dde1c-480b-4211-b035-08d839107534
x-ms-traffictypediagnostic: BYAPR15MB2728:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2728C224C98C40F73949AAC6B34B0@BYAPR15MB2728.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:669;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WwIVEMx2pbrejaU39aAVAegsebsxmNFNEHFBR3QufAVDrAjvMFLPSzRCkJofw/Nptf3Ja6nkjhwZ155cbgEE8vBBqNmSuly0wp+E6j9TApgiRq9q5oB4W+J/k57JjcXvh0NWekTclT8MNxXTLg2k4iKDchuzB0/PO0odtds1sOwEdjofdeWXw+m6lHVQl96q7sqeusKne5OfaLNbRJTJ0ZLg269YZvtuX0n/+HpmE15C4fU+9wHL1qN1DjRrl2CP1zgiU5WWOKsiqrt0nY9oNeOzyjdHkw77f/ojRYDODBJrifV9VqBCIqyOLeZ0SvdUqbGQBalgQZA2kbXDpbF7rP+EpWX0aRbaQCtJOJ1wpNDYjr90TAiYyM+SEWW/xbVA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(346002)(396003)(376002)(136003)(33656002)(2616005)(83380400001)(64756008)(66476007)(66556008)(66446008)(8936002)(8676002)(71200400001)(2906002)(66946007)(76116006)(6916009)(186003)(6512007)(36756003)(54906003)(6506007)(478600001)(6486002)(316002)(4326008)(53546011)(5660300002)(86362001)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: KYM/m/OiLIb58J83l2mxDQFsYn6FLsVdsJH5UVfG5K5FjCLdh2FntVT3yDU7Kr+FFAxr2u4GaN/DBbnGErn4DERw+wxVeIcIx8YhAsZhxOo6ItS/RQjCCsEVGBbJgs91qTaXZf67gj9YI0DJDFnR5btVPsQy14172SMbSc44fKKJ5KFDS/cXDpzQDfU6jG4Ju81+XGpvVkqGiATiWdNY8u4Xu5Ux7CGSa0u1VOuE9Mq0qZ8d44UkTHaA2defJbqFeWNDhnLAyvNoccNjP1s+Dfmf+ioa6k2+M2xCdJLTPGIifEM/VDrU0NSBc33MUpo7dBryuwNbGtD6U1sLPGMZ44uOmkfdwnsoTN+SHi8cosm2W2ppIh2QyhvX7XRyw7AUjzFQvCEV1kZL5zX0yq/oeIVzK3Zbv/G2cyIIhS22rfC6uDPTkWFu2HaTMVfK+BtLcTBvcq2sA/e0AVPgHpZs/eh2JveytCuxd6YzeP8ypX0JSz6d7jV9wg1EQk7lMgDckxP4/ya6ZOTT0MjHs4a0FgQ2jmi43JKhHt8ZkgpH2nW/KaUUkTJseKBUeqFWRj8jQsC9Dplv22wLwj6JEsIE2CRJhsNvfWCd+aqI6iZZChH/ioZId6rCEIKIunYXO0wTfSKigBAqA3tlH+7ke/RcxiOE340Krk7ZIRy4BH70xus=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5664687029CD5C4B9B5A94A62460FF62@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 843dde1c-480b-4211-b035-08d839107534
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2020 07:23:31.9963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5ExoabcYDBAECA+lLBbee/A597vjJxHdnOxb6wcZKajUrrc4L3RJoAF65hPZv2p+S9kKFu4ODhHl1gQOEvlQyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2728
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-05_05:2020-08-03,2020-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 clxscore=1015 adultscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008050062
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 4, 2020, at 11:54 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Tue, Aug 4, 2020 at 11:26 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Aug 4, 2020, at 10:32 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com=
> wrote:
>>>=20
>>> On Tue, Aug 4, 2020 at 8:59 PM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Aug 4, 2020, at 6:38 PM, Andrii Nakryiko <andrii.nakryiko@gmail.co=
m> wrote:
>>>>>=20
>>>>> On Mon, Aug 3, 2020 at 6:18 PM Song Liu <songliubraving@fb.com> wrote=
:
>>>>>>=20
>>>>>>=20
>>>>>>=20
>>>>>>> On Aug 2, 2020, at 6:40 PM, Andrii Nakryiko <andrii.nakryiko@gmail.=
com> wrote:
>>>>>>>=20
>>>>>>> On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> wro=
te:
>>>>>>>>=20
>>>>>>=20
>>>>>> [...]
>>>>>>=20
>>>>>>>=20
>>>>>>>> };
>>>>>>>>=20
>>>>>>>> LIBBPF_API int bpf_prog_test_run_xattr(struct bpf_prog_test_run_at=
tr *test_attr);
>>>>>>>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>>>>>>>> index b9f11f854985b..9ce175a486214 100644
>>>>>>>> --- a/tools/lib/bpf/libbpf.c
>>>>>>>> +++ b/tools/lib/bpf/libbpf.c
>>>>>>>> @@ -6922,6 +6922,7 @@ static const struct bpf_sec_def section_defs=
[] =3D {
>>>>>>>>     BPF_PROG_SEC("lwt_out",                 BPF_PROG_TYPE_LWT_OUT)=
,
>>>>>>>>     BPF_PROG_SEC("lwt_xmit",                BPF_PROG_TYPE_LWT_XMIT=
),
>>>>>>>>     BPF_PROG_SEC("lwt_seg6local",           BPF_PROG_TYPE_LWT_SEG6=
LOCAL),
>>>>>>>> +       BPF_PROG_SEC("user",                    BPF_PROG_TYPE_USER=
),
>>>>>>>=20
>>>>>>> let's do "user/" for consistency with most other prog types (and ni=
ce
>>>>>>> separation between prog type and custom user name)
>>>>>>=20
>>>>>> About "user" vs. "user/", I still think "user" is better.
>>>>>>=20
>>>>>> Unlike kprobe and tracepoint, user prog doesn't use the part after "=
/".
>>>>>> This is similar to "perf_event" for BPF_PROG_TYPE_PERF_EVENT, "xdl" =
for
>>>>>> BPF_PROG_TYPE_XDP, etc. If we specify "user" here, "user/" and "user=
/xxx"
>>>>>> would also work. However, if we specify "user/" here, programs that =
used
>>>>>> "user" by accident will fail to load, with a message like:
>>>>>>=20
>>>>>>      libbpf: failed to load program 'user'
>>>>>>=20
>>>>>> which is confusing.
>>>>>=20
>>>>> xdp, perf_event and a bunch of others don't enforce it, that's true,
>>>>> they are a bit of a legacy,
>>>>=20
>>>> I don't see w/o "/" is a legacy thing. BPF_PROG_TYPE_STRUCT_OPS just u=
ses
>>>> "struct_ops".
>>>>=20
>>>>> unfortunately. But all the recent ones do,
>>>>> and we explicitly did that for xdp_dev/xdp_cpu, for instance.
>>>>> Specifying just "user" in the spec would allow something nonsensical
>>>>> like "userargh", for instance, due to this being treated as a prefix.
>>>>> There is no harm to require users to do "user/my_prog", though.
>>>>=20
>>>> I don't see why allowing "userargh" is a problem. Failing "user" is
>>>> more confusing. We can probably improve that by a hint like:
>>>>=20
>>>>   libbpf: failed to load program 'user', do you mean "user/"?
>>>>=20
>>>> But it is pretty silly. "user/something_never_used" also looks weird.
>>>=20
>>> "userargh" is terrible, IMO. It's a different identifier that just
>>> happens to have the first 4 letters matching "user" program type.
>>> There must be either a standardized separator (which happens to be
>>> '/') or none. See the suggestion below.
>>=20
>> We have no problem deal with "a different identifier that just happens
>> to have the first letters matching", like xdp vs. xdp_devmap and
>> xdp_cpumap, right?
>>=20
>=20
> xdp vs xdp_devmap is an entirely different thing. We deal with it by
> checking xdp_devmap first. What I'm saying is that user can do
> "xdpomg" and libbpf would be happy (today). And I don't think that's
> good. But further, if someone does something like "xdp_devmap_omg",
> guess which program type will be inferred? Hint: not xdp_devmap and
> libbpf won't report an error either. All because "xdp" is so lax
> today.
>=20
>>>>=20
>>>>> Alternatively, we could introduce a new convention in the spec,
>>>>> something like "user?", which would accept either "user" or
>>>>> "user/something", but not "user/" nor "userblah". We can try that as
>>>>> well.
>>>>=20
>>>> Again, I don't really understand why allowing "userblah" is a problem.
>>>> We already have "xdp", "xdp_devmap/", and "xdp_cpumap/", they all work
>>>> fine so far.
>>>=20
>>> Right, we have "xdp_devmap/" and "xdp_cpumap/", as you say. I haven't
>>> seen so much pushback against trailing forward slash with those ;)
>>=20
>> I haven't seen any issue with old "perf_event", "xdp" and new "struct_op=
s"
>> either.
>>=20
>>>=20
>>> But anyways, as part of deprecating APIs and preparing libbpf for 1.0
>>> release over this half, I think I'm going to emit warnings for names
>>> like "prog_type_whatever" or "prog_typeevenworse", etc. And asking
>>> users to normalize section names to either "prog_type" or
>>> "prog_type/something/here", whichever makes sense for a specific
>>> program type.
>>=20
>> Exactly, "user" makes sense here; while "kprobe/__set_task_comm" makes
>> sense for kprobe.
>=20
> Right, but "userblah" doesn't. It would be great if you could help
> make what I described above become true. But at least don't make it
> worse by allowing unrestricted "user" prefix. I'm OK with strict
> "user" or "user/blah", I'm not OK with "userblah", I'm sorry.

If the concern with "userblah" is real and unbearable, so is "xdpblah"
and "perf_eventblah", and so on, and so on.=20

>=20
>>=20
>>> Right now libbpf doesn't allow two separate BPF programs
>>> with the same section name, so enforcing strict "user" is limiting to
>>> users. We are going to lift that restriction pretty soon, though. But
>>> for now, please stick with what we've been doing lately and mark it as
>>> "user/", later we'll allow just "user" as well.
>>=20
>> Since we would allow "user" later, why we have to reject it for now?
>=20
> Because libbpf is dumb in that regard today? And instead of migrating
> users later, I want to prevent users making bad choices right now.

The good choice here is to use "user", IMO. And you are preventing people=20
to use it. If user has to use "user/" for now. They will have to update=20
the programs later, right? If the conclusion is "user/xxx" is the ultimate
goal, I would agree with "user/" for now.=20

> Then relax it, if necessary. Alternatively, we can fix up libbpf logic
> before the USER program type lands.

I don't see why the USER program type need to wait for libbpf fix, as
"xdp", "perf_event", etc. all work well today.=20

>=20
>> Imagine the user just compiled and booted into a new kernel with user
>> program support; and then got the following message:
>>=20
>>        libbpf: failed to load program 'user'
>>=20
>> If I were the user, I would definitely question whether the kernel was
>> correct...
>=20
> That's also bad, and again, we can make libbpf better. I think moving
> forward any non-recognized BPF program type should be reported by
> libbpf as an error. But we can't do it right now, we have to have a
> period in which users will get a chance to update their BPF programs.
> This will have to happen over few libbpf releases at least. So please
> join in on the fun of fixing stuff like this.

I'd love to join the fun. Maybe after user program lands ;)


