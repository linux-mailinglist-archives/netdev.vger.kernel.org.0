Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0812452DD46
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 20:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244215AbiESS7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 14:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243643AbiESS7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 14:59:37 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EE9ABF49;
        Thu, 19 May 2022 11:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652986776; x=1684522776;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OLDQkJZ+ZvpLDZPw/CW1n9AI9FFsLGC/saBab6KRAO8=;
  b=I/H+XBGacemcUak+frTuB7Mn/ueUlWzq5FIyNpIeSpE3CVGC/NBClxbR
   Kjm8TUrxdLUgoQVCd1rviuc3usCXXXwZiigGyKarelw4suPWq8s6M1DTm
   iJBRBBAYCYhYVV3NfG1aHLAWyk6LNZ1CWrViatrVBAbQX7Rj5SzgxF/JI
   fWeSS9HsJieT9vRrUhhPu/Te3uJ8ILD51H+KJgHfT30exmbOQGBeUmA5q
   fYS/LTamPEJjOuDRv0n6eQbIg3BrPy1EjskHhBMIUlOT+P7qbVf5V4hJl
   dPd23EKKQful+amRXlBt6SmMiG2AUGRIwf44j65r5loLIHuRKuomywZiO
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="272297163"
X-IronPort-AV: E=Sophos;i="5.91,237,1647327600"; 
   d="scan'208";a="272297163"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 11:59:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,237,1647327600"; 
   d="scan'208";a="818133987"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by fmsmga006.fm.intel.com with ESMTP; 19 May 2022 11:59:31 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nrlMx-0003ro-90;
        Thu, 19 May 2022 18:59:31 +0000
Date:   Fri, 20 May 2022 02:58:44 +0800
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
Subject: Re: [PATCH 01/12] net: mana: Add support for auxiliary device
Message-ID: <202205200250.8xo3zYa3-lkp@intel.com>
References: <1652778276-2986-2-git-send-email-longli@linuxonhyperv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1652778276-2986-2-git-send-email-longli@linuxonhyperv.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.18-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/longli-linuxonhyperv-com/Introduce-Microsoft-Azure-Network-Adapter-MANA-RDMA-driver/20220517-170632
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 42226c989789d8da4af1de0c31070c96726d990c
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20220520/202205200250.8xo3zYa3-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/5c9b22b8d4038fba4019bb1e5bcda9a101d285b7
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review longli-linuxonhyperv-com/Introduce-Microsoft-Azure-Network-Adapter-MANA-RDMA-driver/20220517-170632
        git checkout 5c9b22b8d4038fba4019bb1e5bcda9a101d285b7
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/infiniband/hw/ drivers/net/ethernet/microsoft/mana/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/microsoft/mana/mana_en.c:18:5: warning: no previous prototype for 'mana_adev_idx_alloc' [-Wmissing-prototypes]
      18 | int mana_adev_idx_alloc(void)
         |     ^~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/microsoft/mana/mana_en.c:23:6: warning: no previous prototype for 'mana_adev_idx_free' [-Wmissing-prototypes]
      23 | void mana_adev_idx_free(int idx)
         |      ^~~~~~~~~~~~~~~~~~


vim +/mana_adev_idx_alloc +18 drivers/net/ethernet/microsoft/mana/mana_en.c

    17	
  > 18	int mana_adev_idx_alloc(void)
    19	{
    20		return ida_alloc(&mana_adev_ida, GFP_KERNEL);
    21	}
    22	
  > 23	void mana_adev_idx_free(int idx)
    24	{
    25		ida_free(&mana_adev_ida, idx);
    26	}
    27	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
