Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3F44D6982
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 21:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351194AbiCKUfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 15:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236514AbiCKUfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 15:35:15 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845411CBA83;
        Fri, 11 Mar 2022 12:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647030851; x=1678566851;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VNO9aR6ZlUQ1VivRTLNBPxlOoJygXM0cpiuy5f1w6pA=;
  b=hA4PIB6c4h8PtGY15F7+muULWpRKsER/3CtNvJAgdzuDHNq3lEKp6hB7
   +/shU6S9ZYhOCxrGEg1YZvNdcAdqtAPDLCE4X2iNQs55xS6OdZYn2Vzk9
   O/luiqjpt7uSeA8GYw+tx5Gz4o6iPlnZcCJgtooQfDgc4DPaaAq9H60UT
   N9/NaUItkX3dE3fyBj8LL8StAnV0X/53NU74+ZagD36mvBlHPW/IA4AqC
   5zZ0Jd8ic0dHtijPSwMziY/dOGoh+31cjagsJvYGoHX1FVZNpcZD9m0X0
   bSHxXs83IJliZSfBJDyYQZx7OtobuylM6fOoYT3ckV0MsxB4ODtCX+1mc
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10283"; a="280394715"
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="280394715"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 12:34:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="579408523"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 11 Mar 2022 12:34:05 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nSlxc-000737-VD; Fri, 11 Mar 2022 20:34:04 +0000
Date:   Sat, 12 Mar 2022 04:34:01 +0800
From:   kernel test robot <lkp@intel.com>
To:     menglong8.dong@gmail.com, dsahern@kernel.org, kuba@kernel.org
Cc:     kbuild-all@lists.01.org, nhorman@tuxdriver.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, davem@davemloft.net, imagedong@tencent.com,
        edumazet@google.com, talalahmad@google.com, keescook@chromium.org,
        alobakin@pm.me, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Mengen Sun <mengensun@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: Re: [PATCH] net: skb: move enum skb_drop_reason to uapi
Message-ID: <202203120451.wHvod29d-lkp@intel.com>
References: <20220311032828.702392-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311032828.702392-1-imagedong@tencent.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on next-20220310]
[cannot apply to linus/master v5.17-rc7 v5.17-rc6 v5.17-rc5 v5.17-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/menglong8-dong-gmail-com/net-skb-move-enum-skb_drop_reason-to-uapi/20220311-113243
base:    71941773e143369a73c9c4a3b62fbb60736a1182
config: i386-randconfig-a014 (https://download.01.org/0day-ci/archive/20220312/202203120451.wHvod29d-lkp@intel.com/config)
compiler: gcc-9 (Ubuntu 9.4.0-1ubuntu1~20.04) 9.4.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/94a9a43cb9a6ba2e57d73b63226cbda08d24f6a2
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review menglong8-dong-gmail-com/net-skb-move-enum-skb_drop_reason-to-uapi/20220311-113243
        git checkout 94a9a43cb9a6ba2e57d73b63226cbda08d24f6a2
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from <command-line>:32:
>> ./usr/include/linux/net_dropmon.h:6:10: fatal error: uapi/linux/netlink.h: No such file or directory
       6 | #include <uapi/linux/netlink.h>
         |          ^~~~~~~~~~~~~~~~~~~~~~
   compilation terminated.

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
