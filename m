Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345DB303034
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732809AbhAYXby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:31:54 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54260 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732535AbhAYXbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 18:31:01 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10PNTAiO032510;
        Mon, 25 Jan 2021 15:30:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=fUu9J2X1r/ZnX8UdiE7WO8MF2GxPeq9BsQE7/nNOzZg=;
 b=H/H/KcG9Ys7fRMA3/WfkjP5/2lRiZwzEoBygwTlaDXepapyX8xuFni5H2isvyRts+HwL
 QaX7wX0pG5s09yc9CgRYCB8aeVSpOS9EfPFYEHDCTvMyxHHPdGNVwYqxwo3G29r88NAs
 DkcVyX9r7aWYMYHx1VwDdQ4q2+ByDOIrJDY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36950a0kte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 25 Jan 2021 15:30:01 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 25 Jan 2021 15:30:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mDgnjDw2TUrvK9kntmt3MuCtcbO+IvAu1wqGQEI+Nf8vg4A/n/dWLCQpS1veBltBL/XNUR5BkQ8l5C72TzepP9xTJK9VONKvwTAN86L7iYS/cujD3JetMeOQjio3CPqdxKtoRTjfBL9nh2Xf4NgVyR9dZSM/0xiF3LuR+50YgAmqK9oLcDYZt2Z0ztL8J4b++vH8CXx3CI/mvLHO91mgcZMh0exkBeGHWa1QFlYKgH7ZqRxk+5877VHmr8EOutiZd09rgHqiK1O7sjezLMhOksyGEZ5DLcwXC4Y0XJhc5GmIeFqRVIEwRd4xZhe0JqxVmSE5iC1hYNFMaj2WJIbTrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUu9J2X1r/ZnX8UdiE7WO8MF2GxPeq9BsQE7/nNOzZg=;
 b=iqmmF8PmcLkNh2p3udra4L9/s+pyOcOqJwWowTWTqWVnfL7cO6jgcdBiCsyOekSbEJe9rQUrOB7kDuTrzpvCuEQPHs1elpE8oe0JGzCQczXLRphaPTTXGouP6vwSQtnUJi5LEW3MRHrMN72RyU+/Mm6ykSx9essfTV83Lv9mXteKWAoF5eAjCAThvmeSLUo2la1aceUVSMFzc3T0Omn4haAb+mhdj9h++B92J6KHuJmc28xdQGkX1wS9G/9XVtjqEK0U0svUQJX/nBRzKXWRtmfAp4LpEKUpqtSKUeOtaBkRh2PGmwg19uPWbMt3y/ApDMEnC3BuFUsChgFQhx2n0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUu9J2X1r/ZnX8UdiE7WO8MF2GxPeq9BsQE7/nNOzZg=;
 b=kPfhfStHQcyl889Aam9zEyGyt+0MwuD78xGCyGWUWq0XMlrEir/LgkJ1eJ9i3EBlIW5mPz4lUvgwLvk7FKNHefZ+w6EIMrrjEkMj5CwRToexVh45FWq5ZFGhnMjZCE8Y1yIEDxXMQJer85YYJEmFa6hGll/4nWdd3gs16bExAsQ=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2261.namprd15.prod.outlook.com (2603:10b6:a02:8e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.13; Mon, 25 Jan
 2021 23:29:58 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66%3]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 23:29:58 +0000
Date:   Mon, 25 Jan 2021 15:29:49 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v2 2/2] selftests/bpf: verify that rebinding to
 port < 1024 from BPF works
Message-ID: <20210125232949.46r26lcc3wyieoaj@kafai-mbp>
References: <20210125172641.3008234-1-sdf@google.com>
 <20210125172641.3008234-2-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125172641.3008234-2-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:4fac]
X-ClientProxiedBy: MW4PR04CA0358.namprd04.prod.outlook.com
 (2603:10b6:303:8a::33) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:4fac) by MW4PR04CA0358.namprd04.prod.outlook.com (2603:10b6:303:8a::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Mon, 25 Jan 2021 23:29:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ed72248-8cdd-4e5c-64a5-08d8c189210c
X-MS-TrafficTypeDiagnostic: BYAPR15MB2261:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2261C5DA0C1F6BE84BBEE0BDD5BD0@BYAPR15MB2261.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g8DmMEPameCYkQBAoA3I50CXjQlChKXm5zYowVLybiNky46NzzBr+kcBpAG+ZpRdXZtYtW8JHIkpdin8aiwD6hOOoLETJLgNRyZhBOaJZEQzbR5QJ8r/SXzMzASqYGhg9HGDsiZGPInxXCrYclqY47TND11e8OrV66mtN5Cwu+haRulN6KK8iIKepnnqb4zourarvwATNjsU63UScHxmVi58XEP2q1o5OPnDuImyLxpKefIkrR8zWihdeQWZ1qRsVTztLNfmc8DG+yUx75GhhuDWmIIT1Zc5j7fLalqifdM8nj8QcmubnoDzGfiXhLJdcoRqV83kQDD+M16ROetaL3YLkJu/P7UvxshQIZ54LDwa1eimEercLn5ncVmeOblx8ZRKG6ax7UAy0rKZEYgOdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(346002)(136003)(366004)(86362001)(4326008)(1076003)(6496006)(6666004)(52116002)(66556008)(83380400001)(186003)(16526019)(66946007)(2906002)(316002)(55016002)(6916009)(9686003)(66476007)(15650500001)(8676002)(33716001)(478600001)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ahvpzMKfrgNpRzBbkaFIlUzPD5jhs2HkZyQ4OTEh5DFxYyNYU3hxVadQSZVe?=
 =?us-ascii?Q?vrVIvyJfnB09vrLXpdkI8OPow44+x+U0/fcSfJa6ZpRQ/KAeE1Ie3dWRMs1E?=
 =?us-ascii?Q?PVSp0C99FGJ6lIIO+16Kg5WA1wGvBPJLodtQ3UaSjkQJo78eDFQm3/KpQ1jp?=
 =?us-ascii?Q?jAKedzC8mIr8hyDWn+Oq1HTKBiGazFuAZ4jZC2JigKHsqL6LxGefKF2/Dm77?=
 =?us-ascii?Q?QFjFG81ORR1e7Ktf8Ur7xYinuE+dGTe31SbXeMoM9Kd9i7ToTdnUWntFcTlL?=
 =?us-ascii?Q?2z5RaqrUnnTkS3CP0WXRxMzIZv9KSyntDCIeJt4kVKbHSS5/Jl2p9i5k+9JJ?=
 =?us-ascii?Q?OFteyiuiQyzh+Y3+yFIDmXBtLGcJIxtiZn/bEHdWHifyWpCYaYQpjPM1TBRQ?=
 =?us-ascii?Q?Vyj56YrstTtEH7yyBYzjKACWqvnGlBzahaIaPxAUp1qd3M+PMcl7J2pdoTMA?=
 =?us-ascii?Q?tBjHKLiQp8Hg/MBbizaVrduw9kY/bRuEXfZ8f3zltHIM62KL7GmduAy8Gi/9?=
 =?us-ascii?Q?SXji7z01fTWW1bojR4IhnEz/p0r4vrtKyKSOd3KP5EsACkJjuoxBpFnnaLy3?=
 =?us-ascii?Q?nSYcU44PaJwT91YNtsOqoW2+5vNgYt748TYK/Tvta0ZB+OXCneIH/WC55cYz?=
 =?us-ascii?Q?jgU74nZknogvXG1g6bgCtiL+IL5y0uDuSZ2DS1hCLw/UbNt5EbFpEpR0dC2I?=
 =?us-ascii?Q?WnJA+MUyPr1Iw8bZfyD6D2iNTuQtt/s92Mm4gPq8eEqyiMMtV9jY5Kca+pzy?=
 =?us-ascii?Q?Iqw9aPL0C7FWAiscPb/A/E+jOY69cVywnvZ0aKE7Ebo6tHbA9V/soNJ3y8FD?=
 =?us-ascii?Q?CSX2Ls9F1jYajPF0GJGMk+qGzRqbp2B0kb19fL4DuItjjANqC657bgvZmVwL?=
 =?us-ascii?Q?e8Ua0efbxGdVmW0R2hMD0IA8wqc9iRGQl4fY1bfOHEGQfyFq9b1I+deVXyn3?=
 =?us-ascii?Q?oe2ZIJaPOXfIZ6HKKiHf9u3ylBt5p3bzxilz3pcpAw8SHMPwZAzI2nru1q5/?=
 =?us-ascii?Q?v87BzXHcGs/d22sdv3yi+rQVeVZ6bzviRBTTQj14DrqH1McpZcKPvaL88Ts7?=
 =?us-ascii?Q?HkRgOnEsSTzfgdOE0sa++2uQeTFA8X7WRqI9/kVgvCd4746IXdA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed72248-8cdd-4e5c-64a5-08d8c189210c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2021 23:29:58.4454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SwUr5S1AiCizSMXo4e65TPc6VjQkJ3Cs5/PeHCxWvc6HtLkpFH7aM25h7iqS7XlU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2261
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-25_10:2021-01-25,2021-01-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 bulkscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101250119
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 09:26:41AM -0800, Stanislav Fomichev wrote:
> BPF rewrites from 111 to 111, but it still should mark the port as
> "changed".
> We also verify that if port isn't touched by BPF, it's still prohibited.
The description requires an update.

> 
> Cc: Andrey Ignatov <rdna@fb.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  .../selftests/bpf/prog_tests/bind_perm.c      | 85 +++++++++++++++++++
>  tools/testing/selftests/bpf/progs/bind_perm.c | 36 ++++++++
>  2 files changed, 121 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/bind_perm.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bind_perm.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bind_perm.c b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> new file mode 100644
> index 000000000000..61307d4494bf
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> @@ -0,0 +1,85 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include "bind_perm.skel.h"
> +
> +#include <sys/types.h>
> +#include <sys/socket.h>
> +#include <sys/capability.h>
> +
> +static int duration;
> +
> +void try_bind(int port, int expected_errno)
> +{
> +	struct sockaddr_in sin = {};
> +	int fd = -1;
> +
> +	fd = socket(AF_INET, SOCK_STREAM, 0);
> +	if (CHECK(fd < 0, "fd", "errno %d", errno))
> +		goto close_socket;
> +
> +	sin.sin_family = AF_INET;
> +	sin.sin_port = htons(port);
> +
> +	errno = 0;
> +	bind(fd, (struct sockaddr *)&sin, sizeof(sin));
> +	ASSERT_EQ(errno, expected_errno, "bind");
> +
> +close_socket:
> +	if (fd >= 0)
> +		close(fd);
> +}
> +
> +void cap_net_bind_service(cap_flag_value_t flag)
> +{
> +	const cap_value_t cap_net_bind_service = CAP_NET_BIND_SERVICE;
> +	cap_t caps;
> +
> +	caps = cap_get_proc();
> +	if (CHECK(!caps, "cap_get_proc", "errno %d", errno))
> +		goto free_caps;
> +
> +	if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_net_bind_service,
> +			       CAP_CLEAR),
> +		  "cap_set_flag", "errno %d", errno))
> +		goto free_caps;
> +
> +	if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_net_bind_service,
> +			       CAP_CLEAR),
> +		  "cap_set_flag", "errno %d", errno))
These two back-to-back cap_set_flag() looks incorrect.
Also, the "cap_flag_value_t flag" is unused.

> +		goto free_caps;
> +
> +	if (CHECK(cap_set_proc(caps), "cap_set_proc", "errno %d", errno))
> +		goto free_caps;
> +
> +free_caps:
> +	if (CHECK(cap_free(caps), "cap_free", "errno %d", errno))
> +		goto free_caps;
There is a loop.

> +}
> +
> +void test_bind_perm(void)
> +{
> +	struct bind_perm *skel;
> +	int cgroup_fd;
> +
> +	cgroup_fd = test__join_cgroup("/bind_perm");
> +	if (CHECK(cgroup_fd < 0, "cg-join", "errno %d", errno))
> +		return;
> +
> +	skel = bind_perm__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "skel"))
> +		goto close_cgroup_fd;
> +
> +	skel->links.bind_v4_prog = bpf_program__attach_cgroup(skel->progs.bind_v4_prog, cgroup_fd);
> +	if (!ASSERT_OK_PTR(skel, "bind_v4_prog"))
> +		goto close_skeleton;
> +
> +	cap_net_bind_service(CAP_CLEAR);
> +	try_bind(110, EACCES);
> +	try_bind(111, 0);
> +	cap_net_bind_service(CAP_SET);
> +
> +close_skeleton:
> +	bind_perm__destroy(skel);
> +close_cgroup_fd:
> +	close(cgroup_fd);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/bind_perm.c b/tools/testing/selftests/bpf/progs/bind_perm.c
> new file mode 100644
> index 000000000000..31ae8d599796
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bind_perm.c
> @@ -0,0 +1,36 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/stddef.h>
> +#include <linux/bpf.h>
> +#include <sys/types.h>
> +#include <sys/socket.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
> +
> +SEC("cgroup/bind4")
> +int bind_v4_prog(struct bpf_sock_addr *ctx)
> +{
> +	struct bpf_sock *sk;
> +	__u32 user_ip4;
> +	__u16 user_port;
> +
> +	sk = ctx->sk;
> +	if (!sk)
> +		return 0;
> +
> +	if (sk->family != AF_INET)
> +		return 0;
> +
> +	if (ctx->type != SOCK_STREAM)
> +		return 0;
> +
> +	/* Rewriting to the same value should still cause
> +	 * permission check to be bypassed.
> +	 */
This comment is out dated also.

> +	if (ctx->user_port == bpf_htons(111))
> +		return 3;
> +
> +	return 1;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> -- 
> 2.30.0.280.ga3ce27912f-goog
> 
