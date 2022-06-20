Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57F85526A8
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 23:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243133AbiFTVkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 17:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240545AbiFTVkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 17:40:07 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E236D17E2D
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 14:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655761206; x=1687297206;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=48iCiQZQ8KLdMlmHJUvfdfk26T5licPB5avF+O7Uw3c=;
  b=X+A39MJHLncNqlLrZfIaxHChZU3xnGL4aohQLdLc5maYKziNxoYKRK1P
   ER8UD8CMcc23ZLeGzSMEhivT6q4uxENdIR1726wKgDJKtdeG0xZheRlqC
   Yn1e+x+fPiO9Ddrs44znV47WLN7Wf0oiexSxZjw4gbQcwNXiK9dQHBHld
   Sc1rc756v9qTEAMeyO01tlkn5ZNBtEEDs528ktGEIOPF2fKbvijqrsUFO
   vPZGnMSIOkeFWLoGWZfrj8DqdZNvo9UIPS+17nvYOTFmH8hdKNSdzhRSI
   liUWC/6llZNmYFG0OV1p8xWfGmCc5N7l8GEptCxtT4eYReflh6KletoPO
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="277524549"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="277524549"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 14:40:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="643306520"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 20 Jun 2022 14:40:04 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o3P7r-000WNr-ND;
        Mon, 20 Jun 2022 21:40:03 +0000
Date:   Tue, 21 Jun 2022 05:39:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Amit Shah <aams@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: Re: [PATCH v2 net-next 6/6] af_unix: Remove unix_table_locks.
Message-ID: <202206210532.q32y1W52-lkp@intel.com>
References: <20220620185151.65294-7-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620185151.65294-7-kuniyu@amazon.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kuniyuki,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Kuniyuki-Iwashima/af_unix-Introduce-per-netns-socket-hash-table/20220621-025503
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git dbca1596bbb08318f5e3b3b99f8ca0a0d3830a65
config: arc-defconfig (https://download.01.org/0day-ci/archive/20220621/202206210532.q32y1W52-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f2cd3aee6929543114a0728717969d9bb2f6fa90
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kuniyuki-Iwashima/af_unix-Introduce-per-netns-socket-hash-table/20220621-025503
        git checkout f2cd3aee6929543114a0728717969d9bb2f6fa90
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   net/unix/diag.c: In function 'unix_lookup_by_ino':
>> net/unix/diag.c:247:46: error: 'unix_table_locks' undeclared (first use in this function); did you mean 'unix_state_lock'?
     247 |                                 spin_unlock(&unix_table_locks[i]);
         |                                              ^~~~~~~~~~~~~~~~
         |                                              unix_state_lock
   net/unix/diag.c:247:46: note: each undeclared identifier is reported only once for each function it appears in


vim +247 net/unix/diag.c

22931d3b906cd0 Pavel Emelyanov   2011-12-15  235  
a50feb1de03567 Kuniyuki Iwashima 2022-06-20  236  static struct sock *unix_lookup_by_ino(struct net *net, unsigned int ino)
5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  237  {
5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  238  	struct sock *sk;
afd20b9290e184 Kuniyuki Iwashima 2021-11-24  239  	int i;
5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  240  
614d83f20d005b Kuniyuki Iwashima 2022-06-20  241  	for (i = 0; i < UNIX_HASH_SIZE; i++) {
a50feb1de03567 Kuniyuki Iwashima 2022-06-20  242  		spin_lock(&net->unx.table.locks[i]);
868a38bbd9ad2a Kuniyuki Iwashima 2022-06-20  243  		sk_for_each(sk, &net->unx.table.buckets[i]) {
5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  244  			if (ino == sock_i_ino(sk)) {
5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  245  				sock_hold(sk);
a50feb1de03567 Kuniyuki Iwashima 2022-06-20  246  				spin_unlock(&net->unx.table.locks[i]);
afd20b9290e184 Kuniyuki Iwashima 2021-11-24 @247  				spin_unlock(&unix_table_locks[i]);
5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  248  				return sk;
5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  249  			}
868a38bbd9ad2a Kuniyuki Iwashima 2022-06-20  250  		}
a50feb1de03567 Kuniyuki Iwashima 2022-06-20  251  		spin_unlock(&net->unx.table.locks[i]);
5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  252  	}
5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  253  	return NULL;
5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  254  }
5d3cae8bc39dd3 Pavel Emelyanov   2011-12-15  255  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
