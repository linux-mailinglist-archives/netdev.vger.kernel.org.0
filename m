Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0442DB58B
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 22:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbgLOVAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 16:00:42 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57862 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728694AbgLOVA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 16:00:27 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0BFKxAQ1010698;
        Tue, 15 Dec 2020 12:59:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=3NkJTanTt6koS2C5bCA6iNUJFCUas1MO5djIHHcZyF0=;
 b=JdzHyzgcNIhWUZbFFwtkqodMEIC1jH2seLigcpNRpv1tbQkzRPhFqedXhGIyJCSQN9K+
 1Z2b48v3S3ULK2tlpmWDn/SyvtPwIFx+ASfD4eCJr5dJ8P13dbZPTQRLsMYr935AmwiA
 fsm7zgDrbfjvqLXAHtXvNBoDIU62O17Yghk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 35ct85grxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Dec 2020 12:59:27 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Dec 2020 12:59:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AR7SH6ClFXcROp5PH5Zf/osTIlk0AB9FyL0BVfxtZwSERBApWNd38DqK6wyn2y2LK03PuZPFNZTgu2BTyKNlcUQZFIMctByw01mKEryIRhf72CNUXaZCKcwwrFlLmO3QqzzKFnvRdxARfUyShUYESxr7SDFseoncspE8g3APE/+Pe9y7GR1ey2V7gxppJEjeLXAvVlYyxAx+CjTQdqatKqj92gTlVygb2Qb4jSpeHibGgZBXfXGsNWDn/lMC7NNHj1Fukp2mE1UITDcg/NOfQ0KNFC9Q5OTN/82jOj3xtXnqxIXBJ1zUJdwSua+ujxaYtfht/jJiz/Bkdgrf7NLGxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3NkJTanTt6koS2C5bCA6iNUJFCUas1MO5djIHHcZyF0=;
 b=NJYED0Pu0DKO9giKssId+as8At38pzCVgWdFcR9E7GwcQc8GTJuh+cqSsJ4SE3vfoRzNPse/+kVo0/4/F4prwAy8POtSkfhEoZvH0LKz44/UcnAkUtd7TlIMEfw0J/caJ1Xak/yQQFLB7YNekYsOldVumv63IBRPvgh/SkBmwX/438aLUNiwmCthXgoTLBTzk6FxuS3FNWPG+nwyQELI2Xr0Yphw+R9ZE7rBlirWTJj5MhNbI7lgkYf3qL5/cjpjW/K6bKTC72FVxhkfKwfnW8wzdXFlCJXN9hP04bIWd9OeQjJ7gl/SsCXuuxBM9FhTfaUdNZa7yAWh2yVJbfIpFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3NkJTanTt6koS2C5bCA6iNUJFCUas1MO5djIHHcZyF0=;
 b=UhUJNSceccUafvz+dS77UYqrHUmN9pCYSImQwc6zHEISpRnTaN4GLwt0UwAZTlsQ5jFCHumkAL4U58zkuyW+OVK/CtTtUuBhIMfVyBxz5wBIfr2DeYw0o7OG1iiAaCEv3+hK3UWZplhaXJMfHKzvveoPQsDZ1gMvkJw1CcIP1m4=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3413.namprd15.prod.outlook.com (2603:10b6:a03:10b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.15; Tue, 15 Dec
 2020 20:59:21 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 20:59:21 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 4/4] selftests/bpf: add test for
 bpf_iter_task_vma
Thread-Topic: [PATCH bpf-next 4/4] selftests/bpf: add test for
 bpf_iter_task_vma
Thread-Index: AQHW0DFWfuxjYlZ+4EaFlvRXkeR1xKn4n0sAgAAKpIA=
Date:   Tue, 15 Dec 2020 20:59:21 +0000
Message-ID: <69017626-7B81-4DDE-8D0F-B2FC9AA32F53@fb.com>
References: <20201212024810.807616-1-songliubraving@fb.com>
 <20201212024810.807616-5-songliubraving@fb.com>
 <e3f13f87-6ee8-1ed3-c575-3f23c907bf3e@fb.com>
In-Reply-To: <e3f13f87-6ee8-1ed3-c575-3f23c907bf3e@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c091:480::1:e346]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d248130-b612-4925-a929-08d8a13c4c1b
x-ms-traffictypediagnostic: BYAPR15MB3413:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB34139335867FD4FFA3B4D44FB3C60@BYAPR15MB3413.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EO4iFE/dygYkQB2kXDngWjYeBy8tQTqY9ThapopRDqkvHW8Z7bbz5YnA7aVn2Al1a/a4xHpbXqwBBD1/ntHJG7cAi4cGdN6PD12t9IqJ23xgMHX/f1RJEd1ORzcOOhIZtEQXmp95aU5sJ/rubUBErdb/3n54sG/3NZAPtDqI5PuaP/JBqQC6Ro8e6rlLj1ErK7+1A69cWhtWqpItul0IbkEPppQyTBgbBe6W1MihV0HSdpisnmPgxucmkJbULJXDfp8OstuG0fU2pyJQPwEobhIUkX9zOjuVdPBOzCxGk469grxBZRkgOgCcGOc58VDZmeXBQyF9HQYOs17S5uptopcy3yeDLfdS5VZdA2YK0qsTr2rbAYWnRPFUdW5iH4pm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(366004)(376002)(346002)(316002)(53546011)(8936002)(6506007)(478600001)(64756008)(6862004)(66476007)(66556008)(6512007)(71200400001)(33656002)(2616005)(37006003)(6636002)(36756003)(2906002)(186003)(54906003)(66446008)(66946007)(5660300002)(86362001)(83380400001)(76116006)(8676002)(4326008)(91956017)(6486002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?+FuMOBiwSyr5PT9jirxnTrvGF3izxTfQwv35xaTQSL1407fQsRqzZPq6b2Wc?=
 =?us-ascii?Q?/PGAwJrgqKseRFT/J/R0HRDAgEg1tcZwN6SVz7D9dUafmVSbH43yIjxh114g?=
 =?us-ascii?Q?eSbfnbhrOBIMwQlDwlqxrcZTyjkGNh/ycDAqIgsfqRjRipJ/QwZJsquhRggI?=
 =?us-ascii?Q?03RKpbmf3+6LcKjIUkJbWapjACyAMcI0aDqGa4+o+k3MxAHKxI0l9vUvvl5R?=
 =?us-ascii?Q?bqk60wep5VG3wQikP4D7QqQ5wXSXmpFNiyPnbXvsNnbEAtKibSpO7zLp9KZb?=
 =?us-ascii?Q?a7XELReAwh4WiP9662FiWos1CwvKVDQMiLNOcS5x/uELXG5wpFS0PUCO3nVO?=
 =?us-ascii?Q?Q2mJipKlJC6gT4Tu6UyMa4XDw7/ho5yU03cCKAC/WTH5PR8ZvYThOCiwm6xr?=
 =?us-ascii?Q?2x0kCopMYc8u8bsI6MbHkXDzWgEEa/Tk6F/tjRyD6zKTv4GfxNch0t0dIUyW?=
 =?us-ascii?Q?7JJTFwLpyoYy92COh+pC8umA1aN2C7ng9EWp3gO2NXaieGxH4RX3yoYXBfvw?=
 =?us-ascii?Q?XCBRx1MICLC4/ozA7STXivj2qd8yY9RBXa2j4JiadcEjdBz3xFN0TGMtpMJy?=
 =?us-ascii?Q?KoinCUWq8h7eVhpAkaGg31dqIkZWs7vDJmlfxUXM/jJuV2hI2EiCdSTcuGP4?=
 =?us-ascii?Q?rOKSwHFCcsrmg7gD4ozW3KuimhKgI0HUmwdL0HMttchFzl7Y+8vA4EAe0GXU?=
 =?us-ascii?Q?21sEizlVttqBnHYqY03+oXEbYAsc6eQ1LD6CwKM5TrXYr+JdJioa4LWAw/Ky?=
 =?us-ascii?Q?dQeX9CjK+tYEoZGOYOUxcf0SPc+o2PzFAd68GIxWeJhTjwBGsE5g6Hg/bA/e?=
 =?us-ascii?Q?3E7opJnK19lQ3q4V4guQ7MGWq304e/EisaToXtT6zgsQNw6eN6m40Am1HVgM?=
 =?us-ascii?Q?Xf0S3DdS8uUJJ6oUgiUC9LhOEQUBiRlbGFJrhqa9bCcbJu1omJZcu4Oz6fSx?=
 =?us-ascii?Q?LsoXAHT589vRqnt0nCGskFLQqMtHEzyQzktkfj741I4cQSYW0umNhE3bczA1?=
 =?us-ascii?Q?nSnmAZvWkR+sxyi/6vNRHhHS6xIeEHLNYWnaf8Eucb5WIek=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <86B1770DBC1FD14396F769F147DCEB34@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d248130-b612-4925-a929-08d8a13c4c1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2020 20:59:21.8346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n8wofN7oUROEHd12fkXLYBcAB0WliM0ugfLA7pCdkN5WBv+L2QK8BMNyIfke3IVuzIPW7jVfRKQygMcXFxyN1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3413
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_12:2020-12-15,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 adultscore=0 impostorscore=0
 clxscore=1015 spamscore=0 phishscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012150141
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 15, 2020, at 12:21 PM, Yonghong Song <yhs@fb.com> wrote:
>=20
>=20
>=20
> On 12/11/20 6:48 PM, Song Liu wrote:
>> The test dumps information similar to /proc/pid/maps. The first line of
>> the output is compared against the /proc file to make sure they match.
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>>  .../selftests/bpf/prog_tests/bpf_iter.c       | 106 ++++++++++++++++--
>>  tools/testing/selftests/bpf/progs/bpf_iter.h  |   9 ++
>>  .../selftests/bpf/progs/bpf_iter_task_vma.c   |  55 +++++++++
>>  3 files changed, 160 insertions(+), 10 deletions(-)
>>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_vma.=
c
>> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/t=
esting/selftests/bpf/prog_tests/bpf_iter.c
>> index 0e586368948dd..7afd3abae1899 100644
>> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>> @@ -7,6 +7,7 @@
>>  #include "bpf_iter_task.skel.h"
>>  #include "bpf_iter_task_stack.skel.h"
>>  #include "bpf_iter_task_file.skel.h"
>> +#include "bpf_iter_task_vma.skel.h"
>>  #include "bpf_iter_task_btf.skel.h"
>>  #include "bpf_iter_tcp4.skel.h"
>>  #include "bpf_iter_tcp6.skel.h"
>> @@ -64,6 +65,22 @@ static void do_dummy_read(struct bpf_program *prog)
>>  	bpf_link__destroy(link);
>>  }
>> =20
> [...]
>> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c b/too=
ls/testing/selftests/bpf/progs/bpf_iter_task_vma.c
>> new file mode 100644
>> index 0000000000000..d60b5b38cb396
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c
>> @@ -0,0 +1,55 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2020 Facebook */
>> +#include "bpf_iter.h"
>> +#include <bpf/bpf_helpers.h>
>> +#include <bpf/bpf_tracing.h>
>> +
>> +char _license[] SEC("license") =3D "GPL";
>> +
>> +/* Copied from mm.h */
>> +#define VM_READ		0x00000001
>> +#define VM_WRITE	0x00000002
>> +#define VM_EXEC		0x00000004
>> +#define VM_MAYSHARE	0x00000080
>> +
>> +/* Copied from kdev_t.h */
>> +#define MINORBITS	20
>> +#define MINORMASK	((1U << MINORBITS) - 1)
>> +#define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
>> +#define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
>> +
>> +#define D_PATH_BUF_SIZE 1024
>> +char d_path_buf[D_PATH_BUF_SIZE];
>> +__u32 pid;
>> +
>> +SEC("iter.s/task_vma") int proc_maps(struct bpf_iter__task_vma *ctx)
>> +{
>> +	struct __vm_area_struct *vma =3D ctx->vma;
>> +	struct seq_file *seq =3D ctx->meta->seq;
>> +	struct task_struct *task =3D ctx->task;
>> +	struct file *file =3D ctx->file;
>> +	char perm_str[] =3D "----";
>> +
>> +	if (task =3D=3D (void *)0 || vma =3D=3D (void *)0 || task->pid !=3D pi=
d)
>> +		return 0;
>> +
>> +	perm_str[0] =3D (vma->flags & VM_READ) ? 'r' : '-';
>> +	perm_str[1] =3D (vma->flags & VM_WRITE) ? 'w' : '-';
>> +	perm_str[1] =3D (vma->flags & VM_EXEC) ? 'x' : '-';
>=20
> typo here? The above should be perm_str[2].

Good catch! Fixing it in the next version.

Song

[...]

