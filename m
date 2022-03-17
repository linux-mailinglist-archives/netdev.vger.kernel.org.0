Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3ED4DC365
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 10:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiCQJ4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 05:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbiCQJz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 05:55:59 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF421DB886
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:54:43 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id o83so5109238oif.0
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8HX1lBnW6aQFDl7BQWxl1uhe8Eh6tZ4iOVBmtw43WMk=;
        b=ei3v5pLnZhsdvftGMiUCeOrT9LWC2SmaI5yPa5lLPqpj736Y9AhHgEWLQzGzDY6/cF
         /zheSIj8Adt3NQR7WeBjA9NnvOPb2OVyj4xCA6aXyI/IFRl/nKI/+9q7MHvZICBQ5Fdt
         3LgxCwMWyPHnG2jEyg20Oj0QdLG2/nuiRQcBwNGx3AOT5GR6UAmXcNlbpsVlsOAeNsNu
         /enilhHlK/imJanzJQOWtPiP2n0plLZTlK/cXexYoQYgcyjmYXQLtUV9fSfklAwk6qKr
         Bwb7U4Okeazfrt/uSuNk7GNOG4pvSY2Li3n2izs4szl8/Yp3B0hRZvB7BBCabxy0w6+M
         BfZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8HX1lBnW6aQFDl7BQWxl1uhe8Eh6tZ4iOVBmtw43WMk=;
        b=Zhmi+scNnbcmKZc3xOgkKrgho1F9HdUYQbD19V++RMGrUn9OWBJKSpiPCPpv3L5kJh
         fyqGgQ01pa5y3z6kUULyKjzRft3m/rB3Kux/3fMtIU9e/QlouxP7VKkPCHjOTM/c4U61
         MlPfZXbG7e6SPO6fJwE1xthdxGGPMRXCUxBXElIoi/Oo7JKXxbhf6xOhJn8PjNoC+xPh
         9dgyCQhTYiI7iimXdw/pJIWMnM0lnaLcj2OKwVOTdVVdoGk250ABZ7gFMJvgRQhAXlDA
         D6LEzSiD5JXHIr2pNAcFh9zXHP2Khhh0rdduQqyJe+653m6j3ydxds8WZW9lz4F6JBJQ
         Vnpg==
X-Gm-Message-State: AOAM533SN9fWVEwMblrt/b1uWSIfh6qaeKDDpypmBRcfw5MWZmGNyoxq
        MhsXJ9SVGdmigy74oICRcd7Nkqg7E7F4eZa8Sf3c0A==
X-Google-Smtp-Source: ABdhPJxzGiSYqEc+hXp/hxPQPdb25+xXq1rxoQWQ3mw76eAjMZmJeCj1kAC8z35ZzncsiS8iVaNEhv4HLASa6E7WbUI=
X-Received: by 2002:a05:6808:1b25:b0:2da:32ff:ab73 with SMTP id
 bx37-20020a0568081b2500b002da32ffab73mr1517347oib.285.1647510882851; Thu, 17
 Mar 2022 02:54:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220317091926.86765-1-andy.chiu@sifive.com> <20220317091926.86765-2-andy.chiu@sifive.com>
In-Reply-To: <20220317091926.86765-2-andy.chiu@sifive.com>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Thu, 17 Mar 2022 17:52:44 +0800
Message-ID: <CABgGipUVMBW8yZum60MUKsni-kNQf-P0HW7-2NVT9mR=c2dNRA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: axiemac: use a phandle to reference pcs_phy
To:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        linux@armlinux.org.uk, Robert Hancock <robert.hancock@calian.com>,
        andrew@lunn.ch, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        radhey.shyam.pandey@xilinx.com
Cc:     Greentime Hu <greentime.hu@sifive.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

loop in: radhey.shyam.pandey@xilinx.com

I am sending this out since I forgot to CC the maintainer of the
driver, again...

Sorry for being noisy here.

Regards,
Andy


On Thu, Mar 17, 2022 at 5:21 PM Andy Chiu <andy.chiu@sifive.com> wrote:
>
> In some SGMII use cases where both an external PHY and the internal
> PCS/PMA PHY need to be configured, we should explicitly use a phandle
> "pcs-phy" to get the reference to the PCS/PMA PHY. Otherwise, the driver
> would use "phy-handle" in the DT as the reference to both external and
> the internal PCS/PMA PHY.
>
> In other cases where the core is connected to a SFP cage, we could
> fallback, pointing phy-handle to the intenal PCS/PMA PHY, and let the
> driver connect to the SFP module, if exist, via phylink.
>
> Fixes: 1a02556086fc (net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode)
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 6fd5157f0a6d..17de81cc0ca5 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -2078,7 +2078,13 @@ static int axienet_probe(struct platform_device *pdev)
>                         ret = -EINVAL;
>                         goto cleanup_mdio;
>                 }
> -               lp->pcs_phy = of_mdio_find_device(lp->phy_node);
> +               np = of_parse_phandle(pdev->dev.of_node, "pcs-handle", 0);
> +               if (np) {
> +                       lp->pcs_phy = of_mdio_find_device(np);
> +                       of_node_put(np);
> +               } else {
> +                       lp->pcs_phy = of_mdio_find_device(lp->phy_node);
> +               }
>                 if (!lp->pcs_phy) {
>                         ret = -EPROBE_DEFER;
>                         goto cleanup_mdio;
> --
> 2.34.1
>
