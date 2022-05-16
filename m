Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D3F527DA9
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 08:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236842AbiEPGeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 02:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235353AbiEPGet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 02:34:49 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BFB2DA86;
        Sun, 15 May 2022 23:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652682888; x=1684218888;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PYSj7F5IhelFsr4dzEOfBF0oudXu8nev09gzwDsQjII=;
  b=jMNDLk+hleamsDBr4uq2WIhssZtnwqykvreMVZPcJuFK1E3fFfHZW0uu
   JFCIniijICvCreh1q5TA04FE7mWbRi2BzItb7kVRVZfTgMTR39dVyXBe8
   inngS/+d6r+z3o/H5iR24QfZr1IxhRgxR6+5Q+Jr7uxpCexFyVqQuZ5gq
   I+Sg2eGjrt/lLr8BMLau8qazwPpIwuY2ewNrwCM6rQl7H2+aUBNBhaCUY
   24MyXo+oSU//Q7GQz0b20XFlLnGXnaKLQRHinQFKwRFDPc8ARnlIc3Fd6
   04cf4ZKoH457c3MHTn6K1lDFG4VnnqIYg2jPRWYr31SMQVPiQN/zL0M61
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10348"; a="331371626"
X-IronPort-AV: E=Sophos;i="5.91,229,1647327600"; 
   d="scan'208";a="331371626"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2022 23:34:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,229,1647327600"; 
   d="scan'208";a="596370016"
Received: from lkp-server01.sh.intel.com (HELO d1462bc4b09b) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 15 May 2022 23:34:41 -0700
Received: from kbuild by d1462bc4b09b with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nqUJU-0002Cl-S3;
        Mon, 16 May 2022 06:34:40 +0000
Date:   Mon, 16 May 2022 14:34:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     menglong8.dong@gmail.com, edumazet@google.com
Cc:     kbuild-all@lists.01.org, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, imagedong@tencent.com,
        kafai@fb.com, talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 7/9] net: tcp: add skb drop reasons to tcp
 connect requesting
Message-ID: <202205161441.bl8a0hGC-lkp@intel.com>
References: <20220516034519.184876-8-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516034519.184876-8-imagedong@tencent.com>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/menglong8-dong-gmail-com/net-tcp-add-skb-drop-reasons-to-tcp-state-change/20220516-114934
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git d9713088158b23973266e07fdc85ff7d68791a8c
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20220516/202205161441.bl8a0hGC-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d93679590223760e685126e344dfddd7d7c08cc3
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review menglong8-dong-gmail-com/net-tcp-add-skb-drop-reasons-to-tcp-state-change/20220516-114934
        git checkout d93679590223760e685126e344dfddd7d7c08cc3
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/dccp/ipv4.c:584:5: error: conflicting types for 'dccp_v4_conn_request'; have 'int(struct sock *, struct sk_buff *, enum skb_drop_reason *)'
     584 | int dccp_v4_conn_request(struct sock *sk, struct sk_buff *skb,
         |     ^~~~~~~~~~~~~~~~~~~~
   In file included from net/dccp/ipv4.c:30:
   net/dccp/dccp.h:258:5: note: previous declaration of 'dccp_v4_conn_request' with type 'int(struct sock *, struct sk_buff *)'
     258 | int dccp_v4_conn_request(struct sock *sk, struct sk_buff *skb);
         |     ^~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:17,
                    from include/linux/uio.h:8,
                    from include/linux/socket.h:8,
                    from include/uapi/linux/in.h:24,
                    from include/linux/in.h:19,
                    from include/linux/dccp.h:6,
                    from net/dccp/ipv4.c:9:
   net/dccp/ipv4.c:660:19: error: conflicting types for 'dccp_v4_conn_request'; have 'int(struct sock *, struct sk_buff *, enum skb_drop_reason *)'
     660 | EXPORT_SYMBOL_GPL(dccp_v4_conn_request);
         |                   ^~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:98:28: note: in definition of macro '___EXPORT_SYMBOL'
      98 |         extern typeof(sym) sym;                                                 \
         |                            ^~~
   include/linux/export.h:160:41: note: in expansion of macro '__EXPORT_SYMBOL'
     160 | #define _EXPORT_SYMBOL(sym, sec)        __EXPORT_SYMBOL(sym, sec, "")
         |                                         ^~~~~~~~~~~~~~~
   include/linux/export.h:164:41: note: in expansion of macro '_EXPORT_SYMBOL'
     164 | #define EXPORT_SYMBOL_GPL(sym)          _EXPORT_SYMBOL(sym, "_gpl")
         |                                         ^~~~~~~~~~~~~~
   net/dccp/ipv4.c:660:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
     660 | EXPORT_SYMBOL_GPL(dccp_v4_conn_request);
         | ^~~~~~~~~~~~~~~~~
   In file included from net/dccp/ipv4.c:30:
   net/dccp/dccp.h:258:5: note: previous declaration of 'dccp_v4_conn_request' with type 'int(struct sock *, struct sk_buff *)'
     258 | int dccp_v4_conn_request(struct sock *sk, struct sk_buff *skb);
         |     ^~~~~~~~~~~~~~~~~~~~
--
   net/mptcp/subflow.c: In function 'subflow_v6_conn_request':
>> net/mptcp/subflow.c:568:24: error: too few arguments to function 'subflow_v4_conn_request'
     568 |                 return subflow_v4_conn_request(sk, skb);
         |                        ^~~~~~~~~~~~~~~~~~~~~~~
   net/mptcp/subflow.c:535:12: note: declared here
     535 | static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb,
         |            ^~~~~~~~~~~~~~~~~~~~~~~


vim +584 net/dccp/ipv4.c

   583	
 > 584	int dccp_v4_conn_request(struct sock *sk, struct sk_buff *skb,
   585				 enum skb_drop_reason *reason)
   586	{
   587		struct inet_request_sock *ireq;
   588		struct request_sock *req;
   589		struct dccp_request_sock *dreq;
   590		const __be32 service = dccp_hdr_request(skb)->dccph_req_service;
   591		struct dccp_skb_cb *dcb = DCCP_SKB_CB(skb);
   592	
   593		/* Never answer to DCCP_PKT_REQUESTs send to broadcast or multicast */
   594		if (skb_rtable(skb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
   595			return 0;	/* discard, don't send a reset here */
   596	
   597		if (dccp_bad_service_code(sk, service)) {
   598			dcb->dccpd_reset_code = DCCP_RESET_CODE_BAD_SERVICE_CODE;
   599			goto drop;
   600		}
   601		/*
   602		 * TW buckets are converted to open requests without
   603		 * limitations, they conserve resources and peer is
   604		 * evidently real one.
   605		 */
   606		dcb->dccpd_reset_code = DCCP_RESET_CODE_TOO_BUSY;
   607		if (inet_csk_reqsk_queue_is_full(sk))
   608			goto drop;
   609	
   610		if (sk_acceptq_is_full(sk))
   611			goto drop;
   612	
   613		req = inet_reqsk_alloc(&dccp_request_sock_ops, sk, true);
   614		if (req == NULL)
   615			goto drop;
   616	
   617		if (dccp_reqsk_init(req, dccp_sk(sk), skb))
   618			goto drop_and_free;
   619	
   620		dreq = dccp_rsk(req);
   621		if (dccp_parse_options(sk, dreq, skb))
   622			goto drop_and_free;
   623	
   624		if (security_inet_conn_request(sk, skb, req))
   625			goto drop_and_free;
   626	
   627		ireq = inet_rsk(req);
   628		sk_rcv_saddr_set(req_to_sk(req), ip_hdr(skb)->daddr);
   629		sk_daddr_set(req_to_sk(req), ip_hdr(skb)->saddr);
   630		ireq->ir_mark = inet_request_mark(sk, skb);
   631		ireq->ireq_family = AF_INET;
   632		ireq->ir_iif = sk->sk_bound_dev_if;
   633	
   634		/*
   635		 * Step 3: Process LISTEN state
   636		 *
   637		 * Set S.ISR, S.GSR, S.SWL, S.SWH from packet or Init Cookie
   638		 *
   639		 * Setting S.SWL/S.SWH to is deferred to dccp_create_openreq_child().
   640		 */
   641		dreq->dreq_isr	   = dcb->dccpd_seq;
   642		dreq->dreq_gsr	   = dreq->dreq_isr;
   643		dreq->dreq_iss	   = dccp_v4_init_sequence(skb);
   644		dreq->dreq_gss     = dreq->dreq_iss;
   645		dreq->dreq_service = service;
   646	
   647		if (dccp_v4_send_response(sk, req))
   648			goto drop_and_free;
   649	
   650		inet_csk_reqsk_queue_hash_add(sk, req, DCCP_TIMEOUT_INIT);
   651		reqsk_put(req);
   652		return 0;
   653	
   654	drop_and_free:
   655		reqsk_free(req);
   656	drop:
   657		__DCCP_INC_STATS(DCCP_MIB_ATTEMPTFAILS);
   658		return -1;
   659	}
   660	EXPORT_SYMBOL_GPL(dccp_v4_conn_request);
   661	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
