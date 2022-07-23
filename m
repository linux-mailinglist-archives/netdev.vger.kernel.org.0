Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD5D57F1D1
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 23:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbiGWVvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 17:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbiGWVvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 17:51:01 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2301AD82
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 14:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658613060; x=1690149060;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4p7Se4hn77BCrrto2e8nUfGmHF71YABtef8CdzAdSIc=;
  b=Ge6Qgdk9XZGm5CdZYVHo9DFafwf5FlDbvk2qr2xwwmUzFAIELD/UX8LI
   4x0MVScA1v6vnGGWCAAtGCFBRpUXiueBjkJAsN7eKdqgOcvsNG7zDKpK+
   eF5GhyQdbhYV9kY6zikLqDuTDS84ZC4AEAwqJGLjia/K+pjKJbWK5ErIO
   eyLtIiMtZP7mzJZRw/9GxgOt/ojK1OxO2U73zj8Q4t/3SOjk5EdwNQkbu
   5rOvFOmOkmPNtEhVz63MKcmbLqMJkU4B8lvJqtRbmn+uKwQs9vSiF5+W3
   buKPc/y7UJdlVdWTxrJztiMDoCCuTA4nIj1toefRdl3Fn+5ZICqsHxdgK
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10417"; a="274354147"
X-IronPort-AV: E=Sophos;i="5.93,189,1654585200"; 
   d="scan'208";a="274354147"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2022 14:50:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,189,1654585200"; 
   d="scan'208";a="775564184"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 23 Jul 2022 14:50:52 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oFN1P-00039r-2P;
        Sat, 23 Jul 2022 21:50:51 +0000
Date:   Sun, 24 Jul 2022 05:50:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Subject: Re: [PATCH net-next] net: dsa: validate that DT nodes of shared
 ports have the properties they need
Message-ID: <202207240531.wQJyi2N1-lkp@intel.com>
References: <20220723164635.1621911-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723164635.1621911-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Vladimir-Oltean/net-dsa-validate-that-DT-nodes-of-shared-ports-have-the-properties-they-need/20220724-004902
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 502c6f8cedcce7889ccdefeb88ce36b39acd522f
config: i386-randconfig-a005 (https://download.01.org/0day-ci/archive/20220724/202207240531.wQJyi2N1-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/67a281495504b3a0a6d5575d7b79121efb83f785
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vladimir-Oltean/net-dsa-validate-that-DT-nodes-of-shared-ports-have-the-properties-they-need/20220724-004902
        git checkout 67a281495504b3a0a6d5575d7b79121efb83f785
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "of_device_compatible_match" [net/dsa/dsa_core.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
