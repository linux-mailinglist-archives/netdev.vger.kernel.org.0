Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA4607013F
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 15:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbfGVNk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 09:40:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55898 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727510AbfGVNk2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 09:40:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=m+J1fo9vC+WNoRkwu0Z8WI8RZOnFX+pR10avPTXahe0=; b=YTqDgeSQ3BEPwTEjGIIxaQJjEs
        6faT7OpX0YBbbl5MGRow7+NXfIducm9Bqgo0fGJ/tEajMGReX3iorXyIVXnAsQjKfY6MgEUttxK7+
        X/oka7lwuQcnYVYfVqVduUS7yDVpne3tuBHviPNhd7RPHiXXyioYLebkrGCM9MAa2yj0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hpYYB-0002x6-Uc; Mon, 22 Jul 2019 15:40:23 +0200
Date:   Mon, 22 Jul 2019 15:40:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     =?utf-8?Q?Ond=C5=99ej?= Jirman <megi@xff.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 0/3] net: stmmac: Convert to phylink
Message-ID: <20190722134023.GD8972@lunn.ch>
References: <cover.1560266175.git.joabreu@synopsys.com>
 <20190722124240.464e73losonwb356@core.my.home>
 <BN8PR12MB32660B12F8E2617ED42249BBD3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN8PR12MB32660B12F8E2617ED42249BBD3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 22, 2019 at 01:28:51PM +0000, Jose Abreu wrote:
> From: Ondřej Jirman <megi@xff.cz>
> Date: Jul/22/2019, 13:42:40 (UTC+00:00)
> 
> > Hello Jose,
> > 
> > On Tue, Jun 11, 2019 at 05:18:44PM +0200, Jose Abreu wrote:
> > > [ Hope this diff looks better (generated with --minimal) ]
> > > 
> > > This converts stmmac to use phylink. Besides the code redution this will
> > > allow to gain more flexibility.
> > 
> > I'm testing 5.3-rc1 and on Orange Pi 3 (uses stmmac-sun8i.c glue) compared to
> > 5.2 it fails to detect 1000Mbps link and the driver negotiates just a 10Mbps speed.
> > 
> > After going through stmmac patches since 5.2, I think it may be realted to this
> > series, but I'm not completely sure. You'll probably have a better understanding
> > of the changes. Do you have an idea what might be wrong? Please, see some logs
> > below.
> 
> Probably due to:
> 5b0d7d7da64b ("net: stmmac: Add the missing speeds that XGMAC supports")
> 
> Can you try attached patch ?
> 

Hi Jose

Does this mean that all stmmac variants support 1G? There are none
which just support Fast Ethernet?

I'm also not sure the change fits the problem. Why did it not
negotiate 100FULL rather than 10Half? You are only moving the 1G
speeds around, so 100 speeds should of been advertised and selected.

      Thanks
	Andrew
