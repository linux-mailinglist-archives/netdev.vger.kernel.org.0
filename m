Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776EB4BD4CE
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 05:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343876AbiBUEgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 23:36:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343853AbiBUEgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 23:36:32 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30F940E4E;
        Sun, 20 Feb 2022 20:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645418169; x=1676954169;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+Pq+xpA3IEK4JrCzqW93Y+vVzfUMjxuVojVzAftO/+E=;
  b=EzlP5eH+wtdj5vuOGhRLlszhWiks/Frqcfd8v400TeMUl68X65bvElNq
   vlje8QW6Red2AqDsgABua17V3moDb05CDkSpZakQfauXluRvegQo3XbWe
   rw24Kfjki0Id1LaaV+FqhZYKoUqYy7HUI8sQ67SQ/P/8f2+ne1hXqegbR
   I4PX0dJEgtJSZ7x5qj8qTWdgbFZTOkVtdC8hANi9+TOM7+toEIr6MIZCk
   0gEttfpFGTThSlQLerJoCNb+QtNDchaIKJZ5N8oIyWoV96Jgp7YRCTkF3
   OO8tN0xJrx15f66PIGVL5j7rT1BJyI48g45WpRlbMir6llBehdlYGlnTo
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="276023745"
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="276023745"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 20:36:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="547173186"
Received: from lkp-server01.sh.intel.com (HELO da3212ac2f54) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 20 Feb 2022 20:36:06 -0800
Received: from kbuild by da3212ac2f54 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nM0Qf-0001Jm-Te; Mon, 21 Feb 2022 04:36:05 +0000
Date:   Mon, 21 Feb 2022 12:35:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 12/15] net/netfilter: Add bpf_ct_kptr_get
 helper
Message-ID: <202202211228.CO4wFX0Q-lkp@intel.com>
References: <20220220134813.3411982-13-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220220134813.3411982-13-memxor@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kumar,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on next-20220217]
[cannot apply to bpf-next/master bpf/master linus/master v5.17-rc4 v5.17-rc3 v5.17-rc2 v5.17-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Kumar-Kartikeya-Dwivedi/Introduce-typed-pointer-support-in-BPF-maps/20220220-215105
base:    3c30cf91b5ecc7272b3d2942ae0505dd8320b81c
config: s390-defconfig (https://download.01.org/0day-ci/archive/20220221/202202211228.CO4wFX0Q-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/79e35d4e4ee33a7692f0612065012307a361cd56
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Kumar-Kartikeya-Dwivedi/Introduce-typed-pointer-support-in-BPF-maps/20220220-215105
        git checkout 79e35d4e4ee33a7692f0612065012307a361cd56
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=s390 SHELL=/bin/bash net/netfilter/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/netfilter/nf_conntrack_bpf.c: In function 'bpf_ct_kptr_get':
>> net/netfilter/nf_conntrack_bpf.c:226:21: warning: variable 'net' set but not used [-Wunused-but-set-variable]
     226 |         struct net *net;
         |                     ^~~
   net/netfilter/nf_conntrack_bpf.c: At top level:
   net/netfilter/nf_conntrack_bpf.c:314:5: warning: no previous prototype for 'register_nf_conntrack_bpf' [-Wmissing-prototypes]
     314 | int register_nf_conntrack_bpf(void)
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~


vim +/net +226 net/netfilter/nf_conntrack_bpf.c

   219	
   220	/* TODO: Just a PoC, need to reuse code in __nf_conntrack_find_get for this */
   221	struct nf_conn *bpf_ct_kptr_get(struct nf_conn **ptr, struct bpf_sock_tuple *bpf_tuple,
   222					u32 tuple__sz, u8 protonum, u8 direction)
   223	{
   224		struct nf_conntrack_tuple tuple;
   225		struct nf_conn *nfct;
 > 226		struct net *net;
   227		u64 *nfct_p;
   228		int ret;
   229	
   230		WARN_ON_ONCE(!rcu_read_lock_held());
   231	
   232		if ((protonum != IPPROTO_TCP && protonum != IPPROTO_UDP) ||
   233		    (direction != IP_CT_DIR_ORIGINAL && direction != IP_CT_DIR_REPLY))
   234			return NULL;
   235	
   236		/* ptr is actually pointer to u64 having address, hence recast u64 load
   237		 * to native pointer width.
   238		 */
   239		nfct_p = (u64 *)ptr;
   240		nfct = (struct nf_conn *)READ_ONCE(*nfct_p);
   241		if (!nfct || unlikely(!refcount_inc_not_zero(&nfct->ct_general.use)))
   242			return NULL;
   243	
   244		memset(&tuple, 0, sizeof(tuple));
   245		ret = bpf_fill_nf_tuple(&tuple, bpf_tuple, tuple__sz);
   246		if (ret < 0)
   247			goto end;
   248		tuple.dst.protonum = protonum;
   249	
   250		/* XXX: Need to allow passing in struct net *, or take netns_id, this is non-sense */
   251		net = nf_ct_net(nfct);
   252		if (!nf_ct_key_equal(&nfct->tuplehash[direction], &tuple,
   253				     &nf_ct_zone_dflt, nf_ct_net(nfct)))
   254			goto end;
   255		return nfct;
   256	end:
   257		nf_ct_put(nfct);
   258		return NULL;
   259	}
   260	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
