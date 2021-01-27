Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A96F3066A6
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 22:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbhA0Vqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 16:46:40 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2772 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231511AbhA0Vod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 16:44:33 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10RLU9cZ032480;
        Wed, 27 Jan 2021 13:43:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=5NJC2xMvqMvw0DaK9sntGQZ3FtG8NQ1iEJm9x65BMbU=;
 b=i22fNkaDRIh5ARaM3+o1jIwHCnMABy5ZN9P2mIkg0Qd8r6ko3PAMSUpIiBapau0W4uzb
 SHnpAfhIkjg15s9jxnLd558Y9Hsv24ekXjKgYimcHyPUYJ1KKXEVSftO5ihbW2MIBTD7
 4JiJrPH0lZNSfOnRw7hg3CjaAhkmrNIdxv4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36awcpnhby-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 27 Jan 2021 13:43:24 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 13:43:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ra0Xy2x7wd33P/L4+nDl7qNkHTfThLjnBEfg8YlCDm99BOI11JreivZwtiKvNd32RZqw9iSlUn9HGEwpnnqn9OB6gstncc0weQ0fEJLs6JfyrqmDXXT7g3mUSL9mAqyZZsV1H85i39HrOTIT0pNWOOonWVlp+rk/nhEFViYl24GRUXL84TonnLjVCUOD5EQwy4P2rwq4G3qxylTNfp6PO81UN/MAT2hX7bc0AOmNXpb96ZplKtAXR5mVw5OC5r0NeUOhiB36Tbe/ldFF071IzvFAmGuuuqJ6ALfI9ZvQnSF48W1eL5bSGF3zZRBj8SGsE0E/ImEWjqHfQYC1Nb3FOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NJC2xMvqMvw0DaK9sntGQZ3FtG8NQ1iEJm9x65BMbU=;
 b=bxX48tcpw4trQRdSDh1vp8Wnsvb3n43MIJFRrtsDNWJJqK3+M6MpaJdD/atEGQnenSu5AlhdTUNIc8Rugh1svrzR83MdnVLL2VQeZ/KBvj4pS1iODcG7e3hfJLEXiVWTVWvfUh7rhNKPUhmQPaD/b6/2Y+8sPoBRWPtUyrc6RQ4/A6CJOClIusU5lalugqOFiFlAQfyWWdYz9May6uCEsGFVHlfU+fNYrEXmeD1khRwFrc8P5ML/x0++l3sZjlU/bH/N7kit3mKqvalIU7KTekI0D2pKLstwJdNA9fpL9ChPGFE//c6NnVUUfuwlV88/D5deIhTmYCdcdQDz066PYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NJC2xMvqMvw0DaK9sntGQZ3FtG8NQ1iEJm9x65BMbU=;
 b=OeMUAS0sNAIROqR/yjBt6uKc/7v59c/iPdAgY3r0WaQkBlmwR7SqyJ4sXurDSrG53IQtnjQZ8acU/Lu0NAWXgHaldASSND4e4XTelnzQOv0tMKQfy+XBUDJ04uGQeuZCxYSiNCqe0pWRQx2fEevMnc1Gl1paLtg7y79TbTJzuyQ=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3095.namprd15.prod.outlook.com (2603:10b6:a03:fe::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Wed, 27 Jan
 2021 21:43:16 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3763.019; Wed, 27 Jan 2021
 21:43:16 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Peter Ziljstra" <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "john fastabend" <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "Kernel Team" <Kernel-team@fb.com>, Hao Luo <haoluo@google.com>
Subject: Re: [PATCH v2 bpf-next 2/4] selftests/bpf: add non-BPF_LSM test for
 task local storage
Thread-Topic: [PATCH v2 bpf-next 2/4] selftests/bpf: add non-BPF_LSM test for
 task local storage
Thread-Index: AQHW88ShH5IOjKYrS029recyIYC356o7/TsAgAAGEYA=
Date:   Wed, 27 Jan 2021 21:43:16 +0000
Message-ID: <4A77E6CE-82FE-4578-BC13-05583E2EA17D@fb.com>
References: <20210126085923.469759-1-songliubraving@fb.com>
 <20210126085923.469759-3-songliubraving@fb.com>
 <CAEf4BzZLJc9=JgZBmvRazHsZg+VLihaRi-3Pt8wrsT9am-eBGg@mail.gmail.com>
In-Reply-To: <CAEf4BzZLJc9=JgZBmvRazHsZg+VLihaRi-3Pt8wrsT9am-eBGg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:f23b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1afb5e5-a9c5-4e08-f030-08d8c30c8df5
x-ms-traffictypediagnostic: BYAPR15MB3095:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3095B87937E39FCE71B8E7F3B3BB9@BYAPR15MB3095.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: trEmfA1OS0+tKjWt6N+Zqx0MykOOyMXy2AFIcuLnUlM0+1KFV8PcORhEY4ErHu23WNXCALDbIRdZPYcDcwLp2QY1N9HFobj/bZwUooIF8jUsmsVBuyetEsdNmf62LCqt3g8foJvWU61bApzQmPj6Bbq3sQN4vlroz+uVJZn18tqbMpdy1XvZT6AkSIvqLV/2iQmm6+DXJwct7rCkO/cU8ka21CKbIEyoMbjEaF+MfvP8wqKzO2QQ3diLyuis50DbsFNaMZPTaKtwn7QVmOl4dUHxZCE9KQsTfRBI0lnXIN135SKqd8srOFnyL4nFu0hcXcQwoDcxtHMZNoqsBNohd8sFqR8ErzFvXEYdOCLHQIiMtLB3NtkfEjYwqgQbXbU2MCdXlebYwsKSBen7hDcMoQCLRGnZwBElnFULkqvaPPabjqKgZzf+4JrxzZ+fXIAaUa3MIC6cvcW8OtzWGa9zUrUvIUbjsxXeNNDQMLOx/nCBgsA6TYuvfQe66FStMUifsMoPQee1GbN+LAVBSjRa2+HEV0ygzE7XRUBjPBL/MRBKT7ZOzZIuErrhZ02VG1jxEx2qMPbuN0DwLPsuXZt2iA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(396003)(39860400002)(376002)(7416002)(66476007)(8676002)(478600001)(83380400001)(4326008)(86362001)(66556008)(6512007)(5660300002)(6486002)(6506007)(6916009)(66946007)(186003)(316002)(64756008)(2616005)(54906003)(2906002)(36756003)(71200400001)(33656002)(91956017)(53546011)(76116006)(66446008)(8936002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?TezzdomDuCjOMzx/umVbIwqmYStPpqd6sW/cTTbvZ17xRm7dtCfseBh4MNDK?=
 =?us-ascii?Q?I3tLPX6umy+EXamS0nyPbfBYRiB5EeTnCcQAEA92HVfjqEzPOokFriXa6EK+?=
 =?us-ascii?Q?D22WwgefKK8HKv+3O6cIa/XG6xV2qCNlkeMUcBPqWyRvU/KhqR44+CmzHPQ8?=
 =?us-ascii?Q?4NcNwJvTLWJtcLarNbqD1BRZ+Cj+EgJUN6JwagTHttQ20qbRMowXuj+fQPA5?=
 =?us-ascii?Q?XGNTnMiE3aL+wTv1dkpL3bxyjm0XMl7q5Nzrg9itGIHqo9gvYMXoLpyiPIIv?=
 =?us-ascii?Q?gMp9WxU8WkYbZQZaPfvYpBuk2oQlmCHm8hkRZSHwec5dw7tn2lMvw3YjMYH1?=
 =?us-ascii?Q?jtrX7L1a+Fiw1hDuj/M7ELI7RUWp2Hn7vV6w00asGKwtgHUM9LdL+3obWBCj?=
 =?us-ascii?Q?9M2T0NGavm2TG4tDY6YyxyErhZPMrh0AyhZ43+OCI8HEdPiHBQvfw+o1mIDn?=
 =?us-ascii?Q?KBsCBa1msZjkBB7x2V6OyC41qG9K1qbj4Z62FexSLfUTnVhCBkN6FXnbYU7T?=
 =?us-ascii?Q?ItIokPKwP6Y43fL1G03jpdFOGAQ0d763DDMDcRtRYYqHniGcqAC0zfCG/eGE?=
 =?us-ascii?Q?1NClqtZMx6MzQnGaNYUSCuRdu+bT2h2t4DDQKDi8hcVzLPlh3feON5MRjiO2?=
 =?us-ascii?Q?oPRrenf26K8NXXgZD+9n23uC/vVaJdJTt6YxiCYjdjbp0SQDDWGH0GVb78zp?=
 =?us-ascii?Q?O6jj5Xp1FBnIeFPUO8JPbZVqUsSM9oZBoHVYJuLj9eJFtkFgyMegDV613tVU?=
 =?us-ascii?Q?1e3jqM/kdDqDlQHj0OFMT3rtcn0FUZHIS3v3Qd2rSP6K7dfPBT0PiOxqJoN2?=
 =?us-ascii?Q?yEY3uDTW9OXzwRcnBOr7NqPKIvBkA5K+x++75wJmqYqH+fEW78ZQIruaK7E0?=
 =?us-ascii?Q?cTev0gpzNMa40Qq1T+lCA1wo9xQoATA0CuLCxReGLoAIePBI20Nvr3aB5psO?=
 =?us-ascii?Q?K/bzFnHCOOD/XxpEpjCvsbGiWt5CGja5G2fhC1tAyPyDPckaR0qdpOUaWwb4?=
 =?us-ascii?Q?w4WmAjypWH1j2SOEZvocUb9YFg8Pb+D00Qfl0wTIJy45vEX3tQ1iTkBe/ZY4?=
 =?us-ascii?Q?1Kl7HWUwrH19/ZyX/YdgoY951ok66XrE53NJp4uVB1J4d2LzkKM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9952AD7C094D6F42A83ADA1D482C67CD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1afb5e5-a9c5-4e08-f030-08d8c30c8df5
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 21:43:16.0764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ru8nb0G+6r1iqAG5d8bQjVhtzpf5zWbpaezGI9KehHGoAk0f2sCTEjldNgxz1dB42XPNCu9JIsTnXDgl73UeTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3095
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_09:2021-01-27,2021-01-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 impostorscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270109
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 27, 2021, at 1:21 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Tue, Jan 26, 2021 at 1:21 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> Task local storage is enabled for tracing programs. Add two tests for
>> task local storage without CONFIG_BPF_LSM.
>>=20
>> The first test measures the duration of a syscall by storing sys_enter
>> time in task local storage.
>>=20
>> The second test checks whether the kernel allows allocating task local
>> storage in exit_creds() (which it should not).
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> .../bpf/prog_tests/task_local_storage.c       | 85 +++++++++++++++++++
>> .../selftests/bpf/progs/task_local_storage.c  | 56 ++++++++++++
>> .../bpf/progs/task_local_storage_exit_creds.c | 32 +++++++
>> 3 files changed, 173 insertions(+)
>> create mode 100644 tools/testing/selftests/bpf/prog_tests/task_local_sto=
rage.c
>> create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage.=
c
>> create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage_=
exit_creds.c
>>=20
>> diff --git a/tools/testing/selftests/bpf/prog_tests/task_local_storage.c=
 b/tools/testing/selftests/bpf/prog_tests/task_local_storage.c
>> new file mode 100644
>> index 0000000000000..a8e2d3a476145
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/prog_tests/task_local_storage.c
>> @@ -0,0 +1,85 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2021 Facebook */
>> +
>> +#include <sys/types.h>
>> +#include <unistd.h>
>> +#include <test_progs.h>
>> +#include "task_local_storage.skel.h"
>> +#include "task_local_storage_exit_creds.skel.h"
>> +
>> +static unsigned int duration;
>> +
>> +static void check_usleep_duration(struct task_local_storage *skel,
>> +                                 __u64 time_us)
>> +{
>> +       __u64 syscall_duration;
>> +
>> +       usleep(time_us);
>> +
>> +       /* save syscall_duration measure in usleep() */
>> +       syscall_duration =3D skel->bss->syscall_duration;
>> +
>> +       /* time measured by the BPF program (in nanoseconds) should be
>> +        * within +/- 20% of time_us * 1000.
>> +        */
>> +       CHECK(syscall_duration < 800 * time_us, "syscall_duration",
>> +             "syscall_duration was too small\n");
>> +       CHECK(syscall_duration > 1200 * time_us, "syscall_duration",
>> +             "syscall_duration was too big\n");
>=20
> this is going to be very flaky, especially in Travis CI. Can you
> please use something more stable that doesn't rely on time?

Let me try.=20

>=20
>> +}
>> +
>> +static void test_syscall_duration(void)
>> +{
>> +       struct task_local_storage *skel;
>> +       int err;
>> +
>> +       skel =3D task_local_storage__open_and_load();
>> +       if (!ASSERT_OK_PTR(skel, "skel_open_and_load"))
>> +               return;
>> +
>> +       skel->bss->target_pid =3D getpid();
>=20
> you are getting process ID, but comparing it with thread ID in BPF
> code. It will stop working properly if/when tests will be run in
> separate threads, so please use gettid() instead.

Will fix.=20

>=20
>> +
>> +       err =3D task_local_storage__attach(skel);
>> +       if (!ASSERT_OK(err, "skel_attach"))
>> +               goto out;
>> +
>> +       check_usleep_duration(skel, 2000);
>> +       check_usleep_duration(skel, 3000);
>> +       check_usleep_duration(skel, 4000);
>> +
>> +out:
>> +       task_local_storage__destroy(skel);
>> +}
>> +
>> +static void test_exit_creds(void)
>> +{
>> +       struct task_local_storage_exit_creds *skel;
>> +       int err;
>> +
>> +       skel =3D task_local_storage_exit_creds__open_and_load();
>> +       if (!ASSERT_OK_PTR(skel, "skel_open_and_load"))
>> +               return;
>> +
>> +       err =3D task_local_storage_exit_creds__attach(skel);
>> +       if (!ASSERT_OK(err, "skel_attach"))
>> +               goto out;
>> +
>> +       /* trigger at least one exit_creds() */
>> +       if (CHECK_FAIL(system("ls > /dev/null")))
>> +               goto out;
>> +
>> +       /* sync rcu, so the following reads could get latest values */
>> +       kern_sync_rcu();
>=20
> what are we waiting for here? you don't detach anything... system() is
> definitely going to complete by now, so whatever counter was or was
> not updated will be reflected here. Seems like kern_sync_rcu() is not
> needed?

IIUC, without sync_ruc(), even system() is finished, the kernel may not=20
have called exit_creds() for the "ls" task yet. Then the following check
for null_ptr_count !=3D 0 would fail.=20

>=20
>> +       ASSERT_EQ(skel->bss->valid_ptr_count, 0, "valid_ptr_count");
>> +       ASSERT_NEQ(skel->bss->null_ptr_count, 0, "null_ptr_count");
>> +out:
>> +       task_local_storage_exit_creds__destroy(skel);
>> +}
>> +
>> +void test_task_local_storage(void)
>> +{
>> +       if (test__start_subtest("syscall_duration"))
>> +               test_syscall_duration();
>> +       if (test__start_subtest("exit_creds"))
>> +               test_exit_creds();
>> +}
>=20
> [...]
>=20
>> +int valid_ptr_count =3D 0;
>> +int null_ptr_count =3D 0;
>> +
>> +SEC("fentry/exit_creds")
>> +int BPF_PROG(trace_exit_creds, struct task_struct *task)
>> +{
>> +       __u64 *ptr;
>> +
>> +       ptr =3D bpf_task_storage_get(&task_storage, task, 0,
>> +                                  BPF_LOCAL_STORAGE_GET_F_CREATE);
>> +       if (ptr)
>> +               valid_ptr_count++;
>> +       else
>> +               null_ptr_count++;
>=20
>=20
> use atomic increments?

Do you mean __sync_fetch_and_add()?=20

>=20
>> +       return 0;
>> +}
>> --
>> 2.24.1

