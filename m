Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D405526F6
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 00:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243581AbiFTWbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 18:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243182AbiFTWbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 18:31:15 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF5B1CB39;
        Mon, 20 Jun 2022 15:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655764274; x=1687300274;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pmSKwHf+XOx/cVvFoD/KBOhPf+3PAaRJZ2sU7Jq1+98=;
  b=ekgd5lyLhWR66HOYz8oPMcLI3tfs1DkAhwI0S7DL3s+aPYy0kxdNDQ3F
   6+7/cOVRN+9nqDhvkbhl8yrtjln4HjCe4l3iwSYC0aY6GgPaL7da33RhW
   zqXsQwyO5TCqQTnYcAXByr/FHC05itfD+gmvqQqv4NfkZmMK9SRZcGEuH
   ireaJ7lDjGzkCnjmBQsRReiA7MXBn73FRRypBdd71ed1m3lr85VxjvJ3U
   1Fbdfm8dOEexlqos2+mtptqZr6zDAPpBhe8WupVgSF8eeQIQGh2KkUTDq
   PlAeQULvxwVetU5NnwaDkObn26+1w3Ihn8QL17v1vpTIAnvwapRHHu0Zx
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="305417435"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="305417435"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 15:31:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="585046305"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 20 Jun 2022 15:31:09 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o3PvI-000Wkl-OD;
        Mon, 20 Jun 2022 22:31:08 +0000
Date:   Tue, 21 Jun 2022 06:30:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Marcin Wojtas <mw@semihalf.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, rafael@kernel.org,
        andriy.shevchenko@linux.intel.com, lenb@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, hkallweit1@gmail.com,
        gjb@semihalf.com, mw@semihalf.com, jaz@semihalf.com,
        tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH 05/12] net: core: switch to
 fwnode_find_net_device_by_node()
Message-ID: <202206210649.QCsWk7fK-lkp@intel.com>
References: <20220620150225.1307946-6-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620150225.1307946-6-mw@semihalf.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcin,

I love your patch! Yet something to improve:

[auto build test ERROR on rafael-pm/linux-next]
[also build test ERROR on robh/for-next linus/master v5.19-rc2 next-20220617]
[cannot apply to horms-ipvs/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Marcin-Wojtas/ACPI-support-for-DSA/20220620-231646
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next
config: arm-allmodconfig (https://download.01.org/0day-ci/archive/20220621/202206210649.QCsWk7fK-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/68a7a52989207bfe8640877c512c77ca233c3bba
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Marcin-Wojtas/ACPI-support-for-DSA/20220620-231646
        git checkout 68a7a52989207bfe8640877c512c77ca233c3bba
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

ERROR: modpost: missing MODULE_LICENSE() in drivers/watchdog/gxp-wdt.o
>> ERROR: modpost: "fwnode_find_net_device_by_node" [net/dsa/dsa_core.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
