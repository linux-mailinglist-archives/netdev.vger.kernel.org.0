Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E090853782F
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235042AbiE3KCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 06:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235047AbiE3KB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 06:01:56 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE79F793B1;
        Mon, 30 May 2022 03:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653904915; x=1685440915;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eWFXU1FqNlG5B/9DM+yltZRjaMGGPd6zhl4yLDxNnVE=;
  b=ZTMjp5ZcNyAUNbVF6UaKAO3B4Si8hz68sYaSITRT8Ql3+vbeYBBDZPXL
   JpmRsOJpTwxgEfkvIixEfISFDy9D2o3Uqy9vIh5rBJhQtWXD+ZfD41Rxw
   b950PO7QxHn/tlaw2KtQ/hbbA7uURNVCcPnGGjwpsrelhh3/IlqGaD6H6
   PQcK3GDN6gps4eYaiPMOsjdpRaj4gsXdeO+Gp74ba6ls5kMqD56qGYkhS
   iO+lvJIXSBj6XuUM61SnMH8Hznu8Nmayb2Rl+teAuW/kWKwPaPy9sMgP6
   EvGO58ouJRlENHqDfkqGwt/SXxW6vSrHmRHMHsi4fArhB0FH3VB7aCmZk
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10362"; a="273772964"
X-IronPort-AV: E=Sophos;i="5.91,262,1647327600"; 
   d="scan'208";a="273772964"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2022 03:01:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,262,1647327600"; 
   d="scan'208";a="644564836"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 30 May 2022 03:01:48 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nvcDb-0001eE-Mo;
        Mon, 30 May 2022 10:01:47 +0000
Date:   Mon, 30 May 2022 18:01:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     menglong8.dong@gmail.com, kuba@kernel.org
Cc:     kbuild-all@lists.01.org, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        nhorman@tuxdriver.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        imagedong@tencent.com, dsahern@kernel.org, talalahmad@google.com,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] net: skb: use auto-generation to convert
 skb drop reason to string
Message-ID: <202205301730.inNRSOxX-lkp@intel.com>
References: <20220530081201.10151-3-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530081201.10151-3-imagedong@tencent.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/menglong8-dong-gmail-com/reorganize-the-code-of-the-enum-skb_drop_reason/20220530-161614
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 7e062cda7d90543ac8c7700fc7c5527d0c0f22ad
config: nios2-defconfig (https://download.01.org/0day-ci/archive/20220530/202205301730.inNRSOxX-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/73e3b002fb9086fc734ba4dcc3041f9bb56eb1a2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review menglong8-dong-gmail-com/reorganize-the-code-of-the-enum-skb_drop_reason/20220530-161614
        git checkout 73e3b002fb9086fc734ba4dcc3041f9bb56eb1a2
        # save the config file
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 ARCH=nios2 

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
