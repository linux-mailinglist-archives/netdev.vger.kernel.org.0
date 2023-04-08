Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99E56DB9F7
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 11:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjDHJ5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 05:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDHJ5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 05:57:49 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA206A67;
        Sat,  8 Apr 2023 02:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680947867; x=1712483867;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yVhRaml7AsllbdxM7IiG7fKmnog0vHKgWdc+YYx0oMQ=;
  b=L8baVNtdsriqar3klRid+lDbzT6vEcq6lIpyxzo99zH953NV2SARCxo0
   W7IiZQ9n5cwMFKHR/101Ogk3JpWONTHO+Yp3k+YD4KVk3XklfNC6o8N25
   Rxnoi7t4shKQjZHF/UDL9yIowNc74DrLZNBK+tmI22obUt74BeJfoziwR
   lPuKqf4CeSlM8LIYqlG2EgRu2+KI6w8hQKr1VnLxhmD6LMJ1FvbEbBLs0
   ATalLkmtFrGMIGin37OGvuNFkYi4JRcUU/XckQOJ3n+qk1X9lXM7P+xTD
   ABWsDF+Hop2biQH+hBSA+LPBEcE1Y5jkikpxtYxsuP/miJYRKK0MPVf5h
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="429414071"
X-IronPort-AV: E=Sophos;i="5.98,329,1673942400"; 
   d="scan'208";a="429414071"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2023 02:57:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="756952505"
X-IronPort-AV: E=Sophos;i="5.98,329,1673942400"; 
   d="scan'208";a="756952505"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 08 Apr 2023 02:57:43 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pl5KJ-000Tbr-0L;
        Sat, 08 Apr 2023 09:57:43 +0000
Date:   Sat, 8 Apr 2023 17:57:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Chen Aotian <chenaotian2@163.com>, alex.aring@gmail.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        stefan@datenfreihafen.org, miquel.raynal@bootlin.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Chen Aotian <chenaotian2@163.com>
Subject: Re: [PATH wpan v2] ieee802154: hwsim: Fix possible memory leaks
Message-ID: <202304081742.rOfPXJln-lkp@intel.com>
References: <20230408081934.54002-1-chenaotian2@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408081934.54002-1-chenaotian2@163.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chen,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]
[also build test ERROR on net/main linus/master v6.3-rc5 next-20230406]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Chen-Aotian/ieee802154-hwsim-Fix-possible-memory-leaks/20230408-162130
patch link:    https://lore.kernel.org/r/20230408081934.54002-1-chenaotian2%40163.com
patch subject: [PATH wpan v2] ieee802154: hwsim: Fix possible memory leaks
config: hexagon-randconfig-r015-20230406 (https://download.01.org/0day-ci/archive/20230408/202304081742.rOfPXJln-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 2c57868e2e877f73c339796c3374ae660bb77f0d)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1a9fcf2d1438f9603039670041da5ed90471a4e5
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Chen-Aotian/ieee802154-hwsim-Fix-possible-memory-leaks/20230408-162130
        git checkout 1a9fcf2d1438f9603039670041da5ed90471a4e5
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/net/ieee802154/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304081742.rOfPXJln-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/net/ieee802154/mac802154_hwsim.c:17:
   In file included from include/linux/rtnetlink.h:7:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
                                                     ^
   In file included from drivers/net/ieee802154/mac802154_hwsim.c:17:
   In file included from include/linux/rtnetlink.h:7:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
                                                     ^
   In file included from drivers/net/ieee802154/mac802154_hwsim.c:17:
   In file included from include/linux/rtnetlink.h:7:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
>> drivers/net/ieee802154/mac802154_hwsim.c:727:21: error: incompatible pointer types passing 'struct mutex *' to parameter of type 'const struct lockdep_map *' [-Werror,-Wincompatible-pointer-types]
                                                           lock_is_held(&hwsim_phys_lock));
                                                                        ^~~~~~~~~~~~~~~~
   include/linux/rcupdate.h:542:60: note: expanded from macro 'rcu_replace_pointer'
           typeof(ptr) __tmp = rcu_dereference_protected((rcu_ptr), (c));  \
                                                                     ^
   include/linux/rcupdate.h:673:54: note: expanded from macro 'rcu_dereference_protected'
           __rcu_dereference_protected((p), __UNIQUE_ID(rcu), (c), __rcu)
                                                               ^
   include/linux/rcupdate.h:469:21: note: expanded from macro '__rcu_dereference_protected'
           RCU_LOCKDEP_WARN(!(c), "suspicious rcu_dereference_protected() usage"); \
                              ^
   include/linux/rcupdate.h:389:39: note: expanded from macro 'RCU_LOCKDEP_WARN'
                   if (debug_lockdep_rcu_enabled() && (c) &&               \
                                                       ^
   include/linux/lockdep.h:281:58: note: passing argument to parameter 'lock' here
   static inline int lock_is_held(const struct lockdep_map *lock)
                                                            ^
   6 warnings and 1 error generated.


vim +727 drivers/net/ieee802154/mac802154_hwsim.c

   684	
   685	static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *info)
   686	{
   687		struct nlattr *edge_attrs[MAC802154_HWSIM_EDGE_ATTR_MAX + 1];
   688		struct hwsim_edge_info *einfo, *einfo_old;
   689		struct hwsim_phy *phy_v0;
   690		struct hwsim_edge *e;
   691		u32 v0, v1;
   692		u8 lqi;
   693	
   694		if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] ||
   695		    !info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE])
   696			return -EINVAL;
   697	
   698		if (nla_parse_nested_deprecated(edge_attrs, MAC802154_HWSIM_EDGE_ATTR_MAX, info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE], hwsim_edge_policy, NULL))
   699			return -EINVAL;
   700	
   701		if (!edge_attrs[MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID] ||
   702		    !edge_attrs[MAC802154_HWSIM_EDGE_ATTR_LQI])
   703			return -EINVAL;
   704	
   705		v0 = nla_get_u32(info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID]);
   706		v1 = nla_get_u32(edge_attrs[MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID]);
   707		lqi = nla_get_u8(edge_attrs[MAC802154_HWSIM_EDGE_ATTR_LQI]);
   708	
   709		mutex_lock(&hwsim_phys_lock);
   710		phy_v0 = hwsim_get_radio_by_id(v0);
   711		if (!phy_v0) {
   712			mutex_unlock(&hwsim_phys_lock);
   713			return -ENOENT;
   714		}
   715	
   716		einfo = kzalloc(sizeof(*einfo), GFP_KERNEL);
   717		if (!einfo) {
   718			mutex_unlock(&hwsim_phys_lock);
   719			return -ENOMEM;
   720		}
   721	
   722		rcu_read_lock();
   723		list_for_each_entry_rcu(e, &phy_v0->edges, list) {
   724			if (e->endpoint->idx == v1) {
   725				einfo->lqi = lqi;
   726				einfo_old = rcu_replace_pointer(e->info, einfo,
 > 727								lock_is_held(&hwsim_phys_lock));
   728				rcu_read_unlock();
   729				kfree_rcu(einfo_old, rcu);
   730				mutex_unlock(&hwsim_phys_lock);
   731				return 0;
   732			}
   733		}
   734		rcu_read_unlock();
   735	
   736		kfree(einfo);
   737		mutex_unlock(&hwsim_phys_lock);
   738	
   739		return -ENOENT;
   740	}
   741	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
