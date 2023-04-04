Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40FF86D56FD
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 05:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbjDDDDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 23:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjDDDDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 23:03:12 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC556133;
        Mon,  3 Apr 2023 20:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680577391; x=1712113391;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N/Phix0WCEAUrCVS0aZ8AFXIBjyECsvs0JD6OIZY+dY=;
  b=QBMV0VSgdOA6EZc5yeBahtQKNrqcvh8Gk33gS+W+2kk5YRVN7F97pBDa
   nbrBxi9uLwC5HfwMYlPms7sidL59X8WCM6bLhDrGfmZFzXVeGZ2Slt+EJ
   hpq0B6e6KujYQ1K3uCEveB04UdsUiTzG/jrgd1BPZaLLNwNs4pT5LMKjp
   I7udTttn5mKOO8LMPdgCWvC52dOp8M7x1+G2qbF4yWsJeRiL2684Wluj/
   ubyml6Qvzc8TgE6rqTpN6eSVdHU8yzAqvJzXtsUop6kcIXMbzxbZe0UfO
   1iDwYSTvbJaIv8VKeHbGAJSJOh1atVqygR4PM4badMTLk3SX5IujS9UzQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="330658843"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="330658843"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 20:03:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="716495136"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="716495136"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 03 Apr 2023 20:02:56 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pjWwh-000P5W-31;
        Tue, 04 Apr 2023 03:02:55 +0000
Date:   Tue, 4 Apr 2023 11:02:13 +0800
From:   kernel test robot <lkp@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>, cong.wang@bytedance.com,
        jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com
Cc:     oe-kbuild-all@lists.linux.dev, john.fastabend@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v3 07/12] bpf: sockmap incorrectly handling copied_seq
Message-ID: <202304041013.HATc3V5L-lkp@intel.com>
References: <20230403200138.937569-8-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403200138.937569-8-john.fastabend@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

kernel test robot noticed the following build errors:

[auto build test ERROR on bpf/master]

url:    https://github.com/intel-lab-lkp/linux/commits/John-Fastabend/bpf-sockmap-pass-skb-ownership-through-read_skb/20230404-040431
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git master
patch link:    https://lore.kernel.org/r/20230403200138.937569-8-john.fastabend%40gmail.com
patch subject: [PATCH bpf v3 07/12] bpf: sockmap incorrectly handling copied_seq
config: sparc64-randconfig-r025-20230403 (https://download.01.org/0day-ci/archive/20230404/202304041013.HATc3V5L-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/fbafbc850ec4ef5aa7e5c39d8133f291ec4c0bb8
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review John-Fastabend/bpf-sockmap-pass-skb-ownership-through-read_skb/20230404-040431
        git checkout fbafbc850ec4ef5aa7e5c39d8133f291ec4c0bb8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc64 SHELL=/bin/bash net/core/ net/ipv4/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304041013.HATc3V5L-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   net/core/skmsg.c: In function 'sk_psock_verdict_apply':
>> net/core/skmsg.c:1056:17: error: implicit declaration of function 'tcp_eat_skb'; did you mean 'tcp_read_skb'? [-Werror=implicit-function-declaration]
    1056 |                 tcp_eat_skb(psock->sk, skb);
         |                 ^~~~~~~~~~~
         |                 tcp_read_skb
   cc1: some warnings being treated as errors
--
>> net/ipv4/tcp_bpf.c:14:6: warning: no previous prototype for 'tcp_eat_skb' [-Wmissing-prototypes]
      14 | void tcp_eat_skb(struct sock *sk, struct sk_buff *skb)
         |      ^~~~~~~~~~~


vim +1056 net/core/skmsg.c

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
  1062			tcp_eat_skb(psock->sk, skb);
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
