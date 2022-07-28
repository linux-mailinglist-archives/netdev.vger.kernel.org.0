Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03E1583BF5
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 12:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235885AbiG1KXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 06:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiG1KXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 06:23:18 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF854F65C
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 03:23:17 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id d17so2133594lfa.12
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 03:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yMZGifoUNXOtUdS4KlzIsHVx4WHyBaSbYfIRmilRvlA=;
        b=mjgVxSDm+fYEWn4vCVM3rACA/ySjzsyesKlU1sEiDPEb9FYZBRorT+TMhNwxwuhKIW
         CSNkjDmJbYMmb/lLMqtIDa2jThXlXg7KDzoXuaRObv4+WFye8Azufk5jXHm48pcpSvaV
         s03fHw+ZpdF7H+pryOufOwPzrTI0qXNXv/LVg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yMZGifoUNXOtUdS4KlzIsHVx4WHyBaSbYfIRmilRvlA=;
        b=MDORdmBOVgIfMZVxXBNlV4Du3MN9Tb+G2NRSjnG+PkKzFMX18i2KBSeg1jgKMplR5G
         EckNTCGCsV2+rcIdqu+XN0Ue/GllyYlfBcs6XO5sV5g+TLIFj//NsItCqYImZt33XKE0
         Wk5F85H9voDZ92yMMUYfSdWgXx0zShHQE3rfEmmyy9yPhkddClcyXISd7yCtN3S3veGj
         gs682qaP2hxYBVi0LutLogTuU598dGM2FvIcch99F+dDfBebSDHOfD2Q9S/zvzk0aU3y
         O/wRQLw2tDxWkWpEimxY5GdyTS6xjgVG/5/8wBwTxFX71W2gbREydJIEWX2wbuv8Va+d
         iLlQ==
X-Gm-Message-State: AJIora/RUAg+dFefNhiVIYVyzV8mZClew4Z0sGnsq+82sofThN/NJHcC
        BUZGGSmCOFVXWGQ0IQ+zmiL6PzzJpt5o0nRy3r1WHw==
X-Google-Smtp-Source: AGRyM1sQ94bkl3cSe4sS2qJv4YReX+VPVipCTj//NNAY/XHi3A7GR63/Gi8RtDRY2/sI20zjM0OWhcOQDqWq/QV+9qM=
X-Received: by 2002:a05:6512:3503:b0:48a:6060:5ebb with SMTP id
 h3-20020a056512350300b0048a60605ebbmr8980945lfs.429.1659003795334; Thu, 28
 Jul 2022 03:23:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
 <20220726210217.3368497-9-dario.binacchi@amarulasolutions.com>
 <20220727113054.ffcckzlcipcxer2c@pengutronix.de> <20220727192839.707a3453.max@enpas.org>
 <20220727182414.3mysdeam7mtnqyfx@pengutronix.de> <CABGWkvoE8i--g_2cNU6ToAfZk9WE6uK-nLcWy7J89hU6RidLWw@mail.gmail.com>
 <20220728090228.nckgpmfe7rpnfcyr@pengutronix.de>
In-Reply-To: <20220728090228.nckgpmfe7rpnfcyr@pengutronix.de>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Thu, 28 Jul 2022 12:23:04 +0200
Message-ID: <CABGWkvoYR67MMmqZ6bRLuL3szhVb-gMwuAy6Z4YMkaG0yw6Sdg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 8/9] can: slcan: add support to set bit time
 register (btr)
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Max Staudt <max@enpas.org>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 11:02 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 28.07.2022 09:36:21, Dario Binacchi wrote:
> > > Most of the other CAN drivers write the BTR values into the register of
> > > the hardware. How are these BTR values transported into the driver?
> > >
> > > There are 2 ways:
> > >
> > > 1) - user space configures a bitrate
> > >    - the kernel calculates with the "struct can_bittiming_const" [1] given
> > >      by driver and the CAN clock rate the low level timing parameters.
> > >
> > >      [1] https://elixir.bootlin.com/linux/v5.18/source/include/uapi/linux/can/netlink.h#L47
> > >
> > > 2) - user space configures low level bit timing parameter
> > >      (Sample point in one-tenth of a percent, Time quanta (TQ) in
> > >       nanoseconds, Propagation segment in TQs, Phase buffer segment 1 in
> > >       TQs, Phase buffer segment 2 in TQs, Synchronisation jump width in
> > >       TQs)
> > >     - the kernel calculates the Bit-rate prescaler from the given TQ and
> > >       CAN clock rate
> > >
> > > Both ways result in a fully calculated "struct can_bittiming" [2]. The
> > > driver translates this into the hardware specific BTR values and writes
> > > the into the registers.
> > >
> > > If you know the CAN clock and the bit timing const parameters of the
> > > slcan's BTR register you can make use of the automatic BTR calculation,
> > > too. Maybe the framework needs some tweaking if the driver supports both
> > > fixed CAN bit rate _and_ "struct can_bittiming_const".
> >
> > Does it make sense to use the device tree
>
> The driver doesn't support DT and DT only works for static serial
> interfaces.
>
> > to provide the driver with those
> > parameters required for the automatic calculation of the BTR (clock rate,
> > struct can_bittiming_const, ...) that depend on the connected
> > controller?
>
> The device tree usually says it's a CAN controller compatible to X and
> the following clock(s) are connected. The driver for CAN controller X
> knows the bit timing const. Some USB CAN drivers query the bit timing
> const from the USB device.
>
> > In this way the solution should be generic and therefore scalable. I
> > think we should also add some properties to map the calculated BTR
> > value on the physical register of the controller.
>
> The driver knows how to map the "struct can_bittiming" to the BTR
> register values of the hardware.
>
> What does the serial protocol say to the BTR values? Are these standard
> SJA1000 layout with 8 MHz CAN clock or are those adapter specific?

I think they are adapter specific.
This is  what the can232_ver3_Manual.pdf reports:

sxxyy[CR]         Setup with BTR0/BTR1 CAN bit-rates where xx and yy is a hex
                         value. This command is only active if the CAN
channel is closed.

xx     BTR0 value in hex
yy     BTR1 value in hex

Example:            s031C[CR]
                           Setup CAN with BTR0=0x03 & BTR1=0x1C
                           which equals to 125Kbit.

But I think the example is misleading because IMHO it depends on the
adapter's controller (0x31C -> 125Kbit).

>
> > Or, use the device tree to extend the bittates supported by the controller
> > to the fixed ones (struct can_priv::bitrate_const)?
>
> The serial protocol defines fixed bit rates, no need to describe them in
> the DT:
>
> |           0            10 Kbit/s
> |           1            20 Kbit/s
> |           2            50 Kbit/s
> |           3           100 Kbit/s
> |           4           125 Kbit/s
> |           5           250 Kbit/s
> |           6           500 Kbit/s
> |           7           800 Kbit/s
> |           8          1000 Kbit/s
>
> Are there more bit rates?

No, the manual can232_ver3_Manual.pdf does not contain any others.

What about defining a device tree node for the slcan (foo adapter):

slcan {
    compatible = "can,slcan";
                                     /* bit rate btr0btr1 */
    additional-bitrates = < 33333  0x0123
                                        80000  0x4567
                                        83333  0x89ab
                                      150000 0xcd10
                                      175000 0x2345
                                      200000 0x6789>
};

So that the can_priv::bitrate_cons array (dynamically created) will
contain the bitrates
           10000,
           20000,
           50000,
         100000,
         125000,
         250000,
         500000,
         800000,
        1000000 /* end of standards bitrates,  use S command */
           33333,  /* use s command, btr 0x0123 */
           80000,  /* use s command, btr 0x4567 */
           83333,  /* use s command, btr 0x89ab */
         150000,  /* use s command, btr 0xcd10 */
         175000, /* use s command, btr 0x2345 */
         200000  /* use s command, btr 0x6789 */
};

So if a standard bitrate is requested, the S command is used,
otherwise the s command with the associated btr.

Thanks and regards,
Dario

>
> regards,
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
