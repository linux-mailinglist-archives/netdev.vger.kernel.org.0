Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C468D54ED42
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 00:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378717AbiFPWZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 18:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbiFPWZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 18:25:45 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593F560B84;
        Thu, 16 Jun 2022 15:25:43 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25GKPjs0013683;
        Thu, 16 Jun 2022 15:25:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=1IBcsZJeTCnhezloptjfyuV1jmSwaAQBUhlT56ydXxw=;
 b=N5ofZEp0UIULPEeIAyYftWMxZT3w58ArX0UGNtA6mAsxwR/JHFGK4kJXlgGm7X2Eiqab
 xpC5GN0I7jOIw4MkCVfn1n5FC4gq7WMBkLxd+3ecfXWjJ9CWfsfGBhkEGy83PBYj3yBT
 oNUOaMM523TuTjsAGyPYnEALvkIrQgUOYN4= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by m0089730.ppops.net (PPS) with ESMTPS id 3gr09vp8wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 15:25:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZfcqvPqHIHQINbJ2WP0r6kTdk3NU/CKj1x1EADaKnh8oYj3IllsOg12LnYv3qyHNOgdkgLZsQzmfxb9sibIMYBnJylSFZBssAaUvwUc2uQVdNFJrlL90DXVurQnmHmSqQX6p2X6gBSBnSWSY7l4WN8Vg5s8357ncJZHdeOKohmHF87IYTgFdrTEeMCpRRw6TujhCJFFrz6pBQbFeSkqHKsT9/p2vR2RYcBu2XIzMvryiW/Lb/80XECWQTX8HtveCE/kv2MNfmbRl2pI8hw2gJSgYsO9rm2Iiu2aYRfeH8CIyvEMEYFdKte3Z7SbeG5W8k5Qudvqn79UBIZIe7i+pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1IBcsZJeTCnhezloptjfyuV1jmSwaAQBUhlT56ydXxw=;
 b=h6rZqdlnz6skPQWkY4FjAHP+MMzfQgD+wwdLIR30GlKLgXMRMtCSauu2mHNNlM3WiPQPbqT5tskwKiRJdh2+YN/FYSDc5xGtkVmM7h/fjypDFQz+KdTftC9hswFUpCwKUlDR6bRDMv60UuSgovCQFXdhrUbQlaoD2opESa7tnyORTldJWro65gOK74pM+qV3riiUoqjwbVgGbRWtWceLDqtze+AzMW/R4ZSc6F4HHbzEKHCOL9nd5Mz8IgQdohOxbSw7ko406K9y4taxsd+vAOhIyI7P+cnZURito6VZg+vTYCzp3jQTqgS9uhvHC0ja09IrgwjQVtMQSwBVtwf3sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by PH0PR15MB5040.namprd15.prod.outlook.com (2603:10b6:510:cf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 16 Jun
 2022 22:25:24 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%7]) with mapi id 15.20.5353.015; Thu, 16 Jun 2022
 22:25:24 +0000
Date:   Thu, 16 Jun 2022 15:25:22 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v9 03/10] bpf: per-cgroup lsm flavor
Message-ID: <20220616222522.5qsvsxlzxjkbfndu@kafai-mbp>
References: <20220610165803.2860154-1-sdf@google.com>
 <20220610165803.2860154-4-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610165803.2860154-4-sdf@google.com>
X-ClientProxiedBy: SJ0PR03CA0087.namprd03.prod.outlook.com
 (2603:10b6:a03:331::32) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b20d7b59-e8d1-4a96-2120-08da4fe71b56
X-MS-TrafficTypeDiagnostic: PH0PR15MB5040:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB5040ED1E33BDE83795A7E76ED5AC9@PH0PR15MB5040.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8N5ZuIFy4ezCMO/kAPulb7ro79DTBzv7A8+S1tmcSBdzLmWkGJjP4+8y1Ld/xOPrZ2qPYX0tg2G9YLQUIyxjzHkcx18PMTJ/bG5VARP9TadRRoWus4dS30YUs5KiVnz6UsG6ZdKjaMR8P7WfvmXO6fOiIl/vaJt6X5/SNneuqrfbE4JkSUlWVSDAfNuOIvK+XVfceQAnfsd6RqM6vsRo171kIsLbGGQYBs5aB21rvvtlwz8UjQdjrL/K6iKMdEc4PgsV6JDdzYfbByg33+GbI0M7EcT+qU4zlXPKGkmr5DKY6PZxO1aR4u0y5jUKQyrJd8L45l/bOpQGKtyNUkauPPqjtyKCYojNI4z/lFtMB2pqEOYzCnqunvWMJXzOjQcXqY6AHBYQeBYEpdpcqNaNcbKCiUbylYT9jxqDwrlADxGPqozjx6ua1T6C11a5coIMrmW/WvUBXrqrKBQ9+sga9smfDnz17vwtYUc//C0s7Zjcgc6LdJlznyzvjwjNFEHlH2HMHKpJU2/AKOAETxQ1+jjv8EtBRiJ6GFXKsPFHuLSgkibe+FpcjXYmFRK5E9+GSl2CJ30TIZjXaJhy7GnbGMaJlDJbY0glWszMJbOhZ29uUGV4tlB7iuwRWghFp9qVPa6YLJ694d3F4kHn0VpsNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(30864003)(2906002)(5660300002)(8936002)(6916009)(33716001)(1076003)(6506007)(66476007)(316002)(66946007)(4326008)(8676002)(52116002)(6512007)(9686003)(66556008)(186003)(38100700002)(83380400001)(6486002)(508600001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8BvvxEG6OX18j+VMCg5FmqfkgdaJ5anHA0NlxHaiNpZnGY6TOkRh1VGlWvqj?=
 =?us-ascii?Q?v79XLVb8iCQ2fzlNuVIYLqbhYG3KGxNP/yYt97THTYBY7uKgvQi+1d0qWhhC?=
 =?us-ascii?Q?l2KOTZqwqzhqzGH8lRWTC5sF013Ef4KuNn44cq5laal0MRUItzLFfPIfHol3?=
 =?us-ascii?Q?5bLZ0Hi3Qycb4QQe4JdJjRJeNYZH7VDTE/oUGs9J856FXEVibpmV/Mu41Uyj?=
 =?us-ascii?Q?CfU/K4wtnEODODobvQrw07Y569q/njRUjUyPZLvodEpskrCg+p5VEdd4mwo6?=
 =?us-ascii?Q?G+G6WCIKV3ajQUOwu3pSIWjN/0WfodrUtjytcaoR2zCaWIjr3k3gZMi8/46x?=
 =?us-ascii?Q?l8ElpC1araO4MTsboxzfEvq/8xtX5mk0FFrEUpoVarPnYiOODcF/BEDBbSMS?=
 =?us-ascii?Q?FaRZ3gS+sviCKRdHHN/kOhpH1C9Fijb/Np68fr+jrFabvJnxiKLVH6EAyIPu?=
 =?us-ascii?Q?TGpgECpcjP18hzUib13OqlgDkZIUQAhgBwI3aE7TH+QRasp45oQAVDP6mXwr?=
 =?us-ascii?Q?t92ZqUrxBgFFEJktV1NGqF1Fuh8GL6GaN2S3PSjQXucRBvcGBqEajhxJ0vXq?=
 =?us-ascii?Q?EVlDRxprHw4TTC5VUWmVNwKzdp8TyRcdSaKv2EOGBoZIdwWXy/WdCGgjZf0/?=
 =?us-ascii?Q?U6Mo1bF+dthZRXwdBwedjfVD9mTrZTzEksZYJMxlCYOTdrTrOIyMMPr0MXd7?=
 =?us-ascii?Q?8WtPSWYSTwgM2xC9ManHJ8uiOjeB2qTGshiTj7/BR16zmznVe1PZPj16shSM?=
 =?us-ascii?Q?rEfizQ4WIpr6vjIogqa+2T4fdHJXFTMGIdqToHDxksPr8/vLVGzI17N6tAxT?=
 =?us-ascii?Q?gxFQGtiXx2JfYJdwBuK31xF5H+tkZ6SX20SKN5RR/7TO+7Ft3iZd0I0YLbSx?=
 =?us-ascii?Q?sZCc2XV+WpFFW50KCtggfKdYOEgjOA09oUwQI5oSRYCgVoXEbpf5jOsiX7WO?=
 =?us-ascii?Q?JoY6gCThB2H/gBvMSI5XLt/75Xi1ra0UFRGvJDfj+t5n/Zgsckh4ht7peL8m?=
 =?us-ascii?Q?S0xSeMmemlV0qd8v0+YfCNghii/jqgwpbqu1y206pGIcV30TYue+kiVLSkBj?=
 =?us-ascii?Q?rE069HwBufgjmvlp8s+f0EJikQOonnqmErZeQ91m2+VwhZK6Sc300vBIgWad?=
 =?us-ascii?Q?Dp4602TYyqwQXcc/bb12RTW0TONiTarT8J9cEnTmg+bmQZzf8Eaws7DGDPKX?=
 =?us-ascii?Q?HhrWAk4mt5WIGAfqc6ROhWltk0kupxa5g3bkYiKbSw1IPcXSamlP3XX50gdj?=
 =?us-ascii?Q?rRXR7YoG1K5enK1ZNObHhZl2kuu1zsXYI153rWTbwERwUdpR42UayIqWlFug?=
 =?us-ascii?Q?z6dK7i0IXD3PbQ23QdapMxSsUFqd1XDbq9SFTBz16kOTnZKpMrTQm1/pXs8Y?=
 =?us-ascii?Q?mV2yow9PL7TIBwj0F+wENz8RWT6jUkClqAatH44KmhsrivvXBcDKv7J4dE2T?=
 =?us-ascii?Q?bVP0xZazP3buAlqbuYknVhCalgEOjyYjblJSndHYBs1PRUZIZr/lK6//VZ5x?=
 =?us-ascii?Q?pg7XWvzem7Dn3yyZgBluqaeTgUm/TYZdkpPHY8ZGFZr8zy49LJwDUcW7vSzB?=
 =?us-ascii?Q?1JgMCnpF4Cq4YqmVEUx5g16epjQIP3tvu2+J9vBUFiHsr1VpA9/iU+V3pAi1?=
 =?us-ascii?Q?ZZNVg6iOgiXNsPqY3FyPsUWFQV90vVBzYGdrYR3aL1rBB2aGhJi9uHnQfE/u?=
 =?us-ascii?Q?81uy2r8RI6ETqJYqQx3Nrodqk8D6OuyuueIksQsclkFAkNLjo/3O/Usw1pjw?=
 =?us-ascii?Q?O07q89r4CbI60Nz0zADA5UwILMScoYg=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b20d7b59-e8d1-4a96-2120-08da4fe71b56
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:25:24.2734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5AZshnZX5xIhVxd93v+WuraWi4Urk3dB/gc6EfZcqb9ZKSNuYL95VuRgK+aQQKea
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5040
X-Proofpoint-GUID: SVjSxqlSjvVS3qRvMtu2ZhrQyKGMQGEJ
X-Proofpoint-ORIG-GUID: SVjSxqlSjvVS3qRvMtu2ZhrQyKGMQGEJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_18,2022-06-16_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 09:57:56AM -0700, Stanislav Fomichev wrote:
> Allow attaching to lsm hooks in the cgroup context.
> 
> Attaching to per-cgroup LSM works exactly like attaching
> to other per-cgroup hooks. New BPF_LSM_CGROUP is added
> to trigger new mode; the actual lsm hook we attach to is
> signaled via existing attach_btf_id.
> 
> For the hooks that have 'struct socket' or 'struct sock' as its first
> argument, we use the cgroup associated with that socket. For the rest,
> we use 'current' cgroup (this is all on default hierarchy == v2 only).
> Note that for some hooks that work on 'struct sock' we still
> take the cgroup from 'current' because some of them work on the socket
> that hasn't been properly initialized yet.
> 
> Behind the scenes, we allocate a shim program that is attached
> to the trampoline and runs cgroup effective BPF programs array.
> This shim has some rudimentary ref counting and can be shared
> between several programs attaching to the same per-cgroup lsm hook.
nit. The 'per-cgroup' may be read as each cgroup has its own shim.
It will be useful to rephrase it a little.

> 
> Note that this patch bloats cgroup size because we add 211
> cgroup_bpf_attach_type(s) for simplicity sake. This will be
> addressed in the subsequent patch.
> 
> Also note that we only add non-sleepable flavor for now. To enable
> sleepable use-cases, bpf_prog_run_array_cg has to grab trace rcu,
> shim programs have to be freed via trace rcu, cgroup_bpf.effective
> should be also trace-rcu-managed + maybe some other changes that
> I'm not aware of.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

[ ... ]

> @@ -1840,10 +1850,8 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
>  	emit_mov_reg(&prog, true, BPF_REG_2, BPF_REG_6);
>  	/* arg3: lea rdx, [rbp - run_ctx_off] */
>  	EMIT4(0x48, 0x8D, 0x55, -run_ctx_off);
> -	if (emit_call(&prog,
> -		      p->aux->sleepable ? __bpf_prog_exit_sleepable :
> -		      __bpf_prog_exit, prog))
> -			return -EINVAL;
> +	if (emit_call(&prog, exit, prog))
> +		return -EINVAL;
>  
>  	*pprog = prog;
>  	return 0;
> diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
> index 5d268e76d8e6..b99f8c3e37ea 100644
> --- a/include/linux/bpf-cgroup-defs.h
> +++ b/include/linux/bpf-cgroup-defs.h
> @@ -10,6 +10,12 @@
>  
>  struct bpf_prog_array;
>  
> +#ifdef CONFIG_BPF_LSM
> +#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> +#else
> +#define CGROUP_LSM_NUM 0
> +#endif
> +
>  enum cgroup_bpf_attach_type {
>  	CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
>  	CGROUP_INET_INGRESS = 0,
> @@ -35,6 +41,8 @@ enum cgroup_bpf_attach_type {
>  	CGROUP_INET4_GETSOCKNAME,
>  	CGROUP_INET6_GETSOCKNAME,
>  	CGROUP_INET_SOCK_RELEASE,
> +	CGROUP_LSM_START,
> +	CGROUP_LSM_END = CGROUP_LSM_START + CGROUP_LSM_NUM - 1,
Likely a dumb question, just in case, presumably everything should be fine when
CGROUP_LSM_NUM is 0 ?

>  	MAX_CGROUP_BPF_ATTACH_TYPE
>  };
>  

[ ... ]

> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 4adb4f3ecb7f..b0314889a409 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -14,6 +14,8 @@
>  #include <linux/string.h>
>  #include <linux/bpf.h>
>  #include <linux/bpf-cgroup.h>
> +#include <linux/bpf_lsm.h>
> +#include <linux/bpf_verifier.h>
>  #include <net/sock.h>
>  #include <net/bpf_sk_storage.h>
>  
> @@ -61,6 +63,88 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
>  	return run_ctx.retval;
>  }
>  
> +unsigned int __cgroup_bpf_run_lsm_sock(const void *ctx,
> +				       const struct bpf_insn *insn)
> +{
> +	const struct bpf_prog *shim_prog;
> +	struct sock *sk;
> +	struct cgroup *cgrp;
> +	int ret = 0;
> +	u64 *args;
> +
> +	args = (u64 *)ctx;
> +	sk = (void *)(unsigned long)args[0];
> +	/*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
> +	shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> +
> +	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> +	if (likely(cgrp))
> +		ret = bpf_prog_run_array_cg(&cgrp->bpf,
> +					    shim_prog->aux->cgroup_atype,
> +					    ctx, bpf_prog_run, 0, NULL);
> +	return ret;
> +}
> +
> +unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
> +					 const struct bpf_insn *insn)
> +{
> +	const struct bpf_prog *shim_prog;
> +	struct socket *sock;
> +	struct cgroup *cgrp;
> +	int ret = 0;
> +	u64 *args;
> +
> +	args = (u64 *)ctx;
> +	sock = (void *)(unsigned long)args[0];
> +	/*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
> +	shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> +
> +	cgrp = sock_cgroup_ptr(&sock->sk->sk_cgrp_data);
> +	if (likely(cgrp))
> +		ret = bpf_prog_run_array_cg(&cgrp->bpf,
> +					    shim_prog->aux->cgroup_atype,
> +					    ctx, bpf_prog_run, 0, NULL);
> +	return ret;
> +}
> +
> +unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> +					  const struct bpf_insn *insn)
> +{
> +	const struct bpf_prog *shim_prog;
> +	struct cgroup *cgrp;
> +	int ret = 0;
> +
> +	/*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
> +	shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> +
> +	rcu_read_lock();
nit. Not needed.  May be a comment about it has been acquired
in __bpf_prog_enter_lsm_cgroup().  For sleepable in the future,
rcu_read_lock() cannot be done here also.

> +	cgrp = task_dfl_cgroup(current);
> +	if (likely(cgrp))
> +		ret = bpf_prog_run_array_cg(&cgrp->bpf,
> +					    shim_prog->aux->cgroup_atype,
> +					    ctx, bpf_prog_run, 0, NULL);
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
> +#ifdef CONFIG_BPF_LSM
> +static enum cgroup_bpf_attach_type
> +bpf_cgroup_atype_find(enum bpf_attach_type attach_type, u32 attach_btf_id)
> +{
> +	if (attach_type != BPF_LSM_CGROUP)
> +		return to_cgroup_bpf_attach_type(attach_type);
> +	return CGROUP_LSM_START + bpf_lsm_hook_idx(attach_btf_id);
> +}
> +#else
> +static enum cgroup_bpf_attach_type
> +bpf_cgroup_atype_find(enum bpf_attach_type attach_type, u32 attach_btf_id)
> +{
> +	if (attach_type != BPF_LSM_CGROUP)
> +		return to_cgroup_bpf_attach_type(attach_type);
> +	return -EOPNOTSUPP;
> +}
> +#endif /* CONFIG_BPF_LSM */
> +
>  void cgroup_bpf_offline(struct cgroup *cgrp)
>  {
>  	cgroup_get(cgrp);
> @@ -163,10 +247,20 @@ static void cgroup_bpf_release(struct work_struct *work)
>  
>  		hlist_for_each_entry_safe(pl, pltmp, progs, node) {
>  			hlist_del(&pl->node);
> -			if (pl->prog)
> +			if (pl->prog) {
> +#ifdef CONFIG_BPF_LSM
This should not be needed as it is not needed in __cgroup_bpf_attach() below.

> +				if (pl->prog->expected_attach_type == BPF_LSM_CGROUP)
> +					bpf_trampoline_unlink_cgroup_shim(pl->prog);
> +#endif
>  				bpf_prog_put(pl->prog);
> -			if (pl->link)
> +			}
> +			if (pl->link) {
> +#ifdef CONFIG_BPF_LSM
Same here.

> +				if (pl->link->link.prog->expected_attach_type == BPF_LSM_CGROUP)
> +					bpf_trampoline_unlink_cgroup_shim(pl->link->link.prog);
> +#endif
>  				bpf_cgroup_link_auto_detach(pl->link);
> +			}
>  			kfree(pl);
>  			static_branch_dec(&cgroup_bpf_enabled_key[atype]);
>  		}
> @@ -479,6 +573,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>  	struct bpf_prog *old_prog = NULL;
>  	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
>  	struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> +	struct bpf_prog *new_prog = prog ? : link->link.prog;
>  	enum cgroup_bpf_attach_type atype;
>  	struct bpf_prog_list *pl;
>  	struct hlist_head *progs;
> @@ -495,7 +590,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>  		/* replace_prog implies BPF_F_REPLACE, and vice versa */
>  		return -EINVAL;
>  
> -	atype = to_cgroup_bpf_attach_type(type);
> +	atype = bpf_cgroup_atype_find(type, new_prog->aux->attach_btf_id);
>  	if (atype < 0)
>  		return -EINVAL;
>  
> @@ -549,17 +644,30 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>  	bpf_cgroup_storages_assign(pl->storage, storage);
>  	cgrp->bpf.flags[atype] = saved_flags;
>  
> +	if (type == BPF_LSM_CGROUP) {
> +		err = bpf_trampoline_link_cgroup_shim(new_prog, atype);
> +		if (err)
> +			goto cleanup;
> +	}
> +
>  	err = update_effective_progs(cgrp, atype);
>  	if (err)
> -		goto cleanup;
> +		goto cleanup_trampoline;
>  
> -	if (old_prog)
> +	if (old_prog) {
> +		if (type == BPF_LSM_CGROUP)
> +			bpf_trampoline_unlink_cgroup_shim(old_prog);
>  		bpf_prog_put(old_prog);
> -	else
> +	} else {
>  		static_branch_inc(&cgroup_bpf_enabled_key[atype]);
> +	}
>  	bpf_cgroup_storages_link(new_storage, cgrp, type);
>  	return 0;
>  
> +cleanup_trampoline:
> +	if (type == BPF_LSM_CGROUP)
> +		bpf_trampoline_unlink_cgroup_shim(new_prog);
> +
>  cleanup:
>  	if (old_prog) {
>  		pl->prog = old_prog;
> @@ -651,7 +759,7 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
>  	struct hlist_head *progs;
>  	bool found = false;
>  
> -	atype = to_cgroup_bpf_attach_type(link->type);
> +	atype = bpf_cgroup_atype_find(link->type, new_prog->aux->attach_btf_id);
>  	if (atype < 0)
>  		return -EINVAL;
>  
> @@ -803,9 +911,15 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>  	struct bpf_prog *old_prog;
>  	struct bpf_prog_list *pl;
>  	struct hlist_head *progs;
> +	u32 attach_btf_id = 0;
>  	u32 flags;
>  
> -	atype = to_cgroup_bpf_attach_type(type);
> +	if (prog)
> +		attach_btf_id = prog->aux->attach_btf_id;
> +	if (link)
> +		attach_btf_id = link->link.prog->aux->attach_btf_id;
> +
> +	atype = bpf_cgroup_atype_find(type, attach_btf_id);
>  	if (atype < 0)
>  		return -EINVAL;
>  
> @@ -839,8 +953,11 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>  	if (hlist_empty(progs))
>  		/* last program was detached, reset flags to zero */
>  		cgrp->bpf.flags[atype] = 0;
> -	if (old_prog)
> +	if (old_prog) {
> +		if (type == BPF_LSM_CGROUP)
> +			bpf_trampoline_unlink_cgroup_shim(old_prog);
I think the same bpf_trampoline_unlink_cgroup_shim() needs to be done
in bpf_cgroup_link_release()?  It should be done just after
WARN_ON(__cgroup_bpf_detach()).

[ ... ]

> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index aeb31137b2ed..a237be4f8bb3 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -3416,6 +3416,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
>  		return BPF_PROG_TYPE_SK_LOOKUP;
>  	case BPF_XDP:
>  		return BPF_PROG_TYPE_XDP;
> +	case BPF_LSM_CGROUP:
> +		return BPF_PROG_TYPE_LSM;
>  	default:
>  		return BPF_PROG_TYPE_UNSPEC;
>  	}
> @@ -3469,6 +3471,11 @@ static int bpf_prog_attach(const union bpf_attr *attr)
>  	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
>  	case BPF_PROG_TYPE_CGROUP_SYSCTL:
>  	case BPF_PROG_TYPE_SOCK_OPS:
> +	case BPF_PROG_TYPE_LSM:
> +		if (ptype == BPF_PROG_TYPE_LSM &&
> +		    prog->expected_attach_type != BPF_LSM_CGROUP)
Check this in bpf_prog_attach_check_attach_type() where
other expected_attach_type are enforced.

> +void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog)
> +{
> +	struct bpf_shim_tramp_link *shim_link = NULL;
> +	struct bpf_trampoline *tr;
> +	bpf_func_t bpf_func;
> +	u64 key;
> +
> +	key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
> +					 prog->aux->attach_btf_id);
> +
> +	bpf_lsm_find_cgroup_shim(prog, &bpf_func);
> +	tr = bpf_trampoline_lookup(key);
> +	if (!tr)
nit. !tr should not be possible?  If not, may be a WARN_ON_ONCE()
or remove this check.

> +		return;
> +
> +	mutex_lock(&tr->mutex);
> +	shim_link = cgroup_shim_find(tr, bpf_func);
> +	mutex_unlock(&tr->mutex);
> +
> +	if (shim_link)
> +		bpf_link_put(&shim_link->link.link);
> +
> +	bpf_trampoline_put(tr); /* bpf_trampoline_lookup above */
> +}
> +#endif

[ ... ]

> diff --git a/tools/include/linux/btf_ids.h b/tools/include/linux/btf_ids.h
> index 57890b357f85..2345b502b439 100644
> --- a/tools/include/linux/btf_ids.h
> +++ b/tools/include/linux/btf_ids.h
> @@ -172,7 +172,9 @@ extern struct btf_id_set name;
>  	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)		\
>  	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)			\
>  	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)			\
> -	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)
> +	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)			\
> +	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UNIX, unix_sock)			\
The existing tools's btf_ids.h looks more outdated from
the kernel's btf_ids.h.  unix_sock is missing which is added back here.
mptcp_sock is missing also but not added.  I assume the latter test
needs unix_sock here ?

Others lgtm.
