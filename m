Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECEAA511521
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 12:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiD0KuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 06:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiD0KuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 06:50:15 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E4F36CE14;
        Wed, 27 Apr 2022 03:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651054869; x=1682590869;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=t6kyq7AiYQ2tz2vU/N/RsGfuRMNtYSu1eleATTJMBgM=;
  b=TnqYVZG+H4a5bjQXFK61ZcVEjKfHYx75H4q1AmhrO3/vbStsyubf+vkm
   I8QJo+CkUMBQBBOXiBEoDx1oOWpU+TJjkDT47eoVC2RLRY8ktTZfEQgk1
   QEEHEXJJB9C6ei6uMsVmyTBk+9oKoGcvOWazTemj6KF9psjU5HCKfDX3I
   xiWxrylwUHu8qaYoLCEmn0JBoCZx7egbDGe4Kj6hpv2Hta3nBtUjb5fWV
   uIrtkDbf9H3BwcFG2iy3QjXuTbtS8CBeW3Gh9nSgGNQ9psoFz7uMI73T6
   WYz3x1BQJMZ/OGW1YihEcXk75/tU40rNOhRXbeZFJtUaE9Rs46bqzpIJG
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="263469525"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="263469525"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 02:57:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="650626768"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Apr 2022 02:57:38 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1njeQU-0004ZY-0k;
        Wed, 27 Apr 2022 09:57:38 +0000
Date:   Wed, 27 Apr 2022 17:56:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Willy Tarreau <w@1wt.eu>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net 1/7] secure_seq: return the full 64-bit of the siphash
Message-ID: <202204271705.VrWNPv7n-lkp@intel.com>
References: <20220427065233.2075-2-w@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427065233.2075-2-w@1wt.eu>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willy,

I love your patch! Yet something to improve:

[auto build test ERROR on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Willy-Tarreau/insufficient-TCP-source-port-randomness/20220427-145651
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 71cffebf6358a7f5031f5b208bbdc1cb4db6e539
config: i386-randconfig-r026-20220425 (https://download.01.org/0day-ci/archive/20220427/202204271705.VrWNPv7n-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/01b26e522b598adf346b809075880feab3dcdc08
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Willy-Tarreau/insufficient-TCP-source-port-randomness/20220427-145651
        git checkout 01b26e522b598adf346b809075880feab3dcdc08
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ld: net/ipv4/inet_hashtables.o: in function `__inet_hash_connect':
>> inet_hashtables.c:(.text+0x187d): undefined reference to `__umoddi3'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
