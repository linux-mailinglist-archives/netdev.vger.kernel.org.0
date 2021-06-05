Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CE639CA20
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 19:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFERMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 13:12:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53560 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229958AbhFERMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 13:12:14 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 155H43Fd011163;
        Sat, 5 Jun 2021 10:10:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Btw4KC6HztCo/l7eRdfE/kr3OFCT+fBbWxVDwdZ1OJE=;
 b=FXs+sXsldR8sxCTTWRquCDPxR/IE4x8DP+7c6foKRStPs0ZnV4FX7xHnctB8+nKsm/Y/
 iNdgYjH/u7ZV7Xlb5KAlkvNW6O0VDpSPPtIDHpXdJtPl/mLDLS9A3lQwXyhYm+gw11yn
 JzgIFOKBbbB5SXdvjo2WyAdtY/5GRAcymTE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39073uhapj-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 05 Jun 2021 10:10:04 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 10:10:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=APSd3PKtexRhFMTmTnJAOemJDehHAs9b9eKXFn2s3Z1GL1hE/mvi8WsRAI5sCN+JiexBSN0E9Rmhs14l60Ncc0onOk+fym8E6XzTImGahJP81TnHe+O9VTZBKeCQ2WkS3WwInBrfThlQbRIiecHpUzPNtRS0QgzOkvtKCDLgwflgAgYjLvFTblKd4TBK9JkDZjXffix6w7ndTjor94DuOQ/O2H0q8wpTQCrzYcUojXZYxoFfI/Wjx5San8iexNiDOoM4ziWOx6nDUO1gSP+cjASv53Ey8DgJiwdFHr3J1oWyDvMUnxv/PmiKvbSZIJknFarsAco1dIHT2QbO24c4pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Btw4KC6HztCo/l7eRdfE/kr3OFCT+fBbWxVDwdZ1OJE=;
 b=F8qMgTW5ybiE8YFnUYw0nPwocj5isWejovSfq7NnKIGUya0O0oU+eqeqwImHxCJ/Xh4/j8HKrbG1/hHjEJ/J8qIE43h4uX/T3NNX4hCHqUnddQDmQV8luuj4ti90VwCuR0yLbRoGJD9H5+dke3pL7oVPIhXsqD9H87YRqqhQRHftgwqq78EYRNh6aKofbPbNIy9NPbf54gwh6M34lp6l0zeCxdmGX2z5UFW1YJ2ieNqFZG6BMvEA5mI/gnvvEXxEf4dN+uhtOZgPE40E4Gen9VzF3egoYMWO6S8RLGE/y8yTPgC9jQvVxM2bdpucJp2+fKmvwK7bt7iS5vc5Z/IHGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR1501MB2030.namprd15.prod.outlook.com (2603:10b6:805:3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.26; Sat, 5 Jun
 2021 17:10:02 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4195.026; Sat, 5 Jun 2021
 17:10:02 +0000
Subject: Re: [PATCH bpf-next v2 6/7] libbpf: add bpf_link based TC-BPF
 management API
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
 <20210604063116.234316-7-memxor@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c4273132-6ce3-f7b4-6312-4dce18a5ebc8@fb.com>
Date:   Sat, 5 Jun 2021 10:09:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210604063116.234316-7-memxor@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:80b3]
X-ClientProxiedBy: BYAPR02CA0034.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::47) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1a79] (2620:10d:c090:400::5:80b3) by BYAPR02CA0034.namprd02.prod.outlook.com (2603:10b6:a02:ee::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Sat, 5 Jun 2021 17:10:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 220702bf-4cf3-44d2-bcc7-08d92844c173
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2030:
X-Microsoft-Antispam-PRVS: <SN6PR1501MB20302444A299965C1A558F31D33A9@SN6PR1501MB2030.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:279;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3iQ9dxyZcVz/9rksfANso8nZP3mXGb6luk1se0B9UGxADuH+Z+crITQweDDQ2y6flg+IDUxIqdhdOv6B3P8N6O0aD97w0hiR2bQTQ3FkphhTXauoFAfqgQO6sdpMDHyFlahxlHJPWkAsl0ylGsY1f48eFB2i4sFqrulUEjkkaUK4LZ77x+fxaB227u2oZV42ICZADeeJBwaHXRJ/H+0RmRUSrTgm6ckXNGNCJPNxZGPw6giGTlWEfqSxGKRD400U4UYrFoGaocvkKve8BLdmhD9tFK0LW+iwstZj+K071VClUzQsl/zjsDOiwXRLcOlcapLpMkKOB0dMwaCUKntZgbQnrfnXylKeAvblnkWCudR3+cjvj0Qb9CVWsbgYFl5ubw2vEDLFGSDtj8O3t0WTnT354HKpuLKPWpxb7ST59SiNecxtbvhoVVIdv6NavTesV1q++mKqUFdp1ZUFeZTBxGYp7TU+4OpWxE2raCeveF3fGuByBt1j5pqdCFk506c3RMha/145h/suXqnVCYuYrH8zKTpZMfWynI/hJtE7Y8T0tJht65CB+9Mgu+7bISPqhljDDnC996T/Lp9MrW7IYRiZ2J8EnXeFdm5nQXoj+J+tqofh+0X/a2+lf3DNCNtFdeAzdLxECE7+blNIgE/uYLG0wy7Ji0Qrq/RamDQSf7dHQbMJ8HI2foGcSbIRkW2IAFLNOWaM87oRMxwVGrWNEWxe6S0iI+QzZEAEtmqWHqP7M57U7utUwk8d+79BkAM76PDQTSwldLoaLf5jSu0YkOf2+vszG9ul82zitrEFqhKLN8ahYKSOEhStNJNTDZQM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(366004)(376002)(136003)(4326008)(2906002)(83380400001)(86362001)(7416002)(31696002)(2616005)(66574015)(8676002)(6486002)(66946007)(66556008)(53546011)(31686004)(478600001)(52116002)(38100700002)(16526019)(966005)(66476007)(186003)(36756003)(54906003)(316002)(8936002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?M1ZLdlhkUGd1UnE2ci9XUVMxWjVSanNDV01YSFZIVnVHajRqTlloRGdTQW8r?=
 =?utf-8?B?ZnRPUDg1QlRjYXRlbkh2ejRNdFFXMDQydE0relgwd080VG9UckVYMG9zSXIz?=
 =?utf-8?B?NzJQRWtLSjFPTGRWY01LT1ZwQWUveDJ0MU8xaWNkS0hBVlZIUVdFK0crRGhK?=
 =?utf-8?B?R3hyUWVzUDUwcE1wMjhkMUI2WjhGYVBKU1dlemt3UkpyeGdXTFcvdTFXellV?=
 =?utf-8?B?bWlsaHVNQmJ3K1o4QW84eUNpVmFnZDBpVm9lMjF0WlZySTJlY0p6NEhtS201?=
 =?utf-8?B?aGE5SGtHREx0WGVCOVNiUXkxd290YnZ1cTQxMEhnbXozNnRpWGJ5UkVuUW5r?=
 =?utf-8?B?RnRQV1E2VlB2dExpMGozdU5JalNkaTZGMjAvc05wZG9nTlhmb3BUYlYzU1JH?=
 =?utf-8?B?MmdkNCszNzE3QnBJRm1Lckw1K1FqVDZVMXpMNkdUTFNTY0dEN2dpOVVCUURQ?=
 =?utf-8?B?N3BncldYME55bXhRL0Fwb0duUkRYNjVBYUd1eTVvOHdNUEd3c3hLMklBeUc5?=
 =?utf-8?B?ZGxJRjZ0cVd4TThzRU5EdjloczBJQ0dhMTFDZGJVQTd0bEhoVTkvTXQ5OC9N?=
 =?utf-8?B?VkE5R3JQL0YraHhQUll3eU16S0M4ZDJOcnRXT2dFd3hnbWwyRXQ0VW51NTlp?=
 =?utf-8?B?aCtFOXVYLzhCN0NMcU0vNHhBV21yb254VzlKb0ZHcU41eGUyMDZEa2pPZkVZ?=
 =?utf-8?B?QWJXdkd3RGVwVTZBMm80c2FzRWYzMFdwODMyaWIwS1pwQitrODVhSWdaTEZp?=
 =?utf-8?B?Q0dGY3VNRTdPMjNyNlJzcWRmTjA5ZFNRalJ4NE9PWGdCeTVpMFBKVUxvQnlW?=
 =?utf-8?B?Q2hjSVVKTm1nbnpnWnp5V0J6aDJBc0JKREhhNklxU3FPMnkwTS9DeWsxRTZu?=
 =?utf-8?B?aTRjR3JPWldiUHJ6dVp2RjdNNUkwU2FTNCtzMllTczVCMlJKVmQveFpGZ2lo?=
 =?utf-8?B?MURIbHZnbVRvc0xMR3V2RkJVWU5MdWZUUWJ6SzFDa3ZZSWhSN1dhY1lVQkRH?=
 =?utf-8?B?TVFGK3VtUGFQSlRveENObHBBYzhYSWhNZTJzWVlhbkNKNXJRTnNxaU93ZWpm?=
 =?utf-8?B?cDZ3QnhuZ1p5T0ZIRkt6YnZmZE1SVHRYa09BSjI2eTVsZDJFdmM3cktTQkxV?=
 =?utf-8?B?UnFBSVFqQjZ1b1VZb3hDVkRES0VuRUZ2eE5ER0p6U3l4bzFWdUhWZlZYR2sx?=
 =?utf-8?B?YVIrUjZTc2IxcXlENk4zcVpVcGpaWUZKRVJ0TG43R3d3ckoxLy8zQUVlYWlL?=
 =?utf-8?B?a2NsZFZYRFJYT1RIUUlKT1praGtYZnZQRDVDeWdqMTNOa29kdFJJMFNPcXE1?=
 =?utf-8?B?OWhjYVNGUWNuMTFhWlN4WkdWRFZ2VlNFcjVxQ3VaWHV2TUxWam9Ia0lDMUlF?=
 =?utf-8?B?MWxnQ096bHNJbE9mK2lMM0JaN0I4RlAvc3REcEV3V011YVJKMXRhWkx0UW9q?=
 =?utf-8?B?TGJPd0FCT25wN2cwSWdlbU1OVlRRRzFJNVhrVHFPeU1JNzZTMmtvQmlCYnU5?=
 =?utf-8?B?MXd2TGtHRTFJU2dFUUJaSUhCTmtjSlNIVmppZHlLZnhvNEZHNTBxZjZaTEYr?=
 =?utf-8?B?bkxJZU9pYnhRRnlLbGpXWGJSNXkwRld0TkU4NDVGYWRNWG9JenhhK1F0RWE0?=
 =?utf-8?B?RC9XRENWVEJ0bWRLMitHVlVSTi9ZVFMvcHpuRHFPY0FsZ0xWRWovQnc1c24w?=
 =?utf-8?B?R3p1QkxINlQxZXR0Z2JHbzM5RVZmelNMMXVuckJsVGhCYUF0aVU0TXlaS0lh?=
 =?utf-8?B?ZVdocG91bEl2Q0lObmRCVFRZaVhEaEZJeWZIT3Noa2xvN1BHckFWcW9RM1J2?=
 =?utf-8?Q?OoH2I2l9B/tCj9pYCfd9FOexE3LWOWfNSDVuQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 220702bf-4cf3-44d2-bcc7-08d92844c173
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2021 17:10:01.9659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i0wL3yjbAxMc75WPfGY6dsFbR3iIFlkmADjtd2SFwvXc3eSiMn7klafdAgFDcfVO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2030
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Na4zCc9c7xzEFf4gLZU27YYyjWUdeARX
X-Proofpoint-GUID: Na4zCc9c7xzEFf4gLZU27YYyjWUdeARX
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-05_10:2021-06-04,2021-06-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0 spamscore=0
 impostorscore=0 malwarescore=0 adultscore=0 mlxscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106050125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/3/21 11:31 PM, Kumar Kartikeya Dwivedi wrote:
> This adds userspace TC-BPF management API based on bpf_link.
> 
> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>.
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>   tools/lib/bpf/bpf.c      |  8 +++++-
>   tools/lib/bpf/bpf.h      |  8 +++++-
>   tools/lib/bpf/libbpf.c   | 59 ++++++++++++++++++++++++++++++++++++++--
>   tools/lib/bpf/libbpf.h   | 17 ++++++++++++
>   tools/lib/bpf/libbpf.map |  1 +
>   tools/lib/bpf/netlink.c  |  5 ++--
>   tools/lib/bpf/netlink.h  |  8 ++++++
>   7 files changed, 100 insertions(+), 6 deletions(-)
>   create mode 100644 tools/lib/bpf/netlink.h
> 
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 86dcac44f32f..bebccea9bfd7 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -28,6 +28,7 @@
>   #include <asm/unistd.h>
>   #include <errno.h>
>   #include <linux/bpf.h>
> +#include <arpa/inet.h>
>   #include "bpf.h"
>   #include "libbpf.h"
>   #include "libbpf_internal.h"
> @@ -693,7 +694,12 @@ int bpf_link_create(int prog_fd, int target_fd,
>   	attr.link_create.attach_type = attach_type;
>   	attr.link_create.flags = OPTS_GET(opts, flags, 0);
>   
> -	if (iter_info_len) {
> +	if (attach_type == BPF_TC) {
> +		attr.link_create.tc.parent = OPTS_GET(opts, tc.parent, 0);
> +		attr.link_create.tc.handle = OPTS_GET(opts, tc.handle, 0);
> +		attr.link_create.tc.priority = OPTS_GET(opts, tc.priority, 0);
> +		attr.link_create.tc.gen_flags = OPTS_GET(opts, tc.gen_flags, 0);
> +	} else if (iter_info_len) {
>   		attr.link_create.iter_info =
>   			ptr_to_u64(OPTS_GET(opts, iter_info, (void *)0));
>   		attr.link_create.iter_info_len = iter_info_len;
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index 4f758f8f50cd..f2178309e9ea 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -177,8 +177,14 @@ struct bpf_link_create_opts {
>   	union bpf_iter_link_info *iter_info;
>   	__u32 iter_info_len;
>   	__u32 target_btf_id;
> +	struct {
> +		__u32 parent;
> +		__u32 handle;
> +		__u32 priority;
> +		__u32 gen_flags;
> +	} tc;
>   };
> -#define bpf_link_create_opts__last_field target_btf_id
> +#define bpf_link_create_opts__last_field tc.gen_flags
>   
>   LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
>   			       enum bpf_attach_type attach_type,
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 1c4e20e75237..7809536980b1 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -55,6 +55,7 @@
>   #include "libbpf_internal.h"
>   #include "hashmap.h"
>   #include "bpf_gen_internal.h"
> +#include "netlink.h"
>   
>   #ifndef BPF_FS_MAGIC
>   #define BPF_FS_MAGIC		0xcafe4a11
> @@ -7185,7 +7186,7 @@ static int bpf_object__collect_relos(struct bpf_object *obj)
>   
>   	for (i = 0; i < obj->nr_programs; i++) {
>   		struct bpf_program *p = &obj->programs[i];
> -		
> +
>   		if (!p->nr_reloc)
>   			continue;
>   
> @@ -10005,7 +10006,7 @@ struct bpf_link {
>   int bpf_link__update_program(struct bpf_link *link, struct bpf_program *prog)
>   {
>   	int ret;
> -	
> +
>   	ret = bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog), NULL);
>   	return libbpf_err_errno(ret);
>   }
> @@ -10613,6 +10614,60 @@ struct bpf_link *bpf_program__attach_xdp(struct bpf_program *prog, int ifindex)
>   	return bpf_program__attach_fd(prog, ifindex, 0, "xdp");
>   }
>   
> +struct bpf_link *bpf_program__attach_tc(struct bpf_program *prog,
> +					const struct bpf_tc_hook *hook,
> +					const struct bpf_tc_link_opts *opts)
> +{
> +	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, lopts, 0);
> +	char errmsg[STRERR_BUFSIZE];
> +	int prog_fd, link_fd, ret;
> +	struct bpf_link *link;
> +	__u32 parent;
> +
> +	if (!hook || !OPTS_VALID(hook, bpf_tc_hook) ||
> +	    !OPTS_VALID(opts, bpf_tc_link_opts))
> +		return ERR_PTR(-EINVAL);

For libbpf API functions, the libbpf proposed 1.0 change
     https://lore.kernel.org/bpf/20210525035935.1461796-5-andrii@kernel.org
will return NULL and set errno properly.

So the above code probably should be
	return errno = EINVAL, NULL;


> +
> +	if (OPTS_GET(hook, ifindex, 0) <= 0 ||
> +	    OPTS_GET(opts, priority, 0) > UINT16_MAX)
> +		return ERR_PTR(-EINVAL);
> +
> +	parent = OPTS_GET(hook, parent, 0);
> +
> +	ret = tc_get_tcm_parent(OPTS_GET(hook, attach_point, 0),
> +				&parent);
> +	if (ret < 0)
> +		return ERR_PTR(ret);
> +
> +	lopts.tc.parent = parent;
> +	lopts.tc.handle = OPTS_GET(opts, handle, 0);
> +	lopts.tc.priority = OPTS_GET(opts, priority, 0);
> +	lopts.tc.gen_flags = OPTS_GET(opts, gen_flags, 0);
> +
> +	prog_fd = bpf_program__fd(prog);
> +	if (prog_fd < 0) {
> +		pr_warn("prog '%s': can't attach before loaded\n", prog->name);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	link = calloc(1, sizeof(*link));
> +	if (!link)
> +		return ERR_PTR(-ENOMEM);
> +	link->detach = &bpf_link__detach_fd;
> +
> +	link_fd = bpf_link_create(prog_fd, OPTS_GET(hook, ifindex, 0), BPF_TC, &lopts);
> +	if (link_fd < 0) {
> +		link_fd = -errno;
> +		free(link);
> +		pr_warn("prog '%s': failed to attach tc filter: %s\n",
> +			prog->name, libbpf_strerror_r(link_fd, errmsg, sizeof(errmsg)));
> +		return ERR_PTR(link_fd);
> +	}
> +	link->fd = link_fd;
> +
> +	return link;
> +}
> +
[...]
