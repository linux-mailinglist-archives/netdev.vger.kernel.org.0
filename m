Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590495284C6
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 14:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240645AbiEPM4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 08:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242874AbiEPM4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 08:56:02 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B3A3B293;
        Mon, 16 May 2022 05:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652705731; x=1684241731;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ihR8n83hg4hum2AepYoqi5H6j9yxUnLz0RKLrq4qGbI=;
  b=EoSDlt/xhKbpw8u1PIZf0EWItiyNq7h8AvfH0Ov/ytLORB4THFKpOmEE
   6trYfnWBX/ybdtrRqHIxd61VoyFRiRn9oNWGBWbLcVhLXVy6xwgm/8XSJ
   a6G6Zl6MAFlpJJODRSmfI8IGPuuVqShFDes9tUroabWE78eCnEOXhWVY9
   PEebjIUq2KoKY9psxj2UWPDvDOpWpE/4qdJ0hV61u4rtPsV6Fuiu+PVcx
   LadsIz6p61Af+oqvtqiLWLsthmIK8EVUQelL5Q4Q9lLIdH9rTmpZWJIS+
   QszW4ML4Th+1ss9Rbm9N69pkeOqHosl17mt24DsKw89m9mtm3NxGXB/kY
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10348"; a="251335884"
X-IronPort-AV: E=Sophos;i="5.91,229,1647327600"; 
   d="scan'208";a="251335884"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 05:55:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,229,1647327600"; 
   d="scan'208";a="574002285"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by fmsmga007.fm.intel.com with ESMTP; 16 May 2022 05:55:27 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nqaFy-00001V-UL;
        Mon, 16 May 2022 12:55:26 +0000
Date:   Mon, 16 May 2022 20:54:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     menglong8.dong@gmail.com, edumazet@google.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, rostedt@goodmis.org,
        mingo@redhat.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        imagedong@tencent.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, dongli.zhang@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 7/9] net: tcp: add skb drop reasons to tcp
 connect requesting
Message-ID: <202205162057.owcP29LO-lkp@intel.com>
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
config: mips-mtx1_defconfig (https://download.01.org/0day-ci/archive/20220516/202205162057.owcP29LO-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 853fa8ee225edf2d0de94b0dcbd31bea916e825e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install mips cross compiling tool for clang build
        # apt-get install binutils-mips-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/d93679590223760e685126e344dfddd7d7c08cc3
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review menglong8-dong-gmail-com/net-tcp-add-skb-drop-reasons-to-tcp-state-change/20220516-114934
        git checkout d93679590223760e685126e344dfddd7d7c08cc3
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash net/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/dccp/ipv4.c:584:5: error: conflicting types for 'dccp_v4_conn_request'
   int dccp_v4_conn_request(struct sock *sk, struct sk_buff *skb,
       ^
   net/dccp/dccp.h:258:5: note: previous declaration is here
   int dccp_v4_conn_request(struct sock *sk, struct sk_buff *skb);
       ^
>> net/dccp/ipv4.c:921:21: error: incompatible function pointer types initializing 'int (*)(struct sock *, struct sk_buff *, enum skb_drop_reason *)' with an expression of type 'int (struct sock *, struct sk_buff *)' [-Werror,-Wincompatible-function-pointer-types]
           .conn_request      = dccp_v4_conn_request,
                                ^~~~~~~~~~~~~~~~~~~~
   2 errors generated.


vim +/dccp_v4_conn_request +584 net/dccp/ipv4.c

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
