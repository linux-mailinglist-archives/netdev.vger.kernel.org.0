Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703122FF9F7
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 02:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbhAVB3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 20:29:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63410 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725275AbhAVB27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 20:28:59 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10M1QPtO006934;
        Thu, 21 Jan 2021 17:28:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Q+6CxNKhLmKPcffO21t5EV97y4l2aCbwZy2qQzPRzi8=;
 b=YIEHgJOeo7RpZ1SA1AD4aHPzAI5Dc7bMiFDaGjUwOSi5HraEWLAJA2emswmDeaIzoptY
 eQJvTbKxOmVt2ZYRYwMIIz/Wqc2FBpT99GpFNn89X2pTBhCQQaE2kuUe4NMnk4QwQhay
 uWZxnBES7gTKfDRpSLimfoY7uYvxnp+7nGk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3668nvxphr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 21 Jan 2021 17:28:00 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 21 Jan 2021 17:27:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gzIMttGkiMRRSEQJoyqcW4bXtNHFolq0lakE1chxxw+QLvOS4J1JyOH5eocEjSMk1MHTdl00QDTb4lBtOMK+hO2DvttvOnhQVq/S4aTy+ImY0qZVsUONrPQLQ2thRWDoA2bGyZuq52GFLvuzf3wRE7rd5Qdp1BovOAPci3xafrgYD02rWd88CaQo59+/Lz/at9HV9+bSxCGVV+RZ4jTyeVRwhghCD9OSQn8hc1OjyBec6EPyvr20CnG2jKNd34qcWy0oW2XG+pIM47CItyHQTALQZIYAUsoywPdYWhZIOz2ZpcOeebR0BrmFxUlmSOwZAGXTuG+WIKFciVx2SK5+Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q+6CxNKhLmKPcffO21t5EV97y4l2aCbwZy2qQzPRzi8=;
 b=eoQY3vksWwj7td8INgJOmnu9BhKe/gty0ilQD/qdCNEJAWjjyyKzyOQI066cso/ObNyZ8XsqkX4ChuUBVUSqaOkq4adN1N3XhFX4Dt22DqGaTJ82QomYz+3YdoPAVFdLOiMbfZKhf6iWCf8FpvkLsMJsvQjBq0l8yXJKihYbJSm97Z67heFlP65EpEfGMVV3+VlRu0SMMdzlwCRiix27yk935RHDjzyzHXy2NoRc2jn48gM564k+H6VY3Bs0lRA2mQ7dncOiFpM25miOtX2B1if/3BmCo/FvBQbb05LPEYY8iWRkt3kENpM7jAx6DePHgzxziWFpX2fHT/49rW+owQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q+6CxNKhLmKPcffO21t5EV97y4l2aCbwZy2qQzPRzi8=;
 b=Cp2Sph+Im5soet2yCXisrfZsWcKJtsjEaY8YMYlBPlfW+U6wrxWyW1P26SIpajvmtrtFhI+4Qhs3QJtAgL0/fmAPGYsScvCfCLv6FRuFsJMqT7ka/AnT+Y0PUaofzbgRtEAe7SbPmfMct7StkBZTlx6pwB2ns2a8IS2p2zzRDEo=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3686.namprd15.prod.outlook.com (2603:10b6:610:1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.14; Fri, 22 Jan
 2021 01:27:58 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::a875:5b25:a9b4:e84e]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::a875:5b25:a9b4:e84e%7]) with mapi id 15.20.3784.012; Fri, 22 Jan 2021
 01:27:58 +0000
Date:   Thu, 21 Jan 2021 17:27:51 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: verify that rebinding to
 port < 1024 from BPF works
Message-ID: <20210122012751.ur4oxeprccefbbyl@kafai-mbp>
References: <20210121012241.2109147-1-sdf@google.com>
 <20210121012241.2109147-2-sdf@google.com>
 <20210121223330.pyk4ljtjirm2zlay@kafai-mbp>
 <YAoG6K37QtRZGJGy@google.com>
 <20210121235007.vmq24fjyesrvjkqm@kafai-mbp>
 <YAockJDIOt3jTqd2@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAockJDIOt3jTqd2@google.com>
X-Originating-IP: [2620:10d:c090:400::5:2363]
X-ClientProxiedBy: SJ0PR05CA0208.namprd05.prod.outlook.com
 (2603:10b6:a03:330::33) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:2363) by SJ0PR05CA0208.namprd05.prod.outlook.com (2603:10b6:a03:330::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.7 via Frontend Transport; Fri, 22 Jan 2021 01:27:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c34de072-d06a-49fe-d490-08d8be74f369
X-MS-TrafficTypeDiagnostic: CH2PR15MB3686:
X-Microsoft-Antispam-PRVS: <CH2PR15MB3686CAEE9C6A95D3CBA5FB98D5A00@CH2PR15MB3686.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zuzXwHOo6odZG1F8lz1ErdhoA7teSO7IW/xrpImKtOUd/5aeKgMnVhgwj0bSpWoIUCcfSZNSm+cFBoaLoJ7vXm4Vu5UX3uzgWMRBNITbmzmvtxcj/0+RYZEWADlXiEVEnvpqmSd7oVa475xdRca0QSfcmEJS/oaxh8P7bTquoamiPNVuDkwcAcUv5CETG//xAoYkffTQoKjIvLneFpt+9eOLlnj3adMIVK1e8Wqxu4qEZtUH+EU0BgKwoyWByi6eYgrySnaClYPPcX8JUmKP4lqYcCHh5yFzXURbR2hCsC9q21tbzccQa9nA0fNc/l91Fvx9CUS8JJkbiJCYQbjT0JatiaZ83Uon7KBudenMD8llxw3G76DLh1gGv7m2wT2ydkqUtbYWFb50+iEoArkInGBwk2irg5ZvLXQmNL/boCmGALYhXaLifC0BFIR5F9/KV9fXCW3VUMoK6hxpbzfdFGKDpjpO3kbjC70QVIN+Qrv1AUaGdeo2qs+DNY78bQyWZ1Bq4am8I3JiETM47TYYcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(39860400002)(136003)(346002)(366004)(16526019)(6496006)(66946007)(83380400001)(186003)(9686003)(15650500001)(478600001)(6666004)(55016002)(86362001)(66476007)(4326008)(66556008)(8936002)(8676002)(1076003)(6916009)(5660300002)(52116002)(316002)(33716001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GOLDiBkH5LI/t2EyZuyDPs6n4FNZcvqSWFHAEqNc5gR3WiABVm+G4V5HtHS8?=
 =?us-ascii?Q?9WWGrurIDsyd95EX6GPkyUcqwrQ/O1Vot3mhrKOlVCH+QgSKD1T2YJiObvKZ?=
 =?us-ascii?Q?U4Geui6WWU//KX8q0AtyHO2tJjlPWRbv/OpdfR7qMVmkBvuxBePZ8W7+qakV?=
 =?us-ascii?Q?n50fRqJSv5yZADbxca2LfjWteKCZjMZb5kr7VOler+QH2N666WcLFfY4y5md?=
 =?us-ascii?Q?D+KiBgr+1pBAi7PIcbl0IA4usv5Qz0Kk56VhORzy4HrFww1PtY6i9BMnO3wj?=
 =?us-ascii?Q?lYnlfkctT6solZKVv+OOcTMPwW7Rggd5RVFoBLmxpqvgLpDJWMLA0GKX9C/J?=
 =?us-ascii?Q?VeJXkSARBu5bDBBBHcbItN4bifteKFf7+FAL4yeB65idZ5K0/xMqSgVAC1jf?=
 =?us-ascii?Q?+HwF7hVHwxDmL3BBXhTMxS13B42gmAY7QnQulnkcfXrGRx6ZC3ekR4lmL6fM?=
 =?us-ascii?Q?sgDt1oaxbgSD9T19vBBeE2wpemdNUk1ywnsvNkR78UUCN/uXe+b7hmJRSjyX?=
 =?us-ascii?Q?06iaPhR1ezS7iNa8+BFgPsyu5V+fM1rkzZRX+geVfBSuswx+XeouoSc2xJbJ?=
 =?us-ascii?Q?aW/L3nhRPreRJ48MYujgAuTXY/LbWqrPPVdgRCKstcN/jxkH4QnzLmd7SnHf?=
 =?us-ascii?Q?0MQhk4WJgX5Jw0ALoKqJXrOjaE9o3HTeXSpPiE8Xhv3LonD7YdMfiVHnCN2C?=
 =?us-ascii?Q?eLCMzurImrLolCZ9t0H9CGz/lr/HQPVbtnLy33/MCysSLY7h8QlHU2/zb82Z?=
 =?us-ascii?Q?6spHh/jL2+vUbjHZ/h1HTvEyMAEPV1KYfiIX3FUN6XSy59jb+4KZsNnKAe/Z?=
 =?us-ascii?Q?CyuHgR8cI1LPfc0VeCNhi3BH9FsFjZIEoe6EzNr823SOtlM0+2PTABio9ixY?=
 =?us-ascii?Q?KbIM5tcr5mgGkRtcZlbak7trL4TbXTZX7pP/3EA330ztX1wmjut11EstAOfv?=
 =?us-ascii?Q?TMw1KHkhwJkTENaYdHXreKSikgn5Qd0ZQKEYeML0ubC26/KbCAfaKBP1vaLO?=
 =?us-ascii?Q?RdJt6YCTNTgYslJT673PATYGMw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c34de072-d06a-49fe-d490-08d8be74f369
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 01:27:58.5306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 79QymzUy7NTE6+hqcoeHccrlbDzqgXoHzYhhA5Ogv2JuZbdhWp8Sby+VI0D75R45
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3686
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_11:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101220003
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 04:30:08PM -0800, sdf@google.com wrote:
> On 01/21, Martin KaFai Lau wrote:
> > On Thu, Jan 21, 2021 at 02:57:44PM -0800, sdf@google.com wrote:
> > > On 01/21, Martin KaFai Lau wrote:
> > > > On Wed, Jan 20, 2021 at 05:22:41PM -0800, Stanislav Fomichev wrote:
> > > > > BPF rewrites from 111 to 111, but it still should mark the port as
> > > > > "changed".
> > > > > We also verify that if port isn't touched by BPF, it's still
> > prohibited.
> > > > >
> > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > ---
> > > > >  .../selftests/bpf/prog_tests/bind_perm.c      | 88
> > +++++++++++++++++++
> > > > >  tools/testing/selftests/bpf/progs/bind_perm.c | 36 ++++++++
> > > > >  2 files changed, 124 insertions(+)
> > > > >  create mode 100644
> > tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > > > >  create mode 100644 tools/testing/selftests/bpf/progs/bind_perm.c
> > > > >
> > > > > diff --git a/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > > > b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > > > > new file mode 100644
> > > > > index 000000000000..840a04ac9042
> > > > > --- /dev/null
> > > > > +++ b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > > > > @@ -0,0 +1,88 @@
> > > > > +// SPDX-License-Identifier: GPL-2.0
> > > > > +#include <test_progs.h>
> > > > > +#include "bind_perm.skel.h"
> > > > > +
> > > > > +#include <sys/types.h>
> > > > > +#include <sys/socket.h>
> > > > > +#include <sys/capability.h>
> > > > > +
> > > > > +static int duration;
> > > > > +
> > > > > +void try_bind(int port, int expected_errno)
> > > > > +{
> > > > > +	struct sockaddr_in sin = {};
> > > > > +	int fd = -1;
> > > > > +
> > > > > +	fd = socket(AF_INET, SOCK_STREAM, 0);
> > > > > +	if (CHECK(fd < 0, "fd", "errno %d", errno))
> > > > > +		goto close_socket;
> > > > > +
> > > > > +	sin.sin_family = AF_INET;
> > > > > +	sin.sin_port = htons(port);
> > > > > +
> > > > > +	errno = 0;
> > > > > +	bind(fd, (struct sockaddr *)&sin, sizeof(sin));
> > > > > +	CHECK(errno != expected_errno, "bind", "errno %d, expected %d",
> > > > > +	      errno, expected_errno);
> > > > > +
> > > > > +close_socket:
> > > > > +	if (fd >= 0)
> > > > > +		close(fd);
> > > > > +}
> > > > > +
> > > > > +void cap_net_bind_service(cap_flag_value_t flag)
> > > > > +{
> > > > > +	const cap_value_t cap_net_bind_service = CAP_NET_BIND_SERVICE;
> > > > > +	cap_t caps;
> > > > > +
> > > > > +	caps = cap_get_proc();
> > > > > +	if (CHECK(!caps, "cap_get_proc", "errno %d", errno))
> > > > > +		goto free_caps;
> > > > > +
> > > > > +	if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1,
> > &cap_net_bind_service,
> > > > > +			       CAP_CLEAR),
> > > > > +		  "cap_set_flag", "errno %d", errno))
> > > > > +		goto free_caps;
> > > > > +
> > > > > +	if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1,
> > &cap_net_bind_service,
> > > > > +			       CAP_CLEAR),
> > > > > +		  "cap_set_flag", "errno %d", errno))
> > > > > +		goto free_caps;
> > > > > +
> > > > > +	if (CHECK(cap_set_proc(caps), "cap_set_proc", "errno %d", errno))
> > > > > +		goto free_caps;
> > > > > +
> > > > > +free_caps:
> > > > > +	if (CHECK(cap_free(caps), "cap_free", "errno %d", errno))
> > > > > +		goto free_caps;
> > > > > +}
> > > > > +
> > > > > +void test_bind_perm(void)
> > > > > +{
> > > > > +	struct bind_perm *skel;
> > > > > +	int cgroup_fd;
> > > > > +
> > > > > +	cgroup_fd = test__join_cgroup("/bind_perm");
> > > > > +	if (CHECK(cgroup_fd < 0, "cg-join", "errno %d", errno))
> > > > > +		return;
> > > > > +
> > > > > +	skel = bind_perm__open_and_load();
> > > > > +	if (CHECK(!skel, "skel-load", "errno %d", errno))
> > > > > +		goto close_cgroup_fd;
> > > > > +
> > > > > +	skel->links.bind_v4_prog =
> > > > bpf_program__attach_cgroup(skel->progs.bind_v4_prog, cgroup_fd);
> > > > > +	if (CHECK(IS_ERR(skel->links.bind_v4_prog),
> > > > > +		  "cg-attach", "bind4 %ld",
> > > > > +		  PTR_ERR(skel->links.bind_v4_prog)))
> > > > > +		goto close_skeleton;
> > > > > +
> > > > > +	cap_net_bind_service(CAP_CLEAR);
> > > > > +	try_bind(110, EACCES);
> > > > > +	try_bind(111, 0);
> > > > > +	cap_net_bind_service(CAP_SET);
> > > > > +
> > > > > +close_skeleton:
> > > > > +	bind_perm__destroy(skel);
> > > > > +close_cgroup_fd:
> > > > > +	close(cgroup_fd);
> > > > > +}
> > > > > diff --git a/tools/testing/selftests/bpf/progs/bind_perm.c
> > > > b/tools/testing/selftests/bpf/progs/bind_perm.c
> > > > > new file mode 100644
> > > > > index 000000000000..2194587ec806
> > > > > --- /dev/null
> > > > > +++ b/tools/testing/selftests/bpf/progs/bind_perm.c
> > > > > @@ -0,0 +1,36 @@
> > > > > +// SPDX-License-Identifier: GPL-2.0
> > > > > +
> > > > > +#include <linux/stddef.h>
> > > > > +#include <linux/bpf.h>
> > > > > +#include <sys/types.h>
> > > > > +#include <sys/socket.h>
> > > > > +#include <bpf/bpf_helpers.h>
> > > > > +#include <bpf/bpf_endian.h>
> > > > > +
> > > > > +SEC("cgroup/bind4")
> > > > > +int bind_v4_prog(struct bpf_sock_addr *ctx)
> > > > > +{
> > > > > +	struct bpf_sock *sk;
> > > > > +	__u32 user_ip4;
> > > > > +	__u16 user_port;
> > > > > +
> > > > > +	sk = ctx->sk;
> > > > > +	if (!sk)
> > > > > +		return 0;
> > > > > +
> > > > > +	if (sk->family != AF_INET)
> > > > > +		return 0;
> > > > > +
> > > > > +	if (ctx->type != SOCK_STREAM)
> > > > > +		return 0;
> > > > > +
> > > > > +	/* Rewriting to the same value should still cause
> > > > > +	 * permission check to be bypassed.
> > > > > +	 */
> > > > > +	if (ctx->user_port == bpf_htons(111))
> > > > > +		ctx->user_port = bpf_htons(111);
> > > > iiuc, this overwrite is essentially the way to ensure the bind
> > > > will succeed (override CAP_NET_BIND_SERVICE in this particular case?).
> > > Correct. The alternative might be to export ignore_perm_check
> > > via bpf_sock_addr and make it explicit.
> > An explicit field is one option.
> 
> > or a different return value (e.g. BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY).
> 
> > Not sure which one (including the one in the current patch) is better
> > at this point.
> Same. My reasoning was: if the BPF program rewrites the port, it knows
> what it's doing, so it doesn't seem like adding another explicit
> signal makes sense. So I decided to go without external api change.
> 
> > Also, from patch 1, if one cgrp bpf prog says no-perm-check,
> > it does not matter what the latter cgrp bpf progs have to say?
> Right, it doesn't matter. But I think it's fine: if the latter
> one rewrites the (previously rewritten) address to something
> new, it still wants that address to be bound to, right?
> 
> If some program returns EPERM, it also doesn't matter.
> 
> > > > It seems to be okay if we consider most of the use cases is rewriting
> > > > to a different port.
> > >
> > > > However, it is quite un-intuitive to the bpf prog to overwrite with
> > > > the same user_port just to ensure this port can be binded successfully
> > > > later.
> > > I'm testing a corner case here when the address is rewritten to the same
> > > value, but the intention is to rewrite X to Y < 1024.
> > It is a legit corner case though.
> 
> > Also, is it possible that the compiler may optimize this
> > same-value-assignment out?
> Yeah, it's a legit case, that's why I tested it. Good point on
> optimizing (can be "healed" with volatile?),
hmm... It is too fragile.

> but it should only matter if
> the program is installed to bypass the permission checks for some ports
> (as it does in this selftest). As you mention below, it's not clear what's
> the 'default' use-case is. Is it rewriting to a different port or just
> bypassing the cap_net_bind_service for some ports? Feels like rewriting
> to a different address/port was the reason the hooks were added,
> so I was targeting this one.
It sounds like having a bpf to bypass permission only without changing
the port is not the target but more like a by-product of this change.

How about only bypass cap_net_bind_service when bpf did change the
address/port.  Will it become too slow for bind?

> 
> > > > Is user_port the only case? How about other fields in bpf_sock_addr?
> > > Good question. For our use case only the port matters because
> > > we rewrite both port and address (and never only address).
> > >
> > > It does feel like it should also work when BPF rewrites address only
> > > (and port happens to be in the privileged range). I guess I can
> > > apply the same logic to the user_ip4 and user_ip6?
> > My concern is having more cases that need to overwrite with the same
> > value.
> > Then it may make a stronger case to use return value or an explicit field.
> Tried to add some reasoning in the comment above. Let me know what's
> your preference is.
