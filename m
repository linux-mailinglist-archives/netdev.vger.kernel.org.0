Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA50718116A
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 08:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgCKHFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 03:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgCKHFx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 03:05:53 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6571420726;
        Wed, 11 Mar 2020 07:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583910353;
        bh=+AL2BfEUIAr0/0yXML3b9QIUQZMmI2deqDZ8qDSRKfQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rrUoUTjhbMbYhG4mKb/hbbIiTVzOrZgbvxLFiiuMZpxmZTNDi3mRwcPjC0ls3m6bp
         lqPBhnKLvIjQibxD147VZJ0EkViho3K8Erts1+StNUy7C3I686lXzfFwZUh3QJsNNB
         P/zsr8hc7pRxqIHjUNrCCQ4S40G/Y/H1cpZ4q+k0=
Date:   Wed, 11 Mar 2020 09:05:49 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH net-next 4/6] octeontx2-vf: Ethtool support
Message-ID: <20200311070549.GG4215@unreal>
References: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
 <1583866045-7129-5-git-send-email-sunil.kovvuri@gmail.com>
 <20200310192111.GC11247@lunn.ch>
 <CA+sq2CeTFZdH60MS1fPhfTJjSJFCn2wY6iPH+VvuLSHzkApB-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+sq2CeTFZdH60MS1fPhfTJjSJFCn2wY6iPH+VvuLSHzkApB-w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 12:09:45PM +0530, Sunil Kovvuri wrote:
> On Wed, Mar 11, 2020 at 12:51 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Wed, Mar 11, 2020 at 12:17:23AM +0530, sunil.kovvuri@gmail.com wrote:
> > > +int __weak otx2vf_open(struct net_device *netdev)
> > > +{
> > > +     return 0;
> > > +}
> > > +
> > > +int __weak otx2vf_stop(struct net_device *netdev)
> > > +{
> > > +     return 0;
> > > +}
> >
> > Hi Sunil
> >
> > weak symbols are very unusual in a driver. Why are they required?
> >
> > Thanks
> >         Andrew
>
> For ethtool configs which need interface reinitialization of interface
> we need to either call PF or VF open/close fn()s.
> If VF driver is not compiled in, then PF driver compilation will fail
> without these weak symbols.
> They are there just for compilation purpose, no other use.

It doesn't make sense, your PF driver should be changed to allow
compilation with those empty functions.

Thanks

>
> Thanks,
> Sunil.
