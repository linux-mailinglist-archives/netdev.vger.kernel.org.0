Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98BF2F24E8
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388188AbhALAZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:25 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44702 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390775AbhAKWuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 17:50:06 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BMiavc030543;
        Mon, 11 Jan 2021 14:49:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=T/qK2QG2c99fbFnIUvxYBuMECs5QBlxoGVwIT0Lekg4=;
 b=IO3fspIWCwAUTyH55u3xsb0r1l7d8pngioKU2FLJbps/h46I+zaoZCFG5uItk4awp4w+
 vCDbPJkFnzTcaQifGPi2STS2jZsKO/xgUveUL26Xsz9IVPb8sqZstrVPHDo32V7Fu5yI
 a/0HqWlj5mKgfEzzivgJrLTNVjCrDzNbBW0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35yavt26qc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 14:49:03 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 14:49:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nEnCvH80/X+uunhcYQiuhl7ya/tLHUJYTrJaNTe8kY4As0ElsUO09jH8ypvv8RRk4wpMso0gk4VtztDGR4fkqDwR4+1Jwyb8RFLuyGHrnojbArYZEOJCLTuKVKwFkIptwk30boZJ8K2NP4SDqxzgKzgt9VYQqs3bjZbBns9DU+E1QkmYSASVhn9h00HGbS5RbHyg6JJnfeO6ON8gFNz+9nvN8s4/94xd0FXvMP+GYhcWnWFsUR9DBMYqGlAVl6a1+5CaNj4qKtjCPYcOi1hs63Fsm0/sSF4mUUogequnTeIZDEOtj7M6dMa2RuSG8+iBDxeB3gz0y9PhqYFrnqP58A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/qK2QG2c99fbFnIUvxYBuMECs5QBlxoGVwIT0Lekg4=;
 b=PkjI85vx7MtXL/vOHKcTLPhpRiDpquTfnuOxMUmgu/XKkMESOpVEb8h6xdECLltHhRMd/5w89KZ0KtFWtKnf7U+G4JH44kLYjdw51a/+cxEMy6Ga/n/o55VVSxPa0V4vxh4wBv0exHqgBtv9rVKIaIzelk8/sJ8/otHpVVq524QAkeKARoe+/9F0SGaQDlFKAYiDr+qmGuqRmwPMvVkEPqPdhzhxwz/pxb9TF+MfcHAnhoyx4WRnAFW4pcwj/l+G1Z5vMiji4dq7sCAhxUuhGA6QX3mZVwYOMiAQqAT5wwqgKf+5hHNm/9piZ4gDuR9+yYojnsOYCx4WAUDNvG1P+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/qK2QG2c99fbFnIUvxYBuMECs5QBlxoGVwIT0Lekg4=;
 b=iK+KS5ETGceZIJMk8YMlsQ/+kE/z2nVqAmIlDqs7FN2UBz/upUvT6Ebe5su2FQ/LN+Tr2yJdgue/W1S6W003IWUIrYKTguAVxK2X5uCx0qb3JvvkQbYQODejRVBy4KXsmy70e7/ftZJpctXs7tRK+cQzqys2pCy4gepc4Axpf/g=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4204.namprd15.prod.outlook.com (2603:10b6:a03:2c8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 22:49:00 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 22:49:00 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Peter Ziljstra" <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "john fastabend" <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "Kernel Team" <Kernel-team@fb.com>,
        "haoluo@google.com" <haoluo@google.com>
Subject: Re: [PATCH bpf-next 2/4] selftests/bpf: add non-BPF_LSM test for task
 local storage
Thread-Topic: [PATCH bpf-next 2/4] selftests/bpf: add non-BPF_LSM test for
 task local storage
Thread-Index: AQHW5hZK9xMR4omnHkq1KgYEe27pC6oistUAgABY4wA=
Date:   Mon, 11 Jan 2021 22:49:00 +0000
Message-ID: <CC251082-A193-44FD-80BD-C8D0431C7798@fb.com>
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-3-songliubraving@fb.com>
 <4eac4156-9c81-ff4d-46f5-d45d9d575a16@fb.com>
In-Reply-To: <4eac4156-9c81-ff4d-46f5-d45d9d575a16@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
x-originating-ip: [2620:10d:c090:400::5:f14a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cca38802-2823-45a1-9220-08d8b6831644
x-ms-traffictypediagnostic: SJ0PR15MB4204:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR15MB42040E1982009CF8C38B2505B3AB0@SJ0PR15MB4204.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ExVl6pH2WyEB6tRG/xZA1z7CATws7hr904/JBSiueIeQ1ET7T6OAd0f+SpVViELo8mTr8OkXnmOFGujDZBpkXGPJK6gYYS4MM+LumnNIV0VmHSzUcOfPodbKGE1Dg+kKOVhZ12L+470xUeCYBq75eUlrw8doY82/3f9ECiNPSbOIJpgzE+KcCrlLyWzEo7+rZXVR4pknPjoLg59FLtIRLn+MuCJsqHt6Z9h9XeabosjvyZZChLmayP2gpGSRORL7MbIvC1x2ao6DBkDGchgSZV8ZFM50uRFtGiA+ZR7iaWk4bc+nKuA29Sy7UkQPqkcdoJ9zVHTNW9vupmUw8s5Cclipc+ekwYAtSqaUrjlz+omKwN9G/4BguMbrKi4qC1lvbZawiNbV/veZYtmbvfA9vxmX3r746GSW+7KJunFc7+DCi19fkPJ+nlgdEFlLH1or
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(346002)(376002)(396003)(136003)(6636002)(316002)(66556008)(64756008)(71200400001)(66446008)(66476007)(76116006)(86362001)(91956017)(54906003)(37006003)(2616005)(4326008)(186003)(5660300002)(66946007)(2906002)(6506007)(53546011)(6862004)(478600001)(8676002)(6486002)(7416002)(6512007)(33656002)(8936002)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?mqZUMnH65YUjE/vCBqTUzIdjLT7X5FpYcLWPXqmKtFX38UkKcP/2MMT+EL96?=
 =?us-ascii?Q?GF7jd1bvNVQfykkIXq8WG+GIZJy7Bfb1T8oKE8x5KhypaE4JNN+tkFTtjUh3?=
 =?us-ascii?Q?Iwd5fjDc9PP+7Wn7tBNrb0Rt2++bJpDYoSxBfkYa9QA6avMG1VA3gNMj3XOb?=
 =?us-ascii?Q?ImK/HR3qD6Wr3cvZzg45HN94DlV0fnshATS59E8hNexWHGVIML0a17/Iw8Wa?=
 =?us-ascii?Q?Lp9S1U0xuqzp1D36UE8FiXLfBtSqhvWW8B87G68cQbDHFNfMTeJ0f7Y5YKFK?=
 =?us-ascii?Q?66SZ1LBeVdG7IhP0CCXa3Pgu5TST0drqKA4bnsRe2RR5NBkom2TmdO4+UDm1?=
 =?us-ascii?Q?GpU9T+9640ovVw4HcViAz2RVCTAP/WQ1o1KLa2bbhVBKfKofyGidYc6RCfJD?=
 =?us-ascii?Q?3kHWa+RK8aIXfBJ0uHP4omebb4hkuEiYaCc3BUf7l4g4+wFVRf+DvzyVN/VZ?=
 =?us-ascii?Q?hp6O7RLreVputzTu72DbM+gk0uTUBwI/n37JxzUNpSc2AhA8BIBURUy8p777?=
 =?us-ascii?Q?7qNolVRidQNaIsHU/Aw4K8ZLx63Gny2EBRaEvo5/sSN7Eh4wxRz6POWrWLEM?=
 =?us-ascii?Q?26bbmqdPWgLaTHwX4LYWtAscF+5XpPt/IMfgi1NKv84XIaEUZMR09BH/d49o?=
 =?us-ascii?Q?cIiDTQ9kpesHLEj5T+j3V9A1ezMRxiFx4KOi48Hr4a9mb0t5jan8W9RubLM6?=
 =?us-ascii?Q?2Gz075cPHVgRPyCFWQz51XsIXrG3A5lJzkb/1BNVGy8Lgrw3QsLo0ySyq4Z/?=
 =?us-ascii?Q?8xwJ3viI1DUA7jQ/PzLD/YeODxOz7d6wJY4L+VCm3oVmWnmG73tblM8G5lUT?=
 =?us-ascii?Q?nNHdInOlLV+OzAnMk6o78/pJCFGMz+yFdDTWL1ZdMrYWA/APJ9NIrkrTe/UT?=
 =?us-ascii?Q?/WUba5F62bRmFdAS1uk8DX92DtH/Wrc/1lp7CxfKJzmpp1GUAITQMQNQUR+w?=
 =?us-ascii?Q?6M3eWBWjN20AaaIrEkJ7quxbePF1JZCYTukSF9SK3vL0m5pSKst7F33vlbor?=
 =?us-ascii?Q?Jknu7+9wdaAqysY1tasu4FU1YG2/ukJU8Cw6Ca0edIDtSVQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <826D5EC85D7A4745855F1CDB542BBDF5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cca38802-2823-45a1-9220-08d8b6831644
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 22:49:00.2769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8kMbWi3CtgWQG3zmZ6sa3Tfjc/jwkxF42PSEsBt9wewVz9vYI8xmyPL/N9IZSBv6i8L5l6FeTbakihQB7Uec0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4204
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_34:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110128
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 11, 2021, at 9:30 AM, Yonghong Song <yhs@fb.com> wrote:
>=20
>=20
>=20
> On 1/8/21 3:19 PM, Song Liu wrote:
>> Task local storage is enabled for tracing programs. Add a test for it
>> without CONFIG_BPF_LSM.
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>>  .../bpf/prog_tests/test_task_local_storage.c  | 34 +++++++++++++++++
>>  .../selftests/bpf/progs/task_local_storage.c  | 37 +++++++++++++++++++
>>  2 files changed, 71 insertions(+)
>>  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_task_loc=
al_storage.c
>>  create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage=
.c
>> diff --git a/tools/testing/selftests/bpf/prog_tests/test_task_local_stor=
age.c b/tools/testing/selftests/bpf/prog_tests/test_task_local_storage.c
>> new file mode 100644
>> index 0000000000000..7de7a154ebbe6
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/prog_tests/test_task_local_storage.c
>> @@ -0,0 +1,34 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2020 Facebook */
>=20
> 2020 -> 2021
>=20
>> +
>> +#include <sys/types.h>
>> +#include <unistd.h>
>> +#include <test_progs.h>
>> +#include "task_local_storage.skel.h"
>> +
>> +static unsigned int duration;
>> +
>> +void test_test_task_local_storage(void)
>> +{
>> +	struct task_local_storage *skel;
>> +	const int count =3D 10;
>> +	int i, err;
>> +
>> +	skel =3D task_local_storage__open_and_load();
>> +
>=20
> Extra line is unnecessary here.
>=20
>> +	if (CHECK(!skel, "skel_open_and_load", "skeleton open and load failed\=
n"))
>> +		return;
>> +
>> +	err =3D task_local_storage__attach(skel);
>> +
>=20
> ditto.
>=20
>> +	if (CHECK(err, "skel_attach", "skeleton attach failed\n"))
>> +		goto out;
>> +
>> +	for (i =3D 0; i < count; i++)
>> +		usleep(1000);
>=20
> Does a smaller usleep value will work? If it is, recommend to have a smal=
ler value here to reduce test_progs running time.

I thought 10ms total was acceptable. But yeah, smaller value should still w=
ork.=20

>=20
>> +	CHECK(skel->bss->value < count, "task_local_storage_value",
>> +	      "task local value too small\n");
>> +
>> +out:
>> +	task_local_storage__destroy(skel);
>> +}
>> diff --git a/tools/testing/selftests/bpf/progs/task_local_storage.c b/to=
ols/testing/selftests/bpf/progs/task_local_storage.c
>> new file mode 100644
>> index 0000000000000..807255c5c162d
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/task_local_storage.c
>> @@ -0,0 +1,37 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2020 Facebook */
>=20
> 2020 -> 2021
>=20
>> +
>> +#include "vmlinux.h"
>> +#include <bpf/bpf_helpers.h>
>> +#include <bpf/bpf_tracing.h>
>> +
>> +char _license[] SEC("license") =3D "GPL";
>> +
>> +struct local_data {
>> +	__u64 val;
>> +};
>> +
>> +struct {
>> +	__uint(type, BPF_MAP_TYPE_TASK_STORAGE);
>> +	__uint(map_flags, BPF_F_NO_PREALLOC);
>> +	__type(key, int);
>> +	__type(value, struct local_data);
>> +} task_storage_map SEC(".maps");
>> +
>> +int value =3D 0;
>> +
>> +SEC("tp_btf/sched_switch")
>> +int BPF_PROG(on_switch, bool preempt, struct task_struct *prev,
>> +	     struct task_struct *next)
>> +{
>> +	struct local_data *storage;
>=20
> If it possible that we do some filtering based on test_progs pid
> so below bpf_task_storage_get is only called for test_progs process?
> This is more targeted and can avoid counter contributions from
> other unrelated processes and make test_task_local_storage.c result
> comparison more meaningful.

Make sense. Will fix in the next version.=20

>=20
>> +
>> +	storage =3D bpf_task_storage_get(&task_storage_map,
>> +				       next, 0,
>> +				       BPF_LOCAL_STORAGE_GET_F_CREATE);
>> +	if (storage) {
>> +		storage->val++;
>> +		value =3D storage->val;
>> +	}
>> +	return 0;
>> +}

