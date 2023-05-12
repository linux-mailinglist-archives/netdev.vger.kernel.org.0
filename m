Return-Path: <netdev+bounces-2317-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AEA7701269
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 01:24:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD8401C21261
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 23:24:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C41B2261F;
	Fri, 12 May 2023 23:24:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8A922615
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 23:24:06 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD66273D;
	Fri, 12 May 2023 16:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683933844; x=1715469844;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EmdFu5NhBMF5IU2oYyEi+Wp7+UrFNaOcC8wu11S8aHI=;
  b=Lhv0E0kWSO0EeA2y9O4DiY4eLqx9EstHinWOZ7+EvCtGpQQDQMnXdHsV
   tHj1dbmf0IkG2qnKlRjsCtpatWsBuZ3HY4wpKKWW2onOpMayBRwQUVGd6
   i3yjNSjBT03hMS0tCw/6kal86YouBn7ZmcuHBmvSNoyRqzLd3/TAgpenK
   pv0Jzhdh5xZDsojqHwUG9ABP5KNVuV1lSLSSjv5ul/qYjVhHWh3rQ16IK
   mLh1APj6oiRLuL+iZbcravKF8ZsL5QcwZvLTboUDLRAUc9g6ez2CF2BWY
   6He7zduc8/8GqF9ZG0dIzdFw93pZa9dWwXAXvh1oNZctqUe1F4X1ajoq5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="349743956"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="349743956"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 16:24:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="789987471"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="789987471"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 12 May 2023 16:23:59 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pxc7C-0005Aa-1i;
	Fri, 12 May 2023 23:23:58 +0000
Date: Sat, 13 May 2023 07:23:43 +0800
From: kernel test robot <lkp@intel.com>
To: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netdev@vger.kernel.org, Dmitry Safonov <dima@arista.com>,
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
Subject: Re: [PATCH v6 01/21] net/tcp: Prepare tcp_md5sig_pool for TCP-AO
Message-ID: <202305130722.D7icLQEP-lkp@intel.com>
References: <20230512202311.2845526-2-dima@arista.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230512202311.2845526-2-dima@arista.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Dmitry,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 47a2ee5d4a0bda05decdda7be0a77e792cdb09a3]

url:    https://github.com/intel-lab-lkp/linux/commits/Dmitry-Safonov/net-tcp-Prepare-tcp_md5sig_pool-for-TCP-AO/20230513-042734
base:   47a2ee5d4a0bda05decdda7be0a77e792cdb09a3
patch link:    https://lore.kernel.org/r/20230512202311.2845526-2-dima%40arista.com
patch subject: [PATCH v6 01/21] net/tcp: Prepare tcp_md5sig_pool for TCP-AO
config: x86_64-randconfig-a005 (https://download.01.org/0day-ci/archive/20230513/202305130722.D7icLQEP-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/20045e7dda43aca6500ad05a899dcf5c59e9f63a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dmitry-Safonov/net-tcp-Prepare-tcp_md5sig_pool-for-TCP-AO/20230513-042734
        git checkout 20045e7dda43aca6500ad05a899dcf5c59e9f63a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/ipv4/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305130722.D7icLQEP-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/ipv4/tcp_sigpool.c:161:9: warning: variable 'ret' is uninitialized when used here [-Wuninitialized]
           return ret;
                  ^~~
   net/ipv4/tcp_sigpool.c:110:14: note: initialize the variable 'ret' to silence this warning
           int cpu, ret;
                       ^
                        = 0
   1 warning generated.


vim +/ret +161 net/ipv4/tcp_sigpool.c

   105	
   106	static int __cpool_alloc_pcp(struct sigpool_entry *e, const char *alg,
   107				     struct crypto_ahash *cpu0_hash)
   108	{
   109		struct crypto_ahash *hash;
   110		int cpu, ret;
   111	
   112		e->spr.pcp_req = alloc_percpu(struct ahash_request *);
   113		if (!e->spr.pcp_req)
   114			return -ENOMEM;
   115	
   116		hash = cpu0_hash;
   117		for_each_possible_cpu(cpu) {
   118			struct ahash_request *req;
   119	
   120			/* If ahash has a key - it has to be allocated per-CPU.
   121			 * In such case re-use for CPU0 hash that just have been
   122			 * allocated above.
   123			 */
   124			if (!hash)
   125				hash = crypto_alloc_ahash(alg, 0, CRYPTO_ALG_ASYNC);
   126			if (IS_ERR(hash))
   127				goto out_free_per_cpu;
   128	
   129			req = ahash_request_alloc(hash, GFP_KERNEL);
   130			if (!req)
   131				goto out_free_hash;
   132	
   133			ahash_request_set_callback(req, 0, NULL, NULL);
   134	
   135			*per_cpu_ptr(e->spr.pcp_req, cpu) = req;
   136	
   137			if (e->needs_key)
   138				hash = NULL;
   139		}
   140		return 0;
   141	
   142	out_free_hash:
   143		if (hash != cpu0_hash)
   144			crypto_free_ahash(hash);
   145	
   146	out_free_per_cpu:
   147		for_each_possible_cpu(cpu) {
   148			struct ahash_request *req = *per_cpu_ptr(e->spr.pcp_req, cpu);
   149			struct crypto_ahash *pcpu_hash;
   150	
   151			if (!req)
   152				break;
   153			pcpu_hash = crypto_ahash_reqtfm(req);
   154			ahash_request_free(req);
   155			/* hash per-CPU, e->needs_key == true */
   156			if (pcpu_hash != cpu0_hash)
   157				crypto_free_ahash(pcpu_hash);
   158		}
   159	
   160		free_percpu(e->spr.pcp_req);
 > 161		return ret;
   162	}
   163	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

