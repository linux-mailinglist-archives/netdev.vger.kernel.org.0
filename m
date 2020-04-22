Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6325C1B45BA
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 15:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgDVNBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 09:01:24 -0400
Received: from mail-eopbgr80049.outbound.protection.outlook.com ([40.107.8.49]:41281
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726319AbgDVNBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 09:01:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZuhdm77HG17w0xB5yukvSrw0sZ3lADWwfExcp1QLL9OwHCXbasiYV8o/8W6VZE20DT1TlatgB1HINYcYjZ8ByIdpQoqdfGxOdd+BStYs1174/ICE4WFvrVFdejAlQ7yQVkB33A2R5znd5QcbCm+HDqyI50xyghVY+NUcW19JzMdDNwf+GH4U4+MLy83Rnbz/Aawaz2o2bzODL3DohpC8FOBK2qveORaMgokSr25+JdVA3IMNXX0mqHj9naEtZjNzpRCIlx7rE3AhifwIr2xItLe2mMwgXUZw+F+EMtvd7GjSzBgBWxYJW9x2X1PWmDQu5k6kPkGBMcILAY4cavV3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PqEu/TI6DfGWWOKTzaByD4MRvRD7WK4/jI+6QYe588w=;
 b=cW/pLbM5Laube+11NJHZv6mOR1cTpgE5yWOc8sLZ9vG2atyXsVSSIiyGAsL3Bch9msMI10+1taLQu+Iw05W9Ann9DyPXp16T+ZvV1gH9RPttIXtNqBSL4rMtFwio7Y/mjdY4yzwoIwgeTPYzzuBzegK2qogY0b9XrzNbqTXfXI7p4ETKpNwl+BKOlc3WOQhmfLCoOVXH6YodGPGk9aj8nh2gRSCE3dWZ0+830n0xNiYi2NdcV4UFaPfT+wMdzhzHFD80X/FBkNs59WhyCK9jMdltn7rv7l0fZT7TwJB0g6bEDEZWHq+uVF/d5A/HiiYVNPbsWzjHklfY1n6CYduhXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PqEu/TI6DfGWWOKTzaByD4MRvRD7WK4/jI+6QYe588w=;
 b=GvXkm4Xlk0Hu/6lwvZSZfFphchJ2BAW0FDbz0C62Hgpk5gDamRihxz9ye2m+NvmfoOlm4rUk0i8jj4HTrUJloaGma/EILI55e2wGiTEOd/b1prIidOqK71jwvyFPkX2Rbkui0SJOxYNp+gCccIcQe1+smt5o8D9WHnXsMnynYKE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB4191.eurprd05.prod.outlook.com (2603:10a6:803:48::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Wed, 22 Apr
 2020 13:01:19 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 13:01:19 +0000
Date:   Wed, 22 Apr 2020 10:01:15 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@kernel.org, leonro@mellanox.com,
        saeedm@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
Subject: Re: [PATCH V4 mlx5-next 11/15] RDMA/core: Get xmit slave for LAG
Message-ID: <20200422130115.GT11945@mellanox.com>
References: <20200422083951.17424-1-maorg@mellanox.com>
 <20200422083951.17424-12-maorg@mellanox.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422083951.17424-12-maorg@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR19CA0063.namprd19.prod.outlook.com
 (2603:10b6:208:19b::40) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR19CA0063.namprd19.prod.outlook.com (2603:10b6:208:19b::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 22 Apr 2020 13:01:19 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jRF07-0006T1-Qo; Wed, 22 Apr 2020 10:01:15 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cda7451e-c8d6-453e-6140-08d7e6bd3fdc
X-MS-TrafficTypeDiagnostic: VI1PR05MB4191:|VI1PR05MB4191:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB419123BF121E4063DD74E972CFD20@VI1PR05MB4191.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(8676002)(37006003)(316002)(26005)(186003)(66946007)(52116002)(6862004)(107886003)(1076003)(66476007)(478600001)(5660300002)(66556008)(2616005)(4326008)(81156014)(86362001)(2906002)(33656002)(36756003)(9746002)(6636002)(8936002)(9786002)(24400500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h1p67g3iLWXwmTt/c3iVqfcr3qkItK6pFWGU10upBTxwjyUQqjGcDHehc/vbmlgf7pADiHSPMqVbfAp/KN4wdqrPt7H7H83vsUraV67MsX+UsEiS+qp360MNgSt3uU6dleXDdCuA46/0Lr5n683oXydApZJkLPXFTLLRCAEYqhpei+ubeOfhlkdM6xL0ObJC+vaFADL76zDWMiRxhYC4TKOGKT1ZrmUlGuWKBOH+d14msa51cGh3Hh1Ej9KI5g0ezPJE7V7+3X6xgBf46nbf7LO1nq/IpLKCrd0qMY7MrTbMEg19fFNfXRj+PSdOFGDJFmEapKGds2u/kaGFGhjflbpbf7UmRnqNCX21fMqKOUtnvkIDh3ZWfiDkC/E3jcB9JYFz05rR0S6TB3eqttkxPxPfbIchQDXSz18iHfy4/ahZhDPBh9NUTbaSwakIWpZr+pq8ibcx/pV4af5ott77Jlvo3f24cpblrlAP692xAH+kBkSJsOx2B+TIQTMQxGEI
X-MS-Exchange-AntiSpam-MessageData: pUnx7mctPbnXgHEKyeWSRiqrzwV+P/A0os2caXP4/G+i58Uro1+C/77sR5hyNjf1Qns3FYNhtl3TSW9U1MzVUMWrjiHe4xu0IQiS+qy3sMqZCzY30ST4uAPdn8xhmVHZkybGxrbZAGnnGO86clqROw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cda7451e-c8d6-453e-6140-08d7e6bd3fdc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 13:01:19.5816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cJnN67uU41f7yiWWvXLeSfYAWFSXBZk9QMfxICl3AHFqONdvMqBuM8ZQPk4tZY2djgJ+WPTQ36fy3ubDzmYeHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4191
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 11:39:47AM +0300, Maor Gottlieb wrote:
> Add a call to rdma_lag_get_ah_roce_slave when
> Address handle is created.
> Low driver can use it to select the QP's affinity port.

Lower
 
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/core/verbs.c | 44 ++++++++++++++++++++++-----------
>  1 file changed, 30 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 56a71337112c..a0d60376ba6b 100644
> +++ b/drivers/infiniband/core/verbs.c
> @@ -50,6 +50,7 @@
>  #include <rdma/ib_cache.h>
>  #include <rdma/ib_addr.h>
>  #include <rdma/rw.h>
> +#include <rdma/lag.h>
>  
>  #include "core_priv.h"
>  #include <trace/events/rdma_core.h>
> @@ -554,8 +555,14 @@ struct ib_ah *rdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
>  	if (ret)
>  		return ERR_PTR(ret);
>  
> -	ah = _rdma_create_ah(pd, ah_attr, flags, NULL);
> +	ret = rdma_lag_get_ah_roce_slave(pd->device, ah_attr);
> +	if (ret) {
> +		rdma_unfill_sgid_attr(ah_attr, old_sgid_attr);
> +		return ERR_PTR(ret);
> +	}
>  
> +	ah = _rdma_create_ah(pd, ah_attr, flags, NULL);
> +	rdma_lag_put_ah_roce_slave(ah_attr);
>  	rdma_unfill_sgid_attr(ah_attr, old_sgid_attr);
>  	return ah;
>  }
> @@ -1638,6 +1645,25 @@ static int _ib_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
>  					  &old_sgid_attr_av);
>  		if (ret)
>  			return ret;
> +
> +		if (attr->ah_attr.type == RDMA_AH_ATTR_TYPE_ROCE &&
> +		    is_qp_type_connected(qp)) {
> +			/*
> +			 * If the user provided the qp_attr then we have to
> +			 * resolve it. Kerne users have to provide already

Kernel

> +			 * resolved rdma_ah_attr's.
> +			 */
> +			if (udata) {
> +				ret = ib_resolve_eth_dmac(qp->device,
> +							  &attr->ah_attr);
> +				if (ret)
> +					goto out_av;
> +			}
> +			ret = rdma_lag_get_ah_roce_slave(qp->device,
> +							 &attr->ah_attr);
> +			if (ret)
> +				goto out_av;
> +		}
>  	}
>  	if (attr_mask & IB_QP_ALT_PATH) {
>  		/*
> @@ -1664,18 +1690,6 @@ static int _ib_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
>  		}
>  	}
>  
> -	/*
> -	 * If the user provided the qp_attr then we have to resolve it. Kernel
> -	 * users have to provide already resolved rdma_ah_attr's
> -	 */
> -	if (udata && (attr_mask & IB_QP_AV) &&
> -	    attr->ah_attr.type == RDMA_AH_ATTR_TYPE_ROCE &&
> -	    is_qp_type_connected(qp)) {
> -		ret = ib_resolve_eth_dmac(qp->device, &attr->ah_attr);
> -		if (ret)
> -			goto out;
> -	}

Why did this need to move up?

> -
>  	if (rdma_ib_or_roce(qp->device, port)) {
>  		if (attr_mask & IB_QP_RQ_PSN && attr->rq_psn & ~0xffffff) {
>  			dev_warn(&qp->device->dev,
> @@ -1717,8 +1731,10 @@ static int _ib_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
>  	if (attr_mask & IB_QP_ALT_PATH)
>  		rdma_unfill_sgid_attr(&attr->alt_ah_attr, old_sgid_attr_alt_av);
>  out_av:
> -	if (attr_mask & IB_QP_AV)
> +	if (attr_mask & IB_QP_AV) {
> +		rdma_lag_put_ah_roce_slave(&attr->ah_attr);

This seems wwrong why doesn't rdma_unfill_sgid_attr do this?

Jason
