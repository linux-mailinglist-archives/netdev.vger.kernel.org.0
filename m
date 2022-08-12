Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1EC5910E1
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 14:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234719AbiHLMks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 08:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237442AbiHLMkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 08:40:45 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5150ABF29;
        Fri, 12 Aug 2022 05:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660308044; x=1691844044;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NtvBC+VhizqH+Pv2KAnQiXJfuGki0qroDTYTiguISRE=;
  b=Vr9wqPfc5n7okvyFgpccTGh7TxDpCAHpYQMYQUsDDH5KupP6b34y7xoj
   z7YID9VF6zuTcpdW0rYV0nuou8NFWx23EwfMAr/fO3N25LWepX6Oug/It
   humBeXTI7LJkomjoKj6A/so8OLRaAAL2fNm+QextDvVYaKTIS6OI2uoRE
   rs6g97niCTTKogDGxekpzDaLhXbWPt4xk1/Qncsh6MsHObFXZ/74aRZNT
   sbqSVzGfdVDztixXTPNeFjvgZkP6NhDGgasTQxes4r6tzWSEdmUijFdD4
   bSHibpyrf6StpeYV5D4hbcw3OBGmAdhzjsatHzp1tYMzzRufvSOVJYxjQ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="271969883"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="271969883"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 05:40:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="695254003"
Received: from lkp-server02.sh.intel.com (HELO 8745164cafc7) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Aug 2022 05:40:42 -0700
Received: from kbuild by 8745164cafc7 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oMTxx-0000W9-1G;
        Fri, 12 Aug 2022 12:40:41 +0000
Date:   Fri, 12 Aug 2022 20:39:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, kafai@fb.com, kuba@kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, kernel-team@fb.com,
        Joanne Koong <joannelkoong@gmail.com>
Subject: Re: [PATCH bpf-next v2 2/3] bpf: Add xdp dynptrs
Message-ID: <202208122032.0CZYkZY8-lkp@intel.com>
References: <20220811230501.2632393-3-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811230501.2632393-3-joannelkoong@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joanne,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/Add-skb-xdp-dynptrs/20220812-070634
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: riscv-randconfig-r042-20220812 (https://download.01.org/0day-ci/archive/20220812/202208122032.0CZYkZY8-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/20947f78c1a22c16604514fe2b7c222b77f8939b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Joanne-Koong/Add-skb-xdp-dynptrs/20220812-070634
        git checkout 20947f78c1a22c16604514fe2b7c222b77f8939b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   riscv32-linux-ld: net/core/filter.o: in function `.L1284':
   filter.c:(.text+0x5606): undefined reference to `bpf_dynptr_init'
   riscv32-linux-ld: net/core/filter.o: in function `.L1279':
   filter.c:(.text+0x561e): undefined reference to `bpf_dynptr_set_null'
   riscv32-linux-ld: net/core/filter.o: in function `.L1298':
   filter.c:(.text+0x566c): undefined reference to `bpf_dynptr_init'
   riscv32-linux-ld: net/core/filter.o: in function `.L1304':
   filter.c:(.text+0x568e): undefined reference to `bpf_dynptr_set_rdonly'
>> riscv32-linux-ld: filter.c:(.text+0x569a): undefined reference to `bpf_dynptr_set_null'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
