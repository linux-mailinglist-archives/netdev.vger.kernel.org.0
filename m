Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6524D583996
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 09:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbiG1Hgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 03:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233608AbiG1Hgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 03:36:46 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B8052E56
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:36:45 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id ez10so1650023ejc.13
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZG/9vTrhrJOGq1JMvZgN00L9EckSKmvxBa3lwJVO5XI=;
        b=NpoUcjH9gI6oaJAHyufhchIG2LTeKnUkwqOYm9jzZMGbSfxc5ZPCOKknpLI2H85x9V
         AV+FWpYJbtRIBX99aIPeNp3BmURZlWQW/ue3eP56ub9c1eVYrrFzwjcwBit9p+oELGFj
         cO7dPnQIyyLlMOjA7YBVmf2jAsK/2UTcDEy6E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZG/9vTrhrJOGq1JMvZgN00L9EckSKmvxBa3lwJVO5XI=;
        b=dwd1aGnXVBtaazUxjJ90kl23d/VBJZWL8EjMIy+uYuKnVtTKq/7/MMUpFIGHm2Mw3q
         Ni2TKpQgHYaLvXv8fKaOMCJq4TlupuV8s+XxkQ8Mvo1+rStTOZf5bnADYrE5rirOjcT0
         5HP+CTBekhmP1GXjIKxJhMZLKWmOIG2esh/qAP7xCRzA+J2EMq/J5B3QI4cO3Q4LNKNZ
         GNoOd2kZ6wcRa3kEnVHUAMPHHXReiiC787krruoVX4bL/DIKYFQXd/Tv7dBmr1iPzTD3
         EQfID1vPaFk96LdYxehnCMkvCEUtg4m+02sKHidib5NaFV0cN65NG3+o1ppnU2ovdYhJ
         o3Xw==
X-Gm-Message-State: AJIora8bUR8Bxh5LaNVAHc3r+Hu+gcagRZxPjRcetzZvOHfeNbqU12f7
        PtXz0WJATqfIEIjpOWIWzI+j2ex8hrtAi4QqvWebC3S4xc4TvA==
X-Google-Smtp-Source: AGRyM1vvV2nin3ftThzTZy5ebCxmO+6Vhwz+IiuVMJgfl9sUVNg3FTrLZEcOrypcNPB6p5mMx0GngzlFMABXHYQQz8Y=
X-Received: by 2002:a05:6512:c08:b0:48a:7cfe:44c8 with SMTP id
 z8-20020a0565120c0800b0048a7cfe44c8mr8653288lfu.120.1658993793285; Thu, 28
 Jul 2022 00:36:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
 <20220726210217.3368497-9-dario.binacchi@amarulasolutions.com>
 <20220727113054.ffcckzlcipcxer2c@pengutronix.de> <20220727192839.707a3453.max@enpas.org>
 <20220727182414.3mysdeam7mtnqyfx@pengutronix.de>
In-Reply-To: <20220727182414.3mysdeam7mtnqyfx@pengutronix.de>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Thu, 28 Jul 2022 09:36:21 +0200
Message-ID: <CABGWkvoE8i--g_2cNU6ToAfZk9WE6uK-nLcWy7J89hU6RidLWw@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

On Wed, Jul 27, 2022 at 8:24 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 27.07.2022 19:28:39, Max Staudt wrote:
> > On Wed, 27 Jul 2022 13:30:54 +0200
> > Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> >
> > > As far as I understand, setting the btr is an alternative way to set the
> > > bitrate, right? I don't like the idea of poking arbitrary values into a
> > > hardware from user space.
> >
> > I agree with Marc here.
> >
> > This is a modification across the whole stack, specific to a single
> > device, when there are ways around.
> >
> > If I understand correctly, the CAN232 "S" command sets one of the fixed
> > bitrates, whereas "s" sets the two BTR registers. Now the question is,
> > what do BTR0/BTR1 mean, and what are they? If they are merely a divider
> > in a CAN controller's master clock, like in ELM327, then you could
> >
> >   a) Calculate the BTR values from the bitrate userspace requests, or
>
> Most of the other CAN drivers write the BTR values into the register of
> the hardware. How are these BTR values transported into the driver?
>
> There are 2 ways:
>
> 1) - user space configures a bitrate
>    - the kernel calculates with the "struct can_bittiming_const" [1] given
>      by driver and the CAN clock rate the low level timing parameters.
>
>      [1] https://elixir.bootlin.com/linux/v5.18/source/include/uapi/linux/can/netlink.h#L47
>
> 2) - user space configures low level bit timing parameter
>      (Sample point in one-tenth of a percent, Time quanta (TQ) in
>       nanoseconds, Propagation segment in TQs, Phase buffer segment 1 in
>       TQs, Phase buffer segment 2 in TQs, Synchronisation jump width in
>       TQs)
>     - the kernel calculates the Bit-rate prescaler from the given TQ and
>       CAN clock rate
>
> Both ways result in a fully calculated "struct can_bittiming" [2]. The
> driver translates this into the hardware specific BTR values and writes
> the into the registers.
>
> If you know the CAN clock and the bit timing const parameters of the
> slcan's BTR register you can make use of the automatic BTR calculation,
> too. Maybe the framework needs some tweaking if the driver supports both
> fixed CAN bit rate _and_ "struct can_bittiming_const".

Does it make sense to use the device tree to provide the driver with those
parameters required for the automatic calculation of the BTR (clock rate,
struct can_bittiming_const, ...) that depend on the connected controller? In
this way the solution should be generic and therefore scalable. I think we
should also add some properties to map the calculated BTR value on the
physical register of the controller.

Or, use the device tree to extend the bittates supported by the controller
to the fixed ones (struct can_priv::bitrate_const)?

Thanks and regards,
Dario

>
> [2] https://elixir.bootlin.com/linux/v5.18/source/include/uapi/linux/can/netlink.h#L31
>
> >   b) pre-calculate a huge table of possible bitrates and present them
> >      all to userspace. Sounds horrible, but that's what I did in can327,
> >      haha. Maybe I should have reigned them in a little, to the most
> >      useful values.
>
> If your adapter only supports fixed values, then that's the only way to
> go.
>
> >   c) just limit the bitrates to whatever seems most useful (like the
> >      "S" command's table), and let users complain if they really need
> >      something else. In the meantime, they are still free to slcand or
> >      minicom to their heart's content before attaching slcan, thanks to
> >      your backwards compatibility efforts.
>
> In the early stages of the non-mainline CAN framework we had tables for
> BTR values for some fixed bit rates, but that turned out to be not
> scaleable.
>
> > In short, to me, this isn't a deal breaker for your patch series.
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
