Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932503EC286
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 14:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238365AbhHNMCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 08:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238064AbhHNMCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 08:02:43 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54305C061764;
        Sat, 14 Aug 2021 05:02:15 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id lo4so23096575ejb.7;
        Sat, 14 Aug 2021 05:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qpQN2aTKtGCMgoh9M7a5uv16Wg9lA0To7j/jpu/dotM=;
        b=bKS4yGk6Fti2p1kFwiaS16i4xy5dlAA1rLYFW1Zxr+tWuJQwVgl+4zSh02FZ238J1j
         WcaESiPePl+mM9B6+Z4raxEVXELqC4/r1uiGmtpx12MsAP+4dOmAJDQsMVy4IqRDyGyJ
         JHPxEa9VwvG4Q/MglkZ6WFXG2QXlIOutehxfvMuowqLY/H0JGQHAqtw0uUsljI7UrJDS
         pkw449U2HCXW87ukHgh1KeIJR8P5D6d1Gr5ZB8kAZtL6q6N4ytwqlyaLFMTPjqfWQKaS
         7S21qTLEvcMx4ucd0jlqUuqf6ZtdcaGvqoXAohcsfJaocLZEC+I6RTpXBJiqYyQwYdn/
         dvpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qpQN2aTKtGCMgoh9M7a5uv16Wg9lA0To7j/jpu/dotM=;
        b=ii2TRoWRjcplHpxia5s4YyBKRsvQtETDgXPK/ci3bsMxorsq4fsop2SvPJU2TxNzsU
         LrNAj1gxycHkqREv0ots9b6/CGiLG8RJ0bTRtUoT77okpXhMaOxn3pM89pknkr8DCQTu
         ZgDnqFjHVo8B/fHGEPkz5AhbDy8vDXfN27SaXuYnviklXV9dRNmOQ5ADNSPClRbV9HK1
         NR+J14h3xXq1++BdBT9CXUHRgXg32Jb2DfPzlrxMZo9XS8fan3jSpfYi+j/Yy3OTc5UU
         SdnB14IB8WN+V6td4L+xkSV8yNouO09OpVo9SjU6a8sMHUbvbZDP5+JPan1RlSMdzHA5
         oFlg==
X-Gm-Message-State: AOAM532nczJrNnm9AEs1DvAH0ZX//GU0UZveOhFAW+PV3AukwjNHFoJX
        2acTEX03Yp4E4Aegm3NDats=
X-Google-Smtp-Source: ABdhPJyCAxqPk9pWqGfFemQsR7dWguvr+DAPui5Ks4oZDkZ9auxKP2h5JpJMabC1Cb/smYB3U+kkRQ==
X-Received: by 2002:a17:906:13d2:: with SMTP id g18mr7170183ejc.280.1628942533886;
        Sat, 14 Aug 2021 05:02:13 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id u2sm2172760edd.82.2021.08.14.05.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 05:02:13 -0700 (PDT)
Date:   Sat, 14 Aug 2021 15:02:11 +0300
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
Message-ID: <20210814120211.v2qjqgi6l3slnkq2@skbuf>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-10-colin.foster@in-advantage.com>
 <20210814114329.mycpcfwoqpqxzsyl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210814114329.mycpcfwoqpqxzsyl@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 02:43:29PM +0300, Vladimir Oltean wrote:
> The issue is that the registers for the PCS1G block look nothing like
> the MDIO clause 22 layout, so anything that tries to map the struct
> ocelot_pcs over a struct mdio_device is going to look like a horrible
> shoehorn.
> 
> For that we might need Russell's assistance.
> 
> The documentation is at:
> http://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10489.pdf
> search for "Information about the registers for this product is available in the attached file."
> and then open the PDF embedded within the PDF.

In fact I do notice now that as long as you don't use any of the
optional phylink_mii_c22_pcs_* helpers in your PCS driver, then
struct phylink_pcs has pretty much zero dependency on struct mdio_device,
which means that I'm wrong and it should be completely within reach to
write a dedicated PCS driver for this hardware.

As to how to make the common felix.c work with different implementations
of struct phylink_pcs, one thing that certainly has to change is that
struct felix should hold a struct phylink_pcs **pcs and not a
struct lynx_pcs **pcs.

Does this mean that we should refactor lynx_pcs_create() to return a
struct phylink_pcs * instead of struct lynx_pcs *, and lynx_pcs_destroy()
to receive the struct phylink_pcs *, use container_of() and free the
larger struct lynx_pcs *? Yes, probably.

If you feel uncomfortable with this, I can try to refactor lynx_pcs to
make it easier to accomodate a different PCS driver in felix.
