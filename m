Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 995F75792A
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 03:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfF0B5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 21:57:12 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44214 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbfF0B5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 21:57:11 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so5421199edr.11;
        Wed, 26 Jun 2019 18:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+RYkXAvqY8Ibx3IpyCaGL2CQcHDuy3e5cBUf4u/Tp/M=;
        b=EKmuAx0YE8zGnIn16nAVwfLy8jupcGyNhEpKgRhlRVTs/JbVjBDzwFMLg8b5Thbjf3
         JBTkK0v4uy4NmZiGqSK3y5yNqqFCN6gh2y3rN/h+sIDsx6ingt26hFUTEZBH+Uq6oe10
         R94ppMNzcI1fJPqbM6Lx/UmigIJvy6v7kjnniG1IISPLU53pflf0DCNWx2dgZe841g9k
         NyELytBCDan+NYVVDzWlMmXkSVpDsfNxRpI9mm0IKihuSlXKtoE+skbdugYIJ8o1yNt6
         oV9oBOOys6tzr3B0lNmhmRcbKxrxWrqlVvx3ZyWdYiCLHxoV6Nm5glZyyZphJeU39ZOP
         PDPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+RYkXAvqY8Ibx3IpyCaGL2CQcHDuy3e5cBUf4u/Tp/M=;
        b=QrXeSlEwBr3vjJZ1Ae+de9HFVaaQqRAgFlDpc2KOHcdwX5MOgEF9hnBdDpHonfytOA
         7YHVwHoJiHIiIfTed8upPyJaW9aRl6k5Ub3qg/ZEHVwENtMRDm2Ea25/+gM2wYQsdXgs
         MpKUgdIz+JWfrTjOvNY0HWWD3n71OYn1nDS70ig1kEWW6cMUMYyGehZSuGM9+/VZXqLj
         SudEEKZn4Y2IM9c3k+4outSss8+5FwahXIKIDLPGi/PmLkuVuyi2U2n+IYg6zhSAj7tg
         VLB9lMrvQ8HnrwxCNolp52zVXpDNK94hvhpLB45zWq8FvXHvhWnKu+XjIdd1P6uJ9lwM
         j9OQ==
X-Gm-Message-State: APjAAAWi4W4Z78bDTRPF+RRCEbOoHpzhyGczlspZw0xsrWBwLhMxA30o
        Z6QYBuR9GTsrqhYPtnsX6QLOdNIFG0R/ElMH5u4=
X-Google-Smtp-Source: APXvYqxxvl9NPGvEuUHgHk0kixOVXn9H07WTnpiqX6Y5Ae5tVNuS4k9zysYn1D9KqeMJGvpUUZfpMlEU/0Qtlqwz1qE=
X-Received: by 2002:a50:b1db:: with SMTP id n27mr1094773edd.62.1561600628882;
 Wed, 26 Jun 2019 18:57:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190624083352.29257-1-rasmus.villemoes@prevas.dk>
 <CA+FuTSeHhz1kntLyeUfAB4ZbtYjO1=Ornwse-yQbPwo5c-_2=g@mail.gmail.com>
 <ff8160d4-3357-9b4f-1840-bbe46195da5a@prevas.dk> <CAF=yD-KyWJwdESFmY=CvbkTBT8yey2atKDY-tgd19yAeMf525g@mail.gmail.com>
 <838ce911-7205-f828-4fc5-79cebc32322a@prevas.dk>
In-Reply-To: <838ce911-7205-f828-4fc5-79cebc32322a@prevas.dk>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 26 Jun 2019 21:56:32 -0400
Message-ID: <CAF=yD-L5AmCeHiDA8RUr_E41FFzGdnudCVzTAHFi-Q1rHGPazQ@mail.gmail.com>
Subject: Re: [PATCH net-next] can: dev: call netif_carrier_off() in register_candev()
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 5:19 PM Rasmus Villemoes
<rasmus.villemoes@prevas.dk> wrote:
>
> On 26/06/2019 16.17, Willem de Bruijn wrote:
> > On Wed, Jun 26, 2019 at 5:31 AM Rasmus Villemoes
> > <rasmus.villemoes@prevas.dk> wrote:
> >>
> >> On 24/06/2019 19.26, Willem de Bruijn wrote:
> >>> On Mon, Jun 24, 2019 at 4:34 AM Rasmus Villemoes
> >>> <rasmus.villemoes@prevas.dk> wrote:
> >>>>
> >>>> Make sure the LED always reflects the state of the CAN device.
> >>>
> >>> Should this target net?
> >>
> >> No, I think this should go through the CAN tree. Perhaps I've
> >> misunderstood when to use the net-next prefix - is that only for things
> >> that should be applied directly to the net-next tree? If so, sorry.
> >
> > I don't see consistent behavior on the list, so this is probably fine.
> > It would probably help to target can (for fixes) or can-next (for new
> > features).
> >
> > Let me reframe the question: should this target can, instead of can-next?
>
> Ah, now I see what you meant, but at least I learned when to use
> net/net-next.
>
> I think can-next is fine, especially this late in the rc cycle. But I'll
> leave it to the CAN maintainer(s).
>
> >>> Regardless of CONFIG_CAN_LEDS deprecation,
> >>> this is already not initialized properly if that CONFIG is disabled
> >>> and a can_led_event call at device probe is a noop.
> >>
> >> I'm not sure I understand this part. The CONFIG_CAN_LEDS support for
> >> showing the state of the interface is implemented via hooking into the
> >> ndo_open/ndo_stop callbacks, and does not look at or touch the
> >> __LINK_STATE_NOCARRIER bit at all.
> >>
> >> Other than via the netdev LED trigger I don't think one can even observe
> >> the slightly odd initial state of the __LINK_STATE_NOCARRIER bit for CAN
> >> devices,
> >
> > it's still incorrect, though I guess that's moot in practice.
> Exactly.
>
> >> which is why I framed this as a fix purely to allow the netdev
> >> trigger to be a closer drop-in replacement for CONFIG_CAN_LEDS.
> >
> > So the entire CONFIG_CAN_LEDS code is to be removed? What exactly is
> > this netdev trigger replacement, if not can_led_event? Sorry, I
> > probably miss some context.
>
> drivers/net/can/Kconfig contains these comments
>
>         # The netdev trigger (LEDS_TRIGGER_NETDEV) should be able to do
>         # everything that this driver is doing. This is marked as broken
>         # because it uses stuff that is intended to be changed or removed.
>         # Please consider switching to the netdev trigger and confirm it
>         # fulfills your needs instead of fixing this driver.
>
> introduced by the commit 30f3b42147ba6 which also marked CONFIG_CAN_LEDS
> as (depends on) BROKEN. So while a .dts for using the CAN led trigger
> might be
>
>                 cana {
>                         label = "cana:green:activity";
>                         gpios = <&gpio0 10 0>;
>                         default-state = "off";
>                         linux,default-trigger = "can0-rxtx";
>                 };
>
> one can achieve mostly the same thing with CAN_LEDS=n,
> LEDS_TRIGGER_NETDEV=y setting linux,default-trigger = "netdev" plus a
> small init script (or udev rule or whatever works) that does
>
> d=/sys/class/leds/cana:green:activity
> echo can0 > $d/device_name
> echo 1 > $d/link
> echo 1 > $d/rx
> echo 1 > $d/tx
>
> to tie the cana LED to the can0 device, plus configure it to show "link"
> state as well as blink on rx and tx.
>
> This works just fine, except for the initial state of the LED. AFAIU,
> the netdev trigger doesn't need cooperation from each device driver
> since it simply works of a timer that periodically checks for changes in
> dev_get_stats().

Thanks, I had to read up on that code. Makes sense.

Acked-by: Willem de Bruijn <willemb@google.com>
