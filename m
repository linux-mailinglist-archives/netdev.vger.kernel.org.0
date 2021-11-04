Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C404458B1
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbhKDRjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:39:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39414 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233972AbhKDRjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 13:39:40 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4H8E6d032003;
        Thu, 4 Nov 2021 10:37:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=XJHYdBGudsk1sxjaBeppgzpZ2oN3qImgcEZX1MgQ6r4=;
 b=TEZXhlcVZNKTSBxZ4biyhZIj74tOMZY0gFOH1N3I+e9yPgI7Gs1XVaAgGZGZu2n9H4P4
 XeY1PsVKwoYc2U4Bw78Hk0ySWOBMk32rCi1/zw42Pw2QfhR/sWa13CNN20Y8Bh5U5Mh+
 lSevJ6F3Wzugd7T7SU28YWgRKDXXRNt1uGs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3c485a5k2g-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 04 Nov 2021 10:37:01 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 4 Nov 2021 10:37:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KjWx3ZxbmsM+ibFZXPy3cBB+kxDD+zuSJ5Pe+dO5cmrStbJ1JQIlDbSxAGPRKD2S4XCZayj9Mx+omA2nBLQUVEA+/6JfZwKxNBd4edysAAKhUYmat5Ex+SwaCcQcSoxpkHDqeb2fyTvvtltr6fXxv24XDZP78hEfC2eUgwVM3vC4UUJhQXjpOQTGmRR8xokY1nI6QxHD0ly48kjAPZWESWhXEezWm/yy+D018q1VG108YMH6K3eiXmcVpfF36p9SnULgeJj9bpLyhHhgipL56KzcHxjmYR/kb7q5ygaIRt3I+m25oC4WjzTpw2sYpJ4J/Fayw1zGE6O6nzNF8nl1zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XJHYdBGudsk1sxjaBeppgzpZ2oN3qImgcEZX1MgQ6r4=;
 b=F/5LYop2k9i5q5ANAdNaFXsp/T5IIstOcC/XdVZ7jothJc1ICd/CcDpz4uHm2uEv/lOba2xnV1A09lso1pRX9+oX2Qakn6R71Ft7Cnw2XftqHZBnUGidejtYuamRZcCTBkd0OdsR+heCGwuaXUBvQbmbv/I1hzgo/DT+ndc+uPnFzl44mFoZRPnCjGK5YV4jsnHNVXoia25aPhZKX0CyaucqEdCVmJwFs1PE7BAWrZku4SYApqECnhU+IAi80baTKzH7b0mYPhBhnl06SvkW4PMcy2MyjFuAlvmL58usw1sum6q8rYMTMMiRURyIXWJMefOmo9Vo3isS8R17q+8ANg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5185.namprd15.prod.outlook.com (2603:10b6:806:235::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17; Thu, 4 Nov
 2021 17:36:59 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953%9]) with mapi id 15.20.4669.013; Thu, 4 Nov 2021
 17:36:59 +0000
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
Thread-Index: AQHX0UmlQ3XCQoYYHUK4RXiwBh4LmqvzmkOAgAAC9oCAAAVVAA==
Date:   Thu, 4 Nov 2021 17:36:59 +0000
Message-ID: <1F7835B6-2B7D-4A82-AB91-D4D6569662D8@fb.com>
References: <20211104070016.2463668-1-songliubraving@fb.com>
 <20211104070016.2463668-3-songliubraving@fb.com>
 <21d8587f-4a27-2966-167b-fa20b68c1fec@fb.com>
 <10CD7450-873D-4136-819B-A1C8F6473E4D@fb.com>
In-Reply-To: <10CD7450-873D-4136-819B-A1C8F6473E4D@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74d3006e-5c40-4c00-5e17-08d99fb9b445
x-ms-traffictypediagnostic: SA1PR15MB5185:
x-microsoft-antispam-prvs: <SA1PR15MB51853C9E529B5296F2E9C74BB38D9@SA1PR15MB5185.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J+11Z4pkdIYxV/L0xPxSlhrrEGQ0YgBhGDNlnrJW0Usf8iEU0LegvtvUcEV3rfWyj2GRHuqYhoPo4sEaFY8TgzaHKWg4uIgqHBODq8+ujrmbkQn9bU4Ufv55AdaHfxSQU6Jad77N3bbpUidAM7wAfwOoEzTGAhtwnpTsskPMOsdbmPBrUmGNT0jJmuFSEZsCVhxav2urodgXz2ykwrzSozN28+6gA+w/xehOgzlqzpIRoA3d2QFUEj5DF1S4omXOZXMiyTvK4Dc1m2m5SiROdIchJsXxkTkUnRAoN6QHkGIwiE/hBqCfMMimAdPcgKRc2jZHXrTSXuaFvyk6KYVALJtM0lUDn+3fo+Ux+uP+iH9yMSJCCHZ7TUB8MmuKKpm090e7GsI4adtE/tCxiKXYwpuAIPdTOmkSZ8cFsfpBEER131CwNR0K39fnwuHrBR70PgOs0/wyyC4stRroA+V2UODoTeX8KxKIaM8ny52WLWvFd4n75GRItja7IrCjc/q4zkMXNEQpLVakw30Ad4iKxOn0Ud9mseESOvQ5V4SF6UOckXCVJvVERFVKH1avfC+K2p5Z1VF1MdvMzakU7j7aV+/zFz4KPRStUTwhPL/YJ9hojPVX3fxE6mRbTd0UJ+fCAk4+iTXM/N//Phb0DSaD+DUw1XyP7J4yM8wWtRuhOxrXePFtOhMB6nnkyfCshFa6HcSZlxHw4SdAbdnsk4eLmxLhU/jdczzrUiD0hSo/hKyKIqx4+o71dJCefwNGWkQJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(6506007)(38070700005)(508600001)(6862004)(4326008)(53546011)(186003)(6512007)(5660300002)(33656002)(6486002)(86362001)(54906003)(83380400001)(66946007)(38100700002)(8676002)(66556008)(64756008)(66446008)(36756003)(122000001)(71200400001)(91956017)(76116006)(2906002)(8936002)(6636002)(37006003)(316002)(66476007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1VMpz436Ay9KQv+GPWkRcfuzKtC+M49ddmsOLR1VCS80T2M8LiGMbo2qZy8B?=
 =?us-ascii?Q?ZG9cXiq0gTj/IA7C95jo4EaTh6SJubm+e++7BXzhp0avbH+DDlm2HqzIkiZ8?=
 =?us-ascii?Q?dbAX5BJs3yHQOuC8w97nK2uN7xAVxmqdJFzp3qcn4wicWzUs+cwZxLX6QvBc?=
 =?us-ascii?Q?OiIEmWQGkR2VVU39VZxTtCC8RxKX80IR+kSL57FiiUDtkYcdvJDaG8hNd9Xr?=
 =?us-ascii?Q?t35aUTNWD72KlD5X7sxRT0GdL2FQ005L8vWK+I/iY+8xyq6OBJM1Yhs9TfdW?=
 =?us-ascii?Q?+rtCSBZIA4dm5DdNKF9oV7tsvsgTD7Dp4zRVI8YMKGMbQ8k2CM9jesJnOV3e?=
 =?us-ascii?Q?HSHpfLG6WygqaBCzY03/arNXWTGmkvvSOpW10zCh7ni1ZJtr3NhZEL+I54z5?=
 =?us-ascii?Q?vsogOG1gj2iKP2zMd3s6UUfcO9tx3wKje5saJDvOKzFeZqF+wvHmjz2raQyR?=
 =?us-ascii?Q?uWMV36Awke/s4jteYNuWG+nQ0/e1ixIw5O0JoJeKvNrr+BB8JGwn/+fRujAl?=
 =?us-ascii?Q?Gdgrfb57P8Ca2Au1bu4qKPSVchgyGREjvYF764Y/BMs57kWOsqd4u+AEYFCl?=
 =?us-ascii?Q?AVEqcH+SF0Ml8R/CbV22nWXy0gLCnHhZhGsnxGbuQvLoVGBnT9waMHb2EafN?=
 =?us-ascii?Q?u+Q+ks17AMIW2gqSDRjUeRwZ5H7PgC1hOYtrQh5oYr+jFGElZFqy+kmW/JOT?=
 =?us-ascii?Q?BdR3is5i5W6yqfDOKEYf6jLlDl9shzEv/Zyei6M0CGOPCX9C/LKxyvZ5MoF8?=
 =?us-ascii?Q?sEB79/mTjk7N6rBUeZbwAR66kkzTlPWSlzErbZJ49+6Snk34DhjaPpmclg2t?=
 =?us-ascii?Q?JHcIbyA+4GsDcF1DEq3ibb8upDipj7BQSpowN6H5znrs5nz+PFEy7Quol5FC?=
 =?us-ascii?Q?YBlXiu6iR1XAA/XashlnHG+sKPYLzHNdSUt84RBhgYdLlYgbe7yfbJxH4Wsm?=
 =?us-ascii?Q?DQAzaSivBxFNP3yl3ZTpi6rRsCEgjnLFKBJdKkct26+SRM5PCnvu71KKLmpM?=
 =?us-ascii?Q?0IJOuaeWhp+5RYYRK1MgDbCjzQ0oifIcLj6HxabsXhkdFpTMCKOReP/He7ir?=
 =?us-ascii?Q?6BlUJ2rdSan6+QdVqtPcyU+HG0jJ/+Oqs4vyENYbLLfclSMlfSjEy1bfXA0T?=
 =?us-ascii?Q?BAmxEv7ZMjohYBuSZRyQ1SuyYqwqdxbOo2aVHxsKnCwO2Wbxd1BBzc/BPTc2?=
 =?us-ascii?Q?Vgl1BwVxZqPt/wRiNtzmRUUUy+QT7rIBFLtgmNKAXjaRY5ukKRt0HJTXKjDC?=
 =?us-ascii?Q?/ugOkqHXU2U1DG1NzcsSGd8Oapf+XPkUoAiBk+Z9eLfHMchJ+/JyktLmoFz9?=
 =?us-ascii?Q?M9XHYMNCJ2kzIADaf3BYdiuzZOa73RTwdIft66Os+HuUHIXg4o5ssw08gV21?=
 =?us-ascii?Q?i/W4jRX1cZP777aHTmgNYF90bKoDu3QkZxvaZb3uCnSCGPzJVc0KFZl1asPx?=
 =?us-ascii?Q?e0gpsv1u1R8pooULLu/tIIc68l521mkqi/uPUtm22IvKht0Kc/IHEhBAAhOo?=
 =?us-ascii?Q?zWMlJwcv2A6dA4X75YWhmW3XTzLo55nZNQSGh9stRquz1+H9xb6qOvib/32t?=
 =?us-ascii?Q?fVWkjANqinO4vCr0/yLiTV6ZPhOtP+p9gKwrt5l4G96FQbaTcseayXBNv1xo?=
 =?us-ascii?Q?DLCuV7tl/lsSSqfHf/m+6aXnYvtITUaU5aWI1xrCBoXWxmUUZepTiSh+TAHh?=
 =?us-ascii?Q?HoOiwQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D408A8B682C3874BA7BC5AF32EBED9FD@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74d3006e-5c40-4c00-5e17-08d99fb9b445
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 17:36:59.1100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LoOLco8Z+ogm4mXeTAb+vywbGWD/eSPLX4A/DR9mVhfFf76mWmYOFiI5gTjjNcUf5pTEpIaXok0mlejpoM1xxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5185
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Hfxvp1BQ64yd0iVTQpslsNCvwORx_DOB
X-Proofpoint-GUID: Hfxvp1BQ64yd0iVTQpslsNCvwORx_DOB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_05,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 adultscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040067
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 4, 2021, at 10:17 AM, Song Liu <songliubraving@fb.com> wrote:
> 
> 
> 
>> On Nov 4, 2021, at 10:07 AM, Yonghong Song <yhs@fb.com> wrote:
>> 
>> 
>> 
>> On 11/4/21 12:00 AM, Song Liu wrote:
>>> Add tests for bpf_find_vma in perf_event program and kprobe program. The
>>> perf_event program is triggered from NMI context, so the second call of
>>> bpf_find_vma() will return -EBUSY (irq_work busy). The kprobe program,
>>> on the other hand, does not have this constraint.
>>> Also add test for illegal writes to task or vma from the callback
>>> function. The verifier should reject both cases.
>>> Signed-off-by: Song Liu <songliubraving@fb.com>
> 
> [...]
> 
>>> +static void test_find_vma_pe(struct find_vma *skel)
>>> +{
>>> +	struct bpf_link *link = NULL;
>>> +	volatile int j = 0;
>>> +	int pfd = -1, i;
>>> +
>>> +	pfd = open_pe();
>>> +	if (pfd < 0) {
>>> +		if (pfd == -ENOENT || pfd == -EOPNOTSUPP) {
>>> +			printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n", __func__);
>>> +			test__skip();
>>> +		}
>>> +		if (!ASSERT_GE(pfd, 0, "perf_event_open"))
>>> +			goto cleanup;
>>> +	}
>>> +
>>> +	link = bpf_program__attach_perf_event(skel->progs.handle_pe, pfd);
>>> +	if (!ASSERT_OK_PTR(link, "attach_perf_event"))
>>> +		goto cleanup;
>>> +
>>> +	for (i = 0; i < 1000000; ++i)
>>> +		++j;
>> 
>> Does this really work? Compiler could do
>> j += 1000000;
> 
> I think compiler won't do it with volatile j? 
> 
>> 
>>> +
>>> +	test_and_reset_skel(skel, -EBUSY /* in nmi, irq_work is busy */);
>>> +cleanup:
>>> +	bpf_link__destroy(link);
>>> +	close(pfd);
>>> +	/* caller will clean up skel */
>> 
>> Above comment is not needed. It should be clear from the code.
>> 
>>> +}
>>> +
>>> +static void test_find_vma_kprobe(struct find_vma *skel)
>>> +{
>>> +	int err;
>>> +
>>> +	err = find_vma__attach(skel);
>>> +	if (!ASSERT_OK(err, "get_branch_snapshot__attach"))
>>> +		return;  /* caller will cleanup skel */
>>> +
>>> +	getpgid(skel->bss->target_pid);
>>> +	test_and_reset_skel(skel, -ENOENT /* could not find vma for ptr 0 */);
>>> +}
>>> +
>>> +static void test_illegal_write_vma(void)
>>> +{
>>> +	struct find_vma_fail1 *skel;
>>> +
>>> +	skel = find_vma_fail1__open_and_load();
>>> +	ASSERT_ERR_PTR(skel, "find_vma_fail1__open_and_load");
>>> +}
>>> +
>>> +static void test_illegal_write_task(void)
>>> +{
>>> +	struct find_vma_fail2 *skel;
>>> +
>>> +	skel = find_vma_fail2__open_and_load();
>>> +	ASSERT_ERR_PTR(skel, "find_vma_fail2__open_and_load");
>>> +}
>>> +
>>> +void serial_test_find_vma(void)
>>> +{
>>> +	struct find_vma *skel;
>>> +
>>> +	skel = find_vma__open_and_load();
>>> +	if (!ASSERT_OK_PTR(skel, "find_vma__open_and_load"))
>>> +		return;
>>> +
>>> +	skel->bss->target_pid = getpid();
>>> +	skel->bss->addr = (__u64)test_find_vma_pe;
>>> +
>>> +	test_find_vma_pe(skel);
>>> +	usleep(100000); /* allow the irq_work to finish */
>>> +	test_find_vma_kprobe(skel);
>>> +
>>> +	find_vma__destroy(skel);
>>> +	test_illegal_write_vma();
>>> +	test_illegal_write_task();
>>> +}
>>> diff --git a/tools/testing/selftests/bpf/progs/find_vma.c b/tools/testing/selftests/bpf/progs/find_vma.c
>>> new file mode 100644
>>> index 0000000000000..2776718a54e29
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/bpf/progs/find_vma.c
>>> @@ -0,0 +1,70 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/* Copyright (c) 2021 Facebook */
>>> +#include "vmlinux.h"
>>> +#include <bpf/bpf_helpers.h>
>>> +#include <bpf/bpf_tracing.h>
>>> +
>>> +char _license[] SEC("license") = "GPL";
>>> +
>>> +struct callback_ctx {
>>> +	int dummy;
>>> +};
>>> +
>>> +#define VM_EXEC		0x00000004
>>> +#define DNAME_INLINE_LEN 32
>>> +
>>> +pid_t target_pid = 0;
>>> +char d_iname[DNAME_INLINE_LEN] = {0};
>>> +__u32 found_vm_exec = 0;
>>> +__u64 addr = 0;
>>> +int find_zero_ret = -1;
>>> +int find_addr_ret = -1;
>>> +
>>> +static __u64
>> 
>> Let us 'long' instead of '__u64' to match uapi bpf.h.
>> 
>>> +check_vma(struct task_struct *task, struct vm_area_struct *vma,
>>> +	  struct callback_ctx *data)
>>> +{
>>> +	if (vma->vm_file)
>>> +		bpf_probe_read_kernel_str(d_iname, DNAME_INLINE_LEN - 1,
>>> +					  vma->vm_file->f_path.dentry->d_iname);
>>> +
>>> +	/* check for VM_EXEC */
>>> +	if (vma->vm_flags & VM_EXEC)
>>> +		found_vm_exec = 1;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +SEC("kprobe/__x64_sys_getpgid")
>> 
>> The test will fail for non x86_64 architecture.
>> I had some tweaks in test_probe_user.c. Please take a look.
>> We can refactor to make tweaks in test_probe_user.c reusable
>> by other files.
> 
> Good point. I will look into this. 

Actually, we can just use SEC("raw_tp/sys_enter") here. 

Thanks,
Song

