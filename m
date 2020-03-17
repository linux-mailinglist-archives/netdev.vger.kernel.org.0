Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE45187948
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 06:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbgCQFgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 01:36:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60338 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725468AbgCQFgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 01:36:09 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02H5Z0GB025954;
        Mon, 16 Mar 2020 22:35:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=5XEl7KAjBGxm8iqYt8DiaZQIByveyxXPYDcwgIxqf+g=;
 b=hlmYeTVZizxV6MvK7mrAunD85ssTkt8ETnhon7wYLG7PQRaMUmwP2W9fJ1VlghxYz/+k
 sEnmxc1JOj7+bHNtV7jM0YY0V5Dq2cCgcqWJqS0eTfYK1OiFe8bHQi6EHusPPmGXKnNY
 ij98EXjk+CIe20oUBl2rfwsloZ8rp+Vu528= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ysf9p0m05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Mar 2020 22:35:55 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 16 Mar 2020 22:35:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVBmaTvahi6/G/n90NYijr81fJ/cuZG7q8F+PXLrs1Vpssm8FqIFH6+DxexgvYrgDmjUAsmj4nVJrAWesCumJeAYJcU3efR7t5yh2Kz1swYM+YtvZ2na1oAMhANNsKULMWj3Vf0paGhL9wRn4XTG9FZpWZWCxhtm1eSHzeEzHK+mu52gCdSyLBv81bPREmL1zY2bYHrWzY1LR3jRJNZDal5tLSRjxeLyf5UxzlpYhPyYOjB4BmnjaTRhcuqezlK/SaEaxG7PGbPdSQ/hib/8Q5KzWw7fftVNBLPU5owpAIlFEkd/ZA/LD1M6oOdY/rpU7XvLdMXB2wTAbSiXg5fNQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5XEl7KAjBGxm8iqYt8DiaZQIByveyxXPYDcwgIxqf+g=;
 b=LJOr4T4kGJD8dbE0E3+8PjddL+2KYMDI3VDzRaJ3RxxUJ3HSrMA8NA5RhRowGnOmMaS6qs+m8sdFiGaX/7tO10MXdOLNPqUSpdw2ysS/xDmlqle8MSopHdTAWPM/wgvpw1wyPkyn2QpXH6DPnU88qLwqSmLiJdWBE71ZSt1co5+SBQAmrDsHjDkuJp2zGfdxiuQg20Ye1IWNZqqYDogpg9GTUUr+rRtK209Px9i5QfgLhZCm453qZ/+Axsf4gBJiInDB/30uFPJjqX8D4DMG5YMPFRpFYhYijYVgQBDtb+3Xqrn71mYYGh9lJCLgRBCGH+FETniuXMfMmE2WrjQD/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5XEl7KAjBGxm8iqYt8DiaZQIByveyxXPYDcwgIxqf+g=;
 b=Fq7QPrBG+ogbG3mObkewTOFhcgETnTzTOSnZmtBvaDhBgkXIcC5sY7Svg2d3YUS077DUxmSm5syB6JXFtdItAg3C99e68TagqqoGJ9dEhTI8V8cVrxMjgyRRDeyXHfbTij4zS1xI3Pl7k9bOVS+RB6vN6uesmCoUqEZuiPOTX24=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB3224.namprd15.prod.outlook.com (2603:10b6:a03:105::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.19; Tue, 17 Mar
 2020 05:35:53 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 05:35:53 +0000
Date:   Mon, 16 Mar 2020 22:35:50 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next 3/3] selftests/bpf: reset
 process and thread affinity after each test/sub-test
Message-ID: <20200317053550.uk2lzcqfrrmgsdq7@kafai-mbp>
References: <20200314013932.4035712-1-andriin@fb.com>
 <20200314013932.4035712-3-andriin@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200314013932.4035712-3-andriin@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR11CA0026.namprd11.prod.outlook.com
 (2603:10b6:300:115::12) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:e745) by MWHPR11CA0026.namprd11.prod.outlook.com (2603:10b6:300:115::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.21 via Frontend Transport; Tue, 17 Mar 2020 05:35:52 +0000
X-Originating-IP: [2620:10d:c090:400::5:e745]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b7fcd10-6262-4d46-11db-08d7ca350ed9
X-MS-TrafficTypeDiagnostic: BYAPR15MB3224:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB322439917B7610C0F82F73F0D5F60@BYAPR15MB3224.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(376002)(346002)(39860400002)(396003)(136003)(199004)(55016002)(2906002)(1076003)(86362001)(52116002)(6496006)(81156014)(8936002)(33716001)(66946007)(8676002)(66476007)(186003)(16526019)(66556008)(478600001)(316002)(6862004)(6636002)(5660300002)(81166006)(4326008)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3224;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B3uCgUcg77u6bTiS2lws07ma3I5k7fKLgcIocvY629k5LmDd3ePt63/zdn8cP8mRahiBVT8nqiPSBPsbAgeaZ1PZmCDaVQQ9gLnNYgCDmkhY50mE/zz7i4wtw93vu5ZqibwoJTKixGUFrm4qhnO2Li6CavH6dWpY/Bi0f+LyA2Z4EIECtNrDlHB6K7IgOYh68PGhraszcqT/b6Uk+f5exC88C3nY0I20o3O7pmBxNwDv5Km4h8vJKOoCEsdQao/fAuyhyyxWO83q5kt/j1oMF3jWYY2r1uK1fdMOPIDTMVEZJcfV/mwiNGAaPftM6H7ICZL1kJeXWd6DGmvPGqAS3TqXAo3t/LFEEzp8X/sil22JHR3CGpBHd213qrY/k2SW5WhujeoD9CZl+lW1mZDW/+kxArmdyg1OseehTF/njrIg2Z8t6AbffluZygTzWrfI
X-MS-Exchange-AntiSpam-MessageData: YcxhoT5Zc7ZhTCCTRNucHM93rB8cVg6Yd+qtnLhEUfNM5iE4mbXsbmoSF8deMAx22ElSMHwO3ipKqSpj3yYGaeEA+G7lXF7qHWbT8mwlwG47lh71jACifNl0KAcZINIqfx7luYakRVqCe0sQjA5L3HUGzyzohxrV/Gafy+OUmWjhKm/77EyTWfZhlG8HDBY+
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b7fcd10-6262-4d46-11db-08d7ca350ed9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 05:35:53.0127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aCdix47vedxISdxJhkvHnD0lX+ggGL08nPaWup2Qao/XVr/XJcLHfXhvSOUw7+7R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3224
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-17_01:2020-03-12,2020-03-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 impostorscore=0 spamscore=0 clxscore=1015 phishscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170024
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 06:39:32PM -0700, Andrii Nakryiko wrote:
> Some tests and sub-tests are setting "custom" thread/process affinity and
> don't reset it back. Instead of requiring each test to undo all this, ensure
> that thread affinity is restored by test_progs test runner itself.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/testing/selftests/bpf/test_progs.c | 42 +++++++++++++++++++++++-
>  tools/testing/selftests/bpf/test_progs.h |  1 +
>  2 files changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> index c8cb407482c6..b521e0a512b6 100644
> --- a/tools/testing/selftests/bpf/test_progs.c
> +++ b/tools/testing/selftests/bpf/test_progs.c
> @@ -1,12 +1,15 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /* Copyright (c) 2017 Facebook
>   */
> +#define _GNU_SOURCE
>  #include "test_progs.h"
>  #include "cgroup_helpers.h"
>  #include "bpf_rlimit.h"
>  #include <argp.h>
> -#include <string.h>
> +#include <pthread.h>
> +#include <sched.h>
>  #include <signal.h>
> +#include <string.h>
>  #include <execinfo.h> /* backtrace */
>  
>  /* defined in test_progs.h */
> @@ -90,6 +93,34 @@ static void skip_account(void)
>  	}
>  }
>  
> +static void stdio_restore(void);
> +
> +/* A bunch of tests set custom affinity per-thread and/or per-process. Reset
> + * it after each test/sub-test.
> + */
> +static void reset_affinity() {
> +
> +	cpu_set_t cpuset;
> +	int i, err;
> +
> +	CPU_ZERO(&cpuset);
> +	for (i = 0; i < env.nr_cpus; i++)
> +		CPU_SET(i, &cpuset);
In case the user may run "taskset somemask test_progs",
is it better to store the inital_cpuset at the beginning
of main and then restore to inital_cpuset after each run?

> +
> +	err = sched_setaffinity(0, sizeof(cpuset), &cpuset);
> +	if (err < 0) {
> +		stdio_restore();
> +		fprintf(stderr, "Failed to reset process affinity: %d!\n", err);
> +		exit(-1);
> +	}
> +	err = pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cpuset);
> +	if (err < 0) {
> +		stdio_restore();
> +		fprintf(stderr, "Failed to reset thread affinity: %d!\n", err);
> +		exit(-1);
> +	}
> +}
