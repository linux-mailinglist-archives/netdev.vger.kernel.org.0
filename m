Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271D94F9F7F
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 00:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbiDHWPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 18:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiDHWPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 18:15:21 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA3C1E8CD6;
        Fri,  8 Apr 2022 15:13:14 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 238LNbCU013936;
        Fri, 8 Apr 2022 15:12:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=6vEB/fGH6N5u1p0Evm+/SEGU2X4SZafdwZure5blvEY=;
 b=EBpqdRpCl2wGv7Iog57MhbFSYdrVnP36ywoCuKBC+N1nflakKzfuJVICI+v0ZpNuMDMr
 xAflFUXlHTfYVHVGv8hnnpYNF/V2IHG4Hz60GXhHlRoilXmb6I1/YmmzS8qBYq6Ju+3Q
 n+rtKr3oLt4ku3ezw1ufDV9tHEFALlk75sg= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fankkbtye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 15:12:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fw3nYxMmtR065C7CVua7G5RWgi+RPXTd3sufwsJIngl2a/6aW9g1ULaDxHkwHJkjBIP7X80dakgFJNaS/fTTesT71g6XOcUuCmrPcFOtAtrS1KT7YxIIuL6rjX6qbQasAG9/OezFuxG4bdQ447t0r/m5mYdoxSmZjXwTNXYIdK4a5bE8Wyr0G+QJFNPZtxXfK3MDtzcfmehIC3qcJXNuUZzZ3LzOH5chuJn79aKDejlnSh3s2EYanWp326ZP4jYOm2RrOIGJEL66ZTGm/lKUYHwjUAOO2g2C2l5Uj9T+PDfBS4zv7Wt9ROgsajRdckXGajsHyvL1Hzc/uoS2VHs90g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6vEB/fGH6N5u1p0Evm+/SEGU2X4SZafdwZure5blvEY=;
 b=lQu9PtEM71cFgngK3ihHMICflfE84qoFFNa5mWw9mgvtMtUERt2uF9z2GdQwRRQKsZ6T/XcrwE51dK90DC9n4i52O2vf5cQAZNGJq6G6YrcUum+xRN/3Dw1IHciMAt4vSAKiGcgGrYRYaRmu3ym07W1zbOKQHTndSEUPKChZhaWKZrOhoGVT5zE4MXDthSKK7ze9mgfA/VlI7eJ6nsTaZNP2sd27JkuBqRfzyzEUJHZmzTbor+wo5DS5rmJCRpASX3LShmmIZ42NDlaYq+ivHQ2er4AF8KMLHr1QJhWa+TvLR+BB7Eo+OUl9pWX0GBTyGo25SGPxXjzT9/cDsgQ6CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by DM5PR15MB1420.namprd15.prod.outlook.com (2603:10b6:3:cf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26; Fri, 8 Apr
 2022 22:12:55 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::bda3:5584:c982:9d44]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::bda3:5584:c982:9d44%3]) with mapi id 15.20.5144.025; Fri, 8 Apr 2022
 22:12:55 +0000
Date:   Fri, 8 Apr 2022 15:12:52 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v3 2/7] bpf: per-cgroup lsm flavor
Message-ID: <20220408221252.b5hgz53z43p6apkt@kafai-mbp.dhcp.thefacebook.com>
References: <20220407223112.1204582-1-sdf@google.com>
 <20220407223112.1204582-3-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407223112.1204582-3-sdf@google.com>
X-ClientProxiedBy: SJ0PR03CA0046.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::21) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8276b5d8-2e25-434e-5d8b-08da19acee65
X-MS-TrafficTypeDiagnostic: DM5PR15MB1420:EE_
X-Microsoft-Antispam-PRVS: <DM5PR15MB14204B9CF8DAFA7D487FD43ED5E99@DM5PR15MB1420.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T4LcdmHUh0Xn3I2jH/le3R026c02p03GsEIZM1aFpgcHPaPGjiYXlvhzWZZbwDIMCYzePk5ykBioGQziiNHlPV4c/q1CQj3VPE+AidweHMWTi3iRrrTCJb7RhplDrZ9pgAQWzm199UHBC79ONLRA5fqxk8d+dPLbPVcmL9xbFgjOYJzSulKIS7Frbbeacdsdt97NfMyHkfMlR8sq/P9gx2a0dcotPulME0GBjpk1i5zq7BYO6FJU/UKYboQhIgbnxiIX5SPwn4t+dXphzOahTE/G5KpmhNTPePrDXiFP0S7IT4qi3gs9MeoI4mGiigAmpKe9Xvf6nFlMn9ccN9wV3H9yAwV+MpI6y+3cJKdTkVs+Are8cbpuZZL0sggai0QUNO1iVjnO7qfmTfD2zkM+LJPvgFniEAqZSsQVRqAF0hwgAtCQhEOb1rk9m8kqcnO2hKHJErvBPnL9OhX8XlIxEY38YpNs8526JUnV4UFNWPgkCsjOJED0RVUPEb+hM91ReO8zDl8hLZ26Xbji3Y0gEs7njMfGommgM2TpnlMlaRKPQNmx5DySMcW59lMIDyAbZxy7xXiWHd3lQFEXkCi3xkJqo60JhZV+w1meNA046NpacN9WlzHYjUDNSYn9Tg1udoCVkbLGHWWR/8/27g61cQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(6512007)(6506007)(9686003)(5660300002)(186003)(8676002)(508600001)(52116002)(2906002)(8936002)(6486002)(30864003)(38100700002)(316002)(66946007)(66476007)(66556008)(6916009)(83380400001)(4326008)(86362001)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RkEt8L7mVpmxeXnc0QCfxz08oWGldWkmIUIlPz7Zf5MA4rhPMIC5i188q4bV?=
 =?us-ascii?Q?JwY4fZPjzTM5RTAxyMoJYMP+oUtccZ9UcBPSqJJOu5ZMh771VIxoMTucbaf4?=
 =?us-ascii?Q?a8Q40X+hFGXghJO0V4PO1pCx4YIGyqF3msYEj6qJTorKGYxJ2l3KClPkvIKI?=
 =?us-ascii?Q?/xy/8dnGfzmsIsirhBm0YDC1/c978SW0XypAsK9GobSHulR32B05KuiCq1OE?=
 =?us-ascii?Q?DPgBCXL+ItxbeN0S/yIAJ9pv//9b4FJGjt75P9bMIsYRsrfuhGlRRwBe/CQp?=
 =?us-ascii?Q?RsIDDXsVC6cBk2LqeDrPpvBjRBIYgiLxqBa+MDjT+C3fjbt98e6EeOFh0JCG?=
 =?us-ascii?Q?TikP8rDViapZuXreXmjJcw36PdoWPiyAFuZR/hTLXaT21ilrMDt/qIk4Zleh?=
 =?us-ascii?Q?/b+1Q/7feE5YEMJ1XvPEIUuhl5/TZdCZP0bFmJeEpESYO4kqVbZk1uWeD6PO?=
 =?us-ascii?Q?wGwNP1IJWI3AKa3xedWR1s68oFCejFvU/Cb3OCyTObgQvgSSaJDQkGzWb+Z0?=
 =?us-ascii?Q?g5VAWBZpHOf1CRFonJrgDDCKUVh2y/HPzfGq4t33IdYnj7+GakMsIaPlX+yZ?=
 =?us-ascii?Q?LPMMYZc3YPMLYmwrhFHfw9lsmJHrEIO1xs8IpGNwTw3HGclVACf67hEsV91H?=
 =?us-ascii?Q?Jzhtl6YzOjuqkdx8PANCS9/npwciCrFvSXYESirDUcuC73icYc3j5sHQ9oyv?=
 =?us-ascii?Q?lACWMxr6cm1lbHS61U2EqksLQW+txbMp9JePnPcaYl4MbX4RBaLhnAKptvSr?=
 =?us-ascii?Q?bGFSAbaUSfx0TWAAyVMEGs/OAJeCNpE1UD91F3Yb+hR5w1ie5IaZ6uDwVNUk?=
 =?us-ascii?Q?pac7IRwZbGJp5Qe9EycQekB3LdwRmvVgPPVw6Rhymm7Jh1MOnyazOQgbog05?=
 =?us-ascii?Q?+2wGlh5QiY51vqUXD0FzPQcUBbONW0n6UJvMlzQah5NbBwZX/A/glDZsE635?=
 =?us-ascii?Q?mW4CDt2cwfYVn3c0ByfaUcMSVqdWvKsyKSuar9eodFcwC/fRIZRvZxVY7xWo?=
 =?us-ascii?Q?AtbtWwExs8ad7cVbLTm2GPxd/3VCoG3w1JmJdCoJ/7eSo5JM9fi5GD7OxD/y?=
 =?us-ascii?Q?KO9yMx8tS0jKReaBK0vUcLGiEr1blm1qp9PPbUps26IkH3skOho7z5lkEicr?=
 =?us-ascii?Q?bq2LFsWZjvW3kZqhzwi95LF5OIQwJVub5kh4VZGimAPCrKX/0xXSMopPROC8?=
 =?us-ascii?Q?BlYUQJ8Lb4t9qLb3JlslB4K5lC2zJYrESCNJ/uwFCdmfdG1xloLH+15KoOMW?=
 =?us-ascii?Q?cJRMPI6or60AIhwyY7YwZs3koqgH2byuDYGe44RNd1neimSdLdhm3vx8+HGM?=
 =?us-ascii?Q?3QDc3S6euTlCPJ1DW2e8EanBdzTGU+QICfBy49dtL6jswvM2o/Kpd0h8OwJS?=
 =?us-ascii?Q?u+iTjQO2Z2V2wzR0xsF7hD0ckNmvO1fz5UJwoiXxD6pREqcn9Q/BOHuWCmcD?=
 =?us-ascii?Q?UqdxcPdFPXDNGhaiWkkmu8oHnPe2YcQhEhsSlwHv9HTNGEagFid7AJoc9I2z?=
 =?us-ascii?Q?uUwqngMPlA64xHzIdrU8Ei8JqiN6V+a2olmdBL2mi73FaWRLbFTMrFJm5vXl?=
 =?us-ascii?Q?fL+tHFJ3EoCMsAXsIbWmPFFr0YPVs9kU1g/TIq5knOPmJ1L1eW48RHaZyh7V?=
 =?us-ascii?Q?B2/QjywLbltmMpZYPGbE9XZiXwOl6YAW9wP8UitswSIyzMf/pGENdjLrMS81?=
 =?us-ascii?Q?LM+VD8xGg0oaxEi+ZtSMw3yE1Ht/9RfUNgD6bFAMeyoeKcKJ6JKZ6invN+fe?=
 =?us-ascii?Q?uy/icjXcc31428dDD8LgwU8IFs7MWPo=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8276b5d8-2e25-434e-5d8b-08da19acee65
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 22:12:55.5421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ZxH0mryKkClaSz9ixZkTJWPzsFWkFMUVkGzma+Y7GXOZ/YGsTSSICRKvSwt2BNX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1420
X-Proofpoint-ORIG-GUID: _e1qLNL7cM5KsYe_GHo54DX8wzZAfLlh
X-Proofpoint-GUID: _e1qLNL7cM5KsYe_GHo54DX8wzZAfLlh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-08_08,2022-04-08_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 03:31:07PM -0700, Stanislav Fomichev wrote:
> diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> index 064eccba641d..eca258ba71d8 100644
> --- a/kernel/bpf/bpf_lsm.c
> +++ b/kernel/bpf/bpf_lsm.c
> @@ -35,6 +35,98 @@ BTF_SET_START(bpf_lsm_hooks)
>  #undef LSM_HOOK
>  BTF_SET_END(bpf_lsm_hooks)
>  
> +static unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
> +						const struct bpf_insn *insn)
> +{
> +	const struct bpf_prog *prog;
> +	struct socket *sock;
> +	struct cgroup *cgrp;
> +	struct sock *sk;
> +	int ret = 0;
> +	u64 *regs;
> +
> +	regs = (u64 *)ctx;
> +	sock = (void *)(unsigned long)regs[BPF_REG_0];
> +	/*prog = container_of(insn, struct bpf_prog, insnsi);*/
> +	prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
nit. Rename prog to shim_prog.

> +
> +	if (unlikely(!sock))
Is it possible in the lsm hooks?  Can these hooks
be rejected at the load time instead?

> +		return 0;
> +
> +	sk = sock->sk;
> +	if (unlikely(!sk))
Same here.

> +		return 0;
> +
> +	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> +	if (likely(cgrp))
> +		ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
> +					    ctx, bpf_prog_run, 0);
> +	return ret;
> +}
> +
> +static unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> +						 const struct bpf_insn *insn)
> +{
> +	const struct bpf_prog *prog;
> +	struct cgroup *cgrp;
> +	int ret = 0;
> +
> +	if (unlikely(!current))
> +		return 0;
> +
> +	/*prog = container_of(insn, struct bpf_prog, insnsi);*/
> +	prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
nit. shim_prog here also.

> +
> +	rcu_read_lock();
> +	cgrp = task_dfl_cgroup(current);
> +	if (likely(cgrp))
> +		ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
> +					    ctx, bpf_prog_run, 0);
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
> +int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
> +			     bpf_func_t *bpf_func)
> +{
> +	const struct btf_type *first_arg_type;
> +	const struct btf_type *sock_type;
> +	const struct btf *btf_vmlinux;
> +	const struct btf_param *args;
> +	s32 type_id;
> +
> +	if (!prog->aux->attach_func_proto ||
> +	    !btf_type_is_func_proto(prog->aux->attach_func_proto))
Are these cases possible at the attaching time or they have already been
rejected at the load time?  If it is the latter, these tests can be
removed.

> +		return -EINVAL;
> +
> +	if (btf_type_vlen(prog->aux->attach_func_proto) < 1)
Is it consistent with the existing BPF_LSM_MAC?
or is there something special about BPF_LSM_CGROUP that
it cannot support this func ?

> +		return -EINVAL;
> +
> +	args = (const struct btf_param *)(prog->aux->attach_func_proto + 1);
nit.
	args = btf_params(prog->aux->attach_func_proto);

> +
> +	btf_vmlinux = bpf_get_btf_vmlinux();
> +	if (!btf_vmlinux)
> +		return -EINVAL;
> +
> +	type_id = btf_find_by_name_kind(btf_vmlinux, "socket", BTF_KIND_STRUCT);
> +	if (type_id < 0)
> +		return -EINVAL;
> +	sock_type = btf_type_by_id(btf_vmlinux, type_id);
> +
> +	first_arg_type = btf_type_resolve_ptr(btf_vmlinux, args[0].type, NULL);
> +	if (first_arg_type == sock_type)
> +		*bpf_func = __cgroup_bpf_run_lsm_socket;
> +	else
> +		*bpf_func = __cgroup_bpf_run_lsm_current;
> +
> +	return 0;
> +}
> +
> +int bpf_lsm_hook_idx(u32 btf_id)
> +{
> +	return btf_id_set_index(&bpf_lsm_hooks, btf_id);
> +}
> +
>  int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
>  			const struct bpf_prog *prog)
>  {
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 0918a39279f6..4199de31f49c 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -4971,6 +4971,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>  
>  	if (arg == nr_args) {
>  		switch (prog->expected_attach_type) {
> +		case BPF_LSM_CGROUP:
>  		case BPF_LSM_MAC:
>  		case BPF_TRACE_FEXIT:
>  			/* When LSM programs are attached to void LSM hooks
> @@ -6396,6 +6397,16 @@ static int btf_id_cmp_func(const void *a, const void *b)
>  	return *pa - *pb;
>  }
>  
> +int btf_id_set_index(const struct btf_id_set *set, u32 id)
> +{
> +	const u32 *p;
> +
> +	p = bsearch(&id, set->ids, set->cnt, sizeof(u32), btf_id_cmp_func);
> +	if (!p)
> +		return -1;
> +	return p - set->ids;
> +}
> +
>  bool btf_id_set_contains(const struct btf_id_set *set, u32 id)
>  {
>  	return bsearch(&id, set->ids, set->cnt, sizeof(u32), btf_id_cmp_func) != NULL;
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 128028efda64..8c77703954f7 100644
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
> @@ -22,6 +25,18 @@
>  DEFINE_STATIC_KEY_ARRAY_FALSE(cgroup_bpf_enabled_key, MAX_CGROUP_BPF_ATTACH_TYPE);
>  EXPORT_SYMBOL(cgroup_bpf_enabled_key);
>  
> +#ifdef CONFIG_BPF_LSM
> +static enum cgroup_bpf_attach_type bpf_lsm_attach_type_get(u32 attach_btf_id)
> +{
> +	return CGROUP_LSM_START + bpf_lsm_hook_idx(attach_btf_id);
> +}
> +#else
> +static enum cgroup_bpf_attach_type bpf_lsm_attach_type_get(u32 attach_btf_id)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif
> +
>  void cgroup_bpf_offline(struct cgroup *cgrp)
>  {
>  	cgroup_get(cgrp);
> @@ -89,6 +104,14 @@ static void bpf_cgroup_storages_link(struct bpf_cgroup_storage *storages[],
>  		bpf_cgroup_storage_link(storages[stype], cgrp, attach_type);
>  }
>  
> +static void bpf_cgroup_storages_unlink(struct bpf_cgroup_storage *storages[])
> +{
> +	enum bpf_cgroup_storage_type stype;
> +
> +	for_each_cgroup_storage_type(stype)
> +		bpf_cgroup_storage_unlink(storages[stype]);
> +}
> +
>  /* Called when bpf_cgroup_link is auto-detached from dying cgroup.
>   * It drops cgroup and bpf_prog refcounts, and marks bpf_link as defunct. It
>   * doesn't free link memory, which will eventually be done by bpf_link's
> @@ -100,6 +123,15 @@ static void bpf_cgroup_link_auto_detach(struct bpf_cgroup_link *link)
>  	link->cgroup = NULL;
>  }
>  
> +static void bpf_cgroup_lsm_shim_release(struct bpf_prog *prog,
> +					enum cgroup_bpf_attach_type atype)
> +{
> +	if (!prog || atype != prog->aux->cgroup_atype)
prog cannot be NULL here, no?

The 'atype != prog->aux->cgroup_atype' looks suspicious also considering
prog->aux->cgroup_atype is only initialized (and meaningful) for BPF_LSM_CGROUP.
I suspect incorrectly passing this test will crash in the below
bpf_trampoline_unlink_cgroup_shim(). More on this later.

> +		return;
> +
> +	bpf_trampoline_unlink_cgroup_shim(prog);
> +}
> +
>  /**
>   * cgroup_bpf_release() - put references of all bpf programs and
>   *                        release all cgroup bpf data
> @@ -123,10 +155,16 @@ static void cgroup_bpf_release(struct work_struct *work)
Copying some missing loop context here:

	for (atype = 0; atype < ARRAY_SIZE(cgrp->bpf.progs); atype++) {
		struct list_head *progs = &cgrp->bpf.progs[atype];
		struct bpf_prog_list *pl, *pltmp;
				  
>  
>  		list_for_each_entry_safe(pl, pltmp, progs, node) {
>  			list_del(&pl->node);
> -			if (pl->prog)
> +			if (pl->prog) {
> +				bpf_cgroup_lsm_shim_release(pl->prog,
> +							    atype);
atype could be 0 (CGROUP_INET_INGRESS) here.  bpf_cgroup_lsm_shim_release()
above will go ahead with bpf_trampoline_unlink_cgroup_shim().
It will break some of the assumptions.  e.g. prog->aux->attach_btf is NULL
for CGROUP_INET_INGRESS.

Instead, only call bpf_cgroup_lsm_shim_release() for BPF_LSM_CGROUP ?

If the above observation is sane, I wonder if the existing test_progs
have uncovered it or may be the existing tests just always detach
cleanly itself before cleaning the cgroup which then avoided this case.

>  				bpf_prog_put(pl->prog);
> -			if (pl->link)
> +			}
> +			if (pl->link) {
> +				bpf_cgroup_lsm_shim_release(pl->link->link.prog,
> +							    atype);
>  				bpf_cgroup_link_auto_detach(pl->link);
> +			}
>  			kfree(pl);
>  			static_branch_dec(&cgroup_bpf_enabled_key[atype]);
>  		}
> @@ -439,6 +477,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>  	struct bpf_prog *old_prog = NULL;
>  	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
>  	struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> +	struct bpf_attach_target_info tgt_info = {};
>  	enum cgroup_bpf_attach_type atype;
>  	struct bpf_prog_list *pl;
>  	struct list_head *progs;
> @@ -455,9 +494,31 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>  		/* replace_prog implies BPF_F_REPLACE, and vice versa */
>  		return -EINVAL;
>  
> -	atype = to_cgroup_bpf_attach_type(type);
> -	if (atype < 0)
> -		return -EINVAL;
> +	if (type == BPF_LSM_CGROUP) {
> +		struct bpf_prog *p = prog ? : link->link.prog;
> +
> +		if (replace_prog) {
> +			/* Reusing shim from the original program.
> +			 */
> +			atype = replace_prog->aux->cgroup_atype;
> +		} else {
> +			err = bpf_check_attach_target(NULL, p, NULL,
> +						      p->aux->attach_btf_id,
> +						      &tgt_info);
> +			if (err)
> +				return -EINVAL;
> +
> +			atype = bpf_lsm_attach_type_get(p->aux->attach_btf_id);
> +			if (atype < 0)
> +				return atype;
> +		}
> +
> +		p->aux->cgroup_atype = atype;
hmm.... not sure about this assignment for the replace_prog case.
In particular, the attaching prog's cgroup_atype can be decided
by the replace_prog's cgroup_atype?  Was there some checks
before to ensure the replace_prog and the attaching prog have
the same attach_btf_id?

> +	} else {
> +		atype = to_cgroup_bpf_attach_type(type);
> +		if (atype < 0)
> +			return -EINVAL;
> +	}
>  
>  	progs = &cgrp->bpf.progs[atype];
>  
> @@ -503,13 +564,27 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>  	if (err)
>  		goto cleanup;
>  
> +	bpf_cgroup_storages_link(new_storage, cgrp, type);
> +
> +	if (type == BPF_LSM_CGROUP && !old_prog) {
> +		struct bpf_prog *p = prog ? : link->link.prog;
> +		int err;
> +
> +		err = bpf_trampoline_link_cgroup_shim(p, &tgt_info);
> +		if (err)
> +			goto cleanup_trampoline;
> +	}
> +
>  	if (old_prog)
>  		bpf_prog_put(old_prog);
>  	else
>  		static_branch_inc(&cgroup_bpf_enabled_key[atype]);
> -	bpf_cgroup_storages_link(new_storage, cgrp, type);
> +
>  	return 0;
>  
> +cleanup_trampoline:
> +	bpf_cgroup_storages_unlink(new_storage);
> +
>  cleanup:
>  	if (old_prog) {
>  		pl->prog = old_prog;
> @@ -601,9 +676,13 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
>  	struct list_head *progs;
>  	bool found = false;
>  
> -	atype = to_cgroup_bpf_attach_type(link->type);
> -	if (atype < 0)
> -		return -EINVAL;
> +	if (link->type == BPF_LSM_CGROUP) {
> +		atype = link->link.prog->aux->cgroup_atype;
> +	} else {
> +		atype = to_cgroup_bpf_attach_type(link->type);
> +		if (atype < 0)
> +			return -EINVAL;
> +	}
>  
>  	progs = &cgrp->bpf.progs[atype];
>  
> @@ -619,6 +698,9 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
>  	if (!found)
>  		return -ENOENT;
>  
> +	if (link->type == BPF_LSM_CGROUP)
> +		new_prog->aux->cgroup_atype = atype;
> +
>  	old_prog = xchg(&link->link.prog, new_prog);
>  	replace_effective_prog(cgrp, atype, link);
>  	bpf_prog_put(old_prog);
> @@ -702,9 +784,15 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>  	u32 flags;
>  	int err;
>  
> -	atype = to_cgroup_bpf_attach_type(type);
> -	if (atype < 0)
> -		return -EINVAL;
> +	if (type == BPF_LSM_CGROUP) {
> +		struct bpf_prog *p = prog ? : link->link.prog;
> +
> +		atype = p->aux->cgroup_atype;
> +	} else {
> +		atype = to_cgroup_bpf_attach_type(type);
> +		if (atype < 0)
> +			return -EINVAL;
> +	}
>  
>  	progs = &cgrp->bpf.progs[atype];
>  	flags = cgrp->bpf.flags[atype];
> @@ -726,6 +814,10 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>  	if (err)
>  		goto cleanup;
>  
> +	if (type == BPF_LSM_CGROUP)
> +		bpf_cgroup_lsm_shim_release(prog ? : link->link.prog,
> +					    atype);
> +
>  	/* now can actually delete it from this cgroup list */
>  	list_del(&pl->node);
>  	kfree(pl);

[ ... ]

> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 0c4fd194e801..fca1dea786c7 100644
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
> @@ -394,6 +396,7 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(struct bpf_prog *prog)
>  		return BPF_TRAMP_MODIFY_RETURN;
>  	case BPF_TRACE_FEXIT:
>  		return BPF_TRAMP_FEXIT;
> +	case BPF_LSM_CGROUP:
Considering BPF_LSM_CGROUP is added here and the 'prog' for the
case concerning here is the shim_prog ... (more below)

>  	case BPF_LSM_MAC:
>  		if (!prog->aux->attach_func_proto->type)
>  			/* The function returns void, we cannot modify its
> @@ -485,6 +488,147 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
>  	return err;
>  }
>  
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
... should this be BPF_LSM_CGROUP instead ?

or the above 'case BPF_LSM_CGROUP:' addition is not needed ?

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
Can bpf_attach_type_to_tramp() be used here instead of
looping all ?

> +		hlist_for_each_entry(aux, &tr->progs_hlist[kind], tramp_hlist) {
> +			struct bpf_prog *p = aux->prog;
> +
> +			if (!p->jited && p->bpf_func == bpf_func)
Is the "!p->jited" test needed ?

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
> +		/* Reusing existing shim attached by the other program.
> +		 */
The shim_prog is reused by >1 BPF_LSM_CGROUP progs and
shim_prog is hidden from the userspace also (no id), so it may worth
to bring this up:

In __bpf_prog_enter(), other than some bpf stats of the shim_prog
will become useless which is a very minor thing, it is also checking
shim_prog->active and bump the misses counter.  Now, the misses counter
is no longer visible to users.  Since it is actually running the cgroup prog,
may be there is no need for the active check ?

> +		bpf_prog_inc(shim_prog);
> +		mutex_unlock(&tr->mutex);
> +		return 0;
> +	}
> +
> +	/* Allocate and install new shim.
> +	 */
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
> +}
> +
