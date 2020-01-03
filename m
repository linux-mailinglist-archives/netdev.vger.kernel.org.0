Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBD912FE61
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 22:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgACV3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 16:29:00 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41118 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728549AbgACV27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 16:28:59 -0500
Received: by mail-ed1-f67.google.com with SMTP id c26so42699131eds.8;
        Fri, 03 Jan 2020 13:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sY+5gBJ9KBN9CmCnj27mx4Jhd9hNgJKF8zYt9OnsI4Q=;
        b=vRNZ8xR0cRi5hS92dxr96kspn6z+MidQ30Ls7zmJ3eyz4Xo26rNawGDzaAtNvsBXFw
         9WnPYoPKyKmc9tJED3/GaF5K9lv/Y9Jf267LnqvgwTdnkoQLc0jE6kZb/yQNk5BjRy2q
         WT0d/g5JIcy9BKL8g2nvmIQLNDBFT40TIT22cOSm73Nz15KO5forfXbMUujZKmurOAs/
         hVK3NZ1kG1fYxuom5n+1EIetBuxP9iIZ8VrZph+ggGnNvr4axOlZgUcQjzVm5Osgr87t
         cR1PzkkayFotuz84RqtglbEJfyDtSQzQRzB5YHM51busvhxUz8jFEheKMkoL4MTeCtcr
         4IzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sY+5gBJ9KBN9CmCnj27mx4Jhd9hNgJKF8zYt9OnsI4Q=;
        b=gLu1wypqBqU+I+LkI55h6AROGks4W0AhxT6kJX4bzJ6sN/J6gPEIU18iv54UYTJyR8
         KVape/L3ZY4kQ5z0b0+1WWyKd1yO0v4owQIh0vQ6D651fdGUlDfJfKzZnEcR2qdx1m9v
         umty4ti2USDRlwEWGBGvlJXO2/JwDUgnBYVV5ggp3SBEUulO1FGKevW7ExABOEL2IWC2
         pbVzHHXvTnCxFJ6HcRw4vIjNkkV080HB3Srv4G8wII5XGnzbaZRmEp/m3AfZ/GcNWyxn
         Iy+Pu3mYGILpV/ADrx0/UJ7yNk+wT/DLSYVaxg/iNdPBmtLiP1tCrLW6y87MqLAr7ROi
         w7dw==
X-Gm-Message-State: APjAAAX6tG4kWyFTzAxlZ0K+CPZhvs2OLkl3igdP5h9jVlhXINQeRPlu
        0i1/ReSOWtatcLgEpZ/atiVazUCJTm+lO79cT84=
X-Google-Smtp-Source: APXvYqz6C0gPA0BhTifMkDy7tGjqFdi13Pdnw86CYCjTgOWj/u5iR1rZ2K6vSRub8lpQ1YCZR9r0P0aJe4S60ETEH9c=
X-Received: by 2002:aa7:cccf:: with SMTP id y15mr94922090edt.108.1578086938142;
 Fri, 03 Jan 2020 13:28:58 -0800 (PST)
MIME-Version: 1.0
References: <20200102233657.12933-1-f.fainelli@gmail.com> <CA+h21hrLO2Nfryu74Joj-T3-ithgoSFOQZsw4Z5QWOnhttvGiA@mail.gmail.com>
 <91eb2720-d933-f1fd-8d50-e9a81434545b@gmail.com>
In-Reply-To: <91eb2720-d933-f1fd-8d50-e9a81434545b@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 3 Jan 2020 23:28:47 +0200
Message-ID: <CA+h21hqEnFjPHyK9ZanzwXdvkcdTA3uZzJMf0eo0FZWRTFzouw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: Remove indirect function call for flow dissection
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Petar Penkov <ppenkov@google.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Jan 2020 at 22:50, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> The call path is the following on TX (e.g.: when you run a DHCP client),

Oh, it gets called on TX too, ok.
In that case, static proto_off information won't work for asymmetric
taggers such as ocelot which may have an independently configurable
prefix length on RX and TX.
I want to get rid of the RX tag prefix in ocelot though, but just saying.

> I don't think your formula works for EDSA which has an EtherType, but

Why doesn't it work with edsa?

> this would probably work for all tags we currently support except trailer.
>
> proto = (__be16 *)(skb->data)[overhead / 2 - 1];
>

I wasn't suggesting to do this exact calculation in flow_dissector.c,
but rather to pre-populate proto_off with a value statically derived
from it on a piece of paper, with the trailer exception where it would
be -2 in bytes or -1 in shorts, but nonetheless a negative and valid
value.

>
> I don't think anyone except Alexander did serious investigation this.
> For now, what I am interested in is reducing the amount of technical
> debt and expensive function calls.

Does the change bring any measurable improvement?

> --
> Florian

Regards,
-Vladimir
