Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4625F327A
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 17:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiJCP2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 11:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiJCP2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 11:28:34 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD45926AD3;
        Mon,  3 Oct 2022 08:28:29 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a26so22964100ejc.4;
        Mon, 03 Oct 2022 08:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=6XN9T4bVHRoTLrA3LFyXh0TLPbIeGy3QK5N9LtYhnms=;
        b=jBk+aQkNYGP8x+fcpAa+87CTAk8CddOBFFVcrUm67r3Cr5bvPdWqK1ARDyiggmv+oT
         V8FHHyVsOse3C+Xiv55EXlwoEVLz0L0sFb1Laqg4a1lPuOlB6tGID3iRln2dA3/GR18H
         3cNYDuwCUmnZXDZojPAcEL2mx1X4EKUTK8sFa/a9iL5Z84ivBWkw5wBMm7XQ3PspXB4f
         ZUcJDuSlAmXbynHECJ+Ycbl0QVepuau6YvWZC3BArVnPXRCW7Ik02Ywj1YsdvF6xev3R
         Xpli+I9du6yyi0AS5s3iqFCL8MU2iYTirKo/5sn8L5tQ7pCiE0+ZF56hOgkAHK9uErKf
         bVAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=6XN9T4bVHRoTLrA3LFyXh0TLPbIeGy3QK5N9LtYhnms=;
        b=I8MSDWyxO1qrEs9EnYjgP083B3W/VYJuP9G9fgPuEK3j5I/Jhd4pQliVzNDuFxR5aa
         as3m2emRaZVCUKK9TY5CcvES+BzlhQaxFzd2Nl/G5EYiC24mJOO4GTVtdkiQ8uE1QolQ
         Gq8TWs0+WdrTBItKAi/ViUauzQNTwf17pyn423PbbPEwRJ5UHmncxLZitlEVvEsYPXTC
         8mFFdj5iOyGQ1/EkFT3FAJ+f9aszD7x1QzgzZAYGijR6EEBy1msb9wKLyKh0/CJ4Z7Ax
         CRtx7oXwyp9C5CXBENk2aihUaTl7L7sKYvQCJM7jlGvD255iFUTavPorUVlRADYrYF/a
         dvnw==
X-Gm-Message-State: ACrzQf13X1wIDPXXUHBksA8mvdg3PLLShB2RaDvS1nsh2s0xbBsOHbpe
        jx9PHh9Pcc229y9Rbrmo4ZQ=
X-Google-Smtp-Source: AMsMyM49oGkn7YBZX2Wcd0AYsPGAhbs2otIECgwtKk3TCEGHk216PxkVKkLhNNoNPCDh0DyXqys6zA==
X-Received: by 2002:a17:906:4fca:b0:782:2484:6d72 with SMTP id i10-20020a1709064fca00b0078224846d72mr15814667ejw.150.1664810907697;
        Mon, 03 Oct 2022 08:28:27 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906200900b00780f6071b5dsm5629510ejo.188.2022.10.03.08.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 08:28:27 -0700 (PDT)
Date:   Mon, 3 Oct 2022 18:28:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Message-ID: <20221003152824.fr6ufy6uf7jb34ne@skbuf>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <20220927202600.hy5dr2s6j4jnmfpg@skbuf>
 <Yzdcjh4OTI90wWyt@euler>
 <YzeHxmYMjMoDqIHe@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzeHxmYMjMoDqIHe@euler>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 05:20:22PM -0700, Colin Foster wrote:
> On Fri, Sep 30, 2022 at 02:15:58PM -0700, Colin Foster wrote:
> > On Tue, Sep 27, 2022 at 11:26:00PM +0300, Vladimir Oltean wrote:
> > > On Sun, Sep 25, 2022 at 05:29:26PM -0700, Colin Foster wrote:
> > > > ---
> > > > +      - phy-mode = "internal": on ports 0, 1, 2, 3
> > > 
> > > More PHY interface types are supported. Please document them all.
> > > It doesn't matter what the driver supports. Drivers and device tree
> > > blobs should be able to have different lifetimes. A driver which doesn't
> > > support the SERDES ports should work with a device tree that defines
> > > them, and a driver that supports the SERDES ports should work with a
> > > device tree that doesn't.
> > 
> > This will change my patch a little bit then. I didn't undersand this
> > requirement.
> > 
> > My current device tree has all 8 ethernet ports populated. ocelot_ext
> > believes "all these port modes are accepted" by way of a fully-populated
> > vsc7512_port_modes[] array.
> > 
> > As a result, when I'm testing, swp4 through swp7 all enumerate as
> > devices, though they don't actually function. It isn't until serdes /
> > phylink / pcs / pll5 come along that they become functional ports.
> > 
> > I doubt this is desired. Though if I'm using the a new macro
> > OCELOT_PORT_MODE_NONE, felix.c stops after felix_validate_phy_mode.
> > 
> > I think the only thing I can do is to allow felix to ignore invalid phy
> > modes on some ports (which might be desired) and continue on with the
> > most it can do. That seems like a potential improvement to the felix
> > driver...
> > 
> > The other option is to allow the ports to enumerate, but leave them
> > non-functional. This is how my system currently acts, but as I said, I
> > bet it would be confusing to any user.
> > 
> > Thoughts?

Having the interfaces probe but not work isn't the worst, but if we
could make just the SERDES ports fail to probe, it would be better.

> Also, for what its worth, I tried this just now by making this change:
> 
> err = felix_validate_phy_mode(felix, port, phy_mode);
> if (err < 0) {
>         dev_err(dev, "Unsupported PHY mode %s on port %d\n",
>                 phy_modes(phy_mode), port);
>         of_node_put(child);
>  -      return err;
>  +      continue;
> }
> 
> This functions in that I only see swp1-swp3, but I don't think it
> should - it is just leaving phy_mode set to 0 (PHY_INTERFACE_MODE_NA).

You could add a comment above the "continue" statement explaining this.

> My guess is it'll need more logic to say "don't add these DSA ports because
> the driver doesn't support those PHY interfaces"
> 
> [    3.555367] ocelot-switch ocelot-switch.4.auto: Unsupported PHY mode qsgmii on port 4
> [    3.563551] ocelot-switch ocelot-switch.4.auto: Unsupported PHY mode qsgmii on port 5
> [    3.571570] ocelot-switch ocelot-switch.4.auto: Unsupported PHY mode qsgmii on port 6
> [    3.579459] ocelot-switch ocelot-switch.4.auto: Unsupported PHY mode qsgmii on port 7
> [    4.271832] ocelot-switch ocelot-switch.4.auto: PHY [ocelot-miim0.2.auto-mii:00] driver [Generic PHY] (irq=POLL)
> [    4.282715] ocelot-switch ocelot-switch.4.auto: configuring for phy/internal link mode
> [    4.296478] ocelot-switch ocelot-switch.4.auto swp1 (uninitialized): PHY [ocelot-miim0.2.auto-mii:01] driver [Generic PHY] (irq=POLL)
> [    4.312876] ocelot-switch ocelot-switch.4.auto swp2 (uninitialized): PHY [ocelot-miim0.2.auto-mii:02] driver [Generic PHY] (irq=POLL)
> [    4.328897] ocelot-switch ocelot-switch.4.auto swp3 (uninitialized): PHY [ocelot-miim0.2.auto-mii:03] driver [Generic PHY] (irq=POLL)
> [    5.032849] ocelot-switch ocelot-switch.4.auto swp4 (uninitiailized): validation of qsgmii with support 00000000,00000000,000062ff and advertisement 00000000,00000000,000062ff failed: -EINVAL
> [    5.051265] ocelot-switch ocelot-switch.4.auto swp4 (uninitialized): failed to connect to PHY: -EINVAL
> [    5.060670] ocelot-switch ocelot-switch.4.auto swp4 (uninitialized): error -22 setting up PHY for tree 0, switch 0, port 4
> (repeated for swp5-7)

I think the behavior is correct and sufficient. The ocelot driver always
requires a valid phy-mode in the device tree for all ports, and
PHY_INTERFACE_MODE_NA means the lack of one. In turn, this is enough to
make phylink_validate() fail with any valid device tree. And DSA is
smart enough to limp on with the rest of its ports if phylink setup
failed for some of them - see dsa_port_setup_as_unused() in the current
net-next git tree.

If you don't think this is enough, you could also patch felix_phylink_get_caps()
to exclude ocelot->ports[port]->phy_mode == PHY_INTERFACE_MODE_NA from
applying this assignment (which would make config->supported_interfaces
remain empty):

	__set_bit(ocelot->ports[port]->phy_mode,
		  config->supported_interfaces);
