Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5421C27B858
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgI1Xjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725272AbgI1Xjj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 19:39:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 597D22076A;
        Mon, 28 Sep 2020 23:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601336378;
        bh=ew32vf9HT6hEsqVTupFdiSi7PiMcvwu3LlxtTWo7ERk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SFSvhj0qSnt11SH0mp5c3BKMT2pMYvVHp6x9kSRE3kRrKlqFpe9FA8UxeFZcKNaVE
         dBHGEK2IsTdd0jwkVCqpZDAtemRoF6tWHVeInK50hC9g1S5Xo5F86fdxzBJ7l0H1LO
         W6xeNUsMRc/eVo255WPk/xpU1Q4t7T251/fLG5aA=
Date:   Mon, 28 Sep 2020 16:39:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Message-ID: <20200928163936.1bdacb89@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <61860d84-d0c6-c711-0674-774149a8d0af@gmail.com>
References: <20200926210632.3888886-1-andrew@lunn.ch>
        <20200926210632.3888886-2-andrew@lunn.ch>
        <20200928143155.4b12419d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200928220507.olh77t464bqsc4ll@skbuf>
        <20200928220730.GD3950513@lunn.ch>
        <20200928153504.1b39a65d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <61860d84-d0c6-c711-0674-774149a8d0af@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Sep 2020 15:36:50 -0700 Florian Fainelli wrote:
> On 9/28/2020 3:35 PM, Jakub Kicinski wrote:
> > On Tue, 29 Sep 2020 00:07:30 +0200 Andrew Lunn wrote:  
> >> On Mon, Sep 28, 2020 at 10:05:08PM +0000, Vladimir Oltean wrote:  
> >>> On Mon, Sep 28, 2020 at 02:31:55PM -0700, Jakub Kicinski wrote:  
> >>>> On Sat, 26 Sep 2020 23:06:26 +0200 Andrew Lunn wrote:  
> >>>>> Not all ports of a switch need to be used, particularly in embedded
> >>>>> systems. Add a port flavour for ports which physically exist in the
> >>>>> switch, but are not connected to the front panel etc, and so are
> >>>>> unused.  
> >>>>
> >>>> This is missing the explanation of why reporting such ports makes sense.  
> >>>
> >>> Because this is a core devlink patch, we're talking really generalistic
> >>> here.  
> >>
> >> Hi Vladimir
> >>
> >> I don't think Jakub is questioning the why. He just wants it in the
> >> commit message.  
> > 
> > Ack, I think we need to clearly say when those should be exposed.
> > Most ASICs will have disabled ports, and we don't expect NICs to
> > suddenly start reporting ports for all PCI PFs they may have.
> > 
> > Also I keep thinking that these ports and all their objects should
> > be hidden under some switch from user space perspective because they
> > are unlikely to be valuable to see for a normal user. Thoughts?  
> 
> Hidden in what sense? They are already hidden in that there is no 
> net_device object being created for them. Are you asking for adding 
> another option to say, devlink show like:
> 
> devlink show -a
> 
> which would also show the ports that are disabled during a dump?

Yup, exactly. Looks like ip uses -a for something I don't quite
understand - but some switch along those lines. We already have 
-d for hiding less-relevant attributes.

Do you think this is an overkill? I don't feel strongly.
