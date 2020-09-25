Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C99F2791F1
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbgIYUTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:19:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57890 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727419AbgIYURu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 16:17:50 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08PJnJ76011143;
        Fri, 25 Sep 2020 12:49:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=+ayJmmwWmbAGVeMoMcZ+j15rp6oygJjURbNlCkzxRBI=;
 b=YDs2vhCisMmTecOFhjeW84kVjKKMw3cbQUlzGYBdnyO2SpSPQ3TIYhBe7cNvmRZpK+5s
 /jIJM8Af+zcISB3U7ZGGrlRekhntTpMZ/UcsOKQFBdamYVlgO0a75O6oNwzdSqe4LR2i
 zIvsBDSL8wMZ0SzvVGG3ZmmpgEzmQ0weFyw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33s8su40ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 25 Sep 2020 12:49:54 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 25 Sep 2020 12:49:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eD0I8ahJg10puzhBYa/kjbBuBRVfCz7pZ8yerELCUHj2kkzcTFC+6z7e1EPwBJKT/hV0FxeQfXi1vFZgToAsxn1PXgWGOWdQ4/qpcdj2KJXggIV8aSWifZTN/nhcAT1I0RfHEOFtG+jsI2WoiYbRUzPAT+LCHDuwqLVesFskMim34S5Txii8CAL45SZ+7eKBrzTfLgky6V6oWDuOwFDsL7PQHAz+UGHsDjnFBbGaNcY2gPj9nj4pDq6eetnfmsuKxMxkTseR1D1/0G0nL00wT9aRbXhuIbmkpfFP2ngf3EhuzPnwGKjudFW1B3Wl8NGa4LHCH+vC/TY50hfkD4pSeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ayJmmwWmbAGVeMoMcZ+j15rp6oygJjURbNlCkzxRBI=;
 b=kdqbL8RYcVbSNCn7GIvoIot9wNvbvOXc/SEau1hCE6GH75aEqeAUQ36fdOJ5YSmOW/+TlzTcWWaV8ccJUIYnXofNdFpIvyaq51mKtlCupf2AHq+YmC9EYWkvYjvfbO8A6F8mCUwmmv1dPpC2IXyTIoAmggHpjH2ewmdeiEv2Id/VXvGO5F8ZF94RUlILrALyE3rjKfJpfW3M8vfqZ57E//9+cN2nZUjRsI3a0yARLkhyPJ4K2oKWSD0t+HZSCtu9popGIPGt7gyZ6pFNQlQesHcujqLSgMpG0b1WZ3EZ+zAGLMAaf25IoDu7jBTeWzuDAMeuwYycyV22TrI+B30hyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ayJmmwWmbAGVeMoMcZ+j15rp6oygJjURbNlCkzxRBI=;
 b=fppbxbLsJ6SD9iBCHB9/wAeaB0s0qT0GR5gut3yYsdjX1SOScTOsqo6pGMXJ2z/hPvI9jjIKIktEBucysJV2ao4FuduF57YPoGW6cItkQzOkinzPiLyoZF8mDEomlJIB+BJZlzEWL8XV1SYYe/YVTzm6ZZe/u6j3ntU5fmJ4jKE=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2952.namprd15.prod.outlook.com (2603:10b6:a03:f9::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Fri, 25 Sep
 2020 19:49:52 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 19:49:52 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH v5 bpf-next 3/3] selftests/bpf: add raw_tp_test_run
Thread-Topic: [PATCH v5 bpf-next 3/3] selftests/bpf: add raw_tp_test_run
Thread-Index: AQHWksbKGhOXDee81UOLFQzQJhghE6l5ndmAgAAmqYA=
Date:   Fri, 25 Sep 2020 19:49:52 +0000
Message-ID: <F1899B9F-ED7A-4556-A370-67A66AAEB83C@fb.com>
References: <20200924230209.2561658-1-songliubraving@fb.com>
 <20200924230209.2561658-4-songliubraving@fb.com>
 <CAEf4BzaD9=+paLnFnnCzyyFsrknyBZPfAZiF=9t6s56RL6Dhsg@mail.gmail.com>
In-Reply-To: <CAEf4BzaD9=+paLnFnnCzyyFsrknyBZPfAZiF=9t6s56RL6Dhsg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a1abc38-40ca-485c-0339-08d8618c2b7f
x-ms-traffictypediagnostic: BYAPR15MB2952:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2952A610AE2C7A6435E89661B3360@BYAPR15MB2952.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9mFkLaXRC5nCipk9bNy4POP3pRmWjLKwLWsqUN9U/KK6/aBcVmKB61tkfOvAqoKgb1s+eX7tTdIjqy83KMqEPiPiivURpJ8oCRTKa5JUiYJqAG9e2FZC5W1ZXCWJu6vYMzW79LoHw92/RetgApxndSk39KCez3BQRgdv1MXsZ2QdqCZhA5U35vsdPFruqCW3x9Xuk7mSvFcK0y6/Pvm0INxkAvopvRDB9faYM+vgvYoRssF6NpHIWXfGu6KulFeH+ORSRnv5b9ivdGV6bNKKapklQqq/uyTCFnSaQ4bTYyc98byigtTTB8T/shkdjqjWiIVWyupNZm6MXmGdWsE+K4FKEtPdFwX3Fg/eMXHhzUuidewc1crV/OtHLIztmJWj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(376002)(346002)(396003)(54906003)(8936002)(2906002)(71200400001)(186003)(316002)(36756003)(6512007)(33656002)(66446008)(2616005)(86362001)(83380400001)(4326008)(76116006)(91956017)(53546011)(6506007)(66476007)(66946007)(6916009)(478600001)(5660300002)(64756008)(6486002)(8676002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: RLFmsxwmeMM2IEwZzVc8NJWdglb0X254URIWwSyC+hpgJ/jcbM9jQ7N4RN5caObA9vkXntMP/wwS4GDj3dZch5NiwVZDwHXS+ci6ZTqgUvHjvEzv7rfkpzxDVR1JC49pL6JTc/u3EkcrnPn+96ZJEgCTYTWcMNOI7UU9/cZU5BhP+VjMt6s2+SNbWoFi+G5divqvTM6OqVU01XJ928p2ZZ/3dvPr65BTpaZsXnkTEb3+210Or595H7SAepM5GBytin/gYpSjBYnZ4fSuVgfGlhK/0wwPN373n0IlXP1C4up4NygliNFZ+rEsKOQ+sWR4xGSUGp867nLR5Fd8i7WBfKZMD5j5p4WiMQWqSxBkTY+BTHI77Aa7terJeslUHwIYLqwA07gHp52YCyXz5HXiKRJzzLqbpChpuJy9EYc4T1YxC98lmFnNJsjWVy0hKF9VTPIWvmDIm9suXMKDpqFzgh34skwhksw07Rjhw0qKrBF33G5CioumRT5YtUDLrfUL30JfGlwDq3pxVJVw++a4MkGqRzrjwEu6IOLh819wOuFAOuHzbE8NRqTTdsdI1vG8V0yfJWyxKLZfZM8Ol/jS9jMzGcuU27rW0lFQJ95QT18kSXaewsaqP4i70vKhhj5fCnBHsHLNZBmegcl0gfAOHoEn2xkJiuuuH9wYm472/Om+X2LLQhDCwoaLzBE/k53T
Content-Type: text/plain; charset="us-ascii"
Content-ID: <507089399741FE4AAF2465ED1A8F3ED0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a1abc38-40ca-485c-0339-08d8618c2b7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2020 19:49:52.4136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LvdrOOj5XjRrP1kOAAnSkydrn7b/HBpN4yX4+lwnSv7DC6iwss6NMQ2Nsrh1YT5TQfw0hEXXJKpNVuiroP+JrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2952
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_17:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250139
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 25, 2020, at 10:31 AM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Thu, Sep 24, 2020 at 4:03 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> This test runs test_run for raw_tracepoint program. The test covers ctx
>> input, retval output, and running on correct cpu.
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>=20
> Few suggestions below, but overall looks good to me:
>=20
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>=20
>> .../bpf/prog_tests/raw_tp_test_run.c          | 98 +++++++++++++++++++
>> .../bpf/progs/test_raw_tp_test_run.c          | 24 +++++
>> 2 files changed, 122 insertions(+)
>> create mode 100644 tools/testing/selftests/bpf/prog_tests/raw_tp_test_ru=
n.c
>> create mode 100644 tools/testing/selftests/bpf/progs/test_raw_tp_test_ru=
n.c
>>=20
>=20
> [...]
>=20
>> +
>> +       err =3D bpf_prog_test_run_xattr(&test_attr);
>> +       CHECK(err =3D=3D 0, "test_run", "should fail for too small ctx\n=
");
>> +
>> +       test_attr.ctx_size_in =3D sizeof(args);
>> +       err =3D bpf_prog_test_run_xattr(&test_attr);
>> +       CHECK(err < 0, "test_run", "err %d\n", errno);
>> +       CHECK(test_attr.retval !=3D expected_retval, "check_retval",
>> +             "expect 0x%x, got 0x%x\n", expected_retval, test_attr.retv=
al);
>> +
>> +       for (i =3D 0; i < nr_online; i++) {
>> +               if (online[i]) {
>=20
> if (!online[i])
>    continue;
>=20
> That will reduce nestedness by one level
>=20
>> +                       DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
>> +                               .ctx_in =3D args,
>> +                               .ctx_size_in =3D sizeof(args),
>> +                               .flags =3D BPF_F_TEST_RUN_ON_CPU,
>> +                               .retval =3D 0,
>> +                               .cpu =3D i,
>> +                       );
>=20
> this declares variable, so should be at the top of the lexical scope
>=20
>=20
>> +
>> +                       err =3D bpf_prog_test_run_opts(prog_fd, &opts);
>> +                       CHECK(err < 0, "test_run_opts", "err %d\n", errn=
o);
>> +                       CHECK(skel->data->on_cpu !=3D i, "check_on_cpu",
>> +                             "expect %d got %d\n", i, skel->data->on_cp=
u);
>> +                       CHECK(opts.retval !=3D expected_retval,
>> +                             "check_retval", "expect 0x%x, got 0x%x\n",
>> +                             expected_retval, opts.retval);
>> +
>> +                       if (i =3D=3D 0) {
>=20
> I agree that this looks a bit obscure. You can still re-use
> DECLARE_LIBBPF_OPTS, just move it outside the loop. And then you can
> just modify it in place to adjust to a particular case. And in log
> output, we'll see 30+ similar success messages for the else branch,
> which is indeed unnecessary.

OK.. 2:1, I will change this in v6.=20

Thanks,
Song

