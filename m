Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0B2EF414
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 04:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbfKEDbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 22:31:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:62298 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728910AbfKEDbl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 22:31:41 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 19:31:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,269,1569308400"; 
   d="gz'50?scan'50,208,50";a="200678972"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 04 Nov 2019 19:31:38 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iRpZC-000G4S-FY; Tue, 05 Nov 2019 11:31:38 +0800
Date:   Tue, 5 Nov 2019 11:30:35 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: [net-next:master 89/97]
 drivers/net/ethernet/ibm/emac/core.c:2901:28: error: passing argument 2 of
 'of_get_phy_mode' from incompatible pointer type
Message-ID: <201911051131.y3ZkP6Se%lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4t3iyzfjso2d55fv"
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4t3iyzfjso2d55fv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   56c1291ee48b4da2a70aa116098c2afc4a54783b
commit: 0c65b2b90d13c1deaee6449304dd367c5d4eb8ae [89/97] net: of_get_phy_mode: Change API to solve int/unit warnings
config: powerpc-fsp2_defconfig (attached as .config)
compiler: powerpc-linux-gcc (GCC) 7.4.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout 0c65b2b90d13c1deaee6449304dd367c5d4eb8ae
        # save the attached .config to linux build tree
        GCC_VERSION=7.4.0 make.cross ARCH=powerpc 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/ethernet/ibm/emac/core.c: In function 'emac_init_config':
>> drivers/net/ethernet/ibm/emac/core.c:2901:28: error: passing argument 2 of 'of_get_phy_mode' from incompatible pointer type [-Werror=incompatible-pointer-types]
     err = of_get_phy_mode(np, &dev->phy_mode);
                               ^
   In file included from drivers/net/ethernet/ibm/emac/core.c:39:0:
   include/linux/of_net.h:15:12: note: expected 'phy_interface_t * {aka enum <anonymous> *}' but argument is of type 'int *'
    extern int of_get_phy_mode(struct device_node *np, phy_interface_t *interface);
               ^~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +/of_get_phy_mode +2901 drivers/net/ethernet/ibm/emac/core.c

  2847	
  2848	static int emac_init_config(struct emac_instance *dev)
  2849	{
  2850		struct device_node *np = dev->ofdev->dev.of_node;
  2851		const void *p;
  2852		int err;
  2853	
  2854		/* Read config from device-tree */
  2855		if (emac_read_uint_prop(np, "mal-device", &dev->mal_ph, 1))
  2856			return -ENXIO;
  2857		if (emac_read_uint_prop(np, "mal-tx-channel", &dev->mal_tx_chan, 1))
  2858			return -ENXIO;
  2859		if (emac_read_uint_prop(np, "mal-rx-channel", &dev->mal_rx_chan, 1))
  2860			return -ENXIO;
  2861		if (emac_read_uint_prop(np, "cell-index", &dev->cell_index, 1))
  2862			return -ENXIO;
  2863		if (emac_read_uint_prop(np, "max-frame-size", &dev->max_mtu, 0))
  2864			dev->max_mtu = ETH_DATA_LEN;
  2865		if (emac_read_uint_prop(np, "rx-fifo-size", &dev->rx_fifo_size, 0))
  2866			dev->rx_fifo_size = 2048;
  2867		if (emac_read_uint_prop(np, "tx-fifo-size", &dev->tx_fifo_size, 0))
  2868			dev->tx_fifo_size = 2048;
  2869		if (emac_read_uint_prop(np, "rx-fifo-size-gige", &dev->rx_fifo_size_gige, 0))
  2870			dev->rx_fifo_size_gige = dev->rx_fifo_size;
  2871		if (emac_read_uint_prop(np, "tx-fifo-size-gige", &dev->tx_fifo_size_gige, 0))
  2872			dev->tx_fifo_size_gige = dev->tx_fifo_size;
  2873		if (emac_read_uint_prop(np, "phy-address", &dev->phy_address, 0))
  2874			dev->phy_address = 0xffffffff;
  2875		if (emac_read_uint_prop(np, "phy-map", &dev->phy_map, 0))
  2876			dev->phy_map = 0xffffffff;
  2877		if (emac_read_uint_prop(np, "gpcs-address", &dev->gpcs_address, 0))
  2878			dev->gpcs_address = 0xffffffff;
  2879		if (emac_read_uint_prop(np->parent, "clock-frequency", &dev->opb_bus_freq, 1))
  2880			return -ENXIO;
  2881		if (emac_read_uint_prop(np, "tah-device", &dev->tah_ph, 0))
  2882			dev->tah_ph = 0;
  2883		if (emac_read_uint_prop(np, "tah-channel", &dev->tah_port, 0))
  2884			dev->tah_port = 0;
  2885		if (emac_read_uint_prop(np, "mdio-device", &dev->mdio_ph, 0))
  2886			dev->mdio_ph = 0;
  2887		if (emac_read_uint_prop(np, "zmii-device", &dev->zmii_ph, 0))
  2888			dev->zmii_ph = 0;
  2889		if (emac_read_uint_prop(np, "zmii-channel", &dev->zmii_port, 0))
  2890			dev->zmii_port = 0xffffffff;
  2891		if (emac_read_uint_prop(np, "rgmii-device", &dev->rgmii_ph, 0))
  2892			dev->rgmii_ph = 0;
  2893		if (emac_read_uint_prop(np, "rgmii-channel", &dev->rgmii_port, 0))
  2894			dev->rgmii_port = 0xffffffff;
  2895		if (emac_read_uint_prop(np, "fifo-entry-size", &dev->fifo_entry_size, 0))
  2896			dev->fifo_entry_size = 16;
  2897		if (emac_read_uint_prop(np, "mal-burst-size", &dev->mal_burst_size, 0))
  2898			dev->mal_burst_size = 256;
  2899	
  2900		/* PHY mode needs some decoding */
> 2901		err = of_get_phy_mode(np, &dev->phy_mode);
  2902		if (err)
  2903			dev->phy_mode = PHY_INTERFACE_MODE_NA;
  2904	
  2905		/* Check EMAC version */
  2906		if (of_device_is_compatible(np, "ibm,emac4sync")) {
  2907			dev->features |= (EMAC_FTR_EMAC4 | EMAC_FTR_EMAC4SYNC);
  2908			if (of_device_is_compatible(np, "ibm,emac-460ex") ||
  2909			    of_device_is_compatible(np, "ibm,emac-460gt"))
  2910				dev->features |= EMAC_FTR_460EX_PHY_CLK_FIX;
  2911			if (of_device_is_compatible(np, "ibm,emac-405ex") ||
  2912			    of_device_is_compatible(np, "ibm,emac-405exr"))
  2913				dev->features |= EMAC_FTR_440EP_PHY_CLK_FIX;
  2914			if (of_device_is_compatible(np, "ibm,emac-apm821xx")) {
  2915				dev->features |= (EMAC_APM821XX_REQ_JUMBO_FRAME_SIZE |
  2916						  EMAC_FTR_APM821XX_NO_HALF_DUPLEX |
  2917						  EMAC_FTR_460EX_PHY_CLK_FIX);
  2918			}
  2919		} else if (of_device_is_compatible(np, "ibm,emac4")) {
  2920			dev->features |= EMAC_FTR_EMAC4;
  2921			if (of_device_is_compatible(np, "ibm,emac-440gx"))
  2922				dev->features |= EMAC_FTR_440GX_PHY_CLK_FIX;
  2923		} else {
  2924			if (of_device_is_compatible(np, "ibm,emac-440ep") ||
  2925			    of_device_is_compatible(np, "ibm,emac-440gr"))
  2926				dev->features |= EMAC_FTR_440EP_PHY_CLK_FIX;
  2927			if (of_device_is_compatible(np, "ibm,emac-405ez")) {
  2928	#ifdef CONFIG_IBM_EMAC_NO_FLOW_CTRL
  2929				dev->features |= EMAC_FTR_NO_FLOW_CONTROL_40x;
  2930	#else
  2931				printk(KERN_ERR "%pOF: Flow control not disabled!\n",
  2932						np);
  2933				return -ENXIO;
  2934	#endif
  2935			}
  2936	
  2937		}
  2938	
  2939		/* Fixup some feature bits based on the device tree */
  2940		if (of_get_property(np, "has-inverted-stacr-oc", NULL))
  2941			dev->features |= EMAC_FTR_STACR_OC_INVERT;
  2942		if (of_get_property(np, "has-new-stacr-staopc", NULL))
  2943			dev->features |= EMAC_FTR_HAS_NEW_STACR;
  2944	
  2945		/* CAB lacks the appropriate properties */
  2946		if (of_device_is_compatible(np, "ibm,emac-axon"))
  2947			dev->features |= EMAC_FTR_HAS_NEW_STACR |
  2948				EMAC_FTR_STACR_OC_INVERT;
  2949	
  2950		/* Enable TAH/ZMII/RGMII features as found */
  2951		if (dev->tah_ph != 0) {
  2952	#ifdef CONFIG_IBM_EMAC_TAH
  2953			dev->features |= EMAC_FTR_HAS_TAH;
  2954	#else
  2955			printk(KERN_ERR "%pOF: TAH support not enabled !\n", np);
  2956			return -ENXIO;
  2957	#endif
  2958		}
  2959	
  2960		if (dev->zmii_ph != 0) {
  2961	#ifdef CONFIG_IBM_EMAC_ZMII
  2962			dev->features |= EMAC_FTR_HAS_ZMII;
  2963	#else
  2964			printk(KERN_ERR "%pOF: ZMII support not enabled !\n", np);
  2965			return -ENXIO;
  2966	#endif
  2967		}
  2968	
  2969		if (dev->rgmii_ph != 0) {
  2970	#ifdef CONFIG_IBM_EMAC_RGMII
  2971			dev->features |= EMAC_FTR_HAS_RGMII;
  2972	#else
  2973			printk(KERN_ERR "%pOF: RGMII support not enabled !\n", np);
  2974			return -ENXIO;
  2975	#endif
  2976		}
  2977	
  2978		/* Read MAC-address */
  2979		p = of_get_property(np, "local-mac-address", NULL);
  2980		if (p == NULL) {
  2981			printk(KERN_ERR "%pOF: Can't find local-mac-address property\n",
  2982			       np);
  2983			return -ENXIO;
  2984		}
  2985		memcpy(dev->ndev->dev_addr, p, ETH_ALEN);
  2986	
  2987		/* IAHT and GAHT filter parameterization */
  2988		if (emac_has_feature(dev, EMAC_FTR_EMAC4SYNC)) {
  2989			dev->xaht_slots_shift = EMAC4SYNC_XAHT_SLOTS_SHIFT;
  2990			dev->xaht_width_shift = EMAC4SYNC_XAHT_WIDTH_SHIFT;
  2991		} else {
  2992			dev->xaht_slots_shift = EMAC4_XAHT_SLOTS_SHIFT;
  2993			dev->xaht_width_shift = EMAC4_XAHT_WIDTH_SHIFT;
  2994		}
  2995	
  2996		/* This should never happen */
  2997		if (WARN_ON(EMAC_XAHT_REGS(dev) > EMAC_XAHT_MAX_REGS))
  2998			return -ENXIO;
  2999	
  3000		DBG(dev, "features     : 0x%08x / 0x%08x\n", dev->features, EMAC_FTRS_POSSIBLE);
  3001		DBG(dev, "tx_fifo_size : %d (%d gige)\n", dev->tx_fifo_size, dev->tx_fifo_size_gige);
  3002		DBG(dev, "rx_fifo_size : %d (%d gige)\n", dev->rx_fifo_size, dev->rx_fifo_size_gige);
  3003		DBG(dev, "max_mtu      : %d\n", dev->max_mtu);
  3004		DBG(dev, "OPB freq     : %d\n", dev->opb_bus_freq);
  3005	
  3006		return 0;
  3007	}
  3008	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--4t3iyzfjso2d55fv
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
6PAAAA==

--4t3iyzfjso2d55fv--
