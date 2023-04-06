Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3E26D8CB6
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 03:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjDFB1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 21:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjDFB1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 21:27:38 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD156EB9;
        Wed,  5 Apr 2023 18:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680744456; x=1712280456;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SOxmFzB3flkE0fuJtRea00vB3Ul8POf8DLfK/eHdwdU=;
  b=MZBa7nWQkiu5RrrOuVy4XDdwUZp8AXa8+DY1YAMJxqlsTw9PGYM5MAWR
   KjDw0MJBoFTXCV9sgfy0r6Sdz6ulmCjY8ecVDOSAtWHZ90vHZGBQwpoKc
   kttRGXcMd1kdNfAhRbUPZW4XVMrhJWfvZmt2UTiqtJQkLokUxgMzXMjaF
   zUcnTHzO+HsU5jUSeIcwZMc0LCEAMpAn3/2Cowa/ZMfboyDThieGYQoa3
   JrLYVEuCPuvnWDwCa2zT5jxABgi8s8NZFyli5p7SSmfpslbm4gi3wGMa2
   wvVl9soSoaHj83KGIuUT8tTLeEmn/tkdgT+aaMRPn8PFce4Iq55K8BJUN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="407701744"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="407701744"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 18:27:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="717256678"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="717256678"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 05 Apr 2023 18:27:32 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pkEPU-000QxG-05;
        Thu, 06 Apr 2023 01:27:32 +0000
Date:   Thu, 6 Apr 2023 09:26:52 +0800
From:   kernel test robot <lkp@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>, jakub@cloudflare.com,
        daniel@iogearbox.net, edumazet@google.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: Re: [PATCH bpf v4 07/12] bpf: sockmap incorrectly handling copied_seq
Message-ID: <202304060904.QIeejeZ5-lkp@intel.com>
References: <20230405220904.153149-8-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405220904.153149-8-john.fastabend@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

kernel test robot noticed the following build errors:

[auto build test ERROR on bpf/master]

url:    https://github.com/intel-lab-lkp/linux/commits/John-Fastabend/bpf-sockmap-pass-skb-ownership-through-read_skb/20230406-061159
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git master
patch link:    https://lore.kernel.org/r/20230405220904.153149-8-john.fastabend%40gmail.com
patch subject: [PATCH bpf v4 07/12] bpf: sockmap incorrectly handling copied_seq
config: hexagon-randconfig-r045-20230403 (https://download.01.org/0day-ci/archive/20230406/202304060904.QIeejeZ5-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 67409911353323ca5edf2049ef0df54132fa1ca7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/dc5529fda29b6c2077f7da535a3f902a4dc3dfa9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review John-Fastabend/bpf-sockmap-pass-skb-ownership-through-read_skb/20230406-061159
        git checkout dc5529fda29b6c2077f7da535a3f902a4dc3dfa9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304060904.QIeejeZ5-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: tcp_eat_skb
   >>> referenced by skmsg.c:1062 (net/core/skmsg.c:1062)
   >>>               net/core/skmsg.o:(sk_psock_verdict_recv) in archive vmlinux.a
   >>> referenced by skmsg.c:1062 (net/core/skmsg.c:1062)
   >>>               net/core/skmsg.o:(sk_psock_verdict_recv) in archive vmlinux.a
   >>> referenced by skmsg.c:1056 (net/core/skmsg.c:1056)
   >>>               net/core/skmsg.o:(sk_psock_verdict_recv) in archive vmlinux.a
   >>> referenced 3 more times

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
