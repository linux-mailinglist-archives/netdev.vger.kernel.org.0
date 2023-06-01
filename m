Return-Path: <netdev+bounces-6979-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F4D71914F
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:28:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3E912816BA
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 03:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BA5A5393;
	Thu,  1 Jun 2023 03:28:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF164C97
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 03:28:06 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E764D124;
	Wed, 31 May 2023 20:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685590085; x=1717126085;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+xq448q5qTkKIgFiYOhT+ecVXzgHvJWPPv1d0I8oCrk=;
  b=Xr0zQSdnLb1YUATP3SkBcSrMq7Ej5OhOr3RiVBO37hWhQRAH7Q/7mcQY
   dOISuqIGW7re9tROk3CmqnMn0u9wFvBjpYFENLUkb5t47V36YLiZ390tV
   odz1BIlbdD5sQcp+38av27FAAM7Mu8skNpyUHie/5LJXLRWk5G47uH/pQ
   xNcYPBbY2UnqrXEd7zOvi2BxIkySsazbKpLYBojyy3ElGeOw4EBAOjdiF
   8pTI9fi0Ofs614Bji0BiFOsMNwt/lqSdMZqdoZoSYrSv27XDDFCqZO2DB
   wMDm2qwYN8tL7CDRuyD0C4QCnG0Iz9+ENWXZy7pMdfivz8ybm0AMg1Dy7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="357839165"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="357839165"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 20:28:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="736913522"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="736913522"
Received: from lkp-server01.sh.intel.com (HELO fb1ced2c09fb) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 31 May 2023 20:27:59 -0700
Received: from kbuild by fb1ced2c09fb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q4Yyk-0001s0-1r;
	Thu, 01 Jun 2023 03:27:58 +0000
Date: Thu, 1 Jun 2023 11:27:43 +0800
From: kernel test robot <lkp@intel.com>
To: Breno Leitao <leitao@debian.org>, dsahern@kernel.org,
	willemdebruijn.kernel@gmail.com,
	Remi Denis-Courmont <courmisch@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Mat Martineau <martineau@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org, leit@fb.com,
	axboe@kernel.dk, asml.silence@gmail.com,
	linux-kernel@vger.kernel.org, dccp@vger.kernel.org,
	linux-wpan@vger.kernel.org, mptcp@lists.linux.dev,
	linux-sctp@vger.kernel.org
Subject: Re: [PATCH net-next v4] net: ioctl: Use kernel memory on protocol
 ioctl callbacks
Message-ID: <202306011128.2sM3vsBl-lkp@intel.com>
References: <20230530175403.2434218-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530175403.2434218-1-leitao@debian.org>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Breno,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Breno-Leitao/net-ioctl-Use-kernel-memory-on-protocol-ioctl-callbacks/20230531-015554
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230530175403.2434218-1-leitao%40debian.org
patch subject: [PATCH net-next v4] net: ioctl: Use kernel memory on protocol ioctl callbacks
config: mips-allmodconfig (https://download.01.org/0day-ci/archive/20230601/202306011128.2sM3vsBl-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 12.3.0
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f97a3206f5ae59ecb0c7105225c5230b343c6c54
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Breno-Leitao/net-ioctl-Use-kernel-memory-on-protocol-ioctl-callbacks/20230531-015554
        git checkout f97a3206f5ae59ecb0c7105225c5230b343c6c54
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=mips olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306011128.2sM3vsBl-lkp@intel.com/

All errors (new ones prefixed by >>):

   mips-linux-ld: net/core/sock.o: in function `sk_ioctl':
>> sock.c:(.text.sk_ioctl+0x12c): undefined reference to `ip6mr_sk_ioctl'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

