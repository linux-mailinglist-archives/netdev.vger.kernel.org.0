Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2856B1AC8B7
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 17:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395133AbgDPPNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 11:13:12 -0400
Received: from pb-smtp20.pobox.com ([173.228.157.52]:56192 "EHLO
        pb-smtp20.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395088AbgDPPNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 11:13:05 -0400
Received: from pb-smtp20.pobox.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id 2C30CCCAF9;
        Thu, 16 Apr 2020 11:13:02 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=date:from:to
        :cc:subject:in-reply-to:message-id:references:mime-version
        :content-type; s=sasl; bh=EmCc83cGpH1PK+OmfXhUEjWC8ds=; b=aVQ7ou
        3WqM0s3ghVtQuQ+FnbxizM2oeosiePh15ekPxSOpZ5O+u89PgTaFwE+kQfwwhh25
        emmYOPZ6Wl2UWxq/FnmZHkgixpcMfM6nOkqGfWOK7E2x/KQGpJCzjT/f3Yl3zVqH
        Yb1epFuCEAxlCdVNqp5xcJA8BnxfM0KCv8YBk=
Received: from pb-smtp20.sea.icgroup.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id 22606CCAF8;
        Thu, 16 Apr 2020 11:13:02 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=fluxnic.net;
 h=date:from:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type; s=2016-12.pbsmtp; bh=ODtNsYZK2kcwPIZiYkxRnX/rGfukkhVwPZgiIX9m3Hc=; b=mhOwPOrLVNViEQcT6ZxueaJIaNS2OOL5Q6V5kVOJqurB2pQbu5SYf5agaBqzZzQgkrZS/H5Ymql18PTg+aPX++qwbVDZvTgLZvgJmFfIRVcrVkcryFpWoLdgyWxZkfPSOHs95eV/gNPMNi3xlcU4RtrraEQdGL7yRh3CzutY8jM=
Received: from yoda.home (unknown [24.203.50.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pb-smtp20.pobox.com (Postfix) with ESMTPSA id D99EDCCAF3;
        Thu, 16 Apr 2020 11:12:58 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
Received: from xanadu.home (xanadu.home [192.168.2.2])
        by yoda.home (Postfix) with ESMTPSA id 09BC42DA0D32;
        Thu, 16 Apr 2020 11:12:57 -0400 (EDT)
Date:   Thu, 16 Apr 2020 11:12:56 -0400 (EDT)
From:   Nicolas Pitre <nico@fluxnic.net>
To:     Arnd Bergmann <arnd@arndb.de>
cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "a.hajda@samsung.com" <a.hajda@samsung.com>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
In-Reply-To: <CAK8P3a1S2x1jnx9Q5B22vX8gBHs0Ztu-znA9hqZ5xp5tRAykGg@mail.gmail.com>
Message-ID: <nycvar.YSQ.7.76.2004161106140.2671@knanqh.ubzr>
References: <20200408202711.1198966-1-arnd@arndb.de> <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr> <CAK8P3a2frDf4BzEpEF0uwPTV2dv6Jve+6N97z1sSuSBUAPJquA@mail.gmail.com> <20200408224224.GD11886@ziepe.ca> <87k12pgifv.fsf@intel.com>
 <7d9410a4b7d0ef975f7cbd8f0b6762df114df539.camel@mellanox.com> <20200410171320.GN11886@ziepe.ca> <16441479b793077cdef9658f35773739038c39dc.camel@mellanox.com> <20200414132900.GD5100@ziepe.ca> <CAK8P3a0aFQ7h4zRDW=QLogXWc88JkJJXEOK0_CpWwsRjq6+T+w@mail.gmail.com>
 <20200414152312.GF5100@ziepe.ca> <CAK8P3a1PjP9_b5NdmqTLeGN4y+3JXx_yyTE8YAf1u5rYHWPA9g@mail.gmail.com> <f6d83b08fc0bc171b5ba5b2a0bc138727d92e2c0.camel@mellanox.com> <CAK8P3a1-J=4EAxh7TtQxugxwXk239u8ffgxZNRdw_WWy8ExFoQ@mail.gmail.com>
 <834c7606743424c64951dd2193ca15e29799bf18.camel@mellanox.com> <CAK8P3a3Wx5_bUOKnN3_hG5nLOqv3WCUtMSq6vOkJzWZgsmAz+A@mail.gmail.com> <874ktj4tvn.fsf@intel.com> <CAK8P3a1S2x1jnx9Q5B22vX8gBHs0Ztu-znA9hqZ5xp5tRAykGg@mail.gmail.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Pobox-Relay-ID: C1D878A0-7FF4-11EA-9E0A-B0405B776F7B-78420484!pb-smtp20.pobox.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Apr 2020, Arnd Bergmann wrote:

> On Thu, Apr 16, 2020 at 12:17 PM Jani Nikula
> <jani.nikula@linux.intel.com> wrote:
> >
> > On Thu, 16 Apr 2020, Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Thu, Apr 16, 2020 at 5:25 AM Saeed Mahameed <saeedm@mellanox.com> wrote:
> > >> BTW how about adding a new Kconfig option to hide the details of
> > >> ( BAR || !BAR) ? as Jason already explained and suggested, this will
> > >> make it easier for the users and developers to understand the actual
> > >> meaning behind this tristate weird condition.
> > >>
> > >> e.g have a new keyword:
> > >>      reach VXLAN
> > >> which will be equivalent to:
> > >>      depends on VXLAN && !VXLAN
> > >
> > > I'd love to see that, but I'm not sure what keyword is best. For your
> > > suggestion of "reach", that would probably do the job, but I'm not
> > > sure if this ends up being more or less confusing than what we have
> > > today.
> >
> > Ah, perfect bikeshedding topic!
> >
> > Perhaps "uses"? If the dependency is enabled it gets used as a
> > dependency.
> 
> That seems to be the best naming suggestion so far

What I don't like about "uses" is that it doesn't convey the conditional 
dependency. It could be mistaken as being synonymous to "select".

What about "depends_if" ? The rationale is that this is actually a 
dependency, but only if the related symbol is set (i.e. not n or empty).

> Right. OTOH whoever implements it gets to pick the color of the
> bikeshed. ;-)

Absolutely. But some brainstorming can't hurt.


Nicolas
