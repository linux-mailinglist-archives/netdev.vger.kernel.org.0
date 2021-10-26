Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BC043BBE1
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 22:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239309AbhJZU4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 16:56:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:29571 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231396AbhJZU4k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 16:56:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="227468154"
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="gz'50?scan'50,208,50";a="227468154"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 13:54:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="gz'50?scan'50,208,50";a="597079610"
Received: from lkp-server01.sh.intel.com (HELO 072b454ebba8) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 26 Oct 2021 13:54:12 -0700
Received: from kbuild by 072b454ebba8 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mfTSW-0000S9-53; Tue, 26 Oct 2021 20:54:12 +0000
Date:   Wed, 27 Oct 2021 04:53:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net-next] inet: remove races in inet{6}_getname()
Message-ID: <202110270409.2AuD9qTa-lkp@intel.com>
References: <20211026173800.2232409-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20211026173800.2232409-1-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Eric,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/inet-remove-races-in-inet-6-_getname/20211027-013901
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 6b3671746a8a3aa05316b829e1357060f35009c1
config: csky-defconfig (attached as .config)
compiler: csky-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/337791bc53db80fb5982e0f66be795a2d37c3d8d
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Eric-Dumazet/inet-remove-races-in-inet-6-_getname/20211027-013901
        git checkout 337791bc53db80fb5982e0f66be795a2d37c3d8d
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross ARCH=csky 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   net/ipv6/af_inet6.c: In function 'inet6_getname':
>> net/ipv6/af_inet6.c:536:17: error: implicit declaration of function 'BPF_CGROUP_RUN_SA_PROG'; did you mean 'BPF_CGROUP_RUN_SA_PROG_LOCK'? [-Werror=implicit-function-declaration]
     536 |                 BPF_CGROUP_RUN_SA_PROG(sk, (struct sockaddr *)sin,
         |                 ^~~~~~~~~~~~~~~~~~~~~~
         |                 BPF_CGROUP_RUN_SA_PROG_LOCK
>> net/ipv6/af_inet6.c:537:40: error: 'CGROUP_INET6_GETPEERNAME' undeclared (first use in this function); did you mean 'BPF_CGROUP_INET6_GETPEERNAME'?
     537 |                                        CGROUP_INET6_GETPEERNAME);
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~~
         |                                        BPF_CGROUP_INET6_GETPEERNAME
   net/ipv6/af_inet6.c:537:40: note: each undeclared identifier is reported only once for each function it appears in
>> net/ipv6/af_inet6.c:545:40: error: 'CGROUP_INET6_GETSOCKNAME' undeclared (first use in this function); did you mean 'BPF_CGROUP_INET6_GETSOCKNAME'?
     545 |                                        CGROUP_INET6_GETSOCKNAME);
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~~
         |                                        BPF_CGROUP_INET6_GETSOCKNAME
   cc1: some warnings being treated as errors


vim +536 net/ipv6/af_inet6.c

   509	
   510	/*
   511	 *	This does both peername and sockname.
   512	 */
   513	int inet6_getname(struct socket *sock, struct sockaddr *uaddr,
   514			  int peer)
   515	{
   516		struct sockaddr_in6 *sin = (struct sockaddr_in6 *)uaddr;
   517		struct sock *sk = sock->sk;
   518		struct inet_sock *inet = inet_sk(sk);
   519		struct ipv6_pinfo *np = inet6_sk(sk);
   520	
   521		sin->sin6_family = AF_INET6;
   522		sin->sin6_flowinfo = 0;
   523		sin->sin6_scope_id = 0;
   524		lock_sock(sk);
   525		if (peer) {
   526			if (!inet->inet_dport ||
   527			    (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_SYN_SENT)) &&
   528			    peer == 1)) {
   529				release_sock(sk);
   530				return -ENOTCONN;
   531			}
   532			sin->sin6_port = inet->inet_dport;
   533			sin->sin6_addr = sk->sk_v6_daddr;
   534			if (np->sndflow)
   535				sin->sin6_flowinfo = np->flow_label;
 > 536			BPF_CGROUP_RUN_SA_PROG(sk, (struct sockaddr *)sin,
 > 537					       CGROUP_INET6_GETPEERNAME);
   538		} else {
   539			if (ipv6_addr_any(&sk->sk_v6_rcv_saddr))
   540				sin->sin6_addr = np->saddr;
   541			else
   542				sin->sin6_addr = sk->sk_v6_rcv_saddr;
   543			sin->sin6_port = inet->inet_sport;
   544			BPF_CGROUP_RUN_SA_PROG(sk, (struct sockaddr *)sin,
 > 545					       CGROUP_INET6_GETSOCKNAME);
   546		}
   547		sin->sin6_scope_id = ipv6_iface_scope_id(&sin->sin6_addr,
   548							 sk->sk_bound_dev_if);
   549		release_sock(sk);
   550		return sizeof(*sin);
   551	}
   552	EXPORT_SYMBOL(inet6_getname);
   553	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--liOOAslEiF7prFVr
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICC9oeGEAAy5jb25maWcAnFxbc9u4kn4/v4KVqdo65yEZX2LZqS0/QCQoYcRbAFCXvLAU
WUlUsS2vJM9M/v02AF4AsiHP7qmaE7u7ATSARvfXDdC//eu3gLye9k/r026zfnz8FXzfPm8P
69P2Ifi2e9z+dxDlQZbLgEZMfgDhZPf8+vfvm+PPX8HNh8ubDxfvD5tRMNsenrePQbh//rb7
/grNd/vnf/32rzDPYjapwrCaUy5YnlWSLuX9O9X8/aPq6f33zSb49yQM/xNcXn64+nDxzmrE
RAWc+18NadJ1dH95eXF1cdEKJySbtLyWTITuIyu7PoDUiF1d33Y9JJESHcdRJwokXNRiXFjq
TqFvItJqksu866XHqPJSFqVE+SxLWEYHrCyvCp7HLKFVnFVESt6JMP65WuR8BhRY79+Cid69
x+C4Pb2+dDsw5vmMZhVsgEgLq3XGZEWzeUU4TIulTN5fX0Evzfh5WqhRJRUy2B2D5/1JddwJ
LCjnObdZzRLlIUmaNXr3rmthMypSyhxpPC4ZrLAgiVRNa+KUzGk1ozyjSTX5wqxJ2JzkS0p8
HGtP3H5a5axO0Ol2XSFaRzQmZSL1mlp6N+RpLmRGUmqM31oRsSAF0p1YiTkrLOOvCerfUCYd
vcgFW1bp55KWFKd2TbqNIzKcVpqLjB3yXIgqpWnOV8reSDi1G5eCJmyMtCMlOIne8hMOA2mG
0oIkluY9qrZfsOfg+Pr1+Ot42j519puSlelOFIQLqszecgs0o5yF+izAQRlTnCWm+QLnhFPb
nhQlylPCMoxWTRnlalIre6JZBMekFjC6dfvbauza1Pb5Idh/600Y0y4F82H1GHw4AclSWs0H
i9uwQzhxMzqnmRTNGsvd0/ZwxJZZsnAGToLCUln7CP5n+kU5gzTP7JkBsYAx8oiFiDGYVgyU
tttoKiI9ZZNpxanQ0+FCN6lXaKBu6yeKuJkS/OjMpx0PGFW9Nujyuw3b08MpTQsJ2maO9g19
nidlJglfoW6ilrJ5RqWi/F2ujz+DE8woWIMCx9P6dAzWm83+9fm0e/7e2wloUJEwzGEslk1s
ReaMyx5b7TjmTEWkDkVI4USDsLWtfU41v7aHkETMhCRS4HMUDF3PfzBHvRY8LAOBGWC2qoBn
KwK/VnQJliYxN2mE7eaiaV+r5A7V9ctm5gd0fmw2pSQCS0SDm4pRYFdTFsv7y9vOalgmZxC4
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

--liOOAslEiF7prFVr--
