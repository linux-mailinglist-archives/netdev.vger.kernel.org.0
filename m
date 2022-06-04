Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532E853D5D5
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 08:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbiFDGgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 02:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbiFDGgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 02:36:17 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6C015730;
        Fri,  3 Jun 2022 23:36:17 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2546CYdV019106;
        Fri, 3 Jun 2022 23:36:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=WRd/S0QNm0rQ88vGX7yhKv9z4gTY7A+X+WUTXBgC7x8=;
 b=LT58pY4zm3YpOVfspa0zLOnPz22709mg1nwJRyCEJYoFv1r3Jh5aWGno2jcOD9zmaZdB
 HbWnqXa0i4lcNjcigYZw+f6dnGl86smpEyWXPqJqTRrq3WefIclBM8dUYtxr8IxW0IPC
 QXdqH3CuXUZmqo7KH9azAm6LnxwpouscgvA= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gfydqgeb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 23:36:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1uSw0JHnuOcBKa/40liRwee6XoOvsAHkzR69Hx0WbPOmEriISLztY6P9k/LiExgvF6TjN15YtIwQ3BnDBSQUXQwmcXmsjWP735MFFxIktTCzYM75z93Vp7LkmVjXGUAysGv/M5bJF8VaDGundGlr6h7eRsIZBRcLuEpGzRbYtBJxk9kfdtGL1Qi/Yaaa2OBDoPjLTSXgX2JCrKwoJN8XhlsoudlUyo3hzLpBMTeO2+phqXwoWXi0Rx7yAdN6Ap6i46qnNeOLPsb/CUlM4HA0ThRlMGXi1KDPSeeCb4QOPLtIVHRbPcl3XKwEWS6yr15NqVlY5o5tVNXFTV5fVZQQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WRd/S0QNm0rQ88vGX7yhKv9z4gTY7A+X+WUTXBgC7x8=;
 b=EVdg4Qg8NfGXxkdecn2Cdf6nyyslSgIm6oy93u7l6Y3rpibHjSBWx4ML2FNmZd8QJ/VwIKPWHa6HMlLm+tDPGRvHzbb4hJSA0vZYxQTNJTYtFH5OOcDC26LlDHEELZx38tW12dtE2M66JwKYi9FccGpjL0ED1ByGnnCsviDFE5DhQRehTorBb769pCzstyUcKPtOzBxa77/RMpXMHLvNbSFz198haTPCSNBHsBo8XBPY/elqt5ZQOUYbGDZciOoD7RpG9XD8HOvn3eTgqFpNIzt5zDsDRVuK2QD0R9O1pzwIEw3e0ZWH/lXYVf7jKRei3LlIrh4BDDCvFYbmMQfJxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB5080.namprd15.prod.outlook.com (2603:10b6:806:1df::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Sat, 4 Jun
 2022 06:35:59 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0%9]) with mapi id 15.20.5314.017; Sat, 4 Jun 2022
 06:35:59 +0000
Date:   Fri, 3 Jun 2022 23:35:56 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v8 04/11] bpf: minimize number of allocated lsm
 slots per program
Message-ID: <20220604063556.qyhsssqgp2stw73q@kafai-mbp>
References: <20220601190218.2494963-1-sdf@google.com>
 <20220601190218.2494963-5-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601190218.2494963-5-sdf@google.com>
X-ClientProxiedBy: MWHPR15CA0038.namprd15.prod.outlook.com
 (2603:10b6:300:ad::24) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cbc0f86f-775c-4247-a707-08da45f47c8a
X-MS-TrafficTypeDiagnostic: SA1PR15MB5080:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB5080FED68929E91C4B648BABD5A09@SA1PR15MB5080.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N46iOIGlt8ZZZvUBG6BQDCJ1WRBvd+ZEE+3gA24y/5ZGC7qcKau5SHypnRK4Q/X6cq1VvQanGNSfv7b7LpqR87lZUUvpOALpUS1tvDhSNxIORDrUy/bMj9c0aofJR/ZGWVZZVH0emxG6zsBa46WRrJ4alqMOpmSDCB7CYq+47vHLk4TLrIFcQQaB1ygoU+UtQFOQV99L4S2EY4fH3PBQPCyo0DN5N/Bbd2oQ7NOdDZz9uR2KdsWZpCOEs5rX4DTPL2ASAMQ+H11bnAVcQZNNYnLJQfR0C/SOxbZw3wIMPhv06QHyElmHKc69psB22RPQF2tJkgWgLHFsW63wy8iRLCffGf0zrSrm/fD7lysNEjJHM9YpbFCFj6AxUa/DDooxkbcXpOIOg3CbjuGg+y/ZiWh1uY+SubwHLv6sBzePnHVt1p5TtdOf2A0qPLoRoiv23U0kFIPZhEMmvRz52bRhgh527d715Ibh7cMNNpP8Dx5+k/y+B17aNY/clMZ2KAtPKe5wONxrslwunRCIjxAyDsPY1HfXoW85QRSG7AOLkg9nY0BJ/PygNiQ2/aS4OhfLtePp4s4TfLBX40ikih9Eeh2QG7Nxua6oRiy5S1eFdB6tcXT0Mqye5DhWxKZYvlUgPugp+JsoUz3PW+zs+vj3iA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(316002)(33716001)(508600001)(8936002)(6486002)(86362001)(5660300002)(6916009)(1076003)(186003)(83380400001)(2906002)(52116002)(38100700002)(6506007)(6666004)(9686003)(6512007)(8676002)(66946007)(66556008)(66476007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FYKLpwk4hwLVTFjGkFBFJ4t/i4t5yAdkkq9OWD0bqDeXAvV38AhfmmVQcD2y?=
 =?us-ascii?Q?fr8264SS/bqCdddA0SMYQrEk/xOXoUugCYb4CjW0zOfPG5AKXpG4G0CwlGk0?=
 =?us-ascii?Q?IxoebPx0xlDRuXAPn90wFtT2QTpvcmXwvjdjauyaGRh9IPW9obUdUMo27sG9?=
 =?us-ascii?Q?Gvg1LBwBwbVRfiBZTHQ3iMLx76YugRdXCvpZq5k6YsFz8i1z19LCKXuLIPXR?=
 =?us-ascii?Q?P6zFqV6eI+WNmiv64IePzS+ngAk9swdsX/cfkYMTIiMOiSDzLhqFuiKRs416?=
 =?us-ascii?Q?9/KZHjEniwdtwwp8LtOBBBa5DpQln2zGKT6wPdAPgYPntyuAVEsv6WKwB6bi?=
 =?us-ascii?Q?nlcZB3TFl05O9G1mKotEZz4N0razysIqT1xtyo0wxZryrkFnNlYoEQh75DXg?=
 =?us-ascii?Q?2YSe9wGlK8100G8KR680FaV1KDcAdSTEmzcHbfjHYUkawx7ZgOj4UFd46qnG?=
 =?us-ascii?Q?ek0GkNNhT5rDPCiK+l4TFxO9HnpX8fg6sgbEljsJIS4dks200M3YU2NKKldb?=
 =?us-ascii?Q?4QRALdKpemqWqZ8TGoVtSEeG4uldvS/HBF/TXkwOSJ8YlkR9aHqqVJazJVqC?=
 =?us-ascii?Q?ibnyfsWTgGsCOQWgvjpjPaGYaFnrFCpSzI5ejy8abUUSZ3AAJ8I3Cu0AOqGB?=
 =?us-ascii?Q?ZQNlpEXIkjKqUF8aljYtXLTj7kphucM2iQ4mNQuv4DJzl4tkqm5D9o61qynw?=
 =?us-ascii?Q?Nm3O+BDJtHCJ0Iin9B18jsNPiFlmhF4mJqgHADQIp4TzHgvRe9dlD5h/CjF3?=
 =?us-ascii?Q?gWG7QfyMDvI6clTwp/497jt1HhoAjmL8ovRPf38ecq9g5tBJFkld2NAYym6a?=
 =?us-ascii?Q?mOdFC8BnaFqmmtquZ8UJ/R+f/54lrhqBjwtAfgvOSj4cApbPI5QKgKktTq7f?=
 =?us-ascii?Q?o/K0Vgw6Yc0HsMYuEWCbst1GAVzR6M0dJ9+j941ZgoV6YlvlAhYFHsFcGWKF?=
 =?us-ascii?Q?P/85ilaVTZ7/Ad4Hr/W6eiu6p5jeFjSy5d3G8sT+W3MsBWyWco/8Fnx1R32P?=
 =?us-ascii?Q?9ve0lnUeQYLI9JAsZTNmQdbm6vGKjGsCQfeTBONTuV2LmmgJeCSkDDNySNbD?=
 =?us-ascii?Q?vwPWTI3xTwUMts7QBu2y2cK/ywhBLDY44YhYVrDizVP6LW00OnLNVabNzR0L?=
 =?us-ascii?Q?1x7BeUN/UZmItmCRlObis5oALxdnNmjbAUkUTOnrUPF03Crd6mskKGLuYLwz?=
 =?us-ascii?Q?OWIeeiZEC2VNqJsFTuRVtNVu1oSn2K31c2MifH11Dii7ctiwzYiuo2HZ1nBE?=
 =?us-ascii?Q?lQ3DK6GkmltWyJQZA+Ec89CQmdMQtQ00QqC7ZIuThI/QtuDVcCD8TTYB+rPG?=
 =?us-ascii?Q?IhSROQ2qVvERbJUgu7B5ggTCtL/87Xb4BSSyDu+ysscYMUngPQmHaKJjgwok?=
 =?us-ascii?Q?8bFG3n2QxtV+0E5UP84QiLbTUCUc5XAJHkIQVB7D08Hu4UjkWad4SFJr7s0Q?=
 =?us-ascii?Q?njQaqPaw48J+iUoP9xajXFN4iigvXyqzNFMWYgB3W0qoS1jshvKC/AdBPBIz?=
 =?us-ascii?Q?IVazim0rUwW+cVaLEFc46EDhHtqTJhFhMnJ40h+V1ddX4LRNys6PkuvNC68+?=
 =?us-ascii?Q?fog2C0iSSZrHC36KsHvDFs103TsDFoIK98ls40GO/8pJZtpvwYsMrP0nJPt+?=
 =?us-ascii?Q?1miq4cxqCjrjglyTE8qiTvLFe1EZONE3gbQrhf0m6xuvg1NWJPoUZBhRYepm?=
 =?us-ascii?Q?vy9bR8MuS4uf0/Np90ddGAFpiK68QeJWnVJ8WfGG7oO/pwQxwhm275Iz/9dz?=
 =?us-ascii?Q?xCXMqpuga6TuU7j376rQKD8hrg2NpSk=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbc0f86f-775c-4247-a707-08da45f47c8a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2022 06:35:59.5317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rZE19AGg+YEH6oYx3G5RrxD9DBz/nVG1bVt5Nxb3whjk31b9qlDYMymlRCge5oMQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5080
X-Proofpoint-ORIG-GUID: pI_R760CCjJunxmF04T4DRNvybo-kbNU
X-Proofpoint-GUID: pI_R760CCjJunxmF04T4DRNvybo-kbNU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_08,2022-06-03_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 01, 2022 at 12:02:11PM -0700, Stanislav Fomichev wrote:
> diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> index 0f72020bfdcf..83aa431dd52e 100644
> --- a/kernel/bpf/bpf_lsm.c
> +++ b/kernel/bpf/bpf_lsm.c
> @@ -69,11 +69,6 @@ void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
>  		*bpf_func = __cgroup_bpf_run_lsm_current;
>  }
>  
> -int bpf_lsm_hook_idx(u32 btf_id)
> -{
> -	return btf_id_set_index(&bpf_lsm_hooks, btf_id);
The implementation of btf_id_set_index() added in patch 3
should be removed also.

> -}
> -
>  int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
>  			const struct bpf_prog *prog)
>  {
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 66b644a76a69..a27a6a7bd852 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -129,12 +129,46 @@ unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
>  }
>  
>  #ifdef CONFIG_BPF_LSM
> +u32 cgroup_lsm_atype_btf_id[CGROUP_LSM_NUM];
static

> +
>  static enum cgroup_bpf_attach_type
>  bpf_cgroup_atype_find(enum bpf_attach_type attach_type, u32 attach_btf_id)
>  {
> +	int i;
> +
> +	lockdep_assert_held(&cgroup_mutex);
> +
>  	if (attach_type != BPF_LSM_CGROUP)
>  		return to_cgroup_bpf_attach_type(attach_type);
> -	return CGROUP_LSM_START + bpf_lsm_hook_idx(attach_btf_id);
> +
> +	for (i = 0; i < ARRAY_SIZE(cgroup_lsm_atype_btf_id); i++)
> +		if (cgroup_lsm_atype_btf_id[i] == attach_btf_id)
> +			return CGROUP_LSM_START + i;
> +
> +	for (i = 0; i < ARRAY_SIZE(cgroup_lsm_atype_btf_id); i++)
> +		if (cgroup_lsm_atype_btf_id[i] == 0)
> +			return CGROUP_LSM_START + i;
> +
> +	return -E2BIG;
> +
> +}
> +
> +static void bpf_cgroup_atype_alloc(u32 attach_btf_id, int cgroup_atype)
> +{
> +	int i = cgroup_atype - CGROUP_LSM_START;
> +
> +	lockdep_assert_held(&cgroup_mutex);
> +
> +	cgroup_lsm_atype_btf_id[i] = attach_btf_id;
> +}
> +
> +void bpf_cgroup_atype_free(int cgroup_atype)
> +{
> +	int i = cgroup_atype - CGROUP_LSM_START;
> +
> +	mutex_lock(&cgroup_mutex);
> +	cgroup_lsm_atype_btf_id[i] = 0;
I think holding cgroup_mutex in the __cgroup_bpf_attach() and
bpf_cgroup_atype_free() is not enough.

Consider a case that __cgroup_bpf_attach() runs first and bpf_trampoline_link_cgroup_shim()
cannot find the shim_link because it is unlinked and its shim_prog
is currently still under the bpf_prog_free_deferred's deadrow.
Then bpf_prog_free_deferred() got run and do the bpf_cgroup_atype_free().

A refcnt is still needed.  It is better to put them together in a
struct instead of having two arrays, like

struct cgroup_lsm_atype {
       u32 attach_btf_id;
       u32 refcnt;
};

> +	mutex_unlock(&cgroup_mutex);
>  }
>  #else
>  static enum cgroup_bpf_attach_type
> @@ -144,6 +178,14 @@ bpf_cgroup_atype_find(enum bpf_attach_type attach_type, u32 attach_btf_id)
>  		return to_cgroup_bpf_attach_type(attach_type);
>  	return -EOPNOTSUPP;
>  }
> +
> +static void bpf_cgroup_atype_alloc(u32 attach_btf_id, int cgroup_atype)
> +{
> +}
> +
> +void bpf_cgroup_atype_free(int cgroup_atype)
> +{
> +}
>  #endif /* CONFIG_BPF_LSM */
>  
>  void cgroup_bpf_offline(struct cgroup *cgrp)
> @@ -659,6 +701,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>  		err = bpf_trampoline_link_cgroup_shim(new_prog, &tgt_info, atype);
>  		if (err)
>  			goto cleanup;
> +		bpf_cgroup_atype_alloc(new_prog->aux->attach_btf_id, atype);
This atype alloc (or refcnt inc) should be done in
cgroup_shim_alloc() where the shim_prog is the one holding
the refcnt of the atype.  If the above "!old_prog" needs to be
removed as the earlier comment in patch 3, bumping the atype refcnt
here will be wrong.

>  	}
>  
>  	err = update_effective_progs(cgrp, atype);
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 091ee210842f..224bb4d4fe4e 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -107,6 +107,9 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
>  	fp->aux->prog = fp;
>  	fp->jit_requested = ebpf_jit_enabled();
>  	fp->blinding_requested = bpf_jit_blinding_enabled(fp);
> +#ifdef CONFIG_BPF_LSM
I don't think this is needed.

> +	aux->cgroup_atype = CGROUP_BPF_ATTACH_TYPE_INVALID;
> +#endif
>  
>  	INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
>  	mutex_init(&fp->aux->used_maps_mutex);
> @@ -2558,6 +2561,10 @@ static void bpf_prog_free_deferred(struct work_struct *work)
>  	aux = container_of(work, struct bpf_prog_aux, work);
>  #ifdef CONFIG_BPF_SYSCALL
>  	bpf_free_kfunc_btf_tab(aux->kfunc_btf_tab);
> +#endif
> +#ifdef CONFIG_BPF_LSM
Same here.

> +	if (aux->cgroup_atype != CGROUP_BPF_ATTACH_TYPE_INVALID)
> +		bpf_cgroup_atype_free(aux->cgroup_atype);
>  #endif
>  	bpf_free_used_maps(aux);
>  	bpf_free_used_btfs(aux);
> -- 
> 2.36.1.255.ge46751e96f-goog
> 
