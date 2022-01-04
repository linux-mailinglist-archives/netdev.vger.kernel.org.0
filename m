Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10DC48409C
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 12:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbiADLOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 06:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbiADLOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 06:14:55 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093A3C061761;
        Tue,  4 Jan 2022 03:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MM0pgbZt8GZt1P5d/6tqfs3rv9NDQ5AH4PVwXzjtAyM=; b=vKNjMZobpKbfIB+rA2RcB4MOY1
        cOCFBlyCgj/EjLmUX9h9anzPmd7OlZYYo7WieCFlv5GuaelJozpr6nRqMak2rHNMsf8LtnRe+vJmG
        81eYpUszx/MP0Z/3jWM4/iSiLDjIVnnz3wOvbqKwB83e3k5cbaSBucU4GmJMNMOmoJ8Gj6dAt3V/f
        7Akn2MuCOw86KnEkxV1XzSb5z4ZaFrdgMtcpGh0SIMDWjHPt0fTJfGgHQhq46wULJ9XmAFOU8XHyq
        kquUppmUeNppa290wa9MNVoy7LYljlOvxOdsemma5kaWt5mz+Om9CGsLutWHiG9SraV9YPuYz/XzI
        hprnb3SA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56552)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n4hmC-0006uZ-Bq; Tue, 04 Jan 2022 11:14:48 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n4hmA-0007BX-Ov; Tue, 04 Jan 2022 11:14:46 +0000
Date:   Tue, 4 Jan 2022 11:14:46 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     linus.walleij@linaro.org, ulli.kroll@googlemail.com,
        kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: marvell: network working with generic PHY and not with
 marvell PHY
Message-ID: <YdQsJnfqjaFrtC0m@shell.armlinux.org.uk>
References: <YdQoOSXS98+Af1wO@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdQoOSXS98+Af1wO@Red>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 11:58:01AM +0100, Corentin Labbe wrote:
> Hello
> 
> I have a gemini SSI 1328 box which has a cortina ethernet MAC with a Marvell 88E1118 as given by:
> Marvell 88E1118 gpio-0:01: attached PHY driver (mii_bus:phy_addr=gpio-0:01, irq=POLL)
> So booting with CONFIG_MARVELL_PHY=y lead to a non-working network with link set at 1Gbit
> Setting 'max-speed = <100>;' (as current state in mainline dtb) lead to a working network.
> By not working, I mean kernel started with ip=dhcp cannot get an IP.

How is the PHY connected to the host (which interface mode?) If it's
RGMII, it could be that the wrong RGMII interface mode is specified in
DT.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
