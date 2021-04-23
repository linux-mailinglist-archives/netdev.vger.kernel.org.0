Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C855368A56
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 03:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbhDWBVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:21:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46842 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229888AbhDWBVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:21:00 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13N1JBoE017703;
        Thu, 22 Apr 2021 18:20:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=8mwUPIxQAC1BzMvFqIfK231CNZckuxrfjjT8t+TVXGg=;
 b=ixKsFMVX+Xw/xrd+XsGVE5aCV3lMWiV5PimvydGwO7nYsFjEM7PytGf77kWAm229orzA
 Fa094Td5N8mrW4MHscpnh13NSyIrH3Lef0s07iTTWiQnsPgMZaMVbkcYPjjqOdLunsfv
 LqUbywxWPcMdO3hwTtE+kB4imy8LXD//Wdc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3832576cyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Apr 2021 18:20:12 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 18:20:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZTWWNVJu90dOZzwOm7ROBTsOSLL9nnZ0gsQPh54DtNlgbVkabuUh4YzB0c+jM8ztMlSmBTG3ZKSCRErhDG1RZm0/7sTHpHNUifsJSNtgDkWem60e5AkpmaQImchi3MDz870tuySwKw9hRWgdkKHHfiJgpx4OSUoLRuv1jeCKu7cUXXxlm26v8uhysKYm24SGRWaRGwQjp4Vg0QFR6mVKM5N/FXFpifUuCe9HtsVGOQBo7GKPDszA2uDF6s9XUWcvQVC173AxTr0dGFHvgv9XAcF3SCMgrWVV3YJLITxPnsci3zhPjC9VLpOibGZscoeykJgZhLKsTuvgaRbpr2+EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mwUPIxQAC1BzMvFqIfK231CNZckuxrfjjT8t+TVXGg=;
 b=UVT1POy86/1vxg3gJJgeJIKf0wuMEYVZ7dwe8N/U/sAlpwo3ISdVJTnL9AKAOIZ4VZ7RXyicbTEH3ffsLWjrw0TblqX9Xry/MJ4y+C8onWaDiYMt9xIecRBbMt2wc+LvszyMpWfXifWHt3zjtY3+6gtO/+Ip9ppDzTWaAyc9Q3O+yI1kW1z59kg4DH2qbBAcASBRtAiVpM5ErKp5AuzumGi76JUTc6HDCGhXFuEectbv/cnpiiEHsQGstpAL+/3TWlb068JCsZJNblx2yUlGPfd1eW58S2I8cJpBzFq+i7oBmZxZBo56nt/lxTPDDt2vrdlgZwmbSDGpD74QtmnZeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2207.namprd15.prod.outlook.com (2603:10b6:805:21::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 01:20:09 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Fri, 23 Apr 2021
 01:20:09 +0000
Subject: Re: [PATCH v2 bpf-next 17/17] sleftests/bpf: add map linking selftest
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-18-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <aeedaa9f-017e-5afb-43c6-96fae29cdb6b@fb.com>
Date:   Thu, 22 Apr 2021 18:20:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210416202404.3443623-18-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:83f]
X-ClientProxiedBy: MW3PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:303:2b::8) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:83f) by MW3PR05CA0003.namprd05.prod.outlook.com (2603:10b6:303:2b::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.15 via Frontend Transport; Fri, 23 Apr 2021 01:20:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81a78755-3fa0-4a77-de5f-08d905f5efa7
X-MS-TrafficTypeDiagnostic: SN6PR15MB2207:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB220703E74EB2ED24563EDB4FD3459@SN6PR15MB2207.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GumThTURjgNXZvu0MR7u/ruiqxKYXFy2zpAkjSmlLgnuH3c33zZle3C6ItalslmLxvrfbs37CWyGZSogjzljLKSqQ3xnlWklfgTCP5vnkuROyR53ioREWJ236Z/d0jPJXvR2Az+YNGMdiW9wvQalRKd4XskUCxpxtvFAc1E8y1Y3JwFfdnD9aqkz8jg+w8RMhExGClZAwL/LW/YVkQGLAFfkgzU0gBZynp/GzNb4E48HcdBXyXiSse+v4nz1vUHMzpslmNw5grZim28hoEsXkx5iRE2wHS0jU8t5cSDVU00wWya4tG2qNaKXVEyxhwOh8QW/Wk94029DEB9hxNSxJNwi4M4SFWvpLjBtkZbc5kIQjTjSm9OM4KKNNET82CyrELFwR+oQlbGYrZeKA0SGTXZutTWL7qMmgKmVCkPq3icbqlpr1Ega1PTsvec5rZhBuTry4lwIX3nZ/rOs4Ig9+HIRJVrPrjnKpRDbnGPQSsfKTJelJVxT35P0v20Y2sTZ3DSxKu2n2+z+ulnMOx5jQoa5zTuu2c0FrOsJmtZtnxSdHzmW2t1pd9BJ9vHZ1JaiL3oUngrvUOecnNq/i8JmFnmHMBqRJBOQzHL+b4vEltYWSHc1ITFzukVuAQ0wQXsj3EJU1Wk0WP/vhAJvVjgvGhjtcqj8hnQi8BawmzGjgTZEwLLODgQUW+9O892doW6R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(346002)(376002)(396003)(83380400001)(66946007)(2616005)(36756003)(31686004)(31696002)(66556008)(66476007)(86362001)(186003)(478600001)(8936002)(38100700002)(52116002)(16526019)(53546011)(6486002)(2906002)(316002)(4326008)(8676002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QUMyendpVjhjWDBBTjJQWkFZRGI4Y2F1RWVMZkN5OEdXcVVrenlwNi9uVTY4?=
 =?utf-8?B?T1RJQVF4QmFudU9wZURIeDhOckNOY2NPQ3c1TC9ja204VlJNa2pwdlQ2N3d5?=
 =?utf-8?B?NngzRmpqSXZiOU1mczRpemlvdVEyTXZCcjJYZ28xS1AwendPWUxLSEdnZXR1?=
 =?utf-8?B?UCthQW42RVhjUnFMdGU0d3RqS29WOWlzVVNrK0hKTm93QkR0VzlETCtFNCtE?=
 =?utf-8?B?RzhxT1lPdHFpMklMY3FHbkVVLy9JNU9rNHhmckhKdEEzeCt1RkZYNXdTUG83?=
 =?utf-8?B?VlVIUUNvNFFaaGR1UUxZcHltaldkNUpXVy9nZEVhWk44NE9PSE5rTFl3b2JK?=
 =?utf-8?B?TW11bWw4MHJ4WlJISldsMWFZaWthdlhpa3NEUnpmeFRxUmYvMjJMbGtyeGFY?=
 =?utf-8?B?R0kzejcrT1hNSGdJeFJieXJZaFNyTW9DZ1FvcnYvV0tIK1ZUbTRZM29zSnF3?=
 =?utf-8?B?SDc2bGFvUHdUQmwrRlF6cDRNdStaWlBvYmRxZGo5ZDhkc3hKOWtGeExLcElu?=
 =?utf-8?B?T1dwTi90c2xyR0FhOVdzbnhOd2FubUdMSFVKWk9wazFiQXUxK21lQVE3Uitj?=
 =?utf-8?B?aXlVSlRyRkhBU01UaDRsNzZrSkVtazdtY0dmQk1xVHRCMEdmdms4WVZNSEth?=
 =?utf-8?B?MXMvcTZHU29wZnMyMVRjcURFRytIOGd0c3A0bDZ6WlJuc1Qrek80dUJoaW42?=
 =?utf-8?B?ZCsrUFdxdE1tTzhjaStiMVZKbUIzeXc2b3k5UWJUN0c1REdscFdBVHZkdDVF?=
 =?utf-8?B?NkorSUNyVFRMajBqa2VzL01BeVZpWmpObitYMEZqaXZraFc2dXNwNkhsMzRM?=
 =?utf-8?B?Tkh5WHZHKy9aNGcvVVZVQ2t1YjlCb3R5U1JBWHpwYVdKV09NQTVpR0RHV3A1?=
 =?utf-8?B?aFpVdUVCRXc3OXR5ODFoNEVPN1ZzMTJxcFE5aEVtNllUZWptWnhqbGxZTTdm?=
 =?utf-8?B?RVErOEhCb0srQ0UrZXpMQ0lPNmdjZkw4N1RQNTZnV09pbGk0SmFFc3pPWWtK?=
 =?utf-8?B?MlNQdUY0WHc5Vjg1bnQ2Rm9RVnY0Wm5TcjBNUDZrS3VzSmtrU2tXMkhJNEZi?=
 =?utf-8?B?NlQ2RElIRlN4L0dvaFFMNXhZUGcrNC9RS2MzRHlnT1IwL3F2Q29GWEVjNUl2?=
 =?utf-8?B?dFBISnR0UmlnaWlqMHZXcmtQeWQwU242LzMyYWxGVDdhM1JESmFvSmlNeVdH?=
 =?utf-8?B?aWlVMFFncll6RFA1UnoxODNnMnhYTDg3L0hkdzJkVUJoeVp1bUdOKzM5eVVW?=
 =?utf-8?B?M0ZDNXg2NE9wb2xyc2dMejgzeHhsYWp6eUUvdlRWb1grWVgvWHgzYThFdm4w?=
 =?utf-8?B?OFVPS25DelUwT3oyQWZDWnZnRjRWL0JSVWpBREVJLzV5K1pmbk51SGx4cmhr?=
 =?utf-8?B?bUNZM0NoQ1FiVEpRZ3VlTkF4OE9rWnF0aEVzRDA5aWRNUC9nb2RuQXV6R2pR?=
 =?utf-8?B?MzJiQnp1NXFmREJXWUl2cVVYMTNHVUNGT0IrYmFyanZHYWpnOUYxaVUwUzJG?=
 =?utf-8?B?dVF6UGQyUW9tbHYwV0MrSzNMK0g5R3piWWlhT292WkNPMmdKWmxJdGhzTC9v?=
 =?utf-8?B?bGlMQ1pXK3JCcGR5Z3V2V243bEhjVUo0eDFzQ3N0UHJjbXpEVnBIS0l6ZXp2?=
 =?utf-8?B?SFdxN0RlQzhhWHpUNUlrQWVUY0x2WWdDMFUwZURjL0lESmM1U2dhaExPMVYv?=
 =?utf-8?B?UXhDYjN4WEp2WGRqUHBacGJkRG5zQU9tYndWcGZOdGVFNkREc2FBeERUekhE?=
 =?utf-8?B?TDVLNmVvWHJ6ZVVoay9uZUtwTzZSWnZHUEFoN3Q1a2ovZnhNQkZydnEwclBQ?=
 =?utf-8?Q?tt6d9BhRjQB7pA3AoKQ3Z9QmS0VMCjSbeKeFs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81a78755-3fa0-4a77-de5f-08d905f5efa7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 01:20:09.6627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +OzVTog2P2Pt5Jp5qAN2M21mPpiLBk8+viRcjA8kOnzDvZzGLCqJory0HyuUgZ8w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2207
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: OZoomsWKYHC8PSWBw1EKM5W9g_7V66u3
X-Proofpoint-ORIG-GUID: OZoomsWKYHC8PSWBw1EKM5W9g_7V66u3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_15:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 adultscore=0 spamscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 1:24 PM, Andrii Nakryiko wrote:
> Add selftest validating various aspects of statically linking BTF-defined map
> definitions. Legacy map definitions do not support extern resolution between
> object files. Some of the aspects validated:
>    - correct resolution of extern maps against concrete map definitions;
>    - extern maps can currently only specify map type and key/value size and/or
>      type information;
>    - weak concrete map definitions are resolved properly.
> 
> Static map definitions are not yet supported by libbpf, so they are not
> explicitly tested, though manual testing showes that BPF linker handles them
> properly.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Ack with a nit below.
Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   tools/testing/selftests/bpf/Makefile          |  4 +-
>   .../selftests/bpf/prog_tests/linked_maps.c    | 30 +++++++
>   .../selftests/bpf/progs/linked_maps1.c        | 82 +++++++++++++++++++
>   .../selftests/bpf/progs/linked_maps2.c        | 76 +++++++++++++++++
>   4 files changed, 191 insertions(+), 1 deletion(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_maps.c
>   create mode 100644 tools/testing/selftests/bpf/progs/linked_maps1.c
>   create mode 100644 tools/testing/selftests/bpf/progs/linked_maps2.c
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index d8f176b55c01..9c031db16b25 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -308,11 +308,13 @@ endef
>   
>   SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
>   
> -LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h linked_vars.skel.h
> +LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
> +		linked_vars.skel.h linked_maps.skel.h
>   
>   test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
>   linked_funcs.skel.h-deps := linked_funcs1.o linked_funcs2.o
>   linked_vars.skel.h-deps := linked_vars1.o linked_vars2.o
> +linked_maps.skel.h-deps := linked_maps1.o linked_maps2.o
>   
>   LINKED_BPF_SRCS := $(patsubst %.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
>   
> diff --git a/tools/testing/selftests/bpf/prog_tests/linked_maps.c b/tools/testing/selftests/bpf/prog_tests/linked_maps.c
> new file mode 100644
> index 000000000000..85dcaaaf2775
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/linked_maps.c
> @@ -0,0 +1,30 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +
> +#include <test_progs.h>
> +#include <sys/syscall.h>
> +#include "linked_maps.skel.h"
> +
> +void test_linked_maps(void)
> +{
> +	int err;
> +	struct linked_maps *skel;
> +
> +	skel = linked_maps__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "skel_open"))
> +		return;
> +
> +	err = linked_maps__attach(skel);
> +	if (!ASSERT_OK(err, "skel_attach"))
> +		goto cleanup;
> +
> +	/* trigger */
> +	syscall(SYS_getpgid);
> +
> +	ASSERT_EQ(skel->bss->output_first1, 2000, "output_first1");
> +	ASSERT_EQ(skel->bss->output_second1, 2, "output_second1");
> +	ASSERT_EQ(skel->bss->output_weak1, 2, "output_weak1");
> +
> +cleanup:
> +	linked_maps__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/linked_maps1.c b/tools/testing/selftests/bpf/progs/linked_maps1.c
> new file mode 100644
> index 000000000000..2f4bab565e64
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/linked_maps1.c
> @@ -0,0 +1,82 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +struct my_key { long x; };
> +struct my_value { long x; };
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_HASH);
> +	__type(key, struct my_key);
> +	__type(value, struct my_value);
> +	__uint(max_entries, 16);
> +} map1 SEC(".maps");
> +
> + /* Matches map2 definition in linked_maps2.c. Order of the attributes doesn't
> +  * matter.
> +  */
> +typedef struct {
> +	__uint(max_entries, 8);
> +	__type(key, int);
> +	__type(value, int);
> +	__uint(type, BPF_MAP_TYPE_ARRAY);
> +} map2_t;
> +
> +extern map2_t map2 SEC(".maps");
> +
> +/* This should be the winning map definition, but we have no way of verifying,
> + * so we just make sure that it links and works without errors
> + */

If in debug output, you output something like
    map_weak in obj linked_maps1.o wins
you can open debug mode for this test, capture debug output and check 
the above substring. But this is really fragile and not really 
recommended. So as long as functionality works, we should be fine.

> +struct {
> +	__uint(type, BPF_MAP_TYPE_ARRAY);
> +	__type(key, int);
> +	__type(value, int);
> +	__uint(max_entries, 16);
> +} map_weak __weak SEC(".maps");
> +
> +int output_first1 = 0;
> +int output_second1 = 0;
> +int output_weak1 = 0;
> +
[...]
