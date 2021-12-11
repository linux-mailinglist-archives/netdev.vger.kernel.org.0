Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F4E470F89
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 01:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345490AbhLKAme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 19:42:34 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22526 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345465AbhLKAmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 19:42:33 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BAKJD7A020592;
        Fri, 10 Dec 2021 16:38:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=RtYbiNAjyrI1mAqsX8JDsUcuNw4GDG2laQ+7mjCgnN0=;
 b=LSxsuCKEKOd7KyWhhAHyMfI7e9f+/Td3bcz3SZFEHTQ20sNiPI8Qc2qNgLir3UDegj4+
 ZKqM4BuwQnfeOeKya7PxO6mWXXmf/AJ3HSiQ/sxIDk0tfmKRPI50iQMJ1dm/5umRvEII
 HHn3jabKX4o45T9Uh5VEf3GCRDHEmcM//dk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cvchfj2xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Dec 2021 16:38:43 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 16:38:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMB86VzRsTkS49NWJN54gzd4VjHBOfVBIydXlDVHZzJzyWQtsm0fsMDVh7jjE27fKRABXnWiRBlCEKzKG5uvTuSenvYVcQPEdk8xRq4SRvmEktLV59wYR8AI6P/4Ne8lxu0owPkv+myqDhj61iVkbrcfCbrQFae4owpyACX/XdJC+5mi/KtwOW6sphxbm1ftzcagmEVB+vDJRPB32z+StAemGHwMzEyDqXDOX+X/iZCqvVzloXfnurZ/xmJyIwAt2GXDioaDCRt2C34zJqQMKJv1zd8WnY63Kq+lKZeiTD/BKL71FjzXJnvW3/5fHoirNz4DmXxlp7oXgPpBwgqtIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RtYbiNAjyrI1mAqsX8JDsUcuNw4GDG2laQ+7mjCgnN0=;
 b=YwVrX+RqGWeeoM9Xh3ub5YZ+1uIZTsWcFDXNRoovjS1ZUCC2Era5X8izKU3zV1CnYPTIIdB5CH866qoDTzgRnX8WSZqw4jlET4eOw6sdRes0XkwwoCrq9z8CruJvYM6Pv5r1VlNMVKkZVhmwJU8maE2xUjQwIzc4d1LdaEsIUvIRxYkSqz5mz8j8+EF2L59EUee3UwSWc0v6Lgiqq278DZnFQSM58UCsEz/Bfm2FNgcyx1xRqgWzRK4JQ5okqql46+w1nj3XqAtIU1+L5v4n1KNvPUR3wA9Dj/hAld0v4RBR574ks44CDiorwK/X8Lwy3XwHt2MWfyNdPv3ymzfl1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4981.namprd15.prod.outlook.com (2603:10b6:806:1d4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Sat, 11 Dec
 2021 00:38:41 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%7]) with mapi id 15.20.4755.022; Sat, 11 Dec 2021
 00:38:41 +0000
Date:   Fri, 10 Dec 2021 16:38:38 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [BPF PATCH for-next] cgroup/bpf: fast path for not loaded skb
 BPF filtering
Message-ID: <20211211003838.7u4lcqghcq2gqvho@kafai-mbp.dhcp.thefacebook.com>
References: <d77b08bf757a8ea8dab3a495885c7de6ff6678da.1639102791.git.asml.silence@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d77b08bf757a8ea8dab3a495885c7de6ff6678da.1639102791.git.asml.silence@gmail.com>
X-ClientProxiedBy: CO2PR18CA0059.namprd18.prod.outlook.com
 (2603:10b6:104:2::27) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:acd1) by CO2PR18CA0059.namprd18.prod.outlook.com (2603:10b6:104:2::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend Transport; Sat, 11 Dec 2021 00:38:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6462e14e-58cb-4395-b55d-08d9bc3e943e
X-MS-TrafficTypeDiagnostic: SA1PR15MB4981:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB49812A16C6B6C1AF150955DBD5729@SA1PR15MB4981.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 80U1Vmo3Vz7i2rtca/LnfFWh+VjSg7NAUog2uqX8ncBYULY4iEDPgdnPqQKFiFa+IwKx84ViBSyOH6+2SDOyUeSTbNI3FGtyi3X4B4E/74dR0JnGkhtWScnb5UTv9GMzaFaSy2kptl2g8P5fTuQ8I1M1nkyJAUSzxpJxExdmAUcw+LOBBJYAE06yYzC1qDA0KIpQWzI1KdKMPSvD1UgVo+swcr21vMRRpevdaQ4qxZqeJF8MzFR0dZ/E/ODPFL37QntriTRu9UmLGG7bSUb0qlwg10TvO87xWfYfqPcNEZmFqCc1eq/Hoh7mepw76AjmmJ4F8aoc0WqnptHa5Gi86dhZmcTJtIAseA0WgLGNPQdiL9Hoibx16HWIkaDj0yEusjrNw519iFEaMTioSAXrN+Fh9+Sx1Wi3ln5Tzz27m5u/k4RebU0fAhPejC9kSrGN7zucDGw/xyVQwHF42c5AEgS2r6OOTR8TJTdnHipvr7mDgUsfEv8VuGw2vGWTlGqV+l75z4/fxxhGHhPan5FJplJl4mihX99mDwDp04kQ+K3yaqDCxcx97bsmMl5xjQ8qD1HS/BmUcDciKlzqES2mCLraw/D2C5/t8Vj7WY6uiJQFAClmo8dGNyfqVRBDhfhI56vI7iN17VP6KJMzCuNuoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(86362001)(66946007)(66556008)(66476007)(316002)(52116002)(508600001)(38100700002)(7696005)(186003)(9686003)(2906002)(8936002)(5660300002)(6506007)(1076003)(83380400001)(8676002)(6916009)(4326008)(55016003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YzablPr3ykuDuaBU3Fg90tyWnM8i3ErzcaWSmU6JFEA7Zx8lrR7Rs57NMgjc?=
 =?us-ascii?Q?VLe8mPLV0BlxacVb520jQVxet9yktLnPqIgeQVcnvn3aR21cp94C/Yr1Fjva?=
 =?us-ascii?Q?xIJsyZIy6Oc5g+JfG/kPQueuNd4Uwbn1FxKd8Fnm6g0oaIANc6tpprP0u84k?=
 =?us-ascii?Q?+40jWa97yCOjg4Fmr6XbJb+nLKmNTMIfpQBLwMqcNwTA2cC6mUbMvvN6veOF?=
 =?us-ascii?Q?rFXUB71GrQaZQbtflyvO0YpwSi6X09g3sLebs9Yi5a/jQv/JdlRhEQzCBzzP?=
 =?us-ascii?Q?AZ+h7cm7kbpl9PLJirAmHiNfXFEWTFidzKWOdabImz9cRhkuy81rlny25Eq+?=
 =?us-ascii?Q?7u3tgSy6nMHvghnv1auGe75ofEZw3ahpalj15GKUBieg8VqsMwd+gL1mQbnj?=
 =?us-ascii?Q?dlwx8y7wKVmNEHE9lbiKX96WTSAPDgoRIpJ3laCSl5SKqJW16HOyCAkBrxtu?=
 =?us-ascii?Q?uVNzvppW4V0BjeTVYaM0zEnPmWqV4/FwwNOVWSZD+D76gqGutDpCgeWn5G8T?=
 =?us-ascii?Q?9GsTMHJ9rnC+Q+XNde8dVDi3smvB02T1fEChbSW8UCiCcPlcvHAqUtBEDUus?=
 =?us-ascii?Q?bTEYh6PQhmrKVIL1ijs84znWln/B2gWAWEIVvM81FgUKXw+tbzRWc+EImDss?=
 =?us-ascii?Q?n4V9eBJkyot8y0oNy2Ij5Z72d/NQf2LyGhEyXKM/1G/J2PsMFdYz79IhU9CF?=
 =?us-ascii?Q?B29e6sWXrUIq/vVqwNB689v8RZ/VRZN5W0FOGckLcR0sJ7WC+ONAY5qTgFRT?=
 =?us-ascii?Q?/8iwmudpOsh8P+4xh3Rx+4g5Lit+Y6mejuQZ0rULgOhJa2S9XM1jeVWdOXK1?=
 =?us-ascii?Q?MnWWi+RZbkOjUj2qK6IB9KEGRndmcc04Ap61MHOi4CAMWqvhEeI3BU/6OKGD?=
 =?us-ascii?Q?8JS3Q+Ad1k1fxb9d2vjoPdcACk8jAtEVyydFoJ2ARb+lGXfbI0uX37wZ6Umh?=
 =?us-ascii?Q?UsP6daVI5QJy4KbCLSCVk+/RpWIe7tGtE+BJzAVZNo6ZMtJmPJc+79/O2bsy?=
 =?us-ascii?Q?eOGHceMgKMFo++bGmfN+R7MZdyKysYwAKnwBVgT+iuWiWPoaWPQ/b2UL7a1k?=
 =?us-ascii?Q?8uQRvjJdgKB+6YjEfCED4Wt0F/5yYML0bwK5GP3tauI5mZ3zf/fvH0sfz+8N?=
 =?us-ascii?Q?hiesMnqlkaVkV4YzVWd/TSdSAcVsrV/Mx9wqkFyOuMim8fcV0tgpeUjIxtVU?=
 =?us-ascii?Q?mG34+RcxKJwL4kO6nPOYVE7rgdnvY64iDgnK0okuZmP8XSqXNKQjjKyj8bJz?=
 =?us-ascii?Q?/xU5wEGDQOpaiCZlx08onmYtjT95PkERwkJYpXIkfgS4WO1YgcCC5nHz9RaC?=
 =?us-ascii?Q?R3XQllkSEip5mNVr+HQk+Rven2JOaudGk/FkDTOny5F4zMnhCS/6bsX5a5bd?=
 =?us-ascii?Q?Nybstx+cfctCdqiNjlMHjoL+5XUtGpDjdEpHNwBQp3FS47hWEzrKpL4LHH6M?=
 =?us-ascii?Q?+MG4IhG+PYTfgF+SHldJ8RRZtqlzB/vlf8iDhg7kBnQ/NGN8AeJ7Vt2jV0dt?=
 =?us-ascii?Q?yqqh3LS4hg8muDjsrvG2aJJQxXq11bzJaQ5iY3xk3mJ7HNgwC6oZvVDVrtP5?=
 =?us-ascii?Q?K5C+AqreXyyZVGlWbOiBdt9sx1zj4eLsCkzxWJnS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6462e14e-58cb-4395-b55d-08d9bc3e943e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2021 00:38:41.6173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ShZzw+7mP4pkQ/vhF+J/ibJwKPKzcSnjUrBOajsr6q0bGxXpI/jlxSPhUbQBjSVs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4981
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: -gEwKmlgOJ-zpzMbkDXfw4Qih0LYrqNj
X-Proofpoint-ORIG-GUID: -gEwKmlgOJ-zpzMbkDXfw4Qih0LYrqNj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_09,2021-12-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 adultscore=0 mlxlogscore=552 suspectscore=0 lowpriorityscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112110001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 02:23:34AM +0000, Pavel Begunkov wrote:
> cgroup_bpf_enabled_key static key guards from overhead in cases where
> no cgroup bpf program of a specific type is loaded in any cgroup. Turn
> out that's not always good enough, e.g. when there are many cgroups but
> ones that we're interesting in are without bpf. It's seen in server
> environments, but the problem seems to be even wider as apparently
> systemd loads some BPF affecting my laptop.
> 
> Profiles for small packet or zerocopy transmissions over fast network
> show __cgroup_bpf_run_filter_skb() taking 2-3%, 1% of which is from
> migrate_disable/enable(), and similarly on the receiving side. Also
> got +4-5% of t-put for local testing.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/bpf-cgroup.h | 24 +++++++++++++++++++++---
>  kernel/bpf/cgroup.c        | 23 +++++++----------------
>  2 files changed, 28 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index 11820a430d6c..99b01201d7db 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -141,6 +141,9 @@ struct cgroup_bpf {
>  	struct list_head progs[MAX_CGROUP_BPF_ATTACH_TYPE];
>  	u32 flags[MAX_CGROUP_BPF_ATTACH_TYPE];
>  
> +	/* for each type tracks whether effective prog array is not empty */
> +	unsigned long enabled_mask;
> +
>  	/* list of cgroup shared storages */
>  	struct list_head storages;
>  
> @@ -219,11 +222,25 @@ int bpf_percpu_cgroup_storage_copy(struct bpf_map *map, void *key, void *value);
>  int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
>  				     void *value, u64 flags);
>  
> +static inline bool __cgroup_bpf_type_enabled(struct cgroup_bpf *cgrp_bpf,
> +					     enum cgroup_bpf_attach_type atype)
> +{
> +	return test_bit(atype, &cgrp_bpf->enabled_mask);
> +}
> +
> +#define CGROUP_BPF_TYPE_ENABLED(sk, atype)				       \
> +({									       \
> +	struct cgroup *__cgrp = sock_cgroup_ptr(&(sk)->sk_cgrp_data);	       \
> +									       \
> +	__cgroup_bpf_type_enabled(&__cgrp->bpf, (atype));		       \
> +})
I think it should directly test if the array is empty or not instead of
adding another bit.

Can the existing __cgroup_bpf_prog_array_is_empty(cgrp, ...) test be used instead?
