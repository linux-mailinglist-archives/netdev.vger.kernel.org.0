Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A276D1BEF9A
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 07:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgD3FMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 01:12:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42002 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726040AbgD3FMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 01:12:53 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03U5B6WY011302;
        Wed, 29 Apr 2020 22:12:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=wqWE/pOQXbDFqJLn4KqXKXj69eSMjsgV7MjQdgvFfhA=;
 b=TXqr/qGwTUMAkKuN9EPjOb06KgAqz2yAoQC8ZwoK07njuBHZQJ+JiQhXWntc3CR+zjam
 NCy/1p4WTy4JodyKr18fp1y9W68qlQPqeOqqSgmAdfn4Gp1r/6iYljlx5stMUNua+w89
 efWWMncKPnGL3Ny8Tqka9n78b1RghEq3M6Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30pq0dm9kg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Apr 2020 22:12:40 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 29 Apr 2020 22:12:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dxg1QAGXNFGA2jtYYsOpFGkyxn0r4IFr2OTkdz1Uak1dyHB8VLkUoyVNJPP7tikYj1wrlSSxnEPJev1OPupwdmUV7allCXjGUfdQWkO90g0+4sPX/r1qoykQVvGo+OeFnSrAtfQzhIc8elz5GDzNzSHrozfCKxr/3Qch5fX4sGh5qc/gIZWGZw04oiOJL8HAbkFoqLSYye5QVtKWUTTyMi0Hp5Hrdc+f21B3Nfu1pcVXVwH4C8x0SmS/XfvPg5jQ3hQVu1k6rQ0WmcP2YYwnB796pFFYxXCnFnqo6PIQXq6v/wBIQLv4sVVRr7DEmZss5mFgoBqIn4EJGVnpcrDy8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wqWE/pOQXbDFqJLn4KqXKXj69eSMjsgV7MjQdgvFfhA=;
 b=Qgr5dCja/VhxRUFU9OsKUrCltlBW9lbUZU351JpMBpuydeuJX3kNz0aY+6x+yhZswpxL5CIXmt+39hiRd48Ht9hh75ggmwmYNMTOuPPbwAvygNCxOd3D6j2gch6mPWFE25o2oPHCA3uspJbniEvYhjbYoBD71+2xTpLK5gzg86f9Mc+FhK2wJt0YT50nQKecp+GH2SoC8uiAG9wdPFlZPzsx45uQLv3vzeWht0RJH3WcCbIexjtqn/b8a9H7lbw+xAqlD/KPhX4SWoVm1D1NcaQRYDWeT2POOzh/Fw/G/NMSim3nd0R2+9nlpuiBNnffdmEzqz+abYWbYyuoJQW7MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wqWE/pOQXbDFqJLn4KqXKXj69eSMjsgV7MjQdgvFfhA=;
 b=dPmx0DdrbBzTkN4AVWCsfVqYN/D2m0wCmJ1GRFo2wckVFYKltIx6Kx50Mlfzv2NG9uInNTszA6XoMBtWCxMTWsWabJ8hA9J1n+9W6g08hKKxiMFY+7UJmrEVD5veU0YFWEXL822YUIo3/ZjXjDjbfM2sSbxSRuj+2jJW0EDT9q4=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2760.namprd15.prod.outlook.com (2603:10b6:a03:159::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 05:12:23 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2%7]) with mapi id 15.20.2958.020; Thu, 30 Apr 2020
 05:12:23 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Kernel Team" <Kernel-team@fb.com>
Subject: Re: [PATCH v8 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
Thread-Topic: [PATCH v8 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
Thread-Index: AQHWHfHXX0bY47IdGEmyZ33wIke0UqiQ8LMAgAAvRAA=
Date:   Thu, 30 Apr 2020 05:12:23 +0000
Message-ID: <C9DC5EF9-0DEE-4952-B7CA-64153C8D8850@fb.com>
References: <20200429064543.634465-1-songliubraving@fb.com>
 <20200429064543.634465-4-songliubraving@fb.com>
 <CAEf4BzZNbBhfS0Hxmn6Fu5+-SzxObS0w9KhMSrLz23inWVSuYQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZNbBhfS0Hxmn6Fu5+-SzxObS0w9KhMSrLz23inWVSuYQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:67b7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d7fb40b-7144-4a48-6cfe-08d7ecc51110
x-ms-traffictypediagnostic: BYAPR15MB2760:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2760EF57EFEE489162D7E0A4B3AA0@BYAPR15MB2760.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0389EDA07F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZZjYOgPr5+LPHkPJwDkkvEmJvcgXvtspVdC8cH/kbw+amloNP8vDwjaqCdXUx9debalUSb8Qah18B292HMoXHSTLQg4CtISsoqaoZrGjUUVFTN0Qh/Mu7E0dVgIAMPf9xL4zWrlT5yPeL2DBvfLtysZs9ODUINX892uRrZ89iDSxzKWI7EiHPo7tHLeibmfA/xsR3EoOycnXRlp+udXBTLdE9rDndai2P26h1ty1xjUkTZxJG5WFo2kwbOkhe2MsZaxnFwnNMwlNDtqcZOAErCB7VfCgWh8694wMnfWrYpGF9HpeMfX4LmBzFK0smYbUvCjydPZot1TyMjV7CBWTMYIbwUQuL5i0YBArTDG5co+XwuwjwkPe/x+HZaqlqv86owQGfswECrqf3KDZFqJj7QYG2W5p5n0TEVds2c5r2yjo91NJl8hd2cr6RRK1scXF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(91956017)(6486002)(86362001)(498600001)(6506007)(6916009)(53546011)(71200400001)(36756003)(54906003)(5660300002)(186003)(8676002)(2906002)(2616005)(4326008)(8936002)(66476007)(64756008)(66446008)(33656002)(66556008)(6512007)(66946007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Zydu65OcEUQnd3sHUSjiaQQNaNSGVgBa0no1TPvmC8eZ3Jkct2uyZz4xIV0bLZVGTfkSsU50H0In2G63qq3AjrgcioC+y4JV/jJQZXcAwQt6+Je4BbqRj/KckeidYeshbO0xNr1DgTrT9WJvPzDCFsDmHNnAL/hQrF3yVEam//eO+TvaBlgA2bt88n1UJgqOSIQ28Ibaks3B4QwouWmTZRhqgCEjT6yH3mmli/FX8Jrazff2ESFCxOBQWhx4ndNaHxV73oQz3bBYwzXmQvgqLJGwed4o/g7R7urQHZXBlnkwPpRRYQ9g8DNUzCel9XXMnzNBS/NwEEqVaMbHarMN60MTatp1OSTXZH9wJ8hVsWN8YCETsxK3j43dKOtLBPRD193RoA9iEuJFyhrkKgBBu296P86RZV5CVrznzZjn5/e9tcgyYQaT0nBdo5qXW77CiFwecaIVKekphs9XtmECqFY14lCGsm425OC/MZeJGopqNgpoukmTx07mFlcyicH0Zf4KnkLTq9U1z6gFGGONueYlF9m2gQodkPFivmMRFpczpA0UhnowhAfnT38/SQ8k8vpycVgJCVWs5wNnHywTsffsqPi35GsDp9rJSaKNi8yrKNYzwVH6bRLFB7CF+4OU94i1k2vQizYmYq8sRoz7/HAmHOISj3VnxcpFJxcjWj1nt+uFEzC0dXfsXsLeByhfXue9OPypJ4ZbfUw69Ph9fwSDyzAKLdd+E7kmzhD+8RNToG5qpDhpMvlvBjLRPuU2q/zd+nPK0Eth/DTpvfMt9qkQNr9rmK8XTPmFxJSmNt9JKd+5qzta0kCqWQkP0zKB208EloAXDkeBa1TLR3N3GQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7426C1B201AA4C48BF2455204D75D5ED@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d7fb40b-7144-4a48-6cfe-08d7ecc51110
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2020 05:12:23.3816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vtw8DLJS1T2ZVO5spzruItN2GUCoCJKCd2PnokjaPnSPh3G/qee7G/mcfQRXS/53HvK8pT2chr8JMzJFmumpQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2760
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_01:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 lowpriorityscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004300041
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 29, 2020, at 7:23 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Tue, Apr 28, 2020 at 11:47 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> Add test for BPF_ENABLE_STATS, which should enable run_time_ns stats.
>>=20
>> ~/selftests/bpf# ./test_progs -t enable_stats  -v
>> test_enable_stats:PASS:skel_open_and_load 0 nsec
>> test_enable_stats:PASS:get_stats_fd 0 nsec
>> test_enable_stats:PASS:attach_raw_tp 0 nsec
>> test_enable_stats:PASS:get_prog_info 0 nsec
>> test_enable_stats:PASS:check_stats_enabled 0 nsec
>> test_enable_stats:PASS:check_run_cnt_valid 0 nsec
>> Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> .../selftests/bpf/prog_tests/enable_stats.c   | 46 +++++++++++++++++++
>> .../selftests/bpf/progs/test_enable_stats.c   | 18 ++++++++
>> 2 files changed, 64 insertions(+)
>> create mode 100644 tools/testing/selftests/bpf/prog_tests/enable_stats.c
>> create mode 100644 tools/testing/selftests/bpf/progs/test_enable_stats.c
>>=20
>> diff --git a/tools/testing/selftests/bpf/prog_tests/enable_stats.c b/too=
ls/testing/selftests/bpf/prog_tests/enable_stats.c
>> new file mode 100644
>> index 000000000000..cb5e34dcfd42
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/prog_tests/enable_stats.c
>> @@ -0,0 +1,46 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +#include <test_progs.h>
>> +#include <sys/mman.h>
>=20
> is this header used for anything?

Not really, will remove it.=20

>=20
>> +#include "test_enable_stats.skel.h"
>> +
>> +void test_enable_stats(void)
>> +{
>=20
> [...]
>=20
>> +
>> +char _license[] SEC("license") =3D "GPL";
>> +
>> +static __u64 count;
>=20
> this is actually very unreliable, because compiler might decide to
> just remove this variable. It should be either `static volatile`, or
> better use zero-initialized global variable:
>=20
> __u64 count =3D 0;

Why would compile remove it? Is it because "static" or "no initialized?
Would "__u64 count;" work?

For "__u64 count =3D 0;", checkpatch.pl generates an error:

ERROR: do not initialise globals to 0
#92: FILE: tools/testing/selftests/bpf/progs/test_enable_stats.c:11:
+__u64 count =3D 0;

Thanks,
Song=
