Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C9C492D26
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 19:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347681AbiARSUp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Jan 2022 13:20:45 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:46835 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347657AbiARSUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 13:20:42 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 18338C0005;
        Tue, 18 Jan 2022 18:20:37 +0000 (UTC)
Date:   Tue, 18 Jan 2022 19:20:36 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v3 26/41] net: mac802154: Add a warning in the hot path
Message-ID: <20220118192036.7da9c51b@xps13>
In-Reply-To: <CAB_54W4EPDiEBHOFka99P5XF2O5gNxFhcWgjMgwaK58AcYr+Xw@mail.gmail.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
        <20220117115440.60296-27-miquel.raynal@bootlin.com>
        <CAB_54W4EPDiEBHOFka99P5XF2O5gNxFhcWgjMgwaK58AcYr+Xw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Mon, 17 Jan 2022 18:14:17 -0500:

> Hi,
> 
> On Mon, 17 Jan 2022 at 06:55, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > We should never start a transmission after the queue has been stopped.
> >
> > But because it might work we don't kill the function here but rather
> > warn loudly the user that something is wrong.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  net/mac802154/tx.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > index 18ee6fcfcd7f..de5ecda80472 100644
> > --- a/net/mac802154/tx.c
> > +++ b/net/mac802154/tx.c
> > @@ -112,6 +112,8 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
> >  static netdev_tx_t
> >  ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
> >  {
> > +       WARN_ON(mac802154_queue_is_stopped(local));
> > +  
> 
> we should do a WARN_ON_ONCE() in this hot function.

Sure!

Thanks,
Miquèl
