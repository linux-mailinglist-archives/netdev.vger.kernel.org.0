Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE09480ADC
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 16:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbhL1Pe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 10:34:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43512 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232237AbhL1Pe1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 10:34:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=peJ8ThJwAnCjEpl/WdWsbtE6zOJhQZGwgZ32zqc1md8=; b=En
        6DeGR4MhDcRjOkzTxvfGjeVs6LGZpdiq6n2Hoq97XIydxxLZdESnW+j8pLoCFbPhl/5fhUCjLMqCk
        UXZRRdaMsam/7orpMeBayUnQzQ96KXFljgW9JqxdfAV8wPMx87QOYbM66zjB9S0Mq1Ls0QoyzlPDR
        uvndUEOOdhU3H5g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n2EUS-0002mX-7h; Tue, 28 Dec 2021 16:34:16 +0100
Date:   Tue, 28 Dec 2021 16:34:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Joseph CHAMG <josright123@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "joseph_chang@davicom.com.tw" <joseph_chang@davicom.com.tw>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v9, 2/2] net: Add dm9051 driver
Message-ID: <YcsueIU3ynUJrMVt@lunn.ch>
References: <20211227100233.8037-1-josright123@gmail.com>
 <20211227100233.8037-3-josright123@gmail.com>
 <CAHp75Vfgd=O_SukOrD4Adw4v7JdPBWsVsjwkj2-TiRy=Vk1mPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHp75Vfgd=O_SukOrD4Adw4v7JdPBWsVsjwkj2-TiRy=Vk1mPA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>     +static int dm9051_mdio_read(struct mii_bus *mdiobus, int phy_id, int reg)
>     +{
>     +       struct board_info *db = mdiobus->priv;
>     +       int val, ret;
>     +
>     +       if (phy_id == DM9051_PHY_ID) {
>     +               mutex_lock(&db->addr_lock);
>     +               ret = dm9051_phy_read(db, reg, &val);
>     +               mutex_unlock(&db->addr_lock);
>     +               if (ret)
>     +                       return ret;
>     +               return val;
>     +       }
>     +
>     +       return 0xffff;
> 
> 
> 
> Hmm.. can we rather use regmap APIs for SPI and MDIO?

Hi Andy

regmap via MDIO is very new, but yes it exists. This driver just needs
SPI which has had regmap support for a long time.

However, i suspect the submitter is trying hard to keep the driver in
a shape they can reuse the core with other OSes. At least that is my
feeling give the way requests for changes are handled. Maybe forcing
the use of regmap is actually a good idea, to break them away from
that bad idea.

     Andrew
