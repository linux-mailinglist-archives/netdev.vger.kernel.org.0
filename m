Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE1444582E
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbhKDRUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:20:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24162 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233473AbhKDRUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 13:20:35 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4GT7pK001845;
        Thu, 4 Nov 2021 10:17:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=qNUVWxFGry4KJedRkp9F6+3s+dhPYI0O6HdPNG3vbKM=;
 b=KRAJjNfVKA9KsLFxIpkd8/oogBKUyrEr8MJmQgQG9kv98EqoDG9qQ+GrtuLuAfULKKoZ
 AcMEjtlETmOr5UgOncZxYe65UQx2WCawM+khShSBn2nGNam5GrMnnh+tsfRfdnL/lmu+
 Dhoi+K4wI5rKYXj7P0eQ6+TjT5+OStWhbyY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3c46b65u5p-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 04 Nov 2021 10:17:57 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 4 Nov 2021 10:17:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aCOw8/lZOjmd8Gvx7yzd8LJ9YhzzsGIB6cESFSCc2a4Q7Abwh+YMtAf3dl1gsc6JUuTRIG1H52Usz4uh6Wak72WLqikwZ4ki1rHCAYQDxLcxxzv0hgWM/YvIcw6yUhpYh+4uiZD8U3RdCnj49ergy1yxMY41xV8hld7An0tzAinLkWjPU4k6+zr8qXmfwAqDgC6mX2s2P0JHrq3osbcTKngIf7AjbtsBkeSF+wUtNW2uvw1HRG5Nm6cn0XmzkNnpzIenRz5/a2+rqjOltnE8y29ibrNmS2JyIbbom/p5sPu9w5JTJvs5kYQdmJzj2vQr2Ay0LZ8Z7+tIvErI6o8z2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qNUVWxFGry4KJedRkp9F6+3s+dhPYI0O6HdPNG3vbKM=;
 b=EM2SB1QCpZmvwO8u8LlaLiAx4/efRRJMd3/hq6tAzl445uwQsZM0bQNfL+zlRR9/NS3RvADAJWZOLeI0vQa8Gl8KDijBqHmPMHHEOn4aJ0F4MckA0uwYWlH/3L0V3FmGIhj2yKxrQlkSDog6/bEoMdyeUy3jRSiAPf/ZfhWu6EGNqc68JANKi4UVkpJ5ANUkaqM86HhTinuFQCJXpUi0LHkVULQACBw8giXKq54MFGXhSn24pIWunNbO1EqXm++JNhyOoGtFpVVKmJ66i0XAIz+2OuRYnsJQ0oWjxQqnRhUH1H7VhMISVIDFVsVJ8fQrK3044a43WVy8blF3ZzDEng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5162.namprd15.prod.outlook.com (2603:10b6:806:235::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Thu, 4 Nov
 2021 17:17:54 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953%9]) with mapi id 15.20.4669.013; Thu, 4 Nov 2021
 17:17:54 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
Subject: Re: [PATCH v2 bpf-next 2/2] selftests/bpf: add tests for bpf_find_vma
Thread-Topic: [PATCH v2 bpf-next 2/2] selftests/bpf: add tests for
 bpf_find_vma
Thread-Index: AQHX0UmlQ3XCQoYYHUK4RXiwBh4LmqvzmkOAgAAC9oA=
Date:   Thu, 4 Nov 2021 17:17:54 +0000
Message-ID: <10CD7450-873D-4136-819B-A1C8F6473E4D@fb.com>
References: <20211104070016.2463668-1-songliubraving@fb.com>
 <20211104070016.2463668-3-songliubraving@fb.com>
 <21d8587f-4a27-2966-167b-fa20b68c1fec@fb.com>
In-Reply-To: <21d8587f-4a27-2966-167b-fa20b68c1fec@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3113a26a-6435-4caf-542f-08d99fb70a01
x-ms-traffictypediagnostic: SA1PR15MB5162:
x-microsoft-antispam-prvs: <SA1PR15MB516233803E59BDC156541951B38D9@SA1PR15MB5162.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WZML9vlVr8FWuvjIAfqI6vU8jlsbAHGe9xzmoX/Hb7BL8Bn1AZuqs9roBf7XPyDncJ0wvYyGTJVnKC9D3KiEgsqG2s5A8tcgx5eK5Ckq0Sk1LaVljdMPNr/bfdr8/T1DyieTuR7Ot1xbiHz1UFka8GbQO0SFOciEXesGrYbGdQXLx9eyAWNEFZxfNpX+BKoeQjpYQq0x4jPgPQqRzxJz2bIs733IEk7G9YTwvfGZ+FUkW3yW68LAZRrV3wOgfVMgRLm6AJ0RYGUVlfOZX+CPMroYhKVpu/GQKCpGnQLJQydkic6zdrD2aYXoQjnA+omv5BoE3n/A1p4lLOsAm7JM06h52BWfGQzwfRz4z6TWXSIa+qUG7NIpMZMa/2FSPGXNi6nCWmF1+rUG6iYTiTZsv45gZcIcagChRIt41s6b29sCYA6P3NRMizGAJd9CigB7s5VHF5jIIax4Zcw5DPgxzX7MWYByjRi9ylInTQkyxvE8nfrYCL0Qn74lSHgd/HZ8gt1N2rDq4FryPh+tG5fB7NdmwYrlZIu0Pi2myxQHN97SxSRb5Vvq890R+e3bS3BaxIYcZX+r5RsmNYHl7V6rgdfD10a8suAzBE3QhBl+TXKRtnug2vMMjgh5MWqWZM0/WtmG0PgNWlp/QmwbyFHWcf6EdsQls4izetGFSXZPITbwdT/z8/13tY4p609waLAxmcM+czI4gBCvem7+ZSbLMZ3evI82cwkPmWofUUtohzHLvhZGX728OFjez6p7q2HR+YiwVRlmOh5SHmq2gwWxVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(38100700002)(122000001)(6486002)(6636002)(33656002)(186003)(66946007)(66446008)(4326008)(6862004)(5660300002)(36756003)(8676002)(64756008)(38070700005)(91956017)(76116006)(66476007)(66556008)(6512007)(6506007)(53546011)(2616005)(2906002)(83380400001)(316002)(86362001)(37006003)(508600001)(71200400001)(54906003)(60764002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XmoqehR/6Y9yqKANmRujW73xcyFYLJXJqzcK9I9Ba9TCkl9rqzs6MB4y+rue?=
 =?us-ascii?Q?sBAviHhlFwqOr2UAUhu0p1GpuwdO4rRY7cNFb0ocyLXs348S+kjgQsP4wPuB?=
 =?us-ascii?Q?cc6EHVzlF73raQLMIIOzTy5KQsgNq7W+R8+bFmOyiGae12LHVm+4sV4K2Kr5?=
 =?us-ascii?Q?LY3ZOdQluCJJqYKpwhcMCynkO6jm0X400YPyqA37+Qw1CYAxUqL7my+Pw6y6?=
 =?us-ascii?Q?A2Fh2JSDl3up7Tbplp0zlcYbVAIugvVR51M7LjpL1ixB+0SN6MFxBpoUjMBI?=
 =?us-ascii?Q?fd0pylUBnC/zhtPPmUl1cwcA1NGw+fa559VKCMCIkZi1FrVCU+QvTtdxhJOE?=
 =?us-ascii?Q?auGv2HuooAX7Fb+9efc1N5W7gmZnMVvlfpWt0dR1GK8LIMyvmaLqnhH446gY?=
 =?us-ascii?Q?LuNJ5dAecZ2KcQ63u76U8eDUiDWHd0qFEhPpuw/5rubKKi/avlnpWubPMF4N?=
 =?us-ascii?Q?EiJbQelvgneN2v3OacUT/6T5Vkyri1zLxG4ePoqL1AEj6hhXqEyFOBRTKvvq?=
 =?us-ascii?Q?pCdu2zoHtUk2PajTmVx3S3nnuEu6XOFQFloSFszLC57PgSfjWQTYbPbg+s7k?=
 =?us-ascii?Q?MED328wdd1RxARXBvecUbgBtv8DvrP9RnIBFx0pi44TmQyGlhg3rySPhLihb?=
 =?us-ascii?Q?aG99mLeOQlMdxEBEnNV/LUqGMDgT888uPsEOCGEzUuY6mUwSg28BI6zMZJo1?=
 =?us-ascii?Q?KnW8V0NIkPiuNiGLX44R+azlBFEg56tX5tbPCXyp23PA+pUkU32A1NbXZ3tg?=
 =?us-ascii?Q?vxkJEKuSPc87mrs+hqmR4RgFuGBg4uJXVDdOiG2jPihHh4OxAXKgrwAflXgh?=
 =?us-ascii?Q?Flz8tF8Y6FM3Qc3FaqJDSUf5wPa/mCYoQqrGqiF1VLbl9Z5qOMWHb1fyXzGP?=
 =?us-ascii?Q?eBUjfRZN7jAt+3HKpuLxKrVvtxIHCGf0FvMlkBh9YUtJ8V8WIoFbA9Wxskh5?=
 =?us-ascii?Q?69pbhJRBHafZ6Pw+V6gfkx6q6v3H5XLu6zaQE+3o+xayMS/3+byj4gkaDjqm?=
 =?us-ascii?Q?2UwNMzWHNI2iMbQBGMTsZPaLLmQCeS7pb563Nw0bxDY4ooBbvneb0E3JiYN3?=
 =?us-ascii?Q?Uf5ar7s9Opr0EYW9fiZWlearByyZr24XaisJZe/ywksW/N6EmMtrpDWsMhIC?=
 =?us-ascii?Q?VRPz0V1+ysXwFubuGMBpduhdMfA/SnsMdRPdwe1FJb7ijNsPS3wkZaiYdP3K?=
 =?us-ascii?Q?cYI+ZtoPHhXnG/BTtzGQ7XCZk0mjUhKW614GNZVnLx0OYO07aQu7JD9Jma/M?=
 =?us-ascii?Q?5BVD4EuCyINjqKnPAv0j1HIaKHv+9XAcBxsvuCdDh68tlKx3jUHgpxB/2LfY?=
 =?us-ascii?Q?tT7xzA1dG6Z9ZBpbt7Jgx5YUzY+4m+QmFx3waKAvMcD39A441aC/HfJMHg6d?=
 =?us-ascii?Q?Vl4f/ZThR3zRsVmcYX0wLcjl4/+ySP/V9hOfvPYQbbkRttAsWPIT6ieJUU80?=
 =?us-ascii?Q?r3VmmQug5slqPEIOWLsHWaNQVOrM3Ohj6sxqOzSlYfRS35pntNPk3qJ9z6mt?=
 =?us-ascii?Q?1hi3D5tGXxqFDTJmc9KD0MM5t14Bdd1xVPiAQzmMEeJ2FCTmRGa2gzXeyYGT?=
 =?us-ascii?Q?qUVfsWHoQn5E/C/D0csJK1aXO1G3ctKvcMP0xQOHreBHU9CqDCVC9+topH9v?=
 =?us-ascii?Q?CMMm4xWLwr+VVXtYuEyExe+nEQxMXqup803ZusiJwYQs/5k/MoaTMGpuQSIj?=
 =?us-ascii?Q?vUjDtA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1B38CA190F4A5C4899705A48AFA8D90D@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3113a26a-6435-4caf-542f-08d99fb70a01
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 17:17:54.4201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5+UnMPkhB+Mq6oNcyxJHEdGCKHKZ7bl2hVtsfEYj2/t7tuhIojuUZAkk8l7/ufTwqAGElZ5F19M0DhnshAnNOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5162
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: qN21vVWVIzhyQNq1zsaUfEDQ7hT0yG5Q
X-Proofpoint-GUID: qN21vVWVIzhyQNq1zsaUfEDQ7hT0yG5Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_05,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 spamscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040066
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 4, 2021, at 10:07 AM, Yonghong Song <yhs@fb.com> wrote:
> 
> 
> 
> On 11/4/21 12:00 AM, Song Liu wrote:
>> Add tests for bpf_find_vma in perf_event program and kprobe program. The
>> perf_event program is triggered from NMI context, so the second call of
>> bpf_find_vma() will return -EBUSY (irq_work busy). The kprobe program,
>> on the other hand, does not have this constraint.
>> Also add test for illegal writes to task or vma from the callback
>> function. The verifier should reject both cases.
>> Signed-off-by: Song Liu <songliubraving@fb.com>

[...]

>> +static void test_find_vma_pe(struct find_vma *skel)
>> +{
>> +	struct bpf_link *link = NULL;
>> +	volatile int j = 0;
>> +	int pfd = -1, i;
>> +
>> +	pfd = open_pe();
>> +	if (pfd < 0) {
>> +		if (pfd == -ENOENT || pfd == -EOPNOTSUPP) {
>> +			printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n", __func__);
>> +			test__skip();
>> +		}
>> +		if (!ASSERT_GE(pfd, 0, "perf_event_open"))
>> +			goto cleanup;
>> +	}
>> +
>> +	link = bpf_program__attach_perf_event(skel->progs.handle_pe, pfd);
>> +	if (!ASSERT_OK_PTR(link, "attach_perf_event"))
>> +		goto cleanup;
>> +
>> +	for (i = 0; i < 1000000; ++i)
>> +		++j;
> 
> Does this really work? Compiler could do
>  j += 1000000;

I think compiler won't do it with volatile j? 

> 
>> +
>> +	test_and_reset_skel(skel, -EBUSY /* in nmi, irq_work is busy */);
>> +cleanup:
>> +	bpf_link__destroy(link);
>> +	close(pfd);
>> +	/* caller will clean up skel */
> 
> Above comment is not needed. It should be clear from the code.
> 
>> +}
>> +
>> +static void test_find_vma_kprobe(struct find_vma *skel)
>> +{
>> +	int err;
>> +
>> +	err = find_vma__attach(skel);
>> +	if (!ASSERT_OK(err, "get_branch_snapshot__attach"))
>> +		return;  /* caller will cleanup skel */
>> +
>> +	getpgid(skel->bss->target_pid);
>> +	test_and_reset_skel(skel, -ENOENT /* could not find vma for ptr 0 */);
>> +}
>> +
>> +static void test_illegal_write_vma(void)
>> +{
>> +	struct find_vma_fail1 *skel;
>> +
>> +	skel = find_vma_fail1__open_and_load();
>> +	ASSERT_ERR_PTR(skel, "find_vma_fail1__open_and_load");
>> +}
>> +
>> +static void test_illegal_write_task(void)
>> +{
>> +	struct find_vma_fail2 *skel;
>> +
>> +	skel = find_vma_fail2__open_and_load();
>> +	ASSERT_ERR_PTR(skel, "find_vma_fail2__open_and_load");
>> +}
>> +
>> +void serial_test_find_vma(void)
>> +{
>> +	struct find_vma *skel;
>> +
>> +	skel = find_vma__open_and_load();
>> +	if (!ASSERT_OK_PTR(skel, "find_vma__open_and_load"))
>> +		return;
>> +
>> +	skel->bss->target_pid = getpid();
>> +	skel->bss->addr = (__u64)test_find_vma_pe;
>> +
>> +	test_find_vma_pe(skel);
>> +	usleep(100000); /* allow the irq_work to finish */
>> +	test_find_vma_kprobe(skel);
>> +
>> +	find_vma__destroy(skel);
>> +	test_illegal_write_vma();
>> +	test_illegal_write_task();
>> +}
>> diff --git a/tools/testing/selftests/bpf/progs/find_vma.c b/tools/testing/selftests/bpf/progs/find_vma.c
>> new file mode 100644
>> index 0000000000000..2776718a54e29
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/find_vma.c
>> @@ -0,0 +1,70 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2021 Facebook */
>> +#include "vmlinux.h"
>> +#include <bpf/bpf_helpers.h>
>> +#include <bpf/bpf_tracing.h>
>> +
>> +char _license[] SEC("license") = "GPL";
>> +
>> +struct callback_ctx {
>> +	int dummy;
>> +};
>> +
>> +#define VM_EXEC		0x00000004
>> +#define DNAME_INLINE_LEN 32
>> +
>> +pid_t target_pid = 0;
>> +char d_iname[DNAME_INLINE_LEN] = {0};
>> +__u32 found_vm_exec = 0;
>> +__u64 addr = 0;
>> +int find_zero_ret = -1;
>> +int find_addr_ret = -1;
>> +
>> +static __u64
> 
> Let us 'long' instead of '__u64' to match uapi bpf.h.
> 
>> +check_vma(struct task_struct *task, struct vm_area_struct *vma,
>> +	  struct callback_ctx *data)
>> +{
>> +	if (vma->vm_file)
>> +		bpf_probe_read_kernel_str(d_iname, DNAME_INLINE_LEN - 1,
>> +					  vma->vm_file->f_path.dentry->d_iname);
>> +
>> +	/* check for VM_EXEC */
>> +	if (vma->vm_flags & VM_EXEC)
>> +		found_vm_exec = 1;
>> +
>> +	return 0;
>> +}
>> +
>> +SEC("kprobe/__x64_sys_getpgid")
> 
> The test will fail for non x86_64 architecture.
> I had some tweaks in test_probe_user.c. Please take a look.
> We can refactor to make tweaks in test_probe_user.c reusable
> by other files.

Good point. I will look into this. 

> 
>> +int handle_getpid(void)
>> +{
>> +	struct task_struct *task = bpf_get_current_task_btf();
>> +	struct callback_ctx data = {0};
>> +
>> +	if (task->pid != target_pid)
>> +		return 0;
>> +
>> +	find_addr_ret = bpf_find_vma(task, addr, check_vma, &data, 0);
>> +
>> +	/* this should return -ENOENT */
>> +	find_zero_ret = bpf_find_vma(task, 0, check_vma, &data, 0);
>> +	return 0;
>> +}
>> +
>> +SEC("perf_event")
>> +int handle_pe(void)
>> +{
>> +	struct task_struct *task = bpf_get_current_task_btf();
>> +	struct callback_ctx data = {0};
>> +
>> +	if (task->pid != target_pid)
>> +		return 0;
> 
> This is tricky. How do we guarantee task->pid == target_pid hit?
> This probably mostly okay in serial running mode. But it may
> become more challenging if test_progs is running in parallel mode?

This is on a per task perf_event, so it shouldn't hit other tasks. 

> 
>> +
>> +	find_addr_ret = bpf_find_vma(task, addr, check_vma, &data, 0);
>> +
>> +	/* In NMI, this should return -EBUSY, as the previous call is using
>> +	 * the irq_work.
>> +	 */
>> +	find_zero_ret = bpf_find_vma(task, 0, check_vma, &data, 0);
>> +	return 0;
>> +}
>> diff --git a/tools/testing/selftests/bpf/progs/find_vma_fail1.c b/tools/testing/selftests/bpf/progs/find_vma_fail1.c
>> new file mode 100644
>> index 0000000000000..d17bdcdf76f07
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/find_vma_fail1.c
>> @@ -0,0 +1,30 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2021 Facebook */
>> +#include "vmlinux.h"
>> +#include <bpf/bpf_helpers.h>
>> +
>> +char _license[] SEC("license") = "GPL";
>> +
>> +struct callback_ctx {
>> +	int dummy;
>> +};
>> +
>> +static __u64
> 
> __u64 => long
> 
>> +write_vma(struct task_struct *task, struct vm_area_struct *vma,
>> +	  struct callback_ctx *data)
>> +{
>> +	/* writing to vma, which is illegal */
>> +	vma->vm_flags |= 0x55;
>> +
>> +	return 0;
>> +}
>> +
>> +SEC("kprobe/__x64_sys_getpgid")
>> +int handle_getpid(void)
>> +{
>> +	struct task_struct *task = bpf_get_current_task_btf();
>> +	struct callback_ctx data = {0};
>> +
>> +	bpf_find_vma(task, 0, write_vma, &data, 0);
>> +	return 0;
>> +}
>> diff --git a/tools/testing/selftests/bpf/progs/find_vma_fail2.c b/tools/testing/selftests/bpf/progs/find_vma_fail2.c
>> new file mode 100644
>> index 0000000000000..079c4594c095d
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/find_vma_fail2.c
>> @@ -0,0 +1,30 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2021 Facebook */
>> +#include "vmlinux.h"
>> +#include <bpf/bpf_helpers.h>
>> +
>> +char _license[] SEC("license") = "GPL";
>> +
>> +struct callback_ctx {
>> +	int dummy;
>> +};
>> +
>> +static __u64
> 
> __u64 => long
> 
>> +write_task(struct task_struct *task, struct vm_area_struct *vma,
>> +	   struct callback_ctx *data)
>> +{
>> +	/* writing to task, which is illegal */
>> +	task->mm = NULL;
>> +
>> +	return 0;
>> +}
>> +
>> +SEC("kprobe/__x64_sys_getpgid")
>> +int handle_getpid(void)
>> +{
>> +	struct task_struct *task = bpf_get_current_task_btf();
>> +	struct callback_ctx data = {0};
>> +
>> +	bpf_find_vma(task, 0, write_task, &data, 0);
>> +	return 0;
>> +}

