Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3533158EAD8
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 13:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbiHJLAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 07:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbiHJLAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 07:00:30 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D852167C2
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 04:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660129225; x=1691665225;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wE5jdbVQDsSfAL8EjrFbwM/BDn5/PkL6c600zUNW6R4=;
  b=ml1t73CUzkLn4MS0Nj1wDoSy3ej550pmbWztAnf0ilEFwtlKbTSb95k3
   xk9VPhorLi0UlPxrylHOVHL39ttdOM4JuaVPktK7wleL1t1B/YGW+hJ3x
   v9eDHw0JBieHDmFUB0OUeGLeTVKGVCVlkwlrd4Cu6xNbdQlOfbQ8R8f7I
   SzHi2TvAcyLgPOlbOcSTqp2kaZOknz09FVZHqPmAF3R5Y8GuNS6ZAnQJK
   86C9Woj4QfP2reaC63TT9KVUFi0W4S5IEGt/BMk+fssm/RigFLp5QizHM
   DO/qHFGNk/eb5v0U642cB6EF1OKTkI8ZLvnUwutMJjCfhIq35QmF8uyuI
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10434"; a="274108187"
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="274108187"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 04:00:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="638070398"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 10 Aug 2022 04:00:22 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27AB0LrY001104;
        Wed, 10 Aug 2022 12:00:21 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        ecree.xilinx@gmail.com, hkallweit1@gmail.com, saeed@kernel.org,
        leon@kernel.org, netdev@vger.kernel.org, linuxarm@openeuler.org
Subject: [RFCv7 PATCH net-next 17/36] treewide: adjust features initialization
Date:   Wed, 10 Aug 2022 12:58:31 +0200
Message-Id: <20220810105831.1307150-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220810030624.34711-18-shenjian15@huawei.com>
References: <20220810030624.34711-1-shenjian15@huawei.com> <20220810030624.34711-18-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>
Date: Wed, 10 Aug 2022 11:06:05 +0800

> There are many direclty single bit assignment to netdev features.
> Adjust these expressions, so can use netdev features helpers later.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> ---
>  arch/um/drivers/vector_kern.c                       | 5 ++++-
>  drivers/firewire/net.c                              | 4 +++-
>  drivers/infiniband/hw/hfi1/vnic_main.c              | 4 +++-
>  drivers/misc/sgi-xp/xpnet.c                         | 3 ++-
>  drivers/net/can/dev/dev.c                           | 4 +++-
>  drivers/net/ethernet/alacritech/slicoss.c           | 4 +++-
>  drivers/net/ethernet/amd/xgbe/xgbe-drv.c            | 4 +++-
>  drivers/net/ethernet/aquantia/atlantic/aq_nic.c     | 3 ++-
>  drivers/net/ethernet/atheros/atlx/atl2.c            | 4 +++-
>  drivers/net/ethernet/cadence/macb_main.c            | 4 +++-
>  drivers/net/ethernet/davicom/dm9000.c               | 4 +++-
>  drivers/net/ethernet/engleder/tsnep_main.c          | 4 +++-
>  drivers/net/ethernet/ibm/ibmveth.c                  | 3 ++-
>  drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 4 +++-
>  drivers/net/ethernet/mellanox/mlx4/en_netdev.c      | 3 ++-
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 4 +++-
>  drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 7 +++++--
>  drivers/net/ethernet/netronome/nfp/nfp_net_repr.c   | 3 ++-
>  drivers/net/ethernet/ni/nixge.c                     | 4 +++-
>  drivers/net/ethernet/renesas/sh_eth.c               | 6 ++++--
>  drivers/net/ethernet/sun/sunhme.c                   | 7 +++++--
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c        | 6 ++++--
>  drivers/net/ethernet/toshiba/spider_net.c           | 3 ++-
>  drivers/net/ethernet/tundra/tsi108_eth.c            | 3 ++-
>  drivers/net/ethernet/xilinx/ll_temac_main.c         | 4 +++-
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c   | 4 +++-
>  drivers/net/hamradio/bpqether.c                     | 4 +++-
>  drivers/net/hyperv/netvsc_drv.c                     | 3 ++-
>  drivers/net/ipa/ipa_modem.c                         | 4 +++-
>  drivers/net/ntb_netdev.c                            | 4 +++-
>  drivers/net/rionet.c                                | 4 +++-
>  drivers/net/tap.c                                   | 2 +-
>  drivers/net/thunderbolt.c                           | 3 ++-
>  drivers/net/usb/smsc95xx.c                          | 4 +++-
>  drivers/net/virtio_net.c                            | 4 +++-
>  drivers/net/wireless/ath/ath10k/mac.c               | 7 +++++--
>  drivers/net/wireless/ath/ath11k/mac.c               | 4 +++-
>  drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c   | 4 +++-
>  drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   | 4 +++-
>  drivers/net/wireless/mediatek/mt76/mt7615/init.c    | 4 +++-
>  drivers/net/wireless/mediatek/mt76/mt7915/init.c    | 4 +++-
>  drivers/net/wireless/mediatek/mt76/mt7921/init.c    | 4 +++-
>  drivers/net/wwan/t7xx/t7xx_netdev.c                 | 4 +++-
>  drivers/s390/net/qeth_core_main.c                   | 7 +++++--
>  include/net/udp.h                                   | 4 +++-
>  net/phonet/pep-gprs.c                               | 4 +++-
>  46 files changed, 138 insertions(+), 52 deletions(-)
> 
> diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
> index 1d59522a50d8..d797758850e1 100644
> --- a/arch/um/drivers/vector_kern.c
> +++ b/arch/um/drivers/vector_kern.c
> @@ -1628,7 +1628,10 @@ static void vector_eth_configure(
>  		.bpf			= NULL
>  	});
>  
> -	dev->features = dev->hw_features = (NETIF_F_SG | NETIF_F_FRAGLIST);
> +	netdev_active_features_zero(dev);
> +	dev->features |= NETIF_F_SG;
> +	dev->features |= NETIF_F_FRAGLIST;
> +	dev->features = dev->hw_features;

I think a new helper can be useful there and in a couple other
places, which would set or clear an array of bits taking them as
varargs:

#define __netdev_features_set_set(feat, uniq, ...) ({	\
	DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
	netdev_features_set_array(feat, &(uniq));	\
})
#define netdev_features_set_set(feat, ...)		\
	__smth(feat, __UNIQUE_ID(feat_set), __VA_ARGS__)

(name is a placeholder)

so that you can do

	netdev_active_features_zero(dev);
	netdev_features_set_set(dev->features, NETIF_F_SG, NETIF_F_FRAGLIST);

in one take. I think it looks elegant, doesn't it?

>  	INIT_WORK(&vp->reset_tx, vector_reset_tx);
>  
>  	timer_setup(&vp->tl, vector_timer_expire, 0);

[...]

> -- 
> 2.33.0

Thanks,
Olek
