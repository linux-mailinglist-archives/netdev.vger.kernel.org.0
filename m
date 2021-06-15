Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B39E3A8BC4
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 00:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhFOW1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 18:27:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59380 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229868AbhFOW1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 18:27:35 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15FMA7hq024760;
        Tue, 15 Jun 2021 15:25:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=YQVosjQrMj4MF2FmQPdy4OMgZRr8DVBTLKX8edQBN5s=;
 b=Hr/HPosbLewhYp4JpRFVtJiHq4n/950+E2UBjOMgVEu4qAsWRGX9eqLdAXKSke8BeOpY
 J1vDUFSN/TMOboxv/Njdzki+Lt+O/xQcG/9LeNWABKbIyd3RnG1zQDMRL6GkZeYb+qEc
 932fIotrFxiI3dUKbH5/leWm+p3D+PhqaQg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 396x3htw44-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Jun 2021 15:25:08 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 15:25:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z6kqhHSN6P/vIyQUcZ9o3LMM5CZGdGz5ELGFdI5LZfE6kOpAq4V2xB1bGpRzex5wnoG52q2dt/RlPrSqUJ4UIHNjRChf1g91ZUKWciEqaSW/2xOByuZ5vmNdreC15+QckvUF2bL2DQ83KscfEwjLw5ZBL21SffgQn+pjqCPzYT+xQb1Zsn46pB859aOYFx0iNKW23j5f3AK3fLQ87J8fgc7jTDEIjXSikxGDduaFKFnG+UJD/qpvmde6ct8/6BuT0RqcNH2FpcFoK1msMgfkPSZ2Ufn3N9UX0U/+OflJxBogbhrwWv431li50GUFTclYL/4C5UfuY54ZkxBTrM3b9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQVosjQrMj4MF2FmQPdy4OMgZRr8DVBTLKX8edQBN5s=;
 b=Px6JFvs/XWF8iiBC5FOlkZAZi8Zta5vndpj7aUQOwvwg/MosiqnjEYY587VfRmUdeQqtiq58quv2bgew6+VAPo8P/t4PHHYktXYtqKkc/AwqqkWdJ1CUcHtJriLchIu+bXTgzSbuDVhkllhAFhTcNKfST/xPRcXNaCEF3V9v+5r0CvQrMtL+3D8sljNLZAsQ5R9E13M/IHQ3LKKUOxmxFIxnSjH/U1WYH+UO7FEw7n7DiNODD5wS1lmWoUPzveRxcyoW9FItmSW/g7HMudXOh/iruWsI7fgxreI++0O2SvU/pZeOXPtQEscQRrIZQAkIhaxvzdxT9EiRlYRHVtx2ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4467.namprd15.prod.outlook.com (2603:10b6:806:196::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.23; Tue, 15 Jun
 2021 22:25:06 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::803d:ce17:853f:6ba6]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::803d:ce17:853f:6ba6%7]) with mapi id 15.20.4219.025; Tue, 15 Jun 2021
 22:25:05 +0000
Date:   Tue, 15 Jun 2021 15:25:01 -0700
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
Subject: Re: [PATCH net-next v6 1/3] net: flow_dissector: extend bpf flow
 dissector support with vnet hdr
Message-ID: <20210615222501.i7uvj63jv5h4faz4@kafai-mbp>
References: <20210615001100.1008325-1-tannerlove.kernel@gmail.com>
 <20210615001100.1008325-2-tannerlove.kernel@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210615001100.1008325-2-tannerlove.kernel@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:5306]
X-ClientProxiedBy: MW4PR03CA0253.namprd03.prod.outlook.com
 (2603:10b6:303:b4::18) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:5306) by MW4PR03CA0253.namprd03.prod.outlook.com (2603:10b6:303:b4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Tue, 15 Jun 2021 22:25:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea02a463-df44-4558-dab0-08d9304c6d15
X-MS-TrafficTypeDiagnostic: SA1PR15MB4467:
X-Microsoft-Antispam-PRVS: <SA1PR15MB4467F531B7C2FB13E9B3CDEBD5309@SA1PR15MB4467.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UZ2XnD10a2sBJ6mj9JunGL3qA6BlQYx/eD322OdNUzk/uzx2G98ILmMmYY7BC6iydjL9r9G9hFlYH3oJOSsCFKkIgFCvp+YwQHkGKXYTu9Rzzeuozp7MkYYcnDsZzdmrbmXy87pOTVI0V3oNkI+PG7yC5mGiPTrWayZgwRDzG0gSpodtntPH2zhI0KtvTO7Y8lfJffIpaey9pkOTIvP5neRYccDmwv7YZb6lNixMsk8dBwOdHVL9yFRzdLBEVBFYbtnv0hjFfjuoPb85gzJTYhOIC4vmt25Ut3YfdAk0kVXq93oS+OLtWVeARtt4a1hn0HvJLdIa6YVQURc6ekEBKcDJhFn3aO0qWv8iMWAXCVY1FYD2K1iIYvpIlumDwlfv2UpRkVO8wDj6IIpwWrAWWUbgDqhXy6jLIM4TdUm/mqhcPeKrLJeOjmHIAZoHS2Hj8aZEviDkRY2xtPdWIRb2sAH8YVnBhKdKE9BaU/aAFZE8kb3OnLPBIRCnm1p0AqwzAhTtxVTXH9jaKHUSvnJPEjRkn8wrZWjCoJeU03MiShNEVSvj2pu3zqsP4/DJRTLcPo1bCdw6NmF2AzEiQASn3RRUPMH5hzqOu45R99Sv3LE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(396003)(366004)(376002)(66476007)(66946007)(54906003)(66556008)(316002)(6916009)(478600001)(1076003)(86362001)(38100700002)(7416002)(33716001)(6666004)(186003)(16526019)(55016002)(8936002)(5660300002)(2906002)(83380400001)(6496006)(4326008)(9686003)(8676002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ziLNDOq7pH2aO2PTSTUTBkTDc/x9LS4LWlwBp0w5I2Q02EChyc8R4tmQ75HV?=
 =?us-ascii?Q?MXLFuat24/K+5xqoarFaiFTQJa8gwYHlf+VhMtPzhE4R0wzmrZQkfsGen+1C?=
 =?us-ascii?Q?vBa+XiCLO7tuvRSDKpMoYjSkkvyVWZ+tZe9ooroJe7r6J1fjBb/Cf2eQFIMY?=
 =?us-ascii?Q?fqC2+F+mKHJ455TVM5F+nOULW1sS9CHvQCCaeVHmjVSV/Uljv90R7n/9k2GG?=
 =?us-ascii?Q?9Qcs3vRIshKbt2pO+1dOtYMEIpehw7hP3gMfZRtCsuclN+ou67mdkAXqFRjz?=
 =?us-ascii?Q?qa/8lWdenTr30wMyB1BD93TXni1UhfLAXtjSFKr6fu3c/yRWMzSE4A1Ebqyo?=
 =?us-ascii?Q?Zqe7WDgc2AY5nP2wXMbvjXvKlItPux+/MSD7IMj/liU5PwDTNpntvBEHhNZz?=
 =?us-ascii?Q?EgxTzpmR4aJIWlWRPCUR0w697d867uS9UvIO5B8IhQTuyv0YwMAvV2OFCnIW?=
 =?us-ascii?Q?+LB1Xu1tHXwmBRjDPnHIkahDoed4plDT09BwMsEN01AxcgnNPxrufhKFuj1h?=
 =?us-ascii?Q?1tqRoCfW52k5zj8X8vHvhGCuRCYIUCURcBORSXI8TmCCayX2mu02RLh0KodG?=
 =?us-ascii?Q?rF3ylCJXZ1fBMmc5UlhJY97Z60EZ1ct3mROBnLK3A51h9Q0YUa5oFy7HztF2?=
 =?us-ascii?Q?caR07YsDTM+kpcArrHRZNEnZuU+DMRlW90OMAMfOlgZ2YMtGRzeDkgx/3EzS?=
 =?us-ascii?Q?obREb41cDwDKmpQNXU+pbBpO69nqbV+Fg+PHY1qUQoVDQGCQE0DJJ7UYegXq?=
 =?us-ascii?Q?EYeD7zt3TWsIHprymy7wjTHpy2PLth0R+U0Q6EsS5gsX4vSGStcyvcljwjQf?=
 =?us-ascii?Q?cURhHG77sAlWmMMI+vUFUhLcjuvH9jSO38cVIpaYrRomN0FEB/Nz3TUy8DdV?=
 =?us-ascii?Q?w1hEgzN1aVJgJ0VZhyB3idlJtDyHyWIhTSY7sy9kLGXxkLIJyLTKMzaCzm96?=
 =?us-ascii?Q?8EMf8O9QvACLaiE1wNz6ZoP/gABVg9ZTL5quRDLlxcZsRSsKCxJtZqNUmx8c?=
 =?us-ascii?Q?e8UiNUeUOcCPPhPy/aCRy0bfj6F8E1WgOCzdFhyRlrl0KNhEsS6uVRMaevpF?=
 =?us-ascii?Q?4cYftiNYBtE9d+AB4cJZdhs8JIFS3T7yIDt7zCyR3zqCsGA3QXtpHj6S9AWH?=
 =?us-ascii?Q?l+h1s4Zbaf2e57n8w9HtkuW9fs3k/3ck90tvioQaj22Qbb0T//xtD6pFWAZu?=
 =?us-ascii?Q?HddrwTz9ZLfWjnm8IcPkaCSgNdl8czmZ93nRE00uZkExeoEpX5TblUIUgtRA?=
 =?us-ascii?Q?NF92KyT6JyC+6iS4Hil+fGne/iVZHJ401tyTApz6cwpcwp1yfWb6edmtekeq?=
 =?us-ascii?Q?QvEOHtGn+oMZmm5Eapv8kQflTc6K1fCxu7+FCTpx9xm83w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ea02a463-df44-4558-dab0-08d9304c6d15
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 22:25:05.7772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7jclzptLGwyLiEHfHoOLEOTI77nhfym+mRdE3d0pktzOyODX03ECj8ir9qvj31hz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4467
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: STows_nHZjvBGp5ipBTFBg3jag2JneGD
X-Proofpoint-ORIG-GUID: STows_nHZjvBGp5ipBTFBg3jag2JneGD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-15_07:2021-06-15,2021-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106150137
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 08:10:58PM -0400, Tanner Love wrote:
> From: Tanner Love <tannerlove@google.com>
> 
> Amend the bpf flow dissector program type to be able to process
> virtio-net headers. Do this to enable bpf flow dissector programs to
> perform virtio-net header validation. The next patch in this series
> will add a flow dissection hook in virtio_net_hdr_to_skb and make use
> of this extended functionality. That commit message has more
> background on the use case.
> 
> Add two new members to struct bpf_flow_keys: a pointer to struct
> virtio_net_hdr, and vhdr_is_little_endian. The latter is required to
> inform the BPF program of the endianness of the virtio-net header
> fields, to handle the case of a version 1+ header on a big endian
> machine.
> 
> Changes
> v6:
>   - Move bpf_flow_dissector_btf_ids, check_flow_keys_access() to
>     filter.c
>   - Verify (off % size == 0) in check_flow_keys_access()
>   - Check bpf_flow_dissector_btf_ids[0] is nonzero in
>     check_flow_keys_access()
> v5:
>   - Use PTR_TO_BTF_ID_OR_NULL instead of defining new
>     PTR_TO_VNET_HDR_OR_NULL
>   - Make check_flow_keys_access() disallow writes to keys->vhdr
>   - Make check_flow_keys_access() check loading keys->vhdr is in
>     sizeof(__u64)
>   - Use BPF_REG_AX instead of BPF_REG_TMP as scratch reg
>   - Describe parameter vhdr_is_little_endian in __skb_flow_dissect
>     documentation
> v4:
>   - Add virtio_net_hdr pointer to struct bpf_flow_keys
>   - Add vhdr_is_little_endian to struct bpf_flow_keys
> v2:
>   - Describe parameter vhdr in __skb_flow_dissect documentation
> 
> Signed-off-by: Tanner Love <tannerlove@google.com>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> Reviewed-by: Petar Penkov <ppenkov@google.com>
> Reviewed-by: Stanislav Fomichev <sdf@google.com>
> ---
>  drivers/net/bonding/bond_main.c |  2 +-
>  include/linux/bpf.h             |  3 ++
>  include/linux/skbuff.h          | 35 ++++++++++++++++-----
>  include/uapi/linux/bpf.h        |  2 ++
>  kernel/bpf/verifier.c           | 35 ++++++++++++---------
>  net/bpf/test_run.c              |  2 +-
>  net/core/filter.c               | 56 +++++++++++++++++++++++++++++++++
>  net/core/flow_dissector.c       | 18 ++++++++---
>  tools/include/uapi/linux/bpf.h  |  2 ++
>  9 files changed, 127 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index eb79a9f05914..36993636d56d 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -3554,7 +3554,7 @@ static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb,
>  	case BOND_XMIT_POLICY_ENCAP34:
>  		memset(fk, 0, sizeof(*fk));
>  		return __skb_flow_dissect(NULL, skb, &flow_keys_bonding,
> -					  fk, NULL, 0, 0, 0, 0);
> +					  fk, NULL, 0, 0, 0, 0, NULL, false);
>  	default:
>  		break;
>  	}
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 9dc44ba97584..f08dee59b099 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1515,6 +1515,9 @@ static inline int bpf_map_attr_numa_node(const union bpf_attr *attr)
>  		attr->numa_node : NUMA_NO_NODE;
>  }
>  
> +int check_flow_keys_access(int off, int size, enum bpf_access_type t,
> +			   struct bpf_insn_access_aux *info);
Thanks for moving it!

1. It needs to be put under CONFIG_NET.  There is one earlier where
   bpf_sock_is_valid_access() also resides.
2. nit. Rename it to xyz_is_valid_access().  xyz probably is
   bpf_flow_keys here.

>  void skb_flow_dissect_meta(const struct sk_buff *skb,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 418b9b813d65..e1ac34548f9a 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -6017,6 +6017,8 @@ struct bpf_flow_keys {
>  	};
>  	__u32	flags;
>  	__be32	flow_label;
> +	__bpf_md_ptr(const struct virtio_net_hdr *, vhdr);
> +	__u8	vhdr_is_little_endian;
I am not familiar with virtio.  A question on the "vhdr_is_little_endian" field.
The commit message said
"to handle the case of a version 1+ header on a big endian machine".
iiuc, version 1+ is always in little endian?
Does it mean most cases are in little endian?
and at least will eventually be moved to version 1+?

I wonder if this field will eventually be useless (because of always
true) and can it be avoided from the uapi now.  The current uapi
fields (e.g. in bpf_sock) are always in one particular order.

If it is in big endian, can it be changed to little endian first
before calling the bpf prog?

>  };
>  
>  struct bpf_func_info {
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 331b170d9fcc..a037476954f5 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -22,6 +22,7 @@
>  #include <linux/error-injection.h>
>  #include <linux/bpf_lsm.h>
>  #include <linux/btf_ids.h>
> +#include <linux/virtio_net.h>
>  
>  #include "disasm.h"
>  
> @@ -3372,18 +3373,6 @@ static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off,
>  	return -EACCES;
>  }
>  
> -static int check_flow_keys_access(struct bpf_verifier_env *env, int off,
> -				  int size)
> -{
> -	if (size < 0 || off < 0 ||
> -	    (u64)off + size > sizeof(struct bpf_flow_keys)) {
> -		verbose(env, "invalid access to flow keys off=%d size=%d\n",
> -			off, size);
> -		return -EACCES;
> -	}
> -	return 0;
> -}
> -
>  static int check_sock_access(struct bpf_verifier_env *env, int insn_idx,
>  			     u32 regno, int off, int size,
>  			     enum bpf_access_type t)
> @@ -4210,6 +4199,8 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
>  		if (!err && t == BPF_READ && value_regno >= 0)
>  			mark_reg_unknown(env, regs, value_regno);
>  	} else if (reg->type == PTR_TO_FLOW_KEYS) {
> +		struct bpf_insn_access_aux info = {};
> +
>  		if (t == BPF_WRITE && value_regno >= 0 &&
>  		    is_pointer_value(env, value_regno)) {
>  			verbose(env, "R%d leaks addr into flow keys\n",
> @@ -4217,9 +4208,23 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
>  			return -EACCES;
>  		}
>  
> -		err = check_flow_keys_access(env, off, size);
> -		if (!err && t == BPF_READ && value_regno >= 0)
> -			mark_reg_unknown(env, regs, value_regno);
> +		err = check_flow_keys_access(off, size, t, &info);
> +		if (err) {
> +			verbose(env,
> +				"invalid access to flow keys off=%d size=%d\n",
> +				off, size);
> +		} else if (t == BPF_READ && value_regno >= 0) {
> +			if (off == offsetof(struct bpf_flow_keys, vhdr)) {
The logic below is very similar to the earlier PTR_TO_CTX case and
they can be refactored in the future.

It is better to check a generic PTR_TO_BTF_ID_OR_NULL value (and more on the
info.reg_type and info.btf later) instead of something specific to bpf_flow_keys
such that it will be easier to make sense with when refactoring with the
PTR_TO_CTX case in the future.  Something like:

			if (info.reg_type == PTR_TO_BTF_ID_OR_NULL) {
				mark_reg_known_zero(env, regs, value_regno);
				regs[value_regno].type = info.reg_type;
				regs[value_regno].btf = info.btf;
				regs[value_regno.btf_id = info.btf_id;
				regs[value_regno].id = ++env->id_gen;
			} else {
				mark_reg_unknown(env, regs, value_regno);
			}
> +				mark_reg_known_zero(env, regs, value_regno);
> +				regs[value_regno].type = PTR_TO_BTF_ID_OR_NULL;
> +				regs[value_regno].btf = btf_vmlinux;
> +				regs[value_regno].btf_id = info.btf_id;
> +				/* required for dropping or_null */
> +				regs[value_regno].id = ++env->id_gen;
> +			} else {
> +				mark_reg_unknown(env, regs, value_regno);
> +			}
> +		}
>  	} else if (type_is_sk_pointer(reg->type)) {
>  		if (t == BPF_WRITE) {
>  			verbose(env, "R%d cannot write into %s\n",
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index aa47af349ba8..a11c5ce99ccb 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -797,7 +797,7 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
>  	bpf_test_timer_enter(&t);
>  	do {
>  		retval = bpf_flow_dissect(prog, &ctx, eth->h_proto, ETH_HLEN,
> -					  size, flags);
> +					  size, flags, NULL, false);
>  	} while (bpf_test_timer_continue(&t, repeat, &ret, &duration));
>  	bpf_test_timer_leave(&t);
>  
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 239de1306de9..f5be14b947cd 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -8329,6 +8329,36 @@ static bool sk_msg_is_valid_access(int off, int size,
>  	return true;
>  }
>  
> +BTF_ID_LIST_SINGLE(bpf_flow_dissector_btf_ids, struct, virtio_net_hdr);
> +
> +int check_flow_keys_access(int off, int size, enum bpf_access_type t,
> +			   struct bpf_insn_access_aux *info)
> +{
> +	if (size < 0 || off < 0 ||
> +	    (u64)off + size > sizeof(struct bpf_flow_keys))
"size" must be > 0 here or the verifier should have already rejected it,
so "size < 0" can be removed.

sizeof() is not enough now.  There is end padding now beause of
the "__u8 vhdr_is_little_endian;".  It is a good chance
to repleace it with offsetofend(struct bpf_flow_keys, whatever_last_member).

> +		return -EACCES;
> +
> +	switch (off) {
> +	case bpf_ctx_range_ptr(struct bpf_flow_keys, vhdr):
> +		if (t == BPF_WRITE || off % size != 0 || size != sizeof(__u64))
> +			return -EACCES;
> +
> +		if (!bpf_flow_dissector_btf_ids[0])
> +			return -EINVAL;
> +
> +		info->btf_id = bpf_flow_dissector_btf_ids[0];
It is setting the info->btf_id.  Set the info->btf and info->reg_type
here also instead of having the caller to second guess.

		info->btf = btf_vmlinux;
		info->reg_type = PTR_TO_BTF_ID_OR_NULL;

others lgtm.

> +
> +		break;
> +	case offsetof(struct bpf_flow_keys, vhdr_is_little_endian):
> +		if (t == BPF_WRITE)
> +			return -EACCES;
> +
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
