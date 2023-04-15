Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31CC16E2EF9
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 06:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjDOEUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 00:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDOEUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 00:20:14 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC4759C5
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 21:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681532413; x=1713068413;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jUlS5UdJEVLwzt7gzzdwooF/ndJzm58fbab7e3xMugM=;
  b=bQTC0HfLH3AlP80+vWEQWa/dy1gTNEgG0NOY7QiLZYb/sLZ3aHas0Vfp
   EZHtKNQz0f+8L6t9alWJ2clSLtVJ50Hkln0T1e8p5V73J66fpQbgL+8SK
   ypsuzxg0uVkbsZrYGw1pFFny1Tu6NG1rfDvBcKIdeow/Ih3grzT7Vl87L
   YMc596DUpj4EhykO6pVnt6ohmhA8bUUaIWKkPDnE5kcv3EcFE9N0cLNO5
   hpSElLurCFzyCrcZHU4JtBT80ovWg8EttnGthwfmw2ssEmL2V7x+Vt+6C
   YAOzBda4iGTZkuAkmcrATXJ1VPL9vyrAtywu/ZN0rfjaxEwDRJGXr4R54
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="343370888"
X-IronPort-AV: E=Sophos;i="5.99,199,1677571200"; 
   d="scan'208";a="343370888"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 21:20:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="936214227"
X-IronPort-AV: E=Sophos;i="5.99,199,1677571200"; 
   d="scan'208";a="936214227"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 14 Apr 2023 21:20:10 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pnXOU-000aPy-03;
        Sat, 15 Apr 2023 04:20:10 +0000
Date:   Sat, 15 Apr 2023 12:20:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, saeedm@nvidia.com,
        leon@kernel.org
Subject: Re: [PATCH net-next] eth: mlx5: avoid iterator use outside of a loop
Message-ID: <202304151226.OgvGHiJI-lkp@intel.com>
References: <20230414180729.198284-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414180729.198284-1-kuba@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Jakub-Kicinski/eth-mlx5-avoid-iterator-use-outside-of-a-loop/20230415-021112
patch link:    https://lore.kernel.org/r/20230414180729.198284-1-kuba%40kernel.org
patch subject: [PATCH net-next] eth: mlx5: avoid iterator use outside of a loop
config: arm64-randconfig-s052-20230413 (https://download.01.org/0day-ci/archive/20230415/202304151226.OgvGHiJI-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/1432c0a2b6d7ea977dad5de303481b1aae454ef4
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jakub-Kicinski/eth-mlx5-avoid-iterator-use-outside-of-a-loop/20230415-021112
        git checkout 1432c0a2b6d7ea977dad5de303481b1aae454ef4
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=arm64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/net/ethernet/mellanox/mlx5/core/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304151226.OgvGHiJI-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/net/ethernet/mellanox/mlx5/core/eq.c:1077:16: sparse: sparse: Using plain integer as NULL pointer

vim +1077 drivers/net/ethernet/mellanox/mlx5/core/eq.c

  1063	
  1064	struct cpumask *
  1065	mlx5_comp_irq_get_affinity_mask(struct mlx5_core_dev *dev, int vector)
  1066	{
  1067		struct mlx5_eq_table *table = dev->priv.eq_table;
  1068		struct mlx5_eq_comp *eq;
  1069		int i = 0;
  1070	
  1071		list_for_each_entry(eq, &table->comp_eqs_list, list) {
  1072			if (i++ == vector)
  1073				return mlx5_irq_get_affinity_mask(eq->core.irq);
  1074		}
  1075	
  1076		WARN_ON_ONCE(1);
> 1077		return 0;
  1078	}
  1079	EXPORT_SYMBOL(mlx5_comp_irq_get_affinity_mask);
  1080	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
