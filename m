Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E00550297
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbiFRD6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiFRD6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:58:13 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF631AD82;
        Fri, 17 Jun 2022 20:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655524687; x=1687060687;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Tdn9YZqKJcIl8RKR+0vr7nLft8oYgegMrai9Dd+G8YQ=;
  b=UyrUTHllCj+VDvtp89LHSp2vD1UidXTa2mGYdXTP5Yp0VJg2yYCbqFaT
   ICGuRFJFHT+XQHFai6jhnvhbLiBdaiHWi6kvNyv5DUeq7YBiivtUVp2Xx
   Yr8s74cFG2xIW/iF0Ng/vc9p/rBrgEJWzOTbtg2QOiVRNaPPQOVwF8CkL
   XcBE+JY0M59AgU+HsujlsEdDkIS0IKBtKggvNWVmA7QbST32G2jcRE+lz
   NIJVQWRih6fp630pZaW+veGUK2RtcB9wO/crDUDYS48pQR2jewbBbK+uM
   HdqZYgMEsQ+KUTWNCKgK7hoRCkRpXag3xzOLf1y+B3p8zk6OQPTCagM9y
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="260058849"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="260058849"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2022 20:58:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="579778043"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2022 20:58:04 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o2Pb1-000Pzv-CT;
        Sat, 18 Jun 2022 03:58:03 +0000
Date:   Sat, 18 Jun 2022 11:57:48 +0800
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
Subject: Re: [PATCH net-next 10/28] net: fman: Move struct dev to mac_device
Message-ID: <202206181156.p7gQheg2-lkp@intel.com>
References: <20220617203312.3799646-11-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617203312.3799646-11-sean.anderson@seco.com>
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
config: m68k-randconfig-r036-20220617 (https://download.01.org/0day-ci/archive/20220618/202206181156.p7gQheg2-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/155c8f9a09b3f95f4804d306c2465ebc82fe608f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sean-Anderson/net-dpaa-Convert-to-phylink/20220618-044003
        git checkout 155c8f9a09b3f95f4804d306c2465ebc82fe608f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash drivers/net/ethernet/freescale/fman/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/freescale/fman/mac.c: In function 'mac_exception':
>> drivers/net/ethernet/freescale/fman/mac.c:50:34: warning: variable 'priv' set but not used [-Wunused-but-set-variable]
      50 |         struct mac_priv_s       *priv;
         |                                  ^~~~
   drivers/net/ethernet/freescale/fman/mac.c: In function 'tgec_initialization':
   drivers/net/ethernet/freescale/fman/mac.c:271:34: warning: variable 'priv' set but not used [-Wunused-but-set-variable]
     271 |         struct mac_priv_s       *priv;
         |                                  ^~~~
   drivers/net/ethernet/freescale/fman/mac.c: In function 'dtsec_initialization':
   drivers/net/ethernet/freescale/fman/mac.c:333:34: warning: variable 'priv' set but not used [-Wunused-but-set-variable]
     333 |         struct mac_priv_s       *priv;
         |                                  ^~~~


vim +/priv +50 drivers/net/ethernet/freescale/fman/mac.c

3933961682a30a Igal Liberman 2015-12-21  46  
3933961682a30a Igal Liberman 2015-12-21  47  static void mac_exception(void *handle, enum fman_mac_exceptions ex)
3933961682a30a Igal Liberman 2015-12-21  48  {
3933961682a30a Igal Liberman 2015-12-21  49  	struct mac_device	*mac_dev;
3933961682a30a Igal Liberman 2015-12-21 @50  	struct mac_priv_s	*priv;
3933961682a30a Igal Liberman 2015-12-21  51  
3933961682a30a Igal Liberman 2015-12-21  52  	mac_dev = handle;
3933961682a30a Igal Liberman 2015-12-21  53  	priv = mac_dev->priv;
3933961682a30a Igal Liberman 2015-12-21  54  
3933961682a30a Igal Liberman 2015-12-21  55  	if (ex == FM_MAC_EX_10G_RX_FIFO_OVFL) {
3933961682a30a Igal Liberman 2015-12-21  56  		/* don't flag RX FIFO after the first */
3933961682a30a Igal Liberman 2015-12-21  57  		mac_dev->set_exception(mac_dev->fman_mac,
3933961682a30a Igal Liberman 2015-12-21  58  				       FM_MAC_EX_10G_RX_FIFO_OVFL, false);
155c8f9a09b3f9 Sean Anderson 2022-06-17  59  		dev_err(mac_dev->dev, "10G MAC got RX FIFO Error = %x\n", ex);
3933961682a30a Igal Liberman 2015-12-21  60  	}
3933961682a30a Igal Liberman 2015-12-21  61  
155c8f9a09b3f9 Sean Anderson 2022-06-17  62  	dev_dbg(mac_dev->dev, "%s:%s() -> %d\n", KBUILD_BASENAME ".c",
3933961682a30a Igal Liberman 2015-12-21  63  		__func__, ex);
3933961682a30a Igal Liberman 2015-12-21  64  }
3933961682a30a Igal Liberman 2015-12-21  65  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
