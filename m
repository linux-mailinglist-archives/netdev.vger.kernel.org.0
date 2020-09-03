Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F046C25CD0D
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 00:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgICWDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 18:03:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41650 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbgICWDE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 18:03:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kDxJs-00D71Z-Rg; Fri, 04 Sep 2020 00:03:00 +0200
Date:   Fri, 4 Sep 2020 00:03:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: bcm_sf2: Ensure that MDIO diversion
 is used
Message-ID: <20200903220300.GH3112546@lunn.ch>
References: <20200902210328.3131578-1-f.fainelli@gmail.com>
 <20200903011324.GE3071395@lunn.ch>
 <28177f17-1557-bd69-e96b-c11c39d71145@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28177f17-1557-bd69-e96b-c11c39d71145@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The firmware provides the Device Tree but here is the relevant section for
> you pasted below. The problematic device is a particular revision of the
> silicon (D0) which got later fixed (E0) however the Device Tree was created
> after the fixed platform, not the problematic one. Both revisions of the
> silicon are in production.
> 
> There should have been an internal MDIO bus created for that chip revision
> such that we could have correctly parented phy@0 (bcm53125 below) as child
> node of the internal MDIO bus, but you have to realize that this was done
> back in 2014 when DSA was barely revived as an active subsystem. The
> BCM53125 node should have have been converted to an actual switch node at
> some point, I use a mdio_boardinfo overlay downstream to support the switch
> as a proper b53/DSA switch, anyway.

I was expecting something like that. I think this patch needs a
comment in the code explaining it is a workaround for a DT blob which
cannot be changed. Maybe also make it conditional on the board
compatible string?

Thanks
	Andrew
