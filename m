Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5C04A8471
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 14:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350687AbiBCNEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 08:04:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40760 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236030AbiBCNEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 08:04:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gNZWKIVJLKNO/IJY+cF5TQndrBUPBqO7gHfrucPm70E=; b=VS8tdWHewiArNhUVu6VGqBayCE
        6h7xECrvPRTVJOY5on5d/h21a7hWmC/n657vSzkE4eWdWBUNblNqgCLGnE3IlOE3A3Ad57uK+qonu
        cgl/iVYfynfK/gu5rwOril0Ka92vyY18ATTgu7SUFt+dGvAKzzeWegqE2QFGq4m10SKg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nFbmm-004757-1e; Thu, 03 Feb 2022 14:04:28 +0100
Date:   Thu, 3 Feb 2022 14:04:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, kernel@pengutronix.de,
        open list <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        devicetree <devicetree@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v1 4/4] usbnet: add support for label from
 device tree
Message-ID: <YfvS3F6kHUyxs6D0@lunn.ch>
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <20220127104905.899341-5-o.rempel@pengutronix.de>
 <YfJ6lhZMAEmetdad@kroah.com>
 <20220127112305.GC9150@pengutronix.de>
 <YfKCTG7N86yy74q+@kroah.com>
 <20220127120039.GE9150@pengutronix.de>
 <YfKcYXjfhVKUKfzY@kroah.com>
 <CAHNKnsTY0cV4=V7t0Q3p4-hO5t9MbWWM-X0MJFRKCZ1SG0ucUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHNKnsTY0cV4=V7t0Q3p4-hO5t9MbWWM-X0MJFRKCZ1SG0ucUg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 05:20:34AM +0300, Sergey Ryazanov wrote:
> Hello Greg,
> 
> if I may be allowed, I would like to make a couple of points about
> specifying network interface names in DT. As in previous mail, not to
> defend this particular patch, but to talk about names assignment in
> general.
> 
> I may be totally wrong, so consider my words as a request for
> discussion. I have been thinking about an efficient way for network
> device names assignment for routers with a fixed configuration and
> have always come to a conclusion that DT is a good place for names
> storage. Recent DSA capability to assign names from labels and this
> patch by Oleksij show that I am not alone.

DSA doing this is not recent. The first patch implementing DSA in 2008
had the ability to set the interface names. This was long before the
idea that userspace should set interface names became the 'correct'
way to do this.

The current thinking for routers which don't make use of the DSA
framework, it to use interface names like swXpY, where X is the switch
number and Y is the port number. udev can make use of for example
/sys/class/net/*/phys_port_name to get the pY bit to give the
interface its full name.

	Andrew
