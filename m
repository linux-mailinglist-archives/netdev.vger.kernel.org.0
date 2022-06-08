Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFF954394A
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245653AbiFHQm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245614AbiFHQmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:42:23 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7A2377EA
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:42:22 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id y32so34087022lfa.6
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 09:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rtvbbKja+RixG7eLu6aZGD6IZi/1ihppukZ37LTZ21o=;
        b=ZHhOkNzX2G0GXL04J/v1/pjgenn1QROUlIT0zdFiZ/K16NMBunyQxo2n8YEg/AIOz/
         52lMfP/EnZxT5OIEs4vtULdZzJFYhV8NazOyPYVeybryD2z7AT4EQftyniAyKstdOU2Q
         WXrnyiolXVyKCWQxM8OB26hIUiT+68DFy9Wl0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rtvbbKja+RixG7eLu6aZGD6IZi/1ihppukZ37LTZ21o=;
        b=bo9DyvGp7CkPsVBh0jjSGea4bpm32/1fOaOPAGrEry17jibvCpRQvk7ATG6ArxAJOp
         6QUJAanRuSrwJs88J7DKS/zmopSAQ+3iVUnF5ys9YN0/DDON34uyK3PGO2n5LVGkXsQU
         Y04Yc96UlM74ONZivsy1xnO7m5G35biK8sRie2TZOQnEe0RwnqlpdeLr2AdQK37UeBpb
         j2Wt8F1BR+oXDuKGQgnq8tXxAoJHiac3S6QPi1e6EKg3EU+sQP+7Mgpdd3HeLa0jACmS
         ouwMcUbCrGo5w0+xfxTp92cp8RRdKRkjDLOqj2sveTpA8ikn+t8BD6KQMYtEV6Q98zYU
         9+eQ==
X-Gm-Message-State: AOAM532wBFId1b6keTz+rrhS36VlnMODuVitsr556SGsEHBm4yOKBrOX
        MjlgSlT7j4ZETCw0o3ZmyMV2VbGFUVnDaVSBCWKwiw==
X-Google-Smtp-Source: ABdhPJx1uAzRSL7xtxPdEgqJWRJv8sD/eH7vAKsECzjBji+29coD64JBDzgESLeN6rGYED4yq4SDFG/QY/AVpRFA5BU=
X-Received: by 2002:a05:6512:10c5:b0:479:2de0:561c with SMTP id
 k5-20020a05651210c500b004792de0561cmr13376583lfg.536.1654706540474; Wed, 08
 Jun 2022 09:42:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
 <20220607094752.1029295-5-dario.binacchi@amarulasolutions.com> <20220607111330.tkpaplzeupfq3peh@pengutronix.de>
In-Reply-To: <20220607111330.tkpaplzeupfq3peh@pengutronix.de>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Wed, 8 Jun 2022 18:42:09 +0200
Message-ID: <CABGWkvotv4Ebm7OSbp=oQ7vwHhR_=sXfAAEkngjLm2faYrUFPw@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Tue, Jun 7, 2022 at 1:13 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 07.06.2022 11:47:43, Dario Binacchi wrote:
> > As suggested by commit [1], now the driver uses the functions and the
> > data structures provided by the CAN network device driver interface.
> >
> > There is no way to set bitrate for SLCAN based devices via ip tool, so
>   ^^^^^^^^^^^^^^^
> Currently the driver doesn't implement a way

Ok, I'll do it.

>
> > you'll have to do this by slcand/slcan_attach invocation through the
> > -sX parameter:
> >
> > - slcan_attach -f -s6 -o /dev/ttyACM0
> > - slcand -f -s8 -o /dev/ttyUSB0
> >
> > where -s6 in will set adapter's bitrate to 500 Kbit/s and -s8 to
> > 1Mbit/s.
> > See the table below for further CAN bitrates:
> > - s0 ->   10 Kbit/s
> > - s1 ->   20 Kbit/s
> > - s2 ->   50 Kbit/s
> > - s3 ->  100 Kbit/s
> > - s4 ->  125 Kbit/s
> > - s5 ->  250 Kbit/s
> > - s6 ->  500 Kbit/s
> > - s7 ->  800 Kbit/s
> > - s8 -> 1000 Kbit/s
> >
> > In doing so, the struct can_priv::bittiming.bitrate of the driver is not
> > set and since the open_candev() checks that the bitrate has been set, it
> > must be a non-zero value, the bitrate is set to a fake value (-1) before
> > it is called.
>
> What does
>
> | ip --details -s -s link show
>
> show as the bit rate?

# ip --details -s -s link show dev can0
 can0: <NOARP,UP,LOWER_UP> mtu 16 qdisc pfifo_fast state UP mode
DEFAULT group default qlen 10
    link/can  promiscuity 0 minmtu 0 maxmtu 0
    can state ERROR-ACTIVE restart-ms 0
  bitrate 500000 sample-point 0.875
  tq 41 prop-seg 20 phase-seg1 21 phase-seg2 6 sjw 1
  slcan: tseg1 2..256 tseg2 1..128 sjw 1..128 brp 1..256 brp-inc 1
  clock 24000000
  re-started bus-errors arbit-lost error-warn error-pass bus-off
  0          0          0          0          0          0
numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
    RX: bytes  packets  errors  dropped overrun mcast
    292        75       0       0       0       0
    RX errors: length   crc     frame   fifo    missed
               0        0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    0          0        0       0       0       0
    TX errors: aborted  fifo   window heartbeat transns
               0        0       0       0       1

And after applying your suggestions about using the CAN framework
support for setting the fixed bit rates (you'll
find it in V2), this is the output instead:

# ip --details -s -s link show dev can0
5: can0: <NOARP,UP,LOWER_UP> mtu 16 qdisc pfifo_fast state UP mode
DEFAULT group default qlen 10
    link/can  promiscuity 0 minmtu 0 maxmtu 0
    can state ERROR-ACTIVE restart-ms 0
  bitrate 500000
     [   10000,    20000,    50000,   100000,   125000,   250000,
        500000,   800000,  1000000 ]
  clock 0
  re-started bus-errors arbit-lost error-warn error-pass bus-off
  0          0          0          0          0          0
numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
    RX: bytes  packets  errors  dropped overrun mcast
    37307      4789     0       0       0       0
    RX errors: length   crc     frame   fifo    missed
               0        0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    7276       988      0       0       0       0
    TX errors: aborted  fifo   window heartbeat transns
               0        0       0       0       1

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
