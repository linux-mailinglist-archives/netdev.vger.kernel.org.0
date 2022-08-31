Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5ADA5A7325
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 03:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbiHaBDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 21:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiHaBDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 21:03:51 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DADAAEDAC;
        Tue, 30 Aug 2022 18:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661907829; x=1693443829;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZZuvi0B/Gtgt7aqGUa3waYjoHFd0myWxVgCqaj6jMyo=;
  b=QQHvSAeRTJA46roKqeruOQw6PzyAbWmN3ZC7xVtUjYGiYRqOqU4Vglut
   m/93Co2JfJytw9jx/b0o0ms3XL8qZ9wZU+cLQFGfQhHs1ddI1HLBOXcem
   NtH72LjPiPzhsk0x7zwSk7+2GSPTxX6sWW3Bm4F06zg22FOtUsP3wahlg
   wdIdM9gRCuUs+4vy75JWKDtPIbanPEhtfnUQa/axBFhzm3coHFBhrotjM
   9kgV1dz4gXezMwPlQbT9ooqHWKx/tBsACGqbrRCEhEXm7M6QIDKoeFxAz
   IGj5AI4Z4AJMkf7UXRDPEhlzQs0SWpkCVYCz5PnE3B1h96zoG9Apdk0I8
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="292919299"
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="292919299"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 18:03:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="940257117"
Received: from lkp-server02.sh.intel.com (HELO 77b6d4e16fc5) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 30 Aug 2022 18:03:41 -0700
Received: from kbuild by 77b6d4e16fc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oTC8r-0000ox-0q;
        Wed, 31 Aug 2022 01:03:41 +0000
Date:   Wed, 31 Aug 2022 09:03:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     Koba Ko <koba.ko@canonical.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: Re: crypto: ccp - Release dma channels before dmaengine unrgister
Message-ID: <202208310843.cesiRP88-lkp@intel.com>
References: <20220830093439.951960-1-koba.ko@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830093439.951960-1-koba.ko@canonical.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Koba,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master linus/master v6.0-rc3 next-20220830]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Koba-Ko/crypto-ccp-Release-dma-channels-before-dmaengine-unrgister/20220830-173803
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20220831/202208310843.cesiRP88-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/5aa373b58528f3f99c5a010e76728776f0240603
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Koba-Ko/crypto-ccp-Release-dma-channels-before-dmaengine-unrgister/20220830-173803
        git checkout 5aa373b58528f3f99c5a010e76728776f0240603
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/crypto/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/crypto/ccp/ccp-dmaengine.c: In function 'ccp_dmaengine_unregister':
>> drivers/crypto/ccp/ccp-dmaengine.c:770:22: warning: unused variable 'i' [-Wunused-variable]
     770 |         unsigned int i;
         |                      ^
>> drivers/crypto/ccp/ccp-dmaengine.c:769:26: warning: unused variable 'dma_chan' [-Wunused-variable]
     769 |         struct dma_chan *dma_chan;
         |                          ^~~~~~~~


vim +/i +770 drivers/crypto/ccp/ccp-dmaengine.c

   765	
   766	void ccp_dmaengine_unregister(struct ccp_device *ccp)
   767	{
   768		struct dma_device *dma_dev = &ccp->dma_dev;
 > 769		struct dma_chan *dma_chan;
 > 770		unsigned int i;

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
