Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEEF146BF41
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238683AbhLGPa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:30:29 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:35496 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238536AbhLGPa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:30:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 22F34CE1B60;
        Tue,  7 Dec 2021 15:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD79C341C3;
        Tue,  7 Dec 2021 15:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638890815;
        bh=5D5Q1AmvtXjWARlnC0jaAsPw2A+t4G1gyWjnvNJtxBQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J5F72trxI0G/4O47+6LGt08h/XTE0C2/8PRM5IIGBvAiWmqqS+LdMeZ10Gmir4Alx
         nfVH0xG7gXOp5rHKmhXy7bzw6BmUXuCUhZ0fer723w4xi6BWXJ3Kzb0AeVTyu68yvO
         GRGYxMKGocZVch/NS1suDljy9j1pPmEkXIeDszeH7zAkR1QVORxgmYvHDqfDAJUptQ
         vPLKT2v3p7awUVyUzC/DpqNMDRtoOWV3BnStusTWhqSvqTKMAl3bvnizI1eNmCWVb1
         u2oIJMGPWda+I0ayBkY3D8xcq1H/wjbmlvBaNUjbijbki+4Z4zCiepHskkmnyKkPgd
         iL3XMkcpIEWMg==
Date:   Tue, 7 Dec 2021 07:26:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Colin Foster <colin.foster@in-advantage.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 net-next 5/5] net: mscc: ocelot: expose ocelot wm
 functions
Message-ID: <20211207072652.36827870@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211207121121.baoi23nxiitfshdk@skbuf>
References: <20211204182858.1052710-1-colin.foster@in-advantage.com>
        <20211204182858.1052710-6-colin.foster@in-advantage.com>
        <20211206180922.1efe4e51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <Ya9KJAYEypSs6+dO@shell.armlinux.org.uk>
        <20211207121121.baoi23nxiitfshdk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Dec 2021 12:11:22 +0000 Vladimir Oltean wrote:
> On Tue, Dec 07, 2021 at 11:48:52AM +0000, Russell King (Oracle) wrote:
> > Thank you for highlighting this.
> > 
> > Vladimir told me recently over the phylink get_interfaces vs get_caps
> > change for DSA, and I quote:
> > 
> >   David who applied your patch can correct me, but my understanding from
> >   the little time I've spent on netdev is that dead code isn't a candidate
> >   for getting accepted into the tree, even more so in the last few days
> >   before the merge window, from where it got into v5.16-rc1.
> >   ...
> >   So yes, I take issue with that as a matter of principle, I very much
> >   expect that a kernel developer of your experience does not set a
> >   precedent and a pretext for people who submit various shady stuff to the
> >   kernel just to make their downstream life easier.
> > 
> > This sounds very much like double-standards, especially as Vladimir
> > reviewed this.
> > 
> > I'm not going to be spiteful NAK these patches, because we all need to
> > get along with each other. I realise that it is sometimes useful to get
> > code merged that facilitates or aids further development - provided
> > that development is submitted in a timely manner.  
> 
> I'm not taking this as a spiteful comment either, it is a very fair point.
> Colin had previously submitted this as part of a 23-patch series and it
> was me who suggested that this change could go in as part of preparation
> work right away:
> https://patchwork.kernel.org/project/netdevbpf/cover/20211116062328.1949151-1-colin.foster@in-advantage.com/#24596529
> I didn't realize that in doing so with this particular change, we would
> end up having some symbols exported by the ocelot switch lib that aren't
> yet in use by other drivers. So yes, this would have to go in at the
> same time as the driver submission itself.

I don't know the dependencies here (there are also pinctrl patches 
in the linked series) so I'll defer to you, if there is a reason to
merge the unused symbols it needs to be spelled out, otherwise let's
drop the last patch for now.
