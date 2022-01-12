Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3684748CE5B
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 23:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbiALW02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 17:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiALW01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 17:26:27 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4983AC06173F;
        Wed, 12 Jan 2022 14:26:27 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 25-20020a05600c231900b003497473a9c4so4319718wmo.5;
        Wed, 12 Jan 2022 14:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KizL2Q8qfZ1jJgGJ046/TGWPLyvOYwIs4pkgv9A+iK0=;
        b=fWxSBmESv/1HYzdp1Z07Du4OXevSOiE84xmcOnsAmFaYKPqneS4d4QO+wNY16QGBcE
         6t8wp3Dmj+IxoK7cTuAowlppD0iv6sS4R+hr5cadw34ClUWILFHqh5AM/UNG4BE1o6oJ
         HHVKUAVI0O26sRXp0LE5J6ppnHClhL682ZjV418kHMI3i9uWBeEUbhk5Pk4mdN4leZLf
         dFqTYrgXLqU52vxrE8GxAtyDV8EbzODgqoSjBKKhsS/M0hNIQlv/TTEIRolGwdQSEcv4
         iOD4+UGK4rDMQX0Bug4AeH8BRiU6bHRifZyuTMIqTSjj7OC3mMhC7skZjcILSEFnjxQp
         GGig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KizL2Q8qfZ1jJgGJ046/TGWPLyvOYwIs4pkgv9A+iK0=;
        b=OuFeTk5fW1UcU+QUrd6/eNkourH73/D3lg/gtmCEsgZ//TDQFrUYhfiNxyCxeDz4sI
         rDfd58ueLeD9Vpfo+yJHwepMSh6tlZoofKn85HDpaSieKhZuWZDHYS55cSvSAg41pWwd
         Iu8CFNCqgDOCHBMR6fh5SfUb9NzgCumiraNhnMQicGN+r76hlowQrub5VFh+a3xi4jQb
         ZZ+9TDitiEI4fddUENAryV9+Yd+9ZYPnyiMMYSdEU8PsSo1obG6yy2eze0+SRu/LcZrS
         kZ22WbeHpnkIWDuumSPPWrh5DaUTAzQ3ezBlJQDABbuuvtvpJqbGVQSd70SvILoiIuTQ
         eNlg==
X-Gm-Message-State: AOAM531mWXhML2uaZRaO6DugjEXufNVBS7zWpOYHtzsF7gpSFPiaP3qV
        B8YkSKhk5Dk4t4Mh8VtAo2yCqzJ+Ea1QcAmnSIw=
X-Google-Smtp-Source: ABdhPJxjpIbrCnz/h87/HUI6mWdyobHKjBjY+N0p4JN/2fErMzMnFEzgpdVlIclqq/ZyiDDaJImIQyDBPzFHFFtxma8=
X-Received: by 2002:a1c:545b:: with SMTP id p27mr8546817wmi.178.1642026385920;
 Wed, 12 Jan 2022 14:26:25 -0800 (PST)
MIME-Version: 1.0
References: <20220112173312.764660-1-miquel.raynal@bootlin.com> <20220112173312.764660-9-miquel.raynal@bootlin.com>
In-Reply-To: <20220112173312.764660-9-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 12 Jan 2022 17:26:14 -0500
Message-ID: <CAB_54W5QU5JCtQYwvTKREd6ZeQWmC19LF4mj853U0Gz-mCObVQ@mail.gmail.com>
Subject: Re: [wpan-next v2 08/27] net: ieee802154: Drop symbol duration
 settings when the core does it already
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 12 Jan 2022 at 12:33, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> The core now knows how to set the symbol duration in a few cases, when
> drivers correctly advertise the protocols used on each channel. For
> these drivers, there is no more need to bother with symbol duration, so
> just drop the duplicated code.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  drivers/net/ieee802154/ca8210.c | 1 -
>  drivers/net/ieee802154/mcr20a.c | 2 --
>  2 files changed, 3 deletions(-)
>
> diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> index 82b2a173bdbd..d3a9e4fe05f4 100644
> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -2977,7 +2977,6 @@ static void ca8210_hw_setup(struct ieee802154_hw *ca8210_hw)
>         ca8210_hw->phy->cca.mode = NL802154_CCA_ENERGY_CARRIER;
>         ca8210_hw->phy->cca.opt = NL802154_CCA_OPT_ENERGY_CARRIER_AND;
>         ca8210_hw->phy->cca_ed_level = -9800;
> -       ca8210_hw->phy->symbol_duration = 16 * 1000;
>         ca8210_hw->phy->lifs_period = 40;
>         ca8210_hw->phy->sifs_period = 12;
>         ca8210_hw->flags =
> diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
> index 8aa87e9bf92e..da2ab19cb5ee 100644
> --- a/drivers/net/ieee802154/mcr20a.c
> +++ b/drivers/net/ieee802154/mcr20a.c
> @@ -975,7 +975,6 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
>
>         dev_dbg(printdev(lp), "%s\n", __func__);
>
> -       phy->symbol_duration = 16 * 1000;
>         phy->lifs_period = 40;
>         phy->sifs_period = 12;
>
> @@ -1010,7 +1009,6 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
>         phy->current_page = 0;
>         /* MCR20A default reset value */
>         phy->current_channel = 20;
> -       phy->symbol_duration = 16 * 1000;
>         phy->supported.tx_powers = mcr20a_powers;
>         phy->supported.tx_powers_size = ARRAY_SIZE(mcr20a_powers);
>         phy->cca_ed_level = phy->supported.cca_ed_levels[75];

What's about the atrf86230 driver?

- Alex
