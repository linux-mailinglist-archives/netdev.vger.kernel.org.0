Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E42207D90
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 22:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391473AbgFXUh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 16:37:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20262 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729833AbgFXUhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 16:37:25 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05OKVUfU026795;
        Wed, 24 Jun 2020 13:37:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Si7jD0Oc/WrCdHCCcq8KqZUAe2LIOQ8qHrGiJ9t4WKk=;
 b=iPiMsbuVG4k4zby85+Dgq8Rx1q2q6NoiTQSgSAcuY8F0zjTncO9MAaXKXIcwDFdrSg0X
 EarDz7wtJsipZUNKP0YCGr6bxTSoe+rJKV+aQPKZTNETZ3cHbvdP8y7FvJAeS9XDXj0t
 SqYtPYjwHaelCuQ+6jJL/pi/SuntfTyKgYk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux0xmayn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 24 Jun 2020 13:37:09 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 24 Jun 2020 13:37:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JDnc39h87XKYa4tfwsNRep9s8db37BkyTedki8mV5AJyd+ahzSLTT2eZrwErof2iIqyF6J0OwRfF3Anyfnj+BroP+/M6b/SnHJlY0t5gCJoEuPjWzggnCHgftqyydNgpyw9+NKTw4QFe6EtTanz/bcLu/jIIfwRWDjcu0e3kDFjmMK7OqTrLaIfxmMUW8JAbxlXHwODM205EjNDu6Gaq7E7ivsc3SrmFezbZjaYDNCDLcaZftMcavCOH6oPh4nh2hB7sLMHNS4+LtRzEn2c6BCGKCQGn99NezVa6awzj+ryPpuuVShYxEVLa3LTgaabFd91ccmYf9xmN+ccZsXYQGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Si7jD0Oc/WrCdHCCcq8KqZUAe2LIOQ8qHrGiJ9t4WKk=;
 b=R8smNOKhIehrzxMoVYlGdy8r/iZpi6Je3jBA0FL6ZQ0DmqQmk/onrd9v14d4WuKuQmW2t2pJcVA7Gs2b6QPcC/ORAX/+DowqPfaTOkdjAz4ecC6WDRM4mZkgF9DNL24NQo8QPhpucU3VtQRSyosaviUu1d/Sb9pcWTAAukEcWtrtl1w0oeyq8h2U3GkslQk7lAdXnaxAMWMo/ae3cFMJsMsnto+kK35eZ0iLXpePhYeEE7FBiiQFE7K6jqTSxn/WECX89RurLU22kDr25T5prk5OCO/yXa/l5AsEGx6ymkgK+gN18fa43Kw1dIBy9HongspWiei7lPgMc6rqn7Dbaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Si7jD0Oc/WrCdHCCcq8KqZUAe2LIOQ8qHrGiJ9t4WKk=;
 b=SnDUKlSSLnuX904xS8J8ZJDFDtR7/FEDaMItcvINbd3rp+/7PuyjvXC/dTZS2uxHSQ+o5RWnlerUOa7CMhECYYHJg62JQ+gTXxbIF88MKPGsfIvndrQCSlaLvRC5fvPVGbG3xJhrel3dn4RDCI0i/RwNJqUbwbiX8Rnr1RsInOw=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3045.namprd15.prod.outlook.com (2603:10b6:a03:f9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Wed, 24 Jun
 2020 20:37:07 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3109.027; Wed, 24 Jun 2020
 20:37:07 +0000
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
Thread-Index: AQHWSS0YqPPKE0Yf2kWel2Uo2kKqj6jmjfIAgAA1IgCAAAWTgIABc3EA
Date:   Wed, 24 Jun 2020 20:37:07 +0000
Message-ID: <03A78005-BDCD-4A90-BD27-724DA6056D9B@fb.com>
References: <20200623070802.2310018-1-songliubraving@fb.com>
 <20200623070802.2310018-4-songliubraving@fb.com>
 <445e1e04-882f-7ff7-9bd4-ebcf679cebbb@fb.com>
 <78BB08A3-D049-4795-8702-470C5841062C@fb.com>
 <dda0849f-f106-18d9-b805-5fe1edb72e42@fb.com>
In-Reply-To: <dda0849f-f106-18d9-b805-5fe1edb72e42@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
x-originating-ip: [2620:10d:c091:480::1:3bf5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c8296dd-f6f5-4d83-1ea5-08d8187e5d17
x-ms-traffictypediagnostic: BYAPR15MB3045:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB30457D0198E7ED767435A30CB3950@BYAPR15MB3045.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0444EB1997
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 096MJV2yCd/CfL1cIFjNib2VAi/cTU3orVg4j5Y7kLdHC9bdpi+RxaCVesUyOs1NEC310ptvWn7owphnGxTmCTGnS1u0G1b/hQ6pRlP3zJmPoD64xHVFuCDIv15B0tEYDDumSlLPWh2Ozy2hQpbhVjHkf0De+MTQG6hoYQye1kKZyCC7smyqBzNT/MZCCHob0amuUf+KzVOE+URyq8EE2Dl4rtd6WoSXdPxlSy/PZ78yl1aZs40WdjQ4V5Peqx8JnzkLp4wnMrfLIZWat3ydKNMLjdp6UsdxuE7ZqjgnQ6tjkdyyoc7wbnMXo6zXmckr33/XACqcGR83csj9T+YcRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(39860400002)(136003)(346002)(366004)(54906003)(316002)(2616005)(5660300002)(86362001)(6512007)(8936002)(66476007)(76116006)(91956017)(8676002)(4326008)(6862004)(6636002)(66946007)(83380400001)(66446008)(71200400001)(64756008)(33656002)(186003)(37006003)(478600001)(2906002)(36756003)(53546011)(6506007)(66556008)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Lgx8icA7ZnEnkL3VmJ8mtbrfUfM+OHPbDYsGg0egkPaBP3fc+uFz8dJfrtFj+D6SpZeoUpt+vJFyhZhLyCB8q+5rg39HdMKmi6un0gj30awM+HkoPyY8oP+xoZEt8tWgwh9LJIt2Ahgr9CmMCc4V1YUfXNTkixOAVayvtHiG6t6g/m9bl2IY2cE8cnKKhPq+xtxXM1vERp5kYAIkOLrxdrKFMbrR8+MKLWQHc3nheQOr9Dj0Lq99BhoWmwN0fehPtuq8v7LC7X+UlLJNCM3n663QA7DUER0digucVFpHxuAzVoEi8wGsS6hFr/rDdGop/gjncGzpRZKzVq+boGCRTBOC6cWHR8CSOGEyYWfYLU95DveOaFJLBVkocwpxWI59OSjEqZSfsjcDbcfUZPNlP3v6ehaAcB4sk2pxuG4Gy3IFnwWQHRj1BNYRa9oHlwQ3Zma9XFP3jF9aKdKrGZ2U7u+YPQNQsfZWtYDHLfWZrzSTLbrxVhTycfV7Z35y5V9ZR0haoYNm2JpcArG5T8W0bQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <88F5368B695BE8448835BF40B289EDE9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c8296dd-f6f5-4d83-1ea5-08d8187e5d17
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2020 20:37:07.8008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1mu5jbT+NF6OeybOq+cBYPIVATOU6K8PAsuWeiz9jXXRuH9guwyZ09r4Sgiu37O+dIKBIgQ2j9sZBEoTOibqVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3045
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-24_16:2020-06-24,2020-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 spamscore=0 mlxscore=0 impostorscore=0 cotscore=-2147483648 malwarescore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006240133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 23, 2020, at 3:27 PM, Yonghong Song <yhs@fb.com> wrote:
>=20
>=20
>=20
> On 6/23/20 3:07 PM, Song Liu wrote:
>>> On Jun 23, 2020, at 11:57 AM, Yonghong Song <yhs@fb.com> wrote:
>>>=20
>>>=20
>>>=20
>>> On 6/23/20 12:08 AM, Song Liu wrote:
>>>> The new test is similar to other bpf_iter tests.
>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>> ---
>>>>  .../selftests/bpf/prog_tests/bpf_iter.c       | 17 +++++++
>>>>  .../selftests/bpf/progs/bpf_iter_task_stack.c | 50 ++++++++++++++++++=
+
>>>>  2 files changed, 67 insertions(+)
>>>>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_st=
ack.c
>>>> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools=
/testing/selftests/bpf/prog_tests/bpf_iter.c
>>>> index 87c29dde1cf96..baa83328f810d 100644
>>>> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>>>> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>>>> @@ -5,6 +5,7 @@
>>>>  #include "bpf_iter_netlink.skel.h"
>>>>  #include "bpf_iter_bpf_map.skel.h"
>>>>  #include "bpf_iter_task.skel.h"
>>>> +#include "bpf_iter_task_stack.skel.h"
>>>>  #include "bpf_iter_task_file.skel.h"
>>>>  #include "bpf_iter_test_kern1.skel.h"
>>>>  #include "bpf_iter_test_kern2.skel.h"
>>>> @@ -106,6 +107,20 @@ static void test_task(void)
>>>>  	bpf_iter_task__destroy(skel);
>>>>  }
>>>>  +static void test_task_stack(void)
>>>> +{
>>>> +	struct bpf_iter_task_stack *skel;
>>>> +
>>>> +	skel =3D bpf_iter_task_stack__open_and_load();
>>>> +	if (CHECK(!skel, "bpf_iter_task_stack__open_and_load",
>>>> +		  "skeleton open_and_load failed\n"))
>>>> +		return;
>>>> +
>>>> +	do_dummy_read(skel->progs.dump_task_stack);
>>>> +
>>>> +	bpf_iter_task_stack__destroy(skel);
>>>> +}
>>>> +
>>>>  static void test_task_file(void)
>>>>  {
>>>>  	struct bpf_iter_task_file *skel;
>>>> @@ -392,6 +407,8 @@ void test_bpf_iter(void)
>>>>  		test_bpf_map();
>>>>  	if (test__start_subtest("task"))
>>>>  		test_task();
>>>> +	if (test__start_subtest("task_stack"))
>>>> +		test_task_stack();
>>>>  	if (test__start_subtest("task_file"))
>>>>  		test_task_file();
>>>>  	if (test__start_subtest("anon"))
>>>> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c b=
/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
>>>> new file mode 100644
>>>> index 0000000000000..4fc939e0fca77
>>>> --- /dev/null
>>>> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
>>>> @@ -0,0 +1,50 @@
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
>>>> +struct bpf_iter_meta {
>>>> +	struct seq_file *seq;
>>>> +	__u64 session_id;
>>>> +	__u64 seq_num;
>>>> +} __attribute__((preserve_access_index));
>>>> +
>>>> +struct bpf_iter__task {
>>>> +	struct bpf_iter_meta *meta;
>>>> +	struct task_struct *task;
>>>> +} __attribute__((preserve_access_index));
>>>> +
>>>> +#define MAX_STACK_TRACE_DEPTH   64
>>>> +unsigned long entries[MAX_STACK_TRACE_DEPTH];
>>>> +
>>>> +SEC("iter/task")
>>>> +int dump_task_stack(struct bpf_iter__task *ctx)
>>>> +{
>>>> +	struct seq_file *seq =3D ctx->meta->seq;
>>>> +	struct task_struct *task =3D ctx->task;
>>>> +	unsigned int i, num_entries;
>>>> +
>>>> +	if (task =3D=3D (void *)0)
>>>> +		return 0;
>>>> +
>>>> +	num_entries =3D bpf_get_task_stack_trace(task, entries, MAX_STACK_TR=
ACE_DEPTH);
>>>> +
>>>> +	BPF_SEQ_PRINTF(seq, "pid: %8u\n", task->pid);
>>>> +
>>>> +	for (i =3D 0; i < MAX_STACK_TRACE_DEPTH; i++) {
>>>> +		if (num_entries > i)
>>>> +			BPF_SEQ_PRINTF(seq, "[<0>] %pB\n", (void *)entries[i]);
>>>=20
>>> We may have an issue on 32bit issue.
>>> On 32bit system, the following is called in the kernel
>>> +	return stack_trace_save_tsk(task, (unsigned long *)entries, size, 0);
>>> it will pack addresses at 4 byte increment.
>>> But in BPF program, the reading is in 8 byte increment.
>> Can we avoid potential issues by requiring size % 8 =3D=3D 0? Or maybe r=
ound down
>> size to closest multiple of 8?
>=20
> This is what I mean:
>  for bpf program: "long" means u64, so we allocate 64 * 8 buffer size
>                   and pass it to the helper
>  in the helper, the address will be increased along sizeof(long), which
>                 is 4 for 32bit system.
>          So address is recorded at buf, buf + 4, buf + 8, buf + 12, ...
>  After the helper returns, the bpf program tries to retrieve
>          the address at buf, buf + 8, buf + 16.
>=20
> The helper itself is okay. But BPF_SEQ_PRINTF above is wrong.
> Is this interpretation correct?

Thanks for the clarification. I guess the best solution is to fix this=20
once in the kernel, so BPF programs don't have to worry about it.=20

Song

