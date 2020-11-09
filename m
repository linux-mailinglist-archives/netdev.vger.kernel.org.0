Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FFE2AC7C4
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 22:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731892AbgKIVzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 16:55:46 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55332 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731769AbgKIVzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 16:55:45 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A9LrRlB001105;
        Mon, 9 Nov 2020 13:55:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=DAg0QU4BluOab9dYza01HM7cILiHMfIxaxbBiJTspG4=;
 b=eSxxBeiL8uNAwa2ZGBHMrJRByp1jIazMBud28txZZKwUPXqTd+RU+EGkNW0YGFaCfgmD
 cxClT3Wg/U9Xrlkuk8//o8kpOZGSH7WMmCPw9YJdeFseJmUcKgsFJ5O3qtqrMvIrc3P9
 QpGvQj541ZO9XNIvG2WNyhr4dTIHW/m+ox0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34nsyq9wey-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 09 Nov 2020 13:55:29 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 9 Nov 2020 13:55:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFm+IOs2AqNINiHmuzJPOchGGXchH6CCUZcXS5axlxyb7ZTuXQglzlWgaNOQtxAMnSpIm0tNy9Dy/0KtrZmQBppgJ2LPLR84rYbUIJevy5FR3EF3Y3Jb2AlpVkuMH4rjMbf7s/U3EZg78Zm77p9jSFeODTb3mZ9SotGNQlhF8vkTozDZr7ojDQ3tYrvREqeoopN5rS0brcla3AxoxIIC0aunz6tGJfQ4m1ciRE5AsEqX9jWTKfWa1TOZTIv0m85ABzFmq0JAyInnnNPimJJBaXXhb0L9jodwRBCmZsDqEK4k18oRSiuzY/hYERj+rW/ij6CJPH9xFgA5/XM7m+r02w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAg0QU4BluOab9dYza01HM7cILiHMfIxaxbBiJTspG4=;
 b=m5JhDs7k9Li+LLwPA0MwRU+/j/fRy/m6Sr5lnGk7VtvRxJwDLTCZKK8zAktsvUgZaveIxxniAmmRKKnQatt1IvmC1P82gyIk8No+Wk/OAtJNBDGSIPbhEPCx7SB3lr4c0JbkgCnLFzLceoZ60g4lpknFialgy1Qk6ObOXKlUf3FI0/GNI/cxQKjnIAlXrL2284URORTrw3+vQyZwTvTrrXlhUABZffG7DVRniamSfVxG/QhJE11UMapRTgmTFhh/QbrVZrIO2sEpPVCNaXUvQ5O6f/vmvQ/7asqUEygipMs8mTg2MFuwr6nKARcC+ZDK22MkRZKylmzdhzamSaki7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAg0QU4BluOab9dYza01HM7cILiHMfIxaxbBiJTspG4=;
 b=LKOQ+5429v/ORZj2dAP/2yHue+jqVV5/Jwskye96+LECOKl8dSu2zDGwskxRltXWS5Ek1gNUN18YhY1iT1dK8Y4b5I81ihB7kb6ycKtBtLDScDA/TTy8/n0dHQG1DgjSb8ODZpQ+wbY1czAw2F4+GXz7bVJDovqH5wTPpRq1DFM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3189.namprd15.prod.outlook.com (2603:10b6:a03:103::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.22; Mon, 9 Nov
 2020 21:55:26 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 21:55:26 +0000
Date:   Mon, 9 Nov 2020 13:55:18 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, <rafael@kernel.org>,
        <jeyu@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 bpf-next 2/5] bpf: assign ID to vmlinux BTF and return
 extra info for BTF in GET_OBJ_INFO
Message-ID: <20201109215518.jcqtsq7h7kni6w2w@kafai-mbp.dhcp.thefacebook.com>
References: <20201109210024.2024572-1-andrii@kernel.org>
 <20201109210024.2024572-3-andrii@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109210024.2024572-3-andrii@kernel.org>
X-Originating-IP: [2620:10d:c090:400::5:b389]
X-ClientProxiedBy: MW2PR16CA0058.namprd16.prod.outlook.com
 (2603:10b6:907:1::35) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:b389) by MW2PR16CA0058.namprd16.prod.outlook.com (2603:10b6:907:1::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25 via Frontend Transport; Mon, 9 Nov 2020 21:55:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95192e7f-0006-47e0-2eb0-08d884fa2a70
X-MS-TrafficTypeDiagnostic: BYAPR15MB3189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB31891FDD0C8707C20220528AD5EA0@BYAPR15MB3189.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vuL7gXQZSY2RJaWIV+KZTxvcBLs5n0LoaH7LPi5wuUXb7eKjWC/SbuGy+4wd4seySfnUx5lrZFQsJMBs30oSDGX2CghRBW5ryFjg+1xNGBHb+xguwMVi3pxEuVMSPZR5+LIbxa+wtUVeLc7qJ3apYnkKy+XK7qx5RvYMLQmBG1diHYxEkr4x0YyNL06IBG/K5TDngDg1fmclMHjElaizS4ze1fErJc8T5DjEo0ohMPf/mODvyOVhzAnX9xC2uBPg/ND61K9gDcQ1+kCT4E2v8QYYr1GcEGQJFVjGmWttdkqbvvmHU6kEDgkBRangZB20Mx/bdD0HD7lwCGO/ym6frw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(136003)(396003)(366004)(5660300002)(2906002)(66476007)(16526019)(186003)(6506007)(316002)(4326008)(66946007)(6666004)(86362001)(66556008)(54906003)(1076003)(83380400001)(6916009)(9686003)(8676002)(478600001)(8936002)(55016002)(7696005)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: o9UNaomXvem9zMMr+mKKRvXnr3yiKtQjx7RV5+YcM2E4Ykmv0j+fRzsOT7dCdkMreGzeWtauws0tM9Bs6XRN3zKKayXBuqnF6NJYRgDho3Mw67YDxb7qKO9jsJ2Th7r/VuTbXXArsNiEJl5ZAgLhAt3w+HxpLttaGe/W1Fx91fCsnS3cf5Rg5omMC9wmdqKPIM5jlYjKKekEqQecoYBVBDcUizAvIJwPTTFch1yavFXV1ssTfZ7BbolOFoIp61jka+LvIHP5dmHMYSevaznaQCJuZLlxujGv1MroyceWQu6WOgi6PW8NZaky+YfU7DJx57iiC3L2FCxmDMEnaLQew5aicyxl52iZWN4l6XiVRMNQp2SlWhyFx4M901XS4zMkV+PSi/bowHbQaEOmDA+3AW9h4bhNzQOAAXzwNn7JYRzC2PrU2xk3FzS9FGixS1zLNjDCGSmHLtY7A3VeoGCppQm0dYisK0IOYt8bAL+HJ2RtZDkWTHSMsGKVvMRxP/pLjrYCwTE/fGMLCesoucQvaDbCmKzn1D6eTOE6Lz4leQnGNh3Y59hyXgyi3Ub0ijMYOpQtyVaJkaDdlaYYINyhhrcrJr3oCVDSPgnNdwgdFtg9dTkwiA6a9wb4qfNjbAzzWiqzOumhQZtG9tReh0iTO6anis6DW3NrO/6jMmUOJgf3gOEvHEIq/0cMsEVDjlIjelzfxz3PjgHOzXto+OAtq8NwmuHJsbT2CFHng4+Kb6nq2xBjxtjK/HaksF/03knDKg/7b4SANW735o7HifNXS6Kh+zXc4KsewYI2vo7OCNRFuvheEt1va/GrL7z3KNZKzccAo6mMgUlo6DqCscFdC1HsgVcRbzfVOOBTfLuDQ9200Kc0AsyqHe2JU6Vq1+1k+eeSt7eyPr7hKXuZtGIM8R3ZC2KpMgLDfnFOy5wN4Ps=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95192e7f-0006-47e0-2eb0-08d884fa2a70
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 21:55:26.3879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0VfM+MaFu83jqgAsfsrZKUXmvoXCUOUf7Nsoj9YtDlt9kLf+5S60Ky8PqjzvS1Mq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3189
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-09_14:2020-11-05,2020-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 suspectscore=34 mlxlogscore=984 malwarescore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011090139
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 01:00:21PM -0800, Andrii Nakryiko wrote:
> Allocate ID for vmlinux BTF. This makes it visible when iterating over all BTF
> objects in the system. To allow distinguishing vmlinux BTF (and later kernel
> module BTF) from user-provided BTFs, expose extra kernel_btf flag, as well as
> BTF name ("vmlinux" for vmlinux BTF, will equal to module's name for module
> BTF).  We might want to later allow specifying BTF name for user-provided BTFs
> as well, if that makes sense. But currently this is reserved only for
> in-kernel BTFs.
> 
> Having in-kernel BTFs exposed IDs will allow to extend BPF APIs that require
> in-kernel BTF type with ability to specify BTF types from kernel modules, not
> just vmlinux BTF. This will be implemented in a follow up patch set for
> fentry/fexit/fmod_ret/lsm/etc.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  include/uapi/linux/bpf.h       |  3 +++
>  kernel/bpf/btf.c               | 39 ++++++++++++++++++++++++++++++++--
>  tools/include/uapi/linux/bpf.h |  3 +++
>  3 files changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 9879d6793e90..162999b12790 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4466,6 +4466,9 @@ struct bpf_btf_info {
>  	__aligned_u64 btf;
>  	__u32 btf_size;
>  	__u32 id;
> +	__aligned_u64 name;
> +	__u32 name_len;
> +	__u32 kernel_btf;
>  } __attribute__((aligned(8)));
>  
>  struct bpf_link_info {
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 894ee33f4c84..663c3fb4e614 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -215,6 +215,8 @@ struct btf {
>  	struct btf *base_btf;
>  	u32 start_id; /* first type ID in this BTF (0 for base BTF) */
>  	u32 start_str_off; /* first string offset (0 for base BTF) */
> +	char name[MODULE_NAME_LEN];
> +	bool kernel_btf;
>  };
>  
>  enum verifier_phase {
> @@ -4430,6 +4432,8 @@ struct btf *btf_parse_vmlinux(void)
>  
>  	btf->data = __start_BTF;
>  	btf->data_size = __stop_BTF - __start_BTF;
> +	btf->kernel_btf = true;
> +	snprintf(btf->name, sizeof(btf->name), "vmlinux");
>  
>  	err = btf_parse_hdr(env);
>  	if (err)
> @@ -4455,8 +4459,13 @@ struct btf *btf_parse_vmlinux(void)
>  
>  	bpf_struct_ops_init(btf, log);
>  
> -	btf_verifier_env_free(env);
>  	refcount_set(&btf->refcnt, 1);
> +
> +	err = btf_alloc_id(btf);
> +	if (err)
> +		goto errout;
> +
> +	btf_verifier_env_free(env);
>  	return btf;
>  
>  errout:
> @@ -5554,7 +5563,8 @@ int btf_get_info_by_fd(const struct btf *btf,
>  	struct bpf_btf_info info;
>  	u32 info_copy, btf_copy;
>  	void __user *ubtf;
> -	u32 uinfo_len;
> +	char __user *uname;
> +	u32 uinfo_len, uname_len, name_len;
>  
>  	uinfo = u64_to_user_ptr(attr->info.info);
>  	uinfo_len = attr->info.info_len;
> @@ -5571,6 +5581,31 @@ int btf_get_info_by_fd(const struct btf *btf,
>  		return -EFAULT;
>  	info.btf_size = btf->data_size;
>  
> +	info.kernel_btf = btf->kernel_btf;
> +
> +	uname = u64_to_user_ptr(info.name);
> +	uname_len = info.name_len;
> +	if (!uname ^ !uname_len)
> +		return -EINVAL;
> +
> +	name_len = strlen(btf->name);
> +	info.name_len = name_len;
> +
> +	if (uname) {
> +		if (uname_len >= name_len + 1) {
> +			if (copy_to_user(uname, btf->name, name_len + 1))
> +				return -EFAULT;
> +		} else {
> +			char zero = '\0';
> +
> +			if (copy_to_user(uname, btf->name, uname_len - 1))
> +				return -EFAULT;
> +			if (put_user(zero, uname + uname_len - 1))
> +				return -EFAULT;
> +			return -ENOSPC;
It should still do copy_to_user() even it will return -ENOSPC.

> +		}
> +	}
> +
>  	if (copy_to_user(uinfo, &info, info_copy) ||
>  	    put_user(info_copy, &uattr->info.info_len))
>  		return -EFAULT;
