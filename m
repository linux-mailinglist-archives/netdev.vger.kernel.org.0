Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362CC50E126
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 15:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237049AbiDYNJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 09:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235807AbiDYNJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 09:09:09 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC33217E18;
        Mon, 25 Apr 2022 06:06:03 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id j4so1549017lfh.8;
        Mon, 25 Apr 2022 06:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/iuipTIr85z9Ry7b+hLDpi3xx0sswTNr1LXRa0/lOgw=;
        b=fdjhJ3vOP601i33FNSmI6Dv67D9wmS2cuQo5sf95mMqzRVqn0y11oysmC035jFLjaK
         rIzNDpq34wH3dHU6jQ/KkOyvTv18U0LtsfLq8IZqunQAV0t2HV1kRHJVKj9dMTgkkqru
         I/ktE+zcxcK2Soiyn7PQicVa1joZ1hgCj6ah4QpTyZBttuxZ/tcuV9/xR4myapTLNd74
         GbBZ1HFAlXPNNKHiOlfJCEmWlP5KtsFqpjMhAE7b+4++LacTMe75F8f+C1t8WmaOjJY0
         YoE5EzIhjExLEoFBH+eFS4XRiLxDPtHYrUcsH+k2SPrqk/zVQfzKc+6Kj1WknhWf436R
         MdvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/iuipTIr85z9Ry7b+hLDpi3xx0sswTNr1LXRa0/lOgw=;
        b=EF/Q9qEez/25XjQZpkPcOyjKTNpmPQYP3j2a422cKVzZGcbEL8pQ6mOPBFjcKsw6/o
         FnLUjzl5agQWNNjnE8uimPMtantKIqkcZxCuzzEEtH0J8yl/pi9ueqx0qbEKXypeVMsB
         5g/P/+myYkpZsZm/L+QMJjBrBF48LXR+ivkghvegcfADQxZ8sJ7nN5JQFTy3nNXDGXv+
         HTdgvCcEksJKhj5ho7vJ4mMkAMeo5l7ec2aAhB0Oel4M2IAiL5HHQGELKTTgNoK4KnrQ
         zAq3ecZaLhoRpoVlkoxq6nwcxJPT3LJN5roJJy6n/DUp1B+1gCXltqQjoZ42mFVGuPZN
         ChAw==
X-Gm-Message-State: AOAM530WpipQXc4+LQt2PdUML2Y63lhP+dIyWgLOLKi4F9mHjrZhebeD
        f2zFTQGSugsUf4ji6R1vgOuWrtE0m5ukiiiW+74=
X-Google-Smtp-Source: ABdhPJy3NUU+cYyK57zWY1LSg6EqgVJvq3DzMDa9sBKA+5nbVektwqdcqnWpVDGKfoOZE5FXrPX4smp3F9R7Ouwxjos=
X-Received: by 2002:a05:6512:15a0:b0:472:d09:a6b4 with SMTP id
 bp32-20020a05651215a000b004720d09a6b4mr1908073lfb.656.1650891961397; Mon, 25
 Apr 2022 06:06:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220406153441.1667375-1-miquel.raynal@bootlin.com>
 <20220406153441.1667375-10-miquel.raynal@bootlin.com> <CAB_54W4epiqcATJhLB9JDZPKGZTj_jbmVwDHRZT9MxtXY6g-QA@mail.gmail.com>
 <20220407100646.049467af@xps13> <CAB_54W5ovb9=rWB-H9oZygWuQpLSG58XFtgniNn9eDh51BBQNw@mail.gmail.com>
In-Reply-To: <CAB_54W5ovb9=rWB-H9oZygWuQpLSG58XFtgniNn9eDh51BBQNw@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 25 Apr 2022 09:05:49 -0400
Message-ID: <CAB_54W4X4--=kmXW-xtV5WiawP0s0UWSCZWb4U8wOR-xhhgR9g@mail.gmail.com>
Subject: Re: [PATCH v5 09/11] net: ieee802154: atusb: Call _xmit_error() when
 a transmission fails
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Apr 25, 2022 at 8:35 AM Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Thu, Apr 7, 2022 at 4:06 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >
> > alex.aring@gmail.com wrote on Wed, 6 Apr 2022 17:58:59 -0400:
> >
> > > Hi,
> > >
> > > On Wed, Apr 6, 2022 at 11:34 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > >
> > > > ieee802154_xmit_error() is the right helper to call when a transmission
> > > > has failed. Let's use it instead of open-coding it.
> > > >
> > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > ---
> > > >  drivers/net/ieee802154/atusb.c | 5 ++---
> > > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
> > > > index f27a5f535808..d04db4d07a64 100644
> > > > --- a/drivers/net/ieee802154/atusb.c
> > > > +++ b/drivers/net/ieee802154/atusb.c
> > > > @@ -271,9 +271,8 @@ static void atusb_tx_done(struct atusb *atusb, u8 seq)
> > > >                  * unlikely case now that seq == expect is then true, but can
> > > >                  * happen and fail with a tx_skb = NULL;
> > > >                  */
> > > > -               ieee802154_wake_queue(atusb->hw);
> > > > -               if (atusb->tx_skb)
> > > > -                       dev_kfree_skb_irq(atusb->tx_skb);
> > > > +               ieee802154_xmit_error(atusb->hw, atusb->tx_skb,
> > > > +                                     IEEE802154_SYSTEM_ERROR);
> > >
> > > That should then call the xmit_error for ANY other reason which is not
> > > 802.15.4 specific which is the bus_error() function?
> >
> > I'll drop the bus error function so we can stick to a regular
> > _xmit_error() call.
> >
>
> Okay, this error is only hardware related.
>
> > Besides, we do not have any trac information nor any easy access to
> > what failed exactly, so it's probably best anyway.
>
> This is correct, Somebody needs to write support for it for atusb firmware. [0]
> However some transceivers can't yet or will never (because lack of
> functionality?) report such errors back... they will act a little bit
> weird.
>
> However, this return value is a BIG step moving into the right
> direction that other drivers can follow.
>
> I think for MLME ops we can definitely handle some transmit errors now
> and retry so that we don't wait for anything when we know the
> transceiver was never submitting.
>

s/submitting/transmitted/

I could more deeper into that topic:

1.

In my opinion this result value was especially necessary for MLME-ops,
for others which do not directly work with MAC... they provide an
upper layer protocol if they want something reliable.

2.

Later on we can do statistics like what was already going around in
the linux-wpan community to have something like whatever dump to see
all neighbors and see how many ack failures there, etc. Some people
want to make some predictions about link quality here. The kernel
should therefore only capture some stats and the $WHATEVER userspace
capable netlink monitor daemon should make some heuristic by dumping
those stats.

3.

Sometimes even IP capable protocols (using 6LoWPAN) want to know if
ack was received or not, as mentioned. But this required additional
handling in the socket layers... I didn't look into that topic yet but
I know wireless solved it because they have some similar problems.

- Alex
