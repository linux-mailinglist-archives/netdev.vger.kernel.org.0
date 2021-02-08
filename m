Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E241D313977
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 17:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbhBHQa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 11:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbhBHQah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 11:30:37 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75718C061786;
        Mon,  8 Feb 2021 08:29:57 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id f67so13807721ioa.1;
        Mon, 08 Feb 2021 08:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WKAu6jD3NL3DoGYOV4wpMs/eBqMreW9BWe9TouHno28=;
        b=t+n9EqsKjvJPZUktEJHY+YK/Q836VAqg8nac9cEhOzzIeDgSLCyp1x/qnYDK3up0G3
         uAWVElBWycUsApd/NOdKZJ8iX4+BIHS6iDrMRNlNoRixQp+PLz/hhuEByeh6eJiQAW97
         VrtV1hVA30jR9nLjxP7kwtDAlbvqgpYOGLxebHpvDwoOAoLLaEdwcFBH2qZy0ynEP5T+
         tzulSk4iUc1rnfB66QFVUGtlzBUskn86k1XlCDyHfqtrxRLOisjTfuYeomU0rXy8HA2v
         9OimlF+Qdlozlak5llGiegi3DpOhbQEDNhfg59uvBnIXadxc1/poFWY/hMMpwiLmv9Ks
         U0xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WKAu6jD3NL3DoGYOV4wpMs/eBqMreW9BWe9TouHno28=;
        b=NcWZGFEUkb+NPaOpYrYJFG7UcRv/6hRRxoIrlKpiweBUDjl5zIFo7lclRktmUU5W7Z
         qOExvS8Ofbc8GN0atg3ze2f7z9pGlQNgNKyF1szPn7gOy6oa9/UFsF/foGM8ZjLsPIkh
         96AZeQiOT74s7TfG/ubW2K7ZI9MWIDpSjade+rh6udKWVqinUNlxVNQiOMxynvP8Lxm5
         aUazSKKYZS/dW36M3Ty9KyJzPEqsYe4j0mfetETkLlY2HLzSmOphOQLwJi+BGMwwy5z3
         8TIFAEQU8fnd7wZN9pJI60bJi5NMOQfMBnOhGsFaySvL1rWb7lmaJkaooA1Chz2CLpz/
         Ulew==
X-Gm-Message-State: AOAM533ubBECbY+/qi8F6ExbmRjGGdu6Au0PNzz3XGU9pNgDkEtSnEQj
        7oqp0d7JLTxyzrQrfAVoq8Jcm+5PbiQ0oYterxaIvNdo9q7O0A==
X-Google-Smtp-Source: ABdhPJz+Xyotw2FoQ4teva9Gi/DKoX3WPEglSKT6yJ3EeRE9Kd/+E9J64braPlsOJf4ZAhrfhr16jye98dNIxDBn9NU=
X-Received: by 2002:a05:6638:b12:: with SMTP id a18mr18850969jab.114.1612801796769;
 Mon, 08 Feb 2021 08:29:56 -0800 (PST)
MIME-Version: 1.0
References: <20210208062859.11429-1-samuel@sholland.org> <20210208062859.11429-5-samuel@sholland.org>
In-Reply-To: <20210208062859.11429-5-samuel@sholland.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 8 Feb 2021 08:29:45 -0800
Message-ID: <CAKgT0Ue3GAWbjZcX7aFxuM-iY-Ga2E0JOTftUqPBQC_dEGz_Eg@mail.gmail.com>
Subject: Re: [PATCH net-next RESEND 3/5] net: stmmac: dwmac-sun8i: Use reset_control_reset
To:     Samuel Holland <samuel@sholland.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Corentin Labbe <clabbe@baylibre.com>,
        Ondrej Jirman <megous@megous.com>,
        Netdev <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linux-sunxi@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 7, 2021 at 10:32 PM Samuel Holland <samuel@sholland.org> wrote:
>
> Use the appropriate function instead of reimplementing it,
> and update the error message to match the code.
>
> Reviewed-by: Chen-Yu Tsai <wens@csie.org>
> Signed-off-by: Samuel Holland <samuel@sholland.org>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
> index 3c3d0b99d3e8..0e8d88417251 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
> @@ -806,11 +806,9 @@ static int sun8i_dwmac_power_internal_phy(struct stmmac_priv *priv)
>         /* Make sure the EPHY is properly reseted, as U-Boot may leave
>          * it at deasserted state, and thus it may fail to reset EMAC.
>          */
> -       reset_control_assert(gmac->rst_ephy);
> -
> -       ret = reset_control_deassert(gmac->rst_ephy);
> +       ret = reset_control_reset(gmac->rst_ephy);
>         if (ret) {
> -               dev_err(priv->device, "Cannot deassert internal phy\n");
> +               dev_err(priv->device, "Cannot reset internal PHY\n");
>                 clk_disable_unprepare(gmac->ephy_clk);
>                 return ret;
>         }

I'm assuming you have exclusive access to the phy and this isn't a
shared line? Just wanting to confirm since the function call has the
following comment in the header for the documentation.

 * Consumers must not use reset_control_(de)assert on shared reset lines when
 * reset_control_reset has been used.
 *

If that is the case it might not hurt to add some documentation to
your call to reset_control_reset here explaining that it is safe to do
so since you have exclusive access.
