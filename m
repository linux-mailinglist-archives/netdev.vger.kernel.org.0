Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983DE590BAD
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 07:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237178AbiHLF7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 01:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237174AbiHLF6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 01:58:48 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72450A406B;
        Thu, 11 Aug 2022 22:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660283916; x=1691819916;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jpBAt7RrH/lqkglG1A2u8wjELkLgo1HyKTHv7Wsj6AU=;
  b=mcjZA42qPxSIuK/KWKHP3Uq2X/0gQCiBeMMqBNM00s9kaFCvz2TJSqqB
   4N3oZjTLaISImnK1zYWfGyYIJsK5CENcyjFe6h7dlZBc7CPFDARU8C3tZ
   74r2D1iu1GIts5iEERpuefQ56+t834V6Sew7hz/LBnw8pf43AOJUxOhkt
   +RJiAG9IGGs4NSfvbNo9TRT61vPN1EvGAGh8BOw1wOy7zQxwURSeeU4aR
   QIosTYl4Rfcf/WBIVGZR1ZTsD4pzEq42hkm8PKl4TCp4sFejRAInif0P7
   Brv3Md7c22R05iHymo1g3bfEMC9Qemdq8u185V7U9ZYDc5x+jcheOLjN+
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="271302299"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="271302299"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 22:58:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="933599071"
Received: from lkp-server02.sh.intel.com (HELO 8745164cafc7) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 11 Aug 2022 22:58:33 -0700
Received: from kbuild by 8745164cafc7 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oMNgn-0000Dl-1J;
        Fri, 12 Aug 2022 05:58:33 +0000
Date:   Fri, 12 Aug 2022 13:57:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, kafai@fb.com, kuba@kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, kernel-team@fb.com,
        Joanne Koong <joannelkoong@gmail.com>
Subject: Re: [PATCH bpf-next v2 1/3] bpf: Add skb dynptrs
Message-ID: <202208121318.MVYzenNA-lkp@intel.com>
References: <20220811230501.2632393-2-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811230501.2632393-2-joannelkoong@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
config: i386-defconfig (https://download.01.org/0day-ci/archive/20220812/202208121318.MVYzenNA-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/ecab09dda7739b27ffd6ed6c93753f6dfd9bdcb2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Joanne-Koong/Add-skb-xdp-dynptrs/20220812-070634
        git checkout ecab09dda7739b27ffd6ed6c93753f6dfd9bdcb2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ld: net/core/filter.o: in function `bpf_dynptr_from_skb':
>> filter.c:(.text+0x84eb): undefined reference to `bpf_dynptr_init'
>> ld: filter.c:(.text+0x8511): undefined reference to `bpf_dynptr_set_rdonly'
>> ld: filter.c:(.text+0x8521): undefined reference to `bpf_dynptr_set_null'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
