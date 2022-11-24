Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02915636F7A
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 01:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiKXAyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 19:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiKXAyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 19:54:13 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E591001C8;
        Wed, 23 Nov 2022 16:53:45 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id w15-20020a17090a380f00b0021873113cb4so258418pjb.0;
        Wed, 23 Nov 2022 16:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uvTvGGE10qkBNf1EjI/GOTQGcFbzt2y9YPcUQhnAxto=;
        b=p8HFJSTLZxXMPaf6jdCtqe3OWMhloUXlcQOA3FugQGC2H2gPuh6L5a1QJYvaA/kRni
         A/VyQxbyWuILc6mSZ+wTUB6Evcl1mNoRIMozf4cnfUwEAcZd5rInmP5JrgZ2X7NHALZD
         UAl1A+w0GgR8QqL5hvj4Rg82Xue3ajwfCSeTYqrRXRPudyhAdc4UrHy8ExkUDEWVVgHC
         zhIFSH47mtPAF5qFdd+tQ5BXqd1wf9Cehz2b3pfqvAETEmES9CUWIu73l8ZG3THmkoOJ
         5ywVzbjCEElzvJfmEtDz5NLReolxU5OEZEPyxfUkjruMEXCu+U9Lo+Ry4D+SgZ0MwWzu
         /JJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uvTvGGE10qkBNf1EjI/GOTQGcFbzt2y9YPcUQhnAxto=;
        b=dxtK4mUFbP+S0kOBngDyWVsXbbp2VY9PuYSUe4Ekg4B1BApVMPqaIE+p9ILt3pvPbO
         XEzpiYN/jfGmXNaLKW3lqK4Nds1dhYb936Dt5ZJHlxvQJSBcPmYvjsn/C/+jfsObRHsm
         TXIUBHYqKvwsTBolUi/TJsDEWdXAMDC5MjW1zYrqHUNlDGTB5piLNkKpzRzRxgAgS/Fo
         g5cVj9Hok0zEtS/nu6IJ7Cfs58K76gKaWVfHbl9VI0vm8pSBJ4fzGjvfiqwdI8Oob2qH
         S1gapG4d/IUvg3XheR8miB2Gt+v2sil2qC5+8uwTf1gyvtMuzNV/q3rvwNkcNoFu9X+q
         GJlQ==
X-Gm-Message-State: ANoB5ple6S9IFC6OMBAURr561pPTcXWcveB8IufqktXhnXIRQsDmGOmi
        2tnKeLEoHXC+NqOyLze0XTqw6Eh5/ziNk1SnKgo=
X-Google-Smtp-Source: AA0mqf5agaCkmCkO37T5I0l8CJiyP/ibgHjk5TGO1i0JjfQlFnjjShOCzxP3KRYfboqu5CSNMtMSby6ouJCnBKLb1Gw=
X-Received: by 2002:a17:90a:8a07:b0:20a:c032:da66 with SMTP id
 w7-20020a17090a8a0700b0020ac032da66mr38086548pjn.19.1669251224773; Wed, 23
 Nov 2022 16:53:44 -0800 (PST)
MIME-Version: 1.0
References: <20221123194406.80575-1-yashi@spacecubics.com>
In-Reply-To: <20221123194406.80575-1-yashi@spacecubics.com>
From:   Vincent Mailhol <vincent.mailhol@gmail.com>
Date:   Thu, 24 Nov 2022 09:53:33 +0900
Message-ID: <CAMZ6RqJ2L6YntT23rsYEEUK=YDF2LrhB8hXwvYjciu3vzjx2hQ@mail.gmail.com>
Subject: Re: [PATCH] can: mcba_usb: Fix termination command argument
To:     Yasushi SHOJI <yasushi.shoji@gmail.com>
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

On Thu. 24 Nov. 2022 at 04:53, Yasushi SHOJI <yasushi.shoji@gmail.com> wrote:
> Microchip USB Analyzer can be set with termination setting ON or OFF.
> As I've observed, both with my oscilloscope and USB packet capture
> below, you must send "0" to turn it ON, and "1" to turn it OFF.
>
> Reverse the argument value to fix this.
>
> These are the two commands sequence, ON then OFF.
>
> > No.     Time           Source                Destination           Protocol Length Info
> >       1 0.000000       host                  1.3.1                 USB      46     URB_BULK out
> >
> > Frame 1: 46 bytes on wire (368 bits), 46 bytes captured (368 bits)
> > USB URB
> > Leftover Capture Data: a80000000000000000000000000000000000a8
> >
> > No.     Time           Source                Destination           Protocol Length Info
> >       2 4.372547       host                  1.3.1                 USB      46     URB_BULK out
> >
> > Frame 2: 46 bytes on wire (368 bits), 46 bytes captured (368 bits)
> > USB URB
> > Leftover Capture Data: a80100000000000000000000000000000000a9
>
> Signed-off-by: Yasushi SHOJI <yashi@spacecubics.com>
> ---
>  drivers/net/can/usb/mcba_usb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
> index 218b098b261d..67beff1a3876 100644
> --- a/drivers/net/can/usb/mcba_usb.c
> +++ b/drivers/net/can/usb/mcba_usb.c
> @@ -785,9 +785,9 @@ static int mcba_set_termination(struct net_device *netdev, u16 term)
>         };
>
>         if (term == MCBA_TERMINATION_ENABLED)
> -               usb_msg.termination = 1;
> -       else
>                 usb_msg.termination = 0;
> +       else
> +               usb_msg.termination = 1;
>
>         mcba_usb_xmit_cmd(priv, (struct mcba_usb_msg *)&usb_msg);

Nitpick: does it make sense to rename the field to something like
usb_msg.termination_disable or usb_msg.termination_off? This would
make it more explicit that this is a "reverse" boolean.
