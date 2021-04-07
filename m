Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C9735701E
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbhDGPYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:24:17 -0400
Received: from mail-eopbgr770082.outbound.protection.outlook.com ([40.107.77.82]:42266
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235741AbhDGPYC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 11:24:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Om+2QrL3FcebXgkPk6JGnmJqNnBTyzXEUn39ByI+XPPY1gTHAGb7yG4HzR6jULoAXA2vHeWaazE/ulzUE3uhyMOwEpm/DJ7bFw+GityjPcidTbE3BlEmzgUKJmXcLEdNhIPiuf4qEmgOJXXr/pmENiXDZCihP5hBX6Qk+XSkikp2pZSgmegcyW2NM89r5nKvYuqBe6ie4ISoIVPHx02W4LpgvjcuK99xSoBlhDaJe0oxtziUrvZqwq5rF3z1P37IKZ+LBrYDfYfvWd+0FzpE9kGgfW/SdIg/MgxqCVSyGuP6yuIEOczaa07DN6kb6qAS8iufXIbwx1gwYxV2RGrJKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfG6lRkH5/r+lZDgjmyy/F6qRjxt4d6MRlxhUPqJzPg=;
 b=F00wTnDhnEr/0LxBgmyT5um/qexhJuWQD3bICJDSpN59U640BAjLMi80K3GnFU+HoC1MBJRjnOsi8VlyqWrFPmnatxd7LmGw6TKLa4pbe3NIBvUQm37t86gAX5MnihvyETdntjlU0nWqLDWlzkUIB0EAy++yvDyOfUIPPGqbBLxYj1Mni6HaiHmkxo6BIhWdUNpn6MnjIBdk6HmJuQ/3N0d0RXjY9Wdd3P+iiKXx39bv+iJwTMF/BRupLO4sqcL9Hh1khwa66AkFsppxz16QnNtuUbI39LmjKskJTFFFa1dy91hxMF4+pJ+154LtXL2n/X3g5L8+ZxMSsokB8aLNHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfG6lRkH5/r+lZDgjmyy/F6qRjxt4d6MRlxhUPqJzPg=;
 b=qGwaVtR6xGesRGeO9VIssp1YyP1YMZApIKpBWcfdhptoD7LOTBwSrtu3wpD6Iyu0XOHfS5+Q1vbGF0LvjsoVQZs2+hJnXzadYdp6ackUsqYj33CsicQ6lRL6XmpCrXSmwVvoy4vRHRrfojSHTwPlP3+8x/NvSNQxQnPBu2BtvSLs6hBgW0NdpnkpOmgOi5I4a2yXO4NqrD5iz6KoA9Uk4b/5HiXgQaIJ99IrXrlBRSzRafVluAVBX8S7kM9rtCtspMihvM2bRHBypyo2BEvSKCyVN8s9NoVM8hGugMR49OIT3DuydIQCWSIHZnn7YYaTIpbmwSmIOjwhh6jvAFECNQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1882.namprd12.prod.outlook.com (2603:10b6:3:112::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Wed, 7 Apr
 2021 15:23:50 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 15:23:50 +0000
Date:   Wed, 7 Apr 2021 12:23:49 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     dledford@redhat.com, kuba@kernel.org, davem@davemloft.net,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH v4 resend 21/23] RDMA/irdma: Add ABI definitions
Message-ID: <20210407152349.GA502118@nvidia.com>
References: <20210407001502.1890-1-shiraz.saleem@intel.com>
 <20210407001502.1890-22-shiraz.saleem@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407001502.1890-22-shiraz.saleem@intel.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR15CA0064.namprd15.prod.outlook.com
 (2603:10b6:208:237::33) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR15CA0064.namprd15.prod.outlook.com (2603:10b6:208:237::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Wed, 7 Apr 2021 15:23:50 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lUA21-0026kO-B4; Wed, 07 Apr 2021 12:23:49 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17a7349d-199c-449e-6c92-08d8f9d92575
X-MS-TrafficTypeDiagnostic: DM5PR12MB1882:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1882FDDA56B68515A1A5C8B7C2759@DM5PR12MB1882.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yY6h7uzTlHRmRFSslIYcUTw1l8I/EdOQhOBTh18IfRw/Iy+IBylE1ZDsMZ3UivzYCA8LSv67nNnKBswgt74zLrKlmEK1xCesVKvDzoHKrN46fFbVVQd7UAgfeezI/7uGR1aPNzmTbqd6OLVud4nbhzCiHiPFVcZnTFG5wmNzME+JbS/1+B4enjLmu5cbYeIspOT3MLteYGKkTsfi61+JwGUYsZb0jRPcpCoLLtzNgGh+1A8OTf3N1ZRNcp2KXqXNsComAd1tXhLjvuwfq0w8cZLHaAjy06qvYL2zW2z0ngYyreLPz63s0Wp2SBfNdB3pg62Sjf6hmbzcEKmgFknSdHYHQLMPhnE4ijZzIcEgb4LBZ/VHPch6dZ3S07qft7qdq204ObC3xzxZKI4FIGCVOxuiLd81PL+VpD3LwFBY8Clu0dAD3K77ssdq0riEzH2wxDHuj4QwyGQjn5jTdUFupPLmH5kN+bdl84nDpnBfEV7oJDVaedLeQPGRKuNRybm/wAL4twNMWgfdsxH0ImAxK0aheNDO9zzCIioC0tr2w0qPtg8+AtDCAP8FdrofNOKJbC46LYlUiphykQ3TqtIavKIYW2/jinf2Ya8vBXw2jhXvYkufzRfDpDFv44BoLDXUns6p1suDV2rJQRDuq5UmiG0sBfr8Ztei42IaaljG6X+wE88egzpMYTMQoAbGTMVv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(2906002)(9746002)(66946007)(66556008)(66476007)(5660300002)(26005)(316002)(4326008)(86362001)(2616005)(8676002)(33656002)(478600001)(8936002)(9786002)(1076003)(426003)(66574015)(6916009)(38100700001)(36756003)(186003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mKENRWT53MBAsrkVQ32KkN5Mo9YuJuiZ2bNtFx6JBYy0AA0SxZ5e3pQm9JMl?=
 =?us-ascii?Q?MNnFqTf8PK/KuH0ot0U3EegFGXGTgEdM+T6k1oreW2Uik8MOCp3AGCkPUL2O?=
 =?us-ascii?Q?+3wZoIbEfjG126/LD7US7zEv9KWH4CDmFn7LgrusMY84WztNa4DJW8UdrZfk?=
 =?us-ascii?Q?Caey5jfOdf4SoVKMvmNeHzlE9Rvm3SvBqSqlt4EggTmSg5jgUHTLMyXncT0x?=
 =?us-ascii?Q?qzr3AV5WwVQcZimFYnZDMRvWpFpBh6bCwz73gBx3vtssp49nuHqElYJFXaHj?=
 =?us-ascii?Q?03nQh8CEjsvxvIfWF6THe5yhAoRDIVdCwy5JQtg94xeBgC8bMBHfAnzM4FK8?=
 =?us-ascii?Q?PEvzfqsekXOFlMtKzY5wh8MQRbC2XCsmClIf8IKZZLN3lrF27w8v3taiLG4b?=
 =?us-ascii?Q?1tmWQ9YvKu4IQnzENzlTdMcZ2MUAkiAHdbAFXMWgMpiet63S9+3n0K0Fb2KQ?=
 =?us-ascii?Q?Nym+XWJ4gknIzsoMLmyuu10pOimEsjq1H04jOoGaOJjI1vcgE+VXZzuvMIwg?=
 =?us-ascii?Q?5Vgb03tqZIZsOclOMafttlSqLjFEIDsuo3RndtBBg5hy72JO+gMnuq0wWqm5?=
 =?us-ascii?Q?+ZhM0QKRcX8Aj1DbgATTdQzMVyI08j249pJyyWdNjOrv2KiyPoc94m8AXsVj?=
 =?us-ascii?Q?JsUvL5Ccnsj/DqLT0iuNYUVptY6W9Omw5ZVnZkAKneE8Y0dLaJV18XXg4VRc?=
 =?us-ascii?Q?/blIeez+J0vs33q8jdF3Ch0+ajMgr98kQuwBjMfI+OGURZHQRZaRSoPxo8E8?=
 =?us-ascii?Q?B1AP9Aby3fEDrD4JlgP4IWFIi3BJ7CoemHcHFO6gqaNQUbu9EOH+u/D45GsS?=
 =?us-ascii?Q?FZR9LnSHA93AyTRIB+NEtv4VI+AVdNs/9D7C0KPeCSGPFovfhuu9bGjHVXmy?=
 =?us-ascii?Q?JXRKsG1f7EQB4p9Y0hd809g3WZvA41AoZfbvBxAySaGFz2mofR+g97Kk8F1Q?=
 =?us-ascii?Q?Ih35urz7EGkS9cNdTYJi1KPf/teLTpxVZMHdlAPTWFoyowTeAZ639e5tGBlK?=
 =?us-ascii?Q?qPPG0r2XpZ14ADW9mCyP2dtYHx55aeqSz/2SuBLsdhGb10uOtxKjI/ZfX34h?=
 =?us-ascii?Q?JDny6sTb6yAR1UTaFnKixLA6pFL9TEipUy7FDMjWgvc/cFyvQSERh+eKxBrd?=
 =?us-ascii?Q?JZPzoKaD9c/ri5ro0rR9lTOASFPueIOMbU2YguYtIkN2xh4j4OLCYvbHMwEl?=
 =?us-ascii?Q?3UKEFy/tbcMDnq/dhNdERFhC3+eMj8gAG5TrwK5oeWzVMl7j7IPOyEfxVTpH?=
 =?us-ascii?Q?TTpMwlC0wbJnOetDTUxG3RYR37pOFvHWUBN0MU6QXlBJ7YMACldcNXZOYifs?=
 =?us-ascii?Q?mnL7/GYt79F5aMeIwaDo5FKZsJ7ZsMYCaWnnndO8Ot12hg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17a7349d-199c-449e-6c92-08d8f9d92575
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 15:23:50.6336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AQeav2yFN5/2CsFbATnzu+/khfq5ZFNieqsbEOfBLgNDHTk14wPQSG7K+yTdaaAw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1882
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 07:15:00PM -0500, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
> 
> Add ABI definitions for irdma.
> 
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
>  include/uapi/rdma/irdma-abi.h | 116 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 116 insertions(+)
>  create mode 100644 include/uapi/rdma/irdma-abi.h
> 
> diff --git a/include/uapi/rdma/irdma-abi.h b/include/uapi/rdma/irdma-abi.h
> new file mode 100644
> index 0000000..d994b0b
> +++ b/include/uapi/rdma/irdma-abi.h
> @@ -0,0 +1,116 @@
> +/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
> +/*
> + * Copyright (c) 2006 - 2021 Intel Corporation.  All rights reserved.
> + * Copyright (c) 2005 Topspin Communications.  All rights reserved.
> + * Copyright (c) 2005 Cisco Systems.  All rights reserved.
> + * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
> + */
> +
> +#ifndef IRDMA_ABI_H
> +#define IRDMA_ABI_H
> +
> +#include <linux/types.h>
> +
> +/* irdma must support legacy GEN_1 i40iw kernel
> + * and user-space whose last ABI ver is 5
> + */
> +#define IRDMA_ABI_VER 5
> +
> +enum irdma_memreg_type {
> +	IW_MEMREG_TYPE_MEM  = 0,
> +	IW_MEMREG_TYPE_QP   = 1,
> +	IW_MEMREG_TYPE_CQ   = 2,
> +	IW_MEMREG_TYPE_RSVD = 3,
> +	IW_MEMREG_TYPE_MW   = 4,
> +};
> +
> +struct irdma_alloc_ucontext_req {
> +	__u32 rsvd32;
> +	__u8 userspace_ver;
> +	__u8 rsvd8[3];
> +};
> +
> +struct irdma_alloc_ucontext_resp {
> +	__u32 max_pds;
> +	__u32 max_qps;
> +	__u32 wq_size; /* size of the WQs (SQ+RQ) in the mmaped area */
> +	__u8 kernel_ver;
> +	__u8 rsvd[3];

So this reserved is to align and for compat with i40iw

> +	__aligned_u64 feature_flags;
> +	__aligned_u64 db_mmap_key;
> +	__u32 max_hw_wq_frags;
> +	__u32 max_hw_read_sges;
> +	__u32 max_hw_inline;
> +	__u32 max_hw_rq_quanta;
> +	__u32 max_hw_wq_quanta;
> +	__u32 min_hw_cq_size;
> +	__u32 max_hw_cq_size;
> +	__u32 rsvd1[7];

But what is this for?

> +	__u16 max_hw_sq_chunk;
> +	__u16 rsvd2[11];

And this?

Reserved should only be used for alignment reasons.

You saw the other explosive thread with Intel about this topic, right?

> +struct irdma_mem_reg_req {
> +	__u16 reg_type; /* Memory, QP or CQ */

Comment is better to clarify this is an enum irdma_memreg_type,
especially since it seems to be wrong?

Why is that enum prefixed with IW_?

Jason
