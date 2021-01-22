Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003F230109D
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 00:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbhAVXIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 18:08:50 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36056 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730546AbhAVTj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 14:39:28 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10MJ8xfW029638;
        Fri, 22 Jan 2021 11:38:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ZOCQu2Ob//t7mFKFpb6BV2hmGtiP8vjchKq5oIsb18M=;
 b=eJFTv4MJHftkJXMqSvDU4IldE9tcIYkqL1dxA28x/ZE59QW9AButbiHcrbiZVKuc6jqH
 NvAVzCvofXkOxWSFhck+UonRFLLLI3VLnFp/7z8a4iZQgsLEmME97+V4gotLjGmTXKXP
 h+tEauMOPtxDE0qGQ8REviogP5KxNlej4bw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 367tvw3a69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 22 Jan 2021 11:38:15 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 22 Jan 2021 11:38:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0lvNrlqpDY7c3irQzefkvqPl8rYrU9yDNl9ZtsBGs+hF+G20KBgdwI3/24JI2kG61uweVmIcVhzpPyoZYDrQJoTxK5KBDkGYkZsi3jSf7HZCUVymg0U7Yo5+s/umamr12EDroEFYj+Kee7uuz2PX0HPyd+WiCkkVFjfdTtvYNC3lHv7JvhUkBip0lDBkBPFL21WzQuRO80+nZSRkyM5hiq7Cqt0INlUpYyA1yzd/3szo2SgpIluJh2HydTECvTHuz1Zp/A73qS7FTW8R1376HlfQH0IiDY9Jx2vN1emC54GHm+K/qNxKPGykezMWNa/eYiEhltybwx/+n5CZp/DXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOCQu2Ob//t7mFKFpb6BV2hmGtiP8vjchKq5oIsb18M=;
 b=OWJ7l4KqBheko0AvEWxt85ye5rYovD2lhmEyGy8cup9HlmGLWboFM6igh/bbFJS+TRGgEhespSzrrdYDuravuDmG0IXmbTY2i2MlG9jU0mJqBaYZgod8wlw8+awt5VDtID4y2E+hudqjTpoTZGB05fj5M8qnDF2YjnNrXqPF0aL3QFY52efxmv82JSaJ8ctsixcRYIpIK6EAxtvVPbHW2nntl4+sgvHFi1D4SHenF5uSgkXAHxksfaXGjMI8RGsAVqVBdopj6fJ5WcMV/gGAoy06C5Gwa7uYtw30s37sjFWC2h525X1A4xBWCxsw5nvKHOp3v1LwZ2Z1jQ2FNpq32w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOCQu2Ob//t7mFKFpb6BV2hmGtiP8vjchKq5oIsb18M=;
 b=GoxBnYagUMZkbEspJA0Fpzvpgxh+sPh7XxNmYM9jPgHe4SS4iAkkx4a8p7Y5/wIHFXBpMy2FQgYEfFtOgum1pLp9RfEmkgG8k8UE3kNfJNeQx711H1KFCwowK24xBrWXhNvNVSPg2zQYaPOaurgsjuftdyjqTe51X2jLQ0x12W0=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2838.namprd15.prod.outlook.com (2603:10b6:a03:b4::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 19:38:13 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66%3]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 19:38:13 +0000
Date:   Fri, 22 Jan 2021 11:38:04 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: verify that rebinding to
 port < 1024 from BPF works
Message-ID: <20210122193804.i2a73pgmkyjqwp3x@kafai-mbp>
References: <20210121012241.2109147-1-sdf@google.com>
 <20210121012241.2109147-2-sdf@google.com>
 <20210121223330.pyk4ljtjirm2zlay@kafai-mbp>
 <YAoG6K37QtRZGJGy@google.com>
 <20210121235007.vmq24fjyesrvjkqm@kafai-mbp>
 <YAockJDIOt3jTqd2@google.com>
 <20210122012751.ur4oxeprccefbbyl@kafai-mbp>
 <YAr6aFwYXgbtFcO6@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAr6aFwYXgbtFcO6@google.com>
X-Originating-IP: [2620:10d:c090:400::5:adba]
X-ClientProxiedBy: MWHPR10CA0057.namprd10.prod.outlook.com
 (2603:10b6:300:2c::19) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:adba) by MWHPR10CA0057.namprd10.prod.outlook.com (2603:10b6:300:2c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 19:38:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 467477f7-2784-48e3-ed53-08d8bf0d4141
X-MS-TrafficTypeDiagnostic: BYAPR15MB2838:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2838AE9E4A539A467A477606D5A09@BYAPR15MB2838.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: as4KPyuPiqipWD6KxTWgHdAomPU13P0+AlhxGiGRSQu71C9NHeLxJUZQr9mH80z8bVEd4EwGfkAEk3Ty2HutmytXmC8mjxtkOz+sKE+jyMAGgd0nMwKqSi2vMAaKtqJNamBtyNtyOMq+MJpM6+yC1uO1+sED7ocLRbUq2bp5b5EDrCyNwpmD7zMIDvNTVIAKxd29OU6rhMKg8o3JjWQKQuR0xTsQT9ded2A5UKN4Ac8tD66pc9/QcyutuaHhJbOWPbBx75hQKAR3Qb/OB7cr5YrhJh+mvoI5v54sqnEAN3qOq0BfHx6ywYdarnztoe83tFDDCjt1STGeQS2BwbPTLZz5OM3wgyQTry27wdSn0FQVi65hd9MnlG0lHo90CQejsM1hLpEWQM7aziTaSr0fQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(346002)(376002)(366004)(86362001)(1076003)(6916009)(8936002)(9686003)(16526019)(186003)(8676002)(55016002)(2906002)(83380400001)(52116002)(66946007)(66476007)(66556008)(15650500001)(33716001)(4326008)(6496006)(478600001)(6666004)(5660300002)(316002)(30864003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CD86GLS8IfkOo9I4LKgdCgFXgPKdEBkok5zTkgv9PIeTaA6TQ1GNi5LTy+U9?=
 =?us-ascii?Q?C9gJ4ZtHN7vAQJ1qt7eb3FxK2BIxkse7OptNOftDBsTkKGsvEKVYy7hMKatK?=
 =?us-ascii?Q?qDby8KcGCSMrhIkbELGXTJGv4Kr2tPy8D/r7CBuYmQhw69YwR10jK2mNTzUk?=
 =?us-ascii?Q?38MqGWkkYMdcwH/adWHLjX1QtkPFoHOJ1+3MtOGGZomEx6xIsAenGH6WcQcP?=
 =?us-ascii?Q?rPEYScCiWnyesMp291qa/RSAePJlNLTTv64u0uffqliYnC51xPbsAtkMX3Hl?=
 =?us-ascii?Q?piRWthDnenf1mvgJt6BAvMWvsTgeLq4Y61wnvEL5Khu88u/Ysxot+1hjv5My?=
 =?us-ascii?Q?4qLBFQ+hnMRTXE65Kfj5M+f9Mg1n4SYH32mLOiz5cLENKFBHHteRvo326hNR?=
 =?us-ascii?Q?hghwbvZjNifbgQ3MMXdRzeVpluwAZbGVYYzqCAE36drtGLbZfo86UVMr/VrO?=
 =?us-ascii?Q?hvmLwcLJejV3HvSy0KfAGG5AMh7FJnq01B6rvy304RvS/QpQBkWvBKOXrqCv?=
 =?us-ascii?Q?PMNixlc29hC9aP1QNTXKaC+17SyM3ajN7qj3R9rdgCTsDsIdAqR7d5QDKfay?=
 =?us-ascii?Q?liu7nWZ9EERWOgRWrk0Nsl9vBZlwDDhGDkiLWpk8EHcY62WmZXcWP95mMpf3?=
 =?us-ascii?Q?c/ohgzDi/v3tMounFs7ATkVKyZYC3A7UI3SHYt6lbrcGUtQQXd9N37q2W/Rl?=
 =?us-ascii?Q?Qoo9g/+tlhjMdnoKxBvsvMkBY3MNUmjEngnwoY5Eh3cK8iDroLrwCzG7SEWX?=
 =?us-ascii?Q?isCm/CoOc1XFp413Erk77ZLvLDpVZlAIdRTVzpTeerMe2JXj1aPcROcw9wzv?=
 =?us-ascii?Q?OlxlE5vajjtAKoHb0oj6lT4EMsAZisi23O4ZTnKuc8toxYJQjHftvIWP/AJL?=
 =?us-ascii?Q?K33t5RsHX6SsNq+fllrziLfnRe1bIM41ooQWZUn2JaUYH5AVgv6pGTBI10fc?=
 =?us-ascii?Q?p503IFN7MagUQIal0XxLH6BzUAT1MvQ9m1ap/mG1EL3gK1AS06eYCvVfyZLN?=
 =?us-ascii?Q?n5tdB3zhLGgGG+gG1sI/p91qsSTkAeoRE/t2mO71jR6JUCu3V4wLY1SehMqv?=
 =?us-ascii?Q?+PsqYplU59UkzEeOi+Tp8+h9RiQankzBc+6haHBbjUb3723s50Q=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 467477f7-2784-48e3-ed53-08d8bf0d4141
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 19:38:13.2119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DomzNhSkIb/S0zBt5n4ycTgLUSHEXiIgILcg3gOZ+YGuvIiG+xb6fhjRfqtFAl14
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2838
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-22_14:2021-01-22,2021-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 mlxscore=0
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101220099
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 08:16:40AM -0800, sdf@google.com wrote:
> On 01/21, Martin KaFai Lau wrote:
> > On Thu, Jan 21, 2021 at 04:30:08PM -0800, sdf@google.com wrote:
> > > On 01/21, Martin KaFai Lau wrote:
> > > > On Thu, Jan 21, 2021 at 02:57:44PM -0800, sdf@google.com wrote:
> > > > > On 01/21, Martin KaFai Lau wrote:
> > > > > > On Wed, Jan 20, 2021 at 05:22:41PM -0800, Stanislav Fomichev
> > wrote:
> > > > > > > BPF rewrites from 111 to 111, but it still should mark the
> > port as
> > > > > > > "changed".
> > > > > > > We also verify that if port isn't touched by BPF, it's still
> > > > prohibited.
> > > > > > >
> > > > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > > > ---
> > > > > > >  .../selftests/bpf/prog_tests/bind_perm.c      | 88
> > > > +++++++++++++++++++
> > > > > > >  tools/testing/selftests/bpf/progs/bind_perm.c | 36 ++++++++
> > > > > > >  2 files changed, 124 insertions(+)
> > > > > > >  create mode 100644
> > > > tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > > > > > >  create mode 100644
> > tools/testing/selftests/bpf/progs/bind_perm.c
> > > > > > >
> > > > > > > diff --git a/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > > > > > b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > > > > > > new file mode 100644
> > > > > > > index 000000000000..840a04ac9042
> > > > > > > --- /dev/null
> > > > > > > +++ b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > > > > > > @@ -0,0 +1,88 @@
> > > > > > > +// SPDX-License-Identifier: GPL-2.0
> > > > > > > +#include <test_progs.h>
> > > > > > > +#include "bind_perm.skel.h"
> > > > > > > +
> > > > > > > +#include <sys/types.h>
> > > > > > > +#include <sys/socket.h>
> > > > > > > +#include <sys/capability.h>
> > > > > > > +
> > > > > > > +static int duration;
> > > > > > > +
> > > > > > > +void try_bind(int port, int expected_errno)
> > > > > > > +{
> > > > > > > +	struct sockaddr_in sin = {};
> > > > > > > +	int fd = -1;
> > > > > > > +
> > > > > > > +	fd = socket(AF_INET, SOCK_STREAM, 0);
> > > > > > > +	if (CHECK(fd < 0, "fd", "errno %d", errno))
> > > > > > > +		goto close_socket;
> > > > > > > +
> > > > > > > +	sin.sin_family = AF_INET;
> > > > > > > +	sin.sin_port = htons(port);
> > > > > > > +
> > > > > > > +	errno = 0;
> > > > > > > +	bind(fd, (struct sockaddr *)&sin, sizeof(sin));
> > > > > > > +	CHECK(errno != expected_errno, "bind", "errno %d, expected
> > %d",
> > > > > > > +	      errno, expected_errno);
> > > > > > > +
> > > > > > > +close_socket:
> > > > > > > +	if (fd >= 0)
> > > > > > > +		close(fd);
> > > > > > > +}
> > > > > > > +
> > > > > > > +void cap_net_bind_service(cap_flag_value_t flag)
> > > > > > > +{
> > > > > > > +	const cap_value_t cap_net_bind_service = CAP_NET_BIND_SERVICE;
> > > > > > > +	cap_t caps;
> > > > > > > +
> > > > > > > +	caps = cap_get_proc();
> > > > > > > +	if (CHECK(!caps, "cap_get_proc", "errno %d", errno))
> > > > > > > +		goto free_caps;
> > > > > > > +
> > > > > > > +	if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1,
> > > > &cap_net_bind_service,
> > > > > > > +			       CAP_CLEAR),
> > > > > > > +		  "cap_set_flag", "errno %d", errno))
> > > > > > > +		goto free_caps;
> > > > > > > +
> > > > > > > +	if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1,
> > > > &cap_net_bind_service,
> > > > > > > +			       CAP_CLEAR),
> > > > > > > +		  "cap_set_flag", "errno %d", errno))
> > > > > > > +		goto free_caps;
> > > > > > > +
> > > > > > > +	if (CHECK(cap_set_proc(caps), "cap_set_proc", "errno %d",
> > errno))
> > > > > > > +		goto free_caps;
> > > > > > > +
> > > > > > > +free_caps:
> > > > > > > +	if (CHECK(cap_free(caps), "cap_free", "errno %d", errno))
> > > > > > > +		goto free_caps;
> > > > > > > +}
> > > > > > > +
> > > > > > > +void test_bind_perm(void)
> > > > > > > +{
> > > > > > > +	struct bind_perm *skel;
> > > > > > > +	int cgroup_fd;
> > > > > > > +
> > > > > > > +	cgroup_fd = test__join_cgroup("/bind_perm");
> > > > > > > +	if (CHECK(cgroup_fd < 0, "cg-join", "errno %d", errno))
> > > > > > > +		return;
> > > > > > > +
> > > > > > > +	skel = bind_perm__open_and_load();
> > > > > > > +	if (CHECK(!skel, "skel-load", "errno %d", errno))
> > > > > > > +		goto close_cgroup_fd;
> > > > > > > +
> > > > > > > +	skel->links.bind_v4_prog =
> > > > > > bpf_program__attach_cgroup(skel->progs.bind_v4_prog, cgroup_fd);
> > > > > > > +	if (CHECK(IS_ERR(skel->links.bind_v4_prog),
> > > > > > > +		  "cg-attach", "bind4 %ld",
> > > > > > > +		  PTR_ERR(skel->links.bind_v4_prog)))
> > > > > > > +		goto close_skeleton;
> > > > > > > +
> > > > > > > +	cap_net_bind_service(CAP_CLEAR);
> > > > > > > +	try_bind(110, EACCES);
> > > > > > > +	try_bind(111, 0);
> > > > > > > +	cap_net_bind_service(CAP_SET);
> > > > > > > +
> > > > > > > +close_skeleton:
> > > > > > > +	bind_perm__destroy(skel);
> > > > > > > +close_cgroup_fd:
> > > > > > > +	close(cgroup_fd);
> > > > > > > +}
> > > > > > > diff --git a/tools/testing/selftests/bpf/progs/bind_perm.c
> > > > > > b/tools/testing/selftests/bpf/progs/bind_perm.c
> > > > > > > new file mode 100644
> > > > > > > index 000000000000..2194587ec806
> > > > > > > --- /dev/null
> > > > > > > +++ b/tools/testing/selftests/bpf/progs/bind_perm.c
> > > > > > > @@ -0,0 +1,36 @@
> > > > > > > +// SPDX-License-Identifier: GPL-2.0
> > > > > > > +
> > > > > > > +#include <linux/stddef.h>
> > > > > > > +#include <linux/bpf.h>
> > > > > > > +#include <sys/types.h>
> > > > > > > +#include <sys/socket.h>
> > > > > > > +#include <bpf/bpf_helpers.h>
> > > > > > > +#include <bpf/bpf_endian.h>
> > > > > > > +
> > > > > > > +SEC("cgroup/bind4")
> > > > > > > +int bind_v4_prog(struct bpf_sock_addr *ctx)
> > > > > > > +{
> > > > > > > +	struct bpf_sock *sk;
> > > > > > > +	__u32 user_ip4;
> > > > > > > +	__u16 user_port;
> > > > > > > +
> > > > > > > +	sk = ctx->sk;
> > > > > > > +	if (!sk)
> > > > > > > +		return 0;
> > > > > > > +
> > > > > > > +	if (sk->family != AF_INET)
> > > > > > > +		return 0;
> > > > > > > +
> > > > > > > +	if (ctx->type != SOCK_STREAM)
> > > > > > > +		return 0;
> > > > > > > +
> > > > > > > +	/* Rewriting to the same value should still cause
> > > > > > > +	 * permission check to be bypassed.
> > > > > > > +	 */
> > > > > > > +	if (ctx->user_port == bpf_htons(111))
> > > > > > > +		ctx->user_port = bpf_htons(111);
> > > > > > iiuc, this overwrite is essentially the way to ensure the bind
> > > > > > will succeed (override CAP_NET_BIND_SERVICE in this particular
> > case?).
> > > > > Correct. The alternative might be to export ignore_perm_check
> > > > > via bpf_sock_addr and make it explicit.
> > > > An explicit field is one option.
> > >
> > > > or a different return value (e.g.
> > BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY).
> > >
> > > > Not sure which one (including the one in the current patch) is better
> > > > at this point.
> > > Same. My reasoning was: if the BPF program rewrites the port, it knows
> > > what it's doing, so it doesn't seem like adding another explicit
> > > signal makes sense. So I decided to go without external api change.
> > >
> > > > Also, from patch 1, if one cgrp bpf prog says no-perm-check,
> > > > it does not matter what the latter cgrp bpf progs have to say?
> > > Right, it doesn't matter. But I think it's fine: if the latter
> > > one rewrites the (previously rewritten) address to something
> > > new, it still wants that address to be bound to, right?
> > >
> > > If some program returns EPERM, it also doesn't matter.
> > >
> > > > > > It seems to be okay if we consider most of the use cases is
> > rewriting
> > > > > > to a different port.
> > > > >
> > > > > > However, it is quite un-intuitive to the bpf prog to overwrite
> > with
> > > > > > the same user_port just to ensure this port can be binded
> > successfully
> > > > > > later.
> > > > > I'm testing a corner case here when the address is rewritten to
> > the same
> > > > > value, but the intention is to rewrite X to Y < 1024.
> > > > It is a legit corner case though.
> > >
> > > > Also, is it possible that the compiler may optimize this
> > > > same-value-assignment out?
> > > Yeah, it's a legit case, that's why I tested it. Good point on
> > > optimizing (can be "healed" with volatile?),
> > hmm... It is too fragile.
> 
> > > but it should only matter if
> > > the program is installed to bypass the permission checks for some ports
> > > (as it does in this selftest). As you mention below, it's not clear
> > what's
> > > the 'default' use-case is. Is it rewriting to a different port or just
> > > bypassing the cap_net_bind_service for some ports? Feels like rewriting
> > > to a different address/port was the reason the hooks were added,
> > > so I was targeting this one.
> > It sounds like having a bpf to bypass permission only without changing
> > the port is not the target but more like a by-product of this change.
> Right, we might have a use-case for that as well, but it's not
> strictly required. We can convert it to be something like
> 'rewrite this magic addr+port to this real addr+port'.
> 
> > How about only bypass cap_net_bind_service when bpf did change the
> > address/port.  Will it become too slow for bind?
> But this is what I'm doing already, isn't it? There is just a by-product
> of triggering it for the same port = port address.
My concern is the way to trigger this legit by-product is too fragile (and
unintuitive) to be usable.  Either avoid this by-product completely or
have a better way to specify the need of bypass.

Lets say we do the latter.  After more thoughts, I think doing it in the
return value is more natural since it is already saying the port/addr
should be EPERM or not.  It makes sense to add BYPASS or not to the
return value.  When one bpf prog says bypass, then it will bypass.
The second bit of the return value can be used to do that.
Thoughts?

> Tracking the real change will require extra space to keep the original
> address and then memcmp to figure out if the change was made.
> Assuming the majority of rewrites don't happen for <1024 ports
> this seems like a bunch of wasted work (vs setting that ctx->port_changed).
Right, so the earlier question about if other fields will need
similar bypass.  If it is only port, it is pretty cheap to do.
However, it seems other fields will eventually need this in the
future if not now.

The check "if (old != new)" itself may be doable within
convert_ctx_access() itself which at least helping on the space side.
However, I think the return value is an easier and cleaner way.
