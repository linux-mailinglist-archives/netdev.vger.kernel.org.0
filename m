Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749114A6657
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240341AbiBAUtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:49:41 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38076 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231629AbiBAUtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 15:49:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GfcG5XCj3A/ORARzsiKJEsAfW7hdPTM5S0U/fpp6p/g=; b=nAKXo/zlrHykd0L+mHF0gdkZwg
        g1xKj0DrxxcJwhHCZ+RUcTB8p8rce1ujKp36K39mGRvpJX39io8eb3994qjoaSJ4jvC/bIvJGTZBi
        JVD+dNMGSoNTAnGM6/lNmH3KMXKXPbQdEG7V9LO5O44AkAhsVj1naCybvwwIcnyqkQ4Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nF05b-003rcB-M6; Tue, 01 Feb 2022 21:49:23 +0100
Date:   Tue, 1 Feb 2022 21:49:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Martin Schiller <ms@dev.tdt.de>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>, hkallweit1@gmail.com,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: Re: [PATCH net-next v6] net: phy: intel-xway: Add RGMII internal
 delay configuration
Message-ID: <Yfmc02MKT7swgFfZ@lunn.ch>
References: <20210719082756.15733-1-ms@dev.tdt.de>
 <CAJ+vNU3_8Gk8Mj_uCudMz0=MdN3B9T9pUOvYtP7H_B0fnTfZmg@mail.gmail.com>
 <94120968908a8ab073fa2fc0dd56b17d@dev.tdt.de>
 <CAJ+vNU2Bn_eks03g191KKLx5uuuekdqovx000aqcT5=f_6Zq=w@mail.gmail.com>
 <Yd7bsbvLyIquY5jn@shell.armlinux.org.uk>
 <CAJ+vNU1R8fGssHjfoz-jN1zjBLPz4Kg8XEUsy4z4bByKS1PqQA@mail.gmail.com>
 <81cce37d4222bbbd941fcc78ff9cacca@dev.tdt.de>
 <CAJ+vNU3NXAgfJ4t3c8RBsZVLLY_OXkZLFDhro8X84x0DAuNEdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ+vNU3NXAgfJ4t3c8RBsZVLLY_OXkZLFDhro8X84x0DAuNEdw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> However, I don't at all like the fact that this
> particular patch defaults the delays to 2ns if 'rx-internal-delay-ps'
> and 'tx-internal-delay-ps' is missing from the dt.

How does this work in combination with phy-mode 'rgmii', 'rgmii-id'
etc? Using 2ns as a default for rgmii-id is sensible, however i would
say it is wrong for rgmii.

> The issue I have here is that if dt's have not been updated to add the
> common delay properties this code will override what the boot firmware
> may have configured them to. I feel that if these common delay
> properties are not found in the device tree, then no changes to the
> delays should be made at all.

If you don't want the PHY driver to touch the delays at all because
you know something else has set it up, you can use phy-mode="", which
should be interpreted as PHY_INTERFACE_MODE_NA.

       Andrew
