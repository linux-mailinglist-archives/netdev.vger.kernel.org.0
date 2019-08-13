Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFAB78BD54
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 17:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbfHMPi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 11:38:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57238 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728535AbfHMPi1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 11:38:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BJYOCOgG3vSFD6B2/NaAeHaq/xMvIZnICqXhFcn1r2g=; b=SrBu8AYaayxZtoAvX73LOWV53W
        T30rx8Yp718aJXL83KUA1lrCEW1ZrAbyOCuuhybNrVEaIkILwcAOzqx69S859eUT3ouinPFsNGR77
        A7UlK8svth/iQczY5jhEFoTPqXqCITyi7pPix70VltvRCfq9gnp4Iq7SS8pNZMUXIovY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxYsO-0002VJ-T4; Tue, 13 Aug 2019 17:38:20 +0200
Date:   Tue, 13 Aug 2019 17:38:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Harini Katakam <harinik@xilinx.com>
Cc:     Harini Katakam <harini.katakam@xilinx.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        radhey.shyam.pandey@xilinx.com
Subject: Re: [PATCH 2/2] net: gmii2rgmii: Switch priv field in mdio device
 structure
Message-ID: <20190813153820.GY14290@lunn.ch>
References: <1564565779-29537-1-git-send-email-harini.katakam@xilinx.com>
 <1564565779-29537-3-git-send-email-harini.katakam@xilinx.com>
 <20190801040648.GJ2713@lunn.ch>
 <CAFcVEC+DyVhLzbMdSDsadivbnZJxSEg-0kUF5_Q+mtSbBnmhSA@mail.gmail.com>
 <20190813132321.GF15047@lunn.ch>
 <CAFcVECKipjD9atgEJSf8j78q_1aOAX77nD6vVeytZ-M00qBt6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFcVECKipjD9atgEJSf8j78q_1aOAX77nD6vVeytZ-M00qBt6A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The kernel does have a few helper, spi_get_drvdata, pci_get_drvdata,
> > hci_get_drvdata. So maybe had add phydev_get_drvdata(struct phy_device
> > *phydev)?
> 
> Maybe phydev_mdio_get_drvdata? Because the driver data member available is
> phydev->mdio.dev.driver_data.

I still prefer phydev_get_drvdata(). It fits with the X_get_drvdata()
pattern, where X is the type of parameter passed to the call, spi,
pci, hci.

We can also add mdiodev_get_drvdata(mdiodev). A few DSA drivers could
use that.

   Andrew
