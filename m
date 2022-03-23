Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28AFC4E4AB9
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 03:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbiCWCIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 22:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbiCWCIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 22:08:10 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF766F484
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 19:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648001201; x=1679537201;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=c6kCEefIb3Hrpw1mbxiEREzW+yJ/0qaXMwwd2UlQRVQ=;
  b=bepPHMYvSCgdA9M0gtXCcJziPdp7hP/1EvEODMebIcApj6purpUDYbOt
   9E0TMAlMxRhAx4vK21suSftPvJv0M/4SnkfQ7bgH3bQ11/KeuLf0LHs3p
   LgWC7E9PwNXJiVhAa0oD5jcbYO6nLZzbAU4hX5CvXyWqWVv4MdjWbpjhu
   QoU77izqpq4ttnJ7zI2pxw7YY4e2bHsvqclLyhHNaebrU3yQI6S3BTkEi
   isfQmM4QxpSn3i4xO3mR+WfXPruyp6JiqJCIgDCfg3S+xo292sH2PJFsk
   m3k7XdXsNUFO4+5Ouf5YUqXaHSZVNQO0QAvTmjV8zi4gmxDntO61wzsGg
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="255563427"
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="255563427"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 19:06:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="500834407"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 22 Mar 2022 19:06:38 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nWqOU-000JX2-1E; Wed, 23 Mar 2022 02:06:38 +0000
Date:   Wed, 23 Mar 2022 10:06:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        richardcochran@gmail.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     kbuild-all@lists.01.org, mlichvar@redhat.com,
        vinicius.gomes@intel.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: Re: [PATCH net-next v1 5/6] ptp: Support late timestamp determination
Message-ID: <202203231015.YRlUe3av-lkp@intel.com>
References: <20220322210722.6405-6-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322210722.6405-6-gerhard@engleder-embedded.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gerhard,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Gerhard-Engleder/ptp-Support-hardware-clocks-with-additional-free-running-time/20220323-051003
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 4a0cb83ba6e0cd73a50fa4f84736846bf0029f2b
config: nios2-randconfig-r023-20220321 (https://download.01.org/0day-ci/archive/20220323/202203231015.YRlUe3av-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/754e870cb9699166113d6ea383e48b0207165c1a
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Gerhard-Engleder/ptp-Support-hardware-clocks-with-additional-free-running-time/20220323-051003
        git checkout 754e870cb9699166113d6ea383e48b0207165c1a
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=nios2 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from net/socket.c:108:
   include/linux/ptp_clock_kernel.h:418:1: error: expected identifier or '(' before '{' token
     418 | { return 0; }
         | ^
   net/socket.c: In function '__sys_getsockopt':
   net/socket.c:2227:13: warning: variable 'max_optlen' set but not used [-Wunused-but-set-variable]
    2227 |         int max_optlen;
         |             ^~~~~~~~~~
   In file included from net/socket.c:108:
   net/socket.c: At top level:
>> include/linux/ptp_clock_kernel.h:415:23: warning: 'ptp_get_timestamp' used but never defined
     415 | static inline ktime_t ptp_get_timestamp(int index,
         |                       ^~~~~~~~~~~~~~~~~


vim +/ptp_get_timestamp +415 include/linux/ptp_clock_kernel.h

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
 > 415	static inline ktime_t ptp_get_timestamp(int index,
   416						const struct skb_shared_hwtstamps *hwtstamps,
   417						bool cycles);
   418	{ return 0; }
   419	static inline int ptp_get_vclocks_index(int pclock_index, int **vclock_index)
   420	{ return 0; }
   421	static inline ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp,
   422						    int vclock_index)
   423	{ return 0; }
   424	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
