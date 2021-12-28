Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C160E480D28
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 22:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbhL1VF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 16:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbhL1VF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 16:05:56 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4D4C061574;
        Tue, 28 Dec 2021 13:05:56 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id w20so31506995wra.9;
        Tue, 28 Dec 2021 13:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qy+EN1lEEGLvFLWU5Lg6MhBBtKBXhty/n19mTqx1M+Y=;
        b=mW1eywlqHMpCc/0xSL16ALeiB5YKscP6ggephiuxpezOWfLa0Wc2HIisMBJaFNq60a
         wJAQOZ1kwHmsv4eJzH8YJ3nsN1knIg4m0oO35NNj3/69DX7qHhGCpCoF2LdaJmEsdtsW
         9GqdC/aWJ8n7vFNihjG0IVtg9B8SiVFqNCatv9txyBEUs7yP4j83T0JpQBDDllq4TvqV
         pAFOc8gs0GCea1bFqLcZDkugvGYCZAOwBufWc73eHL+nT3MPIcDbmNIVHmKnung3SGDu
         s1HjCe5JgpSBhkd7/6yXJXl6X5H+afSM1lDu2Zs/Ro6l4vhaapV+Tziqb7Q7YSbiwMOt
         Ht4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qy+EN1lEEGLvFLWU5Lg6MhBBtKBXhty/n19mTqx1M+Y=;
        b=di0OJ2DJ9z9TMO1fbeau5zoXyKgbgx/ZiXHuawtbDj7LQCmI81mQpoQM97ZlyCyM9N
         1yrMqtQTaAEEW2vydA+3GKJAB+47D7A7HGPwSYm/dGZRREV88N22OHdPgo7yqumMym4F
         RK6aV97E3E48JIqgdQbWuZHZwgxjwfWZn4e0pMh+n6FUNu3QKKWje13Xur74MgX0fAVq
         uosNFHp7CGI2TUAAnq20ONrdYKExxJUDzQ0Ny37OwUAeVmmcFDtuEHwy5GWVnEsq4cJi
         SZS718ccBi5VdhzcVw8eXkMhkS14PwdY7KW87g6p7XqgrAdUI0qDgVXHMajIN1sMb0cT
         M0cQ==
X-Gm-Message-State: AOAM533OnppPyyRJaRLSzY9uaOQlrLf78Utrj0fkRDWSCqsCbNl3sKIx
        TtZheHNCp5wunx6x4uo+mu5Nz7zJNzQqzpZqefk=
X-Google-Smtp-Source: ABdhPJwgSX7LvSGdN6JoCzUtXHv3hQpgoAcX4eT2jSwcbhfNuNn0v5EAVoanuWWKelRz3a7cL6loM4afEFyClzoXdKM=
X-Received: by 2002:adf:d1c2:: with SMTP id b2mr18095209wrd.81.1640725554288;
 Tue, 28 Dec 2021 13:05:54 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com> <20211222155743.256280-2-miquel.raynal@bootlin.com>
In-Reply-To: <20211222155743.256280-2-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 28 Dec 2021 16:05:43 -0500
Message-ID: <CAB_54W7BeSA+2GVzb9Yvz1kj12wkRSqHj9Ybr8cK7oYd7804RQ@mail.gmail.com>
Subject: Re: [net-next 01/18] ieee802154: hwsim: Ensure proper channel
 selection at probe time
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 22 Dec 2021 at 10:57, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> A default channel is selected by default (13), let's clarify that this
> is page 0 channel 13. Call the right helper to ensure the necessary
> configuration for this channel has been applied.
>
> So far there is very little configuration done in this helper but we
> will soon add more information (like the symbol duration which is
> missing) and having this helper called at probe time will prevent us to
> this type of initialization at two different locations.
>

I see why this patch is necessary because in later patches the symbol
duration is set at ".set_channel()" callback like the at86rf230 driver
is doing it.
However there is an old TODO [0]. I think we should combine it and
implement it in ieee802154_set_channel() of "net/mac802154/cfg.c".
Also do the symbol duration setting according to the channel/page when
we call ieee802154_register_hw(), so we have it for the default
settings.

> So far there is very little configuration done in this helper but thanks
> to this improvement, future enhancements in this area (like setting a
> symbol duration, which is missing) will be reflected automatically in
> the default probe state.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  drivers/net/ieee802154/mac802154_hwsim.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
> index 62ced7a30d92..b1a4ee7dceda 100644
> --- a/drivers/net/ieee802154/mac802154_hwsim.c
> +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> @@ -778,8 +778,6 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
>
>         ieee802154_random_extended_addr(&hw->phy->perm_extended_addr);
>
> -       /* hwsim phy channel 13 as default */
> -       hw->phy->current_channel = 13;
>         pib = kzalloc(sizeof(*pib), GFP_KERNEL);
>         if (!pib) {
>                 err = -ENOMEM;
> @@ -793,6 +791,11 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
>         hw->flags = IEEE802154_HW_PROMISCUOUS | IEEE802154_HW_RX_DROP_BAD_CKSUM;

sadly this patch doesn't apply on current net-next/master because
IEEE802154_HW_RX_DROP_BAD_CKSUM is not set.
I agree that it should be set, so we need a patch for it.

- Alex

[0] https://elixir.bootlin.com/linux/v5.16-rc7/source/drivers/net/ieee802154/at86rf230.c#L1059
