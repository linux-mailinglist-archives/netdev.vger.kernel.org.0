Return-Path: <netdev+bounces-963-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F315E6FB7C7
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 21:53:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C31181C20A27
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:53:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4121F111B8;
	Mon,  8 May 2023 19:53:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA55AD43
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 19:53:49 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20722.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::722])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB0572AA
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 12:53:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZYiAIZoLXRuoUaE8qhWLC359M9uktvpVt5egvGqviHpB6j8zmq1pwGm1G9qCfMmAC2mrLLn3GjW5+nSXKkYJKCOejatsPh6QG4/nBEYP2RG3kne5SA4kNEsVwpsEi7Qsi8Whd76cN3XuIWd+FEjLlZJ/FdGMDtOuFitZwWkp6t6ZWFmGpyHr/vzhUOzEuFI+erS6ZYO8UQboKr7aToyNrjz+LrjKx+LuJtlFxRO4KiWJd1g/nHiBmrq8Nb4ThEozzXFJD3F3Sa2mo4QRw5RBwwyqalApNVS51brRuVt7tlIqFOgydpyfarRHEyTOiEMpkEpJK+S/HXgkaZb5jWPA7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Opu22bbZErnqpLa+sb6X9svrjlOF6t4taRhSJHmxO3c=;
 b=DrVLY5sy0gqsrAS5Zyg3jGR58OGM1lyx2BD+EXkA+GN1D7kRRBoMWfz8vZS4XgiAyHSj/+6nNWvw1mYwL0rDS4IlHnekHN/2O2XXZtszv2JYoMqvQYUkx7PU50urCzFPcdCL9FexNWlzroSej+6KtguXqv7q1VSSVx4Qr+cI1f8GYOa7oh31ZCVfEp7QQKW3FicFNGR8/Ml1VLM+LT+NExV+kIQ7Vqb5kRQZIa8+7i/3Pa8a6Yod2I1Rnd4TuxZL4c+/9ZSD0pnBwXuQe8jAW2p7J7QbbQB0G5PGOSPdmTNbOS2jQPtFv5LZMmgKpXh015YZk5N0IhSpWC+XLJwtzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Opu22bbZErnqpLa+sb6X9svrjlOF6t4taRhSJHmxO3c=;
 b=ZrIupAj0qMpHZNkMuQFLEd67uuUObJNg+bhYpSkGu+j6rBAN+sqe4/8ZsCXTlDz/YEgbrqOZQdghhjh4+Rf/DOfVm7S2cqcHZ69Sjha2DvLRu4chO7heG10mrJyxUQJT39V+EjSQW1DXEEzGzPtiOK2w9Rz8eDyP2OjF3DJE7J0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by SN4PR13MB5811.namprd13.prod.outlook.com (2603:10b6:806:21b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 19:51:37 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7%7]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 19:51:36 +0000
Date: Mon, 8 May 2023 21:51:28 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Piotr Raczynski <piotr.raczynski@intel.com>
Cc: intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
	michal.swiatkowski@intel.com, shiraz.saleem@intel.com,
	jacob.e.keller@intel.com, sridhar.samudrala@intel.com,
	jesse.brandeburg@intel.com, aleksander.lobakin@intel.com,
	lukasz.czapnik@intel.com,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: Re: [PATCH net-next v4 6/8] ice: add individual interrupt allocation
Message-ID: <ZFlSwEyiMXMK8uxz@corigine.com>
References: <20230508124321.2927867-1-piotr.raczynski@intel.com>
 <20230508124321.2927867-7-piotr.raczynski@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508124321.2927867-7-piotr.raczynski@intel.com>
X-ClientProxiedBy: AM4PR0902CA0004.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::14) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|SN4PR13MB5811:EE_
X-MS-Office365-Filtering-Correlation-Id: 550bad57-28ae-42ef-3995-08db4ffda1ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	FMmtwQ0gLKgdiMKoV9ptCDRBXkXR97554Eyc9+YSgz7OAdHCqZQcgXhwj8em25T5rgebHl+3AUsjvbQ6aNnCVJYXOx0W19aLx+99sSc/JYjF9bUyg+rR5NChhXxDgrN9+nIrSLIH5T2M0gqKy6EoNp4PhbAJgeZjK/Z+IjB5rq78Fc0PnMyj6nB6jlQsAk/NSZmPGUUmPXt0ExwjkQmYKb2CCsdltbcBX0NtRmC2a279g8HO1R60o4sZXxVHK12I+fniiye8qobOadnkt4BfZGFNuAN/+XkbdGcTxX3z7aGES4co8cHCzWTappNtzPo9E7PvRV6TTqFG3a7b2oI+TnB1NRZjiSqr/YiSS4j09TISk4AIAhhhTTUM+wo8G2BJfJQ5NL9sKDIZx8vk21to4frstiaNVh9Y5VSiSKkrkIcPypgOEa0sHAPI9HtJRRxyMO9Bd0M77o88ll0pg5UXzI5gxoke00af9LUO71H4lJpkBb2olhA7wxBgiPO079LJ1SsA0OvqBBzszEc93S7Gn10O3YwnrGpn4Xm20cRziN8FJt6WTMjw0Q7dI2T6Tihb
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(396003)(346002)(39840400004)(451199021)(66946007)(66556008)(66476007)(6916009)(4326008)(478600001)(6486002)(316002)(54906003)(86362001)(36756003)(83380400001)(6506007)(6512007)(6666004)(2616005)(186003)(7416002)(41300700001)(8676002)(44832011)(2906002)(8936002)(5660300002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GpF9dd7aQ4VlDdYsU/QDKlw8uGmIW559vV90d0IUH7bsnOXP3yd9ofoM2mM4?=
 =?us-ascii?Q?CO1JmRH60VCcDR7dl5uTcAG/LBDJbVQ8ll9SDZUp007kjG4gt9JMmyOWnjv4?=
 =?us-ascii?Q?TfX6tort34m+I0ZOzF6yZun+sMIvSLJx4JyixTDQw3ncOuXMgPibq1n2iEaF?=
 =?us-ascii?Q?IoFzMHUTsM5L2+0fhUYF8uXW2nuA/7kRqd5j0HU7f7nBjB8IhrXGumpNHIuB?=
 =?us-ascii?Q?kE1Ag91qXuRGz7Wqe130ZLwvdnMBnGZEPZVo2d78l/OQQkVGSjRqxuuUNqfy?=
 =?us-ascii?Q?iVG5yC0iXvtOz6hg5P8GGoclGB+Tvod5nbBuN2HI9ZaGxLqkKL9WBGq1xu3K?=
 =?us-ascii?Q?7TVvTDqnVehWNvacDhGwAoR04tzgtpCm7SqxTELARsZrOYft9s30b6jdM/r0?=
 =?us-ascii?Q?uBtz8X4NBZEdzNbEmKk7r9W4cJADerWD+S9tz+PC5Nd7nm9Y95uxYDVRWKI5?=
 =?us-ascii?Q?1+T+oGA0ifUOyTcRWaoLp/7TofJvCcs2wE9hs/JJtwVhZaXUtSKXypnE2WQz?=
 =?us-ascii?Q?IoIqldKHvIm9vkrNXWhGNbUSm8pNrqYNSi6muE30elvW1u4LFJJHefokOZej?=
 =?us-ascii?Q?ivuSFlCd+1/8aUOuyv7RhFVjwyoSigdsntBNPPgEnOTSTuDOgw5LrAtWLDVn?=
 =?us-ascii?Q?YxP8vVjH7qV5lyceTgNyUUkN2a97BRSIGNRXvrFPZVpuM9gzAoN5lJCRpchr?=
 =?us-ascii?Q?fBTmskxBy+9vH0xhXigToaNce28ekUv7QlugLiu4kL1e99UKNGXsFWPeOUax?=
 =?us-ascii?Q?vRY7SrrDitnr9K+pWIuHKxDh8YdcbB8HWU/zxCoZL5eMKi6s/Zo4XNyfNqSZ?=
 =?us-ascii?Q?wXoZc8UZzlrl3cCnX1iUtu/n/ayM+XDwoJSmZPL0NhmZZE8s9oUlPnXBbDYg?=
 =?us-ascii?Q?L9/8iLWr+ffMdNF9edL0hofxzC+NEJszXLLfvKh4w3rPu9SwuBnCxFIfk9Bt?=
 =?us-ascii?Q?JKqQpT110cT5ywAAIPDIDLFLpH099bVdbCY62bs+s6A0CCfYk4F4AkRbkLJA?=
 =?us-ascii?Q?6Elue9eg9bCtPK3GKqRJ1NowOZd1vB3eWDp7p9H071mY00q87e5Ylqufu6PE?=
 =?us-ascii?Q?3lsUmpXAXZwRfiOULe6cRBPghmh4+LAeimWA2aUSGvUz3sIG3n91ezJt6cY4?=
 =?us-ascii?Q?TWPG4hfxEEmtP+rbWxl9BLOlc7umyy9DSCoXeYBfTQOAilIMcQ9tIbMud4BV?=
 =?us-ascii?Q?7WQdaElnRmtpTaSUXofxxxgMayNKlVgpqquVyj8Ns4adE4Fwn4c7/Za0rSWe?=
 =?us-ascii?Q?uO2GsQWalZ76t2i34VthQuH4aV93DhoJsfZcPE6CzCL9vHlaNEGtEbsVKfjR?=
 =?us-ascii?Q?1Jrn5bb6prmBf/MkjqwVT9X0YUNxjOWEsZ55EQhdH+9j53ArMTkAiC1vWfkT?=
 =?us-ascii?Q?xY4ihv48AXMHNZrEZzXdJW0z9UDBiAoQdKdDvgeCf41RkmyYlLJm7NtrkxEJ?=
 =?us-ascii?Q?A89SOcRxSnYWuJJfHjsyselRqemxVT6VuFdO7wC+9aFhuQi7/jD6ot+8ZsVm?=
 =?us-ascii?Q?hdSB4bTnOVIZ8DLiy5zAOJxMq/otMVUw1CCNGdcGoN/1auTtEi6myFV554NO?=
 =?us-ascii?Q?0yCCMtyaoMlvOPMp6wbsh9PYbDAkxKVFogUiQmtJ9e8U/gm+LffUbnXTocDj?=
 =?us-ascii?Q?GxFqISJsqbKOzGRVPr2vzeE3Ha3G050EpqNd4z66qMlIy010CdNgaDGs2hb9?=
 =?us-ascii?Q?DcE0Dg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 550bad57-28ae-42ef-3995-08db4ffda1ef
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 19:51:36.8039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1XBlJhdHVnJdhhsZ+T/4xa0vNqcfIuYJVMcXL8rdCO4TXF0wYHRKLCCEksbCu3rdBhn6nMbDCstM+u/XIjWLZVJG7cnkXcSEhad34fd4E04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5811
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 02:43:19PM +0200, Piotr Raczynski wrote:
> Currently interrupt allocations, depending on a feature are distributed
> in batches. Also, after allocation there is a series of operations that
> distributes per irq settings through that batch of interrupts.
> 
> Although driver does not yet support dynamic interrupt allocation, keep
> allocated interrupts in a pool and add allocation abstraction logic to
> make code more flexible. Keep per interrupt information in the
> ice_q_vector structure, which yields ice_vsi::base_vector redundant.
> Also, as a result there are a few functions that can be removed.
> 
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>

...

> diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
> index 1911d644dfa8..7dd7a0f32471 100644
> --- a/drivers/net/ethernet/intel/ice/ice_base.c
> +++ b/drivers/net/ethernet/intel/ice/ice_base.c
> @@ -105,8 +105,7 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
>  	struct ice_q_vector *q_vector;
>  
>  	/* allocate q_vector */
> -	q_vector = devm_kzalloc(ice_pf_to_dev(pf), sizeof(*q_vector),
> -				GFP_KERNEL);
> +	q_vector = kzalloc(sizeof(*q_vector), GFP_KERNEL);
>  	if (!q_vector)
>  		return -ENOMEM;
>  
> @@ -118,9 +117,31 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
>  	q_vector->rx.itr_mode = ITR_DYNAMIC;
>  	q_vector->tx.type = ICE_TX_CONTAINER;
>  	q_vector->rx.type = ICE_RX_CONTAINER;
> +	q_vector->irq.index = -ENOENT;
>  
> -	if (vsi->type == ICE_VSI_VF)
> +	if (vsi->type == ICE_VSI_VF) {
> +		q_vector->reg_idx = ice_calc_vf_reg_idx(vsi->vf, q_vector);
>  		goto out;
> +	} else if (vsi->type == ICE_VSI_CTRL && vsi->vf) {
> +		struct ice_vsi *ctrl_vsi = ice_get_vf_ctrl_vsi(pf, vsi);
> +
> +		if (ctrl_vsi) {
> +			if (unlikely(!ctrl_vsi->q_vectors))
> +				return -ENOENT;

Hi Piotr,

Smatch tells me that q_vector i leaked here.

> +			q_vector->irq = ctrl_vsi->q_vectors[0]->irq;
> +			goto skip_alloc;
> +		}
> +	}
> +
> +	q_vector->irq = ice_alloc_irq(pf);
> +	if (q_vector->irq.index < 0) {
> +		kfree(q_vector);
> +		return -ENOMEM;
> +	}
> +
> +skip_alloc:
> +	q_vector->reg_idx = q_vector->irq.index;
> +
>  	/* only set affinity_mask if the CPU is online */
>  	if (cpu_online(v_idx))
>  		cpumask_set_cpu(v_idx, &q_vector->affinity_mask);

