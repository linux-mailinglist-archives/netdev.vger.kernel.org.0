Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A384FFB78
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 20:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfKQTZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 14:25:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43890 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbfKQTZi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Nov 2019 14:25:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sWt1tNvr1hHhW++q0izT/c2B1CSr+bShfknH/cf5nAo=; b=jiX8arR42cBisSsv8P+O1hjee8
        GFUko/fLReBeCRSseA4PuuTQZrkdKOpT65K6EJ4gt36dvM+lu7wV/xwtO570jMn0AifbQPo1GwAMM
        novUFdAWfmUtZAPkS9NmsbEIpA0um/mlii8B1Ss6W5gDsB7v90QSVARiykr8PMWP9hzc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iWQAr-0001Qz-IG; Sun, 17 Nov 2019 20:25:29 +0100
Date:   Sun, 17 Nov 2019 20:25:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/3] net: phy: marvell10g: add SFP+ support
Message-ID: <20191117192529.GB4084@lunn.ch>
References: <20191115195339.GR25745@shell.armlinux.org.uk>
 <E1iVhiC-0007bG-Cm@rmk-PC.armlinux.org.uk>
 <20191116160635.GB5653@lunn.ch>
 <20191116214042.GU25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116214042.GU25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The answer is... it depends.

Hi Russell

One issue we have had with phylink is people using the interfaces
wrongly. When asking this question, i was thinking about
documentation. Your answer suggests this method is not simply about
the validation you are doing here, it could also be about
configuration of the PHY to fit the module.

Maybe it would be good to add documentation somewhere about the range
of things this call can do?

> So, this patch reflects what can be done with the SFP+ slots on
> Macchiatobin boards today.

This all sounds very hardware dependent. So we are going to need some
more DT properties i guess. Have you thought about this?

Maybe we need to add compatibles sff,sfp+ and sff,sff+ ? Indicate the
board is capable of the higher speeds? And when sfp+/sff+ is used,
maybe a boolean to indicate it is also sff/sfp compatible?
sfp_select_interface() can then look at these properties and return
PHY_INTERFACE_MODE_NA if the board is not capable of supporting the
module?

Would it even make sense to make the PHY interface more like the MAC
interface? A validate function to indicate what it is capable of? A
configure function to configure its mode towards the SFP?

	  Andrew
