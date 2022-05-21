Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85FAF52F70B
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353950AbiEUAxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348108AbiEUAxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:53:34 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6C31AD5AD;
        Fri, 20 May 2022 17:53:33 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KMsDHs016756;
        Fri, 20 May 2022 17:53:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=dReKlJAoh9cTQjhadVlaBca/ZLFhYcp+JdvzdGLURlg=;
 b=FWQt0c27MbC59JMv+w1aibSJ+P+R4YlDYnXYf2hKCJaVOsMb3hTpEtBoFQMZcL6rMGtW
 zBOwiGUkBUtTXY1TlC2JEg4JoeIegIfCU9ql8VtdzmbB80h+7ABss8c8A4QI1Mr9lQI6
 VZCMSPIAnqhIpFE39jEbw37LvYJ9y2mf1k4= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g5pj53ufc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 17:53:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oc8w4O7Nzv0ZjmsWlsKI3tkyKNx3XZR6vURlkzaXcg8XKJ4f6+6nJFiGBhLH7KYTNfxDlO/aL1pkT+yx69Fsm7AJoSAGWJ+7W5/ZOYdxUffiVru1Ok62gbjyT1orNNcLgGEhC/J0BUoxEVLpr6W9pGOLWWERmRP3/MH5Gz6wHcBBPc+7o5oF3Aq/QNKGY9xUxRH7NhmIoPl8vBYjE0O/RUKNtKPOgyS6sFmLzCN+SpLeUdzJJ8svHTCxkhaX+Q2/E5LUBSl0UVpnuegF0X/LXvpal9WjLvsefMEVkk0LLCW3/nfPBUviKdoYvnmKhSGi//kF/ii6s9kwak0QNglpvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dReKlJAoh9cTQjhadVlaBca/ZLFhYcp+JdvzdGLURlg=;
 b=UPR1lGyPP+Yn+sbghzMgvN3hLoQD6Ewlobd9z8FIv8M18CSi4M+xpnx0dka/RrlJQzQAYP/C+fIqNjgo1V4bIolhCyyDo0Y9NtwrZhsRiFBKMCzF2Y8ayAEAPhyJbvfDh0/zv0fC3lM6SUUjzJT6shG8PzqHWGNnDJ6oOmtubqDcMWNC+bDSDHsV+jSdXV8ZLSfIARiUWEr4ViKzXm/A8smRg4etnPdts8O/GLPrmprcb5yS7RF7XNe2b7Lsks9IpZBXZCnc93i1SyKv2cXeb0mwvXgqFXmY7rDncoO4znsZ5dgMVYX5y42uqbzHEQOcUCTZ0jgj3JB93QSMQYGJvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SJ0PR15MB4156.namprd15.prod.outlook.com (2603:10b6:a03:2e3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.18; Sat, 21 May
 2022 00:53:16 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f172:8f37:fe43:19a3]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f172:8f37:fe43:19a3%6]) with mapi id 15.20.5273.019; Sat, 21 May 2022
 00:53:16 +0000
Date:   Fri, 20 May 2022 17:53:13 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v7 03/11] bpf: per-cgroup lsm flavor
Message-ID: <20220521005313.3q3w2ventgwrccrd@kafai-mbp>
References: <20220518225531.558008-1-sdf@google.com>
 <20220518225531.558008-4-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518225531.558008-4-sdf@google.com>
X-ClientProxiedBy: BY5PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::28) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5a5e18d-504a-468b-8d4d-08da3ac44a26
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4156:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR15MB41561B83CA5B386645CC1B0DD5D29@SJ0PR15MB4156.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dnjLQrXRg6ybnjKR8LWCNHgX4fsnjcyzEg9D57kB2ASzhi3ohvUqaLtOv5kX5X1R1NO5DKAC0rgzZSaCXu02NSueHMQXxnp96JpwyaZtuihEp0p03goxRr7yePwYbiW82VzmJUdbcv8UcBxun73sEkXHGaDmyQO3KAlLL0v0V7VhxTug4dyY2rDBUV9nv0KtXR59F4qpx7QZdRaJwShV+ftSVflbmQ3zKYf6gZEtF7tB5/8Dpgv5q6sld0qu9oaQtwMLvvMnMHu3H5YBiIx/XXvSxsbHrl8RrNzfjfyILzYOiCGBdlZcostwGh9EnIg5O851dZI2/RwHKSJesIbES9cVhgwjGVCzZmbJlLy32/ObJOtza4tE88+jfApsTYz/0/16oOVRoE7U2uiBugS5wToiheVu/skUBc4x5qy3FSbDzBQrBK0haRTQDOxySok0tYo7I1kvkrPlIfJNs7DCZTlm+zsjX5cToEax04B9s3Qbmr4jJkH7gkRoRH5hhVAwWg0Qr9Kr8m1q2t3X5BuArgEQwTfz+E843+ZiNAL8u6JUXSUky2pRGzExeF7vFuwWQPcXPuXQ6/P9XGEB/YUsq2Emf/WQQucSoe7pSlb3HV4qo402YLsecw/P5RK/1xrnFn1mOVtxmpX9Xaa8eTmdug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(9686003)(6512007)(6506007)(186003)(316002)(6916009)(52116002)(66946007)(1076003)(8676002)(86362001)(83380400001)(4326008)(33716001)(8936002)(5660300002)(66476007)(2906002)(6666004)(6486002)(66556008)(38100700002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LQzjBLhRYmCdY1QPFAbmqQ8f9JwoxtoNK5yBhgokUVZM0u6zkoMMxIEJQ5E4?=
 =?us-ascii?Q?bbj/tERhmeiCyDqfGM3esPNrkpzHo8VrFg7cfRcZC6MoUC5bD4G985I00L7/?=
 =?us-ascii?Q?/UMUsB97mnySIwP/SFEIOYTOEpbmLJWnvjuRPg9sTFNx7CI6tCVscvDQaFoM?=
 =?us-ascii?Q?b7f79HMTG32SNTN+4hAesuv8lZN08CH4rkpDZgWrs48l5s2K96Z+T4bn00Ps?=
 =?us-ascii?Q?fTS7IO6f5C7XqebP62qRihEAbaRX1ISP+p93jvs31vI0lLEXkPFOd8oN7B0T?=
 =?us-ascii?Q?m3/ox9Gfg7F3q22T02thVhFew0fPEvuNQA8KPEKkByRe7c1rTOUG0CgQQ+EE?=
 =?us-ascii?Q?metpAqWhlnUgk4zthSmhxYOhF/Zx8Dk7Q0p1XEmmW+XJWUdiZlpoLy1WvkAP?=
 =?us-ascii?Q?Uj9N1ouleBTQZXaJOTR/hxk8wiP3266W6BDcucUAOQAjQdZd4alRATJFS3Or?=
 =?us-ascii?Q?JonCa+SqxuJRmnPuCvPUCRNWModtcCaQxBbOJWL4uZAZQ7wrMJk5iK4W9ePO?=
 =?us-ascii?Q?7s1GVg2cLrgN+OKUBC4clnxspu+bL6o4xRFDM+nLOVlgk/D/hEHKwq15qV99?=
 =?us-ascii?Q?x9OlEPPiZ2V/liy57/IGE/PirmSp2yEzNoBdKgBINQ2wRlrfts+t5HWJdeKP?=
 =?us-ascii?Q?giVQIpzN+RXWdx/lF8kZz1tyAoHjlaXoR1+q//LWHGVew2k80LqFY1G2nb/G?=
 =?us-ascii?Q?FN40tL0Qmk8lEwAjj27o0i3wfI6lXia3DCefJvKaeo3Y9ONk1X0X5N/qyei5?=
 =?us-ascii?Q?sRUYPpeWZpPykIW1klT/S483vBfeyNaLhkjWW2DzlwW8w60lfMBJP+8vGrWM?=
 =?us-ascii?Q?OXr7X82CqnCzq2TcvOsMUfu7FMnTaVFfjkewTQYaSbOkHiT8sQn2XUBrXXGK?=
 =?us-ascii?Q?M99H/AZhGB7Do3jbDc1XPwGCGxfJ+BjI3Y8rwK0SMjrkWZxxRqrfcSm7BA3D?=
 =?us-ascii?Q?yiR41u6NNXdDZ2GypoukcPxN75qnYGmoC9aNkipojULxIODlnjcb+xf+QgkM?=
 =?us-ascii?Q?b5ysRqVToqgikBx5YMFn3r3GA9tW0XxybRXjz1t1yuBEY5dul9zdwe2d9Rmx?=
 =?us-ascii?Q?TxqAhzE8Q869P3lLvtl0lXSPxfAI8+5mQTQGnAwpcvrtoSmpgu7+z9UrB98M?=
 =?us-ascii?Q?P/a4/cNoSqI6CDwusKWMFUcQ/61Uv+j7TI6bUwHVpYZrQycd9V/6Wq4tJNfv?=
 =?us-ascii?Q?M/LiN/lzwieTXgWzFFkFFyV6/+VvHpp35lqqjUIgfb5JIiR09htzF5AHT5j9?=
 =?us-ascii?Q?M5nJf6rUj8pwJyKGqDxjKItnms/BUV0dMLFZxYCN95eHIRPOEkltQSoQ7ber?=
 =?us-ascii?Q?m9sMWy3bPnKCen5xrq9nLEeDPFWQm/yUFh1lZFsDc9wzbJnbTRzSoWyovM79?=
 =?us-ascii?Q?rCMfONdtUL41Xy/s5KymUiAXAhga48rFjhHmTqKxn3JjK4VHfLAKy4ITZbLU?=
 =?us-ascii?Q?w+T46oxFYynEJykmiGYYv9W5O0nsUa3meVD/VBiPyDu+DYE8Q7MMNbIk5ln+?=
 =?us-ascii?Q?D3Qx6yIEWb6E6eXMTtHStwtoQ6g/Fvnb7fV45a5IdlcrhK6ZrjHQasZNLmm4?=
 =?us-ascii?Q?SNjhkG95wb3UB9vEBmI8zIOKk+BXh8fp9/xQo6r3BjAbi06cEw2SwBr7qK0Y?=
 =?us-ascii?Q?/kiKG7e53euHVvY50QUleAXwLjbC2/OLMoskfuqjHYESHEVsrwTDhw1ax/Rf?=
 =?us-ascii?Q?ecGjnOrL9BGfDKCUmeWkdcI8ASCEdB4Ct2JXKPADsdaWhgq60KbZt+0IfS1z?=
 =?us-ascii?Q?UUEExWgaNRJefmaUuhwvWUQJysfsdm4=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5a5e18d-504a-468b-8d4d-08da3ac44a26
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 00:53:16.0887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VmK3/YGmWzCZZHjqi3ICIEzOEsqbjWCUdk/JhrllFnmT4oBYSbHDnMHDy0stm9Ii
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4156
X-Proofpoint-GUID: cpryEoATiGtH3AP-xtaVPU4YL0LM23ys
X-Proofpoint-ORIG-GUID: cpryEoATiGtH3AP-xtaVPU4YL0LM23ys
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_08,2022-05-20_02,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 03:55:23PM -0700, Stanislav Fomichev wrote:

[ ... ]

> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index ea3674a415f9..70cf1dad91df 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -768,6 +768,10 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start, struct bpf_tramp_
>  u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog, struct bpf_tramp_run_ctx *run_ctx);
>  void notrace __bpf_prog_exit_sleepable(struct bpf_prog *prog, u64 start,
>  				       struct bpf_tramp_run_ctx *run_ctx);
> +u64 notrace __bpf_prog_enter_lsm_cgroup(struct bpf_prog *prog,
> +					struct bpf_tramp_run_ctx *run_ctx);
> +void notrace __bpf_prog_exit_lsm_cgroup(struct bpf_prog *prog, u64 start,
> +					struct bpf_tramp_run_ctx *run_ctx);
>  void notrace __bpf_tramp_enter(struct bpf_tramp_image *tr);
>  void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr);
>  
> @@ -1035,6 +1039,7 @@ struct bpf_prog_aux {
>  	u64 load_time; /* ns since boottime */
>  	u32 verified_insns;
>  	struct bpf_map *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
> +	int cgroup_atype; /* enum cgroup_bpf_attach_type */
>  	char name[BPF_OBJ_NAME_LEN];
>  #ifdef CONFIG_SECURITY
>  	void *security;
> @@ -1107,6 +1112,12 @@ struct bpf_tramp_link {
>  	u64 cookie;
>  };
>  
> +struct bpf_shim_tramp_link {
> +	struct bpf_tramp_link tramp_link;
> +	struct bpf_trampoline *tr;
> +	atomic64_t refcnt;
There is already a refcnt in 'struct bpf_link'.
Reuse that one if possible.

[ ... ]

> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 01ce78c1df80..c424056f0b35 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -11,6 +11,8 @@
>  #include <linux/rcupdate_wait.h>
>  #include <linux/module.h>
>  #include <linux/static_call.h>
> +#include <linux/bpf_verifier.h>
> +#include <linux/bpf_lsm.h>
>  
>  /* dummy _ops. The verifier will operate on target program's ops. */
>  const struct bpf_verifier_ops bpf_extension_verifier_ops = {
> @@ -497,6 +499,163 @@ int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampolin
>  	return err;
>  }
>  
> +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_BPF_SYSCALL)
> +static struct bpf_shim_tramp_link *cgroup_shim_alloc(const struct bpf_prog *prog,
> +						     bpf_func_t bpf_func)
> +{
> +	struct bpf_shim_tramp_link *shim_link = NULL;
> +	struct bpf_prog *p;
> +
> +	shim_link = kzalloc(sizeof(*shim_link), GFP_USER);
> +	if (!shim_link)
> +		return NULL;
> +
> +	p = bpf_prog_alloc(1, 0);
> +	if (!p) {
> +		kfree(shim_link);
> +		return NULL;
> +	}
> +
> +	p->jited = false;
> +	p->bpf_func = bpf_func;
> +
> +	p->aux->cgroup_atype = prog->aux->cgroup_atype;
> +	p->aux->attach_func_proto = prog->aux->attach_func_proto;
> +	p->aux->attach_btf_id = prog->aux->attach_btf_id;
> +	p->aux->attach_btf = prog->aux->attach_btf;
> +	btf_get(p->aux->attach_btf);
> +	p->type = BPF_PROG_TYPE_LSM;
> +	p->expected_attach_type = BPF_LSM_MAC;
> +	bpf_prog_inc(p);
> +	bpf_link_init(&shim_link->tramp_link.link, BPF_LINK_TYPE_TRACING, NULL, p);
> +	atomic64_set(&shim_link->refcnt, 1);
> +
> +	return shim_link;
> +}
> +
> +static struct bpf_shim_tramp_link *cgroup_shim_find(struct bpf_trampoline *tr,
> +						    bpf_func_t bpf_func)
> +{
> +	struct bpf_tramp_link *link;
> +	int kind;
> +
> +	for (kind = 0; kind < BPF_TRAMP_MAX; kind++) {
> +		hlist_for_each_entry(link, &tr->progs_hlist[kind], tramp_hlist) {
> +			struct bpf_prog *p = link->link.prog;
> +
> +			if (p->bpf_func == bpf_func)
> +				return container_of(link, struct bpf_shim_tramp_link, tramp_link);
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
> +static void cgroup_shim_put(struct bpf_shim_tramp_link *shim_link)
> +{
> +	if (shim_link->tr)
I have been spinning back and forth with this "shim_link->tr" test and
the "!shim_link->tr" test below with an atomic64_dec_and_test() test
in between  :)

> +		bpf_trampoline_put(shim_link->tr);
Why put(tr) here? 

Intuitive thinking is that should be done after __bpf_trampoline_unlink_prog(.., tr)
which is still using the tr.
or I missed something inside __bpf_trampoline_unlink_prog(..., tr) ?

> +
> +	if (!atomic64_dec_and_test(&shim_link->refcnt))
> +		return;
> +
> +	if (!shim_link->tr)
And this is only for the error case in bpf_trampoline_link_cgroup_shim()?
Can it be handled locally in bpf_trampoline_link_cgroup_shim()
where it could actually happen ?

> +		return;
> +
> +	WARN_ON_ONCE(__bpf_trampoline_unlink_prog(&shim_link->tramp_link, shim_link->tr));
> +	kfree(shim_link);
How about shim_link->tramp_link.link.prog, is the prog freed ?

Considering the bpf_link_put() does bpf_prog_put(link->prog).
Is there a reason the bpf_link_put() not used and needs to
manage its own shim_link->refcnt here ?

> +}
> +
> +int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
> +				    struct bpf_attach_target_info *tgt_info)
> +{
> +	struct bpf_shim_tramp_link *shim_link = NULL;
> +	struct bpf_trampoline *tr;
> +	bpf_func_t bpf_func;
> +	u64 key;
> +	int err;
> +
> +	key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
> +					 prog->aux->attach_btf_id);
> +
> +	err = bpf_lsm_find_cgroup_shim(prog, &bpf_func);
> +	if (err)
> +		return err;
> +
> +	tr = bpf_trampoline_get(key, tgt_info);
> +	if (!tr)
> +		return  -ENOMEM;
> +
> +	mutex_lock(&tr->mutex);
> +
> +	shim_link = cgroup_shim_find(tr, bpf_func);
> +	if (shim_link) {
> +		/* Reusing existing shim attached by the other program. */
> +		atomic64_inc(&shim_link->refcnt);
> +		/* note, we're still holding tr refcnt from above */
hmm... why it still needs to hold the tr refcnt ?

> +
> +		mutex_unlock(&tr->mutex);
> +		return 0;
> +	}
> +
> +	/* Allocate and install new shim. */
> +
> +	shim_link = cgroup_shim_alloc(prog, bpf_func);
> +	if (!shim_link) {
> +		bpf_trampoline_put(tr);
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	err = __bpf_trampoline_link_prog(&shim_link->tramp_link, tr);
> +	if (err)
> +		goto out;
> +
> +	shim_link->tr = tr;
> +
> +	mutex_unlock(&tr->mutex);
> +
> +	return 0;
> +out:
> +	mutex_unlock(&tr->mutex);
> +
> +	if (shim_link)
> +		cgroup_shim_put(shim_link);
> +
> +	return err;
> +}
> +
