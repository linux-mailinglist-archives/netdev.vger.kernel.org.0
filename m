Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C664ADDFD
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 17:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382737AbiBHQKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 11:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343745AbiBHQKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 11:10:53 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CDAC061578;
        Tue,  8 Feb 2022 08:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644336653; x=1675872653;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Mc91wvHfFSboTJHR5WNZ7bZOFFZeN70QARuWwy+FfXk=;
  b=FjcHAOhVwcdEJ7gecTHhwJdrlWCnDjO5HCU/2UZVramu5F8pp86/GnxY
   xxVmKDvZ9oLchNBPvL1CQvS6Ed1fsiYHUrHyJE4iSsaGAT7IHh2laFVqD
   otPItK04YCvhxyFAymA7QNUmAEWomGj9zDe2gPxwApwBJdbhHLezccVUq
   OOmtFG2nrjAfaIZXxFVep2KX+JZYUCS2ZwWjWqbCZ5/7Q4BcumQU/mElR
   lsCuo3zK3V16MUChRC4tU3+fFlSrvbGX8gN/0Zw91R/qT/2fMJPpncAOF
   YpPwZSGDb6ZN78l0OuUsTVCT98meDNZL7VR6HbPN6JEAG0xRa61t4ouhH
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="246568513"
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="246568513"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 08:10:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="700890577"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 08 Feb 2022 08:10:49 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nHT4r-0000Ph-9S; Tue, 08 Feb 2022 16:10:49 +0000
Date:   Wed, 9 Feb 2022 00:10:24 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jeremy Kerr <jk@codeconstruct.com.au>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Matt Johnston <matt@codeconstruct.com.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next 5/5] mctp: Add SIOCMCTP{ALLOC,DROP}TAG ioctls
 for tag control
Message-ID: <202202090043.BhR7muS4-lkp@intel.com>
References: <20220208094617.3675511-6-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208094617.3675511-6-jk@codeconstruct.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jeremy,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Jeremy-Kerr/MCTP-tag-control-interface/20220208-195325
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git c3e676b98326a419f30dd5d956c68fc33323f4fd
config: nios2-randconfig-r021-20220208 (https://download.01.org/0day-ci/archive/20220209/202202090043.BhR7muS4-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/a1d553f399d7457bd3e455cd3f5e10dddb4bc2bf
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jeremy-Kerr/MCTP-tag-control-interface/20220208-195325
        git checkout a1d553f399d7457bd3e455cd3f5e10dddb4bc2bf
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=nios2 SHELL=/bin/bash kernel/ net/mctp/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/mctp/route.c:660:21: warning: no previous prototype for 'mctp_lookup_prealloc_tag' [-Wmissing-prototypes]
     660 | struct mctp_sk_key *mctp_lookup_prealloc_tag(struct mctp_sock *msk,
         |                     ^~~~~~~~~~~~~~~~~~~~~~~~


vim +/mctp_lookup_prealloc_tag +660 net/mctp/route.c

   659	
 > 660	struct mctp_sk_key *mctp_lookup_prealloc_tag(struct mctp_sock *msk,
   661						     mctp_eid_t daddr, u8 req_tag,
   662						     u8 *tagp)
   663	{
   664		struct net *net = sock_net(&msk->sk);
   665		struct netns_mctp *mns = &net->mctp;
   666		struct mctp_sk_key *key, *tmp;
   667		unsigned long flags;
   668	
   669		req_tag &= ~(MCTP_TAG_PREALLOC | MCTP_TAG_OWNER);
   670		key = NULL;
   671	
   672		spin_lock_irqsave(&mns->keys_lock, flags);
   673	
   674		hlist_for_each_entry(tmp, &mns->keys, hlist) {
   675			if (tmp->tag != req_tag)
   676				continue;
   677	
   678			if (!(tmp->peer_addr == daddr || tmp->peer_addr == MCTP_ADDR_ANY))
   679				continue;
   680	
   681			if (!tmp->manual_alloc)
   682				continue;
   683	
   684			spin_lock(&tmp->lock);
   685			if (tmp->valid) {
   686				key = tmp;
   687				refcount_inc(&key->refs);
   688				spin_unlock(&tmp->lock);
   689				break;
   690			}
   691			spin_unlock(&tmp->lock);
   692		}
   693		spin_unlock_irqrestore(&mns->keys_lock, flags);
   694	
   695		if (!key)
   696			return ERR_PTR(-ENOENT);
   697	
   698		if (tagp)
   699			*tagp = key->tag;
   700	
   701		return key;
   702	}
   703	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
