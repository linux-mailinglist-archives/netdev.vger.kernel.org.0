Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F79B612CF9
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 22:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiJ3VWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 17:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiJ3VWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 17:22:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65C1A181
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 14:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xWlWitXqrchjPrfUBYTswcryjzyQkx/XvuMFbUgFbj8=; b=ptdun4eU69Og+tAJbRIidtBVlK
        rMNo/bnvy0FP+M2YCgUNV1JcfD2kZKiRSDQsmUHJe+qHVl6KpnQOjOfA+mA/nbYt+JeLiZjPn7UXj
        fGH7VbTmWk1BbOSNuhlCOU6Imt3px/U1x1esFiLzjlB1LiUqtPTdlndLkdONH3B3hmmU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1opFlB-000yeQ-M9; Sun, 30 Oct 2022 22:22:25 +0100
Date:   Sun, 30 Oct 2022 22:22:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Michael Walle <michael@walle.cc>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: Re: [RFC PATCH net-next 0/3] Autoload DSA tagging driver when
 dynamically changing protocol
Message-ID: <Y17rEVzO2w1RslrV@lunn.ch>
References: <20221027210830.3577793-1-vladimir.oltean@nxp.com>
 <2bad372ce42a06254c7767fd658d2a66@walle.cc>
 <20221028092840.bprd37sn6nxwvzww@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028092840.bprd37sn6nxwvzww@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 09:28:41AM +0000, Vladimir Oltean wrote:
> On Fri, Oct 28, 2022 at 11:17:40AM +0200, Michael Walle wrote:
> > >   alias:          dsa_tag-ocelot-8021q
> > >   alias:          dsa_tag-20
> > 
> > I know that name clashes are not to be expected because one is a numerical id
> > and the other is a string, but it might still make sense to have a different
> > prefix so the user of modinfo can figure that out more easily.
> > 
> > Presuming that backwards compatibility is not an issue, maybe:
> > dsa_tag-ocelot-8021q
> > dsa_tag-id-20
> 
> Hm, it probably isn't an issue, but I'd like to hear from
> Andrew/Florian/Vivien as well?

I don't see it being a big issue either way. This is not ABI, as
Vladimir points out. These module strings are also somewhat black
magic:

pci:v00001269d000000BBsv*sd*bc*sc*i*
usb:v17E9p*d*dc*dsc*dp*icFFisc00ip00in*
virtio:d00000005v*
pcmcia:m*c*f02fn*pfn*pa*pb*pc*pd*
acpi*:TPF0001:*

I don't think they are meant to be human readable.

I do however wounder if they should be dsa_tag:ocelot-8021q,
dsa_tag:20 ?

	   Andrew
