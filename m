Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 323178395A
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 21:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbfHFTGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 15:06:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38252 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbfHFTGm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 15:06:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PMLh2xlPFZO5niUnXrm+VrRV5AaCM60OnF+J/5ln/Rk=; b=JltcvIkgs2EODDZQWrAQ3HXm4h
        5UWll1u9jt5fwZZqbOleDbKzyJZg7f77PDW0v6ANrDIc8gP2aQxow3XSLp5x6R5yZWczI/OXa56j+
        UiQO8ywOW8dpq9NaXY83v5JWTx2UpEShs5Jtyi4LkB1jQ0BPt6uOAHTlQ4j/FeuvDf9E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hv4n7-00071t-38; Tue, 06 Aug 2019 21:06:37 +0200
Date:   Tue, 6 Aug 2019 21:06:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, dsahern@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, mkubecek@suse.cz,
        stephen@networkplumber.org, daniel@iogearbox.net,
        brouer@redhat.com, eric.dumazet@gmail.com
Subject: Re: [RFC] implicit per-namespace devlink instance to set kernel
 resource limitations
Message-ID: <20190806190637.GE17072@lunn.ch>
References: <20190806164036.GA2332@nanopsycho.orion>
 <20190806112717.3b070d07@cakuba.netronome.com>
 <20190806183841.GD2332@nanopsycho.orion>
 <20190806115449.5b3a9d97@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806115449.5b3a9d97@cakuba.netronome.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 11:54:49AM -0700, Jakub Kicinski wrote:
> On Tue, 6 Aug 2019 20:38:41 +0200, Jiri Pirko wrote:
> > >> So the proposal is to have some new device, say "kernelnet", that
> > >> would implicitly create per-namespace devlink instance. This devlink
> > >> instance would be used to setup resource limits. Like:
> > >> 
> > >> devlink resource set kernelnet path /IPv4/fib size 96
> > >> devlink -N ns1name resource set kernelnet path /IPv6/fib size 100
> > >> devlink -N ns2name resource set kernelnet path /IPv4/fib-rules size 8
> > >> 
> > >> To me it sounds a bit odd for kernel namespace to act as a device, but
> > >> thinking about it more, it makes sense. Probably better than to define
> > >> a new api. User would use the same tool to work with kernel and hw.
> > >> 
> > >> Also we can implement other devlink functionality, like dpipe.
> > >> User would then have visibility of network pipeline, tables,
> > >> utilization, etc. It is related to the resources too.
> > >> 
> > >> What do you think?  
> > >
> > >I'm no expert here but seems counter intuitive that device tables would
> > >be aware of namespaces in the first place. Are we not reinventing
> > >cgroup controllers based on a device API? IMHO from a perspective of
> > >someone unfamiliar with routing offload this seems backwards :)  
> > 
> > Can we use cgroup for fib and other limitations instead?
> 
> Not sure the question is to me, I don't feel particularly qualified,
> I've never worked with VDCs or wrote a switch driver.. But I'd see
> cgroups as a natural fit, and if I read Andrew's reply right so does
> he.. 

Hi Jakub

I think there needs to be a clearly reasoned argument why cgroups is
the wrong answer to this problem. I myself don't know enough to give
that answer, but i can pose the question.

     Andrew

