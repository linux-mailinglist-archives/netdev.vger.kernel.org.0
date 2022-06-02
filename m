Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B41553B3E0
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 08:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbiFBGvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 02:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiFBGvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 02:51:19 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664C32A3A16;
        Wed,  1 Jun 2022 23:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654152678; x=1685688678;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dXJ+DZxVh+iuczu508JuqBQrDovi3ToHnV0cOsDG2vk=;
  b=apB1hDb4plhx0nomzOi9xuu49qwJWB9cIztCasIn5pMbngVVtTBplpi4
   akccZYRw5lGBnzdpwnGY7Ya6JyvPj4KaBQTkpEfR/bUhbVbqK0pVXFs3S
   cttfgRX8G0gkprNJy8UAsV+mbOP8X6pVlxJls4Q5ow+k8iVGSvYOPwpYR
   zKv/GW64aB6aO+UvT6Dm5cI9KDhFjR18Eyy2Xl6t/FNcj2CrtcbRjtlHT
   WipO1EpTu753WpCqndukKR1FYsn3ms3I8PZ53DHcIhCkQ0oMoTRgt3S+6
   dHZ454wIZFL9xt8KRRwqFr9YsIPQCHwYuS731w03FZefjJmryKL93fAXM
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="336502947"
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="336502947"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 23:51:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="721159771"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 01 Jun 2022 23:51:13 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nwefp-0004of-5z;
        Thu, 02 Jun 2022 06:51:13 +0000
Date:   Thu, 2 Jun 2022 14:50:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joanne Koong <joannekoong@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, edumazet@google.com, kafai@fb.com,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        testing@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
        syzbot+015d756bbd1f8b5c8f09@syzkaller.appspotmail.com,
        Eric Dumazet <edumzet@google.com>
Subject: Re: [PATCH net-next v1 resend 1/2] net: Update bhash2 when socket's
 rcv saddr changes
Message-ID: <202206021442.Rb7gLaDQ-lkp@intel.com>
References: <20220601201434.1710931-2-joannekoong@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601201434.1710931-2-joannekoong@fb.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joanne,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/Update-bhash2-when-socket-s-rcv-saddr-changes/20220602-050108
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 7e062cda7d90543ac8c7700fc7c5527d0c0f22ad
config: i386-randconfig-s001 (https://download.01.org/0day-ci/archive/20220602/202206021442.Rb7gLaDQ-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-14-g5a0004b5-dirty
        # https://github.com/intel-lab-lkp/linux/commit/d4e9d3ab2c5210670fbe995cc8b13310a5aa6310
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Joanne-Koong/Update-bhash2-when-socket-s-rcv-saddr-changes/20220602-050108
        git checkout d4e9d3ab2c5210670fbe995cc8b13310a5aa6310
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> net/ipv4/inet_hashtables.c:830:5: sparse: sparse: symbol '__inet_bhash2_update_saddr' was not declared. Should it be static?

Please review and possibly fold the followup patch.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
