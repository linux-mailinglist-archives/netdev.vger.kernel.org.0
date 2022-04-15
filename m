Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29627502953
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352918AbiDOMEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 08:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350001AbiDOMET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 08:04:19 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBD0BABBC;
        Fri, 15 Apr 2022 05:01:51 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id bh17so15028334ejb.8;
        Fri, 15 Apr 2022 05:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uFnOdniEZzhGeU5i8rjIFmrAW7TBeR5ZN2MyiZEBz8s=;
        b=QmH5eyS6qYvGoAUvZaEGDQRhd/r3cGiozR5StIR2pL+myyqJG9BTGRDJmZxm69SlpJ
         eMsL6vgo8v3UZ+Q/365PBPdL7j3EwNIwIcxg8L31y5LQ3odXiOKK9tSe8Qt7kqP0g/MB
         umgSfRMNvuBh/w2LkcpFokbrehctAmyWHw0ZMyHvoz4SCmxMzbRRtv5GA76B7tNn4VMw
         l4VRI/H9h6vZvG3uN2x1azOm0MownhxdqEtcLbsWIthkEruZn4DNqHyeeS1zen7dnoln
         201PmuODCCyP0mTufJt1/hJWW/jrEL2HxTzmY+ZSD1yLX9E69LZbaOKJ3YS5UCgG7lHK
         /YuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uFnOdniEZzhGeU5i8rjIFmrAW7TBeR5ZN2MyiZEBz8s=;
        b=E5YntJr2iX3s56P0rPey91OfQgUcdboRE1spGCTrHVeuBes+OtdpzU7xShbSM51wnD
         ZUSv4IccUuV2UlY+vFSLlrCsp/fhVzPfPwPVgmnK2p4GCPnW7szLsOYnp4K7BcuMYfFo
         cm/mj/mf6GN/25qZe2Up4l4EptZ2wFJgnWcX5eXJEhQxx9Z31IE3EoLnx8US196a6LfU
         BSr1LTWEavQZEHTVesF5h7mfjbn8MxfF/WCc7b2ArpKSUKyuKR+hvb4idAEC8GEnygcu
         qBmmsna/wrUVedfKPcSoc47459mJ6zAW4cZ6AgcAXsfMcLQlG4Alk6IMN4ZCh8zgv2jD
         QBEA==
X-Gm-Message-State: AOAM532hEAQ39xXBrayPaKup5r4jOWFQXhT+UFLM96U3qMrPsjtux4cW
        QIc4AUOxNAhfBEPFUS+CkTk=
X-Google-Smtp-Source: ABdhPJweeKsXPOQXAEMTT5hXE3XzWzlnimZHxheCku1KYqIKD3sLxxG2xOgv9/bmAZIgA+Kh66Aesg==
X-Received: by 2002:a17:907:3f09:b0:6e8:4725:8247 with SMTP id hq9-20020a1709073f0900b006e847258247mr5856586ejc.605.1650024109987;
        Fri, 15 Apr 2022 05:01:49 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id q9-20020a170906770900b006d20acf7e2bsm1602517ejm.200.2022.04.15.05.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 05:01:49 -0700 (PDT)
Date:   Fri, 15 Apr 2022 15:01:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next 06/12] net: dsa: rzn1-a5psw: add Renesas RZ/N1
 advanced 5 port switch driver
Message-ID: <20220415120147.7ya2rwtxcldahh4n@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-7-clement.leger@bootlin.com>
 <20220414144709.tpxiiaiy2hu4n7fd@skbuf>
 <20220415113453.1a076746@fixe.home>
 <20220415105503.ztl4zhoyua2qzelt@skbuf>
 <YllQtjybAOF/ePfG@shell.armlinux.org.uk>
 <20220415111419.twrlknxuto4pri63@skbuf>
 <YllVsiN7YhaUkvQe@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YllVsiN7YhaUkvQe@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 12:23:30PM +0100, Russell King (Oracle) wrote:
> If ->shutdown has been called, the system is going down, and userspace
> is probably already dead.

There isn't anything preventing ->remove from being called after ->shutdown
has been called.

It all starts with the pattern that some driver authors prefer, which is
to redirect their ->shutdown method to ->remove. They argue that it
provides for a well-tested common path, so in turn, this pattern is
quite widespread and I'm not one to argue for removing it.

When such driver (redirecting ->shutdown to ->remove) is a bus driver
(SPI, I2C, lately even the fsl-mc bus), the implication is that the
controller will be unregistered on shutdown. To unregister a bus, you
need to unregister all devices on the bus too.

Due to implicit device ordering on the dpm_list, the ->shutdown() method
of children on said bus has already executed, now we're in the context
of the ->shutdown() procedure of the bus driver itself.

You can argue "hey, that's SPI/I2C and this is a platform driver, there
isn't any bus that unregisters on shutdown here", and you may have a
point there. But platform devices aren't just memory-mapped devices,
they can also be children of mfd devices on SPI/I2C buses. So in theory
you can see this pattern happen on platform devices as well.

This is the reason why I insist for uniformity in the DSA layer in the
way that shutdown is handled. People copy and paste code a lot, and by
leaving them with less variance in the code that they copy, subtle
differences that are not understood but do matter are less likely to
creep in.
