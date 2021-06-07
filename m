Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C3D39DD5D
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 15:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhFGNOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 09:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhFGNO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 09:14:29 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68373C061766;
        Mon,  7 Jun 2021 06:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mzx+toA+I5GhMZJQ4bshpMENsBCltPEDS9fQ3Twfj7g=; b=bd0/P2zv8OxN2aVXSWnOUmYg/
        aAmWH4AskdREZQW0GRs6yatKOr8pzi8lUzSILehQ1+JrS469ZEehPY66eojybpFjQcaFuQIATEL1G
        smkIGo30rk+3bnoIdEWQn1nLjOBIgeewLXNrg75mpVuaANWFym9dPQlraYGiex+6ZtpDlzK0zhsH7
        gg0CCwD7Lm4LAl6tcmC5SfXNVMqLHF8K5kE4DTtyJH7QA5kQgpdP2kvB2Nl60FdgDIToKC+LbNfKV
        wFDsi20DA506bpZ3g2fAoooHoCR8x+iD2uAYipfJ048acaFGSssrrrtLZyxqZtV4oI1NgucOXF6vE
        xreUBIc5w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44794)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lqF3Q-0000YM-At; Mon, 07 Jun 2021 14:12:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lqF3P-0005xU-Vc; Mon, 07 Jun 2021 14:12:31 +0100
Date:   Mon, 7 Jun 2021 14:12:31 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Simon Horman <simon.horman@netronome.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next v3 04/10] net: sparx5: add port module support
Message-ID: <20210607131231.GF22278@shell.armlinux.org.uk>
References: <20210604085600.3014532-1-steen.hegelund@microchip.com>
 <20210604085600.3014532-5-steen.hegelund@microchip.com>
 <20210607092136.GA22278@shell.armlinux.org.uk>
 <d5ffe24ce7fbe5dd4cc0b98449b0594b086e3ba9.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5ffe24ce7fbe5dd4cc0b98449b0594b086e3ba9.camel@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jun 07, 2021 at 02:46:44PM +0200, Steen Hegelund wrote:
> Hi Russell,
> 
> Thanks for your comments.
> 
> On Mon, 2021-06-07 at 10:21 +0100, Russell King (Oracle) wrote:
> > It looks to me like the phylink code in your patch series is based on
> > an older version of phylink and hasn't been updated for the split PCS
> > support - you seem to be munging the PCS parts in with the MAC
> > callbacks. If so, please update to the modern way of dealing with this.
> > 
> > If that isn't the case, please explain why you are not using the split
> > PCS support.
> 
> I need to be able to let the user set the speed to get the link up.
> 
> So far I have only been able to get the user configured speeds via the mac_ops, but if this is also
> possible via the pcs_ops, there should not anything preventing me from using these ops instead.
> 
> Will the pcs_ops also support this?

I really don't understand what you're saying here, so I can't answer.

What exactly do you mean "user configured speeds" ? Please give
examples of exactly what you're wanting to do.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
