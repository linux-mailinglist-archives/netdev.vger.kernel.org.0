Return-Path: <netdev+bounces-9592-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 30289729F3B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:53:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACD85281999
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68D2219E65;
	Fri,  9 Jun 2023 15:53:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B4919BC3
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 15:53:32 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9833595;
	Fri,  9 Jun 2023 08:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686326009; x=1717862009;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PnEcmmPcWUbOef8mrx7KdCR85NWYFsHg8gXOQ/9iOvM=;
  b=CGUU1Pcg59YL7rYXin3ZcGyI1GH05lYhExCfoSuH2MBJ2Jqb5EwWI0Rq
   xxB+6p2RAJGGvrvdvcRSqbDnj1eahVkndpRSIn1reZp/gK3B3JgjRb1Sv
   L+5FqdxW7nufwXOL4/wV21GxDD3gc2lZxwysy41OUSCBfI8uWR4FzkN4N
   B4Y9ff3Ny+8lMeQp+FBFT0XsCcKDnGJsLcCoFPv+1PiG2cKY7xrJxXkxp
   JSUD3EvZ/MR7jw5ygLZpKfe59CPYtR56TDUHokS6ej6zg0zGg2A43yocs
   KXLZ0VnOhrzensto68yRaaaqlxwa31Bh0atBGZQaaWgg3x60OYF0e2xIR
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="357630027"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="357630027"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 08:53:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="704595083"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="704595083"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 09 Jun 2023 08:53:25 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q7eQW-0009Bm-1H;
	Fri, 09 Jun 2023 15:53:24 +0000
Date: Fri, 9 Jun 2023 23:52:26 +0800
From: kernel test robot <lkp@intel.com>
To: alexis.lothore@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	paul.arola@telus.com, scott.roberts@telus.com
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: implement egress tbf
 qdisc for 6393x family
Message-ID: <202306092327.Gf6CXGqE-lkp@intel.com>
References: <20230609141812.297521-3-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609141812.297521-3-alexis.lothore@bootlin.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/alexis-lothore-bootlin-com/net-dsa-mv88e6xxx-allow-driver-to-hook-TC-callback/20230609-222048
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230609141812.297521-3-alexis.lothore%40bootlin.com
patch subject: [PATCH net-next 2/2] net: dsa: mv88e6xxx: implement egress tbf qdisc for 6393x family
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20230609/202306092327.Gf6CXGqE-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 12.3.0
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch net-next main
        git checkout net-next/main
        b4 shazam https://lore.kernel.org/r/20230609141812.297521-3-alexis.lothore@bootlin.com
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=alpha olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=alpha SHELL=/bin/bash drivers/net/

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306092327.Gf6CXGqE-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/net/dsa/mv88e6xxx/port.c:1504:5: warning: no previous prototype for 'mv88e6393x_tbf_add' [-Wmissing-prototypes]
    1504 | int mv88e6393x_tbf_add(struct mv88e6xxx_chip *chip, int port,
         |     ^~~~~~~~~~~~~~~~~~
>> drivers/net/dsa/mv88e6xxx/port.c:1559:5: warning: no previous prototype for 'mv88e6393x_tbf_del' [-Wmissing-prototypes]
    1559 | int mv88e6393x_tbf_del(struct mv88e6xxx_chip *chip, int port)
         |     ^~~~~~~~~~~~~~~~~~


vim +/mv88e6393x_tbf_add +1504 drivers/net/dsa/mv88e6xxx/port.c

  1503	
> 1504	int mv88e6393x_tbf_add(struct mv88e6xxx_chip *chip, int port,
  1505			       struct tc_tbf_qopt_offload_replace_params *replace_params)
  1506	{
  1507		int rate_kbps = DIV_ROUND_UP(replace_params->rate.rate_bytes_ps * 8, 1000);
  1508		int overhead = DIV_ROUND_UP(replace_params->rate.overhead, 4);
  1509		int rate_step, decrement_rate, err;
  1510		u16 val;
  1511	
  1512		if (rate_kbps < MV88E6393X_PORT_EGRESS_RATE_MIN_KBPS ||
  1513		    rate_kbps >= MV88E6393X_PORT_EGRESS_RATE_MAX_KBPS)
  1514			return -EOPNOTSUPP;
  1515	
  1516		if (replace_params->rate.overhead > MV88E6393X_PORT_EGRESS_MAX_OVERHEAD)
  1517			return -EOPNOTSUPP;
  1518	
  1519		/* Switch supports only max rate configuration. There is no
  1520		 * configurable burst/max size nor latency.
  1521		 * Formula defining registers value is:
  1522		 * EgressRate = 8 * EgressDec / (16ns * desired Rate)
  1523		 * EgressRate is a set of fixed values depending of targeted range
  1524		 */
  1525		if (rate_kbps < MBPS_TO_KBPS(1)) {
  1526			decrement_rate = rate_kbps / 64;
  1527			rate_step = MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_64_KBPS;
  1528		} else if (rate_kbps < MBPS_TO_KBPS(100)) {
  1529			decrement_rate = rate_kbps / MBPS_TO_KBPS(1);
  1530			rate_step = MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_1_MBPS;
  1531		} else if (rate_kbps < GBPS_TO_KBPS(1)) {
  1532			decrement_rate = rate_kbps / MBPS_TO_KBPS(10);
  1533			rate_step = MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_10_MBPS;
  1534		} else {
  1535			decrement_rate = rate_kbps / MBPS_TO_KBPS(100);
  1536			rate_step = MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_100_MBPS;
  1537		}
  1538	
  1539		dev_dbg(chip->dev, "p%d: adding egress tbf qdisc with %dkbps rate",
  1540			port, rate_kbps);
  1541		val = decrement_rate;
  1542		val |= (overhead << MV88E6XXX_PORT_EGRESS_RATE_CTL1_FRAME_OVERHEAD_SHIFT);
  1543		err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL1,
  1544					   val);
  1545		if (err)
  1546			return err;
  1547	
  1548		val = rate_step;
  1549		/* Configure mode to bits per second mode, on layer 1 */
  1550		val |= MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_L1_BYTES;
  1551		err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2,
  1552					   val);
  1553		if (err)
  1554			return err;
  1555	
  1556		return 0;
  1557	}
  1558	
> 1559	int mv88e6393x_tbf_del(struct mv88e6xxx_chip *chip, int port)
  1560	{
  1561		int err;
  1562	
  1563		dev_dbg(chip->dev, "p%d: removing tbf qdisc", port);
  1564		err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2,
  1565					   0x0000);
  1566		if (err)
  1567			return err;
  1568		return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL1,
  1569					    0x0001);
  1570	}
  1571	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

