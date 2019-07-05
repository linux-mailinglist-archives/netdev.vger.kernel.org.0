Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC59760A45
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 18:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbfGEQ3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 12:29:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57088 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfGEQ3f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 12:29:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/ataEGZSOL+nuZDsLx0axzYzlb6dLsffIscARtjpMwE=; b=uMOv6YBQleUehDC8E/SOVWjyJS
        Wii3q3OARflhOtXeZa+aiBZYZK+aofCJl6HFvrF4fXPKzNO2RI3rHBsVZN2DygUnKXH0pQjhXKb6B
        6+SZVAJblx5bQyYmySDtrtmBB79iDtH2r/i6MMz5WnuVYPCXnqkeR5UA2khh+47WzHiA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hjR5S-00035G-B0; Fri, 05 Jul 2019 18:29:26 +0200
Date:   Fri, 5 Jul 2019 18:29:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Matthias Kaehlcke <mka@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 1/7] dt-bindings: net: Add bindings for Realtek PHYs
Message-ID: <20190705162926.GM18473@lunn.ch>
References: <20190703193724.246854-1-mka@chromium.org>
 <CAL_JsqJdBAMPc1sZJfL7V9cxGgCb4GWwRokwJDmac5L2AO2-wg@mail.gmail.com>
 <20190703213327.GH18473@lunn.ch>
 <CAL_Jsq+dqz7n0_+Y5R4772-rh=9x=k20A69hnDwxH3OyZXQneQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+dqz7n0_+Y5R4772-rh=9x=k20A69hnDwxH3OyZXQneQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 05, 2019 at 10:17:16AM -0600, Rob Herring wrote:
> On Wed, Jul 3, 2019 at 3:33 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > I think if we're going to have custom properties for phys, we should
> > > have a compatible string to at least validate whether the custom
> > > properties are even valid for the node.
> >
> > Hi Rob
> >
> > What happens with other enumerable busses where a compatible string is
> > not used?
> 
> We usually have a compatible. USB and PCI both do. Sometimes it is a
> defined format based on VID/PID.

Hi Rob

Is it defined what to do with this compatible? Just totally ignore it?
Validate it against the hardware and warning if it is wrong? Force
load the driver that implements the compatible, even thought bus
enumeration says it is the wrong driver?

> > The Ethernet PHY subsystem will ignore the compatible string and load
> > the driver which fits the enumeration data. Using the compatible
> > string only to get the right YAML validator seems wrong. I would
> > prefer adding some other property with a clear name indicates its is
> > selecting the validator, and has nothing to do with loading the
> > correct driver. And it can then be used as well for USB and PCI
> > devices etc.
> 
> Just because Linux happens to not use compatible really has nothing to
> do with whether or not the nodes should have a compatible. What does
> FreeBSD want? U-boot?
> 
> I don't follow how adding a validate property would help. It would
> need to be 'validate-node-as-a-realtek-phy'.

This makes it clear it is all about validating the DT, and nothing
about the actual running hardware. What i don't really want to see is
the poorly defined situation that DT contains a compatible string, but
we have no idea what it is actually used for. See the question above.

     Andrew
