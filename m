Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5B05501D5
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 04:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383758AbiFRCCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 22:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiFRCCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 22:02:06 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1722C6B7F6;
        Fri, 17 Jun 2022 19:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655517725; x=1687053725;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F+kquDhQYU7e9qwmycTfeZfhwHMfyYFkHaYr7abKEPM=;
  b=VLdlaQz2R+knU192d67y6qb5Ezj7j1b2dQf5C2ZNbQceMMBWqYDL9xMN
   jhtaP+DezXbUhyH2eONqqBvdAj8QdSR3oYOx333EYP31eoGvpbqcils0+
   F23amzVdgrAcwo3rhqUObX+2Yx8wXIbMWiNUZW5BGB6G9dGkZy5vXAaHc
   D/f+I+/Ie5ZZjyKtGGmcdt1Ja81NQrTd9seBYvNcD+8CF9Wt4drFh7wIg
   u28BpRQkoM5vfwVX1QyGrU8p7W1GLvEHmCDaiBK76dx90mpKgtpOF6KAj
   FVRzJOgqyRCD0UV/l/vW/c+jyz9hd6qnlMZnVjxGgh0ep6SED2ba8jGV7
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="278393422"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="278393422"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2022 19:02:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="763453615"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 17 Jun 2022 19:02:01 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o2Nmi-000Pvf-W2;
        Sat, 18 Jun 2022 02:02:00 +0000
Date:   Sat, 18 Jun 2022 10:01:06 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH net-next 18/28] net: fman: Map the base address once
Message-ID: <202206180959.mgYg6khw-lkp@intel.com>
References: <20220617203312.3799646-19-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617203312.3799646-19-sean.anderson@seco.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Sean-Anderson/net-dpaa-Convert-to-phylink/20220618-044003
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 4875d94c69d5a4836c4225b51429d277c297aae8
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220618/202206180959.mgYg6khw-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/91ca730be8451e814e919382364039413db7e5bb
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sean-Anderson/net-dpaa-Convert-to-phylink/20220618-044003
        git checkout 91ca730be8451e814e919382364039413db7e5bb
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash drivers/net/ethernet/freescale/fman/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/freescale/fman/mac.c: In function 'mac_exception':
   drivers/net/ethernet/freescale/fman/mac.c:48:34: warning: variable 'priv' set but not used [-Wunused-but-set-variable]
      48 |         struct mac_priv_s       *priv;
         |                                  ^~~~
   drivers/net/ethernet/freescale/fman/mac.c: In function 'mac_probe':
>> drivers/net/ethernet/freescale/fman/mac.c:387:30: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     387 |         mac_dev->vaddr_end = (void *)res->end;
         |                              ^


vim +387 drivers/net/ethernet/freescale/fman/mac.c

   297	
   298	static int mac_probe(struct platform_device *_of_dev)
   299	{
   300		int			 err, i, nph;
   301		int (*init)(struct mac_device *mac_dev, struct device_node *mac_node);
   302		struct device		*dev;
   303		struct device_node	*mac_node, *dev_node;
   304		struct mac_device	*mac_dev;
   305		struct platform_device	*of_dev;
   306		struct resource		*res;
   307		struct mac_priv_s	*priv;
   308		u32			 val;
   309		u8			fman_id;
   310		phy_interface_t          phy_if;
   311	
   312		dev = &_of_dev->dev;
   313		mac_node = dev->of_node;
   314		init = of_device_get_match_data(dev);
   315	
   316		mac_dev = devm_kzalloc(dev, sizeof(*mac_dev), GFP_KERNEL);
   317		if (!mac_dev) {
   318			err = -ENOMEM;
   319			goto _return;
   320		}
   321		priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
   322		if (!priv) {
   323			err = -ENOMEM;
   324			goto _return;
   325		}
   326	
   327		/* Save private information */
   328		mac_dev->priv = priv;
   329		mac_dev->dev = dev;
   330	
   331		INIT_LIST_HEAD(&priv->mc_addr_list);
   332	
   333		/* Get the FM node */
   334		dev_node = of_get_parent(mac_node);
   335		if (!dev_node) {
   336			dev_err(dev, "of_get_parent(%pOF) failed\n",
   337				mac_node);
   338			err = -EINVAL;
   339			goto _return_of_node_put;
   340		}
   341	
   342		of_dev = of_find_device_by_node(dev_node);
   343		if (!of_dev) {
   344			dev_err(dev, "of_find_device_by_node(%pOF) failed\n", dev_node);
   345			err = -EINVAL;
   346			goto _return_of_node_put;
   347		}
   348	
   349		/* Get the FMan cell-index */
   350		err = of_property_read_u32(dev_node, "cell-index", &val);
   351		if (err) {
   352			dev_err(dev, "failed to read cell-index for %pOF\n", dev_node);
   353			err = -EINVAL;
   354			goto _return_of_node_put;
   355		}
   356		/* cell-index 0 => FMan id 1 */
   357		fman_id = (u8)(val + 1);
   358	
   359		priv->fman = fman_bind(&of_dev->dev);
   360		if (!priv->fman) {
   361			dev_err(dev, "fman_bind(%pOF) failed\n", dev_node);
   362			err = -ENODEV;
   363			goto _return_of_node_put;
   364		}
   365	
   366		of_node_put(dev_node);
   367	
   368		/* Get the address of the memory mapped registers */
   369		res = platform_get_mem_or_io(_of_dev, 0);
   370		if (!res) {
   371			dev_err(dev, "could not get registers\n");
   372			return -EINVAL;
   373		}
   374	
   375		err = devm_request_resource(dev, fman_get_mem_region(priv->fman), res);
   376		if (err) {
   377			dev_err_probe(dev, err, "could not request resource\n");
   378			goto _return_of_node_put;
   379		}
   380	
   381		mac_dev->vaddr = devm_ioremap(dev, res->start, resource_size(res));
   382		if (!mac_dev->vaddr) {
   383			dev_err(dev, "devm_ioremap() failed\n");
   384			err = -EIO;
   385			goto _return_of_node_put;
   386		}
 > 387		mac_dev->vaddr_end = (void *)res->end;
   388	
   389		if (!of_device_is_available(mac_node)) {
   390			err = -ENODEV;
   391			goto _return_of_node_put;
   392		}
   393	
   394		/* Get the cell-index */
   395		err = of_property_read_u32(mac_node, "cell-index", &val);
   396		if (err) {
   397			dev_err(dev, "failed to read cell-index for %pOF\n", mac_node);
   398			err = -EINVAL;
   399			goto _return_of_node_put;
   400		}
   401		priv->cell_index = (u8)val;
   402	
   403		/* Get the MAC address */
   404		err = of_get_mac_address(mac_node, mac_dev->addr);
   405		if (err)
   406			dev_warn(dev, "of_get_mac_address(%pOF) failed\n", mac_node);
   407	
   408		/* Get the port handles */
   409		nph = of_count_phandle_with_args(mac_node, "fsl,fman-ports", NULL);
   410		if (unlikely(nph < 0)) {
   411			dev_err(dev, "of_count_phandle_with_args(%pOF, fsl,fman-ports) failed\n",
   412				mac_node);
   413			err = nph;
   414			goto _return_of_node_put;
   415		}
   416	
   417		if (nph != ARRAY_SIZE(mac_dev->port)) {
   418			dev_err(dev, "Not supported number of fman-ports handles of mac node %pOF from device tree\n",
   419				mac_node);
   420			err = -EINVAL;
   421			goto _return_of_node_put;
   422		}
   423	
   424		for (i = 0; i < ARRAY_SIZE(mac_dev->port); i++) {
   425			/* Find the port node */
   426			dev_node = of_parse_phandle(mac_node, "fsl,fman-ports", i);
   427			if (!dev_node) {
   428				dev_err(dev, "of_parse_phandle(%pOF, fsl,fman-ports) failed\n",
   429					mac_node);
   430				err = -EINVAL;
   431				goto _return_of_node_put;
   432			}
   433	
   434			of_dev = of_find_device_by_node(dev_node);
   435			if (!of_dev) {
   436				dev_err(dev, "of_find_device_by_node(%pOF) failed\n",
   437					dev_node);
   438				err = -EINVAL;
   439				goto _return_of_node_put;
   440			}
   441	
   442			mac_dev->port[i] = fman_port_bind(&of_dev->dev);
   443			if (!mac_dev->port[i]) {
   444				dev_err(dev, "dev_get_drvdata(%pOF) failed\n",
   445					dev_node);
   446				err = -EINVAL;
   447				goto _return_of_node_put;
   448			}
   449			of_node_put(dev_node);
   450		}
   451	
   452		/* Get the PHY connection type */
   453		err = of_get_phy_mode(mac_node, &phy_if);
   454		if (err) {
   455			dev_warn(dev,
   456				 "of_get_phy_mode() for %pOF failed. Defaulting to SGMII\n",
   457				 mac_node);
   458			phy_if = PHY_INTERFACE_MODE_SGMII;
   459		}
   460		mac_dev->phy_if = phy_if;
   461	
   462		priv->speed		= phy2speed[mac_dev->phy_if];
   463		priv->max_speed		= priv->speed;
   464		mac_dev->if_support	= DTSEC_SUPPORTED;
   465		/* We don't support half-duplex in SGMII mode */
   466		if (mac_dev->phy_if == PHY_INTERFACE_MODE_SGMII)
   467			mac_dev->if_support &= ~(SUPPORTED_10baseT_Half |
   468						SUPPORTED_100baseT_Half);
   469	
   470		/* Gigabit support (no half-duplex) */
   471		if (priv->max_speed == 1000)
   472			mac_dev->if_support |= SUPPORTED_1000baseT_Full;
   473	
   474		/* The 10G interface only supports one mode */
   475		if (mac_dev->phy_if == PHY_INTERFACE_MODE_XGMII)
   476			mac_dev->if_support = SUPPORTED_10000baseT_Full;
   477	
   478		/* Get the rest of the PHY information */
   479		mac_dev->phy_node = of_parse_phandle(mac_node, "phy-handle", 0);
   480	
   481		err = init(mac_dev, mac_node);
   482		if (err < 0) {
   483			dev_err(dev, "mac_dev->init() = %d\n", err);
   484			of_node_put(mac_dev->phy_node);
   485			goto _return_of_node_put;
   486		}
   487	
   488		/* pause frame autonegotiation enabled */
   489		mac_dev->autoneg_pause = true;
   490	
   491		/* By intializing the values to false, force FMD to enable PAUSE frames
   492		 * on RX and TX
   493		 */
   494		mac_dev->rx_pause_req = true;
   495		mac_dev->tx_pause_req = true;
   496		mac_dev->rx_pause_active = false;
   497		mac_dev->tx_pause_active = false;
   498		err = fman_set_mac_active_pause(mac_dev, true, true);
   499		if (err < 0)
   500			dev_err(dev, "fman_set_mac_active_pause() = %d\n", err);
   501	
   502		if (!is_zero_ether_addr(mac_dev->addr))
   503			dev_info(dev, "FMan MAC address: %pM\n", mac_dev->addr);
   504	
   505		priv->eth_dev = dpaa_eth_add_device(fman_id, mac_dev);
   506		if (IS_ERR(priv->eth_dev)) {
   507			dev_err(dev, "failed to add Ethernet platform device for MAC %d\n",
   508				priv->cell_index);
   509			priv->eth_dev = NULL;
   510		}
   511	
   512		goto _return;
   513	
   514	_return_of_node_put:
   515		of_node_put(dev_node);
   516	_return:
   517		return err;
   518	}
   519	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
