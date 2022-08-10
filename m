Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2208258EB5E
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 13:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiHJLhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 07:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiHJLhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 07:37:43 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22DC6E8AE
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 04:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660131460; x=1691667460;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n2HynFr+DquXtZqIQ7iDhvt9lQOGrN83jLYaFbih7oA=;
  b=Nsei566Rq7wzb9TRONLlufAUNWwqzuSg2wijzI4m/uD+9Xg4gxJ9tL4x
   6XrJSTZ2eoTKumaQMmT1w5pAd/+Q+dEURKZ3QVhWpoIy9MpiKwrbWDV+P
   H2Y4aoi0jrSTAUfh7b0X9UqYUrZDZy9iutTQPQPWXECVTGw/sJR6vA+Gu
   ICEJqbVQ3ZkNUVjHM8DiZ6+8weR8mE9eveRivEq/swNg013PPAKWKDXTT
   5AZmKGBsFRfzOXhmT84JSJepvcpZZooklXc4OLGkko3H97URmqFHcasnp
   uc75gNKXihcZo60+lkgEhnySEgB0wazv6eULtVahvqF2xvE1n0/Ispsih
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10434"; a="317009143"
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="317009143"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 04:37:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="601783857"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 10 Aug 2022 04:37:37 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27ABbafe014027;
        Wed, 10 Aug 2022 12:37:36 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        ecree.xilinx@gmail.com, hkallweit1@gmail.com, saeed@kernel.org,
        leon@kernel.org, netdev@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [RFCv7 PATCH net-next 36/36] net: redefine the prototype of netdev_features_t
Date:   Wed, 10 Aug 2022 13:35:47 +0200
Message-Id: <20220810113547.1308711-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220810030624.34711-37-shenjian15@huawei.com>
References: <20220810030624.34711-1-shenjian15@huawei.com> <20220810030624.34711-37-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>
Date: Wed, 10 Aug 2022 11:06:24 +0800

> For the prototype of netdev_features_t is u64, and the number
> of netdevice feature bits is 64 now. So there is no space to
> introduce new feature bit. Change the prototype of netdev_features_t
> from u64 to structure below:
> 	typedef struct {
> 		DECLARE_BITMAP(bits, NETDEV_FEATURE_COUNT);
> 	} netdev_features_t;
> 
> Rewrite the netdev_features helpers to adapt with new prototype.
> 
> To avoid mistake using NETIF_F_XXX as NETIF_F_XXX_BIT as
> input macroes for above helpers, remove all the macroes
> of NETIF_F_XXX for single feature bit. Serveal macroes remained
> temporarily, by some precompile dependency.
> 
> With the prototype is no longer u64, the implementation of print
> interface for netdev features(%pNF) is changed to bitmap. So
> does the implementation of net/ethtool/.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c  |  12 +-
>  .../net/ethernet/intel/i40e/i40e_debugfs.c    |  12 +-
>  .../ethernet/netronome/nfp/nfp_net_common.c   |   4 +-
>  .../net/ethernet/pensando/ionic/ionic_lif.c   |   4 +-
>  include/linux/netdev_features.h               | 101 ++----------
>  include/linux/netdev_features_helper.h        | 149 +++++++++++-------
>  include/linux/netdevice.h                     |   7 +-
>  include/linux/skbuff.h                        |   4 +-
>  include/net/ip_tunnels.h                      |   2 +-
>  lib/vsprintf.c                                |  11 +-
>  net/ethtool/features.c                        |  96 ++++-------
>  net/ethtool/ioctl.c                           |  46 ++++--
>  net/mac80211/main.c                           |   3 +-
>  13 files changed, 201 insertions(+), 250 deletions(-)

[...]

> -static inline int find_next_netdev_feature(u64 feature, unsigned long start)
> -{
> -	/* like BITMAP_LAST_WORD_MASK() for u64
> -	 * this sets the most significant 64 - start to 0.
> -	 */
> -	feature &= ~0ULL >> (-start & ((sizeof(feature) * 8) - 1));
> -
> -	return fls64(feature) - 1;
> -}
> +#define NETIF_F_HW_VLAN_CTAG_TX
> +#define NETIF_F_IPV6_CSUM
> +#define NETIF_F_TSO
> +#define NETIF_F_GSO

Uhm, what are those empty definitions for? They look confusing.

>  
>  /* This goes for the MSB to the LSB through the set feature bits,
>   * mask_addr should be a u64 and bit an int
>   */
>  #define for_each_netdev_feature(mask_addr, bit)				\
> -	for ((bit) = find_next_netdev_feature((mask_addr),		\
> -					      NETDEV_FEATURE_COUNT);	\
> -	     (bit) >= 0;						\
> -	     (bit) = find_next_netdev_feature((mask_addr), (bit)))
> +	for_each_set_bit(bit, (unsigned long *)(mask_addr.bits), NETDEV_FEATURE_COUNT)
>  
>  /* Features valid for ethtool to change */
>  /* = all defined minus driver/device-class-related */
> @@ -311,4 +235,11 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
>  
>  #define NETIF_F_GSO_ENCAP_ALL	netdev_gso_encap_all_features
>  
> +#define GSO_ENCAP_FEATURES	(((u64)1 << NETIF_F_GSO_GRE_BIT) |		\
> +				 ((u64)1 << NETIF_F_GSO_GRE_CSUM_BIT) |		\
> +				 ((u64)1 << NETIF_F_GSO_IPXIP4_BIT) |		\
> +				 ((u64)1 << NETIF_F_GSO_IPXIP6_BIT) |		\
> +				 (((u64)1 << NETIF_F_GSO_UDP_TUNNEL_BIT) |	\
> +				  ((u64)1 << NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT)))

1) 1ULL;
2) what if we get a new GSO encap type which's bit will be higher
   than 64?

> +
>  #endif	/* _LINUX_NETDEV_FEATURES_H */
> diff --git a/include/linux/netdev_features_helper.h b/include/linux/netdev_features_helper.h
> index 476d36352160..479d120bd8bd 100644
> --- a/include/linux/netdev_features_helper.h
> +++ b/include/linux/netdev_features_helper.h
> @@ -9,7 +9,7 @@
>  
>  static inline void netdev_features_zero(netdev_features_t *dst)
>  {
> -	*dst = 0;
> +	bitmap_zero(dst->bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  /* active_feature prefer to netdev->features */
> @@ -36,12 +36,12 @@ static inline void netdev_features_zero(netdev_features_t *dst)
>  
>  static inline void netdev_features_fill(netdev_features_t *dst)
>  {
> -	*dst = ~0ULL;
> +	bitmap_fill(dst->bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline bool netdev_features_empty(const netdev_features_t src)
>  {
> -	return src == 0;
> +	return bitmap_empty(src.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  #define netdev_active_features_empty(ndev) \
> @@ -69,7 +69,7 @@ static inline bool netdev_features_empty(const netdev_features_t src)
>  static inline bool netdev_features_equal(const netdev_features_t src1,
>  					 const netdev_features_t src2)
>  {
> -	return src1 == src2;
> +	return bitmap_equal(src1.bits, src2.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  #define netdev_active_features_equal(ndev, __features) \
> @@ -97,7 +97,10 @@ static inline bool netdev_features_equal(const netdev_features_t src1,
>  static inline netdev_features_t
>  netdev_features_and(const netdev_features_t a, const netdev_features_t b)
>  {
> -	return a & b;
> +	netdev_features_t dst;
> +
> +	bitmap_and(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
> +	return dst;

Yeah, so as I wrote previously, not a good idea to return a whole
bitmap/structure.

netdev_features_and(*dst, const *a, const *b)
{
	return bitmap_and(); // bitmap_and() actually returns useful value
}

I mean, 16 bytes (currently 8, but some new features will come
pretty shortly, I'm sure) are probably okayish, but... let's see
what other folks think, but even Linus wrote about this recently
BTW.

>  }
>  
>  #define netdev_active_features_and(ndev, __features) \
> @@ -126,63 +129,74 @@ static inline void
>  netdev_features_mask(netdev_features_t *dst,
>  			   const netdev_features_t features)
>  {
> -	*dst = netdev_features_and(*dst, features);
> +	bitmap_and(dst->bits, dst->bits, features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_active_features_mask(struct net_device *ndev,
>  			    const netdev_features_t features)
>  {
> -	ndev->features = netdev_active_features_and(ndev, features);
> +	bitmap_and(ndev->features.bits, ndev->features.bits, features.bits,
> +		   NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_hw_features_mask(struct net_device *ndev,
>  			const netdev_features_t features)
>  {
> -	ndev->hw_features = netdev_hw_features_and(ndev, features);
> +	bitmap_and(ndev->hw_features.bits, ndev->hw_features.bits,
> +		   features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_wanted_features_mask(struct net_device *ndev,
>  			    const netdev_features_t features)
>  {
> -	ndev->wanted_features = netdev_wanted_features_and(ndev, features);
> +	bitmap_and(ndev->wanted_features.bits, ndev->wanted_features.bits,
> +		   features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_vlan_features_mask(struct net_device *ndev,
>  			  const netdev_features_t features)
>  {
> -	ndev->vlan_features = netdev_vlan_features_and(ndev, features);
> +	bitmap_and(ndev->vlan_features.bits, ndev->vlan_features.bits,
> +		   features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_hw_enc_features_mask(struct net_device *ndev,
>  			    const netdev_features_t features)
>  {
> -	ndev->hw_enc_features = netdev_hw_enc_features_and(ndev, features);
> +	bitmap_and(ndev->hw_enc_features.bits, ndev->hw_enc_features.bits,
> +		   features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_mpls_features_mask(struct net_device *ndev,
>  			  const netdev_features_t features)
>  {
> -	ndev->mpls_features = netdev_mpls_features_and(ndev, features);
> +	bitmap_and(ndev->mpls_features.bits, ndev->mpls_features.bits,
> +		   features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_gso_partial_features_mask(struct net_device *ndev,
>  				 const netdev_features_t features)
>  {
> -	ndev->gso_partial_features = netdev_mpls_features_and(ndev, features);
> +	bitmap_and(ndev->gso_partial_features.bits,
> +		   ndev->gso_partial_features.bits, features.bits,
> +		   NETDEV_FEATURE_COUNT);
>  }
>  
>  /* helpers for netdev features '|' operation */
>  static inline netdev_features_t
>  netdev_features_or(const netdev_features_t a, const netdev_features_t b)
>  {
> -	return a | b;
> +	netdev_features_t dst;
> +
> +	bitmap_or(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
> +	return dst;

Same here.

>  }
>  
>  #define netdev_active_features_or(ndev, __features) \
> @@ -210,64 +224,69 @@ netdev_features_or(const netdev_features_t a, const netdev_features_t b)
>  static inline void
>  netdev_features_set(netdev_features_t *dst, const netdev_features_t features)
>  {
> -	*dst = netdev_features_or(*dst, features);
> +	bitmap_or(dst->bits, dst->bits, features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_active_features_set(struct net_device *ndev,
>  			   const netdev_features_t features)
>  {
> -	ndev->features = netdev_active_features_or(ndev, features);
> +	bitmap_or(ndev->features.bits, ndev->features.bits, features.bits,
> +		  NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_hw_features_set(struct net_device *ndev,
>  		       const netdev_features_t features)
>  {
> -	ndev->hw_features = netdev_hw_features_or(ndev, features);
> +	bitmap_or(ndev->hw_features.bits, ndev->hw_features.bits, features.bits,
> +		  NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_wanted_features_set(struct net_device *ndev,
>  			   const netdev_features_t features)
>  {
> -	ndev->wanted_features = netdev_wanted_features_or(ndev, features);
> +	bitmap_or(ndev->wanted_features.bits, ndev->wanted_features.bits,
> +		  features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_vlan_features_set(struct net_device *ndev,
>  			 const netdev_features_t features)
>  {
> -	ndev->vlan_features = netdev_vlan_features_or(ndev, features);
> +	bitmap_or(ndev->vlan_features.bits, ndev->vlan_features.bits,
> +		  features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_hw_enc_features_set(struct net_device *ndev,
>  			   const netdev_features_t features)
>  {
> -	ndev->hw_enc_features = netdev_hw_enc_features_or(ndev, features);
> +	bitmap_or(ndev->hw_enc_features.bits, ndev->hw_enc_features.bits,
> +		  features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_mpls_features_set(struct net_device *ndev,
>  			 const netdev_features_t features)
>  {
> -	ndev->mpls_features = netdev_mpls_features_or(ndev, features);
> +	bitmap_or(ndev->mpls_features.bits, ndev->mpls_features.bits,
> +		  features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_gso_partial_features_set(struct net_device *ndev,
>  				const netdev_features_t features)
>  {
> -	ndev->gso_partial_features = netdev_mpls_features_or(ndev, features);
> +	bitmap_or(ndev->gso_partial_features.bits,
> +		  ndev->gso_partial_features.bits, features.bits,
> +		  NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void netdev_feature_change(int nr, netdev_features_t *src)
>  {
> -	if (*src & __NETIF_F_BIT(nr))
> -		*src &= ~(__NETIF_F_BIT(nr));
> -	else
> -		*src |= __NETIF_F_BIT(nr);
> +	__change_bit(nr, src->bits);
>  }
>  
>  #define netdev_active_feature_change(ndev, nr) \
> @@ -295,7 +314,10 @@ static inline void netdev_feature_change(int nr, netdev_features_t *src)
>  static inline netdev_features_t
>  netdev_features_xor(const netdev_features_t a, const netdev_features_t b)
>  {
> -	return a ^ b;
> +	netdev_features_t dst;
> +
> +	bitmap_xor(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
> +	return dst;
>  }

Here as well.

>  
>  #define netdev_active_features_xor(ndev, __features) \
> @@ -323,64 +345,74 @@ netdev_features_xor(const netdev_features_t a, const netdev_features_t b)
>  static inline void
>  netdev_features_toggle(netdev_features_t *dst, const netdev_features_t features)
>  {
> -	*dst = netdev_features_xor(*dst, features);
> +	bitmap_xor(dst->bits, dst->bits, features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_active_features_toggle(struct net_device *ndev,
>  			      const netdev_features_t features)
>  {
> -	ndev->features = netdev_active_features_xor(ndev, features);
> +	bitmap_xor(ndev->features.bits, ndev->features.bits, features.bits,
> +		   NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_hw_features_toggle(struct net_device *ndev,
>  			      const netdev_features_t features)
>  {
> -	ndev->hw_features = netdev_hw_features_xor(ndev, features);
> +	bitmap_xor(ndev->hw_features.bits, ndev->hw_features.bits,
> +		   features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_wanted_features_toggle(struct net_device *ndev,
>  				  const netdev_features_t features)
>  {
> -	ndev->wanted_features = netdev_wanted_features_xor(ndev, features);
> +	bitmap_xor(ndev->wanted_features.bits, ndev->wanted_features.bits,
> +		   features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_vlan_features_toggle(struct net_device *ndev,
>  				const netdev_features_t features)
>  {
> -	ndev->vlan_features = netdev_vlan_features_xor(ndev, features);
> +	bitmap_xor(ndev->vlan_features.bits, ndev->vlan_features.bits,
> +		   features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_hw_enc_features_toggle(struct net_device *ndev,
>  			      const netdev_features_t features)
>  {
> -	ndev->hw_enc_features = netdev_hw_enc_features_xor(ndev, features);
> +	bitmap_xor(ndev->hw_enc_features.bits, ndev->hw_enc_features.bits,
> +		   features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_mpls_features_toggle(struct net_device *ndev,
>  			    const netdev_features_t features)
>  {
> -	ndev->mpls_features = netdev_mpls_features_xor(ndev, features);
> +	bitmap_xor(ndev->mpls_features.bits, ndev->mpls_features.bits,
> +		   features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_gso_partial_features_toggle(struct net_device *ndev,
>  				   const netdev_features_t features)
>  {
> -	ndev->gso_partial_features =
> -			netdev_gso_partial_features_xor(ndev, features);
> +	bitmap_xor(ndev->gso_partial_features.bits,
> +		   ndev->gso_partial_features.bits, features.bits,
> +		   NETDEV_FEATURE_COUNT);
>  }
>  
>  /* helpers for netdev features '& ~' operation */
>  static inline netdev_features_t
>  netdev_features_andnot(const netdev_features_t a, const netdev_features_t b)
>  {
> -	return a & ~b;
> +	netdev_features_t dst;
> +
> +	bitmap_andnot(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
> +	return dst;
>  }

And in all other such places.

>  
>  #define netdev_active_features_andnot(ndev, __features) \
> @@ -428,63 +460,71 @@ netdev_features_andnot(const netdev_features_t a, const netdev_features_t b)
>  static inline void
>  netdev_features_clear(netdev_features_t *dst, const netdev_features_t features)
>  {
> -	*dst = netdev_features_andnot(*dst, features);
> +	bitmap_andnot(dst->bits, dst->bits, features.bits,
> +		      NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_active_features_clear(struct net_device *ndev,
>  			     const netdev_features_t features)
>  {
> -	ndev->features = netdev_active_features_andnot(ndev, features);
> +	bitmap_andnot(ndev->features.bits, ndev->features.bits, features.bits,
> +		      NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_hw_features_clear(struct net_device *ndev,
>  			 const netdev_features_t features)
>  {
> -	ndev->hw_features = netdev_hw_features_andnot(ndev, features);
> +	bitmap_andnot(ndev->features.bits, ndev->features.bits, features.bits,
> +		      NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_wanted_features_clear(struct net_device *ndev,
>  			     const netdev_features_t features)
>  {
> -	ndev->wanted_features = netdev_wanted_features_andnot(ndev, features);
> +	bitmap_andnot(ndev->wanted_features.bits, ndev->wanted_features.bits,
> +		      features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_vlan_features_clear(struct net_device *ndev,
>  			   const netdev_features_t features)
>  {
> -	ndev->vlan_features = netdev_vlan_features_andnot(ndev, features);
> +	bitmap_andnot(ndev->vlan_features.bits, ndev->vlan_features.bits,
> +		      features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_hw_enc_features_clear(struct net_device *ndev,
>  			     const netdev_features_t features)
>  {
> -	ndev->hw_enc_features = netdev_hw_enc_features_andnot(ndev, features);
> +	bitmap_andnot(ndev->hw_enc_features.bits, ndev->hw_enc_features.bits,
> +		      features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_mpls_features_clear(struct net_device *ndev,
>  			   const netdev_features_t features)
>  {
> -	ndev->mpls_features = netdev_mpls_features_andnot(ndev, features);
> +	bitmap_andnot(ndev->mpls_features.bits, ndev->mpls_features.bits,
> +		      features.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline void
>  netdev_gso_partial_features_clear(struct net_device *ndev,
>  				  const netdev_features_t features)
>  {
> -	ndev->gso_partial_features =
> -		netdev_gso_partial_features_andnot(ndev, features);
> +	bitmap_andnot(ndev->gso_partial_features.bits,
> +		      ndev->gso_partial_features.bits, features.bits,
> +		      NETDEV_FEATURE_COUNT);
>  }
>  
>  /* helpers for netdev features 'set bit' operation */
>  static inline void netdev_feature_add(int nr, netdev_features_t *src)
>  {
> -	*src |= __NETIF_F_BIT(nr);
> +	__set_bit(nr, src->bits);
>  }
>  
>  #define netdev_active_feature_add(ndev, nr) \
> @@ -543,7 +583,7 @@ netdev_features_set_array(const struct netdev_feature_set *set,
>  /* helpers for netdev features 'clear bit' operation */
>  static inline void netdev_feature_del(int nr, netdev_features_t *src)
>  {
> -	*src &= ~__NETIF_F_BIT(nr);
> +	__clear_bit(nr, src->bits);
>  }
>  
>  #define netdev_active_feature_del(ndev, nr) \
> @@ -602,7 +642,7 @@ netdev_features_clear_array(const struct netdev_feature_set *set,
>  static inline bool netdev_features_intersects(const netdev_features_t src1,
>  					      const netdev_features_t src2)
>  {
> -	return (src1 & src2) > 0;
> +	return bitmap_intersects(src1.bits, src2.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  #define netdev_active_features_intersects(ndev, __features) \
> @@ -669,20 +709,11 @@ static inline void netdev_gso_partial_features_copy(struct net_device *ndev,
>  	ndev->gso_partial_features = src;
>  }
>  
> -/* helpers for netdev features 'get' operation */
> -#define netdev_active_features(ndev)	((ndev)->features)
> -#define netdev_hw_features(ndev)	((ndev)->hw_features)
> -#define netdev_wanted_features(ndev)	((ndev)->wanted_features)
> -#define netdev_vlan_features(ndev)	((ndev)->vlan_features)
> -#define netdev_hw_enc_features(ndev)	((ndev)->hw_enc_features)
> -#define netdev_mpls_features(ndev)	((ndev)->mpls_features)
> -#define netdev_gso_partial_features(ndev)	((ndev)->gso_partial_features)
> -
>  /* helpers for netdev features 'subset' */
>  static inline bool netdev_features_subset(const netdev_features_t src1,
>  					  const netdev_features_t src2)
>  {
> -	return (src1 & src2) == src2;
> +	return bitmap_subset(src1.bits, src2.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 4741f81fa968..11b31e512d68 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2338,7 +2338,7 @@ struct net_device {
>  /* helpers for netdev features 'test bit' operation */
>  static inline bool netdev_feature_test(int nr, const netdev_features_t src)
>  {
> -	return (src & __NETIF_F_BIT(nr)) > 0;
> +	return test_bit(nr, src.bits);
>  }
>  
>  #define netdev_active_feature_test(ndev, nr) \
> @@ -4888,7 +4888,7 @@ static inline bool net_gso_ok(netdev_features_t features, int gso_type)
>  {
>  #define GSO_INDEX(x)	((1ULL << (x)) >> NETIF_F_GSO_SHIFT)
>  
> -	netdev_features_t feature = (netdev_features_t)gso_type << NETIF_F_GSO_SHIFT;
> +	netdev_features_t feature = netdev_empty_features;
>  
>  	/* check flags correspondence */
>  	BUILD_BUG_ON(SKB_GSO_TCPV4   != GSO_INDEX(NETIF_F_TSO_BIT));
> @@ -4911,7 +4911,8 @@ static inline bool net_gso_ok(netdev_features_t features, int gso_type)
>  	BUILD_BUG_ON(SKB_GSO_UDP_L4 != GSO_INDEX(NETIF_F_GSO_UDP_L4_BIT));
>  	BUILD_BUG_ON(SKB_GSO_FRAGLIST != GSO_INDEX(NETIF_F_GSO_FRAGLIST_BIT));
>  
> -	return (features & feature) == feature;
> +	bitmap_from_u64(feature.bits, (u64)gso_type << NETIF_F_GSO_SHIFT);
> +	return bitmap_subset(features.bits, feature.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static inline bool skb_gso_ok(struct sk_buff *skb, netdev_features_t features)
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index ca8afa382bf2..2f4e6cd05754 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -3989,8 +3989,8 @@ static inline bool skb_needs_linearize(struct sk_buff *skb,
>  				       netdev_features_t features)
>  {
>  	return skb_is_nonlinear(skb) &&
> -	       ((skb_has_frag_list(skb) && !(features & NETIF_F_FRAGLIST)) ||
> -		(skb_shinfo(skb)->nr_frags && !(features & NETIF_F_SG)));
> +	       ((skb_has_frag_list(skb) && !test_bit(NETIF_F_FRAGLIST_BIT, features.bits)) ||
> +		(skb_shinfo(skb)->nr_frags && !test_bit(NETIF_F_SG_BIT, features.bits)));
>  }
>  
>  static inline void skb_copy_from_linear_data(const struct sk_buff *skb,
> diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
> index 63fac94f9ace..4cf7e596eb53 100644
> --- a/include/net/ip_tunnels.h
> +++ b/include/net/ip_tunnels.h
> @@ -447,7 +447,7 @@ static inline int iptunnel_pull_offloads(struct sk_buff *skb)
>  		err = skb_unclone(skb, GFP_ATOMIC);
>  		if (unlikely(err))
>  			return err;
> -		skb_shinfo(skb)->gso_type &= ~(NETIF_F_GSO_ENCAP_ALL >>
> +		skb_shinfo(skb)->gso_type &= ~(GSO_ENCAP_FEATURES >>
>  					       NETIF_F_GSO_SHIFT);
>  	}
>  
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 3c1853a9d1c0..d44e47681563 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1729,25 +1729,24 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
>  }
>  
>  static noinline_for_stack
> -char *netdev_bits(char *buf, char *end, const void *addr,
> +char *netdev_bits(char *buf, char *end, void *addr,
>  		  struct printf_spec spec,  const char *fmt)
>  {
> -	unsigned long long num;
> -	int size;
> +	netdev_features_t *features;

const? We're printing.

>  
>  	if (check_pointer(&buf, end, addr, spec))
>  		return buf;
>  
>  	switch (fmt[1]) {
>  	case 'F':
> -		num = *(const netdev_features_t *)addr;
> -		size = sizeof(netdev_features_t);
> +		features = (netdev_features_t *)addr;

Casts are not needed when assigning from `void *`.

> +		spec.field_width = NETDEV_FEATURE_COUNT;
>  		break;
>  	default:
>  		return error_string(buf, end, "(%pN?)", spec);
>  	}
>  
> -	return special_hex_number(buf, end, num, size);
> +	return bitmap_string(buf, end, features->bits, spec, fmt);
>  }
>  
>  static noinline_for_stack
> diff --git a/net/ethtool/features.c b/net/ethtool/features.c
> index 38efdab960ba..7650a63cb234 100644
> --- a/net/ethtool/features.c
> +++ b/net/ethtool/features.c
> @@ -27,10 +27,7 @@ const struct nla_policy ethnl_features_get_policy[] = {
>  
>  static void ethnl_features_to_bitmap32(u32 *dest, netdev_features_t src)
>  {
> -	unsigned int i;
> -
> -	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; i++)
> -		dest[i] = src >> (32 * i);
> +	bitmap_to_arr32(dest, src.bits, NETDEV_FEATURE_COUNT);
>  }
>  
>  static int features_prepare_data(const struct ethnl_req_info *req_base,
> @@ -45,7 +42,7 @@ static int features_prepare_data(const struct ethnl_req_info *req_base,
>  	ethnl_features_to_bitmap32(data->wanted, dev->wanted_features);
>  	ethnl_features_to_bitmap32(data->active, dev->features);
>  	ethnl_features_to_bitmap32(data->nochange, NETIF_F_NEVER_CHANGE);
> -	all_features = GENMASK_ULL(NETDEV_FEATURE_COUNT - 1, 0);
> +	netdev_features_fill(&all_features);
>  	ethnl_features_to_bitmap32(data->all, all_features);
>  
>  	return 0;
> @@ -131,28 +128,6 @@ const struct nla_policy ethnl_features_set_policy[] = {
>  	[ETHTOOL_A_FEATURES_WANTED]	= { .type = NLA_NESTED },
>  };
>  
> -static void ethnl_features_to_bitmap(unsigned long *dest, netdev_features_t val)
> -{
> -	const unsigned int words = BITS_TO_LONGS(NETDEV_FEATURE_COUNT);
> -	unsigned int i;
> -
> -	for (i = 0; i < words; i++)
> -		dest[i] = (unsigned long)(val >> (i * BITS_PER_LONG));
> -}
> -
> -static netdev_features_t ethnl_bitmap_to_features(unsigned long *src)
> -{
> -	const unsigned int nft_bits = sizeof(netdev_features_t) * BITS_PER_BYTE;
> -	const unsigned int words = BITS_TO_LONGS(NETDEV_FEATURE_COUNT);
> -	netdev_features_t ret = netdev_empty_features;
> -	unsigned int i;
> -
> -	for (i = 0; i < words; i++)
> -		ret |= (netdev_features_t)(src[i]) << (i * BITS_PER_LONG);
> -	ret &= ~(netdev_features_t)0 >> (nft_bits - NETDEV_FEATURE_COUNT);
> -	return ret;
> -}
> -
>  static int features_send_reply(struct net_device *dev, struct genl_info *info,
>  			       const unsigned long *wanted,
>  			       const unsigned long *wanted_mask,
> @@ -209,16 +184,16 @@ static int features_send_reply(struct net_device *dev, struct genl_info *info,
>  
>  int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
>  {
> -	DECLARE_BITMAP(wanted_diff_mask, NETDEV_FEATURE_COUNT);
> -	DECLARE_BITMAP(active_diff_mask, NETDEV_FEATURE_COUNT);
> -	DECLARE_BITMAP(old_active, NETDEV_FEATURE_COUNT);
> -	DECLARE_BITMAP(old_wanted, NETDEV_FEATURE_COUNT);
> -	DECLARE_BITMAP(new_active, NETDEV_FEATURE_COUNT);
> -	DECLARE_BITMAP(new_wanted, NETDEV_FEATURE_COUNT);
> -	DECLARE_BITMAP(req_wanted, NETDEV_FEATURE_COUNT);
> -	DECLARE_BITMAP(req_mask, NETDEV_FEATURE_COUNT);
>  	struct ethnl_req_info req_info = {};
>  	struct nlattr **tb = info->attrs;
> +	netdev_features_t wanted_diff_mask;
> +	netdev_features_t active_diff_mask;
> +	netdev_features_t old_active;
> +	netdev_features_t old_wanted;
> +	netdev_features_t new_active;
> +	netdev_features_t new_wanted;
> +	netdev_features_t req_wanted;
> +	netdev_features_t req_mask;

8 bitmaps, that can provoke frame warning to appear sooner or later.
Maybe worth to kzalloc() a chunk of heap for them here.

>  	struct net_device *dev;
>  	netdev_features_t tmp;
>  	bool mod;
> @@ -235,50 +210,47 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
>  	dev = req_info.dev;
>  
>  	rtnl_lock();
> -	ethnl_features_to_bitmap(old_active, dev->features);
> -	ethnl_features_to_bitmap(old_wanted, dev->wanted_features);
> -	ret = ethnl_parse_bitset(req_wanted, req_mask, NETDEV_FEATURE_COUNT,
> +	old_active = dev->features;
> +	old_wanted = dev->wanted_features;
> +	ret = ethnl_parse_bitset(req_wanted.bits, req_mask.bits,
> +				 NETDEV_FEATURE_COUNT,
>  				 tb[ETHTOOL_A_FEATURES_WANTED],
>  				 netdev_features_strings, info->extack);
>  	if (ret < 0)
>  		goto out_rtnl;
> -	if (ethnl_bitmap_to_features(req_mask) & ~NETIF_F_ETHTOOL_BITS) {
> +
> +	if (!netdev_features_subset(req_mask, NETIF_F_ETHTOOL_BITS)) {
>  		GENL_SET_ERR_MSG(info, "attempt to change non-ethtool features");
>  		ret = -EINVAL;
>  		goto out_rtnl;
>  	}
>  
>  	/* set req_wanted bits not in req_mask from old_wanted */
> -	bitmap_and(req_wanted, req_wanted, req_mask, NETDEV_FEATURE_COUNT);
> -	bitmap_andnot(new_wanted, old_wanted, req_mask, NETDEV_FEATURE_COUNT);
> -	bitmap_or(req_wanted, new_wanted, req_wanted, NETDEV_FEATURE_COUNT);
> -	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
> -		dev->wanted_features &= ~dev->hw_features;
> -		tmp = ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
> -		dev->wanted_features |= tmp;
> +	netdev_features_mask(&req_wanted, req_mask);
> +	new_wanted = netdev_features_andnot(old_wanted, req_mask);
> +	netdev_features_set(&req_wanted, new_wanted);
> +	if (!netdev_features_equal(req_wanted, old_wanted)) {
> +		netdev_wanted_features_clear(dev, dev->hw_features);
> +		tmp = netdev_hw_features_and(dev, req_wanted);
> +		netdev_wanted_features_set(dev, tmp);
>  		__netdev_update_features(dev);
>  	}
> -	ethnl_features_to_bitmap(new_active, dev->features);
> -	mod = !bitmap_equal(old_active, new_active, NETDEV_FEATURE_COUNT);
> +	new_active = dev->features;
> +	mod = !netdev_features_equal(old_active, new_active);
>  
>  	ret = 0;
>  	if (!(req_info.flags & ETHTOOL_FLAG_OMIT_REPLY)) {
>  		bool compact = req_info.flags & ETHTOOL_FLAG_COMPACT_BITSETS;
>  
> -		bitmap_xor(wanted_diff_mask, req_wanted, new_active,
> -			   NETDEV_FEATURE_COUNT);
> -		bitmap_xor(active_diff_mask, old_active, new_active,
> -			   NETDEV_FEATURE_COUNT);
> -		bitmap_and(wanted_diff_mask, wanted_diff_mask, req_mask,
> -			   NETDEV_FEATURE_COUNT);
> -		bitmap_and(req_wanted, req_wanted, wanted_diff_mask,
> -			   NETDEV_FEATURE_COUNT);
> -		bitmap_and(new_active, new_active, active_diff_mask,
> -			   NETDEV_FEATURE_COUNT);
> -
> -		ret = features_send_reply(dev, info, req_wanted,
> -					  wanted_diff_mask, new_active,
> -					  active_diff_mask, compact);
> +		wanted_diff_mask = netdev_features_xor(req_wanted, new_active);
> +		active_diff_mask = netdev_features_xor(old_active, new_active);
> +		netdev_features_mask(&wanted_diff_mask, req_mask);
> +		netdev_features_mask(&req_wanted, wanted_diff_mask);
> +		netdev_features_mask(&new_active, active_diff_mask);
> +
> +		ret = features_send_reply(dev, info, req_wanted.bits,
> +					  wanted_diff_mask.bits, new_active.bits,
> +					  active_diff_mask.bits, compact);
>  	}
>  	if (mod)
>  		netdev_features_change(dev);
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index e4718b24dd38..97df79c62420 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -89,6 +89,10 @@ static int ethtool_get_features(struct net_device *dev, void __user *useraddr)
>  		.size = ETHTOOL_DEV_FEATURE_WORDS,
>  	};
>  	struct ethtool_get_features_block features[ETHTOOL_DEV_FEATURE_WORDS];
> +	u32 never_changed_arr[ETHTOOL_DEV_FEATURE_WORDS];
> +	u32 wanted_arr[ETHTOOL_DEV_FEATURE_WORDS];
> +	u32 active_arr[ETHTOOL_DEV_FEATURE_WORDS];
> +	u32 hw_arr[ETHTOOL_DEV_FEATURE_WORDS];
>  	u32 __user *sizeaddr;
>  	u32 copy_size;
>  	int i;
> @@ -96,12 +100,16 @@ static int ethtool_get_features(struct net_device *dev, void __user *useraddr)
>  	/* in case feature bits run out again */
>  	BUILD_BUG_ON(ETHTOOL_DEV_FEATURE_WORDS * sizeof(u32) > sizeof(netdev_features_t));
>  
> +	bitmap_to_arr32(hw_arr, dev->hw_features.bits, NETDEV_FEATURE_COUNT);
> +	bitmap_to_arr32(wanted_arr, dev->wanted_features.bits, NETDEV_FEATURE_COUNT);
> +	bitmap_to_arr32(active_arr, dev->features.bits, NETDEV_FEATURE_COUNT);
> +	bitmap_to_arr32(never_changed_arr, netdev_never_change_features.bits,
> +			NETDEV_FEATURE_COUNT);
>  	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; ++i) {
> -		features[i].available = (u32)(dev->hw_features >> (32 * i));
> -		features[i].requested = (u32)(dev->wanted_features >> (32 * i));
> -		features[i].active = (u32)(dev->features >> (32 * i));
> -		features[i].never_changed =
> -			(u32)(NETIF_F_NEVER_CHANGE >> (32 * i));
> +		features[i].available = hw_arr[i];
> +		features[i].requested = wanted_arr[i];
> +		features[i].active = active_arr[i];
> +		features[i].never_changed = never_changed_arr[i];
>  	}
>  
>  	sizeaddr = useraddr + offsetof(struct ethtool_gfeatures, size);
> @@ -125,6 +133,8 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
>  {
>  	struct ethtool_sfeatures cmd;
>  	struct ethtool_set_features_block features[ETHTOOL_DEV_FEATURE_WORDS];
> +	u32 wanted_arr[ETHTOOL_DEV_FEATURE_WORDS];
> +	u32 valid_arr[ETHTOOL_DEV_FEATURE_WORDS];
>  	netdev_features_t wanted = netdev_empty_features;
>  	netdev_features_t valid = netdev_empty_features;
>  	netdev_features_t tmp;
> @@ -141,27 +151,29 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
>  		return -EFAULT;
>  
>  	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; ++i) {
> -		valid |= (netdev_features_t)features[i].valid << (32 * i);
> -		wanted |= (netdev_features_t)features[i].requested << (32 * i);
> +		valid_arr[i] = features[i].valid;
> +		wanted_arr[i] = features[i].requested;
>  	}
> +	bitmap_from_arr32(valid.bits, valid_arr, NETDEV_FEATURE_COUNT);
> +	bitmap_from_arr32(wanted.bits, wanted_arr, NETDEV_FEATURE_COUNT);
>  
> -	tmp = valid & ~NETIF_F_ETHTOOL_BITS;
> -	if (tmp)
> +	tmp = netdev_features_andnot(valid, NETIF_F_ETHTOOL_BITS);
> +	if (!netdev_features_empty(tmp))
>  		return -EINVAL;
>  
> -	tmp = valid & ~dev->hw_features;
> -	if (tmp) {
> -		valid &= dev->hw_features;
> +	tmp = netdev_hw_features_andnot_r(dev, valid);
> +	if (!netdev_features_empty(tmp)) {
> +		netdev_features_mask(&valid, dev->hw_features);
>  		ret |= ETHTOOL_F_UNSUPPORTED;
>  	}
>  
> -	dev->wanted_features &= ~valid;
> -	tmp = wanted & valid;
> -	dev->wanted_features |= tmp;
> +	netdev_wanted_features_clear(dev, valid);
> +	tmp = netdev_features_and(wanted, valid);
> +	netdev_wanted_features_set(dev, tmp);
>  	__netdev_update_features(dev);
>  
> -	tmp = dev->wanted_features ^ dev->features;
> -	if (tmp & valid)
> +	tmp = netdev_wanted_features_xor(dev, dev->features);
> +	if (netdev_features_intersects(tmp, valid))
>  		ret |= ETHTOOL_F_WISH;
>  
>  	return ret;
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 7a3d98473a0a..614f2e7b3eb7 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -1046,7 +1046,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  	}
>  
>  	/* Only HW csum features are currently compatible with mac80211 */
> -	if (WARN_ON(hw->netdev_features & ~MAC80211_SUPPORTED_FEATURES))
> +	if (WARN_ON(!netdev_features_empty(netdev_features_andnot(hw->netdev_features,
> +								  MAC80211_SUPPORTED_FEATURES))))
>  		return -EINVAL;
>  
>  	if (hw->max_report_rates == 0)
> -- 
> 2.33.0

That's my last review email for now. Insane amount of work, I'm glad
someone did it finally. Thanks a lot!

Olek
