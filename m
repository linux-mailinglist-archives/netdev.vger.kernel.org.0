Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC4A4B8B07
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbiBPOHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:07:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiBPOHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:07:08 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CC4EF08F
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645020415; x=1676556415;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EE/CjSP76fFakZhpMBsq2l8PWis4xiMzO1+0+7cntJ0=;
  b=EQP42bTuMAdfXkzsEesiXnnBA44J1x7tO3+Wgj14rI6QOIhrCmiyYSgf
   t1ndp4ZOdYfMvib6wv1FVYoUWwmxKe6xJPpjIkh+bXmi5pGeMvmkphZrH
   YRTBHDUXnJ2DBbbt6HE9XS0nqb6SGaw75tv/PNaHOv0Df/w1DXbAIeDlc
   f4gPJ3lgyZ6Pqnwx5Inh5uFsQoH2uGnOht9mkdopXGtPxXe7k8aDQtV4D
   nV9LDOWLJu7pEUR9nNJGVXXAjeWfjRevIAOSH9ofQUVI8NOGeQmEsKteh
   e+6tZVQWktjz0DHMXmgPOTAI170a9+g8hfRUONzVVec/sjORn43jqvblj
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="275189557"
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="275189557"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 06:06:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="544949903"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 16 Feb 2022 06:06:52 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 21GE6opS012072;
        Wed, 16 Feb 2022 14:06:51 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Gal Pressman <gal@nvidia.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [PATCH net-next] net: gro: Fix a 'directive in macro's argument list' sparse warning
Date:   Wed, 16 Feb 2022 15:06:05 +0100
Message-Id: <20220216140605.430015-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216103100.9489-1-gal@nvidia.com>
References: <20220216103100.9489-1-gal@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>
Date: Wed, 16 Feb 2022 12:31:00 +0200

> Following the cited commit, sparse started complaining about:
> ../include/net/gro.h:58:1: warning: directive in macro's argument list
> ../include/net/gro.h:59:1: warning: directive in macro's argument list
> 
> Fix that by moving the defines out of the struct_group() macro.

Ah, correct, sorry that I missed it during the initial review.

Acked-by: Alexander Lobakin <alexandr.lobakin@intel.com>

> 
> Fixes: de5a1f3ce4c8 ("net: gro: minor optimization for dev_gro_receive()")
> Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> ---
>  include/net/gro.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/gro.h b/include/net/gro.h
> index a765fedda5c4..146e2af8dd7d 100644
> --- a/include/net/gro.h
> +++ b/include/net/gro.h
> @@ -35,6 +35,8 @@ struct napi_gro_cb {
>  	/* jiffies when first packet was created/queued */
>  	unsigned long age;
>  
> +#define NAPI_GRO_FREE		  1
> +#define NAPI_GRO_FREE_STOLEN_HEAD 2

1. Maybe add a comment above the definitions that they belong to
the `napi_gro_cb::free` field?
2. Maybe align the second with tabs while at it?

>  	/* portion of the cb set to zero at every gro iteration */
>  	struct_group(zeroed,
>  
> @@ -55,8 +57,6 @@ struct napi_gro_cb {
>  
>  		/* Free the skb? */
>  		u8	free:2;
> -#define NAPI_GRO_FREE		  1
> -#define NAPI_GRO_FREE_STOLEN_HEAD 2
>  
>  		/* Used in foo-over-udp, set in udp[46]_gro_receive */
>  		u8	is_ipv6:1;
> -- 
> 2.25.1

Thanks!
Al
