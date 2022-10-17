Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5F2601ADD
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 23:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiJQVCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 17:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiJQVCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 17:02:37 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A2C1DA73;
        Mon, 17 Oct 2022 14:02:36 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id s30so17841649eds.1;
        Mon, 17 Oct 2022 14:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cc7Xg9SxU+d+qlYLmXHtIAZtphICLxRR7jvwC5zao74=;
        b=Ra8qxPUInt4KzYCIY9WAXRek0DRllcYiAiv/XbEby0Gj+tgFA6i4da1rUowKbSIM1R
         peTVKmUuEcbqizJfSIpnxa5s6HSnrbxJVOi9bdFHNkAkqSMH76rhPFSFom+0bfl/gbiq
         dq4/cGg2pABI56VneKLGr9/CZvvVGkocwRj2xPuK1eOmUwU5O6UYxSsmV6hsuoKgWtCI
         gTGC0eHZWmLGJLGbtalWbkatnRMG1p2YuddxQNjkF/IIFmQHYYqbjZWhcE4SNU1M6nDg
         XBJOUeb2FQto9k3REF5r9OXKcf95kupBEuSx+L4GDkr4LSV1U4czdG78q5QbOP1AXejn
         NrHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cc7Xg9SxU+d+qlYLmXHtIAZtphICLxRR7jvwC5zao74=;
        b=0MwtTS4g3o/SUxyn4aHjT6232koesGoIHxVtr5cjK8j4zeyvGI485rqN9LktR55odZ
         H8NCIXiEOU1157BIhTaoj6BYZY8/Epl3TyQlIxu982HDsE709u2uP7C+41Gew1XxZ7jg
         NrVPHx/OZPnpqigVdh8a1J4RnZsN/xlbSvGqAdCP66y38Ue8RignEEw8NGW64Dta8JJj
         eTLNCLfQw1RGVQI5CsK+LYXHKJuLs3uDyRjhfC+7sZatOkQ9LhtQ+gTOfP1fcC2aq5Wo
         aaSgFT7XieiSvG6F16HuUxBxq3FD/z5+h/REEgVtFuh9ie/UhzldIN3Ro9gCDYfozAi5
         NleA==
X-Gm-Message-State: ACrzQf0TPe3vlfBhhmev9tUcnYWOQ+rCbHjMAF1vrEFC7YZnFgbfWYCC
        QeYM9lTiVhkhYsniBtpD/jY=
X-Google-Smtp-Source: AMsMyM5zUfnt7ZcThWnsNOBjHUzDwCt1/x/fWWM+rCbAm+docH0KZP2XUhjqu8Jp4Lx2N2e2vgEy1A==
X-Received: by 2002:aa7:c314:0:b0:458:dc90:467a with SMTP id l20-20020aa7c314000000b00458dc90467amr11404684edq.284.1666040555130;
        Mon, 17 Oct 2022 14:02:35 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id f19-20020a056402195300b00459cd13fd34sm7932499edz.85.2022.10.17.14.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 14:02:34 -0700 (PDT)
Date:   Tue, 18 Oct 2022 00:02:32 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry.Ray@microchip.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next][PATCH v4] dt-bindings: dsa: Add lan9303 yaml
Message-ID: <20221017210232.7splojlm6kjijj2k@skbuf>
References: <20221003164624.4823-1-jerry.ray@microchip.com>
 <20221003164624.4823-1-jerry.ray@microchip.com>
 <20221008225628.pslsnwilrpvg3xdf@skbuf>
 <MWHPR11MB1693771FDBEFA284B490DF71EF299@MWHPR11MB1693.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1693771FDBEFA284B490DF71EF299@MWHPR11MB1693.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 17, 2022 at 08:00:13PM +0000, Jerry.Ray@microchip.com wrote:
> >> ---
> >> v3->v4:
> >>  - Addressed v3 community feedback
> >
> >More specifically?
> >
> 
> - Old lan9303.txt file is totally removed rather than containing text that
>   redirects the user to the microchip,lan9303.yaml source file.
> - Drop "Tree Bindings" from title
> - Drop quotes from dsa.yaml reference line.
> - Modified the compatible second enum to include a second string.
> (( I now realize this is not what was being asked for and have made
>   it a single enum with 4 items, removing the oneOf. ))
> - Drop "gpio specifier for a" in reset-gpois description
> - added a default: property to the reset-duration item and set it to 200.
> - Drop "0" from the ethernet name.  Split the MDIO and I2C examples into
>   two so that the number is no longer needed.
> - Placed the reg property to be directly following the compatible string
>   in the mdio node.

Please carry the change log for v3->v4 also for future versions.

> >> +examples:
> >> +  - |
> >> +    #include <dt-bindings/gpio/gpio.h>
> >> +
> >> +    // Ethernet switch connected via mdio to the host
> >> +    ethernet {
> >> +        #address-cells = <1>;
> >> +        #size-cells = <0>;
> >> +        phy-handle = <&lan9303switch>;
> >> +        phy-mode = "rmii";
> >> +        fixed-link {
> >> +            speed = <100>;
> >> +            full-duplex;
> >> +        };
> >
> >I see the phy-handle to the switch is inherited from the .txt dt-binding,
> >but I don't understand it. The switch is an mdio_device, not a phy_device,
> >so what will this do?
> >
> >Also, any reasonable host driver will error out if it finds a phy-handle
> >and a fixed-link in its OF node. So one of phy-handle or fixed-link must
> >be dropped, they are bogus.
> >
> >Even better, just stick to the mdio node as root and drop the DSA master
> >OF node, like other DSA dt-binding examples do. You can have dangling
> >phandles, so "ethernet = <&ethernet>" below is not an issue.
> >
> 
> I can remove the phy-handle, but I'm trying to establish the link between
> this ethernet port and port0 (the CPU port) of the lan9303.  The lan9303
> acts as the phy for this ethernet port and I want to force the speed and
> duplex of the link to be 100 / full-duplex.

If the lan9303 acts as the PHY, then what do you need to force the speed
and duplex for? PHYs have a standard MDIO register set which gives you
that information.

I can understand a switch acting as a PHY towards Linux if you want to
hide the fact that it's a switch, and pretend it's just a regular port
going to the outside world (and maybe the switch is self-managed via a
microcontroller or something). But what purpose does this serve when
Linux is already in control of both ends of the link?

And furthermore, why would the MDIO-managed switch have a phy-handle
towards it, but the I2C managed switch not? If the host Ethernet
controller can tolerate not knowing the link state and being forced to a
given speed/duplex when the switch is I2C controlled, why can it not
also tolerate being forced when the switch has registers accessed in MDIO mode?

Lastly, when you have a phy-handle towards the switch, there will run 2
driver instances in parallel which will access the same hardware. What
PHY driver will phylib use for the RevMII/RevRMII emulated register map
of the CPU port? Will the registers accessed by the PHY driver collide
in any way with the registers accessed by the DSA driver? What if paged
MDIO access is used; how is synchronization between the 2 drivers handled?

> >> +    #include <dt-bindings/gpio/gpio.h>
> >> +
> >> +    // Ethernet switch connected via i2c to the host
> >> +    ethernet {
> >> +        #address-cells = <1>;
> >> +        #size-cells = <0>;
> >> +        phy-mode = "rmii";
> >> +            speed = <100>;
> >> +        fixed-link {
> >> +            full-duplex;
> >> +        };
> >> +    };
> >
> >No need for this node.
> >
> 
> Without this, what does the port0 entry below have to point to?
> How do you establish the device tree linkage between the ethenet
> MAC and the rev-rmii PHY it connects to?

To repeat myself, the ethernet = <&ethernet> phandle in port@0 can be
broken (not point to anything) in the dt-schema examples. Same as for
interrupt-parent, gpios, clocks, etc etc. Check out any .example.dts
generated by "make dt_binding_check", it has this at the top:

/plugin/; // silence any missing phandle references
