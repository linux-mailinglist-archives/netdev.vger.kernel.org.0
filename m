Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B2F239E53
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 06:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgHCEeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 00:34:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54476 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725908AbgHCEeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 00:34:05 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0734TG0Y021108;
        Sun, 2 Aug 2020 21:33:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=fwhUiqkBJ4oMm0olwB05c2BHVwzAPFJBwekUDL+0BYA=;
 b=XtgN32HIkzSy1ZRwvAR1i45u/Wx8NXmUPKm0zvX+rRDvVPpKvKNpeHS3U7kGKI34YPSX
 FsS8wjjhQB4RFlWhWdRpGcltf+vnWpfzaraSZiYG+PgwNdDm4/HT/2Xxng/jq8JFQThp
 z5lOxMGoKuN6sYGunc9gfO5KKWK7nMuh/bY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32nrcs2ry6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 02 Aug 2020 21:33:47 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 2 Aug 2020 21:33:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqpVogZGEHmEh/9inCccso/jdWRA/zx4dGOx+GWqgSCjqvp5le1C2XFkW/F7RkB83Cp0wwkjIRygcWg5OdAHUWJjCi7PpGClG0Gkst8sOs93QAYnSwtAQVLQnqgYmGysO14ah3GOJKTH0HE7ZnFHVH1OXjNy2k6rrwj9yfrk7ILCZ/2WnBhDJbpKKQqIA7DDSD42VKfCQcIPSi/ckMKT4VTSYU8fBdSExVqmyI+ltiHzqm0gjNCSTAurCMsKpPlaFheYVQyY6CKOQ8hSXyBL9kDVtfv9YHEWUpUFnDoMvH9O+eOkvvtefT3iAAq/W5wR1rTdAF1CXrB/uydLcyrnSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fwhUiqkBJ4oMm0olwB05c2BHVwzAPFJBwekUDL+0BYA=;
 b=JfFTRDoPE3xZ748v0kR4i9/Vn1o8FH7Y/zW/VR/rpZDgaNgL3+dBlKXI95nN5/wBK4XO9P507/81FWdtYYm40wXbjpJAwzWAchbqb0nfYbUJvQPdK7fEq42no4fv98xSsk4ZaN0nRHSu/Ctf+czJzaT9fhfLMuVBH2nAUEf8s4koAtFjSTlMxePKgsP2OEeXUunlrTFMMo5Vggq2dohsB9xputog9m3Cs0/JizZBBI66F66w2h+0A8AIn8txHGVix09D3xFCMyiLwCmHaClgHBsjl7mXXicxpSBZ6XRl6fGzQeWHQq40DYGSsxanqd1ij+kWFYkzNx/RFJ5qENF17A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fwhUiqkBJ4oMm0olwB05c2BHVwzAPFJBwekUDL+0BYA=;
 b=dC4VKzvc27NZ28fnK1VlwQZwOFL18HhYmS8sjygNOsHDHugRAD0DNQGheWMv1cR+IHUGRJK69i0oCs6K0x+TX8Nrogo0BZ1bhw0pK7pYS9PVtpDE/t3UwAqD7Ea0CcLRPayUH6bZQo7WALF49fxzUMtjjhIHz02LfJEI+kisqqg=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3095.namprd15.prod.outlook.com (2603:10b6:a03:fe::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Mon, 3 Aug
 2020 04:33:45 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 04:33:45 +0000
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
Subject: Re: [PATCH bpf-next 3/5] selftests/bpf: add selftest for
 BPF_PROG_TYPE_USER
Thread-Topic: [PATCH bpf-next 3/5] selftests/bpf: add selftest for
 BPF_PROG_TYPE_USER
Thread-Index: AQHWZ+C38TtsngeYdEmidjk+2G1vlqkln1aAgAAvdIA=
Date:   Mon, 3 Aug 2020 04:33:45 +0000
Message-ID: <C5606E9B-D3EC-4425-82F5-DA5865836D3E@fb.com>
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-4-songliubraving@fb.com>
 <CAEf4BzazkFMw3LAs3M2hxSLWWZJ7ywykwte=0WDhC1zgMYw-3A@mail.gmail.com>
In-Reply-To: <CAEf4BzazkFMw3LAs3M2hxSLWWZJ7ywykwte=0WDhC1zgMYw-3A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:8f7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dbbd6077-bb0a-4794-28b3-08d8376668c8
x-ms-traffictypediagnostic: BYAPR15MB3095:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB30950E4F4FA646E745BDD6DCB34D0@BYAPR15MB3095.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1RQudHAoHuPOn7E8MTBEBHmwhBNNmFLd2LK5PUTVQN8+Syl53toIv+0xT8loAzkysPyW72O5EFlT1RkE7uuU1nG0z7oX14dm8QW2oJFRpnFxMD/MGCPVzj98HS9XRjHAtKaAGHonbGftqaPEoPsua9c2nM1Lhs2oq5VKqmSfY4BoULf+5vKUnkjOVnF5W1BEn7n2i9wjnR2+6Dszj8rjoxbRF4cQnQlQva91LmCvlYVew1F47Zhij1Xa7bL+a1M9bhYhasVi9fB3wHndWxR6cds3bkPNpegz5i4pJ9iCVzUsutz8b7+MXTHAKeuEomhBu28UC2WeTJuFR0y3ewbO+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39860400002)(346002)(366004)(376002)(396003)(6506007)(2906002)(53546011)(86362001)(36756003)(6486002)(6916009)(64756008)(8936002)(54906003)(66476007)(66946007)(66446008)(4326008)(76116006)(71200400001)(5660300002)(2616005)(83380400001)(6512007)(33656002)(8676002)(316002)(478600001)(186003)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: NDvMIdtL9HLUFjxWSXxBKMTDzyrh0d+pyqX+GDnot7NMMQK8Fv8+tyaxk6YiXTrzUWWpVRr48ddTvUvtcBrwcKBHUju7kzVWyU58PFBjhU4IzDwsjwZUG2F8Z27MyiR7WeyJp/WmSNqEzEDW83wCK8m7bT42MfKPz4C6ugrOLw/8mSqmAJA6nAKVc/8YGTbyO09hLmkDrWMXDHqd8DoNrpsg/gSaHDSSgsgCb/wTAXh3K7RD/bQCbfvhjFq8GOD5TS2a9dJjhf6BcB9Awcy3agEFVZ8wVEdUY7CX+7uIz+UHKi61GVtWtHfha2pusU8DJvdGfOxlbxckBIdafHbtxp73XJYDISotJSPldVsOtRRMcO0pGHyjgoeqAphW0p6Q8yzVByQY4HtaU0ksBfL27cSXKDWs55UwS9uAnR6+eKE+U+4gJ8zRFMecQcb1SXhgIz6+siGTKSCVv5tpL3Vmpi5ECPLivJoIk9K4Ne5aliRZA5lnPmPrArBQfUoqoCF0eH65oS84+vl8zHG3Gl9QzGM5O1MFZHE2efCM0cGpNFjSy0/JmdJ9HYHZVD0WkNU/7hQR+6uwh9lwRg+tjZwLOMLgXGN7gQ9T8NRlC/HBvTanuRi+V9NOf3s9573ANBAbS+vEqVMWciTnxd0nQooHQNwW2JOd4OmF6aB7iV01WKw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14C719EDB93DB448ABFB99E92828758C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbbd6077-bb0a-4794-28b3-08d8376668c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2020 04:33:45.5665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lilT/XxfkCfXt38GLtd+3eCbTWDlQs0xtRndP8ToOynIhHvuIxrkkWCh0oTeZf5xeedvYF3TxmaD4HcE9LLWeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3095
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_01:2020-07-31,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 clxscore=1015 adultscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008030032
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 2, 2020, at 6:43 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>=20
> On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> This test checks the correctness of BPF_PROG_TYPE_USER program, includin=
g:
>> running on the right cpu, passing in correct args, returning retval, and
>> being able to call bpf_get_stack|stackid.
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> .../selftests/bpf/prog_tests/user_prog.c      | 52 +++++++++++++++++
>> tools/testing/selftests/bpf/progs/user_prog.c | 56 +++++++++++++++++++
>> 2 files changed, 108 insertions(+)
>> create mode 100644 tools/testing/selftests/bpf/prog_tests/user_prog.c
>> create mode 100644 tools/testing/selftests/bpf/progs/user_prog.c
>>=20
>> diff --git a/tools/testing/selftests/bpf/prog_tests/user_prog.c b/tools/=
testing/selftests/bpf/prog_tests/user_prog.c
>> new file mode 100644
>> index 0000000000000..416707b3bff01
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/prog_tests/user_prog.c
>> @@ -0,0 +1,52 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2020 Facebook */
>> +#include <test_progs.h>
>> +#include "user_prog.skel.h"
>> +
>> +static int duration;
>> +
>> +void test_user_prog(void)
>> +{
>> +       struct bpf_user_prog_args args =3D {{0, 1, 2, 3, 4}};
>> +       struct bpf_prog_test_run_attr attr =3D {};
>> +       struct user_prog *skel;
>> +       int i, numcpu, ret;
>> +
>> +       skel =3D user_prog__open_and_load();
>> +
>> +       if (CHECK(!skel, "user_prog__open_and_load",
>> +                 "skeleton open_and_laod failed\n"))
>> +               return;
>> +
>> +       numcpu =3D libbpf_num_possible_cpus();
>=20
> nit: possible doesn't mean online right now, so it will fail on
> offline or non-present CPUs

Just found parse_cpu_mask_file(), will use it to fix this.=20

[...]

>> +
>> +volatile int cpu_match =3D 1;
>> +volatile __u64 sum =3D 1;
>> +volatile int get_stack_success =3D 0;
>> +volatile int get_stackid_success =3D 0;
>> +volatile __u64 stacktrace[PERF_MAX_STACK_DEPTH];
>=20
> nit: no need for volatile for non-static variables
>=20
>> +
>> +SEC("user")
>> +int user_func(struct bpf_user_prog_ctx *ctx)
>=20
> If you put args in bpf_user_prog_ctx as a first field, you should be
> able to re-use the BPF_PROG macro to access those arguments in a more
> user-friendly way.

I am not sure I am following here. Do you mean something like:

struct bpf_user_prog_ctx {
        __u64 args[BPF_USER_PROG_MAX_ARGS];
        struct pt_regs *regs;
};

(swap args and regs)?=20

Thanks,
Song


