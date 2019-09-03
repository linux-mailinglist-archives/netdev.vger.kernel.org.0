Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBD71A7505
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 22:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfICUfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 16:35:40 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43882 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726451AbfICUfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 16:35:39 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i5FWV-0004op-J2; Tue, 03 Sep 2019 22:35:31 +0200
Date:   Tue, 3 Sep 2019 22:35:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Leonardo Bras <leonardo@linux.ibm.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 1/2] netfilter: Terminate rule eval if protocol=IPv6
 and ipv6 module is disabled
Message-ID: <20190903203531.GF13660@breakpoint.cc>
References: <20190830181354.26279-1-leonardo@linux.ibm.com>
 <20190830181354.26279-2-leonardo@linux.ibm.com>
 <20190830205802.GS20113@breakpoint.cc>
 <99e3ef9c5ead1c95df697d49ab9cc83a95b0ac7c.camel@linux.ibm.com>
 <20190903164948.kuvtpy7viqhcmp77@salvia>
 <20190903170550.GA13660@breakpoint.cc>
 <20190903193155.v74ws47zcn6zrwpr@salvia>
 <20190903194809.GD13660@breakpoint.cc>
 <20190903201904.npna6dt25ug5gwvd@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903201904.npna6dt25ug5gwvd@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Sep 03, 2019 at 09:48:09PM +0200, Florian Westphal wrote:
> > We could do that from nft_do_chain_netdev().
> 
> Indeed, this is all about the netdev case.
> 
> Probably add something similar to nf_ip6_route() to deal with
> ip6_route_lookup() case? This is the one trigering the problem, right?

Yes, this particular problem is caused by ipv6 fib not being
initialized due to ipv6.disable=1.  I don't know if there are cases
other than FIB.

> BTW, how does nft_fib_ipv6 module kicks in if ipv6 module is not
> loaded? The symbol dependency would pull in the IPv6 module anyway.

ipv6.disabled=1 does load the ipv6 module, but its non-functional.
