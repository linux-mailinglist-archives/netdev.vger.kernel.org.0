Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAD73A3C40
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 08:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhFKGv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 02:51:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12870 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229824AbhFKGv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 02:51:59 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B6nDJY019353;
        Thu, 10 Jun 2021 23:49:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=eR2edkxs6m0DhSZC+RXfiqz/PlhhH3z8TdTXzbxhHLU=;
 b=gTIN8b8LhcgiBSm1/qn94dkItZul21HSqn1Gf9chDF9mDlOn985MMBOiB18dSu6Yv3de
 C9mfXAw9UjiLR+BjqEawx1l4WYpqPh+5jCelqE9K33/B2XZu+YCmxpFmTZ0Lw1g504JH
 F4JAXQF2xlXzBhii9f/CLST0w15yDNLn2MU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 393sk0atrh-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Jun 2021 23:49:20 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 23:49:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lxK44kmqYkcMBaRHsq/sMhzcQODKmMhcLc8YoUagHtnM4DXVIys7vl8TvsFkfTfDdZIoLnAPQbmwn0QtDjbP3uhAtjLnlgznmV6v03V6YmbFXZcQPRGeABOyxWPk07QR4uO0wFZM9JJ9nvhsoDgSuXQZYDw+TtTx0ClwdxV9mxkLZnFBJrQu3kg9LJN1xInhsdfHsjSasG19IVI25tDuWNgIyzsW70IoBNHmxrb7QV3D+Bpoql8Q+A9FdDyi6swy4tE+oOdmOJfmdtdRqGapK2foiun+jBEDOKyD4Bt0GNbxVN5wPKr1NTJxeBsMpJm4B9rjxre8Ue4AhDjb1sVRew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eR2edkxs6m0DhSZC+RXfiqz/PlhhH3z8TdTXzbxhHLU=;
 b=UFgxJhiRGuC3yM8pZIDiUM+BxS6/YDk0SUnzojphvEiVhsQpT5NkOcQpLDrXdSAU4bxbkYcAA2rx4G6YU4skMMzuJ598xxYoso63UyTbFjLODOuBCGh1oX23t3MZkk4pkl3yoU2vIgXJKJQm8MsflIocj1uyg+LwwLNygq88qBDxJqI86aeZalpJQH4F8+7m5shGytNGVKmIvCcoZCX06d0ZqwlPF4idlCJGFzj3DoKiV2TO525Y1Tlf0Mkl9BzQnyuDkEH5OsJ/Zd4GnyNrIDpibVsQAa3FDn1lLt9hHd57yM6dfJaX5zCHDqImuJqxVBN+Kees2yMnY4bYUoRi1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR1501MB2000.namprd15.prod.outlook.com (2603:10b6:805:10::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Fri, 11 Jun
 2021 06:49:16 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f88a:b4cc:fc4f:4034]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f88a:b4cc:fc4f:4034%3]) with mapi id 15.20.4195.031; Fri, 11 Jun 2021
 06:49:16 +0000
Date:   Thu, 10 Jun 2021 23:49:12 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Tanner Love <tannerlove.kernel@gmail.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Tanner Love <tannerlove@google.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH net-next v5 1/3] net: flow_dissector: extend bpf flow
 dissector support with vnet hdr
Message-ID: <20210611064912.76eoangg4xgyb3v5@kafai-mbp.dhcp.thefacebook.com>
References: <20210610183853.3530712-1-tannerlove.kernel@gmail.com>
 <20210610183853.3530712-2-tannerlove.kernel@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210610183853.3530712-2-tannerlove.kernel@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:1b7e]
X-ClientProxiedBy: CO2PR05CA0102.namprd05.prod.outlook.com
 (2603:10b6:104:1::28) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1b7e) by CO2PR05CA0102.namprd05.prod.outlook.com (2603:10b6:104:1::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Fri, 11 Jun 2021 06:49:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28403feb-0822-4fe2-8a47-08d92ca507f8
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2000:
X-Microsoft-Antispam-PRVS: <SN6PR1501MB2000186B0FCD7A4071FC6BA0D5349@SN6PR1501MB2000.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6wHFMW6gg3DP61XGptXH9rV2etrwqVZlnzXrg8ZUsNGFzV/BlYtW9D56E+xKy4MC8gSSJe80ZD05uXlCYRhg7zsWbKVoQ0imH4Qp+UfrqW1gshX7jnPjLY6zaDDmg2Myvobkk9OXTm9SHpEA+I2QJfEwe13eVes/QwKgsDo8NWh49yU8fkEBYh952FbHh1LY6oP0JdFnPLGnJsyNAIipZuX08do4JPHBT+2WuVue5u8g2gjaoQMEuYhckSrfpo5Li57Hw47pLYKINYIw4k0hjq0+vs7pO9RtF/KmQKFbL64lzoU+SdKfkbuP5zyh9zq10MmBeFlXa6RQYJgNYGPvAMWdw8oAlGsy5GTXd3f5/b9tcqJXOq0O1x1/DlU7QjHLPKz93NMvbE+h8saDugM5TQQ3/cm7wNjKaXIxM6721nlk0veZkBlZ7kn7+56CjIUddvyN2GSE6ZnfbYe9r8i7yIUyIGiH5cxtH+e8IaePPSl2rys17MA1lu3wLP3vrtX7J2InsMuBMQt0E/+x0uoapcBKDPz5rpp08rV9V4je2Np4jUif1vtjC6Eq37lb7sR4ZgPi3W1Aw370UzmnAC7MC+TCoZl0dRh4nLMn7cnm+lc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(396003)(346002)(39850400004)(1076003)(9686003)(7696005)(54906003)(55016002)(6506007)(8936002)(38100700002)(2906002)(52116002)(16526019)(316002)(5660300002)(66476007)(66556008)(66946007)(186003)(83380400001)(86362001)(7416002)(6666004)(8676002)(4326008)(6916009)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C00pZMISf8h/+Q64pgua7pa90jid1I+w/TAfPe8G4DNGiTGy3GWOlLAjOEKt?=
 =?us-ascii?Q?z974+VWWt4IHTFwBRcrx7aRaGaa1SGoi2uuWl1t0LCwNmdN5Nw5isCf15Jcz?=
 =?us-ascii?Q?L3bx4R5nUbVQ4V38EqA148g7U7W49kXsCsoGIW0DZU/EZq0BVtUYKV9KiNLM?=
 =?us-ascii?Q?UpYK5nkM2/JnqR+IakOcp9E0aWh/ebfa8WVkKhcugYgbUo+z4luLLi6Ao533?=
 =?us-ascii?Q?Jl496Z/y3oUfjdsWNusaX5EMLLK5f+z57r+G08HR/bWDjvqzwhYv6QZSHbqj?=
 =?us-ascii?Q?3ImQoJULFjAttjln9P2GGQBn477C+s+2Gis4A/zb8lt4DbAoPSFUe+mBN+cB?=
 =?us-ascii?Q?mOHFTkVjroiiiFfJZPiKixNR0dTpJgO6ogMbLTbx8F4Anrm/L4r2TUBCUBJn?=
 =?us-ascii?Q?Dmj8AFDZXrhtGN53bvnIH3Co90exXCHWJLdYQNNzvd7fTqdO0+1OwoDDSvVT?=
 =?us-ascii?Q?foGzAiwMFS6Gdwc0hsYAWD8BTd4Yspb1N56WQFPT2KsLr6WmG/tNg7bmfIHq?=
 =?us-ascii?Q?VeuPDs/pzGC6z95ul70lYkW+sPqTz2AJKKPBRE6ZoofTjs2WeYRuOq3nCDvr?=
 =?us-ascii?Q?TbysXuJcn9sVg4x5dEsGLkKM0VYo0L1G1KNOjSxbE8tc3Agwwds6Skb7P5Pc?=
 =?us-ascii?Q?MRlfFN/7QKL92SULl3xFm7X24gWIIhXaY3HbVsDqrEFRS3Qt77v2h2sFRFMO?=
 =?us-ascii?Q?iITX55Ht0YhpZhF40TMPWHqAcs0G17sBtPT1Pn4PCj0SW1ls3GenjGkmVJTJ?=
 =?us-ascii?Q?IPlsodWFdCu/0iOzyegS1uAqmKOSYHktxBUE+WSgjD3vJWpoMGvQMvlPsy/y?=
 =?us-ascii?Q?rRCEe1mX270ROWDAr+d/wt2z1HRds/pQUGb9QYejaR9GATAK27JZkGftUBze?=
 =?us-ascii?Q?69RZzoNLsC0NixVnTW/ZCTvoZV77y+VjvR/50dDVKZDGdV/G/2CLTDVTqe2v?=
 =?us-ascii?Q?57wCjH8Su0eeWK9ZyLzTFcmxoBRCT+mizpuQULCo2oFkbfxuMKfp63f2rNC5?=
 =?us-ascii?Q?4s33TPcCSb8rF+TdGhNzCrIvmRoQF6i6B6hAMBpDtFHm6wVpiNB9cqByRSvb?=
 =?us-ascii?Q?QYc3CstkEeweBiCptn2kK849paghL1sHXVus/DVHANM0PGSAl20+dSml/5ED?=
 =?us-ascii?Q?eOOB6NsPgN+XbwOQAKX4t8B6HDFX9Ea6CLJITdpHx/fL7tsyIeNm6lKI3Om5?=
 =?us-ascii?Q?d5YQft1u+PSxtq3VmRQlgDAzLpjw2IrJH30yVhJ9IPfLX0axUgrT/mYVdxXE?=
 =?us-ascii?Q?mBgzr7FC3HhYZcS9P2E0AQD/1+k0Zz5mex3p+9yGxwmrZ143dr0SvdNJ0rUy?=
 =?us-ascii?Q?4qgE25iC8jZlshD6DoXHCY1IIYwm9ZS9cOshJXmX4bkw9Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 28403feb-0822-4fe2-8a47-08d92ca507f8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 06:49:16.6691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v19An2QNxLUU8HtzbYL0QWlupl77gMSH8Yms6IPLbB2Owhdai3T32PDVVZHdj97Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2000
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: fNzhpwSBosmjy-cgZ5hkqsUzh_lFHvB8
X-Proofpoint-GUID: fNzhpwSBosmjy-cgZ5hkqsUzh_lFHvB8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_01:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 malwarescore=0 impostorscore=0 spamscore=0 mlxscore=0 phishscore=0
 adultscore=0 mlxlogscore=984 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106110044
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 02:38:51PM -0400, Tanner Love wrote:
[ ... ]

>  static int check_flow_keys_access(struct bpf_verifier_env *env, int off,
> -				  int size)
> +				  int size, enum bpf_access_type t)
>  {
>  	if (size < 0 || off < 0 ||
>  	    (u64)off + size > sizeof(struct bpf_flow_keys)) {
> @@ -3381,6 +3382,35 @@ static int check_flow_keys_access(struct bpf_verifier_env *env, int off,
>  			off, size);
>  		return -EACCES;
>  	}
> +
> +	switch (off) {
> +	case offsetof(struct bpf_flow_keys, vhdr):
It is not enough to stop writing to keys->vhdr.
e.g. what if off is offsetof(struct bpf_flow_keys, vhdr) + 1?

Will it break your existing use case if align access (off % size != 0) is
enforced now?  Take a look at bpf_skb_is_valid_access() in filter.c.
Otherwise, another way is needed here.

A nit. It is a good chance to move the new BTF_ID_LIST_SINGLE
and most of the check_flow_keys_access() to filter.c.
Take a look at check_sock_access().

> +		if (t == BPF_WRITE) {
> +			verbose(env,
> +				"invalid write to flow keys off=%d size=%d\n",
> +				off, size);
> +			return -EACCES;
> +		}
> +
> +		if (size != sizeof(__u64)) {
> +			verbose(env,
> +				"invalid access to flow keys off=%d size=%d\n",
> +				off, size);
> +			return -EACCES;
> +		}
> +
> +		break;
> +	case offsetof(struct bpf_flow_keys, vhdr_is_little_endian):
> +		if (t == BPF_WRITE) {
> +			verbose(env,
> +				"invalid write to flow keys off=%d size=%d\n",
> +				off, size);
> +			return -EACCES;
> +		}
> +
> +		break;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -4053,6 +4083,8 @@ static int check_stack_access_within_bounds(
>  	return err;
>  }
>  
> +BTF_ID_LIST_SINGLE(bpf_flow_dissector_btf_ids, struct, virtio_net_hdr);
> +
>  /* check whether memory at (regno + off) is accessible for t = (read | write)
>   * if t==write, value_regno is a register which value is stored into memory
>   * if t==read, value_regno is a register which will receive the value from memory
> @@ -4217,9 +4249,19 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
>  			return -EACCES;
>  		}
>  
> -		err = check_flow_keys_access(env, off, size);
> -		if (!err && t == BPF_READ && value_regno >= 0)
> -			mark_reg_unknown(env, regs, value_regno);
> +		err = check_flow_keys_access(env, off, size, t);
> +		if (!err && t == BPF_READ && value_regno >= 0) {
> +			if (off == offsetof(struct bpf_flow_keys, vhdr)) {
> +				mark_reg_known_zero(env, regs, value_regno);
> +				regs[value_regno].type = PTR_TO_BTF_ID_OR_NULL;
> +				regs[value_regno].btf = btf_vmlinux;
> +				regs[value_regno].btf_id = bpf_flow_dissector_btf_ids[0];
It needs to check "!bpf_flow_dissector_btf_ids[0]" in case
CONFIG_DEBUG_INFO_BTF is not enabled.  Take a look
at the RET_PTR_TO_BTF_ID case in verifier.c.
