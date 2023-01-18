Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5ED671A35
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjARLQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjARLPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:15:51 -0500
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96A67E69D;
        Wed, 18 Jan 2023 02:27:33 -0800 (PST)
Received: by mail-lf1-f50.google.com with SMTP id cf42so51080795lfb.1;
        Wed, 18 Jan 2023 02:27:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p9ZnJkG0s5EEhXOo2d/hvqvfJvwr2PPMUoRMNQc9hbQ=;
        b=nAMUMd0y2tmKBlLaZu4tY2joPVqP4kCpCz4AONwfSKyuVwWguw0Rlii+Du9Oh4tbhX
         15vvHppDOlSc264Yw7ZV/X7Mxj8W9EcgjW8VQLVgVvd11fW1KFCen9MNCDoN2blYRJYL
         UBvG8YkQXsl/VW9RBIUzDEaqKr49IbX583SIy48tgA1S9Uua7DDKCRu6zdmJolz71j07
         cn0l23XIcYTnTaSRw/qSRDNq61WGrc2V6m9ipLivT43hZtyS+YxWMKWzYbcusgfgJGtg
         asvLFSWHK56lW/0cT/4zCYCBNm4dJzzXjNLj24SSsRblH1SgeZbuey/yTfh3ER3BBapY
         f0LQ==
X-Gm-Message-State: AFqh2kr2wpDTtSPDZ/wymRXixcC2tisLMUMekCB2r2GB4HXc2LL8WjFa
        7AeUg+OKMzAwKwNBGaLwD6uVKStPCiSzNd3Y
X-Google-Smtp-Source: AMrXdXtA41GbS72MSaPagQx80bGWLhvP6X3HazcTaMvGcuxI1YeG6QeC1QuOzwoYJeQBVu70rkLg6A==
X-Received: by 2002:ac2:4295:0:b0:4b5:7096:23ff with SMTP id m21-20020ac24295000000b004b5709623ffmr1419171lfh.66.1674037649567;
        Wed, 18 Jan 2023 02:27:29 -0800 (PST)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id m7-20020a195207000000b004cb10601096sm5622828lfb.136.2023.01.18.02.27.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 02:27:26 -0800 (PST)
Received: by mail-lj1-f169.google.com with SMTP id s22so36085191ljp.5;
        Wed, 18 Jan 2023 02:27:24 -0800 (PST)
X-Received: by 2002:a2e:958a:0:b0:286:3c35:6810 with SMTP id
 w10-20020a2e958a000000b002863c356810mr464843ljh.278.1674037643865; Wed, 18
 Jan 2023 02:27:23 -0800 (PST)
MIME-Version: 1.0
References: <20230104103432.1126403-1-s-vadapalli@ti.com> <20230104103432.1126403-4-s-vadapalli@ti.com>
 <CAMuHMdWiXu9OJxH4mRnneC3jhqTEcYXek3kbr7svhJ3cnPPwcw@mail.gmail.com> <69d39885-68df-7c94-5a98-5f1e174c7316@ti.com>
In-Reply-To: <69d39885-68df-7c94-5a98-5f1e174c7316@ti.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 18 Jan 2023 11:27:07 +0100
X-Gmail-Original-Message-ID: <CAMuHMdX0+7UyjbR7HLVqghU3dpa+VEL9oV6tkLSZxcZdhM=UXQ@mail.gmail.com>
Message-ID: <CAMuHMdX0+7UyjbR7HLVqghU3dpa+VEL9oV6tkLSZxcZdhM=UXQ@mail.gmail.com>
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

Hi Siddarth,

On Wed, Jan 18, 2023 at 6:48 AM Siddharth Vadapalli <s-vadapalli@ti.com> wrote:
> On 17/01/23 19:25, Geert Uytterhoeven wrote:
> > On Wed, Jan 4, 2023 at 11:37 AM Siddharth Vadapalli <s-vadapalli@ti.com> wrote:
> >> Use PHY framework APIs to initialize the SERDES PHY connected to CPSW MAC.
> >>
> >> Define the functions am65_cpsw_disable_phy(), am65_cpsw_enable_phy(),
> >> am65_cpsw_disable_serdes_phy() and am65_cpsw_enable_serdes_phy().
> >>
> >> Add new member "serdes_phy" to struct "am65_cpsw_slave_data" to store the
> >> SERDES PHY for each port, if it exists. Use it later while disabling the
> >> SERDES PHY for each port.
> >>
> >> Power on and initialize the SerDes PHY in am65_cpsw_nuss_init_slave_ports()
> >> by invoking am65_cpsw_enable_serdes_phy().
> >>
> >> Power off the SerDes PHY in am65_cpsw_nuss_remove() by invoking
> >> am65_cpsw_disable_serdes_phy().
> >>
> >> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> >
> > Thanks for your patch, which is now commit dab2b265dd23ef8f ("net:
> > ethernet: ti: am65-cpsw: Add support for SERDES configuration")
> > in net-next.
> >
> >> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c

> >> +static int am65_cpsw_init_serdes_phy(struct device *dev, struct device_node *port_np,
> >> +                                    struct am65_cpsw_port *port)
> >> +{
> >> +       const char *name = "serdes-phy";
> >> +       struct phy *phy;
> >> +       int ret;
> >> +
> >> +       phy = devm_of_phy_get(dev, port_np, name);
> >> +       if (PTR_ERR(phy) == -ENODEV)
> >> +               return 0;
> >> +
> >> +       /* Serdes PHY exists. Store it. */
> >
> > "phy" may be a different error here (e.g. -EPROBE_DEFER)...
>
> The Serdes is automatically configured for multi-link protocol (Example: PCIe +
> QSGMII) by the Serdes driver, due to which it is not necessary to invoke the
> Serdes configuration via phy_init(). However, for single-link protocol (Example:
> Serdes has to be configured only for SGMII), the Serdes driver doesn't configure
> the Serdes unless requested. For this case, the am65-cpsw driver explicitly
> invokes phy_init() for the Serdes to be configured, by looking up the optional
> device-tree phy named "serdes-phy". For this reason, the above section of code
> is actually emulating a non-existent "devm_of_phy_optional_get()". The
> "devm_of_phy_optional_get()" function is similar to the
> "devm_phy_optional_get()" function in the sense that the "serdes-phy" phy in the
> device-tree is optional and it is not truly an error if the property isn't present.

Yeah, I noticed while adding devm_phy_optional_get(), and looking for
possible users.
See "[PATCH treewide 0/7] phy: Add devm_of_phy_optional_get() helper"
https://lore.kernel.org/all/cover.1674036164.git.geert+renesas@glider.be

> Thank you for pointing out that if the Serdes driver is built as a module and
> the am65-cpsw driver runs first, then the "phy" returned for "serdes-phy" will
> be "-EPROBE_DEFER".
>
> >
> >> +       port->slave.serdes_phy = phy;
> >> +
> >> +       ret =  am65_cpsw_enable_phy(phy);
> >
> > ... so it will crash when dereferencing phy in phy_init().
> >
> > I think you want to add an extra check above:
> >
> >     if (IS_ERR(phy))
> >             return PTR_ERR(phy);
>
> Please let me know if posting a "Fixes" patch for fixing this net-next commit is
> the right process to address this.

I think it is, as devm_of_phy_optional_get() might not make it in time.

> >> @@ -1959,6 +2021,11 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
> >
> > Right out of context we have:
> >
> >                 port->slave.ifphy = devm_of_phy_get(dev, port_np, NULL);
> >                 if (IS_ERR(port->slave.ifphy)) {
> >                         ret = PTR_ERR(port->slave.ifphy);
> >                         dev_err(dev, "%pOF error retrieving port phy: %d\n",
> >                                 port_np, ret);
> >
> > So if there is only one PHY (named "serdes-phy") in DT, it will be
> > used for both ifphy and serdes_phy. Is that intentional?
>
> The PHY corresponding to "ifphy" is meant to be the CPSW MAC's PHY and not the
> Serdes PHY. The CPSW MAC's PHY is configured by the
> drivers/phy/ti/phy-gmii-sel.c driver and this is NOT an optional PHY, unlike the
> Serdes PHY. Therefore, it is assumed that the CPSW MAC's PHY is always provided
> in the device-tree, while the Serdes PHY is optional, depending on whether the
> Serdes is being configured for single-link protocol or multi-link protocol.
> Please let me know if this appears to be an issue and I will fix it based on
> your suggestion.

Hence this should be documented in the DT bindings. Please document
there can be 1 or 2 phys, with an optional "phys-names" property,
listing "ifphy" and "serdes-phy" (the DT people might request a rename).

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
