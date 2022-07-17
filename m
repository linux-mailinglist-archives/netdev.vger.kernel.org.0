Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF9357738B
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 05:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbiGQDHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 23:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbiGQDHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 23:07:11 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBB314015;
        Sat, 16 Jul 2022 20:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658027230; x=1689563230;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uUmr0gfp7sBu+1FQAMYo1RIRCsFIUDNOcndHmpvNGVk=;
  b=DcbFiLT2wXpdPvENL8dBIYYUZCT4PaC2ZT1n/7JLBvd569GQ5Zrd2odY
   UJi7E0ZYcf3lLJr5D8PYu40vFuGd0kfjn1ks0+hy6OUkf2CE8YQDhKyqw
   iA3Ccb1N6O0S8VzxMdezcrzABR7ZO5cBjJH/WcQsOlsClzD4BLXHTBJGU
   UNMnarMS5LdtDwMcWucRpxBPX3nor4SZP8CTSbEX2xcEKgeiUjhPbwRfm
   TXzb7ojCG4EWzMZy6Ggyxq4mxIUeQau/mGu1fJ6iDeYdZ24tLbLb1k6Aj
   DNHLGAK+HCbzqyV8IicbhURTfiIL8bL/SsMnmtLCzHyrdZ2JjFQtQWYRX
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10410"; a="283588339"
X-IronPort-AV: E=Sophos;i="5.92,278,1650956400"; 
   d="scan'208";a="283588339"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2022 20:07:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,278,1650956400"; 
   d="scan'208";a="739080825"
Received: from lkp-server02.sh.intel.com (HELO ff137eb26ff1) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 16 Jul 2022 20:07:07 -0700
Received: from kbuild by ff137eb26ff1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oCucc-0002aS-Nh;
        Sun, 17 Jul 2022 03:07:06 +0000
Date:   Sun, 17 Jul 2022 11:06:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mathias Lark <mathiaslark@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH net-next] improve handling of ICMP_EXT_ECHO icmp type
Message-ID: <202207171049.oU9toH2Z-lkp@intel.com>
References: <20220714151358.GA16615@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714151358.GA16615@debian>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mathias,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Mathias-Lark/improve-handling-of-ICMP_EXT_ECHO-icmp-type/20220714-231818
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git b126047f43f11f61f1dd64802979765d71795dae
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20220717/202207171049.oU9toH2Z-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/d238a024060b9cf5095b5027301f5921c9140c4e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Mathias-Lark/improve-handling-of-ICMP_EXT_ECHO-icmp-type/20220714-231818
        git checkout d238a024060b9cf5095b5027301f5921c9140c4e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from <command-line>:
>> ./usr/include/linux/icmp.h:163:19: error: unknown type name 'bool'
     163 | static __inline__ bool icmp_is_valid_type(__u8 type)
         |                   ^~~~

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
