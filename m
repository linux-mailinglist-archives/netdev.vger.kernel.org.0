Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946522A3CD2
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 07:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgKCGa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 01:30:27 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50436 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725982AbgKCGa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 01:30:26 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A36QiAY030356;
        Mon, 2 Nov 2020 22:30:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=NhLSpJza1HSxkdENDTp9N5tPWs1fjw7a/1ffxWtKa5A=;
 b=eCX3FJl2quBcGxHLOU5F1Mkldh/whe4fVdHx/euh37SY7Giy1GPPkK243nVDIhbB1mSf
 SitRPiehRvjHR0szjMulUuIY7A3qPFLxCs01YvbB8tsWrb4fShUswaSnhMyBmj38svAA
 CFsKzW9xMaT2qwwLO1gMmj9QeLa2vSOUKJM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34hqdu9mkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Nov 2020 22:30:12 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 22:30:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dttYnkXXQ5NteoRK+GdZXxXO9wD3ntQ1iW4glvnpXRYNQnhtwJJ+PghEVGIibOU+q/rZXgjGYDtSMbsKgEvmFvD1V1JxXC82zpgNNY0+bAusYyE7ZctEZaaFoFndBdtx86EDxsscgG76P4/C9IK+coHYKy7pfNHjq1a5W3HP2GOZtOZP/vy46XFyVmiMGlE544nds/J/PCLqiIbjU2JpiTUpH9o/WJ6eTWk84SiAhw0ilHFsXv1xHbuc87ViJ+VSVNjiqjmyG6bq1wobLumFnGj7M057MDAl2Snmhrs1rI4gImpVqrvreVPoMZ4XtI2ijfi4pWk4dMxkkxhcMngRWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NhLSpJza1HSxkdENDTp9N5tPWs1fjw7a/1ffxWtKa5A=;
 b=guFkEbYo7M2aiTY3Gu8zOtHZ9beQZPkJ/b2KtbqeDUOLTnKropVcM/Wlm8+e9qYqCXbnh/a7bavgS60FmecwUsRxBYZ5MganRKQG3wLpn6JFmKD1+aZDANcBjYQvEFag8juxjxTYwYAVqiX3Pknf/1xVqD3llKE8y/f0xRD3Bs73N0e6X7qCh91q0SXoB+CFfF+oEY3OK3cgDhJ5KCYnfJLYN7I0LGGiv8KXYnQPvmaAQ1eh4hldTnwZtA4TYd4WGRbJMWnBR0h5RIA1sx0lsJjVGHycGAA5jzE8mh113Z16PMHRwjuEboJh6/4tGNW4sVCD+qYH3FikUaJFuDlLtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NhLSpJza1HSxkdENDTp9N5tPWs1fjw7a/1ffxWtKa5A=;
 b=c5CVkizJprMmUaVjGZ7mUeFE6JfMziUKQxzTkdlQf8oE3vJXnVjJgalXwqer2OF8v+4bPofaHT3qH50/4ArHUmwaO7qEaRHE7aB/OaI1mLxrcIM6nh71uwFMRAF162K/Sotvf10C4DIJqxEreOfP+rK8qRCFpDIkflxoSU2y8DM=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2695.namprd15.prod.outlook.com (2603:10b6:a03:150::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 06:30:10 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 06:30:10 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 10/11] selftests/bpf: add split BTF dedup
 selftests
Thread-Topic: [PATCH bpf-next 10/11] selftests/bpf: add split BTF dedup
 selftests
Thread-Index: AQHWrY7ZjPZZk5MObUyN0fT/zS+U16m16xaAgAAIjACAAAbNgA==
Date:   Tue, 3 Nov 2020 06:30:10 +0000
Message-ID: <657A464B-2C83-40FD-9F5C-4AA19F4311BF@fb.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
 <20201029005902.1706310-11-andrii@kernel.org>
 <23399683-99A4-4E91-9C7B-8B0E3A4083DE@fb.com>
 <CAEf4Bzbqi_PNU8ZJHBwjxDoHNieDwaviPojox_LynmQjcmaFLw@mail.gmail.com>
In-Reply-To: <CAEf4Bzbqi_PNU8ZJHBwjxDoHNieDwaviPojox_LynmQjcmaFLw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c2a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7d35d79-8f32-41e8-e96e-08d87fc1ea44
x-ms-traffictypediagnostic: BYAPR15MB2695:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB26956EA072AD980EF692F15EB3110@BYAPR15MB2695.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nFwryXLcTT/gasR3UjLDR4CVyjsGmscrz6DGEHKeEUkHqcM2LI2yHtwF48RdSm7CJXxruwOXcdS+GYNZqaHOaoZRceE20aU1RdZQPJR6hCJfEFJL5ZQ2vA9U6ZCK6AjhAnXk/Zjs7m10llILkLstd4mIibkHqotXEOrLi7O09mvNJ/trHhT2Mc/P0vX85romVUdD4nF9EYs3Qr6oCnGcRUJvY4yIgM0rdWsMALJAbmxM2TIeORz9DatzjPLxAtp2ira1yDv+lBuFGEPFpnmjO5a1HNrlk5mIUAXcqgfqrUvfAcuAJx0K+zTxG4MyW1Kj7v6k+IyivOVPU9ovC1nlCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(136003)(39860400002)(396003)(36756003)(66476007)(66556008)(8676002)(66446008)(64756008)(76116006)(66946007)(6486002)(6916009)(91956017)(186003)(2616005)(54906003)(6512007)(33656002)(316002)(8936002)(4326008)(478600001)(71200400001)(83380400001)(86362001)(2906002)(5660300002)(6506007)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: s3HKFZh/njA3qBZSZru8ew+fPx43j4fD9SetlZ2ziqeyiNtDLEqxaswggkM6OLuPbZWV93cHPBF19reN7j4zz15Im6lAJ9VGT/NS6oNBI2nBvO5q6DZcnlxI4kozBLn8N1jdVITqGdUJFEDmbzuIU4IpzjHhld65jX27Ibw81dOLPkKBbxtJ4rGXt6jT5DPq4I35+JgocQfbdII4WTuO4Qu7vOZHxWoHHZQcRSfZfJtYi5wik+v6cZ5koyFpP3KhCoN3FGa3QS10huIrPEphxSlItGOgGqG3tsI4oheh/B6B992PUyfrtdU9ln1FjAbop5yb6JS52tihvkB6YRkcHFsOqyKg+HRzz9HZSxzySLUwLOi6TnAdeLoRYRht09omIU6T90eM/zkAAkEt2oqAKa+0YxlBL3cteA/pwWKByAdbMNm+kbtnAQ5Q0lTH5bT8/GmQqBWkFy85iCaV5CPNcEMjSRkzRqxzhK36e80NoSO0mDESHQQEtzrdVJXPuIFckuRiB4cBGUH1axy7mAYZAOMoCYokcVGb5AlL5J/nCFyJ0fMI4aIH6rWPHVTA/6Z6QnMwKBaWXngjIJUOK/smmoDtmUbf6Gu4iZ6KQB6Ma29jB6aCb1A5+YpdMYYRhmZNY0Ylq+5w4ucKI91HDsXywlB6HYSG2xaJH0zlvYe54ZH7hTMXHkaMHTz1MF9rT2ki
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E7AEC40838A4E14FA3C4DAE936E264FE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d35d79-8f32-41e8-e96e-08d87fc1ea44
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 06:30:10.7326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6wlzeh2qGaky2PSSPym1QqZo/xPNCPGABxMPSHTGTrkrIH6QRDF0C0iQ2FAX8Ypoq9aP3BAWyfI6DB7RtUDBJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2695
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_05:2020-11-02,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030047
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 2, 2020, at 10:05 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Mon, Nov 2, 2020 at 9:35 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Oct 28, 2020, at 5:59 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>>>=20
>>> Add selftests validating BTF deduplication for split BTF case. Add a he=
lper
>>> macro that allows to validate entire BTF with raw BTF dump, not just
>>> type-by-type. This saves tons of code and complexity.
>>>=20
>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>=20
>> Acked-by: Song Liu <songliubraving@fb.com>
>>=20
>> with a couple nits:
>>=20
>> [...]
>>=20
>>>=20
>>> int fprintf_btf_type_raw(FILE *out, const struct btf *btf, __u32 id);
>>> const char *btf_type_raw_dump(const struct btf *btf, int type_id);
>>> +int btf_validate_raw(struct btf *btf, int nr_types, const char *exp_ty=
pes[]);
>>>=20
>>> +#define VALIDATE_RAW_BTF(btf, raw_types...)                          \
>>> +     btf_validate_raw(btf,                                           \
>>> +                      sizeof((const char *[]){raw_types})/sizeof(void =
*),\
>>> +                      (const char *[]){raw_types})
>>> +
>>> +const char *btf_type_c_dump(const struct btf *btf);
>>> #endif
>>> diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c b=
/tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c
>>> new file mode 100644
>>> index 000000000000..097370a41b60
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c
>>> @@ -0,0 +1,326 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/* Copyright (c) 2020 Facebook */
>>> +#include <test_progs.h>
>>> +#include <bpf/btf.h>
>>> +#include "btf_helpers.h"
>>> +
>>> +
>>> +static void test_split_simple() {
>>> +     const struct btf_type *t;
>>> +     struct btf *btf1, *btf2 =3D NULL;
>>> +     int str_off, err;
>>> +
>>> +     btf1 =3D btf__new_empty();
>>> +     if (!ASSERT_OK_PTR(btf1, "empty_main_btf"))
>>> +             return;
>>> +
>>> +     btf__set_pointer_size(btf1, 8); /* enforce 64-bit arch */
>>> +
>>> +     btf__add_int(btf1, "int", 4, BTF_INT_SIGNED);   /* [1] int */
>>> +     btf__add_ptr(btf1, 1);                          /* [2] ptr to int=
 */
>>> +     btf__add_struct(btf1, "s1", 4);                 /* [3] struct s1 =
{ */
>>> +     btf__add_field(btf1, "f1", 1, 0, 0);            /*      int f1; *=
/
>>> +                                                     /* } */
>>> +
>>=20
>> nit: two empty lines.
>=20
> There is a comment on one of them, so I figured it's not an empty line?

Exactly! I missed that one.=20

[...]=
