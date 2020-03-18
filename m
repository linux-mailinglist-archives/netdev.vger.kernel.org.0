Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08DB7189880
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbgCRJvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:51:54 -0400
Received: from correo.us.es ([193.147.175.20]:45052 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbgCRJvy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 05:51:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2D456FB44A
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 10:51:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E3B6DA390
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 10:51:23 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1386BDA3C3; Wed, 18 Mar 2020 10:51:23 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1565DA3A3;
        Wed, 18 Mar 2020 10:51:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 10:51:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D3A6F42EE38E;
        Wed, 18 Mar 2020 10:51:20 +0100 (CET)
Date:   Wed, 18 Mar 2020 10:51:49 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH net-next] netfilter: revert introduction of egress hook
Message-ID: <20200318095149.stvs27fj2whir2x5@salvia>
References: <bbdee6355234e730ef686f9321bd072bcf4bb232.1584523237.git.daniel@iogearbox.net>
 <20200318093649.sn3hsi7nkd3j34lj@salvia>
 <97a81974-5063-ed3d-8ad4-9f7ff3aa0908@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97a81974-5063-ed3d-8ad4-9f7ff3aa0908@iogearbox.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 10:41:30AM +0100, Daniel Borkmann wrote:
> On 3/18/20 10:36 AM, Pablo Neira Ayuso wrote:
> > On Wed, Mar 18, 2020 at 10:33:22AM +0100, Daniel Borkmann wrote:
> > > This reverts the following commits:
> > > 
> > >    8537f78647c0 ("netfilter: Introduce egress hook")
> > >    5418d3881e1f ("netfilter: Generalize ingress hook")
> > >    b030f194aed2 ("netfilter: Rename ingress hook include file")
> > > 
> > >  From the discussion in [0], the author's main motivation to add a hook
> > > in fast path is for an out of tree kernel module, which is a red flag
> > > to begin with. Other mentioned potential use cases like NAT{64,46}
> > > is on future extensions w/o concrete code in the tree yet. Revert as
> > > suggested [1] given the weak justification to add more hooks to critical
> > > fast-path.
> > > 
> > >    [0] https://lore.kernel.org/netdev/cover.1583927267.git.lukas@wunner.de/
> > >    [1] https://lore.kernel.org/netdev/20200318.011152.72770718915606186.davem@davemloft.net/
> > > 
> > > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > 
> > Nacked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > Daniel, you must be really worried about achieving your goals if you
> > have to do politics to block stuff.
> 
> Looks like this is your only rationale technical argument you can come
> up with?

I have waited for two days and I got no feedback from you.

Moreover, your concerns on performance has been addressed: Performance
impact is negligible.

Then, you popped up more arguments, like a reference to an email from
17 years ago, where only iptables was available and the only choice to
add ingress/egress filtering was to make another copy and paste of the
iptables code.

I also explained how to use this egress hook in Netfilter.

What's missing on your side?
