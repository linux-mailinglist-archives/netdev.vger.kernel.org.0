Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792401AE7A0
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 23:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgDQVeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 17:34:09 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:50970 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727857AbgDQVeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 17:34:09 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jPYcO-00082E-D2; Fri, 17 Apr 2020 23:33:48 +0200
Date:   Fri, 17 Apr 2020 23:33:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+33e06702fd6cffc24c40@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: WARNING in nf_nat_unregister_fn
Message-ID: <20200417213348.GC32392@breakpoint.cc>
References: <000000000000490f1005a375ed34@google.com>
 <20200417094250.21872-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417094250.21872-1-hdanton@sina.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hillf Danton <hdanton@sina.com> wrote:
> In case of failure to register NFPROTO_IPV4, unregister NFPROTO_IPV6
> instead of ops->pf (== NFPROTO_INET).
> 
> --- a/net/netfilter/nf_nat_proto.c
> +++ b/net/netfilter/nf_nat_proto.c
> @@ -1022,8 +1022,8 @@ int nf_nat_inet_register_fn(struct net *
>  	ret = nf_nat_register_fn(net, NFPROTO_IPV4, ops, nf_nat_ipv4_ops,
>  				 ARRAY_SIZE(nf_nat_ipv4_ops));
>  	if (ret)
> -		nf_nat_ipv6_unregister_fn(net, ops);
> -
> +		nf_nat_unregister_fn(net, NFPROTO_IPV6, ops,
> +					ARRAY_SIZE(nf_nat_ipv6_ops));
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(nf_nat_inet_register_fn);

Yes.  Please make a formal patch submission to netfilter-devel@,
including you signed-off-by, the Reported-by tag from syzbot
and a 'Fixes' tag for the buggy commit.

Thank you.
