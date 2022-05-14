Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934D6526E6C
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiENDoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 23:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiENDoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 23:44:04 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F8811459;
        Fri, 13 May 2022 20:44:00 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2fb9a85a124so104383377b3.13;
        Fri, 13 May 2022 20:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sJzlF99MMJ/4VRi/5NrL6Jp0J+n+hynsI8EUWbxr3us=;
        b=fTANJ+/WK7bsKQwvKUHQRV4wA+acsDpY2tuK2pyYJAxkynd59svNWPKUwZH2V6NW8z
         GL9wpaqBs+bpJzK9mnA6bD+MbbH221zV6U7cIWZNWqqjwYxhpyWa/fRnOt1MFlTWZ9k9
         aDl9ScNCvqLqu0WVFjSS0SWCRPTIxF4Y44r82FLlKodhu2PFVnkNiBVwAiSUoAzDSspX
         eMmQjAravcS19tDiDafxdZvdRPP8Z79RIIJPFM8LoWJ6nLdIjZJrQf+8oVC9DXf1Vqn6
         Z9Q12S4exeMiACWDbGqvrP32bByRNpZbAGs1WyaO7AGtGyfRuW9V+Sj4q2e+bo9Osqk/
         2/gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sJzlF99MMJ/4VRi/5NrL6Jp0J+n+hynsI8EUWbxr3us=;
        b=M56TniF6pmSf0sHy4R/UdeIEpbORpQe3LSd/ENtS53Exm5RhAWsfcyAkbaz34OnUhW
         881k3UksTywgQOh/mhc/tgr0ttOd232f6FdmvhLvVlmcPqL/YrMxKiYfNSCAmVqpqZEQ
         t9nL2AeCFRCpgxUioDCoeKnmvUtzt0ZAYzf76L7mHxM1IJwZpob7ENMWm/mapdmvjjm1
         /6P1kWdirdamCxyReMbQRexS5QMCLHPUBM1BfH4jwEtlzymK2FgjWpDfnugRmJqZ06+L
         97ustL+Eg1HjJQ2Oi2s6NgtbSIkO/FJRN76SC3I4lVBaUDriv9Lg+N7bI2Ll2MhbDrkn
         1c5g==
X-Gm-Message-State: AOAM5314+K06e8XsJGnwazRPkeuWCABsR1TSpWLswNWcIx3TG+2sLuiI
        OtlDei3sl59NA9h4MHOn0hWIoAgJ7BfiXBEB1785CcAOKNoY4Q==
X-Google-Smtp-Source: ABdhPJzmix6rDFK5h3SwvbkKf0znC1BWS4iJESrC8+ST33B0hDFl9FnY/gGZ7lNI9THPgdODYfEI/44xYMJzteee+XA=
X-Received: by 2002:a81:ff12:0:b0:2db:2d8a:9769 with SMTP id
 k18-20020a81ff12000000b002db2d8a9769mr9224115ywn.172.1652499839751; Fri, 13
 May 2022 20:43:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220511121913.2696181-1-o.rempel@pengutronix.de>
 <b631b022-72d5-9160-fd13-f33c80dbbe59@hartkopp.net> <20220511132421.7o5a3po32l3w2wcr@pengutronix.de>
 <20220511143620.kphwgp2vhjyoecs5@pengutronix.de>
In-Reply-To: <20220511143620.kphwgp2vhjyoecs5@pengutronix.de>
From:   Vincent Mailhol <vincent.mailhol@gmail.com>
Date:   Sat, 14 May 2022 12:43:48 +0900
Message-ID: <CAMZ6RqL7p2Thks2RNX3CYB9XxXPJB2f5=NArzrT3O2-BjmH_dg@mail.gmail.com>
Subject: Re: [PATCH 1/1] can: skb: add and set local_origin flag
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Devid Antonio Filoni <devid.filoni@egluetechnologies.com>,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat. 14 May 2022 at 12:29, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 11.05.2022 15:24:21, Marc Kleine-Budde wrote:
> > On 11.05.2022 14:38:32, Oliver Hartkopp wrote:
> > > IMO this patch does not work as intended.
> > >
> > > You probably need to revisit every place where can_skb_reserve() is used,
> > > e.g. in raw_sendmsg().
> >
> > And the loopback for devices that don't support IFF_ECHO:
> >
> > | https://elixir.bootlin.com/linux/latest/source/net/can/af_can.c#L257
>
> BTW: There is a bug with interfaces that don't support IFF_ECHO.
>
> Assume an invalid CAN frame is passed to can_send() on an interface that
> doesn't support IFF_ECHO. The above mentioned code does happily generate
> an echo frame and it's send, even if the driver drops it, due to
> can_dropped_invalid_skb(dev, skb).
>
> The echoed back CAN frame is treated in raw_rcv() as if the headroom is valid:
>
> | https://elixir.bootlin.com/linux/v5.17.6/source/net/can/raw.c#L138
>
> But as far as I can see the can_skb_headroom_valid() check never has
> been done. What about this patch?
>
> index 1fb49d51b25d..fda4807ad165 100644
> --- a/net/can/af_can.c
> +++ b/net/can/af_can.c
> @@ -255,6 +255,9 @@ int can_send(struct sk_buff *skb, int loop)
>                  */
>
>                 if (!(skb->dev->flags & IFF_ECHO)) {
> +                       if (can_dropped_invalid_skb(dev, skb))
> +                               return -EINVAL;
> +

This means that can_dropped_invalid_skb() would be called twice: one
time in can_send() and one time in the driver's xmit() function,
right?
It would be nice to find a trick to detect whether the skb was
injected through the packet socket or not in order not to execute
can_dropped_invalid_skb() twice. I guess the information of the
provenance of the skb is available somewhere, just not sure where (not
familiar with the packet socket).


Yours sincerely,
Vincent Mailhol
