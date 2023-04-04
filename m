Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D056D569E
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 04:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbjDDCM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 22:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbjDDCM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 22:12:26 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266981728;
        Mon,  3 Apr 2023 19:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680574322; x=1712110322;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=O3LmMUztqYHW9Ro/MW5kg4lW7J5uBoJYEKMV7Bq+Dgg=;
  b=H0ospT3xA4u07rYn8l3Iud1VVCYzovgUqVYIP1h87HwKu11aDXKjbjEi
   +Mg7ivXOtZkjdXp/4jMeiHomATlKBbw94/SNZGPc7I7yfEuebDndbemiY
   u2wBIgu9QAXBqtaXiNNuvoWqsNHhiiDTrynzvFTNd3YdDCvyzx2hct9sw
   +wwhgPLlFmNOkWqCtUtBqQboDLr7y5ZrArsjJgiDwNOZadzRiOIXslw+R
   A0AyNu+HWdpICwpUlsmAGBfuN2+6Eu+xPkFVJYAvCgg/Jim014T7yQcHe
   hOamsFxSw3K05gSbO99aEhcDbipqVqAq4Fbx2iQbrHEVnKLSOEodEnbOX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="326085989"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="326085989"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 19:12:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="686188929"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="686188929"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 03 Apr 2023 19:11:58 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pjW9I-000P2I-2L;
        Tue, 04 Apr 2023 02:11:52 +0000
Date:   Tue, 4 Apr 2023 10:10:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>, cong.wang@bytedance.com,
        jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com
Cc:     oe-kbuild-all@lists.linux.dev, john.fastabend@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v3 01/12] bpf: sockmap, pass skb ownership through
 read_skb
Message-ID: <202304040949.mjn0pmKV-lkp@intel.com>
References: <20230403200138.937569-2-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403200138.937569-2-john.fastabend@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

kernel test robot noticed the following build warnings:

[auto build test WARNING on bpf/master]

url:    https://github.com/intel-lab-lkp/linux/commits/John-Fastabend/bpf-sockmap-pass-skb-ownership-through-read_skb/20230404-040431
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git master
patch link:    https://lore.kernel.org/r/20230403200138.937569-2-john.fastabend%40gmail.com
patch subject: [PATCH bpf v3 01/12] bpf: sockmap, pass skb ownership through read_skb
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20230404/202304040949.mjn0pmKV-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/44ddc6a14f8903f3f97d347b5303f678a8e2c3ea
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review John-Fastabend/bpf-sockmap-pass-skb-ownership-through-read_skb/20230404-040431
        git checkout 44ddc6a14f8903f3f97d347b5303f678a8e2c3ea
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/ipv4/ net/unix/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304040949.mjn0pmKV-lkp@intel.com/

All warnings (new ones prefixed by >>):

   net/ipv4/udp.c: In function 'udp_read_skb':
>> net/ipv4/udp.c:1816:18: warning: unused variable 'copied' [-Wunused-variable]
    1816 |         int err, copied;
         |                  ^~~~~~
--
   net/unix/af_unix.c: In function 'unix_read_skb':
>> net/unix/af_unix.c:2556:18: warning: unused variable 'copied' [-Wunused-variable]
    2556 |         int err, copied;
         |                  ^~~~~~


vim +/copied +1816 net/ipv4/udp.c

2276f58ac5890e Paolo Abeni     2017-05-16  1812  
965b57b469a589 Cong Wang       2022-06-15  1813  int udp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
d7f571188ecf25 Cong Wang       2021-03-30  1814  {
d7f571188ecf25 Cong Wang       2021-03-30  1815  	struct sk_buff *skb;
31f1fbcb346c93 Peilin Ye       2022-09-22 @1816  	int err, copied;
d7f571188ecf25 Cong Wang       2021-03-30  1817  
31f1fbcb346c93 Peilin Ye       2022-09-22  1818  try_again:
ec095263a96572 Oliver Hartkopp 2022-04-11  1819  	skb = skb_recv_udp(sk, MSG_DONTWAIT, &err);
d7f571188ecf25 Cong Wang       2021-03-30  1820  	if (!skb)
d7f571188ecf25 Cong Wang       2021-03-30  1821  		return err;
099f896f498a2b Cong Wang       2021-11-14  1822  
099f896f498a2b Cong Wang       2021-11-14  1823  	if (udp_lib_checksum_complete(skb)) {
31f1fbcb346c93 Peilin Ye       2022-09-22  1824  		int is_udplite = IS_UDPLITE(sk);
31f1fbcb346c93 Peilin Ye       2022-09-22  1825  		struct net *net = sock_net(sk);
31f1fbcb346c93 Peilin Ye       2022-09-22  1826  
31f1fbcb346c93 Peilin Ye       2022-09-22  1827  		__UDP_INC_STATS(net, UDP_MIB_CSUMERRORS, is_udplite);
31f1fbcb346c93 Peilin Ye       2022-09-22  1828  		__UDP_INC_STATS(net, UDP_MIB_INERRORS, is_udplite);
099f896f498a2b Cong Wang       2021-11-14  1829  		atomic_inc(&sk->sk_drops);
099f896f498a2b Cong Wang       2021-11-14  1830  		kfree_skb(skb);
31f1fbcb346c93 Peilin Ye       2022-09-22  1831  		goto try_again;
099f896f498a2b Cong Wang       2021-11-14  1832  	}
099f896f498a2b Cong Wang       2021-11-14  1833  
db39dfdc1c3bd9 Peilin Ye       2022-09-20  1834  	WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));
44ddc6a14f8903 John Fastabend  2023-04-03  1835  	return recv_actor(sk, skb);
d7f571188ecf25 Cong Wang       2021-03-30  1836  }
965b57b469a589 Cong Wang       2022-06-15  1837  EXPORT_SYMBOL(udp_read_skb);
d7f571188ecf25 Cong Wang       2021-03-30  1838  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
