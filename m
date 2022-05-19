Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 189A452C995
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 04:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbiESCH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 22:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiESCH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 22:07:28 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F58E3D48C;
        Wed, 18 May 2022 19:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652926047; x=1684462047;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NW+eRlcG/MgejbNpwgfiiUoBffsK8joi9+Ij1lE+c0g=;
  b=TVJVLxCh2JBXSzjW0ZI/68mgaIxlfD/t2cm4xnIqBx7GYAXxdJMsoEvQ
   m2rqrYUpo5va5C2SY6EeXOdUn08tAeor5WlZewdwSSrbU8tXzMbG1fKlv
   glGoCa7Mxi37BkMrUeNMjPllO5ZQK6kQvfqfUWrBiWp+iPvMMyKp4FE3I
   r5MWwBwTqHpmM1vu5p5ei/qraVEOICvwpePF5O321NewWuILq6tddYQ1V
   +d/fJZtaFD8VwAIyUHxq8LA5NSVOjyHr0dmYZeJwLRFD3yAnpAjAS3lKq
   WClKUZSRw5wOYB4yHkNpsxPuBMocdNY9DXZzchdcRQc8Vivdg8VjUTrjb
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="252497346"
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="252497346"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 19:07:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="523825043"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 18 May 2022 19:07:22 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nrVZR-0002w5-Sy;
        Thu, 19 May 2022 02:07:21 +0000
Date:   Thu, 19 May 2022 10:06:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: Re: [PATCH v3 bpf-next 4/5] net: netfilter: add kfunc helper to add
 a new ct entry
Message-ID: <202205191006.OH1ukt9R-lkp@intel.com>
References: <40e7ce4b79c86c46e5fbf22e9cafb51b9172da19.1652870182.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40e7ce4b79c86c46e5fbf22e9cafb51b9172da19.1652870182.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

I love your patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Bianconi/net-netfilter-add-kfunc-helper-to-update-ct-timeout/20220518-184654
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: s390-defconfig (https://download.01.org/0day-ci/archive/20220519/202205191006.OH1ukt9R-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/7427419a3d3ae771c69eed7318a9b5f5d582b488
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Lorenzo-Bianconi/net-netfilter-add-kfunc-helper-to-update-ct-timeout/20220518-184654
        git checkout 7427419a3d3ae771c69eed7318a9b5f5d582b488
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash net/netfilter/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/netfilter/nf_conntrack_bpf.c:99:1: warning: no previous prototype for '__bpf_nf_ct_alloc_entry' [-Wmissing-prototypes]
      99 | __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
         | ^~~~~~~~~~~~~~~~~~~~~~~


vim +/__bpf_nf_ct_alloc_entry +99 net/netfilter/nf_conntrack_bpf.c

    97	
    98	struct nf_conn *
  > 99	__bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
   100				u32 tuple_len, u8 protonum, s32 netns_id, u32 timeout)
   101	{
   102		struct nf_conntrack_tuple otuple, rtuple;
   103		struct nf_conn *ct;
   104		int err;
   105	
   106		if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
   107			return ERR_PTR(-EINVAL);
   108	
   109		err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, protonum,
   110					    IP_CT_DIR_ORIGINAL, &otuple);
   111		if (err < 0)
   112			return ERR_PTR(err);
   113	
   114		err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, protonum,
   115					    IP_CT_DIR_REPLY, &rtuple);
   116		if (err < 0)
   117			return ERR_PTR(err);
   118	
   119		if (netns_id >= 0) {
   120			net = get_net_ns_by_id(net, netns_id);
   121			if (unlikely(!net))
   122				return ERR_PTR(-ENONET);
   123		}
   124	
   125		ct = nf_conntrack_alloc(net, &nf_ct_zone_dflt, &otuple, &rtuple,
   126					GFP_ATOMIC);
   127		if (IS_ERR(ct))
   128			goto out;
   129	
   130		ct->timeout = timeout * HZ + jiffies;
   131		ct->status |= IPS_CONFIRMED;
   132	
   133		memset(&ct->proto, 0, sizeof(ct->proto));
   134		if (protonum == IPPROTO_TCP)
   135			ct->proto.tcp.state = TCP_CONNTRACK_ESTABLISHED;
   136	
   137		err = nf_conntrack_hash_check_insert(ct);
   138		if (err < 0) {
   139			nf_conntrack_free(ct);
   140			ct = ERR_PTR(err);
   141		}
   142	out:
   143		if (netns_id >= 0)
   144			put_net(net);
   145	
   146		return ct;
   147	}
   148	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
