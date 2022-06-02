Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E174953B13C
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 03:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbiFBBKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 21:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbiFBBKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 21:10:45 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789AE286499;
        Wed,  1 Jun 2022 18:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654132243; x=1685668243;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4UxoSN4PtgxrLf/wgUO5B7SD7cFMIM4LvYxJbbrwpe8=;
  b=ftgXX6POHMH5RMy9J1vXv5CGvrWuvq5/yI7WQaJb+SONWduyXzsLEo1B
   o+niG0vLxkEWQJP3NM51sFRtjBS/w1HprVX0b9gwu5qAupppyR5PXgNYI
   dLLeOzGPnvAMu9Ah9KXkaPiDBENvgXIrEFQWo8GcdbuK1OtVf5gGatjHw
   GYA4ShmWzdpIsGPBbPN/OeBZpzZx5Cmk4MMVoVyDBCBTPpPYJgQDFIb1i
   ehSuoDlOyqbIM56ky/RAcy1n/ahwyPnSA3w0/h2gCUEvjKY/2CM2XW4l/
   Y0pEYu8kSol2/mheDcvtkaoKEPzxrcR5BQHewCpRPDLMLZeSqPjnYCppA
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="263419589"
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="263419589"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 18:10:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="680375301"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 01 Jun 2022 18:10:32 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nwZM7-0004be-Aq;
        Thu, 02 Jun 2022 01:10:31 +0000
Date:   Thu, 2 Jun 2022 09:09:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joanne Koong <joannekoong@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, edumazet@google.com,
        kafai@fb.com, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, testing@vger.kernel.org,
        Joanne Koong <joannelkoong@gmail.com>,
        syzbot+015d756bbd1f8b5c8f09@syzkaller.appspotmail.com,
        Eric Dumazet <edumzet@google.com>
Subject: Re: [PATCH net-next v1 resend 1/2] net: Update bhash2 when socket's
 rcv saddr changes
Message-ID: <202206020958.MfddzQxe-lkp@intel.com>
References: <20220601201434.1710931-2-joannekoong@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601201434.1710931-2-joannekoong@fb.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
config: hexagon-defconfig (https://download.01.org/0day-ci/archive/20220602/202206020958.MfddzQxe-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c825abd6b0198fb088d9752f556a70705bc99dfd)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d4e9d3ab2c5210670fbe995cc8b13310a5aa6310
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Joanne-Koong/Update-bhash2-when-socket-s-rcv-saddr-changes/20220602-050108
        git checkout d4e9d3ab2c5210670fbe995cc8b13310a5aa6310
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash net/ipv4/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/ipv4/inet_hashtables.c:830:5: warning: no previous prototype for function '__inet_bhash2_update_saddr' [-Wmissing-prototypes]
   int __inet_bhash2_update_saddr(struct sock *sk, struct inet_hashinfo *hinfo,
       ^
   net/ipv4/inet_hashtables.c:830:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int __inet_bhash2_update_saddr(struct sock *sk, struct inet_hashinfo *hinfo,
   ^
   static 
   1 warning generated.


vim +/__inet_bhash2_update_saddr +830 net/ipv4/inet_hashtables.c

   828	
   829	/* the lock for the socket's corresponding bhash entry must be held */
 > 830	int __inet_bhash2_update_saddr(struct sock *sk, struct inet_hashinfo *hinfo,
   831				       struct net *net, int port, int l3mdev)
   832	{
   833		struct inet_bind2_hashbucket *head2;
   834		struct inet_bind2_bucket *tb2;
   835	
   836		tb2 = inet_bind2_bucket_find(hinfo, net, port, l3mdev, sk,
   837					     &head2);
   838		if (!tb2) {
   839			tb2 = inet_bind2_bucket_create(hinfo->bind2_bucket_cachep,
   840						       net, head2, port, l3mdev, sk);
   841			if (!tb2)
   842				return -ENOMEM;
   843		}
   844	
   845		/* Remove the socket's old entry from bhash2 */
   846		__sk_del_bind2_node(sk);
   847	
   848		sk_add_bind2_node(sk, &tb2->owners);
   849		inet_csk(sk)->icsk_bind2_hash = tb2;
   850	
   851		return 0;
   852	}
   853	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
