Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0072066E6
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388354AbgFWWID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:08:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58632 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388082AbgFWWIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:08:02 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NLwZYS009203;
        Tue, 23 Jun 2020 15:07:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=DBIl/gvdhRFxH01kubxGoJrvQFdZsVj9UOHkDLWvJ+c=;
 b=p4Mn7rIRXtXV7H55Pf8J4yV+n5zl3nOCHDe0cEnRvDjEfzxwYU2YkQ+67mJjhorKOS8W
 cwdbR9QpOyXI8yaTWflHYeaF5ln9puMlkvx5SXX0qrV1IU9WFX7cj9liXQgAmwKtZLMQ
 zi2f0NiJa7HPOgAco51Dp3SulZ7i0s6Ouns= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk20afjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 15:07:47 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 15:07:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gqwspG0/Nql9M+LxPLR5104E5vfIXs7Wb5f8RZbHhkS8rtVN00E8B+TvicOQFfjYzlKL6y0D7Z3JwdCcsYQvH9diVWQ+D7via0Oze9WnPPfPTOlb4MC+K/MEXLOtyUQCT4IGs2O0TklBriGbjKdwsN8weujtkW0FtYEX1SvJZ1ZbFx9/fICCmAh5XAe2V1SKme0Mc+ss3k/aON08huHfE6PlmlryrWLzAUiUXEPLSkaelD+dBtuwzEqktwhbCi14tvES0wtLTw+Z7UaFrRJCf9GVCeoGT1I6foDlVOH22zcZlrrb3rHfllFhsO3Yf95evF04vN7MkEpJwSUPzjVBhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBIl/gvdhRFxH01kubxGoJrvQFdZsVj9UOHkDLWvJ+c=;
 b=cfQONhpYQ8qaiFluXQQEqt22iiG4Csqlg6tAbtCnRoCdZXEellQGU+be3EEpwLb+3RdYQLceW6sFTRWuZ22Qzb2m4ltSeT03ZTfE8xYN24Mbv1U5jCG1trIoHPohO19H+w697VcQavyBWE0XeAZizeMdXCf5qrqFp6ZoRgZp80gjSBXKnQfc8S490TzRysXiwNWHkuVAHD6NevJPtNWHIGc+5nPKMklO4b6GMk5riVneg/Og6tB6pzwG+h9fUDZ1rDy3tsei7wByroyQnx4nRrcWw+zcN96dIRTHP1dhNU0wDmClcE51QWKiUMMI6dM8ZhxtQbyK1+/+jJC/PTQj2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBIl/gvdhRFxH01kubxGoJrvQFdZsVj9UOHkDLWvJ+c=;
 b=KoXf4Ol7UzxXjzYEpbKD9lOQHiJQOhHvuTbjYmUUp7YXdLZxXkDbyEyjAKiQtFC5MPAhlIRFhwH74jV/naw4p8+BRN8haUVqdEPYwhckOSOf/RlHbpjw9E9HEucN2dfNpKUYSCndqGi2TX7m6WGk7ACbSuZ8PAGKoUDVxz9j5bw=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3620.namprd15.prod.outlook.com (2603:10b6:a03:1f8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 22:07:43 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 22:07:43 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: add bpf_iter test with
 bpf_get_task_stack_trace()
Thread-Topic: [PATCH bpf-next 3/3] selftests/bpf: add bpf_iter test with
 bpf_get_task_stack_trace()
Thread-Index: AQHWSS0YqPPKE0Yf2kWel2Uo2kKqj6jmjfIAgAA1IgA=
Date:   Tue, 23 Jun 2020 22:07:43 +0000
Message-ID: <78BB08A3-D049-4795-8702-470C5841062C@fb.com>
References: <20200623070802.2310018-1-songliubraving@fb.com>
 <20200623070802.2310018-4-songliubraving@fb.com>
 <445e1e04-882f-7ff7-9bd4-ebcf679cebbb@fb.com>
In-Reply-To: <445e1e04-882f-7ff7-9bd4-ebcf679cebbb@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
x-originating-ip: [2620:10d:c090:400::5:5ffc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c0243be-0852-4b1a-d9b0-08d817c1da5b
x-ms-traffictypediagnostic: BY5PR15MB3620:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB3620D527777EFD7A15FA85E7B3940@BY5PR15MB3620.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nw6VL1MZvbOdN2CQr7A3on0SoqGbIuX9rjyP+Iz71ZgDH1dXLtbbCQx12BPVXHI5ffLrA0FywDjLKf0M5PNBcaEuP+ZxQUcIjFAowUpouInr8PJIXLismAx+R8bproGyF9H2LLtXj06yF6KS81/xBCpseJ+HbaTnTYWQJ+AArGWK9BZREviszJI5sMFLBXTQEPH+GnGLEn0+UsPcVooeja1KQYsoAl2uHR/jr1ex9IRCs9wGyk4a6uBjqXFThPFaL/YXrX+I+6Gi6BfQvlR4g856kFHK77SAft8DjATUq8NXLQcIti7E80ZJsPrECQW4yyZVI7EHNWlB5XemnHx3tQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(376002)(366004)(396003)(39860400002)(76116006)(6862004)(316002)(2616005)(6512007)(64756008)(66556008)(66476007)(54906003)(66946007)(66446008)(37006003)(8936002)(33656002)(8676002)(36756003)(6636002)(186003)(6506007)(53546011)(4326008)(2906002)(83380400001)(6486002)(86362001)(478600001)(71200400001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 2Mr1Z9hCSorFa6uf3BUS3to4HBdq8tkCMax9EwqtRHkMEW0hdE+TwGyJTm1eJMbf9CKSV6ltjXCN3+k0yRPzSeoT7rzcS8D8kPOttk/qe1ew1Bnd6lbdto9BPH+xliWuQseCOo36KTgC1fLD0aXTaAG62b4bZxW4c4PuZKB2/3NsxAb1xJuh8t6kgmkoMtpi7nIarsMDOwFkPq5Qs9xsDc6BHQEP/2ya9U57IenUYrckU0Z3lR2Efgr/rWv/j9P9JCCwD+Gs45iWTocaHrujX2UqUhZWuNhMIBvvcyTFicXW5FVUgkLvo8tQ7uNyVHkM46c3V+JFSaF3LEF6J1ChO1MEviO73xGYbeYSIrLdtq6325ZmUMiwuCIKm7vgv9zjVCY+fcmKVWS7SonGaVgQS3eIJUrSrHlxK3XBVR/Ghyt4ilE7b2TQtIevsUonI4Tf09eiD6MrPXiD700+eyAnEWFsis+ySk/YBGcQDtKuIiylFS+m3oavyJ3+k05vqY6ELFirUtxF+AkB5eSi9GsVPQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <94E03E6AD6446E489B3CEACE52C66F77@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c0243be-0852-4b1a-d9b0-08d817c1da5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 22:07:43.0915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aUcPRSvMLAi1VFhEIKC5xy3FmA6mmFi0LZR7di6sJYUsqd1LyPBdbfaVtEN2T4c+2z47AVv1T3fkDGKNW4/4Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3620
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_14:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006120000 definitions=main-2006230147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 23, 2020, at 11:57 AM, Yonghong Song <yhs@fb.com> wrote:
>=20
>=20
>=20
> On 6/23/20 12:08 AM, Song Liu wrote:
>> The new test is similar to other bpf_iter tests.
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>>  .../selftests/bpf/prog_tests/bpf_iter.c       | 17 +++++++
>>  .../selftests/bpf/progs/bpf_iter_task_stack.c | 50 +++++++++++++++++++
>>  2 files changed, 67 insertions(+)
>>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_stac=
k.c
>> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/t=
esting/selftests/bpf/prog_tests/bpf_iter.c
>> index 87c29dde1cf96..baa83328f810d 100644
>> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>> @@ -5,6 +5,7 @@
>>  #include "bpf_iter_netlink.skel.h"
>>  #include "bpf_iter_bpf_map.skel.h"
>>  #include "bpf_iter_task.skel.h"
>> +#include "bpf_iter_task_stack.skel.h"
>>  #include "bpf_iter_task_file.skel.h"
>>  #include "bpf_iter_test_kern1.skel.h"
>>  #include "bpf_iter_test_kern2.skel.h"
>> @@ -106,6 +107,20 @@ static void test_task(void)
>>  	bpf_iter_task__destroy(skel);
>>  }
>>  +static void test_task_stack(void)
>> +{
>> +	struct bpf_iter_task_stack *skel;
>> +
>> +	skel =3D bpf_iter_task_stack__open_and_load();
>> +	if (CHECK(!skel, "bpf_iter_task_stack__open_and_load",
>> +		  "skeleton open_and_load failed\n"))
>> +		return;
>> +
>> +	do_dummy_read(skel->progs.dump_task_stack);
>> +
>> +	bpf_iter_task_stack__destroy(skel);
>> +}
>> +
>>  static void test_task_file(void)
>>  {
>>  	struct bpf_iter_task_file *skel;
>> @@ -392,6 +407,8 @@ void test_bpf_iter(void)
>>  		test_bpf_map();
>>  	if (test__start_subtest("task"))
>>  		test_task();
>> +	if (test__start_subtest("task_stack"))
>> +		test_task_stack();
>>  	if (test__start_subtest("task_file"))
>>  		test_task_file();
>>  	if (test__start_subtest("anon"))
>> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c b/t=
ools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
>> new file mode 100644
>> index 0000000000000..4fc939e0fca77
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
>> @@ -0,0 +1,50 @@
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
>> +struct bpf_iter_meta {
>> +	struct seq_file *seq;
>> +	__u64 session_id;
>> +	__u64 seq_num;
>> +} __attribute__((preserve_access_index));
>> +
>> +struct bpf_iter__task {
>> +	struct bpf_iter_meta *meta;
>> +	struct task_struct *task;
>> +} __attribute__((preserve_access_index));
>> +
>> +#define MAX_STACK_TRACE_DEPTH   64
>> +unsigned long entries[MAX_STACK_TRACE_DEPTH];
>> +
>> +SEC("iter/task")
>> +int dump_task_stack(struct bpf_iter__task *ctx)
>> +{
>> +	struct seq_file *seq =3D ctx->meta->seq;
>> +	struct task_struct *task =3D ctx->task;
>> +	unsigned int i, num_entries;
>> +
>> +	if (task =3D=3D (void *)0)
>> +		return 0;
>> +
>> +	num_entries =3D bpf_get_task_stack_trace(task, entries, MAX_STACK_TRAC=
E_DEPTH);
>> +
>> +	BPF_SEQ_PRINTF(seq, "pid: %8u\n", task->pid);
>> +
>> +	for (i =3D 0; i < MAX_STACK_TRACE_DEPTH; i++) {
>> +		if (num_entries > i)
>> +			BPF_SEQ_PRINTF(seq, "[<0>] %pB\n", (void *)entries[i]);
>=20
> We may have an issue on 32bit issue.
> On 32bit system, the following is called in the kernel
> +	return stack_trace_save_tsk(task, (unsigned long *)entries, size, 0);
> it will pack addresses at 4 byte increment.
> But in BPF program, the reading is in 8 byte increment.

Can we avoid potential issues by requiring size % 8 =3D=3D 0? Or maybe roun=
d down
size to closest multiple of 8?=20

Thanks,
Song=
