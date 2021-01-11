Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643E52F1C66
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389196AbhAKRcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:32:11 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47622 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727121AbhAKRcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:32:09 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BHIBVs023812;
        Mon, 11 Jan 2021 09:31:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=AIqHmQxFn5jTEK+d8MPQo2ELjIKnrjN0kNapAUYCZtE=;
 b=SnUHIzmKvfXuYnpQF3Ka3pq5+zmvHDar/abbkyBxVrg6EsV3+QIUT9qxnDSUxE1OWpuh
 JqwahbaPKayNkt/dPV1APLKsRHpCWTuZkiMkc1sI/MxfCGVeVEwcmteEenM9jN4wWf8L
 pPJPkiyFfy1KxQDl69wKZ4+AnkjNWtE0vwI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35yweb5stf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 09:31:04 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 09:31:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/+2l30kaYX9xV28JpoDjv8Z7utiTLB1BwhvajY5dm8qZOQDlPNrtac11EOkeLwkN0wQOUPD3pIewK32tY0Ur49Zcolb0Fp0WsfQaiXiIUiZlpPTWYdspUnCzfzKtsd4n46xyQddP0DZp26ij3Aq2zZUyiLSOqJNsh6II/Ut0U7r8+SbEG000bUvUInLU3IafftVcLbMd9o+MltYCfUr1nhHOWtSAtYdsO8oNfEI5/XAgR+KJlANofhBj78dEf3pRES2hj9ygoxWU80n7PdiXsGPWEAmL7gmJI3LVXZC2MPIjSclemjvbzSIZc/IlygKe/GC0UE7dTKjBD3UdVOk8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIqHmQxFn5jTEK+d8MPQo2ELjIKnrjN0kNapAUYCZtE=;
 b=kXi+LUZ8w4K52jnr7s/ups5oRxQbJv8kL/5lmGeyRAZEHy4GnpHmNceNLkX3fYD1scjf6w90Q//Zr50NuP7yRO274GyQU5/CMjT598bSXvT4Kssk53D2duAPSPaXAaF5VBExbNbPz4Gd4RS+azTeXZ2d2iYoaTG4iC3qBCgMVxU0jmNcWXQUsO+BjuvnNVSA//ccPYxbn3XYCxsftURnaOwrEbO2uO08JExETHqvy+gwrMMRwKgnaV3dZvJHTR721k38IFdz0HZrrElWoP4I8+j9PLrHwqdeZT6GDofSVqXw86wdX/RZIvMGco5yy/O8vvtvjH7kJxRHjq/4aEXTZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIqHmQxFn5jTEK+d8MPQo2ELjIKnrjN0kNapAUYCZtE=;
 b=APUew+nHn+a8IGsrMjrIFxSLqnEubAETwRWwUC5xZKmbTP+b+JFRszQr4yMyXgq1zzZkIhT11mBODcrOH1Ybi3xFFyySKPdE3UdQw6wCUcFC+wfn2XexvPItKVXNzbF3FdEWwcIu3Jr1tdg/h/H6vgTd9i/7Iz8nAMohGNHBBdM=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2408.namprd15.prod.outlook.com (2603:10b6:a02:85::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 17:30:54 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 17:30:54 +0000
Subject: Re: [PATCH bpf-next 2/4] selftests/bpf: add non-BPF_LSM test for task
 local storage
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <mingo@redhat.com>, <peterz@infradead.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>, <haoluo@google.com>
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-3-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <4eac4156-9c81-ff4d-46f5-d45d9d575a16@fb.com>
Date:   Mon, 11 Jan 2021 09:30:50 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <20210108231950.3844417-3-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6450]
X-ClientProxiedBy: MWHPR07CA0018.namprd07.prod.outlook.com
 (2603:10b6:300:116::28) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1158] (2620:10d:c090:400::5:6450) by MWHPR07CA0018.namprd07.prod.outlook.com (2603:10b6:300:116::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 17:30:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7133f8f3-0de0-4aad-0f09-08d8b656a624
X-MS-TrafficTypeDiagnostic: BYAPR15MB2408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2408A11F1F6A50EEDC6C8632D3AB0@BYAPR15MB2408.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YBDcxWiYs3CjdVZbSAJjoigb14Z1QNDfp+nvA4KHIXJNRXhkXSxmj6nRgyVUGs2Qn3B4jfYJXciu9s8Kr+ecJiEqnISWcD/+q6azpmcV4uzVQUu92ueSekRMI6u1pVjkkFVa1Hpab9rgFS7vEtGCNjj7yzATkLGi54zB18OLDqJLvv7iPuynC1aM9qigptSoyFTDHEXJcu0yqAsm6avokHWlS8dUnLJJygUvNfjKCvTRFkaWJQo1J0arg0D0KwyrANQRrv5N3hf9WAUSk6INMV/WpanYjajDxfXG3jo8s8BuJZ3QUDPx3mb5iZmYZJee1JOVxpWBUwurPzJi3ZiILuGk5gxdO5bcEyT+Ds43tjKydk8HY+fxJFcCB2nkTi0iafKhPtWeU0kV2MsevVMO5Gj3ux4A5AnLnv2qbMWn1C4kBpK+Evcw5X+VTltHefm6YLN2f6XEBnN0iGM9++R3x1eO2UjT06ebipn3o1B1LQ8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(346002)(376002)(396003)(7416002)(66946007)(36756003)(86362001)(8936002)(66556008)(4326008)(186003)(31686004)(53546011)(6486002)(8676002)(31696002)(52116002)(478600001)(2906002)(5660300002)(2616005)(316002)(16526019)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NWErcmhYZytzWnYyNnVwUi9kZlc4QXZQdm9hbXAyU3lBVVpuZmkxTEdBbkZz?=
 =?utf-8?B?K1dyT3VKUlI3dS92Y09JY3MxdU9TRU9VNXNzWVZ6UkgycjNSSitXUEF5Nkpt?=
 =?utf-8?B?RFhSUUpScWZrdk1TT1lJczFFWEFBZzcxM0VpMVZDd2I1WjdFUGhScTFEbUNs?=
 =?utf-8?B?U2loaEZLQVN1dEZ2bVF2bUVVcHBsKzJzWEZNRjQ5b1o4dEtOTjRSb2pqZWFQ?=
 =?utf-8?B?YzBOZVVPVUZjVU1aSlU0eE5zSXlReDdEOUJ6UzUwUEF5N25paE1MMU81QTBJ?=
 =?utf-8?B?cVQrR1FsbFBiR2Y4V3p1TlBCY25qNGdyYVdnL1Q3ZDhTcGxUS1NEalBLN3Vx?=
 =?utf-8?B?Mm9kTysrUXpONGdia24ySDNvQi9iTnZmMy9ZTW9Ta3IvNlIvNW9LMUdaZktt?=
 =?utf-8?B?RGN0bXhQY0ZrOE1uR3NQZGlIM0FYR3ErN2h4c1YvRXcrRjFTQXo2QkdUdk5u?=
 =?utf-8?B?RHpXN1g5TDZTcEV6ZDVzR3JCMFhyNzE2YnpwSXVBSUdUYVZtcXFkZjVJWUJ3?=
 =?utf-8?B?UHVFSFErOTNQb1E2bzBqMERObHhuSElpemlYb0NQMmxMWEwyZkVjOXRRRWli?=
 =?utf-8?B?cTdqb0FwNEhCdGI1VG1hTjQ4cjhOalJKaUlpY1NuRm9tUXVIWkdKV1ArL3pa?=
 =?utf-8?B?QVdZT1VLM3oreXdXZWZnUWlXNWxhaHF4aWlyU0hSa1p5dFBCeUZjMTBQek5m?=
 =?utf-8?B?TWxEV3MvRE5jSG9QV1pOQ2dUMCsvZzhpTnAyb2dsaVhEd3lLRUtqLzJBOFEv?=
 =?utf-8?B?S3cycUg1MmlHRTZESVRFSXhRYkduZ0Nnb2YzVHVuUTFNVW0wUWszZXVnbWoz?=
 =?utf-8?B?ZGlwUXNQK1BGWWZsWk5NMk5JS1JCQkpYR0h4QlY5S2hqMUUrbDdndVhOMW14?=
 =?utf-8?B?c2pLTTU3QUFlc1RMQmJWVzBjUi9BZGR0MERhZzd3MXo0Uldwc3AyVEl3L3VG?=
 =?utf-8?B?U2tSdDFHWHlLcHJwakRyUStzYy95NmdHRVNsbVJldnVDS2tCbEQvM0hHRll5?=
 =?utf-8?B?clppUU5HRGZ2a0tzZVhqS29GZXcvZDNCYktBZHhHYkF5Y2pKOXhaU0hreWwy?=
 =?utf-8?B?aHdaWCtiTzVDdFlEbG1xR3RidzdTWHZncVhnYmxTYnA2YzBGR0RPK05IbVBo?=
 =?utf-8?B?RE9QZnIzSDlaeHZJdTlmRUsrWFBBZzc0N3k0enlaSEFDM25KaEcvT3lRcUs0?=
 =?utf-8?B?ZVhYZWdKdklxb0paMC9vZnR2Rk5JS0dXTzdzSkR2UnBIZjdRYkdLKzZ4M1R4?=
 =?utf-8?B?L2VFcHI0U2doRWdJWWxFaXBJN0UxMXRzR2NIaVpWOTBQNFVZeVpQU29WcmRh?=
 =?utf-8?B?UjlTZGFTbXJiU25vdWhmeVdyakVqcW1WVVo1cFBNeHZYTnY0NEFObUUxV2dj?=
 =?utf-8?B?N2VCbkYxVy9xbHc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 17:30:54.3189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 7133f8f3-0de0-4aad-0f09-08d8b656a624
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cAjFbCn51MuD8HM3Wi8C8DnSAbZ3gfGMHRm8yjiYaw27fSa58H6FUwGudyq+pfmN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2408
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_28:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 mlxscore=0
 adultscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101110100
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/21 3:19 PM, Song Liu wrote:
> Task local storage is enabled for tracing programs. Add a test for it
> without CONFIG_BPF_LSM.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   .../bpf/prog_tests/test_task_local_storage.c  | 34 +++++++++++++++++
>   .../selftests/bpf/progs/task_local_storage.c  | 37 +++++++++++++++++++
>   2 files changed, 71 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/test_task_local_storage.c
>   create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/test_task_local_storage.c b/tools/testing/selftests/bpf/prog_tests/test_task_local_storage.c
> new file mode 100644
> index 0000000000000..7de7a154ebbe6
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/test_task_local_storage.c
> @@ -0,0 +1,34 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */

2020 -> 2021

> +
> +#include <sys/types.h>
> +#include <unistd.h>
> +#include <test_progs.h>
> +#include "task_local_storage.skel.h"
> +
> +static unsigned int duration;
> +
> +void test_test_task_local_storage(void)
> +{
> +	struct task_local_storage *skel;
> +	const int count = 10;
> +	int i, err;
> +
> +	skel = task_local_storage__open_and_load();
> +

Extra line is unnecessary here.

> +	if (CHECK(!skel, "skel_open_and_load", "skeleton open and load failed\n"))
> +		return;
> +
> +	err = task_local_storage__attach(skel);
> +

ditto.

> +	if (CHECK(err, "skel_attach", "skeleton attach failed\n"))
> +		goto out;
> +
> +	for (i = 0; i < count; i++)
> +		usleep(1000);

Does a smaller usleep value will work? If it is, recommend to have a 
smaller value here to reduce test_progs running time.

> +	CHECK(skel->bss->value < count, "task_local_storage_value",
> +	      "task local value too small\n");
> +
> +out:
> +	task_local_storage__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/task_local_storage.c b/tools/testing/selftests/bpf/progs/task_local_storage.c
> new file mode 100644
> index 0000000000000..807255c5c162d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/task_local_storage.c
> @@ -0,0 +1,37 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */

2020 -> 2021

> +
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +struct local_data {
> +	__u64 val;
> +};
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_TASK_STORAGE);
> +	__uint(map_flags, BPF_F_NO_PREALLOC);
> +	__type(key, int);
> +	__type(value, struct local_data);
> +} task_storage_map SEC(".maps");
> +
> +int value = 0;
> +
> +SEC("tp_btf/sched_switch")
> +int BPF_PROG(on_switch, bool preempt, struct task_struct *prev,
> +	     struct task_struct *next)
> +{
> +	struct local_data *storage;

If it possible that we do some filtering based on test_progs pid
so below bpf_task_storage_get is only called for test_progs process?
This is more targeted and can avoid counter contributions from
other unrelated processes and make test_task_local_storage.c result
comparison more meaningful.

> +
> +	storage = bpf_task_storage_get(&task_storage_map,
> +				       next, 0,
> +				       BPF_LOCAL_STORAGE_GET_F_CREATE);
> +	if (storage) {
> +		storage->val++;
> +		value = storage->val;
> +	}
> +	return 0;
> +}
> 
