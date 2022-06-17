Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726BE54EE89
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 02:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbiFQAnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 20:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiFQAnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 20:43:42 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948C43E5D3;
        Thu, 16 Jun 2022 17:43:41 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GMYmtY005052;
        Thu, 16 Jun 2022 17:43:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=OtQfZDaXpBdctW6RLWGKNkDGgw9eOyJgDcKR4Ltxrg0=;
 b=K2Q12c3hG9tbIXdOpwtKp2NxcZgsufNI7giXj7OQcAKXq5P79i9QG5CnFk4GXVPjbwui
 EeWEBBmzI3Eh4mbq04H0/bniOvnDtkIvby/qDYQq3IgH/vZsun9az/DLniLSw2G7ZWps
 KDXyjPc0RNIrOq+Z37QBfpYUGOfCgKbjaLQ= 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gqve4350j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 17:43:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMi/7bAwNhqA8gWIGrkLW9++h7mzKPNoQMswxNnrAAH0D37JJj7UH2t252yG8akzUNVhV4mEaefsMNLzk7QC0UVZNcW0eO7uJl8tqNj93BN/eJgF7bSfM8IOftHYNSL5GGR8KNNSB6+xNxSMh7KpZl7xggCU6USDGAtW2WHOKC3GwoUtz1hsgGK9lgc+QszmbQ40rGdW4sRdiKiaRe/dT3Tcs7MIit5t284Ie2YGEPfZQSIVa2HMEmQiMBbAJMqnanWY3dlu8JDg9j4fpWCgauKTi1A2bv3FMgOLAG1XH40scP0hUoaDx0iF5bYpZuypjTU2epA4rRYBV/bfqAzqxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OtQfZDaXpBdctW6RLWGKNkDGgw9eOyJgDcKR4Ltxrg0=;
 b=l3sd4AhyLXmuXVBv98h4+R2ReZEMsGLBDiRXmhUhj8LEw3kFcnejWZt9VvUb2kOZPIvyESp2p0F7oGgZGcY7dXpkn6H0RVHWr0SQdTVD+A+p1JjKWgLCprgsW8MHEFXFh89SWQrRNi3u+b1pL2CvzADdQCT3ma+NMXC0gXxs+gyz+Yi+IkqUpbBN6LLZVbnbcV9U8vgEwG2Dy5n8TYDCItamaY2T+IXBpq/WxNrij/tgKJ89C9PttRz9ZCYg3ivM6fy1P/lCUGx3T0MrXu6ftPybevu0PldUk8fwk2hSUfr9nPVVN9YezbdvuK9bD8uPT5UrWouUC2mkeVzWbYN98w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BY3PR15MB4995.namprd15.prod.outlook.com (2603:10b6:a03:3ca::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 00:43:23 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%7]) with mapi id 15.20.5353.015; Fri, 17 Jun 2022
 00:43:23 +0000
Date:   Thu, 16 Jun 2022 17:43:21 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v9 04/10] bpf: minimize number of allocated lsm
 slots per program
Message-ID: <20220617004321.4qbte4k5ftbcvivs@kafai-mbp>
References: <20220610165803.2860154-1-sdf@google.com>
 <20220610165803.2860154-5-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610165803.2860154-5-sdf@google.com>
X-ClientProxiedBy: BY3PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:a03:254::16) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c96b7a9-5cff-4aa0-e1a5-08da4ffa6204
X-MS-TrafficTypeDiagnostic: BY3PR15MB4995:EE_
X-Microsoft-Antispam-PRVS: <BY3PR15MB4995535E007C56A83AFE79FDD5AF9@BY3PR15MB4995.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ET/EYHFb2fSWQOwRB6SMbk+aXCrTXvPtUva38VV8e0tHSRi6Xw04YhrFonzkzU00PfcDjo8WJksy3LdtaPAwIM5AI1mnhIEQNaaWfaeK24ZTEGQBlSx6j6cLePB+ybGukRCCJ+D5yZYlo8HTXuudIglL66c8qjjl9SeB4bOioy7BsqIbdLHHFYaTgNTWoqppiIfjmxGp9AtYc7tohdm3q9lEMbklYsjYJTp4aBVa3jxIF7HbSEvP/riwihUyzC8XgNV2Z831hLpV8pIJwxB8zt0Clrsm4RSXCHjh5FXirrmXOL5eD58kVr/VoZlKyggTRzSBqft/kr6hSmQyEEQzjGxdS9aE1c2zEFZk+kO623nCULwgTx6T15QBJ5ZOVX3XL3wc/W3iiMBnVw0rICxsCgsWCNpyp87i3tYsGVfkCHokc/ID8+CEbNC27yXpbRICHmvolwWOYNCmCpZxuAZbE1va0hgytsEjOBQe0cXhY7a57E58wfvKU8x0/7rE2Nj7YO+QvYzOHksNJtZ2gHAJibftbCi11jRuKhGakf3PTnjZioLZojqiVZSdAe6bUTS4/q7vzb1nzPk4P8YxJuovC/pm9+L+pMQBS8K9Pt1t/U7KvTPAg9rWjkig6xvlycnpxcyjMS+whPY7CiyXjngs+DbXKkfC3gFPLDMqEsXachxfDsrRnxWXXNLp58Lb4v0L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(52116002)(6506007)(9686003)(6512007)(38100700002)(2906002)(33716001)(8936002)(5660300002)(66556008)(6486002)(66476007)(4326008)(8676002)(508600001)(86362001)(186003)(1076003)(83380400001)(6916009)(316002)(66946007)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0hZgaOdKQ2o11VIpLGKdzOMIVPEkjNgBpSLn38dg1ly6xkFWf5TpNnamw+D5?=
 =?us-ascii?Q?3YquwN+2FdQppVKduLD0ZzmNnC4hzhHG7BFUrdrQKirvbwpGhNr/QPWP977+?=
 =?us-ascii?Q?U7KmTn+2GjAYYkxoWM6g4RARVR297sGCbNoGHIxeLU2Y5cYxfykc87cyI4ra?=
 =?us-ascii?Q?Se9gsaRW41tHfALNzOojRf98xjFeH8Da80lkjD5f+YK3AMyKX+8Hs2jS52Ur?=
 =?us-ascii?Q?6ElCdrSRcrgGP1bdos+0RnM5WF+QOM1z9nzn2b/pTTmy4X1U1DEuvYjd0oRN?=
 =?us-ascii?Q?P3mbjNeVetM6oUShBZnYDHOCLgv/Umuye+QfVYyMU84ZqtjaP6Apk4Ii3xdT?=
 =?us-ascii?Q?/1dL/g57L6mw/1EUu7c4mOHWnYeo1hmc4j4rT3Kn3CbbuTYDe4WONCIksC/j?=
 =?us-ascii?Q?7Mga2rI3SSvOUyUn6Sjprv9e3TMXFLay/xCNPAqwGjgekNIdLnjWv7JylUMO?=
 =?us-ascii?Q?fwDnNywL+g4GilX3XkRbnstVOjKTLTCbonHRpes4bNU00gafLx3OyfNGuPEe?=
 =?us-ascii?Q?X3bfRlkoD9suo2QQajK3S/kXGY8EGItkDQ/8gBMBXH9cQ6TIrhHE2bdik7kY?=
 =?us-ascii?Q?cOANO3EWVN5FmwJ0KUuTvCs4XnjqY/fA6f2Bdibv94p68nRj7LGneYvLTT6s?=
 =?us-ascii?Q?3pZEwkZDm/84qDEb9dNJxRx6ncS7Re1T2o+DoPIhvX0OYEnRd8vNZ+uBKqa3?=
 =?us-ascii?Q?3vxpbmAjMC51XlAL+tpw8FIlxMdzoYzERz8n+/q4wVw8+1vnVAKXb/yPXP/w?=
 =?us-ascii?Q?H4e1DOPOzW03BcQfrHqjyjbZg2joWfbqIGwDpyWsmx8zhB294/p4SdEUGguN?=
 =?us-ascii?Q?y3ZliR+Isw2ccoUvcX8gNk8eZGLYeYnsW9kGvW1mHQuA+4xaEvmaVJaDDNDB?=
 =?us-ascii?Q?CYWN8rvDoJEpc6GA2fQDApeexUf+yYkw6h00AuYnrurxkD3O6OzUUrvjgvx9?=
 =?us-ascii?Q?dLLIniZFFzdAixXqyDQbMlXpmxs41yegDakyWPkJXq+RCd6S66ys6XvvA8Ii?=
 =?us-ascii?Q?5E8ZIUEi80SY5KpgzzyLiAPspathcG1jtTC8aTjL4kfM1IC+HUbHTliMRvzU?=
 =?us-ascii?Q?fX0Hl/eOZHFATMOXbcktykuZ28sMdqmzK0NGYDkPQE8oIxoy6AtWMm5moGBk?=
 =?us-ascii?Q?+5yW6Oq3EVYG5/05Q3GK0XdOG2J1nz92vWw+/Si2mxCcNpV5wQAtjnVOwmTa?=
 =?us-ascii?Q?bxdgnvflXxvvsL3F4t3SIF707+6lgmV1jNnirXg4YLms7nsa47EfnV3K4Sp2?=
 =?us-ascii?Q?kiJw2YttMNQ32iD4H/A65HYelayXp2Pfc1X4mCD4aJRQZ/SQkU2DYHBTq09k?=
 =?us-ascii?Q?ThMz+GaMpYiNyVtBE5sU3ufRAq3z83s8LKlk15XN8m2O3hBANO1o+HwqE+ry?=
 =?us-ascii?Q?ZOJ9YREiu4Uz147fq74eSdCZ1HOXHjB+CnrkB4PWyEs7V1xDYEbOKGfW1wsu?=
 =?us-ascii?Q?lHwi9gZBnoZ0PgVL5usmVsOlHeHUBXx2/ewRq/WHzHa5wZ36sIwWROeqoyEI?=
 =?us-ascii?Q?OsxANiYxNOd55iQGORqvikxn3neXuA8JjrGgN6SmGGgGkLGDEGlQwfxzmVE0?=
 =?us-ascii?Q?dty+iNrBFjXbUSufj2c/wSQFHCqpa1x81V14fgGUhGV/RHC7zmzAjni6JLzx?=
 =?us-ascii?Q?Ajr4mRHIS63sXlt7Y8AIforN8slPJm1ZCG7DkzfjO4daE4vu+i42y8UzpD3m?=
 =?us-ascii?Q?0qcs1XVVA6a024PnrtPWaUJirD7T99fbmQZ0Q7QPAQNeqQ4xVR0zmdWXN9B7?=
 =?us-ascii?Q?QhlfsNk5kKziTgw5XRVGXu+2RgETRxs=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c96b7a9-5cff-4aa0-e1a5-08da4ffa6204
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 00:43:23.5927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XBSqOpl41FWEZMdlta7raHn0aI8dv3fIzgbaGOU763mGJeSiFSbfq7ulpRDBZrrt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4995
X-Proofpoint-ORIG-GUID: SP-nLkPGAb2RM3dcEsBreZXuAoKl_CD8
X-Proofpoint-GUID: SP-nLkPGAb2RM3dcEsBreZXuAoKl_CD8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_20,2022-06-16_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 09:57:57AM -0700, Stanislav Fomichev wrote:
> Previous patch adds 1:1 mapping between all 211 LSM hooks
> and bpf_cgroup program array. Instead of reserving a slot per
> possible hook, reserve 10 slots per cgroup for lsm programs.
> Those slots are dynamically allocated on demand and reclaimed.
> 
> struct cgroup_bpf {
> 	struct bpf_prog_array *    effective[33];        /*     0   264 */
> 	/* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
> 	struct hlist_head          progs[33];            /*   264   264 */
> 	/* --- cacheline 8 boundary (512 bytes) was 16 bytes ago --- */
> 	u8                         flags[33];            /*   528    33 */
> 
> 	/* XXX 7 bytes hole, try to pack */
> 
> 	struct list_head           storages;             /*   568    16 */
> 	/* --- cacheline 9 boundary (576 bytes) was 8 bytes ago --- */
> 	struct bpf_prog_array *    inactive;             /*   584     8 */
> 	struct percpu_ref          refcnt;               /*   592    16 */
> 	struct work_struct         release_work;         /*   608    72 */
> 
> 	/* size: 680, cachelines: 11, members: 7 */
> 	/* sum members: 673, holes: 1, sum holes: 7 */
> 	/* last cacheline: 40 bytes */
> };
> 
> Move 'ifdef CONFIG_CGROUP_BPF' to expose CGROUP_BPF_ATTACH_TYPE_INVALID
> to non-cgroup (core) parts.
hmm... don't see this change in bpf-cgroup-defs.h in this patch.

> 
> diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
> index b99f8c3e37ea..7b121bd780eb 100644
> --- a/include/linux/bpf-cgroup-defs.h
> +++ b/include/linux/bpf-cgroup-defs.h
> @@ -11,7 +11,8 @@
>  struct bpf_prog_array;
>  
>  #ifdef CONFIG_BPF_LSM
> -#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> +/* Maximum number of concurrently attachable per-cgroup LSM hooks. */
> +#define CGROUP_LSM_NUM 10
>  #else
>  #define CGROUP_LSM_NUM 0
>  #endif
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 4dceb86229f6..503f28fa66d2 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -2407,7 +2407,6 @@ int bpf_arch_text_invalidate(void *dst, size_t len);
>  
>  struct btf_id_set;
>  bool btf_id_set_contains(const struct btf_id_set *set, u32 id);
> -int btf_id_set_index(const struct btf_id_set *set, u32 id);
>  
>  #define MAX_BPRINTF_VARARGS		12
>  
> @@ -2444,4 +2443,7 @@ void bpf_dynptr_init(struct bpf_dynptr_kern *ptr, void *data,
>  void bpf_dynptr_set_null(struct bpf_dynptr_kern *ptr);
>  int bpf_dynptr_check_size(u32 size);
>  
> +void bpf_cgroup_atype_put(int cgroup_atype);
> +void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype);
> +
>  #endif /* _LINUX_BPF_H */

[ ... ]

> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index b0314889a409..ba402d50e130 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -128,12 +128,56 @@ unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
>  }
>  
>  #ifdef CONFIG_BPF_LSM
> +struct cgroup_lsm_atype {
> +	u32 attach_btf_id;
> +	int refcnt;
> +};
> +
> +static struct cgroup_lsm_atype cgroup_lsm_atype[CGROUP_LSM_NUM];
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
> +	for (i = 0; i < ARRAY_SIZE(cgroup_lsm_atype); i++)
> +		if (cgroup_lsm_atype[i].attach_btf_id == attach_btf_id)
> +			return CGROUP_LSM_START + i;
> +
> +	for (i = 0; i < ARRAY_SIZE(cgroup_lsm_atype); i++)
> +		if (cgroup_lsm_atype[i].attach_btf_id == 0)
> +			return CGROUP_LSM_START + i;
> +
> +	return -E2BIG;
> +
> +}
> +
> +void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype)
> +{
> +	int i = cgroup_atype - CGROUP_LSM_START;
> +
> +	lockdep_assert_held(&cgroup_mutex);
> +
> +	WARN_ON_ONCE(cgroup_lsm_atype[i].attach_btf_id &&
> +		     cgroup_lsm_atype[i].attach_btf_id != attach_btf_id);
> +
> +	cgroup_lsm_atype[i].attach_btf_id = attach_btf_id;
> +	cgroup_lsm_atype[i].refcnt++;
> +}
> +
> +void bpf_cgroup_atype_put(int cgroup_atype)
> +{
> +	int i = cgroup_atype - CGROUP_LSM_START;
> +
> +	mutex_lock(&cgroup_mutex);
> +	if (--cgroup_lsm_atype[i].refcnt <= 0)
> +		cgroup_lsm_atype[i].attach_btf_id = 0;
> +	mutex_unlock(&cgroup_mutex);
>  }
>  #else
>  static enum cgroup_bpf_attach_type
> @@ -143,6 +187,14 @@ bpf_cgroup_atype_find(enum bpf_attach_type attach_type, u32 attach_btf_id)
>  		return to_cgroup_bpf_attach_type(attach_type);
>  	return -EOPNOTSUPP;
>  }
> +
> +void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype)
> +{
> +}
> +
> +void bpf_cgroup_atype_put(int cgroup_atype)
> +{
> +}
From the test bot report, these two empty functions may need
to be inlined in a .h or else the caller needs to have a CONFIG_CGROUP_BPF
before calling bpf_cgroup_atype_get().  The bpf-cgroup.h may be a better place
than bpf.h for the inlines but not sure if it is easy to be included in
trampoline.c or core.c.  Whatever way makes more sense.  Either .h is fine.

Others lgtm.

>  #endif /* CONFIG_BPF_LSM */
>  
>  void cgroup_bpf_offline(struct cgroup *cgrp)
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 8d171eb0ed0d..0699098dc6bc 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -107,6 +107,9 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
>  	fp->aux->prog = fp;
>  	fp->jit_requested = ebpf_jit_enabled();
>  	fp->blinding_requested = bpf_jit_blinding_enabled(fp);
> +#ifdef CONFIG_CGROUP_BPF
> +	aux->cgroup_atype = CGROUP_BPF_ATTACH_TYPE_INVALID;
> +#endif
>  
>  	INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
>  	mutex_init(&fp->aux->used_maps_mutex);
> @@ -2554,6 +2557,10 @@ static void bpf_prog_free_deferred(struct work_struct *work)
>  	aux = container_of(work, struct bpf_prog_aux, work);
>  #ifdef CONFIG_BPF_SYSCALL
>  	bpf_free_kfunc_btf_tab(aux->kfunc_btf_tab);
> +#endif
> +#ifdef CONFIG_CGROUP_BPF
> +	if (aux->cgroup_atype != CGROUP_BPF_ATTACH_TYPE_INVALID)
> +		bpf_cgroup_atype_put(aux->cgroup_atype);
>  #endif
>  	bpf_free_used_maps(aux);
>  	bpf_free_used_btfs(aux);
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 023239a10e7c..e849dd243624 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -555,6 +555,7 @@ static struct bpf_shim_tramp_link *cgroup_shim_alloc(const struct bpf_prog *prog
>  	bpf_prog_inc(p);
>  	bpf_link_init(&shim_link->link.link, BPF_LINK_TYPE_UNSPEC,
>  		      &bpf_shim_tramp_link_lops, p);
> +	bpf_cgroup_atype_get(p->aux->attach_btf_id, cgroup_atype);
>  
>  	return shim_link;
>  }
> -- 
> 2.36.1.476.g0c4daa206d-goog
> 
