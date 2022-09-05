Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4545AD8E9
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 20:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbiIESOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 14:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiIESOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 14:14:47 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC581A804
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 11:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662401686; x=1693937686;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/xjM7bflB/oFUCH/jdhoLos9QAh6pFrJU/24sWVS7zs=;
  b=CHs72pQtHauSuJHs9QySWj5rFpWs5GWcvA7BMk/4RXdZUmQJRVHFuemm
   dwA2ZPE3MirWZBfB9y7TXdZN8IvNm6xyIv1ILw0ZlcApytfnZ2WUo3zKZ
   fPF0QrOe3PklntKyYl2X7JCUMXZge4Eiqi8HWdTIEL4uDE/EYVXGy1Iq8
   H4lvaBdicWWbv3hm1iQCv4cvMWUt5gf/BOT0fn7Yslx8loY8RCH9fXLnf
   pUmWkJCBClR7bVaH60csCM3ldzlJW0LQgi27iGvHX7zlq/eEPoUbWp9tj
   ir90pIRxaUR7x2r+qogIqo7l2a70zzh3R397JIRIiXcp207FyjpbH79mU
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10461"; a="295173264"
X-IronPort-AV: E=Sophos;i="5.93,291,1654585200"; 
   d="scan'208";a="295173264"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 11:14:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,291,1654585200"; 
   d="scan'208";a="756111798"
Received: from lkp-server02.sh.intel.com (HELO 95dfd251caa2) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 05 Sep 2022 11:14:43 -0700
Received: from kbuild by 95dfd251caa2 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oVGcN-0004Pl-0Z;
        Mon, 05 Sep 2022 18:14:43 +0000
Date:   Tue, 6 Sep 2022 02:14:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: Re: [PATCH net-next v3 1/2] net: dsa: mv88e6xxx: Add functionality
 for handling RMU frames.
Message-ID: <202209060114.YyFnMA33-lkp@intel.com>
References: <20220905131917.3643193-2-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905131917.3643193-2-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mattias,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Mattias-Forsblad/net-dsa-mv88e6xxx-qca8k-Add-RMU-support/20220905-212125
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 5f3c5193479e5b9d51b201245febab6fbda4c477
config: loongarch-buildonly-randconfig-r002-20220905 (https://download.01.org/0day-ci/archive/20220906/202209060114.YyFnMA33-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/50e5d9b5948e53c773edc3c710020e01f6045f9f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Mattias-Forsblad/net-dsa-mv88e6xxx-qca8k-Add-RMU-support/20220905-212125
        git checkout 50e5d9b5948e53c773edc3c710020e01f6045f9f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch SHELL=/bin/bash drivers/net/dsa/mv88e6xxx/ net/mptcp/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/dsa/mv88e6xxx/chip.c:6888:5: warning: no previous prototype for 'mv88e6xxx_connect_tag_protocol' [-Wmissing-prototypes]
    6888 | int mv88e6xxx_connect_tag_protocol(struct dsa_switch *ds,
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/mv88e6xxx_connect_tag_protocol +6888 drivers/net/dsa/mv88e6xxx/chip.c

  6887	
> 6888	int mv88e6xxx_connect_tag_protocol(struct dsa_switch *ds,
  6889					   enum dsa_tag_protocol proto)
  6890	{
  6891		struct dsa_tagger_data *tagger_data = ds->tagger_data;
  6892	
  6893		switch (proto) {
  6894		case DSA_TAG_PROTO_DSA:
  6895		case DSA_TAG_PROTO_EDSA:
  6896			tagger_data->decode_frame2reg = mv88e6xxx_decode_frame2reg_handler;
  6897			break;
  6898		default:
  6899			return -EOPNOTSUPP;
  6900		}
  6901	
  6902		return 0;
  6903	}
  6904	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
