Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61C923C5BA
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 08:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgHEG06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 02:26:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34504 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725904AbgHEG04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 02:26:56 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0756PRjv010601;
        Tue, 4 Aug 2020 23:26:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=K3MRQ9Lx00VnZNwvSCA8Q39TCtbLBNerKPf3nlLbPCQ=;
 b=nFfyy/8CmvU6llyykO0sH1kVJ0UonV/6Raw8bGEZhPHYEGH/STP+pynWPLUJXICVvbOo
 8X9etPNtxyTQqdkmgwndboZzVpRGzcls9Uy/jlzp2/CZYNOteUlWXfUkIygNro3Byq89
 iqyCncPcrv2s2w4aAkqnH2l8j4Uy34QAAmk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 32n81ygnct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 04 Aug 2020 23:26:38 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 4 Aug 2020 23:26:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WIXgC5G7UcxyW8ziDoehq3tPs+XeGl1Nc0SDBSw8OYtne2iAnSajQY3ezmYKdjnZUeBgOzONOCLGBz8bkJEdL4HWVxiOU0I/fG9lDVUUEmk6O0HemGXuseBoZVxoIwis2i9vf6FBonxt9nEcdQrFx/h7yBfhY3pTY9z22K7/f7H8znNInMG4NZ5EqWIqX2mh3bu+XRojDAaayOkJebbj+JM/QA/tJQT6o6Vq8jedEdAclxSagDlK3dQT7xd/xr45ahtyxSsI4HYM7kveERlm6sjYbvRC3S6wV5XP8Aa/6tYAV1Et37L1c33Rlpu8yufWMKxFrrWFhsdN2zP1nzxGmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3MRQ9Lx00VnZNwvSCA8Q39TCtbLBNerKPf3nlLbPCQ=;
 b=Bwi71jOI9wMLEPSUXUHWIm5tD/jVo3MBB1dKHpQGMzkPptV4JbMp2XOc1lQ2wawO0UR8TFHk7WRb8qndv3EDXiaufAFb6vvU2Q+TOhzPPvvMTld8vGXHSm5ptvK6F9BNihvy+bFrLN/kUeZGlaY4kPvLGLdCaOQ4JiYCDM427fqEKbUqednYUOc3tf46s6+cjDkybtQV/CQ5iKY3Kg1GMM5ilpRX8UItazdOiGLCRZpVj1CrC7vCIGtWzvW3hAu0ffuxvdmfxf805Eh+Z2WEPVJhG7hkeKUP83TxzYZaodP4p2SFoRCERB3MxZRjM2fCiMkhjTo7gtTdEwFKNwbsAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3MRQ9Lx00VnZNwvSCA8Q39TCtbLBNerKPf3nlLbPCQ=;
 b=K3qyukBp7n9Iq0lBkfbb2u+GApR/d8ba6xRvjeOWabIKVqDC0Le7dYxG/hFIQIocevheVqlMtJRP4uGrEtCznpolqUlYTZ99Yvt8bt82/9rkMz6KpmAEygQ26rAymhM4oCKjkvjgmVra++UPGW8cJEiVFPaFnFL2Ksksw6XqAGA=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3094.namprd15.prod.outlook.com (2603:10b6:a03:ff::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Wed, 5 Aug
 2020 06:26:36 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3239.022; Wed, 5 Aug 2020
 06:26:36 +0000
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
Thread-Index: AQHWZ+C4tQwFkmvi20aNhPcONSrEz6klnl6AgAGMFwCAAZgFAIAAJ1IAgAAaAQCAAA8tgA==
Date:   Wed, 5 Aug 2020 06:26:36 +0000
Message-ID: <4DB698F2-BC51-4E96-BC3B-F478BE9AE106@fb.com>
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-3-songliubraving@fb.com>
 <CAEf4BzYp4gO1P+OrY7hGyQjdia3BuSu4DX2_z=UF6RfGNa+gkQ@mail.gmail.com>
 <9C1285C1-ECD6-46BD-BA95-3E9E81C00EF0@fb.com>
 <CAEf4BzYojfFiMn6VeUkxUsdSTdFK0A4MzKQxhCCp_OowkseznQ@mail.gmail.com>
 <5BC1D7AD-32C1-4CDC-BA99-F4DABE61EEA3@fb.com>
 <CAEf4BzbbCZmijrU4vfkmq2PFsMMFG+xz9qR1e4wfrdm6tF4_hA@mail.gmail.com>
In-Reply-To: <CAEf4BzbbCZmijrU4vfkmq2PFsMMFG+xz9qR1e4wfrdm6tF4_hA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:8f7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2860b8f7-d824-4728-b6fe-08d83908813c
x-ms-traffictypediagnostic: BYAPR15MB3094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3094A358EF6EE7CBE7975211B34B0@BYAPR15MB3094.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4989XmiWo8Q+c/mrtXwX2Rk1M9dQZv7eBjaGdwKs9cA7y5YCnpDTUFjKomYlUAMnC2JSulDJdu6V8Df8QRm0Uvlhto9y5aiI2wA8xZbQuep3O6b5sS+c/F917zSPpv8MH+i4mYvDVhFSBhdmPdaEwPeIG5EgMG7oCLM9PhsWn1IQdiotoEnKVS9MU0PibSQxvxrNFQTaAVMtTqY5rUpzXY5mGmwstXQMAbXxRitL+dVr7MJL0I+Np9FoW3NjBz9ttzPowuVhYLfda7mDKY9DmN100PUf5UJSkVMXI/J+up+Ib1lOThlAy+fEDo9oqdcM4K7I7NTW4vHKjzhSWnkLuX84UzcU7NU9gp5TUSQna74my6l9lcWuCf2Uzyl5kLMI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(346002)(39860400002)(136003)(376002)(6486002)(2616005)(6916009)(4326008)(36756003)(86362001)(6506007)(33656002)(71200400001)(53546011)(2906002)(76116006)(83380400001)(5660300002)(8676002)(6512007)(64756008)(66556008)(54906003)(66476007)(66946007)(186003)(8936002)(478600001)(66446008)(316002)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: wK30etm4MVtN26ctnhpsogkusmGccgd/cD2ggpXQ05Ro35Qin5UcYEF3T+GHLr0hGRH609lp2IlH4VA7KDKez79jBjO2VXMacmTXe+W/i6SV24pfYOlguUVoampe0VzTq8dQlmLL0d0iTk0lQSl5epCr3QbqkB/1SYlu75t8WCTB9kF9k3uim66eOk3lPI87c+n8lmxE9CxL2hJi5Udng9iOSmr7N8MOCj/1pM+BOm9QN9J/hgEywqwgkOxj3GV11yOOcTZIodD4xdXeKZ2jfGWI+LFcMy0IwSuAfTcnb9qd40baK0SMLuVQ7Ig5gcaicPH5MsOgLh5/0wLGZBFekrFYAYHF7mRg+hyxmNpJbr2uPRQLUTTLigtUa5DD5nfOTbNrErc/knDaPXik+L9OyYsqexGh7OSl7QkY0TQpktlqm5bqb6T7hO0N2LT+2HHxkL+uoaRWh/yZdoqAh/yF5Ua9liIx1262KT6cz+FT9qV4XCWMHDYSPSsQGcX4iBnbDuprAmorcX8z38bzEaGSovbJJ0fQyWveIW4iHMVl/gav2n4Ikp24gvBDnbZjouttzs0hN9Sr0o1FtAB9yBDu6OYQKeTsp1uZi+DFksgEBUui08O3tWOnSDUXVnld6yQOaKEXy3eDDanQ+kZxx4BJhd73iwkvvEZ1ok+676BCpCc=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <53731D105C5BE64691331E4735E38722@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2860b8f7-d824-4728-b6fe-08d83908813c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2020 06:26:36.2497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 087JlHqs7FUe6p/AA0TBKHF94pSs2807R9zhrfw7MLs1j0vUIIhS6impDbfXUh2isSHICfGZFg8euA0XwWdVDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3094
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-05_04:2020-08-03,2020-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0 suspectscore=0
 impostorscore=0 adultscore=0 clxscore=1015 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008050056
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 4, 2020, at 10:32 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Tue, Aug 4, 2020 at 8:59 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Aug 4, 2020, at 6:38 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>>>=20
>>> On Mon, Aug 3, 2020 at 6:18 PM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Aug 2, 2020, at 6:40 PM, Andrii Nakryiko <andrii.nakryiko@gmail.co=
m> wrote:
>>>>>=20
>>>>> On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> wrote=
:
>>>>>>=20
>>>>=20
>>>> [...]
>>>>=20
>>>>>=20
>>>>>> };
>>>>>>=20
>>>>>> LIBBPF_API int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr=
 *test_attr);
>>>>>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>>>>>> index b9f11f854985b..9ce175a486214 100644
>>>>>> --- a/tools/lib/bpf/libbpf.c
>>>>>> +++ b/tools/lib/bpf/libbpf.c
>>>>>> @@ -6922,6 +6922,7 @@ static const struct bpf_sec_def section_defs[]=
 =3D {
>>>>>>      BPF_PROG_SEC("lwt_out",                 BPF_PROG_TYPE_LWT_OUT),
>>>>>>      BPF_PROG_SEC("lwt_xmit",                BPF_PROG_TYPE_LWT_XMIT)=
,
>>>>>>      BPF_PROG_SEC("lwt_seg6local",           BPF_PROG_TYPE_LWT_SEG6L=
OCAL),
>>>>>> +       BPF_PROG_SEC("user",                    BPF_PROG_TYPE_USER),
>>>>>=20
>>>>> let's do "user/" for consistency with most other prog types (and nice
>>>>> separation between prog type and custom user name)
>>>>=20
>>>> About "user" vs. "user/", I still think "user" is better.
>>>>=20
>>>> Unlike kprobe and tracepoint, user prog doesn't use the part after "/"=
.
>>>> This is similar to "perf_event" for BPF_PROG_TYPE_PERF_EVENT, "xdl" fo=
r
>>>> BPF_PROG_TYPE_XDP, etc. If we specify "user" here, "user/" and "user/x=
xx"
>>>> would also work. However, if we specify "user/" here, programs that us=
ed
>>>> "user" by accident will fail to load, with a message like:
>>>>=20
>>>>       libbpf: failed to load program 'user'
>>>>=20
>>>> which is confusing.
>>>=20
>>> xdp, perf_event and a bunch of others don't enforce it, that's true,
>>> they are a bit of a legacy,
>>=20
>> I don't see w/o "/" is a legacy thing. BPF_PROG_TYPE_STRUCT_OPS just use=
s
>> "struct_ops".
>>=20
>>> unfortunately. But all the recent ones do,
>>> and we explicitly did that for xdp_dev/xdp_cpu, for instance.
>>> Specifying just "user" in the spec would allow something nonsensical
>>> like "userargh", for instance, due to this being treated as a prefix.
>>> There is no harm to require users to do "user/my_prog", though.
>>=20
>> I don't see why allowing "userargh" is a problem. Failing "user" is
>> more confusing. We can probably improve that by a hint like:
>>=20
>>    libbpf: failed to load program 'user', do you mean "user/"?
>>=20
>> But it is pretty silly. "user/something_never_used" also looks weird.
>=20
> "userargh" is terrible, IMO. It's a different identifier that just
> happens to have the first 4 letters matching "user" program type.
> There must be either a standardized separator (which happens to be
> '/') or none. See the suggestion below.

We have no problem deal with "a different identifier that just happens
to have the first letters matching", like xdp vs. xdp_devmap and=20
xdp_cpumap, right?

>>=20
>>> Alternatively, we could introduce a new convention in the spec,
>>> something like "user?", which would accept either "user" or
>>> "user/something", but not "user/" nor "userblah". We can try that as
>>> well.
>>=20
>> Again, I don't really understand why allowing "userblah" is a problem.
>> We already have "xdp", "xdp_devmap/", and "xdp_cpumap/", they all work
>> fine so far.
>=20
> Right, we have "xdp_devmap/" and "xdp_cpumap/", as you say. I haven't
> seen so much pushback against trailing forward slash with those ;)

I haven't seen any issue with old "perf_event", "xdp" and new "struct_ops"=
=20
either.=20

>=20
> But anyways, as part of deprecating APIs and preparing libbpf for 1.0
> release over this half, I think I'm going to emit warnings for names
> like "prog_type_whatever" or "prog_typeevenworse", etc. And asking
> users to normalize section names to either "prog_type" or
> "prog_type/something/here", whichever makes sense for a specific
> program type.

Exactly, "user" makes sense here; while "kprobe/__set_task_comm" makes
sense for kprobe.=20

> Right now libbpf doesn't allow two separate BPF programs
> with the same section name, so enforcing strict "user" is limiting to
> users. We are going to lift that restriction pretty soon, though. But
> for now, please stick with what we've been doing lately and mark it as
> "user/", later we'll allow just "user" as well.

Since we would allow "user" later, why we have to reject it for now?=20
Imagine the user just compiled and booted into a new kernel with user=20
program support; and then got the following message:

	libbpf: failed to load program 'user'

If I were the user, I would definitely question whether the kernel was=20
correct...=
