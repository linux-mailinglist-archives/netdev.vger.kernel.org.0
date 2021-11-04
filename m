Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A58445712
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 17:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbhKDQVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 12:21:15 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3964 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231806AbhKDQVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 12:21:12 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4E7WCC014777;
        Thu, 4 Nov 2021 09:18:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=3Nhm8fgc6ZeL1mJ0MMgAY2yD3ykOlL47nMU2ykQHEMU=;
 b=ObJj+tAGu354lBIEQEBKmMaQnTnO2rMaLgLdjb+q3CvrOWrwkRtsOhVmFz/qHDz41guT
 Hdk2rAG0vMtS91wwmbWfgnvq6NnXy0LQlyZW5r+E7K85HF+5MJi4oUVRIiurJbCvB/kL
 EYlH3IqAvR7CHXvMoBFG1iOkoYHc0TUoFtY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3c43a4pbdq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 04 Nov 2021 09:18:34 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 4 Nov 2021 09:18:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGko2Rxvip0/g0HyWOwivo477KdbbxalWUU2K6Q9VYczH/aWoVwDKFGp+MopSNLHT79CeNbQK4DpmY3TCbUAdKAbn61joksZFxreo6BHUUd/UMwuguUayyW7kQqSjGBv2Dwrm7v5HdSLNYd2vHiWjEmhnmV6OmQOqeQeohYhZ9pAND8wGirn30dyJlDccAwqZrC4bUcVLkQMfI1+/meywJC/ltiZiSlz+zTOtKZ7XoxF/5zStvPFnwucWRgxAHbDuQ7JhFEfVaE0p5tAc6dLr+HpK/D+0Mw8N8XIBhaHamzIQtQQfRDUYABVjQRHEchi3jPHgEr1IKzsHha+3eZVTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Nhm8fgc6ZeL1mJ0MMgAY2yD3ykOlL47nMU2ykQHEMU=;
 b=XTo734/zDDidLP5lBty1+e8r2eTfBOW3Atyx0Zlscd8sFBbRXjZDKR5ueueE3F4z1YhLtqFa29ATK7vvNQ9laVf3zf1T13tLgtQWtccwSjW0AUA1PA9wXos3+vVXtj+/ajzVnPvlvLUpZWXk/UVM1Ztwz9539FjEeX6xLaZ28SKGCNWxvgkTUE5DK6a0UpXKCievMvSxEIOWR168Ck69465GuFYLz4uVmKuluInZQLTrzhZjcRztvWm6sNdPI/eMydDLO22v4u8wj48S9lbgia9oZqzrfEUod0PjYhw7/ox3SPRV6R4n/a8YOot/FN+RUNpomUSLmk3nNPXSj3Ol9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5162.namprd15.prod.outlook.com (2603:10b6:806:235::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Thu, 4 Nov
 2021 16:18:30 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953%9]) with mapi id 15.20.4669.013; Thu, 4 Nov 2021
 16:18:29 +0000
From:   Song Liu <songliubraving@fb.com>
To:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
Subject: Re: [PATCH v2 bpf-next 2/2] selftests/bpf: add tests for bpf_find_vma
Thread-Topic: [PATCH v2 bpf-next 2/2] selftests/bpf: add tests for
 bpf_find_vma
Thread-Index: AQHX0UmlQ3XCQoYYHUK4RXiwBh4LmqvzjKAA
Date:   Thu, 4 Nov 2021 16:18:29 +0000
Message-ID: <683021D3-2B7D-4721-AB24-9D5E58E5A20C@fb.com>
References: <20211104070016.2463668-1-songliubraving@fb.com>
 <20211104070016.2463668-3-songliubraving@fb.com>
In-Reply-To: <20211104070016.2463668-3-songliubraving@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d058497-80e0-4fa5-6bc6-08d99faebd5b
x-ms-traffictypediagnostic: SA1PR15MB5162:
x-microsoft-antispam-prvs: <SA1PR15MB51620FCAFA0DB924F40F1A19B38D9@SA1PR15MB5162.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3yXJJ2HOpsmUxyg/ZLKbNND9Zsxghk45Uw+8XmAqHfeTYrsF1wzdNue//e+nFKhh1iki1+kftmDhN6IYWSeH2bIRleczLgIi9XNjQwd6WwzNRgYrU1sMxKkGM8dqs6YTeruyVt7p3rfD1mQHgCgCuIub6FF5YKNMnSlN9z442YokTlH/9mwWZD6NF0lPcm60tkMwFRsV8ZPH+J5lX5REgX/fTdm2MUWFWj61+Z3X+vnEL1R0YyTrKNkcEvXwVIjXH9YWVav4w8okBtCrK0ZSTosD20m4BthsXi6N1dQnBudSDfsDU1GXCGCZhj38wDdCmvz4ncBO1y9QR1wBQ++4Dr01zW4r/hkjGK+jCtKJIRb7rg1Z0XWCCtm3B1hk0AKw/MzLpn4SMLdcsuiiasLSgsnnfJ6uOUjpmx7s3YtBel7UqTNx2senfC3fr9I9zJWsqn7me0NAsh1dIv3UhipScm3QgMDWVKS8fsDYEP0/IOTn5ukYrryRp3QLTtjb7aIS7Uy+fqTnlVF8NxyiuhqYokp8R/GATKLo+/b8zl3cDonsCB3lqa6T5hVhtJM6OW1af6q5GFnEWwKlFP4qCucuvUhKUuh5LPp8ROHqyKTTVswL7crC3Fz75rRpaIO6uSYlZEQ1cZDO5EL6ZAIUSLUnzbwWIMSgn44r5Svg90s3xA5KCyR4iH1eGA1g+0+yWBRCQm3u7EdNoIG+U1pl5Gu2U7hEFSlmLfxDDWOJMGYNpIpWNwCnIRARULP1gjy6spJ+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(38100700002)(122000001)(6486002)(33656002)(186003)(66946007)(66446008)(4326008)(76116006)(5660300002)(36756003)(8676002)(64756008)(38070700005)(91956017)(66476007)(66556008)(6506007)(6512007)(53546011)(2616005)(2906002)(83380400001)(316002)(86362001)(110136005)(508600001)(54906003)(71200400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fMA1o50Nb3lQZK1Fsq1pr1Z8kZZk5k7BfiyoBpayy77UM9ng7fLSw7HnIJL7?=
 =?us-ascii?Q?TybeeEQ+bayw2OSJPcuvmgDfqEFVwZXHRk9snThywdwwfcCInpK7uzgYGD/D?=
 =?us-ascii?Q?448jeSx8vLfLadKOmCdPksU65dsJJ0mPSTY09JwnbQFEioNk+ABDoaMOcGz+?=
 =?us-ascii?Q?LGYNnKzgz4NcifEfZHNbZRsUjBggM23mIQc7dpVvSkIX3ntiosnDHklVfbyK?=
 =?us-ascii?Q?bWDElf+9mzryFC3ltCATdPHXf/X4cOY0iBbSHjXeMnKuOe9qEeDvM/kkZ8Kh?=
 =?us-ascii?Q?kgTMxBaIRPivU3Zi+xL/7hh/KKDlrz2gDU8FN9sUnmXLxHTI2n/ZRqM1Jj+S?=
 =?us-ascii?Q?u8A1QpxvozjEw4b6Vze3w/V2jhLKitmsKhWHazPp+hmOPkvw0s3iUYIGcORK?=
 =?us-ascii?Q?cY0lsm3mKKpEVUUFeIHR9y2D2tqocJDKfKzD1d11ClLbDW6kyQ9GwuvNlh/V?=
 =?us-ascii?Q?7AKPj/Ud73y24cxB0xh0fLq33ArBkQlbQhR1zqo3k2MeHjuZaiwGcHHFqDVX?=
 =?us-ascii?Q?6bIuF5Y9OscSCZZ8e1EC09LVS8HgexKlY9bZ7bM6bmQcdxl0qt+3WsLwcm7j?=
 =?us-ascii?Q?0vZxchDPoil6EDkadCyJ4rKIPjDxKuOWnQH7qhMNZEowMRr9SzR/fyjUrAwu?=
 =?us-ascii?Q?kcu0CzVwfpjod83Q7VzVFC9HQRRpRJwtOVNvzA4sX4W3YL+iknsxBFQBKP1s?=
 =?us-ascii?Q?TIhL+S8LqdPyORQOSWKXpZCy7tWf494TkWMkTEpdsgc9q0GT07DuXGpGcM+6?=
 =?us-ascii?Q?IPHFRcQGhBjxESMED0OMxuWdMjtStnXkYnXlS4TjtCir3pzkXodzjR2MYFrG?=
 =?us-ascii?Q?UtQtUwsL1Hwcv4yv4+4jW99peRrckf8F8sp65PamJaumWf3q+uzOSIusH5MA?=
 =?us-ascii?Q?3vW8a8Iz/SHhf03s5+C7tgIxLoHYgvNyELta1AieMS0UwunuZIxW1cQO9tlW?=
 =?us-ascii?Q?OSKN5Doeayfy9CRVYApEpukxlExEGZ8INszGtMCm0Y5w08Lr1RwrsE/0FHF6?=
 =?us-ascii?Q?R6jzf6TEa3/xZPiBDr3Aqwfa8h2sqzHzISC7L4BP3Pf7Ulz8QVN+IYvtM2Gt?=
 =?us-ascii?Q?wb+l9PRmcGbv9essM6248a96i93ozHCHqMuCQN4dVuwFHpo5nG5OTNBYuenM?=
 =?us-ascii?Q?m61npoply4RT2IMmnZ5xRWIrR64Mpu11Il1hDx08A/10G0wW0s8JLrJIBWvg?=
 =?us-ascii?Q?z3jBLBEWtDUQnAgrvx7UP95C1ExLfCTPEzgRBHNbkd/r+TMTjlpdh9KLtmql?=
 =?us-ascii?Q?fCnPpcYYyQYuMpst4+nFN+mIO3VLio89shSfdH7ip60Jnjy/xBUuuVKiR/t8?=
 =?us-ascii?Q?ms90xOi7kxX4RIhAcJIgDMFD2wwYy48np6CWSKVEIgjzRY4IF3U2SRkupg9X?=
 =?us-ascii?Q?eZxfdUiJhkRxqvdDGlawFzIQclzP3ejtRC6NVrWuIQ41DuXjsRtCLJVZry28?=
 =?us-ascii?Q?Cp31bYHtIAulLp0ibccNiV2K0btWVEtjtVyUhVDyTeyk6v7Qh2PORCAn4LsN?=
 =?us-ascii?Q?B86eOoIsrqg9+rdAKvmZEbtCCZsj4Q7Fb0PXt/YJgGwSMZ0Me2GboUdxcT/6?=
 =?us-ascii?Q?Ia57AOcikMPOLEPlLccd3OZ3TzPvrgnFCJP9Z3ZZ911dyGCaLQzhDoH19DBC?=
 =?us-ascii?Q?pc3alnWqTkOPWUsLzU0ols+wKApuYK8/SB38dGxeOJv8xoGGHN1rsvs2KAVd?=
 =?us-ascii?Q?cUy1jA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <90E16ED25035DE4AA8447ED4D703EB66@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d058497-80e0-4fa5-6bc6-08d99faebd5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 16:18:29.8004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mu+iA7+dzEXcnlHb96feZijNg56hpM/zocFMmZWGEQgbsIPcFlOcvylFeC/BrOR250eTP3id0BL3mQhY/j9Jcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5162
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: YzkSy9z7FuO83MvsbPfAZNxPLDAjNOez
X-Proofpoint-GUID: YzkSy9z7FuO83MvsbPfAZNxPLDAjNOez
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_05,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 clxscore=1015 priorityscore=1501 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040062
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 4, 2021, at 12:00 AM, Song Liu <songliubraving@fb.com> wrote:
> 
> Add tests for bpf_find_vma in perf_event program and kprobe program. The
> perf_event program is triggered from NMI context, so the second call of
> bpf_find_vma() will return -EBUSY (irq_work busy). The kprobe program,
> on the other hand, does not have this constraint.
> 
> Also add test for illegal writes to task or vma from the callback
> function. The verifier should reject both cases.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
> .../selftests/bpf/prog_tests/find_vma.c       | 115 ++++++++++++++++++
> tools/testing/selftests/bpf/progs/find_vma.c  |  70 +++++++++++
> .../selftests/bpf/progs/find_vma_fail1.c      |  30 +++++
> .../selftests/bpf/progs/find_vma_fail2.c      |  30 +++++
> 4 files changed, 245 insertions(+)
> create mode 100644 tools/testing/selftests/bpf/prog_tests/find_vma.c
> create mode 100644 tools/testing/selftests/bpf/progs/find_vma.c
> create mode 100644 tools/testing/selftests/bpf/progs/find_vma_fail1.c
> create mode 100644 tools/testing/selftests/bpf/progs/find_vma_fail2.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/find_vma.c b/tools/testing/selftests/bpf/prog_tests/find_vma.c
> new file mode 100644
> index 0000000000000..3955a92d4c152
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/find_vma.c
> @@ -0,0 +1,115 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +#include <test_progs.h>
> +#include <sys/types.h>
> +#include <unistd.h>
> +#include "find_vma.skel.h"
> +#include "find_vma_fail1.skel.h"
> +#include "find_vma_fail2.skel.h"
> +
> +static void test_and_reset_skel(struct find_vma *skel, int expected_find_zero_ret)
> +{
> +	ASSERT_EQ(skel->bss->found_vm_exec, 1, "found_vm_exec");
> +	ASSERT_EQ(skel->data->find_addr_ret, 0, "find_addr_ret");
> +	ASSERT_EQ(skel->data->find_zero_ret, expected_find_zero_ret, "find_zero_ret");
> +	ASSERT_OK_PTR(strstr(skel->bss->d_iname, "test_progs"), "find_test_progs");
> +
> +	skel->bss->found_vm_exec = 0;
> +	skel->data->find_addr_ret = -1;
> +	skel->data->find_zero_ret = -1;
> +	skel->bss->d_iname[0] = 0;
> +}
> +
> +static int open_pe(void)
> +{
> +	struct perf_event_attr attr = {0};
> +	int pfd;
> +
> +	/* create perf event */
> +	attr.size = sizeof(attr);
> +	attr.type = PERF_TYPE_HARDWARE;
> +	attr.config = PERF_COUNT_HW_CPU_CYCLES;
> +	attr.freq = 1;
> +	attr.sample_freq = 4000;
> +	pfd = syscall(__NR_perf_event_open, &attr, 0, -1, -1, PERF_FLAG_FD_CLOEXEC);
> +
> +	return pfd >= 0 ? pfd : -errno;
> +}
> +
> +static void test_find_vma_pe(struct find_vma *skel)
> +{
> +	struct bpf_link *link = NULL;
> +	volatile int j = 0;
> +	int pfd = -1, i;
> +
> +	pfd = open_pe();
> +	if (pfd < 0) {
> +		if (pfd == -ENOENT || pfd == -EOPNOTSUPP) {
> +			printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n", __func__);
> +			test__skip();

Ah, I missed a goto cleanup here, so it breaks vmtest. I can fix this in 
v3, or we can fix it when applying the patch. 

> +		}
> +		if (!ASSERT_GE(pfd, 0, "perf_event_open"))
> +			goto cleanup;
> +	}
> +
> +	link = bpf_program__attach_perf_event(skel->progs.handle_pe, pfd);
> +	if (!ASSERT_OK_PTR(link, "attach_perf_event"))
> +		goto cleanup;
> +
> +	for (i = 0; i < 1000000; ++i)
> +		++j;
> +
> +	test_and_reset_skel(skel, -EBUSY /* in nmi, irq_work is busy */);
> +cleanup:
> +	bpf_link__destroy(link);
> +	close(pfd);
> +	/* caller will clean up skel */
> +}
> +
> +static void test_find_vma_kprobe(struct find_vma *skel)
> +{
> +	int err;
> +
> +	err = find_vma__attach(skel);
> +	if (!ASSERT_OK(err, "get_branch_snapshot__attach"))
> +		return;  /* caller will cleanup skel */
> +
> +	getpgid(skel->bss->target_pid);
> +	test_and_reset_skel(skel, -ENOENT /* could not find vma for ptr 0 */);
> +}
> +
> +static void test_illegal_write_vma(void)
> +{
> +	struct find_vma_fail1 *skel;
> +
> +	skel = find_vma_fail1__open_and_load();
> +	ASSERT_ERR_PTR(skel, "find_vma_fail1__open_and_load");
> +}
> +
> +static void test_illegal_write_task(void)
> +{
> +	struct find_vma_fail2 *skel;
> +
> +	skel = find_vma_fail2__open_and_load();
> +	ASSERT_ERR_PTR(skel, "find_vma_fail2__open_and_load");
> +}
> +
> +void serial_test_find_vma(void)
> +{
> +	struct find_vma *skel;
> +
> +	skel = find_vma__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "find_vma__open_and_load"))
> +		return;
> +
> +	skel->bss->target_pid = getpid();
> +	skel->bss->addr = (__u64)test_find_vma_pe;
> +
> +	test_find_vma_pe(skel);
> +	usleep(100000); /* allow the irq_work to finish */
> +	test_find_vma_kprobe(skel);
> +
> +	find_vma__destroy(skel);
> +	test_illegal_write_vma();
> +	test_illegal_write_task();
> +}
> diff --git a/tools/testing/selftests/bpf/progs/find_vma.c b/tools/testing/selftests/bpf/progs/find_vma.c
> new file mode 100644
> index 0000000000000..2776718a54e29
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/find_vma.c
> @@ -0,0 +1,70 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +struct callback_ctx {
> +	int dummy;
> +};
> +
> +#define VM_EXEC		0x00000004
> +#define DNAME_INLINE_LEN 32
> +
> +pid_t target_pid = 0;
> +char d_iname[DNAME_INLINE_LEN] = {0};
> +__u32 found_vm_exec = 0;
> +__u64 addr = 0;
> +int find_zero_ret = -1;
> +int find_addr_ret = -1;
> +
> +static __u64
> +check_vma(struct task_struct *task, struct vm_area_struct *vma,
> +	  struct callback_ctx *data)
> +{
> +	if (vma->vm_file)
> +		bpf_probe_read_kernel_str(d_iname, DNAME_INLINE_LEN - 1,
> +					  vma->vm_file->f_path.dentry->d_iname);
> +
> +	/* check for VM_EXEC */
> +	if (vma->vm_flags & VM_EXEC)
> +		found_vm_exec = 1;
> +
> +	return 0;
> +}
> +
> +SEC("kprobe/__x64_sys_getpgid")
> +int handle_getpid(void)
> +{
> +	struct task_struct *task = bpf_get_current_task_btf();
> +	struct callback_ctx data = {0};
> +
> +	if (task->pid != target_pid)
> +		return 0;
> +
> +	find_addr_ret = bpf_find_vma(task, addr, check_vma, &data, 0);
> +
> +	/* this should return -ENOENT */
> +	find_zero_ret = bpf_find_vma(task, 0, check_vma, &data, 0);
> +	return 0;
> +}
> +
> +SEC("perf_event")
> +int handle_pe(void)
> +{
> +	struct task_struct *task = bpf_get_current_task_btf();
> +	struct callback_ctx data = {0};
> +
> +	if (task->pid != target_pid)
> +		return 0;
> +
> +	find_addr_ret = bpf_find_vma(task, addr, check_vma, &data, 0);
> +
> +	/* In NMI, this should return -EBUSY, as the previous call is using
> +	 * the irq_work.
> +	 */
> +	find_zero_ret = bpf_find_vma(task, 0, check_vma, &data, 0);
> +	return 0;
> +}
> diff --git a/tools/testing/selftests/bpf/progs/find_vma_fail1.c b/tools/testing/selftests/bpf/progs/find_vma_fail1.c
> new file mode 100644
> index 0000000000000..d17bdcdf76f07
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/find_vma_fail1.c
> @@ -0,0 +1,30 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +struct callback_ctx {
> +	int dummy;
> +};
> +
> +static __u64
> +write_vma(struct task_struct *task, struct vm_area_struct *vma,
> +	  struct callback_ctx *data)
> +{
> +	/* writing to vma, which is illegal */
> +	vma->vm_flags |= 0x55;
> +
> +	return 0;
> +}
> +
> +SEC("kprobe/__x64_sys_getpgid")
> +int handle_getpid(void)
> +{
> +	struct task_struct *task = bpf_get_current_task_btf();
> +	struct callback_ctx data = {0};
> +
> +	bpf_find_vma(task, 0, write_vma, &data, 0);
> +	return 0;
> +}
> diff --git a/tools/testing/selftests/bpf/progs/find_vma_fail2.c b/tools/testing/selftests/bpf/progs/find_vma_fail2.c
> new file mode 100644
> index 0000000000000..079c4594c095d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/find_vma_fail2.c
> @@ -0,0 +1,30 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +struct callback_ctx {
> +	int dummy;
> +};
> +
> +static __u64
> +write_task(struct task_struct *task, struct vm_area_struct *vma,
> +	   struct callback_ctx *data)
> +{
> +	/* writing to task, which is illegal */
> +	task->mm = NULL;
> +
> +	return 0;
> +}
> +
> +SEC("kprobe/__x64_sys_getpgid")
> +int handle_getpid(void)
> +{
> +	struct task_struct *task = bpf_get_current_task_btf();
> +	struct callback_ctx data = {0};
> +
> +	bpf_find_vma(task, 0, write_task, &data, 0);
> +	return 0;
> +}
> -- 
> 2.30.2
> 

