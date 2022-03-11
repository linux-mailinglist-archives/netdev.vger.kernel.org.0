Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7CF4D5877
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 03:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345815AbiCKC4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 21:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243446AbiCKC4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 21:56:21 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EEF1A6FAB;
        Thu, 10 Mar 2022 18:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646967319; x=1678503319;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uemGpo3r1Ljzh7J5aQez3PPGjZxZAPOCkt2/GKim9c8=;
  b=ccJ5gZgQZ3Q/ovJ+yyYeK8M11XsA8fow2xX1eX5U2fIZOrz7T4CpUJYi
   7UqWd09/u5cNo1Z02lhz1LTSf39ItRodQp5zIZE26mvUgHxSgwzn2clj9
   A5vabYAD8fkhyZiOpS2hI+WOk6Z4xy4wpkxt5fj1txXDeOa1f5HpRQAea
   dvVJIYWUtYY18Rptz3VdSmEf03lrjAPPQawMgmxb2lAZT8ezBPsh/PZE8
   AaOLBAQ+ofDT3tlLploJNfoh0dDfcucwZDuwmnNd7W0brzJrUpUcItVv3
   E3gzniJJDms0nJMPcFyfAEQ9/GR654qHcYfNMrcDYXBNeDWo+unULPS2O
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="253048095"
X-IronPort-AV: E=Sophos;i="5.90,172,1643702400"; 
   d="scan'208";a="253048095"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 18:55:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,172,1643702400"; 
   d="scan'208";a="688937088"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 10 Mar 2022 18:55:16 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nSVQy-0005k9-1G; Fri, 11 Mar 2022 02:55:16 +0000
Date:   Fri, 11 Mar 2022 10:55:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jiyong Park <jiyong@google.com>, sgarzare@redhat.com,
        stefanha@redhat.com, mst@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     kbuild-all@lists.01.org, adelva@google.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiyong Park <jiyong@google.com>
Subject: Re: [PATCH 1/2] vsock: each transport cycles only on its own sockets
Message-ID: <202203111023.SPYFGn7W-lkp@intel.com>
References: <20220310125425.4193879-2-jiyong@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310125425.4193879-2-jiyong@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiyong,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on 3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b]

url:    https://github.com/0day-ci/linux/commits/Jiyong-Park/vsock-cycle-only-on-its-own-socket/20220310-205638
base:   3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b
config: x86_64-rhel-8.3 (https://download.01.org/0day-ci/archive/20220311/202203111023.SPYFGn7W-lkp@intel.com/config)
compiler: gcc-9 (Ubuntu 9.4.0-1ubuntu1~20.04) 9.4.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/6219060e1d706d7055fb0829b3bf23c5ae84790e
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jiyong-Park/vsock-cycle-only-on-its-own-socket/20220310-205638
        git checkout 6219060e1d706d7055fb0829b3bf23c5ae84790e
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/vmw_vsock/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   net/vmw_vsock/vmci_transport.c: In function 'vmci_transport_handle_detach':
>> net/vmw_vsock/vmci_transport.c:808:25: error: 'vmci_transport' undeclared (first use in this function)
     808 |  if (vsk->transport != &vmci_transport)
         |                         ^~~~~~~~~~~~~~
   net/vmw_vsock/vmci_transport.c:808:25: note: each undeclared identifier is reported only once for each function it appears in


vim +/vmci_transport +808 net/vmw_vsock/vmci_transport.c

   800	
   801	static void vmci_transport_handle_detach(struct sock *sk)
   802	{
   803		struct vsock_sock *vsk;
   804	
   805		vsk = vsock_sk(sk);
   806	
   807		/* Only handle our own sockets */
 > 808		if (vsk->transport != &vmci_transport)
   809			return;
   810	
   811		if (!vmci_handle_is_invalid(vmci_trans(vsk)->qp_handle)) {
   812			sock_set_flag(sk, SOCK_DONE);
   813	
   814			/* On a detach the peer will not be sending or receiving
   815			 * anymore.
   816			 */
   817			vsk->peer_shutdown = SHUTDOWN_MASK;
   818	
   819			/* We should not be sending anymore since the peer won't be
   820			 * there to receive, but we can still receive if there is data
   821			 * left in our consume queue. If the local endpoint is a host,
   822			 * we can't call vsock_stream_has_data, since that may block,
   823			 * but a host endpoint can't read data once the VM has
   824			 * detached, so there is no available data in that case.
   825			 */
   826			if (vsk->local_addr.svm_cid == VMADDR_CID_HOST ||
   827			    vsock_stream_has_data(vsk) <= 0) {
   828				if (sk->sk_state == TCP_SYN_SENT) {
   829					/* The peer may detach from a queue pair while
   830					 * we are still in the connecting state, i.e.,
   831					 * if the peer VM is killed after attaching to
   832					 * a queue pair, but before we complete the
   833					 * handshake. In that case, we treat the detach
   834					 * event like a reset.
   835					 */
   836	
   837					sk->sk_state = TCP_CLOSE;
   838					sk->sk_err = ECONNRESET;
   839					sk_error_report(sk);
   840					return;
   841				}
   842				sk->sk_state = TCP_CLOSE;
   843			}
   844			sk->sk_state_change(sk);
   845		}
   846	}
   847	

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
