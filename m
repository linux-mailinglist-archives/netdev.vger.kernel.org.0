Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646625321BC
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 05:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbiEXDtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 23:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiEXDtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 23:49:22 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D1C6C0FB;
        Mon, 23 May 2022 20:49:18 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NKGofG020624;
        Mon, 23 May 2022 20:49:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=C24t8z9wgSV6lDcIitZnklr7//nEyF5IihiawJMsNoY=;
 b=adV4/GWAgvjVAvct+YBIGfbzDe5KKzNrjHIGybSgl2C7kLPk4j3FuBMg+pg8uzCXDldx
 5KY9KeImNcfjFCdq/gFJC03pfQ75Kz0QCB1d4qlNc3gsaSSW53brBoMX0fDGf0Md6J7X
 MnGrVyaztCMHB4tQaICHO/kdFVAH20oxcHQ= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g6w6rwu86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 20:49:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlplG5wHnhBsnGd8jh/RnHy+8hJEKrt55jPkOy4gIJXYrWwVlhmU6A0y5EmFJFuq5an94MP0NZkB9+M6azgLIZ5T+XXlYlLZsKbJLLSuPpcSIJz9ecdCBQubOMCIIYYgptKmGMYpbE4DaIPDMk4u2HB6nAc9MF6zkBrcbIrrTM9M/4KtrJK3i5MG5NdJpA1D5XYl+IroXuVG8De/w0TTWXTAX7kA+TgfBE2YAAN5uqCgpYLdM9Ym61DRYYfKtpeqr7b2hTGtk4GL5kGuqv6csWQdUp5+32UANNiBe7XlEHEiMy6/aKXRIL9d5wyD5OqKofTpdEagRJdoFM0DEFRliQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C24t8z9wgSV6lDcIitZnklr7//nEyF5IihiawJMsNoY=;
 b=Sb1FHxcZu+UrnQkzzKnoRiQLm+KeA4gTtVqt5G14uOTrdtzsOV4LXNIw1kfiWxylsaRlzIWJnBjHouFY29DESiFAO2NKWwrrM+zSCAVyFaU1p329RkGvnb2DTsHgAtqQkBvGFnUe+xv6VyrrfrNbksFgowdcpx1c30D00qHBCFhMPnkFl/EAMJvI9BKc3zYZGWxjQvO3bZ6Xad2bAGWmDxsKjRXNi025P1dioXLipeLx5mtpL2DIrjb8WWuPvaKmrUpGUKmkWza/a8QSCIhGwdsBOY64vit59xYvtF/x8zcYc5UgN5wqZs8L9lP9Kkb50hW5PHonp56A0H64rlrGUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by BN7PR15MB4113.namprd15.prod.outlook.com (2603:10b6:406:ba::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Tue, 24 May
 2022 03:48:59 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::44a1:2ac9:9ebd:a419]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::44a1:2ac9:9ebd:a419%6]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 03:48:59 +0000
Date:   Mon, 23 May 2022 20:48:57 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v7 05/11] bpf: implement BPF_PROG_QUERY for
 BPF_LSM_CGROUP
Message-ID: <20220524034857.jwbjciq3rfb3l5kx@kafai-mbp>
References: <20220518225531.558008-1-sdf@google.com>
 <20220518225531.558008-6-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518225531.558008-6-sdf@google.com>
X-ClientProxiedBy: BY3PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::32) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 321794a9-66f1-4153-4931-08da3d385602
X-MS-TrafficTypeDiagnostic: BN7PR15MB4113:EE_
X-Microsoft-Antispam-PRVS: <BN7PR15MB4113F9A210949FC292804F0DD5D79@BN7PR15MB4113.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YjxLfKpQcdoity/kLNJG0hLdoup+iR4y+GpqW2C+bxvDMCb3+w9u3tM3kesCQ5hbGvN1YK2TWQDNJnIAZnSErer6/GRb1IXltMeKHGdro2/xCeJgBCWLcQyEAhZBvSEYDo86n1qRcsiBIoEeU/9pY1EgKnNkSolRTtKqe9/Wuq+lKQpFShTnRIDGfROkt0ougxxP3LBnO3V5fovwp4jSoHdhuEi1f041CgCAkcp+rNmcLHCivIb6BUG6htxHJ/tfEqk1oahIBGV//rM9y/eqwzRu8AoDnCIlyGFMgwJ31jeTDf6YV0ahEdvSOwW5rwjeKqb8L8f/kapvMtp2vgHRgnK/+Ja740UaWTqCiJ+/1Hk/UgIeewuC5f0PnhhRs/utxb0Apwc6Z6P07+Cyj2AeYX/UWPrPh2w4OhIETCy5NeT3J97Ckld32Izh9G/1yyCdKdQleuEBCihNWaEIRoWdXryLqX8DulJTdwOvapSuGUTyIdwsycjKVKHpt0nDrjNsVn3uBrygxj6/4ux4p72soLjvPqbogxjGMWCmQ4QQILnfYlaaUkVlEIMunRZGPYZMSIK4SgMxRh6S8QVikacWuFLWgF85gBZuuNeS7PWIkOO9xLf6+Q7I3+5yzJ4AqrrvJoDrlh/KXeQ2j7x/oTmkng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(8676002)(4326008)(66556008)(66476007)(508600001)(2906002)(66946007)(38100700002)(5660300002)(8936002)(83380400001)(186003)(9686003)(52116002)(1076003)(6506007)(316002)(6916009)(6486002)(86362001)(33716001)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OqWLq9x92wR9UvNjla7iZ81kI6dEiTR/6kSxvaA8uycy3DQURJnO8ZBPB94y?=
 =?us-ascii?Q?Uw338sXLav+AoLzvKb5kQ1AsUGpVZyXNAqsDLHz5kKIoNJylixaZvdPiSJZn?=
 =?us-ascii?Q?PQ9twRSW0uK1qE1LoMn0A/fvbe9sIwwd9Z8kPn7pcDSrrNpXRQ3tDM3MEPXb?=
 =?us-ascii?Q?y/T5V+a8jxFdUGiSo8CtNYZoRKA8/6NiJ7Me/wjKSFhr2yYf6Wkg6tJkDc3w?=
 =?us-ascii?Q?UNzvU+tffB/FDaOiPz4A6ISldBJk2p0Yhaxoax7qMjnT9PCmCdyBLhnVk1D8?=
 =?us-ascii?Q?MOwl6D285ZzMXad4iC5nBh93vtHs2ZqzcPioWo18Y1Vg/soiwqTvy5l16O4T?=
 =?us-ascii?Q?G5nVYeMgVDHl73nNaGtVvZk/FXgML8c+TvM7OsllrMrfAor/MCvR3G6a3uzp?=
 =?us-ascii?Q?mQLGBP5odGFY0kbRpNvhbc2CMwIFBjPhNNEc0N6TlRdTm+Yx1NupbuwbSy4W?=
 =?us-ascii?Q?7EN2HNAlHZmg8dSV15WeGpZ7DkQOL561N45qzggO4PLgJbhoQbiHm6NBsnuA?=
 =?us-ascii?Q?vD3FtUSeBvMb5pJQz9OnYD7ahGWI7Ln4XChD6W9MiX6pwg0ZyLyzHRGBXH9T?=
 =?us-ascii?Q?r3gdoUiI+eWZ385pFn/1Dimhzta+16ZPsigONwEgDKJwfuKJzRWPMAto1VAU?=
 =?us-ascii?Q?dv0Vy8+O2+tsSE4NXRPdvHQS4J+CabGWI3ISxqDpmtZR7JrXlZSCDxaWhBaP?=
 =?us-ascii?Q?j/bS3Aw7pRbFM+MSZht/c8fkfGyzWoJraskPfGWCS2hjJXDXX1oZ1pPqht2G?=
 =?us-ascii?Q?8nPpxssb8uVVnHYsudObbBenUrU2vVMCO0gijMzCllpTFJuA/af+02hYndbe?=
 =?us-ascii?Q?ooG8Uq2zTP7coaEhph7fXdtswPqX2rVD7kaZOlCH5Y2HT0NWZN2UwvVyVWL8?=
 =?us-ascii?Q?2FwsP00AHBmzxAEz9juNuajhHggZUNVosR1OWYy6NNjVD7lk1JsGiAHzmByg?=
 =?us-ascii?Q?rW164HrOqVWhD3V3cLjRQJStL6nil/mtL4sdcCiSAUbxyVKoZ4xHMMm8IVlY?=
 =?us-ascii?Q?tRk5rBh62sonNhJQAkAU3JzU85eqOhY7seZkEGUqP71lAH1gJeuXgK+Js4i9?=
 =?us-ascii?Q?7qbfQ3GueCkgVPlu89a4dGGnBJCT9KrfoIWPr4ngy5fVzTT8JqFA7VsQ1PSI?=
 =?us-ascii?Q?hl2Uz13O7QpZXBo6dy0rEXx4Zg5NrpuNokcmxGt6GIXMduTXvqAsGBwJPA6X?=
 =?us-ascii?Q?ZsUdpciNOmWy+2CNTUFynaFmCUlg+RhFdGKlTNL1rWFhxUzUpqAZJ+skq/N7?=
 =?us-ascii?Q?NG/AYen1ikLskcgzFfR6DPTDjLzR51elBUZya8kKaUX5n7GJ3t4bjMzzOwHt?=
 =?us-ascii?Q?jJoDbTvm3KsC7EmNpEJUZCS/xFjOyxXcuvviHTFlZyl9lKVRxLtj0NecR6gL?=
 =?us-ascii?Q?XLG8/dtXgVl4Uxh6ioNUa8vXu4xk8XU6ie4bySvIogb/66j/EstONQP+RKV0?=
 =?us-ascii?Q?QrCL8Hh9kPfWg1onb8RLPi37FE+Arqm/+GdWOCUB+UOucL6HDFAOEqgrZkQt?=
 =?us-ascii?Q?07m3ahEGdFB+Ud9mQ9tYCR/CT6JqS7LFwv16mOYkbHc6ecWrW6TXq87eEwPp?=
 =?us-ascii?Q?Gqq2y7fxfBhM1R7Hc0r+8noNk3D4c7Zzv/PJq79OYX/obJTS84Ted3YHc7Nx?=
 =?us-ascii?Q?TYZo/t9zN920++BQvx9PujTnvTd7L7se4hMOV1dgzkcwMEfy9IPrhQL9k2Yn?=
 =?us-ascii?Q?JTT8+eRyDYYQDcgRDULPQZ14quBU4FsnzVlTIJQYmcrLoAUUbzwQxfG+Yj0A?=
 =?us-ascii?Q?B22fKN162xmYTDhI/UTclb3Uay6dX3o=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 321794a9-66f1-4153-4931-08da3d385602
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 03:48:59.8205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MwL4zNmlEYNCaPYuRABDyG3dKIlxDtInhAkIICamaQI8TIkaIDib4Jkl4510MzHz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB4113
X-Proofpoint-ORIG-GUID: Ckxt7691QMqcUssgAp1fK6dXEiBjKbz7
X-Proofpoint-GUID: Ckxt7691QMqcUssgAp1fK6dXEiBjKbz7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_01,2022-05-23_01,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 03:55:25PM -0700, Stanislav Fomichev wrote:
> We have two options:
> 1. Treat all BPF_LSM_CGROUP the same, regardless of attach_btf_id
> 2. Treat BPF_LSM_CGROUP+attach_btf_id as a separate hook point
> 
> I was doing (2) in the original patch, but switching to (1) here:
> 
> * bpf_prog_query returns all attached BPF_LSM_CGROUP programs
> regardless of attach_btf_id
> * attach_btf_id is exported via bpf_prog_info
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/uapi/linux/bpf.h |   5 ++
>  kernel/bpf/cgroup.c      | 103 +++++++++++++++++++++++++++------------
>  kernel/bpf/syscall.c     |   4 +-
>  3 files changed, 81 insertions(+), 31 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b9d2d6de63a7..432fc5f49567 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1432,6 +1432,7 @@ union bpf_attr {
>  		__u32		attach_flags;
>  		__aligned_u64	prog_ids;
>  		__u32		prog_cnt;
> +		__aligned_u64	prog_attach_flags; /* output: per-program attach_flags */
>  	} query;
>  
>  	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
> @@ -5911,6 +5912,10 @@ struct bpf_prog_info {
>  	__u64 run_cnt;
>  	__u64 recursion_misses;
>  	__u32 verified_insns;
> +	/* BTF ID of the function to attach to within BTF object identified
> +	 * by btf_id.
> +	 */
> +	__u32 attach_btf_func_id;
>  } __attribute__((aligned(8)));
>  
>  struct bpf_map_info {
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index a959cdd22870..08a1015ee09e 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -1074,6 +1074,7 @@ static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>  static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
>  			      union bpf_attr __user *uattr)
>  {
> +	__u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
>  	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
>  	enum bpf_attach_type type = attr->query.attach_type;
>  	enum cgroup_bpf_attach_type atype;
> @@ -1081,50 +1082,92 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
>  	struct hlist_head *progs;
>  	struct bpf_prog *prog;
>  	int cnt, ret = 0, i;
> +	int total_cnt = 0;
>  	u32 flags;
>  
> -	atype = to_cgroup_bpf_attach_type(type);
> -	if (atype < 0)
> -		return -EINVAL;
> +	enum cgroup_bpf_attach_type from_atype, to_atype;
>  
> -	progs = &cgrp->bpf.progs[atype];
> -	flags = cgrp->bpf.flags[atype];
> +	if (type == BPF_LSM_CGROUP) {
> +		from_atype = CGROUP_LSM_START;
> +		to_atype = CGROUP_LSM_END;
> +	} else {
> +		from_atype = to_cgroup_bpf_attach_type(type);
> +		if (from_atype < 0)
> +			return -EINVAL;
> +		to_atype = from_atype;
> +	}
>  
> -	effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> -					      lockdep_is_held(&cgroup_mutex));
> +	for (atype = from_atype; atype <= to_atype; atype++) {
> +		progs = &cgrp->bpf.progs[atype];
> +		flags = cgrp->bpf.flags[atype];
>  
> -	if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> -		cnt = bpf_prog_array_length(effective);
> -	else
> -		cnt = prog_list_length(progs);
> +		effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> +						      lockdep_is_held(&cgroup_mutex));
>  
> -	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> -		return -EFAULT;
> -	if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt)))
> +		if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> +			total_cnt += bpf_prog_array_length(effective);
> +		else
> +			total_cnt += prog_list_length(progs);
> +	}
> +
> +	if (type != BPF_LSM_CGROUP)
> +		if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> +			return -EFAULT;
> +	if (copy_to_user(&uattr->query.prog_cnt, &total_cnt, sizeof(total_cnt)))
>  		return -EFAULT;
> -	if (attr->query.prog_cnt == 0 || !prog_ids || !cnt)
> +	if (attr->query.prog_cnt == 0 || !prog_ids || !total_cnt)
>  		/* return early if user requested only program count + flags */
>  		return 0;
> -	if (attr->query.prog_cnt < cnt) {
> -		cnt = attr->query.prog_cnt;
> +
> +	if (attr->query.prog_cnt < total_cnt) {
> +		total_cnt = attr->query.prog_cnt;
>  		ret = -ENOSPC;
>  	}
>  
> -	if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> -		return bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> -	} else {
> -		struct bpf_prog_list *pl;
> -		u32 id;
> +	for (atype = from_atype; atype <= to_atype; atype++) {
> +		if (total_cnt <= 0)
> +			break;
>  
> -		i = 0;
> -		hlist_for_each_entry(pl, progs, node) {
> -			prog = prog_list_prog(pl);
> -			id = prog->aux->id;
> -			if (copy_to_user(prog_ids + i, &id, sizeof(id)))
> -				return -EFAULT;
> -			if (++i == cnt)
> -				break;
> +		progs = &cgrp->bpf.progs[atype];
> +		flags = cgrp->bpf.flags[atype];
> +
> +		effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> +						      lockdep_is_held(&cgroup_mutex));
> +
> +		if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> +			cnt = bpf_prog_array_length(effective);
> +		else
> +			cnt = prog_list_length(progs);
> +
> +		if (cnt >= total_cnt)
> +			cnt = total_cnt;
> +
> +		if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> +			ret = bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> +		} else {
> +			struct bpf_prog_list *pl;
> +			u32 id;
> +
> +			i = 0;
> +			hlist_for_each_entry(pl, progs, node) {
> +				prog = prog_list_prog(pl);
> +				id = prog->aux->id;
> +				if (copy_to_user(prog_ids + i, &id, sizeof(id)))
> +					return -EFAULT;
> +				if (++i == cnt)
> +					break;
> +			}
>  		}
> +
> +		if (prog_attach_flags)
> +			for (i = 0; i < cnt; i++)
> +				if (copy_to_user(prog_attach_flags + i, &flags, sizeof(flags)))
> +					return -EFAULT;
> +
> +		prog_ids += cnt;
> +		total_cnt -= cnt;
> +		if (prog_attach_flags)
> +			prog_attach_flags += cnt;
>  	}
>  	return ret;
>  }
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 5ed2093e51cc..4137583c04a2 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -3520,7 +3520,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
>  	}
>  }
>  
> -#define BPF_PROG_QUERY_LAST_FIELD query.prog_cnt
> +#define BPF_PROG_QUERY_LAST_FIELD query.prog_attach_flags
>  
>  static int bpf_prog_query(const union bpf_attr *attr,
>  			  union bpf_attr __user *uattr)
> @@ -3556,6 +3556,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
>  	case BPF_CGROUP_SYSCTL:
>  	case BPF_CGROUP_GETSOCKOPT:
>  	case BPF_CGROUP_SETSOCKOPT:
> +	case BPF_LSM_CGROUP:
>  		return cgroup_bpf_prog_query(attr, uattr);
>  	case BPF_LIRC_MODE2:
>  		return lirc_prog_query(attr, uattr);
> @@ -4066,6 +4067,7 @@ static int bpf_prog_get_info_by_fd(struct file *file,
>  
>  	if (prog->aux->btf)
>  		info.btf_id = btf_obj_id(prog->aux->btf);
> +	info.attach_btf_func_id = prog->aux->attach_btf_id;
Note that exposing prog->aux->attach_btf_id only may not be enough
unless it can assume info.attach_btf_id is always referring to btf_vmlinux
for all bpf prog types.
