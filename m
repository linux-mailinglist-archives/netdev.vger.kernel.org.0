Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4151F2F1E5E
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390654AbhAKS6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:58:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31784 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731334AbhAKS6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 13:58:08 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BIoOEb023630;
        Mon, 11 Jan 2021 10:57:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=qJABTQ6N0obgZkuMAPWze5iITFjYOLnlf6btz6SZ5EU=;
 b=QGKiKlBjMevFN+9rELMTudjC++2jFfeGUbCoDPRZ6JNkbFUPEvif25VmZXBBQu5TCvzG
 5YwS7j/86anRILkMCOty+cyg4KrYwh8w3rJwdilApx0FpvZlUP3d5tnNAfylFeEt/dtA
 4y4tMzS+/sH+RR6xWDeQE9ea8+MmpfwSHRw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35ywdupa53-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 10:57:04 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 10:57:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jMJNV0c0+bliT9JFpZYTsduJjspc5ozD9tqohcpy5UYk2xtCckI8ZHU/WUBg8HGKhYGlWo3n8zhcJaWLOG/hHahOvjo5AFH3sjd6bX+VjRInjx20IKdnbOpjTAtg680SBp4vxoxNKmsIS3bBHMr2n6M9zLr2pCwHvvT1/OiC9eVPl8F/jjYwydUhNJhs+rIdDOqpoeTQKjp+TzOI8rygk73VeoyxnmsWXHBRlysfRdMgYDEIn5ofuomViifN7Bny/eeiyhS7vzudDosVLukVY0HzolLPZt8Z+xFo1oWRBfNih2ClJ2H6eMMQ9XvAEWKRqCBLqqonEK+NFuBT3Y4iDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJABTQ6N0obgZkuMAPWze5iITFjYOLnlf6btz6SZ5EU=;
 b=nokMX08Lj6IE3ZPLWf1D3r2UgiBghpOVu+YhRrcBs3OF0/yF423OX68PIJBIuj30BzMxQjmmOJKevZ65eTzJ3tVUck92nXrOsr7ywnpzyQMAt0X+wxRfDVr0tSWsgizLVw68CFrIv5AkKOr/GRGIgwzuMvNVRotpI7Sy1R5GIAytbi5SHi4kvIGh8LfF7TcuWbUDWA0018qDSV22j687Obzo+0cMBBmgXHGE5XFvpsMlDBrS1/fns0YcBIHnk3qVU9BUv+JF1Ec3clb6JbFNFT/EcO+jIQyeMxPfOsUWyXyzJa5GvC4k+Cu1r0BZjmlBBzJpIB4smw63BFStGM9DmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJABTQ6N0obgZkuMAPWze5iITFjYOLnlf6btz6SZ5EU=;
 b=HTAAgVpgJ7NQwFV3frz/emzPsSEMH2+lypVsooHRmZC5u138foTh9ARVD/mEYbdQ9uuZGxdTIDjuAmInG5K0nCWv2LmlvJWg8pRgVmBOyfDmwNXYwcpP+U76GYYcb15+VqVnvq1qG2dcI4SmDjfji+D6W4JZQTW2m7Jf7wA3kX4=
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3618.namprd15.prod.outlook.com (2603:10b6:a03:1b0::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.11; Mon, 11 Jan
 2021 18:56:57 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66%3]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 18:56:57 +0000
Date:   Mon, 11 Jan 2021 10:56:50 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Song Liu <songliubraving@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
        <peterz@infradead.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <kernel-team@fb.com>, <haoluo@google.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: enable task local storage for tracing
 programs
Message-ID: <20210111185650.hsvfpoqmqc2mj7ci@kafai-mbp.dhcp.thefacebook.com>
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-2-songliubraving@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108231950.3844417-2-songliubraving@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:e2df]
X-ClientProxiedBy: MWHPR15CA0069.namprd15.prod.outlook.com
 (2603:10b6:301:4c::31) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:e2df) by MWHPR15CA0069.namprd15.prod.outlook.com (2603:10b6:301:4c::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 18:56:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fb7c08d-53d4-415e-1f0d-08d8b662ab8b
X-MS-TrafficTypeDiagnostic: BY5PR15MB3618:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3618DA4BE74A4B63970790F4D5AB0@BY5PR15MB3618.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CxTy3PvTsbjD9fVCn0F9GTKw4DTLwjH37Ey9yBH1VcTgtxKWP3pi6a2qsWm08roXqQ8z5YVjde6AB7C7SUlqkOuJQKLzRNjzdoVNzleEJSYlhbfrAyU+gelawBELk5VqHkgB1faGgtARRAdpYOzSxxurgrXx8Pe6LZZQWAptaQwOAXh3t1BsO/KemkcYd2qFHOXdmgl4HzZeZjmHY++bCm8YoUcfQjtT3BfAvYRg2wKyWPRUJe+3I59vGpfA14TeXgtkWPXSzBaSKVYwJWM6zniBrgvGJjOmnaiUBRzhN5DWjkRiPye3tGDy8ZeD3ViSA91YddKWggHVonaGaVpVBHdFiLzUf46KA+kDLz7d8R7rBWYSzPe+fct5hyYqyM58WCrxd3RTmVguSw/WW2W8TA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(376002)(39860400002)(346002)(6862004)(86362001)(16526019)(6506007)(4326008)(478600001)(83380400001)(8936002)(66946007)(6666004)(55016002)(5660300002)(8676002)(2906002)(9686003)(6636002)(66476007)(7416002)(7696005)(52116002)(316002)(1076003)(66556008)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Fc+EJRER8/wxShLu+Wa1ddNEixpWPBbQGl5wTqrm76o82bAhK/C9wBr8N8fe?=
 =?us-ascii?Q?zjduXwEuxHQfXiM+gVoziIdeR11lEmXgsLT4K4T5Nl87zpPLEIDBhW4ssgKW?=
 =?us-ascii?Q?1wRGY5/72YPoJJNH6u2Iy4lJGdLZp5bu2xI70Y59y4urJFGbuITEYd+T07tY?=
 =?us-ascii?Q?XqFuG1xW0CCVoZXfc5yiDZ320TubeSPU7wOT9P7qs1ZyFxmkx77ELUu1CIWl?=
 =?us-ascii?Q?HwTx4cPGhjE59hCtDhFnj70nL/cXlOsJljdNN3LYwYBbCWCgqm1vYIyc1tq2?=
 =?us-ascii?Q?LlUAUJRTOL/u3jc7nBa0iGKYAa97nou728cGchxXaNbGF2zeMR0zgI/GQ9cD?=
 =?us-ascii?Q?y/iyIidwksNnjM36o7IUCYdRWosJ02YHFZZBFJgRJfU2vmK+BsAZZPzhbUdm?=
 =?us-ascii?Q?6IEuCw+mGiZxoP+20WM5SHidzkE+PxItQVh9Hljve0X6I4JabFodBdDSxgpL?=
 =?us-ascii?Q?VWB4nFGiIk98/lieNrTHvirfbaaImlQwvreQmtjr6p93IVuAwTGrPLPSwPsg?=
 =?us-ascii?Q?bLaWcsngvyNgCVQKwLipuxx8ws7IEEshfGnUcnGgbY8OvN9qjlLB17FN0uOx?=
 =?us-ascii?Q?zMoQP9xz4O7wY+McJWh+a7v9EqgyuUSY0jao6QzRbjaJK78e4Pz00LCIgKQ1?=
 =?us-ascii?Q?WW5DSRtEW2ZtfpBOZeOWXzdph49r2gYr3ptzO+rmWO0UB+eWXJYRlluApCIF?=
 =?us-ascii?Q?tcGnj9SmFlRq3HAmWoa6YVOl/ymqHkgzI9b6PXA9aIb8hdj+9NVtF43vv5wc?=
 =?us-ascii?Q?Ghg7ti0CMqHVNfN+U9XXE9/G6Y7yy1hvpn1/7APT9yia8dTbpyetVmBPQPfz?=
 =?us-ascii?Q?7p4wI9hHcyNLQAcpLpxNLGtuGRIjmILGDWK1Er2iIMQFqT0hXj1kiDgBcr8Y?=
 =?us-ascii?Q?TdYzQRNCxJZOb8aYea4+L7+hpXiYxyNmCj2Au2UIyrgK3YglOeP+MQPw266N?=
 =?us-ascii?Q?IKxQbtvlxRuMraFzZcUkpN8XAkIrK76Wz0QgABoli3Sop0y8Y1H6vxTCpKhg?=
 =?us-ascii?Q?L+g1U1iy+wb6bqNgrIaQrqV4yQ=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 18:56:57.2677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fb7c08d-53d4-415e-1f0d-08d8b662ab8b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g6NcQSd4NTg+DJ9Nc3Y5dtIMIgAuv6rsoQCK/UJFwBzvyKmOTS7WqJ332KXi1ZqO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3618
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_29:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 malwarescore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 impostorscore=0 clxscore=1011 mlxscore=0 priorityscore=1501 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110104
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 03:19:47PM -0800, Song Liu wrote:

[ ... ]

> diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
> index dd5aedee99e73..9bd47ad2b26f1 100644
> --- a/kernel/bpf/bpf_local_storage.c
> +++ b/kernel/bpf/bpf_local_storage.c
> @@ -140,17 +140,18 @@ static void __bpf_selem_unlink_storage(struct bpf_local_storage_elem *selem)
>  {
>  	struct bpf_local_storage *local_storage;
>  	bool free_local_storage = false;
> +	unsigned long flags;
>  
>  	if (unlikely(!selem_linked_to_storage(selem)))
>  		/* selem has already been unlinked from sk */
>  		return;
>  
>  	local_storage = rcu_dereference(selem->local_storage);
> -	raw_spin_lock_bh(&local_storage->lock);
> +	raw_spin_lock_irqsave(&local_storage->lock, flags);
It will be useful to have a few words in commit message on this change
for future reference purpose.

Please also remove the in_irq() check from bpf_sk_storage.c
to avoid confusion in the future.  It probably should
be in a separate patch.

[ ... ]

> diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.c
> index 4ef1959a78f27..f654b56907b69 100644
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 7425b3224891d..3d65c8ebfd594 100644
[ ... ]

> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -96,6 +96,7 @@
>  #include <linux/kasan.h>
>  #include <linux/scs.h>
>  #include <linux/io_uring.h>
> +#include <linux/bpf.h>
>  
>  #include <asm/pgalloc.h>
>  #include <linux/uaccess.h>
> @@ -734,6 +735,7 @@ void __put_task_struct(struct task_struct *tsk)
>  	cgroup_free(tsk);
>  	task_numa_free(tsk, true);
>  	security_task_free(tsk);
> +	bpf_task_storage_free(tsk);
>  	exit_creds(tsk);
If exit_creds() is traced by a bpf and this bpf is doing
bpf_task_storage_get(..., BPF_LOCAL_STORAGE_GET_F_CREATE),
new task storage will be created after bpf_task_storage_free().

I recalled there was an earlier discussion with KP and KP mentioned
BPF_LSM will not be called with a task that is going away.
It seems enabling bpf task storage in bpf tracing will break
this assumption and needs to be addressed?
