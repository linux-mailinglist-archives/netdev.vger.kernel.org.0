Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329A725360D
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 19:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgHZRlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 13:41:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22034 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725995AbgHZRlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 13:41:20 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07QHbJhY012204;
        Wed, 26 Aug 2020 10:41:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=3gT3kyP+h6uSL/Uf4CrZaDXHedWudk/oGGg+fqF0pNI=;
 b=EWcquvZbxIWB4QJwAW+1QPGuNT9lfY6P3CWuQW4cBim2xyCka7QQw1ijFgsg9n+CqAI8
 8dwm6A7E6/SfNEI+GbbjKv0Op8LFIY0jI5/4GJOoaffWoVEci5el6FfLR4TZTyoHiHGI
 QDMne3hRNJgvNAaMbyefTt5GI3hWl6yBuIQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 335up8g8hs-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 26 Aug 2020 10:41:15 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 26 Aug 2020 10:41:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5s1DEHUe8Y1GRSCWXbRO1g9hi/y7XJm39Iq266iZGUSqiU0UE8aNTpmDs/q0rRfVwmIcz8DLtoEXjO74NruKfT2sxdWkmLnhG3HUxmtOS6Hqi88JluBl1TWaU5fjpbeal97hVoppTfCH4TsYGhFn3a0agGSJLtWKh+mWljRM1hdrQ0zGWj3qQjU+kQNf3bV52tqfm2BXdT0kW6P35KZCqM3Fv9yhMV4Y0/6SU/C3g3hNbtE/ayzkbD/CpQCm+xdYHtnMShplNonGP7T49MX1WRjf7CKG2RUZ8i06j4k453BBK35LeIE2TMl5oKbFdSALgcgSU04kFyM+Tm3K3cvWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3gT3kyP+h6uSL/Uf4CrZaDXHedWudk/oGGg+fqF0pNI=;
 b=nv6vWpQm63AU34O7xjxrhC4WNGXAaxnGQw8XZbV5ZlEl5g0hnlflUGD04G9l50l9qD5tydGN0Uve5FIDkecmFDxZNF8jEmLOd+6M6eg/ePTohdv+VQq5mHdr1eAr9eCATn08sZ+DoHCIhx8i8PKJPDqFUbFplVfP3+U1DhBttpz9S89tt7ze40nZ0p+LBezZxn7CLD/aLNWptgUKM5HUTYUdHGEqn9cxMYqrv6px54iT1m6JB2KSUyo8KVjDmn7unEWpyfAEk0MQUkfkN9OpU1F4ZW9hvK7WeIHXjtesI06mrLrpSkLGZtR63qq9Q8k1bAJ+r1eOjSWtIH4BbSKFfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3gT3kyP+h6uSL/Uf4CrZaDXHedWudk/oGGg+fqF0pNI=;
 b=PC0LSq4Vn3NDOt3uv6xkXrTqObQIgudqfIoKKXKvPNwyD9sek6aiVFTtxXxuetfe+77AdA18/dpVQijKItWsYjHKJjxUo1Jm/N9Eyfl5ApgNlzECzS2iumBPLwiV+PoLmY6P5tvafProHLdaG0NB3DF3+zrS79/uAuTxo7+Hi4c=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2263.namprd15.prod.outlook.com (2603:10b6:a02:87::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Wed, 26 Aug
 2020 17:41:07 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3326.019; Wed, 26 Aug 2020
 17:41:07 +0000
Subject: Re: [PATCH v1 bpf-next] bpf: new helper bpf_get_current_pcomm
To:     Carlos Neira <cneirabustos@gmail.com>, <netdev@vger.kernel.org>
CC:     <ebiederm@xmission.com>, <brouer@redhat.com>,
        <bpf@vger.kernel.org>, <andriin@fb.com>
References: <20200826160424.14131-1-cneirabustos@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e3d9907a-391e-9b7e-c211-4a43b9d4f43f@fb.com>
Date:   Wed, 26 Aug 2020 10:41:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200826160424.14131-1-cneirabustos@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR06CA0004.namprd06.prod.outlook.com
 (2603:10b6:208:23d::9) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR06CA0004.namprd06.prod.outlook.com (2603:10b6:208:23d::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Wed, 26 Aug 2020 17:41:04 +0000
X-Originating-IP: [2620:10d:c091:480::1:342c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69f6b458-6bbc-4392-784c-08d849e735e2
X-MS-TrafficTypeDiagnostic: BYAPR15MB2263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2263381A4ECAD325C3ED3E29D3540@BYAPR15MB2263.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7152DSvMPTbEV0KtHe1jc3R8njRUDGCD5AidT9ou4FWkV5AF2xtyvb/ySra6lxdE+i1ZkjAny+AG7yaJrFkEjngW2QiVxOzGOhgZMJ/K7bK+ipnuPfp/8Am5zMc7KndI5+NgSQ5znQltbmUa45qFlG5/6aSgxWqc9/nThsnB4weIKmb/4Fb2YiL5JwsYIEHZjIwVBhNifmiD/dgxighsKvaoXkYsdLxih+tO+c8AnvbOwKnK2Kvwa5g7wuxWzP5/oAzL9cn5AUGtcUlk1jlssKktJxGqUrc6UtHavipsjZ+/u/eRP+CJPFe0/rbIDDLJ+DQEzLHNzR05VJqmr8TSuAsWIZyfRN7O2JsWLioHBFTxD7R2ACbKmI0iraQbTJl5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(396003)(346002)(376002)(366004)(66946007)(4326008)(478600001)(6486002)(5660300002)(2616005)(2906002)(31696002)(83380400001)(316002)(16576012)(86362001)(66556008)(66476007)(52116002)(8936002)(53546011)(186003)(956004)(36756003)(8676002)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: SKxS9kxwxrXnxG5e6IhK5zOdYFVhv9eRf4c3sVlPCYp70KrkbpVaC7lAoqwjMg+zdNMHnvvmRMfBoZDw8rgC+3+e0uthgdw0wnngqaTN7t/SQ12Z6FmJgVa7oodkFIo/aDL0HiA/dHWMEIMqr7OzT90qlIlwDG3nsiJzkrsleGNiBO9Bep7pLVouGoBe3FYsWo+2QvMyimq610LAtdwUTq/AOxr4YlFIZxb2eQgMclpz9TpOkVso1GQpJM8BqPl2rGLVvsGSc9H4EUNrX/cKN20HsLf7zHfbwnP66u+k9bhy3Qxu5CQAFvw0Tind1p5iiWrqDxDYY8LCj7S4NsdUn9VynQis7bY2k+GUKSPuUVEMCi8AKiRB/ZPyKAiG5AXYgqvR7seqcHYrxWRRa5eWdEeSadssFuma9aoOnQhmLppKosCP71Lzo60saUvVRFoCthn44bU3K7e7vCOANN1Aze+LWmV8qucEt+fKNdgRhyi9dcB3ofs63t6+Msv4BTpIXgf7QrgbrBjnFRry1J87Ua1PjJq7zFyS22hJ8IWVvpPo69NWwlHKmClOdMU512HeR5oCNI1h28NDAr5FgUbXuPL9GCKWt+e0oYSoGqf5NgvR7XfiKd4sQrUjjcZtsuMAkvQ77qvZlJu9neG7rjTNjlSS110dLHM4XITQB3taQZNRXdj/oI8QUrG8QVewnZHF
X-MS-Exchange-CrossTenant-Network-Message-Id: 69f6b458-6bbc-4392-784c-08d849e735e2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 17:41:07.0548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MGs332xhIvwJMlaGqOhx+QwRUcaoEyRaTYcXZebqQmo2nU5PAvdfe2CmYn3/RnEL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2263
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-26_10:2020-08-26,2020-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 clxscore=1011 bulkscore=0
 spamscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260132
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/26/20 9:04 AM, Carlos Neira wrote:
> In multi-threaded applications bpf_get_current_comm is returning per-thread
> names, this helper will return comm from real_parent.
> This makes a difference for some Java applications, where get_current_comm is
> returning per-thread names, but get_current_pcomm will return "java".
> 
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> ---
>   include/linux/bpf.h                           |  1 +
>   include/uapi/linux/bpf.h                      | 15 ++++-
>   kernel/bpf/core.c                             |  1 +
>   kernel/bpf/helpers.c                          | 28 +++++++++
>   kernel/trace/bpf_trace.c                      |  2 +
>   tools/include/uapi/linux/bpf.h                | 15 ++++-
>   .../selftests/bpf/prog_tests/current_pcomm.c  | 57 +++++++++++++++++++
>   .../selftests/bpf/progs/test_current_pcomm.c  | 17 ++++++
>   8 files changed, 134 insertions(+), 2 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/current_pcomm.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_current_pcomm.c
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 81f38e2fda78..93b0c197fd75 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1754,6 +1754,7 @@ extern const struct bpf_func_proto bpf_skc_to_tcp_sock_proto;
>   extern const struct bpf_func_proto bpf_skc_to_tcp_timewait_sock_proto;
>   extern const struct bpf_func_proto bpf_skc_to_tcp_request_sock_proto;
>   extern const struct bpf_func_proto bpf_skc_to_udp6_sock_proto;
> +extern const struct bpf_func_proto bpf_get_current_pcomm_proto;
>   
>   const struct bpf_func_proto *bpf_tracing_func_proto(
>   	enum bpf_func_id func_id, const struct bpf_prog *prog);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 544b89a64918..200a2309e5e1 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3509,6 +3509,18 @@ union bpf_attr {
>    *
>    *		**-EPERM** This helper cannot be used under the
>    *			   current sock_ops->op.
> + *
> + * long bpf_get_current_pcomm(void *buf, u32 size_of_buf)
> + *	Description
> + *		Copy the **comm** attribute of the real_parent current task
> + *		into *buf* of *size_of_buf*. The **comm** attribute contains
> + *		the name of the executable (excluding the path) for real_parent
> + *		of current task.
> + *		The *size_of_buf* must be strictly positive. On success, the
> + *		helper makes sure that the *buf* is NUL-terminated. On failure,
> + *		it is filled with zeroes.
> + *	Return
> + *		0 on success, or a negative error in case of failure.
>    */
>   #define __BPF_FUNC_MAPPER(FN)		\
[...]
>   
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/tools/testing/selftests/bpf/prog_tests/current_pcomm.c b/tools/testing/selftests/bpf/prog_tests/current_pcomm.c
> new file mode 100644
> index 000000000000..23b708e1c417
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/current_pcomm.c
> @@ -0,0 +1,57 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
> +
> +#define _GNU_SOURCE
> +#include <test_progs.h>
> +#include "test_current_pcomm.skel.h"
> +#include <sys/types.h>
> +#include <unistd.h>
> +#include <string.h>
> +#include <pthread.h>
> +
> +void *current_pcomm(void *args)
> +{
> +	struct test_current_pcomm__bss  *bss;
> +	struct test_current_pcomm *skel;
> +	int err, duration = 0;
> +
> +	skel = test_current_pcomm__open_and_load();
> +	if (CHECK(!skel, "skel_open_load", "failed to load skeleton"))
> +		goto cleanup;
> +
> +	bss = skel->bss;
> +
> +	err = test_current_pcomm__attach(skel);
> +	if (CHECK(err, "skel_attach", "skeleton attach failed %d", err))
> +		goto cleanup;
> +
> +	/* trigger tracepoint */
> +	usleep(10);
> +	err = memcmp(bss->comm, "current_pcomm2", 14);
> +	if (CHECK(!err, "pcomm ", "bss->comm: %s\n", bss->comm))
> +		goto cleanup;
> +cleanup:
> +	test_current_pcomm__destroy(skel);
> +	return NULL;
> +}
> +
> +int test_current_pcomm(void)
> +{
> +	int err = 0, duration = 0;
> +	pthread_t tid;
> +
> +	err = pthread_create(&tid, NULL, &current_pcomm, NULL);
> +	if (CHECK(err, "thread", "thread creation failed %d", err))
> +		return EXIT_FAILURE;
> +	err = pthread_setname_np(tid, "current_pcomm2");
> +	if (CHECK(err, "thread naming", "thread naming failed %d", err))
> +		return EXIT_FAILURE;
> +
> +	usleep(5);
> +
> +	err = pthread_join(tid, NULL);
> +	if (CHECK(err, "thread join", "thread join failed %d", err))
> +		return EXIT_FAILURE;
> +
> +	return EXIT_SUCCESS;
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_current_pcomm.c b/tools/testing/selftests/bpf/progs/test_current_pcomm.c
> new file mode 100644
> index 000000000000..27dab17ccdd4
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_current_pcomm.c
> @@ -0,0 +1,17 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
> +
> +#include <linux/bpf.h>
> +#include <stdint.h>
> +#include <bpf/bpf_helpers.h>
> +
> +char comm[16] = {0};
> +
> +SEC("raw_tracepoint/sys_enter")
> +int current_pcomm(const void *ctx)
> +{
> +	bpf_get_current_pcomm(comm, sizeof(comm));

I think you want to get the pcomm of the newly created pthread. But
the bpf program here could be triggered by other syscall as well.
You probably want to filter based on the "curr_pcomm" pthread tid.

> +	return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> 
