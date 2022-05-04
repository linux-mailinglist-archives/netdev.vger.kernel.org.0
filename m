Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC12519631
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 06:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344447AbiEDEGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 00:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiEDEGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 00:06:16 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02861A396;
        Tue,  3 May 2022 21:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651636961; x=1683172961;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ckh2B3G/pTVLFtGJOv5T4bNsOnAzGDa8qxR2Bi3Txpc=;
  b=LvRgUPT/o7Jb8s0R8aWbNmP4fDofN7LhvI8AKOhSFbdLqshyxZklksl5
   wshoMyCwkbUYGdsL7845wSP9ijWWDFEQMIy0leGVa2GMjj4Mcio2wxtxk
   sQ7S6/a2pyO7RLhV20WE7zJH/xDXEOUp+MOuSMr7zPxb4LhibDfYFXUMT
   kMDb47Y9RGu/FrLTPGvJKBrmls6HJc9iCmthACCtA8uJWqpUa0tvwFcTq
   JFSv4ALY5yEvRDqbCXO35kIHFYSsLwRKPn2Q51OVNU62M7DvRWEZoeyMp
   geQz2EGQnOMvwvN6eLYdUwjVMMmKbUhiPqTsz9anjK8GD6XI6Whucv7uz
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="267251979"
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="267251979"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 21:02:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="693144489"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 03 May 2022 21:02:37 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nm6Dk-000B35-NM;
        Wed, 04 May 2022 04:02:36 +0000
Date:   Wed, 4 May 2022 12:01:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: Re: [PATCH bpf-next] net: netfilter: add kfunc helper to update ct
 timeout
Message-ID: <202205041143.5PZf1J9F-lkp@intel.com>
References: <1327f8f5696ff2bc60400e8f3b79047914ccc837.1651595019.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327f8f5696ff2bc60400e8f3b79047914ccc837.1651595019.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

I love your patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Bianconi/net-netfilter-add-kfunc-helper-to-update-ct-timeout/20220504-003234
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220504/202205041143.5PZf1J9F-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/intel-lab-lkp/linux/commit/a184a0a4e28e8af16232b4ccd899f7ae976f7f64
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Lorenzo-Bianconi/net-netfilter-add-kfunc-helper-to-update-ct-timeout/20220504-003234
        git checkout a184a0a4e28e8af16232b4ccd899f7ae976f7f64
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> net/netfilter/nf_conntrack_bpf.c:230:6: sparse: sparse: symbol 'bpf_ct_refresh_timeout' was not declared. Should it be static?

Please review and possibly fold the followup patch.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
