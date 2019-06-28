Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E03765A597
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 22:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfF1UGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 16:06:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41734 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbfF1UGa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 16:06:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eFxYurngNB9thjDjZoKv0CgvUoLipNFN9ma3HIqZbB4=; b=F9Qu5N2ASGv7+O8j2PJ+rh2huC
        wlAIIONViKJsz8QoJr5+xojsQzcYONKjmTjrgKhBLedQgOFdXw2wqokTxITISf7L0WYvd43i8DeNL
        M1MyONOZZz2lozOk2NVaJ3/KKZVGo1dLPofmilwwTBoLLOviieazpQ2Z1S5//aeFkykI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hgx8e-0001Fu-Ia; Fri, 28 Jun 2019 22:06:28 +0200
Date:   Fri, 28 Jun 2019 22:06:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Catherine Sullivan <csully@google.com>, netdev@vger.kernel.org,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Subject: Re: [net-next 1/4] gve: Add basic driver framework for Compute
 Engine Virtual NIC
Message-ID: <20190628200628.GS27733@lunn.ch>
References: <20190626185251.205687-1-csully@google.com>
 <20190626185251.205687-2-csully@google.com>
 <20190626160832.3f191a53@cakuba.netronome.com>
 <CAH_-1qzzWVKxDX3LaorsgYPjT5uhDgqdN3oMZtJ2p6AzDqRyXA@mail.gmail.com>
 <20190628114615.4fc81791@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628114615.4fc81791@cakuba.netronome.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 11:46:15AM -0700, Jakub Kicinski wrote:
> On Fri, 28 Jun 2019 10:52:27 -0700, Catherine Sullivan wrote:
> > > > +if NET_VENDOR_GOOGLE
> > > > +
> > > > +config GVE
> > > > +     tristate "Google Virtual NIC (gVNIC) support"
> > > > +     depends on (PCI_MSI && X86)  
> > >
> > > We usually prefer for drivers not to depend on the platform unless
> > > really necessary, but IDK how that applies to the curious new world
> > > of NICs nobody can buy :)  
> > 
> > This is the only platform it will ever need to run on so we would really
> > prefer to not have to support others :)
> 
> I think the motivation is partially to force the uniform use of generic
> APIs across the drivers, so that re-factoring of core code is easier.
> Do you have any specific pain-points in mind where x86 dependency
> simplifies things? If not I think it's a better default to not have it.
> Not a big deal, though.

And maybe sometime in the future you might want to put this interface
in an ARM64 server?

One 'pain-paint' is that the driver might assume cache-coherency,
which is an x86 thing. If the generic APIs have been used, it should
not be an issue, but i've not spent the time to see if the DMA API has
been used correctly.

     Andrew
