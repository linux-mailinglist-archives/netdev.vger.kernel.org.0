Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456F6637594
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 10:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiKXJwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 04:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiKXJw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 04:52:28 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404A0D77;
        Thu, 24 Nov 2022 01:52:26 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id j196so1274454ybj.2;
        Thu, 24 Nov 2022 01:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qFTZ04DRkjWThgTvp15/resthoS/KxUCw2zoiX2YXtM=;
        b=c60oSozfBD75M0P1nAxyPrMiooosQ/+qIRtcyCKeGfJaUYDLHhsQROBJeAu5pJVzwT
         ixHqRpyXufgUyR9Kz5ck0WWOmLpWpBGp1NwFCn6v+bTMxY3TqqG/leo1KzZwpfWsxvT6
         R0T4UEYI5syH/3uAtT8CcSmuzVZeLz8fh6h/ImcUuezSGI3bl++bGMErTQU/73kc4QJ1
         kLb14N8i1AiQQus34AglFflODYuGz23mcgPmzAmTFCeRuAqHvLj7RnsBTxGU0fq72ZQo
         AX9hXAGC7WEiU3KdURff931LuLGmx+/qrV5Xgzv1UkhBioSIpvvZzFFGCbuCWhSB1vQ7
         sgCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qFTZ04DRkjWThgTvp15/resthoS/KxUCw2zoiX2YXtM=;
        b=lJacuzKlQHnUPT2YMfDNYcMGIKjd2NvlNly8n2FlRZI6x3Re5Bk4N2s736PEcNKqY8
         e8BqDiOP/LTgxG5OobI42dH+pJoDiFdvSt1ffRfOowLesZlrH8dxgy0oEhG8iAVdWnqo
         YmoFOmU9GaWadBWYOi6TLA4k/yrnBP4IaMMKSVDux+YEB+7cXmwDENrUDIfK3ShIlAw4
         xKQNYWXjskK3pZRqNAPuBE/DXZB1mRcbSZF0Ga4PsVZlI+6TIqqg8tody6+v4oF1A7kq
         bkBbfAG2eDknxBEy7skzvg/xIqWXec64DCQH0VUczG4zUkZ1yyGkIzUoPXoD/pV1Onaz
         5BIA==
X-Gm-Message-State: ANoB5pmtZ1HnxJ8TCW0Q+uOOPBBYRjVWF9PZq7z9wLGc0bySMNPdYoBD
        bP8Rxq8lO2f7vYVrDzzFdlK2L/XGZhnrvqHJRKE=
X-Google-Smtp-Source: AA0mqf6jYQxhXuepPevY6OrEFv2vQFImt1XiSMBP1CT8viRz6IJ2YcVH+RdO0iabnk1mHS0cnDFII9AI8WTyMJeq36s=
X-Received: by 2002:a25:aea7:0:b0:6d5:34cb:d441 with SMTP id
 b39-20020a25aea7000000b006d534cbd441mr14383548ybj.593.1669283545483; Thu, 24
 Nov 2022 01:52:25 -0800 (PST)
MIME-Version: 1.0
References: <20221123194406.80575-1-yashi@spacecubics.com> <CAMZ6RqJ2L6YntT23rsYEEUK=YDF2LrhB8hXwvYjciu3vzjx2hQ@mail.gmail.com>
In-Reply-To: <CAMZ6RqJ2L6YntT23rsYEEUK=YDF2LrhB8hXwvYjciu3vzjx2hQ@mail.gmail.com>
From:   Yasushi SHOJI <yasushi.shoji@gmail.com>
Date:   Thu, 24 Nov 2022 18:52:14 +0900
Message-ID: <CAELBRWLOKW8NCLpV=MG0_=XY4N3BaozsZCacfgaXEs-tyfzoAA@mail.gmail.com>
Subject: Re: [PATCH] can: mcba_usb: Fix termination command argument
To:     Vincent Mailhol <vincent.mailhol@gmail.com>
Cc:     Yasushi SHOJI <yashi@spacecubics.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 9:53 AM Vincent Mailhol
<vincent.mailhol@gmail.com> wrote:
> > diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
> > index 218b098b261d..67beff1a3876 100644
> > --- a/drivers/net/can/usb/mcba_usb.c
> > +++ b/drivers/net/can/usb/mcba_usb.c
> > @@ -785,9 +785,9 @@ static int mcba_set_termination(struct net_device *netdev, u16 term)
> >         };
> >
> >         if (term == MCBA_TERMINATION_ENABLED)
> > -               usb_msg.termination = 1;
> > -       else
> >                 usb_msg.termination = 0;
> > +       else
> > +               usb_msg.termination = 1;
> >
> >         mcba_usb_xmit_cmd(priv, (struct mcba_usb_msg *)&usb_msg);
>
> Nitpick: does it make sense to rename the field to something like
> usb_msg.termination_disable or usb_msg.termination_off? This would
> make it more explicit that this is a "reverse" boolean.

I'd rather define the values like

#define TERMINATION_ON (0)
#define TERMINATION_OFF (1)

So the block becomes

if (term == MCBA_TERMINATION_ENABLED)
    usb_msg.termination = TERMINATION_ON;
else
    usb_msg.termination = TERMINATION_OFF;
--
             yashi
