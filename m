Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDF458EB0A
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 13:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiHJLLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 07:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbiHJLLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 07:11:13 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7AA31DDF
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 04:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660129872; x=1691665872;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qTPo1j+3cLEjBYFm6umYzIBNjP7KM5sGVcckJbVq9GI=;
  b=Y/YXp/WpSo20gsRdGaCl08PPmJbAGmlLWbnJ+eoXvx8byb1VPN9/Q6+j
   mWLv+3H3I76Ml0N/vuN16ZtSCtxU/Q2VyEp47IbU0MXzP8e3E1/gGS1IT
   giIrLiiw80KS5orJhP9bDqsrJY4D01GV2pb1OIO47XL/S0d5U92oCB4LD
   /iIys2/m2DbdcsFG6eJMSo8qLUSVgpmplO8c5mgtYoUCwT1AmeERdbDdY
   ueHK4U/QTsBi87JQAtH4HoCUHyklVAdZtF2XYsC0AYacULI2XvTK0qxAP
   QdfC7mAh7nzDmzOeKlEZPNS9OXEMo3W8cJlnQsCnSfqtyt+89bNDVhyMk
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10434"; a="377348227"
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="377348227"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 04:11:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="781200238"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 10 Aug 2022 04:11:09 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27ABB7ZT004526;
        Wed, 10 Aug 2022 12:11:08 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        ecree.xilinx@gmail.com, hkallweit1@gmail.com, saeed@kernel.org,
        leon@kernel.org, netdev@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [RFCv7 PATCH net-next 23/36] net: adjust the build check for net_gso_ok()
Date:   Wed, 10 Aug 2022 13:09:17 +0200
Message-Id: <20220810110917.1307697-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220810030624.34711-24-shenjian15@huawei.com>
References: <20220810030624.34711-1-shenjian15@huawei.com> <20220810030624.34711-24-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>
Date: Wed, 10 Aug 2022 11:06:11 +0800

> Introduce macro GSO_INDEX(x) to replace the NETIF_F_XXX
> feature shift check, for all the macroes NETIF_F_XXX will
> be remove later.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> ---
>  include/linux/netdevice.h | 40 ++++++++++++++++++++-------------------
>  1 file changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 1bd5dcbc884d..b01af2a3838d 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -4886,28 +4886,30 @@ netdev_features_t netif_skb_features(struct sk_buff *skb);
>  
>  static inline bool net_gso_ok(netdev_features_t features, int gso_type)
>  {
> +#define GSO_INDEX(x)	((1ULL << (x)) >> NETIF_F_GSO_SHIFT)

What if we get a new GSO offload which's corresponding bit will be
higher than 64?
You could instead do

#define __SKB_GSO_FLAG(x)	(1ULL << (x))

enum {
	SKB_GSO_TCPV4_BIT	= 0,
	SKB_GSO_DODGY_BIT	= 1,
	...,
};
enum {
	SKB_GSO_TCPV4		= __SKB_GSO_FLAG(TCPV4),
	SKB_GSO_DODGY		= __SKB_GSO_FLAG(DODGY),
	...,
};

and then just

#define ASSERT_GSO_TYPE(fl, feat)	\
	static_assert((fl) == (feat) - NETIF_F_GSO_SHIFT)

	...
	ASSERT_GSO_TYPE(SKB_GSO_TCPV4_BIT, NETIF_F_TSO_BIT);
	ASSERT_GSO_TYPE(SKB_GSO_DODGY, NETIF_F_GSO_ROBUST_BIT);
	...

> +
>  	netdev_features_t feature = (netdev_features_t)gso_type << NETIF_F_GSO_SHIFT;
>  
>  	/* check flags correspondence */
> -	BUILD_BUG_ON(SKB_GSO_TCPV4   != (NETIF_F_TSO >> NETIF_F_GSO_SHIFT));
> -	BUILD_BUG_ON(SKB_GSO_DODGY   != (NETIF_F_GSO_ROBUST >> NETIF_F_GSO_SHIFT));
> -	BUILD_BUG_ON(SKB_GSO_TCP_ECN != (NETIF_F_TSO_ECN >> NETIF_F_GSO_SHIFT));
> -	BUILD_BUG_ON(SKB_GSO_TCP_FIXEDID != (NETIF_F_TSO_MANGLEID >> NETIF_F_GSO_SHIFT));
> -	BUILD_BUG_ON(SKB_GSO_TCPV6   != (NETIF_F_TSO6 >> NETIF_F_GSO_SHIFT));
> -	BUILD_BUG_ON(SKB_GSO_FCOE    != (NETIF_F_FSO >> NETIF_F_GSO_SHIFT));
> -	BUILD_BUG_ON(SKB_GSO_GRE     != (NETIF_F_GSO_GRE >> NETIF_F_GSO_SHIFT));
> -	BUILD_BUG_ON(SKB_GSO_GRE_CSUM != (NETIF_F_GSO_GRE_CSUM >> NETIF_F_GSO_SHIFT));
> -	BUILD_BUG_ON(SKB_GSO_IPXIP4  != (NETIF_F_GSO_IPXIP4 >> NETIF_F_GSO_SHIFT));
> -	BUILD_BUG_ON(SKB_GSO_IPXIP6  != (NETIF_F_GSO_IPXIP6 >> NETIF_F_GSO_SHIFT));
> -	BUILD_BUG_ON(SKB_GSO_UDP_TUNNEL != (NETIF_F_GSO_UDP_TUNNEL >> NETIF_F_GSO_SHIFT));
> -	BUILD_BUG_ON(SKB_GSO_UDP_TUNNEL_CSUM != (NETIF_F_GSO_UDP_TUNNEL_CSUM >> NETIF_F_GSO_SHIFT));
> -	BUILD_BUG_ON(SKB_GSO_PARTIAL != (NETIF_F_GSO_PARTIAL >> NETIF_F_GSO_SHIFT));
> -	BUILD_BUG_ON(SKB_GSO_TUNNEL_REMCSUM != (NETIF_F_GSO_TUNNEL_REMCSUM >> NETIF_F_GSO_SHIFT));
> -	BUILD_BUG_ON(SKB_GSO_SCTP    != (NETIF_F_GSO_SCTP >> NETIF_F_GSO_SHIFT));
> -	BUILD_BUG_ON(SKB_GSO_ESP != (NETIF_F_GSO_ESP >> NETIF_F_GSO_SHIFT));
> -	BUILD_BUG_ON(SKB_GSO_UDP != (NETIF_F_GSO_UDP >> NETIF_F_GSO_SHIFT));
> -	BUILD_BUG_ON(SKB_GSO_UDP_L4 != (NETIF_F_GSO_UDP_L4 >> NETIF_F_GSO_SHIFT));
> -	BUILD_BUG_ON(SKB_GSO_FRAGLIST != (NETIF_F_GSO_FRAGLIST >> NETIF_F_GSO_SHIFT));
> +	BUILD_BUG_ON(SKB_GSO_TCPV4   != GSO_INDEX(NETIF_F_TSO_BIT));
> +	BUILD_BUG_ON(SKB_GSO_DODGY   != GSO_INDEX(NETIF_F_GSO_ROBUST_BIT));
> +	BUILD_BUG_ON(SKB_GSO_TCP_ECN != GSO_INDEX(NETIF_F_TSO_ECN_BIT));
> +	BUILD_BUG_ON(SKB_GSO_TCP_FIXEDID != GSO_INDEX(NETIF_F_TSO_MANGLEID_BIT));
> +	BUILD_BUG_ON(SKB_GSO_TCPV6   != GSO_INDEX(NETIF_F_TSO6_BIT));
> +	BUILD_BUG_ON(SKB_GSO_FCOE    != GSO_INDEX(NETIF_F_FSO_BIT));
> +	BUILD_BUG_ON(SKB_GSO_GRE     != GSO_INDEX(NETIF_F_GSO_GRE_BIT));
> +	BUILD_BUG_ON(SKB_GSO_GRE_CSUM != GSO_INDEX(NETIF_F_GSO_GRE_CSUM_BIT));
> +	BUILD_BUG_ON(SKB_GSO_IPXIP4  != GSO_INDEX(NETIF_F_GSO_IPXIP4_BIT));
> +	BUILD_BUG_ON(SKB_GSO_IPXIP6  != GSO_INDEX(NETIF_F_GSO_IPXIP6_BIT));
> +	BUILD_BUG_ON(SKB_GSO_UDP_TUNNEL != GSO_INDEX(NETIF_F_GSO_UDP_TUNNEL_BIT));
> +	BUILD_BUG_ON(SKB_GSO_UDP_TUNNEL_CSUM != GSO_INDEX(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT));
> +	BUILD_BUG_ON(SKB_GSO_PARTIAL != GSO_INDEX(NETIF_F_GSO_PARTIAL_BIT));
> +	BUILD_BUG_ON(SKB_GSO_TUNNEL_REMCSUM != GSO_INDEX(NETIF_F_GSO_TUNNEL_REMCSUM_BIT));
> +	BUILD_BUG_ON(SKB_GSO_SCTP    != GSO_INDEX(NETIF_F_GSO_SCTP_BIT));
> +	BUILD_BUG_ON(SKB_GSO_ESP != GSO_INDEX(NETIF_F_GSO_ESP_BIT));
> +	BUILD_BUG_ON(SKB_GSO_UDP != GSO_INDEX(NETIF_F_GSO_UDP_BIT));
> +	BUILD_BUG_ON(SKB_GSO_UDP_L4 != GSO_INDEX(NETIF_F_GSO_UDP_L4_BIT));
> +	BUILD_BUG_ON(SKB_GSO_FRAGLIST != GSO_INDEX(NETIF_F_GSO_FRAGLIST_BIT));
>  
>  	return (features & feature) == feature;
>  }
> -- 
> 2.33.0

Thanks,
Olek
