Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4DC51EF5F
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238700AbiEHTGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236435AbiEHRk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 13:40:56 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5891E023
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 10:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652031425; x=1683567425;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0/fC6EgJ5Kqmg8rZFo5D4/lxmFZW7WGP5yZGUfcCwoU=;
  b=O2cQ8SsPxkUjPb4JIJ7xCGCPVwGQV9ox12GiUSuznIWTx1ENgOzJEIzz
   3M9N8ijHQ3pLQd1uZ1u68ZLpzZWnXeRHBvCnvxtQKAFFAEIMwwJpUuRU3
   kg2+D1Fk5z6/UDPovK/W99UV0sfNt1QYl2f9iH4dMI3U6eeiEHiSFv78c
   kTdv8GQqQxM8e4MZpsOefNNcBZCGYBhS1X75cwp5vrHPor4ivKZVwX5Xh
   TLBR3mkiZ561e1lX4jVYSgfckboh4djon9aPxhP7+AhAdPzfd68kOXIgR
   nshS32cHG1mEqiOPnBzrGCw1KuiEfMt8vA6P68zrgN1bqS5QjEcglR80n
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10341"; a="256381779"
X-IronPort-AV: E=Sophos;i="5.91,208,1647327600"; 
   d="scan'208";a="256381779"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2022 10:37:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,208,1647327600"; 
   d="scan'208";a="668592609"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 08 May 2022 10:37:00 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nnkq3-000Ff4-VQ;
        Sun, 08 May 2022 17:36:59 +0000
Date:   Mon, 9 May 2022 01:36:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Cc:     kbuild-all@lists.01.org, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>
Subject: Re: [PATCH net-next 09/10] net: dsa: Separate C22 and C45 MDIO bus
 transaction methods
Message-ID: <202205090111.Nnl7VN9a-lkp@intel.com>
References: <20220508153049.427227-10-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220508153049.427227-10-andrew@lunn.ch>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Andrew-Lunn/net-mdio-Start-separating-C22-and-C45/20220508-233302
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 8fc0b6992a06998404321f26a57ea54522659b64
config: parisc-randconfig-r023-20220508 (https://download.01.org/0day-ci/archive/20220509/202205090111.Nnl7VN9a-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/643c2f1541edcf0c2cb0f91e3e1981a8691894a0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Andrew-Lunn/net-mdio-Start-separating-C22-and-C45/20220508-233302
        git checkout 643c2f1541edcf0c2cb0f91e3e1981a8691894a0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=parisc SHELL=/bin/bash drivers/net/dsa/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/dsa/mt7530.c: In function 'mt7530_phy_read_c45':
>> drivers/net/dsa/mt7530.c:622:16: error: implicit declaration of function 'mdiobus_c45_read_nested'; did you mean 'mdiobus_read_nested'? [-Werror=implicit-function-declaration]
     622 |         return mdiobus_c45_read_nested(priv->bus, port, devad, regnum);
         |                ^~~~~~~~~~~~~~~~~~~~~~~
         |                mdiobus_read_nested
   drivers/net/dsa/mt7530.c: In function 'mt7530_phy_write_c45':
>> drivers/net/dsa/mt7530.c:628:16: error: implicit declaration of function 'mdiobus_c45_write_nested'; did you mean 'mdiobus_write_nested'? [-Werror=implicit-function-declaration]
     628 |         return mdiobus_c45_write_nested(priv->bus, port, devad, regnum, val);
         |                ^~~~~~~~~~~~~~~~~~~~~~~~
         |                mdiobus_write_nested
   cc1: some warnings being treated as errors


vim +622 drivers/net/dsa/mt7530.c

   618	
   619	static int mt7530_phy_read_c45(struct mt7530_priv *priv, int port,
   620				       int devad, int regnum)
   621	{
 > 622		return mdiobus_c45_read_nested(priv->bus, port, devad, regnum);
   623	}
   624	
   625	static int mt7530_phy_write_c45(struct mt7530_priv *priv, int port, int devad,
   626					int regnum, u16 val)
   627	{
 > 628		return mdiobus_c45_write_nested(priv->bus, port, devad, regnum, val);
   629	}
   630	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
