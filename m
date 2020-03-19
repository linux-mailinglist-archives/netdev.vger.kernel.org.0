Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA90418AEEA
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 10:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgCSJKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 05:10:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44660 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgCSJKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 05:10:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CI8Mkqpqhq5Ol9RWGo3fT4TAxUbv+rmtv4SbFWmBGu0=; b=oYSy/JWqMNhjXpHMIDrpJJV04Q
        xDJaemLJmvLyEaKcaF4I1X1Niyr7VFOiDEsK/wFpEYyIZhXpTwZTiILMncblfM3h7p+4HbishgY2X
        RYsV9zDpsveTNr4/Vi284YTQRs/F11E6yK2Iq3hQ2IBifuwyHEtUrZqs1dBAcPGjm9jY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jErCP-0005Th-Nu; Thu, 19 Mar 2020 10:10:45 +0100
Date:   Thu, 19 Mar 2020 10:10:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] net: phy: add and use phy_check_downshift
Message-ID: <20200319091045.GC20761@lunn.ch>
References: <6e4ea372-3d05-3446-2928-2c1e76a66faf@gmail.com>
 <d2822357-4c1e-a072-632e-a902b04eba7c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2822357-4c1e-a072-632e-a902b04eba7c@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 10:29:01PM +0100, Heiner Kallweit wrote:
> So far PHY drivers have to check whether a downshift occurred to be
> able to notify the user. To make life of drivers authors a little bit
> easier move the downshift notification to phylib. phy_check_downshift()
> compares the highest mutually advertised speed with the actual value
> of phydev->speed (typically read by the PHY driver from a
> vendor-specific register) to detect a downshift.
>  
> +/**
> + * phy_check_downshift - check whether downshift occurred
> + * @phydev: The phy_device struct
> + *
> + * Check whether a downshift to a lower speed occurred. If this should be the
> + * case warn the user.
> + */

Hi Heiner

Might be worth documenting here that phydev->speed needs to contain
the real speed, which typically requires a vendor-specific register.

    Andrew
