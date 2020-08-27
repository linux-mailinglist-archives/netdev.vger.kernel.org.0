Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B20255051
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 23:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgH0VGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 17:06:13 -0400
Received: from mg.ssi.bg ([178.16.128.9]:35380 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbgH0VGJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 17:06:09 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Aug 2020 17:06:07 EDT
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 393092E4AD;
        Thu, 27 Aug 2020 23:59:34 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [178.16.128.7])
        by mg.ssi.bg (Proxmox) with ESMTP id A945B2E3D0;
        Thu, 27 Aug 2020 23:59:33 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id A90133C09C4;
        Thu, 27 Aug 2020 23:59:27 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 07RKxO9Y013130;
        Thu, 27 Aug 2020 23:59:26 +0300
Date:   Thu, 27 Aug 2020 23:59:24 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Lach <iam@lach.pw>
cc:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove ipvs v6 dependency on iptables
In-Reply-To: <20200827194802.1164-1-iam@lach.pw>
Message-ID: <alpine.LFD.2.23.451.2008272357240.4567@ja.home.ssi.bg>
References: <20200827194802.1164-1-iam@lach.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Fri, 28 Aug 2020, Lach wrote:

> This dependency was added in 63dca2c0b0e7a92cb39d1b1ecefa32ffda201975, because this commit had dependency on
> ipv6_find_hdr, which was located in iptables-specific code
> 
> But it is no longer required, because f8f626754ebeca613cf1af2e6f890cfde0e74d5b moved them to a more common location

	May be then we should also not include ip6_tables.h from
include/net/ip_vs.h ?

> ---
>  net/netfilter/ipvs/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
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

