Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FEB257F5B
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 19:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbgHaRMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 13:12:21 -0400
Received: from mg.ssi.bg ([178.16.128.9]:41756 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbgHaRMU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 13:12:20 -0400
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 1B84C247A0;
        Mon, 31 Aug 2020 20:12:17 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [178.16.128.7])
        by mg.ssi.bg (Proxmox) with ESMTP id 7A1112479F;
        Mon, 31 Aug 2020 20:12:16 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id DD17E3C24C7;
        Mon, 31 Aug 2020 20:12:09 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 07VHC5NF006196;
        Mon, 31 Aug 2020 20:12:06 +0300
Date:   Mon, 31 Aug 2020 20:12:05 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Yaroslav Bolyukin <iam@lach.pw>
cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCHv5 net-next] ipvs: remove dependency on ip6_tables
In-Reply-To: <20200829135953.20228-1-iam@lach.pw>
Message-ID: <alpine.LFD.2.23.451.2008312005270.4425@ja.home.ssi.bg>
References: <alpine.LFD.2.23.451.2008291233110.3043@ja.home.ssi.bg> <20200829135953.20228-1-iam@lach.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Sat, 29 Aug 2020, Yaroslav Bolyukin wrote:

> This dependency was added because ipv6_find_hdr was in iptables specific
> code but is no longer required
> 
> Fixes: f8f626754ebe ("ipv6: Move ipv6_find_hdr() out of Netfilter code.")
> Fixes: 63dca2c0b0e7 ("ipvs: Fix faulty IPv6 extension header handling in IPVS").
> Signed-off-by: Yaroslav Bolyukin <iam@lach.pw>

	Looks good to me, thanks! May be maintainers will
remove the extra dot after the Fixes line.

Acked-by: Julian Anastasov <ja@ssi.bg>

> ---
>  Missed canonical patch format section, subsystem is now spevified
> 
>  include/net/ip_vs.h        | 3 ---
>  net/netfilter/ipvs/Kconfig | 1 -
>  2 files changed, 4 deletions(-)
> 
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 9a59a3378..d609e957a 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -25,9 +25,6 @@
>  #include <linux/ip.h>
>  #include <linux/ipv6.h>			/* for struct ipv6hdr */
>  #include <net/ipv6.h>
> -#if IS_ENABLED(CONFIG_IP_VS_IPV6)
> -#include <linux/netfilter_ipv6/ip6_tables.h>
> -#endif
>  #if IS_ENABLED(CONFIG_NF_CONNTRACK)
>  #include <net/netfilter/nf_conntrack.h>
>  #endif
> diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
> index 2c1593089..eb0e329f9 100644
> --- a/net/netfilter/ipvs/Kconfig
> +++ b/net/netfilter/ipvs/Kconfig
> @@ -29,7 +29,6 @@ if IP_VS
>  config	IP_VS_IPV6
>  	bool "IPv6 support for IPVS"
>  	depends on IPV6 = y || IP_VS = IPV6
> -	select IP6_NF_IPTABLES
>  	select NF_DEFRAG_IPV6
>  	help
>  	  Add IPv6 support to IPVS.
> --
> 2.28.0

Regards

--
Julian Anastasov <ja@ssi.bg>

