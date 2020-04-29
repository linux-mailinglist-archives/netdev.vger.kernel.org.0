Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F143B1BD173
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 02:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgD2Ayd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 20:54:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49430 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726399AbgD2Ayd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 20:54:33 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T0p3Mc015198;
        Tue, 28 Apr 2020 17:54:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=x/U6mRkRQxD5ww73yTGRk8UWjEV5ntQNaSZ5dwix9Oc=;
 b=aMLn82Gq0tPDSl2PERihOZjXQ2+w+Z+nhrY3FjMQ0RD4ESmZ8VMJPcU4CMWDH0RFxd2m
 mh6k0JHbDljIacwmserw7a6C56nOZB/chsmHPQk+1WN08WwH+/mq3KwFLAdQj/AGwgwc
 3vHX9HDmQmKqQ9N3KeBsYrt25RrHpd9EepI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30n57qb7g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 17:54:20 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 17:54:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=An3aJono/ooY3koi3AdvaIII2RAhD/qgPzCC3NILySmHofKpM1zf+xFhI+/gbPJuwH9mM2wJ0A+x0ytXReZJAli4k2bpaQu82U0nsSp9SLmCSf8ATOeyrYWMcOxiLP4Hq0JEqB4QAIoeINDnqfkHN9BlVHVlsdNbrFHCKTR3/olCJL0VcFMOaBehF84HnMTTPpNHEHN+9vv4yGCnzNJ/GWfJQCGYDJgySngi69Ttin8tbFNMrwwjgHzixDFBcGI2qFF1b9IQbDvxqrNefqfG7+w2yPMtIAYWNlSl3mWOciHYX2N7CeLgSnxlXBQMQI1fd24WD/x/ziM4HO3aoC8FMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/U6mRkRQxD5ww73yTGRk8UWjEV5ntQNaSZ5dwix9Oc=;
 b=D8DnT3RIGM7YoCagzEpcrHb7AzjGNBlJO+NkAzFJh0jqvF9SzPPhajivA0xnJ7mm2fwkkYgcxh6mZFoXEfH1G+qp9UVR2duwKciLoYksX7DR91UIRuLBT9INaOGWuyfECkX4t1JJj8JdmMjbX1EwBdS0olZYAdVQy1ePMKM6Avv996MMX/F7YUHQXo3yfR/pQlILoaG/2nLucJAIqMOdX+socvI15jvr9wuQv2w+U2TBJ9EzyPIyq9PiH0EZFaIUk4ry4basXnIZHEqmrE5bkBJW97ezyjCA6G+7OfQapQu86gDMjhQ7qNLN66DXWIJ0Gnr7luAwbxeimKWlyIR9cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/U6mRkRQxD5ww73yTGRk8UWjEV5ntQNaSZ5dwix9Oc=;
 b=YgxKZE+yEZ19f/tYNb5FlisCoM0hmnPRBdAfqzNyNnik7ai3NlGG7e4NBXxzO7NcudLTRESzyzfBBRdvu9NQCjiwuIG9x+FWXG+HiqPOh4EwIAXajnoteumMChoOUshu4ObDPB5WUYDhXFkHsQ4h7RRmp2H8IMNnLAlkFFkwFlQ=
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB4041.namprd15.prod.outlook.com (2603:10b6:303:47::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Wed, 29 Apr
 2020 00:54:18 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%5]) with mapi id 15.20.2937.026; Wed, 29 Apr 2020
 00:54:18 +0000
Date:   Tue, 28 Apr 2020 17:54:15 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v1 04/19] bpf: allow loading of a bpf_iter
 program
Message-ID: <20200429005415.x2ocuctowbagpkaw@kafai-mbp>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201239.2994896-1-yhs@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427201239.2994896-1-yhs@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR04CA0057.namprd04.prod.outlook.com
 (2603:10b6:300:6c::19) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:950c) by MWHPR04CA0057.namprd04.prod.outlook.com (2603:10b6:300:6c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Wed, 29 Apr 2020 00:54:17 +0000
X-Originating-IP: [2620:10d:c090:400::5:950c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c488860-1949-4934-12f0-08d7ebd7d861
X-MS-TrafficTypeDiagnostic: MW3PR15MB4041:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB404174D5B2CBB59EA450597BD5AD0@MW3PR15MB4041.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(396003)(366004)(346002)(136003)(16526019)(316002)(66556008)(6636002)(66476007)(86362001)(186003)(9686003)(55016002)(33716001)(2906002)(5660300002)(66946007)(1076003)(6862004)(4326008)(6496006)(478600001)(52116002)(54906003)(8936002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wHI6Lfs30tHTVRqy6dfntR6z8t2mvZ/e7eV43l/OzXy8zptXRHWYATk422+QUMrmtFa09l8AVHngv/foWpvh/u6mNGBF0RgnfrJdvDX6d9DGef1wXw+79HwGxp29YshW1P85E0c7TapC7JGub8AmzfJHvEaBQ2EObbEyhOH/+ZN1nap0lChFoJlkgYZQpoWj1Tl0URSpTo4aYG3YVXHPgjWGdiZJIIIRwHt0tbpi7xFErwyVIW81EoOl35TdUfULbXCRpsf0pTP5bdI6XhtO6tfpY5Xk8euyCXC7pykpglkMxKN9dq0cWH71okKHXUYIH3IFN/JN4Q1Pnghq71vInNnZfRoez23FUVH8BHDAtcycadvjBR0Ibv5wXUo2EILV6MiAV5pqTJIndw3aP/CdRkcfeNJpqN22QIJoFimLNDjyWk8m+llpKgqLWK964iSK
X-MS-Exchange-AntiSpam-MessageData: G4JVQupobxxnCjsO8KkjWaIpGsSUgL4yxoxZrdL5UrAMl0rB8iw9Lf3hNQ24Mzi/u/rzcUmBQSd2VCb6ivdDG2ftJHS23MVps3tXOILjXwduVq2aRdqaFv7VltfnwekJ3agwY0jDBltuVIt9CqCs24V4k9M9IU6qB7LEMzqLx1/UD8/U/oV+y9dyexkhxxGcJ9qe0VdcjHZEpCiv7axo0Skytp9lrI+6UkD1FIPfB+TBkEDIIPiHOwCxkO0KpDdQZbD2lESHD4Q9kiaKwSOQ5wH12vrLUtRLRFwNUA2Seuq7E7j11uBPBg1jhkp29q/ZEtmU3DrxGVLXTmmW3RvG3kbONCxINW07vSI2qTye63DN/+T+B5Wz3hjYR10xWg4MdMYj5LUc2hz2g+1gqWu/Fao8tNmAMrzZgtQNOrWkgkjh2H60Xh2SxTiVvma752/sf3Q5RrSmO8w3i4/VWEnw63gqiMrwbr1hxzKRdMIlUoaA4GzSuCLYXKevBBZNSzbJBeKNxgt7MRJsHSwgk8zh4VPOdyUmsBoIWs2JjjLVRVAdlcfqYmbCI/Yx36ME6YD0lYI9Al2j49tGPxRBKJGVKhP/zgJwmHbZJS/cIfNGpHNMzRRq0Pv7oSuSYPWtQ+sl12SzbwRPRmANLWUgq5vWs+JgbcFI7U6OatkUoLletB9dSD2nuzPEDdpbzy2XkPN/KPPKyounCA4Dj4+d5KSFNiyy7AUK2hXbXJff0Q1achwCodS+S+DxStCSq8ky4Hi6sEcB4AtaaPFlxnmLnVWP6tHUwxWTPEOad0cC9ytT4yDX/hg737Idq55wzH3Aa/vEZdTholmk5NeWMdZbxWCcGw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c488860-1949-4934-12f0-08d7ebd7d861
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 00:54:18.2855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0GpZF6tA89YnciaqdYnXFhODWFNHuWLbGrqIfJfye3CChHLCDmr/hIauI93vky8K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4041
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290003
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 01:12:39PM -0700, Yonghong Song wrote:
> A bpf_iter program is a tracing program with attach type
> BPF_TRACE_ITER. The load attribute
>   attach_btf_id
> is used by the verifier against a particular kernel function,
> e.g., __bpf_iter__bpf_map in our previous bpf_map iterator.
> 
> The program return value must be 0 for now. In the
> future, other return values may be used for filtering or
> teminating the iterator.
> 
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/uapi/linux/bpf.h       |  1 +
>  kernel/bpf/verifier.c          | 20 ++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  1 +
>  3 files changed, 22 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4a6c47f3febe..f39b9fec37ab 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -215,6 +215,7 @@ enum bpf_attach_type {
>  	BPF_TRACE_FEXIT,
>  	BPF_MODIFY_RETURN,
>  	BPF_LSM_MAC,
> +	BPF_TRACE_ITER,
>  	__MAX_BPF_ATTACH_TYPE
>  };
>  
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 91728e0f27eb..fd36c22685d9 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7074,6 +7074,11 @@ static int check_return_code(struct bpf_verifier_env *env)
>  			return 0;
>  		range = tnum_const(0);
>  		break;
> +	case BPF_PROG_TYPE_TRACING:
> +		if (env->prog->expected_attach_type != BPF_TRACE_ITER)
> +			return 0;
> +		range = tnum_const(0);
> +		break;
>  	default:
>  		return 0;
>  	}
> @@ -10454,6 +10459,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
>  	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
>  	u32 btf_id = prog->aux->attach_btf_id;
>  	const char prefix[] = "btf_trace_";
> +	struct btf_func_model fmodel;
>  	int ret = 0, subprog = -1, i;
>  	struct bpf_trampoline *tr;
>  	const struct btf_type *t;
> @@ -10595,6 +10601,20 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
>  		prog->aux->attach_func_proto = t;
>  		prog->aux->attach_btf_trace = true;
>  		return 0;
> +	case BPF_TRACE_ITER:
> +		if (!btf_type_is_func(t)) {
> +			verbose(env, "attach_btf_id %u is not a function\n",
> +				btf_id);
> +			return -EINVAL;
> +		}
> +		t = btf_type_by_id(btf, t->type);
> +		if (!btf_type_is_func_proto(t))
Other than the type tests,
to ensure the attach_btf_id is a supported bpf_iter target,
should the prog be checked against the target list
("struct list_head targets") here also during the prog load time?

> +			return -EINVAL;
> +		prog->aux->attach_func_name = tname;
> +		prog->aux->attach_func_proto = t;
> +		ret = btf_distill_func_proto(&env->log, btf, t,
> +					     tname, &fmodel);
> +		return ret;
>  	default:
>  		if (!prog_extension)
>  			return -EINVAL;
