Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E7549C9FA
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 13:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241478AbiAZMrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 07:47:02 -0500
Received: from mail-vk1-f176.google.com ([209.85.221.176]:43910 "EHLO
        mail-vk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbiAZMrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 07:47:02 -0500
Received: by mail-vk1-f176.google.com with SMTP id w206so14418723vkd.10;
        Wed, 26 Jan 2022 04:47:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u63OEq+WTaU4bt+o2rdnm1n2f6yhuqtltDfZWHomT0A=;
        b=3vzUVn4MkJk3XLqBN/95M4qHpuHkkzhZNSMMWcJrRYQA+oKJ11RY5gEfLsVbBhrepa
         yGObqNizypa39gCSaL6G8Jh4WPLosp4y/fwbPrXo092Rj+6Kk4/IscYgIgwz/7XSL7Il
         x4+8ZYaqagaDxDVfrM78CRnENwWP/SfkqPQOVOuy7ugyF6UJFs2W4QvSIdhjrOaZ4gUz
         ydfsxW6O/1PStp3kBh5rTYR9uoBC27muwKDtov2wGe9qBAPy5d+GRW+9TzX543nYNTf9
         i1PLjfTpiXNGzPyeQSM/G2YPjXhYbQ6vyb8uowY05btA13qK6q0YiILwUCq1vpSr0kr+
         nb9Q==
X-Gm-Message-State: AOAM532MrewOXZJQrp9/ziahSH25WJ5tr0NuwmM9tWIa3jwFgXTy795D
        TpchtDXiCgPJ+1maKXCxPGmPXyRDP9Zq9Z5L
X-Google-Smtp-Source: ABdhPJxHhT0gAKj7WdPBtV0JaPrgY6JbYCu3UZYn6iJtYxqiNJfjiN6H0QQNNeL7O9LNoYyPDSiWrQ==
X-Received: by 2002:a1f:1953:: with SMTP id 80mr9461612vkz.8.1643201221157;
        Wed, 26 Jan 2022 04:47:01 -0800 (PST)
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com. [209.85.221.170])
        by smtp.gmail.com with ESMTPSA id j6sm392837uae.4.2022.01.26.04.46.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 04:47:00 -0800 (PST)
Received: by mail-vk1-f170.google.com with SMTP id n14so14341649vkk.6;
        Wed, 26 Jan 2022 04:46:59 -0800 (PST)
X-Received: by 2002:a67:c18e:: with SMTP id h14mr5732650vsj.5.1643201219525;
 Wed, 26 Jan 2022 04:46:59 -0800 (PST)
MIME-Version: 1.0
References: <20220111162231.10390-1-uli+renesas@fpond.eu> <20220111162231.10390-3-uli+renesas@fpond.eu>
 <20220112184327.f7fwzgqvle23gfzv@pengutronix.de>
In-Reply-To: <20220112184327.f7fwzgqvle23gfzv@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 26 Jan 2022 13:46:48 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWhRULedk1GCav+8=DMc9OqKTtuaG1XHNqxurF9S=s18w@mail.gmail.com>
Message-ID: <CAMuHMdWhRULedk1GCav+8=DMc9OqKTtuaG1XHNqxurF9S=s18w@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] can: rcar_canfd: Add support for r8a779a0 SoC
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Ulrich Hecht <uli+renesas@fpond.eu>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        socketcan@hartkopp.net,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Wed, Jan 12, 2022 at 7:43 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 11.01.2022 17:22:28, Ulrich Hecht wrote:
> > Adds support for the CANFD IP variant in the V3U SoC.
> >
> > Differences to controllers in other SoCs are limited to an increase in
> > the number of channels from two to eight, an absence of dedicated
> > registers for "classic" CAN mode, and a number of differences in magic
> > numbers (register offsets and layouts).
> >
> > Inspired by BSP patch by Kazuya Mizuguchi.
> >
> > Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>

> > --- a/drivers/net/can/rcar/rcar_canfd.c
> > +++ b/drivers/net/can/rcar/rcar_canfd.c

> > -     of_child = of_get_child_by_name(pdev->dev.of_node, "channel1");
> > -     if (of_child && of_device_is_available(of_child))
> > -             channels_mask |= BIT(1);        /* Channel 1 */
> > +     strcpy(name, "channelX");
>
> please use strlcpy()

Why? To cause a silent failure instead of a possible crash, in the unlikely
case the buffer is shrinked or the string is enlarged?

What about preinitializing it at declaration time instead:

    char name[9] = "channelX";

?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
