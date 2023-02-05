Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 747CB68AE00
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 03:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbjBECDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 21:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjBECDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 21:03:11 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D984ED2
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 18:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675562590; x=1707098590;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0vitMxx9UI0aEaOTDTV8/5KdlIx/caeyeekfZgZMTWs=;
  b=ey3SmcXhlcsi4Qkonzs6kELvgRORJmbQihkglBXg2I4ubfB7Q5nQM/5m
   Di1hVsuAHEAWhtpJFQFtgu1kCuSRTvxcRn4/s49nN/yrMUFTiN0+lw+8o
   J5LMVnqFpv52/LRRgU7uH/4oEspVk/xlHyHGwsdwa0AobaWwu9TNztnDh
   q18/GUKawZXpv/zBu+R9OSatlNSHMfpBwbijKnRkpjDSSKSAFvYPXLM37
   ubumUAeQz0EY1Y8l0huVy5OLxN32FdrBG9rAJtI/BzRp1q4tV2WHn2PE/
   UExqX8Ws7qv+17mQYOLBe1uj/8sn0Y9yX+zv69KE64zs6WG+e2gnRO+0m
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10611"; a="308650296"
X-IronPort-AV: E=Sophos;i="5.97,274,1669104000"; 
   d="scan'208";a="308650296"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2023 18:03:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10611"; a="643663526"
X-IronPort-AV: E=Sophos;i="5.97,274,1669104000"; 
   d="scan'208";a="643663526"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 04 Feb 2023 18:03:04 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pOUMx-0001eu-2a;
        Sun, 05 Feb 2023 02:03:03 +0000
Date:   Sun, 5 Feb 2023 10:02:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>, dev@openvswitch.org
Cc:     oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCH net-next 5/5] net: extract nf_ct_handle_fragments to
 nf_conntrack_ovs
Message-ID: <202302050907.QhHYY6qZ-lkp@intel.com>
References: <658ca267b02decd564d52139274a0076d164e312.1675548023.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <658ca267b02decd564d52139274a0076d164e312.1675548023.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xin,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Xin-Long/net-create-nf_conntrack_ovs-for-ovs-and-tc-use/20230205-060514
patch link:    https://lore.kernel.org/r/658ca267b02decd564d52139274a0076d164e312.1675548023.git.lucien.xin%40gmail.com
patch subject: [PATCH net-next 5/5] net: extract nf_ct_handle_fragments to nf_conntrack_ovs
config: s390-defconfig (https://download.01.org/0day-ci/archive/20230205/202302050907.QhHYY6qZ-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/a0329da66336f34ae6ec5db5b6e5224ffcf01d0c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Xin-Long/net-create-nf_conntrack_ovs-for-ovs-and-tc-use/20230205-060514
        git checkout a0329da66336f34ae6ec5db5b6e5224ffcf01d0c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "nf_ct_handle_fragments" [net/openvswitch/openvswitch.ko] undefined!
ERROR: modpost: "nf_ct_helper" [net/openvswitch/openvswitch.ko] undefined!
ERROR: modpost: "nf_ct_add_helper" [net/openvswitch/openvswitch.ko] undefined!
ERROR: modpost: "nf_ct_skb_network_trim" [net/openvswitch/openvswitch.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
