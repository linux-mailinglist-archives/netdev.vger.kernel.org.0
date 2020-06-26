Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234B220BD34
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 01:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgFZXlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 19:41:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51412 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726256AbgFZXlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 19:41:24 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QNcV2o012484;
        Fri, 26 Jun 2020 16:41:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/yn+BhZyUNqGtzhaIQNMO1TiqbiYrcHuSKclqUZt7+Q=;
 b=aahHjv9PP5a9+Gk0MbvDNPx1hPqw33zLpONS1nWt7XNS2vt9Pg/j9V9Y5XuFwVq96Uhi
 0Wb7mXdf0q+BdtvATuz/q5r1+ImNWSdE9iqdZzCa1GVupg5VqAC4HVnr9WLoR/IZZIGR
 ujBwjJtkPMQFqQbj8+DdMwRcn2c8apc+818= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31vdptkvty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 26 Jun 2020 16:41:03 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 16:41:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYl0+gi04PlHxNZPhHK1AF1v1A9lE6kz8Ikj9SeUzCt68EYElHI4cPm2P+Pg9xBmlU5LAER2Fqg4/ih8cm41sv9EOxALrB0y1uMnH2yHfJa1OX+T3dELLT2zNcL6GZkxfThDFWVIDifZ44pk9CMe/N35W37MsGyaareHOnVaa/pkCuKWyokZKh9pZGOdTGdLvkIDxPwzOK9uKe1Vm2bj81GBM50Uwhwtzy+75Kj8LXMTqYynTpn9N/xWN4TlFPmszAc0wuwmBiJ2xb/9KYA03RDhCWTmTQnoc9QElsYWKY8hw6mzwxU6hRiC8En9uaiJDnukfGPIJWO8IrxkU/V2KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/yn+BhZyUNqGtzhaIQNMO1TiqbiYrcHuSKclqUZt7+Q=;
 b=DAKs8e2TpHCx+1g34uE/vWEXHDMrAaZxIhhDF+/w1kdcxI4FloF7xlBrd6y/63j7FROXAM8V4fbZPmlFbR/f2554jPeJ6zzUNRcGWWmtMF48eK/7+YNqliIvcnNmDjQTyniiFKa2SIPvbmbG6YigETxUuuNXOyw0zkych2Nt8KZuSv33daoHo+bUnohB4ZV6rtPYeyCxZOBEOgyrvO575L1Is33Yb6axn8VzAMqzA2PEQfyCRrTlvK0I8WZnA0qZ4mlOK/6FsG/TDpl6JbpDx0dMdRmFFYWsH1Z9WWxyaJ3+MisOXsnKQn6oXnxaWxn1tJDhew370jKQ5R5mto1jMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/yn+BhZyUNqGtzhaIQNMO1TiqbiYrcHuSKclqUZt7+Q=;
 b=QS+KnWZs163PIseQc51lFNmsmj4XyIEsdIajNeZIDCpnHLopyfY5oAItdEzGpU9ZTshZc0kNVfAsd+7K4F8oTrEG02+Apd0YFsoeo3RMLXXGObdAVZrLlHOErTSdWeqYzaWYtJsc1jnivQljppPqymNJJuNZ3IbLnADKzpFQhNk=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2824.namprd15.prod.outlook.com (2603:10b6:a03:158::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Fri, 26 Jun
 2020 23:40:58 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3109.027; Fri, 26 Jun 2020
 23:40:58 +0000
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
Thread-Index: AQHWS068Ev45veeFRE2swU/r54D7aKjrWAOAgAAt4ICAAAHfgIAACBwA
Date:   Fri, 26 Jun 2020 23:40:58 +0000
Message-ID: <CFBFBF50-FC9C-42C8-A65A-500681B64E8D@fb.com>
References: <20200626001332.1554603-1-songliubraving@fb.com>
 <20200626001332.1554603-5-songliubraving@fb.com>
 <CAEf4Bzb6H3a48S3L4WZtPTMSLZpAe4C5_2aFwJAnNDVLVWDTQA@mail.gmail.com>
 <6B6E4195-BC5C-4A13-80A6-9493469D6A2E@fb.com>
 <CAEf4Bzb543EVJF+nU0X+1JNMaTehgiwx_0V=80W-frBYku0odA@mail.gmail.com>
In-Reply-To: <CAEf4Bzb543EVJF+nU0X+1JNMaTehgiwx_0V=80W-frBYku0odA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:1a00]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9406ecae-9fe8-495a-9232-08d81a2a60b6
x-ms-traffictypediagnostic: BYAPR15MB2824:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2824E04CAAEE56C515E4BA13B3930@BYAPR15MB2824.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rVepzACTAs9C+M2u8t78bJkFqK2mb/06s5inZmG10o+dZZI2XoAu++jSSq/xVRQjHH+B9RNGoUpsB+oz596OPlEhhjkLjJlXntLUGPmb5iATRyUvox39Xj3uljInsXsDUecD091Z9njuDUzz/hPMoNpxvA9VE9XgJVfKav6Vzx5bY8ugdoGO0Wtj53ucqBYAt3Xwekq0xiTUZoWAROSr8HtJTpvL8BY1YXVQZJnZ8U5u8UFuU8EsD5aIa3m7feEGeqHkw2iXNLqqIOfDIyOcCEJX1uX/AxRwLrXyPqR+AUnmLBNEljbddNy3zyH1H51Vw2OBhDHjWczbSmFC700rQg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(136003)(346002)(376002)(366004)(86362001)(71200400001)(186003)(8936002)(6916009)(33656002)(64756008)(66556008)(66476007)(6486002)(66446008)(5660300002)(8676002)(76116006)(66946007)(478600001)(6506007)(6512007)(54906003)(316002)(53546011)(4326008)(36756003)(2616005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: sqToPiesKddLzETzCaG0YQv7AChC7WaimbIOWIENUNLuKHt38Jvhcm+9XgyijagpNBeFE54cE+4FdOqXw81St+9Bs3t0p/9vPV2jkG87P8/GC1yebN5NZtSD1Na1I/ezpldzndlrEjlHVj6ZWw/Tnt61ZWA7Ebascfeja8Pq1dn02TUpRlEG5k75Eq9VUJY9dPjO5eUuzcr6Peh9+tnqvPaVhEjZAwkZ+g37H23ieMDopyv0WXdn3ysCGxgkD1MV0Q65Zre5ZZOqiIgHZlo0n/PgaEDsKW3AEGMiVyryM4DXZyKXU7/TiilIWqbj6rJCWaDMW7Hoi9TeH7rFYu9piDfw/v6AmDDyXKfsV8UhVWQ/WfZGHwwUvl+fm53CEcjrLzdvrN5OfqHgspEe9LTIlqiLtqZn7UfQbf1lQwOhPKjhYGJyjxVbjFBDhpseNaDaGlw3oFB3l0VWn1kQ9CTOIauIySSjBBJzVQxEq/CMglXmZWbdDXQrF5SwroHXAwPLXQtJkBGbo9vyDVobZSA3KA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <343157150F3E874B846B6CDD218E9EA9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9406ecae-9fe8-495a-9232-08d81a2a60b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 23:40:58.4932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fpHcjcATU7jAAxh2xm20gUYOEcIxlM2JQS9h9hrAjjstosTFPZm/fpN1tOVCIbe1pk4vuiDMjaP5/+dhnbwt7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2824
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_12:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 cotscore=-2147483648 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006260167
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 26, 2020, at 4:11 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Fri, Jun 26, 2020 at 4:05 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Jun 26, 2020, at 1:21 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com=
> wrote:
>>>=20
>>> On Thu, Jun 25, 2020 at 5:15 PM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>> The new test is similar to other bpf_iter tests.
>>>>=20
>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>> ---
>>>> .../selftests/bpf/prog_tests/bpf_iter.c       | 17 ++++++
>>>> .../selftests/bpf/progs/bpf_iter_task_stack.c | 60 +++++++++++++++++++
>>>> 2 files changed, 77 insertions(+)
>>>> create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_sta=
ck.c
>>>>=20
>>>> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools=
/testing/selftests/bpf/prog_tests/bpf_iter.c
>>>> index 87c29dde1cf96..baa83328f810d 100644
>>>> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>>>> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>>>> @@ -5,6 +5,7 @@
>>>> #include "bpf_iter_netlink.skel.h"
>>>> #include "bpf_iter_bpf_map.skel.h"
>>>> #include "bpf_iter_task.skel.h"
>>>> +#include "bpf_iter_task_stack.skel.h"
>>>> #include "bpf_iter_task_file.skel.h"
>>>> #include "bpf_iter_test_kern1.skel.h"
>>>> #include "bpf_iter_test_kern2.skel.h"
>>>> @@ -106,6 +107,20 @@ static void test_task(void)
>>>>       bpf_iter_task__destroy(skel);
>>>> }
>>>>=20
>>>> +static void test_task_stack(void)
>>>> +{
>>>> +       struct bpf_iter_task_stack *skel;
>>>> +
>>>> +       skel =3D bpf_iter_task_stack__open_and_load();
>>>> +       if (CHECK(!skel, "bpf_iter_task_stack__open_and_load",
>>>> +                 "skeleton open_and_load failed\n"))
>>>> +               return;
>>>> +
>>>> +       do_dummy_read(skel->progs.dump_task_stack);
>>>> +
>>>> +       bpf_iter_task_stack__destroy(skel);
>>>> +}
>>>> +
>>>> static void test_task_file(void)
>>>> {
>>>>       struct bpf_iter_task_file *skel;
>>>> @@ -392,6 +407,8 @@ void test_bpf_iter(void)
>>>>               test_bpf_map();
>>>>       if (test__start_subtest("task"))
>>>>               test_task();
>>>> +       if (test__start_subtest("task_stack"))
>>>> +               test_task_stack();
>>>>       if (test__start_subtest("task_file"))
>>>>               test_task_file();
>>>>       if (test__start_subtest("anon"))
>>>> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c b=
/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
>>>> new file mode 100644
>>>> index 0000000000000..83aca5b1a7965
>>>> --- /dev/null
>>>> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
>>>> @@ -0,0 +1,60 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +/* Copyright (c) 2020 Facebook */
>>>> +/* "undefine" structs in vmlinux.h, because we "override" them below =
*/
>>>> +#define bpf_iter_meta bpf_iter_meta___not_used
>>>> +#define bpf_iter__task bpf_iter__task___not_used
>>>> +#include "vmlinux.h"
>>>> +#undef bpf_iter_meta
>>>> +#undef bpf_iter__task
>>>> +#include <bpf/bpf_helpers.h>
>>>> +#include <bpf/bpf_tracing.h>
>>>> +
>>>> +char _license[] SEC("license") =3D "GPL";
>>>> +
>>>> +/* bpf_get_task_stack needs a stackmap to work */
>>>=20
>>> no it doesn't anymore :) please drop
>>=20
>> We still need stack_map_alloc() to call get_callchain_buffers() in this
>> case. Without an active stack map, get_callchain_buffers() may fail.
>=20
> Oh... um... is it possible to do it some other way? It's extremely
> confusing dependency. Does bpf_get_stack() also require stackmap?
>=20

Aha, I thought bpf_get_stack() also requires stackmap, but it doesn't.=20
The fix is in check_helper_call(). Let me do the same for bpf_get_task_stac=
k().=20

Thanks,
Song

