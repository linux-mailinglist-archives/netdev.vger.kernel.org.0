Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 922A5A27FA
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 22:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfH2UaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 16:30:12 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:53550 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726661AbfH2UaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 16:30:11 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i3R3N-0007Cs-Vv; Thu, 29 Aug 2019 22:29:58 +0200
Date:   Thu, 29 Aug 2019 22:29:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Leonardo Bras <leonardo@linux.ibm.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v2 1/1] netfilter: nf_tables: fib: Drop IPV6 packages if
 IPv6 is disabled on boot
Message-ID: <20190829202957.GL20113@breakpoint.cc>
References: <20190821141505.2394-1-leonardo@linux.ibm.com>
 <db0f02c5b1a995fde174f036540a3d11008cf116.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db0f02c5b1a995fde174f036540a3d11008cf116.camel@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leonardo Bras <leonardo@linux.ibm.com> wrote:
> > Thats a good point -- Leonardo, is the
> > "net.bridge.bridge-nf-call-ip6tables" sysctl on?
> 
> Running
> # sudo sysctl -a
> I can see:
> net.bridge.bridge-nf-call-ip6tables = 1
>  
> So this packets are sent to host iptables for processing?

Yes, this is an hold hack that was made because ebtables is
very feature-limited.

However, as I mentioned before I don't think there is anything
we can do here except audit all affected nft expressions and ip6tables
matches and add this check where needed.  ip6t_rpfilter.c comes to mind.

In any case your patch looks ok to me.

> (Sorry for the delay, I did not received the previous e-mails.
> Please include me in to/cc.)

Sorry about that.
