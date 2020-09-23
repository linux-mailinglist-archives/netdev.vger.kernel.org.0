Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E789F276321
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 23:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgIWVam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 17:30:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12326 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbgIWVal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 17:30:41 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NLTD4v020835;
        Wed, 23 Sep 2020 14:30:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=qk9ospJpchRpAwGRf/Xgh7TwcXJb3IgMN3kzur1oVB0=;
 b=hhN9/8Ova6oMEr7wQA36WoGixl6IVwnFmFjbVKBeR6mmuZgXuQ41ikmOX2aDbZUA0Zor
 Y323OBu2jxAXH6+bJiAH1IwTuid7Ify3JkMjfHo4INfkSaPuUvuFiSfv7X6Wl7ka5sSx
 TAVE+6o0oLBqgHRQvR7NGrV115vcETfS4Qw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp4x371-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Sep 2020 14:30:27 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 14:30:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOpNwS7/TcCx+aRDOXuC4Go51J7OfhMC87yfEAfF89Uc46LhjvtjyeApw8Eu63DuRred4Sd3zIDdkCOzHPULUj3KZCHWjZCoYdK19VSZ3XPPCBPKNDykN2LnjsuXEtyquuNIVszHNNeoWd+JXYiJvtXZyIY3/yx6jAoRCOAAWz4vDYnAX6PfWdl3yNQwEphna3hjRhAo1Y5LNPMnicVpzAH50K7zks1ISSLloXYfLPVTgLOoKeT3d7Z3cYfQar/xCYtCjHp3gDRfkwngsJ7Jtzxwv0ITVJnpAOhlwM1D65BndZPP5YGFoFm0e5BCpgpBPZwOnNjnHJ3XmD1lbtuw4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qk9ospJpchRpAwGRf/Xgh7TwcXJb3IgMN3kzur1oVB0=;
 b=d1Ix32xBWDu/SKVHtNFBWIwbudt6nVw+hvMz7gK1jxUudz1jsEw9ZT/Lk9XCKuf7eCOdzfVacjuv5GLb0BrT7J6E/zDnh3r6o4uXE/7S7l1hdQ5BYpnCTD5Qkm23mqJOG8fUixFKKQkJ8c+Bw1acx3Bpw1tVCnIGbRvyguKWjaFQnwWeSxwqO8OHkJNgExJHnZ8XfIQCN62li93+JP4JiuU0u1DAZTh97c02owQrhtkUKLUOh4u5bynFLfZ8tjEGA2bHcJ3duBAsiboh0bKRzRdrUlGsNkkC56v7WwckBAZ50CcRibGqPt3vxwm2S6+KbwgYjn8/i3d1GhcNU+6WOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qk9ospJpchRpAwGRf/Xgh7TwcXJb3IgMN3kzur1oVB0=;
 b=cFmTrBdQwVih4FD5wG9Ksgn0QfeiWKLBXsfa81S6xq226f08mwGNwJ08r6EmAoR3byh38piMV+TeGDSLorE5iXgNtVF5JW2ys43dYko9siPjzDWUQPN6XYSAhh/mRHi3WFrSX+xT+ZwJwOIYrNydN6iFpKq8V5kXxZi3YHl+2OA=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2328.namprd15.prod.outlook.com (2603:10b6:a02:8b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Wed, 23 Sep
 2020 21:30:21 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 21:30:21 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH v2 bpf-next 3/3] selftests/bpf: add raw_tp_test_run
Thread-Topic: [PATCH v2 bpf-next 3/3] selftests/bpf: add raw_tp_test_run
Thread-Index: AQHWkco4SYH69gJDR0SArqOBG2jagal2n06AgAAelwA=
Date:   Wed, 23 Sep 2020 21:30:21 +0000
Message-ID: <F220CD52-C103-4E90-9B5B-504500984747@fb.com>
References: <20200923165401.2284447-1-songliubraving@fb.com>
 <20200923165401.2284447-4-songliubraving@fb.com>
 <CAEf4Bzb2KdA3m6-hfH96HxwCvPeOyNQ59LRm0rW8OWs+7zyMHQ@mail.gmail.com>
In-Reply-To: <CAEf4Bzb2KdA3m6-hfH96HxwCvPeOyNQ59LRm0rW8OWs+7zyMHQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac6fcc5d-0dda-48a2-9378-08d86007e04a
x-ms-traffictypediagnostic: BYAPR15MB2328:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2328965611F7EF38BA8C3C91B3380@BYAPR15MB2328.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hvU7OzKWgxPIO8QJ3kMphqQ7usotGKRe6C1OaJSu+p0zhPwelSVceV32Gg6lrZAIwGY32joI7UwuIPjbNp0dVCH1n4gnC+ppO+lWaqze9FjvEY4n+UmD7Hv5gblIrr+QwYxH6w7K+Qk8mGauqoG3Hxe8pIpgyer46OKFgT37xFjKijPrWO/OH7qc4nhitVkdkhDv3EZjcAFwJ2rKheMIqpqckMj18fTQ8xFcbDy8QUDdzWf5NiqvG21Nx1ZKcopEi7fg1nWOOWoG8hyRVg/QA899aoedbk7rlx3InRG9a7rFjwfk07QHTY1szEqzweZg2FT1E/WKWB8OZQ+7z7z8JKUTvvxe0X2VHXciCq+7exer0RnnlYF6DpToQlG7Fd+R
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(8936002)(71200400001)(66446008)(6916009)(66476007)(54906003)(36756003)(66556008)(64756008)(8676002)(6486002)(498600001)(83380400001)(186003)(5660300002)(6512007)(66946007)(2906002)(86362001)(4326008)(91956017)(6506007)(53546011)(76116006)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: uUmQatjZPosZqjzSA0GSTD36y3Km5KDxSVXpILhW1iQE9LQL7rh0kmNdQLHYsouT++KSa313NNHNO+7DGWfR1ItvGQdOB37m9kmfkc06WUZXKZM7j1I4CCZ8LIHhn/DaaOySX46QwpQE6V0a9lr2Xov0sl4pUTzqD3J9WvcQDz3GuxXq1RF08yVsQOh+CTWIbXcVRJGF+IkJCu+qbIgapI63zvZA0QI3uJx+fwzHsYQA9s0X2o9M00S66r/ZMnmk9wPlNqMJ/UZQnqtFUoN47hfmP2bm3sfN4rVJKzRmhdLdKSr7wS9K9uJAx3Sj7nP6bQ8/MRMypRoyuB5+eBNllrbf9Z8Xsmy3Lh0p5xkLRobQ0iuhsubJaDq1sTziQE5pn2prmLUpVA3uQ6czBw5lwpjzmd5zfnlwhI1XK93ynhMqxU34WKybyzt491GQfzssRMdL0Og3sI70IDfBe4FltUXf9t/+gRgpfvLvQJxxUq25RRYw44UZZb0H073qlbOH8bUabjr6XUy8xesx3AiAHvTCvajGhGib7wyFWptl2DSgR5i4DoglCOjdvoB8UD9PTyLKdNyuJt/sba0p8URBQsyh9GKCqblleOa68pMFcb6n8XordSSptvdTiP/uhpRobLjrn/r/lUVdIs24QZgCcvB8tjQh3t+p0xHU63szvRIuukvB+vKR8GfNHXJMomdK
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22582F75D0D0F44EB954BB5FC8587420@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac6fcc5d-0dda-48a2-9378-08d86007e04a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 21:30:21.5417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iuyKYkObkma/eNrkZR7f3w9+v3N2Lg3xzKOXbjDw/jKtlQZhDvHAM9taJwRS8R43+wpkeRkNFqQYbEFIJmsfMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2328
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_16:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230162
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 23, 2020, at 12:40 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Wed, Sep 23, 2020 at 9:55 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> This test runs test_run for raw_tracepoint program. The test covers ctx
>> input, retval output, and proper handling of cpu_plus field.
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> .../bpf/prog_tests/raw_tp_test_run.c          | 73 +++++++++++++++++++
>> .../bpf/progs/test_raw_tp_test_run.c          | 26 +++++++
>> 2 files changed, 99 insertions(+)
>> create mode 100644 tools/testing/selftests/bpf/prog_tests/raw_tp_test_ru=
n.c
>> create mode 100644 tools/testing/selftests/bpf/progs/test_raw_tp_test_ru=
n.c
>>=20
>> diff --git a/tools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c b/=
tools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c
>> new file mode 100644
>> index 0000000000000..3c6523b61afc1
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c
>> @@ -0,0 +1,73 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* Copyright (c) 2019 Facebook */
>> +#include <test_progs.h>
>> +#include "bpf/libbpf_internal.h"
>> +#include "test_raw_tp_test_run.skel.h"
>> +
>> +static int duration;
>> +
>> +void test_raw_tp_test_run(void)
>> +{
>> +       struct bpf_prog_test_run_attr test_attr =3D {};
>> +       __u64 args[2] =3D {0x1234ULL, 0x5678ULL};
>> +       int comm_fd =3D -1, err, nr_online, i;
>> +       int expected_retval =3D 0x1234 + 0x5678;
>> +       struct test_raw_tp_test_run *skel;
>> +       char buf[] =3D "new_name";
>> +       bool *online =3D NULL;
>> +
>> +       err =3D parse_cpu_mask_file("/sys/devices/system/cpu/online", &o=
nline,
>> +                                 &nr_online);
>> +       if (CHECK(err, "parse_cpu_mask_file", "err %d\n", err))
>> +               return;
>> +
>> +       skel =3D test_raw_tp_test_run__open_and_load();
>> +       if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
>> +               return;
>=20
> leaking memory here

Good catch! Fixing it in the next version.=20

>=20
>> +       err =3D test_raw_tp_test_run__attach(skel);
>> +       if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", er=
r))
>> +               goto cleanup;
>> +
>> +       comm_fd =3D open("/proc/self/comm", O_WRONLY|O_TRUNC);
>> +       if (CHECK(comm_fd < 0, "open /proc/self/comm", "err %d\n", errno=
))
>> +               goto cleanup;
>> +
>=20
> [...]
>=20
>> +SEC("raw_tp/task_rename")
>> +int BPF_PROG(rename, struct task_struct *task, char *comm)
>> +{
>> +
>> +       count++;
>> +       if ((unsigned long long) task =3D=3D 0x1234 &&
>> +           (unsigned long long) comm =3D=3D 0x5678) {
>=20
> you can use shorter __u64?

Sure. =
