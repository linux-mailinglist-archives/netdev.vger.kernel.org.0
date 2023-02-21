Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9588A69E565
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 18:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbjBURBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 12:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbjBURBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 12:01:17 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670DA2DE4C;
        Tue, 21 Feb 2023 09:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676998858; x=1708534858;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/uDZVbdY6N/F4bBf82Z5z+zEup9dGw6Lu0/VdW3Y+ds=;
  b=AWQVHpHWrfBsG5qBrOkWHKB40k02T2lC69S7e9YK83pZcbCy5taHec0z
   BhcFM/jkOJlQ1YCtm3LEW7rlPOWnBisrokzBlmE3DdFnuujUGQl4VNj/9
   R3WPipqoU5ssRmwA0g5Uzs06liNj4fD0LSfWVLaWM3nqsTwngat79s+PV
   S6QBick5f4p5I/KbMeK9mfdeYRmbCcqYVL5f/3zQL/Q9rToZfZoTJY2w9
   DIkgMwaMUkJrdEBkBoPDSH5Ll/pHs42i/aA8R27VzFqQmSC7x7LFaKs7W
   /s2y6Ty8MwiivClrfCpd6FL99jU51m5VeJpALjLdM6uGXaftMTqx8UK1x
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="312315474"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="312315474"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 09:00:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="917251899"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="917251899"
Received: from lkp-server01.sh.intel.com (HELO eac18b5d7d93) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 21 Feb 2023 09:00:29 -0800
Received: from kbuild by eac18b5d7d93 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pUW0C-00003Z-1x;
        Tue, 21 Feb 2023 17:00:28 +0000
Date:   Wed, 22 Feb 2023 01:00:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hangyu Hua <hbh25y@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ian.mcdonald@jandi.co.nz
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: Re: [PATCH] net: dccp: delete redundant ackvec record in
 dccp_insert_options()
Message-ID: <202302220054.Y70E8KTB-lkp@intel.com>
References: <20230221092206.39741-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230221092206.39741-1-hbh25y@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hangyu,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]
[also build test ERROR on net/master horms-ipvs/master linus/master v6.2 next-20230221]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Hangyu-Hua/net-dccp-delete-redundant-ackvec-record-in-dccp_insert_options/20230221-172448
patch link:    https://lore.kernel.org/r/20230221092206.39741-1-hbh25y%40gmail.com
patch subject: [PATCH] net: dccp: delete redundant ackvec record in dccp_insert_options()
config: i386-randconfig-a013-20230220 (https://download.01.org/0day-ci/archive/20230222/202302220054.Y70E8KTB-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/ea44b55ba82bbe3f35b51212bf839f507a30b70b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Hangyu-Hua/net-dccp-delete-redundant-ackvec-record-in-dccp_insert_options/20230221-172448
        git checkout ea44b55ba82bbe3f35b51212bf839f507a30b70b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302220054.Y70E8KTB-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/dccp/options.c:594:8: error: implicit declaration of function 'dccp_ackvec_lookup' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
           avr = dccp_ackvec_lookup(&av->av_records, DCCP_SKB_CB(skb)->dccpd_seq);
                 ^
   net/dccp/options.c:594:6: warning: incompatible integer to pointer conversion assigning to 'struct dccp_ackvec_record *' from 'int' [-Wint-conversion]
           avr = dccp_ackvec_lookup(&av->av_records, DCCP_SKB_CB(skb)->dccpd_seq);
               ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> net/dccp/options.c:596:18: error: use of undeclared identifier 'dccp_ackvec_record_slab'; did you mean 'dccp_ackvec_clear_state'?
           kmem_cache_free(dccp_ackvec_record_slab, avr);
                           ^~~~~~~~~~~~~~~~~~~~~~~
                           dccp_ackvec_clear_state
   net/dccp/ackvec.h:110:6: note: 'dccp_ackvec_clear_state' declared here
   void dccp_ackvec_clear_state(struct dccp_ackvec *av, const u64 ackno);
        ^
   1 warning and 2 errors generated.


vim +/dccp_ackvec_lookup +594 net/dccp/options.c

   548	
   549	int dccp_insert_options(struct sock *sk, struct sk_buff *skb)
   550	{
   551		struct dccp_sock *dp = dccp_sk(sk);
   552		struct dccp_ackvec *av = dp->dccps_hc_rx_ackvec;
   553		struct dccp_ackvec_record *avr;
   554	
   555		DCCP_SKB_CB(skb)->dccpd_opt_len = 0;
   556	
   557		if (dp->dccps_send_ndp_count && dccp_insert_option_ndp(sk, skb))
   558			return -1;
   559	
   560		if (DCCP_SKB_CB(skb)->dccpd_type != DCCP_PKT_DATA) {
   561	
   562			/* Feature Negotiation */
   563			if (dccp_feat_insert_opts(dp, NULL, skb))
   564				return -1;
   565	
   566			if (DCCP_SKB_CB(skb)->dccpd_type == DCCP_PKT_REQUEST) {
   567				/*
   568				 * Obtain RTT sample from Request/Response exchange.
   569				 * This is currently used for TFRC initialisation.
   570				 */
   571				if (dccp_insert_option_timestamp(skb))
   572					return -1;
   573	
   574			} else if (dccp_ackvec_pending(sk) &&
   575				   dccp_insert_option_ackvec(sk, skb)) {
   576					return -1;
   577			}
   578		}
   579	
   580		if (dp->dccps_hc_rx_insert_options) {
   581			if (ccid_hc_rx_insert_options(dp->dccps_hc_rx_ccid, sk, skb))
   582				goto delete_ackvec;
   583			dp->dccps_hc_rx_insert_options = 0;
   584		}
   585	
   586		if (dp->dccps_timestamp_echo != 0 &&
   587		    dccp_insert_option_timestamp_echo(dp, NULL, skb))
   588			goto delete_ackvec;
   589	
   590		dccp_insert_option_padding(skb);
   591		return 0;
   592	
   593	delete_ackvec:
 > 594		avr = dccp_ackvec_lookup(&av->av_records, DCCP_SKB_CB(skb)->dccpd_seq);
   595		list_del(&avr->avr_node);
 > 596		kmem_cache_free(dccp_ackvec_record_slab, avr);
   597		return -1;
   598	}
   599	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
