Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B091BD136
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 02:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgD2Ae3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 20:34:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64448 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726274AbgD2Ae3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 20:34:29 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T0YAdU009431;
        Tue, 28 Apr 2020 17:34:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=BvwDNycsTcr1vlXUb5twoiV0kzxQRnQLnzOe8TYoM5M=;
 b=cttwcUGfIj7Q2ssII4EWwnk7MWR2eEv3ntItef0zo9EbKHZCe+yyi1f4MxULi3e17eju
 hSHsEIjZbjHu8CeAL6Kk5ueurroUp60G1FmiU4yaEGtlKb/UhCii1q+a1l9rXNQq39+u
 T84EEEgGYJcoxVZpiqH8XfFd9ErTJvnZ5m8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30mk1gpy3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 17:34:15 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 17:34:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0gXMU3poTNVWSSAC55t7a6ZUFhcNCzTMsFueWn1WsaYNqMlIk51E41QAWHGk3BGkRlx8Xnu3ckyM7RXwJgem3xWexWNWj0AnpElgJm5mdBUMDdKKng8w0KoUGGFpm/GxcmXpKnoxjPW4Z9xRU/ehpOcOri+13unwGjLmz45Hvh8NYikRMTHW9j7WDj4qb5yKhsP5RtiOdgcliWPAguVxcRniqyiJJsHu1TxqWCfosT4y7Mpdl/MHbK9GFlZ/sjJonhIuWSGibvWYVG9J2RqFcqv+LVAKsyf0z+TmktmYWh0B/w+yyVjBrcHjKdXmBhHOQrJzlfDpi8EalzAIpto2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BvwDNycsTcr1vlXUb5twoiV0kzxQRnQLnzOe8TYoM5M=;
 b=ONjpmzcxoVPwmwbKNcLEsWw0B+fqy07v36wF0OByBJVrb5iPz0KXZ55OrEq/Qhzid3yPW98dJGty24pkhJ4YqSznjyh9fXqsTDgGB4X5K1bW33YueC1hU8zgxbt3+E10Mnt1DgcfybT9OQPBMV9NyUVcxnrH7LrDB0bqqnibxy8WRGDlZH/Et0RHeUSEwLuQaRiL39mkPuFqFJIGfeBkb2ICxvtvR4eWrpY3E5XvJqv6XHUSGpK62yWbBftTbghKuFQ9oLtoja3EBEucm0S+FN/wTb7CHA1hAGfvYKtI0Q2sbFGuO2VIKCuWBRc8cQ9bWlX0ob5kWsA4wfeLnIzW6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BvwDNycsTcr1vlXUb5twoiV0kzxQRnQLnzOe8TYoM5M=;
 b=U+Mx2ziT6rWmm/wVuxJwe7mqLInjlPJyH+11iJHdmMGEM1ZKiDWNGwHFSj/CNpoT+1jLflIfcKrThrosWwsjmFdXoFp6gPj5j8sbdQWWDJYdUVgbWiwcy95WFf2o9Itrifmrof42B6Awmw67dnS5ZwsKsDchL0IhcJhd7bFS4BM=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4087.namprd15.prod.outlook.com (2603:10b6:a02:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Wed, 29 Apr
 2020 00:34:13 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 00:34:12 +0000
Subject: Re: [PATCH v6 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200429002922.3064669-1-songliubraving@fb.com>
 <20200429002922.3064669-4-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <290a94fb-f3ee-227c-ffa0-66629ce8327a@fb.com>
Date:   Tue, 28 Apr 2020 17:33:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <20200429002922.3064669-4-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0200.namprd04.prod.outlook.com
 (2603:10b6:104:5::30) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:2258) by CO2PR04CA0200.namprd04.prod.outlook.com (2603:10b6:104:5::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 29 Apr 2020 00:34:10 +0000
X-Originating-IP: [2620:10d:c090:400::5:2258]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56c89a39-b601-442e-8099-08d7ebd50993
X-MS-TrafficTypeDiagnostic: BYAPR15MB4087:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB40877A7B5B9AEC65024DD969D3AD0@BYAPR15MB4087.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(346002)(136003)(376002)(396003)(66476007)(66556008)(8936002)(66946007)(52116002)(86362001)(31696002)(6506007)(2906002)(6512007)(186003)(8676002)(316002)(16526019)(53546011)(478600001)(2616005)(31686004)(5660300002)(6666004)(6486002)(4326008)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8iQFuE/vvpkoqj4yxB+Xgur+YzOyE0qJGUCMVmoiyUyjVeW7CK+Pq7z0XmXxZ0KaPz4X5C84xmsB4D0krQd0reFexBIr03s/aZzdAm4ip3aph+wqnRBBXhvJXtZ9oBsIsHsy9fnhEmlb0H+Pi6cqSi2F9dKHXLR5Kk7/19+qFL9dKDSQSdDfgVNrOjInZ3tRS+evu2PL8zu8I+3kYdu6f873Yxf2+JKoRTiYxl0JHceSHtJfOl58p3frU/CT2WnysD0QB7GmXXiQ9aB4GcoZAJtVB4OcDnx6jwEIx5dMjvBZtnKQcAghziBqn8FVK1m2IY86q4rQriFlpV/d6chTz2+3R+WiWXhbgCNxnGOld1n/Co8zRqYsI4soTgOUJumiZNw2O/05eZRyYrGraDBfwP6LNfvuLg79EOfXH95lXyrFt/BtOaXb6y+6kdF7UpNw
X-MS-Exchange-AntiSpam-MessageData: 6LqXOMgUNiEKWAbuFQ+I6cisRg7zrRK9jcMmXrrSMdb2DS0zoe404lxUKS6/qTd442IA0z/9GDl98/Zs9x2fd9TrY+p5B7qnzj7kxq14fOms2jo++hLabUVtFX45Hldvx9yI3hfyOZ9243vSc8PmdBOd8SKiNJMG2xEnvVBdrj2Lm5PtF/SL/0Zi1pJ3P6fcmhRUh3Se1ZyFBsBGkBQ9NU4E4e9Ih7xmHknr/q3ZbwgNIJgmNMicNXzZlATR798Ob0zZLJ8WZ9PP6WUFDcr+ctjXtdfzSZA/lDx1WCFruOl64dzh/WJcn9D+BjvQ90SzvEgVk/OyBK9/jAPpbCdGsQduO1/K4M5Qz8JbYPEsfoe5tpIFbgCiC+VN1JBuH3fkOMb2Hs5reS+zVeVPVrj5COfc8kuIkqTe/o1xK+nj4w9UXH2R84ryl38+6Uqz7meW8hsD2KxW017UJt52sfBKsOuBRhhsjG7/phjSuxCdqigXzQ8YHH8B8q7CfyH2LN9YGxj7oXNtAbWtwALyz2mIQvGDfk/G0rvXc0GrwkMwigrVhauw5o9Oex4OAze0z+MsIxoR6bO2LsnKnCNw4uaM9UFS4Q0MG+UKxlxNsnKl1SWWLim82rHjBXMNxwdSPgPd3J6QMzYL/ejZdWO1Xp+N1PuOgFq+LGQW4loR1mk5L0r36qABHI02S5ACZ93wIrxXoCjfKNm6QCty9pTWMTNvN1UEps7DrpCpgUAU/LmyRqtLQ2ZZwLQ3wRDjYT66fmgUyDOpZavFr1cjqKxXHsLA8r3n9X4X/MDxas2ip3bY3Xn32QycCE1TNNxtSfWmmt1WcZJPvXlVikCWJgpE5ru39A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 56c89a39-b601-442e-8099-08d7ebd50993
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 00:34:12.5852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fed8FeMPupvw5s3VfEASlZgkfV8ycKfFC2+0bh8Mowu/IZFmO8MANpkdHH1J9m8t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4087
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/20 5:29 PM, Song Liu wrote:
> Add test for  BPF_ENABLE_STATS, which should enable run_time_ns stats.
> 
> ~/selftests/bpf# ./test_progs -t enable_stats  -v
> test_enable_stats:PASS:skel_open_and_load 0 nsec
> test_enable_stats:PASS:get_stats_fd 0 nsec
> test_enable_stats:PASS:attach_raw_tp 0 nsec
> test_enable_stats:PASS:get_prog_info 0 nsec
> test_enable_stats:PASS:check_stats_enabled 0 nsec
> Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   .../selftests/bpf/prog_tests/enable_stats.c   | 45 +++++++++++++++++++
>   .../selftests/bpf/progs/test_enable_stats.c   | 21 +++++++++
>   2 files changed, 66 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/enable_stats.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_enable_stats.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/enable_stats.c b/tools/testing/selftests/bpf/prog_tests/enable_stats.c
> new file mode 100644
> index 000000000000..987fc743ab75
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/enable_stats.c
> @@ -0,0 +1,45 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include <sys/mman.h>
> +#include "test_enable_stats.skel.h"
> +
> +void test_enable_stats(void)
> +{
> +	struct test_enable_stats *skel;
> +	struct bpf_prog_info info = {};
> +	__u32 info_len = sizeof(info);
> +	int stats_fd, err, prog_fd;
> +	int duration = 0;
> +
> +	skel = test_enable_stats__open_and_load();
> +
> +	if (CHECK(!skel, "skel_open_and_load", "skeleton open/load failed\n"))
> +		return;
> +
> +	stats_fd = bpf_enable_stats(BPF_STATS_RUNTIME_CNT);
> +
> +	if (CHECK(stats_fd < 0, "get_stats_fd", "failed %d\n", errno))
> +		goto cleanup;
> +
> +	err = test_enable_stats__attach(skel);
> +
> +	if (CHECK(err, "attach_raw_tp", "err %d\n", err))
> +		goto cleanup;
> +
> +	usleep(1000);
> +
> +	prog_fd = bpf_program__fd(skel->progs.test_enable_stats);
> +	err = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
> +
> +	if (CHECK(err, "get_prog_info",
> +		  "failed to get bpf_prog_info for fd %d\n", prog_fd))
> +		goto cleanup;
> +
> +	CHECK(info.run_time_ns == 0, "check_stats_enabled",
> +	      "failed to enable run_time_ns stats\n");
> +
> +cleanup:
> +	test_enable_stats__destroy(skel);
> +	if (stats_fd >= 0)
> +		close(stats_fd);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_enable_stats.c b/tools/testing/selftests/bpf/progs/test_enable_stats.c
> new file mode 100644
> index 000000000000..aa9626330a9e
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_enable_stats.c
> @@ -0,0 +1,21 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2020 Facebook
> +
> +#include <linux/bpf.h>
> +#include <stdint.h>
> +#include <bpf/bpf_helpers.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +static int val = 1;
> +
> +SEC("raw_tracepoint/sys_enter")
> +int test_enable_stats(void *ctx)
> +{
> +	__u32 key = 0;
> +	__u64 *val;

The above two declarations (key/val) are not needed,
esp. "val" is shadowing.
Maybe the maintainer can fix it up before merging
if there is no other changes for this patch set.

> +
> +	val += 1;
> +
> +	return 0;
> +}
> 
