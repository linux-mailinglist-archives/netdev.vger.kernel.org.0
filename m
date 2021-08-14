Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063323EC272
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 13:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238298AbhHNLoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 07:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238147AbhHNLoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 07:44:01 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF62C061764;
        Sat, 14 Aug 2021 04:43:32 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id u3so23190443ejz.1;
        Sat, 14 Aug 2021 04:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=icOROKq9/08zimcpHL9b3PprA266pg098dhoPyGfhOY=;
        b=oel1ia603A8lwu4S0Ilk//SfSX8xlZACWnMz5l1nxiCq4r4zi/hrXJaELjwp2Jsrzx
         oZyImgAVwSCi1ME/a7nthklE73jJQgH/Wl0WV3yHPd0I04+FI7G9EVK4pelGiWMVGeoH
         6OK8F08julxpnCwFDsNoM0aj4nFK0S7pRKGYtGxRVebyzmTcn7DOrgULGaZ5bDGSanTU
         C+6vfGx7MlZhSAq8gO0duqc4n4evDBIfU+azEvN/u0d0eisBJ/f/0rjAajIlA/wGmFIf
         picV4SilLgWCk8QQdUlPN4kgiiyS8aKuU1d5B59VzxxShNegKjAwwJDub0mgJAxmsuss
         7K1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=icOROKq9/08zimcpHL9b3PprA266pg098dhoPyGfhOY=;
        b=KG4AeEXsY6pZQ3xsNqsji/6GYkMbMreT78SpHalDXC/4aVqpPnbMnkk+MZGrwIghLS
         85K02pRDzDS0fyiCsDUTEQ7+cdn2JAEJE1s84faVYL3I4nKSorFAPKjH7EYkYrZpy+AH
         fSmfSTlYVG9QRm9emISYYSLuFW+L//sIoKRH4FBB0M/TbCEHGVmF0Gy5V9qRdeWTWOWz
         cDCGGP3cdREd3PpERtB+5xrBWTeiFuVJN1QRTFtVIRiI+D63CL7n7dJWEm2iP8wuSAEu
         LgbQbFHCToeijUrwG7cJDsrfMDktF95wAZqr/mobgaQiX7scMuTCL0bdeiYv9k3TccAa
         XO5A==
X-Gm-Message-State: AOAM5313diXlpCOVHoQxd3kMzujSL/OelkgNM6VL2h+rwImNfKIQ9g+t
        N9sPv8GxZDT1RAe1ZOS8l1s=
X-Google-Smtp-Source: ABdhPJyWs7LzG8QG+GtrVryGqGDOQ578gGXGx2cxLutV/8h3s5UEZqWRW462GYF4RfSrSvC2FBIWYQ==
X-Received: by 2002:a17:906:4b47:: with SMTP id j7mr6879002ejv.148.1628941411268;
        Sat, 14 Aug 2021 04:43:31 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id n26sm2139734eds.63.2021.08.14.04.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 04:43:30 -0700 (PDT)
Date:   Sat, 14 Aug 2021 14:43:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 09/10] net: dsa: ocelot: felix: add
 support for VSC75XX control over SPI
Message-ID: <20210814114329.mycpcfwoqpqxzsyl@skbuf>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-10-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210814025003.2449143-10-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 07:50:02PM -0700, Colin Foster wrote:
> +/* Code taken from ocelot_adjust_link. Since we don't have a phydev, and
> + * therefore a phydev->link associated with the NPI port, it needs to be enabled
> + * blindly.
> + */

This makes no sense. You do have a phylink associated with the NPI port,
see for yourself, all of felix_phylink_mac_link_up, felix_phylink_mac_config,
felix_phylink_validate get called for the NPI port.

The trouble, really, is that what is done in felix_phylink_mac_link_up
is not sufficient for your hardware. The felix_vsc9959 and seville_vsc9953
drivers are Microchip switches integrated with NXP PCS, and the NXP PCS
has a dedicated driver in drivers/net/pcs/pcs-lynx.c.

So you won't see any of the PCS1G writes in the common driver, because
NXP integrations of these switches don't have that block.

This is not the proper way to do things. You are "fixing" SGMII for the
NPI/CPU port by pretending it's an NPI port issue, but in reality all
the other ports that use SGMII need the same treatment.

What we might need is a dedicated PCS driver for the VSC7512 switch, and
a way for the felix driver to interchangeably work with either struct
lynx_pcs or struct ocelot_pcs (or whatever it's going to be called).

The issue is that the registers for the PCS1G block look nothing like
the MDIO clause 22 layout, so anything that tries to map the struct
ocelot_pcs over a struct mdio_device is going to look like a horrible
shoehorn.

For that we might need Russell's assistance.

The documentation is at:
http://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10489.pdf
search for "Information about the registers for this product is available in the attached file."
and then open the PDF embedded within the PDF.
