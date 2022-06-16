Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B382B54E554
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 16:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377103AbiFPOtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 10:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376284AbiFPOtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 10:49:07 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8212F29365
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 07:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655390946; x=1686926946;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4Y6huoQfUV0IGxRND8vZxr2VsTQzaCwzZmM0BbPl+Wg=;
  b=CSnEjSUdsZNgM2sqN/GOIG28YaxtBOJ4fXOMl841fWdN9L4KwqVaFgUt
   UqXYFLr5abX9tDKgGsiQT32qL5Y9SlNwWOhCpMNoqAnVBHkSG63Uv6/eX
   yWUCpxCu9/TJOmtijXoO5GLz+Oo7rZBJS0biL3r2Oa7T2szne/Kc9Z96y
   djOILHoCSZfXso/SoSf0+KwLaqwEJYe7MKKND/4kEu261IpnlzPNU+HWC
   OTxfC9nJzXw+uSgTh8REP5OL8UIUFbH6s5vNT2wYw/CNKzUF+rBqzYGIq
   4hNWHOX/yYsjNZONi3uj6CyI9x34DiI+A0RjIW8sxw7MCE6nEWjf+G16m
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="276839334"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="276839334"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 07:49:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="613185472"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 16 Jun 2022 07:49:03 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o1qnu-000OT7-Kg;
        Thu, 16 Jun 2022 14:49:02 +0000
Date:   Thu, 16 Jun 2022 22:48:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCHv2 net-next] Bonding: add per-port priority for failover
 re-selection
Message-ID: <202206162221.Oqz0N9WH-lkp@intel.com>
References: <20220615032934.2057120-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615032934.2057120-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hangbin,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Hangbin-Liu/Bonding-add-per-port-priority-for-failover-re-selection/20220615-113309
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 6ac6dc746d70ef9b4ac835d98ac1baf63a810c57
config: i386-randconfig-a005 (https://download.01.org/0day-ci/archive/20220616/202206162221.Oqz0N9WH-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/2ab299e7237ababa2ce05baa6035154fa04b272d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Hangbin-Liu/Bonding-add-per-port-priority-for-failover-re-selection/20220615-113309
        git checkout 2ab299e7237ababa2ce05baa6035154fa04b272d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/bonding/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/bonding/bond_netlink.c: In function 'bond_slave_changelink':
>> drivers/net/bonding/bond_netlink.c:174:23: error: too few arguments to function '__bond_opt_set'
     174 |                 err = __bond_opt_set(bond, BOND_OPT_PRIO, &newval);
         |                       ^~~~~~~~~~~~~~
   In file included from include/net/bonding.h:31,
                    from drivers/net/bonding/bond_netlink.c:16:
   include/net/bond_options.h:110:5: note: declared here
     110 | int __bond_opt_set(struct bonding *bond, unsigned int option,
         |     ^~~~~~~~~~~~~~


vim +/__bond_opt_set +174 drivers/net/bonding/bond_netlink.c

   138	
   139	static int bond_slave_changelink(struct net_device *bond_dev,
   140					 struct net_device *slave_dev,
   141					 struct nlattr *tb[], struct nlattr *data[],
   142					 struct netlink_ext_ack *extack)
   143	{
   144		struct bonding *bond = netdev_priv(bond_dev);
   145		struct bond_opt_value newval;
   146		int err;
   147	
   148		if (!data)
   149			return 0;
   150	
   151		if (data[IFLA_BOND_SLAVE_QUEUE_ID]) {
   152			u16 queue_id = nla_get_u16(data[IFLA_BOND_SLAVE_QUEUE_ID]);
   153			char queue_id_str[IFNAMSIZ + 7];
   154	
   155			/* queue_id option setting expects slave_name:queue_id */
   156			snprintf(queue_id_str, sizeof(queue_id_str), "%s:%u\n",
   157				 slave_dev->name, queue_id);
   158			bond_opt_initstr(&newval, queue_id_str);
   159			err = __bond_opt_set(bond, BOND_OPT_QUEUE_ID, &newval,
   160					     data[IFLA_BOND_SLAVE_QUEUE_ID], extack);
   161			if (err)
   162				return err;
   163		}
   164	
   165		if (data[IFLA_BOND_SLAVE_PRIO]) {
   166			int prio = nla_get_s32(data[IFLA_BOND_SLAVE_PRIO]);
   167			char prio_str[IFNAMSIZ + 7];
   168	
   169			/* prio option setting expects slave_name:prio */
   170			snprintf(prio_str, sizeof(prio_str), "%s:%d\n",
   171				 slave_dev->name, prio);
   172	
   173			bond_opt_initstr(&newval, prio_str);
 > 174			err = __bond_opt_set(bond, BOND_OPT_PRIO, &newval);
   175			if (err)
   176				return err;
   177		}
   178	
   179		return 0;
   180	}
   181	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
