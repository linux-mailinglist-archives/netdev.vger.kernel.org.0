Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BDF653A8A
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 03:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234908AbiLVCVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 21:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiLVCVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 21:21:51 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B549012D31;
        Wed, 21 Dec 2022 18:21:49 -0800 (PST)
Received: by mail-pl1-f171.google.com with SMTP id jn22so660510plb.13;
        Wed, 21 Dec 2022 18:21:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gui9TPCJOVUSUktjCWnA9zsRwJZwg7eNRroFbCCso00=;
        b=PwtQssrER1Bak+HFgsn7HPad9glUWB2ZB0kXKvRM2+bJlAHLMzmbSyaoFfEK9rmcDy
         Vhit0VQorDqqBMSfeg2ioCY72F2CEU2sQ53ZSfHpxs72DalX7ARQUMBWDrAMnsfAgWfc
         qNTDzSak4zc6QHTmAV/nPH0oY9Q5YMYrxRmL/baHv3xSMMsUEnnolyJaykXsE19NtKCo
         POYgq8GKsJfvxCi44n0mOkpZHs3IaioB0M+BtACn313g9Ss+U7WghRvo2S58Nyv2q4HR
         9QpplJYFXIDL7AtLEh4148XybBbgP0FZgpPoC40LlV+YgmB4dzokI5udp7zIbZaWs0DL
         lslg==
X-Gm-Message-State: AFqh2ko4a0/9e5r0Mdskoy+M7C71o0AgkxaqYAKTgIy1/CA2J3WNJazb
        Q7+ccVWEcz6MzO/MrePLOUzDrzRlA09vAyfCZ2Q=
X-Google-Smtp-Source: AMrXdXv1rnQAXO4HkXFTYrPkhRlLf2Zlbf3DOQ7vwwOi5DqymV0oCdfnVkEMF+CnNRt4BvUxmctu5g8D2lIwxNAwa0g=
X-Received: by 2002:a17:90a:d789:b0:221:4b1c:3b29 with SMTP id
 z9-20020a17090ad78900b002214b1c3b29mr361830pju.92.1671675709094; Wed, 21 Dec
 2022 18:21:49 -0800 (PST)
MIME-Version: 1.0
References: <20221219212717.1298282-1-frank.jungclaus@esd.eu>
 <CAMZ6RqKAmrgQUKLehUZx+hiSk3jD+o44uGtzrRFk+RBk8Bt81A@mail.gmail.com> <a1d253bacdf296947a45fb069a0fd64eabb7e117.camel@esd.eu>
In-Reply-To: <a1d253bacdf296947a45fb069a0fd64eabb7e117.camel@esd.eu>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 22 Dec 2022 11:21:38 +0900
Message-ID: <CAMZ6RqLeHNzZyKdCmqXDDtd5GZC8KZ0Y1hESYyPaaMbFe=ryYQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT
 event (2)
To:     Frank Jungclaus <Frank.Jungclaus@esd.eu>
Cc:     =?UTF-8?Q?Stefan_M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu. 22 Dec. 2022 at 03:42, Frank Jungclaus <Frank.Jungclaus@esd.eu> wrote:
> On Tue, 2022-12-20 at 14:49 +0900, Vincent MAILHOL wrote:
> > On Tue. 20 Dec. 2022 at 06:29, Frank Jungclaus <frank.jungclaus@esd.eu> wrote:
> > > Started a rework initiated by Vincents remarks "You should not report
> > > the greatest of txerr and rxerr but the one which actually increased."
> > > [1]
> >
> > I do not see this comment being addressed. You are still assigning the
> > flags depending on the highest value, not the one which actually
> > changed.
>
>
> Yes, I'm assigning depending on the highest value, but from my point of
> view doing so is analogue to what is done by can_change_state().

On the surface, it may look similar. But if you look into details,
can_change_state() is only called when there is a change on enum
can_state. enum can_state is the global state and does not
differentiate the RX and TX.

I will give an example. Imagine that:

  - txerr is 128 (ERROR_PASSIVE)
  - rxerr is 95 (ERROR_ACTIVE)

Imagine that rxerr then increases to 96. If you call
can_change_state() under this condition, the old state:
can_priv->state is still equal to the new one: max(tx_state, rx_state)
and you would get the oops message:

  https://elixir.bootlin.com/linux/latest/source/drivers/net/can/dev/dev.c#L100

So can_change_state() is indeed correct because it excludes the case
when the smallest err counter changed.

> And
> it should be fine, because e.g. my "case ESD_BUSSTATE_WARN:" is reached
> exactly once while the transition from ERROR_ACTIVE to
> ERROR_WARN. Than one of rec or tec is responsible for this
> transition.
> There is no second pass for "case ESD_BUSSTATE_WARN:"
> when e.g. rec is already on WARN (or above) and now tec also reaches
> WARN.
> Man, this is even difficult to explain in German language ;)

OK. This is new information. I agree that it should work. But I am
still puzzled because the code doesn't make this limitation apparent.

Also, as long as you have the rxerr and txerr value, you should still
be able to set the correct flag by comparing the err counters instead
of relying on your device events.

I am thinking of something like this:


  enum can_state can_get_state_from_err_cnt(u16 berr_counter)
  {
          if (berr_counter >= CAN_BUS_OFF_THRESHOLD)
                  return CAN_STATE_BUS_OFF;

          if (berr_counter >= CAN_ERROR_PASSIVE_THRESHOLD)
                  return CAN_STATE_ERROR_PASSIVE;

          if (berr_counter >= CAN_ERROR_WARNING_THRESHOLD)
                  return CAN_STATE_ERROR_WARNING;

          return CAN_STATE_ERROR_ACTIVE;
  }
  EXPORT_SYMBOL_GPL(can_get_state_from_err_cnt);

  void can_frame_set_error_status(struct net_device *dev, struct can_frame *cf,
                                  struct can_berr_counter *old_ctr,
                                  struct can_berr_counter *new_ctr)
  {
          enum can_state old_state, new_state;

          /* TX err cnt */
          old_state = can_get_state_from_err_cnt(old_ctr->txerr);
          new_state = can_get_state_from_err_cnt(new_ctr->txerr);
          if (old_state != new_state)
                  cf->data[1] |= can_tx_state_to_frame(dev, new_state);

          /* RX err cnt */
          old_state = can_get_state_from_err_cnt(old_ctr->rxerr);
          new_state = can_get_state_from_err_cnt(new_ctr->rxerr);
          if (old_state != new_state)
                  cf->data[1] |= can_rx_state_to_frame(dev, new_state);
  }
  EXPORT_SYMBOL_GPL(can_set_error_status);


If this looks good to you, I can put this in a patch (N.B. code not
tested! But should be enough for you to get the idea).

> >
> > > and "As far as I understand, those flags should be set only when
> > > the threshold is *reached*" [2] .
> > >
> > > Now setting the flags for CAN_ERR_CRTL_[RT]X_WARNING and
> > > CAN_ERR_CRTL_[RT]X_PASSIVE regarding REC and TEC, when the
> > > appropriate threshold is reached.
> > >
> > > Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
> > > Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> > > Link: [1] https://lore.kernel.org/all/CAMZ6RqKGBWe15aMkf8-QLf-cOQg99GQBebSm+1wEzTqHgvmNuw@mail.gmail.com/
> > > Link: [2] https://lore.kernel.org/all/CAMZ6Rq+QBO1yTX_o6GV0yhdBj-RzZSRGWDZBS0fs7zbSTy4hmA@mail.gmail.com/
> > > ---
> > >  drivers/net/can/usb/esd_usb.c | 14 ++++++++------
> > >  1 file changed, 8 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
> > > index 5e182fadd875..09745751f168 100644
> > > --- a/drivers/net/can/usb/esd_usb.c
> > > +++ b/drivers/net/can/usb/esd_usb.c
> > > @@ -255,10 +255,18 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
> > >                                 can_bus_off(priv->netdev);
> > >                                 break;
> > >                         case ESD_BUSSTATE_WARN:
> > > +                               cf->can_id |= CAN_ERR_CRTL;
> > > +                               cf->data[1] = (txerr > rxerr) ?
> > > +                                               CAN_ERR_CRTL_TX_WARNING :
> > > +                                               CAN_ERR_CRTL_RX_WARNING;
> >
> > Nitpick: when a ternary operator is too long to fit on one line,
> > prefer an if/else.
>
> AFAIR line length up to 120 chars is tolerated nowadays. So putting
> this on a single line might also be an option!(?)
> How will this be handled in the CAN sub tree?

Correct. The 120 is tolerated but the recommendation remains the 80
characters. I am not supportive of squeezing things and making this a
~120 characters line.

Also, this is a nitpick. I will not fight for you to change it. Just
be aware that there are often comments on the mailing list asking not
to use ternary operators (and I will not do an archivist job to find
such messages).

> >
> > >                                 priv->can.state = CAN_STATE_ERROR_WARNING;
> > >                                 priv->can.can_stats.error_warning++;
> > >                                 break;
> > >                         case ESD_BUSSTATE_ERRPASSIVE:
> > > +                               cf->can_id |= CAN_ERR_CRTL;
> > > +                               cf->data[1] = (txerr > rxerr) ?
> > > +                                               CAN_ERR_CRTL_TX_PASSIVE :
> > > +                                               CAN_ERR_CRTL_RX_PASSIVE;
> >
> > Same.
> >
> > >                                 priv->can.state = CAN_STATE_ERROR_PASSIVE;
> > >                                 priv->can.can_stats.error_passive++;
> > >                                 break;
> > > @@ -296,12 +304,6 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
> > >                         /* Bit stream position in CAN frame as the error was detected */
> > >                         cf->data[3] = ecc & SJA1000_ECC_SEG;
> > >
> > > -                       if (priv->can.state == CAN_STATE_ERROR_WARNING ||
> > > -                           priv->can.state == CAN_STATE_ERROR_PASSIVE) {
> > > -                               cf->data[1] = (txerr > rxerr) ?
> > > -                                       CAN_ERR_CRTL_TX_PASSIVE :
> > > -                                       CAN_ERR_CRTL_RX_PASSIVE;
> > > -                       }
> > >                         cf->data[6] = txerr;
> > >                         cf->data[7] = rxerr;
> > >                 }
> >
> > Yours sincerely,
> > Vincent Mailhol
