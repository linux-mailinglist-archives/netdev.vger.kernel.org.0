Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3AB53B023
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 00:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbiFAWC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 18:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbiFAWC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 18:02:28 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D8AB86F
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 15:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654120947; x=1685656947;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3z/j317NlI3xcyDNldMXZQ5CSLJfGKteu9YPUIwxMaU=;
  b=jm8fMrFauV2CZ6hSVMtR+0YX75kDWAQhY+CBVOqmPsodPFkNwsTG9OAu
   yf/ZP9BJtxILSJVf9RD42OvbhkBvP+oDdzhMCcyIs8U4l0oW6LU5JR8B3
   BLvQ1S9Q+kbU+6tn4EU4YxICdPAUEPsUuRvXiaGEQdjI/6Ytr/H5OrsR7
   iHTLNeXQbXHJlGrkkEBWKm6kaUZ7aOypVvx02bLJLp0kFgH8MFEDPb2Mg
   G66an5ddTfKsGzMxESlWdi4NDBYMvvMikUJHZ1UTHlgVM6fuD3xXjUJ/m
   dfI3jb64PLIXmg7TLDwL6F8aX6wc6c1GopQOw8yQwvhGOdhym85Kb/2HJ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="275470140"
X-IronPort-AV: E=Sophos;i="5.91,269,1647327600"; 
   d="scan'208";a="275470140"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 15:02:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,269,1647327600"; 
   d="scan'208";a="581789970"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 01 Jun 2022 15:02:24 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nwWQ4-0004SW-4C;
        Wed, 01 Jun 2022 22:02:24 +0000
Date:   Thu, 2 Jun 2022 06:01:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net 1/2] net: add debug info to __skb_pull()
Message-ID: <202206020557.QyvlGs0H-lkp@intel.com>
References: <20220531185933.1086667-2-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220531185933.1086667-2-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Yet something to improve:

[auto build test ERROR on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/net-af_packet-be-careful-when-expanding-mac-header-size/20220601-030146
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 09e545f7381459c015b6fa0cd0ac6f010ef8cc25
config: hexagon-randconfig-r002-20220531 (https://download.01.org/0day-ci/archive/20220602/202206020557.QyvlGs0H-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c825abd6b0198fb088d9752f556a70705bc99dfd)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/a907c048e7699133feedaa06948c15c719a59f94
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Eric-Dumazet/net-af_packet-be-careful-when-expanding-mac-header-size/20220601-030146
        git checkout a907c048e7699133feedaa06948c15c719a59f94
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: skb_dump
   >>> referenced by cgroup.c
   >>>               bpf/cgroup.o:(__cgroup_bpf_run_filter_skb) in archive kernel/built-in.a
   >>> referenced by cgroup.c
   >>>               bpf/cgroup.o:(__cgroup_bpf_run_filter_skb) in archive kernel/built-in.a

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
