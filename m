Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D858B66DFAF
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbjAQN4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 08:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbjAQN4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:56:34 -0500
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A774695;
        Tue, 17 Jan 2023 05:56:03 -0800 (PST)
Received: by mail-qv1-f54.google.com with SMTP id p96so9542699qvp.13;
        Tue, 17 Jan 2023 05:56:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oLCNgQgSzIWRwnZwPRVxRdnKYpvVJh9+ULJwZcc5wHA=;
        b=CvVUvp3BqBjefv1JCZR9bhvIGrKF/aYGdJOXqVEj3fEzqTI22dvPkeXZvQe4DFZQV+
         E5EOvhwDyR75jq1+WODhwbDzHkmo0F0DeMOwc2vnh25GB43lY1zkbpf9t4vbyYApXuv9
         LWMqpZc0QRbPRmIhBLBtxhywISXUuwAaOJRl9Xd1L7jq38FDBj2fYzrgGjvB+ljO767A
         3rQY7gw7YtLAgkTR5M8Dd3PDTpuSKZvjSjtFD1Ll4UqyPbMywcgU/Q2dEcRlM5IEx5WT
         1m1UWktnibncW2nGc2yBQeJeQPC5Gusk4PiTP0W10qqtglCs8G4AXWxEd+HlGNg2//Xs
         087w==
X-Gm-Message-State: AFqh2koTNrW3H4+9yUcI6yTsxSl2Pqf/OMrn8Iq01/tNz3d2T74Jyc1q
        5MslQfFL0fmIV6LO/S6MsAZ59FJXfFbmFQ==
X-Google-Smtp-Source: AMrXdXuRcAyU5V+fIJpzGWuC1cyklgMuEAUpshXtpik7ebQFXPEj03lP+p/y5lSlvfgfs5ftWJU3cA==
X-Received: by 2002:a05:6214:57d1:b0:515:5e33:505b with SMTP id lw17-20020a05621457d100b005155e33505bmr4544782qvb.20.1673963761916;
        Tue, 17 Jan 2023 05:56:01 -0800 (PST)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id u12-20020a05620a430c00b006ee949b8051sm20129510qko.51.2023.01.17.05.56.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 05:56:01 -0800 (PST)
Received: by mail-yb1-f180.google.com with SMTP id 20so14993171ybl.0;
        Tue, 17 Jan 2023 05:56:01 -0800 (PST)
X-Received: by 2002:a25:2f90:0:b0:7d5:620e:b60f with SMTP id
 v138-20020a252f90000000b007d5620eb60fmr454677ybv.89.1673963761015; Tue, 17
 Jan 2023 05:56:01 -0800 (PST)
MIME-Version: 1.0
References: <20230104103432.1126403-1-s-vadapalli@ti.com> <20230104103432.1126403-4-s-vadapalli@ti.com>
In-Reply-To: <20230104103432.1126403-4-s-vadapalli@ti.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 17 Jan 2023 14:55:49 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWiXu9OJxH4mRnneC3jhqTEcYXek3kbr7svhJ3cnPPwcw@mail.gmail.com>
Message-ID: <CAMuHMdWiXu9OJxH4mRnneC3jhqTEcYXek3kbr7svhJ3cnPPwcw@mail.gmail.com>
Subject: Re: [PATCH net-next v6 3/3] net: ethernet: ti: am65-cpsw: Add support
 for SERDES configuration
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        linux@armlinux.org.uk, vladimir.oltean@nxp.com, vigneshr@ti.com,
        nsekhar@ti.com, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Siddharth,

On Wed, Jan 4, 2023 at 11:37 AM Siddharth Vadapalli <s-vadapalli@ti.com> wrote:
> Use PHY framework APIs to initialize the SERDES PHY connected to CPSW MAC.
>
> Define the functions am65_cpsw_disable_phy(), am65_cpsw_enable_phy(),
> am65_cpsw_disable_serdes_phy() and am65_cpsw_enable_serdes_phy().
>
> Add new member "serdes_phy" to struct "am65_cpsw_slave_data" to store the
> SERDES PHY for each port, if it exists. Use it later while disabling the
> SERDES PHY for each port.
>
> Power on and initialize the SerDes PHY in am65_cpsw_nuss_init_slave_ports()
> by invoking am65_cpsw_enable_serdes_phy().
>
> Power off the SerDes PHY in am65_cpsw_nuss_remove() by invoking
> am65_cpsw_disable_serdes_phy().
>
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>

Thanks for your patch, which is now commit dab2b265dd23ef8f ("net:
ethernet: ti: am65-cpsw: Add support for SERDES configuration")
in net-next.

> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -1416,6 +1416,68 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
>         .ndo_setup_tc           = am65_cpsw_qos_ndo_setup_tc,
>  };
>
> +static void am65_cpsw_disable_phy(struct phy *phy)
> +{
> +       phy_power_off(phy);
> +       phy_exit(phy);
> +}
> +
> +static int am65_cpsw_enable_phy(struct phy *phy)
> +{
> +       int ret;
> +
> +       ret = phy_init(phy);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret = phy_power_on(phy);
> +       if (ret < 0) {
> +               phy_exit(phy);
> +               return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static void am65_cpsw_disable_serdes_phy(struct am65_cpsw_common *common)
> +{
> +       struct am65_cpsw_port *port;
> +       struct phy *phy;
> +       int i;
> +
> +       for (i = 0; i < common->port_num; i++) {
> +               port = &common->ports[i];
> +               phy = port->slave.serdes_phy;
> +               if (phy)
> +                       am65_cpsw_disable_phy(phy);
> +       }
> +}
> +
> +static int am65_cpsw_init_serdes_phy(struct device *dev, struct device_node *port_np,
> +                                    struct am65_cpsw_port *port)
> +{
> +       const char *name = "serdes-phy";
> +       struct phy *phy;
> +       int ret;
> +
> +       phy = devm_of_phy_get(dev, port_np, name);
> +       if (PTR_ERR(phy) == -ENODEV)
> +               return 0;
> +
> +       /* Serdes PHY exists. Store it. */

"phy" may be a different error here (e.g. -EPROBE_DEFER)...

> +       port->slave.serdes_phy = phy;
> +
> +       ret =  am65_cpsw_enable_phy(phy);

... so it will crash when dereferencing phy in phy_init().

I think you want to add an extra check above:

    if (IS_ERR(phy))
            return PTR_ERR(phy);

> +       if (ret < 0)
> +               goto err_phy;
> +
> +       return 0;
> +
> +err_phy:
> +       devm_phy_put(dev, phy);
> +       return ret;
> +}
> +
>  static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned int mode,
>                                       const struct phylink_link_state *state)
>  {
> @@ -1959,6 +2021,11 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)

Right out of context we have:

                port->slave.ifphy = devm_of_phy_get(dev, port_np, NULL);
                if (IS_ERR(port->slave.ifphy)) {
                        ret = PTR_ERR(port->slave.ifphy);
                        dev_err(dev, "%pOF error retrieving port phy: %d\n",
                                port_np, ret);

So if there is only one PHY (named "serdes-phy") in DT, it will be
used for both ifphy and serdes_phy. Is that intentional?

>                         goto of_node_put;
>                 }
>
> +               /* Initialize the Serdes PHY for the port */
> +               ret = am65_cpsw_init_serdes_phy(dev, port_np, port);
> +               if (ret)
> +                       return ret;
> +
>                 port->slave.mac_only =
>                                 of_property_read_bool(port_np, "ti,mac-only");
>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
