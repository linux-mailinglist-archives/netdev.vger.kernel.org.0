Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4C445C8B0
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 16:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236235AbhKXPeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 10:34:09 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50268 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239549AbhKXPeI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 10:34:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=46XcPyl8eEIwgeYx8zSSRcjpNg6bob7jlv3ETrKnMGE=; b=zrjzW4IsK9pm3+XRws2dySv9IL
        1Rf0v6glLm7vYY8GdX+3uNKb8oPNONF2n1usY2lyNoIWsEk4bRXnef+wRd8qnlDGjfzsYmwxzPg/v
        IhVlR99K4IHtkeS1TdH0B4g3reCmG33rlWATu0x/dVyqr7gHy+Nzz8tu197jhvtYab8U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mpuEX-00EWEy-GS; Wed, 24 Nov 2021 16:30:53 +0100
Date:   Wed, 24 Nov 2021 16:30:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alessandro B Maurici <abmaurici@gmail.com>
Subject: Re: [PATCH net] lan743x: fix deadlock in
 lan743x_phy_link_status_change()
Message-ID: <YZ5ara1hQZhjICCy@lunn.ch>
References: <40e27f76-0ba3-dcef-ee32-a78b9df38b0f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40e27f76-0ba3-dcef-ee32-a78b9df38b0f@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 08:16:25AM +0100, Heiner Kallweit wrote:
> Usage of phy_ethtool_get_link_ksettings() in the link status change
> handler isn't needed, and in combination with the referenced change
> it results in a deadlock. Simply remove the call and replace it with
> direct access to phydev->speed. The duplex argument of 
> lan743x_phy_update_flowcontrol() isn't used and can be removed.
> 
> Fixes: c10a485c3de5 ("phy: phy_ethtool_ksettings_get: Lock the phy for consistency")
> Reported-by: Alessandro B Maurici <abmaurici@gmail.com>
> Tested-by: Alessandro B Maurici <abmaurici@gmail.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Thanks Heiner

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
