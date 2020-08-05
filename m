Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC40523C439
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 05:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgHED7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 23:59:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4418 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725904AbgHED7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 23:59:42 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0753xPkp012006;
        Tue, 4 Aug 2020 20:59:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=p/Duiods2BS/Vc6ISTdJQimTmp2nKYEznLIsIHGXDGs=;
 b=b2SyfvtX4W3k0uQGGLQBYa+OObTFoV2rIKxEi4FUHseHRvtPuifZmIsn8TU6Sq9gIaf3
 n5VQG9S2dK37D35hIk7R53GiNwyQDMx4crd9XzqX9KtBM/7xjn4Fd71LBvFr/d6JtR7i
 +3Hc9OYsw8qaQ76syULsTSAdpQDA6wPoyfY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 32n81yg6xk-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 04 Aug 2020 20:59:26 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 4 Aug 2020 20:59:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Varg3wynbhuqe9jVe5Q24jNv2X86hPD19GQmCko06HFKFANP1Cft5JjQqAg3JiVExRcR+ijPEHnYaQCE+LZFLMek/uchLWjT3f0/ynBbDCrSIfBYl2qYenCg/eGI5vYoM83ri0g+6qp8j0zwbO96wjgiWPKFFwf9Kr3uyTZVyqO2IpSxK4k1Rskyb6erIKVKqn1nIAzF23UIuA66dBHZERvGY8XPF/szyNfQMV0sPyRVTvpkeJHDXU92cWZUXHZ4SE5JWgXmeZPfk8Q0CuaRHTHNDJ5oNmQzX3g8+ks9bVI6OBzfj2/QT/EVg4mb1JHdYGihDV8gwascLln/+ZvzgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/Duiods2BS/Vc6ISTdJQimTmp2nKYEznLIsIHGXDGs=;
 b=QHrj3ZVu1ado4hhrULR0M6Z7hhxDU+7Impm/K7BEMZ18JGywWsvTzMQggD3QCyBt+aO0wWRzeyZkVrwDk+2TVd9ZGWmfzMHEPxNt5n0+GeYg3Yj7Ep8PwkpnOZH1ywD/vmc3+BMbxn4xUFPlbX4lTdqw0cgQzyD+5sLFYzVG9dblDQYoZFg55y4886ofRVrXjmMOk0ogEIPdGcJcCQGe4rdUiFuMtIqYwxY+Xah/BdgIg2eDk3trnLqiPKBDDh1e6AM7YIH6ImcxvKwfepDjGeJSFZgkd5jV3h8gGR/egf/gO22XNVh6fjuugffk7K0Py6d07YkEMYzUIMziw8UfSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/Duiods2BS/Vc6ISTdJQimTmp2nKYEznLIsIHGXDGs=;
 b=cd4jdlyOMpV3nLr/RVsK4mv3PkDWzoX+sNyWI5Ydcl9A7JpzHYyuN8a0zUZUDYTF5CXVqnMVeRjkLytQ/P0z6kUZ9E333GLwRUbr6ddaZeDcXob8YBizIeE8nFWZaJfK24LqUjHBzRvUXwtso3juVx9aVcpJoQwLl87W9gCvnNg=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3304.namprd15.prod.outlook.com (2603:10b6:a03:10a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Wed, 5 Aug
 2020 03:59:13 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3239.022; Wed, 5 Aug 2020
 03:59:13 +0000
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
Thread-Index: AQHWZ+C4tQwFkmvi20aNhPcONSrEz6klnl6AgAGMFwCAAZgFAIAAJ1IA
Date:   Wed, 5 Aug 2020 03:59:13 +0000
Message-ID: <5BC1D7AD-32C1-4CDC-BA99-F4DABE61EEA3@fb.com>
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-3-songliubraving@fb.com>
 <CAEf4BzYp4gO1P+OrY7hGyQjdia3BuSu4DX2_z=UF6RfGNa+gkQ@mail.gmail.com>
 <9C1285C1-ECD6-46BD-BA95-3E9E81C00EF0@fb.com>
 <CAEf4BzYojfFiMn6VeUkxUsdSTdFK0A4MzKQxhCCp_OowkseznQ@mail.gmail.com>
In-Reply-To: <CAEf4BzYojfFiMn6VeUkxUsdSTdFK0A4MzKQxhCCp_OowkseznQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:8f7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 364af8d9-ee68-4070-9d2e-08d838f3ea71
x-ms-traffictypediagnostic: BYAPR15MB3304:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3304882C9EC34BE545E765E1B34B0@BYAPR15MB3304.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WhMNdsMz7xpz+LH6/lmG79zTy4uW2Oixbef/C0ppWCBVroNCLFyLFDwONaJbnE0dbeLclXuNHodt56qHsg2tszGW/4m44uYF4MNeIBP0Fk7JC/ZcMeLtGun8KwFPCWZ98/mWlwTZREpkqEARb9iyC0o17MQtGodqVhAZOV9w4TNqI4dkCUCyi8tPYzWncL/C4kyMz2YZcT4hMZl5M/KV5I2ppTKbJjNvKLRlqEaOdGwffwx+4p75HcqScvjPDKroZLBakMcRQLCKShnAIlAtTI2GQvxldb9ezstQAyh+5Q4M0ukpYn2Kr8/lhjrtk92n+nVJMzZhEI5i3MS+zd5VotjUuJbZXiVvD0oR/pDblYonMfieCvVnTB0oDIg+oZSO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(366004)(396003)(136003)(39860400002)(316002)(4326008)(186003)(2616005)(54906003)(8676002)(36756003)(86362001)(8936002)(6486002)(83380400001)(6512007)(478600001)(71200400001)(66556008)(33656002)(6916009)(64756008)(2906002)(66476007)(66446008)(76116006)(5660300002)(53546011)(6506007)(66946007)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 32kRozHzKHvYaltuBJoS7O4TbL6InB3Maz8QHzLx1IyYs4mKxuGu6py0mW5dRtj2jUMZCmuhb4xLtnlTnPg6BWkmYgI6hyNppvbuuvvyWbZS8kNaTJIaKuSthRDb81sKH5iPN+p1WkfdHVKcIzU8cC0FZBo31cZPSlShs4HhCtESIbhLrvTCwIAvLY9fAZXUjiVnv8dUndsUiohDyT6ojU1dRDolJoEkmcsbAEcWjG6rYkGgutElMj8eGk6SrN2HYNDBTHQfG1dZ/NTczA7lTbiUbml5M5Bf8MxY9NHMBA6anLoFQhN5y+pr9fijc0zDekRZDHJSoZatApLg/Svrq2+duKwP427Q2C9WEHjyum0IkxGAHKBjLZEu8zAZ5Bdx4Zt5dv4Q8GRr4pvQjfQPZmEr+aGg+oUMW4lwIH4TPM0w5L3wRTvoxOTjyo4EY+Faf7mFXGYk5pxe9OaYTYCBXzAlP/lAd9V6yEMYX+qjEk8BG004Bun3RFvzRzfgtt6UCrLYEEbHp0IKcKwDPxOfRjwZFH9nMykSLR2oaMwoJev/PrYCPOki0yO1GdFXYnrS3aJqBiEoJUgVYGvID0oLhqMNULtnoXgPVGyvSm3zIrC4XNK3fflWgVXL5lIDG54PXcjJ9BeSMeYAF+TXcwaCd9DVrpo6K6Jgj1j120owYOM=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <807257139EBEDF4199E1EB2BD2128796@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 364af8d9-ee68-4070-9d2e-08d838f3ea71
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2020 03:59:13.4108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iSUCFO2Mwd1tGr30BctY4CGlhacpNIu8izloVbatHErLI71NcivvSkOmDYs00R/V2uHGWMthUpl1lhLedf+S8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3304
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-05_03:2020-08-03,2020-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0 suspectscore=0
 impostorscore=0 adultscore=0 clxscore=1015 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008050035
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 4, 2020, at 6:38 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>=20
> On Mon, Aug 3, 2020 at 6:18 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Aug 2, 2020, at 6:40 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>>>=20
>>> On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>=20
>> [...]
>>=20
>>>=20
>>>> };
>>>>=20
>>>> LIBBPF_API int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *=
test_attr);
>>>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>>>> index b9f11f854985b..9ce175a486214 100644
>>>> --- a/tools/lib/bpf/libbpf.c
>>>> +++ b/tools/lib/bpf/libbpf.c
>>>> @@ -6922,6 +6922,7 @@ static const struct bpf_sec_def section_defs[] =
=3D {
>>>>       BPF_PROG_SEC("lwt_out",                 BPF_PROG_TYPE_LWT_OUT),
>>>>       BPF_PROG_SEC("lwt_xmit",                BPF_PROG_TYPE_LWT_XMIT),
>>>>       BPF_PROG_SEC("lwt_seg6local",           BPF_PROG_TYPE_LWT_SEG6LO=
CAL),
>>>> +       BPF_PROG_SEC("user",                    BPF_PROG_TYPE_USER),
>>>=20
>>> let's do "user/" for consistency with most other prog types (and nice
>>> separation between prog type and custom user name)
>>=20
>> About "user" vs. "user/", I still think "user" is better.
>>=20
>> Unlike kprobe and tracepoint, user prog doesn't use the part after "/".
>> This is similar to "perf_event" for BPF_PROG_TYPE_PERF_EVENT, "xdl" for
>> BPF_PROG_TYPE_XDP, etc. If we specify "user" here, "user/" and "user/xxx=
"
>> would also work. However, if we specify "user/" here, programs that used
>> "user" by accident will fail to load, with a message like:
>>=20
>>        libbpf: failed to load program 'user'
>>=20
>> which is confusing.
>=20
> xdp, perf_event and a bunch of others don't enforce it, that's true,
> they are a bit of a legacy,

I don't see w/o "/" is a legacy thing. BPF_PROG_TYPE_STRUCT_OPS just uses
"struct_ops".=20

> unfortunately. But all the recent ones do,
> and we explicitly did that for xdp_dev/xdp_cpu, for instance.
> Specifying just "user" in the spec would allow something nonsensical
> like "userargh", for instance, due to this being treated as a prefix.
> There is no harm to require users to do "user/my_prog", though.

I don't see why allowing "userargh" is a problem. Failing "user" is=20
more confusing. We can probably improve that by a hint like:

    libbpf: failed to load program 'user', do you mean "user/"?

But it is pretty silly. "user/something_never_used" also looks weird.

> Alternatively, we could introduce a new convention in the spec,
> something like "user?", which would accept either "user" or
> "user/something", but not "user/" nor "userblah". We can try that as
> well.

Again, I don't really understand why allowing "userblah" is a problem.=20
We already have "xdp", "xdp_devmap/", and "xdp_cpumap/", they all work=20
fine so far.=20

Thanks,
Song=
