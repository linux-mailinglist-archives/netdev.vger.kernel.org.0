Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72BD312FB79
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 18:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgACRRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 12:17:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46722 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727952AbgACRRZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 12:17:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6DWrB1umXlgJmXfg/wK6IDqVDNHFHyv/eiqcp2/lHpg=; b=CROChRXS3rMrORIX6bjd5yfAep
        b5cz1zo4a2An628AzQ9qFS3uxXAVRedSDfGonVwm2E4oVnVV5V7iY+H8pB6kOp6qKZ/fTGMhJu/+z
        +9KnFhCrhNLLVc+pKHgaG9VuB+PaiZ6fI43OsKCkvySJelZ3kaK9z1i/nap662VrEJ44=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1inQZb-0000Yu-Ri; Fri, 03 Jan 2020 18:17:19 +0100
Date:   Fri, 3 Jan 2020 18:17:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>
Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Message-ID: <20200103171719.GM1397@lunn.ch>
References: <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191223120730.GO25745@shell.armlinux.org.uk>
 <DB8PR04MB69858081021729EC70216BE3EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103092718.GB25745@shell.armlinux.org.uk>
 <20200103094204.GA18808@shell.armlinux.org.uk>
 <DB8PR04MB698591AAC029ADE9F7FFF69BEC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103125310.GE25745@shell.armlinux.org.uk>
 <20200103133523.GA22988@lunn.ch>
 <DB8PR04MB6985AD897CC0159E324DF992EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6985AD897CC0159E324DF992EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> There are many things pushed down to u-boot so the Linux driver has less
> work to do, that's one of the reasons there is little left there.

I prefer barebox. Which is a problem, since it sounds like Ethernet
will be broken on your boards if i swap to it.

If you are going to offload setting up the hardware, please do it to
firmware. That is independent of the bootloader. The Marvell SoCs do
this for their low level SERDES setup, making SMC calls into the
firmware.

https://patchwork.kernel.org/cover/10880297/

> Ideally this dependency should be removed but then we'd need to make
> a clearer distinction. As you've noticed, currently I don't even
> need to distinguish XFI from SFI because for basic scenarios the
> code does the same thing.  Problem is, if I select a common
> denominator now, and later I need to make this distinction, I'll
> need to update device trees, code, etc. Just like "xgmii" was just
> fine as a placeholder until recently. I'd rather use a correct
> description now.

So it seems like you need two properties. You need a property to tell
your bootloader how to configure the electrical properties of the
SERDES, XFI, SFI, etc.

And you need a property to configure the protocol running over the
SERDES, which is phy-mode.

	Andrew
