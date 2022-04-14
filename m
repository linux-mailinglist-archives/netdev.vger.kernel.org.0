Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144755011F5
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 17:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347017AbiDNO0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 10:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347785AbiDNN7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 09:59:33 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C1E193F1
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 06:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649944466; x=1681480466;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iTIKQb01y3jl3fEWGQGFevWFGxXwImo/bkABxNPz4oo=;
  b=Tj78BbXdSa1Vf1ZndxpmV3gYlJcj2JynsYvZxbcBcrgsIA/BBW/H+8V4
   YUD0/I6k8j9nUeDjSLvIzZrbchtvZt8sllRoNkK5+oZv9bXOhUgQqIpbe
   94DAdPnJJ7bTaRXjoZ/O7P+HmzFoeoMKz6EU8q2d5kHPP9h/vEvutFqyk
   9jPbdl9VRIps5Hsk2ivY+Y8L+4ZeK5BpwdXTU8jAooCf6UKvNUnDASrKi
   bl8dblNkEg6/J85zp5rRIg+mFReVjeWYWz9fIltScmxkvPOWdcWTCWBLf
   miMwawucA9W5e6vdgFGfDUHvwzig+MlQhfv1by/nQIlNpQCchOp0mZLk1
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="242866051"
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="242866051"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 06:54:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="700687549"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 14 Apr 2022 06:54:23 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nezvS-00010b-M8;
        Thu, 14 Apr 2022 13:54:22 +0000
Date:   Thu, 14 Apr 2022 21:53:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: Re: [PATCH net-next 6/6] net: bridge: avoid uselessly making
 offloaded ports promiscuous
Message-ID: <202204142133.6pDDI4xD-lkp@intel.com>
References: <20220408200337.718067-7-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408200337.718067-7-vladimir.oltean@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Vladimir-Oltean/Disable-host-flooding-for-DSA-ports-under-a-bridge/20220409-041556
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git e8bd70250a821edb541c3abe1eacdad9f8dc7adf
config: i386-debian-10.3 (https://download.01.org/0day-ci/archive/20220414/202204142133.6pDDI4xD-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-19) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/2b24e24c704fa129c753dbc8fb764c95f4a3562c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vladimir-Oltean/Disable-host-flooding-for-DSA-ports-under-a-bridge/20220409-041556
        git checkout 2b24e24c704fa129c753dbc8fb764c95f4a3562c
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/bridge/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   net/bridge/br_if.c: In function 'br_manage_promisc':
>> net/bridge/br_if.c:145:22: error: 'struct net_bridge_port' has no member named 'offload_count'
     145 |                 if (p->offload_count) {
         |                      ^~


vim +145 net/bridge/br_if.c

   129	
   130	/* When a port is added or removed or when certain port flags
   131	 * change, this function is called to automatically manage
   132	 * promiscuity setting of all the bridge ports.  We are always called
   133	 * under RTNL so can skip using rcu primitives.
   134	 */
   135	void br_manage_promisc(struct net_bridge *br)
   136	{
   137		struct net_bridge_port *p;
   138	
   139		list_for_each_entry(p, &br->port_list, list) {
   140			/* Offloaded ports have a separate address database for
   141			 * forwarding, which is managed through switchdev and not
   142			 * through dev_uc_add(), so the promiscuous concept makes no
   143			 * sense for them. Avoid updating promiscuity in that case.
   144			 */
 > 145			if (p->offload_count) {
   146				br_port_clear_promisc(p);
   147				continue;
   148			}
   149	
   150			/* If bridge is promiscuous, unconditionally place all ports
   151			 * in promiscuous mode too. This allows the bridge device to
   152			 * locally receive all unknown traffic.
   153			 */
   154			if (br->dev->flags & IFF_PROMISC) {
   155				br_port_set_promisc(p);
   156				continue;
   157			}
   158	
   159			/* If vlan filtering is disabled, place all ports in
   160			 * promiscuous mode.
   161			 */
   162			if (!br_vlan_enabled(br->dev)) {
   163				br_port_set_promisc(p);
   164				continue;
   165			}
   166	
   167			/* If the number of auto-ports is <= 1, then all other ports
   168			 * will have their output configuration statically specified
   169			 * through fdbs. Since ingress on the auto-port becomes
   170			 * forwarding/egress to other ports and egress configuration is
   171			 * statically known, we can say that ingress configuration of
   172			 * the auto-port is also statically known.
   173			 * This lets us disable promiscuous mode and write this config
   174			 * to hw.
   175			 */
   176			if (br->auto_cnt == 0 ||
   177			    (br->auto_cnt == 1 && br_auto_port(p)))
   178				br_port_clear_promisc(p);
   179			else
   180				br_port_set_promisc(p);
   181		}
   182	}
   183	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
