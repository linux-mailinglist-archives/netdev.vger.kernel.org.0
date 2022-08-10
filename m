Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5E458EA86
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 12:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbiHJKjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 06:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiHJKjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 06:39:40 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83ECC79686
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 03:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660127979; x=1691663979;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3VdMfPMojaLOFo1wmxjBZXV6GfMCXZsE24rME1ck0P0=;
  b=ZFoPgLXCQMr0H1kNskTsItA0usJ1esxn6fW3LI52+ntwn1LRc29DkIfe
   X+Vb942p5O6wLIZGcvfnPjt6B2+cwcyVppCGFRowoPSoYtlBQAq2Mn+Ot
   RRBQ+wyN9CsL7k+p0tqnYAJEMY+J0bK/akn5geByPCEkrZyj3KTj5ultg
   VmtBchgrRwlMoyT/fmBwRvLVY3KkZ+Hb1qBRl/MMBt6zXKJaeYh6Lrqdn
   rvpLZMey2kP2vVa9PzJpAnmJoIYIPw6FzOR5A82oOvrVKooxfBbEjidug
   aMv1CUaWrVE/TVqQRFM0zVhCoNqX3zgVbxmq5XCGIL3FNXwd+xw9Eio2O
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10434"; a="352786084"
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="352786084"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 03:39:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="708180299"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 10 Aug 2022 03:39:36 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27AAdZ9F027548;
        Wed, 10 Aug 2022 11:39:35 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        ecree.xilinx@gmail.com, hkallweit1@gmail.com, saeed@kernel.org,
        leon@kernel.org, netdev@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [RFCv7 PATCH net-next 03/36] net: replace multiple feature bits with DECLARE_NETDEV_FEATURE_SET
Date:   Wed, 10 Aug 2022 12:37:43 +0200
Message-Id: <20220810103743.1306052-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220810030624.34711-4-shenjian15@huawei.com>
References: <20220810030624.34711-1-shenjian15@huawei.com> <20220810030624.34711-4-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>
Date: Wed, 10 Aug 2022 11:05:51 +0800

> There are many netdev_features bits group used in drivers, replace them
> with DECLARE_NETDEV_FEATURE_SET, prepare to remove all the NETIF_F_XXX
> macroes.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> ---
>  arch/um/drivers/vector_transports.c           |  49 +++++--
>  drivers/infiniband/ulp/ipoib/ipoib.h          |   1 +
>  drivers/infiniband/ulp/ipoib/ipoib_main.c     |   8 +-
>  drivers/net/amt.c                             |  16 ++-
>  drivers/net/bareudp.c                         |  21 ++-
>  drivers/net/bonding/bond_main.c               |  48 +++++--
>  drivers/net/dsa/xrs700x/xrs700x.c             |  15 +-
>  drivers/net/dummy.c                           |  11 +-
>  drivers/net/ethernet/3com/typhoon.c           |  18 ++-
>  drivers/net/ethernet/aeroflex/greth.c         |   9 +-
>  drivers/net/ethernet/alteon/acenic.c          |  10 +-
>  drivers/net/ethernet/amazon/ena/ena_netdev.c  |  13 +-
>  drivers/net/ethernet/amd/xgbe/xgbe-main.c     |  59 ++++----
>  .../net/ethernet/apm/xgene/xgene_enet_main.c  |  12 +-
>  .../net/ethernet/aquantia/atlantic/aq_nic.c   |  14 +-
>  drivers/net/ethernet/asix/ax88796c_main.c     |  21 ++-
>  drivers/net/ethernet/atheros/alx/main.c       |  15 +-
>  drivers/net/ethernet/atheros/atl1c/atl1c.h    |   1 +
>  .../net/ethernet/atheros/atl1c/atl1c_main.c   |  14 +-
>  drivers/net/ethernet/atheros/atl1e/atl1e.h    |   1 +
>  .../net/ethernet/atheros/atl1e/atl1e_main.c   |  10 +-
>  drivers/net/ethernet/atheros/atlx/atl1.c      |  22 ++-
>  drivers/net/ethernet/broadcom/bcmsysport.c    |  24 +++-
>  drivers/net/ethernet/broadcom/bgmac.c         |   9 +-
>  drivers/net/ethernet/broadcom/bnx2.c          |  14 +-
>  .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  83 ++++++++---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  54 +++++--
>  .../net/ethernet/broadcom/genet/bcmgenet.c    |  10 +-
>  drivers/net/ethernet/brocade/bna/bnad.c       |  39 +++--
>  drivers/net/ethernet/calxeda/xgmac.c          |  15 +-
>  .../net/ethernet/cavium/liquidio/lio_main.c   |  42 ++++--
>  .../ethernet/cavium/liquidio/lio_vf_main.c    |  40 ++++--
>  .../ethernet/cavium/liquidio/octeon_network.h |   4 +-
>  .../net/ethernet/cavium/thunder/nicvf_main.c  |  27 +++-
>  drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  19 ++-
>  .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  29 +++-
>  .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  68 ++++++---
>  .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  39 ++++-
>  drivers/net/ethernet/cirrus/ep93xx_eth.c      |   7 +-
>  drivers/net/ethernet/cisco/enic/enic_main.c   |  19 ++-
>  drivers/net/ethernet/cortina/gemini.c         |  22 ++-
>  drivers/net/ethernet/emulex/benet/be_main.c   |  47 ++++--
>  drivers/net/ethernet/faraday/ftgmac100.c      |  13 +-
>  .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  14 +-
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  17 ++-
>  .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  10 +-
>  .../ethernet/freescale/dpaa2/dpaa2-switch.h   |   1 +
>  .../net/ethernet/freescale/enetc/enetc_pf.c   |  42 ++++--
>  .../net/ethernet/freescale/enetc/enetc_vf.c   |  40 ++++--
>  drivers/net/ethernet/freescale/fec_main.c     |  11 +-
>  drivers/net/ethernet/freescale/gianfar.c      |  18 ++-
>  .../ethernet/fungible/funeth/funeth_main.c    |  48 +++++--
>  drivers/net/ethernet/google/gve/gve_main.c    |  21 +--
>  drivers/net/ethernet/hisilicon/hns/hns_enet.c |  51 +++++--
>  .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  40 ++++--
>  .../net/ethernet/huawei/hinic/hinic_main.c    |  37 +++--
>  drivers/net/ethernet/ibm/ehea/ehea_main.c     |  34 +++--
>  drivers/net/ethernet/ibm/emac/core.c          |   7 +-
>  drivers/net/ethernet/ibm/ibmveth.c            |  11 +-
>  drivers/net/ethernet/ibm/ibmvnic.c            |   8 +-
>  drivers/net/ethernet/intel/e1000/e1000.h      |   1 +
>  drivers/net/ethernet/intel/e1000/e1000_main.c |  33 +++--
>  drivers/net/ethernet/intel/e1000e/netdev.c    |  46 ++++--
>  .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  37 +++--
>  drivers/net/ethernet/intel/i40e/i40e_main.c   |  75 +++++-----
>  drivers/net/ethernet/intel/iavf/iavf.h        |   1 +
>  drivers/net/ethernet/intel/iavf/iavf_main.c   |  43 +++---
>  drivers/net/ethernet/intel/ice/ice.h          |   1 +
>  drivers/net/ethernet/intel/ice/ice_main.c     |  64 ++++++---
>  drivers/net/ethernet/intel/igb/igb_main.c     |  74 ++++++----
>  drivers/net/ethernet/intel/igbvf/netdev.c     |  76 ++++++----
>  drivers/net/ethernet/intel/igc/igc_mac.c      |   1 +
>  drivers/net/ethernet/intel/igc/igc_main.c     |  77 ++++++----
>  drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  15 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 134 +++++++++++-------
>  drivers/net/ethernet/intel/ixgbevf/ipsec.c    |  15 +-
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf.h  |   1 +
>  .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  87 +++++++-----
>  drivers/net/ethernet/jme.c                    |  34 +++--
>  drivers/net/ethernet/marvell/mv643xx_eth.c    |   9 +-
>  drivers/net/ethernet/marvell/mvneta.c         |  12 +-
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  19 ++-
>  .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  17 ++-
>  .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  17 ++-
>  drivers/net/ethernet/marvell/skge.c           |   9 +-
>  drivers/net/ethernet/marvell/sky2.c           |  19 ++-
>  drivers/net/ethernet/mellanox/mlx4/en_main.c  |   1 +
>  .../net/ethernet/mellanox/mlx4/en_netdev.c    |  75 ++++++----
>  .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  20 +--
>  .../net/ethernet/mellanox/mlxsw/spectrum.c    |  16 ++-
>  drivers/net/ethernet/micrel/ksz884x.c         |   9 +-
>  drivers/net/ethernet/microchip/lan743x_main.c |   9 +-
>  drivers/net/ethernet/microsoft/mana/mana_en.c |  15 +-
>  drivers/net/ethernet/mscc/ocelot_net.c        |  14 +-
>  .../net/ethernet/myricom/myri10ge/myri10ge.c  |  11 +-
>  drivers/net/ethernet/neterion/s2io.c          |  24 +++-
>  drivers/net/ethernet/nvidia/forcedeth.c       |  10 +-
>  .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |  10 +-
>  drivers/net/ethernet/pasemi/pasemi_mac.c      |  11 +-
>  .../net/ethernet/pensando/ionic/ionic_lif.c   |  23 +--
>  .../ethernet/qlogic/netxen/netxen_nic_main.c  |  11 +-
>  drivers/net/ethernet/qlogic/qede/qede_main.c  |  50 +++++--
>  .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    |  29 ++--
>  .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  34 +++--
>  drivers/net/ethernet/qualcomm/emac/emac.c     |  23 ++-
>  .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  12 +-
>  drivers/net/ethernet/realtek/8139cp.c         |  23 ++-
>  drivers/net/ethernet/realtek/8139too.c        |   8 +-
>  drivers/net/ethernet/realtek/r8169_main.c     |  18 ++-
>  .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |  15 +-
>  drivers/net/ethernet/sfc/ef10.c               |  11 +-
>  drivers/net/ethernet/sfc/ef100_netdev.c       |   9 +-
>  drivers/net/ethernet/sfc/ef100_nic.c          |  15 +-
>  drivers/net/ethernet/sfc/efx.c                |  21 ++-
>  drivers/net/ethernet/sfc/falcon/efx.c         |  10 +-
>  drivers/net/ethernet/sfc/falcon/net_driver.h  |   1 +
>  drivers/net/ethernet/sfc/net_driver.h         |   1 +
>  drivers/net/ethernet/sfc/siena/efx.c          |  22 ++-
>  drivers/net/ethernet/sgi/ioc3-eth.c           |  13 +-
>  drivers/net/ethernet/silan/sc92031.c          |  11 +-
>  drivers/net/ethernet/socionext/netsec.c       |  11 +-
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  11 +-
>  drivers/net/ethernet/sun/ldmvsw.c             |   7 +-
>  drivers/net/ethernet/sun/niu.c                |   9 +-
>  drivers/net/ethernet/sun/sungem.c             |   9 +-
>  drivers/net/ethernet/sun/sunvnet.c            |  10 +-
>  drivers/net/ethernet/tehuti/tehuti.c          |  25 +++-
>  drivers/net/ethernet/tehuti/tehuti.h          |   1 +
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  13 +-
>  drivers/net/ethernet/ti/cpsw_new.c            |  11 +-
>  drivers/net/ethernet/via/via-velocity.c       |  19 ++-
>  drivers/net/geneve.c                          |  20 ++-
>  drivers/net/hyperv/netvsc_drv.c               |  11 +-
>  drivers/net/ifb.c                             |  20 ++-
>  drivers/net/ipvlan/ipvlan_main.c              |  58 ++++++--
>  drivers/net/ipvlan/ipvtap.c                   |  12 +-
>  drivers/net/loopback.c                        |  25 ++--
>  drivers/net/macsec.c                          |  22 ++-
>  drivers/net/macvlan.c                         |  56 ++++++--
>  drivers/net/macvtap.c                         |  12 +-
>  drivers/net/net_failover.c                    |  23 +++
>  drivers/net/netdevsim/ipsec.c                 |  13 +-
>  drivers/net/netdevsim/netdev.c                |  14 +-
>  drivers/net/netdevsim/netdevsim.h             |   1 +
>  drivers/net/nlmon.c                           |  11 +-
>  drivers/net/tap.c                             |  18 ++-
>  drivers/net/team/team.c                       |  31 +++-
>  drivers/net/thunderbolt.c                     |  11 +-
>  drivers/net/tun.c                             |  28 +++-
>  drivers/net/usb/aqc111.c                      |  38 ++++-
>  drivers/net/usb/aqc111.h                      |  14 --
>  drivers/net/usb/ax88179_178a.c                |  11 +-
>  drivers/net/usb/lan78xx.c                     |   8 +-
>  drivers/net/usb/r8152.c                       |  53 +++++--
>  drivers/net/usb/smsc75xx.c                    |  10 +-
>  drivers/net/veth.c                            |  27 ++--
>  drivers/net/vmxnet3/vmxnet3_drv.c             |  36 +++--
>  drivers/net/vmxnet3/vmxnet3_ethtool.c         |  35 +++--
>  drivers/net/vmxnet3/vmxnet3_int.h             |   1 +
>  drivers/net/vrf.c                             |  12 +-
>  drivers/net/vsockmon.c                        |  11 +-
>  drivers/net/vxlan/vxlan_core.c                |  20 ++-
>  drivers/net/wireguard/device.c                |  20 ++-
>  drivers/net/wireless/ath/wil6210/netdev.c     |  14 +-
>  drivers/net/xen-netback/interface.c           |  14 +-
>  drivers/net/xen-netfront.c                    |  20 ++-
>  drivers/s390/net/qeth_l3_main.c               |  13 +-
>  drivers/staging/qlge/qlge_main.c              |  21 +--
>  include/net/bonding.h                         |   5 +-
>  include/net/net_failover.h                    |   8 +-
>  net/8021q/vlan_dev.c                          |  15 +-
>  net/batman-adv/soft-interface.c               |   9 +-
>  net/bridge/br_device.c                        |  25 +++-
>  net/ethtool/ioctl.c                           |  17 ++-
>  net/hsr/hsr_device.c                          |  13 +-
>  net/ipv4/ip_gre.c                             |  19 +--
>  net/ipv4/ipip.c                               |  19 ++-
>  net/ipv6/ip6_gre.c                            |  15 +-
>  net/ipv6/ip6_tunnel.c                         |  19 ++-
>  net/ipv6/sit.c                                |  18 ++-
>  net/mac80211/ieee80211_i.h                    |  13 +-
>  net/mac80211/main.c                           |  24 ++++
>  net/openvswitch/vport-internal_dev.c          |  13 +-
>  net/xfrm/xfrm_interface.c                     |  16 ++-
>  184 files changed, 2923 insertions(+), 1139 deletions(-)

[...]

> +static DECLARE_NETDEV_FEATURE_SET(bond_mpls_feature_set,
> +				  NETIF_F_HW_CSUM_BIT,
> +				  NETIF_F_SG_BIT);
> +
> +static netdev_features_t bond_vlan_features __ro_after_init;
> +static netdev_features_t bond_enc_features __ro_after_init;
> +static netdev_features_t bond_mpls_features __ro_after_init;
>  /*-------------------------- Forward declarations ---------------------------*/

Nit: any reason to not leave an empty space in between the
declarations and that comment line?

>  
>  static int bond_init(struct net_device *bond_dev);
> @@ -1421,16 +1441,11 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
>  	return features;
>  }

[...]

>  /**
>   * struct gmac_queue_page - page buffer per-page info
> @@ -2610,6 +2618,12 @@ static struct platform_driver gemini_ethernet_driver = {
>  	.remove = gemini_ethernet_remove,
>  };
>  
> +static void __init gmac_netdev_features_init(void)
> +{
> +	netdev_features_set_array(&gmac_offload_feature_set,
> +				  &gmac_offload_features);
> +}

I'd say it's not worth it to create a new function for a one-liner.

> +
>  static int __init gemini_ethernet_module_init(void)
>  {
>  	int ret;
> @@ -2624,6 +2638,8 @@ static int __init gemini_ethernet_module_init(void)
>  		return ret;
>  	}
>  
> +	gmac_netdev_features_init();
> +
>  	return 0;
>  }
>  module_init(gemini_ethernet_module_init);

[...]

> @@ -120,16 +144,12 @@ static void enetc_vf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
>  	ndev->watchdog_timeo = 5 * HZ;
>  	ndev->max_mtu = ENETC_MAX_MTU;
>  
> -	ndev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
> -			    NETIF_F_HW_VLAN_CTAG_TX |
> -			    NETIF_F_HW_VLAN_CTAG_RX |
> -			    NETIF_F_HW_CSUM | NETIF_F_TSO | NETIF_F_TSO6;
> -	ndev->features = NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_RXCSUM |
> -			 NETIF_F_HW_VLAN_CTAG_TX |
> -			 NETIF_F_HW_VLAN_CTAG_RX |
> -			 NETIF_F_HW_CSUM | NETIF_F_TSO | NETIF_F_TSO6;
> -	ndev->vlan_features = NETIF_F_SG | NETIF_F_HW_CSUM |
> -			      NETIF_F_TSO | NETIF_F_TSO6;
> +	netdev_hw_features_zero(ndev);
> +	netdev_hw_features_set_array(ndev, &enetc_vf_hw_feature_set);

Hmm, I see that pattern

netdev*_features_zero();
netdev*_features_set_array();

pretty often, maybe create a couple static inlines like
'netdev*_features_from_array'? And use it for initializing
shared/exported netdev_features as well? Otherwise, sooner or later,
but someone will forget to zero the features before setting them and
will get a garbage and some hard-to-track bugs %)

> +	netdev_active_features_zero(ndev);
> +	netdev_active_features_set_array(ndev, &enetc_vf_feature_set);
> +	netdev_vlan_features_zero(ndev);
> +	netdev_vlan_features_set_array(ndev, &enetc_vf_vlan_feature_set);
>  
>  	if (si->num_rss)
>  		ndev->hw_features |= NETIF_F_RXHASH;
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index e8e2aa1e7f01..49850ee91d4e 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c

[...]

> +static DECLARE_NETDEV_FEATURE_SET(fun_vlan_feature_set,
> +				  NETIF_F_SG_BIT,
> +				  NETIF_F_HW_CSUM_BIT,
> +				  NETIF_F_HIGHDMA_BIT);
> +
>  static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
>  {
> +	netdev_features_t gso_encap_flags = netdev_empty_features;
> +	netdev_features_t tso_flags = netdev_empty_features;

Same here as I mentioned previously, direct assignments wouldn't
work here later for bitmaps. So it's rather bitmap_copy(), i.e.
netdev_features_copy(), or am I missing something?

>  	struct fun_dev *fdev = &ed->fdev;
> +	netdev_features_t vlan_feat;
>  	struct net_device *netdev;
>  	struct funeth_priv *fp;
>  	unsigned int ntx, nrx;

[...]

> @@ -1265,6 +1266,13 @@ static void ax88179_get_mac_addr(struct usbnet *dev)
>  			  dev->net->dev_addr);
>  }
>  
> +DECLARE_NETDEV_FEATURE_SET(ax88179_feature_set,

static?
You can use sparse to detect such places (`make C=1`).

> +			   NETIF_F_SG_BIT,
> +			   NETIF_F_IP_CSUM_BIT,
> +			   NETIF_F_IPV6_CSUM_BIT,
> +			   NETIF_F_RXCSUM_BIT,
> +			   NETIF_F_TSO_BIT);

[...]

> -- 
> 2.33.0

Thanks,
Olek
