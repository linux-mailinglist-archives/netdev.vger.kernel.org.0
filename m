Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68AD83DC2B2
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 04:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235763AbhGaC32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 22:29:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54846 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231335AbhGaC31 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 22:29:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fTMpPnF7MNPIeWiCWwW2KmQn0PAalSgBt+h2ZsLcBHU=; b=l/Uryn7pXFoajvjHHL7k0N/Krr
        4ZZhnM75MOm+LJCvJh+wASnN667p+KNfS7Vq+5Q8rwjN06d9RhSlnl9DVOiAEcWeS4yulFwlBpvrP
        UCwBceM7Jt1KzmZchFuSKSOO+PyYsCIBNuAvzUeHXrvP5fbsVzEhsn/cwbbntAoKrOYk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m9ekJ-00FYZR-Ab; Sat, 31 Jul 2021 04:29:03 +0200
Date:   Sat, 31 Jul 2021 04:29:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Walker <danielwa@cisco.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Balamurugan Selvarajan <balamsel@cisco.com>,
        xe-linux-external@cisco.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC-PATCH] net: stmmac: Add KR port support.
Message-ID: <YQS1bzsIAD83+762@lunn.ch>
References: <20210729234443.1713722-1-danielwa@cisco.com>
 <YQNrmB9XHkcGy5D0@lunn.ch>
 <20210730144830.GO1633923@zorba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730144830.GO1633923@zorba>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 07:48:30AM -0700, Daniel Walker wrote:
> On Fri, Jul 30, 2021 at 05:01:44AM +0200, Andrew Lunn wrote:
> > On Thu, Jul 29, 2021 at 04:44:42PM -0700, Daniel Walker wrote:
> > > From: Balamurugan Selvarajan <balamsel@cisco.com>
> > > 
> > > For KR port the mii interface is a chip-to-chip
> > > interface without a mechanical connector. So PHY
> > > inits are not applicable. In this case MAC is
> > > configured to operate at forced speed(1000Mbps)
> > > and full duplex. Modified driver to accommodate
> > > PHY and NON-PHY mode.
> > 
> > I agree with Florian here. Look at all the in kernel examples of a SoC
> > MAC connected to an Ethernet switch. Some use rgmii, others 1000BaseX
> > or higher. But they all follow the same scheme, and don't need
> > invasive MAC driver changes.
> 
> 
> Can you provide the examples which you looked at ?

There are plenty of examples using Freescale FEC and Marvell Ethernet
switches:

arch/arm/boot/dts/vf610-zii-dev-rev-b.dts

Or the Mavell based

arch/arm/boot/dts/armada-xp-linksys-mamba.dts

	Andrew
