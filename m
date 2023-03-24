Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922EB6C8333
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjCXRTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjCXRTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:19:20 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8FC7AA5
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 10:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679678347; x=1711214347;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hA4koLHftrpeOq5mL+OCKc3pGVwHrPtB+eq+RJU3Q7o=;
  b=iq8ktFH7HJkaXJecatxwENM4yixJZPKkYLY6IW4yti36K9mjTb7/M/6U
   YW9kamCZVsXB3X9O9FmDd8iUlIKS9qY1513J9xc9t03PnmaYF7KMBlNoK
   GckLgN3GeY6/93y7CQmeg+tQM2wTTmSK+xPSeBpkftPFU3pQn+5Ryvl71
   zDHeOM9bQaoyMFk/VOKUJMHEw4CksHyBNVTfF5+bs9MfzhYYmeDkTdeAd
   SQU+4VsXumFrZQKSGgHP+C12Zh53dYRgFRi4oMTRnmw/CSgoVDfXeMdKy
   GK3dD9I7LROqOcJaiE8A+UShitGRWaUUcU/TQXlHylg1cgDiXWWCoqWMo
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="402423921"
X-IronPort-AV: E=Sophos;i="5.98,288,1673942400"; 
   d="scan'208";a="402423921"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2023 10:18:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="806739969"
X-IronPort-AV: E=Sophos;i="5.98,288,1673942400"; 
   d="scan'208";a="806739969"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 24 Mar 2023 10:17:26 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pfl2b-000FVk-2d;
        Fri, 24 Mar 2023 17:17:25 +0000
Date:   Sat, 25 Mar 2023 01:16:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     edward.cree@amd.com, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, michal.swiatkowski@linux.intel.com
Subject: Re: [PATCH net-next v2 5/6] sfc: add code to register and unregister
 encap matches
Message-ID: <202303250154.HsaEs3hh-lkp@intel.com>
References: <57c4e599df3fff7bf678c1813445bd6016c6db79.1679603051.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57c4e599df3fff7bf678c1813445bd6016c6db79.1679603051.git.ecree.xilinx@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/edward-cree-amd-com/sfc-document-TC-to-EF100-MAE-action-translation-concepts/20230324-044845
patch link:    https://lore.kernel.org/r/57c4e599df3fff7bf678c1813445bd6016c6db79.1679603051.git.ecree.xilinx%40gmail.com
patch subject: [PATCH net-next v2 5/6] sfc: add code to register and unregister encap matches
config: arm-randconfig-r025-20230322 (https://download.01.org/0day-ci/archive/20230325/202303250154.HsaEs3hh-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 67409911353323ca5edf2049ef0df54132fa1ca7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/intel-lab-lkp/linux/commit/48db650a79ec4f4091360a2c1363d1cac6235707
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review edward-cree-amd-com/sfc-document-TC-to-EF100-MAE-action-translation-concepts/20230324-044845
        git checkout 48db650a79ec4f4091360a2c1363d1cac6235707
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/net/ethernet/sfc/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303250154.HsaEs3hh-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/sfc/tc.c:414:43: warning: variable 'ipv6' is uninitialized when used here [-Wuninitialized]
           rc = efx_mae_check_encap_match_caps(efx, ipv6, extack);
                                                    ^~~~
   drivers/net/ethernet/sfc/tc.c:356:11: note: initialize the variable 'ipv6' to silence this warning
           bool ipv6;
                    ^
                     = 0
   1 warning generated.


vim +/ipv6 +414 drivers/net/ethernet/sfc/tc.c

   348	
   349	__always_unused
   350	static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
   351						    struct efx_tc_match *match,
   352						    enum efx_encap_type type,
   353						    struct netlink_ext_ack *extack)
   354	{
   355		struct efx_tc_encap_match *encap, *old;
   356		bool ipv6;
   357		int rc;
   358	
   359		/* We require that the socket-defining fields (IP addrs and UDP dest
   360		 * port) are present and exact-match.  Other fields are currently not
   361		 * allowed.  This meets what OVS will ask for, and means that we don't
   362		 * need to handle difficult checks for overlapping matches as could
   363		 * come up if we allowed masks or varying sets of match fields.
   364		 */
   365		if (match->mask.enc_dst_ip | match->mask.enc_src_ip) {
   366			if (!IS_ALL_ONES(match->mask.enc_dst_ip)) {
   367				NL_SET_ERR_MSG_MOD(extack,
   368						   "Egress encap match is not exact on dst IP address");
   369				return -EOPNOTSUPP;
   370			}
   371			if (!IS_ALL_ONES(match->mask.enc_src_ip)) {
   372				NL_SET_ERR_MSG_MOD(extack,
   373						   "Egress encap match is not exact on src IP address");
   374				return -EOPNOTSUPP;
   375			}
   376	#ifdef CONFIG_IPV6
   377			if (!ipv6_addr_any(&match->mask.enc_dst_ip6) ||
   378			    !ipv6_addr_any(&match->mask.enc_src_ip6)) {
   379				NL_SET_ERR_MSG_MOD(extack,
   380						   "Egress encap match on both IPv4 and IPv6, don't understand");
   381				return -EOPNOTSUPP;
   382			}
   383		} else {
   384			ipv6 = true;
   385			if (!efx_ipv6_addr_all_ones(&match->mask.enc_dst_ip6)) {
   386				NL_SET_ERR_MSG_MOD(extack,
   387						   "Egress encap match is not exact on dst IP address");
   388				return -EOPNOTSUPP;
   389			}
   390			if (!efx_ipv6_addr_all_ones(&match->mask.enc_src_ip6)) {
   391				NL_SET_ERR_MSG_MOD(extack,
   392						   "Egress encap match is not exact on src IP address");
   393				return -EOPNOTSUPP;
   394			}
   395	#endif
   396		}
   397		if (!IS_ALL_ONES(match->mask.enc_dport)) {
   398			NL_SET_ERR_MSG_MOD(extack, "Egress encap match is not exact on dst UDP port");
   399			return -EOPNOTSUPP;
   400		}
   401		if (match->mask.enc_sport) {
   402			NL_SET_ERR_MSG_MOD(extack, "Egress encap match on src UDP port not supported");
   403			return -EOPNOTSUPP;
   404		}
   405		if (match->mask.enc_ip_tos) {
   406			NL_SET_ERR_MSG_MOD(extack, "Egress encap match on IP ToS not supported");
   407			return -EOPNOTSUPP;
   408		}
   409		if (match->mask.enc_ip_ttl) {
   410			NL_SET_ERR_MSG_MOD(extack, "Egress encap match on IP TTL not supported");
   411			return -EOPNOTSUPP;
   412		}
   413	
 > 414		rc = efx_mae_check_encap_match_caps(efx, ipv6, extack);
   415		if (rc) {
   416			NL_SET_ERR_MSG_FMT_MOD(extack, "MAE hw reports no support for IPv%d encap matches",
   417					       ipv6 ? 6 : 4);
   418			return -EOPNOTSUPP;
   419		}
   420	
   421		encap = kzalloc(sizeof(*encap), GFP_USER);
   422		if (!encap)
   423			return -ENOMEM;
   424		encap->src_ip = match->value.enc_src_ip;
   425		encap->dst_ip = match->value.enc_dst_ip;
   426	#ifdef CONFIG_IPV6
   427		encap->src_ip6 = match->value.enc_src_ip6;
   428		encap->dst_ip6 = match->value.enc_dst_ip6;
   429	#endif
   430		encap->udp_dport = match->value.enc_dport;
   431		encap->tun_type = type;
   432		old = rhashtable_lookup_get_insert_fast(&efx->tc->encap_match_ht,
   433							&encap->linkage,
   434							efx_tc_encap_match_ht_params);
   435		if (old) {
   436			/* don't need our new entry */
   437			kfree(encap);
   438			if (old->tun_type != type) {
   439				NL_SET_ERR_MSG_FMT_MOD(extack,
   440						       "Egress encap match with conflicting tun_type %u != %u",
   441						       old->tun_type, type);
   442				return -EEXIST;
   443			}
   444			if (!refcount_inc_not_zero(&old->ref))
   445				return -EAGAIN;
   446			/* existing entry found */
   447			encap = old;
   448		} else {
   449			rc = efx_mae_register_encap_match(efx, encap);
   450			if (rc) {
   451				NL_SET_ERR_MSG_MOD(extack, "Failed to record egress encap match in HW");
   452				goto fail;
   453			}
   454			refcount_set(&encap->ref, 1);
   455		}
   456		match->encap = encap;
   457		return 0;
   458	fail:
   459		rhashtable_remove_fast(&efx->tc->encap_match_ht, &encap->linkage,
   460				       efx_tc_encap_match_ht_params);
   461		kfree(encap);
   462		return rc;
   463	}
   464	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
