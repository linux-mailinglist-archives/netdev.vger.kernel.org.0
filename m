Return-Path: <netdev+bounces-10461-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE90B72E9A7
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:29:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE1911C208BE
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C465B37B89;
	Tue, 13 Jun 2023 17:29:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6E123C74;
	Tue, 13 Jun 2023 17:29:23 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C34173C;
	Tue, 13 Jun 2023 10:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686677334; x=1718213334;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SlHj7S5jOOv05K4dEGQA+cB2WN4KQBOtvdjDfWv8PXg=;
  b=Smfb44NorWLELeCCs+PbsDBnJtYiS4HZssecQw8CamAXLcBsJ6y9HNow
   niBz/3dmTAgr4E08cbTZ+EvoWthc/EpNPGRUUtuI/Z6YHDycYoAieTrJM
   Gi1b4ncZ0/IVYL6TUCxnOXtrGAZmg4H6BpwM5yUuiJzLKe5Lco4r2BxAz
   yHL3AvWSTAaMMQYEr1Ef//BGCJQqA4dSBrhfICNpw2v6HXP8HyjZR/m5M
   nOedioBMaUz8iXbmFCCVFye+x2HaQYFLbahIPr/hWLjWfk67YIMZjSnAF
   SKP+9NdJkV8DzMHUbk8i/KxIzuCJRcZQ3uoL5MoFx9nmwpf3PT394sudJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="361774277"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="361774277"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 10:27:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="885923880"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="885923880"
Received: from lkp-server01.sh.intel.com (HELO 211f47bdb1cb) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 13 Jun 2023 10:27:12 -0700
Received: from kbuild by 211f47bdb1cb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q97nT-0001bK-2i;
	Tue, 13 Jun 2023 17:27:11 +0000
Date: Wed, 14 Jun 2023 01:26:22 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenz Bauer <lmb@isovalent.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>,
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
	Joe Stringer <joe@wand.net.nz>, Mykola Lysenko <mykolal@fb.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netdev@vger.kernel.org, Hemanth Malla <hemanthmalla@gmail.com>,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Lorenz Bauer <lmb@isovalent.com>
Subject: Re: [PATCH bpf-next v2 5/6] bpf, net: Support SO_REUSEPORT sockets
 with bpf_sk_assign
Message-ID: <202306140012.hLncDFR5-lkp@intel.com>
References: <20230613-so-reuseport-v2-5-b7c69a342613@isovalent.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613-so-reuseport-v2-5-b7c69a342613@isovalent.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Lorenz,

kernel test robot noticed the following build errors:

[auto build test ERROR on 25085b4e9251c77758964a8e8651338972353642]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenz-Bauer/net-export-inet_lookup_reuseport-and-inet6_lookup_reuseport/20230613-181619
base:   25085b4e9251c77758964a8e8651338972353642
patch link:    https://lore.kernel.org/r/20230613-so-reuseport-v2-5-b7c69a342613%40isovalent.com
patch subject: [PATCH bpf-next v2 5/6] bpf, net: Support SO_REUSEPORT sockets with bpf_sk_assign
config: arm-randconfig-r016-20230612 (https://download.01.org/0day-ci/archive/20230614/202306140012.hLncDFR5-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        git checkout 25085b4e9251c77758964a8e8651338972353642
        b4 shazam https://lore.kernel.org/r/20230613-so-reuseport-v2-5-b7c69a342613@isovalent.com
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=arm olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306140012.hLncDFR5-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

WARNING: modpost: lib/test_user_copy.o: section mismatch in reference: (unknown) (section: .text.fixup) -> .Ltmp1 (section: .init.text)
WARNING: modpost: lib/test_user_copy.o: section mismatch in reference: (unknown) (section: .text.fixup) -> .Ltmp4 (section: .init.text)
WARNING: modpost: lib/test_user_copy.o: section mismatch in reference: (unknown) (section: .text.fixup) -> .Ltmp7 (section: .init.text)
WARNING: modpost: lib/test_user_copy.o: section mismatch in reference: (unknown) (section: .text.fixup) -> .Ltmp10 (section: .init.text)
WARNING: modpost: lib/test_user_copy.o: section mismatch in reference: (unknown) (section: .text.fixup) -> .Ltmp13 (section: .init.text)
WARNING: modpost: lib/test_user_copy.o: section mismatch in reference: (unknown) (section: .text.fixup) -> .Ltmp16 (section: .init.text)
WARNING: modpost: lib/test_user_copy.o: section mismatch in reference: (unknown) (section: .text.fixup) -> .Ltmp19 (section: .init.text)
WARNING: modpost: lib/test_user_copy.o: section mismatch in reference: (unknown) (section: .text.fixup) -> .Ltmp22 (section: .init.text)
WARNING: modpost: lib/test_user_copy.o: section mismatch in reference: (unknown) (section: .text.fixup) -> .Ltmp25 (section: .init.text)
WARNING: modpost: lib/test_user_copy.o: section mismatch in reference: (unknown) (section: .text.fixup) -> .Ltmp28 (section: .init.text)
WARNING: modpost: lib/test_user_copy.o: section mismatch in reference: (unknown) (section: .text.fixup) -> .Ltmp31 (section: .init.text)
WARNING: modpost: lib/test_user_copy.o: section mismatch in reference: (unknown) (section: .text.fixup) -> .Ltmp34 (section: .init.text)
>> ERROR: modpost: "inet_ehashfn" [net/dccp/dccp_ipv4.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

