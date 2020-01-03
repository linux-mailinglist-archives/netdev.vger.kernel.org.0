Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E86612F8CF
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 14:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbgACNfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 08:35:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46510 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727508AbgACNfc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 08:35:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+G47s2y2Sg2fK9dxyGmLkDMSg3BWEgjGRsQXMWhTH40=; b=RZnmy0RktlxTOiaci5ujm5SkgM
        sj9PqJ5OSEpfxJWoVYB36/1Pl6K0jTQm3po3dG6SDD8Wfw9xjvt9SjWyCEuP5swCXyGVEtTEwFnUY
        FZ4JorisTE3hwC/tQNR9wyWBUIZYUMnkwi/R/PVkF7QxC5R6JPCQGGwhmmsAQMOmAZmE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1inN6p-0006JX-TD; Fri, 03 Jan 2020 14:35:23 +0100
Date:   Fri, 3 Jan 2020 14:35:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>
Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Message-ID: <20200103133523.GA22988@lunn.ch>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191223120730.GO25745@shell.armlinux.org.uk>
 <DB8PR04MB69858081021729EC70216BE3EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103092718.GB25745@shell.armlinux.org.uk>
 <20200103094204.GA18808@shell.armlinux.org.uk>
 <DB8PR04MB698591AAC029ADE9F7FFF69BEC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103125310.GE25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103125310.GE25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What I might be willing to accept is if we were to introduce
> XFI_10GBASER, XFI_10GBASEW, XFI_10GFC, XFI_G709 and their SFI
> counterparts - but, there would remain one HUGE problem with that,
> which is the total lack of specification of the board characteristics
> required to achieve XFI electrical compliance.

Hi Russell

The four RGMII variants are precedents for mixing protocol and
'electrical' properties, in terms of clock delays. But having four
RGMII variants has been a pain point, implementations getting it
wrong, etc.

So i would avoid mixing them in one property. I would prefer we keep
phy-mode as a protocol property, and we define additional DT
properties to describe the electrical parts of the SERDES interface.

Madalin, what electrical properties do you actually need in DT?  I
guess you need to know if it is using XFI or SFI. But that is only the
start. Do you want to place all the other properties in DT as well, or
are they in a board specific firmware blobs, and you just need to know
if you should use the XFI blob or the SFI blob?

We can probably define a vendor neutral DT property for XFI vs SFI,
but i expect all the other electrical properties are going to be
vendor specific.

       Andrew
