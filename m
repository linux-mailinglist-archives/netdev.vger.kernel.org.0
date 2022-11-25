Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3094638D0F
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 16:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiKYPHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 10:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiKYPHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 10:07:51 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2612A15A35;
        Fri, 25 Nov 2022 07:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669388869; x=1700924869;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=NOCR7gaDOf3iueCLvBzzO8WDbNJxFrOrBIyMf4ZDDho=;
  b=TGrcdZWoPlnr4xP+SmRncgiT2f4Jm0wfBLlJQkDy3e13Pgrwo7SLYjBj
   OqYGiVkvFV1rBlsmJNB9tsMVeJh4XRf1mwx9ln0zCWsYs5xEkpY0nRWJr
   YE5rjxQ6LCNo0KZv4j2lyUGxUQ8CYd0z6akGnZcOsnGRjMmEfa2ijtiJV
   pgCR6qLm57WhRp4IAKQx9EVHKTIvUu7fT6+h9aRogdeyjts4Bw4LTlQjb
   WTxEhdYGadiTH7CQVvKSEKNJwocBLqxkXOIUQxaLNhaRlLTh+yO3NoyPY
   H0xQoKDzdySjUnCGKPIlWSQf9b/NGct4N6hWHMAktPiwxwqbbrtgcNjFA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="378753974"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="378753974"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:07:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="748615043"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="748615043"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 25 Nov 2022 07:05:36 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 07:05:29 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 25 Nov 2022 07:05:29 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 05:31:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lcmp76E/fZtDsesi9wTu+RRuQABvDtc39fH05J5ELcgtylrT3q+/7Ra94YutbE4h/GXR+olFl8OnLyGWSrMh3Z9mCCRkQRmIDQEMmw01rA3rNhRtmrg9XpWFrZNrSpxWiQnP0j1modbN8rz3D+MFSMirjo2pcLbrajZkVvVJ9b44uNwLnWuWMHcVx6h4hy1QVKawfzwQvKkmgW6PWrfnIdDJg+MDqzeva62Dd4JkoGRZnvt6mHla3Iq4eilJVfIY27HafEl8qwpITPEof8rCU2QkZIKaZAj+tfl03RsDugtvOMZf/vB5s1BS83NLSmRuJ+zDctRbPvDNvmdjR88ZXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5HVOt5f7WbMJ/Xi2GMaiXVfdpmTt4WeYgdadQTnsobA=;
 b=AJWdSnZzbGRCqjd3dBJJ5Ww/eUdWAqyAY5mjcgnmKXYLI+SNPsrnNiS/4rdvqG8K3MsAhUH+0Gk+uG2F7/SnACtEwChca5299WfUDfuh02F41JIEvT8HHyX0TCN19NoW9oSm226POD6Qsh+7S82zTQjQ5cBup2wqtMPCxQpI5lhNdXrQ5Imr+VJ/dMNXnBLQMlV1421ORA+CBWjdvbTrsZlldhKsBm6IM6nPKqRMb+rvo14I+an0MdZUoAj6jnNR1yHCRJq+NZva+ct0v8me3xUQfbLLOCeVlXNns3TkBKqMGId/ao41pWTpjzQ4ymJ5Z9haWvzYz2PuhEswmG5MGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.20; Fri, 25 Nov 2022 13:31:00 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Fri, 25 Nov 2022
 13:31:00 +0000
Date:   Fri, 25 Nov 2022 14:30:54 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Yuri Karpov <YKarpov@ispras.ru>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>
Subject: Re: [PATCH] net: ethernet: nixge: fix NULL dereference
Message-ID: <Y4DDjquBK8upTxs0@boxer>
References: <20221124084303.2075092-1-YKarpov@ispras.ru>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221124084303.2075092-1-YKarpov@ispras.ru>
X-ClientProxiedBy: LO2P123CA0081.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::14) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CO1PR11MB5154:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ecd16fd-78ef-4e0f-55f3-08dacee94ad7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2MSsQcwwAT18xyOlJB/POtJYit2Hbf5avZVei3sgTzGSfTnn0o+7oXP6o8NmJdaaD2stWLqGv1jrtcdjD5MmUBvmzYRivsKydF92TGTIKxiAgBwdenu9nIp98juzebclRccvp5IuY9+1jRUNmAaSOa8u9j5o1wCF3znqJ7IfcU/ueFskC9Kzj4prEfVPwnL0HEvTEf3G3gA2hCsMBupGQP66Kvxh0QnfsESJfmT/kCuiRtyETgKyZ2hSeats4AnRjlkOCB5PEqGOXA3RWKMH9iSrUPUHc0Hc1BUCWqqaRM+y7kHQwG5P7plDfzaRsDk32cp4AzXkqWFVaaM9Q/MP1j55w0kmv/TgUwNBmzXuQmTKMLUs5g8L+9kCkONIaYwaSA7oDFQe0SwvskFhEKnG180BEvBAhtgnjnuqEu8vV5o8PphceEh3mPT7iyKWs43tfbMxakwDRAFqcQBYXio90Usc1ZnhuV1RDjxd1PtNM8yBG+1vcYJ+SmA97N2IU63eamwvV/bE3g23foG85eH6gr18IL0isJweTMJ8EgW2n+S8xMh4aUciQmamPjbyfqYfVDr5yvriLGt6WKjZfDZTGCelNWICtbRvl4LIeI5ur6t1fan1lh+Fo7Gl3wZnC5s5K34uoRlPQCGgKN7uDn4ST5uY5KZCU2So885yaICBn7IsDHEOebFfQ66/aS+/fO8z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(82960400001)(54906003)(478600001)(38100700002)(2906002)(33716001)(6486002)(4326008)(41300700001)(5660300002)(66476007)(66556008)(66946007)(8676002)(86362001)(8936002)(316002)(6916009)(44832011)(83380400001)(186003)(6666004)(6506007)(9686003)(6512007)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TE3hxhRMcfQKiiGF2n5b7xtHq44cTQwSZblmNtZynlFuf8PthGm7v2Pt4ChL?=
 =?us-ascii?Q?Ol0QW4wQjGV1uOum05zgn9Ign78Dnc042z5mMQ3cQcnDvNrckbnzIM2pt7i1?=
 =?us-ascii?Q?Q+4ltcvWRd12n66vbFQ2kXj95hoyViOB3B/nW1AWAJO0Ylb01urSCUv/bMRS?=
 =?us-ascii?Q?uzNfIgd3xcHlk/ECdv0iltUhLMbOCcno3dPGb5Vy8pd90tQhaIoQofQtWLd1?=
 =?us-ascii?Q?yC14nSmRS2U0BC6riwJ+u1HfdY9IebAa8HjqDbn5jyJqqTD73pxJk0l0eMwS?=
 =?us-ascii?Q?BN5TA8lNd1fL+ysZ6BFBJbj2dcqotY1O41Ydt1OYAtzpc5moRiye9ZgoIhbb?=
 =?us-ascii?Q?WYRRr20lvkhN04QzX+l+4yGvCkSMJxpp+l/jPPeICCZtWWsjnh3OplXKuT5D?=
 =?us-ascii?Q?P2nKmFmPDTGu2JSYnVM7ANbzgyN9jfe+7lnX0OkB+jmscfteg3b0KRPjQRJF?=
 =?us-ascii?Q?CzWf3ebVTVMoFrhebOpC6ZcYB5QWqa7o/3NFoM28ysrnB2KTirAOLaamIHU6?=
 =?us-ascii?Q?y5zKrbpPKaizJJ8EERITa+fPapVtlNm3nw6tGmv3BHj8K3vKTxYNlnZbCd0j?=
 =?us-ascii?Q?GSWndydQD2P24TS/xFZYbZpFJ6pvYlRojXrtxhu/f2JGiBWgXhIe9nPc7JDV?=
 =?us-ascii?Q?M32jp0Vtxb1iYGXVtnGHzrCB7VNM1xFZpc/XHu6f7qYnBLFlhMbbPn+aV0hc?=
 =?us-ascii?Q?Uv6W1s6igDZXksOKoNUL2o2Qln0q7nd3TtDj5g8aMF7MDhDo2vt9lyccX1Hj?=
 =?us-ascii?Q?w+CueCelfLzwKq7bUkCHg/qhnjkXhew03vQijMfRhW/fOK093RfRohCd+Lrd?=
 =?us-ascii?Q?JeVdCVbtNDUPAn3RodOJxCdLtlhHSIcKirb/LoqW3MXEIyb9q1DrmWz3cakH?=
 =?us-ascii?Q?lliRLDKvZ/0KOkLtO7+PDJlkAk8Kv8avuNGQaMbMlmCCKdwjezWrNVE1DP0H?=
 =?us-ascii?Q?paWFJi3K1SoeKcs5yY/2fZTeHEiVBCQadCKhZS4IRbxnXTxXYq0UvBMYhqdB?=
 =?us-ascii?Q?+/XMJMBc7sTkL3xk2vFev9CVcnY51k2ZuUHUMv3Oabz8hQ265waYRHqs8RmY?=
 =?us-ascii?Q?V4oa5bggzrS5R71RnF0Rr0heQ6CmtMyqzxFb3u3Pas1rkyTwrrFgsGRqfSAC?=
 =?us-ascii?Q?HXAO2lLCA13evclhRLjtYJtYE7mI7OPOhYyKDU1Q7alDr7OLGs5Tvb1A6xZd?=
 =?us-ascii?Q?4J2d2bB2K/FmqrpE5yZuzi8on1N5gEVNIAPC5CcW7g/+X0FDr3F8+k4ObfzT?=
 =?us-ascii?Q?9wXFsx3tCO75m5IntsaCbO0D/sSUIh32+Lqs6FTb/2dvLHx7AYHq6z/W3hpT?=
 =?us-ascii?Q?pi97sqpS6uH7obGvbZbXaD0v0+9eV4rJFJK5oOnCB0+xfouA0CTSyKPFGMyh?=
 =?us-ascii?Q?8v7auJ5lVvSGglsFUMKMcih0vxGfo8I8gL9XTrZMa4upvsRvzylzQ77pOtoD?=
 =?us-ascii?Q?qeuSnseiM4wT2eJ+BWLLKrUiGVXOcv/1akywU7IIdT37UJ3Newfg39O7Q6LS?=
 =?us-ascii?Q?HP6ixLrGxdZDztuW9tzT0lzVHx1DxA62tc5hkVbkqN93qbRMmosFgcFakim3?=
 =?us-ascii?Q?bHfioOiQp1rs8byexgppU0yQlRL4bPCY++1ka9csT9qLnjDREf5EIyQmrp2k?=
 =?us-ascii?Q?EA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ecd16fd-78ef-4e0f-55f3-08dacee94ad7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 13:31:00.5924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6DIhrOPhiwn3TVAlQlMkYHr41YPw/j7IGn+hw+gK87ixal3y/Aw04piGsOz45Lk1C7nuEpYYBTLRdyDANRu2cHSSt78MmwWbzpv1Gksc7o0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5154
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 11:43:03AM +0300, Yuri Karpov wrote:
> In function nixge_hw_dma_bd_release() dereference of NULL pointer
> priv->rx_bd_v is possible for the case of its allocation failure in
> nixge_hw_dma_bd_init().
> 
> Move for() loop with priv->rx_bd_v dereference under the check for
> its validity.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 492caffa8a1a ("net: ethernet: nixge: Add support for National Instruments XGE netdev")
> Signed-off-by: Yuri Karpov <YKarpov@ispras.ru>

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
>  drivers/net/ethernet/ni/nixge.c | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
> index 19d043b593cc..62320be4de5a 100644
> --- a/drivers/net/ethernet/ni/nixge.c
> +++ b/drivers/net/ethernet/ni/nixge.c
> @@ -249,25 +249,26 @@ static void nixge_hw_dma_bd_release(struct net_device *ndev)
>  	struct sk_buff *skb;
>  	int i;
>  
> -	for (i = 0; i < RX_BD_NUM; i++) {
> -		phys_addr = nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
> -						     phys);
> -
> -		dma_unmap_single(ndev->dev.parent, phys_addr,
> -				 NIXGE_MAX_JUMBO_FRAME_SIZE,
> -				 DMA_FROM_DEVICE);
> -
> -		skb = (struct sk_buff *)(uintptr_t)
> -			nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
> -						 sw_id_offset);
> -		dev_kfree_skb(skb);
> -	}
> +	if (priv->rx_bd_v) {
> +		for (i = 0; i < RX_BD_NUM; i++) {
> +			phys_addr = nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
> +							     phys);
> +
> +			dma_unmap_single(ndev->dev.parent, phys_addr,
> +					 NIXGE_MAX_JUMBO_FRAME_SIZE,
> +					 DMA_FROM_DEVICE);
> +
> +			skb = (struct sk_buff *)(uintptr_t)
> +				nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
> +							 sw_id_offset);
> +			dev_kfree_skb(skb);
> +		}
>  
> -	if (priv->rx_bd_v)
>  		dma_free_coherent(ndev->dev.parent,
>  				  sizeof(*priv->rx_bd_v) * RX_BD_NUM,
>  				  priv->rx_bd_v,
>  				  priv->rx_bd_p);
> +	}
>  
>  	if (priv->tx_skb)
>  		devm_kfree(ndev->dev.parent, priv->tx_skb);
> -- 
> 2.34.1
> 
