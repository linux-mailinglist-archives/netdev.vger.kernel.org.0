Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99616590AF5
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 06:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbiHLEQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 00:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiHLEQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 00:16:34 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BB1FD37;
        Thu, 11 Aug 2022 21:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660277793; x=1691813793;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xEKQMRYYwNapwWCbuAHmwaEJwzGtEja9gbRJRyakeJ8=;
  b=UI5+wn2unGkKbMbQFqbbwPfG6sZYpTcUEf5lmGTMXrnC6SgPPTENMyOu
   xw7HX8vgUKP7Iow5aQUfV5vOsoL8K8Dnosv6T06RXQQc4P1i7WUSAiaIE
   NgUzPURsio3xDUxmhtHAe3hlhdYI5M+UcB545h26+lyTZppStQq2AXg2v
   JsOLsdWuD2e7WAQcx3eShxm8WSg/GHXTpSiECI2/PvkFfep21hGVRIl1X
   FocypV6CesiAx/gwqc+OvX3w1/K1nAzfczHY4YzFwCkCITey3HFLgO1NV
   MAogkjdxvZTDH+iWtdJCqv2emuL4jlVO6JJJsW2hCcAGqVDA1OdQXoXgc
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="289087908"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="289087908"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 21:16:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="933578432"
Received: from lkp-server02.sh.intel.com (HELO 8745164cafc7) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 11 Aug 2022 21:16:31 -0700
Received: from kbuild by 8745164cafc7 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oMM62-00007f-1X;
        Fri, 12 Aug 2022 04:16:30 +0000
Date:   Fri, 12 Aug 2022 12:16:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, kafai@fb.com, kuba@kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, kernel-team@fb.com,
        Joanne Koong <joannelkoong@gmail.com>
Subject: Re: [PATCH bpf-next v2 1/3] bpf: Add skb dynptrs
Message-ID: <202208121214.urSMKXgE-lkp@intel.com>
References: <20220811230501.2632393-2-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811230501.2632393-2-joannelkoong@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
config: um-i386_defconfig (https://download.01.org/0day-ci/archive/20220812/202208121214.urSMKXgE-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/ecab09dda7739b27ffd6ed6c93753f6dfd9bdcb2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Joanne-Koong/Add-skb-xdp-dynptrs/20220812-070634
        git checkout ecab09dda7739b27ffd6ed6c93753f6dfd9bdcb2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=um SUBARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   /usr/bin/ld: net/core/filter.o: in function `bpf_dynptr_from_skb':
>> filter.c:(.text+0x4e87): undefined reference to `bpf_dynptr_set_null'
>> /usr/bin/ld: filter.c:(.text+0x4e9e): undefined reference to `bpf_dynptr_init'
>> /usr/bin/ld: filter.c:(.text+0x4eae): undefined reference to `bpf_dynptr_set_rdonly'
   collect2: error: ld returned 1 exit status

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
