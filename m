Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8EE4911F4
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 23:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238396AbiAQWwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 17:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234402AbiAQWwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 17:52:23 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A97C061574;
        Mon, 17 Jan 2022 14:52:23 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id az27-20020a05600c601b00b0034d2956eb04so303752wmb.5;
        Mon, 17 Jan 2022 14:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ecp2IWUxBs19SZZEzNcvrKalvgeBC3iiDFe/qUWHaEg=;
        b=kj7TSLpDnuyyi9yHEDlVpyb2p+DNAlR7Ol767/gy2cv5WLnBcaOylkgsdzkKST9o58
         ZHhMRPskCCCt6DfTC9/Ya8qyShNxUw/Ip8DY48mLw9Y1v9Qkx47rQArRNibiVWdpah9D
         3DYAZ28NqnRAggF5bgXSeNb9ATQSErsoXGE2yetP7XoOTi29EiN2qzN97tjc1alMDNYx
         vJ2Jz00w3GFvEo4n1zVyoWivk6vPA6iC2sXTb18u0iBG5sNvGQ0CJMXqoKVyoeJgYX9+
         /DRtSaskdU9QoFW2sxfG9h+kLqldkFBeD8u0gRjs9RoWfA1ig7+ZauysNsHMjOqblFgv
         A/2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ecp2IWUxBs19SZZEzNcvrKalvgeBC3iiDFe/qUWHaEg=;
        b=mLd8A2VQ14JtxtuejcFqLxhxwtrKAjIit44Dtc1FfbCy0CjXCGltjEgLjq0xOeVz0C
         nW3inQm4raq/UAsD1zIfEIvTrSf46+V497wCZo/tGG79xaRARssJds4Wm4GDjY/4vRYp
         vJsVKoFMXmyr+o7QRq7MpVKFq1JGFhrV4jyu0xnhgvLl0Dcn7VdOsm+6JMB9aCyq/Leq
         1Q9rWaC6S/KBqBTPj8D0yz4UJwxBQlrCnar4hqEOL9KnMcim12lII7Xt9jPEE2mjKBvU
         x687TJlelxJnhfaZq2wAzrAcgdyEGSFd6LZTHCuVD6NolLSlH9AK4AKf5OxgOr4J0azy
         NeVg==
X-Gm-Message-State: AOAM533FkLAEOwistN+Mu7bzY+6arKRzqtMIGb0orZGQGpfx9xqCmTgU
        ZZfMcROxuuqVTrzBWqAjI4tZTlUpD8y3kLSGOik=
X-Google-Smtp-Source: ABdhPJzDkOB2softr7ma2fhxCapX/vDo/lEBwbPpC55YgfTc4Scsmh7Wp5+mJzTMiH5RfUS/frKNHm40VkafsamijyQ=
X-Received: by 2002:a05:600c:1f16:: with SMTP id bd22mr8399138wmb.91.1642459941775;
 Mon, 17 Jan 2022 14:52:21 -0800 (PST)
MIME-Version: 1.0
References: <20220117115440.60296-1-miquel.raynal@bootlin.com> <20220117115440.60296-8-miquel.raynal@bootlin.com>
In-Reply-To: <20220117115440.60296-8-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 17 Jan 2022 17:52:10 -0500
Message-ID: <CAB_54W5_XoTk=DzMmm33csrEKe3m97KnNWnktRiyJsk7vfxO6w@mail.gmail.com>
Subject: Re: [PATCH v3 07/41] net: ieee802154: mcr20a: Fix lifs/sifs periods
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 17 Jan 2022 at 06:54, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> These periods are expressed in time units (microseconds) while 40 and 12
> are the number of symbol durations these periods will last. We need to
> multiply them both with phy->symbol_duration in order to get these
> values in microseconds.
>
> Fixes: 8c6ad9cc5157 ("ieee802154: Add NXP MCR20A IEEE 802.15.4 transceiver driver")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  drivers/net/ieee802154/mcr20a.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
> index f0eb2d3b1c4e..e2c249aef430 100644
> --- a/drivers/net/ieee802154/mcr20a.c
> +++ b/drivers/net/ieee802154/mcr20a.c
> @@ -976,8 +976,8 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
>         dev_dbg(printdev(lp), "%s\n", __func__);
>
>         phy->symbol_duration = 16;
> -       phy->lifs_period = 40;
> -       phy->sifs_period = 12;
> +       phy->lifs_period = 40 * phy->symbol_duration;
> +       phy->sifs_period = 12 * phy->symbol_duration;

I thought we do that now in register_hw(). Why does this patch exist?

- Alex
