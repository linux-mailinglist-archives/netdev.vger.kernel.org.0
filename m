Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211C731B039
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 12:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhBNLcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 06:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhBNLcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 06:32:50 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4A4C061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 03:32:09 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id z6so2499756pfq.0
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 03:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gLNzr4HrtwMCPW4EX4UzsnF0mCx3UiKNOGf6Cin1vXo=;
        b=P9k4x+O5XNqV7QVZn6PYbWKoxalQMy/QdrjrYKMjdz+BHqsMDNRIK5pFWtmy7cQ7cS
         Z+Vpm3JdE1ZFPwDekN1dhwTN72FrYi5kLhKFfxxenjGgrdx3c8uSBgIAs2WVBSYhleOM
         /nF8ZsNqSBOqr3VGw82w/j1kTFGC2oy+Brs+4K4DZlV0Wz5I+sIEOjOMxzRfI6U/omF8
         ZWTbNwglLtr7a5Jrk95lRcxj0urkPUfo3pmHFAwObGTSjTJYTu+m0+Zg1DkTT7wqynmw
         PzJEm3M3NV/JC0oFQxxZJGfq6Fkt3fcUzYP3fl4Mk8lKZZ01gHflASJsXi2aabWSqBUC
         GhkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gLNzr4HrtwMCPW4EX4UzsnF0mCx3UiKNOGf6Cin1vXo=;
        b=uGk7zRF+svimSMlNTTBh3TnkE4GGYFgzELMY9RkmXTlawlO+kZSyBSiax6ngKsN5f8
         KCgrqp2d2ezI2lTU1Ppi+YBmG01hoWii3T5ZF1GgWxpgtl7LdGnf+6yV1vlPX8zQCMON
         umJwGYUEi1rDMP70nSIMZhU4DxLhuznReVFFZu47CNtlTwJ0KbCvnJDy28hJ2a4hfTse
         FzJS1QU2PVJDUrmOKH0FzYYz4fFmGXENYTz5yQKigC/LA3SVk0BmjOm5v9uXaDFv+YOI
         EMB3JxeSdcIJaXOTjg6YLpMYBaqUH8bB15otx0rqftmfos/QYOz2lSRDkfM3XIrRNdrb
         kmSg==
X-Gm-Message-State: AOAM532IjGk/MP3PkZNahOxmpuPQyVMXUS1Xvx69Yz5Nl8fvzeFWdVJK
        AHc3FgHnAx7LCLr2fIYfZtA=
X-Google-Smtp-Source: ABdhPJws+Y9AeX3/rAP5a9NfKXF0stLpMgYUjbUbyLQ663StaDPh/yYyKeO+bBr/9NTIQb2Pi3OQyw==
X-Received: by 2002:a05:6a00:2353:b029:1ba:d824:f1dc with SMTP id j19-20020a056a002353b02901bad824f1dcmr10985985pfj.9.1613302328990;
        Sun, 14 Feb 2021 03:32:08 -0800 (PST)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id h20sm11508266pfv.164.2021.02.14.03.32.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Feb 2021 03:32:08 -0800 (PST)
Subject: Re: [PATCH net-next v2 5/7] mld: convert ipv6_mc_socklist->sflist to
 RCU
To:     kernel test robot <lkp@intel.com>, davem@davemloft.net,
        kuba@kernel.org, xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch
Cc:     kbuild-all@lists.01.org, ap420073@gmail.com
References: <20210213175239.28571-1-ap420073@gmail.com>
 <202102140308.IZ2lfKij-lkp@intel.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <14dd6a56-4088-0fb6-5b15-2d8424e94d36@gmail.com>
Date:   Sun, 14 Feb 2021 20:32:04 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <202102140308.IZ2lfKij-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21. 2. 14. 오전 4:41, kernel test robot wrote:
> Hi Taehee,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on net-next/master]
> 
> url:    https://github.com/0day-ci/linux/commits/Taehee-Yoo/mld-change-context-from-atomic-to-sleepable/20210214-015930
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 3c5a2fd042d0bfac71a2dfb99515723d318df47b
> config: x86_64-randconfig-s022-20210214 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> reproduce:
>          # apt-get install sparse
>          # sparse version: v0.6.3-215-g0fb77bb6-dirty
>          # https://github.com/0day-ci/linux/commit/5a21fa32b1401aa428cd0249ee5b02ddb12cff60
>          git remote add linux-review https://github.com/0day-ci/linux
>          git fetch --no-tags linux-review Taehee-Yoo/mld-change-context-from-atomic-to-sleepable/20210214-015930
>          git checkout 5a21fa32b1401aa428cd0249ee5b02ddb12cff60
>          # save the attached .config to linux build tree
>          make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=x86_64
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> 
> "sparse warnings: (new ones prefixed by >>)"
>>> net/ipv6/mcast.c:430:17: sparse: sparse: incompatible types in comparison expression (different address spaces):
>>> net/ipv6/mcast.c:430:17: sparse:    struct ip6_sf_socklist [noderef] __rcu *
>>> net/ipv6/mcast.c:430:17: sparse:    struct ip6_sf_socklist *
>     net/ipv6/mcast.c: note: in included file:
>     include/net/mld.h:32:43: sparse: sparse: array of flexible structures
>     net/ipv6/mcast.c:257:25: sparse: sparse: context imbalance in 'ip6_mc_find_dev_rcu' - different lock contexts for basic block
>     net/ipv6/mcast.c:447:9: sparse: sparse: context imbalance in 'ip6_mc_source' - unexpected unlock
>     net/ipv6/mcast.c:536:9: sparse: sparse: context imbalance in 'ip6_mc_msfilter' - unexpected unlock
>     net/ipv6/mcast.c:583:21: sparse: sparse: context imbalance in 'ip6_mc_msfget' - unexpected unlock
>     net/ipv6/mcast.c:2724:25: sparse: sparse: context imbalance in 'igmp6_mc_get_next' - unexpected unlock
>     net/ipv6/mcast.c:2746:9: sparse: sparse: context imbalance in 'igmp6_mc_get_idx' - wrong count at exit
>     net/ipv6/mcast.c:2773:9: sparse: sparse: context imbalance in 'igmp6_mc_seq_stop' - unexpected unlock
>     net/ipv6/mcast.c:2845:31: sparse: sparse: context imbalance in 'igmp6_mcf_get_next' - unexpected unlock
>     net/ipv6/mcast.c:2877:9: sparse: sparse: context imbalance in 'igmp6_mcf_get_idx' - wrong count at exit
>     net/ipv6/mcast.c:2894:9: sparse: sparse: context imbalance in 'igmp6_mcf_seq_next' - wrong count at exit
>     net/ipv6/mcast.c:2907:17: sparse: sparse: context imbalance in 'igmp6_mcf_seq_stop' - unexpected unlock
> 
> vim +430 net/ipv6/mcast.c
> 
>     325	
>     326	int ip6_mc_source(int add, int omode, struct sock *sk,
>     327		struct group_source_req *pgsr)
>     328	{
>     329		struct in6_addr *source, *group;
>     330		struct ipv6_mc_socklist *pmc;
>     331		struct inet6_dev *idev;
>     332		struct ipv6_pinfo *inet6 = inet6_sk(sk);
>     333		struct ip6_sf_socklist *psl;
>     334		struct net *net = sock_net(sk);
>     335		int i, j, rv;
>     336		int leavegroup = 0;
>     337		int err;
>     338	
>     339		source = &((struct sockaddr_in6 *)&pgsr->gsr_source)->sin6_addr;
>     340		group = &((struct sockaddr_in6 *)&pgsr->gsr_group)->sin6_addr;
>     341	
>     342		if (!ipv6_addr_is_multicast(group))
>     343			return -EINVAL;
>     344	
>     345		rcu_read_lock();
>     346		idev = ip6_mc_find_dev_rcu(net, group, pgsr->gsr_interface);
>     347		if (!idev) {
>     348			rcu_read_unlock();
>     349			return -ENODEV;
>     350		}
>     351	
>     352		err = -EADDRNOTAVAIL;
>     353	
>     354		for_each_pmc_rcu(inet6, pmc) {
>     355			if (pgsr->gsr_interface && pmc->ifindex != pgsr->gsr_interface)
>     356				continue;
>     357			if (ipv6_addr_equal(&pmc->addr, group))
>     358				break;
>     359		}
>     360		if (!pmc) {		/* must have a prior join */
>     361			err = -EINVAL;
>     362			goto done;
>     363		}
>     364		/* if a source filter was set, must be the same mode as before */
>     365		if (rcu_access_pointer(pmc->sflist)) {
>     366			if (pmc->sfmode != omode) {
>     367				err = -EINVAL;
>     368				goto done;
>     369			}
>     370		} else if (pmc->sfmode != omode) {
>     371			/* allow mode switches for empty-set filters */
>     372			ip6_mc_add_src(idev, group, omode, 0, NULL, 0);
>     373			ip6_mc_del_src(idev, group, pmc->sfmode, 0, NULL, 0);
>     374			pmc->sfmode = omode;
>     375		}
>     376	
>     377		psl = rtnl_dereference(pmc->sflist);
>     378		if (!add) {
>     379			if (!psl)
>     380				goto done;	/* err = -EADDRNOTAVAIL */
>     381			rv = !0;
>     382			for (i = 0; i < psl->sl_count; i++) {
>     383				rv = !ipv6_addr_equal(&psl->sl_addr[i], source);
>     384				if (rv == 0)
>     385					break;
>     386			}
>     387			if (rv)		/* source not found */
>     388				goto done;	/* err = -EADDRNOTAVAIL */
>     389	
>     390			/* special case - (INCLUDE, empty) == LEAVE_GROUP */
>     391			if (psl->sl_count == 1 && omode == MCAST_INCLUDE) {
>     392				leavegroup = 1;
>     393				goto done;
>     394			}
>     395	
>     396			/* update the interface filter */
>     397			ip6_mc_del_src(idev, group, omode, 1, source, 1);
>     398	
>     399			for (j = i+1; j < psl->sl_count; j++)
>     400				psl->sl_addr[j-1] = psl->sl_addr[j];
>     401			psl->sl_count--;
>     402			err = 0;
>     403			goto done;
>     404		}
>     405		/* else, add a new source to the filter */
>     406	
>     407		if (psl && psl->sl_count >= sysctl_mld_max_msf) {
>     408			err = -ENOBUFS;
>     409			goto done;
>     410		}
>     411		if (!psl || psl->sl_count == psl->sl_max) {
>     412			struct ip6_sf_socklist *newpsl;
>     413			int count = IP6_SFBLOCK;
>     414	
>     415			if (psl)
>     416				count += psl->sl_max;
>     417			newpsl = sock_kmalloc(sk, IP6_SFLSIZE(count), GFP_ATOMIC);
>     418			if (!newpsl) {
>     419				err = -ENOBUFS;
>     420				goto done;
>     421			}
>     422			newpsl->sl_max = count;
>     423			newpsl->sl_count = count - IP6_SFBLOCK;
>     424			if (psl) {
>     425				for (i = 0; i < psl->sl_count; i++)
>     426					newpsl->sl_addr[i] = psl->sl_addr[i];
>     427				atomic_sub(IP6_SFLSIZE(psl->sl_max), &sk->sk_omem_alloc);
>     428				kfree_rcu(psl, rcu);
>     429			}
>   > 430			rcu_assign_pointer(psl, newpsl);
>     431			rcu_assign_pointer(pmc->sflist, psl);
>     432		}
>     433		rv = 1;	/* > 0 for insert logic below if sl_count is 0 */
>     434		for (i = 0; i < psl->sl_count; i++) {
>     435			rv = !ipv6_addr_equal(&psl->sl_addr[i], source);
>     436			if (rv == 0) /* There is an error in the address. */
>     437				goto done;
>     438		}
>     439		for (j = psl->sl_count-1; j >= i; j--)
>     440			psl->sl_addr[j+1] = psl->sl_addr[j];
>     441		psl->sl_addr[i] = *source;
>     442		psl->sl_count++;
>     443		err = 0;
>     444		/* update the interface list */
>     445		ip6_mc_add_src(idev, group, omode, 1, source, 1);
>     446	done:
>     447		read_unlock_bh(&idev->lock);
>     448		rcu_read_unlock();
>     449		if (leavegroup)
>     450			err = ipv6_sock_mc_drop(sk, pgsr->gsr_interface, group);
>     451		return err;
>     452	}
>     453	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 

I will add __rcu annotation in a v3 patch to avoid sparse warning.
Thanks!
