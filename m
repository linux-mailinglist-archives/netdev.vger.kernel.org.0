Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F56E698819
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 23:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjBOWvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 17:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBOWvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 17:51:16 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849B52D5A;
        Wed, 15 Feb 2023 14:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676501474; x=1708037474;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3M+hiPga4ES/I6q/eg87QVkzRFuqBoiE+TeHGZ8J2Ds=;
  b=iKeJMp2WwXevitrDhHoAK/rv2qk/k7v8EolICcdwcY4IhSLHxGGQmvrh
   IykS1AtG/Av7xvU3oVbLt6TfRgEJ8rB7vd+VAcmHoLIfSgBCARVM8qZxN
   omczE+OlnhcDlMYeiu+KB9/gO2rgCDW2n5rQBKJyiETFskjNYa4tvLiee
   PYXMZnGKHHemV60Wo5bImk+e/85dVbPlE+0nMadQtgEfY3ANyrDy6L/dM
   4y56SV6KK8XOlGlnXdgFlE410/+RI3ZJiazXuzsVuD8Jz0QdFeZp1T+b1
   FUDqXWJit7Czm0uhqYzOlDKYtQhdnBUSF44zYyyAyQU+abJanD8/i2z1H
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="319610556"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="319610556"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 14:51:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="812714012"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="812714012"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 15 Feb 2023 14:51:09 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pSQcG-0009r7-0R;
        Wed, 15 Feb 2023 22:51:08 +0000
Date:   Thu, 16 Feb 2023 06:50:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <error27@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>
Subject: Re: [PATCH v4 05/21] net/tcp: Calculate TCP-AO traffic keys
Message-ID: <202302160619.lvY45Sx5-lkp@intel.com>
References: <20230215183335.800122-6-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215183335.800122-6-dima@arista.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dmitry,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on e1c04510f521e853019afeca2a5991a5ef8d6a5b]

url:    https://github.com/intel-lab-lkp/linux/commits/Dmitry-Safonov/net-tcp-Prepare-tcp_md5sig_pool-for-TCP-AO/20230216-023836
base:   e1c04510f521e853019afeca2a5991a5ef8d6a5b
patch link:    https://lore.kernel.org/r/20230215183335.800122-6-dima%40arista.com
patch subject: [PATCH v4 05/21] net/tcp: Calculate TCP-AO traffic keys
config: sparc-allyesconfig (https://download.01.org/0day-ci/archive/20230216/202302160619.lvY45Sx5-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/e93c86e7edccffd9992748d03591579a4ebc2731
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dmitry-Safonov/net-tcp-Prepare-tcp_md5sig_pool-for-TCP-AO/20230216-023836
        git checkout e93c86e7edccffd9992748d03591579a4ebc2731
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc SHELL=/bin/bash net/ipv4/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302160619.lvY45Sx5-lkp@intel.com/

All warnings (new ones prefixed by >>):

   net/ipv4/tcp_ao.c:59:20: warning: no previous prototype for 'tcp_ao_matched_key' [-Wmissing-prototypes]
      59 | struct tcp_ao_key *tcp_ao_matched_key(struct tcp_ao_info *ao,
         |                    ^~~~~~~~~~~~~~~~~~
>> net/ipv4/tcp_ao.c:245:5: warning: no previous prototype for 'tcp_ao_calc_key_sk' [-Wmissing-prototypes]
     245 | int tcp_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
         |     ^~~~~~~~~~~~~~~~~~


vim +/tcp_ao_calc_key_sk +245 net/ipv4/tcp_ao.c

   244	
 > 245	int tcp_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
   246			       const struct sock *sk,
   247			       __be32 sisn, __be32 disn,
   248			       bool send)
   249	{
   250		if (mkt->family == AF_INET)
   251			return tcp_v4_ao_calc_key_sk(mkt, key, sk, sisn, disn, send);
   252		else
   253			return tcp_v6_ao_calc_key_sk(mkt, key, sk, sisn, disn, send);
   254	}
   255	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
