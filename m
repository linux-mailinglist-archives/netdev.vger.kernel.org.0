Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2DC653A2D
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 01:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234861AbiLVArD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 19:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLVArC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 19:47:02 -0500
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6A2314;
        Wed, 21 Dec 2022 16:47:00 -0800 (PST)
Received: by mail-pg1-f180.google.com with SMTP id s196so340969pgs.3;
        Wed, 21 Dec 2022 16:47:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D8q+249haixB7NYYpN2RHdBV90bkuxv5Hi/JR+Cotic=;
        b=nZnvQnYyKBPQ78V++T6KAA8f45BHvb42rwZpNa9fV9dreFM5M7b9Tkp6HqOIIXcXEs
         xaxBd45I7HNdNoyUUropgssACIvicc5TiufGRlFakCKNljlOHu8NkMA0BHL8sJJyBlzl
         BMLNksaIqHCd5FDXeQfXr6FU/qMZdhc0mpRRDfu0vEAKPX2u3Nr6A+Kaux5SUeOd0rhZ
         0ki/PfzWWczSHOUfsWEFMs4LnAM2cyldayTrv54KpfZN3lS2dZ5QHQzM4mjr1b17nbis
         +OM4sd2t0UHBqMZObKhynInvRA4euk5d2uCeUduaizHA28dGRQ2G6Cg8k5ZF37D+8vIg
         k8Sg==
X-Gm-Message-State: AFqh2kosjtHVI60oubhstzz6BE1TCbII9qV5IuT4fEyz49TPb3BWq7fM
        scmkzKLClDptSTby+YVeUblaUkrXYZORB56dgrEp1q318CI=
X-Google-Smtp-Source: AMrXdXvRy0gMj7jpUxsIu5yTJZvAgCC1niu1PLKOOTN9T/h4F8EvgV2okW2zQLST6MZvo/mVilmodZPyvtWKFIa0o/g=
X-Received: by 2002:a05:6a00:3387:b0:572:7c58:540 with SMTP id
 cm7-20020a056a00338700b005727c580540mr238341pfb.69.1671670019429; Wed, 21 Dec
 2022 16:46:59 -0800 (PST)
MIME-Version: 1.0
References: <20221219212013.1294820-1-frank.jungclaus@esd.eu>
 <20221219212013.1294820-2-frank.jungclaus@esd.eu> <CAMZ6RqKc0mvfQGEGb7gCE69Mskhzq5YKF88Jhe+1VR=43YW3Xg@mail.gmail.com>
 <f9c68625149673fec635d64a21608f3b53866cd7.camel@esd.eu>
In-Reply-To: <f9c68625149673fec635d64a21608f3b53866cd7.camel@esd.eu>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 22 Dec 2022 09:46:48 +0900
Message-ID: <CAMZ6RqL+7zLLkL_bXAR0iwk6XH_7F_-t472vnq_-jMgT4XC6UA@mail.gmail.com>
Subject: Re: [PATCH 1/3] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT
 event (1)
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 22 Dec. 2022 at 02:55, Frank Jungclaus <Frank.Jungclaus@esd.eu> wrote:
> On Tue, 2022-12-20 at 14:16 +0900, Vincent MAILHOL wrote:
> > On Tue. 20 Dec. 2022 at 06:25, Frank Jungclaus <frank.jungclaus@esd.eu> wrote:
> > >
> > > Moved the supply for cf->data[3] (bit stream position of CAN error)
> > > outside of the "switch (ecc & SJA1000_ECC_MASK){}"-statement, because
> > > this position is independent of the error type.
> > >
> > > Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
> > > Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> > > ---
> > >  drivers/net/can/usb/esd_usb.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
> > > index 42323f5e6f3a..5e182fadd875 100644
> > > --- a/drivers/net/can/usb/esd_usb.c
> > > +++ b/drivers/net/can/usb/esd_usb.c
> > > @@ -286,7 +286,6 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
> > >                                 cf->data[2] |= CAN_ERR_PROT_STUFF;
> > >                                 break;
> > >                         default:
> > > -                               cf->data[3] = ecc & SJA1000_ECC_SEG;
> > >                                 break;
> > >                         }
> > >
> > > @@ -294,6 +293,9 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
> > >                         if (!(ecc & SJA1000_ECC_DIR))
> > >                                 cf->data[2] |= CAN_ERR_PROT_TX;
> > >
> > > +                       /* Bit stream position in CAN frame as the error was detected */
> > > +                       cf->data[3] = ecc & SJA1000_ECC_SEG;
> >
> > Can you confirm that the value returned by the device matches the
> > specifications from linux/can/error.h?
>
> The value returned is supposed to be compatible to the SJA1000 ECC
> register.
>
> See
> https://esd.eu/fileadmin/esd/docs/manuals/NTCAN_Part1_Function_API_Manual_en_56.pdf
>
> Chapter "6.2.10 EV_CAN_ERROR_EXT" (page 185)
> and
> "Annex B: Bus Error Code" table 37 and 38 (page 272 and following).
>
> So this should be compliant with the values given in linux/can/error.h.

Thanks for the link. It is indeed compliant.

Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

> >   https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/can/error.h#L90
> >
> > >                         if (priv->can.state == CAN_STATE_ERROR_WARNING ||
> > >                             priv->can.state == CAN_STATE_ERROR_PASSIVE) {
> > >                                 cf->data[1] = (txerr > rxerr) ?
> > > --
> > > 2.25.1
> > >
>
