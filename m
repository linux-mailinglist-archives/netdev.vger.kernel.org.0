Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EBE2FF802
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 23:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbhAUWey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 17:34:54 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43348 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726000AbhAUWef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 17:34:35 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10LMSjhp004046;
        Thu, 21 Jan 2021 14:33:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=gPrrMXoZdHH1VPh0SVxLFsryFqyIOfqdg2QUWKAbrms=;
 b=drXFsMRdNu97FB/icdNw5U2wzaDK29KJfarCBNnm5nop39moIPsrj1tfym2NmrchSSiB
 8hq8ph7Gty/yFZ+N59rmUt5AsCN2yOdIluL4P3UuyVMCLvr+ogri1I10QzgDBRiDWj1W
 5kGnCd5joZV8iEOB7bJxw3WpORZfrGBECjg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3668ngww3s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 21 Jan 2021 14:33:39 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 21 Jan 2021 14:33:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h1Ma2Z5uvHuEdJmPhSjYsjJx7k0oKZJv4guvUMVFKQ/dhgLqattDxy50H3Ai3Y/3IAx3ToRtn430nC8+3iLYbe9/zPBmYn4wtaYYtuk3FbojDc91BXjzl8oPtY7crrS4IckiozxVU2Tmos8YDOEnN/3B0XxFpUZAa30BKcwIKvrQ+OXMOvvO61aAbiDqXb/nn/YMImKdCC6A4vIgiB34WVoFNyJLMT9nAwE8DMLesgWJelk4Lf/MU7NDd79DKnLDewSothG51AFpBpWd3shskGfYuiN8jNQ0tMUhbFAwRdzk5rEE+az9uxtvGhBf2UblFjVz7cAtcwMKx0wR3g8weg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPrrMXoZdHH1VPh0SVxLFsryFqyIOfqdg2QUWKAbrms=;
 b=NEBdLY0+EDajcJi5Is3YH+u9LzhM17dG59D+9YYWOyAikY3jgmpmf6GiaIPJ0UTFJ4aqm5tMQuUaptypqiEe+c2s866nd+YI197kzOJMY1mk7OhdQq4pWq6oz++Vsm5a8oTq8/F6w5UicGxHrKTexQXukHzNUqzwyfVt6V+A25WFAcRINZ3IvmdtE3oDC3LjuLQQKOA4U/brgVVIUr54yqD+gGD3dxzUHVqaVOxSHHY986DDl8caM0BSAYM0WmZKsePdzrLBdK6Vm1Unqt7o9kh2CSQxvK3GSBBGlRWdHB+rnT0NSN4rTx2fu6cEou+yG8aiyG+VY/R/R+M1mfanAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPrrMXoZdHH1VPh0SVxLFsryFqyIOfqdg2QUWKAbrms=;
 b=knrmsRHhGXR6gZKWAqcMwTrTeAWIWIjGmRrHHNLGtFkZikBk5gnavatvSi0X3HQqOSuXOQfm1/3SaMXNYyjEJvmF0yP0F91mJa8MxCdg5lKDtOhjz831ZxDLCilRpkB9V9nklhT3seg8kaW3jPWL1FCd4DYRpect2Xm5lb556tQ=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3688.namprd15.prod.outlook.com (2603:10b6:610:d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Thu, 21 Jan
 2021 22:33:37 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::a875:5b25:a9b4:e84e]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::a875:5b25:a9b4:e84e%7]) with mapi id 15.20.3784.012; Thu, 21 Jan 2021
 22:33:37 +0000
Date:   Thu, 21 Jan 2021 14:33:30 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: verify that rebinding to
 port < 1024 from BPF works
Message-ID: <20210121223330.pyk4ljtjirm2zlay@kafai-mbp>
References: <20210121012241.2109147-1-sdf@google.com>
 <20210121012241.2109147-2-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121012241.2109147-2-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:2363]
X-ClientProxiedBy: SJ0PR03CA0101.namprd03.prod.outlook.com
 (2603:10b6:a03:333::16) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:2363) by SJ0PR03CA0101.namprd03.prod.outlook.com (2603:10b6:a03:333::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 22:33:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cb701ed-ecc5-4cbe-9e74-08d8be5c97ea
X-MS-TrafficTypeDiagnostic: CH2PR15MB3688:
X-Microsoft-Antispam-PRVS: <CH2PR15MB36886C0CA2E7070765E64C1DD5A19@CH2PR15MB3688.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qoKTgmPAeiM2RMzEdJAyVyk4jiAnBuwho0lzP9tFfK/zXUMQLcfonn5vNbEcjrA3XRMsJK42xtjTuTxUGuByT44jw8/uEukZVD4zTcG1MKELCPWYxxSg4WYgtBRVqbm4t/+ZHU3pVRLtdFapg9yru0n+j/2vdyZxBW7DNQUu6DTYlT/2jrJP2y1fCrtPZywIpvyujJlfS92WO5QZNCIr4G/4jVYcZt38BKvbLCR9FpZQyDLXTajaH+NxJBi5DnY7bVzpATcis1+doSpsqs1gDZ1FJAWqF/L15iT4dJQedjmpjPo8GO6C58NL1y90eY8JOp3xiRCbBbijOatMk93gvKhkURY5shegIU33q8vjXZhe7WVCI+1J7rJrppXtmxpw/exT7NoaG2xKKFzGLh8osQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(39860400002)(136003)(346002)(366004)(8676002)(66476007)(55016002)(6666004)(66556008)(66946007)(316002)(6496006)(86362001)(186003)(52116002)(6916009)(16526019)(33716001)(9686003)(5660300002)(15650500001)(4326008)(83380400001)(1076003)(2906002)(8936002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nv4LmQKasCw7MX73e0LTMyYe/z10o73jEF3H3k4Y7giNJSMSJQBwVt1yuBD0?=
 =?us-ascii?Q?rdUipYveRef7CrFdgFVSaA3e5dC3hI21HX496yJsoTIos/t8jyVPK3KGhBl4?=
 =?us-ascii?Q?yhRpWMCoF1XCkMLxngZVUg6Zvh5Hk+jfLkqu0FkzKa+EbUfT9UCVqsZH0KrQ?=
 =?us-ascii?Q?maca+gf93lRv11qVmreqxjto4Saqh1IogJhnJW6jo1uLgrBWL/wBAvHRwPXs?=
 =?us-ascii?Q?Pr8bZyNDLIzJ33JX2qhsQddW2FJ2RKnYqkUwK8KNixYk8Driqay5OVdyL12h?=
 =?us-ascii?Q?HPq5l5/FHkBBfWuqFSUc7HGfFDb1GoBehmhMdijWNGqUU0UVn+u6b/dKdw02?=
 =?us-ascii?Q?w5LHsOmbvcrByKVOi55+1DSYF28kIx9rU6Ax6AywV5mgntWR8SvWcFop14sc?=
 =?us-ascii?Q?waF1a7MeQUjQSFPOo8qpz9gYwRV8Gx7DYrqlcjzcJsMj/9uBwtElVNq9ISWf?=
 =?us-ascii?Q?tUUJMGc+CEqo8HBpRI+MaOVK7XUiT9e8X83lNfGal/P6wg+uvt0USGDIjp8O?=
 =?us-ascii?Q?5UwFpolgJV6TdmETVXf7ZEkXBKygHivyjAwFIX1fL4lipAVJhpjIpsSkOnbe?=
 =?us-ascii?Q?9EMhOpVSthRVf6/fo7Q5Lcg/zr7toYGHAElVbGEOQdZLfnRijsN2eNVAvRzY?=
 =?us-ascii?Q?3DD3CchUM+1Vnd+RFlfUHDwOKKbLwmpH2UrYeG8gQkJ9lvAwZUThY2Rm0IOP?=
 =?us-ascii?Q?z1KtcA/h3GHRNqb6xkeUqHEpTlYEd1BVqh2IXk97rDJmRfVOPQv6NMr9Hatg?=
 =?us-ascii?Q?I1Vj5cikbJW7C/x9kooWG2UafgALT6jZsMrwWcw7FnRFqANYDPmzReEfoLqt?=
 =?us-ascii?Q?82BiEgGjG9veqQg5f9dXYtZ5qV63L/CibzXwigv3pF88YlBkdNmeWjWsuZ74?=
 =?us-ascii?Q?vHnkzPtgHeEKXK2x14rPOrBstBV7CiQ+ImEnTZSCRroo6cMiWzIwmD/VoucS?=
 =?us-ascii?Q?QUHxBDKSFagfjhi1r1PLO7RjmTkteXPJ2GuXIdZ2CkyloagVi1wIvnTjQM9+?=
 =?us-ascii?Q?rbsU3CKO8tbYHObqVsBMNnOfZg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cb701ed-ecc5-4cbe-9e74-08d8be5c97ea
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 22:33:37.0667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sJti+hCpbimJIIJps5nuAYsDacDPOTxVFTfpWcMgSqvymgfY0I1IvVo0JoqSUq/2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3688
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_10:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210115
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 05:22:41PM -0800, Stanislav Fomichev wrote:
> BPF rewrites from 111 to 111, but it still should mark the port as
> "changed".
> We also verify that if port isn't touched by BPF, it's still prohibited.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  .../selftests/bpf/prog_tests/bind_perm.c      | 88 +++++++++++++++++++
>  tools/testing/selftests/bpf/progs/bind_perm.c | 36 ++++++++
>  2 files changed, 124 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/bind_perm.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bind_perm.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bind_perm.c b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> new file mode 100644
> index 000000000000..840a04ac9042
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> @@ -0,0 +1,88 @@
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
> +	CHECK(errno != expected_errno, "bind", "errno %d, expected %d",
> +	      errno, expected_errno);
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
> +		goto free_caps;
> +
> +	if (CHECK(cap_set_proc(caps), "cap_set_proc", "errno %d", errno))
> +		goto free_caps;
> +
> +free_caps:
> +	if (CHECK(cap_free(caps), "cap_free", "errno %d", errno))
> +		goto free_caps;
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
> +	if (CHECK(!skel, "skel-load", "errno %d", errno))
> +		goto close_cgroup_fd;
> +
> +	skel->links.bind_v4_prog = bpf_program__attach_cgroup(skel->progs.bind_v4_prog, cgroup_fd);
> +	if (CHECK(IS_ERR(skel->links.bind_v4_prog),
> +		  "cg-attach", "bind4 %ld",
> +		  PTR_ERR(skel->links.bind_v4_prog)))
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
> index 000000000000..2194587ec806
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
> +	if (ctx->user_port == bpf_htons(111))
> +		ctx->user_port = bpf_htons(111);
iiuc, this overwrite is essentially the way to ensure the bind
will succeed (override CAP_NET_BIND_SERVICE in this particular case?).

It seems to be okay if we consider most of the use cases is rewriting
to a different port.

However, it is quite un-intuitive to the bpf prog to overwrite with
the same user_port just to ensure this port can be binded successfully
later.

Is user_port the only case? How about other fields in bpf_sock_addr?

> +
> +	return 1;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> -- 
> 2.30.0.284.gd98b1dd5eaa7-goog
> 
