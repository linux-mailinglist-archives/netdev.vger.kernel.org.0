Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E7E39D4A2
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 08:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhFGGIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 02:08:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28130 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229436AbhFGGIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 02:08:51 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 15760sJX016925;
        Sun, 6 Jun 2021 23:06:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Js7Q7FXk7m1kb4Wr4hnZ47I0ZDqBB3UyBkQFKHDAsng=;
 b=hPQ8z0T/CxLgtjSAvhJIWkEKmLn0ZSDSXEW4rJl46VE+ZIqa6mEikKFrNk5CXMky1Nb8
 orhJxQPQx5ZToYcCkXUQwqOfoow2KcXiKrRPEciuxDUcmiht5e02MGhRiLamH+gGlaoP
 tVV/dO/iHwqsFDv8JpAhWl9pQFBt989ndEo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3904sbffkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 06 Jun 2021 23:06:19 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 6 Jun 2021 23:06:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VjtKb4uu8K7a2QKp1XC3IBoHZ+/cNb1UjHAFkhagyOU/Yh8Aayd9tCOf0+ayADgu5ROpmDo5MtispyzVXWlkHwYKxc+oStvOOYvHzh7xVjbhcg+707cXCqi1p68Fk7knxY9vxhgwwDVttI0atA8C6+bws5W4c4/ZBcX6P4+DCE1ZFBKeCkv3Q08V7qxA8jYWYzD73LQ0DFyxPqD6tIOEBAloq6QfylBj3iyO7qgV72x1rPGaH3lbfYBkSP6RQMtiDqIrKnezUba8DMWAWe30dSO9GnBz84kKB9KS+efNxbO5PFvgVRC8gMebjnmMCao8WIxcDiAOAklNI5F0F190ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Js7Q7FXk7m1kb4Wr4hnZ47I0ZDqBB3UyBkQFKHDAsng=;
 b=NesxNReKdRka7g2vs6FGAf8T4wSCiyhYVKNa208sU9W5dhmPpfyaZ0D/3FmdjwoGNxSWxE6wzQ58/p2SN+aGWF/M1AhynrsgVhgYzeE2e8XSjUP1Zj7/gjp6WBf9BUeYKsOAyuf2Tjg9WU//aegCjL8TMfbEOV1zdNQfaujl9ePLsJufXP/8SQrgf27pMqY2BDC9eHEkowiAbogwUr1a8wLJNRJAyqHRdVrKQyGlFhkHQ84zG0fUiEN73uVzb1nH5Wpvx1+X7bUo/tk8UzdxMpeU1MzrL8Uh2oqYu02/tOVU0a81lxBkaDAuv8JO5Q53la18LJmUkf74/hwBKd9GpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4420.namprd15.prod.outlook.com (2603:10b6:806:197::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Mon, 7 Jun
 2021 06:06:17 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 06:06:17 +0000
Subject: Re: [PATCH 16/19] selftests/bpf: Add fentry multi func test
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-17-jolsa@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <1f3946e8-24eb-6804-e06f-8c97f5145fb7@fb.com>
Date:   Sun, 6 Jun 2021 23:06:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210605111034.1810858-17-jolsa@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:9a26]
X-ClientProxiedBy: SJ0PR05CA0143.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::28) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1097] (2620:10d:c090:400::5:9a26) by SJ0PR05CA0143.namprd05.prod.outlook.com (2603:10b6:a03:33d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.12 via Frontend Transport; Mon, 7 Jun 2021 06:06:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02e93383-92b1-4357-b159-08d9297a5ce5
X-MS-TrafficTypeDiagnostic: SA1PR15MB4420:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4420A62230E1DA34D47D5354D3389@SA1PR15MB4420.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:107;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: US6gFD+LqXxCR3w/S/H/4jz1QgE0mVIXDelFnyPokgREUHAWsk5730fQnnI4kTK1+4GKvtYza+DFOlGl5/Wx+YPPQallikNKRKW9aogX13+BeocZsVZ4YU7MB4Ckg93VyM7GlTxI6C0YbAAq2C7NutxJ1IketAN06rUuQLNOQTnjEdWIanY4/idN0bA4q4mxHuFGUoEisEDYCx7YpuhSyaceRBKIJ2jzV+WpJy/u9hfoOk7A3JI1TAhia2V71cAGkalNavoatZkwl1fHbn3ZPHvsno4DDxcrVV+YwIkl/zr7KPKy6eo79G3oY7WRJ+F9bXfeo5IZaanxT9oSC5t74Q/QPrH5LCCXKRukglJuDFr+zx5AFY+gITSuBf3DIDYtn/leV7XsJsRekiJQ485XMZ/W9SZIgyiy3fcjIMVReEFJ5074lmzMeua+DhQXREbxreG3PQzCOQctRlJuB9WZUFPw2wR2TrPKC+H5f8k96oxpSnzIa7yvQAcKhpnkzt2PY2RMwpfhe9F4XxITCFMSmSJk2KQj9RHFx0AEqD+hts5qERYGaq2koTMfOWK4+UtMxmqe+3C4H75QjnoSRcM8MAWDGvuBMJQhuYJBmrIIwnzqvhOP70xL+x4bpn3xFnJmh4tI831z5iz/47kZ/kht42iWp8yQAlpt41V4h10QrehCI1PhCGk4+Nt8n95dz7ax
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(66946007)(54906003)(110136005)(86362001)(316002)(66476007)(5660300002)(66556008)(186003)(38100700002)(53546011)(31686004)(52116002)(6486002)(36756003)(8676002)(8936002)(4326008)(31696002)(2906002)(16526019)(7416002)(478600001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?W4f5WBztyDRzyasw3+jj/nr5lOb/e3/53kBssDBl9Q5SCtbJvVS2O41p?=
 =?Windows-1252?Q?eYW/v+M8LKbLsk+NTyhlvQ10n9qy+TjfF/Xt0chIzKYrpo8HJOVapO+P?=
 =?Windows-1252?Q?vyvcM1fck1UD4WmUNxuHNn74hphzHk/gQQpVmXmt8jPHtBvw6Lca2OXu?=
 =?Windows-1252?Q?e35oonBkIZtkjhM3rTCbToV8uHOq4O3UXQjola/m8nIVV2t3p7WwCWtz?=
 =?Windows-1252?Q?wrtDKVSerUXYCmqINuV2z7XF5GGjRo+SgzxDtpxv26VK1CsDynP2ZGaW?=
 =?Windows-1252?Q?fOWp/ZoAK1sTYTW6QA1SJ1ONIFdoFGNaRDlGwegl4kz02w0cTFVZIjdo?=
 =?Windows-1252?Q?SX1AZmoSsx5Ghl3X74+a9WFzGEfmjcEtZz4In+JzZMHjJPZ7Gej+pbgG?=
 =?Windows-1252?Q?8yvWqFeAct6NlU63yFdLRKC3ZfKGs01SbJHjTwQqcq5KlYE9Q/TvHrgd?=
 =?Windows-1252?Q?0P2z2Vgt04pfWC00Qm0Bh+yTuJI/PAfmLklmqXiy1/lgm/ygKRhQXP6a?=
 =?Windows-1252?Q?0n9wi5kTCRXw8S34A/4AgH9Q/ybw4Xzo+NeHrhyc6y0jwRJaV7o2AVYi?=
 =?Windows-1252?Q?H67eoKX5u2g54pp/ydn5rar6E0733kRtEpvI8u71HxBaXARxwdbmjGzE?=
 =?Windows-1252?Q?vqDuKN5buK8sZ6DlyMOabDULh+dVxAsRGgnMM+pDZSjW0Fsm1ADTFXyc?=
 =?Windows-1252?Q?PbFwdjvcj5qN2zQla9iIu4SXtzBNfaHPXD6P90iSM4WsYoHmBQylK/yO?=
 =?Windows-1252?Q?pEu12P8DgIZxNFJp1YvnRiXJ+eBGoS7RVDcv0EelsGpuKHQKh3uMZYXX?=
 =?Windows-1252?Q?b3RF/FvFvCBrOrsxt/xqb+83XqDCSlZye6TdVt6N8pHCH5y3Xa/PUtyj?=
 =?Windows-1252?Q?dIsK5jjsiKSsFCRwv1sAs5rqhg0Qy0MM8fsEDPKqlJY/9lIVu6Ewc5dv?=
 =?Windows-1252?Q?8fLhwV4aKBWF9Vb4cD/2qGNiuUIUTO3f9rGZLUEpCY8wYS9iCGTpSRLF?=
 =?Windows-1252?Q?n+lizTEkWpe4itrIeq6SQ4ogLsL15dYPNduPD2VaSSQvHx2QxUPbOF/H?=
 =?Windows-1252?Q?H4a5FUTQwWwAlrF9D2POJpDDLV1jQWrbmTKi46VMuBfBm/rnccuCkbtG?=
 =?Windows-1252?Q?qXvy4Dm2s12HgOIBhDoiExGadbmbMYXenyD/qgQ1ZzjUS/J7hdxYOkkf?=
 =?Windows-1252?Q?I+dWE/9wAVRywx7h6v04ReOFw4Wshonygou/Yvmk5M2f9GFdYirY2CNQ?=
 =?Windows-1252?Q?cC+c521ZoIvEsHR3EtcIEhOvxVbVKIoNg42UhAv79o2BiQLJpnRDidr3?=
 =?Windows-1252?Q?RW2NXW9KRqqdj3tWQB9LuZpUlRDnnJ8goTcsups8X1/792dDASUTUskj?=
 =?Windows-1252?Q?ci+SRAPmhuQKOv7WjVoADOWz3sRjxhhxnEet5KDotlEbaSYwFx6KhrIG?=
 =?Windows-1252?Q?AWBVr5GKxTOIxxc+Op3MFdkSBSiW29rbg5fn2Q5mSsw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 02e93383-92b1-4357-b159-08d9297a5ce5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 06:06:17.2950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G5VWe8k2qyect9To5/kPeX80J6seFilHJkjDQKtwHSMQQLIzq2gd6M59rCKPBbod
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4420
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 6SOYFgjAj9fFt8LF2pHIIqXmIEJzpSK-
X-Proofpoint-GUID: 6SOYFgjAj9fFt8LF2pHIIqXmIEJzpSK-
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-07_06:2021-06-04,2021-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 mlxscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106070047
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/5/21 4:10 AM, Jiri Olsa wrote:
> Adding selftest for fentry multi func test that attaches
> to bpf_fentry_test* functions and checks argument values
> based on the processed function.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   tools/testing/selftests/bpf/multi_check.h     | 52 +++++++++++++++++++

Should we put this file under selftests/bpf/progs directory?
It is included only by bpf programs.

>   .../bpf/prog_tests/fentry_multi_test.c        | 43 +++++++++++++++
>   .../selftests/bpf/progs/fentry_multi_test.c   | 18 +++++++
>   3 files changed, 113 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/multi_check.h
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/fentry_multi_test.c
>   create mode 100644 tools/testing/selftests/bpf/progs/fentry_multi_test.c
> 
> diff --git a/tools/testing/selftests/bpf/multi_check.h b/tools/testing/selftests/bpf/multi_check.h
> new file mode 100644
> index 000000000000..36c2a93f9be3
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/multi_check.h
> @@ -0,0 +1,52 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef __MULTI_CHECK_H
> +#define __MULTI_CHECK_H
> +
> +extern unsigned long long bpf_fentry_test[8];
> +
> +static __attribute__((unused)) inline
> +void multi_arg_check(unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, __u64 *test_result)
> +{
> +	if (ip == bpf_fentry_test[0]) {
> +		*test_result += (int) a == 1;
> +	} else if (ip == bpf_fentry_test[1]) {
> +		*test_result += (int) a == 2 && (__u64) b == 3;
> +	} else if (ip == bpf_fentry_test[2]) {
> +		*test_result += (char) a == 4 && (int) b == 5 && (__u64) c == 6;
> +	} else if (ip == bpf_fentry_test[3]) {
> +		*test_result += (void *) a == (void *) 7 && (char) b == 8 && (int) c == 9 && (__u64) d == 10;
> +	} else if (ip == bpf_fentry_test[4]) {
> +		*test_result += (__u64) a == 11 && (void *) b == (void *) 12 && (short) c == 13 && (int) d == 14 && (__u64) e == 15;
> +	} else if (ip == bpf_fentry_test[5]) {
> +		*test_result += (__u64) a == 16 && (void *) b == (void *) 17 && (short) c == 18 && (int) d == 19 && (void *) e == (void *) 20 && (__u64) f == 21;
> +	} else if (ip == bpf_fentry_test[6]) {
> +		*test_result += 1;
> +	} else if (ip == bpf_fentry_test[7]) {
> +		*test_result += 1;
> +	}
> +}
> +
> +static __attribute__((unused)) inline
> +void multi_ret_check(unsigned long ip, int ret, __u64 *test_result)
> +{
> +	if (ip == bpf_fentry_test[0]) {
> +		*test_result += ret == 2;
> +	} else if (ip == bpf_fentry_test[1]) {
> +		*test_result += ret == 5;
> +	} else if (ip == bpf_fentry_test[2]) {
> +		*test_result += ret == 15;
> +	} else if (ip == bpf_fentry_test[3]) {
> +		*test_result += ret == 34;
> +	} else if (ip == bpf_fentry_test[4]) {
> +		*test_result += ret == 65;
> +	} else if (ip == bpf_fentry_test[5]) {
> +		*test_result += ret == 111;
> +	} else if (ip == bpf_fentry_test[6]) {
> +		*test_result += ret == 0;
> +	} else if (ip == bpf_fentry_test[7]) {
> +		*test_result += ret == 0;
> +	}
> +}
> +
> +#endif /* __MULTI_CHECK_H */
> diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_multi_test.c b/tools/testing/selftests/bpf/prog_tests/fentry_multi_test.c
> new file mode 100644
> index 000000000000..e4a8089533d6
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/fentry_multi_test.c
> @@ -0,0 +1,43 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include "fentry_multi_test.skel.h"
> +#include "trace_helpers.h"
> +
> +void test_fentry_multi_test(void)
> +{
> +	struct fentry_multi_test *skel = NULL;
> +	unsigned long long *bpf_fentry_test;
> +	__u32 duration = 0, retval;
> +	int err, prog_fd;
> +
> +	skel = fentry_multi_test__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "fentry_multi_skel_load"))
> +		goto cleanup;
> +
> +	bpf_fentry_test = &skel->bss->bpf_fentry_test[0];
> +	ASSERT_OK(kallsyms_find("bpf_fentry_test1", &bpf_fentry_test[0]), "kallsyms_find");
> +	ASSERT_OK(kallsyms_find("bpf_fentry_test2", &bpf_fentry_test[1]), "kallsyms_find");
> +	ASSERT_OK(kallsyms_find("bpf_fentry_test3", &bpf_fentry_test[2]), "kallsyms_find");
> +	ASSERT_OK(kallsyms_find("bpf_fentry_test4", &bpf_fentry_test[3]), "kallsyms_find");
> +	ASSERT_OK(kallsyms_find("bpf_fentry_test5", &bpf_fentry_test[4]), "kallsyms_find");
> +	ASSERT_OK(kallsyms_find("bpf_fentry_test6", &bpf_fentry_test[5]), "kallsyms_find");
> +	ASSERT_OK(kallsyms_find("bpf_fentry_test7", &bpf_fentry_test[6]), "kallsyms_find");
> +	ASSERT_OK(kallsyms_find("bpf_fentry_test8", &bpf_fentry_test[7]), "kallsyms_find");
> +
> +	err = fentry_multi_test__attach(skel);
> +	if (!ASSERT_OK(err, "fentry_attach"))
> +		goto cleanup;
> +
> +	prog_fd = bpf_program__fd(skel->progs.test);
> +	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> +				NULL, NULL, &retval, &duration);
> +	ASSERT_OK(err, "test_run");
> +	ASSERT_EQ(retval, 0, "test_run");
> +
> +	ASSERT_EQ(skel->bss->test_result, 8, "test_result");
> +
> +	fentry_multi_test__detach(skel);
> +
> +cleanup:
> +	fentry_multi_test__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/fentry_multi_test.c b/tools/testing/selftests/bpf/progs/fentry_multi_test.c
> new file mode 100644
> index 000000000000..a443fc958e5a
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/fentry_multi_test.c
> @@ -0,0 +1,18 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include "multi_check.h"
> +
> +char _license[] SEC("license") = "GPL";
> +
> +unsigned long long bpf_fentry_test[8];
> +
> +__u64 test_result = 0;
> +
> +SEC("fentry.multi/bpf_fentry_test*")
> +int BPF_PROG(test, unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)
> +{
> +	multi_arg_check(ip, a, b, c, d, e, f, &test_result);
> +	return 0;
> +}
> 
