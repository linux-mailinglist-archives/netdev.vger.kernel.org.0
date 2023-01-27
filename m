Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7604567DF54
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 09:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbjA0Iey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 03:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbjA0Iex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 03:34:53 -0500
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EE223117;
        Fri, 27 Jan 2023 00:34:52 -0800 (PST)
Received: by mail-qt1-f180.google.com with SMTP id m26so3443033qtp.9;
        Fri, 27 Jan 2023 00:34:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hY3siCQpqUTqTnZ9pzJ4oPleQ2RuWtp/ZoxSSndTMRI=;
        b=KH/rmaVbFcR5mln/pv39h+bOgwkSR/C/yCI5uIwzjp9xrt42B8yqtcarfG52WQHqfe
         kcPJNgqnhjhOBvR7Cx8rbq1CYhccrjbq1/Frx+rXD+WzzVuIqdU88A9cm2LY4xYAp4Oi
         HuTDHBDXsKCcEASwKc4Zj3yFgq7e32VHNKhmcSqcK5kQAWiAiDqF1ZP0sl9bbnsIzkn5
         c2ZLJ02fIO+qGXJrWomoZb0T7hTj+dMT1LS9/NN3pC0gRynxRlAL+KyV4JDtY0lnRlQ8
         BZv4rGWgEhROUI0ZDx7bBAshFCTQ9GmaQy2t6LiJy3tanw+gySFcFeFVb0CwYStBbNt6
         gnSA==
X-Gm-Message-State: AO0yUKV2sjOtAoOXQ8NQZAtPZGn8m10k3RupYH0qtkToeoWKyPbqb/J2
        uKhMwhIQ2o5q+mWeg5iNqt7jlV5ibI7JXA==
X-Google-Smtp-Source: AK7set9UJjbYpV4LjGI+YluxUYhWKpL9ZLSqP2HJ6Oe2mMBgMf3nc4VtghCYYvIXDepxXVhfcIjjpg==
X-Received: by 2002:a05:622a:1016:b0:3b8:248b:a035 with SMTP id d22-20020a05622a101600b003b8248ba035mr1714613qte.19.1674808491184;
        Fri, 27 Jan 2023 00:34:51 -0800 (PST)
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com. [209.85.128.172])
        by smtp.gmail.com with ESMTPSA id g13-20020ac8468d000000b003a7e4129f83sm2274786qto.85.2023.01.27.00.34.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 00:34:50 -0800 (PST)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-50660e2d2ffso58113397b3.1;
        Fri, 27 Jan 2023 00:34:50 -0800 (PST)
X-Received: by 2002:a81:5204:0:b0:507:86ae:c733 with SMTP id
 g4-20020a815204000000b0050786aec733mr1184162ywb.358.1674808490126; Fri, 27
 Jan 2023 00:34:50 -0800 (PST)
MIME-Version: 1.0
References: <20230127014812.1656340-1-yoshihiro.shimoda.uh@renesas.com> <20230127014812.1656340-3-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20230127014812.1656340-3-yoshihiro.shimoda.uh@renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 27 Jan 2023 09:34:39 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXGNWZ6NQxFKKJ-aWKO6YG=dD+jeJynDyK9XZNRx=hgJA@mail.gmail.com>
Message-ID: <CAMuHMdXGNWZ6NQxFKKJ-aWKO6YG=dD+jeJynDyK9XZNRx=hgJA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/4] net: ethernet: renesas: rswitch: Simplify
 struct phy * handling
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shimoda-san,

On Fri, Jan 27, 2023 at 2:49 AM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
> Simplify struct phy *serdes handling by keeping the valiable in
> the struct rswitch_device.
>
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Thanks for your patch!

> --- a/drivers/net/ethernet/renesas/rswitch.c
> +++ b/drivers/net/ethernet/renesas/rswitch.c
> @@ -1222,49 +1222,40 @@ static void rswitch_phylink_deinit(struct rswitch_device *rdev)
>         phylink_destroy(rdev->phylink);
>  }
>
> -static int rswitch_serdes_set_params(struct rswitch_device *rdev)
> +static int rswitch_serdes_phy_get(struct rswitch_device *rdev)
>  {
>         struct device_node *port = rswitch_get_port_node(rdev);
>         struct phy *serdes;
> -       int err;
>
>         serdes = devm_of_phy_get(&rdev->priv->pdev->dev, port, NULL);
>         of_node_put(port);
>         if (IS_ERR(serdes))
>                 return PTR_ERR(serdes);

You may as well just return serdes...

> +       rdev->serdes = serdes;

... and move the above assignment into the caller.
That would save one if (...) check.

After that, not much is left in this function, so I'm wondering if it
can just be inlined at the single callsite?

BTW, there seem to be several calls to rswitch_get_port_node(), which
calls into DT tree traversal, so you may want to call it once, and store
a pointer to the port device node, too.  Then rswitch_serdes_phy_get()
becomes a candidate for manual inlining for sure.

> +
> +       return 0;
> +}
> +
> +static int rswitch_serdes_set_params(struct rswitch_device *rdev)
> +{
> +       int err;
>
> -       err = phy_set_mode_ext(serdes, PHY_MODE_ETHERNET,
> +       err = phy_set_mode_ext(rdev->serdes, PHY_MODE_ETHERNET,
>                                rdev->etha->phy_interface);
>         if (err < 0)
>                 return err;
>
> -       return phy_set_speed(serdes, rdev->etha->speed);
> +       return phy_set_speed(rdev->serdes, rdev->etha->speed);
>  }
>
>  static int rswitch_serdes_init(struct rswitch_device *rdev)
>  {
> -       struct device_node *port = rswitch_get_port_node(rdev);
> -       struct phy *serdes;
> -
> -       serdes = devm_of_phy_get(&rdev->priv->pdev->dev, port, NULL);
> -       of_node_put(port);
> -       if (IS_ERR(serdes))
> -               return PTR_ERR(serdes);
> -
> -       return phy_init(serdes);
> +       return phy_init(rdev->serdes);
>  }

As this is now a one-line function, just call phy_init() in all
callers instead?

>
>  static int rswitch_serdes_deinit(struct rswitch_device *rdev)
>  {
> -       struct device_node *port = rswitch_get_port_node(rdev);
> -       struct phy *serdes;
> -
> -       serdes = devm_of_phy_get(&rdev->priv->pdev->dev, port, NULL);
> -       of_node_put(port);
> -       if (IS_ERR(serdes))
> -               return PTR_ERR(serdes);
> -
> -       return phy_exit(serdes);
> +       return phy_exit(rdev->serdes);
>  }

Just call phy_exit() in all callers instead?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
