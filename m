Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213C5323166
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 20:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbhBWTY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 14:24:56 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23900 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232003AbhBWTYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 14:24:35 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 11NJJ4Ak006573;
        Tue, 23 Feb 2021 11:23:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=3DPyHvdEHREXku3237UknRdmmXIlstC8pH+31VmpsQ8=;
 b=qRIN/jWuh8CuOm5kA3Y3vS2MycdDqhjMKDgW1TuIxqXw+2NtEwbEAmDMDAiJTxl/U65u
 fLy8fwUaBpW+68ZGqFMhmzJjfxf4XNrzL2HaJasMnQMPrY0X854h+z7/VFyZMcYBo7D5
 lfCs89C9iCJLxhx3NQ9+Z3MTlg4fzCqGUbw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 36ukhycynv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Feb 2021 11:23:35 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Feb 2021 11:23:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NRikgroZKbB7UsrO6Ezk+0ayKTmPUDF9gsQOHwVdfEajoKwrZb86L0nYqkiUX1X9NFTShKQXvlUa8VAT9aGznpRAsX87KdVhejEl55XBnE193gXCXgQOX4FfkLKzxk7TINO39fvw6u5j9j9os4m4chJZfCxSB/nNuuIrSzCNulCCuxzCDuTPUwNSDf/sZ7f7kQabwJCurB1oZwoRxZsZOQ2+/7BSXiA5GoKs9qehJjGkE2ueAcIk/jYtpp4/BQ/ZLKU31s3nqLqrjMxhNtb7zK/6n+3XBy1jK8OnlpzSTHVPCM+7Kz3Nlvxq3tkPEyRMQOghLfADomexMuLaO5IGBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DPyHvdEHREXku3237UknRdmmXIlstC8pH+31VmpsQ8=;
 b=mdk275tnMIXB5kkXdH9/6qFi+HBFHzOp0c8N/pnDOQRgn91hbvqPUOKdd6wbc5lF3BRtcJ5Q+JWSpiWMbm64pcfQdRS6a9cXeJ5Vp12noza8DX17xtvaxcZNJiL5tBLzcwzLBI/z3zhU2cBqUN0Z1RwFq/9BxHwvtijs6YLNFAbnBP5lMUTBljq9/BlynC6b6W/tQnkAWORVZtvH462HT8qRJGhoetCToDDPMU8IbnJk2MM2x4iJTTLWnksbQnyMWqQBYFfunufiqlLbasi3z6ShDR7ULBY9CVEmj0soPSGaXXaHpMQwU+IdcjYNci9HNScbG/HpSN8FdQ8gMomsRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.42; Tue, 23 Feb
 2021 19:23:33 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3868.032; Tue, 23 Feb 2021
 19:23:33 +0000
Date:   Tue, 23 Feb 2021 11:23:29 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Song Liu <songliubraving@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <peterz@infradead.org>, KP Singh <kpsingh@kernel.org>
Subject: Re: [PATCH v4 bpf-next 1/6] bpf: enable task local storage for
 tracing programs
Message-ID: <20210223192329.lutwo4ols75ut5ai@kafai-mbp.dhcp.thefacebook.com>
References: <20210223012014.2087583-1-songliubraving@fb.com>
 <20210223012014.2087583-2-songliubraving@fb.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210223012014.2087583-2-songliubraving@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:512c]
X-ClientProxiedBy: CO2PR06CA0064.namprd06.prod.outlook.com
 (2603:10b6:104:3::22) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:512c) by CO2PR06CA0064.namprd06.prod.outlook.com (2603:10b6:104:3::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 23 Feb 2021 19:23:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9d0674d-f818-4a47-cd4e-08d8d830824b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2999:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB299944B63AB068D4F595E194D5809@BYAPR15MB2999.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bUQ3ACOlLAHG2Ki8ZreEi8cdQYGcpKQ7CdEx1jpSzZH3rCnqV15OrUCb6c5Pf/KT+IQnsXiXgz+SVYOnSSUdsejbVwF7sigFiEveykyvEFZRly/9z3WYDZo7KJpTA9UowItNXvPuhOI0DQXrFahy2eBpBEEgJ2EbkjSzFIDEHRa9O+/NgPR6dOPnOq9TNeyb//f7omgXK7gPb2TI5kSC4mcH9yahoImG6AHoC8ZH9OiD7mX42+rsM0N9PuByN3a0LqhOGXNuKl0oacPLCd9K2an3fb5WZA/Pv2nGnyCYSUrx9B5f150bACqSHJibeAUHoaqFeyQflC3KJzlOc/LxRW6wIV3mrMGBATPR2SmkRXMdozeDJcMCwcyZz+P4If6LtyCv4Hnm8IXSyXwloGo6UKriCgsU0USTV5RNF772veeXxSsfPIQfPasHhCgnqtaAY1s3AB7hcEpQS3K0rKfPoi9qEHMAx2eJyoXaK8acK1I3PFk/Kav86Kygd6eO1QITDfxm5LiRUvwIua7nxcVwUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(396003)(39860400002)(346002)(478600001)(9686003)(6636002)(55016002)(8676002)(186003)(16526019)(83380400001)(2906002)(5660300002)(8936002)(6666004)(66946007)(4744005)(6862004)(52116002)(6506007)(7696005)(316002)(66476007)(86362001)(66556008)(1076003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pFj8Vp6KutX0HsDbzJlbwgA+H6GFGdsWHekjXuU58J7qXKJoM5OrK86+dk3p?=
 =?us-ascii?Q?3T0hCWXEn+7FitV8/GQmoFNiGpgxgvhDDanEi16MTiJD74qEhkyyMGwVDkIf?=
 =?us-ascii?Q?KGfijyDOl8awRvBK5b03yZ6IngSlDKouNwLuFbCWSp+KX6MrSzGbZYw+GTPY?=
 =?us-ascii?Q?Dlepae9H5RAw/VDsff79SYyUqJiY4XmwjIPyMbwYa6pGtcGHTkH9l3K52F7O?=
 =?us-ascii?Q?OLyvrd/f+Pq7J6eFevc42Ygdg1KIrdIrdEo+vigIUjKXNsUr05bd0/DXkA5U?=
 =?us-ascii?Q?oj898enJt+kLIH8nRjxcUS73LVS3LQcvRJoZv+1K/WQhWfDQGBr3jk1N1Sl8?=
 =?us-ascii?Q?mzfyMaKYLIID0JJ7X/TtKuPhmocd+cgz0NIlxXsb+6MLAK4pazws0yNoKaMr?=
 =?us-ascii?Q?z1eDrovL30MVC5kAb8IrgrB2tblfMvVRz9KoaLAmMFh34+8/83mhk6o4xrbw?=
 =?us-ascii?Q?595vLkXj/VlLtnABDbr74yl/Ikh9zkE51uXzD1gUKyDi7y9EBt5L1RAuZ+45?=
 =?us-ascii?Q?8o2972iceMw/LWiYID5ZsZ/zFX4/p9AghtDzsx779zpE2LoGZr86KQtUQS5R?=
 =?us-ascii?Q?kbjDTt/RPy/DLLhVfsVYcUV1Eud4yeHk3rYTZ6sRCL7BUXWgU6NFdLAHXuaz?=
 =?us-ascii?Q?llmQO10o4p6QuHf3lirRvZ1lxn7d+G1FGEU0UiZ1ebwUikpgF/TeY4Xdq+G7?=
 =?us-ascii?Q?QjTr2Ly6h4HfYL4/pfrHb0IrPlo+N+igYxoJD+1LL6jV3BXJa/3iVBdmsbaj?=
 =?us-ascii?Q?klZhqQkg4gFteGUKxHTVQCJPW/TWp9Op7uVM9Smf1LbG0YhY5fSriaMIL1H4?=
 =?us-ascii?Q?qSXAAuJlCmwXwtHNlsgoZ4Y6wq36m6hcIuAqug+8fHVOGqmVQUWmbSsLV8Jh?=
 =?us-ascii?Q?KrwwhcW2oBZEwmtgBd6DZdyV9ikEKkyTj5buC8PR5lWkUtAoifeyv83KeHxm?=
 =?us-ascii?Q?HiYcuUJKz4v87TPb6DevzHWzrfehsvQvDCb++0943+fYi+l2zwuGLHbtpwNJ?=
 =?us-ascii?Q?qpaQq2He0Zn8lGf5NhrDsHsGKX3l9NWpkE6UGFw7NTukP6JZ/AaO+NkObbtq?=
 =?us-ascii?Q?T5K3qLW0aOCUd7rMA/NCJbowW103LuOAwocZMp+cuDYXTt0FaY+0xPjOE+y+?=
 =?us-ascii?Q?tMSS0eDXYyRUlzSdyd0u4JSsvmGJTDy3OphsRhnDnLwen+ijA4XZL+aW2LpL?=
 =?us-ascii?Q?gKBEPlDZf79vbvSgRP0RZKMLVgKD+DfHGfmFTSb6AoT6ijrzQFV06OUF0D+X?=
 =?us-ascii?Q?uUPuo1rywmPo3iYrq+is9GdG8Y6dOtsv7dUFuDJgnOYB+v4P3s7GT/F+0Wlh?=
 =?us-ascii?Q?+2o0O7s0O68Yslf6YqDOcUvEWhO8aO0FZzuABcZgSQGTPA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a9d0674d-f818-4a47-cd4e-08d8d830824b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 19:23:33.2159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GxfNnrHrO0EohZpFdxYY9QRAaTV3fA/4tNOzSMvpuwMT7g/IQEzgncpffhCAhVE9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2999
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_08:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 mlxlogscore=897 impostorscore=0
 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230161
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 05:20:09PM -0800, Song Liu wrote:
[ ... ]

> diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.c
> index e0da0258b732d..2034019966d44 100644
> --- a/kernel/bpf/bpf_task_storage.c
> +++ b/kernel/bpf/bpf_task_storage.c
> @@ -15,7 +15,6 @@
>  #include <linux/bpf_local_storage.h>
>  #include <linux/filter.h>
>  #include <uapi/linux/btf.h>
> -#include <linux/bpf_lsm.h>
>  #include <linux/btf_ids.h>
>  #include <linux/fdtable.h>
>  
> @@ -24,12 +23,8 @@ DEFINE_BPF_STORAGE_CACHE(task_cache);
>  static struct bpf_local_storage __rcu **task_storage_ptr(void *owner)
>  {
>  	struct task_struct *task = owner;
> -	struct bpf_storage_blob *bsb;
>  
> -	bsb = bpf_task(task);
> -	if (!bsb)
> -		return NULL;
task_storage_ptr() no longer returns NULL.  All "!task_storage_ptr(task)"
checks should be removed also.  e.g. In bpf_task_storage_get
and bpf_pid_task_storage_update_elem.

> -	return &bsb->storage;
> +	return &task->bpf_storage;
>  }
>  
