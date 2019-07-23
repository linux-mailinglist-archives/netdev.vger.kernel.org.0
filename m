Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60131722AF
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389444AbfGWW4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:56:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1236 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726713AbfGWW4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 18:56:53 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6NMrgJ2027970;
        Tue, 23 Jul 2019 15:56:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=9nq3Zw+TUh+t2ocWsFfIG5FD/g2DWHI+Iqdq02lK+14=;
 b=ZpMEwg/+1GMKonlyFnt2BqlzOn65OTdqf5brwWgIbQlcX3jD4cxxfrtTnRduW9Isw/jN
 TZkYsUPWmXxbqDb6viEOfdRZXaDUxRj9yr29grTGei8gIQskaYL95DJRFnsq+BB+gu73
 Co3hVb4Z988RJspyEUoAwijhQTbwBXWff9o= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2txb3u82ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jul 2019 15:56:26 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 23 Jul 2019 15:56:25 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 23 Jul 2019 15:56:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVES+BJZbm/O3xLLCV5q0s0evxzD07yHIwcebccODoloRwMQpaDoULTdgTksqKiMMB5/ILbGF/87jvdjxk1xAimVsqLbVNkDUpskfiq0/eQfGik/OJrt35ewNhFc3Rcm32Q2E91S08NnWSMhAJp61/ssABPHDu/F6Qv0Fl9boMJJ1QZ/PfvOCItUAF4uQPn0HCB4hGzuDr41QSykj/HoGnxDOMyop8jEHWS/p2Jmt3mm95V5Ims726bpB+lTA4cPb4GAGW7HDK14LazSnJYP00+p7bvV3euf90JawmEpZOU5Uz7mvyIk5n1u13L62EScaYSe9Ti5jjfNOD2aUjSuIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9nq3Zw+TUh+t2ocWsFfIG5FD/g2DWHI+Iqdq02lK+14=;
 b=hLnbsDgMXgitYI9/IFZeyQaPozZzxq39Gdca8JvGqKmSnLJfGVEdlLCUNW5OVCrCtrXnn/cblF3XLqCPTZr0MG/OMwINAngoK06hrSB3wfMY305nNe5zihVeoZVcBz4RNgR1ZcQb416SIzg0MLAvT6JNi3ay5Twm6yQiGHGjz1lcC/NDRRwMHeO+Y4isYPe1UHhT+k2Og01Gl9lrY4Y1Lf57hUQhq6MGBlQuNp9X/a7URcEu1TUqT1ZqVukvuHHeCgH38wkPfUR2YNlFfE2l96iqBrb4W+k1ZZc+RL1b7+WErho+B3E+OHMXnX43Jo7R/Gw5CE1z9MRrt09944RKmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9nq3Zw+TUh+t2ocWsFfIG5FD/g2DWHI+Iqdq02lK+14=;
 b=PbjQuhg7rvve4uAXwAlld6ezqyIDHhXwEjeWD2Q7u+9ycoEz+AzZzdisWkvHzWdIhms3GCEE+JeOA9BNulxu2cfbHebvpNsSXb7i194/ruBHGFqJRlPdCZ8XMxGkKY+1dRhZhpT1fjd+/hvSV5m1ZZeI/NykcsXG8BKr9mzLVeI=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1247.namprd15.prod.outlook.com (10.175.2.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Tue, 23 Jul 2019 22:56:23 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7%7]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 22:56:23 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     Kees Cook <keescook@chromium.org>,
        "linux-security@vger.kernel.org" <linux-security@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Topic: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via
 /dev/bpf
Thread-Index: AQHVLSW5611trSWWQEuGSg4xXBva46awKSYAgAFFJoCAAehSgIACJsgAgAEbzICAARNPgIAANGYAgB9j6wCAATKggIAAgfQA
Date:   Tue, 23 Jul 2019 22:56:23 +0000
Message-ID: <514D5453-0AEE-420F-AEB6-3F4F58C62E7E@fb.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com>
 <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com>
 <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com>
 <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
 <201907021115.DCD56BBABB@keescook>
 <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
 <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com>
 <CALCETrX2bMnwC6_t4b_G-hzJSfMPrkK4YKs5ebcecv2LJ0rt3w@mail.gmail.com>
In-Reply-To: <CALCETrX2bMnwC6_t4b_G-hzJSfMPrkK4YKs5ebcecv2LJ0rt3w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:bd93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8205f1b-fd67-4643-8126-08d70fc0fc4f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1247;
x-ms-traffictypediagnostic: MWHPR15MB1247:
x-microsoft-antispam-prvs: <MWHPR15MB12471DC6E79072B59A90E98EB3C70@MWHPR15MB1247.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(396003)(366004)(346002)(136003)(51444003)(199004)(189003)(8676002)(478600001)(6486002)(6116002)(76176011)(6916009)(86362001)(99286004)(6436002)(54906003)(316002)(68736007)(4326008)(33656002)(486006)(5660300002)(14454004)(25786009)(6512007)(2906002)(476003)(256004)(57306001)(5024004)(6246003)(53936002)(305945005)(66446008)(50226002)(66476007)(66556008)(229853002)(102836004)(8936002)(36756003)(446003)(76116006)(2616005)(66946007)(46003)(81166006)(11346002)(7416002)(7736002)(71200400001)(53546011)(71190400001)(81156014)(14444005)(64756008)(186003)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1247;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: S/xk44dnnH3gpEZ+mRlUTcPQoiskQN6gww50B6yCuCXFh8lW5t+emrdk3rY1p+IAB9c4DW8C7kwIZ6KSVinGblVgyREDvtyHTdyfy6bkUR7IGaWFM2JnUBKK0ugTV4BljbDSmT8/QyZChIvu1DRQwBGQyNcRI4ACMvpDzfGjfOqHCwL42v3kjDJURGFLQmMO+ntvtkXrvPIdWNXc9VMXo7RJA9UoDdTbHYjd4aL44VxpIIB/UN0d17SO8r8VW9BslPKORzcCTf9ajA/eJFx+65TI0kK+ldOCRFgR/1PJSTdQ8Jjy4BTNXOWL9ntS2/qGqqnVkrEbxQImGcyNIkzLz5rYf/Y9VZMNrCNMyKuscNx2VwpkXwfVmxTBtNYwLH4sNC8td8X7+RrV7g7wdP6Q59WQFpW4lpTZlfcnyZVTUbk=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5EC7F3F996308B4AB86FDA88D0984145@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a8205f1b-fd67-4643-8126-08d70fc0fc4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 22:56:23.5909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1247
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907230234
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 23, 2019, at 8:11 AM, Andy Lutomirski <luto@kernel.org> wrote:
>=20
> On Mon, Jul 22, 2019 at 1:54 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> Hi Andy, Lorenz, and all,
>>=20
>>> On Jul 2, 2019, at 2:32 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>>=20
>>> On Tue, Jul 2, 2019 at 2:04 PM Kees Cook <keescook@chromium.org> wrote:
>>>>=20
>>>> On Mon, Jul 01, 2019 at 06:59:13PM -0700, Andy Lutomirski wrote:
>>>>> I think I'm understanding your motivation.  You're not trying to make
>>>>> bpf() generically usable without privilege -- you're trying to create
>>>>> a way to allow certain users to access dangerous bpf functionality
>>>>> within some limits.
>>>>>=20
>>>>> That's a perfectly fine goal, but I think you're reinventing the
>>>>> wheel, and the wheel you're reinventing is quite complicated and
>>>>> already exists.  I think you should teach bpftool to be secure when
>>>>> installed setuid root or with fscaps enabled and put your policy in
>>>>> bpftool.  If you want to harden this a little bit, it would seem
>>>>> entirely reasonable to add a new CAP_BPF_ADMIN and change some, but
>>>>> not all, of the capable() checks to check CAP_BPF_ADMIN instead of th=
e
>>>>> capabilities that they currently check.
>>>>=20
>>>> If finer grained controls are wanted, it does seem like the /dev/bpf
>>>> path makes the most sense. open, request abilities, use fd. The open c=
an
>>>> be mediated by DAC and LSM. The request can be mediated by LSM. This
>>>> provides a way to add policy at the LSM level and at the tool level.
>>>> (i.e. For tool-level controls: leave LSM wide open, make /dev/bpf owne=
d
>>>> by "bpfadmin" and bpftool becomes setuid "bpfadmin". For fine-grained
>>>> controls, leave /dev/bpf wide open and add policy to SELinux, etc.)
>>>>=20
>>>> With only a new CAP, you don't get the fine-grained controls. (The
>>>> "request abilities" part is the key there.)
>>>=20
>>> Sure you do: the effective set.  It has somewhat bizarre defaults, but
>>> I don't think that's a real problem.  Also, this wouldn't be like
>>> CAP_DAC_READ_SEARCH -- you can't accidentally use your BPF caps.
>>>=20
>>> I think that a /dev capability-like object isn't totally nuts, but I
>>> think we should do it well, and this patch doesn't really achieve
>>> that.  But I don't think bpf wants fine-grained controls like this at
>>> all -- as I pointed upthread, a fine-grained solution really wants
>>> different treatment for the different capable() checks, and a bunch of
>>> them won't resemble capabilities or /dev/bpf at all.
>>=20
>> With 5.3-rc1 out, I am back on this. :)
>>=20
>> How about we modify the set as:
>>  1. Introduce sys_bpf_with_cap() that takes fd of /dev/bpf.
>=20
> I'm fine with this in principle, but:
>=20
>>  2. Better handling of capable() calls through bpf code. I guess the
>>     biggest problem here is is_priv in verifier.c:bpf_check().
>=20
> I think it would be good to understand exactly what /dev/bpf will
> enable one to do.  Without some care, it would just become the next
> CAP_SYS_ADMIN: if you can open it, sure, you're not root, but you can
> intercept network traffic, modify cgroup behavior, and do plenty of
> other things, any of which can probably be used to completely take
> over the system.

Well, yes. sys_bpf() is pretty powerful.=20

The goal of /dev/bpf is to enable special users to call sys_bpf(). In=20
the meanwhile, such users should not take down the whole system easily
by accident, e.g., with rm -rf /.

It is similar to CAP_BPF_ADMIN, without really adding the CAP_. =20

I think adding new CAP_ requires much more effort.=20

>=20
> It would also be nice to understand why you can't do what you need to
> do entirely in user code using setuid or fscaps.

It is not very easy to achieve the same control: only certain users can
run certain tools (bpftool, etc.).=20

The closest approach I can find is:
  1. use libcap (pam_cap) to give CAP_SETUID to certain users;
  2. add setuid(0) to bpftool.

The difference between this approach and /dev/bpf is that certain users
would be able to run other tools that call setuid(). Though I am not=20
sure how many tools call setuid(), and how risky they are.=20

>=20
> Finally, at risk of rehashing some old arguments, I'll point out that
> the bpf() syscall is an unusual design to begin with.  As an example,
> consider bpf_prog_attach().  Outside of bpf(), if I want to change the
> behavior of a cgroup, I would write to a file in
> /sys/kernel/cgroup/unified/whatever/, and normal DAC and MAC rules
> apply.  With bpf(), however, I just call bpf() to attach a program to
> the cgroup.  bpf() says "oh, you are capable(CAP_NET_ADMIN) -- go for
> it!".  Unless I missed something major, and I just re-read the code,
> there is no check that the caller has write or LSM permission to
> anything at all in cgroupfs, and the existing API would make it very
> awkward to impose any kind of DAC rules here.
>=20
> So I think it might actually be time to repay some techincal debt and
> come up with a real fix.  As a less intrusive approach, you could see
> about requiring ownership of the cgroup directory instead of
> CAP_NET_ADMIN.  As a more intrusive but perhaps better approach, you
> could invert the logic to to make it work like everything outside of
> cgroup: add pseudo-files like bpf.inet_ingress to the cgroup
> directories, and require a writable fd to *that* to a new improved
> attach API.  If a user could do:
>=20
> int fd =3D open("/sys/fs/cgroup/.../bpf.inet_attach", O_RDWR);  /* usual
> DAC and MAC policy applies */
> int bpf_fd =3D setup the bpf stuff;  /* no privilege required, unless
> the program is huge or needs is_priv */
> bpf(BPF_IMPROVED_ATTACH, target =3D fd, program =3D bpf_fd);
>=20
> there would be no capabilities or global privilege at all required for
> this.  It would just work with cgroup delegation, containers, etc.
>=20
> I think you could even pull off this type of API change with only
> libbpf changes.  In particular, there's this code:
>=20
> int bpf_prog_attach(int prog_fd, int target_fd, enum bpf_attach_type type=
,
>                    unsigned int flags)
> {
>        union bpf_attr attr;
>=20
>        memset(&attr, 0, sizeof(attr));
>        attr.target_fd     =3D target_fd;
>        attr.attach_bpf_fd =3D prog_fd;
>        attr.attach_type   =3D type;
>        attr.attach_flags  =3D flags;
>=20
>        return sys_bpf(BPF_PROG_ATTACH, &attr, sizeof(attr));
> }
>=20
> This would instead do something like:
>=20
> int specific_target_fd =3D openat(target_fd, bpf_type_to_target[type], O_=
RDWR);
> attr.target_fd =3D specific_target_fd;
> ...
>=20
> return sys_bpf(BPF_PROG_IMPROVED_ATTACH, &attr, sizeof(attr));
>=20
> Would this solve your problem without needing /dev/bpf at all?

This gives fine grain access control. I think it solves the problem.=20
But it also requires a lot of rework to sys_bpf(). And it may also=20
break backward/forward compatibility?

Personally, I think it is an overkill for the original motivation:=20
call sys_bpf() with special user instead of root.=20

Alexei, Daniel: what do you think about this?=20

Thanks,
Song=
