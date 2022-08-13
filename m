Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B537D5917EC
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 02:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237367AbiHMA6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 20:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237218AbiHMA6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 20:58:07 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74844B4AC;
        Fri, 12 Aug 2022 17:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660352286; x=1691888286;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p0lq8pAlLxDsJstetxbWP2fNSNOWHlbrdqrjxTDoBmI=;
  b=GTdyH4YxUNR/fXSUsHPF6DDpR1y9pgFs9Pow8migDPIcLpfbELA18e+G
   XmbLbZhbixL7a9t3tbPrmVWA6NTI9/qPyDNDn7wFSSQFwD5PP/fUomOKj
   XqvfLE/x1LZfCF7Csc6A+fj5L+ITEUTUJfyvuykaGmpN4ZwoM06s+BL6I
   jThMbXkXntZL6as4Anw0NcUZmwPLfZTYxYRpjMtHicDRElTNx4jSm2XD0
   G9HGpfacmxXEnzCPTeMBShF8ClnZZja0LZ3aQlJGYatdw5eJKwduFFi1A
   /es/FrK/SWf/rZ8DyavdNuij7vT2uLHVJ02US77CCSvFwWcQ22H0tnRVV
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="271487896"
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="271487896"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 17:58:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="606098191"
Received: from lkp-server02.sh.intel.com (HELO 8745164cafc7) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 12 Aug 2022 17:58:02 -0700
Received: from kbuild by 8745164cafc7 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oMfTV-00018W-1I;
        Sat, 13 Aug 2022 00:58:01 +0000
Date:   Sat, 13 Aug 2022 08:57:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ravi Gunasekaran <r-gunasekaran@ti.com>, davem@davemloft.net
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, andrew@lunn.ch,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kishon@ti.com, vigneshr@ti.com, r-gunasekaran@ti.com
Subject: Re: [PATCH v2 net-next] net: ethernet: ti: davinci_mdio: Add
 workaround for errata i2329
Message-ID: <202208130814.216FrNfX-lkp@intel.com>
References: <20220810111345.31200-1-r-gunasekaran@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810111345.31200-1-r-gunasekaran@ti.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ravi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Ravi-Gunasekaran/net-ethernet-ti-davinci_mdio-Add-workaround-for-errata-i2329/20220810-191718
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git f86d1fbbe7858884d6754534a0afbb74fc30bc26
config: arm-randconfig-r026-20220810 (https://download.01.org/0day-ci/archive/20220813/202208130814.216FrNfX-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 5f1c7e2cc5a3c07cbc2412e851a7283c1841f520)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/intel-lab-lkp/linux/commit/c62c93111418d5468f6add98d244f0a594dbe352
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Ravi-Gunasekaran/net-ethernet-ti-davinci_mdio-Add-workaround-for-errata-i2329/20220810-191718
        git checkout c62c93111418d5468f6add98d244f0a594dbe352
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/net/ethernet/ti/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/ethernet/ti/davinci_mdio.c:548:37: error: use of undeclared identifier 'k3_mdio_socinfo'
                   soc_match_data = soc_device_match(k3_mdio_socinfo);
                                                     ^
>> drivers/net/ethernet/ti/davinci_mdio.c:553:31: error: incomplete definition of type 'struct k3_mdio_soc_data'
                           data->manual_mode = socdata->manual_mode;
                                               ~~~~~~~^
   drivers/net/ethernet/ti/davinci_mdio.c:550:17: note: forward declaration of 'struct k3_mdio_soc_data'
                           const struct k3_mdio_soc_data *socdata =
                                        ^
   2 errors generated.


vim +/k3_mdio_socinfo +548 drivers/net/ethernet/ti/davinci_mdio.c

   528	
   529	static int davinci_mdio_probe(struct platform_device *pdev)
   530	{
   531		struct mdio_platform_data *pdata = dev_get_platdata(&pdev->dev);
   532		struct device *dev = &pdev->dev;
   533		struct davinci_mdio_data *data;
   534		struct resource *res;
   535		struct phy_device *phy;
   536		int ret, addr;
   537		int autosuspend_delay_ms = -1;
   538		const struct soc_device_attribute *soc_match_data;
   539	
   540		data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
   541		if (!data)
   542			return -ENOMEM;
   543	
   544		data->manual_mode = false;
   545		data->bb_ctrl.ops = &davinci_mdiobb_ops;
   546	
   547		if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
 > 548			soc_match_data = soc_device_match(k3_mdio_socinfo);
   549			if (soc_match_data && soc_match_data->data) {
   550				const struct k3_mdio_soc_data *socdata =
   551							soc_match_data->data;
   552	
 > 553				data->manual_mode = socdata->manual_mode;
   554			}
   555		}
   556	
   557		if (data->manual_mode)
   558			data->bus = alloc_mdio_bitbang(&data->bb_ctrl);
   559		else
   560			data->bus = devm_mdiobus_alloc(dev);
   561	
   562		if (!data->bus) {
   563			dev_err(dev, "failed to alloc mii bus\n");
   564			return -ENOMEM;
   565		}
   566	
   567		if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
   568			const struct davinci_mdio_of_param *of_mdio_data;
   569	
   570			ret = davinci_mdio_probe_dt(&data->pdata, pdev);
   571			if (ret)
   572				return ret;
   573			snprintf(data->bus->id, MII_BUS_ID_SIZE, "%s", pdev->name);
   574	
   575			of_mdio_data = of_device_get_match_data(&pdev->dev);
   576			if (of_mdio_data) {
   577				autosuspend_delay_ms =
   578						of_mdio_data->autosuspend_delay_ms;
   579			}
   580		} else {
   581			data->pdata = pdata ? (*pdata) : default_pdata;
   582			snprintf(data->bus->id, MII_BUS_ID_SIZE, "%s-%x",
   583				 pdev->name, pdev->id);
   584		}
   585	
   586		data->bus->name		= dev_name(dev);
   587	
   588		if (data->manual_mode) {
   589			data->bus->read		= davinci_mdiobb_read;
   590			data->bus->write	= davinci_mdiobb_write;
   591			data->bus->reset	= davinci_mdiobb_reset;
   592	
   593			dev_info(dev, "Configuring MDIO in manual mode\n");
   594		} else {
   595			data->bus->read		= davinci_mdio_read;
   596			data->bus->write	= davinci_mdio_write;
   597			data->bus->reset	= davinci_mdio_reset;
   598			data->bus->priv		= data;
   599		}
   600		data->bus->parent	= dev;
   601	
   602		data->clk = devm_clk_get(dev, "fck");
   603		if (IS_ERR(data->clk)) {
   604			dev_err(dev, "failed to get device clock\n");
   605			return PTR_ERR(data->clk);
   606		}
   607	
   608		dev_set_drvdata(dev, data);
   609		data->dev = dev;
   610	
   611		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
   612		if (!res)
   613			return -EINVAL;
   614		data->regs = devm_ioremap(dev, res->start, resource_size(res));
   615		if (!data->regs)
   616			return -ENOMEM;
   617	
   618		davinci_mdio_init_clk(data);
   619	
   620		pm_runtime_set_autosuspend_delay(&pdev->dev, autosuspend_delay_ms);
   621		pm_runtime_use_autosuspend(&pdev->dev);
   622		pm_runtime_enable(&pdev->dev);
   623	
   624		/* register the mii bus
   625		 * Create PHYs from DT only in case if PHY child nodes are explicitly
   626		 * defined to support backward compatibility with DTs which assume that
   627		 * Davinci MDIO will always scan the bus for PHYs detection.
   628		 */
   629		if (dev->of_node && of_get_child_count(dev->of_node))
   630			data->skip_scan = true;
   631	
   632		ret = of_mdiobus_register(data->bus, dev->of_node);
   633		if (ret)
   634			goto bail_out;
   635	
   636		/* scan and dump the bus */
   637		for (addr = 0; addr < PHY_MAX_ADDR; addr++) {
   638			phy = mdiobus_get_phy(data->bus, addr);
   639			if (phy) {
   640				dev_info(dev, "phy[%d]: device %s, driver %s\n",
   641					 phy->mdio.addr, phydev_name(phy),
   642					 phy->drv ? phy->drv->name : "unknown");
   643			}
   644		}
   645	
   646		return 0;
   647	
   648	bail_out:
   649		pm_runtime_dont_use_autosuspend(&pdev->dev);
   650		pm_runtime_disable(&pdev->dev);
   651		return ret;
   652	}
   653	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
