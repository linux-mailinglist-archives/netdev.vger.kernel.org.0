Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652C241CB62
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 19:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345594AbhI2R63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 13:58:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64698 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245152AbhI2R62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 13:58:28 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18THeTF6024051;
        Wed, 29 Sep 2021 10:56:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=9FdTLOwU1Oz5jYEG2qDmpNkB64HPm+O39f6lvffLXFI=;
 b=XtsYr4FK9XLMi0o2yua5oZutfzN7SFFDiDGzZXGBrEP3COtU6sFgfSVivuON48frEG4t
 tbx5a5rKGyt/riG/4Y246E8SnSHKY6VVF0U1soW5m1rJZJshVB3m9ykqFL55YAe8Nmzr
 GMRUmALkdu9zB00os0PQGfcD5Ywg6/66p0o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bcvrh83te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Sep 2021 10:56:26 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 29 Sep 2021 10:56:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eNomr+FNMB5kRytc31Da6ztk27Y/ZZJ6BamoNhD3+D+jCnlRDbkAZmnejZ0DRvd8ECQ+vi2OaWirGOg93bUQeZCatOQTRUsrHS+4ZLFxgo50x37Sjyp3yZzKidj+F9nue3upz/gEH7hpyIq3Tyqv9itDwGid6E7vB7NeItHnnuEe6Eq4oQ/Q/1jTikaaSP+NeqVQMCWYx0j7BgMQGtuyrN7HHDE3OitPr8dsIkZdXmqCD/cv9T60U9YtT/PVVR9mnn2ZWdRb4ALLuqjAsz5sFZYc7fjdXVe+9RMLOIMWk5mzvW5Z6c1ywimlfSbr6kF33lxFpo6cYCrZQftX+CjSYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9FdTLOwU1Oz5jYEG2qDmpNkB64HPm+O39f6lvffLXFI=;
 b=Ye45BE0lzgVsQ1ddm/eeX5UsrZl4Y/XTVkaNi/CBk2CrRdrev0AFyXm5pFYJ0kDx7I3BWZ174Bxx1Mxh7PyuwTDHo0el5hjCf2/ULUTxyRUc7x1k1dXK3fzptVL8+PeGaw7KsfJnf0yHbGcs0vqiRyAu0J244jCa35OhrOCu7qBxdr8hBHp+DacnWDt0vKeQC0rLcW3tNYbo0LLxo3pq9hW5HdlTNFG1wTMISjzYpXB4IFM93Ul9wSjG/7SGHY5UtxhhnRroxm9BUoSJ5O96WIHfER0wRR05S/JDpvYU8DSP+IZ+lItdKEaXbBJ6zHVoqrP1WVTO7Ur5VCaqErDn5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA0PR15MB3901.namprd15.prod.outlook.com (2603:10b6:806:8f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Wed, 29 Sep
 2021 17:56:24 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%6]) with mapi id 15.20.4566.015; Wed, 29 Sep 2021
 17:56:24 +0000
Date:   Wed, 29 Sep 2021 10:56:20 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hou Tao <houtao1@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/5] bpf: factor out a helper to prepare
 trampoline for struct_ops prog
Message-ID: <20210929175620.yi4jfpllhugys6eo@kafai-mbp.dhcp.thefacebook.com>
References: <20210928025228.88673-1-houtao1@huawei.com>
 <20210928025228.88673-3-houtao1@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210928025228.88673-3-houtao1@huawei.com>
X-ClientProxiedBy: SJ0PR03CA0210.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::35) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:d4e0) by SJ0PR03CA0210.namprd03.prod.outlook.com (2603:10b6:a03:2ef::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Wed, 29 Sep 2021 17:56:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bd87695-b79e-4d60-a329-08d9837273bb
X-MS-TrafficTypeDiagnostic: SA0PR15MB3901:
X-Microsoft-Antispam-PRVS: <SA0PR15MB39013E2B2FB4116C0FBACD24D5A99@SA0PR15MB3901.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:580;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H0nDjqEADQy0O1sQaTbbyRfgtxKaLn7zjRKO7xQXxsvOyhiEPaSnC6AsZ7tDiAfAmW+JAyfLbR1j81fpHbKZ0q6oQxBK1/vCEbhom5iykVKXPyHq7m4NseHBbP1V+HgAYzKvnVm5bLCeA0STvxb/Mm4nvv1BjrF6KJctONKh5bxiO9AbTanU7huezeWYLSE7uZc1K8scZOQyJS6IQxwGZ6Z2xjPpgQjP79yoGBAfDZGf0Pe62GHhc8EbVwkDzfK2NeC+j1BO0ri67rM59xOFtoFTik4b5eA5tweGzmE6lKQqCTLkVBom7417QaLkwdHl7JFb29SYuB+35HUPlo2C8CO6VQS6XM8vI1Jt5BjZiuHyWLTvy3YrhwvTySRonFH1jLNNH/+8eVc7M9zZwYOt42Y1Dp+9nUVXDvHFy/eQfuXLCaoiO0VBzra2s8VeD1AyRaS8BNHoxCBiSPqUOq0vQ3mb4IH1Df0Kyldru1jGT+SSxjWkoPjlWYacC5OYxRa9feiDO8XRWDfVteWjqkyZfHqzqlcnqSLElMXqZxL7PPLFFkSNrHZi8K/ZRR1hMWzf5e4s1liEerb+yMOHTlLgD9Bza+IHFDgv/MK2ZAZ7MQouYvMMgluHb/UBS6gfw2V47GUnT/zn+FZ8LMfowp9kLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(86362001)(508600001)(1076003)(316002)(9686003)(52116002)(66556008)(66476007)(7696005)(186003)(5660300002)(8676002)(54906003)(2906002)(38100700002)(8936002)(6916009)(55016002)(6506007)(4326008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ki3XS5TVkpTP0W1gBYnOgqiJm0uXirKjF/7x5PileM4UOoFzi8+6AZVEHIeY?=
 =?us-ascii?Q?+Bv0v+q5HMl8pYD0Mqf8PDzK86U7ecyL6DuDXCdP7bsETpHoVqTit4WtqOwa?=
 =?us-ascii?Q?T2Ef4loA6Lb5m0UkHRXsBAu4bhovhQCiqHpSyvvldS+KYFv00bJjXtF8Nmwr?=
 =?us-ascii?Q?yCA/zTQIwbRT2iUjIdRXsMuoIdfaVvp87a6qMABodkuIVkMl5mkzoJcB+DGI?=
 =?us-ascii?Q?9+WLJvfbQKuOfKUAvs6ZuscCvXP03o9qbDywy971YXUpSJy75POwabJq1DAu?=
 =?us-ascii?Q?B/7v/gXsdNfWfhiH2xi1sYlYqBlxoWQaGA9znQEUHWRU/v9GyN761y9aB1v3?=
 =?us-ascii?Q?WPMBWkXqDmwyNLfgPMf9hs4wfm6jq/aXEzPDZL+KfdO9vzUkR5sYTG1ZdMIQ?=
 =?us-ascii?Q?Xs9G/UPW6xhHcMDl25cVNGdQr4PlupG0OaNcgnDZU/4Nz9LORlm3nYp4urgM?=
 =?us-ascii?Q?vKMP0e1jsh4md4aTOINcLZVnwS4h3BkRZperpeZVIcIh2bVoFHvOi7FKx7aZ?=
 =?us-ascii?Q?V1uWiPVPP5wtEIrPi6aWY2wEJdQoZgMEhnbMu7D5m8WCD1NCRhZyTxxgjD7K?=
 =?us-ascii?Q?ziKY0TYSqK/r80P6kKkALQ5FXSka//o0DupikHWNMY+e6P66kgEfjLN+whNO?=
 =?us-ascii?Q?BaMu2QePVDMf7ZoCWXqYqFbtCQq5pllWp0ydmVK/xsWUjX9ZPP3bwkuhHAHe?=
 =?us-ascii?Q?cSocfKJog08sfh3Z10l8Md0qZ/1+A4ObUPbIoYffF1yG5Im/ZKAh9ns4OepK?=
 =?us-ascii?Q?OIuJfdOwUVv3Dntko9quhUdHBbzu2DddFzbJK8srD3J28niDsI0SLtDM7fvC?=
 =?us-ascii?Q?qX6mB3YhYKdfk+z/o5XDi2de9J5rdZMJYuXP726keXVL/s+LtaPaoJkMYo/z?=
 =?us-ascii?Q?g0NMECrNdBEXQmy6KCn11tmzY6ZaNJCwuHftuYgLV8QEefwuVtbfjUatG+Lz?=
 =?us-ascii?Q?vZtmj4lk22B9T9qvUaxv461Nsl2W0s+f2rSvequlfEWYGrnnvVmIms+dG3Wt?=
 =?us-ascii?Q?PMMq14hwddcdN8ufMqxUa4NsL/skf1z2Bs11IBsxvm3viq7sF4C5Se7GHd9v?=
 =?us-ascii?Q?9vB/N0S6A6s3om4Jl/WsGA2scTPbcKaRj22i+MfsBfUt2iPaz7DKrnvbln5Q?=
 =?us-ascii?Q?kBX3gZIqkuCHTmlh6z3pfMC+V2mvrsOhYBWnxaINh77VwaEhh2E/x3FCoGiZ?=
 =?us-ascii?Q?KvW3JDk0cEYF7HCjVj5M0QoaQd5mDN7hHrXiVPrXdUGq8aOOpHBj988r1I+c?=
 =?us-ascii?Q?b67bjUn5EWsMGJDITq5fvwV6FBYj7Yh0oRStLz5TIQXZ1JxGvXrvXB6J0oHD?=
 =?us-ascii?Q?b/uUyCMZg6DI3ciYp5365hCGfpbdwzWB4tp2HSUT+Tpf8Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bd87695-b79e-4d60-a329-08d9837273bb
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 17:56:24.2426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y/meUo3eKENU6RGbAYgVlPopb25yQ1iQqV3scRm4Wn1HZ58Y00ifVspF31GfVUEb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3901
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: W-eZ8d4Ruqo8IO3l2ET9-pFXz215VHej
X-Proofpoint-ORIG-GUID: W-eZ8d4Ruqo8IO3l2ET9-pFXz215VHej
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_07,2021-09-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 mlxlogscore=707 phishscore=0 lowpriorityscore=0 impostorscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290103
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 10:52:25AM +0800, Hou Tao wrote:
> Factor out a helper bpf_prepare_st_ops_prog() to prepare trampoline
> for BPF_PROG_TYPE_STRUCT_OPS prog. It will be used by .test_run
> callback in following patch.
Thanks for the patches.

This preparation change should be the first patch instead.

> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 155dfcfb8923..002bbb2c8bc7 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -2224,4 +2224,9 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
>  			u32 **bin_buf, u32 num_args);
>  void bpf_bprintf_cleanup(void);
>  
> +int bpf_prepare_st_ops_prog(struct bpf_tramp_progs *tprogs,
> +			    struct bpf_prog *prog,
> +			    const struct btf_func_model *model,
> +			    void *image, void *image_end);
Move it under where other bpf_struct_ops_.*() resides in bpf.h.

> +
>  #endif /* _LINUX_BPF_H */
> diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
> index 9abcc33f02cf..ec3c25174923 100644
> --- a/kernel/bpf/bpf_struct_ops.c
> +++ b/kernel/bpf/bpf_struct_ops.c
> @@ -312,6 +312,20 @@ static int check_zero_holes(const struct btf_type *t, void *data)
>  	return 0;
>  }
>  
> +int bpf_prepare_st_ops_prog(struct bpf_tramp_progs *tprogs,
> +			    struct bpf_prog *prog,
> +			    const struct btf_func_model *model,
> +			    void *image, void *image_end)
The existing struct_ops functions in the kernel now have naming like
bpf_struct_ops_.*().  How about renaming it to
bpf_struct_ops_prepare_trampoline()?

> +{
> +	u32 flags;
> +
> +	tprogs[BPF_TRAMP_FENTRY].progs[0] = prog;
> +	tprogs[BPF_TRAMP_FENTRY].nr_progs = 1;
> +	flags = model->ret_size > 0 ? BPF_TRAMP_F_RET_FENTRY_RET : 0;
> +	return arch_prepare_bpf_trampoline(NULL, image, image_end,
> +					   model, flags, tprogs, NULL);
> +}
> +
>  static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
>  					  void *value, u64 flags)
>  {
> @@ -368,7 +382,6 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
>  		const struct btf_type *mtype, *ptype;
>  		struct bpf_prog *prog;
>  		u32 moff;
> -		u32 flags;
>  
>  		moff = btf_member_bit_offset(t, member) / 8;
>  		ptype = btf_type_resolve_ptr(btf_vmlinux, member->type, NULL);
> @@ -430,14 +443,9 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
>  			goto reset_unlock;
>  		}
>  
> -		tprogs[BPF_TRAMP_FENTRY].progs[0] = prog;
> -		tprogs[BPF_TRAMP_FENTRY].nr_progs = 1;
> -		flags = st_ops->func_models[i].ret_size > 0 ?
> -			BPF_TRAMP_F_RET_FENTRY_RET : 0;
This change can't apply to bpf-next now because
commit 356ed64991c6 ("bpf: Handle return value of BPF_PROG_TYPE_STRUCT_OPS prog")
is not pulled into bpf-next yet.  Please mention the dependency
in the cover letter if it is still the case in v2.

> -		err = arch_prepare_bpf_trampoline(NULL, image,
> -						  st_map->image + PAGE_SIZE,
> -						  &st_ops->func_models[i],
> -						  flags, tprogs, NULL);
> +		err = bpf_prepare_st_ops_prog(tprogs, prog,
> +					      &st_ops->func_models[i],
> +					      image, st_map->image + PAGE_SIZE);
>  		if (err < 0)
>  			goto reset_unlock;
>  
> -- 
> 2.29.2
> 
