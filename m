Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6008220099
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 00:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgGNW1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 18:27:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35682 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbgGNW1a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 18:27:30 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jvTOO-0057wB-Jb; Wed, 15 Jul 2020 00:27:16 +0200
Date:   Wed, 15 Jul 2020 00:27:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: microchip: look for phy-mode in port nodes
Message-ID: <20200714222716.GP1078057@lunn.ch>
References: <20200617082235.GA1523@laureti-dev>
 <20200714120827.GA7939@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714120827.GA7939@laureti-dev>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 02:08:28PM +0200, Helmut Grohne wrote:
> Documentation/devicetree/bindings/net/dsa/dsa.txt says that the phy-mode
> property should be specified on port nodes. However, the microchip
> drivers read it from the switch node.
> 
> Let the driver use the per-port property and fall back to the old
> location with a warning.
> 
> Fix in-tree users.

Hi Helmut

I think this change is more complex than it needs to be. Only the CPU
port supports different interface modes. So i don't see the need to
handle both dev->interface and p->interface. Just first search
ksz_switch_register() first look in the cpu port node, and if not
found go back to the old location. The rest of the code can stay the
same.

	Andrew
