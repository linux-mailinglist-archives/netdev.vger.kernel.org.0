Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9FA2FF91C
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 00:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbhAUXva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 18:51:30 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37726 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726162AbhAUXvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 18:51:21 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10LNZ5YR009870;
        Thu, 21 Jan 2021 15:50:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Igkm7u9mXLOojj2xY2+883ZQI+XeDDDbZk+15EiCHeI=;
 b=QXY5+riTWPiYMvjNNvIv5kgB+59YTV809i0tiqbK8uJL9G7hBog3/73m5R1FqkgP3E1M
 u5XVq2+G47vINr//yfaMiH29k8+pXmLRXiF8USioYImkcK8s/qK6BoBXzQkvTZjbjh4M
 nq0ovN4T281OvPmyqLHg7wjb4o180hZPcG0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3668php5ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 21 Jan 2021 15:50:17 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 21 Jan 2021 15:50:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCIJbugYueF6OLr3I0QZoH58C5ux/cW+z3Sioe3RVQllVDJ1BX0l+z99k9iBkx+53dclmNyQsFNRZTimnoHqDB22Zu+PaTsbrcpmZvBJxYgebmpIikYoX2mvZ4ZljU+NRUGGtiRAwC5C58kVfozpR8S+eCsi+G7oay/xJSqx6f5BOMCBIuqepauXHipzrdt7c51iqxduIyVByWfOEA9uheVymKkziqmJuI7+pjIWS/Hi9o0y5PCXhhjObeepRis6Y8XsTBOINFnnxICSHeKdHqUw3ki4G/cZA3+zba4i2k6VhfZT6+tyvXZOeTTz/8/FJG9FKCFpk4ilhbRKdssAiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Igkm7u9mXLOojj2xY2+883ZQI+XeDDDbZk+15EiCHeI=;
 b=TMNn6RLgh2vELcorH4hcvYI2EBIQtuKcGZMKM0zgjmlv2NPUal9iFoCc5jzFHpqCLY4qEutqK1VPym31c5CaTgK8WvPoz+2yKS8NsLz0ZCLLfHXkAAAfPt3IXVMma7uUO4dqRWvugBw8fzffJcdHtc2KTFAswZgAqE5DPQputLgMD4LE2iMZ8h4xU7GpcNEGjhYhpMeh+vkklAa+IFDqnXJxqnGQVhVeNhEH3mYPJr0fU4AJmOfiI/Pu54H8blI3i4luXDDKCwmwnODHKSCE3174YxOG8NF2GunYtUadLCnZ/DVnk9dAoV0cVpk5H6FINMeKbiVts3ApZxpeth9pcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Igkm7u9mXLOojj2xY2+883ZQI+XeDDDbZk+15EiCHeI=;
 b=ZFUhhsugzp66yCp3UMrOYT0f7NcmjXhN9YuaRbIVHYujLo6e3b0Hh8UhrcD6iwBquFcJn35ydhhkuZYO8HFpxo/NtpJZgOdXHYkldSCorOvpTzreTc0zkn5Ho6Bbq+rQW4JLcm+IZ6LhGakHDXsSPz/Hw9hLC5toY1M3KkrK8aU=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3670.namprd15.prod.outlook.com (2603:10b6:610:a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Thu, 21 Jan
 2021 23:50:15 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::a875:5b25:a9b4:e84e]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::a875:5b25:a9b4:e84e%7]) with mapi id 15.20.3784.012; Thu, 21 Jan 2021
 23:50:15 +0000
Date:   Thu, 21 Jan 2021 15:50:07 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: verify that rebinding to
 port < 1024 from BPF works
Message-ID: <20210121235007.vmq24fjyesrvjkqm@kafai-mbp>
References: <20210121012241.2109147-1-sdf@google.com>
 <20210121012241.2109147-2-sdf@google.com>
 <20210121223330.pyk4ljtjirm2zlay@kafai-mbp>
 <YAoG6K37QtRZGJGy@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAoG6K37QtRZGJGy@google.com>
X-Originating-IP: [2620:10d:c090:400::5:2363]
X-ClientProxiedBy: MW4PR03CA0215.namprd03.prod.outlook.com
 (2603:10b6:303:b9::10) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:2363) by MW4PR03CA0215.namprd03.prod.outlook.com (2603:10b6:303:b9::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Thu, 21 Jan 2021 23:50:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81b28888-54c7-486d-bbe2-08d8be674c91
X-MS-TrafficTypeDiagnostic: CH2PR15MB3670:
X-Microsoft-Antispam-PRVS: <CH2PR15MB3670EFE14E41DA457D899D6BD5A19@CH2PR15MB3670.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iO/HuU6PZXWKJP8g5LwEdf7CkW5HyUu9ZP48Vm73SOLF+FY35m3WfoTyjWPaz7EhUz/Qx/DfmWg3lXh639pEWGOT1ZJrjCSrvFlQx5w3jTCp5y6bCht2I4/VktCdASNtQ8vYlKNDKhNjLtZMvWx1N/IutCyEkBFeZ6ZUMo0geroEGBw1qtU2j8pVHQwUD4dyYIJbTZ6K7lRryK1tk0MTo6PrQ7aQJ1iUzS4Q3lsKj21TErU8FClX1BGZPAQPQ49gGRlFOcNHZYAE4khuHyrWixkAELMTUKtVqsJsMMY7zEtiJ0zkP1L/brgYJ95tvpJH6vcYw/w+HuK116sGmL3qs273j4G90SStwdsrpOBNIiSUYMkkG1IYtxNVRWtZVpRTxqmwG+QmOaMP2ntRPGgS+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(366004)(346002)(39860400002)(55016002)(9686003)(186003)(4326008)(15650500001)(5660300002)(52116002)(8936002)(8676002)(2906002)(33716001)(16526019)(66476007)(86362001)(316002)(66556008)(66946007)(83380400001)(6666004)(6496006)(1076003)(478600001)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yCmXk1xq9OJcmXRI3OPa5md4cvyCiC+FCc2r7e1KgPxjXUwr1zOeGmfamSOC?=
 =?us-ascii?Q?i9Uivy6FkB3TODMdJiTv42fA0qgYV1CTz44+hhMEYtLfrYSh/dvccHhFZeHj?=
 =?us-ascii?Q?JkBaUDHv/pbaPdC5yQh4fP3fHwnEvGuAwPXA8D11liWdgc2xRclA1vO4eccd?=
 =?us-ascii?Q?RovNvNqVHSIUYVgvB3kF38huDRZmBJX4iStuKSGFwjdG5C36Gr6+mINrgG0t?=
 =?us-ascii?Q?ppzI5CaA1fEhn7umbhCtunfDu9XaTIKEiKITaf4KNKycR2RARxEhRSuuMAzG?=
 =?us-ascii?Q?QjvFhj0YdneZMk6+6cj7OZQxf91xJQGpwFAN0iQ3UYKe9hQlNSfS/ScvqwDi?=
 =?us-ascii?Q?QkOQl2pFqvxh+ql7+hlinUXrptrY0CjZooij8T7ba7tCEKX5biEqI1z3Etti?=
 =?us-ascii?Q?m3mPwO0+GaDJkSVVQAcbWTvjflYLL4cNWQomFRElm3V8hF5ZS09UlHeNk1tY?=
 =?us-ascii?Q?M/HI4fxJkxNX4REvVI0PAL0g8A4FFqd3S3DVuCl5zwTHktcVS2S24z9Fkor8?=
 =?us-ascii?Q?xtjVRuIHmQcwnabuhJRFXsEowHfdEA72j2n3jZF2NvmDaiwR14bUbjXssBLM?=
 =?us-ascii?Q?Jv9J2aKpiuNDbhVGIJNHyvRU3bQni5Mme1Z1ZASyTOPtF1zz5PNihFFKCBrZ?=
 =?us-ascii?Q?0ghN8ywv7U/LB8d6fEMV9BmJvbDS8URlx5bDkIn4wJDnu7BWKmhXJaub7VVw?=
 =?us-ascii?Q?aJztYBv9Y/xX92m/NCJLXQg4f8+u25jP0AgH5dAXJJRSwKr94yymjHISr1EA?=
 =?us-ascii?Q?kjqMtal81p5rF99sho47cum8MMB2E+RrVVkyBpqU6yX+v4CgW7NOHDToqemP?=
 =?us-ascii?Q?juRaCbn9HBYMBYFSWEG6FS9qVBzLzU+/35llZbN8wOtJEALGYNgxzn2g42LM?=
 =?us-ascii?Q?SKTapKRqxqnrJE5hTy8/u8IJ9MJ/F4ciyEkK5qxBNdKBrXfQ1ciro5bDnVaL?=
 =?us-ascii?Q?XeXxO731p9tFTCFgivGL9jtWbrTWwaweqNSshQbOQx9v/YMu841gbcmxsETm?=
 =?us-ascii?Q?1//YzMX7rR1Iyk0KRaIu1vHXFw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b28888-54c7-486d-bbe2-08d8be674c91
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 23:50:15.1261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +FgIBAmLHyDIXeE06uZdJu/wt94vTe00h4njKI43++HcZBN/vF0KW5l9Dj99oe71
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3670
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_11:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 adultscore=0 clxscore=1015
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 02:57:44PM -0800, sdf@google.com wrote:
> On 01/21, Martin KaFai Lau wrote:
> > On Wed, Jan 20, 2021 at 05:22:41PM -0800, Stanislav Fomichev wrote:
> > > BPF rewrites from 111 to 111, but it still should mark the port as
> > > "changed".
> > > We also verify that if port isn't touched by BPF, it's still prohibited.
> > >
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  .../selftests/bpf/prog_tests/bind_perm.c      | 88 +++++++++++++++++++
> > >  tools/testing/selftests/bpf/progs/bind_perm.c | 36 ++++++++
> > >  2 files changed, 124 insertions(+)
> > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/bind_perm.c
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > > new file mode 100644
> > > index 000000000000..840a04ac9042
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > > @@ -0,0 +1,88 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +#include <test_progs.h>
> > > +#include "bind_perm.skel.h"
> > > +
> > > +#include <sys/types.h>
> > > +#include <sys/socket.h>
> > > +#include <sys/capability.h>
> > > +
> > > +static int duration;
> > > +
> > > +void try_bind(int port, int expected_errno)
> > > +{
> > > +	struct sockaddr_in sin = {};
> > > +	int fd = -1;
> > > +
> > > +	fd = socket(AF_INET, SOCK_STREAM, 0);
> > > +	if (CHECK(fd < 0, "fd", "errno %d", errno))
> > > +		goto close_socket;
> > > +
> > > +	sin.sin_family = AF_INET;
> > > +	sin.sin_port = htons(port);
> > > +
> > > +	errno = 0;
> > > +	bind(fd, (struct sockaddr *)&sin, sizeof(sin));
> > > +	CHECK(errno != expected_errno, "bind", "errno %d, expected %d",
> > > +	      errno, expected_errno);
> > > +
> > > +close_socket:
> > > +	if (fd >= 0)
> > > +		close(fd);
> > > +}
> > > +
> > > +void cap_net_bind_service(cap_flag_value_t flag)
> > > +{
> > > +	const cap_value_t cap_net_bind_service = CAP_NET_BIND_SERVICE;
> > > +	cap_t caps;
> > > +
> > > +	caps = cap_get_proc();
> > > +	if (CHECK(!caps, "cap_get_proc", "errno %d", errno))
> > > +		goto free_caps;
> > > +
> > > +	if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_net_bind_service,
> > > +			       CAP_CLEAR),
> > > +		  "cap_set_flag", "errno %d", errno))
> > > +		goto free_caps;
> > > +
> > > +	if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_net_bind_service,
> > > +			       CAP_CLEAR),
> > > +		  "cap_set_flag", "errno %d", errno))
> > > +		goto free_caps;
> > > +
> > > +	if (CHECK(cap_set_proc(caps), "cap_set_proc", "errno %d", errno))
> > > +		goto free_caps;
> > > +
> > > +free_caps:
> > > +	if (CHECK(cap_free(caps), "cap_free", "errno %d", errno))
> > > +		goto free_caps;
> > > +}
> > > +
> > > +void test_bind_perm(void)
> > > +{
> > > +	struct bind_perm *skel;
> > > +	int cgroup_fd;
> > > +
> > > +	cgroup_fd = test__join_cgroup("/bind_perm");
> > > +	if (CHECK(cgroup_fd < 0, "cg-join", "errno %d", errno))
> > > +		return;
> > > +
> > > +	skel = bind_perm__open_and_load();
> > > +	if (CHECK(!skel, "skel-load", "errno %d", errno))
> > > +		goto close_cgroup_fd;
> > > +
> > > +	skel->links.bind_v4_prog =
> > bpf_program__attach_cgroup(skel->progs.bind_v4_prog, cgroup_fd);
> > > +	if (CHECK(IS_ERR(skel->links.bind_v4_prog),
> > > +		  "cg-attach", "bind4 %ld",
> > > +		  PTR_ERR(skel->links.bind_v4_prog)))
> > > +		goto close_skeleton;
> > > +
> > > +	cap_net_bind_service(CAP_CLEAR);
> > > +	try_bind(110, EACCES);
> > > +	try_bind(111, 0);
> > > +	cap_net_bind_service(CAP_SET);
> > > +
> > > +close_skeleton:
> > > +	bind_perm__destroy(skel);
> > > +close_cgroup_fd:
> > > +	close(cgroup_fd);
> > > +}
> > > diff --git a/tools/testing/selftests/bpf/progs/bind_perm.c
> > b/tools/testing/selftests/bpf/progs/bind_perm.c
> > > new file mode 100644
> > > index 000000000000..2194587ec806
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/progs/bind_perm.c
> > > @@ -0,0 +1,36 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +
> > > +#include <linux/stddef.h>
> > > +#include <linux/bpf.h>
> > > +#include <sys/types.h>
> > > +#include <sys/socket.h>
> > > +#include <bpf/bpf_helpers.h>
> > > +#include <bpf/bpf_endian.h>
> > > +
> > > +SEC("cgroup/bind4")
> > > +int bind_v4_prog(struct bpf_sock_addr *ctx)
> > > +{
> > > +	struct bpf_sock *sk;
> > > +	__u32 user_ip4;
> > > +	__u16 user_port;
> > > +
> > > +	sk = ctx->sk;
> > > +	if (!sk)
> > > +		return 0;
> > > +
> > > +	if (sk->family != AF_INET)
> > > +		return 0;
> > > +
> > > +	if (ctx->type != SOCK_STREAM)
> > > +		return 0;
> > > +
> > > +	/* Rewriting to the same value should still cause
> > > +	 * permission check to be bypassed.
> > > +	 */
> > > +	if (ctx->user_port == bpf_htons(111))
> > > +		ctx->user_port = bpf_htons(111);
> > iiuc, this overwrite is essentially the way to ensure the bind
> > will succeed (override CAP_NET_BIND_SERVICE in this particular case?).
> Correct. The alternative might be to export ignore_perm_check
> via bpf_sock_addr and make it explicit.
An explicit field is one option.

or a different return value (e.g. BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY).

Not sure which one (including the one in the current patch) is better
at this point.

Also, from patch 1, if one cgrp bpf prog says no-perm-check,
it does not matter what the latter cgrp bpf progs have to say?

> 
> > It seems to be okay if we consider most of the use cases is rewriting
> > to a different port.
> 
> > However, it is quite un-intuitive to the bpf prog to overwrite with
> > the same user_port just to ensure this port can be binded successfully
> > later.
> I'm testing a corner case here when the address is rewritten to the same
> value, but the intention is to rewrite X to Y < 1024.
It is a legit corner case though.

Also, is it possible that the compiler may optimize this
same-value-assignment out?

> 
> > Is user_port the only case? How about other fields in bpf_sock_addr?
> Good question. For our use case only the port matters because
> we rewrite both port and address (and never only address).
> 
> It does feel like it should also work when BPF rewrites address only
> (and port happens to be in the privileged range). I guess I can
> apply the same logic to the user_ip4 and user_ip6?
My concern is having more cases that need to overwrite with the same value.
Then it may make a stronger case to use return value or an explicit field.
