Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E387A5288EA
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 17:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245338AbiEPPb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 11:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245393AbiEPPb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 11:31:56 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2341AD98;
        Mon, 16 May 2022 08:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652715114; x=1684251114;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cAyhnzlJ4M6VnaKsxFV7pBKPLeBQuvPO63ShLdUWKOI=;
  b=hT0syYqwRoCI7fDMHSKroLC4shOH8jN07ZhB9ImhJhskaQe9iSY7+IPn
   NeZMlgzhPVOLOEwLxXZheBpPLQirv8daCKrPL92HbNfQta0YnExtxngIx
   QGWXz1irYoe7BisL/efvk3QBKp5l2nCLnJmB5FiE7NLCVRxKkWfsanCws
   nF+LsED+wvFMZUBFmpziYccqSrGwmn2QJI2xDyroR4Wdn4EDCO2v3rrFm
   rAH9XtG6FbmDcWxoOScxU0bFpLTZ/xMTiUD6mULB43bN6UiUELfCWYZJJ
   4jFXZVGPm/i4RJkvBqXfZBtK2Te3GvXUOb5EciG4l/tcpKWPEq3BbAMc2
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="270814408"
X-IronPort-AV: E=Sophos;i="5.91,230,1647327600"; 
   d="scan'208";a="270814408"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 08:31:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,230,1647327600"; 
   d="scan'208";a="596570183"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 16 May 2022 08:31:34 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nqch3-00008d-Su;
        Mon, 16 May 2022 15:31:33 +0000
Date:   Mon, 16 May 2022 23:30:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     menglong8.dong@gmail.com, edumazet@google.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, rostedt@goodmis.org,
        mingo@redhat.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        imagedong@tencent.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, dongli.zhang@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 8/9] net: tcp: add skb drop reasons to tcp tw
 code path
Message-ID: <202205162352.OThc1nAw-lkp@intel.com>
References: <20220516034519.184876-9-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516034519.184876-9-imagedong@tencent.com>
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

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/menglong8-dong-gmail-com/net-tcp-add-skb-drop-reasons-to-tcp-state-change/20220516-114934
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git d9713088158b23973266e07fdc85ff7d68791a8c
config: mips-mtx1_defconfig (https://download.01.org/0day-ci/archive/20220516/202205162352.OThc1nAw-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 853fa8ee225edf2d0de94b0dcbd31bea916e825e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install mips cross compiling tool for clang build
        # apt-get install binutils-mips-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/6a657e07d2943a7df8277769f29624ea28599e09
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review menglong8-dong-gmail-com/net-tcp-add-skb-drop-reasons-to-tcp-state-change/20220516-114934
        git checkout 6a657e07d2943a7df8277769f29624ea28599e09
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash net/ipv4/ net/ipv6/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/ipv4/tcp_ipv4.c:2161:7: warning: variable 'ret' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
                   if (drop_reason)
                       ^~~~~~~~~~~
   net/ipv4/tcp_ipv4.c:2092:9: note: uninitialized use occurs here
           return ret;
                  ^~~
   net/ipv4/tcp_ipv4.c:2161:3: note: remove the 'if' if its condition is always true
                   if (drop_reason)
                   ^~~~~~~~~~~~~~~~
   net/ipv4/tcp_ipv4.c:1926:9: note: initialize the variable 'ret' to silence this warning
           int ret;
                  ^
                   = 0
   1 warning generated.
--
>> net/ipv6/tcp_ipv6.c:1825:7: warning: variable 'ret' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
                   if (drop_reason)
                       ^~~~~~~~~~~
   net/ipv6/tcp_ipv6.c:1753:9: note: uninitialized use occurs here
           return ret ? -1 : 0;
                  ^~~
   net/ipv6/tcp_ipv6.c:1825:3: note: remove the 'if' if its condition is always true
                   if (drop_reason)
                   ^~~~~~~~~~~~~~~~
   net/ipv6/tcp_ipv6.c:1594:9: note: initialize the variable 'ret' to silence this warning
           int ret;
                  ^
                   = 0
   1 warning generated.


vim +2161 net/ipv4/tcp_ipv4.c

  1911	
  1912	/*
  1913	 *	From tcp_input.c
  1914	 */
  1915	
  1916	int tcp_v4_rcv(struct sk_buff *skb)
  1917	{
  1918		struct net *net = dev_net(skb->dev);
  1919		enum skb_drop_reason drop_reason;
  1920		int sdif = inet_sdif(skb);
  1921		int dif = inet_iif(skb);
  1922		const struct iphdr *iph;
  1923		const struct tcphdr *th;
  1924		bool refcounted;
  1925		struct sock *sk;
  1926		int ret;
  1927	
  1928		drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
  1929		if (skb->pkt_type != PACKET_HOST)
  1930			goto discard_it;
  1931	
  1932		/* Count it even if it's bad */
  1933		__TCP_INC_STATS(net, TCP_MIB_INSEGS);
  1934	
  1935		if (!pskb_may_pull(skb, sizeof(struct tcphdr)))
  1936			goto discard_it;
  1937	
  1938		th = (const struct tcphdr *)skb->data;
  1939	
  1940		if (unlikely(th->doff < sizeof(struct tcphdr) / 4)) {
  1941			drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
  1942			goto bad_packet;
  1943		}
  1944		if (!pskb_may_pull(skb, th->doff * 4))
  1945			goto discard_it;
  1946	
  1947		/* An explanation is required here, I think.
  1948		 * Packet length and doff are validated by header prediction,
  1949		 * provided case of th->doff==0 is eliminated.
  1950		 * So, we defer the checks. */
  1951	
  1952		if (skb_checksum_init(skb, IPPROTO_TCP, inet_compute_pseudo))
  1953			goto csum_error;
  1954	
  1955		th = (const struct tcphdr *)skb->data;
  1956		iph = ip_hdr(skb);
  1957	lookup:
  1958		sk = __inet_lookup_skb(&tcp_hashinfo, skb, __tcp_hdrlen(th), th->source,
  1959				       th->dest, sdif, &refcounted);
  1960		if (!sk)
  1961			goto no_tcp_socket;
  1962	
  1963	process:
  1964		if (sk->sk_state == TCP_TIME_WAIT)
  1965			goto do_time_wait;
  1966	
  1967		if (sk->sk_state == TCP_NEW_SYN_RECV) {
  1968			struct request_sock *req = inet_reqsk(sk);
  1969			bool req_stolen = false;
  1970			struct sock *nsk;
  1971	
  1972			sk = req->rsk_listener;
  1973			drop_reason = tcp_inbound_md5_hash(sk, skb,
  1974							   &iph->saddr, &iph->daddr,
  1975							   AF_INET, dif, sdif);
  1976			if (unlikely(drop_reason)) {
  1977				sk_drops_add(sk, skb);
  1978				reqsk_put(req);
  1979				goto discard_it;
  1980			}
  1981			if (tcp_checksum_complete(skb)) {
  1982				reqsk_put(req);
  1983				goto csum_error;
  1984			}
  1985			if (unlikely(sk->sk_state != TCP_LISTEN)) {
  1986				nsk = reuseport_migrate_sock(sk, req_to_sk(req), skb);
  1987				if (!nsk) {
  1988					inet_csk_reqsk_queue_drop_and_put(sk, req);
  1989					goto lookup;
  1990				}
  1991				sk = nsk;
  1992				/* reuseport_migrate_sock() has already held one sk_refcnt
  1993				 * before returning.
  1994				 */
  1995			} else {
  1996				/* We own a reference on the listener, increase it again
  1997				 * as we might lose it too soon.
  1998				 */
  1999				sock_hold(sk);
  2000			}
  2001			refcounted = true;
  2002			nsk = NULL;
  2003			if (!tcp_filter(sk, skb)) {
  2004				th = (const struct tcphdr *)skb->data;
  2005				iph = ip_hdr(skb);
  2006				tcp_v4_fill_cb(skb, iph, th);
  2007				nsk = tcp_check_req(sk, skb, req, false, &req_stolen);
  2008			} else {
  2009				drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
  2010			}
  2011			if (!nsk) {
  2012				reqsk_put(req);
  2013				if (req_stolen) {
  2014					/* Another cpu got exclusive access to req
  2015					 * and created a full blown socket.
  2016					 * Try to feed this packet to this socket
  2017					 * instead of discarding it.
  2018					 */
  2019					tcp_v4_restore_cb(skb);
  2020					sock_put(sk);
  2021					goto lookup;
  2022				}
  2023				goto discard_and_relse;
  2024			}
  2025			if (nsk == sk) {
  2026				reqsk_put(req);
  2027				tcp_v4_restore_cb(skb);
  2028			} else {
  2029				drop_reason = tcp_child_process(sk, nsk, skb);
  2030				if (drop_reason) {
  2031					tcp_v4_send_reset(nsk, skb);
  2032					goto discard_and_relse;
  2033				} else {
  2034					sock_put(sk);
  2035					return 0;
  2036				}
  2037			}
  2038		}
  2039	
  2040		if (static_branch_unlikely(&ip4_min_ttl)) {
  2041			/* min_ttl can be changed concurrently from do_ip_setsockopt() */
  2042			if (unlikely(iph->ttl < READ_ONCE(inet_sk(sk)->min_ttl))) {
  2043				__NET_INC_STATS(net, LINUX_MIB_TCPMINTTLDROP);
  2044				goto discard_and_relse;
  2045			}
  2046		}
  2047	
  2048		if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb)) {
  2049			drop_reason = SKB_DROP_REASON_XFRM_POLICY;
  2050			goto discard_and_relse;
  2051		}
  2052	
  2053		drop_reason = tcp_inbound_md5_hash(sk, skb, &iph->saddr,
  2054						   &iph->daddr, AF_INET, dif, sdif);
  2055		if (drop_reason)
  2056			goto discard_and_relse;
  2057	
  2058		nf_reset_ct(skb);
  2059	
  2060		if (tcp_filter(sk, skb)) {
  2061			drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
  2062			goto discard_and_relse;
  2063		}
  2064		th = (const struct tcphdr *)skb->data;
  2065		iph = ip_hdr(skb);
  2066		tcp_v4_fill_cb(skb, iph, th);
  2067	
  2068		skb->dev = NULL;
  2069	
  2070		if (sk->sk_state == TCP_LISTEN) {
  2071			ret = tcp_v4_do_rcv(sk, skb);
  2072			goto put_and_return;
  2073		}
  2074	
  2075		sk_incoming_cpu_update(sk);
  2076	
  2077		bh_lock_sock_nested(sk);
  2078		tcp_segs_in(tcp_sk(sk), skb);
  2079		ret = 0;
  2080		if (!sock_owned_by_user(sk)) {
  2081			ret = tcp_v4_do_rcv(sk, skb);
  2082		} else {
  2083			if (tcp_add_backlog(sk, skb, &drop_reason))
  2084				goto discard_and_relse;
  2085		}
  2086		bh_unlock_sock(sk);
  2087	
  2088	put_and_return:
  2089		if (refcounted)
  2090			sock_put(sk);
  2091	
  2092		return ret;
  2093	
  2094	no_tcp_socket:
  2095		drop_reason = SKB_DROP_REASON_NO_SOCKET;
  2096		if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
  2097			goto discard_it;
  2098	
  2099		tcp_v4_fill_cb(skb, iph, th);
  2100	
  2101		if (tcp_checksum_complete(skb)) {
  2102	csum_error:
  2103			drop_reason = SKB_DROP_REASON_TCP_CSUM;
  2104			trace_tcp_bad_csum(skb);
  2105			__TCP_INC_STATS(net, TCP_MIB_CSUMERRORS);
  2106	bad_packet:
  2107			__TCP_INC_STATS(net, TCP_MIB_INERRS);
  2108		} else {
  2109			tcp_v4_send_reset(NULL, skb);
  2110		}
  2111	
  2112	discard_it:
  2113		/* Discard frame. */
  2114		kfree_skb_reason(skb, drop_reason);
  2115		return 0;
  2116	
  2117	discard_and_relse:
  2118		sk_drops_add(sk, skb);
  2119		if (refcounted)
  2120			sock_put(sk);
  2121		goto discard_it;
  2122	
  2123	do_time_wait:
  2124		if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb)) {
  2125			drop_reason = SKB_DROP_REASON_XFRM_POLICY;
  2126			inet_twsk_put(inet_twsk(sk));
  2127			goto discard_it;
  2128		}
  2129	
  2130		tcp_v4_fill_cb(skb, iph, th);
  2131	
  2132		if (tcp_checksum_complete(skb)) {
  2133			inet_twsk_put(inet_twsk(sk));
  2134			goto csum_error;
  2135		}
  2136		switch (tcp_timewait_state_process(inet_twsk(sk), skb, th,
  2137						   &drop_reason)) {
  2138		case TCP_TW_SYN: {
  2139			struct sock *sk2 = inet_lookup_listener(dev_net(skb->dev),
  2140								&tcp_hashinfo, skb,
  2141								__tcp_hdrlen(th),
  2142								iph->saddr, th->source,
  2143								iph->daddr, th->dest,
  2144								inet_iif(skb),
  2145								sdif);
  2146			if (sk2) {
  2147				inet_twsk_deschedule_put(inet_twsk(sk));
  2148				sk = sk2;
  2149				tcp_v4_restore_cb(skb);
  2150				refcounted = false;
  2151				goto process;
  2152			}
  2153			/* TCP_FLAGS or NO_SOCKET? */
  2154			SKB_DR_SET(drop_reason, TCP_FLAGS);
  2155		}
  2156			/* to ACK */
  2157			fallthrough;
  2158		case TCP_TW_ACK:
  2159			tcp_v4_timewait_ack(sk, skb);
  2160			refcounted = false;
> 2161			if (drop_reason)
  2162				goto discard_it;
  2163			else
  2164				goto put_and_return;
  2165		case TCP_TW_RST:
  2166			tcp_v4_send_reset(sk, skb);
  2167			inet_twsk_deschedule_put(inet_twsk(sk));
  2168			goto discard_it;
  2169		case TCP_TW_SUCCESS:;
  2170		}
  2171		goto discard_it;
  2172	}
  2173	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
