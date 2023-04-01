Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1D26D33F2
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 22:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjDAUvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 16:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjDAUvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 16:51:47 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3802700F;
        Sat,  1 Apr 2023 13:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680382306; x=1711918306;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N23LrCmIXbWTc0I8sjnRDXdeh+BfnU52W2myvp+hnDQ=;
  b=Bls3hMtseBK23gNL59IbrLd4AuWf/BNtwWMU1WZGDJhuYcmN7N6TbEtn
   InWrCdtT/BeprOOwDFzqOfspgA4U4ZzeN2XCzgMvQRAje7TUq31kk81kQ
   4J/ApWthIH1wx64+vVMQjsi05MKUBvcx3w98QDd5Dy4qBn+AFPII+wT1f
   jHIPwFGrTf9r0ONAXu+T6QD0552LHphT3BAnJ4s6Fcr3YQRRU/cW0BtKs
   vbVmMF3kSR48Mhto1fR864zYL5W8JPnLInH0XERy04ZRgV73fLRhOkyWu
   mfCWLPLjoLaXTN1LXOetxd0SUGwPtVAUyUdrPAs2KdSx0d93kE/+hwIGy
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="369481158"
X-IronPort-AV: E=Sophos;i="5.98,311,1673942400"; 
   d="scan'208";a="369481158"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 13:51:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="1015229352"
X-IronPort-AV: E=Sophos;i="5.98,311,1673942400"; 
   d="scan'208";a="1015229352"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 01 Apr 2023 13:51:39 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1piiCI-000N29-1n;
        Sat, 01 Apr 2023 20:51:38 +0000
Date:   Sun, 2 Apr 2023 04:51:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Christian Ehrig <cehrig@cloudflare.com>, bpf@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, cehrig@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/3] bpf,fou: Add bpf_skb_{set,get}_fou_encap
 kfuncs
Message-ID: <202304020425.L8MwfV5h-lkp@intel.com>
References: <65b05e447b28d32fb0e07275dc988989f358da2c.1680379518.git.cehrig@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65b05e447b28d32fb0e07275dc988989f358da2c.1680379518.git.cehrig@cloudflare.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christian,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Christian-Ehrig/ipip-ip_tunnel-sit-Add-FOU-support-for-externally-controlled-ipip-devices/20230402-033512
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
patch link:    https://lore.kernel.org/r/65b05e447b28d32fb0e07275dc988989f358da2c.1680379518.git.cehrig%40cloudflare.com
patch subject: [PATCH bpf-next 2/3] bpf,fou: Add bpf_skb_{set,get}_fou_encap kfuncs
config: microblaze-randconfig-r021-20230402 (https://download.01.org/0day-ci/archive/20230402/202304020425.L8MwfV5h-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/111ef54093a724110ca63e6a6279e60dd669094b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Christian-Ehrig/ipip-ip_tunnel-sit-Add-FOU-support-for-externally-controlled-ipip-devices/20230402-033512
        git checkout 111ef54093a724110ca63e6a6279e60dd669094b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=microblaze olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=microblaze SHELL=/bin/bash net/ipv4/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304020425.L8MwfV5h-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/ipv4/fou_bpf.c:114:5: warning: no previous prototype for 'register_fou_bpf' [-Wmissing-prototypes]
     114 | int register_fou_bpf(void)
         |     ^~~~~~~~~~~~~~~~


vim +/register_fou_bpf +114 net/ipv4/fou_bpf.c

   113	
 > 114	int register_fou_bpf(void)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
