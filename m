Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6025A51B1D1
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 00:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379025AbiEDWbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 18:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378486AbiEDWbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 18:31:25 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A391839F;
        Wed,  4 May 2022 15:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651703268; x=1683239268;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=iseNbFUPu4r/NGZXn1J3t8MNxJoP+Y5rD4HFKbxDpxI=;
  b=PY99yEScy8oodSx1VzA239KGEDVFz6L3OLo22cpQwoGljO25F1M1iHnh
   oJUdPT1PcYrB+XykY6SX4zWCEr95QTB12ZXaxwa4aDAk+BX52M4g6EzqC
   ppcJWp5QswOfJSfdhRScENTR7PB01/aFPkDAJ1iGL4P3b0+WOW+QlUnFe
   eLNj5RQqYXMdgnXytiJje4l8ZHni/WoY+cksx2w2QW0JzvXTsWyC8h9Zi
   sQ2WScbYzRgMS869MuO/hS7Dkrq1/zKK550nGn3zSi5AicjE6HzPaSfsb
   gquytq6Ls8Hh1iaK6vhGVX4cfhMzclFSFW7bu/GgCceN8GjzsY0dkfSBL
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="265511499"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="265511499"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 15:27:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="517226448"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 04 May 2022 15:27:41 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nmNTA-000Bqd-Na;
        Wed, 04 May 2022 22:27:40 +0000
Date:   Thu, 5 May 2022 06:27:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-can@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Anatolij Gustschin <agust@denx.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v1 2/4] powerpc/mpc5xxx: Switch
 mpc5xxx_get_bus_frequency() to use fwnode
Message-ID: <202205050659.ppSbPqfb-lkp@intel.com>
References: <20220504134449.64473-2-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220504134449.64473-2-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

I love your patch! Perhaps something to improve:

[auto build test WARNING on powerpc/next]
[also build test WARNING on wsa/i2c/for-next mkl-can-next/testing broonie-spi/for-next tty/tty-testing linus/master v5.18-rc5 next-20220504]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Andy-Shevchenko/powerpc-52xx-Remove-dead-code-i-e-mpc52xx_get_xtal_freq/20220504-215701
base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git next
config: powerpc-pcm030_defconfig (https://download.01.org/0day-ci/archive/20220505/202205050659.ppSbPqfb-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/7bff10cee4f441153a56de337715dd4f40c55521
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Andy-Shevchenko/powerpc-52xx-Remove-dead-code-i-e-mpc52xx_get_xtal_freq/20220504-215701
        git checkout 7bff10cee4f441153a56de337715dd4f40c55521
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash drivers/i2c/busses/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/i2c/busses/i2c-mpc.c: In function 'mpc_i2c_get_fdr_52xx':
   drivers/i2c/busses/i2c-mpc.c:242:30: error: expected identifier or '(' before '=' token
     242 |         struct fwnode_handle = of_fwnode_handle(node);
         |                              ^
   In file included from include/linux/of_address.h:6,
                    from drivers/i2c/busses/i2c-mpc.c:14:
   include/linux/of.h:176:10: error: expected statement before ')' token
     176 |         })
         |          ^
   drivers/i2c/busses/i2c-mpc.c:242:32: note: in expansion of macro 'of_fwnode_handle'
     242 |         struct fwnode_handle = of_fwnode_handle(node);
         |                                ^~~~~~~~~~~~~~~~
>> drivers/i2c/busses/i2c-mpc.c:243:9: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
     243 |         const struct mpc_i2c_divider *div = NULL;
         |         ^~~~~
   drivers/i2c/busses/i2c-mpc.c:250:62: error: 'fwnode' undeclared (first use in this function); did you mean 'node'?
     250 |                 *real_clk = mpc5xxx_fwnode_get_bus_frequency(fwnode) / 2048;
         |                                                              ^~~~~~
         |                                                              node
   drivers/i2c/busses/i2c-mpc.c:250:62: note: each undeclared identifier is reported only once for each function it appears in


vim +243 drivers/i2c/busses/i2c-mpc.c

f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  238  
0b255e927d47b55 Bill Pemberton      2012-11-27  239  static int mpc_i2c_get_fdr_52xx(struct device_node *node, u32 clock,
38a99bd7730efdd Arseny Solokha      2018-01-10  240  					  u32 *real_clk)
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  241  {
7bff10cee4f4411 Andy Shevchenko     2022-05-04  242  	struct fwnode_handle = of_fwnode_handle(node);
1904b03430ade1c Wolfgang Grandegger 2009-04-09 @243  	const struct mpc_i2c_divider *div = NULL;
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  244  	unsigned int pvr = mfspr(SPRN_PVR);
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  245  	u32 divider;
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  246  	int i;
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  247  
0c2daaafcdec726 Albrecht Dreﬂ       2010-02-17  248  	if (clock == MPC_I2C_CLOCK_LEGACY) {
0c2daaafcdec726 Albrecht Dreﬂ       2010-02-17  249  		/* see below - default fdr = 0x3f -> div = 2048 */
7bff10cee4f4411 Andy Shevchenko     2022-05-04  250  		*real_clk = mpc5xxx_fwnode_get_bus_frequency(fwnode) / 2048;
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  251  		return -EINVAL;
0c2daaafcdec726 Albrecht Dreﬂ       2010-02-17  252  	}
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  253  
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  254  	/* Determine divider value */
7bff10cee4f4411 Andy Shevchenko     2022-05-04  255  	divider = mpc5xxx_fwnode_get_bus_frequency(fwnode) / clock;
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  256  
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  257  	/*
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  258  	 * We want to choose an FDR/DFSR that generates an I2C bus speed that
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  259  	 * is equal to or lower than the requested speed.
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  260  	 */
1904b03430ade1c Wolfgang Grandegger 2009-04-09  261  	for (i = 0; i < ARRAY_SIZE(mpc_i2c_dividers_52xx); i++) {
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  262  		div = &mpc_i2c_dividers_52xx[i];
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  263  		/* Old MPC5200 rev A CPUs do not support the high bits */
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  264  		if (div->fdr & 0xc0 && pvr == 0x80822011)
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  265  			continue;
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  266  		if (div->divider >= divider)
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  267  			break;
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  268  	}
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  269  
7bff10cee4f4411 Andy Shevchenko     2022-05-04  270  	*real_clk = mpc5xxx_fwnode_get_bus_frequency(fwnode) / div->divider;
0c2daaafcdec726 Albrecht Dreﬂ       2010-02-17  271  	return (int)div->fdr;
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  272  }
f2bd5efe7238149 Wolfgang Grandegger 2009-04-07  273  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
