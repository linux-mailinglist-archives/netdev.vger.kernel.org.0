Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B58756C25F
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238834AbiGHUkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 16:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238652AbiGHUkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 16:40:13 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A1B2182F;
        Fri,  8 Jul 2022 13:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657312812; x=1688848812;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DIVHdvGmcoQvN9wD6lnJmfi5wn5rSahT3GEvClW89ZA=;
  b=h57LgtzQYYDr4Ut2QBHOxBUbeJgkaPQ/jYVgKR8bF1mEhaZUeAa8ClkI
   ZHXHCkBkWHTRONDpXbPcUwW8QkmAIjA1fXeZDecXS58Chd5MHEtwKMzvP
   UrkjCG3v2hIhB851kn18O/QBiUqXdUtQehFHvIwZbIcrIOZd+3Z8wri3W
   MbAJmjnt8Mn6itUyuyYgHh0Hfw5tBzIuAITOYnUX8f7G+a0rcvIkyC8MO
   5/UAgZU7UZkb1PomAxMnN7mNYxFewGgKiIDEkiO6S2I8Jc2A1kQAEk8YJ
   pbqW9Q5ODXBtFo7xQCIoVgs3XR3g4xOdjr3PgG6EpDTCVIDaX0Zh1obkH
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10402"; a="309946170"
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="309946170"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 13:40:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="594244629"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 08 Jul 2022 13:40:07 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o9uli-000Nv4-Tb;
        Fri, 08 Jul 2022 20:40:06 +0000
Date:   Sat, 9 Jul 2022 04:39:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hans Schultz <netdev@kapio-technology.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, Hans Schultz <netdev@kapio-technology.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
Message-ID: <202207090438.PlGIeA4G-lkp@intel.com>
References: <20220707152930.1789437-4-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707152930.1789437-4-netdev@kapio-technology.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hans,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]
[also build test ERROR on shuah-kselftest/next linus/master v5.19-rc5]
[cannot apply to net-next/master next-20220708]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Hans-Schultz/Extend-locked-port-feature-with-FDB-locked-flag-MAC-Auth-MAB/20220707-233246
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 07266d066301b97ad56a693f81b29b7ced429b27
config: i386-randconfig-a013 (https://download.01.org/0day-ci/archive/20220709/202207090438.PlGIeA4G-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 562c3467a6738aa89203f72fc1d1343e5baadf3c)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/ebd598d7ea6c015001489c4293da887763491086
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Hans-Schultz/Extend-locked-port-feature-with-FDB-locked-flag-MAC-Auth-MAB/20220707-233246
        git checkout ebd598d7ea6c015001489c4293da887763491086
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/dsa/sja1105/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/dsa/sja1105/sja1105_main.c:1952:58: error: too few arguments to function call, expected 6, have 5
           return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid, db);
                  ~~~~~~~~~~~~~~~                                  ^
   drivers/net/dsa/sja1105/sja1105_main.c:1803:12: note: 'sja1105_fdb_add' declared here
   static int sja1105_fdb_add(struct dsa_switch *ds, int port,
              ^
   1 error generated.


vim +1952 drivers/net/dsa/sja1105/sja1105_main.c

5126ec72a094bd3 Vladimir Oltean 2021-08-08  1947  
a52b2da778fc93e Vladimir Oltean 2021-01-09  1948  static int sja1105_mdb_add(struct dsa_switch *ds, int port,
c26933639b5402c Vladimir Oltean 2022-02-25  1949  			   const struct switchdev_obj_port_mdb *mdb,
c26933639b5402c Vladimir Oltean 2022-02-25  1950  			   struct dsa_db db)
291d1e72b756424 Vladimir Oltean 2019-05-02  1951  {
c26933639b5402c Vladimir Oltean 2022-02-25 @1952  	return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid, db);
291d1e72b756424 Vladimir Oltean 2019-05-02  1953  }
291d1e72b756424 Vladimir Oltean 2019-05-02  1954  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
