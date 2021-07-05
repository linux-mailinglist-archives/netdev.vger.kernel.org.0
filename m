Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A229F3BBAF2
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 12:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhGEKSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 06:18:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:33103 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230396AbhGEKSe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 06:18:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10035"; a="208912814"
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="gz'50?scan'50,208,50";a="208912814"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2021 03:15:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="gz'50?scan'50,208,50";a="644158471"
Received: from lkp-server01.sh.intel.com (HELO 4aae0cb4f5b5) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 05 Jul 2021 03:15:53 -0700
Received: from kbuild by 4aae0cb4f5b5 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1m0Ldo-000CNm-EQ; Mon, 05 Jul 2021 10:15:52 +0000
Date:   Mon, 5 Jul 2021 18:15:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paul Blakey <paulb@nvidia.com>, netdev@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kbuild-all@lists.01.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
Subject: Re: [PATCH net v2] skbuff: Release nfct refcount on napi stolen or
 re-used skbs
Message-ID: <202107051828.LFqH8BA9-lkp@intel.com>
References: <1625471347-21730-1-git-send-email-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <1625471347-21730-1-git-send-email-paulb@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Paul,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]

url:    https://github.com/0day-ci/linux/commits/Paul-Blakey/skbuff-Release-nfct-refcount-on-napi-stolen-or-re-used-skbs/20210705-155140
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 6ff63a150b5556012589ae59efac1b5eeb7d32c3
config: um-x86_64_defconfig (attached as .config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/92ce7d888d93e976782be040ca8bff871e7153cf
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Paul-Blakey/skbuff-Release-nfct-refcount-on-napi-stolen-or-re-used-skbs/20210705-155140
        git checkout 92ce7d888d93e976782be040ca8bff871e7153cf
        # save the attached .config to linux build tree
        make W=1 ARCH=um SUBARCH=x86_64

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   net/core/skbuff.c: In function 'napi_skb_free_stolen_head':
>> net/core/skbuff.c:946:2: error: implicit declaration of function 'nf_conntrack_put' [-Werror=implicit-function-declaration]
     946 |  nf_conntrack_put(skb_nfct(skb));
         |  ^~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
--
   net/core/dev.c: In function 'gro_list_prepare':
>> net/core/dev.c:6015:33: error: implicit declaration of function 'skb_ext_find'; did you mean 'skb_ext_copy'? [-Werror=implicit-function-declaration]
    6015 |    struct tc_skb_ext *skb_ext = skb_ext_find(skb, TC_SKB_EXT);
         |                                 ^~~~~~~~~~~~
         |                                 skb_ext_copy
>> net/core/dev.c:6015:51: error: 'TC_SKB_EXT' undeclared (first use in this function)
    6015 |    struct tc_skb_ext *skb_ext = skb_ext_find(skb, TC_SKB_EXT);
         |                                                   ^~~~~~~~~~
   net/core/dev.c:6015:51: note: each undeclared identifier is reported only once for each function it appears in
>> net/core/dev.c:6020:19: error: dereferencing pointer to incomplete type 'struct tc_skb_ext'
    6020 |     diffs |= p_ext->chain ^ skb_ext->chain;
         |                   ^~
   cc1: some warnings being treated as errors


vim +/nf_conntrack_put +946 net/core/skbuff.c

   943	
   944	void napi_skb_free_stolen_head(struct sk_buff *skb)
   945	{
 > 946		nf_conntrack_put(skb_nfct(skb));
   947		skb_dst_drop(skb);
   948		skb_ext_put(skb);
   949		napi_skb_cache_put(skb);
   950	}
   951	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--7AUc2qLy4jB3hD7Z
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--7AUc2qLy4jB3hD7Z--
