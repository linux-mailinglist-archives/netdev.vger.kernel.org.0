Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AA620BD00
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 01:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgFZXGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 19:06:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22798 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbgFZXGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 19:06:00 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QN5bnZ022279;
        Fri, 26 Jun 2020 16:05:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/3hzjLg5Kurgu7Jc+9ZO/5MV9USwR+zQTWcFYjhlfF8=;
 b=hL2moIuuxMhJf7smYR9tQnP9yuuGxamLGoybiNPyNTH4iLzE2ovyJH1JmepCI8VVx7tu
 xOWkKFct4UihMtTCXuVh7QbF/3KDXyNyRyO4SOxNBBFviCU5vr+/MAE2sZHv+EguypgG
 J2wzDuo+FvLn/qB5UlgpyjR3oZbbDD3XqTU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux0w7xnv-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 26 Jun 2020 16:05:39 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 16:05:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fW6HxJlrMA6WqfvbspYNQKKpv8NWj65mym0uSjCG50O/QYbxDG1S445c1hxHqBEo8n0oLzep6NaczWDf9b6JJ9ko9c7KKGJ19YSzyd3ABwHnP+dVLsZJpeHMiGus0FWtgrrWsnyjT/mYPHATxbBX4SGl+Rz4LVwexNEEdRWBJ8qlcvlcczCVD3kQcyzakwQBN4kK6yBQUI8VldZ3PgWw3ds0oPhgoE0q3qK/3YlammhwGLLTGVuOYYXZwIHk6FsY/WE8OEZrOwUkL8KvpF03MpgdYXFYvJ1Y1BcA09UFoi5OsnM8K1iPQKfK7kplGWtHzvvXJf3oJdhw9C/IKZL5xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/3hzjLg5Kurgu7Jc+9ZO/5MV9USwR+zQTWcFYjhlfF8=;
 b=I1ZP0Su2v5mfehjzwW5oh+5vPynf/NRQaLf3qm8OGpqh6IPL54l/t6syMciGvWU4LkBqmGR8vM20tSq2/oNWYaz7uFm8J47JLTpFrmM1ZE1e9G9kNdLy82bpWn1lW1XYQLlPc6+Arz/8qaISpM0pIh1he3fyFMkzbEEPa7Y3FXrw/8ib4fp4DmprqGxkiWSzE1CN8Do4y4L+CoHGpKJtyy6P/PtgX5rV68x/L/pU4ajV8z6xNpFpQyKuOk4uJx5Nv4goJ32n14ZnIw9rVylQ4+TQJzo8GUgZmtS2EzL/3kBYozXcJ83L5Cv9jiuL3+NK1DY6wKVjiLCFbz7ojtPX6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/3hzjLg5Kurgu7Jc+9ZO/5MV9USwR+zQTWcFYjhlfF8=;
 b=eVWIgDtjsBLpEo3cPv1OYagtoFZ9oWRi/w+XtXKYoEdQ7+LfdGtonMmqsCx5EYITeg1EuwsxL55I3JmPTmFwpzBFIMflj9Xqz8bPMEuxLR6phAfNjCUhRzkRFS1MRzQC9FMr3bhcTk9v/jdnSRNow+KwWqAjsLruge9AF9qIG0k=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2997.namprd15.prod.outlook.com (2603:10b6:a03:b0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Fri, 26 Jun
 2020 23:05:28 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3109.027; Fri, 26 Jun 2020
 23:05:28 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        "KP Singh" <kpsingh@chromium.org>
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: add bpf_iter test with
 bpf_get_task_stack()
Thread-Topic: [PATCH v2 bpf-next 4/4] selftests/bpf: add bpf_iter test with
 bpf_get_task_stack()
Thread-Index: AQHWS068Ev45veeFRE2swU/r54D7aKjrWAOAgAAt4IA=
Date:   Fri, 26 Jun 2020 23:05:28 +0000
Message-ID: <6B6E4195-BC5C-4A13-80A6-9493469D6A2E@fb.com>
References: <20200626001332.1554603-1-songliubraving@fb.com>
 <20200626001332.1554603-5-songliubraving@fb.com>
 <CAEf4Bzb6H3a48S3L4WZtPTMSLZpAe4C5_2aFwJAnNDVLVWDTQA@mail.gmail.com>
In-Reply-To: <CAEf4Bzb6H3a48S3L4WZtPTMSLZpAe4C5_2aFwJAnNDVLVWDTQA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:1a00]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1e73b0e-25ef-4085-248b-08d81a256b37
x-ms-traffictypediagnostic: BYAPR15MB2997:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2997C26EE392C95D62B96759B3930@BYAPR15MB2997.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2tFbjQLUoWvYxHmh85+D0GHsRodYUFJxpM6YsxzgGlg3VOMujUuvt75EjhvaclMDwGzDBhUGPCO3X/mz1SjJP/lzs6ifY4Y/uiIEkkL31EivS0fSDI3FAQ0vsqRDTMWR287PhXILPuULXRSF/iF9Gst9mouEj5WI3b6vTTI9HN1C+ouvQFk/SRBioqi6LI/23ljXKLnuwWajED2jE3jcK8/Oh0LmwWZyVwf1rkzmepiyP40Mtrt/MplJpyVYeMK1+xgfrtEBfuOVob0Woa3GXefxYipxiioKddGbuUYEB9Ma49vl5xPV1tl1RDEXk0n1+7zTF+q4B+BoQeonmZeX2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(39860400002)(396003)(346002)(376002)(2616005)(6916009)(316002)(4326008)(36756003)(478600001)(2906002)(66476007)(86362001)(66946007)(8936002)(8676002)(66556008)(66446008)(76116006)(71200400001)(6512007)(64756008)(186003)(6486002)(33656002)(53546011)(54906003)(6506007)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: /FyIYGVpbhjKCcXkhYdcbn/ZACGYoozeNa3DJcjAFmNZBERL5kNmyi1w8cLzxusASNjGbJP9A74L9qxticSE3W39vHwZwYWgxU42VeyN3FsV7ntmbL1YUGFjZ3qnRbDDhCWcFxHureFBL1pNz5qU24usvKg6GVfOewvFX8b0hbETXdmY3MsNTCbra0tT4aLXhNDzU7l3vFmlggTxuEV1TwHGDK2LXsP+Nr0zC0NbTgdqWhVfL52vJkyHR/VFgpgE/SLk8o5LQLwExTjEtOidehQlC8BdPRbUzIUzafJFWDEmTcxoy7UFwXs81JpF9LVsGsmMlcJ8Dyo0tFNnFS6EeQeL0RwkLi6LdOSZM/P5D6FGvRgrT7cfC1xd3e+rsk4pMsm0vKP7H+6o67CgsqdnSa3awGdcHkWOxhtGlbtJeyrWDIWCFBvjqXaM25e0UnOs2LJ5i1Ce/uiJf/ydUAEC0mc/KT5hI+XRxzZJvWb5XQVLo6kiqjXPEZ/ERcm04c3aeej5tiGE2ERxbufrb5u+ig==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1C533891E1B9714B839F70F55F6928E0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e1e73b0e-25ef-4085-248b-08d81a256b37
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 23:05:28.6484
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +onM4SA0Agw2z+MgvGRUH7bmiuiCSYLU1qweTEyGTnJR+EcvTRvozkwVCV/yEcBqQ1Vy1MLuyO4sNcWp6AJybA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2997
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_12:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 cotscore=-2147483648 mlxscore=0 suspectscore=0 adultscore=0
 phishscore=0 clxscore=1015 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006260163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 26, 2020, at 1:21 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Thu, Jun 25, 2020 at 5:15 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> The new test is similar to other bpf_iter tests.
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> .../selftests/bpf/prog_tests/bpf_iter.c       | 17 ++++++
>> .../selftests/bpf/progs/bpf_iter_task_stack.c | 60 +++++++++++++++++++
>> 2 files changed, 77 insertions(+)
>> create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_stack=
.c
>>=20
>> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/t=
esting/selftests/bpf/prog_tests/bpf_iter.c
>> index 87c29dde1cf96..baa83328f810d 100644
>> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>> @@ -5,6 +5,7 @@
>> #include "bpf_iter_netlink.skel.h"
>> #include "bpf_iter_bpf_map.skel.h"
>> #include "bpf_iter_task.skel.h"
>> +#include "bpf_iter_task_stack.skel.h"
>> #include "bpf_iter_task_file.skel.h"
>> #include "bpf_iter_test_kern1.skel.h"
>> #include "bpf_iter_test_kern2.skel.h"
>> @@ -106,6 +107,20 @@ static void test_task(void)
>>        bpf_iter_task__destroy(skel);
>> }
>>=20
>> +static void test_task_stack(void)
>> +{
>> +       struct bpf_iter_task_stack *skel;
>> +
>> +       skel =3D bpf_iter_task_stack__open_and_load();
>> +       if (CHECK(!skel, "bpf_iter_task_stack__open_and_load",
>> +                 "skeleton open_and_load failed\n"))
>> +               return;
>> +
>> +       do_dummy_read(skel->progs.dump_task_stack);
>> +
>> +       bpf_iter_task_stack__destroy(skel);
>> +}
>> +
>> static void test_task_file(void)
>> {
>>        struct bpf_iter_task_file *skel;
>> @@ -392,6 +407,8 @@ void test_bpf_iter(void)
>>                test_bpf_map();
>>        if (test__start_subtest("task"))
>>                test_task();
>> +       if (test__start_subtest("task_stack"))
>> +               test_task_stack();
>>        if (test__start_subtest("task_file"))
>>                test_task_file();
>>        if (test__start_subtest("anon"))
>> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c b/t=
ools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
>> new file mode 100644
>> index 0000000000000..83aca5b1a7965
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
>> @@ -0,0 +1,60 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2020 Facebook */
>> +/* "undefine" structs in vmlinux.h, because we "override" them below */
>> +#define bpf_iter_meta bpf_iter_meta___not_used
>> +#define bpf_iter__task bpf_iter__task___not_used
>> +#include "vmlinux.h"
>> +#undef bpf_iter_meta
>> +#undef bpf_iter__task
>> +#include <bpf/bpf_helpers.h>
>> +#include <bpf/bpf_tracing.h>
>> +
>> +char _license[] SEC("license") =3D "GPL";
>> +
>> +/* bpf_get_task_stack needs a stackmap to work */
>=20
> no it doesn't anymore :) please drop

We still need stack_map_alloc() to call get_callchain_buffers() in this
case. Without an active stack map, get_callchain_buffers() may fail.=20

Thanks,
Song=
