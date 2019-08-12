Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 197E889885
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 10:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfHLIPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 04:15:07 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:38985 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbfHLIPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 04:15:07 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 740C8C0010;
        Mon, 12 Aug 2019 08:15:02 +0000 (UTC)
Date:   Mon, 12 Aug 2019 10:15:01 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        sd@queasysnail.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com
Subject: Re: [PATCH net-next v2 6/9] net: macsec: hardware offloading
 infrastructure
Message-ID: <20190812081501.GD3698@kwain>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
 <20190810163423.GA30120@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190810163423.GA30120@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sat, Aug 10, 2019 at 06:34:23PM +0200, Andrew Lunn wrote:
> On Thu, Aug 08, 2019 at 04:05:57PM +0200, Antoine Tenart wrote:
> > This patch introduces the MACsec hardware offloading infrastructure.
> > 
> > The main idea here is to re-use the logic and data structures of the
> > software MACsec implementation. This allows not to duplicate definitions
> > and structure storing the same kind of information. It also allows to
> > use a unified genlink interface for both MACsec implementations (so that
> > the same userspace tool, `ip macsec`, is used with the same arguments).
> > The MACsec offloading support cannot be disabled if an interface
> > supports it at the moment.
> > 
> > The MACsec configuration is passed to device drivers supporting it
> > through macsec_hw_offload() which is called from the MACsec genl
> > helpers. This function calls the macsec ops of PHY and Ethernet
> > drivers in two steps
> 
> It is great that you are thinking how a MAC driver would make use of
> this. But on the flip side, we don't usual add an API unless there is
> a user. And as far as i see, you only add a PHY level implementation,
> not a MAC level.

That's right, and the only modification here is a simple patch adding
the MACsec ops within struct net_device. I can remove it as we do not
have providers as of now and it can be added easily later on.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
