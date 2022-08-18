Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC1A1597FA8
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 10:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243935AbiHRH6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 03:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243931AbiHRH6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 03:58:39 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E081836D
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 00:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660809518; x=1692345518;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jf8R4CeCCKCAljJ2bYoz3kLzZcptBlO4cIQBGrBtZpA=;
  b=UDTco351sDx5eI5PoxClLJnqTMP9E0UYdMgbolwlqXf+IGaSr65I+hAJ
   FAc+Ax9Mv6Rs4S6cceUaycHWel7yLE7GvkjTb7nzoCmprF5LYDqVqi7Lv
   R18IRiwvNvWPC/OjcZizroh9hl3ms3N/0tEu0wuv0ncDIMA/0xNLm1Tlx
   ANprOOQYL+0lEPOqzQrL9OD/sPaZVpIeG13yOr6CQCVh18EoPwvdF+1IF
   ZN1BaSGcL84zjryoeqE524mP5bgM78UyQFNMm93WCY6kkPHXavNt9Hkwj
   lEav+5PlACW4hjTpNp4EHmISSxnBzIxpF+13bsBcOlp/YJm2wEOyFKHxK
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="356686298"
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="356686298"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 00:58:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="710864535"
Received: from lkp-server01.sh.intel.com (HELO 6cc724e23301) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2022 00:58:35 -0700
Received: from kbuild by 6cc724e23301 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oOaQE-0000Dz-2z;
        Thu, 18 Aug 2022 07:58:34 +0000
Date:   Thu, 18 Aug 2022 15:58:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: Re: [PATCH v2 net 13/17] net: Fix data-races around
 sysctl_fb_tunnels_only_for_init_net.
Message-ID: <202208181501.0Ip3aKFx-lkp@intel.com>
References: <20220818035227.81567-14-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818035227.81567-14-kuniyu@amazon.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kuniyuki,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Kuniyuki-Iwashima/net-sysctl-Fix-data-races-around-net-core-XXX/20220818-115941
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git fc4aaf9fb3c99bcb326d52f9d320ed5680bd1cee
config: mips-randconfig-r035-20220818 (https://download.01.org/0day-ci/archive/20220818/202208181501.0Ip3aKFx-lkp@intel.com/config)
compiler: mips64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/6bc3dfb3dc4862f4e00ba93c45cd5c0251b85d5b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kuniyuki-Iwashima/net-sysctl-Fix-data-races-around-net-core-XXX/20220818-115941
        git checkout 6bc3dfb3dc4862f4e00ba93c45cd5c0251b85d5b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   mips64-linux-ld: mips64-linux-ld: DWARF error: could not find abbrev number 127
   net/ipv4/ip_tunnel.o: in function `ip_tunnel_init_net':
>> net/ipv4/ip_tunnel.c:(.text.ip_tunnel_init_net+0x118): undefined reference to `sysctl_fb_tunnels_only_for_init_net'
>> mips64-linux-ld: net/ipv4/ip_tunnel.c:(.text.ip_tunnel_init_net+0x128): undefined reference to `sysctl_fb_tunnels_only_for_init_net'
   mips64-linux-ld: mips64-linux-ld: DWARF error: could not find abbrev number 2060
   net/ipv6/ip6_vti.o: in function `vti6_init_net':
>> net/ipv6/ip6_vti.c:(.init.text+0x1f8): undefined reference to `sysctl_fb_tunnels_only_for_init_net'
>> mips64-linux-ld: net/ipv6/ip6_vti.c:(.init.text+0x1fc): undefined reference to `sysctl_fb_tunnels_only_for_init_net'
   mips64-linux-ld: mips64-linux-ld: DWARF error: could not find abbrev number 913972
   net/ipv6/sit.o: in function `sit_init_net':
>> net/ipv6/sit.c:(.init.text+0x154): undefined reference to `sysctl_fb_tunnels_only_for_init_net'
   mips64-linux-ld: net/ipv6/sit.o:net/ipv6/sit.c:(.init.text+0x158): more undefined references to `sysctl_fb_tunnels_only_for_init_net' follow

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
