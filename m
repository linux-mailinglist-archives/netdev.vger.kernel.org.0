Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52071592705
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 02:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiHOAA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 20:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiHOAA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 20:00:26 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A47B63B5
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 17:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660521625; x=1692057625;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2HqQoy1RQrINR2FAUEyPHD0UYRtp3j3rvEucZNY90A4=;
  b=WbVD0CnLGajrA2O9EG5hCbzAv4/zSL4Ela2IKJHH3oAf0o7+CnijWfM2
   B2pQxAYteWPSQWUDO3KYpaUr8Y/roEu460CaDsv6iAPb4gifN/CpQ+E3e
   oM95ueUehkPZHyVOy/CJ99FLx4YTrQYOn57ZHSmQkplnUIQW0420WnJrL
   J4JvLNs6gllmfFXgouOUGMfHfgUEHjqKudjZni+DxU8mDz0QlTPNIbvK0
   Wd8JIICMjfScT8S6jmfXNc3Q35nH/paZfzsGfaCbHvIbFeb/JopkJucOF
   bketHY5a+AEo0KfJiT/nV8jUQXOR4bwq3djpcalFpexWcrcfsYMoLS2C5
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10439"; a="272253957"
X-IronPort-AV: E=Sophos;i="5.93,237,1654585200"; 
   d="scan'208";a="272253957"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2022 17:00:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,237,1654585200"; 
   d="scan'208";a="782489064"
Received: from lkp-server02.sh.intel.com (HELO 3d2a4d02a2a9) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 14 Aug 2022 17:00:21 -0700
Received: from kbuild by 3d2a4d02a2a9 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oNNWm-0000e0-36;
        Mon, 15 Aug 2022 00:00:20 +0000
Date:   Mon, 15 Aug 2022 07:59:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kirill Tkhai <tkhai@ya.ru>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Kirill Tkhai <tkhai@ya.ru>
Subject: Re: [PATCH] af_unix: Add ioctl(SIOCUNIXGRABFDS) to grab files of
 receive queue skbs
Message-ID: <202208150743.t05nZxqC-lkp@intel.com>
References: <9293c7ee-6fb7-7142-66fe-051548ffb65c@ya.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9293c7ee-6fb7-7142-66fe-051548ffb65c@ya.ru>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kirill,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]
[also build test ERROR on net-next/master linus/master v5.19 next-20220812]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kirill-Tkhai/af_unix-Add-ioctl-SIOCUNIXGRABFDS-to-grab-files-of-receive-queue-skbs/20220815-045608
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 777885673122b78b2abd2f1e428730961a786ff2
config: s390-randconfig-r044-20220815 (https://download.01.org/0day-ci/archive/20220815/202208150743.t05nZxqC-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 3329cec2f79185bafd678f310fafadba2a8c76d2)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/0b4bc309fb3cdc6e470ee5c28e33f2909bfb8266
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kirill-Tkhai/af_unix-Add-ioctl-SIOCUNIXGRABFDS-to-grab-files-of-receive-queue-skbs/20220815-045608
        git checkout 0b4bc309fb3cdc6e470ee5c28e33f2909bfb8266
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

ERROR: modpost: "devm_ioremap" [drivers/net/ethernet/altera/altera_tse.ko] undefined!
>> ERROR: modpost: "__receive_fd" [net/unix/unix.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
