Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0225C1710EA
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 07:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbgB0G1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 01:27:17 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8210 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbgB0G1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 01:27:17 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01R6Q89k014273;
        Wed, 26 Feb 2020 22:27:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=qNNa6MyGwBKaZcYQYKrBFpqIKmqoJYJJc9/3PcaOBl8=;
 b=M6eztt42DoBPO7wqTSwdT+u0O0pbCqmW821FEDUtTPWjG5O+kCU0+0qQ5T/iK32l12QG
 ttunhXKw4XAsPKrAGy+WrzBfYZtDNOiKdCFuDP0uE3d0srZ4ZyleZUANHDetz0Lh3hJJ
 ygzAV5M+jegGdFuwXkgHQs0ujNh0qy5EqLE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2ydcn7fbyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 26 Feb 2020 22:27:02 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 26 Feb 2020 22:27:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FV/NOA1HYwptd00ze15GPyUXNZu4TZPyR9brznM36pt5YIip87EKnOS2zWHTm1bAThUOlxbfTDfu6goKlwgAiVG8djwDlS5eUhIyCeaxKyrc6A70k+ZK1y9pDg1RA2abIENa5CM7WPGOjVPY4y9G4s2O1XEFgYEAk8jp7ZOoWBmnbhvKA+68w4OYgNi10On7UgGnyp7fKRetkC1+CUXd28IkPaVabUoI3vCX1vUfnIRVkPQodJWtZW9pzI4wXIi8KfwZNHQEWkoF8PEjXWSgsb7ZxQP/flLGvKo6Yknm73b9ti8SXLNKjSVzu4g8ihHXXw2w1AOHVqsvyh3GScIMMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qNNa6MyGwBKaZcYQYKrBFpqIKmqoJYJJc9/3PcaOBl8=;
 b=TBh5zXJRtmIcJD3JPThXa2EK3TiA0vfRM7JLcve9kFDTuFP7KmdijXzc5OWUGotahCELoOqMN4DuYlvZu4QHet+BTxsI0EeIMhABFGRJEYok9/7195j/5wpqC+L/uCaetKS5JDTHA5gDyS99J1jwP/fmon3M4LogGmjUnhbQCr6Lxi5gxRdN/A1Jhw6twiHc56blnhVJCoub0uV8duRP0NNjnkJkdsGoNNUGmBdb35k/zG8E7Bf0rvR2+Ndq9HPwRBmG3yIVROK7HUbhTSJCwT/hpVO7bIECTWz1hk7YoOKuxfF0dpnDeGmyuPDhK6jZvDa27uWahfLKOxTpVEG6Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qNNa6MyGwBKaZcYQYKrBFpqIKmqoJYJJc9/3PcaOBl8=;
 b=ZZqqk1kvaUDeGCAxJja/MsV19gti1LloBNHGjP7MCaw7BcUM+ZGPRR1TnLPBn7FrK/yqs3UhY9ZL+Qi6W99WR/vo2i3PG9W0l4IjvwhWVzSZc8avCUBLLNt+vcvDq+5espYOSIYGxrpDxtw/AKzNSMk1IXVoi6SsktuMLuHPGWU=
Received: from DM6PR15MB2283.namprd15.prod.outlook.com (2603:10b6:5:88::22) by
 DM6PR15MB2697.namprd15.prod.outlook.com (2603:10b6:5:1aa::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Thu, 27 Feb 2020 06:26:45 +0000
Received: from DM6PR15MB2283.namprd15.prod.outlook.com
 ([fe80::bde9:ede5:309d:954a]) by DM6PR15MB2283.namprd15.prod.outlook.com
 ([fe80::bde9:ede5:309d:954a%4]) with mapi id 15.20.2750.021; Thu, 27 Feb 2020
 06:26:45 +0000
Date:   Wed, 26 Feb 2020 22:26:40 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jiri Olsa <jolsa@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 12/18] bpf: Add trampolines to kallsyms
Message-ID: <20200227062640.4srlnkxvtw34jml7@kafai-mbp>
References: <20200226130345.209469-1-jolsa@kernel.org>
 <20200226130345.209469-13-jolsa@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226130345.209469-13-jolsa@kernel.org>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR22CA0053.namprd22.prod.outlook.com
 (2603:10b6:300:12a::15) To DM6PR15MB2283.namprd15.prod.outlook.com
 (2603:10b6:5:88::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:d7c1) by MWHPR22CA0053.namprd22.prod.outlook.com (2603:10b6:300:12a::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Thu, 27 Feb 2020 06:26:43 +0000
X-Originating-IP: [2620:10d:c090:400::5:d7c1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7812155-9608-4f21-674c-08d7bb4e03e5
X-MS-TrafficTypeDiagnostic: DM6PR15MB2697:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB26976DC88B291FDFA9C24006D5EB0@DM6PR15MB2697.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 03264AEA72
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(136003)(366004)(376002)(39860400002)(346002)(199004)(189003)(316002)(5660300002)(186003)(7416002)(66946007)(66476007)(2906002)(16526019)(86362001)(478600001)(66556008)(81156014)(4326008)(6496006)(54906003)(6916009)(52116002)(8936002)(33716001)(81166006)(1076003)(9686003)(55016002)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2697;H:DM6PR15MB2283.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g32te7rnMC54R2kgOr4lWeOu3qSwAzO+qowqI23U6d/3PDEunw4nyd/cBL+zMpYTIUjTxjs3ktSRXpSyhdOlnqKSJH7w3yWyTLJfempkRJx4PeJSe0yil+DbgGJUpbBvWCIfZ2szMfk5ztlYgN8WkMmqksQSagij3hbPTeDUB7SyBHeVESJMa9Y/BOV1F/Kr5bEFvEjJpXK4jSdUWIYC8Um3VeA3iy+NRbEZgeDpuhuOOJKmbiWZoZFTaprhvO7HaS6dQ1t1yo/slH99n/g3ABTnH7I+DSsWizt9meolvjVA+Qo6Rs9EB+RqwIM3CQ2yZIVNRQjss6Fira0BDmLhmqjEi4B1I6LcfShPN1qc5PZMDvKvKjOgmAvu1m08x4yBWI6boO74iP0Tc7OB8OLV/HSdNZNAAQwUORN/Vdnb/WjmjAeh9jzvrSGy5cTuPbe2
X-MS-Exchange-AntiSpam-MessageData: Pbf6pyhaPMHOEjpxuCCAOXw3mRPFqQYHyjglnGiqcph6Fg6RCSRyHNk63fPow0fjov4q/dmr0dd6iZQhnPZgekMxzv6nSfji11AihIG8NrvYQUbLsxXP2i7ZWHdwRGr47/0U61lW/frLbXYCU6QzI18SeZ+0Kls08N+bRBASHKBFNKffGFutJg6U1IupBHbD
X-MS-Exchange-CrossTenant-Network-Message-Id: b7812155-9608-4f21-674c-08d7bb4e03e5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2020 06:26:45.3137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fRkgscWQCp3Y83YvbKvEw0feG+Mht6WOemYrDl/lP68l4R8lCcOFLCOvxWIBGT3U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2697
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_01:2020-02-26,2020-02-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 adultscore=0 spamscore=0 mlxlogscore=999 clxscore=1011
 lowpriorityscore=0 bulkscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002270050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 02:03:39PM +0100, Jiri Olsa wrote:
> Adding trampolines to kallsyms. It's displayed as
>   bpf_trampoline_<ID> [bpf]
> 
> where ID is the BTF id of the trampoline function.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf.h     |  3 +++
>  kernel/bpf/trampoline.c | 38 +++++++++++++++++++++++++++++++++++++-
>  2 files changed, 40 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 76934893bccf..c216af89254f 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -502,6 +502,7 @@ struct bpf_trampoline {
>  	/* Executable image of trampoline */
>  	void *image;
>  	u64 selector;
> +	struct bpf_ksym ksym;
>  };
>  
>  #define BPF_DISPATCHER_MAX 48 /* Fits in 2048B */
> @@ -573,6 +574,8 @@ struct bpf_image {
>  #define BPF_IMAGE_SIZE (PAGE_SIZE - sizeof(struct bpf_image))
>  bool is_bpf_image_address(unsigned long address);
>  void *bpf_image_alloc(void);
> +void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym);
> +void bpf_image_ksym_del(struct bpf_ksym *ksym);
>  /* Called only from code, so there's no need for stubs. */
>  void bpf_ksym_add(struct bpf_ksym *ksym);
>  void bpf_ksym_del(struct bpf_ksym *ksym);
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 6b264a92064b..4b0ae976a6eb 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -5,6 +5,7 @@
>  #include <linux/filter.h>
>  #include <linux/ftrace.h>
>  #include <linux/rbtree_latch.h>
> +#include <linux/perf_event.h>
>  
>  /* dummy _ops. The verifier will operate on target program's ops. */
>  const struct bpf_verifier_ops bpf_extension_verifier_ops = {
> @@ -96,6 +97,22 @@ bool is_bpf_image_address(unsigned long addr)
>  	return ret;
>  }
>  
> +void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym)
> +{
> +	ksym->start = (unsigned long) data;
> +	ksym->end = ksym->start + BPF_IMAGE_SIZE;
> +	bpf_ksym_add(ksym);
> +	perf_event_ksymbol(PERF_RECORD_KSYMBOL_TYPE_BPF, ksym->start,
> +			   BPF_IMAGE_SIZE, false, ksym->name);
> +}
> +
> +void bpf_image_ksym_del(struct bpf_ksym *ksym)
> +{
> +	bpf_ksym_del(ksym);
> +	perf_event_ksymbol(PERF_RECORD_KSYMBOL_TYPE_BPF, ksym->start,
> +			   BPF_IMAGE_SIZE, true, ksym->name);
> +}
> +
>  struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
>  {
>  	struct bpf_trampoline *tr;
> @@ -131,6 +148,7 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
>  	for (i = 0; i < BPF_TRAMP_MAX; i++)
>  		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
>  	tr->image = image;
> +	INIT_LIST_HEAD_RCU(&tr->ksym.lnode);
>  out:
>  	mutex_unlock(&trampoline_mutex);
>  	return tr;
> @@ -267,6 +285,14 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(enum bpf_attach_type t)
>  	}
>  }
>  
> +static void bpf_trampoline_ksym_add(struct bpf_trampoline *tr)
> +{
> +	struct bpf_ksym *ksym = &tr->ksym;
> +
> +	snprintf(ksym->name, KSYM_NAME_LEN, "bpf_trampoline_%llu", tr->key);
Do you have plan to support struct_ops which is also using
trampoline (in bpf_struct_ops_map_update_elem())?
Any idea on the name? bpf_struct_ops_<map_id>? 

> +	bpf_image_ksym_add(tr->image, ksym);
> +}
> +
