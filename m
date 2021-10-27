Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AFA43CCA7
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238956AbhJ0OtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:49:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33710 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhJ0OtA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 10:49:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0NawOESsVNIJIdAki4IPwOT9LJl5489VErazyHx/ilE=; b=mU5q8gepWoSvAJdVa9qkt+rQCr
        qY8A2OX45ebvJoB2jW/f1CP2Wmgu4hwyOls2nGPC1EeSQKE1Vj3tD8i6tL0XhWVuLESoStTuJwouo
        tB5T0pq1rzli6pCi1C69sYg39cK2jNlcv29zPbuS110uJB+BBP6sgK589KwJ8ZRV7UG0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mfkCG-00BuDo-Or; Wed, 27 Oct 2021 16:46:32 +0200
Date:   Wed, 27 Oct 2021 16:46:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yuiko.Oshino@microchip.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Nisar.Sayed@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next] net: phy: microchip_t1: add cable test support
 for lan87xx phy
Message-ID: <YXlmSByDhPo0ZwWb@lunn.ch>
References: <20211022183632.8415-1-yuiko.oshino@microchip.com>
 <YXMXeuMUVvmR5Zrc@lunn.ch>
 <CH0PR11MB55619DF408C4EC0D729BC87F8E859@CH0PR11MB5561.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH0PR11MB55619DF408C4EC0D729BC87F8E859@CH0PR11MB5561.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> +     /* start cable diag */
> >> +     /* check if part is alive - if not, return diagnostic error */
> >> +     rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
> >PHYACC_ATTR_BANK_SMI,
> >> +                      0x00, 0);
> >> +     if (rc < 0)
> >> +             return rc;
> >> +
> >> +     if (rc != 0x2100)
> >> +             return -ENODEV;
> >
> >What does this actually mean? Would -EOPNOTSUPP be better?
> 
> This register should return the value of 0x2100. So if the return value is different, then I assume there is no device.

If the device does not exist, can we have go this far? Would probe of
the PHY failed? Or are you talking about a device within a device? Is
cable test implemented using an optional component?

      Andrew
