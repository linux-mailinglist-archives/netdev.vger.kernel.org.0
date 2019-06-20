Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3B9B4D272
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 17:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfFTPuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 11:50:22 -0400
Received: from mail.us.es ([193.147.175.20]:50916 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726675AbfFTPuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 11:50:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C3362C1B44
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 17:50:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4830DA707
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 17:50:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A7750DA70D; Thu, 20 Jun 2019 17:50:19 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4D70EDA702;
        Thu, 20 Jun 2019 17:50:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Jun 2019 17:50:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 253FB4265A2F;
        Thu, 20 Jun 2019 17:50:17 +0200 (CEST)
Date:   Thu, 20 Jun 2019 17:50:16 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Yuehaibing <yuehaibing@huawei.com>
Cc:     kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        rdunlap@infradead.org, linux-kernel@vger.kernel.org,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: ipv6: Fix build error without
 CONFIG_IPV6
Message-ID: <20190620155016.6kk7xi4wldm5ijyh@salvia>
References: <20190612084715.21656-1-yuehaibing@huawei.com>
 <d2eba9e4-34be-f9bb-f0fd-024fe81d2b02@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2eba9e4-34be-f9bb-f0fd-024fe81d2b02@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 11:26:01PM +0800, Yuehaibing wrote:
> Friendly ping...
> 
> On 2019/6/12 16:47, YueHaibing wrote:
> > If CONFIG_IPV6 is not set, building fails:
> > 
> > net/bridge/netfilter/nf_conntrack_bridge.o: In function `nf_ct_bridge_pre':
> > nf_conntrack_bridge.c:(.text+0x41c): undefined symbol `nf_ct_frag6_gather'
> > net/bridge/netfilter/nf_conntrack_bridge.o: In function `nf_ct_bridge_post':
> > nf_conntrack_bridge.c:(.text+0x820): undefined symbol `br_ip6_fragment'

Is this one enough to fix this problem?

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/commit/?id=16e6427c88c5b7e7b6612f6c286d5f71d659e5be

Thanks.

> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > Fixes: c9bb6165a16e ("netfilter: nf_conntrack_bridge: fix CONFIG_IPV6=y")
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > ---
> >  include/linux/netfilter_ipv6.h | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
> > index 3a3dc4b..0e1febc 100644
> > --- a/include/linux/netfilter_ipv6.h
> > +++ b/include/linux/netfilter_ipv6.h
> > @@ -108,8 +108,11 @@ static inline int nf_ipv6_br_defrag(struct net *net, struct sk_buff *skb,
> >  		return 1;
> >  
> >  	return v6_ops->br_defrag(net, skb, user);
> > -#else
> > +#endif
> > +#if IS_BUILTIN(CONFIG_IPV6)
> >  	return nf_ct_frag6_gather(net, skb, user);
> > +#else
> > +	return 1;
> >  #endif
> >  }
> >  
> > @@ -133,8 +136,11 @@ static inline int nf_br_ip6_fragment(struct net *net, struct sock *sk,
> >  		return 1;
> >  
> >  	return v6_ops->br_fragment(net, sk, skb, data, output);
> > -#else
> > +#endif
> > +#if IS_BUILTIN(CONFIG_IPV6)
> >  	return br_ip6_fragment(net, sk, skb, data, output);
> > +#else
> > +	return 1;
> >  #endif
> >  }
> >  
> > 
> 
