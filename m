Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4A8577733
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiGQQD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiGQQD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:03:58 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CA2DF76
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658073836; x=1689609836;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BUd+MHnd+pJss+BEg+5hqAUIkpgu+RKEwwzP0cA2i64=;
  b=CMxrDOsdUMwb47H5mFuk5rYqnkzL64P5YN0ewZINP5t76+tyicKc8gZS
   VSn5KLyM2SVaGW4J2hqxzbHgcMu/S7a9dyiff4fZFJMbCzXn6f7RAA/+A
   Whtz1BbPgk0H8d7dbnHABtildBXGlBxYhq84PO0Hz3/E1gqD7H7ADd8mk
   RIWI5xI8XLpGzwRv3LyDRT1nVys1NWXRVDBc76YFsOb0pAJoK7NbdN7xL
   2FYNq8WI6U403MY0Am0jRfh/pEn39gU5lS12h0CaZod/ifsxSAPfAOdu6
   FBYOL7K3wdh/sQfM8lE9xbSX/dWmnjYxG6LVLQH5nP3y1alMwC+AarLRj
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10411"; a="266479086"
X-IronPort-AV: E=Sophos;i="5.92,279,1650956400"; 
   d="scan'208";a="266479086"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2022 09:03:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,279,1650956400"; 
   d="scan'208";a="547209038"
Received: from lkp-server02.sh.intel.com (HELO ff137eb26ff1) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 17 Jul 2022 09:03:54 -0700
Received: from kbuild by ff137eb26ff1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oD6kM-0003Ra-1d;
        Sun, 17 Jul 2022 16:03:54 +0000
Date:   Mon, 18 Jul 2022 00:03:01 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrey Turkin <andrey.turkin@gmail.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Andrey Turkin <andrey.turkin@gmail.com>
Subject: Re: [PATCH] vmxnet3: Implement ethtool's get_channels command
Message-ID: <202207172303.yyCkQKVF-lkp@intel.com>
References: <20220717022050.822766-1-andrey.turkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220717022050.822766-1-andrey.turkin@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrey,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on 972a278fe60c361eb8f37619f562f092e8786d7c]

url:    https://github.com/intel-lab-lkp/linux/commits/Andrey-Turkin/vmxnet3-Implement-ethtool-s-get_channels-command/20220717-102410
base:   972a278fe60c361eb8f37619f562f092e8786d7c
config: i386-randconfig-a015-20211103 (https://download.01.org/0day-ci/archive/20220717/202207172303.yyCkQKVF-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/87d4e00b53b145b85dfcda9645ed4a2467caab7d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Andrey-Turkin/vmxnet3-Implement-ethtool-s-get_channels-command/20220717-102410
        git checkout 87d4e00b53b145b85dfcda9645ed4a2467caab7d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/vmxnet3/vmxnet3_ethtool.c:1191:6: warning: no previous prototype for 'vmxnet3_get_channels' [-Wmissing-prototypes]
    1191 | void vmxnet3_get_channels(struct net_device *netdev,
         |      ^~~~~~~~~~~~~~~~~~~~
   drivers/net/vmxnet3/vmxnet3_ethtool.c: In function 'vmxnet3_get_channels':
>> drivers/net/vmxnet3/vmxnet3_ethtool.c:1194:33: warning: unused variable 'adapter' [-Wunused-variable]
    1194 |         struct vmxnet3_adapter *adapter = netdev_priv(netdev);
         |                                 ^~~~~~~


vim +/adapter +1194 drivers/net/vmxnet3/vmxnet3_ethtool.c

  1190	
  1191	void vmxnet3_get_channels(struct net_device *netdev,
  1192				  struct ethtool_channels *ec)
  1193	{
> 1194		struct vmxnet3_adapter *adapter = netdev_priv(netdev);
  1195	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
