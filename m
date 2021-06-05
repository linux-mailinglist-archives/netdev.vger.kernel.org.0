Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357FF39CA33
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 19:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhFER2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 13:28:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28392 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229964AbhFER2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 13:28:53 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 155HL1Ai010928;
        Sat, 5 Jun 2021 10:26:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=sRGez9ra1htpsIm+tYDGu7bzkgWLnglvZUZw54gPVJg=;
 b=jICgBLJWJc6GrVBsqIx93XUe8ybDBW1Z9upgIp6Xm5t2heIse1JT7hmUzCj3pGoSbg8E
 bkjJxRb3LayXfmQDwUEZo84cqNiz+O0ApQjX+lDNZ7/uXlv+5gNu/w2X0NsAAfsBq8EE
 IUxnlmuNa/0vj/zsw8f/N9gZhwZc0ulvwvY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3904sb9v66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 05 Jun 2021 10:26:49 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 10:26:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOKOEw7KyDX+Oliwc+XbRJCA/W+QmU5Gq+Q/9maQ+TfKfRzMXfYR3yOFfvJlQJ8r2YwIWgBfE6A5BT2VrijNto6+vEJWs1ynG41zqDUx1mHsDFW4ptIAuIW+NUi3FsdSdpSoQFoueKTLl6bIatHeFemRghYT6VTJhWHPaqfEcf1r1W75RwoUN5abtmri6jPyZ0deY7CUgi5jO5C3vIoa8hv6oYqoFqsWCTqjwcERdd32+FsNjaX3HST8rCWooDfjPLlpbGf4w3rw64TsqLtW5MG7mTiDnaTYOSYxAtx0e/STR+AH0qdLEDRChA4vwI6XJC6wLdgaFkhcQgYx6HOb8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRGez9ra1htpsIm+tYDGu7bzkgWLnglvZUZw54gPVJg=;
 b=SKixFTQ9qe6HQB5nkNSiBpG4rgzs2eNCogn1deIF04SyTj93MIWDacT26UJY3XC9fwrSjFUHrSWdjSm9S43e60hUv9Z1WxspxmEt0MIuVicaBAm5enpkR4hI7j3Jps6lv7QGBYC82OdknkmsyoD+YIQHrqnzzbvw8Cuejm0JSxRodcEURuWNb9faikcVuGHKpGT3Gcz4w4zzjW8H/2BzJR0kuOlWfNS2Q1y+CSfe/nTFSgmdVFcK18EJ2Oe6NHtl3Bu5eQCYqAUDrxfQTcWnfkMKddfGWP+GaJi5Hlnkp7UjpBLA9OfLiq6c3Uo1S0ZSqzdAbBC6AKBJst1cjEkd5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4434.namprd15.prod.outlook.com (2603:10b6:806:195::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Sat, 5 Jun
 2021 17:26:45 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4195.026; Sat, 5 Jun 2021
 17:26:45 +0000
Subject: Re: [PATCH bpf-next v2 7/7] libbpf: add selftest for bpf_link based
 TC-BPF management API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, <bpf@vger.kernel.org>
CC:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        <netdev@vger.kernel.org>
References: <20210604063116.234316-1-memxor@gmail.com>
 <20210604063116.234316-8-memxor@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a2e9d489-7fe1-f185-3443-565601624269@fb.com>
Date:   Sat, 5 Jun 2021 10:26:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210604063116.234316-8-memxor@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:80b3]
X-ClientProxiedBy: BY5PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::32) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1a79] (2620:10d:c090:400::5:80b3) by BY5PR03CA0022.namprd03.prod.outlook.com (2603:10b6:a03:1e0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Sat, 5 Jun 2021 17:26:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea3042c1-961a-4237-207c-08d928471768
X-MS-TrafficTypeDiagnostic: SA1PR15MB4434:
X-Microsoft-Antispam-PRVS: <SA1PR15MB443410DC924826267F1B2D45D33A9@SA1PR15MB4434.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:67;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N5nllknXEKPZESq0p2rJq7Cib12EyucEYbIjRhUTcWbyOzrXJj2W03gCMVroU0iBuAmZtntGkykPwkutOanw/5u4nwzxEKzQXtvpQZPrtWFQ6EFRTNjmGXU74NPKj/fd+BYYSaYel0Cnj5nu73OLUCYtYHdXSLo5avdCqHFAkwhWurTqBU2oHeYDJ4H+Y+ZglPe5wgIKYslGpmATZtBVw9kAPdXs9PL64/KgDDNlycn/Y2kVwKHo0ucmc1XeGYBzTNqK6PItr/mn36QbXR1pwR2h5yCS1gzu4aAopl1CrwK0hEmEppAgLMKH6ll2b1tHg99tYG75ILCy8/mXHhXa7n8K/miKNQobrU6Gi/n4NvqsdUz6jTUWE7fcMX8cpcL2D13rQajnCqJ8lg97QGWKQeks8DFCs49mx7XJ4fo0xZ1JWVYHyfVNwp/w02pLq/JFHffZJ6ZPOTGmVUyIBrbZ0XqBzG3o263UL5/Yij5Wrw3gzfgCl+6dw3ocmBmWtk5eFgz3owKec3bBoPJHIOYVzbPIUoqDrp4affjpmElMeNhYlO/D0/GoPzOAYePzDUjTP7f7Ja5xulBAdx2gICNUkKRd3PhTnIi6UOkyG3IeDRlgwy7WyO1Urn6Wt7F5bcQN3KqwroX9l0qSWO7WY9tWTIjpuQTjPPHbZaatdQhORsF3SpXpV3YNOMTlBjSEc3Nn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(31696002)(36756003)(6486002)(66946007)(4326008)(66556008)(66476007)(16526019)(38100700002)(5660300002)(52116002)(8936002)(8676002)(2616005)(66574015)(83380400001)(53546011)(7416002)(316002)(54906003)(478600001)(186003)(86362001)(31686004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L2xSZUJNS3pPYnRYbnZySHQrRURDNG5peXlaVnRTZDU5eVgzTE1ja0hlMklX?=
 =?utf-8?B?NEhLeWRoU0tuQXQra01VRFc5QXlSQ2hvNHRpdWtUYm9UckFQYVNlbW1KQ1Bz?=
 =?utf-8?B?bC9YOVk2ZVVEWnYrdmpKaVpvbDIyemZwS3ZIQkZRMjkxTjRyV0s3c2hvOERl?=
 =?utf-8?B?alMyZXMzTFlKODNlYTlmZTNOVnl0QTUvR1k3Tmkvc0NzQng2RlR5OHEvTCs1?=
 =?utf-8?B?ZW00dlNSRjlleEhscXRGa1lVbVRLT0ZUWEg4VnQ2ZTVJbVJIOHJYMmFvTXdB?=
 =?utf-8?B?MERyTFhHeHp6bmxVbXpHc0E0Qnlsdm52Q09FT1gwVDlUekdRQmZkKzlUY2p4?=
 =?utf-8?B?d0FGTW1HRzFaeGVhNk8wbWVxL0xUZXBmRmQ0WDVwbXVDOFVaRXU5c2ZaMXVP?=
 =?utf-8?B?dkNyRkwvOXl2UzJwaGRpSTJjTllQakR5am15dGlsVW9pK0FsaHFKYnhzQXNB?=
 =?utf-8?B?b1UwOGt2TUNzT1V2djdmT0Vma1lLcFovV1dlV2tPcSt0SWpURC9USmlMTmJq?=
 =?utf-8?B?OTFkVi80dDJORGJmaUdYNWhDMW01YnQwRDFpMFVkM21PeGMrWlJQcmhEaFhF?=
 =?utf-8?B?TGE0a25ra1pIVjlibEwzNUFsQjEyd1FxcUhhQkdNNlg5RFlJdUUyQU0xMm1Z?=
 =?utf-8?B?N2l1QnE1YW95VllZNFFmbC9nci8ydW1HUEd6emR6QWY0S0NScU5ySm9HSDlF?=
 =?utf-8?B?dy8vSU9UeUtUTFM4R1pEYTExVGhNZW02VzVleW9UelBTM1RKUlEwNEZNSVl3?=
 =?utf-8?B?L0tSa0ZjYXNWbmorQ2JSVWJTL1BFNnliQzR0WnJSbGw3OXJRaVVSYVhBR2c0?=
 =?utf-8?B?YzNPbUpHQWxPaUtlTnk0N1hFTXYyMVVhcXRzQUhqTDA5eUQ4SkVTZ2tyaVVV?=
 =?utf-8?B?NHE4dkc5ZWI0b3U2WERCU285YTdJTU1TTjJPRzY0a05kOWs1bHRRdXloeXlk?=
 =?utf-8?B?RVR1SStXdERhSi8rS0toKzdPYnZKSDE0aDB2S0MvZnplNW1yaFcvM0tyRGlp?=
 =?utf-8?B?VkF6NXRBUlZYb3hzSlNVbVhNdDNMVU1OWkhsMEd6MFdzRTNkRi9SNDBreStM?=
 =?utf-8?B?NEhsR0grTnZ6ckVlTGh5VFNKTC9yd0NBNDJIVXFFUHJRbytMbWpHc1VoWkhM?=
 =?utf-8?B?eDJ6MTJVc1p1TGJhVDBMOWN3M2ljSUM3bmE5TmFyOGZwc1hFT3BtZUU3bU9J?=
 =?utf-8?B?ZFl0SGZGc1pHN3d2M2lSMGdNRmtDWEcyQ0YrS05pdTV0MmxkV1hDOG1aOXh3?=
 =?utf-8?B?cW5MMlZEVVllMGlsa3BXUXRzdDZ1djdjamlJSmNpUjlBZWZTalJ4akJXeXZx?=
 =?utf-8?B?VWNDY0xwZnhBMG1zaUFxbGxwTEdYbHZiQlFlZGV1Y3E2NkhMRkFqb2NmOHcz?=
 =?utf-8?B?R2w4czhtMnU1ZHEzRkt0enBsV25YNlExMjNyMkJKbW51VlNZSHRmU01GYSs0?=
 =?utf-8?B?cGxVVityQnpJdkxkL3VWY2dwMWR5OStwenVxWU1RSkRRWFQ4WUdDTXhFQWFJ?=
 =?utf-8?B?ZzBXb2Zoa3plYXJyQ0tSd2ZFYzRLRlZKazgzcXlPNmJEKzJJeHBlNWt5Tm5j?=
 =?utf-8?B?NzdFVXpIeVRYaXhaeitMaXFGb3VwUUhHam5FLzB1MlVPeGdqUHYvcTRNRmNT?=
 =?utf-8?B?NXJVYnFYc1V5UE1yUjdFdm90T0ZKejlIZmwzNEFTOWc4OTFsTGZ6NW0vcGVp?=
 =?utf-8?B?ZkZ3OXBoTmF4S3RPdWYyMEtJVElZYXpDTmxRRjZTWTFRTjU5dmgrUGN2Uys2?=
 =?utf-8?B?RGRuSC9Jbm1ILzYwWXRDbjd3S01kNHM1R09temp6YzdNNFo5cjVCbUVCYkNB?=
 =?utf-8?Q?EQrWMPZXTovKQK8jFnAYMqXMTvYv3JxhYF/mk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ea3042c1-961a-4237-207c-08d928471768
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2021 17:26:45.1454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iHPurlm2qax0w+/hjozs+W5IpxB/F3LoqTSXd0ZRx5syKEIMrA0AtzsOjS3w14sk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4434
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: eWvQ2QooZVFjEz1fxi7cqrg33wl4febz
X-Proofpoint-GUID: eWvQ2QooZVFjEz1fxi7cqrg33wl4febz
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-05_11:2021-06-04,2021-06-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 mlxscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106050126
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/3/21 11:31 PM, Kumar Kartikeya Dwivedi wrote:
> This covers basic attach/detach/update, and tests interaction with the
> netlink API. It also exercises the bpf_link_info and fdinfo codepaths.
> 
> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>.
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>   .../selftests/bpf/prog_tests/tc_bpf_link.c    | 285 ++++++++++++++++++
>   1 file changed, 285 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf_link.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/tc_bpf_link.c b/tools/testing/selftests/bpf/prog_tests/tc_bpf_link.c
> new file mode 100644
> index 000000000000..beaf06e0557c
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/tc_bpf_link.c
> @@ -0,0 +1,285 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <test_progs.h>
> +#include <linux/pkt_cls.h>
> +
> +#include "test_tc_bpf.skel.h"
> +
> +#define LO_IFINDEX 1
> +
> +static int test_tc_bpf_link_basic(struct bpf_tc_hook *hook,
> +				  struct bpf_program *prog)
> +{
> +	DECLARE_LIBBPF_OPTS(bpf_tc_link_opts, opts, .handle = 1, .priority = 1);
> +	DECLARE_LIBBPF_OPTS(bpf_tc_opts, qopts, .handle = 1, .priority = 1);
> +	struct bpf_prog_info info = {};
> +	__u32 info_len = sizeof(info);
> +	struct bpf_link *link, *invl;
> +	int ret;
> +
> +	link = bpf_program__attach_tc(prog, hook, &opts);
> +	if (!ASSERT_OK_PTR(link, "bpf_program__attach_tc"))
> +		return PTR_ERR(link);

If we changed the bpf_program__attach_tc return semantics such that
the return "link" value can only be NULL or a valid pointer, you can do
	if (!ASSERT_OK_PTR(link, "bpf_program__attach_tc"))
		return -EINVAL;

The true error code should have been printed inside ASSERT_OK_PTR.

The same for a few other cases below.

> +
> +	ret = bpf_obj_get_info_by_fd(bpf_program__fd(prog), &info, &info_len);
> +	if (!ASSERT_OK(ret, "bpf_obj_get_info_by_fd"))
> +		goto end;
> +
> +	ret = bpf_tc_query(hook, &qopts);
> +	if (!ASSERT_OK(ret, "bpf_tc_query"))
> +		goto end;
> +
> +	if (!ASSERT_EQ(qopts.prog_id, info.id, "prog_id match"))
> +		goto end;
> +
> +	opts.gen_flags = ~0u;
> +	invl = bpf_program__attach_tc(prog, hook, &opts);
> +	if (!ASSERT_ERR_PTR(invl, "bpf_program__attach_tc with invalid flags")) {
> +		bpf_link__destroy(invl);
> +		ret = -EINVAL;
> +	}
> +
> +end:
> +	bpf_link__destroy(link);
> +	return ret;
> +}
> +
[...]
> +
> +static int test_tc_bpf_link_info_api(struct bpf_tc_hook *hook,
> +				     struct bpf_program *prog)
> +{
> +	DECLARE_LIBBPF_OPTS(bpf_tc_link_opts, opts, .handle = 1, .priority = 1);
> +	__u32 ifindex, parent, handle, gen_flags, priority;
> +	char buf[4096], path[256], *begin;
> +	struct bpf_link_info info = {};
> +	__u32 info_len = sizeof(info);
> +	struct bpf_link *link;
> +	int ret, fdinfo;
> +
> +	link = bpf_program__attach_tc(prog, hook, &opts);
> +	if (!ASSERT_OK_PTR(link, "bpf_program__attach_tc"))
> +		return PTR_ERR(link);
> +
> +	ret = bpf_obj_get_info_by_fd(bpf_link__fd(link), &info, &info_len);
> +	if (!ASSERT_OK(ret, "bpf_obj_get_info_by_fd"))
> +		goto end;
> +
> +	ret = snprintf(path, sizeof(path), "/proc/self/fdinfo/%d",
> +		       bpf_link__fd(link));
> +	if (!ASSERT_TRUE(!ret || ret < sizeof(path), "snprintf pathname"))
> +		goto end;
> +
> +	fdinfo = open(path, O_RDONLY);
> +	if (!ASSERT_GT(fdinfo, -1, "open fdinfo"))
> +		goto end;
> +
> +	ret = read(fdinfo, buf, sizeof(buf));
> +	if (!ASSERT_GT(ret, 0, "read fdinfo")) {
> +		ret = -EINVAL;
> +		goto end_file;
> +	}
> +
> +	begin = strstr(buf, "ifindex");
> +	if (!ASSERT_OK_PTR(begin, "find beginning of fdinfo info")) {
> +		ret = -EINVAL;
> +		goto end_file;
> +	}
> +
> +	ret = sscanf(begin, "ifindex:\t%u\n"
> +			    "parent:\t%u\n"
> +			    "handle:\t%u\n"
> +			    "priority:\t%u\n"
> +			    "gen_flags:\t%u\n",
> +			    &ifindex, &parent, &handle, &priority, &gen_flags);
> +	if (!ASSERT_EQ(ret, 5, "sscanf fdinfo")) {
> +		ret = -EINVAL;
> +		goto end_file;
> +	}
> +
> +	ret = -EINVAL;
> +
> +#define X(a, b, c) (!ASSERT_EQ(a, b, #a " == " #b) || !ASSERT_EQ(b, c, #b " == " #c))
> +	if (X(info.tc.ifindex, ifindex, 1) ||
> +	    X(info.tc.parent, parent,
> +	      TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)) ||
> +	    X(info.tc.handle, handle, 1) ||
> +	    X(info.tc.gen_flags, gen_flags, TCA_CLS_FLAGS_NOT_IN_HW) ||
> +	    X(info.tc.priority, priority, 1))
> +#undef X
> +		goto end_file;

Maybe put "#undef X" after "goto end_file" is a little bit better?

> +
> +	ret = 0;
> +
> +end_file:
> +	close(fdinfo);
> +end:
> +	bpf_link__destroy(link);
> +	return ret;
> +}
> +
[...]
