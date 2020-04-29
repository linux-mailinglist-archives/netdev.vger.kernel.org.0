Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077B91BD13C
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 02:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgD2AiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 20:38:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31554 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726401AbgD2AiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 20:38:13 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T0Yu0G029025;
        Tue, 28 Apr 2020 17:37:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=RQUWgcNl9HJWoUgCLjnQHf66Ci4m6O33Q9wqrgBKIm0=;
 b=cMLspmCumPPVZiOej7CUYE8z2AFnJM8M79YLz9zB9uDbDUuGS6+NmyDVgyAgMuiuSjQP
 Vcgek3SNl90PGhbWFei9ibnXEb8Ddc0VD3J5KSnWwbxL2+zRceJ1GwXT3uQdhK/CuylS
 nyJqFRZf37wenjS6c/XExc1+WKZ9NzfdZk4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30nq53x184-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 17:37:59 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 17:37:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZsmiaklxOlRCPxyLFyIn/pMHnsQWDbt5K6snTh7Fq9G/+5ttJris2ZI8KmSuyYJmbEpe52RQ7Xxft6pniF/MBGCvk3tRuEswjvhUomisOJbrSan6QV87SnPm5HVtxawz0c+lrytcVc7543Y1bRG5WyjXtNJ2bfvP5QbihWPmjZExsqhVuGFMuE5sBrcr7rRY5mZsaN4y9LtoTHYXM6Q2SmSq6un2GlITuB+YHIdXNHKfBSbxGxGsYOGVPneMqgWR0tstn2bPSFpE0oekXPT9HozBaua/opqROzmJNnyVUT50FpB0yo+9negonQJP9O2kw7jsedkb1X54fuE74qfWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQUWgcNl9HJWoUgCLjnQHf66Ci4m6O33Q9wqrgBKIm0=;
 b=VgyV+4ajNM4juk4lKaVE49M4J34K/3KzoVqL0hOSfrp7VeK+Ay+HXROp07NhQRtgCJDZO4U6kJ7j+YyleMD1g/goB4L/RdeC6HbmVHtDUd6f0kDewWSNI8xUkOsKIZFgK+SA75FSxUurKpYE1DDHw6Uou7H2lNpTcBuf79hAlUO14VIISsD9Qk8Tp9+qcNWaJInM6i/xDiZu1akqDesg4jjpsNTA3cfHvgKOIYCtsITZ/Us5iEGmvvp9+uesvz7hxv4eyIQ/TFI0bpQDaz8VJAkURV9O3Vr7rTgBr8bnWyoJWmxWhR0bxOANZdMTBtw8NK2fuH2dybUXM9n9V7Qz5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQUWgcNl9HJWoUgCLjnQHf66Ci4m6O33Q9wqrgBKIm0=;
 b=Hv91rkawdYFmeUGZ1oYJ729BAAAfnGg7D7n8rKgAvrb2supYnO0QnYZ39+jj4Zcs2TA+LhGD/y6mzK+C/7zqC04dJh1V7FZZsJ33dNmN5voBaTMHW8yKqPq4pKxz7BYJ5DsvKJIT3qg4YJnSKl32aVj8+tJRH1I5TWxuCyGCKp4=
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3850.namprd15.prod.outlook.com (2603:10b6:303:42::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 00:37:41 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%5]) with mapi id 15.20.2937.026; Wed, 29 Apr 2020
 00:37:41 +0000
Date:   Tue, 28 Apr 2020 17:37:38 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v1 03/19] bpf: add bpf_map iterator
Message-ID: <20200429003738.pv4flhdaxpg66wiv@kafai-mbp>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201237.2994794-1-yhs@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427201237.2994794-1-yhs@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR10CA0002.namprd10.prod.outlook.com (2603:10b6:301::12)
 To MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:950c) by MWHPR10CA0002.namprd10.prod.outlook.com (2603:10b6:301::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 29 Apr 2020 00:37:40 +0000
X-Originating-IP: [2620:10d:c090:400::5:950c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2b45373-c9cb-4a82-349e-08d7ebd58600
X-MS-TrafficTypeDiagnostic: MW3PR15MB3850:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB38505DA60DB7B329E57B6B50D5AD0@MW3PR15MB3850.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(366004)(376002)(396003)(136003)(39850400004)(6636002)(2906002)(478600001)(9686003)(54906003)(8676002)(4326008)(316002)(8936002)(5660300002)(66556008)(86362001)(186003)(16526019)(66476007)(66946007)(52116002)(6862004)(1076003)(6496006)(55016002)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Do1Aau/4TL7S/Gvi4sIUzfhtVHsgD49C0s0qtvr5BMN5LoVW07y2xEmzZCU7fRnUacxLU0A0ikeVHJmaO7c2X9Ar+K/i+uxKc4hQiT/STJnvzYCBnPCRZvllmmgwkhY3yzCsfrME1/SfaaR8PEx2gh7/mHEhIsJmz6DtxXj7CPOKzAjZPA5PWLqMD71rPVxNNqNuXKYvQevwExJW5Rx0OP5Mv0qSpjX2EIgc0Z1aSJQU03iaZ6IfoeVgNqQ8gNnx5qQ4zJadp9tGm8Kia6TvK/fT1NBo4zLqMrf5IVvqs2r/Kw0URBV5pqfgCrDaVKCI3VKN5Rki3LDrdkgmYoa7Rg5mpNUxTMcbj4nHGSbDG9rez43Jwcvjh7UAX6hRqoR+mZ2PMxnglcA8OPeJeagNUEnDTeBdm/+WOCO5y+0iAmAJ+4xCvufFUFELXCR9sjVK
X-MS-Exchange-AntiSpam-MessageData: hK70BAEukgcDnzGJh3w2oFbMxX9rQMVJ5ftuAc5dhrRtQrBYVossFkwneeX5r2AnmxFLZ7WPrRxcpCt8hRKVGS0rQyKa3i/uJVOv8XDJpjTLHzDLWFtQpWNtl7BdKRpCHQdtN5h559Gl7Q4mTAkAGJNR6qTGws/auzcawudIxdflghI/AqiIyp6FiAXMguRaCcFHIwsT1W8w9BT8oETn7XhxgPi50xYZCK/ORzTdixBErpls0/cif/ZIFRUuiGcjdyXAGwnpJKccvqGaKMVSZAUbfLpd5UzmKVXXxVI/xjvbwgPYCa2uwVqfiw+6DfN3adv4XF/86EZhP0ZE3zsAq897ESvN82JHBDVutJWJbtu3nM5efT48QSMFPfIwSVn2Vn0P/8qhbFw8UuKiPC0TVJWHnm6T99Z45i6As+Q/CTMFBk6/q+EY1R8seqa+lOWOcOkLrvuabTobiP4fNRlY5sxI+9swDIpQ+w2YWxYYFOFRC1YJVWjxU5nUkODWKiuqhhzx8tatEt4S/jqx6z6IPKsjLFp8p0W6WD6x8UdjeBNs+pQmy9NEHkcCIMmq/OwqFFHPBLyVS1PEleiDpEHeFMtprTtDrKTXeh9bW6R5QWwhpidVNUzIByb3d+CItMYhaf3xY2R7b3YDg9bQiCQWakv4X/2unwRIcJTHHjw5YH92399sq3TlgpiVu445hjCrTM2RYiRBuuIym/D+fRIZsXJxpMcxz5UwQ4KDKpje8t3WylLtHKtE+m8Ue6+YnhGc09o40NhcYHOzDmknB8c0OBiv8H7xq2Qpb2jx9e8iDd1KTBmGJ535dRTGAMMSJhgI8E1rtOOvhUrrvTfv4ccBvA==
X-MS-Exchange-CrossTenant-Network-Message-Id: c2b45373-c9cb-4a82-349e-08d7ebd58600
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 00:37:41.2313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MycspAwa7MalMDPKkQMmIK6bwfXVMPHfc61BG5uuJ3nnFDV2lF7Jonet1ho2LSAZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3850
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 01:12:37PM -0700, Yonghong Song wrote:
> The bpf_map iterator is implemented.
> The bpf program is called at seq_ops show() and stop() functions.
> bpf_iter_get_prog() will retrieve bpf program and other
> parameters during seq_file object traversal. In show() function,
> bpf program will traverse every valid object, and in stop()
> function, bpf program will be called one more time after all
> objects are traversed.
> 
> The first member of the bpf context contains the meta data, namely,
> the seq_file, session_id and seq_num. Here, the session_id is
> a unique id for one specific seq_file session. The seq_num is
> the number of bpf prog invocations in the current session.
> The bpf_iter_get_prog(), which will be implemented in subsequent
> patches, will have more information on how meta data are computed.
> 
> The second member of the bpf context is a struct bpf_map pointer,
> which bpf program can examine.
> 
> The target implementation also provided the structure definition
> for bpf program and the function definition for verifier to
> verify the bpf program. Specifically for bpf_map iterator,
> the structure is "bpf_iter__bpf_map" andd the function is
> "__bpf_iter__bpf_map".
> 
> More targets will be implemented later, all of which will include
> the following, similar to bpf_map iterator:
>   - seq_ops() implementation
>   - function definition for verifier to verify the bpf program
>   - seq_file private data size
>   - additional target feature
> 
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h   |  10 ++++
>  kernel/bpf/Makefile   |   2 +-
>  kernel/bpf/bpf_iter.c |  19 ++++++++
>  kernel/bpf/map_iter.c | 107 ++++++++++++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c  |  13 +++++
>  5 files changed, 150 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/bpf/map_iter.c
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 5e56abc1e2f1..4ac8d61f7c3e 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1078,6 +1078,7 @@ int  generic_map_update_batch(struct bpf_map *map,
>  int  generic_map_delete_batch(struct bpf_map *map,
>  			      const union bpf_attr *attr,
>  			      union bpf_attr __user *uattr);
> +struct bpf_map *bpf_map_get_curr_or_next(u32 *id);
>  
>  extern int sysctl_unprivileged_bpf_disabled;
>  
> @@ -1118,7 +1119,16 @@ struct bpf_iter_reg {
>  	u32 target_feature;
>  };
>  
> +struct bpf_iter_meta {
> +	__bpf_md_ptr(struct seq_file *, seq);
> +	u64 session_id;
> +	u64 seq_num;
> +};
> +
>  int bpf_iter_reg_target(struct bpf_iter_reg *reg_info);
> +struct bpf_prog *bpf_iter_get_prog(struct seq_file *seq, u32 priv_data_size,
> +				   u64 *session_id, u64 *seq_num, bool is_last);
> +int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx);
>  
>  int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
>  int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 6a8b0febd3f6..b2b5eefc5254 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -2,7 +2,7 @@
>  obj-y := core.o
>  CFLAGS_core.o += $(call cc-disable-warning, override-init)
>  
> -obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o
> +obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o
>  obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
>  obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o
>  obj-$(CONFIG_BPF_SYSCALL) += disasm.o
> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> index 1115b978607a..284c95587803 100644
> --- a/kernel/bpf/bpf_iter.c
> +++ b/kernel/bpf/bpf_iter.c
> @@ -48,3 +48,22 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
>  
>  	return 0;
>  }
> +
> +struct bpf_prog *bpf_iter_get_prog(struct seq_file *seq, u32 priv_data_size,
> +				   u64 *session_id, u64 *seq_num, bool is_last)
> +{
> +	return NULL;
Can this patch be moved after this function is implemented?

> +}
> +
> +int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx)
> +{
> +	int ret;
> +
> +	migrate_disable();
> +	rcu_read_lock();
> +	ret = BPF_PROG_RUN(prog, ctx);
> +	rcu_read_unlock();
> +	migrate_enable();
> +
> +	return ret;
> +}
> diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
> new file mode 100644
> index 000000000000..bb3ad4c3bde5
> --- /dev/null
> +++ b/kernel/bpf/map_iter.c
> @@ -0,0 +1,107 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2020 Facebook */
> +#include <linux/bpf.h>
> +#include <linux/fs.h>
> +#include <linux/filter.h>
> +#include <linux/kernel.h>
> +
> +struct bpf_iter_seq_map_info {
> +	struct bpf_map *map;
> +	u32 id;
> +};
> +
> +static void *bpf_map_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	struct bpf_iter_seq_map_info *info = seq->private;
> +	struct bpf_map *map;
> +	u32 id = info->id;
> +
> +	map = bpf_map_get_curr_or_next(&id);
> +	if (IS_ERR_OR_NULL(map))
> +		return NULL;
> +
> +	++*pos;
Does pos always need to be incremented here?

> +	info->map = map;
> +	info->id = id;
> +	return map;
> +}
> +
> +static void *bpf_map_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +	struct bpf_iter_seq_map_info *info = seq->private;
> +	struct bpf_map *map;
> +
> +	++*pos;
> +	++info->id;
> +	map = bpf_map_get_curr_or_next(&info->id);
> +	if (IS_ERR_OR_NULL(map))
> +		return NULL;
> +
> +	bpf_map_put(info->map);
> +	info->map = map;
> +	return map;
> +}
> +
> +struct bpf_iter__bpf_map {
> +	__bpf_md_ptr(struct bpf_iter_meta *, meta);
> +	__bpf_md_ptr(struct bpf_map *, map);
> +};
> +
> +int __init __bpf_iter__bpf_map(struct bpf_iter_meta *meta, struct bpf_map *map)
> +{
> +	return 0;
> +}
> +
> +static int bpf_map_seq_show(struct seq_file *seq, void *v)
> +{
> +	struct bpf_iter_meta meta;
> +	struct bpf_iter__bpf_map ctx;
> +	struct bpf_prog *prog;
> +	int ret = 0;
> +
> +	ctx.meta = &meta;
> +	ctx.map = v;
> +	meta.seq = seq;
> +	prog = bpf_iter_get_prog(seq, sizeof(struct bpf_iter_seq_map_info),
> +				 &meta.session_id, &meta.seq_num,
> +				 v == (void *)0);
From looking at seq_file.c, when will show() be called with "v == NULL"?

> +	if (prog)
> +		ret = bpf_iter_run_prog(prog, &ctx);
> +
> +	return ret == 0 ? 0 : -EINVAL;
The verifier change in patch 4 should have ensured that prog
can only return 0?

> +}
> +
> +static void bpf_map_seq_stop(struct seq_file *seq, void *v)
> +{
> +	struct bpf_iter_seq_map_info *info = seq->private;
> +
> +	if (!v)
> +		bpf_map_seq_show(seq, v);
> +
> +	if (info->map) {
> +		bpf_map_put(info->map);
> +		info->map = NULL;
> +	}
> +}
> +
> +static const struct seq_operations bpf_map_seq_ops = {
> +	.start	= bpf_map_seq_start,
> +	.next	= bpf_map_seq_next,
> +	.stop	= bpf_map_seq_stop,
> +	.show	= bpf_map_seq_show,
> +};
> +
> +static int __init bpf_map_iter_init(void)
> +{
> +	struct bpf_iter_reg reg_info = {
> +		.target			= "bpf_map",
> +		.target_func_name	= "__bpf_iter__bpf_map",
> +		.seq_ops		= &bpf_map_seq_ops,
> +		.seq_priv_size		= sizeof(struct bpf_iter_seq_map_info),
> +		.target_feature		= 0,
> +	};
> +
> +	return bpf_iter_reg_target(&reg_info);
> +}
> +
> +late_initcall(bpf_map_iter_init);
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 7626b8024471..022187640943 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2800,6 +2800,19 @@ static int bpf_obj_get_next_id(const union bpf_attr *attr,
>  	return err;
>  }
>  
> +struct bpf_map *bpf_map_get_curr_or_next(u32 *id)
> +{
> +	struct bpf_map *map;
> +
> +	spin_lock_bh(&map_idr_lock);
> +	map = idr_get_next(&map_idr, id);
> +	if (map)
> +		map = __bpf_map_inc_not_zero(map, false);
nit. For the !map case, set "map = ERR_PTR(-ENOENT)" so that
the _OR_NULL() test is not needed.  It will be more consistent
with other error checking codes in syscall.c.

> +	spin_unlock_bh(&map_idr_lock);
> +
> +	return map;
> +}
> +
>  #define BPF_PROG_GET_FD_BY_ID_LAST_FIELD prog_id
>  
>  struct bpf_prog *bpf_prog_by_id(u32 id)
> -- 
> 2.24.1
> 
