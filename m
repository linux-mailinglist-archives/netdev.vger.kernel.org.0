Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC742473DA2
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 08:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhLNH1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 02:27:42 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29680 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229452AbhLNH1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 02:27:41 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 1BDMeL1V001530;
        Mon, 13 Dec 2021 23:27:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=CYVe/H9vtO1xcyyJgicE7Ej056wzC+m3WUjrhGh1zwE=;
 b=b0sngEJBxHG6U+Fq6aGKQe/zr/tyxstImjvBSEl9XhfoRetpyhkFroPr2yCmFT7xmT02
 k180fS6rZIngGUVeGrjJEDD0w4F/REPbCxu4dzYm++8q/F7VeOMmw6W7/yH9T1ydwIve
 HXm6ZBskmNg0gORXUntQgVS73aXKhvUiU+w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3cx9rn5bqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 13 Dec 2021 23:27:27 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 23:27:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ry9VmH58FDx6RBmkocaGIpEXL3I4hl3Uh/FguZU7iNHxrYI4rDmFZcn4k47jrlGKR9yIo8/BksWeKLXJUPs78G7A/7zQTAzeJH9niKdyVO9u2n9JXMUV9OVDC0duejMcQDd6AAy5QQ0h5pxYl724SlQ/hVs7n89O9zEmox9hx5hRkuaksPQjkf8k3RPQi6CpHWFCwl1Gqw/hewT5B+kn+qb3iK3GjbRYl6tTuYq6qbK7VM5oFSKnY+ZwgJvgR4/C2MoS0fA6cIzuHAIOE2bKowcjFtCN+285/cszT3mDZ6Ml0l/QrzA4qLLVf0JEiNoIHGRg2HPcSnBqNQP0XB4uIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYVe/H9vtO1xcyyJgicE7Ej056wzC+m3WUjrhGh1zwE=;
 b=ZTDx3SSH6oIkQviVHuAAL71uY6sjWCuR+VRFFXZxWU90BSC4HSAQkaunHPmTHUzfvrqejIxU4CtoFFOvlHfQThU7REEZqveG0IYQf6dSgpO/9OkWn0s9nYPEPQ/+JGCOpyu1H3OuTYZfwDJrYYGPvLFlM+Hf8uNCcJOw5ubk+rTe0/6FnxrsK6ErsuG9yseZ1JYjJKpL98u/sZSrgSzTgVVB9qNotq24UOSr/3MdHbfqEmyO6/HCp7Kv9pU9NmRWYrXhq6LcQUHVJMvyDiLXJagX5QRDExxZ/oUGwqMopYIPplqXWQ6982bcNjB54Vd10+GyW67LOU0sU+uRv+z9PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4612.namprd15.prod.outlook.com (2603:10b6:806:19f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Tue, 14 Dec
 2021 07:27:20 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%8]) with mapi id 15.20.4778.017; Tue, 14 Dec 2021
 07:27:20 +0000
Date:   Mon, 13 Dec 2021 23:27:16 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] cgroup/bpf: fast path for not loaded skb BPF filtering
Message-ID: <20211214072716.jdemxmsavd6venci@kafai-mbp.dhcp.thefacebook.com>
References: <d1b6d4756287c28faf9ad9ce824e1a62be9a5e84.1639200253.git.asml.silence@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d1b6d4756287c28faf9ad9ce824e1a62be9a5e84.1639200253.git.asml.silence@gmail.com>
X-ClientProxiedBy: MWHPR04CA0064.namprd04.prod.outlook.com
 (2603:10b6:300:6c::26) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bbc7186-1217-4ec0-3003-08d9bed329ca
X-MS-TrafficTypeDiagnostic: SA1PR15MB4612:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB46122B84C7BDA1BB1620D8ADD5759@SA1PR15MB4612.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VKxq1eHy7C7bWnEUejLdzcoViTdUMbxyqkdv9kIGIh3Evqnf+IFm2XKBVsjwgPJRv24BGsMmkqIVyzr6+CEZa/NZ8Ic0qPLo1JyID+kqPqMvPjLO2lJJDuvQfsY+/uhsLINIME+CRqYs0mGq1XgQ/3LR39/9L6HMs+JPDQk6pgNxkf8sQKnCX6zhL9qrq1ZvAsmq1katGzdARxaBuShwaOjFwysZrrieVN4WvJ7C9+9c8lFcUZUNEGGc3uspOUlFZE0pZ52FkkfCSBi61eWMpfP+OiMJQLCCwhTNHTq9iqBbxf9anVlI4R5WQzipE0HnG+psO93HfJ0nOcxQQcQdGZHraLeeva/ZhJJ5Rc26PV3H+lPzXnBpD+sZGWNS+AiPmAUX6qO+pnZPzaZoJmfDLVq9BvQFLZ2z0VpfuuII05h+NL5KPbzNxCKIfRh6YXyn4ppN2G4cKQbgKvbTT1h5f4wBLw9y4HRbMb/Q2ShOm2SOnZ23FHoX9DMVGvzqix8ixjeyG2hosB78LaNBt+zM9yjtVMtUmKn1KaaKGF6UyMUVg/h1Rn66sBgKbTPVo3//Wr65DAzkStZvoPe3GcPKHsARV5B18hmliuCtTaH8OsLL9Z3jJzTnygyvIfaIfcbuu6vKMxxWLsfaEGpnwFdERQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(8676002)(83380400001)(86362001)(316002)(52116002)(9686003)(6512007)(4326008)(8936002)(54906003)(38100700002)(508600001)(6916009)(186003)(5660300002)(66556008)(66946007)(6506007)(66476007)(2906002)(6486002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1VCDttqlk7Ed64hsf0lT4fg+yAnFHc8awU1X2SsAjvIpE2Dkj2RF/XayZyiz?=
 =?us-ascii?Q?azPeWONwLkMC7wTkbOD8EgsYFmcBlKkz6oS8jxr9D63nRFWazHt+VHrlyXYt?=
 =?us-ascii?Q?318KTuCqliV8+OEFawvXwJAJQiPHICelQmN9wchqVaEpvPG4zLyJB7cy5hVb?=
 =?us-ascii?Q?qpbCls1iDwDq7PFGBDfasVgyukRCE2glfU7C9pjMTmv2kHUVmN4WWsghWikl?=
 =?us-ascii?Q?0qnY0k7wHOQx9mJtR9oG7kMhQDBGna3mYIAq9IpAmimEZQ+NiO5UjnnPwOYS?=
 =?us-ascii?Q?IXsx9cCmIs9wIsfXF0LE77hxx1L0WdLwhNHscRjhHVRnAuksFJMmZ9U2+YRa?=
 =?us-ascii?Q?t18+jLi1lP57QNlzrE7vElDns46dsiyMnoqmkQVmQOT2CGe7a9jG4/0gLxjB?=
 =?us-ascii?Q?CdVGM0QZW0RwpOu5l1h8lNIcfOXExIe+mqi/qziGxAhfcQIYLe4V0ysmRARi?=
 =?us-ascii?Q?8JcPUB4ZLAy6lPeAM2rfHhLc9oVhqEGBISl9b06D+m5OXKFdRc4n+P3Nl/b6?=
 =?us-ascii?Q?usObnI51L5Be67lYBqzyxCj101SzEXV9PNNuOYwEZiMNAHlvS3iinomp6qu0?=
 =?us-ascii?Q?LosJn/VaCUA0niXr21jN++m2pa4IC7+wrdIZG0HwiMJllNWEUteCMEModXJK?=
 =?us-ascii?Q?JPQu0tfstZR7TiBiTnOY5k8CQZEq7VkWVw3dM7uWXYl1QIpI1Wbyc1gwzn7H?=
 =?us-ascii?Q?Xlbh4lcy7ZEvDJxgDGUPp/iX617DyhG/FYALBNGVSKMua6ZFy5fbNQivzvd7?=
 =?us-ascii?Q?lHFp+/6BpL37I91xVlvBt8G0LRv8uNGhLQ0gdmMKVnorWJWf7kWuJfwqmoNB?=
 =?us-ascii?Q?1KAwS17t7qKQn/5VXLPJ/rCLAd1wjnSbNWEOmO27l9eai/hp3LS6kUMI3+lk?=
 =?us-ascii?Q?nh0f0/dZV5xbyqEV9RtP37DxEtUEyW0YWe1wHECf/Cit2GuXJqqtduRbVSG/?=
 =?us-ascii?Q?YPr2XBeXxHo8UotYQG+eh8MiCbZIA4YsUcIjb6qyz1/Z23qUg5SYssL+l077?=
 =?us-ascii?Q?GV33Ho8s2TH2pVdd+7QkbCeFznhGc708Mo1rCzyTOn9qjEcqiQjorgXnhv9E?=
 =?us-ascii?Q?eUNTSyWQc/CvXEmOZXdzR/fCTQ4P+ZPB85V/wHViSabhLF9nlCrRvmap14ph?=
 =?us-ascii?Q?EOzDdPseSDnxGlibLiV7kTcmTSE8bvvTdWaKtd39uNS83W4zJJdtMWDyOAEl?=
 =?us-ascii?Q?51A1Y4InUhPhDuUyDAWktooK4dHy8mCiGnLQ/QGLqI0vmRX6+FJpSkt+GWfG?=
 =?us-ascii?Q?Sebs19G0VOe2XtYdyp6gzNzvY+nrtykcR79wRc4nOhRB2e5Z3d/zl5AoINY6?=
 =?us-ascii?Q?JEPody/0eeo4ScZ7bZVIIktG59ENXVR46WjHG2+U7qplenbcE07+J+QkFVBp?=
 =?us-ascii?Q?vPPicryZ1HZbhEmMhHMBEC2Kw05/f0R2ZMLmtAEcb1j14xKTv/n6fChyeHa2?=
 =?us-ascii?Q?2XuF2f8bmTmUcC6FMRrJ7k4EqFsHuxyxWiIZU9YvO4XBTAtCt+jcsyFjXH9k?=
 =?us-ascii?Q?sF98tVvT0mLRaZI6Zyl6eU9ajRpEJLAANfAQTFAkC/w/XGiuZ6ybxR2BrZwV?=
 =?us-ascii?Q?ScJcx0IPQAExCHbXVT5Onw6YDz8DHKsM99ZjykwD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bbc7186-1217-4ec0-3003-08d9bed329ca
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 07:27:20.1892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jnXaBjYJ9fd+36jTx2XL9vSvhl23mjTIXxPzbefS0dlRvfEgSOGIFDSNcnfrysPR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4612
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 1mBhofbA9ki9d8Za5Lsbui4DLLgGdUCD
X-Proofpoint-GUID: 1mBhofbA9ki9d8Za5Lsbui4DLLgGdUCD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-14_02,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 mlxlogscore=463 clxscore=1015 suspectscore=0 mlxscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140041
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 07:17:49PM +0000, Pavel Begunkov wrote:
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
What is t-put?  throughput?

Local testing means sending to lo/dummy?

[ ... ]

> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index 11820a430d6c..793e4f65ccb5 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -219,11 +219,28 @@ int bpf_percpu_cgroup_storage_copy(struct bpf_map *map, void *key, void *value);
>  int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
>  				     void *value, u64 flags);
>  
> +static inline bool
> +__cgroup_bpf_prog_array_is_empty(struct cgroup_bpf *cgrp_bpf,
> +				 enum cgroup_bpf_attach_type type)
Lets remove this.

> +{
> +	struct bpf_prog_array *array = rcu_access_pointer(cgrp_bpf->effective[type]);
> +
> +	return array == &empty_prog_array.hdr;
> +}
> +
> +#define CGROUP_BPF_TYPE_ENABLED(sk, atype)				       \
and change cgroup.c to directly use this instead, so
everywhere holding a fullsock sk will use this instead
of having two helpers for empty check.

[ ... ]

> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 2405e39d800f..fedc7b44a1a9 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1967,18 +1967,10 @@ static struct bpf_prog_dummy {
>  	},
>  };
>  
> -/* to avoid allocating empty bpf_prog_array for cgroups that
> - * don't have bpf program attached use one global 'empty_prog_array'
> - * It will not be modified the caller of bpf_prog_array_alloc()
> - * (since caller requested prog_cnt == 0)
> - * that pointer should be 'freed' by bpf_prog_array_free()
> - */
> -static struct {
> -	struct bpf_prog_array hdr;
> -	struct bpf_prog *null_prog;
> -} empty_prog_array = {
> +struct bpf_empty_prog_array empty_prog_array = {
>  	.null_prog = NULL,
>  };
> +EXPORT_SYMBOL(empty_prog_array);
nit. Since it is exported, may be prefix it with 'bpf_'.
