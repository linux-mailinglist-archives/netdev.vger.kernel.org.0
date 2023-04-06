Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61ADC6D8E89
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 06:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbjDFEvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 00:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjDFEvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 00:51:42 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDB072A3;
        Wed,  5 Apr 2023 21:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680756701; x=1712292701;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bqJe+t1QsecNzm1dAwJpBEL7IrTSX/dNoAOZTjiKKhc=;
  b=m+bUM7zS1PcmHMH747VnF5gpKBPZB2K1YVk8XXBu/SDawPduYOMyG2FT
   QzbWd+NILjj/I8KcHSRarYs4vVk09TVjjbov5NDjrwE1l+a6fZLzfN/8z
   KwTpprfJ8JGA/Gb2EzQhecDy33dsjRAyInXz5LhhjlyBXw0YDSBnol8zj
   UWXIsOOamPVLAy9EU+WK+GniYLluC1BMw+vMYbThm1ykonUShIIdpPxip
   oN6q0CDjCMydNMuySEbmgUM+65jph+uvYu8cvLJWzkl8dTkqRjVU7m6G/
   IZbr080SqhEIdWgigM6XyhsDWd/NOLnNDD4hfidA+h10QDS4uUVwrD+mI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="405421806"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="405421806"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 21:51:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="680521706"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="680521706"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 05 Apr 2023 21:51:37 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pkHay-000R3C-2A;
        Thu, 06 Apr 2023 04:51:36 +0000
Date:   Thu, 6 Apr 2023 12:50:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>, jakub@cloudflare.com,
        daniel@iogearbox.net, edumazet@google.com
Cc:     oe-kbuild-all@lists.linux.dev, john.fastabend@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v5 07/12] bpf: sockmap, incorrectly handling
 copied_seq
Message-ID: <202304061211.MxmUvLOR-lkp@intel.com>
References: <20230406010031.3354-8-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406010031.3354-8-john.fastabend@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

kernel test robot noticed the following build errors:

[auto build test ERROR on bpf/master]

url:    https://github.com/intel-lab-lkp/linux/commits/John-Fastabend/bpf-sockmap-pass-skb-ownership-through-read_skb/20230406-090237
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git master
patch link:    https://lore.kernel.org/r/20230406010031.3354-8-john.fastabend%40gmail.com
patch subject: [PATCH bpf v5 07/12] bpf: sockmap, incorrectly handling copied_seq
config: nios2-randconfig-r024-20230403 (https://download.01.org/0day-ci/archive/20230406/202304061211.MxmUvLOR-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/4fe1333c965d96cc2aee2e018a5219a7c8b2c0c5
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review John-Fastabend/bpf-sockmap-pass-skb-ownership-through-read_skb/20230406-090237
        git checkout 4fe1333c965d96cc2aee2e018a5219a7c8b2c0c5
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=nios2 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=nios2 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304061211.MxmUvLOR-lkp@intel.com/

All errors (new ones prefixed by >>):

   nios2-linux-ld: net/core/skmsg.o: in function `sk_psock_verdict_apply':
>> net/core/skmsg.c:1062: undefined reference to `tcp_eat_skb'
   net/core/skmsg.c:1062:(.text+0x1348): relocation truncated to fit: R_NIOS2_CALL26 against `tcp_eat_skb'
>> nios2-linux-ld: net/core/skmsg.c:1056: undefined reference to `tcp_eat_skb'
   net/core/skmsg.c:1056:(.text+0x1470): relocation truncated to fit: R_NIOS2_CALL26 against `tcp_eat_skb'
   nios2-linux-ld: net/core/skmsg.o: in function `sk_psock_verdict_recv':
   net/core/skmsg.c:1216: undefined reference to `tcp_eat_skb'
   net/core/skmsg.c:1216:(.text+0x14c4): relocation truncated to fit: R_NIOS2_CALL26 against `tcp_eat_skb'


vim +1062 net/core/skmsg.c

   986	
   987	static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
   988					  int verdict)
   989	{
   990		struct sk_psock_work_state *state;
   991		struct sock *sk_other;
   992		int err = 0;
   993		u32 len, off;
   994	
   995		switch (verdict) {
   996		case __SK_PASS:
   997			err = -EIO;
   998			sk_other = psock->sk;
   999			if (sock_flag(sk_other, SOCK_DEAD) ||
  1000			    !sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
  1001				skb_bpf_redirect_clear(skb);
  1002				goto out_free;
  1003			}
  1004	
  1005			skb_bpf_set_ingress(skb);
  1006	
  1007			/* We need to grab mutex here because in-flight skb is in one of
  1008			 * the following states: either on ingress_skb, in psock->state
  1009			 * or being processed by backlog and neither in state->skb and
  1010			 * ingress_skb may be also empty. The troublesome case is when
  1011			 * the skb has been dequeued from ingress_skb list or taken from
  1012			 * state->skb because we can not easily test this case. Maybe we
  1013			 * could be clever with flags and resolve this but being clever
  1014			 * got us here in the first place and we note this is done under
  1015			 * sock lock and backlog conditions mean we are already running
  1016			 * into ENOMEM or other performance hindering cases so lets do
  1017			 * the obvious thing and grab the mutex.
  1018			 */
  1019			mutex_lock(&psock->work_mutex);
  1020			state = &psock->work_state;
  1021	
  1022			/* If the queue is empty then we can submit directly
  1023			 * into the msg queue. If its not empty we have to
  1024			 * queue work otherwise we may get OOO data. Otherwise,
  1025			 * if sk_psock_skb_ingress errors will be handled by
  1026			 * retrying later from workqueue.
  1027			 */
  1028			if (skb_queue_empty(&psock->ingress_skb) && likely(!state->skb)) {
  1029				len = skb->len;
  1030				off = 0;
  1031				if (skb_bpf_strparser(skb)) {
  1032					struct strp_msg *stm = strp_msg(skb);
  1033	
  1034					off = stm->offset;
  1035					len = stm->full_len;
  1036				}
  1037				err = sk_psock_skb_ingress_self(psock, skb, off, len);
  1038			}
  1039			if (err < 0) {
  1040				spin_lock_bh(&psock->ingress_lock);
  1041				if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
  1042					skb_queue_tail(&psock->ingress_skb, skb);
  1043					schedule_delayed_work(&psock->work, 0);
  1044					err = 0;
  1045				}
  1046				spin_unlock_bh(&psock->ingress_lock);
  1047				if (err < 0) {
  1048					skb_bpf_redirect_clear(skb);
  1049					mutex_unlock(&psock->work_mutex);
  1050					goto out_free;
  1051				}
  1052			}
  1053			mutex_unlock(&psock->work_mutex);
  1054			break;
  1055		case __SK_REDIRECT:
> 1056			tcp_eat_skb(psock->sk, skb);
  1057			err = sk_psock_skb_redirect(psock, skb);
  1058			break;
  1059		case __SK_DROP:
  1060		default:
  1061	out_free:
> 1062			tcp_eat_skb(psock->sk, skb);
  1063			skb_bpf_redirect_clear(skb);
  1064			sock_drop(psock->sk, skb);
  1065		}
  1066	
  1067		return err;
  1068	}
  1069	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
