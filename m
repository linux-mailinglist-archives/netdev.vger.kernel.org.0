Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7258F4380FC
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 02:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbhJWAiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 20:38:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19200 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230086AbhJWAiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 20:38:24 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MLC8gL029591;
        Fri, 22 Oct 2021 17:35:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=7XKln6Bp2bj/zahADh92sU+VAj1XvzUNrjpRT4+Cy2Q=;
 b=FpNz4bNPMautiamDh3+4wF+9vsYcUAnIHpzmF65oXySBDRDSHwzoRCtFwBr0US6D21UO
 e+02Ft4H8OFQO/tUfROikHbTRphb9Tj+KtxpNKA6PVE5STQUd3/hEvMiV/Teyo3Jcqat
 3L+aIMjRoQq1I4MVF4cAszXyql35GFheceQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bunregnkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 22 Oct 2021 17:35:42 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 22 Oct 2021 17:35:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWTel3XPq80+QELDIIMJIqvO+2sGbxEc/1VyX7TsrbwNi516SwSeaDXAc4lMeLzyvXYfRCAlcWb2fxxLK7QMxtfCd2vbKEFIRnZJ68HfG3eQf0buuymPlFZeJJ+Ql9FPyox23mI2+tPzsA+WWepybMD9BBPzcZcHR7O5/fz1499Z8XHjGh7fBCd+p5hF3lYmrTMwgE0z4xMYydfO/hxINpxtNN11TRuUVp997L+z2OtD59KWYjxcAL2laIhqoka/OSIA4d2YZ+yWfVzdsP22bzwBY4eyb02Dc+ylx/gkstSzJaWqPY17rZg7US10pDfqz9WoYNlnJ7C7TBnPCIf9rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7XKln6Bp2bj/zahADh92sU+VAj1XvzUNrjpRT4+Cy2Q=;
 b=g3dVvg4sU1OEOOKt7zROSLYtWu/5NKjivMwZElqvuIHOtnPSNTZLLImTIoXBLxvRSHlMI3dcB3/fPnkosP0WhgWnNAB4H3f3V5AH7ueJN5WQHy1gKHh1TQB5wR+qJUcKyMKlvE6VT4fg/TirlGrw6TgizCS6HSZF/sreY5AXRqxDUT2DXQeKuVwdGojbUgKzpwfX/cq27Ja6Hr6gFLoSl02JeYjjaD6LCRLiCkAwX5YAT9zyFTyZqUkn3zUuPoDIkLrdLYYDmsv1iWvZOONbsQBWScnkVLI8jSdEQhhTjGsemYXoQ7x+lecaZg4xL33LDDchdz/noDCoWbJekP4xBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2511.namprd15.prod.outlook.com (2603:10b6:805:24::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Sat, 23 Oct
 2021 00:35:34 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%7]) with mapi id 15.20.4628.018; Sat, 23 Oct 2021
 00:35:34 +0000
Date:   Fri, 22 Oct 2021 17:35:30 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hou Tao <houtao1@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 3/4] bpf: add dummy BPF STRUCT_OPS for test
  purpose
Message-ID: <20211023003530.c2sfy6ogic7gdvzs@kafai-mbp.dhcp.thefacebook.com>
References: <20211022075511.1682588-1-houtao1@huawei.com>
 <20211022075511.1682588-4-houtao1@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211022075511.1682588-4-houtao1@huawei.com>
X-ClientProxiedBy: CO2PR18CA0053.namprd18.prod.outlook.com
 (2603:10b6:104:2::21) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:792e) by CO2PR18CA0053.namprd18.prod.outlook.com (2603:10b6:104:2::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Sat, 23 Oct 2021 00:35:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 910f1caf-7866-4ed6-b696-08d995bd06b4
X-MS-TrafficTypeDiagnostic: SN6PR15MB2511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB251164DFA37B28C430CE726CD5819@SN6PR15MB2511.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OckdDrKgjxO5bSA6neVuyJ6s75EsLUBbn3Kz9355ViI+RTjA9XMfGg0cMEE64pPX6ghBKECLsweBeIjq9U28e6e+TC67MmtkBs+VLAbsiu1A+LZLRdK6p5igJSoh5lCWdJmm/nqpgb3oDEnvQe09M2ynnOWBtky00rmfTFLW0rDsDb9tHu4YyhTzmxj5dQkHFaOE6CF69qLb0C+vbThpJ2CLljbdX95oGOdJSEu80Tl/8GXmuD4IVGdzLvhi7fH/AK2wLq7VG7do04D2bjYi/0al3MSPTpWYuvQ1ujY3Y+qV2H5ECk9kwUrvvlENMDm0VAzvkYGV3ti0hKPBQ34eTUUdvAO1k9x8KJjWfGY+d3WKkm7nnIOstb/jK2OQ9EM2XTxSVa4rFtSfP4VbeJSxWpVI8cLYQyCeMijZ5oAmtwsJfgHUxyLXO4YcMsj6K2Fhlsc4iqOZzYGFUHUIjzYOnOX6rabE+/pI/AZC/brMwjr59BfffYmvGl/vrdFK/XGkfb4KtpMuYZeDl8rqDwct1sMpVmf7VLcHXxAahU20DZzqDyBAy/iRdrIE9UQnQNXMwo7kMOkjzs/cVb6XuNrBN6z0X6/D28tNnOHyouGisRgyym3Z4ZkDsAnoR3mag6W3vrlgbRz0yc8rbxzUmQSwMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(5660300002)(8676002)(1076003)(54906003)(55016002)(8936002)(6506007)(316002)(52116002)(7696005)(66556008)(66476007)(86362001)(2906002)(508600001)(9686003)(66946007)(6916009)(38100700002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AwMLEN8+ichyJhtVX3YvQSISwEbuncUCsVqPBlywwfUf5ALj28DYpKATdAdC?=
 =?us-ascii?Q?EPmAXwru8IXDW9WhOcJo7N7LGOvAmAGLe4heoEbAytNV469I2r2QztCvdCYx?=
 =?us-ascii?Q?hAanrvI0KhRJyxlxN365McI0kAZp9z6RD5kfcLDTPZPPLl9YUGjgyjtgKOLn?=
 =?us-ascii?Q?hKrCNYtzkUM33bEoce1ZXNP+0fgoI6+yzwv33KOc3WQjnlWlQ5Kee1K1lPQ2?=
 =?us-ascii?Q?z2Cwi2xU29TJc5e1YGo9SEAJSGK+wzg+9BKSbXf8zJzjU+tyHDROf3WGuSjC?=
 =?us-ascii?Q?9d/mu9fDrq9LVlm7lUikMovGGn9MYbYZlyi2q7pchlJG+WACfdZySDDD5wtB?=
 =?us-ascii?Q?cNG8O3kujKRszCtRcvrzuRdVz5ijNfrnIZcoCKXQT/gfOah7AkXG9CEw0dVE?=
 =?us-ascii?Q?DAKUEy7dSYb5XcBgqraPXdbxxErMji8OeAeZ992xhA+T8yxzgwFCaJe+FtV7?=
 =?us-ascii?Q?3xyMrocIBPmadEzrbIYW/EDvcvwpudXRTFN3j+aaddZAbuItAhsFyL4JRa6X?=
 =?us-ascii?Q?nL4FxcME7Luog7GR3d01jcvx12RW5u/lkkdUCCclf39woPiE3zdbDUFwCF5y?=
 =?us-ascii?Q?gsuXYkmFIzlpov5Qv4Yv7a9o4Omd452UHXrrCbZWJ9PBzGegT0xzZvgKdzZh?=
 =?us-ascii?Q?xYhg4kjH8af/KKy+9JPyY5dltOCaKVhtOcNCOJdUgZHwsUakJgiEBS50xb/x?=
 =?us-ascii?Q?RSAd+yqQSAb2dpDWV1/SQdHgbldaz0VPYdvqthSfeA+B3aem4LiADFwunH73?=
 =?us-ascii?Q?ibVRTDNj927dtE+ttSD1jODIt8t2hYLTC8CoWqpbpIID/jtffXbXshJMG6MY?=
 =?us-ascii?Q?u+/s558avCeMRSnYmLGHHBMuKcgXmlEKtO2f0iajkp3DNokmL0t4Q1fIw0eQ?=
 =?us-ascii?Q?CSYGqigoHPP9h5RO64RO2hZhcsspqqM8Q4UAK1x8gPSU3KE/OdYj0QQ+b59P?=
 =?us-ascii?Q?1i5UJ1qaRAdOpjIuIxjFtDj8UhQDHRS1Ce+2n45NmbyJSZDOpUKuXwXEPFk/?=
 =?us-ascii?Q?hH4oiszhhj5E0E/AwILEC96+C4SqkP994l3O4fTJlPmWIHchOBPf8nF376f7?=
 =?us-ascii?Q?YA1ooaHl/oprYfTRcCj2nmyzrc+Wpw3NKN/Z+cEWuIZwmdq8x0ikC+FjcfGj?=
 =?us-ascii?Q?paVWkmX0xnK8FaZafBO0ESMEFrixdEk4dk7zwwDusPygamZKxriYkkFF5dO6?=
 =?us-ascii?Q?/brefLMONtl1MgzY7PmKnfsvfTdfGBLDilWJucvNFMVjkLZ6ZXNu+/qIPz0n?=
 =?us-ascii?Q?7UgrhPvD4G353XDbyX5s+/3j+XUiYQMTqnUuFgLwXzW3RktulG2xtm/gtKWS?=
 =?us-ascii?Q?d47XzM0TNKWqhPlpAiRBskGO0MGA4UEf3nZ8Z1eOIZFlCwCmdZl0r4ChrXnL?=
 =?us-ascii?Q?a3bj/Zc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 910f1caf-7866-4ed6-b696-08d995bd06b4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2021 00:35:34.5789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dz8GM3oqJ9zlUghy9y7Vw0zXbOV5ZPWo9+7+l261VsA0VtAOu3pj4PAKxZ5A1nUV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2511
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: W0lxOQ57zRI3_oo2YSN0klPrFmt6v9Mz
X-Proofpoint-GUID: W0lxOQ57zRI3_oo2YSN0klPrFmt6v9Mz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_05,2021-10-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 spamscore=0 mlxscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=916 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110230001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 03:55:10PM +0800, Hou Tao wrote:
> --- /dev/null
> +++ b/net/bpf/bpf_dummy_struct_ops.c
> @@ -0,0 +1,203 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2021. Huawei Technologies Co., Ltd
> + */
> +#include <linux/kernel.h>
> +#include <linux/bpf_verifier.h>
> +#include <linux/bpf.h>
> +#include <linux/btf.h>
> +
> +extern struct bpf_struct_ops bpf_bpf_dummy_ops;
> +
> +/* A common type for test_N with return value in bpf_dummy_ops */
> +typedef int (*dummy_ops_test_ret_fn)(struct bpf_dummy_ops_state *state, ...);
> +
> +struct bpf_dummy_ops_test_args {
> +	u64 args[MAX_BPF_FUNC_ARGS];
> +	struct bpf_dummy_ops_state state;
> +};
> +
> +static struct bpf_dummy_ops_test_args *
> +dummy_ops_init_args(const union bpf_attr *kattr, unsigned int nr)
> +{
> +	__u32 size_in;
> +	struct bpf_dummy_ops_test_args *args;
> +	void __user *ctx_in;
> +	void __user *u_state;
> +
> +	if (!nr || nr > MAX_BPF_FUNC_ARGS)
These checks are unnecessary and can be removed.  They had already been
checked by the verifier during the bpf prog load time.

Others lgtm.

Acked-by: Martin KaFai Lau <kafai@fb.com>

> +		return ERR_PTR(-EINVAL);
> +
> +	size_in = kattr->test.ctx_size_in;
> +	if (size_in != sizeof(u64) * nr)
> +		return ERR_PTR(-EINVAL);
> +
> +	args = kzalloc(sizeof(*args), GFP_KERNEL);
> +	if (!args)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ctx_in = u64_to_user_ptr(kattr->test.ctx_in);
> +	if (copy_from_user(args->args, ctx_in, size_in))
> +		goto out;
> +
> +	/* args[0] is 0 means state argument of test_N will be NULL */
> +	u_state = u64_to_user_ptr(args->args[0]);
> +	if (u_state && copy_from_user(&args->state, u_state,
> +				      sizeof(args->state)))
> +		goto out;
> +
> +	return args;
> +out:
> +	kfree(args);
> +	return ERR_PTR(-EFAULT);
> +}

[ ... ]

> +int bpf_struct_ops_test_run(struct bpf_prog *prog, const union bpf_attr *kattr,
> +			    union bpf_attr __user *uattr)
> +{
> +	const struct bpf_struct_ops *st_ops = &bpf_bpf_dummy_ops;
> +	const struct btf_type *func_proto;
> +	struct bpf_dummy_ops_test_args *args;
> +	struct bpf_tramp_progs *tprogs;
> +	void *image = NULL;
> +	unsigned int op_idx;
> +	int prog_ret;
> +	int err;
> +
> +	if (prog->aux->attach_btf_id != st_ops->type_id)
> +		return -EOPNOTSUPP;
> +
> +	func_proto = prog->aux->attach_func_proto;
> +	args = dummy_ops_init_args(kattr, btf_type_vlen(func_proto));
> +	if (IS_ERR(args))
> +		return PTR_ERR(args);
