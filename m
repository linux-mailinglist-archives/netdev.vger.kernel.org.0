Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E717259A573
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350776AbiHSSiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 14:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349427AbiHSSiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 14:38:19 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E522B3D;
        Fri, 19 Aug 2022 11:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660934291; x=1692470291;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iNZ8OTgrcP4HEsJvk4GqUiryuR+PawK94q78dSQ8mT8=;
  b=CQmPZX4TEz+FzCCu0Nj8fiiqz7k27RrhqDo6iYwtSHes0DmB8rPnxha5
   GQhy5j3/P9oW8N7C7mZWyepNFT2vQ0Fx5b3iGHOBKcTcNvE09XK0YkTm0
   IWYOx9RM0vquDN1jkAUydiuXIYVxffLdWLTVoclBCPNCPLGy6uVizmDxJ
   0z8eQUT77zNVlYcp8nst/65eBoaLm2ytVH6vhVrEIwcOuj8Vo1Xd66CUl
   X2pSe0GeMFbYekGuJ2KhIWu2JWCxYhPjike+3h3GoTenbFTYGXX4p9GSl
   0p3Ew9/5XISsIoNsa/wy0aY4DsorXoCGxbzbiH5cV4Zqm1M0raTPMfnWx
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="273466290"
X-IronPort-AV: E=Sophos;i="5.93,248,1654585200"; 
   d="scan'208";a="273466290"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 11:38:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,248,1654585200"; 
   d="scan'208";a="697645941"
Received: from lkp-server01.sh.intel.com (HELO 44b6dac04a33) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Aug 2022 11:38:07 -0700
Received: from kbuild by 44b6dac04a33 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oP6sg-0001ht-1W;
        Fri, 19 Aug 2022 18:38:06 +0000
Date:   Sat, 20 Aug 2022 02:37:35 +0800
From:   kernel test robot <lkp@intel.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH net-next v1 7/7] ethtool: add interface to interact with
 Ethernet Power Equipment
Message-ID: <202208200202.pmwCMvZd-lkp@intel.com>
References: <20220819120109.3857571-8-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819120109.3857571-8-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Oleksij-Rempel/add-generic-PSE-support/20220819-200408
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 268603d79cc48dba671e9caf108fab32315b86a2
config: x86_64-randconfig-a014 (https://download.01.org/0day-ci/archive/20220820/202208200202.pmwCMvZd-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 0ac597f3cacf60479ffd36b03766fa7462dabd78)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/ac5a14669dbe6cac4972ff01ea6291d12152e78f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Oleksij-Rempel/add-generic-PSE-support/20220819-200408
        git checkout ac5a14669dbe6cac4972ff01ea6291d12152e78f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> make[3]: *** No rule to make target 'net/ethtool/pse.o', needed by 'net/ethtool/built-in.a'.
   make[3]: Target '__build' not remade because of errors.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
