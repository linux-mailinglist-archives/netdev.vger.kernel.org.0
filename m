Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FF051E269
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444902AbiEFXGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 19:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343967AbiEFXGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 19:06:50 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FAE50463;
        Fri,  6 May 2022 16:03:05 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 246MWGc3005333;
        Fri, 6 May 2022 16:02:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=40qsjXjlup5Og1Y3jz2F6o9fIf82r61gcGcltlBVLiw=;
 b=fqhiEG3cChiv/nN6nTj6ue41XYEysvS84Vq2iLLWSRtroGEI+2DaCSfufbW/XK5Br5fi
 jy5o7DVfWvuZ+GtULfYsqVGNiTQ8UrGG8KqtXM2h6MaRRLn0guAMX7qRkFoCiiczQrrN
 w0YVje40hSQdtpBviwYhbiotxPw1CunpQUM= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by m0001303.ppops.net (PPS) with ESMTPS id 3fw8b7hsap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 16:02:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rbkdqkv9Km6F4dESs5WXiYngnIVCSRXY/paHwDvBLI2/iz5Mb3UvbHf72BoS6fgRnstgVpaSLYCYvFQ3rZlhYrIBMwuEzJmZsiKsykuMQyjO+diuMJqOE8nhyKKY30GeUY7e+JzpYoFhob5ySvDRpVjG9n8O8AMzr/TcVMOF8wi0OauGVhMWrakNpMhbl24D+c1+E4R7rxrOkRNokeAZoA679WKNxNWhOv20/cNfn5tA9ZwSWwxo97mHz881LDuL8uK7GBKWDHFMDLyo+mqCTGMWqqeJYjVQUtQkqvYpBWNrI2yqEdQWyWioW9yJ11DbWxP9fX+5prR1tLk4bYaiZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=40qsjXjlup5Og1Y3jz2F6o9fIf82r61gcGcltlBVLiw=;
 b=AWnFHunD/u45mgGX9G18iC8VgOreZqqIs41PWcTOnmwUzTXMRJ5DNcANs1mWpk99VHTLsNUnjGNjDmlINdx0z46c4SVnKl6W6fi+RWz5+/xgLeeAhwG2tukCs9Sgt6UMtoTsS1OL0CuLk3OiclcCFq6KZFrkeU0b7ArGkderazW+E10yF/ArH08fOjIIVh6/YLEwd7rnaCGfcO+/3TuwMobZFQTWVf3oYoNf38L5fKbHN8KXRskVYKpkDipb6MpiAKXS+OETx3MUyzy3hN/4CnaMtZnGZ6TONc6uOpcM/r4RNaNrxNTReUJruAkWZVZEgTibN0ANxrC598hsc2xRIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by CY4PR15MB1400.namprd15.prod.outlook.com (2603:10b6:903:f9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.27; Fri, 6 May
 2022 23:02:47 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::5f5:8b2a:4022:c566]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::5f5:8b2a:4022:c566%4]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 23:02:46 +0000
Date:   Fri, 6 May 2022 16:02:44 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v6 03/10] bpf: per-cgroup lsm flavor
Message-ID: <20220506230244.4t4p5gnbgg6i4tht@kafai-mbp.dhcp.thefacebook.com>
References: <20220429211540.715151-1-sdf@google.com>
 <20220429211540.715151-4-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220429211540.715151-4-sdf@google.com>
X-ClientProxiedBy: BYAPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:a03:114::37) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1b5b542-f2cb-45b0-b532-08da2fb488fc
X-MS-TrafficTypeDiagnostic: CY4PR15MB1400:EE_
X-Microsoft-Antispam-PRVS: <CY4PR15MB140079B99F243B80508A736CD5C59@CY4PR15MB1400.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lEIheBPeh5uFQEAWZ3knvWuPg1aClqbWW+aU/XFHWC1rzB1mzbou68MN1Bx/3ZMtTekoAj84j9LniqpqLzZBp/Y8xQhJWAZMoDXhTStTar20YUG877Xfi1WdKeqyWdS5cYIe2GNEBs69myl7VKZBtRuCVwdrsejcKpFaQSaNyVcXT1BPCB0Kc4bSlZTx2ZsVxK8uhuRNgkajFgu7d8p8G1O6SiIyKJmUPZfpWBdGS1ICgr0d1ZnaQAQFZh4ttKBW9mEAvxQ+HMPpKulGIzuOVb8Cpb3+9Cun5Bv/vF7H324VFc1hsKIOpkRF82V95uKP/jeAruQgeJppPBTYkj9nwyQLCKFUNKfHNSdK97LGy2bFic0AP80I68H4kT9fiPJB1BdIeqKqCysz6Tef08KfQ5gVtFQs31p8j7V9LyCl+s1yoA6P367yF/vOwgEXVtpZfyMDaGKgBd1KZUM8p90t2y0IVQBwC0fJVNIoA6IBLaSubUXzWcSfjrD09wR/cEdPJPVMEra9Wb8HV29avuE/XbewCpqdAdq9glD1f+0jNgj3gY+ou8YS3pu4ydzQfeEeSiE/Y+tET3jZvWkI1+CPjbI4ADeCddBaPizCYFRuLYrtlFB9rKQkuwtwalONgDFaS8wv20kVO4PnQfvv6EcsTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(9686003)(6506007)(2906002)(6512007)(52116002)(86362001)(186003)(316002)(6916009)(6486002)(83380400001)(1076003)(38100700002)(8936002)(30864003)(4326008)(5660300002)(66476007)(66556008)(66946007)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YSXgbSIpAjnw5QLeKiBp6Pf74iFmqKUgfhsPwRMY9lq8HlLv0QonSlneu5wJ?=
 =?us-ascii?Q?MeHgIWe7LTtQ+WW6gHjMRjG56jTnVDwRXUZpQkUK2Vc6ZicHGZZWfcbEwX4I?=
 =?us-ascii?Q?tUKeSM6QZRko1fyWbPMBsIF5OdtTLrZPfID16wNKQWslvjevfEC2wL0UeC1b?=
 =?us-ascii?Q?rF9rPdnDmPmuWRf0ehcEpbdWc0lMLkZ+9rbGloquY01Oq6zXnX8hIWzPkjBv?=
 =?us-ascii?Q?6rIUz5dn+9Sxu0cyM8lO7Ca2lIobDYCroAB3L8+ytuyGfDGGTh7Ig9/Ov1wv?=
 =?us-ascii?Q?P36mXYXRsAJ+I+SWZ/vSGZZG1udnGo1GBXVmOeoZylqzmkqqeSnqC6U2CaQy?=
 =?us-ascii?Q?oa7WfoCXfzjKUEvPaGfSkb1aS6BOHiSxeaoM/VXjgwVVpwZZYYUDF2bCfcC0?=
 =?us-ascii?Q?K0ZlmA+QnUysXCuV2ttjic2cLnyqBu1ecxRe2uJGuAPiwcvO1w9keAGFrbuC?=
 =?us-ascii?Q?y4s+nEw15TahylqznHwM0VNsUKG2tHSZrxdD6lawSiTsk8CCojKuKYli/H6B?=
 =?us-ascii?Q?BjllPKwVa9Q6Z2N9WheJnF6PIK0fPX3TPMNtLCV3OXIjm2EmK6f16HsQ4eVY?=
 =?us-ascii?Q?of3Za1AmyCS1W+xO4g2MWeoit743smG+qv8zkyxXgmpEmJwrIocgvmml0nDn?=
 =?us-ascii?Q?njLuKTZZKKqUEIvM8uDSF5yonGtzLvtXf+F5vd85Z+47IMidlTSzAKmKVCC+?=
 =?us-ascii?Q?VghYY5lyV/dtceI+WIvMx6p7dK2pyUdzn3wdhvEhxq126Z1rFK3CveHTRfCn?=
 =?us-ascii?Q?ih2wLsQiU6UDlK5XcjKYE3yGiaIABwXS1y0J52cUsJb/rj+1ysLR3Qckl2ML?=
 =?us-ascii?Q?SLYRRPkBs4xJ6vjtAr6+DIMssU+hzd/9Lk9zEqTn80y9AIFagB8MQ/sfKoav?=
 =?us-ascii?Q?6fR5Ylyo/TQFEOlE7zcTSpEYz0m9PzNiOTXFhbaja6pSLLI8d0KjMX5JBYzJ?=
 =?us-ascii?Q?04f7ipgffXJaLLK1M4BLtaY7iQeu+UxJ0CGSTqfZQIAGYL+0NmDY+6Ul7SyA?=
 =?us-ascii?Q?ZvbsUD1l9ZPxi57shOQDcH/QAk80Ive0BMfDJ2kRs7JDmbhIJHaHLBARkWGZ?=
 =?us-ascii?Q?1vYxND8QtpML/77a4lqjAde5YWe+IkxKlbTy0VlCJrCHb4AXXveRClGJETgN?=
 =?us-ascii?Q?rfTY71nOcVCjFOedO404pRy7wFQ09SO+GeOQH0w+h1th9oInv0MtHN1sYVCS?=
 =?us-ascii?Q?3H7ZzJ4sKclXXYhz/AZDFFU4teGmtvib4/QjJu6Cq4D4jk5GxZo49jrRxlHP?=
 =?us-ascii?Q?6G46PrrkE0u8BxrtNeE1okSwLA837G7FtiTv/xskGrgKQeDaK7mi6mI6EP2Z?=
 =?us-ascii?Q?3MaE+3oMDS2KriEbAw20bCg/+z6pdDOyHXhUE8AtdTKv+kuzAOSeETeRX7Rt?=
 =?us-ascii?Q?fuE3ibQV4JUOkKtdxphsPXH8yPrOkpbjFhS0vafQa6+kU/e5fTlVYOVv//zg?=
 =?us-ascii?Q?De2owcXEgVAyp9zNyF4xbi6wuUK1tlqVavy7dbtSD0acOgxjbnQpOCKXlPSD?=
 =?us-ascii?Q?CgPYKTF4o7cbtOMAJpq6HyDrezie+HQWAPswmd3RsnPL6XD9l36ixBWyGUJT?=
 =?us-ascii?Q?tq2WxPbt/u7bc0i+uWuowZUmjT4V4uoKNpLOvpzKUkb2KlObCvW2EFQKYrMc?=
 =?us-ascii?Q?6yJxLmpYyPATZcT/zf9H0ZPZtts9gWfYeOWp2nqCLhpIA8OIOBxO9wL/cXIl?=
 =?us-ascii?Q?RBUHvkcPNygdvBjH/bO76shjlWZOPmk5vfVz3HPLgw/BrnMckgTC/KrVWv5L?=
 =?us-ascii?Q?XN+EqTEZX6sU+XAIS2+klOf+7YOCQPs=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1b5b542-f2cb-45b0-b532-08da2fb488fc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 23:02:46.8821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JS0OW7ph9cFKAnhT4vr8gYewXzs1pFz3omI40nrUplzZU4ConJIoVcIDDcluv+2v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1400
X-Proofpoint-GUID: QefBrWipha3epNogsh7HrSu2fN9oTJ0I
X-Proofpoint-ORIG-GUID: QefBrWipha3epNogsh7HrSu2fN9oTJ0I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_07,2022-05-06_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 02:15:33PM -0700, Stanislav Fomichev wrote:
> diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> index 064eccba641d..a0e68ef5dfb1 100644
> --- a/kernel/bpf/bpf_lsm.c
> +++ b/kernel/bpf/bpf_lsm.c
> @@ -16,6 +16,7 @@
>  #include <linux/bpf_local_storage.h>
>  #include <linux/btf_ids.h>
>  #include <linux/ima.h>
> +#include <linux/bpf-cgroup.h>
>  
>  /* For every LSM hook that allows attachment of BPF programs, declare a nop
>   * function where a BPF program can be attached.
> @@ -35,6 +36,66 @@ BTF_SET_START(bpf_lsm_hooks)
>  #undef LSM_HOOK
>  BTF_SET_END(bpf_lsm_hooks)
>  
> +/* List of LSM hooks that should operate on 'current' cgroup regardless
> + * of function signature.
> + */
> +BTF_SET_START(bpf_lsm_current_hooks)
> +/* operate on freshly allocated sk without any cgroup association */
> +BTF_ID(func, bpf_lsm_sk_alloc_security)
> +BTF_ID(func, bpf_lsm_sk_free_security)
> +BTF_SET_END(bpf_lsm_current_hooks)
> +
> +int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
> +			     bpf_func_t *bpf_func)
> +{
> +	const struct btf_type *first_arg_type;
> +	const struct btf_type *sock_type;
> +	const struct btf_type *sk_type;
> +	const struct btf *btf_vmlinux;
> +	const struct btf_param *args;
> +	s32 type_id;
> +
> +	if (!prog->aux->attach_func_proto ||
> +	    !btf_type_is_func_proto(prog->aux->attach_func_proto))
Also remove these tests during the attach time.  These should have
already been checked during the load time.

> +		return -EINVAL;
> +
> +	if (btf_type_vlen(prog->aux->attach_func_proto) < 1 ||
> +	    btf_id_set_contains(&bpf_lsm_current_hooks,
> +				prog->aux->attach_btf_id)) {
> +		*bpf_func = __cgroup_bpf_run_lsm_current;
> +		return 0;
> +	}
> +
> +	args = btf_params(prog->aux->attach_func_proto);
> +
> +	btf_vmlinux = bpf_get_btf_vmlinux();
> +
> +	type_id = btf_find_by_name_kind(btf_vmlinux, "socket", BTF_KIND_STRUCT);
> +	if (type_id < 0)
> +		return -EINVAL;
> +	sock_type = btf_type_by_id(btf_vmlinux, type_id);
> +
> +	type_id = btf_find_by_name_kind(btf_vmlinux, "sock", BTF_KIND_STRUCT);
> +	if (type_id < 0)
> +		return -EINVAL;
> +	sk_type = btf_type_by_id(btf_vmlinux, type_id);
Although practical kconfig should have CONFIG_NET, not sure btf has
"socket" and "sock" in some unusual kconfig setup.  If it does not, it will
return error too early for other hooks.

May be put them under "#ifdef CONFIG_NET"?  While adding CONFIG_NET,
it will be easier to just use the btf_sock_ids[].  "socket" needs to be
added to btf_sock_ids[].  Take a look at btf_ids.h and filter.c.

> +
> +	first_arg_type = btf_type_resolve_ptr(btf_vmlinux, args[0].type, NULL);
> +	if (first_arg_type == sock_type)
> +		*bpf_func = __cgroup_bpf_run_lsm_socket;
> +	else if (first_arg_type == sk_type)
> +		*bpf_func = __cgroup_bpf_run_lsm_sock;
> +	else
> +		*bpf_func = __cgroup_bpf_run_lsm_current;
> +
> +	return 0;
> +}

[ ... ]

> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 134785ab487c..9cc38454e402 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -14,6 +14,9 @@
>  #include <linux/string.h>
>  #include <linux/bpf.h>
>  #include <linux/bpf-cgroup.h>
> +#include <linux/btf_ids.h>
> +#include <linux/bpf_lsm.h>
> +#include <linux/bpf_verifier.h>
>  #include <net/sock.h>
>  #include <net/bpf_sk_storage.h>
>  
> @@ -61,6 +64,85 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
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
> +	u64 *regs;
> +
> +	regs = (u64 *)ctx;
> +	sk = (void *)(unsigned long)regs[BPF_REG_0];
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
> +	u64 *regs;
> +
> +	regs = (u64 *)ctx;
> +	sock = (void *)(unsigned long)regs[BPF_REG_0];
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
From lsm_hook_defs.h, there are some default return values that are not 0.
Is it ok to always return 0 in cases like the cgroup array is empty ?

> +
> +	if (unlikely(!current))
> +		return 0;
> +
> +	/*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
> +	shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> +
> +	rcu_read_lock();
> +	cgrp = task_dfl_cgroup(current);
> +	if (likely(cgrp))
> +		ret = bpf_prog_run_array_cg(&cgrp->bpf,
> +					    shim_prog->aux->cgroup_atype,
> +					    ctx, bpf_prog_run, 0, NULL);
> +	rcu_read_unlock();
> +	return ret;
> +}

[ ... ]

> @@ -479,6 +572,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>  	struct bpf_prog *old_prog = NULL;
>  	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
>  	struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> +	struct bpf_attach_target_info tgt_info = {};
>  	enum cgroup_bpf_attach_type atype;
>  	struct bpf_prog_list *pl;
>  	struct hlist_head *progs;
> @@ -495,9 +589,34 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>  		/* replace_prog implies BPF_F_REPLACE, and vice versa */
>  		return -EINVAL;
>  
> -	atype = to_cgroup_bpf_attach_type(type);
> -	if (atype < 0)
> -		return -EINVAL;
> +	if (type == BPF_LSM_CGROUP) {
> +		struct bpf_prog *p = prog ? : link->link.prog;
nit. This "prog ? ...." has been done multiple times (new and existing codes)
in this function.  may be do it once at the very beginning.

> +
> +		if (replace_prog) {
> +			/* Reusing shim from the original program. */
> +			if (replace_prog->aux->attach_btf_id !=
> +			    p->aux->attach_btf_id)
> +				return -EINVAL;
> +
> +			atype = replace_prog->aux->cgroup_atype;
> +		} else {
> +			err = bpf_check_attach_target(NULL, p, NULL,
> +						      p->aux->attach_btf_id,
> +						      &tgt_info);
> +			if (err)
> +				return -EINVAL;
return err;

> +
> +			atype = bpf_lsm_attach_type_get(p->aux->attach_btf_id);
> +			if (atype < 0)
> +				return atype;
> +		}
> +
> +		p->aux->cgroup_atype = atype;
> +	} else {
> +		atype = to_cgroup_bpf_attach_type(type);
> +		if (atype < 0)
> +			return -EINVAL;
> +	}
>  
>  	progs = &cgrp->bpf.progs[atype];

[ ... ]

> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 0c4fd194e801..77dfa517c47c 100644
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
> @@ -485,6 +487,147 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
>  	return err;
>  }
>  
> +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_BPF_SYSCALL)
> +static struct bpf_prog *cgroup_shim_alloc(const struct bpf_prog *prog,
> +					  bpf_func_t bpf_func)
> +{
> +	struct bpf_prog *p;
> +
> +	p = bpf_prog_alloc(1, 0);
> +	if (!p)
> +		return NULL;
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
> +
> +	return p;
> +}
> +
> +static struct bpf_prog *cgroup_shim_find(struct bpf_trampoline *tr,
> +					 bpf_func_t bpf_func)
> +{
> +	const struct bpf_prog_aux *aux;
> +	int kind;
> +
> +	for (kind = 0; kind < BPF_TRAMP_MAX; kind++) {
> +		hlist_for_each_entry(aux, &tr->progs_hlist[kind], tramp_hlist) {
> +			struct bpf_prog *p = aux->prog;
> +
> +			if (p->bpf_func == bpf_func)
> +				return p;
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
> +int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
> +				    struct bpf_attach_target_info *tgt_info)
> +{
> +	struct bpf_prog *shim_prog = NULL;
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
> +	shim_prog = cgroup_shim_find(tr, bpf_func);
> +	if (shim_prog) {
> +		/* Reusing existing shim attached by the other program. */
> +		bpf_prog_inc(shim_prog);
> +		mutex_unlock(&tr->mutex);
> +		return 0;
> +	}
> +
> +	/* Allocate and install new shim. */
> +
> +	shim_prog = cgroup_shim_alloc(prog, bpf_func);
> +	if (!shim_prog) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	err = __bpf_trampoline_link_prog(shim_prog, tr);
> +	if (err)
> +		goto out;
> +
> +	mutex_unlock(&tr->mutex);
> +
> +	return 0;
> +out:
> +	if (shim_prog)
> +		bpf_prog_put(shim_prog);
> +
bpf_trampoline_get() was done earlier.
Does it need to call bpf_trampoline_put(tr) in error cases ?
More on tr refcnt later.

> +	mutex_unlock(&tr->mutex);
> +	return err;
> +}
> +
> +void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog)
> +{
> +	struct bpf_prog *shim_prog;
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
> +		return;
> +
> +	tr = bpf_trampoline_lookup(key);
> +	if (!tr)
> +		return;
> +
> +	mutex_lock(&tr->mutex);
> +
> +	shim_prog = cgroup_shim_find(tr, bpf_func);
> +	if (shim_prog) {
> +		/* We use shim_prog refcnt for tracking whether to
> +		 * remove the shim program from the trampoline.
> +		 * Trampoline's mutex is held while refcnt is
> +		 * added/subtracted so we don't need to care about
> +		 * potential races.
> +		 */
> +
> +		if (atomic64_read(&shim_prog->aux->refcnt) == 1)
> +			WARN_ON_ONCE(__bpf_trampoline_unlink_prog(shim_prog, tr));
> +
> +		bpf_prog_put(shim_prog);
> +	}
> +
> +	mutex_unlock(&tr->mutex);
> +
> +	bpf_trampoline_put(tr); /* bpf_trampoline_lookup */
> +
> +	if (shim_prog)
> +		bpf_trampoline_put(tr);
While looking at the bpf_trampoline_{link,unlink}_cgroup_shim() again,
which prog (cgroup lsm progs or shim_prog) actually owns the tr.
It should be the shim_prog ?

How about storing tr in "shim_prog->aux->dst_trampoline = tr;"
Then the earlier bpf_prog_put(shim_prog) in this function will take care
of the bpf_trampoline_put(shim_prog->aux->dst_trampoline)
instead of each cgroup lsm prog owns a refcnt of the tr
and then this individual bpf_trampoline_put(tr) here can also
go away.

> +}
> +#endif
> +
>  struct bpf_trampoline *bpf_trampoline_get(u64 key,
>  					  struct bpf_attach_target_info *tgt_info)
>  {
> @@ -609,6 +752,24 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
>  	rcu_read_unlock();
>  }
>  
> +u64 notrace __bpf_prog_enter_lsm_cgroup(struct bpf_prog *prog)
> +	__acquires(RCU)
> +{
> +	/* Runtime stats are exported via actual BPF_LSM_CGROUP
> +	 * programs, not the shims.
> +	 */
> +	rcu_read_lock();
> +	migrate_disable();
> +	return NO_START_TIME;
> +}
> +
> +void notrace __bpf_prog_exit_lsm_cgroup(struct bpf_prog *prog, u64 start)
> +	__releases(RCU)
> +{
> +	migrate_enable();
> +	rcu_read_unlock();
> +}
> +
>  u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog)
>  {
>  	rcu_read_lock_trace();
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 813f6ee80419..99703d96c579 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -14455,6 +14455,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
>  		fallthrough;
>  	case BPF_MODIFY_RETURN:
>  	case BPF_LSM_MAC:
> +	case BPF_LSM_CGROUP:
>  	case BPF_TRACE_FENTRY:
>  	case BPF_TRACE_FEXIT:
>  		if (!btf_type_is_func(t)) {
> @@ -14633,6 +14634,33 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
>  	return 0;
>  }
>  
> +static int check_used_maps(struct bpf_verifier_env *env)
> +{
> +	int i;
> +
> +	for (i = 0; i < env->used_map_cnt; i++) {
> +		struct bpf_map *map = env->used_maps[i];
> +
> +		switch (env->prog->expected_attach_type) {
> +		case BPF_LSM_CGROUP:
> +			if (map->map_type != BPF_MAP_TYPE_CGROUP_STORAGE &&
> +			    map->map_type != BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
> +				break;
> +
> +			if (map->key_size != sizeof(__u64)) {
Follow on my very last comment in v5.  I think we should not
limit the bpf_cgroup_storage_key and should allow using both
cgroup_inode_id and attach_type as the key to avoid
inconsistent surprise (some keys are not allowed in a specific
attach_type), so this check_used_maps() function can also be avoided.

> +				verbose(env, "only global cgroup local storage is supported for BPF_LSM_CGROUP\n");
> +				return -EINVAL;
> +			}
> +
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  struct btf *bpf_get_btf_vmlinux(void)
>  {
>  	if (!btf_vmlinux && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) {
> @@ -14854,6 +14882,10 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
>  		convert_pseudo_ld_imm64(env);
>  	}
>  
> +	ret = check_used_maps(env);
> +	if (ret < 0)
> +		goto err_release_maps;
> +
>  	adjust_btf_func(env);
>  
>  err_release_maps:
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 444fe6f1cf35..112e396bbe65 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -998,6 +998,7 @@ enum bpf_attach_type {
>  	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
>  	BPF_PERF_EVENT,
>  	BPF_TRACE_KPROBE_MULTI,
> +	BPF_LSM_CGROUP,
>  	__MAX_BPF_ATTACH_TYPE
>  };
>  
> -- 
> 2.36.0.464.gb9c8b46e94-goog
> 

