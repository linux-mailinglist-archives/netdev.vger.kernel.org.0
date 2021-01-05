Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF782EA142
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 01:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbhAEAEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 19:04:36 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14894 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726163AbhAEAEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 19:04:36 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 104No4SW030562;
        Mon, 4 Jan 2021 16:03:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=1ppAzx0EHMWU0ox8dBh/N5HpB1sElmxTNJ+lQVpXBLc=;
 b=IwfVDLv2hpylCA++wyxIKzjVG+4Fbf6R0zKdJ9Z/AZlto2acYztnbl1oh9osC35Oci5p
 pTAb4PhL7lF1cfl1PxSfICm/chzQ3RyJISzguL9d7UHefEi5vg/WC+w3HKBdVEFDNoMK
 rUWIlTBVOxTCLeXbHX/+Csjt0Fe583hpwxM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35u9rupphq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 04 Jan 2021 16:03:38 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 4 Jan 2021 16:03:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cscex11YYtCTy8nRmS3mB0egqDc2Qp1FudwcUVYmIAtAl5MBRiKOaSflReEsnSyQ+ojwgirBCUg5eEKlA1BbwudAYl0jWwcraTea/U+ce/XCW3wEXpyx2mE5i51b4OxvvZ6mvjP7xzoCwOCskfc6OHl6dUIO9MIQ1DxV0K8Itoq0AsLiCHmKumJ0/nbnf4AVeGQq97JuE6QFl98/qIfaVMoKh6CtZ4ufc3narIMap0SK4q0fmcMg7hOIR0z2mbMbjlWbZCI4bMfJhQ2Qm6aHgJIOTFE52RHTmmiPT4QJfHkm/Wr2bQjehb83HHvuRzMQdLPB8Y3+H4TcIiGg2Ey7IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ppAzx0EHMWU0ox8dBh/N5HpB1sElmxTNJ+lQVpXBLc=;
 b=KBpJ1WOLAUvdUNlKtk8uCivbkSSZEv48PDFk5+MEuGkqfpDWrfB46iymvxS/kY4jahT/GyctqF2cI2Ply4ctnUEdOi0t3QTGoz7Jt/oKOOOH8WXFdP+cGe/MlX/pisGDF1kzX7GHbU7ZWT+dA3zg+2QHyCKkRP0VyOd0B9s71NALlG9/Gfud99pSGtk4duDR4HYYYcueoouWO9I0Raxp1nHf0ZErysVyxk/Z3oEDYUgMpusIC8KiJiB2WHiHQCGn97wCcWCXT5w/Uwrw4cdzcoNQBief4hMq5qZipCzDe6ky8QFhUzBPacuQsSEk0Z6vvErMBeRRVgGT7RiQ2B+TkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ppAzx0EHMWU0ox8dBh/N5HpB1sElmxTNJ+lQVpXBLc=;
 b=ZRZpoI0vTkT14klydZQvUqehSxYsJriEAb1nOjXgwKJB7WezxH9+NojCr8NfdtK5p2Wk57JMliQEwevJdIipQuKiYy8oprZDPgKthnTsat7CQ+loJuIi/NVyU0ei8tYQobOjm0aYbJrJRolPExm8sw6ukOV5wVy2DcnahQRN7WE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2774.namprd15.prod.outlook.com (2603:10b6:a03:15d::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.24; Tue, 5 Jan
 2021 00:03:36 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7%7]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 00:03:36 +0000
Date:   Mon, 4 Jan 2021 16:03:29 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next v2 1/2] bpf: try to avoid kzalloc in
 cgroup/{s,g}etsockopt
Message-ID: <20210105000329.augyugyaucykt35r@kafai-mbp>
References: <20210104221454.2204239-1-sdf@google.com>
 <20210104221454.2204239-2-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104221454.2204239-2-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:eac]
X-ClientProxiedBy: MW2PR2101CA0014.namprd21.prod.outlook.com
 (2603:10b6:302:1::27) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:eac) by MW2PR2101CA0014.namprd21.prod.outlook.com (2603:10b6:302:1::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.0 via Frontend Transport; Tue, 5 Jan 2021 00:03:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5852c9e2-d9b6-417c-94e9-08d8b10d59a5
X-MS-TrafficTypeDiagnostic: BYAPR15MB2774:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2774CE0D633CD2EFFDC6DEECD5D10@BYAPR15MB2774.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5jwDeW4Xm5ANinSucIHpczDzAJPKyvt7ObILAF3O5sp9fmapGWq/T2hwkt+Lx3S3IJGG1aLdhCklMB+CC3P8nC0aJUGsvRueR08CKgx8jwQznj3QC1UdGAUlol1c4udYjGrPYLfZC+/F/in8fN9S+Ky/7RmpLNEdIcLI7x9xTgoizPyBe9L/UQtTniMtYeXgUpvW6MNuMrfIoFeI4rrQeQv2lcrfRzIEq2Ijpae9z9nVfhRNHUTg24bnUSMkYe4JWJ7VvC2RByE3g9pdQ8uqOxZQK0upX7k+OwUSiOGRTjVJgvmz0d/72cRQVdgxjOVEGUVjfOXppj/En0klpeKaGk373YK7TaNU4Aw07dvwvO3Xa3dS+nSc3JixGIVygccyHch4JS7YAvqP0YhkLFtWfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(376002)(366004)(346002)(8676002)(316002)(2906002)(16526019)(186003)(66946007)(478600001)(86362001)(33716001)(66556008)(66476007)(52116002)(6496006)(8936002)(83380400001)(5660300002)(6916009)(1076003)(55016002)(4326008)(9686003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vKYSccwA8mCn9dgcMmdDVs5Wp66EePZW3BrpEOVlyZOWlF7/34sY+JizVECo?=
 =?us-ascii?Q?MCScxMVvJP9xLOaTo/q9/5nXpJJlUMV+TeM+EaclOtsmEeNwU3DxyK4UxDJY?=
 =?us-ascii?Q?sqRY+t0OCtWUA+rBGlG/dSD4KxaLOfEnRE99x6cr/VuRpOdkTN7GbV2h9vae?=
 =?us-ascii?Q?Qn5P1JtWxAi/SPiPZHX6IPkDL5rNJL2KlOEI/F5M4jHEYd8m5aVCnaFcGmmW?=
 =?us-ascii?Q?5Mg+3of4Axa4R2BSKYftPDDbIXzZgkfOGy803N4xTN79UVGGkaiLJ83myGTH?=
 =?us-ascii?Q?ZMBmaDCrexWdldO0bfQDoc4jPQ18SMRcbdfF46N6lEOpr6NjEZ1uwd4Bkfsc?=
 =?us-ascii?Q?clMX05o8MFNSii27dGVdAL88iSoLIw5SxQpHqO1V9JzPBEQ/Ro3z1U7oD5qE?=
 =?us-ascii?Q?53o0hF74iAwnj0eakvfKEAnBS+bodQSsMM0KzTW7DP0LvPF18hNjK8X8D3P/?=
 =?us-ascii?Q?1QHLlQz88scXg+6aomWSH4IN21I28oMnqS0KM0wOifEr3OTRRU9yqNkKbs6C?=
 =?us-ascii?Q?StHkBgCODGwX1Rm3At/1bYWeOfQIKx1ddNYWPVRl1O42SPreSdCc5z+BhOXc?=
 =?us-ascii?Q?Lya+jrGsiZufJ7zSjwQ4d2UXSodF7p2b2H0mO28rJNOIto51sZD8ONcLMACD?=
 =?us-ascii?Q?dK+D8G1pNVbRMGO9O1DV1YOBr+55MZm8lczdCapBmXhmVU6BneU7x8A1f2wv?=
 =?us-ascii?Q?lzJZqHDqO7/crmNakMgq9tOOtdedawXIaxH7imcvDVFYVRT77m3IFZK/3Ycj?=
 =?us-ascii?Q?qOgvBJQdwS2sWNjMXufNp7gRnD3zLqCL1ac6Biw4XqdLE5aFRejk9WdfdQyx?=
 =?us-ascii?Q?W/7MY5eF7SiHHhuAGGrW9fgtzeTd+LZdZwJkRCOA98Ce9wl1XBRPR58qbUAM?=
 =?us-ascii?Q?+enAlvAuH2L7uFxPvkbmRNoIssYwA5JE5QEYkWYw7jtL5BAdD4QLuO/4Rl28?=
 =?us-ascii?Q?tZceLYazYXuk8vncdNnrMkRaXYxf1PF2Qsqw7IceH5FiUNaBdn9+HF0F6Ym2?=
 =?us-ascii?Q?N3omzDCyJ4l0KSlfs+zzaA+yag=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2021 00:03:36.8880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 5852c9e2-d9b6-417c-94e9-08d8b10d59a5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b8V9P0OPXBlAKUksjPdgEfNXXC7Dey4XfZRU8bD1IhCMNl6jVCfwpYEtP8FqpzkX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2774
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-04_16:2021-01-04,2021-01-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 suspectscore=0 adultscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 phishscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101040145
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 04, 2021 at 02:14:53PM -0800, Stanislav Fomichev wrote:
> When we attach a bpf program to cgroup/getsockopt any other getsockopt()
> syscall starts incurring kzalloc/kfree cost. While, in general, it's
> not an issue, sometimes it is, like in the case of TCP_ZEROCOPY_RECEIVE.
> TCP_ZEROCOPY_RECEIVE (ab)uses getsockopt system call to implement
> fastpath for incoming TCP, we don't want to have extra allocations in
> there.
> 
> Let add a small buffer on the stack and use it for small (majority)
> {s,g}etsockopt values. I've started with 128 bytes to cover
> the options we care about (TCP_ZEROCOPY_RECEIVE which is 32 bytes
> currently, with some planned extension to 64).
> 
> It seems natural to do the same for setsockopt, but it's a bit more
> involved when the BPF program modifies the data (where we have to
> kmalloc). The assumption is that for the majority of setsockopt
> calls (which are doing pure BPF options or apply policy) this
> will bring some benefit as well.
> 
> Collected some performance numbers using (on a 65k MTU localhost in a VM):
> $ perf record -g -- ./tcp_mmap -s -z
> $ ./tcp_mmap -H ::1 -z
> $ ...
> $ perf report --symbol-filter=__cgroup_bpf_run_filter_getsockopt
> 
> Without this patch:
>      4.81%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_>
>             |
>              --4.74%--__cgroup_bpf_run_filter_getsockopt
>                        |
>                        |--1.06%--__kmalloc
>                        |
>                        |--0.71%--lock_sock_nested
>                        |
>                        |--0.62%--__might_fault
>                        |
>                         --0.52%--release_sock
> 
> With the patch applied:
>      3.29%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
>             |
>              --3.22%--__cgroup_bpf_run_filter_getsockopt
>                        |
>                        |--0.66%--lock_sock_nested
>                        |
>                        |--0.57%--__might_fault
>                        |
>                         --0.56%--release_sock
> 
> So it saves about 1% of the system call. Unfortunately, we still get
> 2-3% of overhead due to another socket lock/unlock :-(
That could be a future exercise to optimize the fast path sockopts. ;)

[ ... ]

> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -16,6 +16,7 @@
>  #include <linux/bpf-cgroup.h>
>  #include <net/sock.h>
>  #include <net/bpf_sk_storage.h>
> +#include <net/tcp.h> /* sizeof(struct tcp_zerocopy_receive) */
To be more specific, it should be <uapi/linux/tcp.h>.

>  
>  #include "../cgroup/cgroup-internal.h"
>  
> @@ -1298,6 +1299,7 @@ static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
>  	return empty;
>  }
>  
> +
Extra newline.

>  static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
>  {
>  	if (unlikely(max_optlen < 0))
> @@ -1310,6 +1312,18 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
>  		max_optlen = PAGE_SIZE;
>  	}
>  
> +	if (max_optlen <= sizeof(ctx->buf)) {
> +		/* When the optval fits into BPF_SOCKOPT_KERN_BUF_SIZE
> +		 * bytes avoid the cost of kzalloc.
> +		 */
If it needs to respin, it will be good to have a few words here on why
it only BUILD_BUG checks for "struct tcp_zerocopy_receive".

> +		BUILD_BUG_ON(sizeof(struct tcp_zerocopy_receive) >
> +			     BPF_SOCKOPT_KERN_BUF_SIZE);
> +
> +		ctx->optval = ctx->buf;
> +		ctx->optval_end = ctx->optval + max_optlen;
> +		return max_optlen;
> +	}
> +
