Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD57366605
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 09:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237058AbhDUHDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 03:03:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22432 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236673AbhDUHDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 03:03:04 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13L70WLA011698;
        Wed, 21 Apr 2021 00:01:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=NYZZkCu/ut8gU1Ok6AxSME7tmEA55AOgso5boa5CnR0=;
 b=LLB5pR8asQZ/psO8GXHMgclBje/4lKKqJBIN+65vGdaKz7eiSsI477y3hlOc9shj8E+Y
 BTr+3xcC3JwqUFmgigcswCxMrrfYMoD41cyjSmUIPXNCP+vEAH8DRA8k8tKqknA6qwr0
 lOuvdp7sQJc/xve4OsKitGLC+mHzpYJM9bQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 381mxefg5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 21 Apr 2021 00:01:46 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 21 Apr 2021 00:01:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayxS+RcaOkx7bgbYXtoEQKpG19YITi3M9cNdcOgcwUjsW++k9MHn+AYhdcZPcdkPs/wfAgi46G+VzUNGo/hpk2HwxnrfMkDAzVKlP/TnhEMcorWGFmjQVVHdqC4B33ywyFeHQN3BMTrXUC4yFy+Be0wmoVgiAGLghCN23m+lHvYEKu4sryCmKU/Y1gxAkRJj11V9qL/aDF6x/Li+hKZrxQ8IQQj8wgQwIje+lsYNYVsgelcHkSB4+2x+6BtC14rEm7TrBW1+F8q2YrY4p8/H0Ht+kNVh+i9IUdLQW8c3O1Th1WYJE6lXNDhW00z9uFSKYEyLtsCp8tG71+CFo+Yx5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYZZkCu/ut8gU1Ok6AxSME7tmEA55AOgso5boa5CnR0=;
 b=CaTzZyKy8wDEQ8BEnsFT30hnYWthNFr8sNdvobSiRPmVhrBdS5MNXPRwWU4oLshjNeFhfA68MhKkNB60Jwydptqk6x9ruKHLcWE9DAFz0FC2JL8lmg9djUFNIp4nthIDl0UZY01akMujvc9rXdyB25vyrdJDj2CXxbDW3u1uMpRfM+a7gepa2LlvBr6jOcTmnjAWpS9bLgqXDclIty1I9GYZ9nzB2PzPpqDiI352Ytba1a69bbdfUOSQbxakN/RBUyNOdR/Prr/zZjZQoQPVn+ZZMWt0U6jehT7wiCgcWRbJpRu+/wgNRHzNtO2lZX5Uaias1z8AcFjyGn3+5BEZ9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4919.namprd15.prod.outlook.com (2603:10b6:806:1d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 21 Apr
 2021 07:01:43 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 07:01:43 +0000
Subject: Re: [PATCH bpf-next v3 3/3] libbpf: add selftests for TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, <bpf@vger.kernel.org>
CC:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        <netdev@vger.kernel.org>
References: <20210420193740.124285-1-memxor@gmail.com>
 <20210420193740.124285-4-memxor@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2656c9ec-3d33-4646-8653-5b8069ec38bb@fb.com>
Date:   Wed, 21 Apr 2021 00:01:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210420193740.124285-4-memxor@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:d87c]
X-ClientProxiedBy: MWHPR1701CA0013.namprd17.prod.outlook.com
 (2603:10b6:301:14::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::137a] (2620:10d:c090:400::5:d87c) by MWHPR1701CA0013.namprd17.prod.outlook.com (2603:10b6:301:14::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Wed, 21 Apr 2021 07:01:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 002d4ee0-e60c-46de-5662-08d90493524c
X-MS-TrafficTypeDiagnostic: SA1PR15MB4919:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB491989C5990C7C4B2E060654D3479@SA1PR15MB4919.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +T4xJOIuXe1OiE+Gl0SVIspaMv28dP3W5iFhk5FR20KXaqfV4yYB3AKSzwASWJo+wDrBDBeM622nICdMNDD9bo5ebWx0t6OQukih+GViidsKR0Nlp06x+lX/ghncPtfofaET0gxgfgtwHhk6Zb/7TekBw5/5I3WvvaF6+s4zWsHUZTcBJkqltY7OoojtN46HG8Q1lzAKVCAe/rY0FcRO8z6HFq4Z4ZehyIB97kuQeJrqT1H7CwIZkMpjlibuaLVJ0A5IIAGxd4yoo3QgUSWG7yDxiQB4A1EFPW4TYqdFeaogu2JzTRim07Zf4kzAhjwZkMpiFqvC0gVGcfwJypY4Sw9vWhOoAKwpvRykt3f3ewDJPrDoIJGTzpVUhKE7ZgRxoq8HxbMBJHlCCTwk8yaPbn7MvgOwUc0ZcBl9D92sA+Q28XzGNlqzeFGLiANTSaWDE9oRUrN+oxbUJyNs9ZKRsZxtopYdFkpNLq62nZF5+bYfxo5Vkyl2cEJ/jnYrt5Peeecrn7Z1rquaYhf5VfH2w6qiaeBnBATY/LHJ1GHMowv9WMN64Daz5k/Qedu+voN4R/zR9uVWGGUaaviaKjV4PeOPvY0ymD53NZDY3XfQ3rQECSjtKOQuSHsYeKhq1oTUcn/WB9+1TmeD+hgc0yuItisV2S2zmXBm3xLFeYuajXAOhxQ7nQ/SVKlB2BXr9xIr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(53546011)(498600001)(2906002)(6486002)(8936002)(31686004)(4326008)(36756003)(6666004)(7416002)(83380400001)(186003)(66574015)(86362001)(52116002)(16526019)(8676002)(2616005)(66556008)(54906003)(66476007)(31696002)(66946007)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VU5qZjkxb3k4TGxFY0VDSzBtYkgrc3VYejd5UFBrS3BXdERDQjJqZUlHcGVu?=
 =?utf-8?B?UTFJQVNpMTRtbHpOdC83NUNaclp5SnBVK0ErbUFMUU5uNVE2ZjdoNlBvckRw?=
 =?utf-8?B?Rk9QNmxiNWFnUE11TVY2QVNENlpUMnVqNzlVYXRtcFZGc1dYL3BnOWZYQTR5?=
 =?utf-8?B?blk2ZEFMd2R5U1d1WVdqZUNQQW5Dd2VpU3BZWHNwNUE5RG13bHFRd09tZnp3?=
 =?utf-8?B?M01OU0RMbmV3bU9pbThGaUY2MnlQY2lBYXBLcVBiVDNBYXZSekk3RWdOZm16?=
 =?utf-8?B?c05KMml5NDlweVVnemdQdjRrMGhzem43aDlOQi9MZ3BzbTFrL2pjOTNJa29T?=
 =?utf-8?B?ZzJIMUFzenBtQStGbWtBNkZDUmh6TXFWZjBMNWR1SVVOdFo5aEtYYXI0b0xV?=
 =?utf-8?B?YWViUldSc1J2b3AwSU9mQ2t0VEJBZnpOU2V3WUlWVGxkcHIzaEhndlhyY2JU?=
 =?utf-8?B?NkdNbUNTM1hQMGFJbWsyUFEvdXlHYndWQ0xiRmI4UlhJanQrZHNLODBIUFRW?=
 =?utf-8?B?Ui9pby9pMkEvU05SZjVkb1E3dTlVRnV6anVCRzF3ejhOcGEzelhrT2FKVkxh?=
 =?utf-8?B?TS9ETnVWd3RNNWpXbnpReEVLNWVNV3F4WmdjQ2RDLy9vWDBaTiswdkZKY3ZQ?=
 =?utf-8?B?c1FuRnZtUzJTbHRGaERDY1F5b3RCSkdnVEEyR0FtR05ZM3k2eGplNU5ZZWd4?=
 =?utf-8?B?UGU3aW53TEQ5UmJ6OUg5TTRtVll5bUVVK1E2NGpnZ052RjB0cDF6ejJBYmp1?=
 =?utf-8?B?WVpOUmN4R3c4bFpJcG9xNDIxd1NDZVJTdFhtRTNVbUY1MmtJZTlhZU4yM3g3?=
 =?utf-8?B?NzNxbVNzSDMxaHllQlFwVTQwanNXNDU3VlhJSGU4Q3Nka2twcmNSQUJwbVpo?=
 =?utf-8?B?T1k1cmp3cVRQd2w3c3orNSs2OEI1ejNDUEFpc3orTmU4alVBSWdHbDQ3Wjdj?=
 =?utf-8?B?OTE0OTlHbGNmQlB0VnBSTWZXcG1QZ2RyN1YzR3pDT2ZvSnRZTS9VQ1psMkt0?=
 =?utf-8?B?TjQ1OTN3Z01ESU1QenMzc0lVUWFSZGFmemhuRHh3aExCNlgxbnh4aXBTV3NP?=
 =?utf-8?B?cUtTTWMrcDhmUWl6bDN0KzJRUXVvUXBXZ0YxU2o2M3Q1NWk5Nm03YXBHSktm?=
 =?utf-8?B?b1p6Z2gzYlo2WVBwWUgveGYrOWE2b3ExUGluK3BKWmhETU1aYnV6eXIwTm0x?=
 =?utf-8?B?aHBGVFBTcUV2NUw4Q1pNanhyaktPVk5KUDV2K1VkTjJhMWRJL1puRFFjbTMr?=
 =?utf-8?B?YkJ4YmR6NlppN25yNFNIMDBCUzhOd0tzbEx6VGROdGltQklNNkkrNmEzcDYx?=
 =?utf-8?B?TVYzeUVMbWVGaThERmc5OXRLaEVBZUNvTnJNOWdYRENpWWlldWtaYUw4M3JL?=
 =?utf-8?B?RUdDRXkxaVZSQVB3R0M3anhsdG4rWC9McC9ONmIxd0w2b3h6bWhpMVZlaUVQ?=
 =?utf-8?B?YkRuQUVVUjkxamRYUU14REovY3VyNXFsSGxUaFFYYlE2bnJOTW1vYkJoV0R1?=
 =?utf-8?B?dFp4SnNKazh1d3BoWWMzV2FDT0QvRzByanpMYVE2cGt5dHgxUE1HS3UrN2tP?=
 =?utf-8?B?WHpsWjZuS3Z5Z2ZMY3h1MUFSRG9CdkUyTTBBdDVscmFQT0pzWDk0clc4M3Iw?=
 =?utf-8?B?Q2M0cVI1cGhUWkxLRGQvWUNadW1oY0pNWWZva1gzY002NCtXdG40RHBKL2Yz?=
 =?utf-8?B?MTdxRDM4bGdQc0dSQ01YMXR4eVZoS1V4eEZOSUZyTy9JRVE4aVRjaVk2ekxZ?=
 =?utf-8?B?S3ZTNFpIU0JUeC9yRHBHTHBxZVQ0RG1ZYWc3TkowaGhTVXE1eUluK0MyS0Mr?=
 =?utf-8?Q?iBaL5/HmHWcqicleWpLwqewTALDJKTsey8fX8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 002d4ee0-e60c-46de-5662-08d90493524c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 07:01:43.8233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hsavxC+KGuyX5mHCJCL1xAwbY7x9+WKUGKpS2DqGBGZPYqtTDhglzb2jIx6yQDlv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4919
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: iK4a3iXGqTq9u9ux0vKHPLeoS0qfk-2r
X-Proofpoint-ORIG-GUID: iK4a3iXGqTq9u9ux0vKHPLeoS0qfk-2r
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_02:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104210055
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/21 12:37 PM, Kumar Kartikeya Dwivedi wrote:
> This adds some basic tests for the low level bpf_tc_* API.
> 
> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>   .../selftests/bpf/prog_tests/test_tc_bpf.c    | 169 ++++++++++++++++++
>   .../selftests/bpf/progs/test_tc_bpf_kern.c    |  12 ++
>   2 files changed, 181 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c b/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
> new file mode 100644
> index 000000000000..563a3944553c
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
> @@ -0,0 +1,169 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/bpf.h>
> +#include <linux/err.h>
> +#include <linux/limits.h>
> +#include <bpf/libbpf.h>
> +#include <errno.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <test_progs.h>
> +#include <linux/if_ether.h>
> +
> +#define LO_IFINDEX 1
> +
[...]
> +
> +void test_test_tc_bpf(void)
> +{
> +	const char *file = "./test_tc_bpf_kern.o";
> +	struct bpf_program *clsp;
> +	struct bpf_object *obj;
> +	int cls_fd, ret;
> +
> +	obj = bpf_object__open(file);
> +	if (!ASSERT_OK_PTR(obj, "bpf_object__open"))
> +		return;
> +
> +	clsp = bpf_object__find_program_by_title(obj, "classifier");
> +	if (!ASSERT_OK_PTR(clsp, "bpf_object__find_program_by_title"))
> +		goto end;

Please use bpf_object__find_program_by_name() API.

> +
> +	ret = bpf_object__load(obj);
> +	if (!ASSERT_EQ(ret, 0, "bpf_object__load"))
> +		goto end;
> +
> +	cls_fd = bpf_program__fd(clsp);
> +
> +	system("tc qdisc del dev lo clsact");
> +
> +	ret = test_tc_internal(cls_fd, BPF_TC_CLSACT_INGRESS);
> +	if (!ASSERT_EQ(ret, 0, "test_tc_internal INGRESS"))
> +		goto end;
> +
> +	if (!ASSERT_EQ(system("tc qdisc del dev lo clsact"), 0,
> +		       "clsact qdisc delete failed"))
> +		goto end;
> +
> +	ret = test_tc_info(cls_fd);
> +	if (!ASSERT_EQ(ret, 0, "test_tc_info"))
> +		goto end;
> +
> +	if (!ASSERT_EQ(system("tc qdisc del dev lo clsact"), 0,
> +		       "clsact qdisc delete failed"))
> +		goto end;
> +
> +	ret = test_tc_internal(cls_fd, BPF_TC_CLSACT_EGRESS);
> +	if (!ASSERT_EQ(ret, 0, "test_tc_internal EGRESS"))
> +		goto end;
> +
> +	ASSERT_EQ(system("tc qdisc del dev lo clsact"), 0,
> +		  "clsact qdisc delete failed");
> +
> +end:
> +	bpf_object__close(obj);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c b/tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c
> new file mode 100644
> index 000000000000..18a3a7ed924a
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c
> @@ -0,0 +1,12 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +/* Dummy prog to test TC-BPF API */
> +
> +SEC("classifier")
> +int cls(struct __sk_buff *skb)
> +{
> +	return 0;
> +}
> 
