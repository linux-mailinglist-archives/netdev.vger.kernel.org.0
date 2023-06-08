Return-Path: <netdev+bounces-9217-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F15FC728004
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 14:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A38A32816E8
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E2F19460;
	Thu,  8 Jun 2023 12:30:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB3412B73
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 12:30:24 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2096.outbound.protection.outlook.com [40.107.101.96])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E99E62;
	Thu,  8 Jun 2023 05:30:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H61fSCKrJ9UvQR+jEWFPZby/83Z89uOTC+JMO/mR38rzICnmLhu4iV1Ov5Ijd1cS0lF/yEnilga4E0rxH3cKI8PiMJ2Ci+3liIv1xE9Z4Fh3ik3TR5fiE8f5mZgLsDOjt+KQ8CYpWq77bQnDUd0jz2SCmNPOZyCFg1zmbIATpImmtn08GU5rquCFfMa4dODslLAiKrt64P1RWNGSz8N47JrF/0/z8zh/0A6C/1Y1pWwtRRxNBrlyeIrVRFBNVhEBY07n45OHbMQZDj1k1r8KQ81ksNB71XZQMvAyQK7QvuGq/anLKq23SVc0PiVymxkCfh5pfGrGQ5AfaI6Lj+fdBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=43FwK1BCdDBrNv1SgOsKy96ExJFo+k+52Wzn8S5Pyqk=;
 b=cwN3Nq0kvsIR4XeWug8z8IGOML6n21UgBbTmeg1pa/sbEVSx6+vVJqvevNVf0CxnlBVxPzzJ978sOHfPuU6AyuyIQsey/TCgiut6uRXJpXdy78/REQJIeVX32+6thJeTBsW2Amgxolewt7C2xI6rp2xEvqmNOVkvOjxCeYmiwWi4orVZljzcOBncUGAypIL5kFqsDF0TaKmb6vS9N3DLKY1PBG++NGG9sMFB48afnoHjOuRlQBvgD+fey6dtAq/mSIynD3xI3CB+/idwJsUChJQldbGxr/PGb/UrMx90yjTokp/6NCO7UDJw2/4hO4+u4NnivAMtNRmOtMvCLd/hOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43FwK1BCdDBrNv1SgOsKy96ExJFo+k+52Wzn8S5Pyqk=;
 b=dKaYuF/uFbkI3ZMTN8QAXKWHHnbiuetg+oHSqVL4iU1MlrBq8DvkXAWz/0V6fJpm7Hf1ElZBeCPmwqZoRp6MFzyuGJkjiEq468dANA1SYtdzphBQJ/zL/EGzh8pHW6ZnqSxUUi+BeqFADrVY2qgNl4EKOVUWv4TDMSuzKNpN8Wg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5209.namprd13.prod.outlook.com (2603:10b6:208:340::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 12:30:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 12:30:17 +0000
Date: Thu, 8 Jun 2023 14:30:10 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Yang Li <yang.lee@linux.alibaba.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, kys@microsoft.com, haiyangz@microsoft.com,
	wei.liu@kernel.org, decui@microsoft.com,
	linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] net: hv_netvsc: Remove duplicated include in
 rndis_filter.c
Message-ID: <ZIHJ0pxnv63jGkuW@corigine.com>
References: <20230608080316.84203-1-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608080316.84203-1-yang.lee@linux.alibaba.com>
X-ClientProxiedBy: AS4P191CA0024.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5209:EE_
X-MS-Office365-Filtering-Correlation-Id: 1231e974-f3ec-47e1-2881-08db681c1db1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1LyqXVzU3K21tlvbe+/CXRXtwGm/NDC0r4nURT5kmD0BWtwy/uQirpFX0MxdPaLQRIzuNNazo0ABpSqfp8NTjyT+8HOX95hCoUE/WVn5CoccoQU43PmNi+q8JT1r7R8gUDrapD3LtNOs/3U48tXLHNLer2OygTYDK1Ud3l2UQLX6C26QbYAsAnU7+G+evNW76k3xOHj84L0POYw1sgV8nsRDTGhKkWF27pYA7MScOcJa/MwN6hBJs85sE99hdV3C1aCXNfk4yqjFLg1hr2VeD7F0fSgUYK6X6oVTYjtmR+FCckx/+jdTd3Aubub81s9uzku9o5YsxC4KDOWYYelWV1rbNXLjta870FogJ/E9TuMBcH2uR0+Sgbs+5c+zPZlTo7jdftWDsg0a9l8ds7f0u9YhQfqIfUYaoXSMPMgv/vhl1o5MLCD6p2ZDSzXHMbj4OcOM+FjCnsJrYUnTq9XFlyE15EvuVhGyFVScBs/hGy5yYtC/1vbWb5ew1lGvM5jE97Fafg7y/Ca32BOuIkOLoYEWTysHd3WyVdcw3OkQJdQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(39840400004)(346002)(376002)(451199021)(966005)(6512007)(2616005)(6666004)(6506007)(478600001)(186003)(6486002)(83380400001)(66476007)(66946007)(4326008)(6916009)(66556008)(316002)(38100700002)(8676002)(8936002)(44832011)(5660300002)(7416002)(2906002)(41300700001)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sw4tA6th8gdGxLho9BhMA8w+IgbZ6eoAUbqA49YrLxfO3//2+wpwNO1nRmaM?=
 =?us-ascii?Q?taagZI76IVcecTPTfKr6zVh0+SghBhengHfzTcMvpPlOgtgMsjwcS441Oo8b?=
 =?us-ascii?Q?5xGZ7vv6kVIXukmq+dOCUewB86tv5EeeRCR/N+BmR7IwMb9C7PKdYhTA5C9M?=
 =?us-ascii?Q?88sHHV6jt0h4llUte8/LLtyGlvqNKqQRfeSvb9y+8+dFbhNrCzUF4Ot52jJA?=
 =?us-ascii?Q?yUTP381/xhH1A6Ygyktt6+BixFvr3xAGqy14h6fzcjNyLMoyGh8RR1WhM8ny?=
 =?us-ascii?Q?UOuxJo1nwsRnIlqG5MH1YvXi4MwylOqv9esbU6iBUlmz+j+Ph+LF1iwGq702?=
 =?us-ascii?Q?wTBuQVwgagHXcdUZQnSfB9DF5Oe93dWXQ+NUkGfMjbAJ3fXWBAWdcm6UD7Jq?=
 =?us-ascii?Q?InPekm0ljX+ks9touPh9cbPGG4ZVSPiFqBCHZX52oDwYSJ/SckMVpFNqXgm5?=
 =?us-ascii?Q?+gIFeaoxTnFVsSq4MqfwhLLH/4BSU9Io0iATHB/e+5yAqMLyt1vH84UspThz?=
 =?us-ascii?Q?Z7VnIMdaqdLOk+yzYkIlaYIoORjlLlgKatvnzGePaa1HtYkFZCkAhP+6g+XX?=
 =?us-ascii?Q?R4N90Kma1ufaiQfMiHtYRnwYh0X2F3z6MV9P4aH50kEZeSFddMxmcuXhkogm?=
 =?us-ascii?Q?uW2cpLrxlfvDUrJmkdfTCv2ocN41mdrH+pPo9ENI6NrQ0sDcdAuZ/9r0ClmY?=
 =?us-ascii?Q?nnWIwVHUPxDwmT6gk2rsUjP5ccc2PTggcauC79m7jYF9R9x7Il5Wy7xG2Zn7?=
 =?us-ascii?Q?gZQBtGOuATmpz554Vk5xuOVEKk8VbuvSy57xmNmlS67SSTFQt4WjFHLg3tqt?=
 =?us-ascii?Q?pZ8cjiUuFbo4A6p9pqgPBrCqvY1G1XsPeQ/f5QGgj12fJQBhbiTMlWL4kjTL?=
 =?us-ascii?Q?+Y6c155cGtyfbxFN1/wzAgExsSRZyQwb/CiprfWSTgpu4HDR4RI4q09Xn36B?=
 =?us-ascii?Q?7KvroHGpPzssy8l7mTCzz/xbDoOxrg1wO+aQLPkT+3SVFGfvN7MnDdi2G0vs?=
 =?us-ascii?Q?VXV2DjXDMX5eUyDwc1Ai1JoF2duK0bbU9vc6Ug3KS5rY6UG4rW1eKIOtTxcb?=
 =?us-ascii?Q?aQrYFcNtFLsWDXmOoJ1XYjWNFNelU+moYZDGC+BcLTXgo4q+pr0W3i1oW6lq?=
 =?us-ascii?Q?UjSVs3PzLDRAvI+8S8T8jns9zzoFeunqCm/K4KyH5qZkQ6i0R0fhFFuw0JLS?=
 =?us-ascii?Q?ZM1cLz1xZYYPLhzSgIWZtnWb8v+hiCQyak0ggpnosDVwpLBGbslbGA0HssR0?=
 =?us-ascii?Q?9yp6Vo7ny0AeW6QOuMo1DhUTvRWGokJEj4OZ0lRvh7dml3KcUeDmiQtprroS?=
 =?us-ascii?Q?FHZMcfCFZgBwXQ19Bbr8+8/y2eejEHEspR1GNLMKQVNtdb7Vn5MTwcZ9UUmz?=
 =?us-ascii?Q?xgoKS3UByRHOuAKIRK2vsYiQ+3rPS4rEob5Elye4zsZ+slqru8xrZhHRFRVD?=
 =?us-ascii?Q?egJRsgyo6kPBbFqC4Anm7lZdqoQIL4bWTNTqWA9KB0dsyf5Dnieuk8uT5ER3?=
 =?us-ascii?Q?o7o+59KDdbzVbVLY18RvcTYs6qJ3bbr54DQdiCcDhGORtt7x3Xf0qw1EAkoA?=
 =?us-ascii?Q?TQ96HPb5XPORh/gsem5s8TiTIcZiHoufDqnt1fnpwTwSSuMl1BjJ3q87VQRz?=
 =?us-ascii?Q?KraM7y9/3nsfvKkrxNT9uyfVdmnZ4KuNDeN+738AjUq06DLfhq05W5Tssib5?=
 =?us-ascii?Q?VQcZeQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1231e974-f3ec-47e1-2881-08db681c1db1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 12:30:17.1154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EgLW48DTnoOA9U40tG8ze3MBJlrKhLrUwnYJ1a8DeZazhzUz8PJIdp2AEytW8HQ0oWGXXt1rUxYUHzgKy15aXqw7oMrnZlFiAGjPP1dXXNc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5209
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 04:03:16PM +0800, Yang Li wrote:
> ./drivers/net/hyperv/rndis_filter.c: linux/slab.h is included more than once.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5462
> Fixes: 4cab498f33f7 ("hv_netvsc: Allocate rx indirection table size dynamically")
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Hi Yang Li,

A few nits from my side;

1. The subject should include the target tree, in this case net-next.

	[PATCH net-next] ...

2. I don't think this needs a fixes tag: nothing was broken

I'm not sure this warrants a v2.
If you do decide to post a v2, please allow for 24h since
v1 was posted.

Link: https://kernel.org/doc/html/v6.3/process/maintainer-netdev.html

Lastly, I think at least one other similar change has been posted recently.
Please consider batching up such changes, say in groups of 10 patches,
and posting them as a patch-set.


The change itself seems fine to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/hyperv/rndis_filter.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
> index af95947a87c5..ecc2128ca9b7 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -21,7 +21,6 @@
>  #include <linux/rtnetlink.h>
>  #include <linux/ucs2_string.h>
>  #include <linux/string.h>
> -#include <linux/slab.h>
>  
>  #include "hyperv_net.h"
>  #include "netvsc_trace.h"
> -- 
> 2.20.1.7.g153144c
> 
> 

