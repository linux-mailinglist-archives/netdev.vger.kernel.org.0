Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D72547C6E
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 23:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236091AbiFLVYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 17:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235790AbiFLVYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 17:24:40 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F258237FF
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 14:24:38 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id w20so6067764lfa.11
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 14:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FyyYTHjRbLKqDj2XD2Ol0SA2EUt4GRQ6Iq2004ova5w=;
        b=lQPvOmJAzvz70+K5gdUBcporfTIIV8LdEccM6A0RFzfW8w+nZos3LQ7iy6FPdwTAqf
         qvHr3UVZ9IlJJdDpCutPlAnOZ/GZbgmOCNGS2I6wTdtehQuAID2a6u1+0pG5g843ePAo
         MBDwFtuKmm/3zsu6q/dpHNHHbAyBgPTujdipg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FyyYTHjRbLKqDj2XD2Ol0SA2EUt4GRQ6Iq2004ova5w=;
        b=zhRZUm/p8n43Nh5mwIgxrqAE6Yrpg4vVhCR1eAdGaR9TNrP8VXBbwuqH3PaOzaQhjc
         CBcG2Feo0s3o0OPskg4HN9JvncnRP8zifdFeld2KJtBC3YgOR3YZNj4HsfZx/XnvmdE3
         EfQgu6mb8wHaBQ10d/L+PIig00pCv20fVNKZFlZg9Gl270ugE3DXdspRgxW4t97qt3X2
         2jlXs2Q750ZNrgsW/1yPE4NDnsfKVPD4DKL9aXNuIFDbQhCd4yb1g4g6HVauxFLCLQDJ
         dDOBnVEa5ebhW7WMuQl3T43kJnTRtvWOfZHcXQ/m64ai2vOX3PNbcDew/izKNeTavQog
         USSw==
X-Gm-Message-State: AOAM533Nm9GyRi3+lkupzz2Ih3/mIhzDIqorNYns6PGhyHI7oIZ9k5AV
        S4yWEBgYytunie5XKU86KI/+O18Vgnvibs2bZbDGBQ==
X-Google-Smtp-Source: ABdhPJy5t8odWbkgN7xcAENqYqxbKE/ptg7q3OUdqkeyBFezTJs//Qc1bAYctIS+uVWCcjiNLLAZj3lUYzdgxcewn64=
X-Received: by 2002:ac2:4562:0:b0:478:f062:f85c with SMTP id
 k2-20020ac24562000000b00478f062f85cmr35438573lfm.662.1655069076715; Sun, 12
 Jun 2022 14:24:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
 <20220607094752.1029295-5-dario.binacchi@amarulasolutions.com>
 <20220607111330.tkpaplzeupfq3peh@pengutronix.de> <CABGWkvotv4Ebm7OSbp=oQ7vwHhR_=sXfAAEkngjLm2faYrUFPw@mail.gmail.com>
 <20220609070749.fjcqsw3nuolgr5wh@pengutronix.de>
In-Reply-To: <20220609070749.fjcqsw3nuolgr5wh@pengutronix.de>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Sun, 12 Jun 2022 23:24:25 +0200
Message-ID: <CABGWkvqZFdu--p+VcEAaFjno7wBuE8xchdFTSWQ7Us8LdAw5-A@mail.gmail.com>
Subject: Re: [RFC PATCH 04/13] can: slcan: use CAN network device driver API
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 9, 2022 at 9:07 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 08.06.2022 18:42:09, Dario Binacchi wrote:
> > > > In doing so, the struct can_priv::bittiming.bitrate of the driver is not
> > > > set and since the open_candev() checks that the bitrate has been set, it
> > > > must be a non-zero value, the bitrate is set to a fake value (-1) before
> > > > it is called.
> > >
> > > What does
> > >
> > > | ip --details -s -s link show
> > >
> > > show as the bit rate?
> >
> > # ip --details -s -s link show dev can0
>
> This is the bitrate configured with "ip"?
>
> >  can0: <NOARP,UP,LOWER_UP> mtu 16 qdisc pfifo_fast state UP mode
> > DEFAULT group default qlen 10
> >     link/can  promiscuity 0 minmtu 0 maxmtu 0
> >     can state ERROR-ACTIVE restart-ms 0
> >   bitrate 500000 sample-point 0.875
> >   tq 41 prop-seg 20 phase-seg1 21 phase-seg2 6 sjw 1
> >   slcan: tseg1 2..256 tseg2 1..128 sjw 1..128 brp 1..256 brp-inc 1
> >   clock 24000000
> >   re-started bus-errors arbit-lost error-warn error-pass bus-off
> >   0          0          0          0          0          0
> > numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
> >     RX: bytes  packets  errors  dropped overrun mcast
> >     292        75       0       0       0       0
> >     RX errors: length   crc     frame   fifo    missed
> >                0        0       0       0       0
> >     TX: bytes  packets  errors  dropped carrier collsns
> >     0          0        0       0       0       0
> >     TX errors: aborted  fifo   window heartbeat transns
> >                0        0       0       0       1
> >
> > And after applying your suggestions about using the CAN framework
> > support for setting the fixed bit rates (you'll
> > find it in V2), this is the output instead:
>
> This looks good.
>
> > # ip --details -s -s link show dev can0
> > 5: can0: <NOARP,UP,LOWER_UP> mtu 16 qdisc pfifo_fast state UP mode
> > DEFAULT group default qlen 10
> >     link/can  promiscuity 0 minmtu 0 maxmtu 0
> >     can state ERROR-ACTIVE restart-ms 0
> >   bitrate 500000
> >      [   10000,    20000,    50000,   100000,   125000,   250000,
> >         500000,   800000,  1000000 ]
> >   clock 0
> >   re-started bus-errors arbit-lost error-warn error-pass bus-off
> >   0          0          0          0          0          0
> > numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
> >     RX: bytes  packets  errors  dropped overrun mcast
> >     37307      4789     0       0       0       0
> >     RX errors: length   crc     frame   fifo    missed
> >                0        0       0       0       0
> >     TX: bytes  packets  errors  dropped carrier collsns
> >     7276       988      0       0       0       0
> >     TX errors: aborted  fifo   window heartbeat transns
> >                0        0       0       0       1
>
> Can you configure the bitrate with slcand and show the output of "ip
> --details -s -s link show dev can0". I fear it will show 4294967295 as
> the bitrate, which I don't like.
>

Yes, you are right.

> A hack would be to replace the -1 by 0 in the CAN netlink code.

You will find it in V3.

Thanks and regards,
Dario

>
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |



-- 

Dario Binacchi

Embedded Linux Developer

dario.binacchi@amarulasolutions.com

__________________________________


Amarula Solutions SRL

Via Le Canevare 30, 31100 Treviso, Veneto, IT

T. +39 042 243 5310
info@amarulasolutions.com

www.amarulasolutions.com
