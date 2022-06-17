Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8379F54F8D0
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 16:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236898AbiFQOBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 10:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbiFQOBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 10:01:48 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E9149C95;
        Fri, 17 Jun 2022 07:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655474507; x=1687010507;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iVg+fkchqNy0NLwD7C0/R3ieqtSh8cMlhM0PEw8K7Bs=;
  b=EnSS1Tcocn2SKfFXnKk9d8pvStGKzPC6MvGBoMvQBq0hhW/AB6A9nxCd
   LH4oXPYToYrLtXDFCOjcLvPoXD/sMQN7NxkHkpDYKk4bu2FbRobSQrso8
   4EsR4Q6fZ7s/AV8BBesXDG1SW6LER3DNzaB9jAGIEV8X89gqQ2OInFft9
   UfGBO+nBk1/CeYPrjGB7qe1yEtPtt4fmSq9p0iWrtAQG86HYKXKYDrSLJ
   JPl+CUaXBKltCHtEIwG8fnDrl9sZALOfSo5Sc/ab20yJx6Omlri42B5pw
   PNss2O4bpuEyzzJaez+gKEq0BpvXqrV1qEhGuyyo7BO1zXyfz4wSituVg
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="341183723"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="341183723"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2022 07:01:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="578005427"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2022 07:01:43 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o2CXe-000PUP-Rr;
        Fri, 17 Jun 2022 14:01:42 +0000
Date:   Fri, 17 Jun 2022 22:01:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        netdev@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: Re: [PATCH V2 net-next 4/4] net: marvell: prestera: implement
 software MDB entries allocation
Message-ID: <202206172146.gg9GL71Z-lkp@intel.com>
References: <20220617101520.19794-5-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617101520.19794-5-oleksandr.mazur@plvision.eu>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksandr,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Oleksandr-Mazur/net-marvell-prestera-add-MDB-offloading-support/20220617-181737
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 982c3e2948d6a30d34f186e3b7d592a33147719b
config: riscv-allyesconfig (https://download.01.org/0day-ci/archive/20220617/202206172146.gg9GL71Z-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/e58f821bf9b04f502947d46edce5e694afba26ca
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Oleksandr-Mazur/net-marvell-prestera-add-MDB-offloading-support/20220617-181737
        git checkout e58f821bf9b04f502947d46edce5e694afba26ca
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/net/ethernet/marvell/prestera/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/marvell/prestera/prestera_switchdev.c: In function 'prestera_mdb_flush_bridge_port':
>> drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:1776:36: warning: variable 'mdb' set but not used [-Wunused-but-set-variable]
    1776 |         struct prestera_mdb_entry *mdb;
         |                                    ^~~


vim +/mdb +1776 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c

  1769	
  1770	static void
  1771	prestera_mdb_flush_bridge_port(struct prestera_bridge_port *br_port)
  1772	{
  1773		struct prestera_br_mdb_port *br_mdb_port, *tmp_port;
  1774		struct prestera_br_mdb_entry *br_mdb, *br_mdb_tmp;
  1775		struct prestera_bridge *br_dev = br_port->bridge;
> 1776		struct prestera_mdb_entry *mdb;
  1777	
  1778		list_for_each_entry_safe(br_mdb, br_mdb_tmp, &br_dev->br_mdb_entry_list,
  1779					 br_mdb_entry_node) {
  1780			mdb = br_mdb->mdb;
  1781	
  1782			list_for_each_entry_safe(br_mdb_port, tmp_port,
  1783						 &br_mdb->br_mdb_port_list,
  1784						 br_mdb_port_node) {
  1785				prestera_mdb_port_del(br_mdb->mdb,
  1786						      br_mdb_port->br_port->dev);
  1787				prestera_br_mdb_port_del(br_mdb,  br_mdb_port->br_port);
  1788			}
  1789			prestera_br_mdb_entry_put(br_mdb);
  1790		}
  1791	}
  1792	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
