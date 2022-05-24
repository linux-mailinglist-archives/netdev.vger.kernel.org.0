Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6A05332FD
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 23:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241921AbiEXVgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 17:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiEXVgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 17:36:19 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9791E02C;
        Tue, 24 May 2022 14:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653428178; x=1684964178;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9jK8G9ag+81bcO5Ko8qhZ3SN8Fupy/S9GkA/3mPTsOI=;
  b=deIq+mwioW3JsB9+Y80mOQ9R9K/hsTy/+1HQG0F1AXZBSBPrhcdumWYL
   KTncHMQJvCLZpyfBHK5StZ8OLFZVHQPgWa9a2UrSU869+3N0IEsaq/dR8
   J2XAzX3HQZ9dbCQKj02+4pHUeu2YZWg2NCtbx9DfQXpNwUWzLYgTEhRlM
   SJiO1Hmh55l5hHBCNA//7pAwMFQRe9uWzO9kD3h2kJh/3og0TOuxf0r7A
   tudBezPqqK0KC3u2Y6IzG1Ry4ZXhhaPCy+bmMcW/iY4fZsEOmIojWDM02
   IfvMFEIZ/26yoXKkIQm56NXBJ+1/bkS/LXgdOzouodN9mWDEYN3TJSxUz
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10357"; a="273382969"
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="273382969"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 14:36:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="745404583"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 24 May 2022 14:36:12 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ntcCJ-0002T6-UI;
        Tue, 24 May 2022 21:36:11 +0000
Date:   Wed, 25 May 2022 05:36:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
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
Subject: Re: [PATCH V3 net-next 3/4] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <202205250511.beuDDi9L-lkp@intel.com>
References: <20220524152144.40527-4-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524152144.40527-4-schultz.hans+netdev@gmail.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hans,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Hans-Schultz/Extend-locked-port-feature-with-FDB-locked-flag-MAC-Auth-MAB/20220524-232455
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 677fb7525331375ba2f90f4bc94a80b9b6e697a3
config: x86_64-randconfig-a005 (https://download.01.org/0day-ci/archive/20220525/202205250511.beuDDi9L-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 10c9ecce9f6096e18222a331c5e7d085bd813f75)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/5c2d731ec7670b3eb06906c64d66c6098c588a6a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Hans-Schultz/Extend-locked-port-feature-with-FDB-locked-flag-MAC-Auth-MAB/20220524-232455
        git checkout 5c2d731ec7670b3eb06906c64d66c6098c588a6a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/dsa/mv88e6xxx/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/dsa/mv88e6xxx/chip.c:2754:6: warning: variable 'err' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
           if (!locked_found) {
               ^~~~~~~~~~~~~
   drivers/net/dsa/mv88e6xxx/chip.c:2759:9: note: uninitialized use occurs here
           return err;
                  ^~~
   drivers/net/dsa/mv88e6xxx/chip.c:2754:2: note: remove the 'if' if its condition is always true
           if (!locked_found) {
           ^~~~~~~~~~~~~~~~~~~
   drivers/net/dsa/mv88e6xxx/chip.c:2749:9: note: initialize the variable 'err' to silence this warning
           int err;
                  ^
                   = 0
   1 warning generated.


vim +2754 drivers/net/dsa/mv88e6xxx/chip.c

  2742	
  2743	static int mv88e6xxx_port_fdb_del(struct dsa_switch *ds, int port,
  2744					  const unsigned char *addr, u16 vid,
  2745					  struct dsa_db db)
  2746	{
  2747		struct mv88e6xxx_chip *chip = ds->priv;
  2748		bool locked_found = false;
  2749		int err;
  2750	
  2751		if (mv88e6xxx_port_is_locked(chip, port, true))
  2752			locked_found = mv88e6xxx_atu_locked_entry_find_purge(ds, port, addr, vid);
  2753	
> 2754		if (!locked_found) {
  2755			mv88e6xxx_reg_lock(chip);
  2756			err = mv88e6xxx_port_db_load_purge(chip, port, addr, vid, 0);
  2757			mv88e6xxx_reg_unlock(chip);
  2758		}
  2759		return err;
  2760	}
  2761	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
