Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22C2856BB7
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbfFZORm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:17:42 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34052 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZORm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:17:42 -0400
Received: by mail-ed1-f67.google.com with SMTP id s49so3642460edb.1;
        Wed, 26 Jun 2019 07:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jz+d8Bq6px4B5hv9aLpu7uCGEvD+endKK7G195O5KL8=;
        b=Xpyj1SUPnpsE8OMNc9qWXya/cPkZB9lk6rT8T0PoUrlFKAxcKz4Yy7evwdpI1FOXdn
         FuO689CFG8+xvQfJoY34NLnEzKyE89bBKXy3vMTSJNuCPyh7U9nwu8I98fUrR0/nmcM5
         RjvASyRfbHLqGvhuA4sK/ktdvelXsXIYu9/yYn6C+eiAravBk/5asaEO0jtF9r0kxBrx
         Rrm0y7DRVVTF3MBy+0Qj86uUIeREEb4CBI0Yu/ayD40X+xQjB/jVWu2theWuOjmxxQxH
         xOksdgr/UaX3dHuv/qwlxewevbcc5oUZIjT3KkXAvEY5rDHZzTqatZMpIYe8I2x5fIhw
         td2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jz+d8Bq6px4B5hv9aLpu7uCGEvD+endKK7G195O5KL8=;
        b=aEAfjYE6mtZKAR+uYk4iL08csq26cBekfWzV8t99QYrdQEhYzMAcfwqnUBvuTRHO+o
         Q52UvOU1VgKDF8LYz8VxOQ4J45lFJ9gRcNf+OtUIi+FRnXxjautpnHe4WP4VaWCBaOMn
         jSgCgMDQPxZRojVD45/vFiYydlsrULfIqQ2603HSbI/A5AKwjrWZ2twgA1zCAYCQb08z
         gMNBBSGbf09ytopdbfiMDJoOb1q0PhFm2TvxHu3CukkA5smptxZaSnmSvDWy56Q8ymfE
         8KbAuZ4mPk/NcO7eCLUl+qsErDKhdWB9At4zscjwMU8UAr93ieiOn988mMJvyZ31lTGE
         5Yyg==
X-Gm-Message-State: APjAAAVw66aid8A2zeCNINZdyqoDsloPtUl9POjost7sbi7rFTQYtUqe
        7iQXpZK/aKpvXpdlFD8Yai3Q2kioU8BKBJFzJgI=
X-Google-Smtp-Source: APXvYqzrDNdvijzgbDqLjKhIz4Heet+Bul9RUJ3dxyVTIvG4efO+aI1oC/4DF9NAaTNa5V5XYDFtsZA2Eu41NOmx0z0=
X-Received: by 2002:a50:a53a:: with SMTP id y55mr5734894edb.147.1561558659862;
 Wed, 26 Jun 2019 07:17:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190624083352.29257-1-rasmus.villemoes@prevas.dk>
 <CA+FuTSeHhz1kntLyeUfAB4ZbtYjO1=Ornwse-yQbPwo5c-_2=g@mail.gmail.com> <ff8160d4-3357-9b4f-1840-bbe46195da5a@prevas.dk>
In-Reply-To: <ff8160d4-3357-9b4f-1840-bbe46195da5a@prevas.dk>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 26 Jun 2019 10:17:03 -0400
Message-ID: <CAF=yD-KyWJwdESFmY=CvbkTBT8yey2atKDY-tgd19yAeMf525g@mail.gmail.com>
Subject: Re: [PATCH net-next] can: dev: call netif_carrier_off() in register_candev()
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 5:31 AM Rasmus Villemoes
<rasmus.villemoes@prevas.dk> wrote:
>
> On 24/06/2019 19.26, Willem de Bruijn wrote:
> > On Mon, Jun 24, 2019 at 4:34 AM Rasmus Villemoes
> > <rasmus.villemoes@prevas.dk> wrote:
> >>
> >> CONFIG_CAN_LEDS is deprecated. When trying to use the generic netdev
> >> trigger as suggested, there's a small inconsistency with the link
> >> property: The LED is on initially, stays on when the device is brought
> >> up, and then turns off (as expected) when the device is brought down.
> >>
> >> Make sure the LED always reflects the state of the CAN device.
> >>
> >> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> >
> > Should this target net?
>
> No, I think this should go through the CAN tree. Perhaps I've
> misunderstood when to use the net-next prefix - is that only for things
> that should be applied directly to the net-next tree? If so, sorry.

I don't see consistent behavior on the list, so this is probably fine.
It would probably help to target can (for fixes) or can-next (for new
features).

Let me reframe the question: should this target can, instead of can-next?

> > Regardless of CONFIG_CAN_LEDS deprecation,
> > this is already not initialized properly if that CONFIG is disabled
> > and a can_led_event call at device probe is a noop.
>
> I'm not sure I understand this part. The CONFIG_CAN_LEDS support for
> showing the state of the interface is implemented via hooking into the
> ndo_open/ndo_stop callbacks, and does not look at or touch the
> __LINK_STATE_NOCARRIER bit at all.
>
> Other than via the netdev LED trigger I don't think one can even observe
> the slightly odd initial state of the __LINK_STATE_NOCARRIER bit for CAN
> devices,

it's still incorrect, though I guess that's moot in practice.

> which is why I framed this as a fix purely to allow the netdev
> trigger to be a closer drop-in replacement for CONFIG_CAN_LEDS.

So the entire CONFIG_CAN_LEDS code is to be removed? What exactly is
this netdev trigger replacement, if not can_led_event? Sorry, I
probably miss some context.
