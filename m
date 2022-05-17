Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A567052AEC7
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 01:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiEQXl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 19:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbiEQXlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 19:41:15 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44ED0255B4;
        Tue, 17 May 2022 16:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652830873; x=1684366873;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=imyt6uq+UNW0wKrhVYBLtxM7Mz/fgYTfzhpJI8C0tjo=;
  b=fQgWbzFhXFou8pozb1AC23chE9eteydchKAKAObyPkSh7LY/1nMhpbnm
   j5t363gtbrl/luNBiS/cmvGkjmbs8/LwS+xRgcrXFLCqIHUq6sTr10piZ
   5IhA+3vAWCbQmsizF6iV4ZAq7TSPHlLiqbQWstOF1R3/wIJXahWB3QCwB
   /FLqE1BNl1Md8rYIBjYMLXviZ3lo7Df8vQWEWVq+jEFfn+pZMqYt03dbJ
   yU48j1PhTSMVNRiVLxzAaW2jh/+fKGM9usfJtX9k8zyP4g7MBUuxQQ+Id
   EyxR21j/UDHu1aLFM6x+cBdqp1l4cH/pmZdUMoW5Apr4dubu6zUxmZ7RX
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="334428466"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="334428466"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 16:41:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="660853597"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 17 May 2022 16:41:08 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nr6oN-0001Zd-Va;
        Tue, 17 May 2022 23:41:07 +0000
Date:   Wed, 18 May 2022 07:40:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     longli@linuxonhyperv.com, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Long Li <longli@microsoft.com>
Subject: Re: [PATCH 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Message-ID: <202205180712.8ZVP06bH-lkp@intel.com>
References: <1652778276-2986-13-git-send-email-longli@linuxonhyperv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1652778276-2986-13-git-send-email-longli@linuxonhyperv.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.18-rc7 next-20220517]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/longli-linuxonhyperv-com/Introduce-Microsoft-Azure-Network-Adapter-MANA-RDMA-driver/20220517-170632
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 42226c989789d8da4af1de0c31070c96726d990c
config: x86_64-randconfig-a011-20220516 (https://download.01.org/0day-ci/archive/20220518/202205180712.8ZVP06bH-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/f082dc68ab65c498c978d574e62413d50286b4f9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review longli-linuxonhyperv-com/Introduce-Microsoft-Azure-Network-Adapter-MANA-RDMA-driver/20220517-170632
        git checkout f082dc68ab65c498c978d574e62413d50286b4f9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from <command-line>:
>> ./usr/include/rdma/mana-abi.h:12:10: fatal error: linux/mana/mana.h: No such file or directory
      12 | #include <linux/mana/mana.h>
         |          ^~~~~~~~~~~~~~~~~~~
   compilation terminated.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
