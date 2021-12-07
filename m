Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6AF546C4B9
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 21:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236948AbhLGUjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 15:39:47 -0500
Received: from mga03.intel.com ([134.134.136.65]:23813 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231583AbhLGUjq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 15:39:46 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="237625392"
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="237625392"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 12:36:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="600308120"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Dec 2021 12:36:13 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1muhC8-000MwI-GV; Tue, 07 Dec 2021 20:36:12 +0000
Date:   Wed, 8 Dec 2021 04:36:05 +0800
From:   kernel test robot <lkp@intel.com>
To:     Qing Wang <wangqing@vivo.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, Wang Qing <wangqing@vivo.com>
Subject: Re: [PATCH] ethernet: fman: add missing put_device() call in
 fman_port_probe()
Message-ID: <202112080417.7Js3IaI3-lkp@intel.com>
References: <1638881746-3215-1-git-send-email-wangqing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638881746-3215-1-git-send-email-wangqing@vivo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Qing,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master horms-ipvs/master linus/master v5.16-rc4 next-20211207]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Qing-Wang/ethernet-fman-add-missing-put_device-call-in-fman_port_probe/20211207-210146
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 1c5526968e270e4efccfa1da21d211a4915cdeda
config: hexagon-buildonly-randconfig-r005-20211207 (https://download.01.org/0day-ci/archive/20211208/202112080417.7Js3IaI3-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 097a1cb1d5ebb3a0ec4bcaed8ba3ff6a8e33c00a)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/72dfcb1946c5b8a0eca2806c574922ebbd990b49
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Qing-Wang/ethernet-fman-add-missing-put_device-call-in-fman_port_probe/20211207-210146
        git checkout 72dfcb1946c5b8a0eca2806c574922ebbd990b49
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/net/ethernet/freescale/fman/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/freescale/fman/fman_port.c:1903:1: warning: unused label 'free_port' [-Wunused-label]
   free_port:
   ^~~~~~~~~~
   1 warning generated.


vim +/free_port +1903 drivers/net/ethernet/freescale/fman/fman_port.c

880f874cf50568 Yangbo Lu         2018-06-25  1767  
18a6c85fcc78dd Igal Liberman     2015-12-21  1768  static int fman_port_probe(struct platform_device *of_dev)
18a6c85fcc78dd Igal Liberman     2015-12-21  1769  {
18a6c85fcc78dd Igal Liberman     2015-12-21  1770  	struct fman_port *port;
18a6c85fcc78dd Igal Liberman     2015-12-21  1771  	struct fman *fman;
18a6c85fcc78dd Igal Liberman     2015-12-21  1772  	struct device_node *fm_node, *port_node;
0572054617f326 Florinel Iordache 2020-08-03  1773  	struct platform_device *fm_pdev;
18a6c85fcc78dd Igal Liberman     2015-12-21  1774  	struct resource res;
18a6c85fcc78dd Igal Liberman     2015-12-21  1775  	struct resource *dev_res;
537a31658f8a01 Madalin Bucur     2016-05-16  1776  	u32 val;
18a6c85fcc78dd Igal Liberman     2015-12-21  1777  	int err = 0, lenp;
18a6c85fcc78dd Igal Liberman     2015-12-21  1778  	enum fman_port_type port_type;
18a6c85fcc78dd Igal Liberman     2015-12-21  1779  	u16 port_speed;
18a6c85fcc78dd Igal Liberman     2015-12-21  1780  	u8 port_id;
18a6c85fcc78dd Igal Liberman     2015-12-21  1781  
18a6c85fcc78dd Igal Liberman     2015-12-21  1782  	port = kzalloc(sizeof(*port), GFP_KERNEL);
18a6c85fcc78dd Igal Liberman     2015-12-21  1783  	if (!port)
18a6c85fcc78dd Igal Liberman     2015-12-21  1784  		return -ENOMEM;
18a6c85fcc78dd Igal Liberman     2015-12-21  1785  
18a6c85fcc78dd Igal Liberman     2015-12-21  1786  	port->dev = &of_dev->dev;
18a6c85fcc78dd Igal Liberman     2015-12-21  1787  
18a6c85fcc78dd Igal Liberman     2015-12-21  1788  	port_node = of_node_get(of_dev->dev.of_node);
18a6c85fcc78dd Igal Liberman     2015-12-21  1789  
18a6c85fcc78dd Igal Liberman     2015-12-21  1790  	/* Get the FM node */
18a6c85fcc78dd Igal Liberman     2015-12-21  1791  	fm_node = of_get_parent(port_node);
18a6c85fcc78dd Igal Liberman     2015-12-21  1792  	if (!fm_node) {
18a6c85fcc78dd Igal Liberman     2015-12-21  1793  		dev_err(port->dev, "%s: of_get_parent() failed\n", __func__);
18a6c85fcc78dd Igal Liberman     2015-12-21  1794  		err = -ENODEV;
72dfcb1946c5b8 Wang Qing         2021-12-07  1795  		goto return_of_node_put;
18a6c85fcc78dd Igal Liberman     2015-12-21  1796  	}
18a6c85fcc78dd Igal Liberman     2015-12-21  1797  
0572054617f326 Florinel Iordache 2020-08-03  1798  	fm_pdev = of_find_device_by_node(fm_node);
18a6c85fcc78dd Igal Liberman     2015-12-21  1799  	of_node_put(fm_node);
0572054617f326 Florinel Iordache 2020-08-03  1800  	if (!fm_pdev) {
0572054617f326 Florinel Iordache 2020-08-03  1801  		err = -EINVAL;
72dfcb1946c5b8 Wang Qing         2021-12-07  1802  		goto return_of_node_put;
0572054617f326 Florinel Iordache 2020-08-03  1803  	}
0572054617f326 Florinel Iordache 2020-08-03  1804  
0572054617f326 Florinel Iordache 2020-08-03  1805  	fman = dev_get_drvdata(&fm_pdev->dev);
18a6c85fcc78dd Igal Liberman     2015-12-21  1806  	if (!fman) {
18a6c85fcc78dd Igal Liberman     2015-12-21  1807  		err = -EINVAL;
72dfcb1946c5b8 Wang Qing         2021-12-07  1808  		goto return_of_put_device;
18a6c85fcc78dd Igal Liberman     2015-12-21  1809  	}
18a6c85fcc78dd Igal Liberman     2015-12-21  1810  
537a31658f8a01 Madalin Bucur     2016-05-16  1811  	err = of_property_read_u32(port_node, "cell-index", &val);
537a31658f8a01 Madalin Bucur     2016-05-16  1812  	if (err) {
f7ce91038d5278 Rob Herring       2017-07-18  1813  		dev_err(port->dev, "%s: reading cell-index for %pOF failed\n",
f7ce91038d5278 Rob Herring       2017-07-18  1814  			__func__, port_node);
18a6c85fcc78dd Igal Liberman     2015-12-21  1815  		err = -EINVAL;
72dfcb1946c5b8 Wang Qing         2021-12-07  1816  		goto return_of_put_device;
18a6c85fcc78dd Igal Liberman     2015-12-21  1817  	}
537a31658f8a01 Madalin Bucur     2016-05-16  1818  	port_id = (u8)val;
18a6c85fcc78dd Igal Liberman     2015-12-21  1819  	port->dts_params.id = port_id;
18a6c85fcc78dd Igal Liberman     2015-12-21  1820  
18a6c85fcc78dd Igal Liberman     2015-12-21  1821  	if (of_device_is_compatible(port_node, "fsl,fman-v3-port-tx")) {
18a6c85fcc78dd Igal Liberman     2015-12-21  1822  		port_type = FMAN_PORT_TYPE_TX;
18a6c85fcc78dd Igal Liberman     2015-12-21  1823  		port_speed = 1000;
537a31658f8a01 Madalin Bucur     2016-05-16  1824  		if (of_find_property(port_node, "fsl,fman-10g-port", &lenp))
18a6c85fcc78dd Igal Liberman     2015-12-21  1825  			port_speed = 10000;
18a6c85fcc78dd Igal Liberman     2015-12-21  1826  
18a6c85fcc78dd Igal Liberman     2015-12-21  1827  	} else if (of_device_is_compatible(port_node, "fsl,fman-v2-port-tx")) {
18a6c85fcc78dd Igal Liberman     2015-12-21  1828  		if (port_id >= TX_10G_PORT_BASE)
18a6c85fcc78dd Igal Liberman     2015-12-21  1829  			port_speed = 10000;
18a6c85fcc78dd Igal Liberman     2015-12-21  1830  		else
18a6c85fcc78dd Igal Liberman     2015-12-21  1831  			port_speed = 1000;
18a6c85fcc78dd Igal Liberman     2015-12-21  1832  		port_type = FMAN_PORT_TYPE_TX;
18a6c85fcc78dd Igal Liberman     2015-12-21  1833  
18a6c85fcc78dd Igal Liberman     2015-12-21  1834  	} else if (of_device_is_compatible(port_node, "fsl,fman-v3-port-rx")) {
18a6c85fcc78dd Igal Liberman     2015-12-21  1835  		port_type = FMAN_PORT_TYPE_RX;
18a6c85fcc78dd Igal Liberman     2015-12-21  1836  		port_speed = 1000;
537a31658f8a01 Madalin Bucur     2016-05-16  1837  		if (of_find_property(port_node, "fsl,fman-10g-port", &lenp))
18a6c85fcc78dd Igal Liberman     2015-12-21  1838  			port_speed = 10000;
18a6c85fcc78dd Igal Liberman     2015-12-21  1839  
18a6c85fcc78dd Igal Liberman     2015-12-21  1840  	} else if (of_device_is_compatible(port_node, "fsl,fman-v2-port-rx")) {
18a6c85fcc78dd Igal Liberman     2015-12-21  1841  		if (port_id >= RX_10G_PORT_BASE)
18a6c85fcc78dd Igal Liberman     2015-12-21  1842  			port_speed = 10000;
18a6c85fcc78dd Igal Liberman     2015-12-21  1843  		else
18a6c85fcc78dd Igal Liberman     2015-12-21  1844  			port_speed = 1000;
18a6c85fcc78dd Igal Liberman     2015-12-21  1845  		port_type = FMAN_PORT_TYPE_RX;
18a6c85fcc78dd Igal Liberman     2015-12-21  1846  
18a6c85fcc78dd Igal Liberman     2015-12-21  1847  	}  else {
18a6c85fcc78dd Igal Liberman     2015-12-21  1848  		dev_err(port->dev, "%s: Illegal port type\n", __func__);
18a6c85fcc78dd Igal Liberman     2015-12-21  1849  		err = -EINVAL;
72dfcb1946c5b8 Wang Qing         2021-12-07  1850  		goto return_of_put_device;
18a6c85fcc78dd Igal Liberman     2015-12-21  1851  	}
18a6c85fcc78dd Igal Liberman     2015-12-21  1852  
18a6c85fcc78dd Igal Liberman     2015-12-21  1853  	port->dts_params.type = port_type;
18a6c85fcc78dd Igal Liberman     2015-12-21  1854  	port->dts_params.speed = port_speed;
18a6c85fcc78dd Igal Liberman     2015-12-21  1855  
18a6c85fcc78dd Igal Liberman     2015-12-21  1856  	if (port_type == FMAN_PORT_TYPE_TX) {
18a6c85fcc78dd Igal Liberman     2015-12-21  1857  		u32 qman_channel_id;
18a6c85fcc78dd Igal Liberman     2015-12-21  1858  
18a6c85fcc78dd Igal Liberman     2015-12-21  1859  		qman_channel_id = fman_get_qman_channel_id(fman, port_id);
18a6c85fcc78dd Igal Liberman     2015-12-21  1860  		if (qman_channel_id == 0) {
18a6c85fcc78dd Igal Liberman     2015-12-21  1861  			dev_err(port->dev, "%s: incorrect qman-channel-id\n",
18a6c85fcc78dd Igal Liberman     2015-12-21  1862  				__func__);
18a6c85fcc78dd Igal Liberman     2015-12-21  1863  			err = -EINVAL;
72dfcb1946c5b8 Wang Qing         2021-12-07  1864  			goto return_of_put_device;
18a6c85fcc78dd Igal Liberman     2015-12-21  1865  		}
18a6c85fcc78dd Igal Liberman     2015-12-21  1866  		port->dts_params.qman_channel_id = qman_channel_id;
18a6c85fcc78dd Igal Liberman     2015-12-21  1867  	}
18a6c85fcc78dd Igal Liberman     2015-12-21  1868  
18a6c85fcc78dd Igal Liberman     2015-12-21  1869  	err = of_address_to_resource(port_node, 0, &res);
18a6c85fcc78dd Igal Liberman     2015-12-21  1870  	if (err < 0) {
18a6c85fcc78dd Igal Liberman     2015-12-21  1871  		dev_err(port->dev, "%s: of_address_to_resource() failed\n",
18a6c85fcc78dd Igal Liberman     2015-12-21  1872  			__func__);
18a6c85fcc78dd Igal Liberman     2015-12-21  1873  		err = -ENOMEM;
72dfcb1946c5b8 Wang Qing         2021-12-07  1874  		goto return_of_put_device;
18a6c85fcc78dd Igal Liberman     2015-12-21  1875  	}
18a6c85fcc78dd Igal Liberman     2015-12-21  1876  
18a6c85fcc78dd Igal Liberman     2015-12-21  1877  	port->dts_params.fman = fman;
18a6c85fcc78dd Igal Liberman     2015-12-21  1878  
18a6c85fcc78dd Igal Liberman     2015-12-21  1879  	dev_res = __devm_request_region(port->dev, &res, res.start,
18a6c85fcc78dd Igal Liberman     2015-12-21  1880  					resource_size(&res), "fman-port");
18a6c85fcc78dd Igal Liberman     2015-12-21  1881  	if (!dev_res) {
18a6c85fcc78dd Igal Liberman     2015-12-21  1882  		dev_err(port->dev, "%s: __devm_request_region() failed\n",
18a6c85fcc78dd Igal Liberman     2015-12-21  1883  			__func__);
18a6c85fcc78dd Igal Liberman     2015-12-21  1884  		err = -EINVAL;
72dfcb1946c5b8 Wang Qing         2021-12-07  1885  		goto return_of_put_device;
18a6c85fcc78dd Igal Liberman     2015-12-21  1886  	}
18a6c85fcc78dd Igal Liberman     2015-12-21  1887  
18a6c85fcc78dd Igal Liberman     2015-12-21  1888  	port->dts_params.base_addr = devm_ioremap(port->dev, res.start,
18a6c85fcc78dd Igal Liberman     2015-12-21  1889  						  resource_size(&res));
5df6f7fa47e030 Madalin Bucur     2016-03-22  1890  	if (!port->dts_params.base_addr)
18a6c85fcc78dd Igal Liberman     2015-12-21  1891  		dev_err(port->dev, "%s: devm_ioremap() failed\n", __func__);
18a6c85fcc78dd Igal Liberman     2015-12-21  1892  
72dfcb1946c5b8 Wang Qing         2021-12-07  1893  	of_node_put(port_node);
72dfcb1946c5b8 Wang Qing         2021-12-07  1894  
18a6c85fcc78dd Igal Liberman     2015-12-21  1895  	dev_set_drvdata(&of_dev->dev, port);
18a6c85fcc78dd Igal Liberman     2015-12-21  1896  
18a6c85fcc78dd Igal Liberman     2015-12-21  1897  	return 0;
18a6c85fcc78dd Igal Liberman     2015-12-21  1898  
72dfcb1946c5b8 Wang Qing         2021-12-07  1899  return_of_put_device:
72dfcb1946c5b8 Wang Qing         2021-12-07  1900  	put_device(&fm_pdev->dev);
72dfcb1946c5b8 Wang Qing         2021-12-07  1901  return_of_node_put:
18a6c85fcc78dd Igal Liberman     2015-12-21  1902  	of_node_put(port_node);
18a6c85fcc78dd Igal Liberman     2015-12-21 @1903  free_port:
18a6c85fcc78dd Igal Liberman     2015-12-21  1904  	kfree(port);
18a6c85fcc78dd Igal Liberman     2015-12-21  1905  	return err;
18a6c85fcc78dd Igal Liberman     2015-12-21  1906  }
18a6c85fcc78dd Igal Liberman     2015-12-21  1907  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
