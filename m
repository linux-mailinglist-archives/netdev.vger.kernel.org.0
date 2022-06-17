Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2860254FCD6
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 20:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiFQSRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 14:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiFQSRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 14:17:55 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE4E24BE5
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 11:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655489874; x=1687025874;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mdJexJRngEj3g12OLIu0Kv8q9SXJ16g4FSwegKZqiFM=;
  b=YuhqJLNlwytgQNqkOSHHKl7L8AjLbe9cRm9KRKeUsSnX663fcYKz0nim
   i2nLlC94K0uvWPoYjXw6M7P0s2fSQEqFnZcXf/bZn+BWMayb+k7CKp34K
   LqgYpCXFRQ3G6gAngKuZETdAw8yH24KOUmcKFRWQKOUG7BB975mO0f9qr
   PEGSn91lII16dE8ypDGd97zl/1nVFjbzQJ1Gqyo9NHm7xO3epUDlLcPFz
   ZE40b+QqI8xkZl9VvPTTGQ9vadQD2H8rnyEsdQEVCJbITfQQQXEo4D0qz
   fmQkiG9oVVSjsF5t/cdAYJuwhzwKKSA3DN5++1QMovVaCLkwalIm0USFK
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="262598603"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="262598603"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2022 11:17:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="713859647"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 17 Jun 2022 11:17:51 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o2GXX-000Pf7-4C;
        Fri, 17 Jun 2022 18:17:51 +0000
Date:   Sat, 18 Jun 2022 02:17:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, Amit Shah <aams@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: Re: [PATCH v1 net-next 3/6] af_unix: Define a per-netns hash table.
Message-ID: <202206180244.SIWZxbAo-lkp@intel.com>
References: <20220616234714.4291-4-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616234714.4291-4-kuniyu@amazon.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kuniyuki,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Kuniyuki-Iwashima/af_unix-Introduce-per-netns-socket-hash-table/20220617-075046
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 5dcb50c009c9f8ec1cfca6a81a05c0060a5bbf68
config: hexagon-randconfig-r045-20220617 (https://download.01.org/0day-ci/archive/20220618/202206180244.SIWZxbAo-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d764aa7fc6b9cc3fbe960019018f5f9e941eb0a6)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d0da436e1c42550dbd332f48fd11992d5f4af487
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kuniyuki-Iwashima/af_unix-Introduce-per-netns-socket-hash-table/20220617-075046
        git checkout d0da436e1c42550dbd332f48fd11992d5f4af487
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash net/unix/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/unix/af_unix.c:3590:1: warning: unused label 'err_sysctl' [-Wunused-label]
   err_sysctl:
   ^~~~~~~~~~~
   1 warning generated.


vim +/err_sysctl +3590 net/unix/af_unix.c

  3573	
  3574		net->unx.hash = kmalloc(sizeof(struct unix_hashbucket) * UNIX_HASH_SIZE,
  3575					GFP_KERNEL);
  3576		if (!net->unx.hash)
  3577			goto err_proc;
  3578	
  3579		for (i = 0; i < UNIX_HASH_SIZE; i++) {
  3580			INIT_HLIST_HEAD(&net->unx.hash[i].head);
  3581			spin_lock_init(&net->unx.hash[i].lock);
  3582		}
  3583	
  3584		return 0;
  3585	
  3586	err_proc:
  3587	#ifdef CONFIG_PROC_FS
  3588		remove_proc_entry("unix", net->proc_net);
  3589	#endif
> 3590	err_sysctl:
  3591		unix_sysctl_unregister(net);
  3592	out:
  3593		return -ENOMEM;
  3594	}
  3595	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
