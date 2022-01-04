Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442A7484428
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbiADPFS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Jan 2022 10:05:18 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:46145 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbiADPFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 10:05:18 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 0BC1AFF809;
        Tue,  4 Jan 2022 15:05:14 +0000 (UTC)
Date:   Tue, 4 Jan 2022 16:05:13 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [net-next 08/18] net: ieee802154: Add support for internal PAN
 management
Message-ID: <20220104160513.220b2901@xps13>
In-Reply-To: <CAB_54W786n6_4FAMc7VMAX0nuyd6r2Hi+wYEEbd5Bjdrd8ArpA@mail.gmail.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
        <20211222155743.256280-9-miquel.raynal@bootlin.com>
        <CAB_54W786n6_4FAMc7VMAX0nuyd6r2Hi+wYEEbd5Bjdrd8ArpA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Tue, 28 Dec 2021 17:22:38 -0500:

> Hi,
> 
> On Wed, 22 Dec 2021 at 10:57, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Let's introduce the basics of PAN management:
> > - structures defining PANs
> > - helpers for PANs registration
> > - helpers discarding old PANs
> >  
> 
> I think there exists a little misunderstanding about how the
> architecture is between the structures wpan_phy, wpan_dev and
> cfg802154.
> 
>  - wpan_phy: represents the PHY layer of IEEE 802154 and is a
> registered device class.
>  - wpan_dev: represents the MAC layer of IEEE 802154 and is a netdev interface.
> 
> You can have multiple wpan_dev operate on one wpan_phy. To my best
> knowledge it's like having multiple access points running on one phy
> (wireless) or macvlan on ethernet. You can actually do that with the
> mac802154_hwsim driver. However as there exists currently no (as my
> knowledge) hardware which supports e.g. multiple address filters we
> wanted to be prepared for to support such handling. Although, there
> exists some transceivers which support something like a "pan bridge"
> which goes into such a direction.
> 
> What is a cfg802154 registered device? Well, at first it offers an
> interface between SoftMAC and HardMAC from nl802154, that's the
> cfg802154_ops structure. In theory a HardMAC transceiver would bypass
> the SoftMAC stack by implementing "cfg802154_ops" on the driver layer
> and try to do everything there as much as possible to support it. It
> is not a registered device class but the instance is tight to a
> wpan_phy. There can be multiple wpan_dev's (MAC layer instances on a
> phy/cfg802154 registered device). We currently don't support a HardMAC
> transceiver and I think because this misunderstanding came up.

Thanks for the explanation, I think it helps because the relationship
between wpan_dev and wpan_phy was not yet fully clear to me.

In order to clarify further your explanation and be sure that I
understand it the correct way, I tried to picture the above explanation
into a figure. Would you mind looking at it and tell me if something
does not fit?

https://bootlin.com/~miquel/ieee802154.pdf

Thanks,
Miquèl
