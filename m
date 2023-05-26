Return-Path: <netdev+bounces-5556-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9257712189
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:52:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 203D0281699
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 07:52:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 498FAA938;
	Fri, 26 May 2023 07:52:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AC279EE
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 07:52:28 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523CF13A
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 00:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685087546; x=1716623546;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MGpah+k1pIZ0tPXYLazG17U/V003vCrY3k0rH8jwHB8=;
  b=f+Yjz9XLlJwT56kEr4o4aeHWdZBj6CGpZJR+R2XXYyeRzWHZUXSqUOS5
   wEdRs9PiJB3uBOvBEXeeSFt2Mcr4tD5RDC6HFJrG8t2q2aB4yNqJm/6k6
   nJNFnFyDRofK7yDZ1i+vHcLTdaVYLKRalgHzo2O2CjyDTkZST395DwPTa
   B6Gyiu5DaMKJbbdjFTBGcm8mvQ6syZ3UMZgixU9R3LuxZKA5mog2iN97p
   n7h5PWkIYVdribdsCo3TAaofOQBWeani35yMq1vE0zEUvAd0K9ttShDxb
   jKjyniPf6fmL5g67qvxtJyqJXqPK2+/lljTpXG0WpAA0CkWEzc9KXe1xC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="352987211"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="352987211"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 00:52:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="829419370"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="829419370"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 26 May 2023 00:52:23 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q2SFK-000JAZ-2t;
	Fri, 26 May 2023 07:52:22 +0000
Date: Fri, 26 May 2023 15:52:13 +0800
From: kernel test robot <lkp@intel.com>
To: Max Tottenham <mtottenh@akamai.com>, netdev@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Amir Vadai <amir@vadai.me>, Josh Hunt <johunt@akamai.com>,
	Max Tottenham <mtottenh@akamai.com>
Subject: Re: [PATCH] net/sched: act_pedit: Parse L3 Header for L4 offset
Message-ID: <202305261541.N165u9TZ-lkp@intel.com>
References: <20230525164741.4188115-1-mtottenh@akamai.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525164741.4188115-1-mtottenh@akamai.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Max,

kernel test robot noticed the following build errors:

[auto build test ERROR on net/main]
[also build test ERROR on net-next/main linus/master v6.4-rc3 next-20230525]
[cannot apply to horms-ipvs/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Max-Tottenham/net-sched-act_pedit-Parse-L3-Header-for-L4-offset/20230526-020135
base:   net/main
patch link:    https://lore.kernel.org/r/20230525164741.4188115-1-mtottenh%40akamai.com
patch subject: [PATCH] net/sched: act_pedit: Parse L3 Header for L4 offset
config: mips-allyesconfig (https://download.01.org/0day-ci/archive/20230526/202305261541.N165u9TZ-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/dc60ecbe9b4432221ba2109d4ca1956f47d5c5d6
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Max-Tottenham/net-sched-act_pedit-Parse-L3-Header-for-L4-offset/20230526-020135
        git checkout dc60ecbe9b4432221ba2109d4ca1956f47d5c5d6
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 ~/bin/make.cross W=1 O=build_dir ARCH=mips olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 ~/bin/make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202305261541.N165u9TZ-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/sched/act_pedit.c: In function 'tcf_pedit_act':
>> net/sched/act_pedit.c:428:17: error: 'rc' undeclared (first use in this function); did you mean 'rq'?
     428 |                 rc = pedit_skb_hdr_offset(skb, htype, &hoffset);
         |                 ^~
         |                 rq
   net/sched/act_pedit.c:428:17: note: each undeclared identifier is reported only once for each function it appears in


vim +428 net/sched/act_pedit.c

   386	
   387	TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
   388					    const struct tc_action *a,
   389					    struct tcf_result *res)
   390	{
   391		enum pedit_header_type htype = TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK;
   392		enum pedit_cmd cmd = TCA_PEDIT_KEY_EX_CMD_SET;
   393		struct tcf_pedit *p = to_pedit(a);
   394		struct tcf_pedit_key_ex *tkey_ex;
   395		struct tcf_pedit_parms *parms;
   396		struct tc_pedit_key *tkey;
   397		u32 max_offset;
   398		int i;
   399	
   400		parms = rcu_dereference_bh(p->parms);
   401	
   402		max_offset = (skb_transport_header_was_set(skb) ?
   403			      skb_transport_offset(skb) :
   404			      skb_network_offset(skb)) +
   405			     parms->tcfp_off_max_hint;
   406		if (skb_ensure_writable(skb, min(skb->len, max_offset)))
   407			goto done;
   408	
   409		tcf_lastuse_update(&p->tcf_tm);
   410		tcf_action_update_bstats(&p->common, skb);
   411	
   412		tkey = parms->tcfp_keys;
   413		tkey_ex = parms->tcfp_keys_ex;
   414	
   415		for (i = parms->tcfp_nkeys; i > 0; i--, tkey++) {
   416			int offset = tkey->off;
   417			int hoffset = 0;
   418			u32 *ptr, hdata;
   419			u32 val;
   420	
   421			if (tkey_ex) {
   422				htype = tkey_ex->htype;
   423				cmd = tkey_ex->cmd;
   424	
   425				tkey_ex++;
   426			}
   427	
 > 428			rc = pedit_skb_hdr_offset(skb, htype, &hoffset);
   429			if (rc) {
   430				pr_info_ratelimited("tc action pedit unable to extract header offset for header type (0x%x)\n", htype);
   431				goto bad;
   432			}
   433	
   434			if (tkey->offmask) {
   435				u8 *d, _d;
   436	
   437				if (!offset_valid(skb, hoffset + tkey->at)) {
   438					pr_info_ratelimited("tc action pedit 'at' offset %d out of bounds\n",
   439							    hoffset + tkey->at);
   440					goto bad;
   441				}
   442				d = skb_header_pointer(skb, hoffset + tkey->at,
   443						       sizeof(_d), &_d);
   444				if (!d)
   445					goto bad;
   446	
   447				offset += (*d & tkey->offmask) >> tkey->shift;
   448				if (offset % 4) {
   449					pr_info_ratelimited("tc action pedit offset must be on 32 bit boundaries\n");
   450					goto bad;
   451				}
   452			}
   453	
   454			if (!offset_valid(skb, hoffset + offset)) {
   455				pr_info_ratelimited("tc action pedit offset %d out of bounds\n", hoffset + offset);
   456				goto bad;
   457			}
   458	
   459			ptr = skb_header_pointer(skb, hoffset + offset,
   460						 sizeof(hdata), &hdata);
   461			if (!ptr)
   462				goto bad;
   463			/* just do it, baby */
   464			switch (cmd) {
   465			case TCA_PEDIT_KEY_EX_CMD_SET:
   466				val = tkey->val;
   467				break;
   468			case TCA_PEDIT_KEY_EX_CMD_ADD:
   469				val = (*ptr + tkey->val) & ~tkey->mask;
   470				break;
   471			default:
   472				pr_info_ratelimited("tc action pedit bad command (%d)\n", cmd);
   473				goto bad;
   474			}
   475	
   476			*ptr = ((*ptr & tkey->mask) ^ val);
   477			if (ptr == &hdata)
   478				skb_store_bits(skb, hoffset + offset, ptr, 4);
   479		}
   480	
   481		goto done;
   482	
   483	bad:
   484		tcf_action_inc_overlimit_qstats(&p->common);
   485	done:
   486		return p->tcf_action;
   487	}
   488	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

