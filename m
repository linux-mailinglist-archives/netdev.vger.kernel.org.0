Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC7E4E4A4C
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 02:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240676AbiCWBHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 21:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbiCWBHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 21:07:08 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F606EC47
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 18:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647997539; x=1679533539;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KQnRpgPSv4g6mg/CIgrwCEl95p3ADl1S9sZenDHRx68=;
  b=m9tbf6bCnEZXByelkIXwU7dQQX+bK/8+H4qkTAK3nsE4Giy7h4YhKE3x
   BvfRe0oFP28HzYlnaQezg0c7jA4kKVHKVSwuQBXefQGerQOCkE1UFTvhW
   wxTq/HBHVyy/0rD+q8oFS4FqODUaYQP9iNLsBHDOOXqoY49IssnAXvF26
   qUxqY1Uwhmt9bTrzcWhR1CmGAERbhTjku217Jzbtef5MWRu1uYSPmnRnF
   dFj0/vbvenOc1Hu7WVaXrGDny5CR3Xs6EuArPy98qwVUm27CfBZVtkYAR
   rLkX1W3Ewesk2bx/K30dtT9P7tD2Dkvy4ccRZ8gv0pZzBR8rU8y3kubf3
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="257709352"
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="257709352"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 18:05:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="515600627"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 22 Mar 2022 18:05:36 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nWpRP-000JTP-UY; Wed, 23 Mar 2022 01:05:35 +0000
Date:   Wed, 23 Mar 2022 09:05:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        richardcochran@gmail.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, mlichvar@redhat.com,
        vinicius.gomes@intel.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: Re: [PATCH net-next v1 5/6] ptp: Support late timestamp determination
Message-ID: <202203230811.oaI4Q7IP-lkp@intel.com>
References: <20220322210722.6405-6-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322210722.6405-6-gerhard@engleder-embedded.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gerhard,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Gerhard-Engleder/ptp-Support-hardware-clocks-with-additional-free-running-time/20220323-051003
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 4a0cb83ba6e0cd73a50fa4f84736846bf0029f2b
config: hexagon-buildonly-randconfig-r004-20220320 (https://download.01.org/0day-ci/archive/20220323/202203230811.oaI4Q7IP-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 902f4708fe1d03b0de7e5315ef875006a6adc319)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/754e870cb9699166113d6ea383e48b0207165c1a
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Gerhard-Engleder/ptp-Support-hardware-clocks-with-additional-free-running-time/20220323-051003
        git checkout 754e870cb9699166113d6ea383e48b0207165c1a
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/spi/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from drivers/spi/spi.c:36:
>> include/linux/ptp_clock_kernel.h:418:1: error: expected identifier or '('
   { return 0; }
   ^
   1 error generated.


vim +418 include/linux/ptp_clock_kernel.h

   404	
   405	/**
   406	 * ptp_convert_timestamp() - convert timestamp to a ptp vclock time
   407	 *
   408	 * @hwtstamp:     timestamp
   409	 * @vclock_index: phc index of ptp vclock.
   410	 *
   411	 * Returns converted timestamp, or 0 on error.
   412	 */
   413	ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index);
   414	#else
   415	static inline ktime_t ptp_get_timestamp(int index,
   416						const struct skb_shared_hwtstamps *hwtstamps,
   417						bool cycles);
 > 418	{ return 0; }
   419	static inline int ptp_get_vclocks_index(int pclock_index, int **vclock_index)
   420	{ return 0; }
   421	static inline ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp,
   422						    int vclock_index)
   423	{ return 0; }
   424	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
