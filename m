Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4145AD88A
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 19:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiIERns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 13:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiIERnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 13:43:45 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1974C28704
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 10:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662399825; x=1693935825;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4pUPNCtwvkVIRVXXohaLxNqbSSwv1y2gBlRiY4VWcp8=;
  b=XeRaFn7SM1ihyqYUll/JEWK+pf99zEzeMVN1Jbx8TkivpQ1RVyk9N9Be
   WEQFhaGERLzaBBXEMCk9HpbRMA18td8pv9Gw3s1snYQix+ZUfsM8scDU1
   uM/7PxHcerlY1kWMANVAsoHUbb0NwTdnkNDui9XxjP0Cwdd2pcpITTf6u
   5EvbJMD7iEWweOQSbvLttSAwuT+0Es19/6xJTx/4qJBRaC/x1M4u/Q0fB
   6XYWOHYV5cM8tpLNl1GuPaG0JNNhdUu9Aud2p1KYq88slN55Y6nA9/lnD
   fhuT8FK6jngo6kiexToCANS+pDAl5j48ky0aNliKfKreT1oIVVWFkAp1F
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10461"; a="297742582"
X-IronPort-AV: E=Sophos;i="5.93,291,1654585200"; 
   d="scan'208";a="297742582"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 10:43:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,291,1654585200"; 
   d="scan'208";a="702955997"
Received: from lkp-server02.sh.intel.com (HELO 95dfd251caa2) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Sep 2022 10:43:41 -0700
Received: from kbuild by 95dfd251caa2 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oVG8L-0004OH-01;
        Mon, 05 Sep 2022 17:43:41 +0000
Date:   Tue, 6 Sep 2022 01:43:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <202209060112.RcYWGm1W-lkp@intel.com>
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
config: x86_64-randconfig-a015-20220905 (https://download.01.org/0day-ci/archive/20220906/202209060112.RcYWGm1W-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/50e5d9b5948e53c773edc3c710020e01f6045f9f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Mattias-Forsblad/net-dsa-mv88e6xxx-qca8k-Add-RMU-support/20220905-212125
        git checkout 50e5d9b5948e53c773edc3c710020e01f6045f9f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/dsa/mv88e6xxx/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/dsa/mv88e6xxx/chip.c:6888:5: warning: no previous prototype for function 'mv88e6xxx_connect_tag_protocol' [-Wmissing-prototypes]
   int mv88e6xxx_connect_tag_protocol(struct dsa_switch *ds,
       ^
   drivers/net/dsa/mv88e6xxx/chip.c:6888:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int mv88e6xxx_connect_tag_protocol(struct dsa_switch *ds,
   ^
   static 
   1 warning generated.
--
>> drivers/net/dsa/mv88e6xxx/rmu.c:239:26: warning: variable 'tagger_data' set but not used [-Wunused-but-set-variable]
           struct dsa_tagger_data *tagger_data;
                                   ^
   1 warning generated.


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
