Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0569650F0F2
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 08:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245151AbiDZGag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 02:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238318AbiDZGae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 02:30:34 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803D913D5D;
        Mon, 25 Apr 2022 23:27:27 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23Q4SOMO022029;
        Mon, 25 Apr 2022 23:27:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ZaNLSjIBjmZL3C19vfhQXbHiHBgxidEqN2qpReDRqGI=;
 b=J1dvd0Z2vHfsPjgySfEjcUeb1RF+3l2C4XYJxCRqYEFC5kaLe08Nr2rYXkgPgpEomRVK
 hAnllfRDRXwPCLxiZQKjO/h42XHbU0tZ5nITcUn837Vhy4Bhcu5LB3hGVDuTZH5Uqug8
 +QgSyy1B06wUiALKzwAYoDM8Tof5uVWqy64= 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2041.outbound.protection.outlook.com [104.47.74.41])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fp9qhrcnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Apr 2022 23:27:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+c2or2gw+ea+cotCckP5yorD3XiUNpiE3BPbynSZcQelLqz+bQyLPn0bS0rKTDbpFXR+u2nqsfWb4RtXsUU/f0Fj3DIDhw2f4L0QjgP2RXKrWIwDp3aaPpYVUOUkFD8/LXK3N70C5oBkll61om7UkekXZG9eFD6JtppV5Z7INVsQZ2lZD9FP+8B5JFO701x9L1VPkd+Ir8Wop/2eaT6iJVtsQgNPJ28hYWZZ/TsGruKupxPRuyeAVIE0LU8pP6I9vUHcE/aSLjDpz3PTt6k611+uEfTtlNwHPZ+HLhaRmwuXmQoOznksPcnIdkoRDzSPa/ltPZvcmdBlq0yePoBQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZaNLSjIBjmZL3C19vfhQXbHiHBgxidEqN2qpReDRqGI=;
 b=BgczHMk22CMDKKsHVKmrTo1beMR4qewfkTOVkyL6idc/wpaPZk3SI2FznJ3qj6tkJF8OKhkNzXts+V1zsMV3xH29LFB+Om1W9CltON4OSWXcRj4NuJA8BP12m2ltKHax5TR3Bdta3eC7gBiuM7B0hYi0dVQk0h6WUvwiv5Lh/il59ND2teUEm0Mp8te2bA5PI04u+CcwCPDwDmvNirU7Vtp+FyXOiLqdnp4XqNvfYKPBfSYgtGimvabOcEb67rxLrIZOPlX8ZN8CUBwWPnc/bFucDMSjpMb1Zumm5ea/T/Pr2pkN/6PaVh3TXjn8wYBrnBCqsFlJ0MsHcvI/pl4Czg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2381.namprd15.prod.outlook.com (2603:10b6:805:26::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Tue, 26 Apr
 2022 06:27:08 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983%5]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 06:27:08 +0000
Date:   Mon, 25 Apr 2022 23:27:05 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v5 3/8] bpf: per-cgroup lsm flavor
Message-ID: <20220426062705.siikmhdj5vhsffjq@kafai-mbp.dhcp.thefacebook.com>
References: <20220419190053.3395240-1-sdf@google.com>
 <20220419190053.3395240-4-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419190053.3395240-4-sdf@google.com>
X-ClientProxiedBy: MW2PR16CA0042.namprd16.prod.outlook.com
 (2603:10b6:907:1::19) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 791cec9d-a810-4e50-d9f7-08da274dc9bb
X-MS-TrafficTypeDiagnostic: SN6PR15MB2381:EE_
X-Microsoft-Antispam-PRVS: <SN6PR15MB2381B819ADCDB759038B4F0CD5FB9@SN6PR15MB2381.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LsrScQ2C1Yjy+abNemfkz49mWyxrgpFE9+k91eNVneQotAlL42R9CX41T2gjRM/GBFIw5ODAyoPjBYgqIXxxsgbNp58usH8K2jwR/l8nr4fPlakevj3VGU/N7f8toWKpAS1ibfGU+dcxill5jnVQa5MCBtR9ldRu78oVD8+s8Z97f2lRW3yC2Y2hFsJio7Nb5xi4DqV+xdiZCl7UQ1g8ZczJh/8Do9Xgq9+0fA4uKD65rIZ5kvc8ig99OuIxYWDWxowoth6jjZimipb+vcHH3CdGKfVCSyyEwimmHZKYV0DFxSBxt6cul4PKpohkh1C3juCryeP18k0RvigPRufFd8pDQOBvK9WyejIFjJQKyagLe7y3HoCqiowLjntpD09850rsaCo2n5tEXHwqstQttMdrMq+8IX8tPnBJvnLOOl+CHKGUlq3xlmclfakewHpCzU2Xe5UJea2v3fL5DTvHmMUfBKyi0PTGeskhVHTvuSqf00Epiv+YFZQvB4qqm72nShREIs/YP7Xj36p8nQf5g6lekEyVp8Dum1sMhp/ci96iau2kBx34sTDK+q1g6ibzdE/4ZvqnLvHG3hAJuYANnQ0RqmX7xb1QYAmdEjToESi+Kmj+NA1amGfcA7LKcnmLp09dCQ1truj2Cky7usc5Jg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(9686003)(83380400001)(8936002)(86362001)(5660300002)(316002)(52116002)(6666004)(186003)(6506007)(1076003)(30864003)(38100700002)(2906002)(6916009)(508600001)(6486002)(8676002)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/iJqY56sc7HlDoP/3bjB92/8zMdWuCeizUDqu6ixd17qptqBjBfj6tO4YBH3?=
 =?us-ascii?Q?8G9OvvcpFau8D8W42x7uYZdYlEWzIF4JbXMyoaP43usHDWXWpkX8Yw7YY0Hk?=
 =?us-ascii?Q?ZOKY0Qm8m3aWBUqjn9bM02b4IlTnkCOgHN7Xjgj3fpkuOJRSHiiJ44oYqAEL?=
 =?us-ascii?Q?9TeMcYu6j9pw9NGGwy3NR7N/uIEIuqqxARCyouqkeLuRb11K0M7ErH+tzEAP?=
 =?us-ascii?Q?qExWyHMHqvVnisWeqzAE4kNuo/XTjaKXWnGnLunpmnwpYu9EaUNB3mjFDqHZ?=
 =?us-ascii?Q?NlUZO4gJa7cwwV8W3mURCSsiAEEimsOlBgdU2i2Rk33JnAheLtFeSFENrSra?=
 =?us-ascii?Q?5jH2SkzN9BaVCEmb7DA3U1gt+kCINcMwNbCsd2lullnWwZIOAalJu2twVT6x?=
 =?us-ascii?Q?naHIFnEEDsRJcc2Ao2lXurVVyQfg1RNtV1UC9uluhd+arYwQsqRdHlqHpnWR?=
 =?us-ascii?Q?OCZYu9gXwqW25VPUo+Bu8I+Th3EibesnsA28FxK5ZIVEfuDqmUU2lrY/oro3?=
 =?us-ascii?Q?RtCgwRI+XlfFlTMYennIfXzcUvUYxgujKzgW8JODNKYODJw2V0FBRjtq3i62?=
 =?us-ascii?Q?QcADCEY8LzVMl4EDCXQYFR4vLER1s+eeCP80gfkjs6rIFClHt4/WliHAimGs?=
 =?us-ascii?Q?LtRvGpxamdVmFfooIlLcETFcGD642/SXoo4JGu/xNK5474ofHBoHXV9/IehQ?=
 =?us-ascii?Q?RQysBhPB4PPm9frWmNUAnX2XODR4jpiabbIb9DfWn6+1nXigU4gaUJqmxH+3?=
 =?us-ascii?Q?eg5IXS5uHkt2GV5cSg/1jo6QPcHJT+Ta6E0EHw2gqL//8E742l+lLC6Z6Z8A?=
 =?us-ascii?Q?VondxVs0eb/ItPXpwVmA4orYYPSa6mitGDb47eIpTzP8aSmAW7XUYiw9jAVx?=
 =?us-ascii?Q?AYkVHSgHpXLjmETt9WYi7n51nTfRj8O0y+1vsvkhdgLDxCTwO9oPcHgWICIp?=
 =?us-ascii?Q?8AWxCI1/88KQinmzJtwDVwTSqrkeoJgFYn3bI3kFhiTUA2pzddB9deDBUe+U?=
 =?us-ascii?Q?L+CECIctfuzvVp2iIP4AdGrfalUcIvFEQRXqMQ5VkgbZ6ttPYczU1DK0I6/O?=
 =?us-ascii?Q?YgaN3PCJj+MO0KDS+q98a7mE86OnoePmiXEJ+FwQpLHb1bSnQUdOiNA863cX?=
 =?us-ascii?Q?TcwJW9qJU0dHloN+5KGbhmrkKn/AsyPuJ5cYLePhRyw7WNvhWWpIe+CIf/LU?=
 =?us-ascii?Q?6ougeBw94tIWyKlSq7mYUDgct6wF+vH/XPnmvwNxF4MClGLFPQZjYiN+HJU4?=
 =?us-ascii?Q?6XIoH+3M2g+vVysKTu0+6wd8XXU3qRWrD9ZYdB6DAWU+boNm56abwzbKtKdv?=
 =?us-ascii?Q?E22w5AKQoZ9yr96ERYC0cgYCW5/CQOLhI6HlcTamIBzns83YsekCig7vkz/Q?=
 =?us-ascii?Q?Qd4TXShfAHLxsxGem56E3ySULT8M9UULIZINylAq10K/z/NqDS73AUOaiMCS?=
 =?us-ascii?Q?9g7wHANAgGJUYpaCWu0cHj82SzPGqkI1enxqnRktHT4FSqF/FVZcpVCrpTtm?=
 =?us-ascii?Q?vHuYcT0N/OHVx90qyK58ebKFzZGGTps/0wQTRtyjWoZY2d7M3qQtuWE1Wjqn?=
 =?us-ascii?Q?Bpc4/DXsDKf9WnQ8nyVWJYBRQi6Lg9MbJiyLKlcpJBvzfrRGXpf+1O7D7pg/?=
 =?us-ascii?Q?g9yiOiMOZ73fCxJwWP0/f1ca5daCZUXOE6ECc8d/7IFe4Q0ZGWrIixhIpq0J?=
 =?us-ascii?Q?yaJkEnegZLAjr+H3l2EaIBbl94zme2qetQP/87tNunEiPwwNx7ZSlOvivitS?=
 =?us-ascii?Q?a64iFaqVwnaVANpMziBJUo1l1+qyglY=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 791cec9d-a810-4e50-d9f7-08da274dc9bb
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 06:27:07.9810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2GxZvKEqpEL3xkzaEbWMRLEv5FR6fOQpzH/a+VzoCDnbjAG4s7Q0k7jsgVYh9nFZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2381
X-Proofpoint-ORIG-GUID: ZJz9bhUavaT8SJ6fLsqx5q57MEWX_OFB
X-Proofpoint-GUID: ZJz9bhUavaT8SJ6fLsqx5q57MEWX_OFB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_02,2022-04-25_03,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 12:00:48PM -0700, Stanislav Fomichev wrote:
> Allow attaching to lsm hooks in the cgroup context.
> 
> Attaching to per-cgroup LSM works exactly like attaching
> to other per-cgroup hooks. New BPF_LSM_CGROUP is added
> to trigger new mode; the actual lsm hook we attach to is
> signaled via existing attach_btf_id.
> 
> For the hooks that have 'struct socket' as its first argument,
> we use the cgroup associated with that socket. For the rest,
> we use 'current' cgroup (this is all on default hierarchy == v2 only).
> Note that for the hooks that work on 'struct sock' we still
> take the cgroup from 'current' because most of the time,
> the 'sock' argument is not properly initialized.
This paragraph is out-dated.

> Behind the scenes, we allocate a shim program that is attached
> to the trampoline and runs cgroup effective BPF programs array.
> This shim has some rudimentary ref counting and can be shared
> between several programs attaching to the same per-cgroup lsm hook.
> 
> Note that this patch bloats cgroup size because we add 211
> cgroup_bpf_attach_type(s) for simplicity sake. This will be
> addressed in the subsequent patch.
> 
> Also note that we only add non-sleepable flavor for now. To enable
> sleepable use-cases, BPF_PROG_RUN_ARRAY_CG has to grab trace rcu,
s/BPF_PROG_RUN_ARRAY_CG/bpf_prog_run_array_cg/

> shim programs have to be freed via trace rcu, cgroup_bpf.effective
> should be also trace-rcu-managed + maybe some other changes that
> I'm not aware of.
> 

[ ... ]

> diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> index 064eccba641d..2161cba1fe0c 100644
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
> @@ -35,6 +36,68 @@ BTF_SET_START(bpf_lsm_hooks)
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
> +	if (!btf_vmlinux)
Remove this check and other similar checks because the btf_vmlinux has
been successfully parsed during the prog load time.

> +		return -EINVAL;
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
> index aaf9e36f2736..ba0e0c7a661d 100644
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
> @@ -88,6 +91,85 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
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
> +					    ctx, bpf_prog_run, 0);
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
> +					    ctx, bpf_prog_run, 0);
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
> +					    ctx, bpf_prog_run, 0);
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
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
> +#endif /* CONFIG_BPF_LSM */
> +
>  void cgroup_bpf_offline(struct cgroup *cgrp)
>  {
>  	cgroup_get(cgrp);
> @@ -155,6 +237,14 @@ static void bpf_cgroup_storages_link(struct bpf_cgroup_storage *storages[],
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
> @@ -166,6 +256,16 @@ static void bpf_cgroup_link_auto_detach(struct bpf_cgroup_link *link)
>  	link->cgroup = NULL;
>  }
>  
> +static void bpf_cgroup_lsm_shim_release(struct bpf_prog *prog,
> +					enum cgroup_bpf_attach_type atype)
> +{
> +	if (prog->aux->cgroup_atype < CGROUP_LSM_START ||
> +	    prog->aux->cgroup_atype > CGROUP_LSM_END)
These checks are unnecessary.  cgroup_atype was set by the kernel
during attach and it could not be invalid during detach.

Remove this helper and directly call bpf_trampoline_unlink_cgroup_shim(prog)
instead.

> +		return;
> +
> +	bpf_trampoline_unlink_cgroup_shim(prog);
> +}
> +
>  /**
>   * cgroup_bpf_release() - put references of all bpf programs and
>   *                        release all cgroup bpf data
> @@ -190,10 +290,18 @@ static void cgroup_bpf_release(struct work_struct *work)
>  
>  		hlist_for_each_entry_safe(pl, pltmp, progs, node) {
>  			hlist_del(&pl->node);
> -			if (pl->prog)
> +			if (pl->prog) {
> +				if (atype == BPF_LSM_CGROUP)
> +					bpf_cgroup_lsm_shim_release(pl->prog,
> +								    atype);
>  				bpf_prog_put(pl->prog);
> -			if (pl->link)
> +			}
> +			if (pl->link) {
> +				if (atype == BPF_LSM_CGROUP)
> +					bpf_cgroup_lsm_shim_release(pl->link->link.prog,
> +								    atype);
>  				bpf_cgroup_link_auto_detach(pl->link);
> +			}
>  			kfree(pl);
>  			static_branch_dec(&cgroup_bpf_enabled_key[atype]);
>  		}
> @@ -506,6 +614,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>  	struct bpf_prog *old_prog = NULL;
>  	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
>  	struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> +	struct bpf_attach_target_info tgt_info = {};
>  	enum cgroup_bpf_attach_type atype;
>  	struct bpf_prog_list *pl;
>  	struct hlist_head *progs;
> @@ -522,9 +631,35 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
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
>  
> @@ -580,13 +715,26 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>  	if (err)
>  		goto cleanup;
>  
> +	bpf_cgroup_storages_link(new_storage, cgrp, type);
It looks everything is ready for the cgrp local_storage.
How about also allowing bpf_get_local_storage() for BPF_LSM_CGROUP?

> +
> +	if (type == BPF_LSM_CGROUP && !old_prog) {
> +		struct bpf_prog *p = prog ? : link->link.prog;
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
> @@ -678,9 +826,13 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
>  	struct hlist_head *progs;
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
> @@ -696,6 +848,9 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
>  	if (!found)
>  		return -ENOENT;
>  
> +	if (link->type == BPF_LSM_CGROUP)
> +		new_prog->aux->cgroup_atype = atype;
Does it also need to check attach_btf_id between the
new_prog and the old prog?

> +
>  	old_prog = xchg(&link->link.prog, new_prog);
>  	replace_effective_prog(cgrp, atype, link);
>  	bpf_prog_put(old_prog);
> @@ -779,9 +934,15 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
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
> @@ -803,6 +964,10 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>  	if (err)
>  		goto cleanup;
>  
> +	if (type == BPF_LSM_CGROUP)
> +		bpf_cgroup_lsm_shim_release(prog ? : link->link.prog,
> +					    atype);
After looking at find_detach_entry(),
the pl->prog may not be the same as the prog or link->link.prog here.

> +
>  	/* now can actually delete it from this cgroup list */
>  	hlist_del(&pl->node);
>  
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index e9621cfa09f2..d94f4951154e 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -3139,6 +3139,11 @@ static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
>  		return prog->enforce_expected_attach_type &&
>  			prog->expected_attach_type != attach_type ?
>  			-EINVAL : 0;
> +	case BPF_PROG_TYPE_LSM:
> +		if (prog->expected_attach_type != BPF_LSM_CGROUP)
> +			return -EINVAL;
> +		return 0;
> +
>  	default:
>  		return 0;
>  	}
> @@ -3194,6 +3199,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
>  		return BPF_PROG_TYPE_SK_LOOKUP;
>  	case BPF_XDP:
>  		return BPF_PROG_TYPE_XDP;
> +	case BPF_LSM_CGROUP:
> +		return BPF_PROG_TYPE_LSM;
>  	default:
>  		return BPF_PROG_TYPE_UNSPEC;
>  	}
> @@ -3247,6 +3254,7 @@ static int bpf_prog_attach(const union bpf_attr *attr)
>  	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
>  	case BPF_PROG_TYPE_CGROUP_SYSCTL:
>  	case BPF_PROG_TYPE_SOCK_OPS:
> +	case BPF_PROG_TYPE_LSM:
>  		ret = cgroup_bpf_prog_attach(attr, ptype, prog);
>  		break;
>  	default:
> @@ -3284,6 +3292,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
>  	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
>  	case BPF_PROG_TYPE_CGROUP_SYSCTL:
>  	case BPF_PROG_TYPE_SOCK_OPS:
> +	case BPF_PROG_TYPE_LSM:
>  		return cgroup_bpf_prog_detach(attr, ptype);
>  	default:
>  		return -EINVAL;
> @@ -4317,6 +4326,7 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
>  	case BPF_PROG_TYPE_CGROUP_DEVICE:
>  	case BPF_PROG_TYPE_CGROUP_SYSCTL:
>  	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> +	case BPF_PROG_TYPE_LSM:
>  		ret = cgroup_bpf_link_attach(attr, prog);
>  		break;
>  	case BPF_PROG_TYPE_TRACING:
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 0c4fd194e801..c76dfa4ea2d9 100644
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
> @@ -485,6 +487,149 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
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
> +		/* Reusing existing shim attached by the other program.
> +		 */
nit.  Avoid extra line in '*/' for one liner comment.  Didn't
see this convention in other bpf codes.

Also, how about the earlier comment regarding to another __bpf_prog_enter
and __bpf_prog_exit for BPF_LSM_CGROUP that don't do the active counts
and stats collection ?

> +		bpf_prog_inc(shim_prog);
> +		mutex_unlock(&tr->mutex);
> +		return 0;
> +	}
> +
> +	/* Allocate and install new shim.
> +	 */
Same here.

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
> +#endif
> +
>  struct bpf_trampoline *bpf_trampoline_get(u64 key,
>  					  struct bpf_attach_target_info *tgt_info)
>  {
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 9c1a02b82ecd..cc84954846d7 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -14197,6 +14197,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
>  		fallthrough;
>  	case BPF_MODIFY_RETURN:
>  	case BPF_LSM_MAC:
> +	case BPF_LSM_CGROUP:
>  	case BPF_TRACE_FENTRY:
>  	case BPF_TRACE_FEXIT:
>  		if (!btf_type_is_func(t)) {
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index d14b10b85e51..bbe48a2dd852 100644
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
> 2.36.0.rc0.470.gd361397f0d-goog
> 
