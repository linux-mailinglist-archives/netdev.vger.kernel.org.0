Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 521EC67A974
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 05:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbjAYEAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 23:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjAYEAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 23:00:48 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4973B3DD;
        Tue, 24 Jan 2023 20:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674619246; x=1706155246;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bFcfCoc34iYDSEWU4hpN/Ow3DangmLoJDiVkUyyHicA=;
  b=LpMFYIsX/ubwORLihUuo8Ta0jJ72JUoqSzl7nnd/dp8VpflfAMFQtKlK
   RktUw8apEKYvxlL10TJzJ/CszmiiZSkHAsPHYA8UmGSMTglIRYpZGWdqB
   S4mKjbkDmlKsYcfIS6bqyUHWBwW2rxSVGdBDU144DsNNlCdMUEwF3aMhq
   Y6pZkkjzmjZnwJK9E19yblJQr31pNouOp3Pb1WrozqSgdWT4fPlX9huyJ
   9QabIc+hOpLR8VC2lQQUheBx1u7oz3ZZ6rqn5no/LH3jDNAwhhsUM5UNq
   7EyUGwdLjV3LcutUdGrO0I5k7IMdhsahuI6OHSI1rCVnPNk9kEn7+yIEE
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="324174286"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="324174286"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 20:00:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="692817992"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="692817992"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 24 Jan 2023 20:00:37 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pKWxg-00071S-1q;
        Wed, 25 Jan 2023 04:00:36 +0000
Date:   Wed, 25 Jan 2023 12:00:19 +0800
From:   kernel test robot <lkp@intel.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        pabeni@redhat.com, edumazet@google.com, toke@redhat.com,
        memxor@gmail.com, alardam@gmail.com, saeedm@nvidia.com,
        anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 bpf-next 2/8] drivers: net: turn on XDP features
Message-ID: <202301251150.xzkLwNpI-lkp@intel.com>
References: <c1171111f8af76da11331277b1e4a930c10f3c30.1674606197.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1171111f8af76da11331277b1e4a930c10f3c30.1674606197.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Bianconi/netdev-genl-create-a-simple-family-for-netdev-stuff/20230125-083645
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
patch link:    https://lore.kernel.org/r/c1171111f8af76da11331277b1e4a930c10f3c30.1674606197.git.lorenzo%40kernel.org
patch subject: [PATCH v2 bpf-next 2/8] drivers: net: turn on XDP features
config: arc-defconfig (https://download.01.org/0day-ci/archive/20230125/202301251150.xzkLwNpI-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/7dab4c7d96218eccccedd50e72c84e0ef4de0f4a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Lorenzo-Bianconi/netdev-genl-create-a-simple-family-for-netdev-stuff/20230125-083645
        git checkout 7dab4c7d96218eccccedd50e72c84e0ef4de0f4a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/core/xdp.c:777:6: error: redefinition of 'xdp_features_set_redirect_target'
     777 | void xdp_features_set_redirect_target(struct net_device *dev, bool support_sg)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/netdevice.h:43,
                    from include/linux/if_vlan.h:10,
                    from include/linux/filter.h:20,
                    from net/core/xdp.c:8:
   include/net/xdp.h:418:1: note: previous definition of 'xdp_features_set_redirect_target' with type 'void(struct net_device *, bool)' {aka 'void(struct net_device *, _Bool)'}
     418 | xdp_features_set_redirect_target(struct net_device *dev, bool support_sg)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> net/core/xdp.c:787:6: error: redefinition of 'xdp_features_clear_redirect_target'
     787 | void xdp_features_clear_redirect_target(struct net_device *dev)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/net/xdp.h:423:1: note: previous definition of 'xdp_features_clear_redirect_target' with type 'void(struct net_device *)'
     423 | xdp_features_clear_redirect_target(struct net_device *dev)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/xdp_features_set_redirect_target +777 net/core/xdp.c

   776	
 > 777	void xdp_features_set_redirect_target(struct net_device *dev, bool support_sg)
   778	{
   779		dev->xdp_features |= NETDEV_XDP_ACT_NDO_XMIT;
   780		if (support_sg)
   781			dev->xdp_features |= NETDEV_XDP_ACT_NDO_XMIT_SG;
   782	
   783		call_netdevice_notifiers(NETDEV_XDP_FEAT_CHANGE, dev);
   784	}
   785	EXPORT_SYMBOL_GPL(xdp_features_set_redirect_target);
   786	
 > 787	void xdp_features_clear_redirect_target(struct net_device *dev)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
