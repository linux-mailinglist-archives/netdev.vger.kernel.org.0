Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F656BDB57
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 23:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjCPWIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 18:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjCPWII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 18:08:08 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D4EB4224;
        Thu, 16 Mar 2023 15:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679004471; x=1710540471;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NUccJEQeyuFmY2OUH22+mD2DNXjeXrjGLxyTCvS9pEY=;
  b=lMznxs/qshTbSSZkv+DZPVCDfunz3h4iUTefMNEBg1rsspKbv5ywpLVM
   rqEkZdQLdkiW6DmeybcQXcA8tAh8t2085IaXBA50n3+hMN8f8Oym24vgP
   6Px2NtaBw/mXJao1KZrW+gKdZanrIQ9fDmmDEcBqrPtROzNWckvp8OTTf
   qHLwDuD5OqUhDhOghPKVqE6aH1OcgVGqpO7ZlVYkO7Io4kfOWHP7VnpOe
   cE0GKvsyo4EBNEQyj/Zb5j86ew6kjBZhnIYvmrXLSHGMnuJrRmN95056f
   ljxCo+RdCIZHVs3Y6JOF1R2NnDMYfuIrA5HXnoohd+jMjSFStBzJJdBQP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="339665734"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="339665734"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 15:07:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="854217836"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="854217836"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 16 Mar 2023 15:07:46 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pcvlB-0008rW-0U;
        Thu, 16 Mar 2023 22:07:45 +0000
Date:   Fri, 17 Mar 2023 06:07:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        John Crispin <john@phrozen.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee@kernel.org>, linux-leds@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 01/11] net: dsa: qca8k: add LEDs basic support
Message-ID: <202303170529.8ag9rmM4-lkp@intel.com>
References: <20230307170046.28917-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307170046.28917-2-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christian,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Christian-Marangi/net-dsa-qca8k-add-LEDs-basic-support/20230308-063832
patch link:    https://lore.kernel.org/r/20230307170046.28917-2-ansuelsmth%40gmail.com
patch subject: [net-next PATCH 01/11] net: dsa: qca8k: add LEDs basic support
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20230317/202303170529.8ag9rmM4-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/ce1977c679b8737815636b72f4e65c2de59e8f7d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Christian-Marangi/net-dsa-qca8k-add-LEDs-basic-support/20230308-063832
        git checkout ce1977c679b8737815636b72f4e65c2de59e8f7d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash drivers/net/dsa/qca/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303170529.8ag9rmM4-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/net/dsa/qca/qca8k-leds.c:171:1: error: redefinition of 'qca8k_setup_led_ctrl'
     171 | qca8k_setup_led_ctrl(struct qca8k_priv *priv)
         | ^~~~~~~~~~~~~~~~~~~~
   In file included from drivers/net/dsa/qca/qca8k-leds.c:5:
   drivers/net/dsa/qca/qca8k.h:577:19: note: previous definition of 'qca8k_setup_led_ctrl' with type 'int(struct qca8k_priv *)'
     577 | static inline int qca8k_setup_led_ctrl(struct qca8k_priv *priv)
         |                   ^~~~~~~~~~~~~~~~~~~~


vim +/qca8k_setup_led_ctrl +171 drivers/net/dsa/qca/qca8k-leds.c

   169	
   170	int
 > 171	qca8k_setup_led_ctrl(struct qca8k_priv *priv)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
