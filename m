Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCAB4D8516
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 13:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240774AbiCNMfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 08:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245463AbiCNMdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 08:33:03 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA51140CC;
        Mon, 14 Mar 2022 05:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647261078; x=1678797078;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Uk40I5JPAuKTeUDKbFKLzPBxKRBgK3se0kAQvR9DnsI=;
  b=bZQuUirVK5p3Z9dAbckXzpJjuJ5Sz01WUFxjd0Sh1vJ0vTOuRw4IvrGx
   k6hNaeiCmlEqMGnMhml+1+CbhNwgSx5O+2rPXluaxvZBpF7eGuP3sVotN
   WJhzNCEnwUD6qOsEtXXS4fHvpcTCbDfixCgQFqKeyKf/yFNV29GuPAnZT
   pMaqMlM92AT5RQImAMG9FNlUJs1ScGdMXHSUZUHbdNLBqbYXKEuV6TIsl
   0IOU4xx9UdnY06agP4RNbnN+CEpgmBNi0ekKGiLMcpTpz1mqw5S66LK/C
   R71yB2wpZy2CZmu6WH5nCXJ+pt0fRGTmoteEWLvSnXUOLEkZUu6pe3Ewd
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10285"; a="342438526"
X-IronPort-AV: E=Sophos;i="5.90,180,1643702400"; 
   d="scan'208";a="342438526"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 05:31:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,180,1643702400"; 
   d="scan'208";a="597871762"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 14 Mar 2022 05:31:13 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nTjqz-0009r8-4f; Mon, 14 Mar 2022 12:31:13 +0000
Date:   Mon, 14 Mar 2022 20:31:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     kbuild-all@lists.01.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v3 net-next 01/14] net: bridge: mst: Multiple Spanning
 Tree (MST) mode
Message-ID: <202203142009.7OAfQ0fR-lkp@intel.com>
References: <20220314095231.3486931-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314095231.3486931-2-tobias@waldekranz.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Tobias-Waldekranz/net-bridge-Multiple-Spanning-Trees/20220314-175717
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git de29aff976d3216e7f3ab41fcd7af46fa8f7eab7
config: xtensa-randconfig-m031-20220313 (https://download.01.org/0day-ci/archive/20220314/202203142009.7OAfQ0fR-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/702c502efb27c12860bc55fc8d9b1bfd99466623
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Tobias-Waldekranz/net-bridge-Multiple-Spanning-Trees/20220314-175717
        git checkout 702c502efb27c12860bc55fc8d9b1bfd99466623
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=xtensa SHELL=/bin/bash net/bridge/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   net/bridge/br.c: In function 'br_boolopt_toggle':
>> net/bridge/br.c:269:23: error: implicit declaration of function 'br_mst_set_enabled'; did you mean 'br_stp_set_enabled'? [-Werror=implicit-function-declaration]
     269 |                 err = br_mst_set_enabled(br, on, extack);
         |                       ^~~~~~~~~~~~~~~~~~
         |                       br_stp_set_enabled
   cc1: some warnings being treated as errors


vim +269 net/bridge/br.c

   245	
   246	/* br_boolopt_toggle - change user-controlled boolean option
   247	 *
   248	 * @br: bridge device
   249	 * @opt: id of the option to change
   250	 * @on: new option value
   251	 * @extack: extack for error messages
   252	 *
   253	 * Changes the value of the respective boolean option to @on taking care of
   254	 * any internal option value mapping and configuration.
   255	 */
   256	int br_boolopt_toggle(struct net_bridge *br, enum br_boolopt_id opt, bool on,
   257			      struct netlink_ext_ack *extack)
   258	{
   259		int err = 0;
   260	
   261		switch (opt) {
   262		case BR_BOOLOPT_NO_LL_LEARN:
   263			br_opt_toggle(br, BROPT_NO_LL_LEARN, on);
   264			break;
   265		case BR_BOOLOPT_MCAST_VLAN_SNOOPING:
   266			err = br_multicast_toggle_vlan_snooping(br, on, extack);
   267			break;
   268		case BR_BOOLOPT_MST_ENABLE:
 > 269			err = br_mst_set_enabled(br, on, extack);
   270			break;
   271		default:
   272			/* shouldn't be called with unsupported options */
   273			WARN_ON(1);
   274			break;
   275		}
   276	
   277		return err;
   278	}
   279	

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
