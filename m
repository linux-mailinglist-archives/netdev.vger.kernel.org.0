Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3BA261D0D
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731101AbgIHTbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730938AbgIHTaj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 15:30:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 644222078E;
        Tue,  8 Sep 2020 19:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599593438;
        bh=GDfjYWhyymA1/5HL9dC27Ql5pXoa70KT4y1y1TOnti8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sTlrE5cOrg1HldMmcXwb6L3AojDFqEvIMf4M9MCT4vSto6fcXrXRGoFselkk/LWF7
         qOWd1a8odz+xh4DHujke/jSgjz0x5Ac68BTXpF2YAhq28IEiAIDhbwOgGeAZs/j4FR
         O/o+3gygWHHgKhhWleyoTGDV5HjTsYsKn4RhKgIA=
Date:   Tue, 8 Sep 2020 12:30:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next v2 5/7] net: dsa: mv88e6xxx: Add devlink
 regions
Message-ID: <20200908123036.0d879b57@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200908192231.GB3290129@lunn.ch>
References: <20200908005155.3267736-1-andrew@lunn.ch>
        <20200908005155.3267736-6-andrew@lunn.ch>
        <20200908120100.77cfcfa1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200908192231.GB3290129@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Sep 2020 21:22:31 +0200 Andrew Lunn wrote:
> On Tue, Sep 08, 2020 at 12:01:06PM -0700, Jakub Kicinski wrote:
> > On Tue,  8 Sep 2020 02:51:53 +0200 Andrew Lunn wrote:  
> > > Allow ports, the global registers, and the ATU to be snapshot via
> > > devlink regions.
> > > 
> > > v2:
> > > Remove left over debug prints
> > > Comment ATU format is generic for mv88e6xxx, not wider
> > > 
> > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>  
> > 
> > Probably best CCing devlink maintainers on devlink patches.
> > 
> > Also - it's always useful to include show command outputs in the commit
> > message for devlink patches.  
> 
> Hi Jakub
> 
> root@rap:~# devlink region dump mdio_bus/gpio-0:00/port5 snapshot 42
> 0000000000000000 0f 10 03 00 00 00 01 39 7c 00 00 00 df 07 01 00 
> 0000000000000010 80 20 01 00 00 80 20 00 00 00 00 00 00 00 00 91 
> 0000000000000020 00 00 00 00 00 00 00 00 00 00 00 00 22 00 00 00 
> 0000000000000030 00 00 00 00 c0 01 00 80 00 00 00 00 00 00 00 00 
> 
> Not very informative. The whole point of devlink regions is that they
> are suppose to be specific to a device, and you need intimate
> knowledge of the device to decode it.

I meant the list of regions the device would create.

> > > +PORT_REGION_OPS(0);
> > > +PORT_REGION_OPS(1);
> > > +PORT_REGION_OPS(2);
> > > +PORT_REGION_OPS(3);
> > > +PORT_REGION_OPS(4);
> > > +PORT_REGION_OPS(5);
> > > +PORT_REGION_OPS(6);
> > > +PORT_REGION_OPS(7);
> > > +PORT_REGION_OPS(8);
> > > +PORT_REGION_OPS(9);
> > > +PORT_REGION_OPS(10);
> > > +PORT_REGION_OPS(11);
> > > +
> > > +static const struct devlink_region_ops *mv88e6xxx_region_port_ops[] = {
> > > +	&mv88e6xxx_region_port_0_ops,
> > > +	&mv88e6xxx_region_port_1_ops,
> > > +	&mv88e6xxx_region_port_2_ops,
> > > +	&mv88e6xxx_region_port_3_ops,
> > > +	&mv88e6xxx_region_port_4_ops,
> > > +	&mv88e6xxx_region_port_5_ops,
> > > +	&mv88e6xxx_region_port_6_ops,
> > > +	&mv88e6xxx_region_port_7_ops,
> > > +	&mv88e6xxx_region_port_8_ops,
> > > +	&mv88e6xxx_region_port_9_ops,
> > > +	&mv88e6xxx_region_port_10_ops,
> > > +	&mv88e6xxx_region_port_11_ops,
> > > +};  
> > 
> > Ahh, seems like regions will get a per-port incarnation as some point as
> > well..  
> 
> Again, i think this is back to the history of dumping firmware core.
> I guess the existing users don't have per port CPUs which could dump a
> core.

Ack, I'm referring to the fact that we recently converted health
reporters to per-port and now traps are getting the same treatment.
