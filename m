Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B673D5776
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 12:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhGZJsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 05:48:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:19471 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231612AbhGZJr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 05:47:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10056"; a="209088081"
X-IronPort-AV: E=Sophos;i="5.84,270,1620716400"; 
   d="gz'50?scan'50,208,50";a="209088081"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2021 03:28:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,270,1620716400"; 
   d="gz'50?scan'50,208,50";a="473635893"
Received: from lkp-server01.sh.intel.com (HELO d053b881505b) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 26 Jul 2021 03:28:25 -0700
Received: from kbuild by d053b881505b with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1m7xqS-0005fC-Io; Mon, 26 Jul 2021 10:28:24 +0000
Date:   Mon, 26 Jul 2021 18:27:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Dave Ertman <david.m.ertman@intel.com>
Subject: Re: [PATCH] ethernet/intel: fix PTP_1588_CLOCK dependencies
Message-ID: <202107261848.FV7RhndS-lkp@intel.com>
References: <20210726084540.3282344-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20210726084540.3282344-1-arnd@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Arnd,

I love your patch! Yet something to improve:

[auto build test ERROR on tnguy-next-queue/dev-queue]
[also build test ERROR on v5.14-rc3 next-20210723]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Arnd-Bergmann/ethernet-intel-fix-PTP_1588_CLOCK-dependencies/20210726-164755
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue.git dev-queue
config: um-x86_64_defconfig (attached as .config)
compiler: gcc-10 (Ubuntu 10.3.0-1ubuntu1~20.04) 10.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/400b6b5bda753bdd933ea7f6b55be00cc4a692ed
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Arnd-Bergmann/ethernet-intel-fix-PTP_1588_CLOCK-dependencies/20210726-164755
        git checkout 400b6b5bda753bdd933ea7f6b55be00cc4a692ed
        # save the attached .config to linux build tree
        make W=1 ARCH=um SUBARCH=x86_64

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/i2c/Kconfig:8:error: recursive dependency detected!
   drivers/i2c/Kconfig:8: symbol I2C is selected by IGB
   drivers/net/ethernet/intel/Kconfig:87: symbol IGB depends on PTP_1588_CLOCK
   drivers/ptp/Kconfig:8: symbol PTP_1588_CLOCK is implied by MLX4_EN
   drivers/net/ethernet/mellanox/mlx4/Kconfig:6: symbol MLX4_EN depends on NET_VENDOR_MELLANOX
   drivers/net/ethernet/mellanox/Kconfig:6: symbol NET_VENDOR_MELLANOX depends on I2C
   For a resolution refer to Documentation/kbuild/kconfig-language.rst
   subsection "Kconfig recursive dependency limitations"


vim +8 drivers/i2c/Kconfig

da3c6647ee0871 Lan Tianyu         2014-05-20   7  
da3c6647ee0871 Lan Tianyu         2014-05-20  @8  config I2C
^1da177e4c3f41 Linus Torvalds     2005-04-16   9  	tristate "I2C support"
194684e596af4b Mika Kuoppala      2009-12-06  10  	select RT_MUTEXES
4d5538f5882a6b Benjamin Tissoires 2016-10-13  11  	select IRQ_DOMAIN
a7f7f6248d9740 Masahiro Yamada    2020-06-14  12  	help
622e040d577dc8 Michael Witten     2011-07-08  13  	  I2C (pronounce: I-squared-C) is a slow serial bus protocol used in
^1da177e4c3f41 Linus Torvalds     2005-04-16  14  	  many micro controller applications and developed by Philips.  SMBus,
^1da177e4c3f41 Linus Torvalds     2005-04-16  15  	  or System Management Bus is a subset of the I2C protocol.  More
^1da177e4c3f41 Linus Torvalds     2005-04-16  16  	  information is contained in the directory <file:Documentation/i2c/>,
^1da177e4c3f41 Linus Torvalds     2005-04-16  17  	  especially in the file called "summary" there.
^1da177e4c3f41 Linus Torvalds     2005-04-16  18  
^1da177e4c3f41 Linus Torvalds     2005-04-16  19  	  Both I2C and SMBus are supported here. You will need this for
^1da177e4c3f41 Linus Torvalds     2005-04-16  20  	  hardware sensors support, and also for Video For Linux support.
^1da177e4c3f41 Linus Torvalds     2005-04-16  21  
^1da177e4c3f41 Linus Torvalds     2005-04-16  22  	  If you want I2C support, you should say Y here and also to the
^1da177e4c3f41 Linus Torvalds     2005-04-16  23  	  specific driver for your bus adapter(s) below.
^1da177e4c3f41 Linus Torvalds     2005-04-16  24  
^1da177e4c3f41 Linus Torvalds     2005-04-16  25  	  This I2C support can also be built as a module.  If so, the module
^1da177e4c3f41 Linus Torvalds     2005-04-16  26  	  will be called i2c-core.
^1da177e4c3f41 Linus Torvalds     2005-04-16  27  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--fdj2RfSjLxBAspz7
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--fdj2RfSjLxBAspz7--
