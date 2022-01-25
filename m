Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F03449B2BE
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 12:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380814AbiAYLNv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Jan 2022 06:13:51 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:46795 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380842AbiAYLLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 06:11:18 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E4114FF80E;
        Tue, 25 Jan 2022 11:10:42 +0000 (UTC)
Date:   Tue, 25 Jan 2022 12:10:41 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [wpan-next v2 6/9] net: ieee802154: Use the IEEE802154_MAX_PAGE
 define when relevant
Message-ID: <20220125121041.391d60c3@xps13>
In-Reply-To: <7287b3d9-dbdd-c2c3-01c7-1f272749ebb9@datenfreihafen.org>
References: <20220120112115.448077-1-miquel.raynal@bootlin.com>
        <20220120112115.448077-7-miquel.raynal@bootlin.com>
        <CAB_54W5DfNa8QSTiejL=1ywEShkK07bwvJeHkhcVowLtOtZrUw@mail.gmail.com>
        <7287b3d9-dbdd-c2c3-01c7-1f272749ebb9@datenfreihafen.org>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

stefan@datenfreihafen.org wrote on Mon, 24 Jan 2022 09:06:39 +0100:

> Hello.
> 
> On 23.01.22 21:44, Alexander Aring wrote:
> > Hi,
> > 
> > On Thu, 20 Jan 2022 at 06:21, Miquel Raynal <miquel.raynal@bootlin.com> wrote:  
> >>
> >> This define already exist but is hardcoded in nl-phy.c. Use the
> >> definition when relevant.
> >>
> >> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> >> ---
> >>   net/ieee802154/nl-phy.c | 5 +++--
> >>   1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/net/ieee802154/nl-phy.c b/net/ieee802154/nl-phy.c
> >> index dd5a45f8a78a..02f6a53d0faa 100644
> >> --- a/net/ieee802154/nl-phy.c
> >> +++ b/net/ieee802154/nl-phy.c
> >> @@ -30,7 +30,8 @@ static int ieee802154_nl_fill_phy(struct sk_buff *msg, u32 portid,
> >>   {
> >>          void *hdr;
> >>          int i, pages = 0;
> >> -       uint32_t *buf = kcalloc(32, sizeof(uint32_t), GFP_KERNEL);
> >> +       uint32_t *buf = kcalloc(IEEE802154_MAX_PAGE + 1, sizeof(uint32_t),
> >> +                               GFP_KERNEL);
> >>
> >>          pr_debug("%s\n", __func__);
> >>
> >> @@ -47,7 +48,7 @@ static int ieee802154_nl_fill_phy(struct sk_buff *msg, u32 portid,
> >>              nla_put_u8(msg, IEEE802154_ATTR_PAGE, phy->current_page) ||
> >>              nla_put_u8(msg, IEEE802154_ATTR_CHANNEL, phy->current_channel))
> >>                  goto nla_put_failure;
> >> -       for (i = 0; i < 32; i++) {
> >> +       for (i = 0; i <= IEEE802154_MAX_PAGE; i++) {
> >>                  if (phy->supported.channels[i])
> >>                          buf[pages++] = phy->supported.channels[i] | (i << 27);
> >>          }  
> > 
> > Where is the fix here?  
> 
> While its more cleanup than fix, its clear and easy and there is no problem for it to go into wpan instead of wpan-next.

As answered earlier, I will split the series so that it's clearer what
should go to wpan and what should go to wpan-next, no problem with that.

Thanks,
Miquèl
