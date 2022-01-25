Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E2849B93E
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1585963AbiAYQu5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Jan 2022 11:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586511AbiAYQtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:49:43 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F76C06173B;
        Tue, 25 Jan 2022 08:48:55 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8F5E360009;
        Tue, 25 Jan 2022 16:48:51 +0000 (UTC)
Date:   Tue, 25 Jan 2022 17:48:49 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [wpan v3 1/6] net: ieee802154: hwsim: Ensure proper channel
 selection at probe time
Message-ID: <20220125174849.31501317@xps13>
In-Reply-To: <d3cab1bb-184d-73f9-7bd8-8eefc5e7e70c@datenfreihafen.org>
References: <20220125121426.848337-1-miquel.raynal@bootlin.com>
        <20220125121426.848337-2-miquel.raynal@bootlin.com>
        <d3cab1bb-184d-73f9-7bd8-8eefc5e7e70c@datenfreihafen.org>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

stefan@datenfreihafen.org wrote on Tue, 25 Jan 2022 15:28:11 +0100:

> Hello.
> 
> On 25.01.22 13:14, Miquel Raynal wrote:
> > Drivers are expected to set the PHY current_channel and current_page
> > according to their default state. The hwsim driver is advertising being
> > configured on channel 13 by default but that is not reflected in its own
> > internal pib structure. In order to ensure that this driver consider the
> > current channel as being 13 internally, we at least need to set the
> > pib->channel field to 13.
> > 
> > Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >   drivers/net/ieee802154/mac802154_hwsim.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
> > index 8caa61ec718f..00ec188a3257 100644
> > --- a/drivers/net/ieee802154/mac802154_hwsim.c
> > +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> > @@ -786,6 +786,7 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
> >   		goto err_pib;
> >   	}  
> >   > +	pib->page = 13;  
> 
> You want to set channel not page here.

Oh crap /o\ I've messed that update badly. Of course I meant
pib->channel here, as it is in the commit log.

I'll wait for Alexander's feedback before re-spinning. Unless the rest
looks good for you both, I don't know if your policy allows you to fix
it when applying, anyhow I'll do what is necessary.

Thanks,
Miquèl
