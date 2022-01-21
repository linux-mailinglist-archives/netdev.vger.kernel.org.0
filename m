Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE3649674E
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 22:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiAUVbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 16:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiAUVbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 16:31:37 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88A3C06173B;
        Fri, 21 Jan 2022 13:31:36 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id p5so31091332ybd.13;
        Fri, 21 Jan 2022 13:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XBPXrK5d4Q3kr1rY61LzklnjBEDewcTywkOFDOQFUkc=;
        b=emvhjIOrkbLkLK7QtoKAezEOQhTjn6XimYAssH9ANqpKpBVzZUO8qo+0n/4HO2bT1Z
         UjSa8pHCocY/PZZ6+ZCtgarsqa0yFJz/eZPsZL/6u2lnfFPukQKGRJzBGFpmd7mTz3CE
         qxcffHvPp3TSy2glIKET5KlOUENx/WHlbBKghYsVTWh+LF7YDkfiMzTz046rgztkBC04
         fo1wkJiOu8TPhz0Z7nnb3UvV/eUEqCz5KbjFsJ0fMljNbko+ecdjeSyEL2qJ9aCV/Wwj
         nvKmP1Sbu58tHUi5MlxcTI0fnjFeUexm1SH9g7bnkNp9f1aFkntCZisC5E7uZ1CHgwQP
         Y1xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XBPXrK5d4Q3kr1rY61LzklnjBEDewcTywkOFDOQFUkc=;
        b=kgzwdXvOMVWcjHe8XaM2KqI0soKO4m5k1F1mAppXisAfH9U6jhxrNRjlHv59u8ED5O
         fwKSOo3wQWEG0+zJGF8Uu2oY+URrFuHT5yZMRy7SBubLcFkFpu7mA9cRo/ja2EeBkyNJ
         i9TrKcBuEqDDUwHZ/2n638Dln/r4L8M2Bnsct/HsaW3+U6eMvnbW+hu3gqp2NMCpbQYf
         jYfTacFMKLSdP+YAtyibvj8OTYwLSV6wwGIbUdaWsiPaUbODHEyixsQKbwzw2aNRH1M5
         GVySLfhqCkJ5sNCnH4s+wMkokfY8L/ZY31VD/iUZppRgfQqe0hMf9BenlJEBDXN5y6NA
         ru+g==
X-Gm-Message-State: AOAM532siZoDg/VZgyytL3cmCaFwWP625dLFWQ5KRqMYayQHfGGXU10E
        6A6dFld98LOjlOkLQx8inCyQgrrSJ7LIk48seG8=
X-Google-Smtp-Source: ABdhPJyosNI2jZMZmoRBd1lV9OFcMO4zy4soqrSDlvOGhQfzpGgMz6abZEWFOYbXpjZQUo/KfutPdvtrvu84Z2WAEww=
X-Received: by 2002:a25:bd8d:: with SMTP id f13mr8920942ybh.573.1642800696041;
 Fri, 21 Jan 2022 13:31:36 -0800 (PST)
MIME-Version: 1.0
References: <20220121173622.192744-1-soenke.huster@eknoes.de> <4f3d6dcf-c142-9a99-df97-6190c8f2abc9@eknoes.de>
In-Reply-To: <4f3d6dcf-c142-9a99-df97-6190c8f2abc9@eknoes.de>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 21 Jan 2022 13:31:25 -0800
Message-ID: <CABBYNZ+VQ3Gfw0n=PavFhnnOy2=+1OAeV5UT_S25Lz_4gWzWEQ@mail.gmail.com>
Subject: Re: [RFC PATCH] Bluetooth: hci_event: Ignore multiple conn complete events
To:     =?UTF-8?Q?S=C3=B6nke_Huster?= <soenke.huster@eknoes.de>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi S=C3=B6nke,

On Fri, Jan 21, 2022 at 10:22 AM S=C3=B6nke Huster <soenke.huster@eknoes.de=
> wrote:
>
> I just noticed that just checking for handle does not work, as obviously =
0x0 could also be a handle value and therefore it can't be distinguished, w=
hether it is not set yet or it is 0x0.

Yep, we should probably check its state, check for state !=3D BT_OPEN
since that is what hci_conn_add initialize the state.

> On 21.01.22 18:36, Soenke Huster wrote:
> > When a HCI_CONNECTION_COMPLETE event is received multiple times
> > for the same handle, the device is registered multiple times which lead=
s
> > to memory corruptions. Therefore, consequent events for a single
> > connection are ignored.
> >
> > The conn->state can hold different values so conn->handle is
> > checked to detect whether a connection is already set up.
> >
> > Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=3D215497
> > Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
> > ---
> > This fixes the referenced bug and several use-after-free issues I disco=
vered.
> > I tagged it as RFC, as I am not 100% sure if checking the existence of =
the
> > handle is the correct approach, but to the best of my knowledge it must=
 be
> > set for the first time in this function for valid connections of this e=
vent,
> > therefore it should be fine.
> >
> > net/bluetooth/hci_event.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > index 681c623aa380..71ccb12c928d 100644
> > --- a/net/bluetooth/hci_event.c
> > +++ b/net/bluetooth/hci_event.c
> > @@ -3106,6 +3106,17 @@ static void hci_conn_complete_evt(struct hci_dev=
 *hdev, void *data,
> >               }
> >       }
> >
> > +     /* The HCI_Connection_Complete event is only sent once per connec=
tion.
> > +      * Processing it more than once per connection can corrupt kernel=
 memory.
> > +      *
> > +      * As the connection handle is set here for the first time, it in=
dicates
> > +      * whether the connection is already set up.
> > +      */
> > +     if (conn->handle) {
> > +             bt_dev_err(hdev, "Ignoring HCI_Connection_Complete for ex=
isting connection");
> > +             goto unlock;
> > +     }
> > +
> >       if (!ev->status) {
> >               conn->handle =3D __le16_to_cpu(ev->handle);
> >



--=20
Luiz Augusto von Dentz
