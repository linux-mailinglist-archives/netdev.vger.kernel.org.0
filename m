Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00663DDA70
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237098AbhHBOOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236412AbhHBONL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 10:13:11 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A66C044027;
        Mon,  2 Aug 2021 06:59:14 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id h9so15601933ejs.4;
        Mon, 02 Aug 2021 06:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MihKPbXWLuAHmHFbjCvlbQGWvDP7j/7zWzZnY5mOiqw=;
        b=sFa9Aa4INuqL14NQ4sv3j2caM780TjKWwuEefU4xzCpXWpu96Ssp6nDWTdUlPfwGbh
         1cTuMDghaIdyd7FwqZ++36zWyw+6K1PDjIyiK6haw4Ik+TZtWynM4Q9+xe7bG53WnSip
         r0rP/SIf2Tc/sY8ipxIe5amaIQJt4M7JRDTz6NKbcDJATQAGXC+Y0eAMZhy2UEj3cyuq
         Eb222JnZifkoCTGlRWD8IMMDx0uPaNHEjzf1SFvldkZHfQODOWhB3P4Z9WIivIDgPZJO
         60wjSOqdTVnb59O8vl9fXLqE9Bsy6gR7lDK1CrI2/7OqcoLbdfA/041kBi/dgadWF447
         7GFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MihKPbXWLuAHmHFbjCvlbQGWvDP7j/7zWzZnY5mOiqw=;
        b=WcSnP3EVMt8Mw6TZ3+jpemvTI+COovu//LUn+IF6Pbf1JQG6beqy+pEge6cx9MbZKU
         rw10apYIZig6vsH4UmaVkCO4fx9y2McXhpVnka86SnutF3euJyw53BA7rJonAYMuFuHZ
         7KoHnsXWVGrrZYC6J/Bk+nwe5/H3uYGDTSTxw2jQ0ke4GAMFVDXqMdWVtD9HtSBtGB4B
         Qs0kGCBAVY05QancFbMJLL9XnsRw7of0V/4fbfJpCL9gIZ82Va/PTFXLbZyVv5Y7GwZE
         5p7Ut3zwKno0mdGO8x5PEKqOFtx7+iGfwXF+tkjRLS0+7dJDGlaoNq1EP2PsaZfx6Anx
         Y68g==
X-Gm-Message-State: AOAM531H9jTz8QP8T7i0IpCFMJ/PXRapR26QLbXQKXn+hwgaOqWyisk4
        Fwyne7Sf97r/uCDlbkMIyxs=
X-Google-Smtp-Source: ABdhPJwpH+ntlOKfXt+DPJwa1ewViuJFhyfswfqjMUWJyaJWoA2ecLH0HFCLb8zfOP7fYTF0lPfUZg==
X-Received: by 2002:a17:906:309a:: with SMTP id 26mr15651618ejv.153.1627912753220;
        Mon, 02 Aug 2021 06:59:13 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id n17sm6102896edr.84.2021.08.02.06.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 06:59:12 -0700 (PDT)
Date:   Mon, 2 Aug 2021 16:59:11 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <20210802135911.inpu6khavvwsfjsp@skbuf>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
 <20210723173108.459770-6-prasanna.vengateshan@microchip.com>
 <20210731150416.upe5nwkwvwajhwgg@skbuf>
 <49678cce02ac03edc6bbbd1afb5f67606ac3efc2.camel@microchip.com>
 <20210802121550.gqgbipqdvp5x76ii@skbuf>
 <YQfvXTEbyYFMLH5u@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQfvXTEbyYFMLH5u@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 03:13:01PM +0200, Andrew Lunn wrote:
> In general, the MAC does nothing, and passes the value to the PHY. The
> PHY inserts delays as requested. To address Vladimir point,
> PHY_INTERFACE_MODE_RGMII_TXID would mean the PHY adds delay in the TX
> direction, and assumes the RX delay comes from somewhere else,
> probably the PCB.

For the PHY, that is the only portion where things are clear.

> I only recommend the MAC adds delays when the PHY cannot, or there is
> no PHY, e.g. SoC to switch, or switch to switch link. There are a few
> MAC drivers that do add delays, mostly because that is how the vendor
> crap tree does it.
> 
> So as i said, what you propose is O.K, it follows this general rule of
> thumb.

The "rule of thumb" for a MAC driver is actually applied in reverse by
most MAC drivers compared to what Russell described should be happening.
For example, mv88e6xxx_port_set_rgmii_delay():

	switch (mode) {
	case PHY_INTERFACE_MODE_RGMII_RXID:
		reg |= MV88E6XXX_PORT_MAC_CTL_RGMII_DELAY_RXCLK;

The mv88e6xxx is a MAC, so when it has a phy-mode = "rgmii-rxid", it
should assume it is connected to a link partner (PHY or otherwise) that
has applied the RXCLK delay already. So it should only be concerned with
the TXCLK delay. That is my point. I am just trying to lay out the
points to Prasanna that would make a sane system going forward. I am not
sure that we actually have an in-tree driver that is sane in that
regard.

That discussion, and Russell's point, was here, btw:
https://patchwork.ozlabs.org/project/netdev/patch/20200616074955.GA9092@laureti-dev/#2461123
