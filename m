Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279196D565D
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 04:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbjDDCBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 22:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjDDCBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 22:01:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD301725;
        Mon,  3 Apr 2023 19:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680573706; x=1712109706;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hg/2aixy2WZXbXG/sWuB7ZCAhNF9nA+BgZkN81OmlaQ=;
  b=kT/yFkki+TngKiPa1ySH60et6SqBlmqM2hcvuZWTHQF5fIlRgsyJQxAH
   kyqmmK+UJoAgn8Xnn+RXc/R2Kdgooapb/OQhf42GifTpgulLxj01KA/YN
   MMvRaZsla8cLhz3Wvo17LI6B/TWh6kl4ExE8m38EqnQZw4u58bf3zUPTJ
   hmSaTct02Fg/7wb4cKYOH0h4HHJbC3SA46u1iMfwZI2/88sE0VU442hXn
   +0WcFcxUiUhJcWPgREk+RfYItQkEQAObfQyBZ7MYKBu3fLEHROtR1YmpM
   LOtSyWbQgqpJ6XC/bMj4ZvlErwVb5eJLsQuzp9I8M/4Z8M9ky8o88SuEZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="343767229"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="343767229"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 19:01:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="829792577"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="829792577"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 03 Apr 2023 19:00:52 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pjVye-000P1a-0J;
        Tue, 04 Apr 2023 02:00:52 +0000
Date:   Tue, 4 Apr 2023 10:00:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <error27@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>
Subject: Re: [PATCH v5 09/21] net/tcp: Add TCP-AO sign to twsk
Message-ID: <202304040904.0iYIgRHd-lkp@intel.com>
References: <20230403213420.1576559-10-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403213420.1576559-10-dima@arista.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dmitry,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 7e364e56293bb98cae1b55fd835f5991c4e96e7d]

url:    https://github.com/intel-lab-lkp/linux/commits/Dmitry-Safonov/net-tcp-Prepare-tcp_md5sig_pool-for-TCP-AO/20230404-054020
base:   7e364e56293bb98cae1b55fd835f5991c4e96e7d
patch link:    https://lore.kernel.org/r/20230403213420.1576559-10-dima%40arista.com
patch subject: [PATCH v5 09/21] net/tcp: Add TCP-AO sign to twsk
config: riscv-allmodconfig (https://download.01.org/0day-ci/archive/20230404/202304040904.0iYIgRHd-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/6dd2eb18d51db7f4e1bfac2de38f7a5c2363ef0e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dmitry-Safonov/net-tcp-Prepare-tcp_md5sig_pool-for-TCP-AO/20230404-054020
        git checkout 6dd2eb18d51db7f4e1bfac2de38f7a5c2363ef0e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash net/ipv6/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304040904.0iYIgRHd-lkp@intel.com/

All warnings (new ones prefixed by >>):

   net/ipv6/tcp_ipv6.c: In function 'tcp_v6_timewait_ack':
>> net/ipv6/tcp_ipv6.c:1214:36: warning: variable 'rnext_key' set but not used [-Wunused-but-set-variable]
    1214 |                 struct tcp_ao_key *rnext_key;
         |                                    ^~~~~~~~~


vim +/rnext_key +1214 net/ipv6/tcp_ipv6.c

  1190	
  1191	static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
  1192	{
  1193		struct inet_timewait_sock *tw = inet_twsk(sk);
  1194		struct tcp_timewait_sock *tcptw = tcp_twsk(sk);
  1195		struct tcp_ao_key *ao_key = NULL;
  1196		u8 *traffic_key = NULL;
  1197		u8 rcv_next = 0;
  1198		u32 ao_sne = 0;
  1199	#ifdef CONFIG_TCP_AO
  1200		struct tcp_ao_info *ao_info;
  1201	
  1202		/* FIXME: the segment to-be-acked is not verified yet */
  1203		ao_info = rcu_dereference(tcptw->ao_info);
  1204		if (ao_info) {
  1205			const struct tcp_ao_hdr *aoh;
  1206	
  1207			/* Invalid TCP option size or twice included auth */
  1208			if (tcp_parse_auth_options(tcp_hdr(skb), NULL, &aoh))
  1209				goto out;
  1210			if (aoh)
  1211				ao_key = tcp_ao_established_key(ao_info, aoh->rnext_keyid, -1);
  1212		}
  1213		if (ao_key) {
> 1214			struct tcp_ao_key *rnext_key;
  1215	
  1216			traffic_key = snd_other_key(ao_key);
  1217			/* rcv_next switches to our rcv_next */
  1218			rnext_key = READ_ONCE(ao_info->rnext_key);
  1219			rcv_next = ao_info->rnext_key->rcvid;
  1220			ao_sne = tcp_ao_compute_sne(ao_info->snd_sne,
  1221						    ao_info->snd_sne_seq,
  1222						    tcptw->tw_snd_nxt);
  1223		}
  1224	#endif
  1225	
  1226		tcp_v6_send_ack(sk, skb, tcptw->tw_snd_nxt, tcptw->tw_rcv_nxt,
  1227				tcptw->tw_rcv_wnd >> tw->tw_rcv_wscale,
  1228				tcp_time_stamp_raw() + tcptw->tw_ts_offset,
  1229				tcptw->tw_ts_recent, tw->tw_bound_dev_if, tcp_twsk_md5_key(tcptw),
  1230				tw->tw_tclass, cpu_to_be32(tw->tw_flowlabel), tw->tw_priority,
  1231				tw->tw_txhash, ao_key, traffic_key, rcv_next, ao_sne);
  1232	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
