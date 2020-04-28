Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0205F1BC4FC
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 18:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgD1QUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 12:20:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41780 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728035AbgD1QUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 12:20:49 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03SGILgF007779;
        Tue, 28 Apr 2020 09:20:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=V16Uh5Lm37u5f01O63n68o3P+PegMhL/RkmGfn9/iu4=;
 b=acv7V21WxBEhhgtwBwvd0j+dxzXBVxMrIIRTSXZku81DqtepM42cFH53iaDazA8QYY5n
 No1ilQ4la4NwQYJNJYQEgQhZgMxKRsw8kFENmcguXzSy6faRQfHCiIxpvVcn21dUbNDw
 8j/z8epI2Zad0YDycjZLXa9XTT3HWGEwSA8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30n54efugk-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 09:20:36 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 09:20:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VwrcGfkE98B/FMbazgvPEtp8ZQFGWUKmvDvgTHJNQRJpIptkmF7AlTW/6d7z4wFWNkGkFN8R1gsVlV6JqkViOEjAGODIuRDxIg8FNC+DhkdXQhkA6Mes1iFLWSf9s0DyyReTzUoich5o+FVZi0BbLCpu8fjprOYxVcgf1ZjP4btXF7g7r0MJvim4uWUBNMn+fV10tf/bdcSt04vcoi9XY8zz4gFlLhWRotQHo4a8xddX7Vxr98axXRn8nQ1dC0ulw8Fauvn5mBOxDhkMwEJncSTjCH02ek55MczCng1IkZLtGHK9/HCRHK8dN3YWsEQE+7d+sTGtB70T0sZNPN4aaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V16Uh5Lm37u5f01O63n68o3P+PegMhL/RkmGfn9/iu4=;
 b=FLq9cNXx19c7BeldWdeRqMekrgQxJrvn7N/CPLYMheBYiOoVIw4TSuMS0tFh0Gvw95YYoDYoawvmqxpSdzEaI14sf3op3fkplnm411OBj0iSeTa2AoPu4UCh+xjqO3IwzjorhBd+LlSP1YsqXDPyjcowU1n/xYFgoF4tcvH2wG/cTF7jNBJ/i25Jpl9J4ATsgHwN0E9N+ynLQMCYhSXB+yzsEdCtRGNMz3B7QS8aZm0Yu7bEMtxKEKoS0MzCb8Fl2Z0eIRbkRBVEwCbxw3MCxPnRYfeKVkfVMwB8TlvvJ+f3qZXsTAXoiOF5gUFYgTndBrLDJAE3tHUHti/kfdJ6KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V16Uh5Lm37u5f01O63n68o3P+PegMhL/RkmGfn9/iu4=;
 b=dp1n7vheEb0sTddUWy0ZlG5E2OWVkKWpojhsGIcjb98B17HwOCyPfGULv2W2CBBfJw118x2nwyGYTnPEfzvqbj8222Nq4I/kEHJesiMdo2+CdrMv8ivg0Sn/HPXxmw7u9Kv//vX4NCzbK2R/I9rpEPNR+Nvyihou4y56JC4EXFA=
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3931.namprd15.prod.outlook.com (2603:10b6:303:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Tue, 28 Apr
 2020 16:20:30 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%5]) with mapi id 15.20.2937.026; Tue, 28 Apr 2020
 16:20:30 +0000
Date:   Tue, 28 Apr 2020 09:20:24 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v1 02/19] bpf: implement an interface to
 register bpf_iter targets
Message-ID: <20200428162024.72iaga3a63hizctg@kafai-mbp>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201236.2994722-1-yhs@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427201236.2994722-1-yhs@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR12CA0050.namprd12.prod.outlook.com
 (2603:10b6:300:103::12) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:c5c5) by MWHPR12CA0050.namprd12.prod.outlook.com (2603:10b6:300:103::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Tue, 28 Apr 2020 16:20:29 +0000
X-Originating-IP: [2620:10d:c090:400::5:c5c5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81727f05-2a02-47e1-e516-08d7eb90117f
X-MS-TrafficTypeDiagnostic: MW3PR15MB3931:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB39315B6847E5FE6F3F47BBA2D5AC0@MW3PR15MB3931.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(346002)(396003)(136003)(376002)(366004)(86362001)(16526019)(81156014)(2906002)(55016002)(9686003)(8676002)(186003)(316002)(54906003)(4326008)(6666004)(52116002)(8936002)(6496006)(66476007)(478600001)(5660300002)(66556008)(1076003)(6862004)(6636002)(33716001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7lW88MiFLQ8yoNglNTIsic0/CYC9X7+OpAb/hxKJm+vzegIXJW/PmGvrqtE7WRs7moHrli/bnV/Vf40yUZkfUGifi4nFcm+zDumjvVd/qdAmLshkrzO0P70OKDlLGNcFKQeX1zDqBz8DyRkVRLzbxxYGCUh1WNqx1TxLPHuiYkmbgg8ITc6vPaqnfng9Efeqz1kApagNEjCGbnH8lCNS/bcmNfOq9oigPFh4oEmev/DIQlg30SNjv5YcrHv9H87nRZCpx3Z6PJp+4NaF3LCbo5wHYzlHYu7TctH4kJnH9XTgEM0NLEQ3bGjOVph2poG5tlP9SygR68gloyqdgqzOAfh2baiipBCBKTQ8iiaKUzL36EiIA3whmMTlMQd038SI0x5kffUCMW8oCJLQ7oypQukVS51o1viytFm82wrnIeh7Rjpi6FkeTtF6ZVNShEuP
X-MS-Exchange-AntiSpam-MessageData: 9RNIQzOpZRNH9rycF/hGokwJm7dnIic1+YseQQoXU7F0BuqkBcsCUpkbz8to7AZt1xz96G6zNfgDnS1CK4IccHWt5DowX/9R/b/3AaGAU8FRdvdgKhA/4yg+om9MRzQoW5/0Ob0hjPJZFvdsl4XfCVqqswVDwX4I6j0WPonGYX3m86RKFm2LjSkm5ppdXI98LF/gqWeg+yXyrPHkNrHPzXf5LPK9xf76Np7hH+RdhBlPII9Awh5j1ub91f/bDH9j7DnOvTu6Bhe0L/iFTJtR11WKbUtRkAzNj733ky/yA1PSU/2SsE1bkXBe5GaA1Je9+mu9qhcoPJEmZEMW7yysUK4HrA6FFc2aMG+k1SMCCT4sGK+Q4RIfL+craYdVPFKikgOqc78Wp0MyCS59CZAVhikvz36iYay+lOXLinJjUhw8M7IoQDDeJ1j2Swwn7vsWja8+f6bT/yonsB30IqUfRvOCYNwd0Lqo8YhS2tzpika7CjCzZsSe8W/ktpNvBSTzeJ5EEl8kjQk64dZ2KpPG3M9iZtpXUnyp5lIFi1iQ3uw8u8HvZJopWxBTMxqfic1n6djkWuVp/3U8ZgUoiijNvqqA5lDn969JirFwMw9ItnjgPgXmN9mAHm0yRIw5xlUWqx1i/uT8YxKb37dBZri4cjGtDCq5RklgFmd/s9qL/7CxuMmiI/mlEcwleXGzvttEb9eccEnSTKDVn/s3jo+nqDLPEM79+XlFHbyut92qZ1eFFTxP7Nc4ddINAdLNPgzYTrmhF1qUfNYZV/v7KGsrKuSqjPAaPcSavyZR4h/wBCURRCYU/vpRpfaSAwQsEH/OK8wuTMVvRW4XBdss2jeMWQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 81727f05-2a02-47e1-e516-08d7eb90117f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 16:20:30.2814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z0M5H/fXsj//0/TkItQJ2R6d52qRVODLmGEiFJlXz35JiISaSItO4FrWEUsc7I0B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3931
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_11:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004280128
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 01:12:36PM -0700, Yonghong Song wrote:
> The target can call bpf_iter_reg_target() to register itself.
> The needed information:
>   target:           target name, reprsented as a directory hierarchy
>   target_func_name: the kernel func name used by verifier to
>                     verify bpf programs
>   seq_ops:          the seq_file operations for the target
>   seq_priv_size:    the private_data size needed by the seq_file
>                     operations
>   target_feature:   certain feature requested by the target for
>                     bpf_iter to prepare for seq_file operations.
> 
> A little bit more explanations on the target name and target_feature.
> For example, the target name can be "bpf_map", "task", "task/file",
> which represents iterating all bpf_map's, all tasks, or all files
> of all tasks.
> 
> The target feature is mostly for reusing existing seq_file operations.
> For example, /proc/net/{tcp6, ipv6_route, netlink, ...} seq_file private
> data contains a reference to net namespace. When bpf_iter tries to
> reuse the same seq_ops, its seq_file private data need the net namespace
> setup properly too. In this case, the bpf_iter infrastructure can help
> set up properly before doing seq_file operations.
> 
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h   | 11 ++++++++++
>  kernel/bpf/Makefile   |  2 +-
>  kernel/bpf/bpf_iter.c | 50 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 62 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/bpf/bpf_iter.c
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 10960cfabea4..5e56abc1e2f1 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -31,6 +31,7 @@ struct seq_file;
>  struct btf;
>  struct btf_type;
>  struct exception_table_entry;
> +struct seq_operations;
>  
>  extern struct idr btf_idr;
>  extern spinlock_t btf_idr_lock;
> @@ -1109,6 +1110,16 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
>  int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
>  int bpf_obj_get_user(const char __user *pathname, int flags);
>  
> +struct bpf_iter_reg {
> +	const char *target;
> +	const char *target_func_name;
> +	const struct seq_operations *seq_ops;
> +	u32 seq_priv_size;
> +	u32 target_feature;
> +};
> +
> +int bpf_iter_reg_target(struct bpf_iter_reg *reg_info);
> +
>  int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
>  int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
>  int bpf_percpu_hash_update(struct bpf_map *map, void *key, void *value,
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index f2d7be596966..6a8b0febd3f6 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -2,7 +2,7 @@
>  obj-y := core.o
>  CFLAGS_core.o += $(call cc-disable-warning, override-init)
>  
> -obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o
> +obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o
>  obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
>  obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o
>  obj-$(CONFIG_BPF_SYSCALL) += disasm.o
> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> new file mode 100644
> index 000000000000..1115b978607a
> --- /dev/null
> +++ b/kernel/bpf/bpf_iter.c
> @@ -0,0 +1,50 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2020 Facebook */
> +
> +#include <linux/fs.h>
> +#include <linux/filter.h>
> +#include <linux/bpf.h>
> +
> +struct bpf_iter_target_info {
> +	struct list_head list;
> +	const char *target;
> +	const char *target_func_name;
> +	const struct seq_operations *seq_ops;
> +	u32 seq_priv_size;
> +	u32 target_feature;
> +};
> +
> +static struct list_head targets;
> +static struct mutex targets_mutex;
> +static bool bpf_iter_inited = false;
The "!bpf_iter_inited" test below is racy.

LIST_HEAD_INIT and DEFINE_MUTEX can be used instead.

> +
> +int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
> +{
> +	struct bpf_iter_target_info *tinfo;
> +
> +	/* The earliest bpf_iter_reg_target() is called at init time
> +	 * where the bpf_iter registration is serialized.
> +	 */
> +	if (!bpf_iter_inited) {
> +		INIT_LIST_HEAD(&targets);
> +		mutex_init(&targets_mutex);
> +		bpf_iter_inited = true;
> +	}
