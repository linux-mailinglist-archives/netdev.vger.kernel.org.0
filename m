Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5399B3B9A66
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 03:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbhGBBHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 21:07:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21894 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234579AbhGBBHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 21:07:45 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16210qFC007100;
        Thu, 1 Jul 2021 18:05:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=hw/lMnkTbVIvkHNrLfZvE1RQhg+VUhlxuj6GP0PM5OI=;
 b=gPJ68bUpVvVr5R8E4CAnpcTOhVycxD8/CundlQ0DUasj71xEjlHf7sEKQyKvw3oSrCto
 aSCAqrXnd61H+E+q1jFqYAOltbx3BVtoW4TZIMGqjr95oM7zBkfV3X7oSaYRaB8iM6Kt
 RvXdYNraflwpa0MuBQZlt4z0Hbk8/vLxLCY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39hmwy1619-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 01 Jul 2021 18:05:00 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Jul 2021 18:04:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PYBLu2u/8SXok5JwmYFJlBg2ZSrqLNfUa88I9PW6S/adW+NDC7Ayr/XN79LoH4XGuvAVQ9KQP1KZ/54JYg3/sdbvX9k6Oq6WxL6aj38XEyr7oBEOIMbBM4r1HI9PeNFS3RuQzJ3mnz8F8z+nV3c+b9gd7teO/CHpvrK+M9EIBdHivXpqpNrYMNIUC45tj+ktFW4o3wSuAWJmEz+N9qRPzB5wMVlvXazngDomRO4pvPGxWic4eF2oW9t0miblHnAJ8b+uLS+VmfXdMCtQw9J7nt3dOq5An7NA2jb20Ta00OywFDax1Vm5/YtVCA4sxkzS/7PKxhL5165OboJwiwLbpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hw/lMnkTbVIvkHNrLfZvE1RQhg+VUhlxuj6GP0PM5OI=;
 b=J2XCarSNGFsN1D5UXi+TqA9ZlxoS9EMpYe2O8Wdit4ikMSWnYLZPWemC6szC24JfGcwxcEW5NaUWG7hEeuby/wDS7+I7pUd8BuqKK9D/c77V4mAH57btg31nUQscxOUiQtyI9Ne5Li2b1vN4ACX0NjrLKhOHC2BvGV3ONd8u8U7JVO+88Tm70zjfbLnbGm+KPkzzuqyCHoS/L6V2GUxfiU5xziS2/52yvtxwsLfibJsykMcBtJby2DJI+gpj0rXEiFx/REy4suUD0t9argEHHvjWOhk/ucLCFjqu78tsj3CMYqQaK7VSmEd/Dy1twt7l76n/ig25ZBIZ45dckoTU0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB5047.namprd15.prod.outlook.com (2603:10b6:806:1da::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.23; Fri, 2 Jul
 2021 01:04:57 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f%7]) with mapi id 15.20.4287.024; Fri, 2 Jul 2021
 01:04:57 +0000
Date:   Thu, 1 Jul 2021 18:04:55 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <davem@davemloft.net>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 1/9] bpf: Introduce bpf timers.
Message-ID: <20210702010455.3h4v5c4g7wx2aeth@kafai-mbp.dhcp.thefacebook.com>
References: <20210701192044.78034-1-alexei.starovoitov@gmail.com>
 <20210701192044.78034-2-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210701192044.78034-2-alexei.starovoitov@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:a1c3]
X-ClientProxiedBy: SJ0PR13CA0056.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::31) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:a1c3) by SJ0PR13CA0056.namprd13.prod.outlook.com (2603:10b6:a03:2c2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Fri, 2 Jul 2021 01:04:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3734d9d5-a46e-4b84-4daa-08d93cf568c2
X-MS-TrafficTypeDiagnostic: SA1PR15MB5047:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB50477D59C1BB1FC367C0AE24D51F9@SA1PR15MB5047.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wdxj4WHydwCQLY92ZEamfp3oL9pjePhI8THqM1+T+8ODvlCnChLNgTKJrhPy6xGLdjFfi5IRyb7UgzTzcwyMO+wVpGC7P7qK0n48tDSN9RWQd12mtc+uN2bxqKENPwhqmYZjN3motraweF2Qn0JSUA50wbPC6IN70ZVIG3aF3lYi5V4CM2XI8xuxumhtAXE6wcm5DunhHHVeLUdOW5K+tknWkk2wHopdLpc+BlwewtaL68Tt6FKeAeVFf//rwyrtdwZOYQ7bo02mQLrkegdQDpb6eHW69agqa+rJWEkR5W9zrOhduxtwUAJ/3H6ctQIKBAHVOB6z5JaTiS8BwdYyhlM5ucjQrjcu5quF8LSrrjbN9Ypk6UH7ccpG6tFtvoYptComQ8NLMiutcqYOwkxYJnKxTFj2JKYPZnPDwuonNEGmlkBOSmzta91ZEnVF2n5wqOEfR4s7mxEFyvyYXjsKBJOKZhPi/3YbZy+CpN4PkgozuY9zh72eGmCqOA84ufJhfqrijBsubOilhAsycVt1XlSvRGwZ6g4+Ovc8h/bM/Tu3i8Nf/ZlHc8DZ/wQ62Hhx0G50ZbvO3E8+5dDF2CIrIolhS8YSYQAgAP5YXqrifnY6md4b8Y58LsRZHGoUaFDNQC6D3Lo0eFxih5EUeUcFxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(6506007)(52116002)(16526019)(83380400001)(186003)(8936002)(478600001)(38100700002)(7696005)(9686003)(86362001)(4326008)(316002)(8676002)(66556008)(66476007)(5660300002)(6916009)(55016002)(2906002)(1076003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZFrXdHumjwzYptnN74QE2ZeNEeE6n4YClsYX+EUtqlECQT/9PcP62rQluwzv?=
 =?us-ascii?Q?UWJykfxZ0BeeAa5Y+exAVmFLkLV29ICW+IFGqz6Yxh4Iy1hgVBqEhgF9oArJ?=
 =?us-ascii?Q?QbDVqXlhnEJeHsTgVX93koJZCz0c7uyJ22i9i45AvvU1HOpDmQFqk2JknJjj?=
 =?us-ascii?Q?eGN3ClCiqM1fL1SEy6XXxtQUC+f7UTFF2gAsaNd4PnpYrUppEZPoEbp3D/Qd?=
 =?us-ascii?Q?ioHQ+OvW3PFBFk9zkdz8N5+HJGJa3bxl3PKNEafosBJosLP7uo4CGcjgpN6/?=
 =?us-ascii?Q?hceq+8PfMWfDaQe+gAnlmpu6QCHd8EF0AiD9Dk9SqBR11GViFr5OsarhRTmT?=
 =?us-ascii?Q?27guKla4enYwvpH7/StfUWLaVK5ynTN86kCEh4T8OnNzpBN+hq6UjSXVr4ST?=
 =?us-ascii?Q?9JxcIQ4cm8LQTZgJHDhzS+gDUe3dDJWMus2lHbZZ8Ta7f57zF25NzLt3hJ5g?=
 =?us-ascii?Q?4dUNTKfpw4OWcW7uuL78mhQ+kyI/MMkKX6WoOXCwrcFsa2scyd6606kMsHBD?=
 =?us-ascii?Q?kV0ZshPy4nLY/Y4RcS5nuYnKwzncXrDKbqS+i8dEOp6LEImEfYuILKw4Fd+n?=
 =?us-ascii?Q?donP2lemyJpDdD59HOG6UhrbFMQ3/8yq/bOEOr+1VUOD6tNqmoCDicJI0Uu4?=
 =?us-ascii?Q?woTpxGUc15COeoORQ9nhVqsfICUcwx0LtQ48nECTffMipJZ2PR5klt8Zqi+W?=
 =?us-ascii?Q?z3S+HWbiClUZSO4r5oFa4Kygk0LfAzD82vzTjRSspdh8zAKQiuaWAMelyIH4?=
 =?us-ascii?Q?xoWWnoEmGuFae/96Rs+7MNv1zKcB6qqEecAFa5WQkT+3IOQzVg7DwqjmwzWb?=
 =?us-ascii?Q?HFUU3Y3+vd2Oz2s4rxKMscKekglNhzsgFiY9rxTV0omlWx4i7dBJd81QqsxL?=
 =?us-ascii?Q?j6ER76sA1ZYsGwEF010jQMfOStK1DdMqhMSjNcpV8P3QSY//SuvBReHvOKn1?=
 =?us-ascii?Q?3yJg5o/0fdOw4vJlFoA8nTAWp7WiqS8hqqgEYDfgCKpUFyR4BUkhhhyfMuh9?=
 =?us-ascii?Q?wDW3X5HSAZJic0fMnPjveRj/waiR/mjfDuJmAmmYhpUvhgXvGlvyuntbD2qz?=
 =?us-ascii?Q?PcyHq/APdu/WiNTWxzY018ROW8StyC5eOTR0R1wM12vw4WE1Q5GQkRRUgOcW?=
 =?us-ascii?Q?4hNFit4U1kt1AJyFihKEqNCNPtrz4ZRBRvYo3o5L5gqn/QD92XEeWNTde+h3?=
 =?us-ascii?Q?ZV7ldilv1GA+7VXG6yzW110OvB79OnPeP2tIUQFQFNoCTidHaRPaDSMvicdQ?=
 =?us-ascii?Q?R3bYvSKEy4Rc+wEX1jBlZw13qnaZ5QgSBQV8L3kU1ycaGjurmYhZ6Cy1CQiY?=
 =?us-ascii?Q?7akTl8Cg2vRZK/b/9O1ty7Eoh8F3fxIUT1xL4+LGpaCD3A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3734d9d5-a46e-4b84-4daa-08d93cf568c2
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2021 01:04:57.3278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +VCWvtSMfnj270s2KP2I8f5v73XtbJGHeH5Kql+cznBY+VeVU0+poJrBsZcKjio0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5047
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: A-dDTiD-pJ-VV51RTeyLaDnx8WAw0G9y
X-Proofpoint-ORIG-GUID: A-dDTiD-pJ-VV51RTeyLaDnx8WAw0G9y
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-01_12:2021-07-01,2021-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 suspectscore=0 spamscore=0 impostorscore=0 mlxscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107020004
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 12:20:36PM -0700, Alexei Starovoitov wrote:
[ ... ]

> +BPF_CALL_3(bpf_timer_set_callback, struct bpf_timer_kern *, timer, void *, callback_fn,
> +	   struct bpf_prog *, prog)
> +{
> +	struct bpf_hrtimer *t;
> +	struct bpf_prog *prev;
> +	int ret = 0;
> +
> +	if (in_nmi())
> +		return -EOPNOTSUPP;
> +	____bpf_spin_lock(&timer->lock); /* including irqsave */
> +	t = timer->timer;
> +	if (!t) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +	if (!atomic64_read(&(t->map->usercnt))) {
> +		/* maps with timers must be either held by user space
> +		 * or pinned in bpffs. Otherwise timer might still be
> +		 * running even when bpf prog is detached and user space
> +		 * is gone, since map_release_uref won't ever be called.
> +		 */
> +		ret = -EPERM;
> +		goto out;
> +	}
> +	prev = t->prog;
> +	if (prev != prog) {
> +		if (prev)
> +			/* Drop prev prog refcnt when swapping with new prog */
> +			bpf_prog_put(prev);
> +		/* Bump prog refcnt once. Every bpf_timer_set_callback()
> +		 * can pick different callback_fn-s within the same prog.
> +		 */
> +		bpf_prog_inc(prog);
I think prog->aux->refcnt could be zero here when the bpf prog
is making its final run and before the rcu grace section ended,
so bpf_prog_inc_not_zero() should be used here.

> +		t->prog = prog;
> +	}
> +	t->callback_fn = callback_fn;
> +out:
> +	____bpf_spin_unlock(&timer->lock); /* including irqrestore */
> +	return ret;
> +}
> +

[ ... ]

> @@ -5837,6 +5906,8 @@ record_func_map(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
>  	    func_id != BPF_FUNC_map_pop_elem &&
>  	    func_id != BPF_FUNC_map_peek_elem &&
>  	    func_id != BPF_FUNC_for_each_map_elem &&
> +	    func_id != BPF_FUNC_timer_init &&
> +	    func_id != BPF_FUNC_timer_set_callback &&
It seems checking the posion map_ptr_state is not needed.
Is this change needed?

[ ... ]

> @@ -12584,6 +12662,46 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
>  			continue;
>  		}
>  
> +		if (insn->imm == BPF_FUNC_timer_set_callback) {
> +			/* There is no need to do:
> +			 *     aux = &env->insn_aux_data[i + delta];
> +			 *     if (bpf_map_ptr_poisoned(aux)) return -EINVAL;
> +			 * for bpf_timer_set_callback(). If the same callback_fn is shared
> +			 * by different timers in different maps the poisoned check
> +			 * will return false positive.
> +			 *
> +			 * The verifier will process callback_fn as many times as necessary
> +			 * with different maps and the register states prepared by
> +			 * set_timer_callback_state will be accurate.
> +			 *
> +			 * The following use case is valid:
> +			 *   map1 is shared by prog1, prog2, prog3.
> +			 *   prog1 calls bpf_timer_init for some map1 elements
> +			 *   prog2 calls bpf_timer_set_callback for some map1 elements.
> +			 *     Those that were not bpf_timer_init-ed will return -EINVAL.
> +			 *   prog3 calls bpf_timer_start for some map1 elements.
> +			 *     Those that were not both bpf_timer_init-ed and
> +			 *     bpf_timer_set_callback-ed will return -EINVAL.
> +			 */
> +			struct bpf_insn ld_addrs[2] = {
> +				BPF_LD_IMM64(BPF_REG_3, (long)prog),
The "prog" pointer value is used here.

> +			};
> +
> +			insn_buf[0] = ld_addrs[0];
> +			insn_buf[1] = ld_addrs[1];
> +			insn_buf[2] = *insn;
> +			cnt = 3;
> +
> +			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
> +			if (!new_prog)
> +				return -ENOMEM;
> +
> +			delta    += cnt - 1;
> +			env->prog = prog = new_prog;
After bpf_patch_insn_data(), a new prog may be allocated.
Is the above old "prog" pointer value updated accordingly?
I could have missed something.

> +			insn      = new_prog->insnsi + i + delta;
> +			goto patch_call_imm;
> +		}
> +
>  		/* BPF_EMIT_CALL() assumptions in some of the map_gen_lookup
>  		 * and other inlining handlers are currently limited to 64 bit
>  		 * only.
