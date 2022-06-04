Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D77653D5EC
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 09:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbiFDHSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 03:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbiFDHSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 03:18:30 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443484EDF8;
        Sat,  4 Jun 2022 00:18:28 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2543Ok1S015023;
        Sat, 4 Jun 2022 00:18:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=XUjiDarxU2slKhk45CSYbBQeSinQR+mjfpy1fLKiikE=;
 b=ri6onqLnYcC/4F4jVJnwAicEQ1/um6l60iEJZt7tNiv78C874/766PNyBK9Q6OVHL8i9
 IxBXCKUQR9Csb6xMgkK6D9dIxopox0W6dcTgI04WmqFq1PsAC5KXeCiCD2aYXqgX4zWV
 1C15ASbGTg6wSvV8Ghj4Q8V5NVAjY2ToHPc= 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gfyf7rh6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 04 Jun 2022 00:18:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X7P/LepWoOQKvtX/9UHS7emBZNg9OLWgTKhscWkD/XHAA9oqSNO3odzY/ENFgdn28ERUaCuHTfpjeWBwaeWfFxX9Z6K+XSnLA4OBTCvCCka8QEpCOf5E39Bi+DVS5by9G2MNWKa7+siyQbWAT1Q5KO+BjICDUv3tIM/jtx0CHUX3BemqA3N34fQzj+KVyJdQ3KrX41h3RRZeBUeDV4ptZJGsgfgmi7dezwnjnZT15VzGbxOhM6uEQu89g008Rf41ffWvRHBd4AygPsH21ADd9F+uia0wPnTuLDbXxcUO9XTmjR6tYYJs23XrJ5yXwaplWve8q8GAfDKEDkTF1/LS4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XUjiDarxU2slKhk45CSYbBQeSinQR+mjfpy1fLKiikE=;
 b=hxwhs5caqjow7qaSX8/cf86ZgsHzwHtNbZ1+dSFauaClpPoDlByfTQSqFBoTzUwEloqvWyjAA5tZTLidK9IHM9QkY0vs/EnP3FHCVGO+SqATa/Xyxa+xnk4Ph6wQzRF4gcjYBfZlLYyMYWc/cOHK+xwF1+tuOF5S3Wv835PWN2e+EI+pDL8Mxh/CwlZnhqzBikS0jxRqTtUXD3ZsCVL8aOtJRQ7CxEMgWi3w24afxebMSpOnB2n0Lr9qymCnRPNE4cKYkkKpsVHPikdFu7JRWlI2uB4hufo4uS6fDaK78NbbdEmMsFWtTyS9U/iqO6GtzC/NvMJJayDLGau3dUaAbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by DM5PR15MB1434.namprd15.prod.outlook.com (2603:10b6:3:d0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Sat, 4 Jun
 2022 07:18:11 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0%9]) with mapi id 15.20.5314.017; Sat, 4 Jun 2022
 07:18:11 +0000
Date:   Sat, 4 Jun 2022 00:18:08 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v8 06/11] bpf: allow writing to a subset of sock
 fields from lsm progtype
Message-ID: <20220604071808.rwzoktja73ijr3i7@kafai-mbp>
References: <20220601190218.2494963-1-sdf@google.com>
 <20220601190218.2494963-7-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601190218.2494963-7-sdf@google.com>
X-ClientProxiedBy: MW4PR02CA0030.namprd02.prod.outlook.com
 (2603:10b6:303:16d::18) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64e504ca-58dd-4b85-3712-08da45fa61ae
X-MS-TrafficTypeDiagnostic: DM5PR15MB1434:EE_
X-Microsoft-Antispam-PRVS: <DM5PR15MB143473FB05A1A48E3B73102BD5A09@DM5PR15MB1434.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xBOG+Ad33NCaHrp/rJWFYYl2Hsqm1va4LMnmmrdcb8uI78FTrqZ1ke9soPXdxu2dl6aRYg6hcTvDH3j6PqeAJopbiv8zCrB7zuFJ0H5F+QWLUHS/1crbRvl4G9qE+tLPgu7ZeaqUCu6Ew54w05D0ezMRa168heOrxKctOWCYJSCCM1JdTgb63Kfimsy1fGGNyQeFq0quZ1Rnh5rV78lEL5GEpnaHO5B1g0rfuXRo32M9ljQMHaZg0vVP3/5IaYxplF7W6bNHc8f3ByWCGUBPyG/K499xWQ+3B4+XszVGYbuad17GAREn3x29gtXbTNB9DpT0B5JKUtODI4Y6ryjIncc4MOOgLePjq6dSKf+VMCnuwJ9yWSsky4vYFeekZstbw2XVT4ZakCUsrLoBdNPYtE2kkyRRBlPHHVdix7kuQwT1/cuGaO+46micWZFnG96qa+zza3knB0s0+xcNt4WNZyKJrSDaupY0pwj0Y0PlS8Hbcfb/Lxfeg0yGr1prJ2lNu6EpngoUSehsdyJY/EyN2dIZljexyrIvjmf2aNkZu6EF8GkzN6kN0yWTEjl3C8O3otUY9vz8rnWLZ0ID3VGPbF25sqe84GiEoID3uTnLa3qbSVC1sEF7JjyHF8+vJYpJIpRTvhXVGgYIWN+WgXXutQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(52116002)(83380400001)(9686003)(6512007)(38100700002)(6506007)(6916009)(6486002)(316002)(1076003)(186003)(508600001)(6666004)(2906002)(4326008)(5660300002)(8936002)(86362001)(33716001)(66556008)(8676002)(66946007)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l69sqB2tx+X8DhOUMMZhOwdtlTLzgQ3GsoeELzNnh/Ihxjrmp8lKjme91twH?=
 =?us-ascii?Q?xYZCkYdfY3QFkxmzhx9MrQ0J+A7PtQ3KDUiblVFhaHlhhApYYwvfUj79vEzf?=
 =?us-ascii?Q?qFFRCYAfWsRTQDF/F7yrWUR0FmfPBwiPbVaEokvXmwAq7ksfdclSA85Xms8S?=
 =?us-ascii?Q?/nhNpxPpvZXU2jMP59TxxEYnJftFb4dIrqhxNP+jdFbywXsnbk3t361yLqQx?=
 =?us-ascii?Q?re9UXBtE1vy104vyPQyYmMzgqbR/B3wj2K/PFAjMSnVafAyKQlX0/0kaCvnJ?=
 =?us-ascii?Q?744CG7IkXwmxaYo85fjd6aXpnLJYzaaHGzSuQ+jbhTJ1FWj7sPVfnLiJ3sAq?=
 =?us-ascii?Q?2V41IVXcjR1ho1hy+Wx/cbnHh6uik3sruJJAuntHVACoiWc09FQZtgD4/kvb?=
 =?us-ascii?Q?IAD4mfUE5P3nPQO7XYcTiSbn//g9JudV0P21+W9pdUY4qdqzIteb1CrTptL1?=
 =?us-ascii?Q?nSy79cA1dphUwA53uS30US4XB71twV+YmfwrXYMTtrZWNiiW5cYWCcp9xJJa?=
 =?us-ascii?Q?SJRYF2mGmmhNqja6fyKrCsevsYzEOapv1kCu5YsnjzlgeiX3A68rt5ndUjhl?=
 =?us-ascii?Q?+Cw/a1auvPxSunoC7643w9K6ZBjXCPpHXv3DwzWgIJellzsA4C3ckDjuvEs/?=
 =?us-ascii?Q?n6m/jGJQaiNlmP0sV+rhmrbZ4J+Sfx8fm6XD+aegcL97hrZIASHBjv0KDPFF?=
 =?us-ascii?Q?ItzzIp1wZjZlyrZlae0rA5ip51z/yo4HVdjctozJzUpGawQFnSsCgC4+iJ2V?=
 =?us-ascii?Q?q3uJxZjnUBK0OEy7iAmLjCaU9eaKee/0kmE75eDEK+BXRbXpAAniRBUovPem?=
 =?us-ascii?Q?iItAfvp/pHRLupQWxY5Y89Fwj7YqbeiIxoIJgiJ9U+K7tPK6mQubU+IUEYu1?=
 =?us-ascii?Q?KvNLovlJYjEvqSsbMi9f+94lAPtXyc3eomlAtTqUFPk6NRp58rhgKzXqhLSR?=
 =?us-ascii?Q?BhyD4xIHb8b/TB3ZgP77Cz5DWURVmByuGjx6ejOfBQMXsR2+lKjASxq5HfWY?=
 =?us-ascii?Q?u1udZrkN10C/4hYbcXeywBc749g1nKCF2Lko/rpa1/FUVNs+C6nz8hR1VAGg?=
 =?us-ascii?Q?Fgt72lRwD7l3j4Pd9RJ+++xwnrviXyz9GW0SNusLxB1kHNID0u/9z+qSxRvo?=
 =?us-ascii?Q?5uU89XjxP8yVvKRiGGR/Ew+7jFPLvK8SCm2k0ina8ctTFMVAWMaIsZ8Ota58?=
 =?us-ascii?Q?L+tCQ3gyX1cZdaH2LBSUF+/qctITjX8/4rXJJUchz2eKlekReTM3dLZ3smHK?=
 =?us-ascii?Q?OQuoAxaN3CE2bPa1PcdBL5vUqthHf5kMOI8NvIwr7z9QaqrG6CC9+rmeE7RD?=
 =?us-ascii?Q?5KyxmWRN1rbx2nf1FM2VEgxTVsTiN486/Muvq0FD4PNgI+0n3b/Yq2FOTcfE?=
 =?us-ascii?Q?eQbjM4ys1x83eZuJk3D9bF/E/S7MWaME1v/83XDEa5VOZ9I7BPboqH6v+YUB?=
 =?us-ascii?Q?jti83LDxKwsx5Ok+9h44MrmiS8nNp71dSkDAWwwsSZa7jea7bVjwnFgbk72Z?=
 =?us-ascii?Q?OV8U3m7NuTeDjjtzAzpidqr5D2vmsvAmgEtxp2+mKsWJuqEGFy/uRVZrfma5?=
 =?us-ascii?Q?FDcbFY6J42WaYAboMVfDiItiZBkzH4jyi2Cz1YazG00eqyLkGVSjsOFkjVdo?=
 =?us-ascii?Q?yaRplfWbj91EK5fRU4+s0oRwW7eUML2FPrg9/vX45WSNA3NAMCz8xOQ344BS?=
 =?us-ascii?Q?avtYL6rUxweu75dmLUmo8tR0h/IFfCersj8MPfgThVYxvFB5KqHq+mLCic7H?=
 =?us-ascii?Q?42jSz8iLxVEya1Z/OlYwx9XOB/3xC2w=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64e504ca-58dd-4b85-3712-08da45fa61ae
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2022 07:18:11.2274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: InpAyOJGFsdXjouC5s3rNwWEqLhaABp6HP+FejhLKNGKR1cWIF3I7VI0E8cycCwJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1434
X-Proofpoint-ORIG-GUID: -9id1lK9fIkf7tT-ZODd83xRq9uGIQfQ
X-Proofpoint-GUID: -9id1lK9fIkf7tT-ZODd83xRq9uGIQfQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-04_01,2022-06-03_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 01, 2022 at 12:02:13PM -0700, Stanislav Fomichev wrote:
> For now, allow only the obvious ones, like sk_priority and sk_mark.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  kernel/bpf/bpf_lsm.c  | 58 +++++++++++++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c |  3 ++-
>  2 files changed, 60 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> index 83aa431dd52e..feba8e96f58d 100644
> --- a/kernel/bpf/bpf_lsm.c
> +++ b/kernel/bpf/bpf_lsm.c
> @@ -303,7 +303,65 @@ bool bpf_lsm_is_sleepable_hook(u32 btf_id)
>  const struct bpf_prog_ops lsm_prog_ops = {
>  };
>  
> +static int lsm_btf_struct_access(struct bpf_verifier_log *log,
> +					const struct btf *btf,
> +					const struct btf_type *t, int off,
> +					int size, enum bpf_access_type atype,
> +					u32 *next_btf_id,
> +					enum bpf_type_flag *flag)
> +{
> +	const struct btf_type *sock_type;
> +	struct btf *btf_vmlinux;
> +	s32 type_id;
> +	size_t end;
> +
> +	if (atype == BPF_READ)
> +		return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
> +					 flag);
> +
> +	btf_vmlinux = bpf_get_btf_vmlinux();
> +	if (!btf_vmlinux) {
> +		bpf_log(log, "no vmlinux btf\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	type_id = btf_find_by_name_kind(btf_vmlinux, "sock", BTF_KIND_STRUCT);
> +	if (type_id < 0) {
> +		bpf_log(log, "'struct sock' not found in vmlinux btf\n");
> +		return -EINVAL;
> +	}
> +
> +	sock_type = btf_type_by_id(btf_vmlinux, type_id);
> +
> +	if (t != sock_type) {
> +		bpf_log(log, "only 'struct sock' writes are supported\n");
> +		return -EACCES;
> +	}
> +
> +	switch (off) {
> +	case bpf_ctx_range(struct sock, sk_priority):
This looks wrong.  It should not allow to write at
any bytes of the '__u32 sk_priority'.

> +		end = offsetofend(struct sock, sk_priority);
> +		break;
> +	case bpf_ctx_range(struct sock, sk_mark):
Same here.

Just came to my mind,
if the current need is only sk_priority and sk_mark,
do you think allowing bpf_setsockopt will be more useful instead ?
It currently has SO_MARK, SO_PRIORITY, and other options.
Also, changing SO_MARK requires to clear the sk->sk_dst_cache.
In general, is it safe to do bpf_setsockopt in all bpf_lsm hooks ?

> +		end = offsetofend(struct sock, sk_mark);
> +		break;
> +	default:
> +		bpf_log(log, "no write support to 'struct sock' at off %d\n", off);
> +		return -EACCES;
> +	}
> +
> +	if (off + size > end) {
> +		bpf_log(log,
> +			"write access at off %d with size %d beyond the member of 'struct sock' ended at %zu\n",
> +			off, size, end);
> +		return -EACCES;
> +	}
> +
> +	return NOT_INIT;
> +}
> +
>  const struct bpf_verifier_ops lsm_verifier_ops = {
>  	.get_func_proto = bpf_lsm_func_proto,
>  	.is_valid_access = btf_ctx_access,
> +	.btf_struct_access = lsm_btf_struct_access,
>  };
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index caa5740b39b3..c54e171d9c23 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -13413,7 +13413,8 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
>  				insn->code = BPF_LDX | BPF_PROBE_MEM |
>  					BPF_SIZE((insn)->code);
>  				env->prog->aux->num_exentries++;
> -			} else if (resolve_prog_type(env->prog) != BPF_PROG_TYPE_STRUCT_OPS) {
> +			} else if (resolve_prog_type(env->prog) != BPF_PROG_TYPE_STRUCT_OPS &&
> +				   resolve_prog_type(env->prog) != BPF_PROG_TYPE_LSM) {
>  				verbose(env, "Writes through BTF pointers are not allowed\n");
>  				return -EINVAL;
>  			}
> -- 
> 2.36.1.255.ge46751e96f-goog
> 
