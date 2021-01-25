Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7111E302D14
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 21:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732417AbhAYU4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 15:56:05 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3827 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732131AbhAYTsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 14:48:22 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600f1fd50001>; Mon, 25 Jan 2021 11:45:25 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 19:45:23 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 19:45:19 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 19:45:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQPLTdyWHSzksYRqWwOjsd+xKEWuWcCW0apshzrRliDj8+vxxizk7eWnSoMiDrRIH0QfhoPRzieacINrY9syyfddVKU3XKbX75xZHhRQVRo09XXnsIjfZ8iJ1YLYQ13ouW6y6VTegCSLPATxa0mD6fVGxV1NO876sVdbS2JbLvdERPo+99DUNbugPhTnV9aBz1SOnDksLVbAmyTg+xe7VdbdhMrjFPR81shOvyDH1iuWg1Q7bJTOZvRc7uPpkABOibC40fTK0cpEk6KhNy2r2e3heTRZUp6n9Nt0O1vAiG+DlntlyyCGbtrmwYs5FeBJUtRTx+YxjiUczjd/b9xJ1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MkpTbzUWS8J8UQtQtCfDPIcVvDeh+1kenQ7wU+DdsF8=;
 b=fO/m1QD1ciKZG/RUraE797xTsUh/f6sV8QvAnsKZHeLmqIF3w2JYnsHJKWZEfgHBQZPZ9OXI6rTE3EIbxehyisHbkdXyJOghwjz5g0MDJbtklwaWLz0AWErmcjkRvY5ZJAhP6W3dZm45eK+biudjAiaulKe1lT+NxK4CXBcPvZ1NhxE676dQNWER5qDXeYw8Bc+wsKlqbc4UGdko4OEk/XOvAyCIC+eSz+CMKVPtaGS5bYFrRU3GdddV57YPdLCQscgl7F6EiWAebwwAMShG1uwdd54K8TVCm+XAREVuAjcJo7KswNV/vulQTrnYeyeGOBZYAvsbkMoVQQ4KzlUV4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4402.namprd12.prod.outlook.com (2603:10b6:5:2a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Mon, 25 Jan
 2021 19:45:17 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 19:45:17 +0000
Date:   Mon, 25 Jan 2021 15:45:15 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
CC:     <dledford@redhat.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <linux-rdma@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <netdev@vger.kernel.org>, <david.m.ertman@intel.com>,
        <anthony.l.nguyen@intel.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH 20/22] RDMA/irdma: Add ABI definitions
Message-ID: <20210125194515.GY4147@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-21-shiraz.saleem@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210122234827.1353-21-shiraz.saleem@intel.com>
X-ClientProxiedBy: MN2PR13CA0023.namprd13.prod.outlook.com
 (2603:10b6:208:160::36) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR13CA0023.namprd13.prod.outlook.com (2603:10b6:208:160::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.7 via Frontend Transport; Mon, 25 Jan 2021 19:45:16 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l47nX-006ih8-VR; Mon, 25 Jan 2021 15:45:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611603925; bh=MkpTbzUWS8J8UQtQtCfDPIcVvDeh+1kenQ7wU+DdsF8=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=oDWuyoM3JTO90pYM2j0uPgQT1KUraYMb0prdjnYH5ZgBpzGBrKXSa+NbAMiwLaYPs
         qblbsq18OYE5xTbo/I0sKFzaWDKA0VaaYxBY+/cnJS09vqk4n27hT3Ksz9EC5cESqI
         VEHMlRBgsVAdchxJkak6XsrKHRksbSV+qHEcEWdk6JrmXUPPoLkpeDBVCd5RQuM+z6
         n9iJR7Eybc1UuOhs1HggyBsEYPUquyjoK32TrPpbUCcQohGA8v43QcpfhXVqJPux9d
         DxskUMHxZdHuZHxOqDR3SBAYuuVF964ZfESygPmJIxFlacPsCe9+JrnUiqGuFaKFS7
         SK7eIN1VuklaQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 05:48:25PM -0600, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
> 
> Add ABI definitions for irdma.
> 
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
>  include/uapi/rdma/irdma-abi.h | 140 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 140 insertions(+)
>  create mode 100644 include/uapi/rdma/irdma-abi.h
> 
> diff --git a/include/uapi/rdma/irdma-abi.h b/include/uapi/rdma/irdma-abi.h
> new file mode 100644
> index 0000000..d9c8ce1
> +++ b/include/uapi/rdma/irdma-abi.h
> @@ -0,0 +1,140 @@
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
> +#define IRDMA_ABI_VER 6

I don't want to see this value increase, either this is ABI compatible
with i40iw or it is not and should be a new driver_id.

This should have a small diff against include/uapi/rdma/i40iw-abi.h
that is obviously compatible

> +struct irdma_create_qp_resp {
> +	__u32 qp_id;
> +	__u32 actual_sq_size;
> +	__u32 actual_rq_size;
> +	__u32 irdma_drv_opt;
> +	__u32 qp_caps;
> +	__u16 rsvd1;
> +	__u8 lsmm;
> +	__u8 rsvd2;
> +};

> +struct i40iw_create_qp_resp {
> +	__u32 qp_id;
> +	__u32 actual_sq_size;
> +	__u32 actual_rq_size;
> +	__u32 i40iw_drv_opt;
> +	__u16 push_idx;
> +	__u8 lsmm;
> +	__u8 rsvd;
> +};

For instance these are almost the same, why put qp_caps in the middle?
Add it to the end so the whole thing is properly compatible with a
single structure.

Jason
