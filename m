Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715AE51F094
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbiEHTcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiEHTb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 15:31:57 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC1C167F3
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 12:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652037621; x=1683573621;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=09kSn2BMpvbbEClFdqcnAt5a8LWzXTbV4dueyVSd/2Y=;
  b=SEin0OjH6yuJS6F5SykmpPGEgMRAEfCk0jmKw1FcmVl1BhG0hyHhnn9d
   BIxoqlOx5hNomfOIbL3+K1ywFMN7C8oCYjpzMsC7VjT/FQbihxUI2CoMC
   DqhqfGtX285J+675k60D5u0sg70sLtO5gcfOgtqfS9VCjEYgnKlaKj0uZ
   c39BdWUGKkLD9NBgkRIGvsgrOnulX7lFtBdIiZCo5zSwAbkDUOROevJTb
   ZEMuWXlabxL3V9W9Qs9fSDQ+e7UgVi1xLqI4tL+ZpuD90J/Bq0LZs4GtI
   fYC1pERaWL7ldSsXTg5TnjfGk1iIvBm5N4HcKrqY3kmTqAi7RIpby6yV8
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10341"; a="329454678"
X-IronPort-AV: E=Sophos;i="5.91,208,1647327600"; 
   d="scan'208";a="329454678"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2022 12:20:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,208,1647327600"; 
   d="scan'208";a="539484848"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 08 May 2022 12:20:16 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nnmRz-000FkX-Ah;
        Sun, 08 May 2022 19:20:15 +0000
Date:   Mon, 9 May 2022 03:19:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Sean Wang <sean.wang@mediatek.com>,
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
Message-ID: <202205090359.Jw8AQHKW-lkp@intel.com>
References: <20220508153049.427227-10-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220508153049.427227-10-andrew@lunn.ch>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
config: hexagon-randconfig-r041-20220509 (https://download.01.org/0day-ci/archive/20220509/202205090359.Jw8AQHKW-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project a385645b470e2d3a1534aae618ea56b31177639f)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/643c2f1541edcf0c2cb0f91e3e1981a8691894a0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Andrew-Lunn/net-mdio-Start-separating-C22-and-C45/20220508-233302
        git checkout 643c2f1541edcf0c2cb0f91e3e1981a8691894a0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/net/dsa/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/dsa/mt7530.c:622:9: error: call to undeclared function 'mdiobus_c45_read_nested'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           return mdiobus_c45_read_nested(priv->bus, port, devad, regnum);
                  ^
   drivers/net/dsa/mt7530.c:622:9: note: did you mean 'mdiobus_read_nested'?
   include/linux/mdio.h:419:5: note: 'mdiobus_read_nested' declared here
   int mdiobus_read_nested(struct mii_bus *bus, int addr, u32 regnum);
       ^
>> drivers/net/dsa/mt7530.c:628:9: error: call to undeclared function 'mdiobus_c45_write_nested'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           return mdiobus_c45_write_nested(priv->bus, port, devad, regnum, val);
                  ^
   drivers/net/dsa/mt7530.c:628:9: note: did you mean 'mdiobus_write_nested'?
   include/linux/mdio.h:421:5: note: 'mdiobus_write_nested' declared here
   int mdiobus_write_nested(struct mii_bus *bus, int addr, u32 regnum, u16 val);
       ^
   2 errors generated.


vim +/mdiobus_c45_read_nested +622 drivers/net/dsa/mt7530.c

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
