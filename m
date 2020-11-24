Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D762C1B19
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 02:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgKXB5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 20:57:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbgKXB5l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 20:57:41 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 544F42072C;
        Tue, 24 Nov 2020 01:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606183060;
        bh=2uzFjnm6RS8AnyuaSsofiaIWSEue4rXki5+JuMHi1JY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TsiIghONEA1YmzUyBqDoO2tN/q/ISqYXcWFgxfkwmL3N/NesHyHl+i5hplGoRPmkY
         NA92TtG7/fbU71hCFp0w6RYTnxqG4gFNdVipP66FG5QwXVS5msepZ4j8F66qu0j2vF
         lD9wH713/6DfrA8kkrCy32Y9HCM5vW9xE4K0Ch9E=
Date:   Mon, 23 Nov 2020 17:57:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     Eelco Chaudron <echaudro@redhat.com>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>, dev@openvswitch.org,
        Pravin B Shelar <pshelar@ovn.org>, bindiyakurle@gmail.com,
        Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [PATCH net] net: openvswitch: fix TTL decrement action netlink
 message format
Message-ID: <20201123175739.13a27aed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAFnufp1RRtwDLwrWayvyZVPmDjab_dTx50u7xWeNwK7J6azqWw@mail.gmail.com>
References: <160577663600.7755.4779460826621858224.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
        <20201120131228.489c3b52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAFnufp1RRtwDLwrWayvyZVPmDjab_dTx50u7xWeNwK7J6azqWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 20:36:39 +0100 Matteo Croce wrote:
> On Fri, Nov 20, 2020 at 10:12 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 19 Nov 2020 04:04:04 -0500 Eelco Chaudron wrote:  
> > > Currently, the openvswitch module is not accepting the correctly formated
> > > netlink message for the TTL decrement action. For both setting and getting
> > > the dec_ttl action, the actions should be nested in the
> > > OVS_DEC_TTL_ATTR_ACTION attribute as mentioned in the openvswitch.h uapi.  
> >
> > IOW this change will not break any known user space, correct?
> >
> > But existing OvS user space already expects it to work like you
> > make it work now?
> >
> > What's the harm in leaving it as is?
> >  
> > > Fixes: 744676e77720 ("openvswitch: add TTL decrement action")
> > > Signed-off-by: Eelco Chaudron <echaudro@redhat.com>  
> >
> > Can we get a review from OvS folks? Matteo looks good to you (as the
> > original author)?
> 
> I think that the userspace still has to implement the dec_ttl action;
> by now dec_ttl is implemented with set_ttl().
> So there is no breakage yet.
> 
> Eelco, with this fix we will encode the netlink attribute in the same
> way for the kernel and netdev datapath?

We don't allow breaking uAPI. Sounds like the user space never
implemented this and perhaps the nesting is just inconvenient 
but not necessarily broken? If it is broken and unusable that 
has to be clearly explained in the commit message. I'm dropping 
v1 from patchwork.
