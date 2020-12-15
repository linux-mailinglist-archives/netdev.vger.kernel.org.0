Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1482DB51F
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 21:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbgLOUWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 15:22:35 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11348 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727472AbgLOUWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 15:22:20 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BFKIxdt014426;
        Tue, 15 Dec 2020 12:21:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=roZhKSc76e3MV/vVySVyE+HrJ+DVwIpBIHoSwB8EcZ4=;
 b=R/v+uGJgOKn0KOAegAohDhKHnU9UqdMp3ZZ0zgkHAVSnAKW557W0uCt6KOYA6vRdt+ai
 Nj1HArteCDisgZa3bOhEc8/2ulH9b7R0n0a7pPy7SJ0sKys7XK7IGYY0TdMtLHwLUZNo
 bEztXyCva1mkNbDJ2UrAYHKc9zJtLb8vkOY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35detaw6a9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Dec 2020 12:21:25 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Dec 2020 12:21:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ilohxlb2A3oMinR7vyTMJv0cZtIyUdo2rRJuAUzg0WOtTTP1/Uv21yfYoDYE3C+Ci6bQaJ8wln0n60ML67gLsUE1/duotREtbv132RFOYyaCMtintP/pRSbhmQJhewFt0ziIqQ5xvbZeyc4nNwb3enBhrELJlcps2YkPE3MLhHd/Ca0ht0Z5IvmDOiHWbfMwiLLvp2yV9iMfx2X39sq4j8ryQFJ+5Kfx8wukBARIIQa+RAyH0dM1GS3Roz3DS3KvtChS90Js0riCbaSxK2JKWh/j3ykv5zR2l1N3qcsXzakAfxLlZJKQGmL4VOrUt18hnPRHtMmNIzTyTYi+r5IGEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=roZhKSc76e3MV/vVySVyE+HrJ+DVwIpBIHoSwB8EcZ4=;
 b=GrFBFro6E59ET1w75y10aU5gd2IulIdhEJxdGRORVcVBfLvmf5GeHKKLUK3xBrZM0OL1wWQt8OS+hQaN+w85Uvynlrua0pBEw+e3kW2dAruZLdMQJrpYjfmjn30DXxSpb221iULOoWQm5tmisoQWd1YVu5KHi2xpntC45m7cwDFKiJ3JpxzweKfoAK8wPeZ9oCmpcgOx9Lvy3xtXK5VefslRiQtGEwDKRvSCMemY4ms9+DH9czSCbXokIn2ssviuFD4K/nDgxEmMXpeGO4BbN5Ql5TYngTL0C3OUFTJexd9GccFDWFsNR4aeL7tbnyRAkTJnOieb8ZrNeCKsCOE3cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=roZhKSc76e3MV/vVySVyE+HrJ+DVwIpBIHoSwB8EcZ4=;
 b=T+wOGBfOsdJ0GfUCOs4vgtS3DY982Jf0KN0Lp0Rf5gnXvjDTxrsOF4+MHBubDWyAhJX1II/Xi+GULJszNQu64fhFxwZmD31ssWFq/bLLLr8jBxS6NcqJ26e0JuWW8WRhZTlQuMAU2Xs2i5JKDepP9d6pnWXMtk32y1b/MoZk/8M=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4085.namprd15.prod.outlook.com (2603:10b6:a02:bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Tue, 15 Dec
 2020 20:21:19 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 20:21:19 +0000
Subject: Re: [PATCH bpf-next 4/4] selftests/bpf: add test for
 bpf_iter_task_vma
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>
References: <20201212024810.807616-1-songliubraving@fb.com>
 <20201212024810.807616-5-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e3f13f87-6ee8-1ed3-c575-3f23c907bf3e@fb.com>
Date:   Tue, 15 Dec 2020 12:21:16 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201212024810.807616-5-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:e381]
X-ClientProxiedBy: MWHPR18CA0036.namprd18.prod.outlook.com
 (2603:10b6:320:31::22) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::112b] (2620:10d:c090:400::5:e381) by MWHPR18CA0036.namprd18.prod.outlook.com (2603:10b6:320:31::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 20:21:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ac861e5-2ea3-4fee-f0a1-08d8a136fbb4
X-MS-TrafficTypeDiagnostic: BYAPR15MB4085:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB408545423D1AAE4BC04FF2D1D3C60@BYAPR15MB4085.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:81;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tCqZVkiMTP4JmbEYYwcoC1XPo+j9xjYJGA9yPXnL2ekGCBpzQRaOyHoxuuvNyxSx5IomibzYLHiEbfVSLhq5gYvCAAFCFFSNvXTlK60oPCYmMfPtGCaaAI/2gJf9VKR0a+PbjnmffoloOLxnanzrJGRmaFHGeSNgOMmpaFee0v+LaBzi0HqHKDFXtJ+xeR7kYzMrqtmp2XZRl78PDABF4kUpfBjxbDS2xr+H7vF8LJ7aNK6PyzBPUcZaj0xsK4fnr0Y7ChKV2DWOcksaAfxHNg2FTjWw2RJF2COydkBo0WC9mmw1c+kvFHLaQGS9D8FcaMz0Fyyz/9HRw2LpTAVweKapd+zL/TvrJ7iTMi8V/xb3a+WWlZXi499Zs/w0JACqYDlwahMHSpolT+UWcqQDEkjWVJUHkTKI9q2WVOKWrIE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(136003)(186003)(16526019)(83380400001)(5660300002)(31686004)(8676002)(53546011)(2616005)(86362001)(36756003)(66476007)(52116002)(4326008)(2906002)(66946007)(508600001)(8936002)(31696002)(6486002)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VEpQMkN5Zk1kS2RrL1VuUDVtNDFWZzc3bEV1U3FGeHZyL01GZTVpc1hOS21o?=
 =?utf-8?B?ZndwaWlSTjJmdjJOMCtwSFhKcldlL0lHRXhERE5jbHlpR1E0bEZTbFpVd29q?=
 =?utf-8?B?dFlIU0ZnQWhUMGJnUFdTcWlKR2pQV3E3b253ejR2MHR5dTZrY1RHdERESFNB?=
 =?utf-8?B?Nk5NQ2doVUx0Q0lVSGxaNlhqUjkvWVAwb1F3T0VSMDZoaGVLS3lZMkNjQzQr?=
 =?utf-8?B?ZEdwdEJoMHF4cGNqU0RvbnV6QVVjVkFPK21BWGt3U1J2SzdabDdBRHBTY2o4?=
 =?utf-8?B?aHJ2WkgxVFVXNHBseVBkOHhZblduYU9FZUEraEoyV05xWVAzQlNCMUt1a3BS?=
 =?utf-8?B?NVE3ZlJ4d1ErT0Jua0VraFZtTEtPQUdJeE1KZFo1MFROaEZoTWNDL3h6NTMz?=
 =?utf-8?B?NFQ2UEtBZ0RqdjRsTUdtR1pVUEs5bzJsbnc3UEk2enNtZVF0RTFZelNJeWMz?=
 =?utf-8?B?SURoNm9PM2NiVy9JNEJWbUxqRGRyMkZIdXorR2JBV21KbW8zREpVMDNMdnNW?=
 =?utf-8?B?MzN4R1ZiMlpZd2g0RHpaQVNiNS85akxWOWpTeUdkdisxWHFhQUhwbUk0NmF4?=
 =?utf-8?B?M1dRTEQxR1ZjdXJERUttTHROSU0rcUFIL2h2RWhIeElqVTZ6QTRYa2FROFhO?=
 =?utf-8?B?TjhCQlh3cWJEcUVMeElLNndsYitlY1FPZVhXblliSThxNE1uT3puOW4vNGk5?=
 =?utf-8?B?aTRTZnVlZ2twTUhoUnR1Ly9JMDdiUlFTSmJsVUFqNXJkQVJWaWRjUHBhRDlj?=
 =?utf-8?B?YzI4NW1DWU0zRWk5Q3MzL0haMEhGOC9mYWZ6eGVicUhKK2F3Ujg2ZnQ4VWlx?=
 =?utf-8?B?bUNnVWw5NmpnREcvZnpyWjJNc0NGRFFMdk5OYWVGMjUwcVpzQzBCZk40bm9v?=
 =?utf-8?B?c244OUttRTNWOCtONnljOU1pYXNubzdTb3lKTDBVNkdja05Dd214Mk8yUEVT?=
 =?utf-8?B?MTlhN215UWNWV0E0LzFreFJNa3ZSVERSNVl4TEMwekdqLzd1RE41VUV5MzJn?=
 =?utf-8?B?UjlYQzgrVkUzd2hRaGZiR0tMS2RZcytLc2pmMzkxM1MwdmMrQ21CRitLV1R2?=
 =?utf-8?B?RTI4UmxjelltekdEL043KzZ3blFNak5yRjVIdlVZbzN6a0ZZbDVyaWxFcGhk?=
 =?utf-8?B?WmdPbmo0cy80RWh3SXdPM0pYZUVWYkFqR013anMvSlpOUUVwcng4MngvZXRa?=
 =?utf-8?B?NnRBS1h4ZkVQVHV6MllnQkF2TDZlR0kzMjliWnFZSHFxSFdhT0h0MWNYa2FR?=
 =?utf-8?B?UENjaVUxcjV6N0s4ZitrYUhGQXZZSlVORE5TaFZvYWdSTlg2Ukw2QVREemhC?=
 =?utf-8?B?NHpOcG1CRWpwOUdVR2Jmby9LTGxnOWhIcnRVd1FQd0JWK25xV3p0UHRSalNw?=
 =?utf-8?B?dnpzOStpbkhpTXc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 20:21:19.5560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ac861e5-2ea3-4fee-f0a1-08d8a136fbb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MdaCpcbfzV39xrjE3BysnVcnv++7DOoG7ZNqxo6SvjVEyr5D/T/6ktRS7Yr5B8jz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4085
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_12:2020-12-15,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 bulkscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012150136
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/11/20 6:48 PM, Song Liu wrote:
> The test dumps information similar to /proc/pid/maps. The first line of
> the output is compared against the /proc file to make sure they match.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   .../selftests/bpf/prog_tests/bpf_iter.c       | 106 ++++++++++++++++--
>   tools/testing/selftests/bpf/progs/bpf_iter.h  |   9 ++
>   .../selftests/bpf/progs/bpf_iter_task_vma.c   |  55 +++++++++
>   3 files changed, 160 insertions(+), 10 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> index 0e586368948dd..7afd3abae1899 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> @@ -7,6 +7,7 @@
>   #include "bpf_iter_task.skel.h"
>   #include "bpf_iter_task_stack.skel.h"
>   #include "bpf_iter_task_file.skel.h"
> +#include "bpf_iter_task_vma.skel.h"
>   #include "bpf_iter_task_btf.skel.h"
>   #include "bpf_iter_tcp4.skel.h"
>   #include "bpf_iter_tcp6.skel.h"
> @@ -64,6 +65,22 @@ static void do_dummy_read(struct bpf_program *prog)
>   	bpf_link__destroy(link);
>   }
>   
[...]
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c b/tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c
> new file mode 100644
> index 0000000000000..d60b5b38cb396
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c
> @@ -0,0 +1,55 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +#include "bpf_iter.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +/* Copied from mm.h */
> +#define VM_READ		0x00000001
> +#define VM_WRITE	0x00000002
> +#define VM_EXEC		0x00000004
> +#define VM_MAYSHARE	0x00000080
> +
> +/* Copied from kdev_t.h */
> +#define MINORBITS	20
> +#define MINORMASK	((1U << MINORBITS) - 1)
> +#define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
> +#define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
> +
> +#define D_PATH_BUF_SIZE 1024
> +char d_path_buf[D_PATH_BUF_SIZE];
> +__u32 pid;
> +
> +SEC("iter.s/task_vma") int proc_maps(struct bpf_iter__task_vma *ctx)
> +{
> +	struct __vm_area_struct *vma = ctx->vma;
> +	struct seq_file *seq = ctx->meta->seq;
> +	struct task_struct *task = ctx->task;
> +	struct file *file = ctx->file;
> +	char perm_str[] = "----";
> +
> +	if (task == (void *)0 || vma == (void *)0 || task->pid != pid)
> +		return 0;
> +
> +	perm_str[0] = (vma->flags & VM_READ) ? 'r' : '-';
> +	perm_str[1] = (vma->flags & VM_WRITE) ? 'w' : '-';
> +	perm_str[1] = (vma->flags & VM_EXEC) ? 'x' : '-';

typo here? The above should be perm_str[2].

> +	perm_str[3] = (vma->flags & VM_MAYSHARE) ? 's' : 'p';
> +	BPF_SEQ_PRINTF(seq, "%08llx-%08llx %s ", vma->start, vma->end, perm_str);
> +
> +	if (file) {
> +		__u32 dev = file->f_inode->i_sb->s_dev;
> +
> +		bpf_d_path(&file->f_path, d_path_buf, D_PATH_BUF_SIZE);
> +
> +		BPF_SEQ_PRINTF(seq, "%08llx ", vma->pgoff << 12);
> +		BPF_SEQ_PRINTF(seq, "%02x:%02x %u", MAJOR(dev), MINOR(dev),
> +			       file->f_inode->i_ino);
> +		BPF_SEQ_PRINTF(seq, "\t%s\n", d_path_buf);
> +	} else {
> +		BPF_SEQ_PRINTF(seq, "%08llx 00:00 0\n", 0ULL);
> +	}
> +	return 0;
> +}
> 
