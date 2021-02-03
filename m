Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411E630E449
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 21:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhBCUwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 15:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbhBCUwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 15:52:13 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D67C0613D6
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 12:43:27 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id t25so1201990otc.5
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 12:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rQ39ARP4nDfSzhSa5Fdin4LOmLIiUdKlAd5b7DzqBDI=;
        b=ajyjIYoniWoTMq4wxO4itjdFKs8cv0dNud+mS5mRXCMmQFGDLQTUHTgDdyZIbMeHEc
         VyIrpWj3ChgkLciUDxsLtJCd7BxsRXZv3oVhaghVJl7epoKatWv7czOUGTBsVRRJkHzj
         6+qAc/q0OTjaOvB8YqJcjayyT/OV85GnH+hapVmpIsw25RYsuAhZRvvSKWFZSX/182ix
         mc//TcMmufaqTTo7OBe/Wm+N3O7XX+xzEcmiHocyZownYqE9mbV680rULF5iFds0+a4W
         0auWRmeKsghjFPxMtmi91C6tFq6w4GdFiB2ztRiaVAxpcp59al5QQjIGaNb7jBszMc6U
         puBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rQ39ARP4nDfSzhSa5Fdin4LOmLIiUdKlAd5b7DzqBDI=;
        b=in1xcJBbzhklDZQOEcv3mmzyORrmOnoO31Y7+Rug5mXN5V/exaP8LeXHGts/TmsxEE
         AD734jZ+ntfzumObFTsugEiQZNaSf42tP2oEcYHqPFfeVvlUU5Cah5GKmT6AfBFCvK6A
         mO1Y2eI66PSGaf0n7AJxiyo+xzNGh9r1eyJq3wnakR8osckiIH+5XVslXctdIGGruoVW
         +BO7Y4wQmr5qDBYXWRvTUVqaiUaMtKL8m8JDK2qMAIFE++/ZYh8vBqtFkysKojwJYzqn
         sgvuKMZDkZQc9cLfwKRD0MtsE3emUmof6sku18PqpYncKrLyjyyEfgSnna0vaCfip2py
         HG3w==
X-Gm-Message-State: AOAM531jL33wUDmrU0OCFfLUV22b/s+CaWAYvCySeDAo0xHUzF2BD7Qt
        1LPu/fBwxEyHIVQFlAL1zrEKwTwzArFCBdZqeg==
X-Google-Smtp-Source: ABdhPJxLMQTTReMSA82QY3Lx0hkGciTVzxkjy6YrZWjtEqUrf1PieQdSE3Nmbe2D0To9HiwIQh5f9ScmzUg5+035kSg=
X-Received: by 2002:a9d:784a:: with SMTP id c10mr3460131otm.132.1612385006446;
 Wed, 03 Feb 2021 12:43:26 -0800 (PST)
MIME-Version: 1.0
References: <20210201140503.130625-1-george.mccollister@gmail.com>
 <20210201140503.130625-3-george.mccollister@gmail.com> <20210201152316.5tienmoueezr4ptj@skbuf>
In-Reply-To: <20210201152316.5tienmoueezr4ptj@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Wed, 3 Feb 2021 14:43:13 -0600
Message-ID: <CAFSKS=OoknskkfgwJHqoVYdNAChaAX5GHFViycaovMiso2rG-w@mail.gmail.com>
Subject: Re: [RESEND PATCH net-next 2/4] net: hsr: add offloading support
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 9:23 AM Vladimir Oltean <olteanv@gmail.com> wrote:
[snip]
> > @@ -357,6 +367,7 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
> >  {
> >       struct hsr_port *port;
> >       struct sk_buff *skb;
> > +     bool sent = false;
> >
> >       hsr_for_each_port(frame->port_rcv->hsr, port) {
> >               struct hsr_priv *hsr = port->hsr;
> > @@ -372,6 +383,12 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
> >               if (port->type != HSR_PT_MASTER && frame->is_local_exclusive)
> >                       continue;
> >
> > +             /* If hardware duplicate generation is enabled, only send out
> > +              * one port.
> > +              */
> > +             if ((port->dev->features & NETIF_F_HW_HSR_DUP) && sent)
> > +                     continue;
> > +
>
> Is this right? It looks to me that you are not bypassing only duplicate
> generation, but also duplicate elimination.

I missed this part in my last reply.

When the duplicate generation is offloaded it simply doesn't attempt
to send the frame out more than one slave device.

It won't skip delivering to the master because NETIF_F_HW_HSR_DUP is
not set on the master device. Again the way this loop works is
confusing (at least to me) because it's handling incoming and outgoing
frames in the same loop.

The duplicate elimination prevents sending a frame with the same
sequence number and source twice to the same device.

It's not bypassing the duplicate elimination. You could certainly have
a switch that sends frames out both redundant ports automatically but
didn't eliminate duplicates being delivered to the CPU facing port.

Let me know if you still think there is a problem and we can discuss it further.

>
> I think this is duplicate elimination:
>
>                 /* Don't send frame over port where it has been sent before.
>                  * Also fro SAN, this shouldn't be done.
>                  */
>                 if (!frame->is_from_san &&
>                     hsr_register_frame_out(port, frame->node_src,
>                                            frame->sequence_nr))
>                         continue;
>
> and this is duplicate generation:
>
>         hsr_for_each_port(frame->port_rcv->hsr, port) {
>                 ...
>                 skb->dev = port->dev;
>                 if (port->type == HSR_PT_MASTER)
>                         hsr_deliver_master(skb, port->dev, frame->node_src);
>                 else
>                         hsr_xmit(skb, port, frame);
>         }
>
> So if this is the description of NETIF_F_HW_HSR_DUP:
>
> | Duplication involves the switch automatically sending a single frame
> | from the CPU port to both redundant ports. This is required because the
> | inserted HSR/PRP header/trailer must contain the same sequence number
> | on the frames sent out both redundant ports.
>
> then NETIF_F_HW_HSR_DUP is a misnomer. You should think of either
> grouping duplicate elimination and generation together, or rethinking
> the whole features system.
>
> >               /* Don't send frame over port where it has been sent before.
> >                * Also fro SAN, this shouldn't be done.
> >                */
[snip]
