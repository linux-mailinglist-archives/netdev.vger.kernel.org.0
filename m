Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0824E5AC13D
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 21:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbiICTvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 15:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiICTvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 15:51:08 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1E7558F7
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 12:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662234664; x=1693770664;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/UnPOu7wldpGjS7KpcfhBj4u7QgBBvjB0EutSUGa9GE=;
  b=hRALS0lYOvoXG3/sjzn8SpVrF7JEfHhT4TcdlO3/8Gv8i+olzYolNwDu
   L3Y/8DQ/JgHb2hiVb+PdC/++ScR6XLMpltOTJUiPlE7BsBJlbYa3QkWSW
   /GOaBBovbDxmLpgHV5XXDAS8E12cu+73fQ82yzptxS42AHkJhs6YI83+O
   PY/32CzfpCflDyTS7WUW0+Sf23b9cyKp2pA6jiOd2odnyh2rNfwSKofZQ
   dZlzHroCwqMAFeC/FrFoXdk5IBqRoq67ujHLjNw/WxgrY7rHXObeLXXh7
   uQFoW48WGJY+S2CqlqcGaFJbszf6I3Et4IiYGuhIrpF9R5XCT0rRUjVeq
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10459"; a="296188224"
X-IronPort-AV: E=Sophos;i="5.93,287,1654585200"; 
   d="scan'208";a="296188224"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2022 12:51:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,287,1654585200"; 
   d="scan'208";a="616023300"
Received: from lkp-server02.sh.intel.com (HELO 95dfd251caa2) ([10.239.97.151])
  by fmsmga007.fm.intel.com with ESMTP; 03 Sep 2022 12:51:03 -0700
Received: from kbuild by 95dfd251caa2 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oUZAU-00026X-29;
        Sat, 03 Sep 2022 19:51:02 +0000
Date:   Sun, 4 Sep 2022 03:50:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, mengyuanlou@net-swift.com,
        Jiawen Wu <jiawenwu@trustnetic.com>
Subject: Re: [PATCH net-next v2 13/16] net: txgbe: Add device Rx features
Message-ID: <202209040350.PvbSvk05-lkp@intel.com>
References: <20220830070454.146211-14-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830070454.146211-14-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiawen,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiawen-Wu/net-WangXun-txgbe-ethernet-driver/20220830-151052
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git f97e971dbdc7c83d697fa2209fed0ea50fffa12e
reproduce:
        # https://github.com/intel-lab-lkp/linux/commit/78bb50a7144416960aa558c486ae078037af526b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jiawen-Wu/net-WangXun-txgbe-ethernet-driver/20220830-151052
        git checkout 78bb50a7144416960aa558c486ae078037af526b
        make menuconfig
        # enable CONFIG_COMPILE_TEST, CONFIG_WARN_MISSING_DOCUMENTS, CONFIG_WARN_ABI_ERRORS
        make htmldocs

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst:76: WARNING: Unexpected indentation.
>> Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst:77: WARNING: Block quote ends without a blank line; unexpected unindent.

vim +76 Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst

    71	
    72	  ifconfig eth<x> mtu 9000 up
    73	
    74	NOTES:
    75	- The maximum MTU setting for Jumbo Frames is 9710. This value coincides
  > 76	  with the maximum Jumbo Frames size of 9728 bytes.
  > 77	- This driver will attempt to use multiple page sized buffers to receive
    78	  each jumbo packet. This should help to avoid buffer starvation issues
    79	  when allocating receive packets.
    80	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
