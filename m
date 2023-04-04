Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4152A6D570D
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 05:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbjDDDNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 23:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbjDDDNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 23:13:08 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2250F2114;
        Mon,  3 Apr 2023 20:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680577982; x=1712113982;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Q3PIxfZjiQSnFPBrlx/lqbr6BF+fp9eU24opAoDCnow=;
  b=E6HfTP8MLLua1PNfFbpdo5aQhz34BOHBEQPcdHiCR7OhpSBOYPSeXwGl
   Wi/4/ImF3at5+b2iuu3uK1YEIp4Ocefv3tZ9I8mAyfbg5nibzRZs0JAKJ
   B+qWa3jIQ2bpAThrLg8kfgwPDSfzaugySr3dMdBP+yNnBeqxFrS7CYHJJ
   zMBYUFd96rps8hBxwQXwU2kwu+X40x7anvrR38ArkyYs++6UbNJSEQJDG
   FzEeDyf65GdAhoC1+X9RGnp8qbIJ5z5JQUjMgWTVNw26NRAJh0BQx13cL
   vlKrO/SEFoWOtLJX82KoQefwCrqKATuXHhpdCpAYhi8OeNFMJyoEgmWVT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="326093990"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="326093990"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 20:13:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="718779016"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="718779016"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 03 Apr 2023 20:12:57 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pjX6O-000P62-2I;
        Tue, 04 Apr 2023 03:12:56 +0000
Date:   Tue, 4 Apr 2023 11:12:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>, cong.wang@bytedance.com,
        jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: Re: [PATCH bpf v3 07/12] bpf: sockmap incorrectly handling copied_seq
Message-ID: <202304041028.XAQryEFM-lkp@intel.com>
References: <20230403200138.937569-8-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403200138.937569-8-john.fastabend@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
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
config: hexagon-randconfig-r041-20230403 (https://download.01.org/0day-ci/archive/20230404/202304041028.XAQryEFM-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 67409911353323ca5edf2049ef0df54132fa1ca7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/fbafbc850ec4ef5aa7e5c39d8133f291ec4c0bb8
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review John-Fastabend/bpf-sockmap-pass-skb-ownership-through-read_skb/20230404-040431
        git checkout fbafbc850ec4ef5aa7e5c39d8133f291ec4c0bb8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash net/core/ net/ipv4/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304041028.XAQryEFM-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from net/core/skmsg.c:4:
   In file included from include/linux/skmsg.h:7:
   In file included from include/linux/bpf.h:31:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:26:
   In file included from include/linux/kernel_stat.h:9:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
                                                     ^
   In file included from net/core/skmsg.c:4:
   In file included from include/linux/skmsg.h:7:
   In file included from include/linux/bpf.h:31:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:26:
   In file included from include/linux/kernel_stat.h:9:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
                                                     ^
   In file included from net/core/skmsg.c:4:
   In file included from include/linux/skmsg.h:7:
   In file included from include/linux/bpf.h:31:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:26:
   In file included from include/linux/kernel_stat.h:9:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
>> net/core/skmsg.c:1056:3: error: call to undeclared function 'tcp_eat_skb'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                   tcp_eat_skb(psock->sk, skb);
                   ^
   net/core/skmsg.c:1056:3: note: did you mean 'tcp_read_skb'?
   include/net/tcp.h:682:5: note: 'tcp_read_skb' declared here
   int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor);
       ^
   net/core/skmsg.c:1216:3: error: call to undeclared function 'tcp_eat_skb'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                   tcp_eat_skb(sk, skb);
                   ^
   6 warnings and 2 errors generated.
--
   In file included from net/ipv4/tcp_bpf.c:4:
   In file included from include/linux/skmsg.h:7:
   In file included from include/linux/bpf.h:31:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:26:
   In file included from include/linux/kernel_stat.h:9:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
                                                     ^
   In file included from net/ipv4/tcp_bpf.c:4:
   In file included from include/linux/skmsg.h:7:
   In file included from include/linux/bpf.h:31:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:26:
   In file included from include/linux/kernel_stat.h:9:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
                                                     ^
   In file included from net/ipv4/tcp_bpf.c:4:
   In file included from include/linux/skmsg.h:7:
   In file included from include/linux/bpf.h:31:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:26:
   In file included from include/linux/kernel_stat.h:9:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
>> net/ipv4/tcp_bpf.c:14:6: warning: no previous prototype for function 'tcp_eat_skb' [-Wmissing-prototypes]
   void tcp_eat_skb(struct sock *sk, struct sk_buff *skb)
        ^
   net/ipv4/tcp_bpf.c:14:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void tcp_eat_skb(struct sock *sk, struct sk_buff *skb)
   ^
   static 
   7 warnings generated.


vim +/tcp_eat_skb +1056 net/core/skmsg.c

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
