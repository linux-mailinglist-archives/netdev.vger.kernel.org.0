Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEA357D9FF
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 08:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbiGVGHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 02:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiGVGHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 02:07:48 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFCB54661;
        Thu, 21 Jul 2022 23:07:47 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LJkduh005827;
        Thu, 21 Jul 2022 23:07:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=uAUOKHHM6sSzK7Nd7QR93ZMEKSYd8eIaWwcF+YptNUE=;
 b=AtqxALpDAfFlcl34XxqJ0dAfRfkb5vn9DtPRL57OTrBh4mDu9dVVfTMRg/NAfdZR+4kl
 qHy0QsEsBrig/9MrHn8hHD+vcne/2bXv/dBGpyH7EQbMKOkBoLOrmqEX1JEwlDTa9KJ5
 OY0HFIs6qiJ36kHUxDQbKYYfZ9YVtMKwVBg= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3henhbb1fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 23:07:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7T8P3hnZnqg2HGYVBO9a6JBBeEK9M85ub3VK/fTajqzX1GTla4hAvrw5fzNdxnSgaqMHWCj0a2SeZ8sm8uhFnXX9gQizAav6a53TLr6suA9zC0GWFcQCDBghtYf7BgrVDS+b0Xn4Jh3Hm6Fuz8nqz8q8wFK3SFjgB2fZ6uFuvi7jb2Q/ZTqZk5sl65sSwo1uTffYv0qr0gM9PCfzt6qYWDDsgdG1Z66xCm1NH0O+1RUx44mCZ+MPINRyjHXxsdm90za4FLgMsXallhWxroUiwD59cxSfGCs7ioaP7PYDzgXSGl4k8VFSFvRLM7FlTVHB08fj6Mg/TOeoKT99wLrng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uAUOKHHM6sSzK7Nd7QR93ZMEKSYd8eIaWwcF+YptNUE=;
 b=YoePRZZu14rkNzMrg4DHjLYSLbfdARP2xImtr5IOSUwh4gYoxkAw3p48wK+2+NYozJuoa6ksZDZHtsjXtLft+jQ6NnXFUlcp/icAw1Eq3vfw0tDQRp4i9i4zz7UKqMhcjmOoxELs1wS5YmMB3EGHiV/ETZT6/0Y41aMenByU2GyznWEWpYVLNKJ5TvlvB9DXvh/3RK9GAOErIR8RLOZY0iLPaz8rxk/+a7yvf+ODJzTfK1jEA/LhNqGXMI4fKMDH9gytyGKTSOn6f8/k10ndgdWScl2DVo3lqEFiTr3GO/56sTlzOSTH0f1YpbZFQNxTy+/rKf6xUC1It39ecRcS6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BL0PR1501MB1987.namprd15.prod.outlook.com (2603:10b6:207:31::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 06:07:10 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::a88e:613f:76a7:a5a2]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::a88e:613f:76a7:a5a2%9]) with mapi id 15.20.5458.019; Fri, 22 Jul 2022
 06:07:10 +0000
Date:   Thu, 21 Jul 2022 23:07:06 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     kpsingh@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, brauner@kernel.org, casey@schaufler-ca.com,
        ebiederm@xmission.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com
Subject: Re: [PATCH v3 3/4] selftests/bpf: Add tests verifying bpf lsm
 userns_create hook
Message-ID: <20220722060706.y6keqvyvzdvkmc6i@kafai-mbp.dhcp.thefacebook.com>
References: <20220721172808.585539-1-fred@cloudflare.com>
 <20220721172808.585539-4-fred@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721172808.585539-4-fred@cloudflare.com>
X-ClientProxiedBy: BYAPR02CA0041.namprd02.prod.outlook.com
 (2603:10b6:a03:54::18) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f9adebd-96a5-4e72-d716-08da6ba869a6
X-MS-TrafficTypeDiagnostic: BL0PR1501MB1987:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IVNzP7HnDGrG5VkCn7A6KUwkbp/95S3I7+syP13VRW/Z3MtOssxXys9ryBVJ0GsrIspQjrlnh5w/CDZliVO6/N1KaJQfQxCgaaCyabXVQLLG/EglxqEoCvoypMNkrg6h30vSlW6Z8oibm5L0Ac6Pqy+yZAhgltD70OjWvkaim/WD36BArLvgNe6eOdIO7iIdseoFX1mqs3vRQTS0qcohV1WMlzSrJj7ASAIohYlCJICStd+WVIPQWjOPJQJpDV96tIpmh+u+58BH10jnmTs8mK6IjetWMXx4U1mc7v4y9y1esa9AHrkHL0fLwDdzE7ZrEglMLcK2RY9ZBgMVqraACZydwMLxapyvUABOKw8jE/yqYQkecuMeAmFDSl8zhcv92zRcue1QKFhPJjEu/Le6zvNi0Xcfl2jFHhoVnDuotF6JXTpuQZxQLMaycLH0/HeXuNmZ1rdyqaXCrrOxb29Iz+tNA0JRv5k0IXD6D+Y7wgCYsLhWIS/iE2Uea1VDxTF2aDm0FErcMlFbjbfPLggs6wUUXIRIMHItXvKghdeTziHv9dPh8R6OgEom8AVEDrhVvXJd4byX6hgvEVaLmX9GhNO0aCqXdkXtQf+LFMCAItY54hJHg9KKQ7EkeNUaAQxjtKhznG/JHD2QQJL755FLenmoCM9D+Dujv5Qxhlx10Brf3e3gbkRqjB2CWmioaNv0y/Cv+eEcA6mKUhS5RxwtBS+/5F55M57ooxdWtpHUjf30DBdms/+LixiRm03RhQH9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(5660300002)(4326008)(8676002)(8936002)(7416002)(66476007)(66946007)(66556008)(83380400001)(2906002)(52116002)(38100700002)(86362001)(6916009)(316002)(9686003)(6512007)(186003)(6486002)(6506007)(478600001)(41300700001)(1076003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tDJBXHQhQ7CEO1pVg84iP+q5A4tJqIvO0syVmDeMA1CqxSXM/0TYpUCUSmy4?=
 =?us-ascii?Q?XSAwdGWaBHvJYA4dpOApRu7cQ9DZRFgFiKl9hWWD/Sjuth8tl0b/h3YujZC/?=
 =?us-ascii?Q?NWQKvlrVfwzzsE3x6KwNRhCeH2rpHEbOxAFhG3ogjUrC9TmbFpaeKNLWJ5XT?=
 =?us-ascii?Q?I0kdr3u861nfMQxuYjyTmmvucRkw7+ijQx/ofDSXn4DaViNK7Y4SvSGRg+Q5?=
 =?us-ascii?Q?tldLpHx/gNblL+cF9mHwKHjl6kSt5AwZbcVbu5PC9GOG2WlNr0DKTzaGiXEu?=
 =?us-ascii?Q?0VPDLLvYdFPyYmDca1wMjEGYKunkpk5gSlgFrIHNw3K8cG621m86rGtt9ty6?=
 =?us-ascii?Q?ai9aF3amQffLF2kkBKfYdQwDaGmLE3SFf4KSHCKQ+2G57ie5OgWyxAp8nvZS?=
 =?us-ascii?Q?dgqu75Bjg7oGI9aWC7k87xfHa+2bAyrLqYkTEI+NsMTiVU3gYYQ8d1z1IMq7?=
 =?us-ascii?Q?sEinB+W6XzqeMWYKiPw3E0JHugDhrkpXoYFDyeD0izMP5v7ubJzG/g+gYr1Q?=
 =?us-ascii?Q?kH0OnbiXfksKwNb8oSUSmgyAlvt2Vg1avv1lNQ+tf8IdSnpCDs7Ic8wIKIKf?=
 =?us-ascii?Q?TENZEugirNMa71AUrnK3Gnf+26flEj5DazuV8OZmGRrNJvUqw9vAA/f59sOQ?=
 =?us-ascii?Q?GUHx1mhzBS675e7/JYoQ9JU4tzpMXHEKPA1oTD1RDVzxanyzaRXcYWlHfTw/?=
 =?us-ascii?Q?tSct1sHvyTRZLQfGUIaJh1XQf7WsrglS/oOOsd21gun6qT55u/Lk/MW1SCTF?=
 =?us-ascii?Q?JhNI/1VlNrIOcDJpoyfqig3gyRXpTOx4QzIp7V4Dhc/gV2WQnUMlvb4Zr+ia?=
 =?us-ascii?Q?t9y2BADm/tcZ70W/xE7PK7zTsahmo5Uge2+Jy8kQ/QjbbuBgTlrH2rTt3lbu?=
 =?us-ascii?Q?QkjwX8ke7d6fXPG+3h9FN1HCmoiL7ArUdkMNXe6KXyrkutgei4+8OYK0ixYB?=
 =?us-ascii?Q?/yIfB8lQzFBdxuFTPefh9q1i0Qxm8xH1fUlHRZ5Re+P2liBX28UHKPq4ygMW?=
 =?us-ascii?Q?599wPPdKN1yFiKNJyCyg3VDuF6EQ7BsDH3coWbbkI2hANztuQ6vo3TzLLCsX?=
 =?us-ascii?Q?Sj7XAluyPajluWvi4CJgbKagpKm+PMNMPWz+SskzfAEIwVxTqepfaHOPT3FZ?=
 =?us-ascii?Q?1CtVNudJba9ho91TSLIFgunQeOauJLHyJE+B3BrLkS2IUwK/rR+wwV3vZTR9?=
 =?us-ascii?Q?/Muxv0KPWFQ/K5246C1LHXH+/rZ/ApPu0A/CFqZIQtKBhChfIjFIFxSKCA5A?=
 =?us-ascii?Q?Lra4WoVBDmeIMRqA4DVu0G37qKMj/S5CXu13I9S1oU9XqTfsDZSLs/8ppgHv?=
 =?us-ascii?Q?gIH6SehxM6idUzpXPCdddSBzd7SQklbYOVXi5yBIYacJMPmFS+Kx7lj5FR5/?=
 =?us-ascii?Q?abhXASX0socCX4gLa912or854KO5K/vx2QxpGwC5s5I7GTFz7uhavgs9f3Et?=
 =?us-ascii?Q?jts7+LeX34Yic5N8IqbrpY6H1oHy3FprEn6IUfZ8Pu/B2mg4mR3vEITWi4IE?=
 =?us-ascii?Q?bYkZZo9r1g2fiwU/5IwqOrX1Gkx7WAuVAYQN8WJSAAHWiRPn7EZZFR88v972?=
 =?us-ascii?Q?sYpbnK097SwLGjPBLjFev4t+0R8GfpqAk0w/k7zZTCcQy8Qc+f27iOFoJPbb?=
 =?us-ascii?Q?9Q=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f9adebd-96a5-4e72-d716-08da6ba869a6
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 06:07:10.0846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iUk9+oZvVKkDDYA4YVcljMgGSYmbfpTcCQNzOkECr9p5Sri1L0CQNCV56xEl+Rdo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR1501MB1987
X-Proofpoint-GUID: 2WlS2idNPTqc12bT4wOq6aI5uCK2ixyN
X-Proofpoint-ORIG-GUID: 2WlS2idNPTqc12bT4wOq6aI5uCK2ixyN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_28,2022-07-21_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 12:28:07PM -0500, Frederick Lawler wrote:
> The LSM hook userns_create was introduced to provide LSM's an
> opportunity to block or allow unprivileged user namespace creation. This
> test serves two purposes: it provides a test eBPF implementation, and
> tests the hook successfully blocks or allows user namespace creation.
> 
> This tests 4 cases:
> 
>         1. Unattached bpf program does not block unpriv user namespace
>            creation.
>         2. Attached bpf program allows user namespace creation given
>            CAP_SYS_ADMIN privileges.
>         3. Attached bpf program denies user namespace creation for a
>            user without CAP_SYS_ADMIN.
>         4. The sleepable implementation loads
> 
> Signed-off-by: Frederick Lawler <fred@cloudflare.com>
> 
> ---
> The generic deny_namespace file name is used for future namespace
> expansion. I didn't want to limit these files to just the create_user_ns
> hook.
> Changes since v2:
> - Rename create_user_ns hook to userns_create
> Changes since v1:
> - Introduce this patch
> ---
>  .../selftests/bpf/prog_tests/deny_namespace.c | 88 +++++++++++++++++++
>  .../selftests/bpf/progs/test_deny_namespace.c | 39 ++++++++
>  2 files changed, 127 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/deny_namespace.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_deny_namespace.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/deny_namespace.c b/tools/testing/selftests/bpf/prog_tests/deny_namespace.c
> new file mode 100644
> index 000000000000..9e4714295008
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/deny_namespace.c
> @@ -0,0 +1,88 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +#include <test_progs.h>
> +#include "test_deny_namespace.skel.h"
> +#include <sched.h>
> +#include "cap_helpers.h"
> +
> +#define STACK_SIZE (1024 * 1024)
Does the child need 1M stack space ?

> +static char child_stack[STACK_SIZE];
> +
> +int clone_callback(void *arg)
static

> +{
> +	return 0;
> +}
> +
> +static int create_new_user_ns(void)
> +{
> +	int status;
> +	pid_t cpid;
> +
> +	cpid = clone(clone_callback, child_stack + STACK_SIZE,
> +		     CLONE_NEWUSER | SIGCHLD, NULL);
> +
> +	if (cpid == -1)
> +		return errno;
> +
> +	if (cpid == 0)
Not an expert in clone() call and it is not clear what 0
return value mean from the man page.  Could you explain ?

> +		return 0;
> +
> +	waitpid(cpid, &status, 0);
> +	if (WIFEXITED(status))
> +		return WEXITSTATUS(status);
> +
> +	return -1;
> +}
> +
> +static void test_userns_create_bpf(void)
> +{
> +	__u32 cap_mask = 1ULL << CAP_SYS_ADMIN;
> +	__u64 old_caps = 0;
> +
> +	ASSERT_OK(create_new_user_ns(), "priv new user ns");
Does it need to enable CAP_SYS_ADMIN first ?

> +
> +	cap_disable_effective(cap_mask, &old_caps);
> +
> +	ASSERT_EQ(create_new_user_ns(), EPERM, "unpriv new user ns");
> +
> +	if (cap_mask & old_caps)
> +		cap_enable_effective(cap_mask, NULL);
> +}
> +
> +static void test_unpriv_userns_create_no_bpf(void)
> +{
> +	__u32 cap_mask = 1ULL << CAP_SYS_ADMIN;
> +	__u64 old_caps = 0;
> +
> +	cap_disable_effective(cap_mask, &old_caps);
> +
> +	ASSERT_OK(create_new_user_ns(), "no-bpf unpriv new user ns");
> +
> +	if (cap_mask & old_caps)
> +		cap_enable_effective(cap_mask, NULL);
> +}
> +
> +void test_deny_namespace(void)
> +{
> +	struct test_deny_namespace *skel = NULL;
> +	int err;
> +
> +	if (test__start_subtest("unpriv_userns_create_no_bpf"))
> +		test_unpriv_userns_create_no_bpf();
> +
> +	skel = test_deny_namespace__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "skel load"))
> +		goto close_prog;
> +
> +	err = test_deny_namespace__attach(skel);
> +	if (!ASSERT_OK(err, "attach"))
> +		goto close_prog;
> +
> +	if (test__start_subtest("userns_create_bpf"))
> +		test_userns_create_bpf();
> +
> +	test_deny_namespace__detach(skel);
> +
> +close_prog:
> +	test_deny_namespace__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_deny_namespace.c b/tools/testing/selftests/bpf/progs/test_deny_namespace.c
> new file mode 100644
> index 000000000000..9ec9dabc8372
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_deny_namespace.c
> @@ -0,0 +1,39 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include <errno.h>
> +#include <linux/capability.h>
> +
> +struct kernel_cap_struct {
> +	__u32 cap[_LINUX_CAPABILITY_U32S_3];
> +} __attribute__((preserve_access_index));
> +
> +struct cred {
> +	struct kernel_cap_struct cap_effective;
> +} __attribute__((preserve_access_index));
> +
> +char _license[] SEC("license") = "GPL";
> +
> +SEC("lsm/userns_create")
> +int BPF_PROG(test_userns_create, const struct cred *cred, int ret)
> +{
> +	struct kernel_cap_struct caps = cred->cap_effective;
> +	int cap_index = CAP_TO_INDEX(CAP_SYS_ADMIN);
> +	__u32 cap_mask = CAP_TO_MASK(CAP_SYS_ADMIN);
> +
> +	if (ret)
> +		return 0;
> +
> +	ret = -EPERM;
> +	if (caps.cap[cap_index] & cap_mask)
> +		return 0;
> +
> +	return -EPERM;
> +}
> +
> +SEC("lsm.s/userns_create")
> +int BPF_PROG(test_sleepable_userns_create, const struct cred *cred, int ret)
> +{
An empty program is weird.  If the intention is
to ensure a sleepable program can attach to userns_create,
move the test logic here and remove the non-sleepable
program above.

> +	return 0;
> +}
> -- 
> 2.30.2
> 
