Return-Path: <netdev+bounces-1518-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 48BC86FE11E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 17:06:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 657661C20DFC
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 15:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 051651640E;
	Wed, 10 May 2023 15:06:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6321640C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 15:06:41 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF0E10F3;
	Wed, 10 May 2023 08:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683731199; x=1715267199;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=E+aW0djLRInoHsjUDke1WuUyioV6E3sOdss1KQvqgwM=;
  b=BM6MYafpRPbp0IUH7D1uIAJlHs++FqR4rzWvmcKspQe3TrzeCtK2HaOM
   7lklBGzI92Kxjhg5oZ6jYE1Z/edyTeLVL6ZxjEyyIHgT4JOMFLHPj42hD
   aknl8A9IupMbaIHy5WoWQhe6Ck3r7JsUz5teIHwmpwj3skua6rtnHGjZi
   uzNtzG9sWd6Pcw9uBaXo8+weM/CNNL9hKcvF2/MqJMjpSqIZnNAYwys2l
   3Kk66lu2sRZEb17i6Bej2VoTHu2xsx1WOmTcUMIaq1jy6YSlsnQqenGLV
   eeI1lE0Ml2bD1zOQmTU+iGJV8HDqp3Za5sEUvGG0TREdLIt38dPjnHtlq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="413538804"
X-IronPort-AV: E=Sophos;i="5.99,265,1677571200"; 
   d="scan'208";a="413538804"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 08:06:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="699340269"
X-IronPort-AV: E=Sophos;i="5.99,265,1677571200"; 
   d="scan'208";a="699340269"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 10 May 2023 08:06:35 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pwlOl-0003N8-00;
	Wed, 10 May 2023 15:06:35 +0000
Date: Wed, 10 May 2023 23:06:07 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	nhorman@tuxdriver.com
Cc: oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Christian Brauner <brauner@kernel.org>,
	Stanislav Fomichev <sdf@google.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>, linux-sctp@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] sctp: add bpf_bypass_getsockopt proto callback
Message-ID: <202305102234.u4T0ut0T-lkp@intel.com>
References: <20230510131527.1244929-1-aleksandr.mikhalitsyn@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510131527.1244929-1-aleksandr.mikhalitsyn@canonical.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Alexander,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Alexander-Mikhalitsyn/sctp-add-bpf_bypass_getsockopt-proto-callback/20230510-211646
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230510131527.1244929-1-aleksandr.mikhalitsyn%40canonical.com
patch subject: [PATCH net-next] sctp: add bpf_bypass_getsockopt proto callback
config: m68k-defconfig (https://download.01.org/0day-ci/archive/20230510/202305102234.u4T0ut0T-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/8ad9818b4b74026fe549b2aa34ea800ab6c8e66d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Alexander-Mikhalitsyn/sctp-add-bpf_bypass_getsockopt-proto-callback/20230510-211646
        git checkout 8ad9818b4b74026fe549b2aa34ea800ab6c8e66d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash net/sctp/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305102234.u4T0ut0T-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/sctp/socket.c:8284:6: warning: no previous prototype for 'sctp_bpf_bypass_getsockopt' [-Wmissing-prototypes]
    8284 | bool sctp_bpf_bypass_getsockopt(int level, int optname)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/sctp_bpf_bypass_getsockopt +8284 net/sctp/socket.c

  8283	
> 8284	bool sctp_bpf_bypass_getsockopt(int level, int optname)
  8285	{
  8286		/*
  8287		 * These options do fd_install(), and if BPF_CGROUP_RUN_PROG_GETSOCKOPT
  8288		 * hook returns an error after success of the original handler
  8289		 * sctp_getsockopt(...), userspace will receive an error from getsockopt
  8290		 * syscall and will be not aware that fd was successfully installed into fdtable.
  8291		 *
  8292		 * Let's prevent bpf cgroup hook from running on them.
  8293		 */
  8294		if (level == SOL_SCTP) {
  8295			switch (optname) {
  8296			case SCTP_SOCKOPT_PEELOFF:
  8297			case SCTP_SOCKOPT_PEELOFF_FLAGS:
  8298				return true;
  8299			default:
  8300				return false;
  8301			}
  8302		}
  8303	
  8304		return false;
  8305	}
  8306	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

