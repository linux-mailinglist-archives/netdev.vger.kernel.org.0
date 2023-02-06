Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1DE68C744
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 21:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjBFUIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 15:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjBFUIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 15:08:15 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCB611676
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 12:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675714094; x=1707250094;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aMFwD6y24c9U/6F/kLzZ1GVp+Tfyxjyjz3GHN4uf6aw=;
  b=JDKg8FvnN0886QjwMfmvSnOjtB8+oJXvs76/JAGVOyTwmsjqGqjZpl3R
   s49KXSTNrvvqbs02tc8OZJxgGYno9JxH6l+ypnmufbv5+g1FtUI9Fg6qb
   38zYYlfVYvDeCwspRmLnThm2f4esrroKaHTvIye3mpS+YiAYmQZiJTWEu
   J4q9ogeoUWWgpabVcjreOMoXR8DVK+vq1WUKBowgHTCtm8mmwR88np3hh
   MrjG7nakyp2vlNXxSHzPSYwFQ1SSZ3r1TvyG8Ts8PlLd01y0Ho8vaulXR
   +0KLCyNcBAzu9H92bqHjCRl961wVnNmWGZtV7NXMUgoHqLP9CbdM87iXL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="391699123"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="391699123"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 12:08:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="840484636"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="840484636"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 06 Feb 2023 12:08:12 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pP7md-0002l6-0n;
        Mon, 06 Feb 2023 20:08:11 +0000
Date:   Tue, 7 Feb 2023 04:07:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v3 net-next 1/4] net-sysctl: factor out cpumask parsing
 helper
Message-ID: <202302070311.gE92izdH-lkp@intel.com>
References: <f171c4f78c17c259deb0cae78a26dc274afe9fce.1675708062.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f171c4f78c17c259deb0cae78a26dc274afe9fce.1675708062.git.pabeni@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Paolo-Abeni/net-sysctl-factor-out-cpumask-parsing-helper/20230207-023315
patch link:    https://lore.kernel.org/r/f171c4f78c17c259deb0cae78a26dc274afe9fce.1675708062.git.pabeni%40redhat.com
patch subject: [PATCH v3 net-next 1/4] net-sysctl: factor out cpumask parsing helper
config: ia64-allyesconfig (https://download.01.org/0day-ci/archive/20230207/202302070311.gE92izdH-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f4b9914b6f1b7a7b3e416e1ef67db9ce6ad87f38
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Paolo-Abeni/net-sysctl-factor-out-cpumask-parsing-helper/20230207-023315
        git checkout f4b9914b6f1b7a7b3e416e1ef67db9ce6ad87f38
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/core/sysctl_net_core.c:49:6: warning: no previous prototype for 'dump_cpumask' [-Wmissing-prototypes]
      49 | void dump_cpumask(void *buffer, size_t *lenp, loff_t *ppos, struct cpumask *mask)
         |      ^~~~~~~~~~~~


vim +/dump_cpumask +49 net/core/sysctl_net_core.c

    47	
    48	#if IS_ENABLED(CONFIG_NET_FLOW_LIMIT)
  > 49	void dump_cpumask(void *buffer, size_t *lenp, loff_t *ppos, struct cpumask *mask)
    50	{
    51		char kbuf[128];
    52		int len;
    53	
    54		if (*ppos || !*lenp) {
    55			*lenp = 0;
    56			return;
    57		}
    58	
    59		len = min(sizeof(kbuf) - 1, *lenp);
    60		len = scnprintf(kbuf, len, "%*pb", cpumask_pr_args(mask));
    61		if (!len) {
    62			*lenp = 0;
    63			return;
    64		}
    65	
    66		if (len < *lenp)
    67			kbuf[len++] = '\n';
    68		memcpy(buffer, kbuf, len);
    69		*lenp = len;
    70		*ppos += len;
    71	}
    72	#endif
    73	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
