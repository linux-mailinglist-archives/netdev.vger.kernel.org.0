Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C57558B48
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 00:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiFWWhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 18:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiFWWhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 18:37:15 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FEB51321;
        Thu, 23 Jun 2022 15:37:13 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NK3WND014202;
        Thu, 23 Jun 2022 15:36:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=lAecZfHL3z5lCrj6im+2Pz38PxwicsAyu3MOow+l0hY=;
 b=ku54y53GCf7DzuKJ7hMqHdwD9Kl82H6MgQihAqYG2b1/yNTeDoXnYD/EQBF2ASGTYdf1
 g0fZF3PzCYCk6doK4nhqarES9nbP0sCVNyJzTWfQjajphu5gtrT3Mq7KIZizzIB2FtIh
 qTQB1rnZOV/yVAZuKwa4mEyCSyk33iBP+y0= 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gvp68ccfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 15:36:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjYxxoRJ5MRWJ9gSKXcSEB9QjCpRiNVWPlowWeX1YSVYqZCYWnPHoAsSjxFCK3/2VFQ/eAQZR94oKxUAXzg1AJdrhydSvX7PXUTAYDt3XpBhfJnnWqykoubQHtNiKBkMvK9V82bFEs9AoPTRDWEUyoa/G5xHt9Fw2Kns6VyEk5+N1Z4JqztN10ZhUXdcHyyzV3Ej8+5DemKR1grSaqcmqXxKqIZgtqhJISs3fDTZ4wD0oMIQU0z6FrjhI/R7GkbUm9Fc7tO7m9E3bi2RsZXvXZs7s9AJA4tooONKnXuRmVGpnKxrRpnvNLnBoe4Oy+YtJgsJO4jMJmTugPVUSauu3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lAecZfHL3z5lCrj6im+2Pz38PxwicsAyu3MOow+l0hY=;
 b=fwqs9u67aUjXr7nYofldlM/c4Z2MAJSd04gAh32cj/oE0YTzSL50GjaCNhfItv6Wgibl8LaO2H7l1qGyk6j8PRfsxszWPhL5DeAW92JFHAZtUqwy8KloUvySo01xmz1ll82qYbcdx7JYprsZBjjtahSogQYKr5JI85O1trLI+6/LZxJYarZVSTDesUneIoHETcfoPzrAmNIWGcPs6OPnhjikSNhD/fGgnZoY1tjXA0LAvgExtGyae8oos5icuPOCul6BOeuztYRcAA887c2C15fc73Xd/3Vejl3Bbb6OgKOOv3UYE0kcPou1exSaDjCvwbpil6rfVgvYn4RaYaD/og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BN6PR15MB1267.namprd15.prod.outlook.com (2603:10b6:404:ef::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 22:36:33 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%7]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 22:36:33 +0000
Date:   Thu, 23 Jun 2022 15:36:31 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v10 11/11] selftests/bpf: lsm_cgroup functional
 test
Message-ID: <20220623223631.uu3uakauseipsx5a@kafai-mbp>
References: <20220622160346.967594-1-sdf@google.com>
 <20220622160346.967594-12-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622160346.967594-12-sdf@google.com>
X-ClientProxiedBy: BY5PR16CA0001.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::14) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c4f4799-774c-4e59-6b53-08da5568d302
X-MS-TrafficTypeDiagnostic: BN6PR15MB1267:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TNBM/6cLl9LQODSAtxQCXQN4ymzC0MbdxHzxizhFE/+b6YWDT86U7Icjhr+fUEL2vmQDdADb9ZCd7i+pCHyStgpA92WH4nA9+eWnzelsNTB/PZvoC5xJqh9FCWgpqCUeR3AXcuthR7YIOCHnnQgWrczJyRKTzC/bIAQyd76ZN8uufwufaDu744fOynB7kZW9lfT7LOR1dUTjknZJg03sA0o9B68N3sgwYyrxtdDTfK91yPOLzrdNNgzb0Ivd48pN6AwqBvepu/7gntPdhUYdO4TN3FnBxiFHAOEFL3OBEJojMGR3hJn0os5geanNohTFE2Nhvzwx/PaymqWW6IJ73Ja/JwBjUv2WwIs/h/jo0qMOgnRNm/P6pfq2/cM6NoWNU7d4bCeggbWO+JcMJRKWpABAPpKFH3mWghhAiyZY3GbhswrnKa5wFF1Y4Lf6Fh5EjNFU3HFVumKa51QXCnHhcDUOClbv2EOldKDazZBRepWYdfnDPzTJESdkaT5pk6cWWKvNg9dC4JcKNcmMZ1tVXKR8cmlyGTFMc/L38Z78mqfV4XKygRrD3a1kO3zuuV842nmJoJaUSP+ZCBkUKaQGeEE7OaqKodSWPK5n/05zyYuSKVJtH3bB1Jp8xg7H5ITop5IDeCGOoMu5TuoQtIWcvK4rBvbbFcVnzFvqaInYmkN5CkyvBkv2os6rRqv4qjV/5dx1TuxeqBLpU4jMeZO7CQX36zF6d14v5EUwF1mrleU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(346002)(366004)(39860400002)(376002)(136003)(83380400001)(41300700001)(66476007)(5660300002)(6512007)(478600001)(186003)(1076003)(52116002)(9686003)(38100700002)(2906002)(33716001)(66946007)(86362001)(8936002)(6506007)(6916009)(30864003)(6486002)(4326008)(8676002)(66556008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8gfERgFo0XjaKd9HVK+chf6Doul8spqJxE4m1CKK1KfHrgcOthBgL+rbN8FD?=
 =?us-ascii?Q?7SmR1OYMX+Wi1vtwrJJOpyeCTU6yTGrBcuc4ZIrpZaYkPqCX5TJoZPzdRKRt?=
 =?us-ascii?Q?iBr88RpbvtR6jevoA2MDJU+4n/q9UjjxaPJPRrv7dH27ogfNPnrzsfy4oSfK?=
 =?us-ascii?Q?r+22H/d2sHVx0hDByyFw8fQULSADOijHsn9dKkZDpd1v1uGqMovdYCGNweG6?=
 =?us-ascii?Q?6ckzRSwExo1AI/RWfMWBu11QznvS+FYqqBp1BmVsi1GftTuydKsebjbr+OGd?=
 =?us-ascii?Q?25vJvqAlLn0VDRrG8m8981EDb6N9SlP+3Ltl048QNgf975FP45E292W0wx2V?=
 =?us-ascii?Q?v5Co9WNMVFQjxJRrk7WYlUUFExUIhGmi6tiGW19EsEMM35SuWBLK15gYZ0mq?=
 =?us-ascii?Q?UTl4z0N7N8FGF2wt89Eltm3OutdFi0YdDrJqZz3E95/DovLMPq2W5LLDy3rI?=
 =?us-ascii?Q?vT/MGsW8NsqZG+/GYfFIS0/RyyyYktasDsREzVnJKaBWYStareh2S96rKAqm?=
 =?us-ascii?Q?7XoowOIq0LEf12GnfVQWdNCa7sXNv+3FYqpHGlQZ9qidFns3Qn/B6zvPO82g?=
 =?us-ascii?Q?1imR4wum4xWHwj5FhZrcCdlDlPy+XIhv2xzUYnSrMRgftp8aIF7wydq7TOU/?=
 =?us-ascii?Q?Gpltlrr7p0vQF17AGy0chQXVvAC16PRS4ykjIWd8x6Y7tB5vW8FyJplVKuom?=
 =?us-ascii?Q?xy1YblK8tgEa0C23tBmawH1Xr8hD2Eg0KzqV4WLIV7wIg1nMAKhkKaaFuXNs?=
 =?us-ascii?Q?e5L1Oqiam4TblhY9tUEVmEcq9Y/W8gF1D4L3gwefrUJTy3ZduDKzw1xEhEnn?=
 =?us-ascii?Q?sI8hi77mn/sRjcifDn2wg5hVZ8JXQ5nVSdXgTXQvf9DQDtpH8Gy7pe4QkAZk?=
 =?us-ascii?Q?A4XoSxKOwi1s9dsCEqS9wCwfrGqwp6NKeK/ywCxOQSjzIS0rTL46VaAtF4bY?=
 =?us-ascii?Q?vXJBzqvMdxHl9IYrwHuVdy+QYvGUhcUCy7UhCE/6W4YhkgXMCrT8cKfFz/Um?=
 =?us-ascii?Q?c9UpbsXfNxZQUXQOrs0ntsiOVj4Njj0370mRvUPgDH91VOjq4YssTkmJ/rhQ?=
 =?us-ascii?Q?0qhp1WJNhXxZrGshKzeVrGgCiJKhrHaj67EqGvCmN94WNbcNLBFHfWuuwR5b?=
 =?us-ascii?Q?2mwX00EHpfmIN9DZcxffOuyyscC2yP/NC4uk9YccDWpHQ7Qybm3IaAGuDwAJ?=
 =?us-ascii?Q?mQQc9My7M2+Kcffq6WCfUgxJTRo2G/SfwGdinVSGO63XYA+YKS3onBfJjS+i?=
 =?us-ascii?Q?QPzm2+kzQzv2GfdEib5NrpMGdY3erfR7TQ2dquyKI6/yAcWXlqlTz0O5dwY/?=
 =?us-ascii?Q?Zf7TClif0h4mA/t6HD9w5iKOu7Rwigq/1DrLuG4p9j/7CFInnwedFYeviuKy?=
 =?us-ascii?Q?TJ0D8D0hB93tUfS4a1kpvCrIW2v6Iu9ZcrkzUF2bC8Tr6hLyq6k7SUDLnCGn?=
 =?us-ascii?Q?g7WwxixwO/1tCqAnuiApACWJ7aKVKWaz9wBTGPh3m/gyUK3UsoDQSGrjJ+Uh?=
 =?us-ascii?Q?WAEGG/GbMIe52z9acwObCX/pxWtI/zAQDUHfqaKRIq+EIh3ytftBBfLNMQJO?=
 =?us-ascii?Q?IgB8+lJ52LvgAIC2iLsXgIxzMHkF/aFjxyUGTGJ0PxQZGArrEhlAiFi0jzNy?=
 =?us-ascii?Q?Zg=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c4f4799-774c-4e59-6b53-08da5568d302
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 22:36:33.3800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J97QOleLSpZLe7w1hESdqz3CxwA4hcUdPWFp7nos+MvcOK3ots7Lyhg7Tv+eTG7g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1267
X-Proofpoint-GUID: iym_NwLHX27cktSH432NwY_14j-Jt2zC
X-Proofpoint-ORIG-GUID: iym_NwLHX27cktSH432NwY_14j-Jt2zC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_10,2022-06-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 09:03:46AM -0700, Stanislav Fomichev wrote:
> diff --git a/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c b/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
> new file mode 100644
> index 000000000000..a96057ec7dd4
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
> @@ -0,0 +1,277 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <sys/types.h>
> +#include <sys/socket.h>
> +#include <test_progs.h>
> +#include <bpf/btf.h>
> +
> +#include "lsm_cgroup.skel.h"
> +#include "cgroup_helpers.h"
> +#include "network_helpers.h"
> +
> +static __u32 query_prog_cnt(int cgroup_fd, const char *attach_func)
> +{
> +	LIBBPF_OPTS(bpf_prog_query_opts, p);
> +	static struct btf *btf;
> +	int cnt = 0;
> +	int i;
> +
> +	ASSERT_OK(bpf_prog_query_opts(cgroup_fd, BPF_LSM_CGROUP, &p), "prog_query");
> +
> +	if (!attach_func)
> +		return p.prog_cnt;
> +
> +	/* When attach_func is provided, count the number of progs that
> +	 * attach to the given symbol.
> +	 */
> +
> +	if (!btf)
> +		btf = btf__load_vmlinux_btf();
This needs a btf__free().  Probably at the end of test_lsm_cgroup().

> +	if (!ASSERT_OK(libbpf_get_error(btf), "btf_vmlinux"))
> +		return -1;
> +
> +	p.prog_ids = malloc(sizeof(u32) * p.prog_cnt);
> +	p.prog_attach_flags = malloc(sizeof(u32) * p.prog_cnt);
and these mallocs too ?

> +	ASSERT_OK(bpf_prog_query_opts(cgroup_fd, BPF_LSM_CGROUP, &p), "prog_query");
> +
> +	for (i = 0; i < p.prog_cnt; i++) {
> +		struct bpf_prog_info info = {};
> +		__u32 info_len = sizeof(info);
> +		int fd;
> +
> +		fd = bpf_prog_get_fd_by_id(p.prog_ids[i]);
> +		ASSERT_GE(fd, 0, "prog_get_fd_by_id");
> +		ASSERT_OK(bpf_obj_get_info_by_fd(fd, &info, &info_len), "prog_info_by_fd");
> +		close(fd);
> +
> +		if (info.attach_btf_id ==
> +		    btf__find_by_name_kind(btf, attach_func, BTF_KIND_FUNC))
> +			cnt++;
> +	}
> +
> +	return cnt;
> +}
> +
> +static void test_lsm_cgroup_functional(void)
> +{
> +	DECLARE_LIBBPF_OPTS(bpf_prog_attach_opts, attach_opts);
> +	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, update_opts);
> +	int cgroup_fd, cgroup_fd2, err, fd, prio;
> +	int listen_fd, client_fd, accepted_fd;
> +	struct lsm_cgroup *skel = NULL;
> +	int post_create_prog_fd2 = -1;
> +	int post_create_prog_fd = -1;
> +	int bind_link_fd2 = -1;
> +	int bind_prog_fd2 = -1;
> +	int alloc_prog_fd = -1;
> +	int bind_prog_fd = -1;
> +	int bind_link_fd = -1;
> +	int clone_prog_fd = -1;
> +	socklen_t socklen;
> +
> +	cgroup_fd = test__join_cgroup("/sock_policy");
> +	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
> +		goto close_skel;
> +
> +	cgroup_fd2 = create_and_get_cgroup("/sock_policy2");
> +	if (!ASSERT_GE(cgroup_fd2, 0, "create second cgroup"))
cgroup_fd needs to close in this error case

> +		goto close_skel;

A valid cgroup_fd2 should be closed later also.

> +
> +	skel = lsm_cgroup__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "open_and_load"))
> +		goto close_cgroup;
> +
> +	post_create_prog_fd = bpf_program__fd(skel->progs.socket_post_create);
> +	post_create_prog_fd2 = bpf_program__fd(skel->progs.socket_post_create2);
> +	bind_prog_fd = bpf_program__fd(skel->progs.socket_bind);
> +	bind_prog_fd2 = bpf_program__fd(skel->progs.socket_bind2);
> +	alloc_prog_fd = bpf_program__fd(skel->progs.socket_alloc);
> +	clone_prog_fd = bpf_program__fd(skel->progs.socket_clone);
> +
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_sk_alloc_security"), 0, "prog count");
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 0, "total prog count");
> +	err = bpf_prog_attach(alloc_prog_fd, cgroup_fd, BPF_LSM_CGROUP, 0);
> +	if (!ASSERT_OK(err, "attach alloc_prog_fd"))
> +		goto detach_cgroup;
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_sk_alloc_security"), 1, "prog count");
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 1, "total prog count");
> +
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_inet_csk_clone"), 0, "prog count");
> +	err = bpf_prog_attach(clone_prog_fd, cgroup_fd, BPF_LSM_CGROUP, 0);
> +	if (!ASSERT_OK(err, "attach clone_prog_fd"))
> +		goto detach_cgroup;
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_inet_csk_clone"), 1, "prog count");
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 2, "total prog count");
> +
> +	/* Make sure replacing works. */
> +
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_post_create"), 0, "prog count");
> +	err = bpf_prog_attach(post_create_prog_fd, cgroup_fd,
> +			      BPF_LSM_CGROUP, 0);
> +	if (!ASSERT_OK(err, "attach post_create_prog_fd"))
> +		goto close_cgroup;
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_post_create"), 1, "prog count");
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 3, "total prog count");
> +
> +	attach_opts.replace_prog_fd = post_create_prog_fd;
> +	err = bpf_prog_attach_opts(post_create_prog_fd2, cgroup_fd,
> +				   BPF_LSM_CGROUP, &attach_opts);
> +	if (!ASSERT_OK(err, "prog replace post_create_prog_fd"))
> +		goto detach_cgroup;
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_post_create"), 1, "prog count");
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 3, "total prog count");
> +
> +	/* Try the same attach/replace via link API. */
> +
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_bind"), 0, "prog count");
> +	bind_link_fd = bpf_link_create(bind_prog_fd, cgroup_fd,
> +				       BPF_LSM_CGROUP, NULL);
> +	if (!ASSERT_GE(bind_link_fd, 0, "link create bind_prog_fd"))
> +		goto detach_cgroup;
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_bind"), 1, "prog count");
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 4, "total prog count");
> +
> +	update_opts.old_prog_fd = bind_prog_fd;
> +	update_opts.flags = BPF_F_REPLACE;
> +
> +	err = bpf_link_update(bind_link_fd, bind_prog_fd2, &update_opts);
> +	if (!ASSERT_OK(err, "link update bind_prog_fd"))
> +		goto detach_cgroup;
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_bind"), 1, "prog count");
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 4, "total prog count");
> +
> +	/* Attach another instance of bind program to another cgroup.
> +	 * This should trigger the reuse of the trampoline shim (two
> +	 * programs attaching to the same btf_id).
> +	 */
> +
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_bind"), 1, "prog count");
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd2, "bpf_lsm_socket_bind"), 0, "prog count");
> +	bind_link_fd2 = bpf_link_create(bind_prog_fd2, cgroup_fd2,
> +					BPF_LSM_CGROUP, NULL);
> +	if (!ASSERT_GE(bind_link_fd2, 0, "link create bind_prog_fd2"))
> +		goto detach_cgroup;
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd2, "bpf_lsm_socket_bind"), 1, "prog count");
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 4, "total prog count");
> +	ASSERT_EQ(query_prog_cnt(cgroup_fd2, NULL), 1, "total prog count");
> +
> +	/* AF_UNIX is prohibited. */
> +
> +	fd = socket(AF_UNIX, SOCK_STREAM, 0);
> +	ASSERT_LT(fd, 0, "socket(AF_UNIX)");
close on fd >=0 case.

> +
> +	/* AF_INET6 gets default policy (sk_priority). */
> +
> +	fd = socket(AF_INET6, SOCK_STREAM, 0);
> +	if (!ASSERT_GE(fd, 0, "socket(SOCK_STREAM)"))
> +		goto detach_cgroup;
> +
> +	prio = 0;
> +	socklen = sizeof(prio);
> +	ASSERT_GE(getsockopt(fd, SOL_SOCKET, SO_PRIORITY, &prio, &socklen), 0,
> +		  "getsockopt");
> +	ASSERT_EQ(prio, 123, "sk_priority");
> +
> +	close(fd);
> +
> +	/* TX-only AF_PACKET is allowed. */
> +
> +	ASSERT_LT(socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL)), 0,
> +		  "socket(AF_PACKET, ..., ETH_P_ALL)");
> +
> +	fd = socket(AF_PACKET, SOCK_RAW, 0);
> +	ASSERT_GE(fd, 0, "socket(AF_PACKET, ..., 0)");
> +
> +	/* TX-only AF_PACKET can not be rebound. */
> +
> +	struct sockaddr_ll sa = {
> +		.sll_family = AF_PACKET,
> +		.sll_protocol = htons(ETH_P_ALL),
> +	};
> +	ASSERT_LT(bind(fd, (struct sockaddr *)&sa, sizeof(sa)), 0,
> +		  "bind(ETH_P_ALL)");
> +
> +	close(fd);
> +
> +	/* Trigger passive open. */
> +
> +	listen_fd = start_server(AF_INET6, SOCK_STREAM, "::1", 0, 0);
> +	ASSERT_GE(listen_fd, 0, "start_server");
> +	client_fd = connect_to_fd(listen_fd, 0);
> +	ASSERT_GE(client_fd, 0, "connect_to_fd");
> +	accepted_fd = accept(listen_fd, NULL, NULL);
> +	ASSERT_GE(accepted_fd, 0, "accept");
This listen/client/accept_fd needs a close.

> +
> +	prio = 0;
> +	socklen = sizeof(prio);
> +	ASSERT_GE(getsockopt(accepted_fd, SOL_SOCKET, SO_PRIORITY, &prio, &socklen), 0,
> +		  "getsockopt");
> +	ASSERT_EQ(prio, 234, "sk_priority");
> +
> +	/* These are replaced and never called. */
> +	ASSERT_EQ(skel->bss->called_socket_post_create, 0, "called_create");
> +	ASSERT_EQ(skel->bss->called_socket_bind, 0, "called_bind");
> +
> +	/* AF_INET6+SOCK_STREAM
> +	 * AF_PACKET+SOCK_RAW
> +	 * listen_fd
> +	 * client_fd
> +	 * accepted_fd
> +	 */
> +	ASSERT_EQ(skel->bss->called_socket_post_create2, 5, "called_create2");
> +
> +	/* start_server
> +	 * bind(ETH_P_ALL)
> +	 */
> +	ASSERT_EQ(skel->bss->called_socket_bind2, 2, "called_bind2");
> +	/* Single accept(). */
> +	ASSERT_EQ(skel->bss->called_socket_clone, 1, "called_clone");
> +
> +	/* AF_UNIX+SOCK_STREAM (failed)
> +	 * AF_INET6+SOCK_STREAM
> +	 * AF_PACKET+SOCK_RAW (failed)
> +	 * AF_PACKET+SOCK_RAW
> +	 * listen_fd
> +	 * client_fd
> +	 * accepted_fd
> +	 */
> +	ASSERT_EQ(skel->bss->called_socket_alloc, 7, "called_alloc");
> +
> +	/* Make sure other cgroup doesn't trigger the programs. */
> +
> +	if (!ASSERT_OK(join_cgroup(""), "join root cgroup"))
In my qemu setup, I am hitting this:
(cgroup_helpers.c:166: errno: Device or resource busy) Joining Cgroup
test_lsm_cgroup_functional:FAIL:join root cgroup unexpected error: 1 (errno 16)

A quick tracing leads to the non zero dst_cgrp->subtree_control
in cgroup_migrate_vet_dst().

This is likely due to the enable_all_controllers() in cgroup_helpers.c
that enabled the 'memory' controller in my setup.  Avoid this function
worked around the issue.  Do you know how to solve this ?

> +		goto detach_cgroup;
> +
> +	fd = socket(AF_INET6, SOCK_STREAM, 0);
> +	if (!ASSERT_GE(fd, 0, "socket(SOCK_STREAM)"))
> +		goto detach_cgroup;
> +
> +	prio = 0;
> +	socklen = sizeof(prio);
> +	ASSERT_GE(getsockopt(fd, SOL_SOCKET, SO_PRIORITY, &prio, &socklen), 0,
> +		  "getsockopt");
> +	ASSERT_EQ(prio, 0, "sk_priority");
> +
> +	close(fd);
> +
> +detach_cgroup:
> +	ASSERT_GE(bpf_prog_detach2(post_create_prog_fd2, cgroup_fd,
> +				   BPF_LSM_CGROUP), 0, "detach_create");
> +	close(bind_link_fd);
> +	/* Don't close bind_link_fd2, exercise cgroup release cleanup. */
> +	ASSERT_GE(bpf_prog_detach2(alloc_prog_fd, cgroup_fd,
> +				   BPF_LSM_CGROUP), 0, "detach_alloc");
> +	ASSERT_GE(bpf_prog_detach2(clone_prog_fd, cgroup_fd,
> +				   BPF_LSM_CGROUP), 0, "detach_clone");
> +
> +close_cgroup:
> +	close(cgroup_fd);
> +close_skel:
> +	lsm_cgroup__destroy(skel);
> +}
> +
> +void test_lsm_cgroup(void)
> +{
> +	if (test__start_subtest("functional"))
> +		test_lsm_cgroup_functional();
> +}
