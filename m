Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C556BBAAA
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 18:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbjCORPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 13:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjCORPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 13:15:05 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCA01555C
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 10:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678900503; x=1710436503;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=oBcDiXeNU237O+jlgIYyLW2wo3La5RrAmsZlEa5BSNY=;
  b=ZEu6DM1PNMAUYD6qagRLwrjLmH1iJ98VP5O+JuBhZxQuowUj69AHGz3+
   HxDHIB4VX+x4gr+y0b1CVOL3y7FoVvTzvPGoMT9uzr6uXSOup6HmxfX2Z
   aXbzzUOM/Kp7TsXOMX1HgcnPuHKPoKUJKLFSgDAbE+dVkef25+DIG2w0E
   0stA4FZbWJ0xiEPbwdi4lN1X8M39Ja0eiaPobgoeBG85r/8B1fVMXwIWT
   GvInVKT5Tb4lTp5Ol8ZXkDpBOoNMlAuakaqxra9Zwl/N+gctnchRupd2O
   xrfLWfs7Ff0tDxYtj+wDuj2Hr3ImCXEnWf7HXG3tuWez0GwLi3DpNOW1Z
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="321614799"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="321614799"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 10:15:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="768588782"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="768588782"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Mar 2023 10:14:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 10:14:58 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 10:14:58 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 10:14:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C5iuan6E8+7sMNIByPfAlPTJUX/T9ELa9jfKYF93V86b9w2IaU2nLGBeg5Em7+FuP/73yeP34qV5RGO6pKUbZAFN4Ol/Vj0FPWNqi2Dq/Swa9qBsbFvWC0dmiZJ4e9yJnYUy0uiInY8Mu68aGn9AbW5vbY/7gCfQQ9Z91OVkOResOrxVlyzWZG26/rc7Rog8ELjH+NKmATUkWYTOh79EZtCdS69Df/cNKXPG0W9LqmphZG9i/OLvidmDOgcRa1yI8lzd2ZXg0V2OR1aZT/8qJY3K0sD0/Aq8BSMao+fl2PQw9S4kVDJqYNVALRjBoLpyr4NCnPM9msgBw9uEYosYHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aiXZkq/t8Rvmpr09EfLxBQPSyvgcnuTJdWTd6s2WEzI=;
 b=BMJz2/R3o1zi9aQP7M99bqvIt+XCdxB9FrIVazXFaZdJ1kyKMQ1t1nn2MQc9zfbYYvgVh6uqY1l5bPZNT4PqWwQI61Z5RpUdbvpigOsgfWKg/J5gu0kMewirSg2mXt8by8LD+i03bAyaBA1/HfYA8pakzxMdCY+x0toFR1aQaCiilGNVnvosWYwl88VajssHe7jQQ/RsFZxlM3xQYgGHMxPGTlnBM4KX31TMRB+SO3S3U0HaF2fuAztL+5Tc3cR+Jp4tX5+aTADUuORdv2+BSw/yAQvCfKMvsK0zxXTd8GkOU8c6fSfv0vXoQrpB+kiFTXfSCFvubDZ+dY6W/HNTrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 CH3PR11MB7772.namprd11.prod.outlook.com (2603:10b6:610:120::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Wed, 15 Mar 2023 17:14:56 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 17:14:56 +0000
Date:   Wed, 15 Mar 2023 18:14:50 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Praveen Kaligineedi <pkaligineedi@google.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <maciej.fijalkowski@intel.com>,
        Jeroen de Borst <jeroendb@google.com>
Subject: Re: [PATCH net-next v3 2/5] gve: Changes to add new TX queues
Message-ID: <ZBH9ClO15oAf+kJB@localhost.localdomain>
References: <20230313202640.4113427-1-pkaligineedi@google.com>
 <20230313202640.4113427-3-pkaligineedi@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230313202640.4113427-3-pkaligineedi@google.com>
X-ClientProxiedBy: LO4P123CA0122.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::19) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|CH3PR11MB7772:EE_
X-MS-Office365-Filtering-Correlation-Id: f03f3d12-7ce2-436f-a45a-08db2578cc46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MYxUU0TZYrYtpdCRMJCbumnhJlpJUvtH7Ukp2elkYpuJg/hPYUie/Th3+lJo531JBv46CGD5+GQELfAMB5mMURnh6iQ6kFFZFL2qMf/2DpgdObAwptxgJTuO4U815LLAmXiGZP0R/SZc0lYQY2YoayvyU9jkfRHW5pm9mgdLv8d9IArOJk+zr8e/SXs/1lCSTT2vU6vr5GoeHKKO4MKTdEs3pSgiz0jxi0vY7+EqqYHXyWl3kZmviBc91Kgdw0v1kL9o9xQ3cTUfkiWKLUoOiUd4xWDMbplWiAIwLD01wKKMGNIrTcM7/PTpRx4NDJg0gjOL/xdNrCh2yhvSnwPM3LB5URxMapHTgYLU3ijvwRkS2QTMu98aOIPyiS+Qb/d6pYrfWPTC36JhQQ8mAXug4QV7vCI42V05q6PBgWuT046QBt9xXbIcvXWTkWb+kglL6HryPYpxmjzWaX6qRxNXx85jFErU5c5TNeezlD9cmThg9mNhVbbPBIwIAmqgGC09AZe8WlqSOIO0bWX2lf8XaNYPbclbv1ZRQmpt4yX5DCdaBgi7hOjYJQXAdm7RQX9z2Ktzq2TENgdT7X8Rt8tDMEgnXAF9nVxYcjpsuIVrObE8p5IjL/4VZsHrqw6bYJWxFdTSIBh0u0hS2KjbyquFe0xNnMs/qWw60DcRSSwgnROgNJ+Yyy+9OIaeQ1MT6MX3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(136003)(396003)(346002)(376002)(451199018)(38100700002)(316002)(83380400001)(8676002)(4326008)(6916009)(66946007)(6486002)(6506007)(9686003)(8936002)(186003)(6666004)(26005)(82960400001)(478600001)(66556008)(66476007)(30864003)(44832011)(2906002)(86362001)(6512007)(5660300002)(41300700001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vgnxQe/eLJF8aPLNmXspYbRm1qMABn69S4mvBZrdfE3eM/YqAmnhPojcEq6s?=
 =?us-ascii?Q?b9YJ65eyh0vAM+LKpwzQXFocNdil0SZkUwdIM2x2lmbjzugZFsaEm85Zi1It?=
 =?us-ascii?Q?z/MeZ97W0IFUO2MS4sx8ejIfscgXe1vRl5kn6c6eeuKVYHgimfWc+Jz0qyPS?=
 =?us-ascii?Q?rNQiayZjRXVpfymorxj03abVodUdBbPIvyIUN7vErFAkRAGygux1qDSj2/Gn?=
 =?us-ascii?Q?6cPufD/a3iPIzIzHXWaISFZrN1D+vVSvge2Col5VmYBoOa8bQDwszywX2+f8?=
 =?us-ascii?Q?qxElIunGrEOvTCsGgvaffgyBnb5mwR9mNRmMK5BU1AVgI3U+3U6AEJ3NnOmB?=
 =?us-ascii?Q?OOYrUs4PeaYHZ5A2U9SEMRWpZq74d06KWBkkRqFXPrivEt0S3FJiamjmDpDF?=
 =?us-ascii?Q?0nG9Q146D1+qbuOUDpxbOCS+7HkHwKWdxFeeGcPPCjIgO4uTmCm7bAft7u1i?=
 =?us-ascii?Q?tlTalw6+tZvyC7unBtoQfMjC2l1KtJ7eX5adzz8Mm3OO/Iju6ug0Vk0r7vyj?=
 =?us-ascii?Q?UoHBaT/1pxRA551lgPgl4Kh5dB/zt0TtxRSmca4MQ09rHKpopD+ypGeJN0GX?=
 =?us-ascii?Q?VCTMXZkUX6VNF/eB+JCWjmYlBWlwar1kGdPSLeHtBrsZ2O8w3CGZHdcgZ5Xx?=
 =?us-ascii?Q?zdzYjjoHDfVE6iQzm94t9OHa0BDK/jJrblQwzrhrEhwfUIjw9A0bBplyXyuI?=
 =?us-ascii?Q?WYXqqn+lh5gzcFAdYqgEQ5C1at0NyjmVaMK1iq4Hq6I2CSZFePrdSCezWyaR?=
 =?us-ascii?Q?f2w5dlNPyYpFIyQwyB3tDLybnVrY7WPmE3+Hql7Bp50HhsHS6uwQ1TnOk2pO?=
 =?us-ascii?Q?+ReVjhbugUD/XgOP8jUNdenE5UgM6UnnRbaqUZ+Hakx6a2B0zt7h60XNZLnZ?=
 =?us-ascii?Q?+RSfFquGEFnqRCm7mzOcVSX64v8uKt3mUxLRl/zVaVQvozqTDVXXGck+LSMa?=
 =?us-ascii?Q?SbWohAcmey1wPCEjsrFDJaiRXkWxOvlNM5qKm3qZPisMFJvTno2sxwlyvJ15?=
 =?us-ascii?Q?/r9tR+ceZvRFJ7PD7lBiQcVpmzB49RX/R+y4kYphR9oWLT9iHfPSaUn1MlFu?=
 =?us-ascii?Q?f5ZLkQayrOtikpelW0Dra+Yp+Vf70TdnOcT6ttzrs2pwPAAySkVSwJTY2/v+?=
 =?us-ascii?Q?iUrL+kIimjrONOPVrOx1qqaCpLm4lDMycujdx14+wciEO4Yn9gvN0u3Bf4/3?=
 =?us-ascii?Q?o4z6nXXuyfP3tclqw79ZoSzEFIR/bL6DKXd/8YvGh5zxuSujRr4q/qx18yRe?=
 =?us-ascii?Q?rii0kTEAz0GM2FENWmrcY00FKqb+pvdKfCgH7hHRm3DT1lldj7QMle4ARHIK?=
 =?us-ascii?Q?IIWYQVkgIFFlLA6NVW9BmcevJCy52WIPiXzntMkMv5WdPAnA8XENe+aOJfks?=
 =?us-ascii?Q?KBs3x/mGenn4N1mGk3pFrOlGsd7bBRZQ+f1yl9taEIMeEB5fFXCFNWxqXQFT?=
 =?us-ascii?Q?v+JhvoMvxpo45Us7WoqeqqZJi5RJfU9Va8uxowmA14LMPBDv7riu4zGL1OL4?=
 =?us-ascii?Q?GIe3KQvbemUXyLpdy1LExmW5QyOIVLP3Txv1s/jETJTQ6vy3Xpj7kej1e67X?=
 =?us-ascii?Q?9bmMG55gNRnnTSsSPZIAjqIHmI8JoYA077BQ0wyDZJA6IygtxCF/9JtCju0M?=
 =?us-ascii?Q?fA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f03f3d12-7ce2-436f-a45a-08db2578cc46
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 17:14:55.9198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gbm6AfvEurmPoM6rDZ7lznCxXAnYLHVPkSlkT5mwTClRUo548ybly7DMrQ4suF7LLvsSO3VWU1F6bkXnVxuygQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7772
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 01:26:37PM -0700, Praveen Kaligineedi wrote:
> Changes to enable adding and removing TX queues without calling
> gve_close() and gve_open().
> 
> Made the following changes:
> 1) priv->tx, priv->rx and priv->qpls arrays are allocated based on
>    max tx queues and max rx queues
> 2) Changed gve_adminq_create_tx_queues(), gve_adminq_destroy_tx_queues(),
> gve_tx_alloc_rings() and gve_tx_free_rings() functions to add/remove a
> subset of TX queues rather than all the TX queues.
> 
> Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
> Reviewed-by: Jeroen de Borst <jeroendb@google.com>
> 

Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>

> ---
> Changed in v2:
> - Added this patch to address the issue raised by Jakub Kicinski about
>   implications of resource allocation failing after reconfig.
> 
> Changed in v3:
> - No changes
> ---
>  drivers/net/ethernet/google/gve/gve.h        | 45 +++++++----
>  drivers/net/ethernet/google/gve/gve_adminq.c |  8 +-
>  drivers/net/ethernet/google/gve/gve_adminq.h |  4 +-
>  drivers/net/ethernet/google/gve/gve_main.c   | 83 ++++++++++++++------
>  drivers/net/ethernet/google/gve/gve_rx.c     |  2 +-
>  drivers/net/ethernet/google/gve/gve_tx.c     | 12 +--
>  6 files changed, 104 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
> index f52f23198278..f354a6448c25 100644
> --- a/drivers/net/ethernet/google/gve/gve.h
> +++ b/drivers/net/ethernet/google/gve/gve.h
> @@ -798,16 +798,35 @@ static inline u32 gve_num_rx_qpls(struct gve_priv *priv)
>  	return priv->rx_cfg.num_queues;
>  }
>  
> +static inline u32 gve_tx_qpl_id(struct gve_priv *priv, int tx_qid)
> +{
> +	return tx_qid;
> +}
> +
> +static inline u32 gve_rx_qpl_id(struct gve_priv *priv, int rx_qid)
> +{
> +	return priv->tx_cfg.max_queues + rx_qid;
> +}
> +
> +static inline u32 gve_tx_start_qpl_id(struct gve_priv *priv)
> +{
> +	return gve_tx_qpl_id(priv, 0);
> +}
> +
> +static inline u32 gve_rx_start_qpl_id(struct gve_priv *priv)
> +{
> +	return gve_rx_qpl_id(priv, 0);
> +}
> +
>  /* Returns a pointer to the next available tx qpl in the list of qpls
>   */
>  static inline
> -struct gve_queue_page_list *gve_assign_tx_qpl(struct gve_priv *priv)
> +struct gve_queue_page_list *gve_assign_tx_qpl(struct gve_priv *priv, int tx_qid)
>  {
> -	int id = find_first_zero_bit(priv->qpl_cfg.qpl_id_map,
> -				     priv->qpl_cfg.qpl_map_size);
> +	int id = gve_tx_qpl_id(priv, tx_qid);
>  
> -	/* we are out of tx qpls */
> -	if (id >= gve_num_tx_qpls(priv))
> +	/* QPL already in use */
> +	if (test_bit(id, priv->qpl_cfg.qpl_id_map))
>  		return NULL;
>  
>  	set_bit(id, priv->qpl_cfg.qpl_id_map);
> @@ -817,14 +836,12 @@ struct gve_queue_page_list *gve_assign_tx_qpl(struct gve_priv *priv)
>  /* Returns a pointer to the next available rx qpl in the list of qpls
>   */
>  static inline
> -struct gve_queue_page_list *gve_assign_rx_qpl(struct gve_priv *priv)
> +struct gve_queue_page_list *gve_assign_rx_qpl(struct gve_priv *priv, int rx_qid)
>  {
> -	int id = find_next_zero_bit(priv->qpl_cfg.qpl_id_map,
> -				    priv->qpl_cfg.qpl_map_size,
> -				    gve_num_tx_qpls(priv));
> +	int id = gve_rx_qpl_id(priv, rx_qid);
>  
> -	/* we are out of rx qpls */
> -	if (id == gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv))
> +	/* QPL already in use */
> +	if (test_bit(id, priv->qpl_cfg.qpl_id_map))
>  		return NULL;
>  
>  	set_bit(id, priv->qpl_cfg.qpl_id_map);
> @@ -843,7 +860,7 @@ static inline void gve_unassign_qpl(struct gve_priv *priv, int id)
>  static inline enum dma_data_direction gve_qpl_dma_dir(struct gve_priv *priv,
>  						      int id)
>  {
> -	if (id < gve_num_tx_qpls(priv))
> +	if (id < gve_rx_start_qpl_id(priv))
>  		return DMA_TO_DEVICE;
>  	else
>  		return DMA_FROM_DEVICE;
> @@ -869,8 +886,8 @@ void gve_free_page(struct device *dev, struct page *page, dma_addr_t dma,
>  /* tx handling */
>  netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev);
>  bool gve_tx_poll(struct gve_notify_block *block, int budget);
> -int gve_tx_alloc_rings(struct gve_priv *priv);
> -void gve_tx_free_rings_gqi(struct gve_priv *priv);
> +int gve_tx_alloc_rings(struct gve_priv *priv, int start_id, int num_rings);
> +void gve_tx_free_rings_gqi(struct gve_priv *priv, int start_id, int num_rings);
>  u32 gve_tx_load_event_counter(struct gve_priv *priv,
>  			      struct gve_tx_ring *tx);
>  bool gve_tx_clean_pending(struct gve_priv *priv, struct gve_tx_ring *tx);
> diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
> index 60061288ad9d..252974202a3f 100644
> --- a/drivers/net/ethernet/google/gve/gve_adminq.c
> +++ b/drivers/net/ethernet/google/gve/gve_adminq.c
> @@ -516,12 +516,12 @@ static int gve_adminq_create_tx_queue(struct gve_priv *priv, u32 queue_index)
>  	return gve_adminq_issue_cmd(priv, &cmd);
>  }
>  
> -int gve_adminq_create_tx_queues(struct gve_priv *priv, u32 num_queues)
> +int gve_adminq_create_tx_queues(struct gve_priv *priv, u32 start_id, u32 num_queues)
>  {
>  	int err;
>  	int i;
>  
> -	for (i = 0; i < num_queues; i++) {
> +	for (i = start_id; i < start_id + num_queues; i++) {
>  		err = gve_adminq_create_tx_queue(priv, i);
>  		if (err)
>  			return err;
> @@ -604,12 +604,12 @@ static int gve_adminq_destroy_tx_queue(struct gve_priv *priv, u32 queue_index)
>  	return 0;
>  }
>  
> -int gve_adminq_destroy_tx_queues(struct gve_priv *priv, u32 num_queues)
> +int gve_adminq_destroy_tx_queues(struct gve_priv *priv, u32 start_id, u32 num_queues)
>  {
>  	int err;
>  	int i;
>  
> -	for (i = 0; i < num_queues; i++) {
> +	for (i = start_id; i < start_id + num_queues; i++) {
>  		err = gve_adminq_destroy_tx_queue(priv, i);
>  		if (err)
>  			return err;
> diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
> index cf29662e6ad1..f894beb3deaf 100644
> --- a/drivers/net/ethernet/google/gve/gve_adminq.h
> +++ b/drivers/net/ethernet/google/gve/gve_adminq.h
> @@ -410,8 +410,8 @@ int gve_adminq_configure_device_resources(struct gve_priv *priv,
>  					  dma_addr_t db_array_bus_addr,
>  					  u32 num_ntfy_blks);
>  int gve_adminq_deconfigure_device_resources(struct gve_priv *priv);
> -int gve_adminq_create_tx_queues(struct gve_priv *priv, u32 num_queues);
> -int gve_adminq_destroy_tx_queues(struct gve_priv *priv, u32 queue_id);
> +int gve_adminq_create_tx_queues(struct gve_priv *priv, u32 start_id, u32 num_queues);
> +int gve_adminq_destroy_tx_queues(struct gve_priv *priv, u32 start_id, u32 num_queues);
>  int gve_adminq_create_rx_queues(struct gve_priv *priv, u32 num_queues);
>  int gve_adminq_destroy_rx_queues(struct gve_priv *priv, u32 queue_id);
>  int gve_adminq_register_page_list(struct gve_priv *priv,
> diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
> index 3cfdeeb74f60..160ca77c2751 100644
> --- a/drivers/net/ethernet/google/gve/gve_main.c
> +++ b/drivers/net/ethernet/google/gve/gve_main.c
> @@ -584,11 +584,26 @@ static void gve_remove_napi(struct gve_priv *priv, int ntfy_idx)
>  
>  static int gve_register_qpls(struct gve_priv *priv)
>  {
> -	int num_qpls = gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv);
> +	int start_id;
>  	int err;
>  	int i;
>  
> -	for (i = 0; i < num_qpls; i++) {
> +	start_id = gve_tx_start_qpl_id(priv);
> +	for (i = start_id; i < start_id + gve_num_tx_qpls(priv); i++) {
> +		err = gve_adminq_register_page_list(priv, &priv->qpls[i]);
> +		if (err) {
> +			netif_err(priv, drv, priv->dev,
> +				  "failed to register queue page list %d\n",
> +				  priv->qpls[i].id);
> +			/* This failure will trigger a reset - no need to clean
> +			 * up
> +			 */
> +			return err;
> +		}
> +	}
> +
> +	start_id = gve_rx_start_qpl_id(priv);
> +	for (i = start_id; i < start_id + gve_num_rx_qpls(priv); i++) {
>  		err = gve_adminq_register_page_list(priv, &priv->qpls[i]);
>  		if (err) {
>  			netif_err(priv, drv, priv->dev,
> @@ -605,11 +620,24 @@ static int gve_register_qpls(struct gve_priv *priv)
>  
>  static int gve_unregister_qpls(struct gve_priv *priv)
>  {
> -	int num_qpls = gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv);
> +	int start_id;
>  	int err;
>  	int i;
>  
> -	for (i = 0; i < num_qpls; i++) {
> +	start_id = gve_tx_start_qpl_id(priv);
> +	for (i = start_id; i < start_id + gve_num_tx_qpls(priv); i++) {
> +		err = gve_adminq_unregister_page_list(priv, priv->qpls[i].id);
> +		/* This failure will trigger a reset - no need to clean up */
> +		if (err) {
> +			netif_err(priv, drv, priv->dev,
> +				  "Failed to unregister queue page list %d\n",
> +				  priv->qpls[i].id);
> +			return err;
> +		}
> +	}
> +
> +	start_id = gve_rx_start_qpl_id(priv);
> +	for (i = start_id; i < start_id + gve_num_rx_qpls(priv); i++) {
>  		err = gve_adminq_unregister_page_list(priv, priv->qpls[i].id);
>  		/* This failure will trigger a reset - no need to clean up */
>  		if (err) {
> @@ -628,7 +656,7 @@ static int gve_create_rings(struct gve_priv *priv)
>  	int err;
>  	int i;
>  
> -	err = gve_adminq_create_tx_queues(priv, num_tx_queues);
> +	err = gve_adminq_create_tx_queues(priv, 0, num_tx_queues);
>  	if (err) {
>  		netif_err(priv, drv, priv->dev, "failed to create %d tx queues\n",
>  			  num_tx_queues);
> @@ -695,10 +723,10 @@ static void add_napi_init_sync_stats(struct gve_priv *priv,
>  	}
>  }
>  
> -static void gve_tx_free_rings(struct gve_priv *priv)
> +static void gve_tx_free_rings(struct gve_priv *priv, int start_id, int num_rings)
>  {
>  	if (gve_is_gqi(priv)) {
> -		gve_tx_free_rings_gqi(priv);
> +		gve_tx_free_rings_gqi(priv, start_id, num_rings);
>  	} else {
>  		gve_tx_free_rings_dqo(priv);
>  	}
> @@ -709,20 +737,20 @@ static int gve_alloc_rings(struct gve_priv *priv)
>  	int err;
>  
>  	/* Setup tx rings */
> -	priv->tx = kvcalloc(priv->tx_cfg.num_queues, sizeof(*priv->tx),
> +	priv->tx = kvcalloc(priv->tx_cfg.max_queues, sizeof(*priv->tx),
>  			    GFP_KERNEL);
>  	if (!priv->tx)
>  		return -ENOMEM;
>  
>  	if (gve_is_gqi(priv))
> -		err = gve_tx_alloc_rings(priv);
> +		err = gve_tx_alloc_rings(priv, 0, gve_num_tx_queues(priv));
>  	else
>  		err = gve_tx_alloc_rings_dqo(priv);
>  	if (err)
>  		goto free_tx;
>  
>  	/* Setup rx rings */
> -	priv->rx = kvcalloc(priv->rx_cfg.num_queues, sizeof(*priv->rx),
> +	priv->rx = kvcalloc(priv->rx_cfg.max_queues, sizeof(*priv->rx),
>  			    GFP_KERNEL);
>  	if (!priv->rx) {
>  		err = -ENOMEM;
> @@ -747,7 +775,7 @@ static int gve_alloc_rings(struct gve_priv *priv)
>  	kvfree(priv->rx);
>  	priv->rx = NULL;
>  free_tx_queue:
> -	gve_tx_free_rings(priv);
> +	gve_tx_free_rings(priv, 0, gve_num_tx_queues(priv));
>  free_tx:
>  	kvfree(priv->tx);
>  	priv->tx = NULL;
> @@ -759,7 +787,7 @@ static int gve_destroy_rings(struct gve_priv *priv)
>  	int num_tx_queues = gve_num_tx_queues(priv);
>  	int err;
>  
> -	err = gve_adminq_destroy_tx_queues(priv, num_tx_queues);
> +	err = gve_adminq_destroy_tx_queues(priv, 0, num_tx_queues);
>  	if (err) {
>  		netif_err(priv, drv, priv->dev,
>  			  "failed to destroy tx queues\n");
> @@ -797,7 +825,7 @@ static void gve_free_rings(struct gve_priv *priv)
>  			ntfy_idx = gve_tx_idx_to_ntfy(priv, i);
>  			gve_remove_napi(priv, ntfy_idx);
>  		}
> -		gve_tx_free_rings(priv);
> +		gve_tx_free_rings(priv, 0, num_tx_queues);
>  		kvfree(priv->tx);
>  		priv->tx = NULL;
>  	}
> @@ -894,40 +922,46 @@ static void gve_free_queue_page_list(struct gve_priv *priv, u32 id)
>  			      qpl->page_buses[i], gve_qpl_dma_dir(priv, id));
>  
>  	kvfree(qpl->page_buses);
> +	qpl->page_buses = NULL;
>  free_pages:
>  	kvfree(qpl->pages);
> +	qpl->pages = NULL;
>  	priv->num_registered_pages -= qpl->num_entries;
>  }
>  
>  static int gve_alloc_qpls(struct gve_priv *priv)
>  {
> -	int num_qpls = gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv);
> +	int max_queues = priv->tx_cfg.max_queues + priv->rx_cfg.max_queues;
> +	int start_id;
>  	int i, j;
>  	int err;
>  
> -	if (num_qpls == 0)
> +	if (priv->queue_format != GVE_GQI_QPL_FORMAT)
>  		return 0;
>  
> -	priv->qpls = kvcalloc(num_qpls, sizeof(*priv->qpls), GFP_KERNEL);
> +	priv->qpls = kvcalloc(max_queues, sizeof(*priv->qpls), GFP_KERNEL);
>  	if (!priv->qpls)
>  		return -ENOMEM;
>  
> -	for (i = 0; i < gve_num_tx_qpls(priv); i++) {
> +	start_id = gve_tx_start_qpl_id(priv);
> +	for (i = start_id; i < start_id + gve_num_tx_qpls(priv); i++) {
>  		err = gve_alloc_queue_page_list(priv, i,
>  						priv->tx_pages_per_qpl);
>  		if (err)
>  			goto free_qpls;
>  	}
> -	for (; i < num_qpls; i++) {
> +
> +	start_id = gve_rx_start_qpl_id(priv);
> +	for (i = start_id; i < start_id + gve_num_rx_qpls(priv); i++) {
>  		err = gve_alloc_queue_page_list(priv, i,
>  						priv->rx_data_slot_cnt);
>  		if (err)
>  			goto free_qpls;
>  	}
>  
> -	priv->qpl_cfg.qpl_map_size = BITS_TO_LONGS(num_qpls) *
> +	priv->qpl_cfg.qpl_map_size = BITS_TO_LONGS(max_queues) *
>  				     sizeof(unsigned long) * BITS_PER_BYTE;
> -	priv->qpl_cfg.qpl_id_map = kvcalloc(BITS_TO_LONGS(num_qpls),
> +	priv->qpl_cfg.qpl_id_map = kvcalloc(BITS_TO_LONGS(max_queues),
>  					    sizeof(unsigned long), GFP_KERNEL);
>  	if (!priv->qpl_cfg.qpl_id_map) {
>  		err = -ENOMEM;
> @@ -940,23 +974,26 @@ static int gve_alloc_qpls(struct gve_priv *priv)
>  	for (j = 0; j <= i; j++)
>  		gve_free_queue_page_list(priv, j);
>  	kvfree(priv->qpls);
> +	priv->qpls = NULL;
>  	return err;
>  }
>  
>  static void gve_free_qpls(struct gve_priv *priv)
>  {
> -	int num_qpls = gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv);
> +	int max_queues = priv->tx_cfg.max_queues + priv->rx_cfg.max_queues;
>  	int i;
>  
> -	if (num_qpls == 0)
> +	if (!priv->qpls)
>  		return;
>  
>  	kvfree(priv->qpl_cfg.qpl_id_map);
> +	priv->qpl_cfg.qpl_id_map = NULL;
>  
> -	for (i = 0; i < num_qpls; i++)
> +	for (i = 0; i < max_queues; i++)
>  		gve_free_queue_page_list(priv, i);
>  
>  	kvfree(priv->qpls);
> +	priv->qpls = NULL;
>  }
>  
>  /* Use this to schedule a reset when the device is capable of continuing
> diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
> index db1c74b1d7d3..051a15e4f1af 100644
> --- a/drivers/net/ethernet/google/gve/gve_rx.c
> +++ b/drivers/net/ethernet/google/gve/gve_rx.c
> @@ -124,7 +124,7 @@ static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
>  		return -ENOMEM;
>  
>  	if (!rx->data.raw_addressing) {
> -		rx->data.qpl = gve_assign_rx_qpl(priv);
> +		rx->data.qpl = gve_assign_rx_qpl(priv, rx->q_num);
>  		if (!rx->data.qpl) {
>  			kvfree(rx->data.page_info);
>  			rx->data.page_info = NULL;
> diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
> index 0fb052ce9e0b..e24e73e74e33 100644
> --- a/drivers/net/ethernet/google/gve/gve_tx.c
> +++ b/drivers/net/ethernet/google/gve/gve_tx.c
> @@ -195,7 +195,7 @@ static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
>  	tx->raw_addressing = priv->queue_format == GVE_GQI_RDA_FORMAT;
>  	tx->dev = &priv->pdev->dev;
>  	if (!tx->raw_addressing) {
> -		tx->tx_fifo.qpl = gve_assign_tx_qpl(priv);
> +		tx->tx_fifo.qpl = gve_assign_tx_qpl(priv, idx);
>  		if (!tx->tx_fifo.qpl)
>  			goto abort_with_desc;
>  		/* map Tx FIFO */
> @@ -233,12 +233,12 @@ static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
>  	return -ENOMEM;
>  }
>  
> -int gve_tx_alloc_rings(struct gve_priv *priv)
> +int gve_tx_alloc_rings(struct gve_priv *priv, int start_id, int num_rings)
>  {
>  	int err = 0;
>  	int i;
>  
> -	for (i = 0; i < priv->tx_cfg.num_queues; i++) {
> +	for (i = start_id; i < start_id + num_rings; i++) {
>  		err = gve_tx_alloc_ring(priv, i);
>  		if (err) {
>  			netif_err(priv, drv, priv->dev,
> @@ -251,17 +251,17 @@ int gve_tx_alloc_rings(struct gve_priv *priv)
>  	if (err) {
>  		int j;
>  
> -		for (j = 0; j < i; j++)
> +		for (j = start_id; j < i; j++)
>  			gve_tx_free_ring(priv, j);
>  	}
>  	return err;
>  }
>  
> -void gve_tx_free_rings_gqi(struct gve_priv *priv)
> +void gve_tx_free_rings_gqi(struct gve_priv *priv, int start_id, int num_rings)
>  {
>  	int i;
>  
> -	for (i = 0; i < priv->tx_cfg.num_queues; i++)
> +	for (i = start_id; i < start_id + num_rings; i++)
>  		gve_tx_free_ring(priv, i);
>  }
>  
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
