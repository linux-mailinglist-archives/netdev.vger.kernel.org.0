Return-Path: <netdev+bounces-7933-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47D7272227E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:47:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3B65281164
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:47:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0954915499;
	Mon,  5 Jun 2023 09:47:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F271415488
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:47:04 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A169BE9;
	Mon,  5 Jun 2023 02:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685958422; x=1717494422;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v/+LgTrwo+Lelaz5gHvZDSoOIGxhoEQ87vO5F8p1ayo=;
  b=IkMQFrhYiUcaNnVZmAAmFRjUmcrkyUbm0bWkpOxMxLe18s5Se/PnWFEM
   FJA4flUq0tkKdX0XtFLPjwnI+4PJdGWD54Ywk0xc/SnT04S+psWBN5UaU
   WNTRO6hSrT1iuxVqPzF1RLP2mQWVxJHKFwHAQKybO5mkpxFNvtzGz0hF9
   PpinZnWF/ODhsSmDvOeg20Y+e1gWPAHlkyNH1/QCz20BKWmunQyUFEXfq
   L+BAflbx8LS8owHwVciV8V4+VIVnQxuDe7ltwJz6Rkv7PTf9MxaIhXGzq
   y3bE85uMdZaz+Aa36olwNfcCTrcw7JVv7fnKiKLbXz2ysr3UqsSS3XEqJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="358775287"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="358775287"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 02:47:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="882842499"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="882842499"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 05 Jun 2023 02:46:57 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q66ng-00044l-3A;
	Mon, 05 Jun 2023 09:46:56 +0000
Date: Mon, 5 Jun 2023 17:46:41 +0800
From: kernel test robot <lkp@intel.com>
To: Shradha Gupta <shradhagupta@linux.microsoft.com>,
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mikelley@microsoft.com>,
	Steen Hegelund <steen.hegelund@microchip.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v5] hv_netvsc: Allocate rx indirection table size
 dynamically
Message-ID: <202306051725.FOGcInnl-lkp@intel.com>
References: <1685949196-16175-1-git-send-email-shradhagupta@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1685949196-16175-1-git-send-email-shradhagupta@linux.microsoft.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Shradha,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on horms-ipvs/master v6.4-rc5 next-20230605]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shradha-Gupta/hv_netvsc-Allocate-rx-indirection-table-size-dynamically/20230605-151438
base:   linus/master
patch link:    https://lore.kernel.org/r/1685949196-16175-1-git-send-email-shradhagupta%40linux.microsoft.com
patch subject: [PATCH v5] hv_netvsc: Allocate rx indirection table size dynamically
config: i386-randconfig-r002-20230605 (https://download.01.org/0day-ci/archive/20230605/202306051725.FOGcInnl-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/cd4dda15951edad50a4ffd51e084863ef2f50bd3
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Shradha-Gupta/hv_netvsc-Allocate-rx-indirection-table-size-dynamically/20230605-151438
        git checkout cd4dda15951edad50a4ffd51e084863ef2f50bd3
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/hyperv/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306051725.FOGcInnl-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/net/hyperv/rndis_filter.c:1612:47: error: use of undeclared identifier 'net'
           struct net_device_context *ndc = netdev_priv(net);
                                                        ^
   1 error generated.


vim +/net +1612 drivers/net/hyperv/rndis_filter.c

  1607	
  1608	void rndis_filter_device_remove(struct hv_device *dev,
  1609					struct netvsc_device *net_dev)
  1610	{
  1611		struct rndis_device *rndis_dev = net_dev->extension;
> 1612		struct net_device_context *ndc = netdev_priv(net);
  1613		struct net_device *net = hv_get_drvdata(dev);
  1614	
  1615		/* Halt and release the rndis device */
  1616		rndis_filter_halt_device(net_dev, rndis_dev);
  1617	
  1618		netvsc_device_remove(dev);
  1619	
  1620		ndc->rx_table_sz = 0;
  1621		kfree(ndc->rx_table);
  1622		ndc->rx_table = NULL;
  1623	}
  1624	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

